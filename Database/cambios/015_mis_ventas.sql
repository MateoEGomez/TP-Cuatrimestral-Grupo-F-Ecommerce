CREATE PROCEDURE storedListarVentasVendedor
    @IdVendedor INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.Id AS IdPedido,
        P.Fecha,
        P.IdEstado,
        EP.Descripcion AS Estado,
        PR.Id AS IdProducto,
        PR.Nombre AS ProductoNombre,
        PR.UrlImagen,
        DP.Cantidad,
        DP.PrecioUnitario
    FROM PEDIDOS P
    INNER JOIN ESTADOS_PEDIDO EP ON P.IdEstado = EP.Id
    INNER JOIN DETALLE_PEDIDO DP ON DP.IdPedido = P.Id
    INNER JOIN PRODUCTOS PR ON PR.Id = DP.IdProducto
    -- Si tu tabla PRODUCTOS tiene IdUsuario / IdVendedor, descomentá y ajustá la columna:
    -- WHERE PR.IdUsuario = @IdVendedor
    ORDER BY P.Fecha DESC, P.Id DESC, DP.Id ASC;
END
GO