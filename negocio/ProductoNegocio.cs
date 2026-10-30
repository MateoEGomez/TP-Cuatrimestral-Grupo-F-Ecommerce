using dominio;
using Newtonsoft.Json.Linq; // Viene de la librería que instalamos por NuGet
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Xml.Linq;

namespace negocio
{
    public class ProductoNegocio
    {
        public List<Producto> listar()
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo FROM Productos");
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

        // Método para ir a buscar cartas a la API y guardarlas en la base de datos
        public void importarCartasDesdeApi()
        {
            // Pedimos un lote de 12 cartas a la API pública de Pokémon TCG
            string url = "https://api.pokemontcg.io/v2/cards?pageSize=12";

            using (HttpClient client = new HttpClient())
            {
                try
                {
                    HttpResponseMessage response = client.GetAsync(url).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        string jsonResult = response.Content.ReadAsStringAsync().Result;

                        // Parseamos el JSON usando JObject
                        JObject data = JObject.Parse(jsonResult);
                        JArray cartas = (JArray)data["data"];

                        foreach (var carta in cartas)
                        {
                            string nombre = carta["name"]?.ToString() ?? "Sin nombre";
                            string setNombre = carta["set"]?["name"]?.ToString() ?? "Set desconocido";
                            string rareza = carta["rarity"]?.ToString() ?? "Común";
                            string descripcion = $"{setNombre} - Rareza: {rareza}";

                            // Intentamos sacar el precio de mercado, si no tiene asignamos uno por defecto
                            decimal precio = 1500.00m;
                            try
                            {
                                var marketPrice = carta["tcgplayer"]?["prices"]?["holofoil"]?["market"] ?? carta["tcgplayer"]?["prices"]?["normal"]?["market"];
                                if (marketPrice != null)
                                {
                                    precio = Convert.ToDecimal(marketPrice) * 1000; // Un estimativo para adaptarlo
                                }
                            }
                            catch { }

                            string urlImagen = carta["images"]?["large"]?.ToString() ?? "";
                            int stock = 15;
                            int idCategoria = 1; // Asumimos una categoría por defecto (ej: Cartas)

                            // Insertamos en la base de datos con tu clase AccesoDatos
                            AccesoDatos datos = new AccesoDatos();
                            try
                            {
                                datos.setearConsulta("INSERT INTO Productos (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, Activo) VALUES (@nombre, @descripcion, @precio, @stock, @urlImagen, @idCategoria, 1)");
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
                    // Si falla el internet o la API, que no rompa la app, solo lo dejamos pasar o logueamos
                    Console.WriteLine(ex.Message);
                }
            }
        }
    }
}