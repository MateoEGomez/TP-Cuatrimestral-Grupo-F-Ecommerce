<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminUsuariosForm.aspx.cs" Inherits="ecommerce_web.AdminUsuariosForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5" style="max-width: 600px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><asp:Label ID="lblTitulo" runat="server" Text="Nuevo usuario" /></h2>
            <a href="AdminUsuarios.aspx" class="btn btn-outline-secondary">⬅ Volver al listado</a>
        </div>
        <hr />

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body">

                <asp:Panel ID="pnlId" runat="server" CssClass="mb-3" Visible="false">
                    <label for="txtId" class="form-label">Id</label>
                    <asp:TextBox ID="txtId" runat="server" CssClass="form-control" ReadOnly="true" />
                </asp:Panel>

                <div class="mb-3">
                    <label for="txtEmail" class="form-label">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="100" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Ingresá el correo." CssClass="text-danger small" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo no tiene un formato válido." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                </div>

                <asp:Panel ID="pnlPassword" runat="server" CssClass="mb-3">
                    <label for="txtPassword" class="form-label">Contraseña</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Ingresá una contraseña." CssClass="text-danger small" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña debe tener al menos 6 caracteres." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^.{6,50}$" />
                </asp:Panel>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtNombre" class="form-label">Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtApellido" class="form-label">Apellido</label>
                        <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" MaxLength="50" />
                    </div>
                </div>

                <div class="mb-3">
                    <label for="txtTelefono" class="form-label">Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="30" />
                    <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" ErrorMessage="El teléfono solo puede tener números, espacios, + o -." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[0-9 +\-]{6,30}$" />
                </div>

                <div class="mb-3">
                    <label for="ddlPerfil" class="form-label">Perfil</label>
                    <asp:DropDownList ID="ddlPerfil" runat="server" CssClass="form-select" />
                    <asp:Label ID="lblAvisoPropio" runat="server" CssClass="form-text d-block" Text="No podés cambiar tu propio perfil ni inactivar tu cuenta." Visible="false" />
                </div>

                <asp:Panel ID="pnlEstado" runat="server" CssClass="mb-3" Visible="false">
                    <span class="form-label d-block">Estado</span>
                    <asp:Label ID="lblEstado" runat="server" />
                </asp:Panel>

                <asp:Label ID="lblError" runat="server" CssClass="text-danger d-block mb-3" Visible="false" />

                <div class="d-flex gap-2">
                    <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:Button ID="btnBaja" runat="server" Text="Inactivar" CssClass="btn btn-outline-danger" CausesValidation="false" Visible="false" OnClick="btnBaja_Click" />
                    <a href="AdminUsuarios.aspx" class="btn btn-outline-secondary ms-auto">Cancelar</a>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
