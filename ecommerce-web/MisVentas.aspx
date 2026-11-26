<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisVentas.aspx.cs" Inherits="ecommerce_web.MisVentas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Mis Ventas</h2>
            <a href="Publicar.aspx" class="btn btn-success">🏷️ Publicar otra carta</a>
        </div>

        <asp:Panel ID="pnlPublicada" runat="server" Visible="false" CssClass="alert alert-success">
            ¡Tu carta se publicó! Queda <strong>pendiente de aprobación</strong>: va a aparecer en la tienda cuando un administrador la revise.
        </asp:Panel>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card shadow-sm dark-mode-card h-100">
                    <div class="card-body text-center">
                        <div class="text-muted small">Publicaciones a la venta</div>
                        <div class="fs-3 fw-bold"><asp:Label ID="lblPublicacionesActivas" runat="server" Text="0" /></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm dark-mode-card h-100">
                    <div class="card-body text-center">
                        <div class="text-muted small">Unidades vendidas</div>
                        <div class="fs-3 fw-bold"><asp:Label ID="lblUnidadesVendidas" runat="server" Text="0" /></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm dark-mode-card h-100">
                    <div class="card-body text-center">
                        <div class="text-muted small">Total vendido</div>
                        <div class="fs-3 fw-bold text-success"><asp:Label ID="lblTotalVendido" runat="server" Text="USD 0.00" /></div>
                        <div class="small text-muted">Sin contar pedidos cancelados</div>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mb-3">Ventas</h4>
        <asp:Panel ID="pnlSinVentas" runat="server" Visible="false" CssClass="alert alert-info">
            Todavía no vendiste ninguna carta.
        </asp:Panel>
        <asp:Panel ID="pnlVentas" runat="server" CssClass="card shadow-sm dark-mode-card mb-5">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="ps-4">Nro. Orden</th>
                                <th>Fecha</th>
                                <th>Cartas vendidas</th>
                                <th>Total</th>
                                <th class="pe-4">Estado del pedido</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repVentas" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold">#ORD-<%# ((int)Eval("Id")).ToString("D6") %></td>
                                        <td><%# ((DateTime)Eval("Fecha")).ToString("dd/MM/yyyy HH:mm") %></td>
                                        <td>
                                            <asp:Repeater ID="repItems" runat="server" DataSource='<%# Eval("Detalles") %>'>
                                                <ItemTemplate>
                                                    <div><%# Eval("Cantidad") %> × <%# Eval("Producto.Nombre") %> <span class="text-muted small">(<%# FormatearUsd((decimal)Eval("PrecioUnitario")) %> c/u)</span></div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </td>
                                        <td class="fw-bold"><%# FormatearUsd((decimal)Eval("Total")) %></td>
                                        <td class="pe-4">
                                            <span class='badge <%# ecommerce_web.EstiloPedido.ObtenerClaseEstado((int)Eval("Estado.Id")) %>'><%# Eval("Estado.Descripcion") %></span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>

        <h4 class="mb-3">Mis publicaciones</h4>
        <asp:Panel ID="pnlSinPublicaciones" runat="server" Visible="false" CssClass="alert alert-info">
            No tenés publicaciones todavía. <a href="Publicar.aspx" class="alert-link">Publicá tu primera carta</a>.
        </asp:Panel>
        <asp:Panel ID="pnlPublicaciones" runat="server" CssClass="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="ps-4">Imagen</th>
                                <th>Carta</th>
                                <th>Precio</th>
                                <th>Stock</th>
                                <th>Estado</th>
                                <th class="text-center pe-4">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repPublicaciones" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4">
                                            <img src='<%# Eval("UrlImagen") != null ? ResolveUrl(Eval("UrlImagen").ToString()) : "" %>' alt="Carta" style="width: 50px; height: 70px; object-fit: contain;" />
                                        </td>
                                        <td class="fw-bold"><%# Eval("Nombre") %></td>
                                        <td><%# FormatearUsd((decimal)Eval("Precio")) %></td>
                                        <td><%# Eval("Stock") %></td>
                                        <td><%# ObtenerEstadoPublicacion(Container.DataItem) %></td>
                                        <td class="text-center pe-4">
                                            <div class="d-flex justify-content-center gap-1 flex-wrap">
                                                <asp:HyperLink ID="lnkVer" runat="server" Text="Ver en la tienda" CssClass="btn btn-sm btn-outline-primary"
                                                    NavigateUrl='<%# "Detalle.aspx?id=" + Eval("Id") %>'
                                                    Visible='<%# EstaALaVenta(Container.DataItem) %>' />

                                                <asp:LinkButton ID="btnPausar" runat="server" CssClass="btn btn-sm btn-outline-warning"
                                                    CommandName="Pausar" CommandArgument='<%# Eval("Id") %>'
                                                    Visible='<%# PuedePausar(Container.DataItem) %>'
                                                    OnCommand="repPublicaciones_ItemCommand">Pausar</asp:LinkButton>

                                                <asp:LinkButton ID="btnReactivar" runat="server" CssClass="btn btn-sm btn-outline-success"
                                                    CommandName="Reactivar" CommandArgument='<%# Eval("Id") %>'
                                                    Visible='<%# PuedeReactivar(Container.DataItem) %>'
                                                    OnCommand="repPublicaciones_ItemCommand">Reactivar</asp:LinkButton>

                                                <asp:LinkButton ID="btnBaja" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                                    CommandName="Baja" CommandArgument='<%# Eval("Id") %>'
                                                    Visible='<%# PuedeDarDeBaja(Container.DataItem) %>'
                                                    OnClientClick="return confirm('¿Seguro que querés dar de baja esta publicación?');"
                                                    OnCommand="repPublicaciones_ItemCommand">Dar de baja</asp:LinkButton>
                                            </div>
                                        </td>
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
