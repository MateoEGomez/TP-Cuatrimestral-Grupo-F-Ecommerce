using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx?volver=checkout", false);
                return;
            }

            try
            {
                if (!IsPostBack)
                {
                    CargarFormasEntrega();
                    CargarFormasPago();
                    CargarDirecciones();
                    ActualizarEstadoDireccion();
                    CargarResumenCarrito();
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private List<DetallePedido> ObtenerCarrito()
        {
            if (Session["carrito"] != null)
                return (List<DetallePedido>)Session["carrito"];

            return new List<DetallePedido>();
        }

        private void CargarFormasEntrega()
        {
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            List<FormaEntrega> lista = negocio.Listar().Where(x => x.Activo).ToList();

            rblFormaEntrega.DataSource = lista;
            rblFormaEntrega.DataTextField = "Descripcion";
            rblFormaEntrega.DataValueField = "Id";
            rblFormaEntrega.DataBind();

            FormaEntrega sinDireccion = lista.FirstOrDefault(x => !x.RequiereDireccion);
            if (sinDireccion != null)
                rblFormaEntrega.SelectedValue = sinDireccion.Id.ToString();
            else if (rblFormaEntrega.Items.Count > 0)
                rblFormaEntrega.SelectedIndex = 0;
        }

        private void CargarFormasPago()
        {
            FormaPagoNegocio negocio = new FormaPagoNegocio();
            List<FormaPago> lista = negocio.Listar().Where(x => x.Activo).ToList();

            rblFormaPago.DataSource = lista;
            rblFormaPago.DataTextField = "Descripcion";
            rblFormaPago.DataValueField = "Id";
            rblFormaPago.DataBind();

            if (rblFormaPago.Items.Count > 0)
                rblFormaPago.SelectedIndex = 0;
        }

        private void CargarDirecciones()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            PedidoNegocio negocio = new PedidoNegocio();

            ddlDirecciones.Items.Clear();
            foreach (Direccion direccion in negocio.ListarDirecciones(usuario.Id))
                ddlDirecciones.Items.Add(new ListItem(direccion.ToString(), direccion.Id.ToString()));
            ddlDirecciones.Items.Add(new ListItem("➕ Nueva dirección", "0"));

            ddlDirecciones.SelectedIndex = 0;
            pnlNuevaDireccion.Visible = ddlDirecciones.SelectedValue == "0";
        }

        protected void rblFormaEntrega_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ActualizarEstadoDireccion();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void ddlDirecciones_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlNuevaDireccion.Visible = ddlDirecciones.SelectedValue == "0";
        }

        private FormaEntrega ObtenerFormaEntregaSeleccionada()
        {
            if (string.IsNullOrEmpty(rblFormaEntrega.SelectedValue))
                return null;

            int idEntrega = int.Parse(rblFormaEntrega.SelectedValue);
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            return negocio.Listar().FirstOrDefault(x => x.Id == idEntrega);
        }

        private void ActualizarEstadoDireccion()
        {
            FormaEntrega seleccionada = ObtenerFormaEntregaSeleccionada();
            bool requiere = seleccionada != null && seleccionada.RequiereDireccion;

            pnlDireccion.Visible = requiere;
            lblTituloPago.Text = requiere ? "3. Forma de Pago" : "2. Forma de Pago";
        }

        private void CargarResumenCarrito()
        {
            List<DetallePedido> carrito = ObtenerCarrito();

            repResumen.DataSource = carrito;
            repResumen.DataBind();

            decimal subtotal = carrito.Sum(x => x.PrecioUnitario * x.Cantidad);
            decimal envio = 0;
            decimal total = subtotal + envio;

            lblSubtotal.Text = subtotal.ToString("C");
            lblEnvio.Text = envio.ToString("C");
            lblTotal.Text = total.ToString("C");

            if (carrito.Count == 0)
            {
                MostrarMensaje("Tu carrito está vacío. Agregá productos antes de confirmar la compra.", "alert-warning");
                pnlCheckout.Visible = false;
            }
        }

        protected void btnConfirmarCompra_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                List<DetallePedido> carrito = ObtenerCarrito();

                if (carrito.Count == 0)
                {
                    MostrarMensaje("No hay productos en el carrito para procesar.", "alert-warning");
                    return;
                }

                PedidoNegocio pedidoNegocio = new PedidoNegocio();
                string errorStock = pedidoNegocio.VerificarStock(carrito);
                if (errorStock != null)
                {
                    MostrarMensaje(errorStock + " Ajustá la cantidad en el carrito.", "alert-danger");
                    return;
                }

                FormaEntrega formaEntrega = ObtenerFormaEntregaSeleccionada();

                Direccion direccion = null;
                if (formaEntrega != null && formaEntrega.RequiereDireccion)
                {
                    direccion = new Direccion();
                    if (ddlDirecciones.SelectedValue != "0")
                    {
                        direccion.Id = int.Parse(ddlDirecciones.SelectedValue);
                    }
                    else
                    {
                        direccion.Calle = txtCalle.Text.Trim();
                        direccion.Numero = txtNumero.Text.Trim();
                        direccion.Localidad = txtLocalidad.Text.Trim();
                        direccion.CodigoPostal = txtCP.Text.Trim();
                        direccion.Observaciones = txtObservaciones.Text.Trim();
                    }
                }

                Pedido nuevoPedido = new Pedido();
                nuevoPedido.Usuario = usuario;
                nuevoPedido.Fecha = DateTime.Now;
                nuevoPedido.Total = carrito.Sum(x => x.PrecioUnitario * x.Cantidad);
                nuevoPedido.FormaPago = new FormaPago();
                nuevoPedido.FormaPago.Id = int.Parse(rblFormaPago.SelectedValue);
                nuevoPedido.FormaEntrega = formaEntrega;
                nuevoPedido.Direccion = direccion;
                nuevoPedido.Estado = new EstadoPedido();
                nuevoPedido.Estado.Id = 1;
                nuevoPedido.Detalles = carrito;

                int idPedido = pedidoNegocio.ConfirmarPedido(nuevoPedido);

                Session["carrito"] = null;
                pnlCheckout.Visible = false;
                MostrarMensaje("¡Compra confirmada con éxito! Tu número de pedido es #" + idPedido + ". Queda en estado Pendiente hasta que se registre el pago.", "alert-success");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void MostrarMensaje(string texto, string claseAlerta)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "alert " + claseAlerta;
            lblMensaje.Text = texto;
        }
    }
}
