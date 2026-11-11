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
    }
}
