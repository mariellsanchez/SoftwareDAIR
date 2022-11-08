USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[IniciarSesion]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[IniciarSesion] 
END 
GO
CREATE PROC [dbo].[IniciarSesion]  
    @usuario NVARCHAR(64),
    @Contrasenia NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		IF EXISTS (
		SELECT *
		FROM dbo.Usuario
		WHERE Nombre = @usuario AND Contrasenia = @Contrasenia)
			BEGIN
				SELECT 1
			END
		ELSE
			BEGIN
				SELECT 0
			END
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO


IF OBJECT_ID('[dbo].[CambiarContrasennia]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CambiarContrasennia] 
END 
GO
CREATE PROC [dbo].[CambiarContrasennia]   
    @usuario NVARCHAR(64),
    @Contrasenia NVARCHAR(32),
    @NuevaContrasenia NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION cambiar
			IF EXISTS (
			SELECT *
			FROM dbo.Usuario
			WHERE Nombre = @usuario AND Contrasenia = @Contrasenia)
				BEGIN
					UPDATE dbo.Usuario
					SET Contrasenia = @NuevaContrasenia
					WHERE Contrasenia = @Contrasenia AND Nombre = @usuario
					SELECT 1;
				END
			ELSE
				BEGIN
					SELECT 0
				END
		COMMIT TRANSACTION cambiar;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION cambiar;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO