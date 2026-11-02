using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
// Asegurate de importar tus namespaces de Dominio y Negocio
// using Dominio;
// using Negocio;

namespace ecommerce_web
{
    public partial class Detalle : System.Web.UI.Page
    {
        // Propiedad pública para que el .aspx pueda leerla con <%= ProductoSeleccionado.Nombre %>
        public Producto ProductoSeleccionado { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    // 1. Capturamos el ID que viaja por la URL (ej: Detalle.aspx?id=5)
                    string idStr = Request.QueryString["id"];

                    if (idStr != null && int.TryParse(idStr, out int id))
                    {
                        ProductoNegocio negocio = new ProductoNegocio();

                        // 2. Buscamos el producto en la base de datos
                        ProductoSeleccionado = negocio.ObtenerPorId(id); // (Asegurate de tener este método en tu ProductoNegocio)

                        // Si no existe la carta con ese ID, lo devolvemos al catálogo
                        if (ProductoSeleccionado == null)
                        {
                            Response.Redirect("Default.aspx", false);
                        }
                    }
                    else
                    {
                        // Si no vino ningún ID en la URL, lo mandamos al catálogo
                        Response.Redirect("Default.aspx", false);
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx");
                }
            }
        }
    }
}