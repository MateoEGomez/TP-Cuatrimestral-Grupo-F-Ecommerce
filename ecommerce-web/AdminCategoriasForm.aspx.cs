using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class AdminCategoriasForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session["usuario"]))
                Response.Redirect("Default.aspx");

            if (!IsPostBack && Request.QueryString["id"] != null)
            {
                try
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    CategoriaNegocio negocio = new CategoriaNegocio();
                    Categoria seleccionada = negocio.Listar().Find(x => x.Id == id);

                    if (seleccionada == null)
                    {
                        Response.Redirect("AdminCategorias.aspx", false);
                        return;
                    }

                    lblTitulo.Text = "Editar categoría";
                    txtId.Text = seleccionada.Id.ToString();
                    txtDescripcion.Text = seleccionada.Descripcion;
                    pnlId.Visible = true;

                    pnlEstado.Visible = true;
                    btnBaja.Visible = true;
                    if (seleccionada.Activo)
                    {
                        lblEstado.Text = "<span class='badge bg-success'>Activa</span>";
                        btnBaja.Text = "Inactivar";
                    }
                    else
                    {
                        lblEstado.Text = "<span class='badge bg-danger'>Inactiva</span>";
                        btnBaja.Text = "Reactivar";
                        btnBaja.CssClass = "btn btn-outline-success";
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                CategoriaNegocio negocio = new CategoriaNegocio();
                Categoria categoria = new Categoria();
                categoria.Descripcion = txtDescripcion.Text.Trim();

                if (Request.QueryString["id"] != null)
                {
                    categoria.Id = int.Parse(Request.QueryString["id"]);
                    negocio.Modificar(categoria);
                }
                else
                {
                    negocio.Agregar(categoria);
                }

                Response.Redirect("AdminCategorias.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnBaja_Click(object sender, EventArgs e)
        {
            try
            {
                int id = int.Parse(Request.QueryString["id"]);
                CategoriaNegocio negocio = new CategoriaNegocio();
                Categoria seleccionada = negocio.Listar().Find(x => x.Id == id);

                negocio.EliminarLogico(id, !seleccionada.Activo);
                Response.Redirect("AdminCategorias.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}
