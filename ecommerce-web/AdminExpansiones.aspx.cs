using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using negocio;

namespace ecommerce_web
{
    public partial class AdminExpansiones : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarExpansiones();
            }
        }

        private void CargarExpansiones()
        {
            ExpansionNegocio negocio = new negocio.ExpansionNegocio();
            repExpansiones.DataSource = negocio.Listar();
            repExpansiones.DataBind();
        }
    }
}
