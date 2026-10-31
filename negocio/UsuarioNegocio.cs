using System;
using System.Collections.Generic;
using dominio;

namespace negocio
{
    public class UsuarioNegocio
    {
        public void Registrar(Usuario nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Usamos un INSERT estándar sin OUTPUT
                datos.setearConsulta("INSERT INTO USUARIOS (Email, Pass, Nombre, Apellido, Telefono, IdPerfil, Activo) VALUES (@email, @pass, @nombre, @apellido, @telefono, @idPerfil, @activo)");

                datos.setearParametro("@email", nuevo.Email);
                datos.setearParametro("@pass", nuevo.Pass);
                datos.setearParametro("@nombre", (object)nuevo.Nombre ?? DBNull.Value);
                datos.setearParametro("@apellido", (object)nuevo.Apellido ?? DBNull.Value);
                datos.setearParametro("@telefono", (object)nuevo.Telefono ?? DBNull.Value);
                datos.setearParametro("@idPerfil", nuevo.Perfil != null ? nuevo.Perfil.Id : 1);
                datos.setearParametro("@activo", true);

                datos.ejecutarAccion(); // Ejecuta la inserción correctamente
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

        public bool Loguear(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Email, Pass, Nombre, Apellido, Telefono, IdPerfil, Activo FROM USUARIOS WHERE Email = @email AND Pass = @pass AND Activo = 1");
                datos.setearParametro("@email", usuario.Email);
                datos.setearParametro("@pass", usuario.Pass);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.Nombre = datos.Lector["Nombre"] is DBNull ? null : (string)datos.Lector["Nombre"];
                    usuario.Apellido = datos.Lector["Apellido"] is DBNull ? null : (string)datos.Lector["Apellido"];
                    usuario.Telefono = datos.Lector["Telefono"] is DBNull ? null : (string)datos.Lector["Telefono"];

                    // Mapeamos el perfil
                    usuario.Perfil = new Perfil();
                    usuario.Perfil.Id = (int)datos.Lector["IdPerfil"];

                    usuario.Activo = (bool)datos.Lector["Activo"];

                    return true; // Login exitoso
                }
                return false; // Credenciales incorrectas
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