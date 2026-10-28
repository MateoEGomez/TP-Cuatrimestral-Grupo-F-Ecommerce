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

insert into CATEGORIAS (Descripcion) values ('Celulares')
insert into CATEGORIAS (Descripcion) values ('Computación')
insert into CATEGORIAS (Descripcion) values ('Audio')
insert into CATEGORIAS (Descripcion) values ('Accesorios')

insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Samsung Galaxy A15', 'Celular de 6,5 pulgadas con 128 GB de almacenamiento y 4 GB de RAM.', 289999.00, 15, null, 1)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Motorola Moto G24', 'Celular de 6,6 pulgadas con 128 GB de almacenamiento y batería de 5000 mAh.', 239999.00, 20, null, 1)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Notebook Lenovo IdeaPad 3', 'Notebook de 15,6 pulgadas, Intel Core i5, 8 GB de RAM y 512 GB SSD.', 849999.00, 6, null, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Monitor LG 24 pulgadas', 'Monitor Full HD IPS de 24 pulgadas con entrada HDMI.', 219999.00, 10, null, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Teclado Logitech K120', 'Teclado USB con cable, resistente a salpicaduras.', 18999.00, 40, null, 2)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Auriculares JBL Tune 520BT', 'Auriculares inalámbricos bluetooth con hasta 57 horas de batería.', 79999.00, 25, null, 3)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Parlante JBL Go 3', 'Parlante bluetooth portátil resistente al agua.', 54999.00, 30, null, 3)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Mouse inalámbrico Logitech M170', 'Mouse inalámbrico con receptor USB.', 14999.00, 50, null, 4)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) values ('Cargador rápido 25W', 'Cargador USB-C de carga rápida compatible con Samsung y Motorola.', 22999.00, 35, null, 4)
insert into PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo) values ('Funda silicona Galaxy A15', 'Funda de silicona para Samsung Galaxy A15.', 7999.00, 0, null, 4, 0)

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

insert into PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado) values (3, '2026-10-20 18:30', 134998.00, 2, 2, 1, 2)
insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) values (1, 6, 1, 79999.00)
insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) values (1, 7, 1, 54999.00)
insert into OBSERVACIONES_PEDIDO (IdPedido, IdUsuario, Fecha, Texto) values (1, 1, '2026-10-21 10:15', 'Cliente confirmó pago por transferencia.')

insert into PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado) values (3, '2026-10-25 12:00', 37998.00, 1, 1, null, 1)
insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario) values (2, 5, 2, 18999.00)
go
