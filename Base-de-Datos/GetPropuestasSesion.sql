USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[GetPropuestasAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetPropuestasAIR] 
END 
GO
CREATE PROC [dbo].[GetPropuestasAIR] 
    @SesionId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT P.Id,E.Nombre AS Etapa, P.Nombre, P.Link,P.Aprovado,P.NumeroDePropuesta,P.VotosAFavor,P.VotosEnContra,P.VotosEnBlanco 
		FROM dbo.PropuestaAIR P
		INNER JOIN dbo.Etapa E ON E.Id = P.EtapaId
		WHERE P.SesionAIRId = @SesionId AND P.Valido = 1
		ORDER BY P.NumeroDePropuesta ASC
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO


IF OBJECT_ID('[dbo].[GetPropuestasDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetPropuestasDAIR] 
END 
GO
CREATE PROC [dbo].[GetPropuestasDAIR] 
    @SesionId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,Nombre,Aprovado,Link
		FROM dbo.PropuestaDAIR P
		WHERE P.SesionDAIRId = @SesionId AND P.Valido = 1
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO