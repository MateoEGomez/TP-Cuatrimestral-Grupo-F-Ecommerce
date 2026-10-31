using System;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Usuario usuario = new Usuario();
            UsuarioNegocio negocio = new UsuarioNegocio();

            usuario.Email = txtEmail.Text;
            usuario.Pass = txtPassword.Text;

            try
            {
                if (negocio.Loguear(usuario))
                {
                    // Guardamos el usuario en sesión
                    Session["usuario"] = usuario;
                    Response.Redirect("Default.aspx", false);
                }
                else
                {
                    lblError.Text = "Usuario o contraseña incorrectos.";
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Session["error"] = ex.ToString();
                // Response.Redirect("Error.aspx", false);
            }
        }
    }
}