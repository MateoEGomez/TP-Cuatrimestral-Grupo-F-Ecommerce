using dominio;
using negocio;
using System;
using System.Web.UI;

namespace ecommerce_web
{
    public partial class Detalle : System.Web.UI.Page
    {
        public Producto ProductoSeleccionado { get; set; }
        public bool EsPublicacionPropia { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string idStr = Request.QueryString["id"];

                    if (idStr != null && int.TryParse(idStr, out int id))
                    {
                        ProductoNegocio negocio = new ProductoNegocio();
                        ProductoSeleccionado = negocio.ObtenerPorId(id);

                        if (ProductoSeleccionado == null)
                        {
                            Response.Redirect("Default.aspx", false);
                            return;
                        }

                        // Usamos Vendedor.Id (porque Producto tiene la propiedad Usuario Vendedor)
                        if (Session["usuario"] != null && ProductoSeleccionado.Vendedor != null)
                        {
                            Usuario user = (Usuario)Session["usuario"];
                            EsPublicacionPropia = (ProductoSeleccionado.Vendedor.Id == user.Id);
                        }
                    }
                    else
                    {
                        Response.Redirect("Default.aspx", false);
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }
    }
}