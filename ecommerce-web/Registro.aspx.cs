using System;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Registro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario nuevo = new Usuario();
                UsuarioNegocio negocio = new UsuarioNegocio();

                nuevo.Email = txtEmail.Text;
                nuevo.Pass = txtPassword.Text;
                nuevo.Nombre = txtNombre.Text;
                nuevo.Apellido = txtApellido.Text;
                nuevo.Telefono = txtTelefono.Text;

                nuevo.Perfil = new Perfil();
                nuevo.Perfil.Id = 1; // Comprador

                // 1. Guardamos el usuario en la BD
                negocio.Registrar(nuevo);

                // 2. Lo logueamos inmediatamente para traer su ID real y datos desde la BD
                if (negocio.Loguear(nuevo))
                {
                    Session["usuario"] = nuevo;
                    Response.Redirect("Default.aspx", false);
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