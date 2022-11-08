USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreatePadron]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreatePadron] 
END 
GO
CREATE PROC [dbo].[CreatePadron] 
	@Cedula NVARCHAR(16),
	@Periodo INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE @Asambleista INT
		SELECT @Asambleista = A.Id
		FROM dbo.Asambleista A
		WHERE A.Cedula = @Cedula
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevoPadron
			IF NOT EXISTS (SELECT Id FROM dbo.Padron WHERE AsambleistaId = @Asambleista AND PeriodoId = @Periodo)
				BEGIN
					INSERT INTO dbo.Padron(AsambleistaId,
											PeriodoId,
											Validacion)
					SELECT @Asambleista,
							@Periodo,
							1;
					
					SELECT @@Identity Id;
				END
			ELSE
				BEGIN
					UPDATE dbo.Padron
					SET Validacion = 1
					WHERE AsambleistaId = @Asambleista AND PeriodoId = @Periodo
				END
		COMMIT TRANSACTION nuevoPadron;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevoPadron;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadPadron]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadPadron] 
END 
GO
CREATE PROC [dbo].[ReadPadron] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Pa.Id,A.Nombre, A.Cedula, D.Nombre AS Departamento, S.Nombre AS Sector, Se.Nombre AS Sede, Pa.Validacion
		FROM dbo.Padron Pa
		INNER JOIN dbo.Asambleista A ON A.Id = Pa.AsambleistaId
		INNER JOIN dbo.Departamento D ON D.Id = A.DepartamentoId
		INNER JOIN dbo.Sector S ON S.Id = A.SectorId
		INNER JOIN dbo.Sede Se ON Se.Id = A.SedeId
		WHERE Pa.[Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdatePadron]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdatePadron] 
END 
GO
CREATE PROC [dbo].[UpdatePadron]
	@Cedula NVARCHAR(16),
	@Periodo INT,
	@Validacion BIT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarPadron
			DECLARE @AsambleistaId INT
			SELECT @AsambleistaId = Id
			FROM dbo.Asambleista
			WHERE Cedula = @Cedula
			UPDATE dbo.Padron
			SET Validacion = @Validacion
			WHERE AsambleistaId = @AsambleistaId AND PeriodoId = @Periodo
		COMMIT TRANSACTION modificarPadron;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarPadron;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[InsertarPadron]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[InsertarPadron] 
END 
GO
CREATE PROC [dbo].[InsertarPadron]
	@PeriodoId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarPadron
			UPDATE dbo.Padron
			SET Validacion = 0
			WHERE PeriodoId = @PeriodoId
		COMMIT TRANSACTION modificarPadron;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarPadron;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[GetPadron]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetPadron] 
END 
GO
CREATE PROC [dbo].[GetPadron] 
    @PeriodoId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Pa.Id,A.Nombre AS Asambleista, A.Cedula, D.Nombre AS Departamento, S.Nombre AS Sector, Se.Nombre AS Sede
		FROM dbo.Padron Pa
		INNER JOIN dbo.Asambleista A ON A.Id = Pa.AsambleistaId
		INNER JOIN dbo.Departamento D ON D.Id = A.DepartamentoId
		INNER JOIN dbo.Sector S ON S.Id = A.SectorId
		INNER JOIN dbo.Sede Se ON Se.Id = A.SedeId
		WHERE Pa.[PeriodoId] = @PeriodoId AND Pa.Validacion = 1
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO


IF OBJECT_ID('[dbo].[NuevoPadronAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[NuevoPadronAIR] 
END 
GO
CREATE PROC [dbo].[NuevoPadronAIR]
	@PeriodoId INT,
	@Route NVARCHAR(200),
	@Sheet NVARCHAR(128)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE @TempTable TABLE(Sec INT IDENTITY(1,1),
									Departamento NVARCHAR(128),
									Sector NVARCHAR(32),
									Sede NVARCHAR(32),
									Nombre NVARCHAR(128),
									Cedula NVARCHAR(16))
		DECLARE @sql NVARCHAR(MAX),
				@cedula NVARCHAR(16),
				@inicio INT,
				@fin INT
		SET @sql = 'SELECT [DEPARTAMENTO / ESCUELA / GRUPO ADMINISTRATIVO],
							SECTOR,
							[CAMPUS O  CENTRO ACADÉMICO],
							NOMBRE + '' '' +[PRIMER APELLIDO] + '' '' + [SEGUNDO APELLIDO],
							CÉDULA
					FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'',
						''Excel 12.0; Database=' + @Route + ''',
						''select * from ['+@Sheet+'$]'')
					WHERE CÉDULA IS NOT NULL'
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION crearPadronAIR
			UPDATE dbo.Padron
			SET Validacion = 0
			WHERE PeriodoId = @PeriodoId
			
			INSERT INTO @TempTable(Departamento,Sector,Sede,Nombre,Cedula)
			EXEC (@sql)
			--SELECT * FROM @TempTable DEC
			
			INSERT INTO dbo.Departamento(Nombre)
			SELECT DISTINCT TT.Departamento
			FROM @TempTable TT
			WHERE TT.Departamento NOT IN (SELECT Nombre FROM dbo.Departamento)
			
			INSERT INTO dbo.Sector(Nombre)
			SELECT DISTINCT TT.Sector
			FROM @TempTable TT
			WHERE TT.Sector NOT IN (SELECT Nombre FROM dbo.Sector)
			
			INSERT INTO dbo.Sede(Nombre)
			SELECT DISTINCT TT.Sede
			FROM @TempTable TT
			WHERE TT.Sede NOT IN (SELECT Nombre FROM dbo.Sede)
			
			UPDATE dbo.Asambleista
			SET DepartamentoId = D.Id,
				SectorId = S.Id,
				SedeId = Sd.Id,
				Nombre = TT.Nombre
			FROM @TempTable AS TT
			INNER JOIN dbo.Departamento AS D ON TT.Departamento = D.Nombre
			INNER JOIN dbo.Sector AS S ON TT.Sector = S.Nombre
			INNER JOIN dbo.Sede AS Sd ON TT.Sede = Sd.Nombre
			WHERE dbo.Asambleista.Cedula = TT.Cedula
			
			INSERT INTO dbo.Asambleista(DepartamentoId,SectorId,SedeId,Nombre,Cedula)
			SELECT D.Id,S.Id,Sd.Id,TT.Nombre,TT.Cedula
			FROM @TempTable TT
			INNER JOIN dbo.Departamento AS D ON TT.Departamento = D.Nombre
			INNER JOIN dbo.Sector AS S ON TT.Sector = S.Nombre
			INNER JOIN dbo.Sede AS Sd ON TT.Sede = Sd.Nombre
			WHERE TT.Cedula NOT IN (SELECT Cedula FROM dbo.Asambleista)
			
			SELECT @inicio = MIN(Sec),
					@fin = MAX(Sec)
			FROM @TempTable
			
			WHILE @inicio <= @fin
				BEGIN
					SELECT @cedula = TT.Cedula
					FROM @TempTable TT
					WHERE TT.Sec = @inicio
					EXEC dbo.CreatePadron @cedula, @PeriodoId 
					SET @inicio = @inicio + 1
				END
			--SELECT * FROM dbo.RegistroAsistenciaAIR
		COMMIT TRANSACTION crearPadronAIR;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION crearPadronAIR;
		SELECT -1
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ActualizarPadronAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ActualizarPadronAIR] 
END 
GO
CREATE PROC [dbo].[ActualizarPadronAIR]
	@PeriodoId INT,
	@Route NVARCHAR(200),
	@Sheet NVARCHAR(128)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE @TempTable TABLE(Sec INT IDENTITY(1,1),
									Departamento NVARCHAR(64),
									Sector NVARCHAR(32),
									Sede NVARCHAR(32),
									Nombre NVARCHAR(128),
									Cedula NVARCHAR(16))
		DECLARE @sql NVARCHAR(MAX),
				@cedula NVARCHAR(16),
				@inicio INT,
				@fin INT
		SET @sql = 'SELECT [DEPARTAMENTO / ESCUELA / GRUPO ADMINISTRATIVO],
							SECTOR,
							[CAMPUS O  CENTRO ACADÉMICO],
							NOMBRE + '' '' +[PRIMER APELLIDO] + '' '' + [SEGUNDO APELLIDO],
							CÉDULA
					FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'',
						''Excel 12.0; Database=' + @Route + ''',
						''select * from ['+@Sheet+'$]'')
					WHERE CÉDULA IS NOT NULL'
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarAsistenciaAIR
			UPDATE dbo.Padron
			SET Validacion = 0
			WHERE PeriodoId = @PeriodoId
			
			INSERT INTO @TempTable(Departamento,Sector,Sede,Nombre,Cedula)
			EXEC (@sql)
			
			INSERT INTO dbo.Departamento(Nombre)
			SELECT DISTINCT TT.Departamento
			FROM @TempTable TT
			WHERE TT.Departamento NOT IN (SELECT Nombre FROM dbo.Departamento)
			
			INSERT INTO dbo.Sector(Nombre)
			SELECT DISTINCT TT.Sector
			FROM @TempTable TT
			WHERE TT.Sector NOT IN (SELECT Nombre FROM dbo.Sector)
			
			INSERT INTO dbo.Sede(Nombre)
			SELECT DISTINCT TT.Sede
			FROM @TempTable TT
			WHERE TT.Sede NOT IN (SELECT Nombre FROM dbo.Sede)
			
			UPDATE dbo.Asambleista
			SET DepartamentoId = D.Id,
				SectorId = S.Id,
				SedeId = Sd.Id,
				Nombre = TT.Nombre
			FROM @TempTable AS TT
			INNER JOIN dbo.Departamento AS D ON TT.Departamento = D.Nombre
			INNER JOIN dbo.Sector AS S ON TT.Sector = S.Nombre
			INNER JOIN dbo.Sede AS Sd ON TT.Sede = Sd.Nombre
			WHERE dbo.Asambleista.Cedula = TT.Cedula
			
			SELECT @inicio = MIN(Sec),
					@fin = MAX(Sec)
			FROM @TempTable
			
			WHILE @inicio <= @fin
				BEGIN
					SELECT @cedula = TT.Cedula
					FROM @TempTable TT
					WHERE TT.Sec = @inicio
					EXEC dbo.CreatePadron @PeriodoId, @cedula
					SET @inicio = @inicio + 1
				END
			SELECT * FROM dbo.RegistroAsistenciaAIR
		COMMIT TRANSACTION modificarAsistenciaAIR;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarAsistenciaAIR;
		SELECT -1
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
SET NOCOUNT OFF
END
GO