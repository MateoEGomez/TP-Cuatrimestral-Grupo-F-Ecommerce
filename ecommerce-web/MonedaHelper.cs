using System;
using System.Globalization;
using System.Web;
using dominio;
using negocio;

namespace ecommerce_web
{
    public static class MonedaHelper
    {
        public const string MonedaUsd = "USD";
        public const string MonedaArs = "ARS";
        private const string ClaveCotizacionApp = "CotizacionDolar";
        private const string ClaveMonedaSession = "moneda";

        public static string ObtenerMonedaActual()
        {
            string moneda = HttpContext.Current?.Session?[ClaveMonedaSession] as string;
            return string.Equals(moneda, MonedaArs, StringComparison.OrdinalIgnoreCase)
                ? MonedaArs
                : MonedaUsd;
        }

        public static void EstablecerMoneda(string moneda)
        {
            if (HttpContext.Current?.Session == null)
                return;

            HttpContext.Current.Session[ClaveMonedaSession] =
                string.Equals(moneda, MonedaArs, StringComparison.OrdinalIgnoreCase)
                    ? MonedaArs
                    : MonedaUsd;
        }

        public static decimal ObtenerCotizacion(bool forzarActualizacionApi = false)
        {
            var app = HttpContext.Current?.Application;

            if (!forzarActualizacionApi && app?[ClaveCotizacionApp] is decimal cotizacionGuardada && cotizacionGuardada > 0m)
                return cotizacionGuardada;

            ProductoNegocio negocio = new ProductoNegocio();
            decimal cotizacionApi = negocio.ActualizarPreciosPorApi();

            if (cotizacionApi <= 0m)
                throw new InvalidOperationException("La API de cotización devolvió un valor inválido.");

            if (app != null)
            {
                app.Lock();
                try
                {
                    app[ClaveCotizacionApp] = cotizacionApi;
                }
                finally
                {
                    app.UnLock();
                }
            }

            return cotizacionApi;
        }

        public static decimal ConvertirMontoDesdeUsd(decimal montoUsd, string moneda = null)
        {
            string activa = moneda ?? ObtenerMonedaActual();
            if (activa == MonedaArs)
                return montoUsd * ObtenerCotizacion();

            return montoUsd;
        }

        public static decimal ObtenerPrecioUnitario(Producto producto, decimal precioBaseUsdFallback = 0m, string moneda = null)
        {
            string activa = moneda ?? ObtenerMonedaActual();
            decimal precioUsd = (producto != null && producto.Precio > 0m)
                ? producto.Precio
                : precioBaseUsdFallback;

            if (activa == MonedaArs)
            {
                if (producto != null && producto.PrecioARS.HasValue && producto.PrecioARS.Value > 0m)
                    return producto.PrecioARS.Value;

                return precioUsd * ObtenerCotizacion();
            }

            return precioUsd;
        }

        public static string Formatear(decimal monto, string moneda = null)
        {
            string activa = moneda ?? ObtenerMonedaActual();
            if (activa == MonedaArs)
                return "ARS " + monto.ToString("N2", new CultureInfo("es-AR"));

            return "USD " + monto.ToString("N2", CultureInfo.InvariantCulture);
        }

        public static string FormatearDesdeUsd(decimal montoUsd, string moneda = null)
        {
            string activa = moneda ?? ObtenerMonedaActual();
            return Formatear(ConvertirMontoDesdeUsd(montoUsd, activa), activa);
        }

        public static string FormatearProducto(Producto producto, decimal precioBaseUsdFallback = 0m, string moneda = null)
        {
            string activa = moneda ?? ObtenerMonedaActual();
            return Formatear(ObtenerPrecioUnitario(producto, precioBaseUsdFallback, activa), activa);
        }
    }
}