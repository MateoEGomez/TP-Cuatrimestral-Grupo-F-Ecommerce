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
    public partial class AdminParametrosForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session["usuario"]))
                Response.Redirect("Default.aspx");

            string tipo = Request.QueryString["tipo"];
            if (string.IsNullOrEmpty(tipo))
            {
                Response.Redirect("AdminParametros.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    bool esEdicion = Request.QueryString["id"] != null;
                    int id = esEdicion ? int.Parse(Request.QueryString["id"]) : 0;

                    if (tipo == "rareza")
                    {
                        lblTitulo.Text = esEdicion ? "Editar rareza" : "Nueva rareza";
                        if (esEdicion)
                        {
                            RarezaNegocio negocio = new RarezaNegocio();
                            Rareza seleccionada = negocio.Listar().Find(x => x.Id == id);
                            if (seleccionada == null) { Response.Redirect("AdminParametros.aspx", false); return; }

                            CargarControlesEdicion(seleccionada.Id, seleccionada.Descripcion, seleccionada.Activo, true);
                        }
                    }
                    else if (tipo == "condicion")
                    {
                        lblTitulo.Text = esEdicion ? "Editar condición" : "Nueva condición";
                        if (esEdicion)
                        {
                            CondicionNegocio negocio = new CondicionNegocio();
                            Condicion seleccionada = negocio.Listar().Find(x => x.Id == id);
                            if (seleccionada == null) { Response.Redirect("AdminParametros.aspx", false); return; }

                            CargarControlesEdicion(seleccionada.Id, seleccionada.Descripcion, seleccionada.Activo, true);
                        }
                    }
                    else if (tipo == "idioma")
                    {
                        lblTitulo.Text = esEdicion ? "Editar idioma" : "Nuevo idioma";
                        if (esEdicion)
                        {
                            IdiomaNegocio negocio = new IdiomaNegocio();
                            Idioma seleccionada = negocio.Listar().Find(x => x.Id == id);
                            if (seleccionada == null) { Response.Redirect("AdminParametros.aspx", false); return; }

                            CargarControlesEdicion(seleccionada.Id, seleccionada.Descripcion, seleccionada.Activo, false);
                        }
                    }
                    else
                    {
                        Response.Redirect("AdminParametros.aspx", false);
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }
        private void CargarControlesEdicion(int id, string descripcion, bool activo, bool esFemenino)
        {
            txtId.Text = id.ToString();
            txtDescripcion.Text = descripcion;
            pnlId.Visible = true;
            pnlEstado.Visible = true;
            btnBaja.Visible = true;

            if (activo)
            {
                lblEstado.Text = esFemenino
                    ? "<span class='badge bg-success'>Activa</span>"
                    : "<span class='badge bg-success'>Activo</span>";
                btnBaja.Text = "Inactivar";
            }
            else
            {
                lblEstado.Text = esFemenino
                    ? "<span class='badge bg-danger'>Inactiva</span>"
                    : "<span class='badge bg-danger'>Inactivo</span>";
                btnBaja.Text = "Reactivar";
                btnBaja.CssClass = "btn btn-outline-success";
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string tipo = Request.QueryString["tipo"];
                string descripcion = txtDescripcion.Text.Trim();
                bool esEdicion = Request.QueryString["id"] != null;
                int id = esEdicion ? int.Parse(Request.QueryString["id"]) : 0;

                if (tipo == "rareza")
                {
                    RarezaNegocio negocio = new RarezaNegocio();
                    Rareza item = new Rareza { Id = id, Descripcion = descripcion };
                    if (esEdicion) negocio.Modificar(item);
                    else negocio.Agregar(item);
                }
                else if (tipo == "condicion")
                {
                    CondicionNegocio negocio = new CondicionNegocio();
                    Condicion item = new Condicion { Id = id, Descripcion = descripcion };
                    if (esEdicion) negocio.Modificar(item);
                    else negocio.Agregar(item);
                }
                else if (tipo == "idioma")
                {
                    IdiomaNegocio negocio = new IdiomaNegocio();
                    Idioma item = new Idioma { Id = id, Descripcion = descripcion };
                    if (esEdicion) negocio.Modificar(item);
                    else negocio.Agregar(item);
                }

                Response.Redirect("AdminParametros.aspx", false);
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
                string tipo = Request.QueryString["tipo"];
                int id = int.Parse(Request.QueryString["id"]);

                if (tipo == "rareza")
                {
                    RarezaNegocio negocio = new RarezaNegocio();
                    Rareza seleccionada = negocio.Listar().Find(x => x.Id == id);
                    negocio.EliminarLogico(id, !seleccionada.Activo);
                }
                else if (tipo == "condicion")
                {
                    CondicionNegocio negocio = new CondicionNegocio();
                    Condicion seleccionada = negocio.Listar().Find(x => x.Id == id);
                    negocio.EliminarLogico(id, !seleccionada.Activo);
                }
                else if (tipo == "idioma")
                {
                    IdiomaNegocio negocio = new IdiomaNegocio();
                    Idioma seleccionada = negocio.Listar().Find(x => x.Id == id);
                    negocio.EliminarLogico(id, !seleccionada.Activo);
                }

                Response.Redirect("AdminParametros.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}