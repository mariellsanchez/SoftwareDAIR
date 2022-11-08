USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[GetAsistenciaAsambleista]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetAsistenciaAsambleista] 
END 
GO
CREATE PROC [dbo].[GetAsistenciaAsambleista]
	@Cedula NVARCHAR(16)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT S.Nombre,S.Fecha,S.PeriodoId,RA.Asistio
		FROM dbo.RegistroAsistenciaAIR RA
		INNER JOIN dbo.Asambleista A ON A.Cedula = @Cedula
		INNER JOIN dbo.SesionAIR S ON S.Id = RA.SesionAIRId
		WHERE RA.Validacion = 1 AND S.Valido = 1 AND A.Id = RA.AsambleistaId
		ORDER BY S.Fecha DESC;
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO