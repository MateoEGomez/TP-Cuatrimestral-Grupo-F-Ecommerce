using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class RarezaNegocio
    {
        public List<Rareza> Listar()
        {
            List<Rareza> lista = new List<Rareza>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("select Id, Descripcion, Activo from Rarezas");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Rareza aux = new Rareza();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
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
        public void Agregar(Rareza nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("insert into Rarezas (Descripcion, Activo) values (@descripcion, 1)");
                datos.setearParametro("@descripcion", nuevo.Descripcion);
                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }

        public void Modificar(Rareza modificado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("update Rarezas set Descripcion = @descripcion where Id = @id ");
                datos.setearParametro("@Descripcion", modificado.Descripcion);
                datos.setearParametro("@id", modificado.Id);
                datos.ejecutarAccion();
            }
            catch(Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }

        public void EliminarLogico(int id, bool activo = false)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("update Rarezas set Activo = @activo where Id = @id");
                datos.setearParametro("@activo", activo);
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }
    }
}
