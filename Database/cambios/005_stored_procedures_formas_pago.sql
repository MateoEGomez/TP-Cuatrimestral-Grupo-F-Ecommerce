use ECOMMERCE_DB
go

create or alter procedure storedListarFormasPago
as
	select Id, Descripcion, Activo from FORMAS_PAGO order by Descripcion
go

create or alter procedure storedAltaFormaPago
	@Descripcion varchar(50)
as
	insert into FORMAS_PAGO (Descripcion, Activo) values (@Descripcion, 1)
go

create or alter procedure storedModificarFormaPago
	@Id int,
	@Descripcion varchar(50)
as
	update FORMAS_PAGO set Descripcion = @Descripcion where Id = @Id
go

create or alter procedure storedBajaLogicaFormaPago
	@Id int,
	@Activo bit
as
	update FORMAS_PAGO set Activo = @Activo where Id = @Id
go
