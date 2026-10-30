using System;
using System.Collections.Generic;
using System.Web.UI;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Default : System.Web.UI.Page
    {
        public List<Producto> ListaProductos { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    ProductoNegocio negocio = new ProductoNegocio();
                    ListaProductos = negocio.listar();

                    // Comprobación inteligente: Si la base está vacía, traemos las cartas de la API
                    if (ListaProductos == null || ListaProductos.Count == 0)
                    {
                        negocio.importarCartasDesdeApi();
                        // Volvemos a listar para capturar las cartas recién guardadas
                        ListaProductos = negocio.listar();
                    }

                    repeaterProductos.DataSource = ListaProductos;
                    repeaterProductos.DataBind();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Error.aspx");
                }
            }
        }
    }
}