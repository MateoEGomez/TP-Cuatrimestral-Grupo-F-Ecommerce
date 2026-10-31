using System;
using dominio; // Asegurate de importar tu espacio de nombres de dominio

namespace ecommerce_web
{
    public partial class Master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificamos si hay un usuario guardado en la sesión
            if (Session["usuario"] != null)
            {
                phNoLogueado.Visible = false; // Ocultamos los botones de login/registro
                phLogueado.Visible = true;   // Mostramos el saludo y el botón de salir

                Usuario user = (Usuario)Session["usuario"];

                // Si cargó nombre se lo mostramos, sino mostramos el email
                lblUser.InnerText = "Hola, " + (!string.IsNullOrEmpty(user.Nombre) ? user.Nombre : user.Email);
            }
            else
            {
                phNoLogueado.Visible = true;  // Mostramos login/registro
                phLogueado.Visible = false;   // Ocultamos saludo
            }
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear(); // Limpiamos la sesión al cerrar sesión
            Response.Redirect("Default.aspx", false);
        }
    }
}