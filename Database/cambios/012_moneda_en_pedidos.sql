use ECOMMERCE_DB
go

if COL_LENGTH('PEDIDOS', 'Moneda') is null
	alter table PEDIDOS add Moneda varchar(3) not null constraint DF_PEDIDOS_Moneda default 'USD'
go

if COL_LENGTH('PEDIDOS', 'Cotizacion') is null
	alter table PEDIDOS add Cotizacion decimal(18, 2) null
go

create or alter procedure storedAltaPedido
	@IdUsuario int,
	@Total decimal(18, 2),
	@IdFormaPago int,
	@IdFormaEntrega int,
	@IdDireccion int,
	@IdEstado int,
	@Moneda varchar(3) = 'USD',
	@Cotizacion decimal(18, 2) = null
as
	insert into PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado, Moneda, Cotizacion)
	values (@IdUsuario, getdate(), @Total, @IdFormaPago, @IdFormaEntrega, @IdDireccion, @IdEstado, @Moneda, @Cotizacion)
	select cast(scope_identity() as int)
go

create or alter procedure storedListarPedidosUsuario
	@IdUsuario int
as
begin
	select
		P.Id,
		P.Fecha,
		P.Total,
		P.Moneda,
		P.Cotizacion,
		P.IdFormaPago,
		FP.Descripcion as FormaPago,
		P.IdFormaEntrega,
		FE.Descripcion as FormaEntrega,
		FE.RequiereDireccion,
		P.IdDireccion,
		D.Calle,
		D.Numero,
		D.Localidad,
		D.CodigoPostal,
		P.IdEstado,
		EP.Descripcion as Estado
	from PEDIDOS P
	inner join FORMAS_PAGO FP on P.IdFormaPago = FP.Id
	inner join FORMAS_ENTREGA FE on P.IdFormaEntrega = FE.Id
	inner join ESTADOS_PEDIDO EP on P.IdEstado = EP.Id
	left join DIRECCIONES D on P.IdDireccion = D.Id
	where P.IdUsuario = @IdUsuario
	order by P.Fecha desc, P.Id desc
end
go
