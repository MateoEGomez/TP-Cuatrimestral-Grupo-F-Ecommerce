<%@ Page Title="Moderación de publicaciones" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminModeracion.aspx.cs" Inherits="ecommerce_web.AdminModeracion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">Moderación de publicaciones</h2>
                <p class="text-muted mb-0">Las cartas que publican los usuarios no aparecen en la tienda hasta que las aprobás.</p>
            </div>
            <a href="Admin.aspx" class="btn btn-outline-secondary">&larr; Volver al Panel Admin</a>
        </div>

        <div class="card shadow-sm dark-mode-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label for="<%= txtFiltro.ClientID %>" class="form-label fw-bold">Buscar carta o vendedor</label>
                        <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control" MaxLength="100" placeholder="ej: Charizard, email o nombre..."></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label for="<%= ddlEstado.ClientID %>" class="form-label fw-bold">Estado</label>
                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <asp:Button ID="btnBuscar" runat="server" Text="Filtrar" CssClass="btn btn-primary w-100" CausesValidation="false" OnClick="btnBuscar_Click" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnLimpiar_Click" />
                    </div>
                </div>
            </div>
        </div>

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert alert-success mb-4">
            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </asp:Panel>

        <asp:Panel ID="pnlRechazo" runat="server" Visible="false" CssClass="card border-danger shadow-sm dark-mode-card mb-4">
            <div class="card-body">
                <h5 class="card-title text-danger mb-3">Rechazar publicación <asp:Label ID="lblRechazoPublicacion" runat="server" /></h5>
                <asp:HiddenField ID="hfIdRechazo" runat="server" />
                <label for="<%= txtMotivo.ClientID %>" class="form-label">Motivo del rechazo (lo ve el vendedor)</label>
                <asp:TextBox ID="txtMotivo" runat="server" CssClass="form-control" MaxLength="200" placeholder="ej: La foto no corresponde a la carta publicada." />
                <asp:RequiredFieldValidator ID="rfvMotivo" runat="server" ControlToValidate="txtMotivo" ValidationGroup="rechazo"
                    ErrorMessage="Escribí el motivo del rechazo." CssClass="text-danger small" Display="Dynamic" />
                <div class="d-flex gap-2 mt-3">
                    <asp:Button ID="btnConfirmarRechazo" runat="server" Text="Rechazar publicación" CssClass="btn btn-danger" ValidationGroup="rechazo" OnClick="btnConfirmarRechazo_Click" />
                    <asp:Button ID="btnCancelarRechazo" runat="server" Text="Cancelar" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnCancelarRechazo_Click" />
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlSinResultados" runat="server" Visible="false" CssClass="alert alert-info">
            No hay publicaciones con los filtros seleccionados.
        </asp:Panel>

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
                                <th scope="col">Estado</th>
                                <th scope="col">Visibilidad</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repPublicaciones" runat="server" OnItemCommand="repPublicaciones_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold">#<%# Eval("Id") %></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src='<%# Eval("UrlImagen") != null ? ResolveUrl(Eval("UrlImagen").ToString()) : "" %>'
                                                    alt="Carta" class="rounded me-3" style="width: 45px; height: 62px; object-fit: contain;" />
                                                <div>
                                                    <div class="fw-bold"><%#: Eval("Nombre") %></div>
                                                    <small class="text-muted"><%#: Eval("Expansion.Nombre") ?? "Sin expansión" %></small>
                                                    <div class="small text-muted fst-italic"><%#: Eval("Descripcion") %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%# FormatearVendedor(Eval("Vendedor")) %></td>
                                        <td class="fw-bold">USD <%# ((decimal)Eval("Precio")).ToString("N2", System.Globalization.CultureInfo.InvariantCulture) %></td>
                                        <td>
                                            <span class='badge <%# ecommerce_web.EstiloPublicacion.ObtenerClaseEstado((int)Eval("EstadoPublicacion.Id")) %>'><%# Eval("EstadoPublicacion.Descripcion") %></span>
                                            <div class="small text-danger"><%#: Eval("MotivoRechazo") %></div>
                                        </td>
                                        <td>
                                            <span class='badge <%# (bool)Eval("Activo") ? "bg-success" : "bg-secondary" %>'><%# (bool)Eval("Activo") ? "Activa" : "Pausada" %></span>
                                        </td>
                                        <td class="text-center pe-4 text-nowrap">
                                            <a href='Detalle.aspx?id=<%# Eval("Id") %>' target="_blank" class="btn btn-sm btn-outline-info me-1">Ver</a>
                                            <asp:LinkButton ID="btnAprobar" runat="server" CommandName="Aprobar" CommandArgument='<%# Eval("Id") %>' CausesValidation="false"
                                                CssClass="btn btn-sm btn-outline-success me-1" Visible='<%# (int)Eval("EstadoPublicacion.Id") != 2 %>'>✔ Aprobar</asp:LinkButton>
                                            <asp:LinkButton ID="btnRechazar" runat="server" CommandName="Rechazar" CommandArgument='<%# Eval("Id") %>' CausesValidation="false"
                                                CssClass="btn btn-sm btn-outline-danger" Visible='<%# (int)Eval("EstadoPublicacion.Id") != 3 %>'>✖ Rechazar</asp:LinkButton>
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
