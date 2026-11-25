using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class EstadoPublicacionNegocio
    {
        public List<EstadoPublicacion> Listar()
        {
            List<EstadoPublicacion> lista = new List<EstadoPublicacion>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarEstadosPublicacion");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    EstadoPublicacion aux = new EstadoPublicacion();
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
