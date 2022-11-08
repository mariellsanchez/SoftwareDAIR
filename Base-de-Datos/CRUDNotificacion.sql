USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateNotificacion]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateNotificacion] 
END 
GO
CREATE PROC [dbo].[CreateNotificacion] 
	@Motivo NVARCHAR(252),
	@Fecha DATE
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevaNotificacion
			INSERT INTO dbo.Notificacion(Motivo,
										FechaNotificacion)
			SELECT @Motivo,
					@Fecha;
		COMMIT TRANSACTION nuevaNotificacion;
		SELECT @@Identity Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaNotificacion;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadNotificacion]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadNotificacion] 
END 
GO
CREATE PROC [dbo].[ReadNotificacion] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,Motivo,FechaNotificacion
		FROM dbo.Notificacion
		WHERE [Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateNotificacion]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateNotificacion] 
END 
GO
CREATE PROC [dbo].[UpdateNotificacion]
	@Id INT,
	@Motivo NVARCHAR(252),
	@Fecha DATE
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarNotificacion
			UPDATE dbo.Notificacion
			SET Motivo = @Motivo,
				FechaNotificacion = @Fecha
			WHERE Id = @Id
		COMMIT TRANSACTION modificarNotificacion;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarNotificacion;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeleteNotificacion]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeleteNotificacion] 
END 
GO
CREATE PROC [dbo].[DeleteNotificacion] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarNotificacion
			DELETE FROM dbo.Notificacion
			WHERE [Id] = @Id
		COMMIT TRANSACTION eliminarNotificacion;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarNotificacion;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO