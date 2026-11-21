<%@ Page Title="Finalizar Compra" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="ecommerce_web.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <a href="Carrito.aspx" class="btn btn-outline-secondary mb-3">&larr; Volver al carrito</a>

        <h2 class="mb-4">Finalizar Compra</h2>

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert alert-warning">
            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </asp:Panel>

        <asp:Panel ID="pnlCheckout" runat="server" CssClass="row">
            <div class="col-lg-8 mb-4">

                <div class="card shadow-sm dark-mode-card mb-3">
                    <div class="card-body">
                        <h5 class="card-title fw-bold">1. Forma de Entrega</h5>
                        <asp:RadioButtonList ID="rblFormaEntrega" runat="server" CssClass="form-check" RepeatLayout="Flow" AutoPostBack="true" OnSelectedIndexChanged="rblFormaEntrega_SelectedIndexChanged"></asp:RadioButtonList>
                        <asp:RequiredFieldValidator ID="rfvFormaEntrega" runat="server" ControlToValidate="rblFormaEntrega" ErrorMessage="Elegí una forma de entrega." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                </div>

                <asp:Panel ID="pnlDireccion" runat="server" CssClass="card shadow-sm dark-mode-card mb-3" Visible="false">
                    <div class="card-body">
                        <h5 class="card-title fw-bold">2. Dirección de Envío</h5>

                        <div class="mb-3">
                            <asp:DropDownList ID="ddlDirecciones" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlDirecciones_SelectedIndexChanged" />
                        </div>

                        <asp:Panel ID="pnlNuevaDireccion" runat="server" CssClass="row g-3">
                            <div class="col-md-8">
                                <label for="txtCalle" class="form-label">Calle</label>
                                <asp:TextBox ID="txtCalle" runat="server" CssClass="form-control" MaxLength="100" placeholder="Ej: Av. Hipólito Yrigoyen" />
                                <asp:RequiredFieldValidator ID="rfvCalle" runat="server" ControlToValidate="txtCalle" ErrorMessage="Ingresá la calle." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                            <div class="col-md-4">
                                <label for="txtNumero" class="form-label">Número</label>
                                <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control" MaxLength="10" placeholder="Ej: 288" />
                                <asp:RequiredFieldValidator ID="rfvNumero" runat="server" ControlToValidate="txtNumero" ErrorMessage="Ingresá el número." CssClass="text-danger small" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revNumero" runat="server" ControlToValidate="txtNumero" ValidationExpression="^[0-9]{1,6}[A-Za-z ]{0,4}$" ErrorMessage="El número tiene que empezar con dígitos (ej: 288 o 288 B)." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                            <div class="col-md-8">
                                <label for="txtLocalidad" class="form-label">Localidad</label>
                                <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control" MaxLength="100" placeholder="Ej: General Pacheco" />
                                <asp:RequiredFieldValidator ID="rfvLocalidad" runat="server" ControlToValidate="txtLocalidad" ErrorMessage="Ingresá la localidad." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                            <div class="col-md-4">
                                <label for="txtCP" class="form-label">Código postal</label>
                                <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" MaxLength="10" placeholder="Ej: 1617" />
                                <asp:RequiredFieldValidator ID="rfvCP" runat="server" ControlToValidate="txtCP" ErrorMessage="Ingresá el código postal." CssClass="text-danger small" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revCP" runat="server" ControlToValidate="txtCP" ValidationExpression="^[A-Za-z]?[0-9]{4}[A-Za-z]{0,3}$" ErrorMessage="Código postal inválido (ej: 1617 o B1617ABC)." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                            <div class="col-md-12">
                                <label for="txtObservaciones" class="form-label">Observaciones</label>
                                <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" MaxLength="200" placeholder="Color de reja, timbre" />
                            </div>
                        </asp:Panel>
                    </div>
                </asp:Panel>

                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body">
                        <h5 class="card-title fw-bold"><asp:Label ID="lblTituloPago" runat="server" Text="2. Forma de Pago" /></h5>
                        <asp:RadioButtonList ID="rblFormaPago" runat="server" CssClass="form-check" RepeatLayout="Flow"></asp:RadioButtonList>
                        <asp:RequiredFieldValidator ID="rfvFormaPago" runat="server" ControlToValidate="rblFormaPago" ErrorMessage="Elegí una forma de pago." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                </div>

            </div>

            <div class="col-lg-4">
                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body">
                        <h5 class="card-title mb-4">Tu Pedido</h5>

                        <asp:Repeater ID="repResumen" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                                    <small class="text-muted"><%# Eval("Producto.Nombre") %> (x<%# Eval("Cantidad") %>)</small>
                                    <small><%# ((decimal)Eval("PrecioUnitario") * (int)Eval("Cantidad")).ToString("C") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div class="d-flex justify-content-between mb-2 mt-3">
                            <span>Subtotal:</span>
                            <asp:Label ID="lblSubtotal" runat="server" Text="$0,00"></asp:Label>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Envío:</span>
                            <asp:Label ID="lblEnvio" runat="server" Text="$0,00"></asp:Label>
                        </div>
                        <hr />
                        <div class="d-flex justify-content-between mb-4">
                            <strong class="fs-5">Total a Pagar</strong>
                            <asp:Label ID="lblTotal" runat="server" CssClass="fs-5 text-success fw-bold" Text="$0,00"></asp:Label>
                        </div>

                        <asp:Button ID="btnConfirmarCompra" runat="server" Text="Confirmar Compra" CssClass="btn btn-primary w-100 btn-lg shadow-sm" OnClick="btnConfirmarCompra_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
