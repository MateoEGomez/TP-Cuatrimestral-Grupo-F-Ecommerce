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
    public partial class AdminUsuariosForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.esAdmin(Session["usuario"]))
                Response.Redirect("Default.aspx");

            if (!IsPostBack)
            {
                try
                {
                    PerfilNegocio perfilNegocio = new PerfilNegocio();
                    ddlPerfil.DataSource = perfilNegocio.Listar();
                    ddlPerfil.DataValueField = "Id";
                    ddlPerfil.DataTextField = "Descripcion";
                    ddlPerfil.DataBind();

                    if (Request.QueryString["id"] != null)
                        CargarUsuario(int.Parse(Request.QueryString["id"]));
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }

        private void CargarUsuario(int id)
        {
            UsuarioNegocio negocio = new UsuarioNegocio();
            Usuario seleccionado = negocio.Listar().Find(x => x.Id == id);

            if (seleccionado == null)
            {
                Response.Redirect("AdminUsuarios.aspx", false);
                return;
            }

            lblTitulo.Text = "Editar usuario";
            pnlId.Visible = true;
            txtId.Text = seleccionado.Id.ToString();
            txtEmail.Text = seleccionado.Email;
            txtEmail.ReadOnly = true;
            pnlPassword.Visible = false;
            txtNombre.Text = seleccionado.Nombre;
            txtApellido.Text = seleccionado.Apellido;
            txtTelefono.Text = seleccionado.Telefono;
            ddlPerfil.SelectedValue = seleccionado.Perfil.Id.ToString();

            pnlEstado.Visible = true;
            btnBaja.Visible = true;
            if (seleccionado.Activo)
            {
                lblEstado.Text = "<span class='badge bg-success'>Activo</span>";
                btnBaja.Text = "Inactivar";
            }
            else
            {
                lblEstado.Text = "<span class='badge bg-danger'>Inactivo</span>";
                btnBaja.Text = "Reactivar";
                btnBaja.CssClass = "btn btn-outline-success";
            }

            Usuario logueado = (Usuario)Session["usuario"];
            if (logueado.Id == seleccionado.Id)
            {
                ddlPerfil.Enabled = false;
                btnBaja.Visible = false;
                lblAvisoPropio.Visible = true;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();
                Usuario usuario = new Usuario();
                usuario.Nombre = txtNombre.Text.Trim() != "" ? txtNombre.Text.Trim() : null;
                usuario.Apellido = txtApellido.Text.Trim() != "" ? txtApellido.Text.Trim() : null;
                usuario.Telefono = txtTelefono.Text.Trim() != "" ? txtTelefono.Text.Trim() : null;
                usuario.Perfil = new Perfil();
                usuario.Perfil.Id = int.Parse(ddlPerfil.SelectedValue);

                if (Request.QueryString["id"] != null)
                {
                    usuario.Id = int.Parse(Request.QueryString["id"]);

                    Usuario logueado = (Usuario)Session["usuario"];
                    if (logueado.Id == usuario.Id)
                        usuario.Perfil.Id = logueado.Perfil.Id;

                    negocio.Modificar(usuario);
                }
                else
                {
                    usuario.Email = txtEmail.Text.Trim();
                    if (negocio.ExisteEmail(usuario.Email))
                    {
                        lblError.Text = "Ya existe un usuario con el correo " + usuario.Email + ".";
                        lblError.Visible = true;
                        return;
                    }
                    usuario.Pass = txtPassword.Text;
                    negocio.Registrar(usuario);
                }

                Response.Redirect("AdminUsuarios.aspx", false);
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
                Usuario logueado = (Usuario)Session["usuario"];
                if (logueado.Id == id)
                    return;

                UsuarioNegocio negocio = new UsuarioNegocio();
                Usuario seleccionado = negocio.Listar().Find(x => x.Id == id);

                negocio.EliminarLogico(id, !seleccionado.Activo);
                Response.Redirect("AdminUsuarios.aspx", false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }
    }
}
