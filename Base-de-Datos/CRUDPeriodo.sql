USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreatePeriodo]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreatePeriodo] 
END 
GO
CREATE PROC [dbo].[CreatePeriodo] 
	@Inicio INT,
	@Fin INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevoPeriodo
			INSERT INTO dbo.Periodo(AnioInicio,
									AnioFin)
			SELECT @Inicio,
					@Fin;
		COMMIT TRANSACTION nuevoPeriodo;
		SELECT @@Identity Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevoPeriodo;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadPeriodo]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadPeriodo] 
END 
GO
CREATE PROC [dbo].[ReadPeriodo] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,AnioInicio,AnioFin
		FROM dbo.Periodo
		WHERE [Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdatePeriodo]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdatePeriodo] 
END 
GO
CREATE PROC [dbo].[UpdatePeriodo]
	@Id INT,
	@Inicio INT,
	@Fin INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarPeriodo
			UPDATE dbo.Periodo
			SET AnioInicio = @Inicio,
				AnioFin = @Fin
			WHERE Id = @Id
		COMMIT TRANSACTION modificarPeriodo;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarPeriodo;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[GetPeriodo]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetPeriodo] 
END 
GO
CREATE PROC [dbo].[GetPeriodo]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT Id,AnioInicio,AnioFin
		FROM dbo.Periodo
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO