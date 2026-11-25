namespace ecommerce_web
{
    public static class EstiloPedido
    {
        public static string ObtenerClaseEstado(int idEstado)
        {
            switch (idEstado)
            {
                case 1: return "bg-warning text-dark";
                case 2: return "bg-primary";
                case 3: return "bg-info text-dark";
                case 4: return "bg-info text-dark";
                case 5: return "bg-success";
                case 6: return "bg-danger";
                default: return "bg-secondary";
            }
        }
    }
}
