use ECOMMERCE_DB
go

create or alter procedure storedListarProductosAdmin
	@Filtro varchar(100)
as
	select top 50 P.Id, P.Nombre, P.Precio, P.Stock, P.UrlImagen, P.Activo,
		C.Descripcion as Categoria, E.Nombre as Expansion, EP.Descripcion as EstadoPublicacion
	from Productos P
	inner join CATEGORIAS C on C.Id = P.IdCategoria
	left join Expansiones E on E.Id = P.IdExpansion
	inner join ESTADOS_PUBLICACION EP on EP.Id = P.IdEstadoPublicacion
	where P.Nombre like '%' + @Filtro + '%' or P.CardId like '%' + @Filtro + '%'
	order by P.Nombre
go

create or alter procedure storedObtenerProducto
	@Id int
as
	select Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion,
		IdRareza, IdCondicion, IdIdioma, CardId, Activo
	from Productos
	where Id = @Id
go

create or alter procedure storedAltaProducto
	@Nombre varchar(100),
	@Descripcion varchar(500),
	@Precio decimal(18, 2),
	@Stock int,
	@UrlImagen varchar(300),
	@IdCategoria int,
	@IdExpansion varchar(50),
	@IdRareza int,
	@IdCondicion int,
	@IdIdioma int,
	@CardId varchar(50),
	@IdVendedor int
as
	insert into Productos (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion,
		IdRareza, IdCondicion, IdIdioma, CardId, IdVendedor, IdEstadoPublicacion, Activo)
	values (@Nombre, @Descripcion, @Precio, @Stock, @UrlImagen, @IdCategoria, @IdExpansion,
		@IdRareza, @IdCondicion, @IdIdioma, @CardId, @IdVendedor, 2, 1)
go

create or alter procedure storedModificarProducto
	@Id int,
	@Nombre varchar(100),
	@Descripcion varchar(500),
	@Precio decimal(18, 2),
	@Stock int,
	@UrlImagen varchar(300),
	@IdCategoria int,
	@IdExpansion varchar(50),
	@IdRareza int,
	@IdCondicion int,
	@IdIdioma int,
	@CardId varchar(50)
as
	update Productos set Nombre = @Nombre, Descripcion = @Descripcion, Precio = @Precio, Stock = @Stock,
		UrlImagen = @UrlImagen, IdCategoria = @IdCategoria, IdExpansion = @IdExpansion,
		IdRareza = @IdRareza, IdCondicion = @IdCondicion, IdIdioma = @IdIdioma, CardId = @CardId
	where Id = @Id
go

create or alter procedure storedBajaLogicaProducto
	@Id int,
	@Activo bit
as
	update Productos set Activo = @Activo where Id = @Id
go
