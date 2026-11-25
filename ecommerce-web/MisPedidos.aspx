<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisPedidos.aspx.cs" Inherits="ecommerce_web.MisPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Mi Historial de Compras</h2>
            <a href="Default.aspx" class="btn btn-outline-primary">Ir a la tienda</a>
        </div>

        <asp:Panel ID="pnlSinPedidos" runat="server" Visible="false" CssClass="alert alert-info">
            Todavia no realizaste ninguna compra. <a href="Default.aspx" class="alert-link">Explora el catalogo de cartas</a>.
        </asp:Panel>

        <asp:Panel ID="pnlTablaPedidos" runat="server" CssClass="card shadow-sm dark-mode-card mb-4">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th scope="col" class="ps-4">Nro. Orden</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Entrega</th>
                                <th scope="col">Pago</th>
                                <th scope="col">Total</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Accion</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repPedidos" runat="server" OnItemCommand="repPedidos_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold">#ORD-<%# ((int)Eval("Id")).ToString("D6") %></td>
                                        <td><%# ((DateTime)Eval("Fecha")).ToString("dd/MM/yyyy HH:mm") %></td>
                                        <td><%# Eval("FormaEntrega.Descripcion") %></td>
                                        <td><%# Eval("FormaPago.Descripcion") %></td>
                                        <td class="fw-bold text-success"><%# FormatearTotal(Container.DataItem) %></td>
                                        <td>
                                            <span class='badge <%# ObtenerClaseEstado((int)Eval("Estado.Id")) %>'>
                                                <%# Eval("Estado.Descripcion") %>
                                            </span>
                                        </td>
                                        <td class="text-center pe-4">
                                            <asp:LinkButton ID="btnVerDetalle" runat="server"
                                                CommandName="VerDetalle"
                                                CommandArgument='<%# Eval("Id") %>'
                                                CssClass="btn btn-sm btn-outline-primary">
                                            Ver Detalle
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlDetallePedido" runat="server" Visible="false" CssClass="card shadow-sm dark-mode-card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Detalle de la orden <asp:Label ID="lblNumeroOrdenDetalle" runat="server" CssClass="fw-bold" /></h5>
                <asp:Button ID="btnCerrarDetalle" runat="server" Text="Cerrar ✖" CssClass="btn btn-sm btn-outline-secondary" OnClick="btnCerrarDetalle_Click" />
            </div>
            <div class="card-body">
                <p class="mb-3">
                    <strong>Entrega:</strong> <asp:Label ID="lblInfoEntrega" runat="server" />
                </p>
                <div class="table-responsive">
                    <table class="table table-sm align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Carta</th>
                                <th>Precio Unitario</th>
                                <th>Cantidad</th>
                                <th class="text-end">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repDetallePedido" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("Producto.Nombre") %></td>
                                        <td><%# FormatearUsd((decimal)Eval("PrecioUnitario")) %></td>
                                        <td><%# Eval("Cantidad") %></td>
                                        <td class="text-end fw-bold"><%# FormatearUsd((decimal)Eval("PrecioUnitario") * (int)Eval("Cantidad")) %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>

    </div>
</asp:Content>
