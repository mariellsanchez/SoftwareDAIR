USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreatePropuestaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreatePropuestaAIR] 
END 
GO
CREATE PROC [dbo].[CreatePropuestaAIR] 
	@SesionAIR INT,
	@Etapa INT,
	@Aprovado BIT,
	@Nombre NVARCHAR(64),
	@Link NVARCHAR(256),
	@NumeroPropuesta INT,
	@AFavor INT,
	@EnContra INT,
	@EnBlanco INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevaPropuestaAIR
			INSERT INTO dbo.PropuestaAIR(SesionAIRId,
										EtapaId,
										Aprovado,
										Nombre,
										Link,
										NumeroDePropuesta,
										VotosAFavor,
										VotosEnContra,
										VotosEnBlanco,
										Valido)
			SELECT @SesionAIR,
					@Etapa,
					@Aprovado,
					@Nombre,
					@Link,
					@NumeroPropuesta,
					@AFavor,
					@EnContra,
					@EnBlanco,
					1;
		COMMIT TRANSACTION nuevaPropuestaAIR;
		SELECT @@Identity Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaPropuestaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadPropuestaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadPropuestaAIR] 
END 
GO
CREATE PROC [dbo].[ReadPropuestaAIR] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT P.Id,E.Nombre,P.Nombre,P.Aprovado,P.Link,P.NumeroDePropuesta,P.VotosAFavor,P.VotosEnContra,P.VotosEnBlanco
		FROM dbo.PropuestaAIR P
		INNER JOIN dbo.Etapa E ON P.EtapaId = E.Id
		WHERE P.[Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdatePropuestaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdatePropuestaAIR] 
END 
GO
CREATE PROC [dbo].[UpdatePropuestaAIR]
	@Id INT,
	@Etapa INT,
	@Aprovado BIT,
	@Nombre NVARCHAR(64),
	@Link NVARCHAR(256),
	@NumeroDePropuesta INT,
	@VotosAFavor INT,
	@VotosEnContra INT,
	@VotosEnBlanco INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarPropuestaAIR
			UPDATE dbo.PropuestaAIR
			SET Nombre = @Nombre,
				Aprovado = @Aprovado,
				Link = @Link,
				NumeroDePropuesta = @NumeroDePropuesta,
				VotosAFavor = @VotosAFavor,
				VotosEnContra = @VotosEnContra,
				VotosEnBlanco = @VotosEnBlanco
			WHERE Id = @Id
		COMMIT TRANSACTION modificarPropuestaAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarPropuestaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeletePropuestaAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeletePropuestaAIR] 
END 
GO
CREATE PROC [dbo].[DeletePropuestaAIR]
	@Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarPropuestaAIR
			UPDATE dbo.PropuestaAIRxAsambleista
			SET Validaion = 0
			WHERE PropuestaAIRId = @Id
			
			UPDATE dbo.PropuestaAIR
			SET Valido = 0
			WHERE Id = @Id
		COMMIT TRANSACTION eliminarPropuestaAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION eliminarPropuestaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO