use ECOMMERCE_DB
go

create or alter procedure storedListarDetallePedido
	@IdPedido int
as
begin
	select
		DP.IdProducto,
		PR.Nombre as ProductoNombre,
		PR.UrlImagen,
		DP.Cantidad,
		DP.PrecioUnitario
	from DETALLE_PEDIDO DP
	inner join Productos PR on DP.IdProducto = PR.Id
	where DP.IdPedido = @IdPedido
end
go