using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using dominio;
using negocio;

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

                if (PaginaActual > 1)
                    html.AppendFormat("<li class=\"page-item\"><a class=\"page-link\" href=\"Default.aspx?page={0}\">Anterior</a></li>", PaginaActual - 1);
                else
                    html.Append("<li class=\"page-item disabled\"><span class=\"page-link\">Anterior</span></li>");

                for (int i = 1; i <= TotalPaginas; i++)
                {
                    string claseActiva = i == PaginaActual ? " active" : "";
                    html.AppendFormat("<li class=\"page-item{0}\"><a class=\"page-link\" href=\"Default.aspx?page={1}\">{1}</a></li>", claseActiva, i);
                }

                if (PaginaActual < TotalPaginas)
                    html.AppendFormat("<li class=\"page-item\"><a class=\"page-link\" href=\"Default.aspx?page={0}\">Siguiente</a></li>", PaginaActual + 1);
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
                    VerificarBaseVaciaEImportar();
                }

                // La paginación y carga de grilla corre siempre (postbacks y cargas iniciales)
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

        private void VerificarBaseVaciaEImportar()
        {
            ProductoNegocio negocio = new ProductoNegocio();
            List<Producto> listaVerificacion = negocio.Listar();
            if (listaVerificacion == null || listaVerificacion.Count == 0)
            {
                try
                {
                    negocio.ImportarCartasPorTandasControladas(1, 1);
                }
                catch (Exception ex)
                {
                    // Si la API externa da error 500, lo registramos pero dejamos cargar la app
                    System.Diagnostics.Debug.WriteLine("Aviso: No se pudo conectar a la API TCG: " + ex.Message);
                }
            }
        }

        private void ProcesarPaginacionYGrilla()
        {
            if (Request.QueryString["page"] != null && int.TryParse(Request.QueryString["page"], out int p))
            {
                PaginaActual = p > 0 ? p : 1;
            }

            ProductoNegocio negocio = new ProductoNegocio();
            int totalRegistros = 0;

            ListaProductos = negocio.ListarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);

            TotalPaginas = (int)Math.Ceiling((double)totalRegistros / registrosPorPagina);
            if (TotalPaginas == 0) TotalPaginas = 1;

            if (PaginaActual > TotalPaginas)
            {
                PaginaActual = TotalPaginas;
                ListaProductos = negocio.ListarPaginado(PaginaActual, registrosPorPagina, out totalRegistros);
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
            string setNombre = ddlSets.SelectedItem.Text;

            if (string.IsNullOrEmpty(setId)) return;

            ProductoNegocio negocio = new ProductoNegocio();

            try
            {
                negocio.ImportarCartasPorSet(setId, setNombre);

                var listaCompleta = negocio.Listar();
                ListaProductos = listaCompleta.FindAll(x => x.Descripcion != null && x.Descripcion.Contains(setNombre));

                if (ListaProductos == null || ListaProductos.Count == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('La expansión seleccionada no contiene cartas disponibles en este momento o es un set especial.');", true);
                    return;
                }

                PaginaActual = 1;
                TotalPaginas = 1;

                repeaterProductos.DataSource = ListaProductos;
                repeaterProductos.DataBind();
            }
            catch (Exception ex)
            {
                string mensajeSeguro = ex.Message.Replace("'", "").Replace("\r", "").Replace("\n", " ");
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Atención: {mensajeSeguro}');", true);
            }
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