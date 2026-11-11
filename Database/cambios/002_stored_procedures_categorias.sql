use ECOMMERCE_DB
go

create or alter procedure storedListarCategorias
as
	select Id, Descripcion, Activo from CATEGORIAS order by Descripcion
go

create or alter procedure storedAltaCategoria
	@Descripcion varchar(50)
as
	insert into CATEGORIAS (Descripcion, Activo) values (@Descripcion, 1)
go

create or alter procedure storedModificarCategoria
	@Id int,
	@Descripcion varchar(50)
as
	update CATEGORIAS set Descripcion = @Descripcion where Id = @Id
go

create or alter procedure storedBajaLogicaCategoria
	@Id int,
	@Activo bit
as
	update CATEGORIAS set Activo = @Activo where Id = @Id
go
