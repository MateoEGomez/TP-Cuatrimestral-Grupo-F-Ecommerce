<%@ Page Title="Moderacion de Publicacion" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminModeracion.aspx.cs" Inherits="ecommerce_web.AdminModeracion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">Moderacion de publicaciones</h2>
                <p class="text-muted mb-0">Revisa, aproba u oculta cartas publicadas en la plataforma.</p>
            </div>
            <a href="Admin.aspx" class="btn btn-outline-secondary">&larr; Volver al Panel Admin</a>
        </div>

        <!-- Filtros -->
        <div class="card shadow-sm dark-mode-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label for="<%= txtFiltro.ClientID %>" class="form-label fw-bold">Buscar cartas o vendedor</label>
                        <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control" placeholder="ej: Charizard, Correo o nombre..."></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label for="<%=ddlEstado.ClientID %>" class="form-label fw-bold">Filtrar por estado / origen</label>
                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todas las publicaciones" Value="todos" />
                            <asp:ListItem Text="Activas (Visibles en tienda)" Value="activas" />
                            <asp:ListItem Text="Ocultas / Pausadas" Value="inactivas" />
                            <asp:ListItem Text="Solo publicaciones de usuarios" Value="usuarios" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <asp:Button ID="btnBuscar" runat="server" Text="Filtrar" CssClass="btn btn-primary w-100" OnClick="btnBuscar_Click" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary" OnClick="btnLimpiar_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Mensaje de accion -->
        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert alert-success mb-4">
            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </asp:Panel>

        <!-- Sin resultado -->
        <asp:Panel ID="pnlSinResultados" runat="server" visible="false" CssClass="alert alert-info">
            No se encontraron publicaciones con los filtros seleccionados.
        </asp:Panel>

        <!-- Tabal de Moderacion -->
        <asp:Panel ID="pnlTabla" runat="server" CssClass="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th scope="col" class="ps-4">ID</th>
                                <th scope="col">Carta</th>
                                <th scope="col">Vendedor</th>
                                <th scope="col">Precio</th>
                                <th scope="col">Stock</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Moderacion</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repPublicaciones" runat="server" OnItemCommand="repPublicaciones_ItemCommand">
                                <itemtemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold">#<%# Eval("Id") %></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src='<%# Eval("UrlImagen") != null ? ResolveUrl(Eval("UrlImagen").ToString()) : "" %>'
                                                    alt='<%# Eval("Nombre") %>'
                                                    class="rounded me-3"
                                                    style="width: 45px; height: 62px; object-fit: contain;" />
                                                <div>
                                                    <div class="fw-bold"><%# Eval("Nombre") %></div>
                                                    <small class="text-muted"><%# Eval("Expansion.Nombre") ?? "Sin expansion" %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%# FormatearVendedor(Eval("Vendedor")) %></td>
                                        <td class="fw-bold text-success"><%# ((decimal)Eval("Precio")).ToString("C") %></td>
                                        <td><%# Eval("Stock") %></td>
                                        <td>
                                            <span class='badge <%# (bool)Eval("Activo") ? "bg-success" : "bg-danger" %>'>
                                                <%# (bool)Eval("Activo") ? "Activa" : "Oculta" %>
                                            </span>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href='Detalle.aspx?id=<%# Eval("Id") %>' target="_blank" class="btn btn-sm btn-outline-info me-1">Ver</a>

                                            <asp:LinkButton ID="btnActivar" runat="server"
                                                CommandName="Activar"
                                                CommandArgument='<%# Eval("Id") %>'
                                                CssClass="btn btn-sm btn-outline-success"
                                                Visible='<%# !(bool)Eval("Activo") %>'>
                                                Aprobar / Activar
                                            </asp:LinkButton>

                                            <asp:LinkButton ID="btnOcultar" runat="server"
                                                CommandName="Ocultar"
                                                CommandArgument='<%# Eval("Id") %>'
                                                CssClass="btn btn-sm btn-outline-danger"
                                                Visible='<%# (bool)Eval("Activo") %>'>
                                                Ocultar
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </itemtemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
