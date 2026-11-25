using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Checkout : System.Web.UI.Page
    {
        private string MonedaActual
        {
            get { return Session["moneda"] as string ?? "USD"; }
        }

        private decimal CotizacionActual
        {
            get
            {
                return HttpContext.Current?.Application?["CotizacionDolar"] is decimal d && d > 0
                    ? d
                    : 1200.00m;
            }
        }

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
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Session["usuario"] == null || !pnlCheckout.Visible)
                return;

            try
            {
                CargarResumenCarrito();
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

        private decimal ObtenerPrecioUnitarioEnMoneda(DetallePedido item)
        {
            if (item == null)
                return 0m;

            if (MonedaActual == "ARS")
            {
                if (item.Producto != null && item.Producto.PrecioARS.HasValue && item.Producto.PrecioARS.Value > 0)
                    return item.Producto.PrecioARS.Value;

                return item.PrecioUnitario * CotizacionActual;
            }

            return item.PrecioUnitario;
        }

        private string FormatearMonto(decimal monto)
        {
            if (MonedaActual == "ARS")
                return "ARS " + monto.ToString("N2", new CultureInfo("es-AR"));

            return "USD " + monto.ToString("N2", CultureInfo.InvariantCulture);
        }

        public string FormatearSubtotalItem(object dataItem)
        {
            if (!(dataItem is DetallePedido item))
                return "";

            decimal subtotalItem = ObtenerPrecioUnitarioEnMoneda(item) * item.Cantidad;
            return FormatearMonto(subtotalItem);
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

            if (!int.TryParse(rblFormaEntrega.SelectedValue, out int idEntrega))
                return null;

            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            return negocio.Listar().FirstOrDefault(x => x.Id == idEntrega && x.Activo);
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

            decimal subtotal = carrito.Sum(x => ObtenerPrecioUnitarioEnMoneda(x) * x.Cantidad);
            decimal envio = 0m;
            decimal total = subtotal + envio;

            lblSubtotal.Text = FormatearMonto(subtotal);
            lblEnvio.Text = FormatearMonto(envio);
            lblTotal.Text = FormatearMonto(total);

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

                FormaEntrega formaEntrega = ObtenerFormaEntregaSeleccionada();
                if (formaEntrega == null)
                {
                    MostrarMensaje("Seleccioná una forma de entrega válida.", "alert-warning");
                    return;
                }

                if (string.IsNullOrEmpty(rblFormaPago.SelectedValue) || !int.TryParse(rblFormaPago.SelectedValue, out int idFormaPago))
                {
                    MostrarMensaje("Seleccioná una forma de pago válida.", "alert-warning");
                    return;
                }

                Direccion direccion = null;
                if (formaEntrega.RequiereDireccion)
                {
                    if (ddlDirecciones.SelectedValue != "0")
                    {
                        if (!int.TryParse(ddlDirecciones.SelectedValue, out int idDir) || idDir <= 0)
                        {
                            MostrarMensaje("Seleccioná una dirección de envío válida.", "alert-warning");
                            return;
                        }
                        direccion = new Direccion { Id = idDir };
                    }
                    else
                    {
                        string calle = txtCalle.Text.Trim();
                        string numero = txtNumero.Text.Trim();
                        string localidad = txtLocalidad.Text.Trim();
                        string cp = txtCP.Text.Trim();

                        if (string.IsNullOrWhiteSpace(calle) ||
                            string.IsNullOrWhiteSpace(numero) ||
                            string.IsNullOrWhiteSpace(localidad) ||
                            string.IsNullOrWhiteSpace(cp))
                        {
                            MostrarMensaje("Completá todos los campos obligatorios de la nueva dirección de envío.", "alert-warning");
                            return;
                        }

                        direccion = new Direccion
                        {
                            Calle = calle,
                            Numero = numero,
                            Localidad = localidad,
                            CodigoPostal = cp,
                            Observaciones = txtObservaciones.Text.Trim()
                        };
                    }
                }

                PedidoNegocio pedidoNegocio = new PedidoNegocio();
                string errorStock = pedidoNegocio.VerificarStock(carrito);
                if (errorStock != null)
                {
                    MostrarMensaje(errorStock + " Revisá tu carrito.", "alert-danger");
                    return;
                }

                Pedido nuevoPedido = new Pedido();
                nuevoPedido.Usuario = usuario;
                nuevoPedido.Fecha = DateTime.Now;
                nuevoPedido.Total = carrito.Sum(x => x.PrecioUnitario * x.Cantidad);
                nuevoPedido.Moneda = MonedaActual;
                if (MonedaActual == "ARS")
                    nuevoPedido.Cotizacion = CotizacionActual;
                nuevoPedido.FormaPago = new FormaPago { Id = idFormaPago };
                nuevoPedido.FormaEntrega = formaEntrega;
                nuevoPedido.Direccion = direccion;
                nuevoPedido.Estado = new EstadoPedido { Id = 1 };
                nuevoPedido.Detalles = carrito;

                string totalMostrado = FormatearMonto(carrito.Sum(x => ObtenerPrecioUnitarioEnMoneda(x) * x.Cantidad));
                int idPedido = pedidoNegocio.ConfirmarPedido(nuevoPedido);

                Session["carrito"] = null;
                pnlCheckout.Visible = false;
                MostrarMensaje("¡Compra confirmada con éxito! Tu número de pedido es #" + idPedido + " por un total de " + totalMostrado + ". Queda en estado Pendiente hasta que se registre el pago.", "alert-success");
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