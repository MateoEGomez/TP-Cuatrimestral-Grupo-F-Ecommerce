using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using dominio;

namespace ecommerce_web
{
    public partial class Carrito : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCarrito();
            }
        }

        private List<DetallePedido> ObtenerCarrito()
        {
            if (Session["carrito"] != null)
                return (List<DetallePedido>)Session["carrito"];

            return new List<DetallePedido>();
        }

        private void CargarCarrito()
        {
            List<DetallePedido> carrito = ObtenerCarrito();

            dgvCarrito.DataSource = carrito;
            dgvCarrito.DataBind();

            pnlVacio.Visible = carrito.Count == 0;

            decimal total = carrito.Sum(x => x.PrecioUnitario * x.Cantidad);
            lblTotalCarrito.Text = total.ToString("C");
        }

        protected void dgvCarrito_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int idProducto))
                return;

            List<DetallePedido> carrito = ObtenerCarrito();
            DetallePedido item = carrito.FirstOrDefault(x => x.Producto.Id == idProducto);

            if (item == null)
                return;

            switch (e.CommandName)
            {
                case "Sumar":
                    if (item.Producto.Stock <= 0 || item.Cantidad < item.Producto.Stock)
                        item.Cantidad++;
                    break;

                case "Restar":
                    item.Cantidad--;
                    if (item.Cantidad <= 0)
                        carrito.Remove(item);
                    break;

                case "Eliminar":
                    carrito.Remove(item);
                    break;
            }

            Session["carrito"] = carrito;
            CargarCarrito();
        }
    }
}