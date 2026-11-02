using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace ecommerce_web
{
    public partial class Default : System.Web.UI.Page
    {
        // =========================================================
        // PROPIEDADES PÚBLICAS
        // =========================================================
        public List<Producto> ListaProductos { get; set; }
        public int PaginaActual { get; set; } = 1;
        public int TotalPaginas { get; set; } = 1;
        private readonly int registrosPorPagina = 6;

        // Propiedad para renderizar la paginación dinámicamente en el HTML
        public string HtmlPaginacion
        {
            get
            {
                var html = new StringBuilder();
                string setIdActual = ddlSets != null ? ddlSets.SelectedValue : "";
                string queryParam = !string.IsNullOrEmpty(setIdActual) ? $"&set={setIdActual}" : "";

                if (PaginaActual > 1)
                    html.AppendFormat("<li class=\"page-item\"><a class=\"page-link\" href=\"Default.aspx?page={0}{1}\">Anterior</a></li>", PaginaActual - 1, queryParam);
                else
                    html.Append("<li class=\"page-item disabled\"><span class=\"page-link\">Anterior</span></li>");

                for (int i = 1; i <= TotalPaginas; i++)
                {
                    string claseActiva = i == PaginaActual ? " active" : "";
                    html.AppendFormat("<li class=\"page-item{0}\"><a class=\"page-link\" href=\"Default.aspx?page={1}{2}\">{1}</a></li>", claseActiva, i, queryParam);
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
                if (!IsPostBack)
                {
                    CargarSetsDesplegable();

                    // Si venía un set por parámetro o queryString lo seleccionamos
                    if (Request.QueryString["set"] != null && ddlSets != null)
                    {
                        string setIdQuery = Request.QueryString["set"];
                        if (ddlSets.Items.FindByValue(setIdQuery) != null)
                        {
                            ddlSets.SelectedValue = setIdQuery;
                        }
                    }
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
        // MÉTODOS PRIVADOS DE ORGANIZACIÓN
        // =========================================================
        private void CargarSetsDesplegable()
        {
            ProductoNegocio negocio = new ProductoNegocio();
            var sets = negocio.ListarSetsDisponibles();
            ddlSets.DataSource = sets;
            ddlSets.DataTextField = "Name";
            ddlSets.DataValueField = "Id";
            ddlSets.DataBind();
            ddlSets.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccioná una expansión...", ""));
        }

        private void ProcesarPaginacionYGrilla()
        {
            if (Request.QueryString["page"] != null && int.TryParse(Request.QueryString["page"], out int p))
            {
                PaginaActual = p > 0 ? p : 1;
            }

            ProductoNegocio negocio = new ProductoNegocio();
            string setIdSeleccionado = ddlSets != null ? ddlSets.SelectedValue : "";

            // Si hay un set seleccionado, filtramos localmente desde la base de datos
            if (!string.IsNullOrEmpty(setIdSeleccionado))
            {
                var listaFiltrada = negocio.Filtrar(null, setIdSeleccionado, null, null);

                // Paginación manual simple para la lista filtrada
                TotalPaginas = (int)Math.Ceiling((double)listaFiltrada.Count / registrosPorPagina);
                if (TotalPaginas == 0) TotalPaginas = 1;

                if (PaginaActual > TotalPaginas) PaginaActual = TotalPaginas;

                int skip = (PaginaActual - 1) * registrosPorPagina;
                ListaProductos = listaFiltrada.Skip(skip).Take(registrosPorPagina).ToList();
            }
            else
            {
                // Listado general paginado nativo
                int totalRegistros = 0;
                ListaProductos = negocio.ListarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);

                TotalPaginas = (int)Math.Ceiling((double)totalRegistros / registrosPorPagina);
                if (TotalPaginas == 0) TotalPaginas = 1;

                if (PaginaActual > TotalPaginas)
                {
                    PaginaActual = TotalPaginas;
                    ListaProductos = negocio.ListarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);
                }
            }

            repeaterProductos.DataSource = ListaProductos;
            repeaterProductos.DataBind();
        }

        // =========================================================
        // EVENTO: FILTRO POR EXPANSIÓN
        // =========================================================
        protected void ddlSets_SelectedIndexChanged(object sender, EventArgs e)
        {
            string setId = ddlSets.SelectedValue;
            PaginaActual = 1;

            if (string.IsNullOrEmpty(setId))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }

            // Redirigimos conservando el set en la URL para que la paginación funcione perfectamente
            Response.Redirect($"Default.aspx?set={setId}&page=1", false);
        }

        // =========================================================
        // FUNCIÓN AUXILIAR: EFECTO GLOW (Rareza)
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