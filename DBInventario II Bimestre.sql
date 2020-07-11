/*Jose Aguilar 2015-554
	Cristian Aguilar 2015-395
		Pablo De Leon 2015-329
					*/


create database Inventario;
use Inventario;

create table Clientes(
	idCliente integer primary key auto_increment,
	nombre varchar(100) not null,
    nit varchar(20) not null default '',
    direccion varchar(50)not null,
	numeroTelefono varchar(8)not null);
---------------------------------------------------------------------------------------------------------------------------------
create table Proveedor(
	idProveedor integer not null primary key auto_increment,
    nombre varchar(50) not null,
	nit varchar(20)not null default '',
	direccion varchar(50)not null,
    numeroTelefono varchar(8)not null,
    fax varchar(8)not null,
    correoElectronico varchar(50)not null,
    departamento varchar(50)not null);
---------------------------------------------------------------------------------------------------------------------------------    
create table Familias(
	idFamilia int not null primary key auto_increment,
	descripcion varchar(100) not null,
	constraint cu_Familias_descripcion unique(descripcion));
 ---------------------------------------------------------------------------------------------------------------------------------
 create table SubFamilias(
	idSubFamilia int not null primary key auto_increment,
	descripcion varchar(100) not null,
	constraint cu_SubFamilias_descripcion unique(descripcion));
---------------------------------------------------------------------------------------------------------------------------------
 create table UnidadMedidas(
	idUnidadMedida int not null primary key auto_increment,
	descripcion varchar(100) not null,
	constraint cu_UnidadMedidas_descripcion unique(descripcion));
--------------------------------------------------------------------------------------------------------------------------------- 
 create table Productos(
	idProducto int not null primary key auto_increment,
	descripcion varchar(100) not null,
	constraint cu_Productos_descripcion unique(descripcion),
	idUnidadMedida int not null,
	idFamilia int not null,
	idSubFamilia int not null,
	fechaProduccion date not null,
	fechaVencimiento date not null,
    tipoProducto char(1),-- T,M
    rendimiento int,
	peso double,
	costo real unsigned,
	precioVenta real unsigned,
	foreign key (idUnidadMedida) references UnidadMedidas(idUnidadMedida),
	foreign key (idFamilia) references Familias(idFamilia),
	foreign key (idSubFamilia) references SubFamilias(idSubFamilia));
    
create table DetalleProducto(
idDetalleProducto int not null,
idProducto int not null,
primary key(idDetalleProducto,idProducto),
cantidad int not null,
idUnidadMedida int not null,
     foreign key (idUnidadMedida) references UnidadMedidas(idUnidadMedida),
	foreign key(idProducto)references Productos(idProducto));
---------------------------------------------------------------------------------------------------------------------------------
  create table Sucursal(
	idSucursal int not null primary key auto_increment,
	nombre varchar(100) not null,
	direccion varchar(50)not null,
	numeroTelefono varchar(8)not null,
	nombreResponsable varchar(50)not null);
    
create table SucursalProductos(
	idSucursal int not null,
	idProducto int not null,
	primary key(idSucursal,idProducto),
	cantidad int not null,
	costoUnitario double not null,
	descripcion varchar(100) not null,
				foreign key (idSucursal) references Sucursal(idSucursal),
                foreign key (idProducto) references Productos(idProducto)); 
---------------------------------------------------------------------------------------------------------------------------------
create table TipoOrden(
	idTipoOrden int not null primary key auto_increment,
    descripcion varchar(25) not null);
---------------------------------------------------------------------------------------------------------------------------------
  create table OrdenProduccion(
	idOrden int not null primary key auto_increment,
    idSucursal int not null,
	idCliente int not null,
    fechaOrden date not null,
    estatus varchar(1),-- p,c,
    idTipoOrden int not null,
	foreign key (idSucursal) references Sucursal(idSucursal),
    foreign key(idCliente)references Clientes(idCliente),
    foreign key (idTipoOrden) references TipoOrden(idTipoOrden));
    

create table OrdenesProduccionTerminado( 
	idOrden int not null,
    idProducto int not null,
    primary key(idOrden,idProducto),
    cantidad int not null,
    idUnidadMedida int not null,
		foreign key(idUnidadMedida) references UnidadMedidas(idUnidadMedida)on delete cascade,
        foreign key(idProducto)references Productos(idProducto)on delete cascade,
        foreign key(idOrden)references OrdenProduccion(idOrden)on delete cascade);
    
create table OrdenesProduccionMateriaPrima(
   idOrden int not null,
   idProductoMateriaPrima int not null,
	primary key(idOrden,idProductoMateriaPrima),
	idUnidadMedida int not null,
    cantidad int not null,
    costoUnitario double,
    foreign key (idUnidadMedida) references UnidadMedidas(idUnidadMedida)on delete cascade,
	foreign key(idOrden)references OrdenProduccion(idOrden)on delete cascade);    
---------------------------------------------------------------------------------------------------------------------------------
  create table ComprasLocal(
	idComprasLocal int not null primary key auto_increment,
	idProveedor integer not null,
	idSucursal integer not null,
	numeroDocumento int not null,
	fechaDocumento date,
	foreign key (idSucursal) references Sucursal(idSucursal),
	foreign key (idProveedor) references Proveedor(idProveedor));

create table ComprasLocalProductos(
	idComprasLocal int not null,
	idProducto int not null,
	primary key(idComprasLocal,idProducto),
	idUnidadMedida int not null,
	cantidad int not null,
	costoUnitario double,
	foreign key(idProducto)references Productos(idProducto),
	foreign key(idUnidadMedida) references UnidadMedidas(idUnidadMedida),
	foreign key(idComprasLocal) references ComprasLocal(idComprasLocal));

---------------------------------------------------------------------------------------------------------------------------------    
create table Facturacion(
	idFacturacion int not null primary key auto_increment,
    idSucursal int not null,
    fechaDocumento date not null,
    fechaEntrega date not null,
    idCliente int not null,
    foreign key(idSucursal)references Sucursal(idSucursal),
    foreign key(idCliente)references Clientes(idCliente));

create table FacturacionProductos(
	idFacturacion int not null,
    idProducto int not null,
    primary key(idFacturacion,idProducto),
    cantidad int not null,
    costoUnitario double,
    idUnidadMedida int not null,
	foreign key(idUnidadMedida) references UnidadMedidas(idUnidadMedida),
    foreign key(idProducto)references Productos(idProducto),
    foreign key(idFacturacion) references Facturacion(idFacturacion));
 ---------------------------------------------------------------------------------------------------------------------------------   
 create table Requisiciones(
	idRequisicion int not null primary key,
    idSucursal int not null,
    idOrden int not null,
    fechaDocumento date not null,
    foreign key (idSucursal) references Sucursal(idSucursal),
    foreign key (idOrden) references OrdenProduccion(idOrden));
    
create table RequisicionesProductos(
	idRequisicion int not null,
	idProducto int not null,
	primary key(idRequisicion,idProducto),
	idUnidadMedida int not null,
    costoUnitario double,
	cantidad int not null,
    foreign key(idRequisicion)references Requisiciones(idRequisicion),
    foreign key (idUnidadMedida) references UnidadMedidas(idUnidadMedida),
    foreign key (idProducto) references Productos(idProducto));
 ---------------------------------------------------------------------------------------------------------------------------------   
create table Devoluciones(
	idDevoluciones int not null primary key,
    idSucursal int not null,
    idOrden int not null,
    fechaDocumento date not null,
    foreign key (idSucursal) references Sucursal(idSucursal),
    foreign key (idOrden) references OrdenProduccion(idOrden));
    

create table DevolucionesProductos(
	idDevoluciones int not null,
    idProducto int not null,
	primary key(idDevoluciones,idProducto),
	cantidad int not null,
	costoUnitario double not null,
    	idUnidadMedida int not null,
    foreign key (idUnidadMedida) references UnidadMedidas(idUnidadMedida),
    foreign key (idDevoluciones)references Devoluciones(idDevoluciones),
        foreign key (idProducto) references Productos(idProducto));
---------------------------------------------------------------------------------------------------------------------------------
create table IngresoProduccion(
	idIngresoProduccion int not null primary key,
    fechaIngreso date not null,
    idSucursal int not null,
    idOrden int not null,
	foreign key (idSucursal) references Sucursal(idSucursal),
    foreign key (idOrden) references OrdenProduccion(idOrden));

create table IngresoProduccionProductos(
	idIngresoProduccion int not null,	
    idProducto int not null,
	primary key(idIngresoProduccion,idProducto),
	cantidad int not null,
	costoUnitario double not null,
    idUnidadMedida int not null,
        foreign key (idUnidadMedida) references UnidadMedidas(idUnidadMedida),
        foreign key (idIngresoProduccion) references IngresoProduccion(idIngresoProduccion),
            foreign key (idProducto) references Productos(idProducto));
 ---------------------------------------------------------------------------------------------------------------------------------   
  DELIMITER $$

create procedure sp_AgregarClientes(p_idCliente int,p_nombre varchar(100),p_nit varchar(20),p_direccion varchar(50),p_numeroTelefono varchar(8))
begin
   INSERT INTO Clientes (idCliente,nombre,nit,direccion,numeroTelefono) values (p_idCliente,p_nombre,p_nit,p_direccion,p_numeroTelefono);
end $$

	call sp_AgregarClientes(1,'Umberto','123456789','0av B','12457896');
	call sp_AgregarClientes(2,'Cefelio','987654321','2av B','78451296');
	select * from Clientes
    
    CREATE VIEW `V_Clientes` AS
		select * from Clientes
 
Delimiter $$
	create procedure sp_UpdateClientes(p_idCliente int,p_nombre varchar(100),p_nit varchar(20),p_direccion varchar(50),p_numeroTelefono varchar(8))
		begin
			update Clientes
            set idCliente=p_idCliente,nombre=p_nombre,nit=p_nit,direccion=p_direccion,numeroTelefono=p_numeroTelefono
			where idCliente=p_idCliente;
        end $$
			call sp_UpdateClientes(1,'Roberto','123456789','0av B','12457896');
 			call sp_UpdateClientes(2,'Carlos','987654321','2av B','78451296');
            select * from Clientes;
 ---------------------------------------------------------------------------------------------------------------------------------   
Delimiter $$
create procedure sp_AgregarProveedor(p_idProveedor integer,p_nombre varchar(50),p_nit varchar(20),p_direccion varchar(50),p_numeroTelefono varchar(8),p_fax varchar(8),p_correoElectronico varchar(50),p_departamento varchar(50))
begin
	INSERT INTO Proveedor (idProveedor,nombre,nit,direccion,numeroTelefono,fax,correoElectronico,departamento) values (p_idProveedor,p_nombre,p_nit,p_direccion,p_numeroTelefono,p_fax,p_correoElectronico,p_departamento);
end $$

	call sp_AgregarProveedor(1,'Trident','96325148','12 calle','78965489','78789869','Tridentgt@gmail.com','Guatemala');
	call sp_AgregarProveedor(2,'CocaCola','45632125','14 calle','75636259','56568984','cocaColaGT@gmail.com','Guatemala');
	select * from Proveedor;

	CREATE VIEW `V_Proveedor` AS
		select * from Proveedor
        
 Delimiter $$
	create procedure sp_UpdateProveedor(p_idProveedor int,p_nombre varchar(50),p_nit varchar(20),p_direccion varchar(50),p_numeroTelefono varchar(8),p_fax varchar(8),p_correoElectronico varchar(50),p_departamento varchar(50))
		begin
			update Proveedor
            set idProveedor=p_idProveedor,nombre=p_nombre,nit=p_nit,direccion=p_direccion,numeroTelefono=p_numeroTelefono,fax=p_fax,correoElectronico=p_correoElectronico,departamento=p_departamento
			where idProveedor=p_idProveedor;
     end $$
		call sp_UpdateProveedor(1,'Bubalu','96325148','12 calle','78965489','78789869','Tridentgt@gmail.com','Guatemala');
		call sp_UpdateProveedor(2,'Pepsi','45632125','14 calle','75636259','56568984','cocaColaGT@gmail.com','Guatemala');
            select * from Proveedor;   
---------------------------------------------------------------------------------------------------------------------------------    
Delimiter $$

create procedure sp_AgregarFamilias(p_idFamilia int,p_descripcion varchar(100))
begin
	INSERT INTO Familias (idFamilia,descripcion) values (p_idFamilia,p_descripcion);
end $$

	call sp_AgregarFamilias(1,'Ropa');
	call sp_AgregarFamilias(2,'Comida');
	select * from Familias

	CREATE VIEW `V_Familias` AS
		select * from Familias
        
  Delimiter $$
	create procedure sp_UpdateFamilias(p_idFamilia int,p_descripcion varchar(100))
		begin
            update Familias
            set idFamilia=p_idFamilia,descripcion=p_descripcion
            where idFamilia=p_idFamilia;
		end $$
			call sp_UpdateFamilias(1,'Calzado');
			call sp_UpdateFamilias(2,'Bebidas');
            select * from Familias;    
---------------------------------------------------------------------------------------------------------------------------------
 Delimiter $$
 
 create procedure sp_AgregarSubFamilias(p_idSubFamilia int,p_descripcion varchar(100))
begin
	INSERT INTO SubFamilias(idSubFamilia,descripcion) values (p_idSubFamilia,p_descripcion);
end $$

	call sp_AgregarSubFamilias(1,'Extranjera');
	call sp_AgregarSubFamilias(2,'Local');
	select * from SubFamilias;
    
    CREATE VIEW `V_SubFamilias` AS
		select * from SubFamilias
        
 Delimiter $$
	create procedure sp_UpdateSubFamilias(p_idSubFamilia int,p_descripcion varchar(100))
		begin
			update SubFamilias
            set idSubFamilia=p_idSubFamilia,descripcion=p_descripcion
            where idSubFamilia=p_idSubFamilia;
		end $$
			call sp_UpdateSubFamilias(1,'Internacional');
			call sp_UpdateSubFamilias(2,'Local');
            select * from SubFamilias;     
---------------------------------------------------------------------------------------------------------------------------------
Delimiter $$
 
 create procedure sp_AgregarUnidadMedidas(p_idUnidadMedida int,p_descripcion varchar(100))
begin
	INSERT INTO UnidadMedidas(idUnidadMedida,descripcion) values (p_idUnidadMedida,p_descripcion);
end $$

	call sp_AgregarUnidadMedidas(1,'Libras');
	call sp_AgregarUnidadMedidas(2,'Toneladas');
	select * from UnidadMedidas

	CREATE VIEW `V_UnidadMedidas` AS
		select * from UnidadMedidas
        
  Delimiter $$
	create procedure sp_UpdateUnidadMedidas(p_idUnidadMedida int,p_descripcion varchar(100))
		begin
			update UnidadMedidas
            set idUnidadMedida=p_idUnidadMedida,descripcion=p_descripcion
            where idUnidadMedida=p_idUnidadMedida;
		end $$
			call sp_UpdateUnidadMedidas(1,'Onza');
			call sp_UpdateUnidadMedidas(2,'Arroba');
            select * from UnidadMedidas; 
---------------------------------------------------------------------------------------------------------------------------------
  Delimiter $$

create procedure sp_AgregarProductos(p_idProducto int,p_descripcion varchar(100),p_idUnidadMedida int,p_idFamilia int,p_idSubFamilia int,p_fechaProduccion date,p_fechaVencimiento date,p_tipoProducto char(1),p_rendimiento int,p_peso double,p_costo real,p_precioVenta real)
begin
	INSERT INTO Productos (idProducto,descripcion,idUnidadMedida,idFamilia,idSubFamilia,fechaProduccion,fechaVencimiento,tipoProducto,rendimiento,peso,costo,precioVenta) values (p_idProducto,p_descripcion,p_idUnidadMedida,p_idFamilia,p_idSubFamilia,p_fechaProduccion,p_fechaVencimiento,p_tipoProducto,p_rendimiento,p_peso,p_costo,p_precioVenta);
end $$

	call sp_AgregarProductos(1,'Trident',1,1,1,'2019-12-01','2020-12-12','T',1,20.0,200,800);
	call sp_AgregarProductos(2,'CocaCola',2,2,2,'2013-12-12','2012-12-30','M',2,15.0,100,600);
	select * from Productos;

	CREATE VIEW `V_Productos` AS
		select * from Productos   
    
   Delimiter $$
	create procedure sp_UpdateProductos(p_idProducto int,p_descripcion varchar(100),p_idUnidadMedida int,p_idFamilia int,p_idSubFamilia int,p_fechaProduccion date,p_fechaVencimiento date,p_tipoProducto char(1),p_rendimiento int,p_peso double,p_costo real,p_precioVenta real)
		begin
			update Productos
          set descripcion=p_descripcion,idUnidadMedida=p_idUnidadMedida,idFamilia=p_idFamilia,idSubFamilia=p_idSubFamilia,fechaProduccion=p_fechaProduccion,fechaVencimiento=p_fechaVencimiento,peso=p_peso,costo=p_costo,precioVenta=p_precioVenta
			where idProducto=p_idProducto;
        end $$
			call sp_UpdateProductos(1,'Cubo',1,1,1,'2019-12-01','2020-12-12','T',1,20.0,200,800);
			call sp_UpdateProductos(2,'BigCola',2,2,2,'2013-12-12','2012-12-30','M',2,15.0,100,600);
            select * from Productos;
---------------------------------------------------------------------------------------------------------------------------------
Delimiter $$
create procedure sp_AgregarDetalleProducto(p_idDetalleProducto int,p_idProducto int,p_cantidad int,p_idUnidadMedida int)
begin
	INSERT INTO DetalleProducto (idDetalleProducto,idProducto,cantidad,idUnidadMedida) values (p_idDetalleProducto,p_idProducto,p_cantidad,p_idUnidadMedida);
end $$

	call sp_AgregarDetalleProducto(1,1,20,1);
	call sp_AgregarDetalleProducto(2,2,50,2);
	select * from DetalleProducto;

	CREATE VIEW `V_DetalleProducto` AS
		select * from DetalleProducto
        
    Delimiter $$
	create procedure sp_UpdateDetalleProducto(p_idDetalleProducto int,p_idProducto int,p_cantidad int,p_idUnidadMedida int)
		begin
			update DetalleProducto
            set idDetalleProducto=p_idDetalleProducto,idProducto=p_idProducto,cantidad=p_cantidad,idUnidadMedida=p_idUnidadMedida
			where idDetalleProducto=p_idDetalleProducto and idProducto=p_idProducto;
        end $$
			call sp_UpdateDetalleProducto(1,1,30,1);
			call sp_UpdateDetalleProducto(2,2,40,2);
            select * from DetalleProducto;
---------------------------------------------------------------------------------------------------------------------------------
  Delimiter $$

create procedure sp_AgregarSucursal(p_idSucursal int,p_nombre varchar(100),p_direccion varchar(50),p_numeroTelefono varchar(8),p_nombreResponsable varchar(50))
begin
   INSERT INTO Sucursal (idSucursal,nombre,direccion,numeroTelefono,nombreResponsable) values (p_idSucursal,p_nombre,p_direccion,p_numeroTelefono,p_nombreResponsable);
end $$

	call sp_AgregarSucursal(1,'Walmart','0av A','96586232','Isaias');
	call sp_AgregarSucursal(2,'Paiz','8av B','98632658','Jeremias');
	select * from Sucursal;
    
    CREATE VIEW `V_Sucursal` AS
		select * from Sucursal
        
    Delimiter $$
	create procedure sp_UpdateSucursal(p_idSucursal int,p_nombre varchar(100),p_direccion varchar(50),p_numeroTelefono varchar(8),p_nombreResponsable varchar(50))
		begin
			update Sucursal
            set idSucursal=p_idSucursal,nombre=p_nombre,direccion=p_direccion,numeroTelefono=p_numeroTelefono,nombreResponsable=p_nombreResponsable
			where idSucursal=p_idSucursal;
        end $$
			call sp_UpdateSucursal(1,'La Torre','0av A','96586232','Isaias');
			call sp_UpdateSucursal(2,'La Barata','8av B','98632658','Jeremias');
            select * from Sucursal;      
---------------------------------------------------------------------------------------------------------------------------------            
Delimiter $$

create procedure sp_AgregarSucursalProductos(p_idSucursal int,p_idProducto int,p_cantidad int,p_costoUnitario double,p_descripcion varchar(100))
begin
   INSERT INTO SucursalProductos(idSucursal,idProducto,cantidad,costoUnitario,descripcion) values (p_idSucursal,p_idProducto,p_cantidad,p_costoUnitario,p_descripcion);
end $$

	call sp_AgregarSucursalProductos(1,1,50,20.00,'Cerveceria Castillo');
	call sp_AgregarSucursalProductos(2,2,30,10.00,'Cerveceria Castillo');
    call sp_AgregarSucursalProductos(1,1,40,15.00,'Cerveceria Castillo');
	select * from SucursalProductos
    
    CREATE VIEW `V_SucursalProductos` AS
		select * from SucursalProductos
        

        
    Delimiter $$
	create procedure sp_UpdateSucursalProductos(p_idSucursal int,p_idProducto int,p_cantidad int,p_costoUnitario double,p_descripcion varchar(100))
		begin
			update SucursalProductos
            set idSucursal=p_idSucursal,idProducto=p_idProducto,cantidad=p_cantidad,costoUnitario=p_costoUnitario,descripcion=p_descripcion
			where idSucursal=p_idSucursal and idProducto=p_idProducto;
        end $$
			call sp_UpdateSucursalProductos();
			call sp_UpdateSucursalProductos();
            select * from SucursalProductos;  
 ---------------------------------------------------------------------------------------------------------------------------------
	
         Delimiter $$
	create procedure sp_UpdateTipoOrden(p_idOrden int,p_descripcion varchar(25))
		begin
			insert into TipoOrden(idOrden,descripcion) values(p_idOrden,p_descripcion);
		end $$
			call sp_UpdateTipoOrden();
			call sp_UpdateTipoOrden();
            select * from TipoOrden;  
 ---------------------------------------------------------------------------------------------------------------------------------           
Delimiter $$
	create procedure sp_UpdateOrdenProduccion(p_idDetalleProducto int,p_idSucursal int,p_idCliente int,p_fechaOrden date,p_estatus varchar(1))
		begin
			insert into OrdenProduccion(idDetalleProducto,idSucursal,idCliente,fechaOrden,estatus) values(p_idDetalleProducto,p_idSucursal,p_idCliente,p_fechaOrden,p_estatus);
		end $$
			call sp_UpdateOrdenProduccion();
			call sp_UpdateOrdenProduccion();
            select * from OrdenProduccion;  
---------------------------------------------------------------------------------------------------------------------------------            
	  Delimiter $$
	create procedure sp_UpdateOrdenesProduccionTerminado(p_idProductoTerminado int,p_idOrden int,p_cantidad int,p_idUnidadMedida int)
		begin
			insert into OrdenesProduccionTerminado(idProductoTerminado,idOrden,cantidad,idUnidadMedida) values(p_idProductoTerminado,p_idOrden,p_cantidad,p_idUnidadMedida);
		end $$
			call sp_UpdateOrdenesProduccionTerminado();
			call sp_UpdateOrdenesProduccionTerminado();
            select * from OrdenesProduccionTerminado; 
---------------------------------------------------------------------------------------------------------------------------------
    Delimiter $$
	create procedure sp_UpdateOrdenesProduccionMateriaPrima(p_idProductoMateriaPrima int,p_idOrden int,p_idUnidadMedida int,p_cantidad int,p_costoUnitario double)
		begin
			insert into OrdenesProduccionMateriaPrima(idProductoMateriaPrima,idOrden,idUnidadMedida,cantidad,costoUnitario) values(p_idProductoMateriaPrima,p_idOrden,p_idUnidadMedida,p_cantidad,p_costoUnitario);
		end $$
			call sp_UpdateOrdenesProduccionMateriaPrima();
			call sp_UpdateOrdenesProduccionMateriaPrima();
            select * from OrdenesProduccionMateriaPrima;     
---------------------------------------------------------------------------------------------------------------------------------            
      Delimiter $$
	create procedure sp_UpdateComprasLocal(p_idProveedor int,p_idSucursal int,p_numeroDocumento int,p_fechaDocumento date)
		begin
			insert into ComprasLocal(idProveedor,idSucursal,numeroDocumento,fechaDocumento) values(p_idProveedor,p_idSucursal,p_numeroDocumento,p_fechaDocumento);
		end $$
			call sp_UpdateComprasLocal();
			call sp_UpdateComprasLocal();
            select * from ComprasLocal;   
---------------------------------------------------------------------------------------------------------------------------------
          Delimiter $$
	create procedure sp_UpdateComprasLocalProductos(p_idComprasLocalProductos int,p_idProducto int,p_cantidad int,p_costoUnitaro double)
		begin
			insert into ComprasLocalProductos(idComprasLocalProductos,idProducto,cantidad,costoUnitaro) values(p_idComprasLocalProductos,p_idProducto,p_cantidad,p_costoUnitaro);
		end $$
			call sp_UpdateComprasLocalProductos();
			call sp_UpdateComprasLocalProductos();
            select * from ComprasLocalProductos; 
---------------------------------------------------------------------------------------------------------------------------------            
      Delimiter $$
	create procedure sp_UpdateFacturacion(p_idSucursal int,p_fechaDocumento date,p_fechaEntrega date,p_idCliente int)
		begin
			insert into Facturacion(idSucursal,fechaDocumento,fechaEntrega,idCliente) values(p_idSucursal,p_fechaDocumento,p_fechaEntrega,p_idCliente);
		end $$
			call sp_UpdateFacturacion();
			call sp_UpdateFacturacion();
            select * from Facturacion;  
---------------------------------------------------------------------------------------------------------------------------------
    Delimiter $$
	create procedure sp_UpdateFacturacionProductos(p_idFacturacionProductos int,p_idProducto int,p_cantidad int,p_costoUnitario double)
		begin
			insert into FacturacionProductos(idFacturacionProductos,idProducto,cantidad,costoUnitario) values(p_idFacturacionProductos,p_idProducto,p_cantidad,p_costoUnitario);
		end $$
			call sp_UpdateFacturacionProductos();
			call sp_UpdateFacturacionProductos();
            select * from FacturacionProductos;   
---------------------------------------------------------------------------------------------------------------------------------
    Delimiter $$
	create procedure sp_UpdateRequisiciones(p_idSucursal int,p_idOrden int,p_fechaDocumento date)
		begin
			insert into Requisiciones(idSucursal,idOrden,fechaDocumento) values(p_idSucursal,p_idOrden,p_fechaDocumento);
		end $$
			call sp_UpdateRequisiciones();
			call sp_UpdateRequisiciones();
            select * from Requisiciones;              
---------------------------------------------------------------------------------------------------------------------------------
    Delimiter $$
	create procedure sp_UpdateRequisicionesProductos(p_idRequisicionProductos int,p_idProducto int,p_idUnidadMedida int,p_costoUnitario double,p_cantidad int)
		begin
			insert into RequisicionesProductos(idRequisicionProductos,idProducto,idUnidadMedida,costoUnitario,cantidad) values(p_idRequisicionProductos,p_idProducto,p_idUnidadMedida,p_costoUnitario,p_cantidad);
		end $$
			call sp_UpdateRequisicionesProductos();
			call sp_UpdateRequisicionesProductos();
            select * from RequisicionesProductos;   		
---------------------------------------------------------------------------------------------------------------------------------
   Delimiter $$
	create procedure sp_UpdateDevoluciones(p_idSucursal int,p_idOrden int,p_fechaDocumento date)
		begin
			insert into Devoluciones(idSucursal,idOrden,fechaDocumento) values(p_idSucursal,p_idOrden,p_fechaDocumento);
		end $$
			call sp_UpdateDevoluciones();
			call sp_UpdateDevoluciones();
            select * from Devoluciones;  
---------------------------------------------------------------------------------------------------------------------------------
   Delimiter $$
	create procedure sp_UpdateDevolucionesProductos(p_idDevolucionesProductos int,p_idProducto int,p_cantidad int,p_costoUnitario double,p_descripcion varchar(100))
		begin
			insert into DevolucionesProductos(idDevolucionesProductos,idProducto,cantidad,costoUnitario,descripcion) values(p_idDevolucionesProductos,p_idProducto,p_cantidad,p_costoUnitario,p_descripcion);
		end $$
			call sp_UpdateDevolucionesProductos();
			call sp_UpdateDevolucionesProductos();
            select * from DevolucionesProductos;      
---------------------------------------------------------------------------------------------------------------------------------
     Delimiter $$
	create procedure sp_UpdateIngresoProduccion(p_fechaIngreso date,p_idSucursal int,p_idOrden int)
		begin
			insert into IngresoProduccion(fechaIngreso,idSucursal,idOrden) values(p_fechaIngreso,p_idSucursal,p_idOrden);
		end $$
			call sp_UpdateIngresoProduccion();
			call sp_UpdateIngresoProduccion();
            select * from IngresoProduccion;        
---------------------------------------------------------------------------------------------------------------------------------            
    Delimiter $$
	create procedure sp_UpdateIngresoProduccionProductos(p_idIngresoProduccion int,p_idProducto int,p_cantidad int,p_costoUnitario double,p_descripcion varchar(100))
		begin
			insert into IngresoProduccionProductos(idIngresoProduccion,idProducto,cantidad,costoUnitario,descripcion) values(p_idIngresoProduccion,p_idProducto,p_cantidad,p_costoUnitario,p_descripcion);
		end $$
			call sp_UpdateIngresoProduccionProductos();
			call sp_UpdateIngresoProduccionProductos();
            
            select * from IngresoProduccionProductos;   
---------------------------------------------------------------------------------------------------------------------------------            
		
-- TRIGGER -----------------------------------

DELIMITER $$
	CREATE TRIGGER tr_RequisicionesProductos_Insert
	after insert 
	on RequisicionesProductos
	for each row 
	Begin 
		declare V_idSucursal int;
		set V_idSucursal=(select idSucursal from RequisicionesProductos where idRequisicion =new.idRequisicion);
		if Exists (select idSucursal from SucursalProductos where idSucursal= V_idSucursal and idProducto=new.idProducto)
		then
			update SucursalProductos
			set cantidad =cantidad+new.cantidad, costoUnitario=(cantidad*costoUnitario + new.cantidad*new.costoUnitario)/(cantidad+new.cantidad)
			where  idSucursal = V_idSucursal and idProducto = new.idProducto;
		else 
			insert SucursalProductos (idSucursal,idProducto,cantidad,costoUnitario) values (V_idSucursal,new.idProducto,new.cantidad,new.costoUnitario);
	end if;
end$$

    