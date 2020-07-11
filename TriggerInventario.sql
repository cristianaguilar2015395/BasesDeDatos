create database Inventario;
use Inventario;

create table Proveedor(
	idProveedor int(10)not null primary key auto_increment,
	nombre varchar(45)not null, 
    nit INT(15)not null,
	constraint cu_tipoproveedor_nit unique(nit),
    numeroTelefono int(10)not null,
    direccion varchar(30)not null,
    numeroFax int(10)not null,
    correo varchar(25)not null default '',
    departamento varchar(20)not null,
    municipio varchar(20)not null,
    zona varchar(10)not null
    );
    
create table Clientes(
	idCliente int(10)not null primary key auto_increment,
	nombre varchar(45)not null, 
	nit INT(15),
	numeroTelefono int(10)not null,
	direccion varchar(30)not null,
	numeroFax int(10)not null,
	correo varchar(25)not null default '',
	departamento varchar(20)not null,
	municipio varchar(20)not null,
	zona varchar(10)not null,
    limiteCredito real unsigned
    );
    
create table UnidadMedida(
	idUnidadMedida int(10)not null primary key auto_increment,
	descripcion varchar(45)not null,
    constraint cu_unidadMedida_descripcion unique(descripcion)
    );
    
create table Familia(
	idFamilia int(10)not null primary key auto_increment,
	descripcion varchar(45)not null,
    constraint cu_unidadMedida_descripcion unique(descripcion)
    );
    
create table SubFamilia(
	idSubfamilia int(10)not null primary key auto_increment,
	descripcion varchar(45)not null,
    constraint cu_unidadMedida_descripcion unique(descripcion)
    );

create table Producto(
	idProducto int not null primary key auto_increment,
	nombre varchar(45)not null,
    descripcion varchar(45)not null,
    idUnidadMedida int(10)not null,
    idFamilia int(10)not null,
    idSubfamilia int(10)not null,
    fechaProduccion date not null,
    peso int(100),
    fechaVencimiento date not null,
    foreign key(idUnidadMedida) references UnidadMedida(idUnidadMedida),
    foreign key(idFamilia)references Familia(idFamilia),
    foreign key(idSubfamilia)references subFamilia(idSubfamilia)
    );
    
create 	table Sucursal(
	idSucursal int(10)not null primary key auto_increment,	
	nombreSucursal varchar(45)not null,
    direccion varchar(30)not null,
    numeroSucursal int(10)not null,
    gerente varchar(45)not null
    );
    
create table StockSucursal(
	idSucursal int(10) not null,
    idProducto int(10) not null,  
    cantidad int(20)not null,
    costoUnitario decimal ,#(10,6),
    precioVenta real unsigned,
    primary key(idSucursal,idProducto),
    foreign key(idSucursal)references Sucursal(idSucursal),
    foreign key(idProducto)references Producto(idProducto)
    );
    
create table Mercaderia(
	numeroDocumento int(10)not null primary key auto_increment,
	idSucursal int(10)not null,
    fechaDocumento date not null,
    idProveedor int(10)not null,
	constraint cu_Mercaderia_numerodeDocumento unique(numeroDocumento),
    foreign key(idSucursal)references Sucursal(idSucursal),
    foreign key(idProveedor)references Proveedor(idProveedor)
    );

    
create table MercaderiaProducto(
	numeroDocumento int not null,
    idProducto int not null ,
    cantidad int not null,
    idUnidadMedida int not null,
	valorIVA int not null,
    valorUnitarioSIva int not null,
    primary key (numeroDocumento,idProducto),
	foreign key(idUnidadMedida)references UnidadMedida(idUnidadMedida),
    foreign key(numeroDocumento)references Mercaderia(numeroDocumento),
    foreign key(idProducto)references Producto(idProducto)
    );
    
create table Facturacion(
	numeroDocumento int not null primary key auto_increment,
    idSucursal int not null,
    fechaDocumento date not null,
    fechaEntrega date not null,
    idCliente int not null,
    foreign key(idSucursal)references Sucursal(idSucursal),
    foreign key(idCliente)references Clientes(idCliente)
    );
    
-- DETALLE---
create table FacturacionProducto(
	numeroDocumento int not null,
	idProducto int not null,
	cantidad  int not null,
	idUnidadMedida int not null,
	costoUnitario decimal not null,
	precioVenta int not null,
	primary key(numeroDocumento,idProducto),
	foreign key (idUnidadMedida)references UnidadMedida(idUnidadMedida),
	foreign key (numeroDocumento)references Facturacion(numeroDocumento),
	foreign key(idProducto)references Producto(idProducto));

-- TRIGGER INSERT----
DELIMITER $$
	CREATE TRIGGER tr_ComprasProductos_Insert
	after insert 
	on FacturacionProducto
	for each row 
	Begin 
		declare V_idSucursal int;
		set V_idSucursal=(select idSucursal from Facturacion where numeroDocumento =new.numeroDocumento);
		if Exists (select idSucursal from StockSucursal where idSucursal= V_idSucursal and idProducto=new.idProducto)
		then
			update StockSucursal
			set cantidad =cantidad+new.cantidad, costoUnitario=(cantidad*costoUnitario + new.cantidad*new.costoUnitario)/(cantidad+new.cantidad)
			where  idSucursal = V_idSucursal and idProducto = new.idProducto;
		else 
			insert StockSucursal(idSucursal,idProducto,cantidad,costoUnitario) values (V_idSucursal,new.idProducto,new.cantidad,new.costoUnitario);#
	end if;
end$$

-- TRIGGER ELIMINAR---
DELIMITER $$
	CREATE TRIGGER tr_ComprasProductos_Delete
	after delete  
	on FacturacionProducto
	for each row 
	Begin
		declare V_idSucursal int;
		set V_idSucursal=(select idSucursal from Facturacion where numeroDocumento =old.numeroDocumento);
			update StockSucursal
				set cantidad =cantidad- old.cantidad, costoUnitario=(cantidad*costoUnitario + old.cantidad*old.costoUnitario)/(cantidad+old.cantidad)
				where  idSucursal = V_idSucursal and idProducto = old.idProducto;	 
	end$$
 
-- TRIGGER MODIFICAR --
DELIMITER $$
	CREATE TRIGGER tr_ComprasProductos_Update
    after update
    on FacturacionProducto
    for each row
		Begin
		declare V_idSucursal int;
		set V_idSucursal=(select idSucursal from Facturacion where numeroDocumento =old.numeroDocumento); 
				update StockSucursal-- 
				set cantidad =cantidad- old.cantidad, costoUnitario=(cantidad*costoUnitario - old.cantidad*old.costoUnitario)/(cantidad-old.cantidad)
				where  idSucursal = V_idSucursal and idProducto = old.idProducto;
					update StockSucursal
					set cantidad =cantidad+new.cantidad,
					costoUnitario=(cantidad*costoUnitario + new.cantidad*new.costoUnitario)/(cantidad+new.cantidad)
					where  idSucursal = V_idSucursal and idProducto = new.idProducto;
		end $$
	
DELIMITER $$
    CREATE PROCEDURE tr_EliminarFacturacionProducto (p_numeroDocumento int,p_idProducto int)
    BEGIN
    delete from FacturacionProducto where numeroDocumento=p_numeroDocumento and 
											idProducto=p_idProducto;
	end $$
    call tr_EliminarFacturacionProducto(1,1);
    

-- PROCESOS DE AGREGAR--
DELIMITER $$ 
	CREATE PROCEDURE sp_AgregarFacturacionProducto(p_numeroDocumento int,p_idProducto int,p_cantidad int,p_idUnidadMedida int,p_costoUnitario decimal,p_precioVenta int)
    BEGIN
    INSERT INTO FacturacionProducto (numeroDocumento,idProducto,cantidad,idUnidadMedida,costoUnitario,precioVenta) values (p_numeroDocumento,p_idProducto,p_cantidad,p_idUnidadMedida,p_costoUnitario,p_precioVenta);
	END $$
    truncate table FacturacionProducto;
    
			call sp_AgregarFacturacionProducto(1,2,300,4,100,250);
			call sp_AgregarFacturacionProducto(1,1,400,4,100,500);
		
        SELECT * FROM FacturacionProducto;
        
DELIMITER $$
	CREATE PROCEDURE sp_AgregarProveedor(p_nombre varchar(45), p_nit int (15),p_numeroTelefono int(10),p_direccion varchar(30), p_numeroFax int(10),p_correo varchar(25), p_departamento varchar(20),p_municipio varchar(20),p_zona varchar(10))
	BEGIN
	INSERT INTO Proveedor(nombre,nit,numeroTelefono,direccion,numeroFax,correo,departamento,municipio,zona) values (p_nombre,p_nit ,p_numeroTelefono,p_direccion,p_numeroFax,p_correo,p_departamento,p_municipio,p_zona);

	END $$
		
        CALL sp_AgregarProveedor('Eduardo',2453569-3,22554963,'Avenida Petapa',45856895,'edu52@gmail.com','Guatemala','Petapa','Zona 12');
		CALL sp_AgregarProveedor('Fernando',5401758-9,54023086,'Naranjo',54856958,'fer502@hotmail.com','Guatemala','Mixco','Zona 7');
        
	SELECT * FROM  Proveedor;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarClientes(p_nombre varchar(45),p_nit int(15),p_numeroTelefono int(10),p_direccion varchar(30),p_numeroFax int(10),p_correo varchar(25), p_departamento varchar(20),p_municipio varchar(20),p_zona varchar(10),p_limiteCredito real)
	BEGIN
	INSERT INTO Clientes (nombre,nit,numeroTelefono,direccion,numeroFax,correo,departamento,municipio,zona,limiteCredito) values (p_nombre,p_nit,p_numeroTelefono,p_direccion,p_numeroFax,p_correo,p_departamento,p_municipio,p_zona,p_limiteCredito);

	END $$

		CALL sp_AgregarClientes('Rodolfo',2457568-2,45857542,'Guatemala',45856895,'rodolfo54@yahoo.com','Quiché','Santa Cruz','Zona 3',3500);
		CALL sp_AgregarClientes('Francisco',4421524-5,56352514,'Villa Nueva',55485963,'francis458@gmail.com','Guatemala','Zona 6','Kilometro 175',7100);
        
	SELECT * FROM Clientes;


DELIMITER $$
	CREATE PROCEDURE sp_AgregarUnidadMedida(p_descripcion varchar(45))
	BEGIN
	INSERT INTO UnidadMedida(descripcion) values (p_descripcion);
END$$

        CALL sp_AgregarUnidadMedida('Metro');
		CALL sp_AgregarUnidadMedida('Kilo');
        CALL sp_AgregarUnidadMedida('Libra');
        CALL sp_AgregarUnidadMedida('Honza');
		CALL sp_AgregarUnidadMedida('Yarda');
        
	SELECT * FROM UnidadMedida;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarFamilia(P_descripcion varchar(45))
	BEGIN
	INSERT INTO Familia(descripcion) values (p_descripcion);
END$$

		CALL sp_AgregarFamilia('Ropa');
		CALL sp_AgregarFamilia('Accesorios');
		CALL sp_AgregarFamilia('Comida');
        
	SELECT * FROM Familia;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarSubFamilia(p_descripcion varchar(45))
	BEGIN
	INSERT INTO SubFamilia(descripcion) values (p_descripcion);
END$$

		CALL sp_AgregarSubFamilia('Pantalones');
		CALL sp_AgregarSubFamilia('Reloj');
		CALL sp_AgregarSubFamilia('Granos');
        
	SELECT * FROM SubFamilia;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarProducto(p_nombre varchar(45),p_descripcion varchar(45),p_idUnidadMedida int(10),p_idFamilia int(10),p_idSubfamilia int(10),p_fechaProduccion date,p_peso int(100),p_fechaVencimiento date)
	BEGIN
	INSERT INTO Producto (nombre,descripcion,idUnidadMedida,idFamilia,idSubfamilia,fechaProduccion,peso,fechaVencimiento) values (p_nombre,p_descripcion,p_idUnidadMedida,p_idFamilia,p_idSubfamilia,p_fechaProduccion,p_peso,p_fechaVencimiento);
END $$

	CALL sp_AgregarProducto('Tommy Hilfiger','Color Negro',4,2,2,'2018-01-28',15,'N/A');
	CALL sp_AgregarProducto('Fosil','Color Azul',4,2,2,'2017-11-16',10,'N/A');
	CALL sp_AgregarProducto('Frijol','Rojo',4,2,2,'2018-03-06',15,'2019-03-06');

	SELECT * FROM Producto;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarSucursal(p_nombreSucursal varchar(45),p_direccion varchar(30), p_numeroSucursal int(10),p_gerente varchar(45))
	BEGIN
	INSERT INTO Sucursal(nombreSucursal,direccion,numeroSucursal,gerente) values (p_nombreSucursal,p_direccion,p_numeroSucursal,p_gerente);
END $$

		CALL sp_AgregarSucursal('Tiendas Distefano','Centro Comercial Plaza Zona 4',3,'Manuel Rodriguez');
		CALL sp_AgregarSucursal('Tiendas Tic Tac','Centro Comercial Miraflores',2,'Roberto Hernandez');
		CALL sp_AgregarSucursal('Walmart','Tienda Majadas',10,'Marco Flores');

	SELECT * FROM Sucursal;


DELIMITER $$
	CREATE PROCEDURE sp_AgregarStockSucursal(p_idSucursal int(10),p_idProducto int(10),p_cantidad int(20),p_costoUnitario decimal,p_precioVenta real)
	BEGIN
	INSERT INTO StockSucursal(idSucursal,idProducto,cantidad,costoUnitario,precioVenta) values (p_idSucursal,p_idProducto,p_cantidad,p_costoUnitario,p_precioVenta);

END$$
		CALL sp_AgregarStockSucursal(25854,25,3,125,200);
        CALL sp_AgregarStockSucursal(35688,16,5,490,750);
        CALL sp_AgregarStockSucursal(14584,24,50,9,16);
        
	 SELECT * FROM StockSucursal;
		TRUNCATE TABLE StockSucursal;

DELIMITER $$
	CREATE PROCEDURE sp_AgregarMercaderia(p_idSucursal int(10),p_fechaDocumento date ,p_idProveedor int(10))
	BEGIN 
	INSERT INTO Mercaderia(idSucursal,fechaDocumento,idProveedor) values (p_idSucursal,p_fechaDocumento,p_idProveedor);

	END$$

	CALL sp_AgregarMercaderia(25854,'2019-01-30',1);
	CALL sp_AgregarMercaderia(35688,'2020-01-30',2);
    CALL sp_AgregarMercaderia(314584,'2021-03-15',3);
    
    SELECT * FROM Mercaderia;


DELIMITER $$
	CREATE PROCEDURE sp_AgregarFacturacion(p_idSucursal int,p_fechaDocumento date,p_fechaEntrega date,p_idCliente int)
	BEGIN
	INSERT INTO Facturacion(idSucursal,fechaDocumento,fechaEntrega,idCliente) values (p_idSucursal,p_fechaDocumento,p_fechaEntrega,p_idCliente);
END $$

		CALL sp_AgregarFacturacion(25854,'2018-01-30','2019-03-15',1);
		CALL sp_AgregarFacturacion(35688,'2020-01-30','2020-04-25',2);
        CALL sp_AgregarFacturacion(314584,'2020-01-30','2020-03-15',3);

	SELECT * FROM Facturacion;


-- PROCESOS DE MODIFICAR --
            
DELIMITER $$
	CREATE PROCEDURE sp_ModificarProveedor(p_idProveedor int(10),p_nombre varchar(45),p_departamento varchar(20))
	BEGIN
		UPDATE Proveedor
		SET  nombre= p_nombre,
		 departamento = p_departamento
		WHERE idProveedor  = p_idProveedor;
	END $$
		
			CALL sp_ModificarProveedor(1,'Ernesto','Sololá');
		
        SELECT * FROM Proveedor;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarClientes(p_idCliente int(10),p_nombre varchar(45),p_departamento varchar(30),p_limiteCredito real)
    BEGIN
		UPDATE Clientes
		SET nombre = p_nombre,
		departamento = p_departamento,
        limiteCredito = p_limiteCredito
		WHERE  idCliente = p_idCliente;
    END $$
		
        CALL sp_ModificarClientes(1,'Juan','Alta Verapaz',2500);
        
	SELECT * FROM Clientes;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarUnidadMedida(p_idUnidadMedida int(10),p_descripcion varchar(45))
    BEGIN
		UPDATE UnidadMedida
		SET descripcion = p_descripcion
		WHERE idUnidadMedida =p_idUnidadMedida;
    END $$
		
        CALL sp_ModificarUnidadMedida(4,'Pies');
        
	SELECT * FROM UnidadMedida;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarFamilia(p_idFamilia int(10),p_descripcion varchar(45))
    BEGIN
		UPDATE Familia
		SET descripcion = p_descripcion
		WHERE idFamilia=p_idFamilia;
    END $$
		
        CALL sp_ModificarFamilia(1,'Jardineria');
        
	SELECT * FROM Familia;
    
DELIMITER $$	
	CREATE PROCEDURE sp_ModificarSubFamilia(p_idSubfamilia  int(10),p_descripcion varchar(45))
    BEGIN 
		UPDATE SubFamilia
		SET descripcion = p_descripcion
		WHERE idSubfamilia = p_idSubfamilia;
    END $$
    
		CALL sp_ModificarSubFamilia(1,'Macetas de Colores');
        
	SELECT * FROM SubFamilia;
   
DELIMITER $$
	CREATE PROCEDURE sp_ModificarProducto(p_idProducto int(10),p_nombre varchar(45),p_descripcion varchar(45))
	BEGIN
		UPDATE Producto
		SET nombre = p_nombre,
		descripcion = p_descripcion
		WHERE  idProducto = p_idProducto;
    END$$
    
		CALL sp_ModificarProducto(2,'Talishte','Macetas de Colores de diferentes tamaños');
        
	SELECT * FROM Producto;
  
DELIMITER $$
    CREATE PROCEDURE sp_ModificarSucursal(p_idSucursal int(10),p_direccion varchar(45),p_gerente varchar(45))
	BEGIN
		UPDATE Sucursal
		SET direccion =p_direccion,
		gerente = p_gerente
		WHERE idSucursal= p_idSucursal;
	END$$
    
		CALL sp_ModificarSucursal(16,'Centro Comercial Miraflores','Alberto Colindres');
        
	SELECT * FROM Sucursal;
    
DELIMITER $$
	CREATE PROCEDURE sp_ModificarStockSucursal(p_idSucursal int(10),p_cantidad int(20),p_precioVenta real )
    BEGIN
		UPDATE StockSucursal 
		SET cantidad = p_cantidad,
		precioVenta =p_precioVenta
		WHERE idSucursal=p_idSucursal;
    END $$
    
		CALL sp_ModificarStockSucursal(16,500,12);
        
	SELECT * FROM StockSucursal;
    
DELIMITER $$
  CREATE PROCEDURE sp_ModificarMercaderia(p_numeroDocumento int(10),p_idProveedor int(10),p_cantidad int(10))
  BEGIN
	UPDATE Mercaderia
	SET idProveedor = p_idProveedor,
      cantidad = p_cantidad
	WHERE numeroDocumento = p_numeroDocumento;
  END $$
  
	CALL sp_ModificarMercaderia(1,2,500);
    
SELECT * FROM Mercaderia;
  
DELIMITER $$
	CREATE PROCEDURE sp_ModificarFacturacion(p_numeroDocumento int,p_idCliente int,p_idProducto int,p_idUnidadMedida int,p_cantidad int,p_costoUnitario int,p_precioVenta int)
	BEGIN
		UPDATE Facturacion
		SET idCliente =p_idCliente,
		idProducto = p_idProducto,
        idUnidadMedida = p_idUnidadMedida,
        cantidad = p_cantidad,
        costoUnitario = p_costoUnitario,
		precioVenta = p_precioVenta
		WHERE numeroDocumento = p_numeroDocumento;
    END $$
    
    CALL sp_ModificarFacturacion(1,2,4,5,1000,400,600);
    
    SELECT * FROM Facturacion;
    

-- PROCESOS DE ELIMINAR -- 
            
DELIMITER $$
	CREATE PROCEDURE sp_EliminarProveedor(p_idProveedor int)
    BEGIN
		DELETE FROM Proveedor 
		WHERE idProveedor = p_idProveedor;
END$$
	
		CALL sp_EliminarProveedor(3);
        
	SELECT * FROM Proveedor;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarClientes( p_idCliente int)
    BEGIN
		DELETE FROM Clientes 
		WHERE idCliente = p_idCliente ;
END $$
	
		CALL sp_EliminarClientes(1);
        
	SELECT * FROM Clientes;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarUnidadMedida(p_idUnidadMedida int)
    BEGIN
    DELETE FROM UnidadMedida 
    WHERE idUnidadMedida = p_idUnidadMedida ;
END $$
	
		CALL sp_EliminarUnidadMedida(2);
        
	SELECT * FROM UnidadMedida;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarFamilia(p_idFamilia int)
    BEGIN
    DELETE FROM Familia 
    WHERE idFamilia = p_idFamilia ;
END $$
	
    CALL sp_EliminarFamilia(3);
    
SELECT * FROM Familia;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarSubFamilia(p_idSubfamilia int)
    BEGIN
    DELETE FROM SubFamilia 
    WHERE idSubfamilia = p_idSubfamilia ;
END $$
	
		CALL sp_EliminarSubFamilia(2);
        
	SELECT * FROM SubFamilia;
    
DELIMITER $$
	CREATE PROCEDURE sp_EliminarProducto(p_idProducto int)
    BEGIN
		DELETE FROM Producto 
        WHERE idProducto = p_idProducto ;
    END $$
	
		CALL sp_EliminarProducto(3);
        
	SELECT * FROM Producto;
    
DELIMITER $$
    CREATE PROCEDURE sp_EliminarSucursal(p_idSucursal int)
    BEGIN
		DELETE FROM Sucursal
        WHERE idSucursal = p_idSucursal ;
    END $$
	
		CALL sp_EliminarSucursal(2);
        
	SELECT * FROM Sucursal;
    
DELIMITER $$
    CREATE PROCEDURE sp_EliminarStockSucursal(p_idSucursal int)
    BEGIN
		DELETE FROM StockSucursal 
        WHERE idSucursal = p_idSucursal ;
    END $$
	
		CALL sp_EliminarStockSucursal(4);
        
	SELECT * FROM Sucursal;
    
DELIMITER $$
    CREATE PROCEDURE sp_EliminarMercaderia(p_numeroDocumento int)
    BEGIN
		DELETE FROM Mercaderia 
		WHERE numeroDocumento = p_numeroDocumento ;
    END $$
	
		CALL sp_EliminarMercaderia(3);
	
    SELECT * FROM Mercaderia;
    
DELIMITER $$
    CREATE PROCEDURE sp_EliminarFacturacion(p_numeroDocumento int)
    BEGIN
		DELETE FROM Facturacion 
		WHERE numeroDocumento = p_numeroDocumento ;
    END $$
	
		CALL sp_EliminarFacturacion(2);
        
	SELECT * FROM Facturacion;