<%@ Page Title="Publicar Carta" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Publicar.aspx.cs" Inherits="ecommerce_web.Publicar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5" style="max-width: 700px;">
        <div class="card shadow">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0"><i class="fas fa-tag me-2"></i>Publicar mi Carta para la Venta</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label for="ddlCartas" class="form-label fw-bold">Seleccioná la carta del catálogo:</label>
                    <asp:DropDownList ID="ddlCartas" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCartas_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label for="txtPrecioSugerido" class="form-label fw-bold">Precio Sugerido de Referencia ($):</label>
                    <asp:TextBox ID="txtPrecioSugerido" runat="server" CssClass="form-control bg-light" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label for="txtPrecioDeseado" class="form-label fw-bold">Tu Precio de Venta ($):</label>
                    <asp:TextBox ID="txtPrecioDeseado" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="Ej: 1500.00"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecioDeseado" ErrorMessage="El precio es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label for="txtEstado" class="form-label fw-bold">Estado y Descripción de tu carta (Ej: Near Mint, detalles de uso):</label>
                    <asp:TextBox ID="txtEstado" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Describí el estado real en el que se encuentra la carta..."></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label for="fileImagen" class="form-label fw-bold">Foto real de la carta:</label>
                    <asp:FileUpload ID="fileImagen" runat="server" CssClass="form-control" />
                    <div class="form-text">Subí una foto clara y real de la carta que vas a enviar al comprador.</div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <asp:Button ID="btnPublicar" runat="server" Text="Confirmar Publicación" CssClass="btn btn-success px-4" OnClick="btnPublicar_Click" />
                    <a href="Default.aspx" class="btn btn-secondary px-4">Cancelar</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>