USE [ProyectoDAIR];
GO

IF OBJECT_ID('[dbo].[GetAsambleistas]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[GetAsambleistas] 
END 
GO
CREATE PROC [dbo].[GetAsambleistas]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[BuscarAsambleista]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[BuscarAsambleista] 
END 
GO
CREATE PROC [dbo].[BuscarAsambleista] 
    @Entrada NVARCHAR(64)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		WHERE A.Nombre LIKE '%' + @Entrada + '%' OR A.Cedula LIKE '%' + @Entrada + '%' OR D.Nombre LIKE '%' + @Entrada + '%'
			OR S.Nombre LIKE '%' + @Entrada + '%' OR Sed.Nombre LIKE '%' + @Entrada + '%'
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[BuscarAsambleistaNombre]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[BuscarAsambleistaNombre] 
END 
GO
CREATE PROC [dbo].[BuscarAsambleistaNombre] 
    @Entrada NVARCHAR(64)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		WHERE A.Nombre LIKE '%' + @Entrada + '%'
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[BuscarAsambleistaCedula]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[BuscarAsambleistaCedula] 
END 
GO
CREATE PROC [dbo].[BuscarAsambleistaCedula] 
    @Entrada NVARCHAR(16)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		WHERE A.Cedula LIKE '%' + @Entrada + '%'
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[BuscarAsambleistaDepartamento]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[BuscarAsambleistaDepartamento] 
END 
GO
CREATE PROC [dbo].[BuscarAsambleistaDepartamento] 
    @Entrada NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		WHERE D.Nombre LIKE '%' + @Entrada + '%'
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[BuscarAsambleistaSector]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[BuscarAsambleistaSector] 
END 
GO
CREATE PROC [dbo].[BuscarAsambleistaSector] 
    @Entrada NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		WHERE S.Nombre LIKE '%' + @Entrada + '%'
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO

IF OBJECT_ID('[dbo].[BuscarAsambleistaSede]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[BuscarAsambleistaSede] 
END 
GO
CREATE PROC [dbo].[BuscarAsambleistaSede] 
    @Entrada NVARCHAR(32)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		SELECT A.Id,A.Nombre AS Asambleista,A.Cedula,D.Nombre AS Departamento,S.Nombre AS Sector,Sed.Nombre AS Sede
		FROM dbo.Asambleista A
		INNER JOIN dbo.Departamento D ON A.DepartamentoId = D.Id
		INNER JOIN dbo.Sector S ON A.SectorId = S.Id
		INNER JOIN dbo.Sede Sed ON A.SedeId = Sed.Id
		WHERE Sed.Nombre LIKE '%' + @Entrada + '%'
		ORDER BY A.Nombre
	END TRY

	BEGIN CATCH
		SELECT -1
	END CATCH
SET NOCOUNT OFF
END
GO