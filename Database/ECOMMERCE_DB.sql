use master
go
create database ECOMMERCE_DB
go
use ECOMMERCE_DB
go

CREATE TABLE [dbo].[CATEGORIAS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_CATEGORIAS] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[PRODUCTOS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Descripcion] [varchar](500) NULL,
	[Precio] [decimal](18, 2) NOT NULL,
	[Stock] [int] NOT NULL DEFAULT 0,
	[UrlImagen] [varchar](300) NULL,
	[IdCategoria] [int] NOT NULL,
	[IdExpansion] [int] NULL,
	[IdRareza] [int] NULL,
	[IdCondicion] [int] NULL,
	[IdIdioma] [int] NULL,
	[IdVendedor] [int] NOT NULL,
	[IdEstadoPublicacion] [int] NOT NULL DEFAULT 1,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_PRODUCTOS] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[PERFILES](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PERFILES] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[USUARIOS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Pass] [varchar](50) NOT NULL,
	[Nombre] [varchar](50) NULL,
	[Apellido] [varchar](50) NULL,
	[Telefono] [varchar](30) NULL,
	[IdPerfil] [int] NOT NULL,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_USUARIOS] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [UQ_USUARIOS_Email] UNIQUE ([Email])
)
GO

CREATE TABLE [dbo].[DIRECCIONES](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[Calle] [varchar](100) NOT NULL,
	[Numero] [varchar](10) NOT NULL,
	[Localidad] [varchar](100) NOT NULL,
	[CodigoPostal] [varchar](10) NOT NULL,
	[Observaciones] [varchar](200) NULL,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_DIRECCIONES] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[FORMAS_PAGO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_FORMAS_PAGO] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[FORMAS_ENTREGA](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[RequiereDireccion] [bit] NOT NULL DEFAULT 0,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_FORMAS_ENTREGA] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[ESTADOS_PEDIDO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ESTADOS_PEDIDO] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[PEDIDOS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL DEFAULT GETDATE(),
	[Total] [decimal](18, 2) NOT NULL,
	[IdFormaPago] [int] NOT NULL,
	[IdFormaEntrega] [int] NOT NULL,
	[IdDireccion] [int] NULL,
	[IdEstado] [int] NOT NULL,
 CONSTRAINT [PK_PEDIDOS] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[DETALLE_PEDIDO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPedido] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[PrecioUnitario] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_DETALLE_PEDIDO] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[OBSERVACIONES_PEDIDO](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPedido] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL DEFAULT GETDATE(),
	[Texto] [varchar](500) NOT NULL,
 CONSTRAINT [PK_OBSERVACIONES_PEDIDO] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[EXPANSIONES](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](100) NOT NULL,
	[Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_EXPANSIONES] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[RAREZAS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RAREZAS] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[CONDICIONES](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CONDICIONES] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[IDIOMAS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_IDIOMAS] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

CREATE TABLE [dbo].[ESTADOS_PUBLICACION](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ESTADOS_PUBLICACION] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

ALTER TABLE [dbo].[PRODUCTOS] WITH CHECK ADD CONSTRAINT [FK_PRODUCTOS_CATEGORIAS] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[CATEGORIAS] ([Id])
GO

ALTER TABLE [dbo].[USUARIOS] WITH CHECK ADD CONSTRAINT [FK_USUARIOS_PERFILES] FOREIGN KEY([IdPerfil])
REFERENCES [dbo].[PERFILES] ([Id])
GO

ALTER TABLE [dbo].[DIRECCIONES] WITH CHECK ADD CONSTRAINT [FK_DIRECCIONES_USUARIOS] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[USUARIOS] ([Id])
GO

ALTER TABLE [dbo].[PEDIDOS] WITH CHECK ADD CONSTRAINT [FK_PEDIDOS_USUARIOS] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[USUARIOS] ([Id])
GO

ALTER TABLE [dbo].[PEDIDOS] WITH CHECK ADD CONSTRAINT [FK_PEDIDOS_FORMAS_PAGO] FOREIGN KEY([IdFormaPago])
REFERENCES [dbo].[FORMAS_PAGO] ([Id])
GO

ALTER TABLE [dbo].[PEDIDOS] WITH CHECK ADD CONSTRAINT [FK_PEDIDOS_FORMAS_ENTREGA] FOREIGN KEY([IdFormaEntrega])
REFERENCES [dbo].[FORMAS_ENTREGA] ([Id])
GO

ALTER TABLE [dbo].[PEDIDOS] WITH CHECK ADD CONSTRAINT [FK_PEDIDOS_DIRECCIONES] FOREIGN KEY([IdDireccion])
REFERENCES [dbo].[DIRECCIONES] ([Id])
GO

ALTER TABLE [dbo].[PEDIDOS] WITH CHECK ADD CONSTRAINT [FK_PEDIDOS_ESTADOS_PEDIDO] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[ESTADOS_PEDIDO] ([Id])
GO

ALTER TABLE [dbo].[DETALLE_PEDIDO] WITH CHECK ADD CONSTRAINT [FK_DETALLE_PEDIDO_PEDIDOS] FOREIGN KEY([IdPedido])
REFERENCES [dbo].[PEDIDOS] ([Id])
GO

ALTER TABLE [dbo].[DETALLE_PEDIDO] WITH CHECK ADD CONSTRAINT [FK_DETALLE_PEDIDO_PRODUCTOS] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[PRODUCTOS] ([Id])
GO

ALTER TABLE [dbo].[OBSERVACIONES_PEDIDO] WITH CHECK ADD CONSTRAINT [FK_OBSERVACIONES_PEDIDO_PEDIDOS] FOREIGN KEY([IdPedido])
REFERENCES [dbo].[PEDIDOS] ([Id])
GO

ALTER TABLE [dbo].[OBSERVACIONES_PEDIDO] WITH CHECK ADD CONSTRAINT [FK_OBSERVACIONES_PEDIDO_USUARIOS] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[USUARIOS] ([Id])
GO

insert into PERFILES values ('Cliente')
insert into PERFILES values ('Administrador')
insert into PERFILES values ('Vendedor')

insert into CATEGORIAS (Descripcion) values ('Cartas sueltas')
insert into CATEGORIAS (Descripcion) values ('Sobres')
insert into CATEGORIAS (Descripcion) values ('Cajas y packs')
insert into CATEGORIAS (Descripcion) values ('Accesorios')

insert into USUARIOS (Email, Pass, Nombre, Apellido, Telefono, IdPerfil) values ('admin@ecommerce.com', 'admin', 'Admin', 'Sistema', null, 2)
insert into USUARIOS (Email, Pass, Nombre, Apellido, Telefono, IdPerfil) values ('vendedor@ecommerce.com', 'vendedor', 'Vendedor', 'Prueba', null, 3)
insert into USUARIOS (Email, Pass, Nombre, Apellido, Telefono, IdPerfil) values ('cliente@ecommerce.com', 'cliente', 'Juan', 'Pérez', '1155550000', 1)

insert into DIRECCIONES (IdUsuario, Calle, Numero, Localidad, CodigoPostal, Observaciones) values (3, 'Av. Siempre Viva', '742', 'San Fernando', '1646', 'Domicilio particular')
insert into DIRECCIONES (IdUsuario, Calle, Numero, Localidad, CodigoPostal, Observaciones) values (3, 'Av. Libertador', '1500', 'Vicente López', '1638', 'Oficina, piso 3')

insert into FORMAS_PAGO (Descripcion) values ('Efectivo')
insert into FORMAS_PAGO (Descripcion) values ('Transferencia bancaria')
insert into FORMAS_PAGO (Descripcion) values ('Tarjeta de crédito / débito')
insert into FORMAS_PAGO (Descripcion) values ('MercadoPago (simulado)')

insert into FORMAS_ENTREGA (Descripcion, RequiereDireccion) values ('Retiro en el local', 0)
insert into FORMAS_ENTREGA (Descripcion, RequiereDireccion) values ('Envío a domicilio', 1)

insert into ESTADOS_PEDIDO values ('Pendiente')
insert into ESTADOS_PEDIDO values ('Pagado')
insert into ESTADOS_PEDIDO values ('En preparación')
insert into ESTADOS_PEDIDO values ('Enviado')
insert into ESTADOS_PEDIDO values ('Entregado')
insert into ESTADOS_PEDIDO values ('Cancelado')

insert into EXPANSIONES (Descripcion) values ('Escarlata y Púrpura')
insert into EXPANSIONES (Descripcion) values ('Escarlata y Púrpura 151')
insert into EXPANSIONES (Descripcion) values ('Destinos de Paldea')
insert into EXPANSIONES (Descripcion) values ('Fuerzas Temporales')
insert into EXPANSIONES (Descripcion) values ('Corona Astral')

insert into RAREZAS values ('Común')
insert into RAREZAS values ('Poco común')
insert into RAREZAS values ('Rara')
insert into RAREZAS values ('Rara holo')
insert into RAREZAS values ('Ultra rara')
insert into RAREZAS values ('Rara ilustración')
insert into RAREZAS values ('Rara secreta')

insert into CONDICIONES values ('Mint')
insert into CONDICIONES values ('Near Mint')
insert into CONDICIONES values ('Excelente')
insert into CONDICIONES values ('Jugada')
insert into CONDICIONES values ('Dañada')

insert into IDIOMAS values ('Español')
insert into IDIOMAS values ('Inglés')
insert into IDIOMAS values ('Japonés')

insert into ESTADOS_PUBLICACION values ('Pendiente')
insert into ESTADOS_PUBLICACION values ('Aprobada')
insert into ESTADOS_PUBLICACION values ('Rechazada')

insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Sobre Escarlata y Púrpura 151', 'Sobre de 10 cartas de la expansión 151.', 9500.00, 40, null, 2, 2, null, null, 1, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Sobre Destinos de Paldea', 'Sobre de 10 cartas con chances de Pokémon variocolor.', 11000.00, 30, null, 2, 3, null, null, 2, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Sobre Fuerzas Temporales', 'Sobre de 10 cartas de la expansión Fuerzas Temporales.', 7500.00, 50, null, 2, 4, null, null, 1, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Elite Trainer Box 151', 'Caja con 9 sobres, fundas, dados y accesorios de la expansión 151.', 145000.00, 5, null, 3, 2, null, null, 2, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Caja de 36 sobres Fuerzas Temporales', 'Caja sellada de 36 sobres (booster box).', 240000.00, 3, null, 3, 4, null, null, 1, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Charizard ex 199/165', 'Carta de ilustración especial de la expansión 151.', 120000.00, 1, null, 1, 2, 6, 2, 2, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Pikachu 173/165', 'Carta de ilustración rara de la expansión 151.', 18000.00, 2, null, 1, 2, 6, 1, 1, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Mew ex 151/165', 'Carta publicada por un usuario. Guardada en folio desde que se abrió el sobre.', 15000.00, 1, null, 1, 2, 5, 2, 2, 3, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Gengar 94/165', 'Carta publicada por un usuario, con marcas de uso en los bordes.', 4000.00, 1, null, 1, 2, 4, 4, 1, 3, 1)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Bulbasaur 1/165', 'Carta publicada por un usuario, doblada en una esquina.', 1500.00, 1, null, 1, 2, 1, 5, 1, 3, 3)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion) values ('Fundas Pokémon x65', 'Fundas oficiales para proteger cartas de tamaño estándar.', 9000.00, 60, null, 4, null, null, null, null, 1, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion, IdRareza, IdCondicion, IdIdioma, IdVendedor, IdEstadoPublicacion, Activo) values ('Carpeta 9 bolsillos', 'Carpeta para coleccionar con 20 hojas de 9 bolsillos.', 25000.00, 0, null, 4, null, null, null, null, 1, 2, 0)

insert into PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado) values (3, '2026-10-20 18:30', 164000.00, 2, 2, 1, 2)
insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) values (1, 4, 1, 145000.00)
insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) values (1, 1, 2, 9500.00)
insert into OBSERVACIONES_PEDIDO (IdPedido, IdUsuario, Fecha, Texto) values (1, 1, '2026-10-21 10:15', 'Cliente confirmó pago por transferencia.')

insert into PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado) values (3, '2026-10-25 12:00', 30000.00, 1, 1, null, 1)
insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) values (2, 3, 4, 7500.00)
go
