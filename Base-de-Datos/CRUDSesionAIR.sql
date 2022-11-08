USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateSesionAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateSesionAIR] 
END 
GO
CREATE PROC [dbo].[CreateSesionAIR] 
	@Periodo INT,
	@Nombre NVARCHAR(64),
	@Fecha DATE,
	@Inicio TIME,
	@Fin TIME
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevaSesionAIR
			INSERT INTO dbo.SesionAIR(PeriodoId,
										Nombre,
										Fecha,
										HoraInicio,
										HoraFin,
										Valido)
			SELECT @Periodo,
					@Nombre,
					@Fecha,
					@Inicio,
					@Fin,
					1;
		COMMIT TRANSACTION nuevaSesionAIR;
		SELECT @@Identity Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaSesionAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadSesionAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadSesionAIR] 
END 
GO
CREATE PROC [dbo].[ReadSesionAIR] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,Nombre,Fecha,HoraInicio,HoraFin
		FROM dbo.SesionAIR
		WHERE [Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateSesionAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateSesionAIR] 
END 
GO
CREATE PROC [dbo].[UpdateSesionAIR]
	@Id INT,
	@Nombre NVARCHAR(64),
	@Fecha DATE,
	@Inicio TIME,
	@Fin TIME
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarSesionAIR
			UPDATE dbo.SesionAIR
			SET Nombre = @Nombre,
				Fecha = @Fecha,
				HoraInicio = @Inicio,
				HoraFin = @Fin
			WHERE Id = @Id
		COMMIT TRANSACTION modificarSesionAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarSesionAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeleteSesionAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeleteSesionAIR] 
END 
GO
CREATE PROC [dbo].[DeleteSesionAIR]
	@Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE @TempPropuestas TABLE ( Sec INT IDENTITY(1,1),
										PropuestaId INT)
		
		DECLARE @inicio INT,
				@fin INT,
				@tempId INT
		
		INSERT INTO @TempPropuestas(PropuestaId)
		SELECT P.Id
		FROM dbo.PropuestaAIR P
		WHERE P.SesionAIRId = @Id
		
		SELECT @inicio = MIN(Sec),
				@fin = MAX(Sec)
		FROM @TempPropuestas
		
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarSesionAIR
			WHILE @inicio <= @fin
				BEGIN
					SELECT @tempId = PropuestaId
					FROM @TempPropuestas
					WHERE Sec = @inicio
					EXEC DeletePropuestaAIR @tempId
					
					SET @inicio = @inicio + 1
				END
			
			UPDATE dbo.SesionAIR
			SET Valido = 0
			WHERE Id = @Id
		COMMIT TRANSACTION eliminarSesionAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION eliminarSesionAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO