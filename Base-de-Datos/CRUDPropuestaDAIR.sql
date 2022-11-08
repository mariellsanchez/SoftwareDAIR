USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreatePropuestaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreatePropuestaDAIR] 
END 
GO
CREATE PROC [dbo].[CreatePropuestaDAIR] 
	@SesionDAIR INT,
	@Nombre NVARCHAR(64),
	@Aprovado BIT,
	@Link NVARCHAR(256)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevaPropuestaDAIR
			INSERT INTO dbo.PropuestaDAIR(SesionDAIRId,
										Nombre,
										Aprovado,
										Link,
										Valido)
			SELECT @SesionDAIR,
					@Nombre,
					@Aprovado,
					@Link,
					1;
		COMMIT TRANSACTION nuevaPropuestaDAIR;
		SELECT @@Identity Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaPropuestaDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadPropuestaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadPropuestaDAIR] 
END 
GO
CREATE PROC [dbo].[ReadPropuestaDAIR] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,Nombre,Aprovado,Link
		FROM dbo.PropuestaDAIR
		WHERE [Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdatePropuestaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdatePropuestaDAIR] 
END 
GO
CREATE PROC [dbo].[UpdatePropuestaDAIR]
	@Id INT,
	@Nombre NVARCHAR(64),
	@Aprovado BIT,
	@Link NVARCHAR(256)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarPropuestaDAIR
			UPDATE dbo.PropuestaDAIR
			SET Nombre = @Nombre,
				Aprovado = @Aprovado,
				Link = @Link
			WHERE Id = @Id
		COMMIT TRANSACTION modificarPropuestaDAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarPropuestaDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeletePropuestaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeletePropuestaDAIR] 
END 
GO
CREATE PROC [dbo].[DeletePropuestaDAIR]
	@Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarPropuestaDAIR
			UPDATE dbo.PropuestaDAIR
			SET Valido = 0
			WHERE Id = @Id
		COMMIT TRANSACTION eliminarPropuestaDAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION eliminarPropuestaDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO