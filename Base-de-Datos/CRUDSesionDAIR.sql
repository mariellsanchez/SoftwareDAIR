USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateSesionDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateSesionDAIR] 
END 
GO
CREATE PROC [dbo].[CreateSesionDAIR] 
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
		BEGIN TRANSACTION nuevaSesionDAIR
			INSERT INTO dbo.SesionDAIR(PeriodoId,
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
		COMMIT TRANSACTION nuevaSesionDAIR;
		SELECT @@Identity Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaSesionDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadSesionDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadSesionDAIR] 
END 
GO
CREATE PROC [dbo].[ReadSesionDAIR] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,Nombre,Fecha,HoraInicio,HoraFin
		FROM dbo.SesionDAIR
		WHERE [Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateSesionDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateSesionDAIR] 
END 
GO
CREATE PROC [dbo].[UpdateSesionDAIR]
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
		BEGIN TRANSACTION modificarSesionDAIR
			UPDATE dbo.SesionDAIR
			SET Nombre = @Nombre,
				Fecha = @Fecha,
				HoraInicio = @Inicio,
				HoraFin = @Fin
			WHERE Id = @Id
		COMMIT TRANSACTION modificarSesionDAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarSesionDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeleteSesionDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeleteSesionDAIR] 
END 
GO
CREATE PROC [dbo].[DeleteSesionDAIR]
	@Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarSesionDAIR
			UPDATE dbo.PropuestaDAIR
			SET Valido = 0
			WHERE SesionDAIRId = @Id
			
			UPDATE dbo.SesionDAIR
			SET Valido = 0
			WHERE Id = @Id
		COMMIT TRANSACTION eliminarSesionDAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION eliminarSesionDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO