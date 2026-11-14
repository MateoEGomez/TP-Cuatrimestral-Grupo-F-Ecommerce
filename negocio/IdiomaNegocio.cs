using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class IdiomaNegocio
    {
        public List<Idioma> Listar()
        {
            AccesoDatos datos = new AccesoDatos();
            List<Idioma> lista = new List<Idioma>();
            try
            {
                datos.setearConsulta("select Id, Descripcion, Activo from Idiomas");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Idioma aux = new Idioma();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Activo = (bool)datos.Lector["Activo"];
                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }
        public void Agregar(Idioma obj)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("insert into Idiomas (Descripcion, Activo) values (@descripcion, 1");
                datos.setearParametro("@descripcion", obj.Descripcion);
                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }

        public void Modificar(Idioma obj)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("update Idiomas set Descripcion = @descripcion where Id = @id");
                datos.setearParametro("@descripcion", obj.Descripcion);
                datos.setearParametro("@id", obj.Id);
                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }
        public void EliminarLogico(int id, bool activo = false)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("update Idioma set Activo = @activo where Id = @id");
                datos.setearParametro("@activo", activo);
                datos.setearParametro("id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex) { throw ex; }
            finally { datos.cerrarConexion(); }
        }
    }
}
