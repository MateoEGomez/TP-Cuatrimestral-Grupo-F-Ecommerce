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

        <div class="row">
            <!-- Columna de Formularios izquierda -->
            <div class="col-lg-8 mb-4">
                <div class="accordion shadow-sm dark-mode-card" id="accordionCheckout">

                    <!-- 1. Forma de entrega -->
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseEntrega" aria-expanded="true" aria-controls="collapseEntrega">
                                1. Forma de Entrega
                            </button>
                        </h2>
                        <div id="collapseEntrega" class="accordion-collapse collapse show" data-bs-parent="#accordionCheckout">
                            <div class="accordion-body">
                                <asp:RadioButtonList ID="rblFormaEntrega" runat="server" CssClass="form-check" RepeatLayout="Flow" AutoPostBack="true" OnSelectedIndexChanged="rblFormaEntrega_SelectedIndexChanged"></asp:RadioButtonList>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Direccion de envio -->
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDireccion" aria-expanded="false" aria-controls="collapseDireccion">
                                2. Dirección de Envío
                            </button>
                        </h2>
                        <div id="collapseDireccion" class="accordion-collapse collapse" data-bs-parent="#accordionCheckout">
                            <div class="accordion-body">
                                <div class="row g-3">
                                    <div class="col-md-8">
                                        <label for="txtCalle" class="form-label">Calle</label>
                                        <asp:TextBox ID="txtCalle" runat="server" CssClass="form-control" placeholder="Ej: Av. Hipólito Yrigoyen" />
                                    </div>
                                    <div class="col-md-4">
                                        <label for="txtNumero" class="form-label">Número</label>
                                        <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control" placeholder="Ej: 288" />
                                    </div>
                                    <div class="col-md-8">
                                        <label for="txtLocalidad" class="form-label">Localidad</label>
                                        <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control" placeholder="Ej: General Pacheco" />
                                    </div>
                                    <div class="col-md-4">
                                        <label for="txtCP" class="form-label">Código postal</label>
                                        <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" placeholder="Ej: 1617" />
                                    </div>
                                    <div class="col-md-12">
                                        <label for="txtObservaciones" class="form-label">Observaciones</label>
                                        <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" placeholder="Color de reja, timbre" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 3. Forma de pago -->
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePago" aria-expanded="false" aria-controls="collapsePago">
                                3. Forma de pago
                            </button>
                        </h2>
                        <div id="collapsePago" class="accordion-collapse collapse" data-bs-parent="#accordionCheckout">
                            <div class="accordion-body">
                                <asp:RadioButtonList ID="rblFormaPago" runat="server" CssClass="form-check" RepeatLayout="Flow"></asp:RadioButtonList>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Columna de Resumen derecha -->
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
        </div>
    </div>
</asp:Content>