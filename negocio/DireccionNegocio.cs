using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class DireccionNegocio
    {
        public List<Direccion> Listar(int idUsuario)
        {
            List<Direccion> lista = new List<Direccion>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedListarDireccionesUsuario");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Direccion aux = new Direccion();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.IdUsuario = (int)datos.Lector["IdUsuario"];
                    aux.Calle = (string)datos.Lector["Calle"];
                    aux.Numero = (string)datos.Lector["Numero"];
                    aux.Localidad = (string)datos.Lector["Localidad"];
                    aux.CodigoPostal = (string)datos.Lector["CodigoPostal"];
                    if (!(datos.Lector["Observaciones"] is DBNull))
                        aux.Observaciones = (string)datos.Lector["Observaciones"];
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

        public int Agregar(Direccion dir)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedAltaDireccion");
                datos.setearParametro("@IdUsuario", dir.IdUsuario);
                datos.setearParametro("@Calle", dir.Calle);
                datos.setearParametro("@Numero", dir.Numero);
                datos.setearParametro("@Localidad", dir.Localidad);
                datos.setearParametro("@CodigoPostal", dir.CodigoPostal);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(dir.Observaciones) ? (object)DBNull.Value : dir.Observaciones);

                return datos.ejecutarAccionScalar();
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

        public void Modificar(Direccion dir)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedModificarDireccion");
                datos.setearParametro("@Id", dir.Id);
                datos.setearParametro("@IdUsuario", dir.IdUsuario);
                datos.setearParametro("@Calle", dir.Calle);
                datos.setearParametro("@Numero", dir.Numero);
                datos.setearParametro("@Localidad", dir.Localidad);
                datos.setearParametro("@CodigoPostal", dir.CodigoPostal);
                datos.setearParametro("@Observaciones", string.IsNullOrWhiteSpace(dir.Observaciones) ? (object)DBNull.Value : dir.Observaciones);
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

        public void EliminarLogico(int id, int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedBajaLogicaDireccion");
                datos.setearParametro("@Id", id);
                datos.setearParametro("@IdUsuario", idUsuario);
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
