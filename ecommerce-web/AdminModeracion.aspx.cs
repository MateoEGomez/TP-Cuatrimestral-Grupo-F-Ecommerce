using negocio;
using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ecommerce_web
{
    public partial class AdminModeracion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (!Seguridad.esAdmin(Session["usuario"]))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                CargarPublicaciones();
            }
        }

        private void CargarPublicaciones()
        {
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();
                List<Producto> lista = negocio.ListarParaModeracion(txtFiltro.Text, ddlEstado.SelectedValue);

                if (lista != null && lista.Count > 0)
                {
                    repPublicaciones.DataSource = lista;
                    repPublicaciones.DataBind();
                    pnlTabla.Visible = true;
                    pnlSinResultados.Visible = false;
                }
                else
                {
                    pnlTabla.Visible = false;
                    pnlSinResultados.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            pnlMensaje.Visible = false;
            CargarPublicaciones();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = string.Empty;
            ddlEstado.SelectedValue = "todos";
            pnlMensaje.Visible = false;
            CargarPublicaciones();
        }

        protected void repPublicaciones_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int idProducto))
                return;
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();

                if (e.CommandName == "Activar")
                {
                    negocio.CambiarEstadoPublicacion(idProducto, true);
                    pnlMensaje.Visible = true;
                    pnlMensaje.CssClass = "alert alert-success mb-4";
                    lblMensaje.Text = $"La publicacion #{idProducto} fue aprobada y ya esta visible en la tienda.";
                }
                else if (e.CommandName == "Ocultar")
                {
                    negocio.CambiarEstadoPublicacion(idProducto, false);
                    pnlMensaje.Visible = true;
                    pnlMensaje.CssClass = "alert alert-warning mb-4";
                    lblMensaje.Text = $"La publicacion #{idProducto} fue ocultada de la tienda";
                }

                CargarPublicaciones();
            }
            catch(Exception ex)
            {
                Session.Add("Error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        public string FormatearVendedor(Object vendedorObj)
        {
            if(vendedorObj is Usuario vendedor)
            {
                string nombreCompleto = (vendedor.Nombre + " " + vendedor.Apellido).Trim();
                if (!string.IsNullOrEmpty(nombreCompleto))
                    return $"{nombreCompleto} <br/><small class='text-muted'>{vendedor.Email}</small>";
                return vendedor.Email;
            }
            return "<span class='badge bg-secondary'>Tienda Oficial</span>";
        }
    }
}