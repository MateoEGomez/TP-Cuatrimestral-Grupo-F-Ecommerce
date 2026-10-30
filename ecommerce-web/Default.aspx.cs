using System;
using System.Collections.Generic;
using System.Web.UI;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Default : System.Web.UI.Page
    {
        // ---------------------------------------------------------
        // PROPIEDADES PÚBLICAS (Obligatorias para que las lea Default.aspx)
        // ---------------------------------------------------------
        public List<Producto> ListaProductos { get; set; }
        public int PaginaActual { get; set; } = 1;
        public int TotalPaginas { get; set; } = 1;
        private int registrosPorPagina = 6; // Cantidad de cartas por página

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    // Leer la página actual de la URL (QueryString, ej: Default.aspx?page=2)
                    if (Request.QueryString["page"] != null && int.TryParse(Request.QueryString["page"], out int p))
                    {
                        PaginaActual = p > 0 ? p : 1;
                    }

                    ProductoNegocio negocio = new ProductoNegocio();

                    // Verificación inicial: Si la base está totalmente vacía, importamos de la API
                    List<Producto> listaVerificacion = negocio.listar();
                    if (listaVerificacion == null || listaVerificacion.Count == 0)
                    {
                        negocio.importarCartasDesdeAPI();
                    }

                    // Obtener productos paginados y el total de registros de la BD
                    int totalRegistros = 0;
                    ListaProductos = negocio.listarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);

                    // Calcular el total de páginas redondedo hacia arriba
                    TotalPaginas = (int)Math.Ceiling((double)totalRegistros / registrosPorPagina);
                    if (TotalPaginas == 0) TotalPaginas = 1;

                    // Validar que si piden una página mayor al total, los mande a la última válida
                    if (PaginaActual > TotalPaginas)
                    {
                        PaginaActual = TotalPaginas;
                        ListaProductos = negocio.listarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);
                    }

                    // Enlazar datos al Repeater
                    repeaterProductos.DataSource = ListaProductos;
                    repeaterProductos.DataBind();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx");
                }
            }
        }

        // ---------------------------------------------------------
        // FUNCIÓN AUXILIAR: Efecto Glow / Resplandor por rareza (Idea de Magu)
        // ---------------------------------------------------------
        public string ObtenerClaseGlow(string descripcion)
        {
            if (string.IsNullOrEmpty(descripcion)) return "glow-comun";

            if (descripcion.Contains("Ultra") || descripcion.Contains("Secret") || descripcion.Contains("Secreta"))
                return "glow-ultra";
            if (descripcion.Contains("Rare") || descripcion.Contains("Holo"))
                return "glow-rara";
            if (descripcion.Contains("Poco común") || descripcion.Contains("Uncommon"))
                return "glow-poco-comun";

            return "glow-comun";
        }
    }
}