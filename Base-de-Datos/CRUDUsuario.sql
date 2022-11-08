USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateUsuario]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateUsuario] 
END 
GO
CREATE PROC [dbo].[CreateUsuario] 
	@Nombre NVARCHAR(64),
	@Contrasenia NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevoUsuario
			IF NOT EXISTS (SELECT Id FROM dbo.Usuario WHERE Nombre = @Nombre)
				BEGIN
					INSERT INTO dbo.Usuario(Nombre,
											Contrasenia)
					SELECT @Nombre,
							@Contrasenia;
					
					SELECT @@Identity Id;
				END
			ELSE
				BEGIN
					SELECT 0
				END
		COMMIT TRANSACTION nuevoUsuario;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevoUsuario;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadUsuario]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadUsuario] 
END 
GO
CREATE PROC [dbo].[ReadUsuario] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id, Nombre, Contrasenia
		FROM dbo.Usuario
		WHERE [Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateUsuario]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateUsuario] 
END 
GO
CREATE PROC [dbo].[UpdateUsuario]
	@Id INT,
	@Nombre NVARCHAR(64),
	@Contrasenia NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarUsuario
			UPDATE dbo.Usuario
			SET Nombre = @Nombre,
				Contrasenia = @Contrasenia
			WHERE Id = @Id
		COMMIT TRANSACTION modificarUsuario;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarUsuario;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO