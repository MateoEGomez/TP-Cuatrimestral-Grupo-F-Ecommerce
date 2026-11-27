using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
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
                try
                {
                    Usuario user = (Usuario)Session["usuario"];
                    pnlPublicada.Visible = Request.QueryString["publicada"] == "1";
                    CargarVentas(user.Id);
                    CargarPublicaciones(user.Id);
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }

        private void CargarVentas(int idVendedor)
        {
            PedidoNegocio negocio = new PedidoNegocio();
            List<Pedido> ventas = negocio.ListarVentasVendedor(idVendedor);

            repVentas.DataSource = ventas;
            repVentas.DataBind();
            pnlVentas.Visible = ventas.Count > 0;
            pnlSinVentas.Visible = ventas.Count == 0;

            List<Pedido> concretadas = ventas.Where(x => x.Estado.Id != 6).ToList();
            lblUnidadesVendidas.Text = concretadas.Sum(x => x.Detalles.Sum(d => d.Cantidad)).ToString();
            lblTotalVendido.Text = FormatearUsd(concretadas.Sum(x => x.Total));
        }

        private void CargarPublicaciones(int idVendedor)
        {
            ProductoNegocio negocio = new ProductoNegocio();
            List<Producto> publicaciones = negocio.ListarPorVendedor(idVendedor);

            repPublicaciones.DataSource = publicaciones;
            repPublicaciones.DataBind();
            pnlPublicaciones.Visible = publicaciones.Count > 0;
            pnlSinPublicaciones.Visible = publicaciones.Count == 0;

            lblPublicacionesActivas.Text = publicaciones.Count(x => EstaALaVenta(x)).ToString();
        }

        public string FormatearUsd(decimal monto)
        {
            return "USD " + monto.ToString("N2", CultureInfo.InvariantCulture);
        }

        public bool EstaALaVenta(object dataItem)
        {
            Producto producto = (Producto)dataItem;
            return producto.Activo && producto.Stock > 0 && producto.EstadoPublicacion.Id == 2;
        }

        public string ObtenerEstadoPublicacion(object dataItem)
        {
            Producto producto = (Producto)dataItem;

            if (producto.EstadoPublicacion.Id == 1)
                return "<span class='badge bg-warning text-dark'>Pendiente de aprobación</span>";
            if (producto.EstadoPublicacion.Id == 3)
                return "<span class='badge bg-danger'>Rechazada</span><div class='small text-danger'>" + HttpUtility.HtmlEncode(producto.MotivoRechazo) + "</div>";
            if (!producto.Activo)
                return "<span class='badge bg-secondary'>Oculta</span>";
            if (producto.Stock == 0)
                return "<span class='badge bg-dark'>Sin stock</span>";
            return "<span class='badge bg-success'>A la venta</span>";
        }

        public bool PuedePausar(object dataItem)
        {
            Producto producto = (Producto)dataItem;
            return producto.Activo && producto.EstadoPublicacion.Id == 2;
        }

        public bool PuedeReactivar(object dataItem)
        {
            Producto producto = (Producto)dataItem;
            return !producto.Activo && producto.Stock > 0 && producto.EstadoPublicacion.Id == 2;
        }

        public bool PuedeDarDeBaja(object dataItem)
        {
            Producto producto = (Producto)dataItem;
            return producto.EstadoPublicacion.Id != 3 && (producto.Activo || producto.Stock > 0);
        }

        protected void repPublicaciones_ItemCommand(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            try
            {
                Usuario user = (Usuario)Session["usuario"];
                int idProducto = int.Parse(e.CommandArgument.ToString());
                ProductoNegocio negocio = new ProductoNegocio();

                if (e.CommandName == "Pausar")
                    negocio.CambiarEstadoPublicacion(idProducto, user.Id, false);
                else if (e.CommandName == "Reactivar")
                    negocio.CambiarEstadoPublicacion(idProducto, user.Id, true);
                else if (e.CommandName == "Baja")
                    negocio.DarDeBajaPublicacion(idProducto, user.Id);

                CargarPublicaciones(user.Id);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void repVentas_ItemCommand(object sender, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "AvanzarEstado")
                return;

            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            try
            {
                string[] partes = e.CommandArgument.ToString().Split('|');
                if (partes.Length != 2
                    || !int.TryParse(partes[0], out int idPedido)
                    || !int.TryParse(partes[1], out int nuevoEstado))
                    return;

                Usuario user = (Usuario)Session["usuario"];
                PedidoNegocio pedidoNegocio = new PedidoNegocio();

                Pedido venta = pedidoNegocio.ListarVentasVendedor(user.Id).FirstOrDefault(x => x.Id == idPedido);
                if (venta == null)
                    return;

                int estadoActual = venta.Estado.Id;
                bool transicionValida =
                    (estadoActual == 1 && nuevoEstado == 2) ||
                    ((estadoActual == 2 || estadoActual == 3) && nuevoEstado == 4) ||
                    (estadoActual == 4 && nuevoEstado == 5);

                if (!transicionValida)
                    return;

                pedidoNegocio.CambiarEstado(idPedido, nuevoEstado);
                CargarVentas(user.Id);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}
