<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminCategoriasForm.aspx.cs" Inherits="ecommerce_web.AdminCategoriasForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5" style="max-width: 600px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><asp:Label ID="lblTitulo" runat="server" Text="Nueva categoría" /></h2>
            <a href="AdminCategorias.aspx" class="btn btn-outline-secondary">⬅ Volver al listado</a>
        </div>
        <hr />

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body">

                <asp:Panel ID="pnlId" runat="server" CssClass="mb-3" Visible="false">
                    <label for="txtId" class="form-label">Id</label>
                    <asp:TextBox ID="txtId" runat="server" CssClass="form-control" ReadOnly="true" />
                </asp:Panel>

                <div class="mb-3">
                    <label for="txtDescripcion" class="form-label">Descripción</label>
                    <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion" ErrorMessage="Ingresá una descripción." CssClass="text-danger small" Display="Dynamic" />
                </div>

                <asp:Panel ID="pnlEstado" runat="server" CssClass="mb-3" Visible="false">
                    <span class="form-label d-block">Estado</span>
                    <asp:Label ID="lblEstado" runat="server" />
                </asp:Panel>

                <div class="d-flex gap-2">
                    <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    <asp:Button ID="btnBaja" runat="server" Text="Inactivar" CssClass="btn btn-outline-danger" CausesValidation="false" Visible="false" OnClick="btnBaja_Click" />
                    <a href="AdminCategorias.aspx" class="btn btn-outline-secondary ms-auto">Cancelar</a>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
