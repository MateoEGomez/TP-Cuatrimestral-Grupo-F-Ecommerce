using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using dominio;
using negocio;

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
                try
                {
                    CargarEstados();
                    CargarPublicaciones();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }

        private void CargarEstados()
        {
            EstadoPublicacionNegocio negocio = new EstadoPublicacionNegocio();
            ddlEstado.DataSource = negocio.Listar();
            ddlEstado.DataValueField = "Id";
            ddlEstado.DataTextField = "Descripcion";
            ddlEstado.DataBind();
            ddlEstado.Items.Insert(0, new ListItem("Todas", "0"));
            ddlEstado.SelectedValue = "1";
        }

        private void CargarPublicaciones()
        {
            int? idEstado = null;
            if (ddlEstado.SelectedValue != "0")
                idEstado = int.Parse(ddlEstado.SelectedValue);

            ProductoNegocio negocio = new ProductoNegocio();
            List<Producto> lista = negocio.ListarParaModeracion(txtFiltro.Text, idEstado);

            repPublicaciones.DataSource = lista;
            repPublicaciones.DataBind();
            pnlTabla.Visible = lista.Count > 0;
            pnlSinResultados.Visible = lista.Count == 0;
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                pnlMensaje.Visible = false;
                pnlRechazo.Visible = false;
                CargarPublicaciones();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            try
            {
                txtFiltro.Text = "";
                ddlEstado.SelectedValue = "1";
                pnlMensaje.Visible = false;
                pnlRechazo.Visible = false;
                CargarPublicaciones();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void repPublicaciones_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int idProducto))
                return;

            try
            {
                ProductoNegocio negocio = new ProductoNegocio();

                if (e.CommandName == "Aprobar")
                {
                    negocio.ModerarPublicacion(idProducto, 2, null);
                    pnlRechazo.Visible = false;
                    MostrarMensaje("La publicación #" + idProducto + " fue aprobada y ya se ve en la tienda.", "alert-success");
                    CargarPublicaciones();
                }
                else if (e.CommandName == "Rechazar")
                {
                    Producto producto = negocio.ObtenerPorId(idProducto);
                    if (producto == null)
                        return;

                    hfIdRechazo.Value = idProducto.ToString();
                    lblRechazoPublicacion.Text = "#" + idProducto + " - " + HttpUtility.HtmlEncode(producto.Nombre);
                    txtMotivo.Text = "";
                    pnlMensaje.Visible = false;
                    pnlRechazo.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnConfirmarRechazo_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                int idProducto = int.Parse(hfIdRechazo.Value);
                ProductoNegocio negocio = new ProductoNegocio();
                negocio.ModerarPublicacion(idProducto, 3, txtMotivo.Text);

                pnlRechazo.Visible = false;
                MostrarMensaje("La publicación #" + idProducto + " fue rechazada. El vendedor va a ver el motivo en Mis ventas.", "alert-warning");
                CargarPublicaciones();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnCancelarRechazo_Click(object sender, EventArgs e)
        {
            pnlRechazo.Visible = false;
        }

        private void MostrarMensaje(string texto, string claseAlerta)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "alert " + claseAlerta + " mb-4";
            lblMensaje.Text = texto;
        }

        public string FormatearVendedor(object vendedorObj)
        {
            Usuario vendedor = vendedorObj as Usuario;
            if (vendedor == null)
                return "";

            string nombreCompleto = HttpUtility.HtmlEncode((vendedor.Nombre + " " + vendedor.Apellido).Trim());
            string email = HttpUtility.HtmlEncode(vendedor.Email);
            if (nombreCompleto != "")
                return nombreCompleto + "<br/><small class='text-muted'>" + email + "</small>";
            return email;
        }
    }
}
