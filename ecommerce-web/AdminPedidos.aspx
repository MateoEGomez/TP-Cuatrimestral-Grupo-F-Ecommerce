<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminPedidos.aspx.cs" Inherits="ecommerce_web.AdminPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>🧾 Gestión de Pedidos</h2>
            <a href="Admin.aspx" class="btn btn-outline-secondary">⬅ Volver al Dashboard</a>
        </div>
        <hr />

        <div class="card shadow-sm dark-mode-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label for="<%= ddlEstado.ClientID %>" class="form-label">Estado</label>
                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select" />
                    </div>
                    <div class="col-md-2">
                        <label for="<%= txtDesde.ClientID %>" class="form-label">Desde</label>
                        <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>
                    <div class="col-md-2">
                        <label for="<%= txtHasta.ClientID %>" class="form-label">Hasta</label>
                        <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control" />
                    </div>
                    <div class="col-md-3">
                        <label for="<%= txtCliente.ClientID %>" class="form-label">Cliente</label>
                        <asp:TextBox ID="txtCliente" runat="server" CssClass="form-control" MaxLength="100" placeholder="Nombre, apellido o email" />
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-primary w-100" OnClick="btnFiltrar_Click" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary w-100" OnClick="btnLimpiar_Click" />
                    </div>
                </div>
                <asp:Label ID="lblErrorFiltro" runat="server" CssClass="text-danger small d-block mt-2" Visible="false" />
            </div>
        </div>

        <p class="text-muted mb-2"><asp:Label ID="lblCantidad" runat="server" /></p>

        <asp:Panel ID="pnlSinPedidos" runat="server" Visible="false" CssClass="alert alert-info">
            No hay pedidos que coincidan con los filtros.
        </asp:Panel>

        <asp:Panel ID="pnlTabla" runat="server" CssClass="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Nro. Orden</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Cliente</th>
                                <th scope="col">Entrega</th>
                                <th scope="col">Pago</th>
                                <th scope="col">Total</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repPedidos" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold">#ORD-<%# ((int)Eval("Id")).ToString("D6") %></td>
                                        <td><%# ((DateTime)Eval("Fecha")).ToString("dd/MM/yyyy HH:mm") %></td>
                                        <td>
                                            <%#: Eval("Usuario.Nombre") %> <%#: Eval("Usuario.Apellido") %>
                                            <div class="small text-muted"><%#: Eval("Usuario.Email") %></div>
                                        </td>
                                        <td><%# Eval("FormaEntrega.Descripcion") %></td>
                                        <td><%# Eval("FormaPago.Descripcion") %></td>
                                        <td class="fw-bold"><%# FormatearTotal(Container.DataItem) %></td>
                                        <td>
                                            <span class='badge <%# ObtenerClaseEstado((int)Eval("Estado.Id")) %>'><%# Eval("Estado.Descripcion") %></span>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href="AdminPedidosForm.aspx?id=<%# Eval("Id") %>" class="btn btn-sm btn-outline-warning">✏️ Gestionar</a>
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
