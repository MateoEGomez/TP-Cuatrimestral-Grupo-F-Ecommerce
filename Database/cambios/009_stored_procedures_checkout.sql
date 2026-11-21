use ECOMMERCE_DB
go

create or alter procedure storedListarDireccionesUsuario
	@IdUsuario int
as
	select Id, IdUsuario, Calle, Numero, Localidad, CodigoPostal, Observaciones, Activo
	from DIRECCIONES
	where IdUsuario = @IdUsuario and Activo = 1
	order by Id desc
go

create or alter procedure storedAltaDireccion
	@IdUsuario int,
	@Calle varchar(100),
	@Numero varchar(10),
	@Localidad varchar(100),
	@CodigoPostal varchar(10),
	@Observaciones varchar(200)
as
	insert into DIRECCIONES (IdUsuario, Calle, Numero, Localidad, CodigoPostal, Observaciones, Activo)
	values (@IdUsuario, @Calle, @Numero, @Localidad, @CodigoPostal, @Observaciones, 1)
	select cast(scope_identity() as int)
go

create or alter procedure storedAltaPedido
	@IdUsuario int,
	@Total decimal(18, 2),
	@IdFormaPago int,
	@IdFormaEntrega int,
	@IdDireccion int,
	@IdEstado int
as
	insert into PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado)
	values (@IdUsuario, getdate(), @Total, @IdFormaPago, @IdFormaEntrega, @IdDireccion, @IdEstado)
	select cast(scope_identity() as int)
go

create or alter procedure storedAltaDetallePedido
	@IdPedido int,
	@IdProducto int,
	@Cantidad int,
	@PrecioUnitario decimal(18, 2)
as
	insert into DETALLE_PEDIDO (IdPedido, IdProducto, Cantidad, PrecioUnitario)
	values (@IdPedido, @IdProducto, @Cantidad, @PrecioUnitario)

	update Productos set Stock = Stock - @Cantidad where Id = @IdProducto
go
