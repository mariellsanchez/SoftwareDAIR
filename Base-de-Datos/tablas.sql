--DROP DATABASE IF EXISTS [ProyectoDAIR]

--CREATE DATABASE [ProyectoDAIR]

USE [ProyectoDAIR];
GO

CREATE TABLE Departamento(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [Nombre]				NVARCHAR(128) NOT NULL,
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE Etapa(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [Nombre]				NVARCHAR(32) NOT NULL,
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE Sector(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [Nombre]				NVARCHAR(32) NOT NULL,
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE Sede(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [Nombre]				NVARCHAR(32) NOT NULL,
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE Periodo(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [AnioInicio]				INT NOT NULL,
	  [AnioFin]					INT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE Notificacion(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [Motivo]				NVARCHAR(256) NOT NULL,
	  [FechaNotificacion]	DATE NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE Asambleista(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [DepartamentoId]		INT NOT NULL,
	  [SectorId]			INT NOT NULL,
	  [SedeId]				INT NOT NULL,
	  [Nombre]				NVARCHAR(128) NOT NULL,
	  [Cedula]				NVARCHAR(16) NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([DepartamentoId]) REFERENCES dbo.Departamento ([ID]),
	  FOREIGN KEY ([SectorId]) REFERENCES dbo.Sector ([ID]),
	  FOREIGN KEY ([SedeId]) REFERENCES dbo.Sede ([ID])
);

CREATE TABLE SesionAIR(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [PeriodoId]			INT NOT NULL,
	  [Nombre]				NVARCHAR(64) NOT NULL,
	  [Fecha]				DATE NOT NULL,
	  [HoraInicio]			TIME NOT NULL,
	  [HoraFin]				TIME NOT NULL,
	  [Valido]				BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([PeriodoId]) REFERENCES dbo.Periodo ([ID])
);

CREATE TABLE SesionDAIR(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [PeriodoId]			INT NOT NULL,
	  [Nombre]				NVARCHAR(64) NOT NULL,
	  [Fecha]				DATE NOT NULL,
	  [HoraInicio]			TIME NOT NULL,
	  [HoraFin]				TIME NOT NULL,
	  [Valido]				BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([PeriodoId]) REFERENCES dbo.Periodo ([ID])
);

CREATE TABLE PropuestaDAIR(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [SesionDAIRId]		INT NOT NULL,
	  [Nombre]				NVARCHAR(64) NOT NULL,
	  [Aprovado]			BIT NOT NULL,
	  [Link]				NVARCHAR(256) NOT NULL,
	  [Valido]				BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([SesionDAIRId]) REFERENCES dbo.SesionDAIR ([ID])
);

CREATE TABLE PropuestaAIR(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [SesionAIRId]			INT NOT NULL,
	  [EtapaId]				INT NOT NULL,
	  [Aprovado]			BIT NOT NULL,
	  [Nombre]				NVARCHAR(64) NOT NULL,
	  [Link]				NVARCHAR(256) NOT NULL,
	  [NumeroDePropuesta]	INT NOT NULL,
	  [VotosAFavor]			INT NOT NULL,
	  [VotosEnContra]		INT NOT NULL,
	  [VotosEnBlanco]		INT NOT NULL,
	  [Valido]				BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([SesionAIRId]) REFERENCES dbo.SesionAIR ([ID]),
	  FOREIGN KEY ([EtapaId]) REFERENCES dbo.Etapa ([ID])
);

CREATE TABLE RegistroAsistenciaDAIR(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [SesionDAIRId]		INT NOT NULL,
	  [AsambleistaId]		INT NOT NULL,
	  [Asistio]				BIT NOT NULL,
	  [Validacion]			BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([SesionDAIRId]) REFERENCES dbo.SesionDAIR ([ID]),
	  FOREIGN KEY ([AsambleistaId]) REFERENCES dbo.Asambleista ([ID])
);

CREATE TABLE RegistroAsistenciaAIR(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [SesionAIRId]			INT NOT NULL,
	  [AsambleistaId]		INT NOT NULL,
	  [Asistio]				BIT NOT NULL,
	  [Validacion]			BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([SesionAIRId]) REFERENCES dbo.SesionAIR ([ID]),
	  FOREIGN KEY ([AsambleistaId]) REFERENCES dbo.Asambleista ([ID])
);

CREATE TABLE Padron(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [AsambleistaId]		INT NOT NULL,
	  [PeriodoId]			INT NOT NULL,
	  [Validacion]			BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([AsambleistaId]) REFERENCES dbo.Asambleista ([ID]),
	  FOREIGN KEY ([PeriodoId]) REFERENCES dbo.Periodo ([ID])
);

CREATE TABLE Usuario(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [Nombre]				NVARCHAR(64),
	  [Contrasenia]			NVARChAR(32)
	  PRIMARY KEY CLUSTERED ([ID] ASC)
);

CREATE TABLE PropuestaAIRxAsambleista(
	  [Id]					INT NOT NULL IDENTITY(1,1),
	  [AsambleistaId]		INT NOT NULL,
	  [PropuestaAIRId]		INT NOT NULL,
	  [Validaion]			BIT NOT NULL
	  PRIMARY KEY CLUSTERED ([ID] ASC),
	  FOREIGN KEY ([AsambleistaId]) REFERENCES dbo.Asambleista ([ID]),
	  FOREIGN KEY ([PropuestaAIRId]) REFERENCES dbo.PropuestaAIR ([ID])
);
