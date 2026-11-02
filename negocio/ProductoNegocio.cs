using System;
using System.Collections.Generic;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using dominio;

namespace negocio
{
    public class ProductoNegocio
    {
        // 1. Método listar clásico
        public List<Producto> Listar()
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

        // 3. Método definitivo para importar TODAS las cartas por tandas de 250
        // Método seguro de importación por tandas controladas (ej: de 250 en 250)
        public void ImportarCartasPorTandasControladas(int paginaInicio = 1, int cantidadPaginasATraer = 4)
        {
            int pageSize = 250; // El límite óptimo por página
            int paginaFin = paginaInicio + cantidadPaginasATraer - 1;

            System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls13;

            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromMinutes(2);
                client.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");

                for (int pagina = paginaInicio; pagina <= paginaFin; pagina++)
                {
                    string url = $"https://api.pokemontcg.io/v2/cards?page={pagina}&pageSize={pageSize}";
                    bool exitoTanda = false;
                    int intentos = 0;

                    // Bucle de reintento por si la API falla intermitentemente (Error 500)
                    while (!exitoTanda && intentos < 3)
                    {
                        try
                        {
                            intentos++;
                            HttpResponseMessage response = client.GetAsync(url).Result;

                            if (response.IsSuccessStatusCode)
                            {
                                string jsonResult = response.Content.ReadAsStringAsync().Result;
                                JObject data = JObject.Parse(jsonResult);
                                JArray cartas = (JArray)data["data"];

                                if (cartas == null || cartas.Count == 0) return;

                                foreach (var carta in cartas)
                                {
                                    string nombre = carta["name"]?.ToString() ?? "Sin nombre";
                                    string setNombre = carta["set"]?["name"]?.ToString() ?? "Set desconocido";
                                    string rareza = carta["rarity"]?.ToString() ?? "Común";
                                    string descripcion = $"{setNombre} - Rareza: {rareza}";

                                    decimal precio = 2500.00m;
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
                                        datos.setearConsulta("INSERT INTO PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) VALUES (@nombre, @descripcion, @precio, @stock, @urlImagen, @idCategoria)");
                                        datos.setearParametro("@nombre", nombre);
                                        datos.setearParametro("@descripcion", descripcion);
                                        datos.setearParametro("@precio", precio);
                                        datos.setearParametro("@stock", stock);
                                        datos.setearParametro("@urlImagen", urlImagen);
                                        datos.setearParametro("@idCategoria", idCategoria);

                                        datos.ejecutarAccion();
                                    }
                                    catch
                                    {
                                        // Ignoramos duplicados
                                    }
                                    finally
                                    {
                                        datos.cerrarConexion();
                                    }
                                }

                                exitoTanda = true; // La tanda se procesó correctamente
                            }
                            else
                            {
                                if (intentos >= 3)
                                {
                                    throw new Exception($"Error HTTP {(int)response.StatusCode} en la página {pagina} tras 3 intentos.");
                                }
                                System.Threading.Thread.Sleep(1000); // Esperar 1 segundo antes de reintentar
                            }
                        }
                        catch (Exception ex)
                        {
                            if (intentos >= 3) throw new Exception("Fallo crítico en tanda: " + ex.Message);
                            System.Threading.Thread.Sleep(1500);
                        }
                    }

                    System.Threading.Thread.Sleep(500); // Pausa de cortesía entre páginas
                }
            }
        }

        // 4. Método para importar cartas de un set específico (Restaurado para que no falle el filtro)
        public void ImportarCartasPorSet(string setId, string nombreSetLegible)
        {
            AccesoDatos datosCheck = new AccesoDatos();
            int cantidadExistente = 0;
            try
            {
                datosCheck.setearConsulta("SELECT COUNT(Id) FROM Productos WHERE Descripcion LIKE @filtro");
                datosCheck.setearParametro("@filtro", $"%{nombreSetLegible}%");
                datosCheck.ejecutarLectura();

                if (datosCheck.Lector.Read())
                {
                    cantidadExistente = Convert.ToInt32(datosCheck.Lector[0]);
                }
            }
            finally
            {
                datosCheck.cerrarConexion();
            }

            // Si ya tenemos cartas de este set descargadas, no volvemos a pegarle a la API
            if (cantidadExistente >= 5) return;

            // Si faltaban, las traemos puntualmente de la API
            string url = $"https://api.pokemontcg.io/v2/cards?q=set.id:{setId}";
            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("User-Agent", "EcommerceTCG-App");
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls13;

                HttpResponseMessage response = client.GetAsync(url).Result;
                if (response.IsSuccessStatusCode)
                {
                    string jsonResult = response.Content.ReadAsStringAsync().Result;
                    JObject data = JObject.Parse(jsonResult);
                    JArray cartas = (JArray)data["data"];

                    if (cartas != null)
                    {
                        foreach (var carta in cartas)
                        {
                            string nombre = carta["name"]?.ToString() ?? "Sin nombre";
                            string setNombre = carta["set"]?["name"]?.ToString() ?? "Set desconocido";
                            string rareza = carta["rarity"]?.ToString() ?? "Común";
                            string descripcion = $"{setNombre} - Rareza: {rareza}";

                            decimal precio = 2500.00m;
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
                                datos.setearConsulta("INSERT INTO PRODUCTOS (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria) VALUES (@nombre, @descripcion, @precio, @stock, @urlImagen, @idCategoria)");
                                datos.setearParametro("@nombre", nombre);
                                datos.setearParametro("@descripcion", descripcion);
                                datos.setearParametro("@precio", precio);
                                datos.setearParametro("@stock", stock);
                                datos.setearParametro("@urlImagen", urlImagen);
                                datos.setearParametro("@idCategoria", idCategoria);

                                datos.ejecutarAccion();
                            }
                            catch { }
                            finally
                            {
                                datos.cerrarConexion();
                            }
                        }
                    }
                }
            }
        }

        // 5. Método para obtener un producto por su ID (Detalle) - Corregido sin etiquetas sueltas
        public Producto ObtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, UrlImagen, Precio, Stock FROM Productos WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];

                    if (!(datos.Lector["UrlImagen"] is DBNull))
                        aux.UrlImagen = (string)datos.Lector["UrlImagen"];

                    aux.Precio = (decimal)datos.Lector["Precio"];
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

        // 6. Método para listar los Sets disponibles en la API (Filtro)
        public List<SetInfo> ListarSetsDisponibles()
        {
            List<SetInfo> listaSets = new List<SetInfo>();
            try
            {
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12 | System.Net.SecurityProtocolType.Tls13;

                using (HttpClient client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
                    string urlApi = "https://api.pokemontcg.io/v2/sets?orderBy=releaseDate";

                    var response = client.GetAsync(urlApi).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        string jsonString = response.Content.ReadAsStringAsync().Result;
                        JObject json = JObject.Parse(jsonString);
                        JArray setsJson = (JArray)json["data"];

                        foreach (var item in setsJson)
                        {
                            listaSets.Add(new SetInfo
                            {
                                Id = item["id"]?.ToString(),
                                Name = item["name"]?.ToString()
                            });
                        }
                    }
                }
            }
            catch (Exception)
            {
                listaSets.Add(new SetInfo { Id = "base1", Name = "Base" });
                listaSets.Add(new SetInfo { Id = "sv1", Name = "Scarlet & Violet" });
                listaSets.Add(new SetInfo { Id = "sval1", Name = "Pokémon 151" });
            }

            return listaSets;
        }
    }
}