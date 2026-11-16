<%@ Page Title="Formulario admin expansiones" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminExpansionesForm.aspx.cs" Inherits="ecommerce_web.AdminExpansionesForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <div class="row">
            <div class="col-md-8 offset-md-2">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 id="lblTituloFormulario" runat="server">➕ Nueva Expasion</h2>
                    <a href="AdminExpansiones.aspx" class="btn btn-outline-secondary">⬅ Volver</a>
                </div>

                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body p-4">
                        <!-- ID -->
                        <div class="mb-3">
                            <label for="txtId" class="form-label fw-bold">Codigo de Expansion (ID)</label>
                            <asp:TextBox ID="txtId" runat="server" CssClass="form-control" placeholder="Ej: base2, sv2" MaxLength="50"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvId" runat="server" ControlToValidate="txtId" ErrorMessage="Ingresá el código de la expansión." CssClass="text-danger small" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revId" runat="server" ControlToValidate="txtId" ErrorMessage="El código solo puede tener letras, números y guiones." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[A-Za-z0-9\-]+$" />
                        </div>
                        <!-- Nombre -->
                        <div class="mb-3">
                            <label for="txtNombre" class="form-label fw-bold">Nombre de la Expansion</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Base Set" MaxLength="150"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="Ingresá el nombre de la expansión." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <!-- Serie -->
                        <div class="mb-3">
                            <label for="txtSerie" class="form-label fw-bold">Serie (Opcional)</label>
                            <asp:TextBox ID="txtSerie" runat="server" CssClass="form-control" placeholder="Ej: Scarlet & Violet" MaxLength="100"></asp:TextBox>
                        </div>
                        <!-- Total de Cartas -->
                        <div class="mb-4">
                            <label for="txtTotalCartas" class="form-label fw-bold">Total de Cartas</label>
                            <asp:TextBox ID="txtTotalCartas" runat="server" CssClass="form-control" placeholder="Ej: 102" MaxLength="4"></asp:TextBox>
                            <asp:RangeValidator ID="rvTotalCartas" runat="server" ControlToValidate="txtTotalCartas" Type="Integer" MinimumValue="0" MaximumValue="2000" ErrorMessage="El total de cartas debe ser un número entre 0 y 2000." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <!-- Estado -->
                        <div class="mb-4 form-check form-switch">
                            <asp:CheckBox ID="chkActivo" runat="server" Checked="true" ClientIDMode="Static" />
                            <label for="chkActivo" class="form-check-label fw-bold">Expansion Activa (Visible)</label>
                        </div>
                        <!-- Botones -->
                        <div class="d-grid gap-2 mt-4">
                            <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar Expansion" CssClass="btn btn-success btn-lg" OnClick="btnGuardar_click"/>
                            <asp:Label ID="lblError" runat="server" CssClass="text-danger text-center mt-2" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
