USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[GetNotificaciones]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetNotificaciones] 
END 
GO
CREATE PROC [dbo].[GetNotificaciones] 
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,Motivo, FechaNotificacion
		FROM dbo.Notificacion
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO