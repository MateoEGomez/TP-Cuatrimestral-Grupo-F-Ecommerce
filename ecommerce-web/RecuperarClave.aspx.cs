using System;
using negocio;

namespace ecommerce_web
{
    public partial class RecuperarClave : System.Web.UI.Page
    {
        private const string SessionCodigoKey = "Recup_Codigo";
        private const string SessionEmailKey = "Recup_Email";
        private const string SessionExpiraKey = "Recup_Expira";

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnEnviarCodigo_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmailRecuperacion.Text.Trim();
                if (string.IsNullOrWhiteSpace(email))
                {
                    MostrarMensaje("Ingresá un correo electrónico válido.", "alert-warning");
                    return;
                }

                UsuarioNegocio negocio = new UsuarioNegocio();
                if (!negocio.ExisteEmail(email))
                {
                    MostrarMensaje("No encontramos una cuenta registrada con ese correo.", "alert-danger");
                    return;
                }

                Random rnd = new Random();
                string codigo = rnd.Next(100000, 999999).ToString();

                Session[SessionCodigoKey] = codigo;
                Session[SessionEmailKey] = email;
                Session[SessionExpiraKey] = DateTime.Now.AddMinutes(10);

                pnlPaso2.Visible = true;
                MostrarMensaje($"[Simulación de correo] Se envió el código <strong>{codigo}</strong> a <strong>{email}</strong> (vence en 10 minutos).", "alert-info");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        protected void btnCambiarPass_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session[SessionCodigoKey] == null || Session[SessionEmailKey] == null || Session[SessionExpiraKey] == null)
                {
                    MostrarMensaje("Primero solicitá un código de recuperación.", "alert-warning");
                    return;
                }

                DateTime expira = (DateTime)Session[SessionExpiraKey];
                if (DateTime.Now > expira)
                {
                    LimpiarSesionRecuperacion();
                    pnlPaso2.Visible = false;
                    MostrarMensaje("El código expiró. Generá uno nuevo.", "alert-warning");
                    return;
                }

                string codigoGuardado = Session[SessionCodigoKey].ToString();
                string emailGuardado = Session[SessionEmailKey].ToString();

                if (txtCodigo.Text.Trim() != codigoGuardado)
                {
                    MostrarMensaje("El código ingresado no coincide.", "alert-danger");
                    return;
                }

                string nuevaPass = txtNuevaPass.Text;
                string confirmarPass = txtConfirmarPass.Text;

                if (string.IsNullOrWhiteSpace(nuevaPass) || nuevaPass.Length < 4)
                {
                    MostrarMensaje("La nueva contraseña debe tener al menos 4 caracteres.", "alert-warning");
                    return;
                }

                if (nuevaPass != confirmarPass)
                {
                    MostrarMensaje("Las contraseñas no coinciden.", "alert-danger");
                    return;
                }

                UsuarioNegocio negocio = new UsuarioNegocio();
                negocio.CambiarPasswordPorEmail(emailGuardado, nuevaPass);

                LimpiarSesionRecuperacion();
                pnlPaso2.Visible = false;
                txtNuevaPass.Text = string.Empty;
                txtConfirmarPass.Text = string.Empty;
                txtCodigo.Text = string.Empty;

                MostrarMensaje("¡Contraseña actualizada con éxito! Ya podés iniciar sesión con tu nueva clave.", "alert-success");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Error.aspx", false);
            }
        }

        private void LimpiarSesionRecuperacion()
        {
            Session.Remove(SessionCodigoKey);
            Session.Remove(SessionEmailKey);
            Session.Remove(SessionExpiraKey);
        }

        private void MostrarMensaje(string html, string cssClase)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = $"alert {cssClase} small";
            lblMensaje.Text = html;
        }
    }
}