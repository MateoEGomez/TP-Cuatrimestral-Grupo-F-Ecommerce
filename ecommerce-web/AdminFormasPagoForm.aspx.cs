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
    public partial class AdminFormasPagoForm : System.Web.UI.Page
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
                    FormaPagoNegocio negocio = new FormaPagoNegocio();
                    FormaPago seleccionada = negocio.Listar().Find(x => x.Id == id);

                    if (seleccionada == null)
                    {
                        Response.Redirect("AdminFormasPago.aspx", false);
                        return;
                    }

                    lblTitulo.Text = "Editar forma de pago";
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
                FormaPagoNegocio negocio = new FormaPagoNegocio();
                FormaPago formaPago = new FormaPago();
                formaPago.Descripcion = txtDescripcion.Text.Trim();

                if (Request.QueryString["id"] != null)
                {
                    formaPago.Id = int.Parse(Request.QueryString["id"]);
                    negocio.Modificar(formaPago);
                }
                else
                {
                    negocio.Agregar(formaPago);
                }

                Response.Redirect("AdminFormasPago.aspx", false);
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
                FormaPagoNegocio negocio = new FormaPagoNegocio();
                FormaPago seleccionada = negocio.Listar().Find(x => x.Id == id);

                negocio.EliminarLogico(id, !seleccionada.Activo);
                Response.Redirect("AdminFormasPago.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}
