use ECOMMERCE_DB
go

create or alter procedure storedListarVentasVendedor
	@IdVendedor int
as
begin
	select
		P.Id as IdPedido,
		P.Fecha,
		P.IdEstado,
		EP.Descripcion as Estado,
		DP.IdProducto,
		PR.Nombre as ProductoNombre,
		PR.UrlImagen,
		DP.Cantidad,
		DP.PrecioUnitario
	from DETALLE_PEDIDO DP
	inner join PEDIDOS P on DP.IdPedido = P.Id
	inner join ESTADOS_PEDIDO EP on P.IdEstado = EP.Id
	inner join Productos PR on DP.IdProducto = PR.Id
	where PR.IdVendedor = @IdVendedor
	order by P.Fecha desc, P.Id desc
end
go
