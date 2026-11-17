using System;
using System.Collections.Generic;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class ABMProducto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    // 1. Cargamos los menús desplegables la primera vez que entra
                    CargarDesplegables();

                    // 2. Cargamos la grilla con la lista de productos
                    CargarGrilla();
                }
            }
            catch (Exception ex) // <-- Corregido para que compile bien
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void CargarDesplegables()
        {
            ProductoNegocio negocio = new ProductoNegocio();

            // Cargamos el Dropdown de Expansiones
            ddlExpansiones.DataSource = negocio.ListarSetsDisponibles();
            ddlExpansiones.DataTextField = "Name";
            ddlExpansiones.DataValueField = "Id";
            ddlExpansiones.DataBind();
            ddlExpansiones.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccioná una expansión...", "0"));
        }

        private void CargarGrilla()
        {
            ProductoNegocio negocio = new ProductoNegocio();

            // Asignamos la lista completa de productos a la grilla del admin
            gvProductos.DataSource = negocio.Listar();
            gvProductos.DataBind();
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                Producto nuevo = new Producto();
                ProductoNegocio negocio = new ProductoNegocio();

                nuevo.Nombre = txtNombre.Text;
                nuevo.Descripcion = txtDescripcion.Text;

                // Validamos y convertimos precio y stock de texto a números de forma segura
                if (decimal.TryParse(txtPrecio.Text, out decimal precio))
                    nuevo.Precio = precio;
                else
                    nuevo.Precio = 0;

                if (int.TryParse(txtStock.Text, out int stock))
                    nuevo.Stock = stock;
                else
                    nuevo.Stock = 1;

                nuevo.UrlImagen = txtUrlImagen.Text;

                // Capturamos la expansión seleccionada en el DropDownList
                if (ddlExpansiones.SelectedValue != "0")
                {
                    nuevo.Expansion = new Expansion();
                    nuevo.Expansion.Id = ddlExpansiones.SelectedValue;
                }

                // Ejecutamos el guardado en la base de datos
                negocio.InsertarAdmin(nuevo);

                // Recargamos la grilla para que aparezca el nuevo producto al instante
                CargarGrilla();

                // Limpiamos los campos (opcional)
                txtNombre.Text = "";
                txtPrecio.Text = "";
                txtStock.Text = "";
                txtUrlImagen.Text = "";
                txtDescripcion.Text = "";
                ddlExpansiones.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}