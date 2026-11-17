using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class FormaEntregaNegocio
    {
        public List<FormaEntrega> Listar()
        {
            List<FormaEntrega> lista = new List<FormaEntrega>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedListarFormasEntrega");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    FormaEntrega aux = new FormaEntrega();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.RequiereDireccion = (bool)datos.Lector["RequiereDireccion"];
                    aux.Activo = (bool)datos.Lector["Activo"];

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

        public void Agregar(FormaEntrega nueva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedAltaFormaEntrega");
                datos.setearParametro("@Descripcion", nueva.Descripcion);
                datos.setearParametro("@RequiereDireccion", nueva.RequiereDireccion);
                datos.ejecutarAccion();
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

        public void Modificar(FormaEntrega formaEntrega)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedModificarFormaEntrega");
                datos.setearParametro("@Id", formaEntrega.Id);
                datos.setearParametro("@Descripcion", formaEntrega.Descripcion);
                datos.setearParametro("@RequiereDireccion", formaEntrega.RequiereDireccion);
                datos.ejecutarAccion();
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

        public void EliminarLogico(int id, bool activo = false)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("storedBajaLogicaFormaEntrega");
                datos.setearParametro("@Id", id);
                datos.setearParametro("@Activo", activo);
                datos.ejecutarAccion();
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
