USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[GetAsistenciaSesionAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetAsistenciaSesionAIR] 
END 
GO
CREATE PROC [dbo].[GetAsistenciaSesionAIR] 
    @SesionId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT R.Id,A.Nombre AS Asambleista, a.Cedula AS Cedula, S.Nombre AS Sesion,R.Asistio AS Asistencia
		FROM dbo.RegistroAsistenciaAIR R
		INNER JOIN dbo.Asambleista A ON R.AsambleistaId = A.Id
		INNER JOIN dbo.SesionAIR S ON R.SesionAIRId = S.Id
		WHERE R.SesionAIRId = @SesionId AND R.Validacion = 1
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[GetAsistenciaSesionDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetAsistenciaSesionDAIR] 
END 
GO
CREATE PROC [dbo].[GetAsistenciaSesionDAIR] 
    @SesionId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT R.Id,A.Nombre AS Asambleista,S.Nombre AS Sesion,R.Asistio AS Asistencia
		FROM dbo.RegistroAsistenciaDAIR R
		INNER JOIN dbo.Asambleista A ON R.AsambleistaId = A.Id
		INNER JOIN dbo.SesionAIR S ON R.SesionDAIRId = S.Id
		WHERE R.SesionDAIRId = @SesionId AND R.Validacion = 1
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO