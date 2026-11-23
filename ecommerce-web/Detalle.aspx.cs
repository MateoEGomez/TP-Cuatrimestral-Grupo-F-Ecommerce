using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Linq;

namespace ecommerce_web
{
    public partial class Detalle : System.Web.UI.Page
    {
        public Producto ProductoSeleccionado { get; set; }
        public bool EsPublicacionPropia { get; set; }

        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            try
            {
                if (!int.TryParse(Request.QueryString["id"], out int idProducto))
                    return;

                ProductoNegocio negocio = new ProductoNegocio();
                Producto prod = negocio.ObtenerPorId(idProducto);

                if (prod == null || !prod.Activo)
                {
                    pnlMensajeDetalle.Visible = true;
                    pnlMensajeDetalle.CssClass = "alert alert-warning mt-3";
                    lblMensajeDetalle.Text = "Esta publicación ya no está disponible.";
                    return;
                }

                if (Session["usuario"] != null && prod.Vendedor != null)
                {
                    Usuario user = (Usuario)Session["usuario"];
                    if (prod.Vendedor.Id == user.Id)
                    {
                        pnlMensajeDetalle.Visible = true;
                        pnlMensajeDetalle.CssClass = "alert alert-warning mt-3";
                        lblMensajeDetalle.Text = "No podés comprar tu propia publicación.";
                        return;
                    }
                }

                if (!int.TryParse(txtCantidad.Text, out int cantidad) || cantidad < 1)
                    cantidad = 1;

                if (prod.Stock > 0 && cantidad > prod.Stock)
                    cantidad = prod.Stock;

                List<DetallePedido> carrito = Session["carrito"] != null
                    ? (List<DetallePedido>)Session["carrito"]
                    : new List<DetallePedido>();

                DetallePedido existente = carrito.FirstOrDefault(x => x.Producto.Id == prod.Id);
                if (existente != null)
                {
                    existente.Cantidad += cantidad;
                    if (prod.Stock > 0 && existente.Cantidad > prod.Stock)
                        existente.Cantidad = prod.Stock;
                }
                else
                {
                    carrito.Add(new DetallePedido
                    {
                        Producto = prod,
                        Cantidad = cantidad,
                        PrecioUnitario = prod.Precio
                    });
                }

                Session["carrito"] = carrito;

                pnlMensajeDetalle.Visible = true;
                pnlMensajeDetalle.CssClass = "alert alert-success mt-3";
                lblMensajeDetalle.Text = $"Se agregaron {cantidad} unidad(es) de \"{prod.Nombre}\" al carrito.";
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string idStr = Request.QueryString["id"];

                if (idStr != null && int.TryParse(idStr, out int id))
                {
                    ProductoNegocio negocio = new ProductoNegocio();
                    ProductoSeleccionado = negocio.ObtenerPorId(id);

                    if (ProductoSeleccionado == null)
                    {
                        Response.Redirect("Default.aspx", false);
                        return;
                    }

                    if (Session["usuario"] != null && ProductoSeleccionado.Vendedor != null)
                    {
                        Usuario user = (Usuario)Session["usuario"];
                        EsPublicacionPropia = (ProductoSeleccionado.Vendedor.Id == user.Id);
                    }

                    if (!ProductoSeleccionado.Activo && !EsPublicacionPropia)
                    {
                        Response.Redirect("Default.aspx", false);
                        return;
                    }
                }
                else
                {
                    Response.Redirect("Default.aspx", false);
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}