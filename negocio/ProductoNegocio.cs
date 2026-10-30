using System;
using System.Collections.Generic;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using dominio;

namespace negocio
{
    public class ProductoNegocio
    {
        // 1. Método listar clásico (indispensable para la validación inicial de base vacía)
        public List<Producto> listar()
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo FROM PRODUCTOS");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];

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

        // 2. Método de paginación profesional con OFFSET y FETCH NEXT de SQL Server
        public List<Producto> listarPaginado(int pagina, int registrosPorPagina, out int totalRegistros)
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
                string consulta = "SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo " +
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
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Precio = (decimal)datos.Lector["Precio"];
                    aux.Stock = (int)datos.Lector["Stock"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];

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

        // 3. Método para importar cartas desde la API de Pokémon TCG
        public void importarCartasDesdeAPI()
        {
            string url = "https://api.pokemontcg.io/v2/cards?pageSize=24";

            using (HttpClient client = new HttpClient())
            {
                try
                {
                    HttpResponseMessage response = client.GetAsync(url).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        string jsonResult = response.Content.ReadAsStringAsync().Result;

                        JObject data = JObject.Parse(jsonResult);
                        JArray cartas = (JArray)data["data"];

                        foreach (var carta in cartas)
                        {
                            string nombre = carta["name"]?.ToString() ?? "Sin nombre";
                            string setNombre = carta["set"]?["name"]?.ToString() ?? "Set desconocido";
                            string rareza = carta["rarity"]?.ToString() ?? "Común";
                            string descripcion = $"{setNombre} - Rareza: {rareza}";

                            decimal precio = 1500.00m;
                            try
                            {
                                var marketPrice = carta["tcgplayer"]?["prices"]?["holofoil"]?["market"] ?? carta["tcgplayer"]?["prices"]?["normal"]?["market"];
                                if (marketPrice != null)
                                {
                                    precio = Convert.ToDecimal(marketPrice) * 1000;
                                }
                            }
                            catch { }

                            string urlImagen = carta["images"]?["large"]?.ToString() ?? "";
                            int stock = 15;
                            int idCategoria = 1;

                            AccesoDatos datos = new AccesoDatos();
                            try
                            {
                                datos.setearConsulta("INSERT INTO PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdVendedor, IdEstadoPublicacion, Activo) VALUES (@nombre, @descripcion, @precio, @stock, @urlImagen, @idCategoria, 1, 2, 1)");
                                datos.setearParametro("@nombre", nombre);
                                datos.setearParametro("@descripcion", descripcion);
                                datos.setearParametro("@precio", precio);
                                datos.setearParametro("@stock", stock);
                                datos.setearParametro("@urlImagen", urlImagen);
                                datos.setearParametro("@idCategoria", idCategoria);

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
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }
    }
}