using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using negocio;

namespace ecommerce_web
{
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Opcional: Validar que el usuario logueado sea Administrador
            // if (Session["usuario"] == null || !((dominio.Usuario)Session["usuario"]).EsAdmin)
            // {
            //     Response.Redirect("Default.aspx", false);
            //     return;
            // }
        }

        protected void btnActualizarPrecios_Click(object sender, EventArgs e)
        {
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();

                // Ejecuta la consulta a la API y el UPDATE masivo en la base de datos
                decimal cotizacionAplicada = negocio.ActualizarPreciosPorApi();

                // Mostramos mensaje de éxito con el valor del dólar aplicado
                lblMensajeResultado.CssClass = "alert alert-success d-block";
                lblMensajeResultado.Text = $"¡Éxito! Se actualizaron los precios de toda la base de datos utilizando una cotización del Dólar Blue de <strong>${cotizacionAplicada:N2}</strong>.";
            }
            catch (Exception ex)
            {
                // Manejo de errores en caso de fallo de red o base de datos
                lblMensajeResultado.CssClass = "alert alert-danger d-block";
                lblMensajeResultado.Text = "Ocurrió un error al actualizar los precios: " + ex.Message;
            }
        }
    }
}