use ECOMMERCE_DB
go

create or alter procedure storedListarEstadosPedido
as
	select Id, Descripcion from ESTADOS_PEDIDO order by Id
go

create or alter procedure storedListarPedidosAdmin
	@IdPedido int = null,
	@IdEstado int = null,
	@Desde date = null,
	@Hasta date = null,
	@Cliente varchar(100) = null
as
begin
	select
		P.Id,
		P.Fecha,
		P.Total,
		P.Moneda,
		P.Cotizacion,
		P.IdUsuario,
		U.Email,
		U.Nombre,
		U.Apellido,
		U.Telefono,
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
	inner join USUARIOS U on P.IdUsuario = U.Id
	inner join FORMAS_PAGO FP on P.IdFormaPago = FP.Id
	inner join FORMAS_ENTREGA FE on P.IdFormaEntrega = FE.Id
	inner join ESTADOS_PEDIDO EP on P.IdEstado = EP.Id
	left join DIRECCIONES D on P.IdDireccion = D.Id
	where (@IdPedido is null or P.Id = @IdPedido)
		and (@IdEstado is null or P.IdEstado = @IdEstado)
		and (@Desde is null or cast(P.Fecha as date) >= @Desde)
		and (@Hasta is null or cast(P.Fecha as date) <= @Hasta)
		and (@Cliente is null
			or U.Email like '%' + @Cliente + '%'
			or U.Nombre like '%' + @Cliente + '%'
			or U.Apellido like '%' + @Cliente + '%')
	order by P.Fecha desc, P.Id desc
end
go

create or alter procedure storedCambiarEstadoPedido
	@IdPedido int,
	@IdEstado int
as
begin
	if @IdEstado = 6 and exists (select 1 from PEDIDOS where Id = @IdPedido and IdEstado <> 6)
		update PR set PR.Stock = PR.Stock + DP.Cantidad
		from Productos PR
		inner join DETALLE_PEDIDO DP on DP.IdProducto = PR.Id
		where DP.IdPedido = @IdPedido

	update PEDIDOS set IdEstado = @IdEstado where Id = @IdPedido
end
go

create or alter procedure storedListarObservacionesPedido
	@IdPedido int
as
	select O.Id, O.Fecha, O.Texto, O.IdUsuario, U.Email, U.Nombre
	from OBSERVACIONES_PEDIDO O
	inner join USUARIOS U on O.IdUsuario = U.Id
	where O.IdPedido = @IdPedido
	order by O.Fecha desc, O.Id desc
go

create or alter procedure storedAltaObservacionPedido
	@IdPedido int,
	@IdUsuario int,
	@Texto varchar(500)
as
	insert into OBSERVACIONES_PEDIDO (IdPedido, IdUsuario, Fecha, Texto)
	values (@IdPedido, @IdUsuario, getdate(), @Texto)
go
