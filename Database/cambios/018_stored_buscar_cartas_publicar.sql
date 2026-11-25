use ECOMMERCE_DB
go

create or alter procedure storedBuscarCartasParaPublicar
	@Filtro varchar(100)
as
	select top 50 P.Id, P.Nombre, P.CardId, P.Precio, P.UrlImagen, E.Nombre as ExpansionNombre
	from PRODUCTOS P
	inner join USUARIOS U on U.Id = P.IdVendedor
	left join EXPANSIONES E on E.Id = P.IdExpansion
	where U.IdPerfil = 2 and P.Activo = 1 and P.IdEstadoPublicacion = 2
		and (P.Nombre like '%' + @Filtro + '%' or P.CardId like '%' + @Filtro + '%')
	order by P.Nombre, E.Nombre
go
