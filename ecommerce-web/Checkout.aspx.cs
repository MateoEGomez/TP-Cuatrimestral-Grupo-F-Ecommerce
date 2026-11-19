using System;
using System.Collections.Generic;
using System.Linq;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Verificamos que el usuario esté logueado para poder comprar
                if (Session["usuario"] == null)
                {
                    Response.Redirect("Login.aspx", false);
                    return;
                }

                if (!IsPostBack)
                {
                    CargarFormasEntrega();
                    CargarFormasPago();
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

            if (rblFormaEntrega.Items.Count > 0)
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

        protected void rblFormaEntrega_SelectedIndexChanged(object sender, EventArgs e)
        {
            ActualizarEstadoDireccion();
        }

        private void ActualizarEstadoDireccion()
        {
            if (string.IsNullOrEmpty(rblFormaEntrega.SelectedValue)) return;

            int idEntrega = int.Parse(rblFormaEntrega.SelectedValue);
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            FormaEntrega seleccionada = negocio.Listar().FirstOrDefault(x => x.Id == idEntrega);

            bool requiere = seleccionada != null && seleccionada.RequiereDireccion;

            txtCalle.Enabled = requiere;
            txtNumero.Enabled = requiere;
            txtLocalidad.Enabled = requiere;
            txtCP.Enabled = requiere;
            txtObservaciones.Enabled = requiere;
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
                btnConfirmarCompra.Enabled = false;
            }
        }

        protected void btnConfirmarCompra_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                List<DetallePedido> carrito = ObtenerCarrito();

                if (usuario == null)
                {
                    Response.Redirect("Login.aspx", false);
                    return;
                }

                if (carrito.Count == 0)
                {
                    MostrarMensaje("No hay productos en el carrito para procesar.", "alert-warning");
                    return;
                }

                int idFormaEntrega = int.Parse(rblFormaEntrega.SelectedValue);
                int idFormaPago = int.Parse(rblFormaPago.SelectedValue);

                FormaEntregaNegocio entregaNegocio = new FormaEntregaNegocio();
                FormaEntrega formaEntrega = entregaNegocio.Listar().FirstOrDefault(x => x.Id == idFormaEntrega);

                Direccion direccion = null;
                if (formaEntrega != null && formaEntrega.RequiereDireccion)
                {
                    if (string.IsNullOrWhiteSpace(txtCalle.Text) ||
                        string.IsNullOrWhiteSpace(txtNumero.Text) ||
                        string.IsNullOrWhiteSpace(txtLocalidad.Text) ||
                        string.IsNullOrWhiteSpace(txtCP.Text))
                    {
                        MostrarMensaje("Completá Calle, Número, Localidad y Código Postal para el envío a domicilio.", "alert-danger");
                        return;
                    }

                    direccion = new Direccion
                    {
                        Calle = txtCalle.Text.Trim(),
                        Numero = txtNumero.Text.Trim(),
                        Localidad = txtLocalidad.Text.Trim(),
                        CodigoPostal = txtCP.Text.Trim(),
                        Observaciones = txtObservaciones.Text.Trim()
                    };
                }

                decimal total = carrito.Sum(x => x.PrecioUnitario * x.Cantidad);

                Pedido nuevoPedido = new Pedido
                {
                    Usuario = usuario,
                    Fecha = DateTime.Now,
                    Total = total,
                    FormaPago = new FormaPago { Id = idFormaPago },
                    FormaEntrega = formaEntrega,
                    Direccion = direccion,
                    Estado = new EstadoPedido { Id = 1 },
                    Detalles = carrito
                };

                PedidoNegocio pedidoNegocio = new PedidoNegocio();
                int idPedido = pedidoNegocio.ConfirmarPedido(nuevoPedido);

                // Vaciamos el carrito y avisamos
                Session["carrito"] = null;
                btnConfirmarCompra.Enabled = false;
                MostrarMensaje($"¡Compra confirmada con éxito! Tu número de pedido es #{idPedido}.", "alert-success");
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
            pnlMensaje.CssClass = $"alert {claseAlerta}";
            lblMensaje.Text = texto;
        }
    }
}