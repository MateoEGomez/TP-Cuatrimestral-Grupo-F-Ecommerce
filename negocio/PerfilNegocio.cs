using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class PerfilNegocio
    {
        public List<Perfil> Listar()
        {
            List<Perfil> lista = new List<Perfil>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarPerfiles");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Perfil aux = new Perfil();
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
