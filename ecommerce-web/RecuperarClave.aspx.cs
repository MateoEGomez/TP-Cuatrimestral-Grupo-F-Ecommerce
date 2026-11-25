using System;
using System.Web;
using negocio;

namespace ecommerce_web
{
    public partial class RecuperarClave : System.Web.UI.Page
    {
        private const string SessionCodigoKey = "Recup_Codigo";
        private const string SessionEmailKey = "Recup_Email";
        private const string SessionExpiraKey = "Recup_Expira";
        private const string SessionIntentosKey = "Recup_Intentos";
        private const int MaximoIntentos = 5;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnEnviarCodigo_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string email = txtEmailRecuperacion.Text.Trim();

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
                Session[SessionIntentosKey] = 0;

                pnlPaso2.Visible = true;
                MostrarMensaje($"[Simulación de correo] Se envió el código <strong>{codigo}</strong> a <strong>{HttpUtility.HtmlEncode(email)}</strong> (vence en 10 minutos).", "alert-info");
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
                    int intentos = (int)Session[SessionIntentosKey] + 1;
                    Session[SessionIntentosKey] = intentos;
                    if (intentos >= MaximoIntentos)
                    {
                        LimpiarSesionRecuperacion();
                        pnlPaso2.Visible = false;
                        MostrarMensaje("Ingresaste mal el código " + MaximoIntentos + " veces. Generá uno nuevo.", "alert-danger");
                        return;
                    }
                    MostrarMensaje("El código ingresado no coincide. Te quedan " + (MaximoIntentos - intentos) + " intento(s).", "alert-danger");
                    return;
                }

                string nuevaPass = txtNuevaPass.Text;
                string confirmarPass = txtConfirmarPass.Text;

                if (nuevaPass.Length < 6)
                {
                    MostrarMensaje("La nueva contraseña debe tener al menos 6 caracteres.", "alert-warning");
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
            Session.Remove(SessionIntentosKey);
        }

        private void MostrarMensaje(string html, string cssClase)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = $"alert {cssClase} small";
            lblMensaje.Text = html;
        }
    }
}