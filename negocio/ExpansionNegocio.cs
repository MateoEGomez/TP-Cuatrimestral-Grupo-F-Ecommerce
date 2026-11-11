using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class ExpansionNegocio
    {
        public List<Expansion> Listar()
        {
            List<Expansion> lista = new List<Expansion>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("select Id, Nombre, Serie, TotalCartas, Activo From Expansiones ORDER BY Nombre");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Expansion aux = new Expansion();
                    aux.Id = (string)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    //Manejo de null
                    aux.Serie = datos.Lector["Serie"] is DBNull ? "Sin Serie" : (string)datos.Lector["Serie"];
                    aux.TotalCartas = datos.Lector["TotalCartas"] is DBNull ? 0 : (int)datos.Lector["TotalCartas"];
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

        public Expansion ObtenerPorId(string id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("select Id, Nombre, Serie, TotalCartas, Activo from Expansiones where Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Expansion aux = new Expansion();
                    aux.Id = (string)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Serie = !(datos.Lector["Serie"] is DBNull) ? (string)datos.Lector["Serie"] : "";
                    aux.TotalCartas = !(datos.Lector["TotalCartas"] is DBNull) ? (int)datos.Lector["TotalCartas"] : 0;
                    aux.Activo = (bool)datos.Lector["Activo"];

                    return aux;
                }
                return null;
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

        public void Agregar(Expansion nueva)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("insert into Expansiones (Id, Nombre, Serie, TotalCartas, Activo) values (@id, @nombre, @serie, @total, @activo)");
                datos.setearParametro("@id", nueva.Id);
                datos.setearParametro("@nombre", nueva.Nombre);
                datos.setearParametro("@serie", nueva.Serie);
                datos.setearParametro("@total", nueva.TotalCartas);
                datos.setearParametro("@activo", nueva.Activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally { datos.cerrarConexion(); }
        }

        public void Modificar(Expansion modificada)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("update Expansiones set Nombre = @nombre, Serie = @serie, TotalCartas = @total, Activo = @activo");
                datos.setearParametro("@nombre", modificada.Nombre);
                datos.setearParametro("@serie", modificada.Serie);
                datos.setearParametro("@total", modificada.TotalCartas);
                datos.setearParametro("@activo", modificada.Activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }

        public void EliminarLogico(string id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("update expansiones set activo = 0 where Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}