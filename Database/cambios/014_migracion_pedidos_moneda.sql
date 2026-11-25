-- 1. Columnas de moneda y cotizacion en PEDIDOS
IF COL_LENGTH('PEDIDOS', 'Moneda') IS NULL
    ALTER TABLE PEDIDOS ADD Moneda VARCHAR(10) NOT NULL CONSTRAINT DF_PEDIDOS_Moneda DEFAULT 'USD';

IF COL_LENGTH('PEDIDOS', 'Cotizacion') IS NULL
    ALTER TABLE PEDIDOS ADD Cotizacion DECIMAL(18, 2) NULL;
GO

-- 2. Actualizar alta de pedido para guardar Moneda y Cotizacion
ALTER PROCEDURE storedAltaPedido
    @IdUsuario INT,
    @Total DECIMAL(18, 2),
    @IdFormaPago INT,
    @IdFormaEntrega INT,
    @IdDireccion INT = NULL,
    @IdEstado INT = 1,
    @Moneda VARCHAR(10) = 'USD',
    @Cotizacion DECIMAL(18, 2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PEDIDOS (IdUsuario, Fecha, Total, IdFormaPago, IdFormaEntrega, IdDireccion, IdEstado, Moneda, Cotizacion)
    OUTPUT INSERTED.Id
    VALUES (@IdUsuario, GETDATE(), @Total, @IdFormaPago, @IdFormaEntrega, @IdDireccion, @IdEstado, @Moneda, @Cotizacion);
END
GO

-- 3. Actualizar listado de pedidos del usuario para devolver Moneda y Cotizacion
ALTER PROCEDURE storedListarPedidosUsuario
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.Id,
        P.Fecha,
        P.Total,
        P.Moneda,
        P.Cotizacion,
        P.IdFormaPago,
        FP.Descripcion AS FormaPago,
        P.IdFormaEntrega,
        FE.Descripcion AS FormaEntrega,
        FE.RequiereDireccion,
        P.IdDireccion,
        D.Calle,
        D.Numero,
        D.Localidad,
        D.CodigoPostal,
        P.IdEstado,
        EP.Descripcion AS Estado
    FROM PEDIDOS P
    INNER JOIN FORMAS_PAGO FP ON P.IdFormaPago = FP.Id
    INNER JOIN FORMAS_ENTREGA FE ON P.IdFormaEntrega = FE.Id
    INNER JOIN ESTADOS_PEDIDO EP ON P.IdEstado = EP.Id
    LEFT JOIN DIRECCIONES D ON P.IdDireccion = D.Id
    WHERE P.IdUsuario = @IdUsuario
    ORDER BY P.Fecha DESC, P.Id DESC;
END
GO