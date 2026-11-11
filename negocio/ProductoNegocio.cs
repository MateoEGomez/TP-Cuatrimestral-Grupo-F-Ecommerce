using dominio;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;

namespace negocio
{
    public class ProductoNegocio
    {
        // 1. Método listar clásico actualizado con las nuevas columnas
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
                        aux.IdExpansion = (string)datos.Lector["IdExpansion"];

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
                datosContador.setearConsulta("SELECT COUNT(*) FROM PRODUCTOS WHERE Activo = 1");
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
                                  "FROM PRODUCTOS WHERE Activo = 1 " +
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
                        aux.IdExpansion = (string)datos.Lector["IdExpansion"];

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
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, UrlImagen, Precio, Stock, CardId, IdExpansion FROM Productos WHERE Id = @id");
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

                    if (!(datos.Lector["CardId"] is DBNull))
                        aux.CardId = (string)datos.Lector["CardId"];

                    if (!(datos.Lector["IdExpansion"] is DBNull))
                        aux.IdExpansion = (string)datos.Lector["IdExpansion"];

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

        // 5. Método de Filtrado Dinámico Local (Por nombre, expansión y precio)
        public List<Producto> Filtrar(string nombre, string idExpansion, decimal? precioMin, decimal? precioMax)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = "SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo, CardId, IdExpansion FROM PRODUCTOS WHERE Activo = 1";

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
                        aux.IdExpansion = (string)datos.Lector["IdExpansion"];

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

        // 6. Método que ejecuta la actualización masiva del precio USD-ARS en la BD usando la API
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
                // Valor de respaldo si no hay internet o falla la API
                return 1200.00m;
            }

            return 1200.00m;
        }

        // Método que ejecuta la actualización masiva en la BD usando la API
        public decimal ActualizarPreciosPorApi()
        {
            decimal cotizacion = ObtenerCotizacionDolarBlue();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                // Multiplica el precio base en USD por la cotización obtenida de la API
                datos.setearConsulta("UPDATE Productos SET PrecioARS = Precio * @cotizacion");
                datos.setearParametro("@cotizacion", cotizacion);
                datos.ejecutarAccion();

                return cotizacion; // Devolvemos la cotización aplicada para mostrarla en pantalla
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
    }
}