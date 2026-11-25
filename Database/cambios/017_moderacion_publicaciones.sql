use ECOMMERCE_DB
go

if COL_LENGTH('PRODUCTOS', 'MotivoRechazo') is null
	alter table PRODUCTOS add MotivoRechazo varchar(200) null
go

create or alter procedure storedListarEstadosPublicacion
as
	select Id, Descripcion from ESTADOS_PUBLICACION order by Id
go

create or alter procedure storedListarPublicacionesModeracion
	@Filtro varchar(100) = null,
	@IdEstadoPublicacion int = null
as
	select top 100 P.Id, P.Nombre, P.Descripcion, P.Precio, P.Stock, P.UrlImagen, P.Activo, P.MotivoRechazo,
		E.Nombre as ExpansionNombre,
		EP.Id as IdEstadoPublicacion, EP.Descripcion as EstadoPublicacion,
		U.Id as IdVendedor, U.Nombre as VendedorNombre, U.Apellido as VendedorApellido, U.Email as VendedorEmail
	from PRODUCTOS P
	inner join USUARIOS U on U.Id = P.IdVendedor
	inner join ESTADOS_PUBLICACION EP on EP.Id = P.IdEstadoPublicacion
	left join EXPANSIONES E on E.Id = P.IdExpansion
	where U.IdPerfil <> 2
		and (@IdEstadoPublicacion is null or P.IdEstadoPublicacion = @IdEstadoPublicacion)
		and (@Filtro is null or P.Nombre like '%' + @Filtro + '%' or U.Email like '%' + @Filtro + '%'
			or U.Nombre like '%' + @Filtro + '%' or U.Apellido like '%' + @Filtro + '%')
	order by P.Id desc
go

create or alter procedure storedModerarPublicacion
	@Id int,
	@IdEstadoPublicacion int,
	@MotivoRechazo varchar(200) = null
as
	update PRODUCTOS set IdEstadoPublicacion = @IdEstadoPublicacion,
		MotivoRechazo = case when @IdEstadoPublicacion = 3 then @MotivoRechazo else null end
	where Id = @Id
go

create or alter procedure storedContarPublicacionesPendientes
as
	select count(*) from PRODUCTOS where IdEstadoPublicacion = 1
go
