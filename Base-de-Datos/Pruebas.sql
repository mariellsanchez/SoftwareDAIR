------------Pruebas CRUD Usuario------------
EXEC dbo.CreateUsuario 'admin','contrasenia'
EXEC dbo.ReadUsuario 1
EXEC dbo.UpdateUsuario 1, 'admin','contrasenia'

------------Pruebas Tablas------------
---Departemento
EXEC dbo.CreateDepartamento 'Matematica'
EXEC dbo.CreateDepartamento 'Ingenieria en Computacion'
EXEC dbo.CreateDepartamento 'Recursos Humanos'
EXEC dbo.CreateDepartamento 'Quimica'

EXEC ReadDepartamento 1
EXEC UpdateDepartamento 1, 'AIR'
EXEC ReadDepartamento 1

---Sede
EXEC dbo.CreateSede 'Limon'
EXEC dbo.CreateSede 'San Jose'

EXEC dbo.ReadSede 1
EXEC dbo.ReadSede 2

EXEC dbo.UpdateSede 2, 'Cartago'
EXEC dbo.ReadSede 2

SELECT * FROM dbo.Sede

---Sector
EXEC dbo.CreateSector 'Administrativo'
EXEC dbo.CreateSector 'Docente'
EXEC dbo.CreateSector 'Oficio'
EXEC dbo.CreateSector 'Egresado'

EXEC dbo.ReadSector 4
EXEC dbo.UpdateSector 4,'Estudiante' 
SELECT * FROM dbo.Sector

---Etapa
EXEC dbo.CreateEtapa 'Aprobado'
EXEC dbo.CreateEtapa 'Rechasado'

EXEC dbo.ReadEtapa 1
EXEC dbo.UpdateEtapa 1, 'Aprobado'
SELECT * FROM dbo.Etapa

---Periodo
EXEC dbo.CreatePeriodo 2020,2022
EXEC dbo.ReadPeriodo 1
EXEC dbo.UpdatePeriodo 1, 2021,2022

SELECT * FROM dbo.Periodo

------------Notificacion------------
EXEC dbo.CreateNotificacion 'Reunion semana 9', '28/09/2022'
EXEC dbo.CreateNotificacion 'Asamblea extraordinaria', '05/11/2022'
EXEC dbo.CreateNotificacion 'Tema importante', '15/02/2026'

EXEC dbo.ReadNotificacion 1
EXEC dbo.ReadNotificacion 3

EXEC dbo.UpdateNotificacion 1,'Reunion semana 10', '05/10/2022'
EXEC dbo.DeleteNotificacion 3

SELECT * FROM dbo.Notificacion

------------Asambleista------------
SELECt * FROM dbo.Departamento
SELECt * FROM dbo.Sector
SELECt * FROM dbo.Sede
EXEC dbo.CreateAsambleista 'AIR','Oficio','Limon','Juan Perez','201540136'
EXEC dbo.CreateAsambleista 'Ingenieria en Computacion','Estudiante','Cartago','Juan Gomez','601450951'
EXEC dbo.CreateAsambleista 'Matematica','Docente','San Jose','Fabian Perez','301451450'
EXEC dbo.CreateAsambleista 'Recursos Humanos','Administrativo','Limon','Pablo Perez','704140312'
EXEC dbo.CreateAsambleista 'Quimica','Docente','Cartago','Maria Quiroz','301470147'
EXEC dbo.CreateAsambleista 'Matematica','Docente','San Jose','Sara Arguedas','601370841'
EXEC dbo.CreateAsambleista 'Matematica','Estudiante','Cartago','Juan Perez','104440888'
EXEC dbo.CreateAsambleista 'Quimica','Estudiante','Cartago','Juana Villalobos','303320112'

EXEC dbo.ReadAsambleista 2
EXEC dbo.UpdateAsambleista 'Ingenieria en Computacion','Docente','San Jose','Juan Perez Coto','201540136'
EXEC dbo.ReadAsambleista 5
SELECT * FROM dbo.Asambleista ORDER BY Nombre

------------Padron------------
EXEC dbo.CreatePadron 301451450, 1
EXEC dbo.CreatePadron 301451450,2
EXEC dbo.CreatePadron 104440888, 1
EXEC dbo.CreatePadron 201540136,2
EXEC dbo.CreatePadron 303320112,2
EXEC dbo.CreatePadron 104440888, 1
EXEC dbo.CreatePadron 601370841,2
EXEC dbo.CreatePadron 301470147,1
EXEC dbo.CreatePadron 301470147,2
EXEC dbo.CreatePadron 301470147,1

EXEC dbo.GetPadron 2
EXEC dbo.InsertarPadron 1
EXEC dbo.GetPadron 1
SELECT * FROM dbo.Padron

EXEC dbo.ReadPadron 5
EXEC dbo.UpdatePadron 301451450, 1, 1
EXEC dbo.UpdatePadron 201540136,2, 1
EXEC dbo.UpdatePadron 301470147,1,1
EXEC dbo.UpdatePadron 301470147,2,1
SELECT * FROM dbo.Padron

------------SesionAIR------------
EXEC dbo.CreateSesionAIR 2,'AIR ordinaria Nº 104-2022','17/6/2021','8:00','12:00','',''
EXEC dbo.CreateSesionAIR 2,'AIR ordinaria Nº 105-2022','16/9/2020','8:00','12:00','',''
EXEC dbo.CreateSesionAIR 2,'AIR ordinaria Nº 106-2022','13/5/2021','8:00','12:00','',''
EXEC dbo.CreateSesionAIR 1,'AIR ordinaria Nº 103-2022','16/9/2022','8:00','12:00','',''
EXEC dbo.CreateSesionAIR 1,'AIR ordinaria Nº 102-2022','9/7/2022','8:00','12:00','',''
EXEC dbo.CreateSesionAIR 1,'AIR extraordinaria Nº 101-2022','19/4/2022','8:00','12:00','',''
EXEC dbo.CreateSesionAIR 1,'AIR ordinaria Nº 100-2022','26/2/2022','8:00','12:00','',''

SELECT * FROM dbo.SesionAIR
EXEC dbo.ReadSesionAIR 1
EXEC dbo.ReadSesionAIR 3
EXEC dbo.ReadSesionAIR 6
EXEC dbo.UpdateSesionAIR 6, 'AIR ordinaria Nº 101-2022','18/4/2022','8:02','11:48','www.youtube.com'
EXEC dbo.DeleteSesionAIR 3
EXEC dbo.ReadSesionAIR 6
EXEC dbo.ReadSesionAIR 3

------------SesionDAIR------------
EXEC dbo.CreateSesionDAIR 2,'DAIR ordinaria Nº 104-2022','17/6/2021','8:00','12:00','www.youtube.com',''
EXEC dbo.CreateSesionDAIR 2,'DAIR ordinaria Nº 105-2022','16/9/2020','8:00','12:00','www.youtube.com',''
EXEC dbo.CreateSesionDAIR 2,'DAIR ordinaria Nº 106-2022','13/5/2021','8:00','12:00','www.youtube.com',''
EXEC dbo.CreateSesionDAIR 1,'DAIR ordinaria Nº 103-2022','16/9/2022','8:00','12:00','www.youtube.com',''
EXEC dbo.CreateSesionDAIR 1,'DAIR ordinaria Nº 102-2022','9/7/2022','8:00','12:00','www.youtube.com',''
EXEC dbo.CreateSesionDAIR 1,'DAIR extraordinaria Nº 101-2022','19/4/2022','8:00','12:00','www.youtube.com',''
EXEC dbo.CreateSesionDAIR 1,'DAIR ordinaria Nº 100-2022','26/2/2022','8:00','12:00','www.youtube.com',''

SELECT * FROM dbo.SesionDAIR
EXEC dbo.ReadSesionDAIR 1
EXEC dbo.ReadSesionDAIR 3
EXEC dbo.ReadSesionDAIR 6
EXEC dbo.UpdateSesionDAIR 6, 'DAIR ordinaria Nº 101-2022','18/4/2022','8:02','11:48','www.google.com'
EXEC dbo.DeleteSesionDAIR 3
EXEC dbo.ReadSesionDAIR 6
EXEC dbo.ReadSesionDAIR 3

------------Registro Asistencia AIR------------
EXEC dbo.CreateAsistenciaAIR 5,'301451450',1
EXEC dbo.CreateAsistenciaAIR 1,'301451450',0
EXEC dbo.CreateAsistenciaAIR 2,'301451450',1
EXEC dbo.CreateAsistenciaAIR 4,'104440888',1
EXEC dbo.CreateAsistenciaAIR 4,'303320112',0
EXEC dbo.CreateAsistenciaAIR 4,'601370841',1
EXEC dbo.CreateAsistenciaAIR 2,'601370841',0
EXEC dbo.CreateAsistenciaAIR 4,'301451450',1
SELECT * FROM dbo.RegistroAsistenciaAIR

EXEC dbo.ReadAsistenciaAIR 2
EXEC dbo.UpdateAsistenciaAIR 6,'301451450',1
EXEC dbo.UpdateAsistenciaAIR 5,'301451450',0
EXEC dbo.DeleteAsistenciaAIR 6

EXEC dbo.DeleteAsistenciaAIR 1
EXEC dbo.NuevoRegistroAIR 4,'C:\\Users\\admin\\Desktop\\TEC\\2022\\Semestre II\\Proyecto\\ProyectoDAIR\\ProyectoDAIR\\Back-End\\UploadedFiles\\Reportes AIR 100-2022.xlsx', 'Padrón_Resumen'
SELECT * FROM dbo.RegistroAsistenciaAIR

------------Registro Asistencia DAIR------------
EXEC dbo.CreateAsistenciaDAIR 1,'301451450',1
EXEC dbo.CreateAsistenciaDAIR 2,'301451450',1
EXEC dbo.CreateAsistenciaDAIR 3,'301451450',0
EXEC dbo.CreateAsistenciaDAIR 4,'104440888',1
EXEC dbo.CreateAsistenciaDAIR 4,'303320112',0
EXEC dbo.CreateAsistenciaDAIR 4,'601370841',0
EXEC dbo.CreateAsistenciaDAIR 2,'601370841',1
EXEC dbo.CreateAsistenciaDAIR 4,'301451450',1
SELECT * FROM dbo.RegistroAsistenciaDAIR

EXEC dbo.ReadAsistenciaDAIR 2
EXEC dbo.UpdateAsistenciaDAIR 1,'301451450',1
EXEC dbo.UpdateAsistenciaDAIR 1,'301451450',0
EXEC dbo.DeleteAsistenciaDAIR 6

EXEC dbo.DeleteAsistenciaDAIR 1
EXEC dbo.NuevoRegistroDAIR 2
SELECT * FROM dbo.RegistroAsistenciaDAIR

------------Propuesta DAIR------------
EXEC CreatePropuestaDAIR 1, 'Reintegracion de los autobuses en la noche',0,'www.link.com'
EXEC CreatePropuestaDAIR 1, 'Prpuesta 2',1,'www.link.com'
EXEC CreatePropuestaDAIR 1, 'Propuesta 3',0,'www.link.com'
EXEC CreatePropuestaDAIR 2, 'Ampliacion del menu del TEC',1,'www.link.com'
EXEC CreatePropuestaDAIR 3, 'Disminucion del menu del TEC',0,'www.link.com'
EXEC CreatePropuestaDAIR 1, 'Aumentar precio del menu del TEC',0,'www.link.com'
EXEC CreatePropuestaDAIR 2, 'Aumentar el numero de sesiones',0,'www.link.com'
EXEC CreatePropuestaDAIR 4, 'Reintegracion de los autobuses en la noche',1,'www.link.com'

EXEC ReadPropuestaDAIR 1
EXEC ReadPropuestaDAIR 6

EXEC UpdatePropuestaDAIR 1, 'Reintegracion de los autobuses en la noche',0,'www.link2.com'
EXEC ReadPropuestaDAIR 1
EXEC DeletePropuestaDAIR 6
EXEC ReadPropuestaDAIR 6
SELECT * FROM dbo.PropuestaDAIR

------------Propuesta AIR------------
EXEC CreatePropuestaAIR 1,1,1, 'Reintegracion de los autobuses en la noche','www.link.com',1,172,24,4
EXEC CreatePropuestaAIR 1,2,1, 'Prpuesta 2','www.link.com',2,100,50,50
EXEC CreatePropuestaAIR 1,1,0, 'Propuesta 3','www.link.com',3,100,60,40
EXEC CreatePropuestaAIR 2,2,1, 'Ampliacion del menu del TEC','www.link.com',1,110,55,45
EXEC CreatePropuestaAIR 3,1,0, 'Disminucion del menu del TEC','www.link.com',1,160,25,15
EXEC CreatePropuestaAIR 1,2,1, 'Aumentar precio del menu del TEC','www.link.com',4,180,12,8
EXEC CreatePropuestaAIR 2,1,0, 'Aumentar el numero de sesiones','www.link.com',2,100,65,35
EXEC CreatePropuestaAIR 4,2,1, 'Reintegracion de los autobuses en la noche','www.link.com',1,100,60,40

EXEC ReadPropuestaAIR 1
EXEC ReadPropuestaAIR 6

EXEC UpdatePropuestaAIR 1,1,1,'Prpuesta 1','www.link2.com',2,162,23,15
EXEC ReadPropuestaAIR 1
EXEC DeletePropuestaAIR 6
EXEC ReadPropuestaAIR 6
SELECT * FROM dbo.PropuestaAIR

------------Proponentes------------
SELECT * FROM dbo.Asambleista
SELECT * FROM dbo.PropuestaAIR

EXEC CreateProponente 5,2
EXEC CreateProponente 2,2
EXEC CreateProponente 1,1
EXEC CreateProponente 9,4

EXEC ReadProponente 1
EXEC ReadProponente 2
EXEC ReadProponente 3
EXEC ReadProponente 4

EXEC UpdateProponente 2,3
EXEC ReadProponente 2

EXEC DeleteProponente 1

SELECT * FROM PropuestaAIRxAsambleista

------------GetSesiones------------
EXEC GetSesionesAIR
EXEC GetSesionesDAIR

EXEC BuscarSesionAIR '100'
EXEC BuscarSesionDAIR '103'

------------GETNOTIFICACIONes------
EXEC GetNotificaciones

------------GetAsistencia------------
EXEC GetAsistenciaSesionAIR 4
EXEC GetAsistenciaSesionDAIR 4

------------GetAsistencia------------
EXEC GetPropuestasAIR 1
EXEC GetPropuestasDAIR 1

------------GetAsambleista------------
EXEC GetAsambleistas
EXEC BuscarAsambleista 'san'


-------------Pruebas Read-----------
EXEC dbo.ReadAsambleista 1
EXEC dbo.ReadAsistenciaAIR 1
EXEC dbo.ReadAsistenciaDAIR 1
EXEC dbo.ReadDepartamento 1
EXEC dbo.ReadEtapa 1
EXEC dbo.ReadNotificacion 1
EXEC dbo.ReadPadron 1
EXEC dbo.ReadPeriodo 1
EXEC dbo.ReadProponente 1
EXEC dbo.ReadPropuestaAIR 1
EXEC dbo.ReadPropuestaDAIR 1
EXEC dbo.ReadSector 1
EXEC dbo.ReadSede 1
EXEC dbo.ReadSesionAIR 1
EXEC dbo.ReadSesionDAIR 1
EXEC dbo.ReadUsuario 1

-------------Pruebas Get-----------
EXEC dbo.GetAsambleistas
EXEC dbo.GetAsistenciaSesionDAIR 1
EXEC dbo.GetAsistenciaSesionAIR 4
EXEC dbo.GetDepartamento
EXEC dbo.GetEtapa
EXEC dbo.GetNotificaciones 
EXEC dbo.GetPadron 1
EXEC dbo.GetPeriodo
EXEC dbo.GetProponente 4
EXEC dbo.GetPropuestasAIR 1
EXEC dbo.GetPropuestasDAIR 1
EXEC dbo.GetSector
EXEC dbo.GetSede
EXEC dbo.GetSesionesAIR 
EXEC dbo.GetSesionesDAIR
