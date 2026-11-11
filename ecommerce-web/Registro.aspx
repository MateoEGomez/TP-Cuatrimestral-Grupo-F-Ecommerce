<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="ecommerce_web.Registro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Acá podrías poner estilos CSS propios de esta pantalla si necesitás -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5" style="max-width: 500px;">
        <div class="card shadow">
            <div class="card-body">
                <h3 class="card-title text-center mb-4">Crear Cuenta</h3>
                
                <!-- Label para mostrar errores (ej: email ya registrado) -->
                <asp:Label ID="lblError" runat="server" CssClass="text-danger d-block mb-3 text-center" />

                <div class="mb-3">
                    <label for="txtEmail" class="form-label">Correo electrónico</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Ingresá tu correo." CssClass="text-danger small" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo no tiene un formato válido." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                </div>
                
                <div class="mb-3">
                    <label for="txtPassword" class="form-label">Contraseña</label>
                    <!-- ClientIDMode="Static" permite encontrar el ID fácil desde JS -->
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" ClientIDMode="Static" MaxLength="50" onkeyup="verificarFuerzaPassword(this.value);" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Ingresá una contraseña." CssClass="text-danger small" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña debe tener al menos 6 caracteres." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^.{6,50}$" />

                    <!-- Barra de progreso de Bootstrap -->
                    <div class="progress mt-2" style="height: 6px;">
                        <div id="barraFuerza" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <small id="textoFuerza" class="form-text text-muted">Mínimo 6 caracteres, letras y números.</small>
                </div>

                <div class="mb-3">
                    <label for="txtConfirmarPassword" class="form-label">Repetir contraseña</label>
                    <asp:TextBox ID="txtConfirmarPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvConfirmarPassword" runat="server" ControlToValidate="txtConfirmarPassword" ErrorMessage="Repetí la contraseña." CssClass="text-danger small" Display="Dynamic" />
                    <asp:CompareValidator ID="cvConfirmarPassword" runat="server" ControlToValidate="txtConfirmarPassword" ControlToCompare="txtPassword" ErrorMessage="Las contraseñas no coinciden." CssClass="text-danger small" Display="Dynamic" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtNombre" class="form-label">Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtApellido" class="form-label">Apellido</label>
                        <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="txtTelefono" class="form-label">Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" TextMode="Phone" MaxLength="30"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="El teléfono solo puede tener números, espacios, + o -." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[0-9 +\-]{6,30}$" />
                </div>

                <asp:Button ID="btnRegistrar" runat="server" Text="Registrarse" CssClass="btn btn-primary w-100" OnClick="btnRegistrar_Click" />
                
                <div class="mt-3 text-center">
                    <a href="Login.aspx">¿Ya tenés cuenta? Iniciar sesión</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Script de validación en tiempo real (organizado al final del contenido) -->
    <script>
    // @ts-nocheck
    function verificarFuerzaPassword(password) {
        var barra = document.getElementById('barraFuerza');
        var texto = document.getElementById('textoFuerza');

        if (!barra || !texto) return;

        var fuerza = 0;

        if (password.length >= 6) fuerza += 33;
        if (password.match(/[A-Z]/) && password.match(/[0-9]/)) fuerza += 34;
        if (password.length >= 10 && password.match(/[^a-zA-Z0-9]/)) fuerza += 33;

        barra.style.width = fuerza + '%';

        if (fuerza <= 33) {
            barra.className = 'progress-bar bg-danger';
            texto.innerText = 'Seguridad: Débil 🔴';
        } else if (fuerza <= 66) {
            barra.className = 'progress-bar bg-warning';
            texto.innerText = 'Seguridad: Normal 🟡';
        } else {
            barra.className = 'progress-bar bg-success';
            texto.innerText = 'Seguridad: Fuerte 🟢';
        }
    }
    </script>
</asp:Content>