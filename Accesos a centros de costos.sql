USE master;
-- Dim Usuarios
CREATE TABLE Usuarios (
    rowid_usuario INT PRIMARY KEY IDENTITY,
    nombre_apellido NVARCHAR(100),
    email NVARCHAR(100) UNIQUE,
	cedula NVARCHAR(100) UNIQUE
);

-- DIM_Roles
CREATE TABLE Roles (
    rowid_Rol INT PRIMARY KEY IDENTITY,
    nombre NVARCHAR(100)
);
-- Fact Usuario Rol
CREATE TABLE UsuarioRoles (
    rowid_usuario INT,
    rowid_rol INT,
    FOREIGN KEY (rowid_usuario) REFERENCES Usuarios(rowid_usuario),
    FOREIGN KEY (rowid_rol) REFERENCES Roles(rowid_rol)
);

-- Dim Permisos
CREATE TABLE Permisos (
    rowid_permiso INT PRIMARY KEY IDENTITY,
    rowid_nombre NVARCHAR(100) -- Ejemplo: 'lectura', 'escritura', 'eliminación'
);
CREATE TABLE RolTablaPermisos (
    rowid_rol INT,
    Tabla VARCHAR(100),  -- Ejemplo: 'Clientes', 'Ventas'
    AccesoTabla BIT,     -- 1 = acceso a la tabla, 0 = no acceso
    AccesoRegistros VARCHAR(1000),  -- Condición SQL para registros (por ejemplo, "id_cliente = 1")
    FOREIGN KEY (rowid_rol) REFERENCES Roles(rowid_rol)
);

--Centros de costos
CREATE TABLE CentrosDeCosto (
    id_centro_costo INT PRIMARY KEY IDENTITY,
    nombre_centro_costo VARCHAR(100),
    descripcion_centro_costo VARCHAR(255)
);

--Tabla empleados
CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY IDENTITY,
    nombre_empleado VARCHAR(100),
    cargo VARCHAR(100),
    salario DECIMAL(10,2),
    fecha_ingreso DATE,
    id_centro_costo INT,  -- Nuevo campo para el centro de costo
    FOREIGN KEY (id_centro_costo) REFERENCES CentrosDeCosto(id_centro_costo)  -- Relación con la tabla CentrosDeCosto
);

-- Tabla de Tablas
CREATE TABLE Tablas (
    rowid_tabla INT PRIMARY KEY IDENTITY,
    nombre NVARCHAR(100)
);

-- Relación de Permisos por Rol en las tablas
CREATE TABLE PermisosUsuarioRol (
    rowid_usuario INT NULL,
    rowid_rol INT NULL,
    rowid_tabla INT,
    rowid_permiso INT,
    FOREIGN KEY (rowid_usuario) REFERENCES Usuarios(rowid_usuario),
    FOREIGN KEY (rowid_rol) REFERENCES Roles(rowid_rol),
    FOREIGN KEY (rowid_tabla) REFERENCES Tablas(rowid_tabla),
    FOREIGN KEY (rowid_permiso) REFERENCES Permisos(rowid_permiso)
);


--Reiniciamos para que arranque desde la llave
DBCC CHECKIDENT ('Usuarios', RESEED, 1);


--Ingresamos los usuarios
INSERT INTO Usuarios(nombre_apellido, email,cedula)
VALUES
	('David Barreiro','davidbc834@gmail.com','1143412043'),
	('Diana Peñarete','dianapeñarate@gmail.com','1143412044'),
	('Simon Herrera','simon@gmail.com','1143412045'),
	('Federico Monsalve','federico@gmail.com','1143412046'),
	('Jesus Martinez','jesus@gmail.com','1143412047');

	--Validacion de la tabla Usuarios
SELECT * FROM Usuarios;

--Reiniciamos para que arranque desde la llave
DBCC CHECKIDENT ('Permisos', RESEED, 1);
--Ingresamos valores a la tabla de Permisos
INSERT INTO Permisos(rowid_nombre)
VALUES
	('Permiso'),
	('No permiso');
--Validacion de la tabla Permisos
SELECT * FROM Permisos;



-- Insertar permisos para el rol 'Jefe de nomina'
INSERT INTO RolTablaPermisos (rowid_rol, Tabla, AccesoTabla, AccesoRegistros)
VALUES
    (1, 'Empleados', 1, NULL),  -- El Jefe de Nomina tiene acceso completo a la tabla 'Empleados'
    (1, 'CentrosDeCosto', 1, NULL), -- El Jefe de Nomina tiene acceso completo a la tabla 'CentrosDeCosto'
    (2, 'Empleados', 1, NULL),  --El Auxiliar de Nomina tiene acceso completo a la tabla 'Empleados'
    (2, 'CentrosDeCosto', 1 ,'id_centro_costo = 3');  -- El Auxiliar de Nomina solo puede ver registros del centro de costo 3


--Reiniciamos para que arranque desde la llave
DBCC CHECKIDENT ('Roles', RESEED, 1);
--Ingresamos valores a la tabla Roles
INSERT INTO Roles(nombre)
VALUES
	('Jefe de nomina'),
	('Auxiliar de nomina'),
	('Trabajador');
--Validacion de la tabla Permisos
SELECT * FROM Roles;

--Reiniciamos para que arranque desde la llave
DBCC CHECKIDENT ('UsuarioRoles', RESEED, 1);
--Ingresamos valores a la tabla Roles
INSERT INTO UsuarioRoles (rowid_usuario, rowid_rol) 
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 3),
(5, 5);

SELECT * FROM UsuarioRoles;

--Reiniciamos para que arranque desde la llave
DBCC CHECKIDENT ('CentrosDeCosto', RESEED, 1);
--Ingresamos valores a la tabla Centro de costos
INSERT INTO CentrosDeCosto (nombre_centro_costo, descripcion_centro_costo)
VALUES 
('Contabilidad', 'Centro de costos relacionado con la contabilidad'),
('Gerencia', 'todas las diferentes gerencias'),
('Talento Humano', 'Area de TH'),
('Compras', 'Area de compras');

--Ingresamos valores a la tabla empleados
DBCC CHECKIDENT ('Empleados', RESEED, 1);
INSERT INTO Empleados (nombre_empleado, cargo, salario, fecha_ingreso, id_centro_costo)
VALUES 
('David Barreiro', 'Desarrollador BI', 6000000, '2023-01-15', 2),
('Diana Peñarete', 'Desarrollador BI', 6000000, '2020-01-15', 2),
('Simon Herrera', 'Jefe de nomina', 9000000, '2024-01-15', 3),
('Federico Monsalve', 'Auxiliar de nomina', 3000000, '2015-01-15', 3),
('Jorge Hidalgo', 'Gerente general', 3000000, '2015-01-15', 2),
('Ana Monsalve', 'Comprador', 3000000, '2015-01-30', 4),
('Jesus Martinez', 'Comprador', 3000000, '2010-01-15', 4),
('Ana Martinez', 'Jefe de contabilidad', 6000000, '2015-01-15', 1);

SELECT * FROM Empleados
--Eliminamos funciones almacenadas--
--DROP FUNCTION dbo.fn_VerificarAccesoTabla;
--DROP FUNCTION dbo.fn_VerificarAccesoRegistros;
--DROP PROCEDURE dbo.sp_ValidarAccesoCentroCosto
--DROP FUNCTION dbo.fn_VerificarAccesoTabla;
DROP FUNCTION dbo.fn_VerificarAccesoRegistros;


--Validamos que las funciones almacenadas no se encuentren--
SELECT name, type_desc
FROM sys.objects
WHERE name IN ('fn_VerificarAccesoTabla', 'fn_VerificarAccesoRegistros');



-- Función para verificar el acceso a una tabla
CREATE FUNCTION dbo.fn_VerificarAccesoTabla (
    @UsuarioID INT,
    @Tabla NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @AccesoTabla BIT;

    SELECT @AccesoTabla = AccesoTabla
    FROM RolTablaPermisos rtp
    JOIN UsuarioRoles ur ON ur.rowid_rol = rtp.rowid_rol
    WHERE ur.rowid_usuario = @UsuarioID
      AND rtp.Tabla = @Tabla;

    RETURN ISNULL(@AccesoTabla, 0);
END;
GO

-- Función para obtener la restricción de acceso a registros
CREATE FUNCTION dbo.fn_VerificarAccesoRegistros (
    @UsuarioID INT,
    @Tabla NVARCHAR(100)
)
RETURNS NVARCHAR(1000)
AS
BEGIN
    DECLARE @AccesoRegistros NVARCHAR(1000);

    SELECT @AccesoRegistros = AccesoRegistros
    FROM RolTablaPermisos rtp
    JOIN UsuarioRoles ur ON ur.rowid_rol = rtp.rowid_rol
    WHERE ur.rowid_usuario = @UsuarioID
      AND rtp.Tabla = @Tabla;

    RETURN ISNULL(@AccesoRegistros, '');
END;
GO

-- Procedimiento almacenado para validar acceso a centros de costo
CREATE PROCEDURE dbo.sp_ValidarAccesoCentroCosto
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RolID INT;
    
    SELECT @RolID = ur.rowid_rol
    FROM UsuarioRoles ur
    WHERE ur.rowid_usuario = @UsuarioID;

    -- Validar si el usuario tiene acceso a ciertos Centros de Costo
    SELECT cc.id_centro_costo, cc.nombre_centro_costo, cc.descripcion_centro_costo
    FROM CentrosDeCosto cc
    JOIN RolTablaPermisos rtp ON rtp.Tabla = 'CentrosDeCosto' 
                             AND rtp.rowid_rol = @RolID
    WHERE rtp.AccesoTabla = 1
      AND (rtp.AccesoRegistros IS NULL OR 
           cc.id_centro_costo IN (SELECT value FROM STRING_SPLIT(rtp.AccesoRegistros, ',')));
END;
GO

--Comprobamos el acceso--
EXEC dbo.sp_ValidarAccesoCentroCosto @UsuarioID = 4;
SELECT * FROM Usuarios
WHERE Usuarios.rowid_usuario = 4

	--DROP TABLE PermisosUsuarioRol;
	--DROP TABLE Tablas;
	---DROP TABLE Empleados;
	--DROP TABLE CentrosDeCosto;
	--DROP TABLE RolTablaPermisos;
	---DROP TABLE Permisos;
	--DROP TABLE UsuarioRoles;
	---DROP TABLE Roles;
	 ---DROP TABLE Usuarios;
	 