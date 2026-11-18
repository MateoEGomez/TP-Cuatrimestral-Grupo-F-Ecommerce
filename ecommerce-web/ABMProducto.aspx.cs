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
            if (!Seguridad.esAdmin(Session["usuario"]))
                Response.Redirect("Default.aspx");

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
            CategoriaNegocio categoriaNegocio = new CategoriaNegocio();
            ddlCategoria.DataSource = categoriaNegocio.Listar().FindAll(x => x.Activo);
            ddlCategoria.DataTextField = "Descripcion";
            ddlCategoria.DataValueField = "Id";
            ddlCategoria.DataBind();
            ddlCategoria.Items.Insert(0, new ListItem("Seleccioná una categoría...", "0"));

            ExpansionNegocio expansionNegocio = new ExpansionNegocio();
            ddlExpansiones.DataSource = expansionNegocio.Listar().FindAll(x => x.Activo);
            ddlExpansiones.DataTextField = "Nombre";
            ddlExpansiones.DataValueField = "Id";
            ddlExpansiones.DataBind();
            ddlExpansiones.Items.Insert(0, new ListItem("Sin expansión", "0"));

            RarezaNegocio rarezaNegocio = new RarezaNegocio();
            ddlRareza.DataSource = rarezaNegocio.Listar().FindAll(x => x.Activo);
            ddlRareza.DataTextField = "Descripcion";
            ddlRareza.DataValueField = "Id";
            ddlRareza.DataBind();
            ddlRareza.Items.Insert(0, new ListItem("Sin especificar", "0"));

            CondicionNegocio condicionNegocio = new CondicionNegocio();
            ddlCondicion.DataSource = condicionNegocio.Listar().FindAll(x => x.Activo);
            ddlCondicion.DataTextField = "Descripcion";
            ddlCondicion.DataValueField = "Id";
            ddlCondicion.DataBind();
            ddlCondicion.Items.Insert(0, new ListItem("Sin especificar", "0"));

            IdiomaNegocio idiomaNegocio = new IdiomaNegocio();
            ddlIdioma.DataSource = idiomaNegocio.Listar().FindAll(x => x.Activo);
            ddlIdioma.DataTextField = "Descripcion";
            ddlIdioma.DataValueField = "Id";
            ddlIdioma.DataBind();
            ddlIdioma.Items.Insert(0, new ListItem("Sin especificar", "0"));
        }

        private void CargarGrilla()
        {
            ProductoNegocio negocio = new ProductoNegocio();
            gvProductos.DataSource = negocio.ListarAdmin(txtFiltro.Text.Trim());
            gvProductos.DataBind();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                gvProductos.PageIndex = 0;
                CargarGrilla();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ModificarItem")
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    CargarProducto(id);
                }
                else if (e.CommandName == "CambiarEstado")
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    ProductoNegocio negocio = new ProductoNegocio();
                    Producto seleccionado = negocio.ObtenerParaEditar(id);
                    negocio.EliminarLogico(id, !seleccionado.Activo);
                    CargarGrilla();
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void CargarProducto(int id)
        {
            ProductoNegocio negocio = new ProductoNegocio();
            Producto seleccionado = negocio.ObtenerParaEditar(id);

            if (seleccionado == null)
                return;

            txtNombre.Text = seleccionado.Nombre;
            txtPrecio.Text = seleccionado.Precio.ToString("0.00");
            txtStock.Text = seleccionado.Stock.ToString();
            txtUrlImagen.Text = seleccionado.UrlImagen;
            txtCardId.Text = seleccionado.CardId;
            txtDescripcion.Text = seleccionado.Descripcion;
            MostrarImagen();

            Seleccionar(ddlCategoria, seleccionado.Categoria.Id.ToString());
            Seleccionar(ddlExpansiones, seleccionado.Expansion != null ? seleccionado.Expansion.Id : "0");
            Seleccionar(ddlRareza, seleccionado.Rareza != null ? seleccionado.Rareza.Id.ToString() : "0");
            Seleccionar(ddlCondicion, seleccionado.Condicion != null ? seleccionado.Condicion.Id.ToString() : "0");
            Seleccionar(ddlIdioma, seleccionado.Idioma != null ? seleccionado.Idioma.Id.ToString() : "0");

            ViewState["idProductoModificar"] = seleccionado.Id;

            lblTituloForm.Text = "Modificando: " + seleccionado.Nombre + " (ID " + seleccionado.Id + ")";
            btnGuardar.Text = "Actualizar Producto";
            btnGuardar.CssClass = "btn btn-warning px-4";
        }

        private void Seleccionar(DropDownList ddl, string valor)
        {
            if (ddl.Items.FindByValue(valor) == null)
                ddl.Items.Add(new ListItem(valor + " (inactivo)", valor));
            ddl.SelectedValue = valor;
        }

        private void MostrarImagen()
        {
            imgPreview.ImageUrl = txtUrlImagen.Text.Trim();
            imgPreview.Visible = txtUrlImagen.Text.Trim() != "";
        }

        protected void txtUrlImagen_TextChanged(object sender, EventArgs e)
        {
            MostrarImagen();
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                ProductoNegocio negocio = new ProductoNegocio();
                Producto aux = new Producto();

                aux.Nombre = txtNombre.Text.Trim();
                aux.Descripcion = txtDescripcion.Text.Trim() != "" ? txtDescripcion.Text.Trim() : null;
                aux.Precio = decimal.Parse(txtPrecio.Text);
                aux.Stock = int.Parse(txtStock.Text);
                aux.UrlImagen = txtUrlImagen.Text.Trim() != "" ? txtUrlImagen.Text.Trim() : null;
                aux.CardId = txtCardId.Text.Trim() != "" ? txtCardId.Text.Trim() : null;

                aux.Categoria = new Categoria();
                aux.Categoria.Id = int.Parse(ddlCategoria.SelectedValue);

                if (ddlExpansiones.SelectedValue != "0")
                {
                    aux.Expansion = new Expansion();
                    aux.Expansion.Id = ddlExpansiones.SelectedValue;
                }
                if (ddlRareza.SelectedValue != "0")
                {
                    aux.Rareza = new Rareza();
                    aux.Rareza.Id = int.Parse(ddlRareza.SelectedValue);
                }
                if (ddlCondicion.SelectedValue != "0")
                {
                    aux.Condicion = new Condicion();
                    aux.Condicion.Id = int.Parse(ddlCondicion.SelectedValue);
                }
                if (ddlIdioma.SelectedValue != "0")
                {
                    aux.Idioma = new Idioma();
                    aux.Idioma.Id = int.Parse(ddlIdioma.SelectedValue);
                }

                if (ViewState["idProductoModificar"] != null)
                {
                    aux.Id = (int)ViewState["idProductoModificar"];
                    negocio.Modificar(aux);
                }
                else
                {
                    aux.Vendedor = (Usuario)Session["usuario"];
                    negocio.InsertarAdmin(aux);
                }

                LimpiarFormulario();
                CargarGrilla();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = "";
            txtPrecio.Text = "";
            txtStock.Text = "";
            txtUrlImagen.Text = "";
            txtCardId.Text = "";
            txtDescripcion.Text = "";
            ddlCategoria.SelectedIndex = 0;
            ddlExpansiones.SelectedIndex = 0;
            ddlRareza.SelectedIndex = 0;
            ddlCondicion.SelectedIndex = 0;
            ddlIdioma.SelectedIndex = 0;
            MostrarImagen();

            ViewState.Remove("idProductoModificar");
            lblTituloForm.Text = "Nuevo producto";
            btnGuardar.Text = "Guardar Producto";
            btnGuardar.CssClass = "btn btn-success px-4";
        }

        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                gvProductos.PageIndex = e.NewPageIndex;
                CargarGrilla();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}
