using dominio;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;

namespace negocio
{
    public class ProductoNegocio
    {
        // 1. Método listar clásico actualizado
        public List<Producto> Listar()
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo, CardId, IdExpansion FROM PRODUCTOS");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                    {
                        aux.Expansion = new Expansion();
                        aux.Expansion.Id = (string)datos.Lector["IdExpansion"];
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

        // 2. Método de paginación profesional con OFFSET y FETCH NEXT
        public List<Producto> ListarPaginado(int pagina, int registrosPorPagina, out int totalRegistros)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            AccesoDatos datosContador = new AccesoDatos();

            try
            {
                datosContador.setearConsulta("SELECT COUNT(*) FROM PRODUCTOS WHERE Activo = 1 AND Stock > 0");
                totalRegistros = datosContador.ejecutarAccionScalar();
            }
            catch (Exception)
            {
                totalRegistros = 0;
            }
            finally
            {
                datosContador.cerrarConexion();
            }

            int offset = (pagina - 1) * registrosPorPagina;

            try
            {
                string consulta = "SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo, CardId, IdExpansion " +
                                  "FROM PRODUCTOS WHERE Activo = 1 AND Stock > 0 " +
                                  "ORDER BY Id " +
                                  "OFFSET @Offset ROWS " +
                                  "FETCH NEXT @PageSize ROWS ONLY";

                datos.setearConsulta(consulta);
                datos.setearParametro("@Offset", offset);
                datos.setearParametro("@PageSize", registrosPorPagina);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                    {
                        aux.Expansion = new Expansion();
                        aux.Expansion.Id = (string)datos.Lector["IdExpansion"];
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

        // 3. Método para obtener un producto por su ID (Detalle)
        public Producto ObtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, UrlImagen, Precio, Stock, CardId, IdExpansion, IdVendedor FROM PRODUCTOS WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                    {
                        aux.Expansion = new Expansion();
                        aux.Expansion.Id = (string)datos.Lector["IdExpansion"];
                    }

                    if (!(datos.Lector["IdVendedor"] is DBNull))
                    {
                        aux.Vendedor = new Usuario();
                        aux.Vendedor.Id = (int)datos.Lector["IdVendedor"];
                    }

                    return aux;
                }
                return null;
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

        public class SetInfo
        {
            public string Id { get; set; }
            public string Name { get; set; }
        }

        // 4. Método para listar los Sets disponibles 100% desde la Base de Datos Local
        public List<SetInfo> ListarSetsDisponibles()
        {
            List<SetInfo> listaSets = new List<SetInfo>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre FROM Expansiones ORDER BY Nombre ASC");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    listaSets.Add(new SetInfo
                    {
                        Id = (string)datos.Lector["Id"],
                        Name = (string)datos.Lector["Nombre"]
                    });
                }
                return listaSets;
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

        // 5. Método de Filtrado Dinámico Local
        public List<Producto> Filtrar(string nombre, string idExpansion, decimal? precioMin, decimal? precioMax)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = "SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo, CardId, IdExpansion FROM PRODUCTOS WHERE Activo = 1 AND Stock > 0";

                if (!string.IsNullOrEmpty(nombre))
                {
                    consulta += " AND Nombre LIKE @nombre";
                }

                if (!string.IsNullOrEmpty(idExpansion) && idExpansion != "0")
                {
                    consulta += " AND IdExpansion = @idExpansion";
                }

                if (precioMin.HasValue)
                {
                    consulta += " AND Precio >= @precioMin";
                }

                if (precioMax.HasValue)
                {
                    consulta += " AND Precio <= @precioMax";
                }

                datos.setearConsulta(consulta);

                if (!string.IsNullOrEmpty(nombre))
                    datos.setearParametro("@nombre", "%" + nombre + "%");

                if (!string.IsNullOrEmpty(idExpansion) && idExpansion != "0")
                    datos.setearParametro("@idExpansion", idExpansion);

                if (precioMin.HasValue)
                    datos.setearParametro("@precioMin", precioMin.Value);

                if (precioMax.HasValue)
                    datos.setearParametro("@precioMax", precioMax.Value);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                    {
                        aux.Expansion = new Expansion();
                        aux.Expansion.Id = (string)datos.Lector["IdExpansion"];
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

        // 6. Cotización Dólar Blue
        private decimal ObtenerCotizacionDolarBlue()
        {
            try
            {
                string url = "https://dolarapi.com/v1/dolares/blue";
                using (HttpClient client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Add("User-Agent", "EcommerceTCG-App");
                    var response = client.GetAsync(url).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string jsonString = response.Content.ReadAsStringAsync().Result;
                        JObject data = JObject.Parse(jsonString);
                        return Convert.ToDecimal(data["venta"]);
                    }
                }
            }
            catch
            {
                return 1200.00m;
            }

            return 1200.00m;
        }

        // 7. Actualización masiva de precios
        public decimal ActualizarPreciosPorApi()
        {
            decimal cotizacion = ObtenerCotizacionDolarBlue();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE Productos SET PrecioARS = Precio * @cotizacion");
                datos.setearParametro("@cotizacion", cotizacion);
                datos.ejecutarAccion();

                return cotizacion;
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

        // 8. Registrar publicación de un cliente
        public void InsertarPublicacionCliente(Producto nuevo, int idVendedor)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = "INSERT INTO PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo, IdExpansion, CardId, IdVendedor) " +
                                  "VALUES (@nombre, @descripcion, @precio, @stock, @urlImagen, @idCategoria, @activo, @idExpansion, @cardId, @idVendedor)";

                datos.setearConsulta(consulta);
                datos.setearParametro("@nombre", nuevo.Nombre);
                datos.setearParametro("@descripcion", (object)nuevo.Descripcion ?? DBNull.Value);
                datos.setearParametro("@precio", nuevo.Precio);
                datos.setearParametro("@stock", 1);
                datos.setearParametro("@urlImagen", (object)nuevo.UrlImagen ?? DBNull.Value);
                datos.setearParametro("@idCategoria", 1);
                datos.setearParametro("@activo", true);
                datos.setearParametro("@idExpansion", (object)nuevo.Expansion?.Id ?? DBNull.Value);
                datos.setearParametro("@cardId", (object)nuevo.CardId ?? DBNull.Value);
                datos.setearParametro("@idVendedor", idVendedor);

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

        // 9. Listar publicaciones de un vendedor específico
        public List<Producto> ListarPorVendedor(int idVendedor)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo, CardId, IdExpansion FROM PRODUCTOS WHERE IdVendedor = @idVendedor");
                datos.setearParametro("@idVendedor", idVendedor);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                    {
                        aux.Expansion = new Expansion();
                        aux.Expansion.Id = (string)datos.Lector["IdExpansion"];
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

        // 10. Pausar o reactivar publicación desde Mis Ventas
        public void CambiarEstadoPublicacion(int idProducto, bool nuevoEstado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE PRODUCTOS SET Activo = @activo WHERE Id = @id");
                datos.setearParametro("@activo", nuevoEstado);
                datos.setearParametro("@id", idProducto);
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

        public List<Producto> ListarAdmin(string filtro)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedListarProductosAdmin");
                datos.setearParametro("@Filtro", filtro);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];
                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Descripcion = (string)datos.Lector["Categoria"];

                    aux.Expansion = new Expansion();
                    if (!(datos.Lector["Expansion"] is DBNull))
                        aux.Expansion.Nombre = (string)datos.Lector["Expansion"];

                    aux.EstadoPublicacion = new EstadoPublicacion();
                    aux.EstadoPublicacion.Descripcion = (string)datos.Lector["EstadoPublicacion"];

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

        public Producto ObtenerParaEditar(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedObtenerProducto");
                datos.setearParametro("@Id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];
                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];
                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                    {
                        aux.Expansion = new Expansion();
                        aux.Expansion.Id = (string)datos.Lector["IdExpansion"];
                    }
                    if (!(datos.Lector["IdRareza"] is DBNull))
                    {
                        aux.Rareza = new Rareza();
                        aux.Rareza.Id = (int)datos.Lector["IdRareza"];
                    }
                    if (!(datos.Lector["IdCondicion"] is DBNull))
                    {
                        aux.Condicion = new Condicion();
                        aux.Condicion.Id = (int)datos.Lector["IdCondicion"];
                    }
                    if (!(datos.Lector["IdIdioma"] is DBNull))
                    {
                        aux.Idioma = new Idioma();
                        aux.Idioma.Id = (int)datos.Lector["IdIdioma"];
                    }

                    return aux;
                }
                return null;
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

        public void InsertarAdmin(Producto nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedAltaProducto");
                CargarParametros(datos, nuevo);
                datos.setearParametro("@IdVendedor", nuevo.Vendedor.Id);
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

        public void Modificar(Producto producto)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedModificarProducto");
                datos.setearParametro("@Id", producto.Id);
                CargarParametros(datos, producto);
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

        public void EliminarLogico(int id, bool activo = false)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedBajaLogicaProducto");
                datos.setearParametro("@Id", id);
                datos.setearParametro("@Activo", activo);
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

        private void CargarParametros(AccesoDatos datos, Producto producto)
        {
            datos.setearParametro("@Nombre", producto.Nombre);
            datos.setearParametro("@Descripcion", producto.Descripcion != null ? (object)producto.Descripcion : DBNull.Value);
            datos.setearParametro("@Precio", producto.Precio);
            datos.setearParametro("@Stock", producto.Stock);
            datos.setearParametro("@UrlImagen", producto.UrlImagen != null ? (object)producto.UrlImagen : DBNull.Value);
            datos.setearParametro("@IdCategoria", producto.Categoria.Id);
            datos.setearParametro("@IdExpansion", producto.Expansion != null ? (object)producto.Expansion.Id : DBNull.Value);
            datos.setearParametro("@IdRareza", producto.Rareza != null ? (object)producto.Rareza.Id : DBNull.Value);
            datos.setearParametro("@IdCondicion", producto.Condicion != null ? (object)producto.Condicion.Id : DBNull.Value);
            datos.setearParametro("@IdIdioma", producto.Idioma != null ? (object)producto.Idioma.Id : DBNull.Value);
            datos.setearParametro("@CardId", producto.CardId != null ? (object)producto.CardId : DBNull.Value);
        }
    }
}