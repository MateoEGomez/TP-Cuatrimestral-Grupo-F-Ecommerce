using negocio;
using dominio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ecommerce_web
{
    public partial class MisPedidos : System.Web.UI.Page
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
                CargarPedidosUsuario();
            }
        }

        private void CargarPedidosUsuario()
        {
            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                PedidoNegocio negocio = new PedidoNegocio();
                List<Pedido> lista = negocio.ListarPorUsuario(usuario.Id);

                if (lista != null && lista.Count > 0)
                {
                    repPedidos.DataSource = lista;
                    repPedidos.DataBind();
                    pnlTablaPedidos.Visible = true;
                    pnlSinPedidos.Visible = false;
                }
                else
                {
                    pnlTablaPedidos.Visible = false;
                    pnlSinPedidos.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void repPedidos_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "VerDetalle")
                return;

            try
            {
                if (!int.TryParse(e.CommandArgument.ToString(), out int idPedido))
                    return;

                Usuario usuario = (Usuario)Session["usuario"];
                PedidoNegocio negocio = new PedidoNegocio();

                Pedido seleccionado = negocio.ListarPorUsuario(usuario.Id).FirstOrDefault(x => x.Id == idPedido);
                if (seleccionado == null)
                    return;

                lblNumeroOrdenDetalle.Text = "#ORD-" + seleccionado.Id.ToString("D6");
                lblInfoEntrega.Text = seleccionado.Direccion != null
                    ? seleccionado.FormaEntrega.Descripcion + " - " + seleccionado.Direccion.ToString()
                    : seleccionado.FormaEntrega.Descripcion;

                repDetallePedido.DataSource = negocio.ListarDetallePedido(idPedido);
                repDetallePedido.DataBind();
                pnlDetallePedido.Visible = true;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnCerrarDetalle_Click(object sender, EventArgs e)
        {
            pnlDetallePedido.Visible = false;
        }

        public string FormatearUsd(decimal monto)
        {
            return "USD " + monto.ToString("N2", CultureInfo.InvariantCulture);
        }

        public string FormatearTotal(object dataItem)
        {
            Pedido pedido = (Pedido)dataItem;
            string texto = FormatearUsd(pedido.Total);

            if (pedido.Moneda == "ARS" && pedido.Cotizacion.HasValue)
            {
                decimal totalArs = pedido.Total * pedido.Cotizacion.Value;
                texto += "<div class='small text-muted fw-normal'>Pagado en ARS " + totalArs.ToString("N2", new CultureInfo("es-AR")) + "</div>";
            }

            return texto;
        }
    }
}