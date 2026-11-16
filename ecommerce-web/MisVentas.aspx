<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisVentas.aspx.cs" Inherits="ecommerce_web.MisVentas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Mi Historial de Ventas / Publicaciones</h2>
            <a href="Default.aspx" class="btn btn-outline-primary">Ir a la tienda</a>
        </div>

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Nro. / ID</th>
                                <th>Imagen</th>
                                <th>Carta publicada</th>
                                <th>Precio</th>
                                <th>Estado</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptMisVentas" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>#VTA-00<%# Eval("Id") %></td>
                                        <td>
                                            <img src='<%# ResolveUrl(Eval("UrlImagen").ToString()) %>' alt="Carta" style="width: 50px; height: 70px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/50x70?text=TCG';" />
                                        </td>
                                        <td class="fw-bold"><%# Eval("Nombre") %></td>
                                        <td>$ <%# Eval("Precio", "{0:N2}") %></td>
                                        <td>
                                            <span class="badge bg-success">Activa / Publicada</span>
                                        </td>
                                        <td>
                                            <a href='Detalle.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary">Ver detalle</a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer text-muted text-center py-3">
                <asp:Label ID="lblMensaje" runat="server" Visible="false" Text="No tenés publicaciones activas todavía."></asp:Label>
                <span>Mostrando las publicaciones registradas en la plataforma.</span>
            </div>
        </div>
    </div>
</asp:Content>