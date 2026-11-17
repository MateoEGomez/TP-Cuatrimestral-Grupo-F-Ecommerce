use ECOMMERCE_DB
go

create or alter procedure storedListarFormasEntrega
as
	select Id, Descripcion, RequiereDireccion, Activo from FORMAS_ENTREGA order by Descripcion
go

create or alter procedure storedAltaFormaEntrega
	@Descripcion varchar(50),
	@RequiereDireccion bit
as
	insert into FORMAS_ENTREGA (Descripcion, RequiereDireccion, Activo) values (@Descripcion, @RequiereDireccion, 1)
go

create or alter procedure storedModificarFormaEntrega
	@Id int,
	@Descripcion varchar(50),
	@RequiereDireccion bit
as
	update FORMAS_ENTREGA set Descripcion = @Descripcion, RequiereDireccion = @RequiereDireccion where Id = @Id
go

create or alter procedure storedBajaLogicaFormaEntrega
	@Id int,
	@Activo bit
as
	update FORMAS_ENTREGA set Activo = @Activo where Id = @Id
go
