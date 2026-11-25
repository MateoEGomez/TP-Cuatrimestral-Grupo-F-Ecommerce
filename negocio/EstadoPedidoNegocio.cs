using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class EstadoPedidoNegocio
    {
        public List<EstadoPedido> Listar()
        {
            List<EstadoPedido> lista = new List<EstadoPedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarEstadosPedido");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    EstadoPedido aux = new EstadoPedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];

                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
