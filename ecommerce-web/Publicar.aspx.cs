using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Publicar : System.Web.UI.Page
    {
        private const int TamanioMaximoFoto = 2 * 1024 * 1024;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (!IsPostBack)
                ddlCartas.Items.Add(new ListItem("Buscá una carta primero...", "0"));
        }

        protected void btnBuscarCarta_Click(object sender, EventArgs e)
        {
            try
            {
                lblBusqueda.Visible = false;
                LimpiarCartaSeleccionada();
                ddlCartas.Items.Clear();

                string filtro = txtBuscarCarta.Text.Trim();
                if (filtro.Length < 3)
                {
                    ddlCartas.Items.Add(new ListItem("Buscá una carta primero...", "0"));
                    MostrarAvisoBusqueda("Escribí al menos 3 letras del nombre o el código de la carta.");
                    return;
                }

                ProductoNegocio negocio = new ProductoNegocio();
                List<Producto> cartas = negocio.BuscarCartasParaPublicar(filtro);

                if (cartas.Count == 0)
                {
                    ddlCartas.Items.Add(new ListItem("Buscá una carta primero...", "0"));
                    MostrarAvisoBusqueda("No encontramos cartas con \"" + HttpUtility.HtmlEncode(filtro) + "\".");
                    return;
                }

                ddlCartas.Items.Add(new ListItem("Seleccioná una carta (" + cartas.Count + " resultados)...", "0"));
                foreach (Producto carta in cartas)
                {
                    string texto = carta.Nombre;
                    if (carta.Expansion != null)
                        texto += " - " + carta.Expansion.Nombre;
                    if (!string.IsNullOrEmpty(carta.CardId))
                        texto += " (" + carta.CardId + ")";
                    ddlCartas.Items.Add(new ListItem(texto, carta.Id.ToString()));
                }

                if (cartas.Count == 50)
                    MostrarAvisoBusqueda("Se muestran las primeras 50. Si no ves tu carta, buscá con más detalle.");
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
                if (idCarta == 0)
                {
                    LimpiarCartaSeleccionada();
                    return;
                }

                ProductoNegocio negocio = new ProductoNegocio();
                Producto carta = negocio.ObtenerPorId(idCarta);
                if (carta == null)
                {
                    LimpiarCartaSeleccionada();
                    return;
                }

                txtPrecioSugerido.Text = carta.Precio.ToString("0.00", CultureInfo.InvariantCulture);
                if (!string.IsNullOrEmpty(carta.UrlImagen))
                {
                    imgCarta.ImageUrl = carta.UrlImagen;
                    imgCarta.Visible = true;
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
            lblErrorPrecio.Visible = false;
            lblErrorImagen.Visible = false;

            if (!Page.IsValid)
                return;

            try
            {
                if (!decimal.TryParse(txtPrecioDeseado.Text, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal precio)
                    || precio <= 0 || precio > 99999)
                {
                    lblErrorPrecio.Text = "Ingresá un precio mayor a 0 y menor a 99999.";
                    lblErrorPrecio.Visible = true;
                    return;
                }

                string extension = "";
                if (fileImagen.HasFile)
                {
                    extension = Path.GetExtension(fileImagen.FileName).ToLower();
                    if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
                    {
                        lblErrorImagen.Text = "La foto tiene que ser una imagen JPG o PNG.";
                        lblErrorImagen.Visible = true;
                        return;
                    }
                    if (fileImagen.PostedFile.ContentLength > TamanioMaximoFoto)
                    {
                        lblErrorImagen.Text = "La foto no puede pesar más de 2 MB.";
                        lblErrorImagen.Visible = true;
                        return;
                    }
                }

                ProductoNegocio negocio = new ProductoNegocio();
                Producto cartaBase = negocio.ObtenerPorId(int.Parse(ddlCartas.SelectedValue));
                if (cartaBase == null)
                {
                    MostrarAvisoBusqueda("La carta elegida ya no está disponible. Buscala de nuevo.");
                    return;
                }

                Usuario user = (Usuario)Session["usuario"];
                Producto nuevoProducto = new Producto();
                nuevoProducto.Nombre = cartaBase.Nombre;
                nuevoProducto.Descripcion = txtEstado.Text.Trim();
                nuevoProducto.Precio = Math.Round(precio, 2);
                nuevoProducto.Stock = 1;
                nuevoProducto.CardId = cartaBase.CardId;

                if (cartaBase.Expansion != null)
                {
                    nuevoProducto.Expansion = new Expansion();
                    nuevoProducto.Expansion.Id = cartaBase.Expansion.Id;
                }

                if (fileImagen.HasFile)
                {
                    string carpeta = Server.MapPath("~/Images/");
                    if (!Directory.Exists(carpeta))
                        Directory.CreateDirectory(carpeta);

                    string nombreUnico = "pub_" + Guid.NewGuid().ToString().Substring(0, 8) + extension;
                    fileImagen.SaveAs(Path.Combine(carpeta, nombreUnico));
                    nuevoProducto.UrlImagen = "~/Images/" + nombreUnico;
                }
                else
                {
                    nuevoProducto.UrlImagen = cartaBase.UrlImagen;
                }

                negocio.InsertarPublicacionCliente(nuevoProducto, user.Id);

                Response.Redirect("MisVentas.aspx?publicada=1", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void LimpiarCartaSeleccionada()
        {
            txtPrecioSugerido.Text = "";
            imgCarta.Visible = false;
        }

        private void MostrarAvisoBusqueda(string texto)
        {
            lblBusqueda.Text = texto;
            lblBusqueda.Visible = true;
        }
    }
}
