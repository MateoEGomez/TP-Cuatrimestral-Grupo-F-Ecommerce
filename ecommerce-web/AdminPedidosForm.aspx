<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminPedidosForm.aspx.cs" Inherits="ecommerce_web.AdminPedidosForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Pedido <asp:Label ID="lblNumero" runat="server" /> <asp:Label ID="lblEstadoActual" runat="server" CssClass="badge fs-6 align-middle" /></h2>
            <a href="AdminPedidos.aspx" class="btn btn-outline-secondary">⬅ Volver al listado</a>
        </div>
        <hr />

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
            <asp:Label ID="lblMensaje" runat="server" />
        </asp:Panel>

        <div class="row g-4">
            <div class="col-lg-7">

                <div class="card shadow-sm dark-mode-card mb-4">
                    <div class="card-header"><h5 class="mb-0">Datos del pedido</h5></div>
                    <div class="card-body">
                        <p class="mb-2"><strong>Fecha:</strong> <asp:Label ID="lblFecha" runat="server" /></p>
                        <p class="mb-2"><strong>Cliente:</strong> <asp:Label ID="lblCliente" runat="server" /></p>
                        <p class="mb-2"><strong>Teléfono:</strong> <asp:Label ID="lblTelefono" runat="server" /></p>
                        <p class="mb-2"><strong>Entrega:</strong> <asp:Label ID="lblEntrega" runat="server" /></p>
                        <p class="mb-2"><strong>Pago:</strong> <asp:Label ID="lblPago" runat="server" /></p>
                        <p class="mb-0"><strong>Total:</strong> <asp:Label ID="lblTotal" runat="server" /></p>
                    </div>
                </div>

                <div class="card shadow-sm dark-mode-card">
                    <div class="card-header"><h5 class="mb-0">Productos</h5></div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-sm align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-3">Carta</th>
                                        <th>Precio Unitario</th>
                                        <th>Cantidad</th>
                                        <th class="text-end pe-3">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="repDetalle" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="ps-3"><%# Eval("Producto.Nombre") %></td>
                                                <td><%# FormatearUsd((decimal)Eval("PrecioUnitario")) %></td>
                                                <td><%# Eval("Cantidad") %></td>
                                                <td class="text-end fw-bold pe-3"><%# FormatearUsd((decimal)Eval("PrecioUnitario") * (int)Eval("Cantidad")) %></td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
            <div class="col-lg-5">

                <div class="card shadow-sm dark-mode-card mb-4">
                    <div class="card-header"><h5 class="mb-0">Cambiar estado</h5></div>
                    <div class="card-body">
                        <asp:Panel ID="pnlCambiarEstado" runat="server">
                            <div class="mb-3">
                                <asp:DropDownList ID="ddlNuevoEstado" runat="server" CssClass="form-select" />
                                <div class="form-text">Si se cancela el pedido, el stock de los productos vuelve al catálogo.</div>
                            </div>
                            <asp:Button ID="btnCambiarEstado" runat="server" Text="💾 Guardar estado" CssClass="btn btn-primary" CausesValidation="false" OnClick="btnCambiarEstado_Click" />
                        </asp:Panel>
                        <asp:Label ID="lblPedidoFinalizado" runat="server" CssClass="text-muted" Visible="false"
                            Text="El pedido está finalizado y ya no puede cambiar de estado." />
                    </div>
                </div>

                <div class="card shadow-sm dark-mode-card">
                    <div class="card-header"><h5 class="mb-0">Observaciones internas</h5></div>
                    <div class="card-body">
                        <div class="mb-2">
                            <asp:TextBox ID="txtObservacion" runat="server" TextMode="MultiLine" Rows="3" MaxLength="500" CssClass="form-control" placeholder="Solo la ve el equipo de administración" />
                            <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ControlToValidate="txtObservacion" ValidationGroup="observacion"
                                ErrorMessage="Escribí la observación." CssClass="text-danger small" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revObservacion" runat="server" ControlToValidate="txtObservacion" ValidationGroup="observacion"
                                ValidationExpression="^[\s\S]{1,500}$" ErrorMessage="Máximo 500 caracteres." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <asp:Button ID="btnAgregarObservacion" runat="server" Text="➕ Agregar observación" CssClass="btn btn-outline-primary mb-3" ValidationGroup="observacion" OnClick="btnAgregarObservacion_Click" />

                        <asp:Label ID="lblSinObservaciones" runat="server" CssClass="text-muted small d-block" Text="Todavía no hay observaciones." />
                        <asp:Repeater ID="repObservaciones" runat="server">
                            <ItemTemplate>
                                <div class="border-top pt-2 mt-2">
                                    <div class="small text-muted"><%# ((DateTime)Eval("Fecha")).ToString("dd/MM/yyyy HH:mm") %> · <%#: Eval("Usuario.Email") %></div>
                                    <div style="white-space: pre-line;"><%#: Eval("Texto") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
