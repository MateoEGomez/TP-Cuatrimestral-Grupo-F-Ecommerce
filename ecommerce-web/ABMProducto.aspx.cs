using System;
using System.Collections.Generic;
using dominio;
using negocio;
using System.Web.UI.WebControls;

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
                    CargarDesplegables();
                    CargarGrilla();
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void CargarDesplegables()
        {
            ProductoNegocio negocio = new ProductoNegocio();

            ddlExpansiones.DataSource = negocio.ListarSetsDisponibles();
            ddlExpansiones.DataTextField = "Name";
            ddlExpansiones.DataValueField = "Id";
            ddlExpansiones.DataBind();
            ddlExpansiones.Items.Insert(0, new ListItem("Seleccioná una expansión...", "0"));
        }

        private void CargarGrilla()
        {
            ProductoNegocio negocio = new ProductoNegocio();
            gvProductos.DataSource = negocio.Listar();
            gvProductos.DataBind();
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ModificarItem")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                ProductoNegocio negocio = new ProductoNegocio();
                Producto seleccionado = negocio.ObtenerPorId(id);

                if (seleccionado != null)
                {
                    txtNombre.Text = seleccionado.Nombre;
                    txtPrecio.Text = seleccionado.Precio.ToString("0.00");
                    txtStock.Text = seleccionado.Stock.ToString();
                    txtUrlImagen.Text = seleccionado.UrlImagen;
                    txtDescripcion.Text = seleccionado.Descripcion;

                    if (seleccionado.Expansion != null && ddlExpansiones.Items.FindByValue(seleccionado.Expansion.Id) != null)
                        ddlExpansiones.SelectedValue = seleccionado.Expansion.Id;

                    Session.Add("idProductoModificar", seleccionado.Id);

                    btnGuardar.Text = "Actualizar Producto";
                    btnGuardar.CssClass = "btn btn-warning px-4";
                }
            }
        }

        // ÚNICO MÉTODO btnGuardar_Click (Maneja Alta y Modificación)
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();
                Producto aux = new Producto();

                aux.Nombre = txtNombre.Text;
                aux.Descripcion = txtDescripcion.Text;

                if (decimal.TryParse(txtPrecio.Text, out decimal precio))
                    aux.Precio = precio;

                if (int.TryParse(txtStock.Text, out int stock))
                    aux.Stock = stock;

                aux.UrlImagen = txtUrlImagen.Text;

                if (ddlExpansiones.SelectedValue != "0")
                {
                    aux.Expansion = new Expansion();
                    aux.Expansion.Id = ddlExpansiones.SelectedValue;
                }

                // Si hay sesión activa, estamos modificando; sino, es alta nueva
                if (Session["idProductoModificar"] != null)
                {
                    aux.Id = (int)Session["idProductoModificar"];
                    aux.Activo = true;
                    negocio.Modificar(aux);

                    Session.Remove("idProductoModificar");
                    btnGuardar.Text = "Guardar Producto";
                    btnGuardar.CssClass = "btn btn-success px-4";
                }
                else
                {
                    negocio.InsertarAdmin(aux);
                }

                CargarGrilla();

                // Limpiar campos
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

        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // Cambiamos a la página seleccionada
            gvProductos.PageIndex = e.NewPageIndex;
            // Recargamos la grilla
            CargarGrilla();
        }
    }
}