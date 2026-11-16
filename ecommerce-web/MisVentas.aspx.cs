using System;
using System.Collections.Generic;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class MisVentas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                CargarVentasUsuario();
            }
        }

        private void CargarVentasUsuario()
        {
            try
            {
                Usuario user = (Usuario)Session["usuario"];
                ProductoNegocio negocio = new ProductoNegocio();

                // Traemos SOLOS los productos publicados por este usuario
                List<Producto> lista = negocio.ListarPorVendedor(user.Id);

                if (lista != null && lista.Count > 0)
                {
                    rptMisVentas.DataSource = lista;
                    rptMisVentas.DataBind();
                    rptMisVentas.Visible = true;
                    lblMensaje.Visible = false;
                }
                else
                {
                    rptMisVentas.Visible = false;
                    lblMensaje.Visible = true;
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