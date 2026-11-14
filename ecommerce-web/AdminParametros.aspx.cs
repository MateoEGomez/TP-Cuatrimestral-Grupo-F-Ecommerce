using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ecommerce_web
{
    public partial class AdminParametros : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                try
                {
                    RarezaNegocio rarezaNegocio = new RarezaNegocio();
                    repRarezas.DataSource = rarezaNegocio.Listar();
                    repRarezas.DataBind();

                    CondicionNegocio condicionNegocio = new CondicionNegocio();
                    repCondiciones.DataSource = condicionNegocio.Listar();
                    repCondiciones.DataBind();

                    IdiomaNegocio idiomaNegocio = new IdiomaNegocio();
                    repIdiomas.DataSource = idiomaNegocio.Listar();
                    repIdiomas.DataBind();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx", false);
                }
            }
        }
    }
}