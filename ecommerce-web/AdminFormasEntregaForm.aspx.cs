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
    public partial class AdminFormasEntregaForm : System.Web.UI.Page
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
                    FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                    FormaEntrega seleccionada = negocio.Listar().Find(x => x.Id == id);

                    if (seleccionada == null)
                    {
                        Response.Redirect("AdminFormasEntrega.aspx", false);
                        return;
                    }

                    lblTitulo.Text = "Editar forma de entrega";
                    txtId.Text = seleccionada.Id.ToString();
                    txtDescripcion.Text = seleccionada.Descripcion;
                    chkRequiereDireccion.Checked = seleccionada.RequiereDireccion;
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
                FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                FormaEntrega formaEntrega = new FormaEntrega();
                formaEntrega.Descripcion = txtDescripcion.Text.Trim();
                formaEntrega.RequiereDireccion = chkRequiereDireccion.Checked;
                if (Request.QueryString["id"] != null)
                    formaEntrega.Id = int.Parse(Request.QueryString["id"]);

                if (negocio.Listar().Exists(x => x.Id != formaEntrega.Id && string.Equals(x.Descripcion, formaEntrega.Descripcion, StringComparison.OrdinalIgnoreCase)))
                {
                    lblError.Text = "Ya existe una forma de entrega llamada \"" + HttpUtility.HtmlEncode(formaEntrega.Descripcion) + "\" (puede estar inactiva).";
                    lblError.Visible = true;
                    return;
                }

                if (Request.QueryString["id"] != null)
                {
                    negocio.Modificar(formaEntrega);
                }
                else
                {
                    negocio.Agregar(formaEntrega);
                }

                Response.Redirect("AdminFormasEntrega.aspx", false);
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
                FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                FormaEntrega seleccionada = negocio.Listar().Find(x => x.Id == id);

                negocio.EliminarLogico(id, !seleccionada.Activo);
                Response.Redirect("AdminFormasEntrega.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}
