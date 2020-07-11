create database HospitalInfectologiaIN5BM;
use HospitalInfectologiaIN5BM;

create table Medicos(
codigoMedico int not null auto_increment primary key,
licenciaMedica int(10) not null,
nombres varchar(100) not null,
apellidos varchar(100) not null,
horaEntrada datetime not null,
horaSalida datetime not null,
-- turnoMaximo int (10) not null,
sexo varchar(15) not null
);

create table telefonosMedico(
codigoTelefonoMedico int not null auto_increment primary key,
telefonoPersonal varchar(15) not null,
telefonoTrabajo varchar(15) not null,
codigoMedico int not null not null,
foreign key(codigoMedico)references Medicos(codigoMedico)
);

create table Horarios(
codigoHorario int not null auto_increment primary key,
horarioInicio datetime not null,
horarioSalida datetime not null,
lunes tinyint not null,
martes tinyint not null,
miercoles tinyint not null,
jueves tinyint not null,
viernes tinyint not null
);

create table Especialidades(
codigoEspecialidad int not null auto_increment primary key,
nombreEspecialidad varchar(45) not null
);

create table Pacientes(
codigoPaciente int not null auto_increment primary key,
DPI varchar(20) not null,
apellidos varchar(100) not null,
nombres varchar(100) not null,
fechaNacimiento date not null,
edad int not null,
direccion varchar(150) not null,
ocupacion varchar(50) not null,
sexo varchar(15) not null
);

create table contactoUrgencia(
codigoContactoUrgencia int not null auto_increment primary key,
nombres varchar(100) not null,
apellidos varchar(100) not null,
numeroContacto varchar(10) not null,
codigoPaciente int not null,
foreign key(codigoPaciente)references Pacientes(codigoPaciente)
);

create table Medico_Especialidad(
codigoMedicoEspecialidad int not null primary key,
codigoEspecialidad int not null,
codigoHorario int not null,
codigoMedico int not null,
foreign key(codigoEspecialidad)references Especialidades(codigoEspecialidad),
foreign key(codigoHorario)references Horarios(codigoHorario),
foreign key(codigoMedico)references Medicos(codigoMedico)
);

create table Areas(
codigoArea int not null auto_increment primary key,
nombreArea varchar(45) not null
);

create table Cargos(
codigoCargo int not null auto_increment primary key,
nombreCargo varchar(45) not null
);

create table ResponsableTurno(
codigoResponsableTurno int not null primary key,
nombreResponsable varchar(75) not null,
apellidosResponsable varchar(45) not null,
telefonoPersonal varchar(10) not null,
codigoArea int not null,
codigoCargo int not null,
foreign key(codigoArea)references Areas(codigoArea),
foreign key(codigoCargo)references Cargos(codigoCargo)
);

create table Turno(
codigoTurno int not null auto_increment primary key,
fechaTurno date not null,
fechaCita date not null,
valorCita decimal(10,2) not null,
codigoResponsableTurno int not null,
codigoPaciente int not null,
codigoMedicoEspecialidad int not null,
foreign key(codigoResponsableTurno)references ResponsableTurno(codigoResponsableTurno),
foreign key(codigoPaciente)references Pacientes(codigoPaciente),
foreign key(codigoMedicoEspecialidad)references Medico_Especialidad(codigoMedicoEspecialidad)
);

-- ----------------------- AGREGAR --------------------------------
DELIMITER $$
	CREATE PROCEDURE sp_AgregarMedicos (p_codigoMedico int, p_licenciaMedica int, p_nombres varchar(100), p_apellidos varchar(100), p_horaEntrada datetime, p_horaSalida datetime, p_sexo varchar(45))
    BEGIN
		INSERT INTO Medicos (codigoMedico, licenciaMedica, nombres, apellidos, horaEntrada, horaSalida, sexo) values (p_codigoMedico, p_licenciaMedica, p_nombres, p_apellidos, p_horaEntrada, p_horaSalida, p_sexo);
    
END $$

	CALL sp_AgregarMedicos (1, 44525,'Roberto','Perez','2019-05-01 06:00:00','2019-05-01 16:00:00','Masculino');
    CALL sp_AgregarMedicos (2, 44595,'Amanda','Flores','2019-04-02 07:00:00','2019-04-02 17:00:00','Femenino');
    
    select * from Medicos;
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregartelefonosMedico (p_codigoTelefonoMedico int, p_telefonoPersonal varchar(15), p_telefonoTrabajo varchar(15), p_codigoMedico int)
    BEGIN
		INSERT INTO telefonosMedico (codigoTelefonoMedico, telefonoPersonal, telefonoTrabajo, codigoMedico) values (p_codigoTelefonoMedico, p_telefonoPersonal, p_telefonoTrabajo, p_codigoMedico);

END $$

	CALL sp_AgregartelefonosMedico (1,'45352565','22553512',1);
    CALL sp_AgregartelefonosMedico (2,'50846555','45856584',2);
    
    SELECT * FROM telefonosMedico;
    
DELIMITER $$	
	CREATE PROCEDURE sp_AgregarHorarios (p_codigoHorario int, p_horarioInicio datetime, p_horarioSalida datetime, p_lunes tinyint, p_martes tinyint, p_miercoles tinyint, p_jueves tinyint, p_viernes tinyint)
    BEGIN
		INSERT INTO  Horarios (codigoHorario, horarioInicio, horarioSalida, lunes, martes, miercoles, jueves, viernes) values (p_codigoHorario, p_horarioInicio, p_horarioSalida, p_lunes, p_martes, p_miercoles, p_jueves, p_viernes);
    
END $$

	CALL sp_AgregarHorarios (1,'2019-04-03 06:00:00', '2019-04-03 16:00:00',2,3,4,8,6);
    CALL sp_AgregarHorarios (2,'2019-03-01 07:00:00', '2019-03-01 17:00:00',1,2,5,3,4);
    
    SELECT * FROM Horarios;
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarEspecialidades (p_codigoEspecialidad int, p_nombreEspecialidad varchar(45))
	BEGIN
		INSERT INTO Especialidades (codigoEspecialidad, nombreEspecialidad) values (p_codigoEspecialidad, p_nombreEspecialidad);
        
END $$

	CALL sp_AgregarEspecialidades (1,'Pediatra');
    CALL sp_AgregarEspecialidades (2,'Dentista');
    
    SELECT * FROM Especialidades;
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarPacientes (p_DPI varchar(20), p_apellidos varchar(100), p_nombres varchar(100), p_fechaNacimiento date, p_edad int, p_direccion varchar(150), p_ocupacion varchar(50), p_sexo varchar(15))    
    BEGIN
		INSERT INTO Pacientes (DPI, apellidos, nombres, fechaNacimiento, edad, direccion, ocupacion, sexo) values (p_DPI, p_apellidos, p_nombres, p_fechaNacimiento, p_edad, p_direccion, p_ocupacion, p_sexo);
	
END $$
	
    CALL sp_AgregarPacientes ('2546853245685', 'Fernandez Ramirez', 'Hugo Alberto', '1992-05-03', 27, 'Av Bolivar 3-21 Zona 3 Ciudad de Guatemala', 'Arquitecto', 'Masculino');
	CALL sp_AgregarPacientes ('2865452312549', 'Perez Aguirre', 'Maria Jose', '2001-03-05', 18, 'Villa Nueva Zona 5 Ciudad de Guatemala', 'Estudiante', 'Femenino');
    
    SELECT * FROM Pacientes;
    
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarcontactoUrgencia (p_codigoContactoUrgencia int, p_nombres varchar(100), p_apellidos varchar(100), p_numeroContacto varchar(10), p_codigoPaciente int)
	BEGIN 
		INSERT INTO contactoUrgencia (codigoContactoUrgencia, nombres, apellidos, numeroContacto, codigoPaciente) values (p_codigoContactoUrgencia, p_nombres, p_apellidos, p_numeroContacto, p_codigoPaciente);

END $$

	CALL sp_AgregarcontactoUrgencia (1, 'Carolina Fernanda', 'Ortega Ramirez', '44256502', 1);
    CALL sp_AgregarcontactoUrgencia (2, 'Armando Francisco', 'Perez Monterroso', '50913526', 2);
    
    SELECT * FROM contactoUrgencia;
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarMedico_Especialidad (p_codigoMedicoEspecialidad int, p_codigoEspecialidad int, p_codigoHorario int, p_codigoMedico int)
    BEGIN
		INSERT INTO Medico_Especialidad (codigoMedicoEspecialidad, codigoEspecialidad, codigoHorario, codigoMedico) values (p_codigoMedicoEspecialidad, p_codigoEspecialidad, p_codigoHorario, p_codigoMedico);

END $$

	CALL sp_AgregarMedico_Especialidad (1,1,1,44596);
    CALL sp_AgregarMedico_Especialidad (2,2,2,44685);
    
    SELECT * FROM Medico_Especialidad;
    
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarAreas (p_codigoArea int, p_nombreArea varchar(45))
    BEGIN
		INSERT INTO Areas (codigoArea, nombreArea) values (p_codigoArea, p_nombreArea);
        
END $$

	CALL sp_AgregarAreas (1, 'Externa');
    CALL sp_AgregarAreas (2, 'Interna');
    
    SELECT * FROM Areas;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarCargos (p_codigoCargo int, p_nombreCargo varchar(45))
    BEGIN
		INSERT INTO Cargos (codigoCargo, nombreCargo) values (p_codigoCargo, p_nombreCargo);
        
END $$

	CALL sp_AgregarCargos (1, 'Supervisor');
    CALL sp_AgregarCargos (2, 'Jefe');
    
    SELECT * FROM Cargos;
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarResponsableTurno (p_codigoResponsableTurno int, p_nombreResponsable varchar(75), p_apellidosResponsable varchar(45), p_telefonoPersonal varchar(10), p_codigoArea int, p_codigoCargo int)
    BEGIN
		INSERT INTO ResponsableTurno (codigoResponsableTurno, nombreResponsable, apellidosResponsable, telefonoPersonal, codigoArea, codigoCargo) values (p_codigoResponsableTurno, p_nombreResponsable, p_apellidosResponsable, p_telefonoPersonal, p_codigoArea, p_codigoCargo);
	
END $$

	CALL sp_AgregarResponsableTurno (1,'Juan', 'Ramirez Vasquez', '45856595', 1, 2);
	CALL sp_AgregarResponsableTurno (2,'Fernanda', 'Juarez Reyes', '450652345', 2, 1);
    
    SELECT * FROM ResponsableTurno;
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarTurno (p_codigoTurno int, p_fechaTurno date, p_fechaCita date, p_valorCita decimal(10,2), p_codigoResponsableTurno int, p_codigoPaciente int, p_codigoMedicoEspecialidad int)
    BEGIN
		INSERT INTO Turno (codigoTurno, fechaTurno, fechaCita , valorCita, codigoResponsableTurno, codigoPaciente, codigoMedicoEspecialidad) values (p_codigoTurno, p_fechaTurno, p_fechaCita, p_valorCita,  p_codigoResponsableTurno, p_codigoPaciente, p_codigoMedicoEspecialidad);

END $$

	CALL sp_AgregarTurno (1,'2019-06-20','2019-07-17',325.20,1,1,1);
    CALL sp_AgregarTurno (2,'2019-04-17','2019-04-17',150.30,2,2,2);
    
    SELECT * FROM Turno;
    drop procedure sp_AgregarTurno
    
-- ------------------------ MODIFICAR -----------------------------
DELIMITER $$
	CREATE PROCEDURE sp_ModificarMedicos (p_codigoMedico int, p_licenciaMedica int(10), p_nombres varchar(100), p_apellidos varchar(100), p_horaEntrada datetime, p_horaSalida datetime, p_sexo varchar(45))
    BEGIN
	UPDATE Medicos
    SET licenciaMedica = p_licenciaMedica,
    nombres = p_nombres,
    apellidos = p_apellidos,
    horaEntrada = p_horaEntrada,
    horaSalida = p_horaSalida,
    sexo = p_sexo
    WHERE codigoMedico = p_codigoMedico;
    
END $$

	CALL sp_ModificarMedicos (1,445865, 'Fernando', 'Rosales', '2019-05-09 07:00:00', '2019-05-09 16:00:00', 'Masculino');
    
    select * from Medicos;
    
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificartelefonosMedico (p_codigoTelefonoMedico int, p_telefonoPersonal varchar(15), p_telefonoTrabajo varchar(15), p_codigoMedico int)
    BEGIN
	UPDATE telefonosMedico
    SET telefonoPersonal = p_telefonoPersonal,
    telefonoTrabajo = p_telefonoTrabajo,
    codigoMedico = p_codigoMedico
    WHERE codigoTelefonoMedico = p_codigoTelefonoMedico;
    
END $$

	CALL sp_ModificartelefonosMedico (1,'44253502', '25365520', 3,4);
    
    select * from telefonosMedico;

DELIMITER $$
	CREATE PROCEDURE sp_ModificarHorarios (p_codigoHorario int, p_horarioInicio datetime, p_horarioSalida datetime, p_lunes tinyint, p_martes tinyint, p_miercoles tinyint, p_jueves tinyint, p_viernes tinyint)
    BEGIN
	UPDATE Horarios
    SET horarioInicio = p_horarioInicio,
    horarioSalida = p_horarioSalida,
    lunes = p_lunes,
    martes = p_martes,
    miercoles = p_miercoles,
    jueves = p_jueves,
    viernes = p_viernes
    WHERE codigoHorario = p_codigoHorario;
    
END $$

	CALL sp_ModificarHorarios (2,'2019-06-03 05:00:00','2019-06-03 15:00:00',4,3,2,5,1);
    
    select * from Horarios;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarEspecialidades (p_codigoEspecialidad int, p_nombreEspecialidad varchar(45))
    BEGIN
	UPDATE Especialidades
    SET nombreEspecialidad = p_nombreEspecialidad
    WHERE codigoEspecialidad = p_codigoEspecialidad;
    
END $$

	CALL sp_ModificarEspecialidades (1,'Cirujano');
    
    select * from Especialidades;

DELIMITER $$
	CREATE PROCEDURE sp_ModificarPacientes (p_codigoPaciente int, p_DPI varchar(20), p_apellidos varchar(100), p_nombres varchar(100), p_fechaNacimiento date, p_edad int, p_direccion varchar(150), p_ocupacion varchar(50), p_sexo varchar(15))
    BEGIN
	UPDATE Pacientes
    SET DPI = p_DPI,
    apellidos = p_apellidos,
    nombres = p_nombres,
    fechaNacimiento = p_fechaNacimiento,
    edad = p_edad,
    direccion = p_direccion,
    ocupacion = p_ocupacion,
    sexo = p_sexo
    WHERE codigoPaciente = p_codigoPaciente;
    
END $$

	CALL sp_ModificarPacientes (2,'4586521254236','Gomez De Leon', 'Gloria Esperanza', '1992-01-08', 27, 'Barrio El Gallito Zona 3 Ciudad de Guatemala','Odontologa','Femenino');
    
    select * from Pacientes;

DELIMITER $$
	CREATE PROCEDURE sp_ModificarcontactoUrgencia (p_codigoContactoUrgencia int, p_nombres varchar(100), p_apellidos varchar(100), p_numeroContacto varchar(10), p_codigoPaciente int)
    BEGIN
	UPDATE contactoUrgencia
    SET nombres = p_nombres,
    apellidos = p_apellidos,
    numeroContacto = p_numeroContacto,
    codigoPaciente = p_codigoPaciente
    WHERE codigoContactoUrgencia = p_codigoContactoUrgencia;
    
END $$

	CALL sp_ModificarcontactoUrgencia (1,'German Alejandro','Flores Reyes','44356525',2);
    
    select * from contactoUrgencia;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarMedico_Especialidad (p_codigoMedicoEspecialidad int, p_codigoMedico int, p_codigoEspecialidad int, p_codigoHorario int)
    BEGIN
	UPDATE Medico_Especialidad
    SET codigoMedico = p_codigoMedico,
    codigoEspecialidad = p_codigoEspecialidad,
    codigoHorario = p_codigoHorario
    WHERE codigoMedicoEspecialidad = p_codigoMedicoEspecialidad;
    
END $$

	CALL sp_ModificarMedico_Especialidad (2,445745,2,1,1,2,1);
    
    select * from Medico_Especialidad;

DELIMITER $$
	CREATE PROCEDURE sp_ModificarAreas (p_codigoArea int, p_nombreArea varchar(45))
    BEGIN
	UPDATE Areas
    SET nombreArea = p_nombreArea
    WHERE codigoArea = p_codigoArea;
    
END $$

	CALL sp_ModificarAreas (1,'Auxiliar');
    
    select * from Areas;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarCargos (p_codigoCargo int, p_nombreCargo varchar(45))
    BEGIN
	UPDATE Cargos
    SET nombreCargo = p_nombreCargo
    WHERE codigoCargo = p_codigoCargo;
    
END $$

	CALL sp_ModificarCargos (1,'Supervisor');
    
    select * from Cargos;

DELIMITER $$
	CREATE PROCEDURE sp_ModificarResponsableTurno (p_codigoResponsableTurno int, p_nombreResponsable varchar(75), p_apellidosResponsable varchar(45), p_telefonoPersonal varchar(10), p_codigoArea int, p_codigoCargo int, p_Areas_codigoArea int, p_Cargos_codigoCargo int)
    BEGIN
	UPDATE ResponsableTurno
    SET nombreResponsable = p_nombreResponsable,
    apellidosResponsable = p_apellidosResponsable,
    telefonoPersonal = p_telefonoPersonal,
    codigoArea = p_codigoArea,
    codigoCargo = p_codigoCargo,
    Areas_codigoArea = p_Areas_codigoArea,
    Cargos_codigoCargo = p_Cargos_codigoCargo
    WHERE codigoResponsableTurno = p_codigoResponsableTurno;
    
END $$

	CALL sp_ModificarResponsableTurno (2,'Rudy','Mendoza Carrillo','45856956',1,2,2,1);
    
    select * from ResponsableTurno;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarTurno (p_codigoTurno int, p_fechaTurno date, p_fechaCita date, p_valorCita decimal(10,2), p_codigoMedicoEspecialidad int, p_codigoTurnoResponsable int, p_codigoPaciente int)
    BEGIN
	UPDATE Turno
    SET fechaTurno = p_fechaTurno,
    fechaCita = p_fechaCita,
    valorCita = p_valorCita,
    codigoMedicoEspecialidad = p_codigoMedicoEspecialidad,
    codigoResponsableTurno = p_codigoResponsableTurno,
    codigoPaciente = p_codigoPaciente
    WHERE codigoTurno = p_codigoTurno;
    
END $$

	CALL sp_ModificarTurno (1,'2019-08-03','2019-09-04',290.00,2,1,2,2,1,2);
    
    select * from Turno;

    
-- ----------------------------- LISTAR ---------------------------------
DELIMITER $$
	CREATE PROCEDURE sp_ListarMedicos()
	BEGIN
	SELECT codigoMedico, licenciaMedica, nombres, apellidos, horaEntrada, horaSalida, sexo from Medicos;

END $$

	SELECT * FROM Medicos;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListartelefonosMedico()
	BEGIN
	SELECT codigoTelefonoMedico, telefonoPersonal, telefonoTrabajo, codigoMedico from telefonosMedico;

END $$

	SELECT * FROM telefonosMedico;

DELIMITER $$
	CREATE PROCEDURE sp_ListarHorarios()
	BEGIN
	SELECT codigoHorario, horarioInicio, horarioSalida, lunes, martes, miercoles, jueves, viernes from Horarios;

END $$

	SELECT * FROM Horarios;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListarEspecialidades()
	BEGIN
	SELECT codigoEspecialidad, nombreEspecialidad from Especialidades;

END $$

	SELECT * FROM Especialidades;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListarPacientes()
	BEGIN
	SELECT codigoPaciente, DPI, apellidos, nombres, fechaNacimiento, edad, direccion, ocupacion, sexo from Pacientes;

END $$

	SELECT * FROM Pacientes;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListarcontactoUrgencia()
	BEGIN
	SELECT codigoContactoUrgencia, nombres, apellidos, numeroContacto, codigoPaciente from contactoUrgencia;

END $$

	SELECT * FROM contactoUrgencia;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListarMedico_Especialidad()
	BEGIN
	SELECT codigoMedicoEspecialidad, codigoMedico, codigoEspecialidad, codigoHorario, Especialidades_codigoEspecialidad, Horarios_codigoHorario, Medicos_codigoMedico from Medico_Especialidad;

END $$

	SELECT * FROM Medico_Especialidad;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListarAreas()
	BEGIN
	SELECT codigoArea, nombreArea from Areas;

END $$

	SELECT * FROM Areas;

DELIMITER $$
	CREATE PROCEDURE sp_ListarCargos()
	BEGIN
	SELECT codigoCargo, nombreCargo from Cargos;

END $$

	SELECT * FROM Cargos;
    
DELIMITER $$
	CREATE PROCEDURE sp_ListarResponsableTurno()
	BEGIN
	SELECT codigoResponsableTurno, nombreResponsable, apellidosResponsable, telefonoPersonal, codigoArea, codigoCargo, Areas_codigoArea, Cargos_codigoCargos from ResponsableTurno;

END $$

	SELECT * FROM ResponsableTurno;

DELIMITER $$
	CREATE PROCEDURE sp_ListarTurno()
	BEGIN
	SELECT codigoTurno, fechaTurno, fechaCita, valorCita, codigoMedicoEspecialidad, codigoResponsableTurno, codigoPaciente from Turno;

END $$

	SELECT * FROM Turno;
    
-- -------------------------- BUSCAR ---------------------------------
DELIMITER $$
CREATE PROCEDURE sp_Buscar_Medicos (p_codigoMedico int)
BEGIN
	SELECT * FROM Medicos WHERE codigoMedico = p_codigoMedico;
    
END $$

select * from Medicos;
CALL sp_Buscar_Medicos(1); 
CALL sp_Buscar_Medicos(2); 

DELIMITER $$
CREATE PROCEDURE sp_Buscar_telefonosMedico (p_codigoTelefonoMedico int)
BEGIN
	SELECT * FROM telefonosMedico WHERE codigoTelefonoMedico = p_codigoTelefonoMedico;
    
END $$

select * from telefonosMedico;
CALL sp_Buscar_telefonosMedico(2);   

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Horarios (p_codigoHorario int)
BEGIN
	SELECT * FROM Horarios WHERE codigoHorario = p_codigoHorario;
    
END $$

select * from Horarios;
CALL sp_Buscar_Horarios(1);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Especialidades (p_codigoEspecialidad int)
BEGIN
	SELECT * FROM Especialidades WHERE codigoEspecialidad = p_codigoEspecialidad;
    
END $$

select * from Especialidades;
CALL sp_Buscar_Especialidades(2);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Pacientes (p_codigoPaciente int)
BEGIN
	SELECT * FROM Pacientes WHERE codigoPaciente = p_codigoPaciente;
    
END $$

select * from Pacientes;
CALL sp_Buscar_Pacientes(1);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_contactoUrgencia (p_codigoContactoUrgencia int)
BEGIN
	SELECT * FROM contactoUrgencia WHERE codigoContactoUrgencia = p_codigoContactoUrgencia;
    
END $$

select * from contactoUrgencia;
CALL sp_Buscar_contactoUrgencia(2);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Medico_Especialidad (p_codigoMedicoEspecialidad int)
BEGIN
	SELECT * FROM Medico_Especialidad WHERE codigoMedicoEspecialidad = p_codigoMedicoEspecialidad;
    
END $$

select * from Medico_Especialidad;
CALL sp_Buscar_Medico_Especialidad(1);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Areas (p_codigoArea int)
BEGIN
	SELECT * FROM Areas WHERE codigoArea = p_codigoArea;
    
END $$

select * from Areas;
CALL sp_Buscar_Areas(2);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Cargos (p_codigoCargo int)
BEGIN
	SELECT * FROM Cargos WHERE codigoCargo = p_codigoCargo;
    
END $$

select * from Cargos;
CALL sp_Buscar_Cargos(1);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_ResponsableTurno (p_codigoResponsableTurno int)
BEGIN
	SELECT * FROM ResponsableTurno WHERE codigoResponsableTurno = p_codigoResponsableTurno;
    
END $$

select * from ResponsableTurno;
CALL sp_Buscar_ResponsableTurno(2);

DELIMITER $$
CREATE PROCEDURE sp_Buscar_Turno (p_codigoTurno int)
BEGIN
	SELECT * FROM Turno WHERE codigoTurno = p_codigoTurno;
    
END $$

select * from Turno;
CALL sp_Buscar_Turno(1);

-- -------------------------- ELIMINAR ----------------------------------
DELIMITER $$
	CREATE PROCEDURE sp_EliminarMedicos( p_codigoMedico int)
    BEGIN
		DELETE FROM Medicos
		WHERE codigoMedico = p_codigoMedico ;
END $$
	
		CALL sp_EliminarMedicos(2);
        
	SELECT * FROM Medicos;

DELIMITER $$
	CREATE PROCEDURE sp_EliminartelefonosMedico( p_codigoTelefonoMedico int)
    BEGIN
		DELETE FROM telefonosMedico
		WHERE codigoTelefonoMedico = p_codigoTelefonoMedico ;
END $$
	
		CALL sp_EliminartelefonosMedico(1);
        
	SELECT * FROM telefonoMedico;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarHorarios( p_codigoHorario int)
    BEGIN
		DELETE FROM Horarios
		WHERE codigoHorario = p_codigoHorario ;
END $$
	
		CALL sp_EliminarHorarios(2);
        
	SELECT * FROM Horarios;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarEspecialidades( p_codigoEspecialidad int)
    BEGIN
		DELETE FROM Especialidades
		WHERE codigoEspecialidad = p_codigoEspecialidad ;
END $$
	
		CALL sp_EliminarEspecialidades(1);
        
	SELECT * FROM Especialidades;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarPacientes( p_codigoPaciente int)
    BEGIN
		DELETE FROM Pacientes
		WHERE codigoPaciente = p_codigoPaciente ;
END $$
	
		CALL sp_EliminarPacientes(2);
        
	SELECT * FROM Pacientes;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarcontactoUrgencia( p_codigoContactoUrgencia int)
    BEGIN
		DELETE FROM contactoUrgencia
		WHERE codigoContactoUrgencia = p_codigoContactoUrgencia ;
END $$
	
		CALL sp_EliminarcontactoUrgencia(1);
        
	SELECT * FROM contactoUrgencia;

DELIMITER $$
	CREATE PROCEDURE sp_EliminarMedico_Especialidad( p_codigoMedicoEspecialidad int)
    BEGIN
		DELETE FROM Medico_Especialidad
		WHERE codigoMedicoEspecialidad = p_codigoMedicoEspecialidad ;
END $$
	
		CALL sp_EliminarMedico_Especialidad(2);
        
	SELECT * FROM Medico_Especialidad;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarAreas( p_codigoArea int)
    BEGIN
		DELETE FROM Areas
		WHERE codigoArea = p_codigoArea ;
END $$
	
		CALL sp_EliminarAreas(1);
        
	SELECT * FROM Areas;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarCargos( p_codigoCargo int)
    BEGIN
		DELETE FROM Cargos
		WHERE codigoCargo = p_codigoCargo ;
END $$
	
		CALL sp_EliminarCargos(2);
        
	SELECT * FROM Cargos;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarResponsableTurno( p_codigoResponsableTurno int)
    BEGIN
		DELETE FROM ResponsableTurno
		WHERE codigoResponsableTurno = p_codigoResponsableTurno ;
END $$
	
		CALL sp_EliminarResponsableTurno(1);
        
	SELECT * FROM ResponsableTurno;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarTurno( p_codigoTurno int)
    BEGIN
		DELETE FROM Turno
		WHERE codigoTurno = p_codigoTurno ;
END $$
	
		CALL sp_EliminarTurno(2);
        
	SELECT * FROM Turno;


ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin';



-- ----------------------------------------------------------------------------------
-- --------------------------------E X A M E N --------------------------------------
-- ----------------------------------------------------------------------------------
create table ControlCitas(
codigoControlCita int not null primary key auto_increment,
fecha date not null,
horaInicio varchar(45) not null,
horaFin varchar(45) not null,
codigoMedico int not null,
codigoPaciente int not null,
foreign key(codigoMedico) references Medicos (codigoMedico) on delete cascade,
foreign key(codigoPaciente) references Pacientes(codigoPaciente)on delete cascade
);

create table Recetas(
codigoReceta int not null primary key auto_increment,
descripcionReceta varchar(45) not null,
codigoControlCita int,
foreign key(codigoControlCita) references ControlCitas(codigoControlCita)on delete cascade
);

-- AGREGAR--------------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
	CREATE PROCEDURE sp_AgregarControlCitas (p_fecha date, p_horaInicio varchar(45), p_horaFin varchar(45), p_codigoMedico int, p_codigoPaciente int)
    BEGIN
		INSERT INTO ControlCitas (fecha, horaInicio, horaFin, codigoMedico, codigoPaciente) values (p_fecha, p_horaInicio, p_horaFin, p_codigoMedico, p_codigoPaciente);
        
END $$
	
    CALL sp_AgregarControlCitas ('2019-07-25', '07:00:00', '11:00:00', 1,1);
    CALL sp_AgregarControlCitas ('2019-09-02', '12:00:00', '16:30:00', 2,2);
    
    SELECT * FROM ControlCitas;
    
    
DELIMITER $$
	CREATE PROCEDURE sp_AgregarRecetas (p_descripcionReceta varchar(45), p_codigoControlCita int)
    BEGIN
		INSERT INTO Recetas (descripcionReceta, codigoControlCita) values (p_descripcionReceta, p_codigoControlCita);
END $$

	CALL sp_AgregarRecetas ('Paracetamol cada 8 horas por 8 dias',1);
    CALL sp_AgregarRecetas ('Lansoprazol cada 12 horas por 8 dias',2);
    
    SELECT * FROM Recetas;
    
-- MOSTRAR ----------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
	CREATE PROCEDURE sp_MostrarControlCitas()
	BEGIN
	SELECT codigoControlCita, fecha, horaInicio, horaFin, codigoMedico, codigoPaciente from ControlCitas;

END $$

	SELECT * FROM ControlCitas;
    

DELIMITER $$
	CREATE PROCEDURE sp_MostrarRecetas()
	BEGIN
	SELECT codigoReceta, descripcionReceta, codigoControlCita from Recetas;

END $$

	SELECT * FROM Recetas;

-- MODIFICAR -------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
	CREATE PROCEDURE sp_ModificarControlCitas (p_codigoControlCita int, p_fecha date, p_horaInicio varchar(45), p_horaFin varchar(45), p_codigoMedico int, p_codigoPaciente int)
    BEGIN
	UPDATE ControlCitas
    SET fecha = p_fecha,
    horaInicio = p_horaInicio,
    horaFin = p_horaFin,
    codigoMedico = p_codigoMedico,
    codigoPaciente = p_codigoPaciente
    WHERE codigoControlCita = p_codigoControlCita;
    
END $$

	CALL sp_ModificarControlCitas (1,'2019-08-26', '08:00:00', '12:00:00', 2,1)
    
	SELECT * FROM ControlCitas;
    
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarRecetas (p_codigoReceta int, p_descripcionReceta varchar(45), p_codigoControlCita int)
    BEGIN
	UPDATE Recetas
    SET descripcionReceta = p_descripcionReceta,
    codigoControlCita = p_codigoControlCita
    WHERE codigoReceta = p_codigoReceta;
    
END $$

	CALL sp_ModificarRecetas (2,'Tetraciclina cada 8 horas durante 5 dias',2)
    
    SELECT * FROM Recetas;
    
-- BUSCAR -----------------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE sp_Buscar_ControlCitas (p_codigoControlCita int)
BEGIN
	SELECT * FROM ControlCitas WHERE codigoControlCita = p_codigoControlCita;
    
END $$

SELECT * FROM ControlCitas;
CALL sp_Buscar_ControlCitas(1);


DELIMITER $$
CREATE PROCEDURE sp_Buscar_Recetas (p_codigoReceta int)
BEGIN
	SELECT * FROM Recetas WHERE codigoReceta = p_codigoReceta;
    
END $$

SELECT * FROM Recetas;
CALL sp_Buscar_Recetas(2);
    
-- ELIMINAR -------------------------------------------------------------------------------------------------------------------------------------

DELIMITER $$
	CREATE PROCEDURE sp_EliminarControlCitas( p_codigoControlCita int)
    BEGIN
		DELETE FROM ControlCitas
		WHERE codigoControlCita = p_codigoControlCita ;
END $$
	
		CALL sp_EliminarControlCitas(1);
        
	SELECT * FROM ControlCitas;
    
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarRecetas( p_codigoReceta int)
    BEGIN
		DELETE FROM Recetas
		WHERE codigoReceta = p_codigoReceta;
END $$
	
		CALL sp_EliminarRecetas(2);
        
	SELECT * FROM Recetas;