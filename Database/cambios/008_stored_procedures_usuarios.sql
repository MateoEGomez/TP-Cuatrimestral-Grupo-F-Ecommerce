use ECOMMERCE_DB
go

create or alter procedure storedListarPerfiles
as
	select Id, Descripcion from PERFILES order by Id
go

create or alter procedure storedListarUsuarios
as
	select U.Id, U.Email, U.Nombre, U.Apellido, U.Telefono, U.Activo,
		P.Id as IdPerfil, P.Descripcion as Perfil
	from USUARIOS U
	inner join PERFILES P on P.Id = U.IdPerfil
	order by U.Email
go

create or alter procedure storedModificarUsuario
	@Id int,
	@Nombre varchar(50),
	@Apellido varchar(50),
	@Telefono varchar(30),
	@IdPerfil int
as
	update USUARIOS set Nombre = @Nombre, Apellido = @Apellido, Telefono = @Telefono, IdPerfil = @IdPerfil
	where Id = @Id
go

create or alter procedure storedBajaLogicaUsuario
	@Id int,
	@Activo bit
as
	update USUARIOS set Activo = @Activo where Id = @Id
go
