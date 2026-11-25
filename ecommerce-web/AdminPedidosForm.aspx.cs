using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class AdminPedidosForm : System.Web.UI.Page
    {
        private int IdPedido
        {
            get
            {
                int.TryParse(Request.QueryString["id"], out int id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session["usuario"]))
                Response.Redirect("Default.aspx");

            if (!IsPostBack)
            {
                try
                {
                    EstadoPedidoNegocio estadoNegocio = new EstadoPedidoNegocio();
                    ddlNuevoEstado.DataSource = estadoNegocio.Listar();
                    ddlNuevoEstado.DataTextField = "Descripcion";
                    ddlNuevoEstado.DataValueField = "Id";
                    ddlNuevoEstado.DataBind();

                    if (!CargarPedido())
                        Response.Redirect("AdminPedidos.aspx", false);
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }

        private bool CargarPedido()
        {
            PedidoNegocio negocio = new PedidoNegocio();
            Pedido pedido = negocio.ObtenerPorId(IdPedido);
            if (pedido == null)
                return false;

            lblNumero.Text = "#ORD-" + pedido.Id.ToString("D6");
            lblEstadoActual.Text = pedido.Estado.Descripcion;
            lblEstadoActual.CssClass = "badge fs-6 align-middle " + ObtenerClaseEstado(pedido.Estado.Id);

            lblFecha.Text = pedido.Fecha.ToString("dd/MM/yyyy HH:mm");
            lblCliente.Text = Server.HtmlEncode((pedido.Usuario.Nombre + " " + pedido.Usuario.Apellido).Trim() + " (" + pedido.Usuario.Email + ")");
            lblTelefono.Text = string.IsNullOrEmpty(pedido.Usuario.Telefono) ? "-" : Server.HtmlEncode(pedido.Usuario.Telefono);
            lblEntrega.Text = pedido.Direccion != null
                ? Server.HtmlEncode(pedido.FormaEntrega.Descripcion + " - " + pedido.Direccion.ToString())
                : pedido.FormaEntrega.Descripcion;
            lblPago.Text = pedido.FormaPago.Descripcion;
            lblTotal.Text = FormatearUsd(pedido.Total);
            if (pedido.Moneda == "ARS" && pedido.Cotizacion.HasValue)
                lblTotal.Text += " (pagado en ARS " + (pedido.Total * pedido.Cotizacion.Value).ToString("N2", new CultureInfo("es-AR"))
                    + " con dólar a " + pedido.Cotizacion.Value.ToString("N2", new CultureInfo("es-AR")) + ")";

            repDetalle.DataSource = negocio.ListarDetallePedido(pedido.Id);
            repDetalle.DataBind();

            bool finalizado = EsFinal(pedido.Estado.Id);
            pnlCambiarEstado.Visible = !finalizado;
            lblPedidoFinalizado.Visible = finalizado;
            ddlNuevoEstado.SelectedValue = pedido.Estado.Id.ToString();

            List<ObservacionPedido> observaciones = negocio.ListarObservaciones(pedido.Id);
            repObservaciones.DataSource = observaciones;
            repObservaciones.DataBind();
            lblSinObservaciones.Visible = observaciones.Count == 0;

            return true;
        }

        private bool EsFinal(int idEstado)
        {
            return idEstado == 5 || idEstado == 6;
        }

        protected void btnCambiarEstado_Click(object sender, EventArgs e)
        {
            try
            {
                PedidoNegocio negocio = new PedidoNegocio();
                Pedido pedido = negocio.ObtenerPorId(IdPedido);
                if (pedido == null)
                {
                    Response.Redirect("AdminPedidos.aspx", false);
                    return;
                }

                int idNuevo = int.Parse(ddlNuevoEstado.SelectedValue);

                if (EsFinal(pedido.Estado.Id))
                    MostrarMensaje("El pedido está finalizado y ya no puede cambiar de estado.", "alert-warning");
                else if (idNuevo == pedido.Estado.Id)
                    MostrarMensaje("El pedido ya está en estado " + pedido.Estado.Descripcion + ".", "alert-info");
                else
                {
                    negocio.CambiarEstado(pedido.Id, idNuevo);

                    ObservacionPedido registro = new ObservacionPedido();
                    registro.Usuario = (Usuario)Session["usuario"];
                    registro.Texto = "Cambio de estado de " + pedido.Estado.Descripcion + " a " + ddlNuevoEstado.SelectedItem.Text + ".";
                    negocio.AgregarObservacion(pedido.Id, registro);

                    MostrarMensaje("Estado actualizado a " + ddlNuevoEstado.SelectedItem.Text + ".", "alert-success");
                }

                CargarPedido();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnAgregarObservacion_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                ObservacionPedido nueva = new ObservacionPedido();
                nueva.Usuario = (Usuario)Session["usuario"];
                nueva.Texto = txtObservacion.Text.Trim();

                if (nueva.Texto.Length == 0)
                {
                    MostrarMensaje("Escribí la observación.", "alert-warning");
                    return;
                }

                PedidoNegocio negocio = new PedidoNegocio();
                negocio.AgregarObservacion(IdPedido, nueva);

                txtObservacion.Text = "";
                MostrarMensaje("Observación agregada.", "alert-success");
                CargarPedido();
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

        public string FormatearUsd(decimal monto)
        {
            return "USD " + monto.ToString("N2", CultureInfo.InvariantCulture);
        }

        public string ObtenerClaseEstado(int idEstado)
        {
            switch (idEstado)
            {
                case 1: return "bg-warning text-dark";
                case 2: return "bg-primary";
                case 3: return "bg-info text-dark";
                case 4: return "bg-info text-dark";
                case 5: return "bg-success";
                case 6: return "bg-danger";
                default: return "bg-secondary";
            }
        }
    }
}
