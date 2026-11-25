namespace ecommerce_web
{
    public static class EstiloPublicacion
    {
        public static string ObtenerClaseEstado(int idEstadoPublicacion)
        {
            switch (idEstadoPublicacion)
            {
                case 1: return "bg-warning text-dark";
                case 2: return "bg-success";
                case 3: return "bg-danger";
                default: return "bg-secondary";
            }
        }
    }
}
