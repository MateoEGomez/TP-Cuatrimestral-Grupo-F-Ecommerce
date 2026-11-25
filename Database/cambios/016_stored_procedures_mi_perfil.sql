use ECOMMERCE_DB
go

create or alter procedure storedModificarDatosPerfil
	@Id int,
	@Nombre varchar(50),
	@Apellido varchar(50),
	@Telefono varchar(30)
as
	update USUARIOS set Nombre = @Nombre, Apellido = @Apellido, Telefono = @Telefono
	where Id = @Id
go

create or alter procedure storedCambiarPasswordUsuario
	@Id int,
	@PassActual varchar(50),
	@PassNueva varchar(50)
as
begin
	update USUARIOS set Pass = @PassNueva
	where Id = @Id and Pass = @PassActual
	select @@rowcount
end
go

create or alter procedure storedModificarDireccion
	@Id int,
	@IdUsuario int,
	@Calle varchar(100),
	@Numero varchar(10),
	@Localidad varchar(100),
	@CodigoPostal varchar(10),
	@Observaciones varchar(200)
as
	update DIRECCIONES
	set Calle = @Calle, Numero = @Numero, Localidad = @Localidad, CodigoPostal = @CodigoPostal, Observaciones = @Observaciones
	where Id = @Id and IdUsuario = @IdUsuario
go

create or alter procedure storedBajaLogicaDireccion
	@Id int,
	@IdUsuario int
as
	update DIRECCIONES set Activo = 0 where Id = @Id and IdUsuario = @IdUsuario
go
