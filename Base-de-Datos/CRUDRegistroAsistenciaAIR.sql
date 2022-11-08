USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateAsistenciaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateAsistenciaAIR] 
END 
GO
CREATE PROC [dbo].[CreateAsistenciaAIR] 
	@SesionAIRId INT,
	@Cedula NVARCHAR(16),
	@Asistio BIT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevaAsistenciaAIR
			DECLARE @AsambleistaId INT
			SELECT @AsambleistaId = A.Id
			FROM dbo.Asambleista A
			WHERE A.Cedula = @Cedula
			IF NOT EXISTS (SELECT Id FROM dbo.RegistroAsistenciaAIR WHERE AsambleistaId = @AsambleistaId AND SesionAIRId = @SesionAIRId)
				BEGIN
					INSERT INTO dbo.RegistroAsistenciaAIR(SesionAIRId,
												AsambleistaId,
												Asistio,
												Validacion)
					SELECT @SesionAIRId,
							@AsambleistaId,
							@Asistio,
							1;
					SELECT @@Identity Id;
				END
			ELSE
				BEGIN
					UPDATE dbo.RegistroAsistenciaAIR
					SET Asistio = @Asistio,
						Validacion = 1
					WHERE SesionAIRId = @SesionAIRId AND AsambleistaId = @AsambleistaId
					SELECT 0
				END
		COMMIT TRANSACTION nuevaAsistenciaAIR;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaAsistenciaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadAsistenciaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadAsistenciaAIR] 
END 
GO
CREATE PROC [dbo].[ReadAsistenciaAIR] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT R.Id,A.Nombre,A.Cedula,R.Asistio
		FROM dbo.RegistroAsistenciaAIR R
		INNER JOIN dbo.Asambleista A ON R.AsambleistaId = A.Id
		WHERE R.[Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateAsistenciaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateAsistenciaAIR] 
END 
GO
CREATE PROC [dbo].[UpdateAsistenciaAIR]
	@SesionAIRId INT,
	@Cedula NVARCHAR(16),
	@Asistio BIT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarAsistenciaAIR
			DECLARE @AsambleistaId INT
			SELECT @AsambleistaId = A.Id
			FROM dbo.Asambleista A
			WHERE A.Cedula = @Cedula
			
			UPDATE dbo.RegistroAsistenciaAIR
			SET Asistio = @Asistio
			WHERE AsambleistaId = @AsambleistaId AND SesionAIRId = @SesionAIRId
		COMMIT TRANSACTION modificarAsistenciaAIR;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarAsistenciaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeleteAsistenciaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeleteAsistenciaAIR] 
END 
GO
CREATE PROC [dbo].[DeleteAsistenciaAIR]
	@Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarAsistenciaAIR
			UPDATE dbo.RegistroAsistenciaAIR
			SET Asistio = 0
			WHERE Id = @Id
		COMMIT TRANSACTION eliminarAsistenciaAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION eliminarAsistenciaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[NuevoRegistroAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[NuevoRegistroAIR] 
END 
GO
CREATE PROC [dbo].[NuevoRegistroAIR]
	@SesionId INT,
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
		BEGIN TRANSACTION modificarAsistenciaAIR
			UPDATE dbo.RegistroAsistenciaAIR
			SET Validacion = 0
			WHERE SesionAIRId = @SesionId
			
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
					EXEC dbo.CreateAsistenciaAIR @SesionId, @cedula,0 
					SET @inicio = @inicio + 1
				END
			--SELECT * FROM dbo.RegistroAsistenciaAIR
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

IF OBJECT_ID('[dbo].[ActualizarRegistroAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ActualizarRegistroAIR] 
END 
GO
CREATE PROC [dbo].[ActualizarRegistroAIR]
	@SesionId INT,
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
		SET @sql = 'SELECT DEPARTAMENTO,
							SECTOR,
							[CAMPUS O  CENTRO ACADÉMICO],
							NOMBRE + '' '' +[PRIMER APELLIDO] + '' '' + [SEGUNDO APELLIDO],
							CEDULA
					FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'',
						''Excel 12.0; Database=' + @Route + ''',
						''select * from ['+@Sheet+'$]'')
					WHERE CEDULA IS NOT NULL'
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarAsistenciaAIR
			UPDATE dbo.RegistroAsistenciaAIR
			SET Asistio = 0
			WHERE SesionAIRId = @SesionId
			
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
					EXEC dbo.UpdateAsistenciaAIR @SesionId, @cedula, 1
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