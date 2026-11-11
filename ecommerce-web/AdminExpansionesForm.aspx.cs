using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ecommerce_web
{
    public partial class AdminExpansionesForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if(!IsPostBack)
                {
                    if (Request.QueryString["id"] != null)
                    {
                        lblTituloFormulario.InnerText = "✏️ Editar Expansion";
                        txtId.Enabled = false;

                        string id = Request.QueryString["id"].ToString();
                        ExpansionNegocio negocio = new ExpansionNegocio();
                        Expansion editar = negocio.ObtenerPorId(id);

                        if(editar != null)
                        {
                            txtId.Text = editar.Id;
                            txtNombre.Text = editar.Nombre;
                            txtSerie.Text = editar.Serie;
                            txtTotalCartas.Text = editar.TotalCartas.ToString();
                            chkActivo.Checked = editar.Activo;
                        }
                    }
                }
            }
            catch(Exception ex) 
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx, false");
            }
        }

        protected void btnGuardar_click(object sender, EventArgs e)
        {
            try
            {
                Expansion nuevo = new Expansion();
                ExpansionNegocio negocio = new ExpansionNegocio();

                //Captura formulario
                nuevo.Id = txtId.Text;
                nuevo.Nombre = txtNombre.Text;
                nuevo.Serie = txtSerie.Text;
                nuevo.TotalCartas = string.IsNullOrEmpty(txtTotalCartas.Text) ? 0 : int.Parse(txtTotalCartas.Text);
                nuevo.Activo = chkActivo.Checked;
                // Si hay Id modificamos de lo contrario agregamos
                if (Request.QueryString["id"] != null)
                {
                    negocio.Modificar(nuevo);
                }
                else
                {
                    negocio.Agregar(nuevo);
                }
                Response.Redirect("AdminExpansiones.aspx", false);

            }
            catch (Exception ex)
            {
                lblError.Text = "Ocurrio un error al guardar: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}