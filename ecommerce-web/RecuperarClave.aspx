<%@ Page Title="Recuperar Contraseña" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="RecuperarClave.aspx.cs" Inherits="ecommerce_web.RecuperarClave" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5" style="max-width: 440px;">
        <div class="card shadow">
            <div class="card-body">
                <h3 class="card-title text-center mb-3">Recuperar Contraseña</h3>

                <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert alert-info small">
                    <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
                </asp:Panel>

                <asp:Panel ID="pnlPaso1" runat="server">
                    <p class="text-muted small">
                        Ingresá el correo de tu cuenta y te generamos un código de recuperación simulado.
                    </p>
                    <div class="mb-3">
                        <label for="<%= txtEmailRecuperacion.ClientID %>" class="form-label">Correo electrónico</label>
                        <asp:TextBox ID="txtEmailRecuperacion" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmailRecuperacion" ValidationGroup="codigo"
                            ErrorMessage="Ingresá tu correo." CssClass="text-danger small" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmailRecuperacion" ValidationGroup="codigo"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="El correo no tiene un formato válido." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <asp:Button ID="btnEnviarCodigo" runat="server" Text="Generar código" CssClass="btn btn-primary w-100" ValidationGroup="codigo" OnClick="btnEnviarCodigo_Click" />
                </asp:Panel>

                <asp:Panel ID="pnlPaso2" runat="server" Visible="false" CssClass="mt-3">
                    <hr />
                    <div class="mb-3">
                        <label for="<%= txtCodigo.ClientID %>" class="form-label">Código de verificación (6 dígitos)</label>
                        <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" MaxLength="6"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCodigo" runat="server" ControlToValidate="txtCodigo" ValidationGroup="clave"
                            ErrorMessage="Ingresá el código." CssClass="text-danger small" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revCodigo" runat="server" ControlToValidate="txtCodigo" ValidationGroup="clave"
                            ValidationExpression="^[0-9]{6}$" ErrorMessage="El código tiene 6 números." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="mb-3">
                        <label for="<%= txtNuevaPass.ClientID %>" class="form-label">Nueva contraseña</label>
                        <asp:TextBox ID="txtNuevaPass" runat="server" CssClass="form-control" TextMode="Password" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNuevaPass" runat="server" ControlToValidate="txtNuevaPass" ValidationGroup="clave"
                            ErrorMessage="Ingresá la contraseña nueva." CssClass="text-danger small" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revNuevaPass" runat="server" ControlToValidate="txtNuevaPass" ValidationGroup="clave"
                            ValidationExpression="^.{6,50}$" ErrorMessage="La contraseña debe tener al menos 6 caracteres." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="mb-3">
                        <label for="<%= txtConfirmarPass.ClientID %>" class="form-label">Confirmar nueva contraseña</label>
                        <asp:TextBox ID="txtConfirmarPass" runat="server" CssClass="form-control" TextMode="Password" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvConfirmarPass" runat="server" ControlToValidate="txtConfirmarPass" ValidationGroup="clave"
                            ErrorMessage="Repetí la contraseña nueva." CssClass="text-danger small" Display="Dynamic" />
                        <asp:CompareValidator ID="cvConfirmarPass" runat="server" ControlToValidate="txtConfirmarPass" ControlToCompare="txtNuevaPass" ValidationGroup="clave"
                            ErrorMessage="Las contraseñas no coinciden." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <asp:Button ID="btnCambiarPass" runat="server" Text="Actualizar contraseña" CssClass="btn btn-success w-100" ValidationGroup="clave" OnClick="btnCambiarPass_Click" />
                </asp:Panel>

                <div class="mt-3 text-center">
                    <a href="Login.aspx" class="small">Volver a Iniciar Sesión</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>