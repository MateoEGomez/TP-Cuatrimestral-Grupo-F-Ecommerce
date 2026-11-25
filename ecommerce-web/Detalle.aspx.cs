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
        public bool PublicacionAprobada { get; set; }

        public string PrecioFormateado()
        {
            if (ProductoSeleccionado == null)
                return MonedaHelper.Formatear(0m);

            return MonedaHelper.FormatearProducto(ProductoSeleccionado);
        }

        public string TextoVendedor()
        {
            if (ProductoSeleccionado == null || ProductoSeleccionado.Vendedor == null || ProductoSeleccionado.Vendedor.Perfil.Id == 2)
                return "🏪 Vendido por la <strong>tienda oficial</strong>";

            string nombre = ((ProductoSeleccionado.Vendedor.Nombre ?? "") + " " + (ProductoSeleccionado.Vendedor.Apellido ?? "")).Trim();
            if (nombre == "")
                nombre = "un usuario de la comunidad";
            return "👤 Vendido por <strong>" + System.Web.HttpUtility.HtmlEncode(nombre) + "</strong>";
        }

        private void MostrarMensajeDetalle(string texto, string claseAlerta)
        {
            pnlMensajeDetalle.Visible = true;
            pnlMensajeDetalle.CssClass = "alert " + claseAlerta + " mt-3";
            lblMensajeDetalle.Text = texto;
        }

        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                if (!int.TryParse(Request.QueryString["id"], out int idProducto))
                    return;

                ProductoNegocio negocio = new ProductoNegocio();
                Producto prod = negocio.ObtenerPorId(idProducto);

                if (prod == null || !prod.Activo || prod.EstadoPublicacion.Id != 2)
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
                {
                    MostrarMensajeDetalle("Ingresá una cantidad válida.", "alert-warning");
                    return;
                }

                if (prod.Stock <= 0)
                {
                    MostrarMensajeDetalle("Esta carta se quedó sin stock.", "alert-warning");
                    return;
                }

                List<DetallePedido> carrito = Session["carrito"] != null
                    ? (List<DetallePedido>)Session["carrito"]
                    : new List<DetallePedido>();

                DetallePedido existente = carrito.FirstOrDefault(x => x.Producto.Id == prod.Id);
                int enCarrito = existente != null ? existente.Cantidad : 0;

                if (enCarrito + cantidad > prod.Stock)
                {
                    string texto = "Solo hay " + prod.Stock + " disponible(s).";
                    if (enCarrito > 0)
                        texto += " Ya tenés " + enCarrito + " en el carrito.";
                    MostrarMensajeDetalle(texto, "alert-warning");
                    return;
                }

                if (existente != null)
                {
                    existente.Cantidad += cantidad;
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

                    int maximo = Math.Max(1, ProductoSeleccionado.Stock);
                    rvCantidad.MaximumValue = maximo.ToString();
                    rvCantidad.ErrorMessage = "La cantidad tiene que ser entre 1 y " + maximo + ".";
                    txtCantidad.Attributes["max"] = maximo.ToString();

                    PublicacionAprobada = ProductoSeleccionado.EstadoPublicacion.Id == 2;
                    bool puedeVerla = EsPublicacionPropia || Seguridad.esAdmin(Session["usuario"]);

                    if ((!ProductoSeleccionado.Activo || !PublicacionAprobada) && !puedeVerla)
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