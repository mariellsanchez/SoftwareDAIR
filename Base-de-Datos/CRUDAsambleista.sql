USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateAsambleista]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateAsambleista] 
END 
GO
CREATE PROC [dbo].[CreateAsambleista] 
    @Departamento NVARCHAR(128),
	@Sector NVARCHAR(32),
	@Sede NVARCHAR(32),
	@Nombre NVARCHAR(128),
	@Cedula NVARCHAR(16)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE @DepartamentoId INT,
				@SectorId INT,
				@SedeId INT
		SELECT @DepartamentoId = Id
		FROM dbo.Departamento
		WHERE Nombre = @Departamento
		
		SELECT @SectorId = Id
		FROM dbo.Sector
		WHERE Nombre = @Sector
		
		SELECT @SedeId = Id
		FROM dbo.Sede
		WHERE Nombre = @Sede
		
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevoAsambleista
			IF NOT EXISTS (SELECT Id FROM dbo.Asambleista WHERE Cedula = @Cedula)
				BEGIN
					INSERT INTO dbo.Asambleista(DepartamentoId,
											SectorId,
											SedeId,
											Nombre,
											Cedula)
					SELECT @DepartamentoId,
							@SectorId,
							@SedeId,
							@Nombre,
							@Cedula;
					SELECT @@Identity Id;
				END
			ELSE
				BEGIN
					UPDATE dbo.Asambleista
					SET DepartamentoId = @DepartamentoId,
						SectorId = @SectorId,
						SedeId = @SedeId,
						Nombre = @Nombre
					WHERE Cedula = @Cedula
					SELECT 0
				END
		COMMIT TRANSACTION nuevoAsambleista;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevoAsambleista;
		SELECT -1
		
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadAsambleista]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadAsambleista] 
END 
GO
CREATE PROC [dbo].[ReadAsambleista] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre, A.Cedula,D.Nombre AS Departamento, Sec.Nombre AS Sector, Se.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector Sec ON A.SectorId = Sec.Id
		INNER JOIN dbo.Sede Se ON A.SedeId = Se.Id
		WHERE A.[Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateAsambleista]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateAsambleista] 
END 
GO
CREATE PROC [dbo].[UpdateAsambleista]
	@Departamento NVARCHAR(32),
	@Sector NVARCHAR(32),
	@Sede NVARCHAR(32),
	@Nombre NVARCHAR(64),
	@Cedula NVARCHAR(16)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE @DepartamentoId INT,
				@SectorId INT,
				@SedeId INT
		SELECT @DepartamentoId = Id
		FROM dbo.Departamento
		WHERE Nombre = @Departamento
		
		SELECT @SectorId = Id
		FROM dbo.Sector
		WHERE Nombre = @Sector
		
		SELECT @SedeId = Id
		FROM dbo.Sede
		WHERE Nombre = @Sede
		
		
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarAsambleista
			UPDATE dbo.Asambleista
			SET DepartamentoId = @DepartamentoId,
				SectorId = @SectorId,
				SedeId = @SedeId,
				Nombre = @Nombre
			WHERE Cedula = @Cedula
			SELECT 1;
		COMMIT TRANSACTION modificarAsambleista;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarAsambleista;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO