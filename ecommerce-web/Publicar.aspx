<%@ Page Title="Publicar Carta" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Publicar.aspx.cs" Inherits="ecommerce_web.Publicar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5" style="max-width: 700px;">
        <div class="card shadow dark-mode-card">
            <div class="card-header bg-success text-white">
                <h4 class="mb-0">🏷️ Publicar mi carta para la venta</h4>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label for="<%= txtBuscarCarta.ClientID %>" class="form-label fw-bold">1. Buscá la carta en el catálogo</label>
                    <asp:Panel ID="pnlBuscar" runat="server" DefaultButton="btnBuscarCarta" CssClass="input-group">
                        <asp:TextBox ID="txtBuscarCarta" runat="server" CssClass="form-control" MaxLength="100" placeholder="Nombre o código, ej: Charizard o base1-4" />
                        <asp:Button ID="btnBuscarCarta" runat="server" Text="🔍 Buscar" CssClass="btn btn-outline-success" CausesValidation="false" OnClick="btnBuscarCarta_Click" />
                    </asp:Panel>
                    <asp:Label ID="lblBusqueda" runat="server" CssClass="text-muted small d-block mt-1" Visible="false" />
                </div>

                <div class="mb-3">
                    <label for="<%= ddlCartas.ClientID %>" class="form-label fw-bold">2. Elegí la carta</label>
                    <asp:DropDownList ID="ddlCartas" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCartas_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCarta" runat="server" ControlToValidate="ddlCartas" InitialValue="0" ValidationGroup="publicar"
                        ErrorMessage="Buscá y elegí la carta que vas a vender." CssClass="text-danger small" Display="Dynamic" />
                </div>

                <div class="row g-3 mb-3 align-items-center">
                    <div class="col-auto">
                        <asp:Image ID="imgCarta" runat="server" Visible="false" AlternateText="Carta elegida" CssClass="rounded shadow-sm" style="width: 90px; height: 125px; object-fit: contain;" />
                    </div>
                    <div class="col">
                        <label for="<%= txtPrecioSugerido.ClientID %>" class="form-label fw-bold">Precio de referencia (USD)</label>
                        <asp:TextBox ID="txtPrecioSugerido" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="<%= txtPrecioDeseado.ClientID %>" class="form-label fw-bold">3. Tu precio de venta (USD)</label>
                    <asp:TextBox ID="txtPrecioDeseado" runat="server" CssClass="form-control" TextMode="Number" step="0.01" min="0.01" max="99999" placeholder="Ej: 15.50"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecioDeseado" ValidationGroup="publicar"
                        ErrorMessage="El precio es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPrecio" runat="server" ControlToValidate="txtPrecioDeseado" ValidationGroup="publicar"
                        ValidationExpression="^\d{1,5}(\.\d{1,2})?$" ErrorMessage="Ingresá un número con hasta 2 decimales, ej: 15.50" CssClass="text-danger small" Display="Dynamic" />
                    <asp:Label ID="lblErrorPrecio" runat="server" CssClass="text-danger small d-block" Visible="false" />
                </div>

                <div class="mb-3">
                    <label for="<%= txtEstado.ClientID %>" class="form-label fw-bold">4. Estado y descripción de tu carta</label>
                    <asp:TextBox ID="txtEstado" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="500" placeholder="Ej: Near Mint, sin marcas, guardada en folio..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEstado" runat="server" ControlToValidate="txtEstado" ValidationGroup="publicar"
                        ErrorMessage="Contá en qué estado está la carta." CssClass="text-danger small" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revEstado" runat="server" ControlToValidate="txtEstado" ValidationGroup="publicar"
                        ValidationExpression="^[\s\S]{10,500}$" ErrorMessage="La descripción tiene que tener entre 10 y 500 caracteres." CssClass="text-danger small" Display="Dynamic" />
                </div>

<div class="mb-3">
    <label class="form-label fw-bold">5. Fotos reales de la carta (mínimo 2, máximo 3)</label>

    <div class="mb-2">
        <label for="<%= fileImagen1.ClientID %>" class="form-label small mb-1">Foto 1 (portada)</label>
        <asp:FileUpload ID="fileImagen1" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png" />
    </div>

    <div class="mb-2">
        <label for="<%= fileImagen2.ClientID %>" class="form-label small mb-1">Foto 2</label>
        <asp:FileUpload ID="fileImagen2" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png" />
    </div>

    <div class="mb-1">
        <label for="<%= fileImagen3.ClientID %>" class="form-label small mb-1">Foto 3 (opcional)</label>
        <asp:FileUpload ID="fileImagen3" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png" />
    </div>

    <asp:Label ID="lblErrorImagen" runat="server" CssClass="text-danger small d-block mt-1" Visible="false" />
    <div class="form-text">JPG o PNG de hasta 2 MB por foto. Subí al menos 2 fotos (hasta 3 como máximo).</div>
</div>

                <div class="alert alert-info small mb-0">
                    Tu publicación va a quedar <strong>pendiente de aprobación</strong> hasta que un administrador la revise.
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <asp:Button ID="btnPublicar" runat="server" Text="Confirmar publicación" CssClass="btn btn-success px-4" ValidationGroup="publicar" OnClick="btnPublicar_Click" />
                    <a href="Default.aspx" class="btn btn-secondary px-4">Cancelar</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
