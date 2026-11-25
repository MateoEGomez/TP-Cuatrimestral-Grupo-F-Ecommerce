using System;
using System.Web;
using dominio;
using negocio;

namespace ecommerce_web
{
    public partial class Master : System.Web.UI.MasterPage
    {
        private static readonly object _lockDolar = new object();
        private static readonly TimeSpan _intervaloActualizacion = TimeSpan.FromHours(1);

        public string MonedaActual
        {
            get { return MonedaHelper.ObtenerMonedaActual(); }
            set { MonedaHelper.EstablecerMoneda(value); }
        }

        public bool EsPesos
        {
            get { return MonedaActual == MonedaHelper.MonedaArs; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ActualizarPreciosSiCorresponde();
            ActualizarEstilosMoneda();

            if (Session["usuario"] != null)
            {
                phNoLogueado.Visible = false;
                phLogueado.Visible = true;

                Usuario user = (Usuario)Session["usuario"];
                lblUser.InnerText = "Hola, " + (!string.IsNullOrEmpty(user.Nombre) ? user.Nombre : user.Email);

                lnkAdmin.Visible = Seguridad.esAdmin(Session["usuario"]);
            }
            else
            {
                phNoLogueado.Visible = true;
                phLogueado.Visible = false;
            }
        }

        public static void ActualizarPreciosSiCorresponde()
        {
            var appState = HttpContext.Current?.Application;
            if (appState == null)
                return;

            DateTime ahora = DateTime.Now;
            DateTime? ultima = appState["UltimaActualizacionDolar"] as DateTime?;

            if (ultima.HasValue && (ahora - ultima.Value) < _intervaloActualizacion)
                return;

            lock (_lockDolar)
            {
                ultima = appState["UltimaActualizacionDolar"] as DateTime?;
                if (ultima.HasValue && (ahora - ultima.Value) < _intervaloActualizacion)
                    return;

                try
                {
                    ProductoNegocio prodNegocio = new ProductoNegocio();
                    decimal cotizacion = prodNegocio.ActualizarPreciosPorApi();
                    appState["CotizacionDolar"] = cotizacion;
                    appState["UltimaActualizacionDolar"] = DateTime.Now;
                }
                catch
                {
                    appState["UltimaActualizacionDolar"] = DateTime.Now.AddMinutes(-50);
                }
            }
        }

        public string FormatearPrecio(decimal precioUsd, decimal? precioArs = null)
        {
            Producto temp = new Producto
            {
                Precio = precioUsd,
                PrecioARS = precioArs
            };
            return MonedaHelper.FormatearProducto(temp, precioUsd);
        }

        private void ActualizarEstilosMoneda()
        {
            if (EsPesos)
            {
                btnMonedaArs.CssClass = "btn btn-sm btn-info text-dark fw-bold active";
                btnMonedaUsd.CssClass = "btn btn-sm btn-outline-info";
            }
            else
            {
                btnMonedaUsd.CssClass = "btn btn-sm btn-info text-dark fw-bold active";
                btnMonedaArs.CssClass = "btn btn-sm btn-outline-info";
            }
        }

        protected void BtnMonedaUsd_Click(object sender, EventArgs e)
        {
            MonedaActual = MonedaHelper.MonedaUsd;
            ActualizarEstilosMoneda();
            if (!(Page is Checkout))
                Response.Redirect(Request.RawUrl, false);
        }

        protected void BtnMonedaArs_Click(object sender, EventArgs e)
        {
            MonedaActual = MonedaHelper.MonedaArs;
            ActualizarEstilosMoneda();
            if (!(Page is Checkout))
                Response.Redirect(Request.RawUrl, false);
        }

        protected void BtnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx", false);
        }
    }
}