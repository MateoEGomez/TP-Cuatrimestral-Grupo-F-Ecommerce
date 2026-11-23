use ECOMMERCE_DB
go

Create or alter procedure storedListarPedidosUsuario
@IdUsuario int
as
begin
	select
		P.Id,
		p.Fecha,
		P.Total,
		P.IdFormaPago,
		FP.Descripcion as FormaPago,
		P.IdFormaEntrega,
		FE. Descripcion as FormaEntrega,
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