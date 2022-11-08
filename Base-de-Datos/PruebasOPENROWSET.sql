DECLARE @TempTable TABLE(Sec INT IDENTITY(1,1),
							Departamento NVARCHAR(64),
							Sector NVARCHAR(32),
							Sede NVARCHAR(32),
							Nombre NVARCHAR(128),
							Cedula INT)
							
DECLARE @TempSede TABLE(Sec INT IDENTITY(1,1),
							Sede NVARCHAR(32))
							
DECLARE @TempCedula TABLE(Sec INT IDENTITY(1,1),
							Cedula NVARCHAR(16))
							
DECLARE @Command NVARCHAR(MAX)
INSERT INTO @TempTable(Departamento,Sector,Sede,Nombre,Cedula)
SELECT DEPARTAMENTO,
		SECTOR,
		[CAMPUS O  CENTRO ACADÉMICO],
		NOMBRE + ' ' +[PRIMER APELLIDO] + ' ' + [SEGUNDO APELLIDO],
		CEDULA
FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
    'Excel 12.0; Database=C:\Users\admin\Desktop\TEC\2022\Semestre II\Proyecto\ProyectoDAIR\ProyectoDAIR\Back-End\UploadedFiles\Reportes AIR 100-2022.xlsx', 'select * from [Padrón_Resumen$]')
WHERE CEDULA IS NOT NULL

INSERT INTO @TempCedula(Cedula)
SELECT convert(nvarchar(16), Cedula)
FROM @TempTable

SELECT * FROM @TempCedula

--INSERT INTO @TempSede
--SELECT 'CARTAGO'
--INSERT INTO @TempSede
--SELECT 'LIMÓN'
--INSERT INTO @TempSede
--SELECT 'SAN JOSÉ'

--INSERT INTO @TempSede(Sede)
--SELECT TS.Sede
--FROM @TempTable TS
--WHERE NOT EXISTS(SELECT S.Sede FROM @TempSede S WHERE S.Sede = TS.Sede) 

--SELECT * FROM @TempSede
    
SELECT * FROM @TempTable
SELECT DISTINCT Sede FROM @TempTable

--SELECT * FROM dbo.SesionAIR
----No se puede revertir nuevoAsambleista. No se encuentra ninguna transacción ni punto de retorno con ese nombre.

--SELECT * FROM dbo.RegistroAsistenciaAIR
--SELECT * FROM dbo.Asambleista
--SELECT * FROM dbo.Sector
--SELECT * FROM dbo.Sede
--SELECT * FROM dbo.Departamento DEC

--DELETE FROM dbo.Departamento WHERE Id > 32;

SELECT * FROM dbo.RegistroAsistenciaAIR
SELECT * FROM dbo.Asambleista

DELETE FROM [dbo].RegistroAsistenciaAIR
DBCC CHECKIDENT(RegistroAsistenciaAIR, RESEED, 0)
SELECT * FROM [dbo].RegistroAsistenciaAIR

DELETE FROM [dbo].RegistroAsistenciaDAIR
DBCC CHECKIDENT(RegistroAsistenciaDAIR, RESEED, 0)
SELECT * FROM [dbo].RegistroAsistenciaDAIR

DELETE FROM [dbo].Padron
DBCC CHECKIDENT(Padron, RESEED, 0)
SELECT * FROM [dbo].Padron

DELETE FROM [dbo].Asambleista
DBCC CHECKIDENT(Asambleista, RESEED, 0)
SELECT * FROM [dbo].Asambleista

--SELECT DEPARTAMENTO,
--		SECTOR,
--		[CAMPUS O  CENTRO ACADÉMICO],
--		NOMBRE + ' ' +[PRIMER APELLIDO] + ' ' + [SEGUNDO APELLIDO],
--		CEDULA
--FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
--    'Excel 12.0; Database=C:\Users\admin\Desktop\TEC\2022\Semestre II\Proyecto\ProyectoDAIR\ProyectoDAIR\Back-End\UploadedFiles\Reportes AIR 100-2022.xlsx', 'select * from [Padrón_Resumen$]')
--WHERE CEDULA IS NOT NULL

--DECLARE @TempTable TABLE(Sec INT IDENTITY(1,1),
--							Departamento NVARCHAR(64),
--							Sector NVARCHAR(32),
--							Sede NVARCHAR(32),
--							Nombre NVARCHAR(128),
--							Cedula INT)


--Declare @Route NVARCHAR(200), 
--		@sql nvarchar(max),
--		@Sheet NVARCHAR(128)
--SELECT @Route = 'C:\Users\admin\Desktop\TEC\2022\Semestre II\Proyecto\ProyectoDAIR\ProyectoDAIR\Back-End\UploadedFiles\Reportes AIR 100-2022.xlsx',
--		@Sheet = 'Padrón_Resumen',
--		@sql = 'SELECT DEPARTAMENTO,SECTOR,[CAMPUS O  CENTRO ACADÉMICO],NOMBRE + '' '' +[PRIMER APELLIDO] + '' '' + [SEGUNDO APELLIDO],
--		CEDULA
--		FROM OPENROWSET(''Microsoft.ACE.OLEDB.16.0'',
--			''Excel 12.0; Database=' + @Route + ''',
--			''select * from ['+@Sheet+'$]'')
--			WHERE CEDULA IS NOT NULL'
----Print @sql
--INSERT INTO @TempTable(Departamento,Sector,Sede,Nombre,Cedula)
--EXEC (@sql)
--SELECT * FROM @TempTable


--Set @sql='SELECT * INTO FFFF
--FROM OPENROWSET(
--               ''Microsoft.ACE.OLEDB.12.0'',
--               ''Excel 12.0;HDR=YES;Database=' + @Route + ''',
--               ''SELECT * FROM [Sheet1$]'')'


SELECT [DEPARTAMENTO / ESCUELA / GRUPO ADMINISTRATIVO],
		SECTOR,
		[CAMPUS O  CENTRO ACADÉMICO],
		NOMBRE + ' ' +[PRIMER APELLIDO] + ' ' + [SEGUNDO APELLIDO],
		CÉDULA
FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
    'Excel 12.0; Database=C:\Users\admin\Desktop\TEC\2022\Semestre II\Proyecto\Padrón Gnrl Provisional AIR-104-2022 10 oct22 (1).xlsx', 'select * from [Padrón Gnl Prov 10 oct$]')
WHERE CÉDULA IS NOT NULL


DECLARE @TempTable TABLE(Sec INT IDENTITY(1,1),
							Departamento NVARCHAR(128),
							Sector NVARCHAR(32),
							Sede NVARCHAR(32),
							Nombre NVARCHAR(128),
							Cedula NVARCHAR(32))
INSERT INTO @TempTable(Departamento,Sector,Sede,Nombre,Cedula)
SELECT [DEPARTAMENTO / ESCUELA / GRUPO ADMINISTRATIVO],
		SECTOR,
		[CAMPUS O  CENTRO ACADÉMICO],
		NOMBRE + ' ' +[PRIMER APELLIDO] + ' ' + [SEGUNDO APELLIDO],
		CÉDULA
FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
    'Excel 12.0; Database=C:\Users\admin\Desktop\TEC\2022\Semestre II\Proyecto\Copia Padrón General Definitivo.xlsx', 'select * from [General Definitivo$]')
--WHERE CÉDULA IS NOT NULL

SELECT * FROM @TempTable

SELECT [DEPARTAMENTO],
		SECTOR,
		[SEDE],
		NOMBRE,
		CEDULA
FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
    'Excel 12.0; Database=C:\Users\admin\Desktop\TEC\2022\Semestre II\Proyecto\Padrón General Definitivo Representantes ante la AIR 2018.2020.Sin protección.xlsx', 'select * from [General Definitivo$]')
