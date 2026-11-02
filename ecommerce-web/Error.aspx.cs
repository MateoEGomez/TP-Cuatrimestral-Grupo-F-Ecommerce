using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ecommerce_web
{
    public partial class Error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();

            if (ex != null)
            {
                // Usamos la variable 'ex' aquí adentro para mostrar el mensaje
                lblMensajeError.Text = ex.InnerException != null ? ex.InnerException.Message : ex.Message;

                // Limpiamos el error
                Server.ClearError();
            }
        }

    }
}