use ECOMMERCE_DB
go

if object_id('IMAGENES_PRODUCTO') is null
begin
	create table IMAGENES_PRODUCTO (
		Id int identity(1,1) not null constraint PK_IMAGENES_PRODUCTO primary key,
		IdProducto int not null constraint FK_IMAGENES_PRODUCTO_PRODUCTOS foreign key references PRODUCTOS (Id),
		UrlImagen varchar(500) not null,
		Orden int not null
	)
end
go
