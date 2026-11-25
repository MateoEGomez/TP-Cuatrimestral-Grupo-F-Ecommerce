using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;

namespace ecommerce_web
{
    public partial class Default : System.Web.UI.Page
    {
        private static readonly object _lockDolar = new object();
        private static readonly TimeSpan _intervaloActualizacion = TimeSpan.FromHours(1);

        // =========================================================
        // PROPIEDADES PUBLICAS
        // =========================================================
        public List<Producto> ListaProductos { get; set; }
        public int PaginaActual { get; set; } = 1;
        public int TotalPaginas { get; set; } = 1;
        private readonly int registrosPorPagina = 6;

        public string MonedaActual
        {
            get { return Session["moneda"] as string ?? "USD"; }
            set { Session["moneda"] = value; }
        }

        // Propiedad para renderizar la paginacion conservando todos los filtros activos
        public string HtmlPaginacion
        {
            get
            {
                var html = new StringBuilder();
                string queryParam = ConstruirQueryFiltros();

                if (PaginaActual > 1)
                    html.AppendFormat("<li class=\"page-item\"><a class=\"page-link\" href=\"Default.aspx?page={0}{1}\">Anterior</a></li>", PaginaActual - 1, queryParam);
                else
                    html.Append("<li class=\"page-item disabled\"><span class=\"page-link\">Anterior</span></li>");

                bool puntosAgregados = false;
                for (int i = 1; i <= TotalPaginas; i++)
                {
                    bool mostrar = i == 1 || i == TotalPaginas || (i >= PaginaActual - 2 && i <= PaginaActual + 2);

                    if (mostrar)
                    {
                        string claseActiva = i == PaginaActual ? " active" : "";
                        html.AppendFormat("<li class=\"page-item{0}\"><a class=\"page-link\" href=\"Default.aspx?page={1}{2}\">{1}</a></li>", claseActiva, i, queryParam);
                        puntosAgregados = false;
                    }
                    else if (!puntosAgregados)
                    {
                        html.Append("<li class=\"page-item disabled\"><span class=\"page-link\">…</span></li>");
                        puntosAgregados = true;
                    }
                }

                if (PaginaActual < TotalPaginas)
                    html.AppendFormat("<li class=\"page-item\"><a class=\"page-link\" href=\"Default.aspx?page={0}{1}\">Siguiente</a></li>", PaginaActual + 1, queryParam);
                else
                    html.Append("<li class=\"page-item disabled\"><span class=\"page-link\">Siguiente</span></li>");

                return html.ToString();
            }
        }

        // =========================================================
        // EVENTO PRINCIPAL: PAGE LOAD
        // =========================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ActualizarPreciosSiCorresponde();

                if (!IsPostBack)
                {
                    if (ddlMoneda != null)
                        ddlMoneda.SelectedValue = MonedaActual;

                    CargarSetsDesplegable();
                    RestaurarFiltrosDesdeQueryString();
                }

                ProcesarPaginacionYGrilla();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        // =========================================================
        // ACTUALIZACION HORARIA Y MONEDA
        // =========================================================
        public static void ActualizarPreciosSiCorresponde()
        {
            var appState = HttpContext.Current?.Application;
            if (appState == null)
                return;

            DateTime ahora = DateTime.Now;
            DateTime? ultima = appState["UltimaActualizacionDolar"] as DateTime?;

            if (ultima.HasValue && (ahora - ultima.Value) < _intervaloActualizacion)
                return;

            lock (_lockDolar)
            {
                ultima = appState["UltimaActualizacionDolar"] as DateTime?;
                if (ultima.HasValue && (ahora - ultima.Value) < _intervaloActualizacion)
                    return;

                try
                {
                    ProductoNegocio prodNegocio = new ProductoNegocio();
                    decimal cotizacion = prodNegocio.ActualizarPreciosPorApi();
                    appState["CotizacionDolar"] = cotizacion;
                    appState["UltimaActualizacionDolar"] = DateTime.Now;
                }
                catch
                {
                    appState["UltimaActualizacionDolar"] = DateTime.Now.AddMinutes(-50);
                }
            }
        }

        protected void DdlMoneda_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                MonedaActual = ddlMoneda.SelectedValue;
                ProcesarPaginacionYGrilla();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        public bool EsPublicacionDeUsuario(object dataItem)
        {
            Producto prod = dataItem as Producto;
            return prod != null && prod.Vendedor != null && prod.Vendedor.Perfil.Id != 2;
        }

        public string FormatearPrecioProducto(object dataItem)
        {
            if (!(dataItem is Producto prod))
                return "";

            if (MonedaActual == "ARS")
            {
                decimal ars;
                if (prod.PrecioARS.HasValue && prod.PrecioARS.Value > 0)
                {
                    ars = prod.PrecioARS.Value;
                }
                else
                {
                    decimal cotizacion = HttpContext.Current?.Application?["CotizacionDolar"] is decimal d && d > 0 ? d : 1200.00m;
                    ars = prod.Precio * cotizacion;
                }

                return "ARS " + ars.ToString("N2", new CultureInfo("es-AR"));
            }

            return "USD " + prod.Precio.ToString("N2", CultureInfo.InvariantCulture);
        }

        // =========================================================
        // MÉTODOS PRIVADOS DE ORGANIZACION
        // =========================================================
        private void CargarSetsDesplegable()
        {
            ProductoNegocio negocio = new ProductoNegocio();
            var sets = negocio.ListarSetsDisponibles();
            ddlSets.DataSource = sets;
            ddlSets.DataTextField = "Name";
            ddlSets.DataValueField = "Id";
            ddlSets.DataBind();
            ddlSets.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Todas las expansiones...", ""));
        }

        private void RestaurarFiltrosDesdeQueryString()
        {
            if (Request.QueryString["set"] != null && ddlSets != null)
            {
                string setIdQuery = Request.QueryString["set"];
                if (ddlSets.Items.FindByValue(setIdQuery) != null)
                    ddlSets.SelectedValue = setIdQuery;
            }

            if (Request.QueryString["q"] != null && txtBuscarNombre != null)
                txtBuscarNombre.Text = Request.QueryString["q"];

            if (Request.QueryString["min"] != null && txtPrecioMin != null)
                txtPrecioMin.Text = Request.QueryString["min"];

            if (Request.QueryString["max"] != null && txtPrecioMax != null)
                txtPrecioMax.Text = Request.QueryString["max"];

            if (Request.QueryString["sort"] != null && ddlOrden != null)
            {
                string sortQuery = Request.QueryString["sort"];
                if (ddlOrden.Items.FindByValue(sortQuery) != null)
                    ddlOrden.SelectedValue = sortQuery;
            }
        }

        private decimal? ParsearDecimalOpcional(string texto)
        {
            if (string.IsNullOrWhiteSpace(texto))
                return null;

            string normalizado = texto.Trim().Replace(',', '.');
            if (decimal.TryParse(normalizado, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal valor) && valor >= 0)
                return valor;

            return null;
        }

        private string ConstruirQueryFiltros()
        {
            var sb = new StringBuilder();

            string setId = ddlSets != null ? ddlSets.SelectedValue : "";
            string nombre = txtBuscarNombre != null ? txtBuscarNombre.Text.Trim() : "";
            decimal? pMin = txtPrecioMin != null ? ParsearDecimalOpcional(txtPrecioMin.Text) : null;
            decimal? pMax = txtPrecioMax != null ? ParsearDecimalOpcional(txtPrecioMax.Text) : null;
            string orden = ddlOrden != null ? ddlOrden.SelectedValue : "";

            if (!string.IsNullOrEmpty(setId))
                sb.AppendFormat("&set={0}", HttpUtility.UrlEncode(setId));

            if (!string.IsNullOrEmpty(nombre))
                sb.AppendFormat("&q={0}", HttpUtility.UrlEncode(nombre));

            if (pMin.HasValue)
                sb.AppendFormat("&min={0}", pMin.Value.ToString(CultureInfo.InvariantCulture));

            if (pMax.HasValue)
                sb.AppendFormat("&max={0}", pMax.Value.ToString(CultureInfo.InvariantCulture));

            if (!string.IsNullOrEmpty(orden))
                sb.AppendFormat("&sort={0}", HttpUtility.UrlEncode(orden));

            return sb.ToString();
        }

        private void ProcesarPaginacionYGrilla()
        {
            if (Request.QueryString["page"] != null && int.TryParse(Request.QueryString["page"], out int p))
            {
                PaginaActual = p > 0 ? p : 1;
            }

            ProductoNegocio negocio = new ProductoNegocio();
            string setIdSeleccionado = ddlSets != null ? ddlSets.SelectedValue : "";
            string nombreBuscado = txtBuscarNombre != null ? txtBuscarNombre.Text.Trim() : "";
            decimal? precioMin = txtPrecioMin != null ? ParsearDecimalOpcional(txtPrecioMin.Text) : null;
            decimal? precioMax = txtPrecioMax != null ? ParsearDecimalOpcional(txtPrecioMax.Text) : null;

            if (precioMin.HasValue && precioMax.HasValue && precioMin.Value > precioMax.Value)
            {
                decimal aux = precioMin.Value;
                precioMin = precioMax;
                precioMax = aux;
            }

            bool hayFiltros = !string.IsNullOrEmpty(setIdSeleccionado)
                           || !string.IsNullOrEmpty(nombreBuscado)
                           || precioMin.HasValue
                           || precioMax.HasValue;

            string ordenSeleccionado = ddlOrden != null ? ddlOrden.SelectedValue : "";
            bool hayOrden = !string.IsNullOrEmpty(ordenSeleccionado);

            int totalRegistros;

            if (hayFiltros || hayOrden)
            {
                var listaFiltrada = negocio.Filtrar(nombreBuscado, setIdSeleccionado, precioMin, precioMax);

                switch (ordenSeleccionado)
                {
                    case "precio_asc":
                        listaFiltrada = listaFiltrada.OrderBy(x => x.Precio).ToList();
                        break;
                    case "precio_desc":
                        listaFiltrada = listaFiltrada.OrderByDescending(x => x.Precio).ToList();
                        break;
                    case "nombre_asc":
                        listaFiltrada = listaFiltrada.OrderBy(x => x.Nombre).ToList();
                        break;
                    case "nombre_desc":
                        listaFiltrada = listaFiltrada.OrderByDescending(x => x.Nombre).ToList();
                        break;
                }

                totalRegistros = listaFiltrada.Count;

                TotalPaginas = (int)Math.Ceiling((double)totalRegistros / registrosPorPagina);
                if (TotalPaginas == 0) TotalPaginas = 1;
                if (PaginaActual > TotalPaginas) PaginaActual = TotalPaginas;

                int skip = (PaginaActual - 1) * registrosPorPagina;
                ListaProductos = listaFiltrada.Skip(skip).Take(registrosPorPagina).ToList();

                lblResultados.Text = hayFiltros
                    ? $"Se encontraron {totalRegistros} carta(s) con los filtros aplicados."
                    : $"Mostrando {totalRegistros} carta(s) disponibles en el catálogo.";
            }
            else
            {
                ListaProductos = negocio.ListarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);

                TotalPaginas = (int)Math.Ceiling((double)totalRegistros / registrosPorPagina);
                if (TotalPaginas == 0) TotalPaginas = 1;

                if (PaginaActual > TotalPaginas)
                {
                    PaginaActual = TotalPaginas;
                    ListaProductos = negocio.ListarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);
                }

                lblResultados.Text = $"Mostrando {totalRegistros} carta(s) disponibles en el catálogo.";
            }

            pnlSinResultados.Visible = (ListaProductos == null || ListaProductos.Count == 0);

            repeaterProductos.DataSource = ListaProductos;
            repeaterProductos.DataBind();
        }

        private void AplicarFiltros()
        {
            string query = ConstruirQueryFiltros();
            if (string.IsNullOrEmpty(query))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }

            Response.Redirect($"Default.aspx?page=1{query}", false);
        }

        // =========================================================
        // EVENTOS DE BUSQUEDA Y FILTRO
        // =========================================================
        protected void DdlSets_SelectedIndexChanged(object sender, EventArgs e)
        {
            AplicarFiltros();
        }

        protected void ddlOrden_SelectedIndexChanged(object sender, EventArgs e)
        {
            AplicarFiltros();
        }

        protected void BtnFiltrar_Click(object sender, EventArgs e)
        {
            AplicarFiltros();
        }

        protected void BtnLimpiar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx", false);
        }

        // =========================================================
        // FUNCION AUXILIAR: EFECTO GLOW (Rareza)
        // =========================================================
        public string ObtenerClaseGlow(string descripcion)
        {
            if (string.IsNullOrEmpty(descripcion)) return "glow-comun";

            string rarezaTexto = descripcion;
            int index = descripcion.IndexOf("Rareza:");
            if (index != -1)
            {
                rarezaTexto = descripcion.Substring(index + 7).Trim();
            }

            if (rarezaTexto.Contains("GX") || rarezaTexto.Contains("V") || rarezaTexto.Contains("Secret") || rarezaTexto.Contains("Ultra") || rarezaTexto.Contains("VMAX") || rarezaTexto.Contains("VSTAR"))
                return "glow-ultra";

            if (rarezaTexto.Contains("Rare") || rarezaTexto.Contains("Holo") || rarezaTexto.Contains("Radiant"))
                return "glow-rara";

            if (rarezaTexto.Contains("Uncommon") || rarezaTexto.Contains("Poco común"))
                return "glow-poco-comun";

            return "glow-comun";
        }
    }
}