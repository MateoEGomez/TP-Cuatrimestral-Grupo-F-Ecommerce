use ECOMMERCE_DB
go

if OBJECT_ID('RAREZAS') is null
	create table RAREZAS(
		Id int identity(1,1) not null,
		Descripcion varchar(50) not null,
		constraint PK_RAREZAS primary key clustered (Id asc)
	)
go

if OBJECT_ID('CONDICIONES') is null
	create table CONDICIONES(
		Id int identity(1,1) not null,
		Descripcion varchar(50) not null,
		constraint PK_CONDICIONES primary key clustered (Id asc)
	)
go

if OBJECT_ID('IDIOMAS') is null
	create table IDIOMAS(
		Id int identity(1,1) not null,
		Descripcion varchar(50) not null,
		constraint PK_IDIOMAS primary key clustered (Id asc)
	)
go

if OBJECT_ID('ESTADOS_PUBLICACION') is null
	create table ESTADOS_PUBLICACION(
		Id int identity(1,1) not null,
		Descripcion varchar(50) not null,
		constraint PK_ESTADOS_PUBLICACION primary key clustered (Id asc)
	)
go

if not exists (select 1 from RAREZAS)
begin
	insert into RAREZAS values ('Común')
	insert into RAREZAS values ('Poco común')
	insert into RAREZAS values ('Rara')
	insert into RAREZAS values ('Rara holo')
	insert into RAREZAS values ('Ultra rara')
	insert into RAREZAS values ('Rara ilustración')
	insert into RAREZAS values ('Rara secreta')
end
go

if not exists (select 1 from CONDICIONES)
begin
	insert into CONDICIONES values ('Mint')
	insert into CONDICIONES values ('Near Mint')
	insert into CONDICIONES values ('Excelente')
	insert into CONDICIONES values ('Jugada')
	insert into CONDICIONES values ('Dañada')
end
go

if not exists (select 1 from IDIOMAS)
begin
	insert into IDIOMAS values ('Español')
	insert into IDIOMAS values ('Inglés')
	insert into IDIOMAS values ('Japonés')
end
go

if not exists (select 1 from ESTADOS_PUBLICACION)
begin
	insert into ESTADOS_PUBLICACION values ('Pendiente')
	insert into ESTADOS_PUBLICACION values ('Aprobada')
	insert into ESTADOS_PUBLICACION values ('Rechazada')
end
go

if COL_LENGTH('Productos', 'IdRareza') is null
	alter table Productos add IdRareza int null
go

if COL_LENGTH('Productos', 'IdCondicion') is null
	alter table Productos add IdCondicion int null
go

if COL_LENGTH('Productos', 'IdIdioma') is null
	alter table Productos add IdIdioma int null
go

if COL_LENGTH('Productos', 'IdVendedor') is null
	alter table Productos add IdVendedor int not null constraint DF_PRODUCTOS_IdVendedor default 1
go

if COLUMNPROPERTY(OBJECT_ID('Expansiones'), 'Id', 'AllowsNull') = 1
	alter table Expansiones alter column Id varchar(50) not null
go

if OBJECT_ID('PK_EXPANSIONES') is null
	alter table Expansiones add constraint PK_EXPANSIONES primary key clustered (Id asc)
go

if OBJECT_ID('FK_PRODUCTOS_EXPANSIONES') is null
	alter table Productos with check add constraint FK_PRODUCTOS_EXPANSIONES foreign key (IdExpansion) references Expansiones (Id)
go

if OBJECT_ID('FK_PRODUCTOS_RAREZAS') is null
	alter table Productos with check add constraint FK_PRODUCTOS_RAREZAS foreign key (IdRareza) references RAREZAS (Id)
go

if OBJECT_ID('FK_PRODUCTOS_CONDICIONES') is null
	alter table Productos with check add constraint FK_PRODUCTOS_CONDICIONES foreign key (IdCondicion) references CONDICIONES (Id)
go

if OBJECT_ID('FK_PRODUCTOS_IDIOMAS') is null
	alter table Productos with check add constraint FK_PRODUCTOS_IDIOMAS foreign key (IdIdioma) references IDIOMAS (Id)
go

if OBJECT_ID('FK_PRODUCTOS_USUARIOS') is null
	alter table Productos with check add constraint FK_PRODUCTOS_USUARIOS foreign key (IdVendedor) references USUARIOS (Id)
go

if OBJECT_ID('FK_PRODUCTOS_ESTADOS_PUBLICACION') is null
	alter table Productos with check add constraint FK_PRODUCTOS_ESTADOS_PUBLICACION foreign key (IdEstadoPublicacion) references ESTADOS_PUBLICACION (Id)
go
