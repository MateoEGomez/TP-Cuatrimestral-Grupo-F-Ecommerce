IF COL_LENGTH('Pedidos', 'Moneda') IS NULL
    ALTER TABLE Pedidos ADD Moneda VARCHAR(10) NOT NULL CONSTRAINT DF_Pedidos_Moneda DEFAULT 'USD';

IF COL_LENGTH('Pedidos', 'Cotizacion') IS NULL
    ALTER TABLE Pedidos ADD Cotizacion DECIMAL(18, 2) NULL;
GO

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