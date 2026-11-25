using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class PedidoNegocio
    {
        public List<Direccion> ListarDirecciones(int idUsuario)
        {
            List<Direccion> lista = new List<Direccion>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedListarDireccionesUsuario");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Direccion aux = new Direccion();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.IdUsuario = (int)datos.Lector["IdUsuario"];
                    aux.Calle = (string)datos.Lector["Calle"];
                    aux.Numero = (string)datos.Lector["Numero"];
                    aux.Localidad = (string)datos.Lector["Localidad"];
                    aux.CodigoPostal = (string)datos.Lector["CodigoPostal"];
                    if (!(datos.Lector["Observaciones"] is DBNull))
                        aux.Observaciones = (string)datos.Lector["Observaciones"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(aux);
                }
                return lista;
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

        public List<Pedido> ListarPorUsuario(int idUsuario)
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarPedidosUsuario");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                while(datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    aux.Moneda = (string)datos.Lector["Moneda"];
                    if (!(datos.Lector["Cotizacion"] is DBNull))
                        aux.Cotizacion = (decimal)datos.Lector["Cotizacion"];

                    aux.FormaPago = new FormaPago
                    {
                        Id = (int)datos.Lector["IdFormaPago"],
                        Descripcion = (string)datos.Lector["FormaPago"]
                    };

                    aux.FormaEntrega = new FormaEntrega
                    {
                        Id = (int)datos.Lector["IdFormaEntrega"],
                        Descripcion = (string)datos.Lector["FormaEntrega"],
                        RequiereDireccion = (bool)datos.Lector["RequiereDireccion"]
                    };

                    aux.Estado = new EstadoPedido
                    {
                        Id = (int)datos.Lector["IdEstado"],
                        Descripcion = (string)datos.Lector["Estado"]
                    };

                    if (!(datos.Lector["IdDireccion"] is DBNull))
                    {
                        aux.Direccion = new Direccion
                        {
                            Id = (int)datos.Lector["IdDireccion"],
                            Calle = (String)datos.Lector["Calle"],
                            Numero = (string)datos.Lector["Numero"],
                            Localidad = (string)datos.Lector["Localidad"],
                            CodigoPostal = (string)datos.Lector["CodigoPostal"]
                        };
                    }
                    lista.Add(aux);
                }
                return lista;
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

        public List<DetallePedido> ListarDetallePedido(int idPedido)
        {
            List<DetallePedido> lista = new List<DetallePedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarDetallePedido");
                datos.setearParametro("@IdPedido", idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    DetallePedido item = new DetallePedido();
                    item.Producto = new Producto
                    {
                        Id = (int)datos.Lector["idProducto"],
                        Nombre = (string)datos.Lector["ProductoNombre"],
                        UrlImagen = datos.Lector["UrlImagen"] is DBNull ? null : (string)datos.Lector["UrlImagen"]
                    };
                    item.Cantidad = (int)datos.Lector["Cantidad"];
                    item.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];

                    lista.Add(item);
                }
                return lista;
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

        public List<Pedido> ListarAdmin(int? idEstado, DateTime? desde, DateTime? hasta, string cliente)
        {
            return ListarPedidos(null, idEstado, desde, hasta, cliente);
        }

        public Pedido ObtenerPorId(int idPedido)
        {
            List<Pedido> lista = ListarPedidos(idPedido, null, null, null, null);
            return lista.Count > 0 ? lista[0] : null;
        }

        private List<Pedido> ListarPedidos(int? idPedido, int? idEstado, DateTime? desde, DateTime? hasta, string cliente)
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarPedidosAdmin");
                datos.setearParametro("@IdPedido", idPedido.HasValue ? (object)idPedido.Value : DBNull.Value);
                datos.setearParametro("@IdEstado", idEstado.HasValue ? (object)idEstado.Value : DBNull.Value);
                datos.setearParametro("@Desde", desde.HasValue ? (object)desde.Value.Date : DBNull.Value);
                datos.setearParametro("@Hasta", hasta.HasValue ? (object)hasta.Value.Date : DBNull.Value);
                datos.setearParametro("@Cliente", string.IsNullOrWhiteSpace(cliente) ? (object)DBNull.Value : cliente.Trim());
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    aux.Moneda = (string)datos.Lector["Moneda"];
                    if (!(datos.Lector["Cotizacion"] is DBNull))
                        aux.Cotizacion = (decimal)datos.Lector["Cotizacion"];

                    aux.Usuario = new Usuario
                    {
                        Id = (int)datos.Lector["IdUsuario"],
                        Email = (string)datos.Lector["Email"],
                        Nombre = datos.Lector["Nombre"] is DBNull ? null : (string)datos.Lector["Nombre"],
                        Apellido = datos.Lector["Apellido"] is DBNull ? null : (string)datos.Lector["Apellido"],
                        Telefono = datos.Lector["Telefono"] is DBNull ? null : (string)datos.Lector["Telefono"]
                    };

                    aux.FormaPago = new FormaPago
                    {
                        Id = (int)datos.Lector["IdFormaPago"],
                        Descripcion = (string)datos.Lector["FormaPago"]
                    };

                    aux.FormaEntrega = new FormaEntrega
                    {
                        Id = (int)datos.Lector["IdFormaEntrega"],
                        Descripcion = (string)datos.Lector["FormaEntrega"],
                        RequiereDireccion = (bool)datos.Lector["RequiereDireccion"]
                    };

                    aux.Estado = new EstadoPedido
                    {
                        Id = (int)datos.Lector["IdEstado"],
                        Descripcion = (string)datos.Lector["Estado"]
                    };

                    if (!(datos.Lector["IdDireccion"] is DBNull))
                    {
                        aux.Direccion = new Direccion
                        {
                            Id = (int)datos.Lector["IdDireccion"],
                            Calle = (string)datos.Lector["Calle"],
                            Numero = (string)datos.Lector["Numero"],
                            Localidad = (string)datos.Lector["Localidad"],
                            CodigoPostal = (string)datos.Lector["CodigoPostal"]
                        };
                    }
                    lista.Add(aux);
                }
                return lista;
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

        public void CambiarEstado(int idPedido, int idEstado)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedCambiarEstadoPedido");
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdEstado", idEstado);
                datos.ejecutarAccion();
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

        public List<ObservacionPedido> ListarObservaciones(int idPedido)
        {
            List<ObservacionPedido> lista = new List<ObservacionPedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarObservacionesPedido");
                datos.setearParametro("@IdPedido", idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ObservacionPedido aux = new ObservacionPedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];
                    aux.Texto = (string)datos.Lector["Texto"];
                    aux.Usuario = new Usuario
                    {
                        Id = (int)datos.Lector["IdUsuario"],
                        Email = (string)datos.Lector["Email"],
                        Nombre = datos.Lector["Nombre"] is DBNull ? null : (string)datos.Lector["Nombre"]
                    };

                    lista.Add(aux);
                }
                return lista;
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

        public void AgregarObservacion(int idPedido, ObservacionPedido observacion)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaObservacionPedido");
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdUsuario", observacion.Usuario.Id);
                datos.setearParametro("@Texto", observacion.Texto);
                datos.ejecutarAccion();
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

        public string VerificarStock(List<DetallePedido> detalles)
        {
            ProductoNegocio productoNegocio = new ProductoNegocio();
            foreach (DetallePedido item in detalles)
            {
                Producto actual = productoNegocio.ObtenerPorId(item.Producto.Id);
                if (actual == null || !actual.Activo)
                    return "El producto \"" + item.Producto.Nombre + "\" ya no está disponible.";
                if (actual.Stock < item.Cantidad)
                    return "No hay stock suficiente de \"" + actual.Nombre + "\": quedan " + actual.Stock + " unidad(es).";
            }
            return null;
        }

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
                if (pedido.Direccion.Id != 0)
                {
                    idDireccionGenerada = pedido.Direccion.Id;
                }
                else
                {
                    pedido.Direccion.IdUsuario = pedido.Usuario.Id;
                    idDireccionGenerada = AgregarDireccion(pedido.Direccion);
                }
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
                datosPedido.setearParametro("@Moneda", string.IsNullOrEmpty(pedido.Moneda) ? "USD" : pedido.Moneda);
                datosPedido.setearParametro("@Cotizacion", pedido.Cotizacion.HasValue ? (object)pedido.Cotizacion.Value : DBNull.Value);

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