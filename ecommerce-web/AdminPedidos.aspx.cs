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
    public partial class AdminPedidos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session["usuario"]))
                Response.Redirect("Default.aspx");

            if (!IsPostBack)
            {
                try
                {
                    CargarEstados();
                    CargarPedidos();
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
            EstadoPedidoNegocio negocio = new EstadoPedidoNegocio();

            ddlEstado.DataSource = negocio.Listar();
            ddlEstado.DataTextField = "Descripcion";
            ddlEstado.DataValueField = "Id";
            ddlEstado.DataBind();
            ddlEstado.Items.Insert(0, new ListItem("Todos", "0"));
        }

        private DateTime? LeerFecha(TextBox txt)
        {
            if (DateTime.TryParseExact(txt.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime fecha))
                return fecha;

            return null;
        }

        private void CargarPedidos()
        {
            int? idEstado = null;
            if (ddlEstado.SelectedValue != "0")
                idEstado = int.Parse(ddlEstado.SelectedValue);

            DateTime? desde = LeerFecha(txtDesde);
            DateTime? hasta = LeerFecha(txtHasta);

            lblErrorFiltro.Visible = false;
            if (desde.HasValue && hasta.HasValue && desde.Value > hasta.Value)
            {
                lblErrorFiltro.Text = "La fecha \"Desde\" no puede ser posterior a la fecha \"Hasta\".";
                lblErrorFiltro.Visible = true;
                return;
            }

            PedidoNegocio negocio = new PedidoNegocio();
            List<Pedido> lista = negocio.ListarAdmin(idEstado, desde, hasta, txtCliente.Text);

            repPedidos.DataSource = lista;
            repPedidos.DataBind();

            pnlTabla.Visible = lista.Count > 0;
            pnlSinPedidos.Visible = lista.Count == 0;
            lblCantidad.Text = lista.Count == 1 ? "1 pedido" : lista.Count + " pedidos";
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            try
            {
                CargarPedidos();
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
                ddlEstado.SelectedValue = "0";
                txtDesde.Text = "";
                txtHasta.Text = "";
                txtCliente.Text = "";
                CargarPedidos();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        public string FormatearTotal(object dataItem)
        {
            Pedido pedido = (Pedido)dataItem;
            string texto = "USD " + pedido.Total.ToString("N2", CultureInfo.InvariantCulture);

            if (pedido.Moneda == "ARS" && pedido.Cotizacion.HasValue)
            {
                decimal totalArs = pedido.Total * pedido.Cotizacion.Value;
                texto += "<div class='small text-muted fw-normal'>Pagado en ARS " + totalArs.ToString("N2", new CultureInfo("es-AR")) + "</div>";
            }

            return texto;
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
