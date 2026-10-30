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

            // Extraemos únicamente el texto que está después de "Rareza:" para evitar falsos positivos
            string rarezaTexto = descripcion;
            int index = descripcion.IndexOf("Rareza:");
            if (index != -1)
            {
                rarezaTexto = descripcion.Substring(index + 7).Trim();
            }

            // 1. Ultra Raras / GX / V / Secret (Dorado / Amarillo furioso)
            if (rarezaTexto.Contains("GX") || rarezaTexto.Contains("V") || rarezaTexto.Contains("Secret") || rarezaTexto.Contains("Ultra") || rarezaTexto.Contains("VMAX") || rarezaTexto.Contains("VSTAR"))
                return "glow-ultra";

            // 2. Raras / Holo / Radiantes (Violeta / Púrpura intenso)
            if (rarezaTexto.Contains("Rare") || rarezaTexto.Contains("Holo") || rarezaTexto.Contains("Radiant"))
                return "glow-rara";

            // 3. Poco Comunes (Azul)
            if (rarezaTexto.Contains("Uncommon") || rarezaTexto.Contains("Poco común"))
                return "glow-poco-comun";


            // 4. Comunes / Common por defecto (Verde sutil)
            return "glow-comun";
        }
    }
}