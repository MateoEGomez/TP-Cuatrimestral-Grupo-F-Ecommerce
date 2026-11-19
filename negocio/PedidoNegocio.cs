using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class PedidoNegocio
    {
        public int AgregarDireccion(Direccion dir)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedAltaDireccion");
                datos.setearParametro("@IdUsuario", dir.IdUsuario);
                datos.setearParametro("@Calle", dir.Calle);
                datos.setearParametro("@Numero", dir.Numero);
                datos.setearParametro("@Localidad", dir.Localidad);
                datos.setearParametro("@CodigoPostal", dir.CodigoPostal);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(dir.Observaciones) ? (object)DBNull.Value : dir.Observaciones);

                return datos.ejecutarAccionScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public int ConfirmarPedido(Pedido pedido)
        {
            int? idDireccionGenerada = null;

            // 1. Si la forma de entrega requiere dirección, la guardamos primero
            if (pedido.FormaEntrega != null && pedido.FormaEntrega.RequiereDireccion && pedido.Direccion != null)
            {
                pedido.Direccion.IdUsuario = pedido.Usuario.Id;
                idDireccionGenerada = AgregarDireccion(pedido.Direccion);
            }

            // 2. Insertamos la cabecera del Pedido
            AccesoDatos datosPedido = new AccesoDatos();
            int idPedidoGenerado;
            try
            {
                datosPedido.setearProcedimiento("storedAltaPedido");
                datosPedido.setearParametro("@IdUsuario", pedido.Usuario.Id);
                datosPedido.setearParametro("@Total", pedido.Total);
                datosPedido.setearParametro("@IdFormaPago", pedido.FormaPago.Id);
                datosPedido.setearParametro("@IdFormaEntrega", pedido.FormaEntrega.Id);
                datosPedido.setearParametro("@IdDireccion", idDireccionGenerada.HasValue ? (object)idDireccionGenerada.Value : DBNull.Value);
                datosPedido.setearParametro("@IdEstado", 1); // 1 = Pendiente

                idPedidoGenerado = datosPedido.ejecutarAccionScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datosPedido.cerrarConexion();
            }

            // 3. Insertamos cada ítem en DETALLE_PEDIDO y descontamos stock
            if (pedido.Detalles != null)
            {
                foreach (DetallePedido item in pedido.Detalles)
                {
                    AccesoDatos datosDetalle = new AccesoDatos();
                    try
                    {
                        datosDetalle.setearProcedimiento("storedAltaDetallePedido");
                        datosDetalle.setearParametro("@IdPedido", idPedidoGenerado);
                        datosDetalle.setearParametro("@IdProducto", item.Producto.Id);
                        datosDetalle.setearParametro("@Cantidad", item.Cantidad);
                        datosDetalle.setearParametro("@PrecioUnitario", item.PrecioUnitario);
                        datosDetalle.ejecutarAccion();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                    finally
                    {
                        datosDetalle.cerrarConexion();
                    }
                }
            }

            return idPedidoGenerado;
        }
    }
}