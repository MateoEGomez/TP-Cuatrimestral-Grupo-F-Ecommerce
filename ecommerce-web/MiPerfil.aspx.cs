using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class MiPerfil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    Usuario usuario = (Usuario)Session["usuario"];
                    txtEmail.Text = usuario.Email;
                    txtNombre.Text = usuario.Nombre;
                    txtApellido.Text = usuario.Apellido;
                    txtTelefono.Text = usuario.Telefono;

                    CargarDirecciones();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }

        private void CargarDirecciones()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            DireccionNegocio negocio = new DireccionNegocio();
            List<Direccion> lista = negocio.Listar(usuario.Id);

            repDirecciones.DataSource = lista;
            repDirecciones.DataBind();
            lblSinDirecciones.Visible = lista.Count == 0;
        }

        protected void btnGuardarDatos_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                usuario.Nombre = txtNombre.Text.Trim();
                usuario.Apellido = txtApellido.Text.Trim();
                usuario.Telefono = txtTelefono.Text.Trim();

                UsuarioNegocio negocio = new UsuarioNegocio();
                negocio.ModificarPerfil(usuario);

                Session["usuario"] = usuario;
                MostrarMensaje("Tus datos se guardaron correctamente.", "alert-success");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnCambiarPass_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                UsuarioNegocio negocio = new UsuarioNegocio();

                if (negocio.CambiarPassword(usuario.Id, txtPassActual.Text, txtPassNueva.Text))
                    MostrarMensaje("Tu contraseña se cambió correctamente.", "alert-success");
                else
                    MostrarMensaje("La contraseña actual no es correcta.", "alert-danger");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnNuevaDireccion_Click(object sender, EventArgs e)
        {
            hfIdDireccion.Value = "0";
            lblTituloDireccion.Text = "Nueva dirección";
            txtCalle.Text = "";
            txtNumero.Text = "";
            txtLocalidad.Text = "";
            txtCodigoPostal.Text = "";
            txtObservaciones.Text = "";
            pnlFormDireccion.Visible = true;
        }

        protected void btnCancelarDireccion_Click(object sender, EventArgs e)
        {
            pnlFormDireccion.Visible = false;
        }

        protected void repDirecciones_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument.ToString(), out int idDireccion))
                return;

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                DireccionNegocio negocio = new DireccionNegocio();
                Direccion seleccionada = negocio.Listar(usuario.Id).Find(x => x.Id == idDireccion);
                if (seleccionada == null)
                    return;

                if (e.CommandName == "Editar")
                {
                    hfIdDireccion.Value = seleccionada.Id.ToString();
                    lblTituloDireccion.Text = "Editar dirección";
                    txtCalle.Text = seleccionada.Calle;
                    txtNumero.Text = seleccionada.Numero;
                    txtLocalidad.Text = seleccionada.Localidad;
                    txtCodigoPostal.Text = seleccionada.CodigoPostal;
                    txtObservaciones.Text = seleccionada.Observaciones;
                    pnlFormDireccion.Visible = true;
                }
                else if (e.CommandName == "Eliminar")
                {
                    negocio.EliminarLogico(seleccionada.Id, usuario.Id);
                    pnlFormDireccion.Visible = false;
                    MostrarMensaje("La dirección se eliminó.", "alert-success");
                    CargarDirecciones();
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnGuardarDireccion_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                Direccion direccion = new Direccion();
                direccion.Id = int.Parse(hfIdDireccion.Value);
                direccion.IdUsuario = usuario.Id;
                direccion.Calle = txtCalle.Text.Trim();
                direccion.Numero = txtNumero.Text.Trim();
                direccion.Localidad = txtLocalidad.Text.Trim();
                direccion.CodigoPostal = txtCodigoPostal.Text.Trim();
                direccion.Observaciones = txtObservaciones.Text.Trim();

                if (direccion.Calle == "" || direccion.Numero == "" || direccion.Localidad == "" || direccion.CodigoPostal == "")
                {
                    MostrarMensaje("Completá calle, número, localidad y código postal.", "alert-warning");
                    return;
                }

                DireccionNegocio negocio = new DireccionNegocio();
                if (direccion.Id == 0)
                {
                    negocio.Agregar(direccion);
                    MostrarMensaje("La dirección se agregó.", "alert-success");
                }
                else
                {
                    negocio.Modificar(direccion);
                    MostrarMensaje("La dirección se actualizó.", "alert-success");
                }

                pnlFormDireccion.Visible = false;
                CargarDirecciones();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void MostrarMensaje(string texto, string claseAlerta)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "alert " + claseAlerta;
            lblMensaje.Text = texto;
        }
    }
}
