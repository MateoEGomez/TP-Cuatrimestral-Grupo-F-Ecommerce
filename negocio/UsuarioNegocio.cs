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

        public bool ExisteEmail(string email)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id FROM USUARIOS WHERE Email = @email");
                datos.setearParametro("@email", email);
                datos.ejecutarLectura();

                // Si el lector encuentra un registro, significa que el email ya está usado
                return datos.Lector.Read();
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

        public List<Usuario> Listar()
        {
            List<Usuario> lista = new List<Usuario>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedListarUsuarios");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Usuario aux = new Usuario();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Email = (string)datos.Lector["Email"];
                    aux.Nombre = datos.Lector["Nombre"] is DBNull ? null : (string)datos.Lector["Nombre"];
                    aux.Apellido = datos.Lector["Apellido"] is DBNull ? null : (string)datos.Lector["Apellido"];
                    aux.Telefono = datos.Lector["Telefono"] is DBNull ? null : (string)datos.Lector["Telefono"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    aux.Perfil = new Perfil();
                    aux.Perfil.Id = (int)datos.Lector["IdPerfil"];
                    aux.Perfil.Descripcion = (string)datos.Lector["Perfil"];

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

        public void Modificar(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("storedModificarUsuario");
                datos.setearParametro("@Id", usuario.Id);
                datos.setearParametro("@Nombre", (object)usuario.Nombre ?? DBNull.Value);
                datos.setearParametro("@Apellido", (object)usuario.Apellido ?? DBNull.Value);
                datos.setearParametro("@Telefono", (object)usuario.Telefono ?? DBNull.Value);
                datos.setearParametro("@IdPerfil", usuario.Perfil.Id);
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
                datos.setearProcedimiento("storedBajaLogicaUsuario");
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

        private string HashPassword(string password)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                var bytes = System.Text.Encoding.UTF8.GetBytes(password);
                var hash = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }

        public void CambiarPasswordPorEmail(string email, string nuevaPass)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE USUARIOS SET Pass = @pass WHERE Email = @email AND Activo = 1");
                datos.setearParametro("@email", email);
                datos.setearParametro("@pass", nuevaPass);
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