using System;
using System.IO;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Publicar : System.Web.UI.Page
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
                CargarCartasCatalogo();
            }
        }

        private void CargarCartasCatalogo()
        {
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();
                ddlCartas.DataSource = negocio.Listar();
                ddlCartas.DataTextField = "Nombre";
                ddlCartas.DataValueField = "Id";
                ddlCartas.DataBind();
                ddlCartas.Items.Insert(0, new ListItem("Seleccioná una carta...", "0"));
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void ddlCartas_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int idCarta = int.Parse(ddlCartas.SelectedValue);
                if (idCarta != 0)
                {
                    ProductoNegocio negocio = new ProductoNegocio();
                    Producto carta = negocio.ObtenerPorId(idCarta);
                    if (carta != null)
                    {
                        txtPrecioSugerido.Text = carta.Precio.ToString("0.00");
                    }
                }
                else
                {
                    txtPrecioSugerido.Text = string.Empty;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnPublicar_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlCartas.SelectedValue == "0") return;

                Usuario user = (Usuario)Session["usuario"];
                int idCartaBase = int.Parse(ddlCartas.SelectedValue);

                ProductoNegocio negocio = new ProductoNegocio();
                Producto cartaBase = negocio.ObtenerPorId(idCartaBase);

                Producto nuevoProducto = new Producto();
                nuevoProducto.Nombre = cartaBase != null ? cartaBase.Nombre : "Carta de Cliente";
                nuevoProducto.Descripcion = txtEstado.Text;
                nuevoProducto.Precio = decimal.Parse(txtPrecioDeseado.Text);
                nuevoProducto.Stock = 1;
                nuevoProducto.CardId = cartaBase != null ? cartaBase.CardId : null;

                if (cartaBase != null && cartaBase.Expansion != null)
                {
                    nuevoProducto.Expansion = new Expansion();
                    nuevoProducto.Expansion.Id = cartaBase.Expansion.Id;
                }

                // Guardar la foto real subida
                if (fileImagen.HasFile)
                {
                    string carpeta = Server.MapPath("~/Images/");
                    if (!Directory.Exists(carpeta)) Directory.CreateDirectory(carpeta);

                    string extension = Path.GetExtension(fileImagen.FileName);
                    string nombreUnico = "pub_" + Guid.NewGuid().ToString().Substring(0, 8) + extension;
                    string rutaFisica = Path.Combine(carpeta, nombreUnico);

                    fileImagen.SaveAs(rutaFisica);
                    nuevoProducto.UrlImagen = "~/Images/" + nombreUnico;
                }
                else if (cartaBase != null)
                {
                    nuevoProducto.UrlImagen = cartaBase.UrlImagen;
                }

                negocio.InsertarPublicacionCliente(nuevoProducto, user.Id);

                Response.Redirect("MisVentas.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}