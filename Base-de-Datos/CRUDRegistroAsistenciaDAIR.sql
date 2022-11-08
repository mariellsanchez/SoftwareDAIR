USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[CreateAsistenciaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[CreateAsistenciaDAIR] 
END 
GO
CREATE PROC [dbo].[CreateAsistenciaDAIR] 
	@SesionDAIRId INT,
	@Cedula NVARCHAR(16),
	@Asistio BIT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION nuevaAsistenciaDAIR
			DECLARE @AsambleistaId INT
			SELECT @AsambleistaId = A.Id
			FROM dbo.Asambleista A
			WHERE A.Cedula = @Cedula
			IF NOT EXISTS (SELECT Id FROM dbo.RegistroAsistenciaDAIR WHERE AsambleistaId = @AsambleistaId AND SesionDAIRId = @SesionDAIRId)
				BEGIN
					INSERT INTO dbo.RegistroAsistenciaDAIR(SesionDAIRId,
												AsambleistaId,
												Asistio,
												Validacion)
					SELECT @SesionDAIRId,
							@AsambleistaId,
							@Asistio,
							1;
					SELECT @@Identity Id;
				END
			ELSE
				BEGIN
					UPDATE dbo.RegistroAsistenciaDAIR
					SET Asistio = @Asistio,
						Validacion = 1
					WHERE SesionDAIRId = @SesionDAIRId
					SELECT 0
				END
		COMMIT TRANSACTION nuevaAsistenciaDAIR;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION nuevaAsistenciaDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[ReadAsistenciaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[ReadAsistenciaDAIR] 
END 
GO
CREATE PROC [dbo].[ReadAsistenciaDAIR] 
    @Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT R.Id,A.Nombre,A.Cedula,R.Asistio
		FROM dbo.RegistroAsistenciaDAIR R
		INNER JOIN dbo.Asambleista A ON R.AsambleistaId = A.Id
		WHERE R.[Id] = @Id
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[UpdateAsistenciaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[UpdateAsistenciaDAIR] 
END 
GO
CREATE PROC [dbo].[UpdateAsistenciaDAIR]
	@SesionDAIRId INT,
	@Cedula NVARCHAR(16),
	@Asistio BIT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarAsistenciaDAIR
			DECLARE @AsambleistaId INT
			SELECT @AsambleistaId = A.Id
			FROM dbo.Asambleista A
			WHERE A.Cedula = @Cedula
			
			UPDATE dbo.RegistroAsistenciaDAIR
			SET Asistio = @Asistio
			WHERE AsambleistaId = @AsambleistaId AND SesionDAIRId = SesionDAIRId
		COMMIT TRANSACTION modificarAsistenciaDAIR;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarAsistenciaDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[DeleteAsistenciaDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[DeleteAsistenciaDAIR] 
END 
GO
CREATE PROC [dbo].[DeleteAsistenciaDAIR]
	@Id INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION eliminarAsistenciaDAIR
			UPDATE dbo.RegistroAsistenciaDAIR
			SET Asistio = 0
			WHERE Id = @Id
		COMMIT TRANSACTION eliminarAsistenciaDAIR;
		SELECT @Id;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION eliminarAsistenciaDAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[NuevoRegistroDAIR]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[NuevoRegistroDAIR] 
END 
GO
CREATE PROC [dbo].[NuevoRegistroDAIR]
	@SesionId INT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		BEGIN TRANSACTION modificarAsistenciaAIR
			UPDATE dbo.RegistroAsistenciaDAIR
			SET Validacion = 0
			WHERE SesionDAIRId = @SesionId
		COMMIT TRANSACTION modificarAsistenciaAIR;
		SELECT 1;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION modificarAsistenciaAIR;
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO