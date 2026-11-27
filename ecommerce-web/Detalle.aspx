<%@ Page Title="Detalle" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Detalle.aspx.cs" Inherits="ecommerce_web.Detalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-5 mb-5">

        <!-- Botón Volver -->
        <div class="mb-4">
            <a href="Default.aspx" class="btn btn-outline-secondary">&larr; Volver al catálogo
            </a>
        </div>
        <div class="row">
            <!-- Columna Imagen Dinámica -->
            <div class="col-md-5 text-center mb-4 mb-md-0">
                <div class="p-3 glow-ultra d-inline-block">
                    <img id="imgPrincipalDetalle"
                         src="<%= ImagenPrincipalUrl() %>"
                         alt="Carta TCG"
                         class="img-fluid rounded"
                         style="max-height: 500px; object-fit: contain;" />
                </div>

                <% if (ImagenesProducto != null && ImagenesProducto.Count > 1) { %>
                    <div class="d-flex justify-content-center gap-2 mt-3 flex-wrap">
                        <% foreach (var imgUrl in ImagenesProducto) { %>
                            <img src="<%= ResolveUrl(imgUrl) %>"
                                 alt="Vista de la carta"
                                 class="img-thumbnail"
                                 style="width: 72px; height: 96px; object-fit: contain; cursor: pointer;"
                                 onclick="document.getElementById('imgPrincipalDetalle').src = this.src;" />
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- Columna Información Dinámica -->
            <div class="col-md-7 d-flex flex-column justify-content-center">
                <h2 class="display-5 fw-bold mb-2"><%= ProductoSeleccionado != null ? ProductoSeleccionado.Nombre : "" %></h2>

                <h3 class="text-success fw-bold mb-2"><%= PrecioFormateado() %></h3>
                <p class="text-muted mb-4"><%= TextoVendedor() %></p>

                <p class="lead mb-4">
                    <%: ProductoSeleccionado != null ? ProductoSeleccionado.Descripcion : "" %>
                </p>

                <hr class="mb-4" />

                <% if (EsPublicacionPropia)
                    { %>
                <div class="alert alert-info fw-bold" role="alert">
                    Esta carta fue publicada por vos. Podés administrarla desde <a href="MisVentas.aspx" class="alert-link">Mis Ventas</a>.
                </div>
                <% }
                    else if (!PublicacionAprobada)
                    { %>
                <div class="alert alert-warning fw-bold" role="alert">
                    Esta publicación todavía no está aprobada. Revisala desde <a href="AdminModeracion.aspx" class="alert-link">Moderación</a>.
                </div>
                <% }
                    else if (ProductoSeleccionado != null && ProductoSeleccionado.Stock > 0)
                    { %>
                <!-- Selector de Cantidad -->
                <div class="row align-items-center mb-4">
                    <div class="col-auto">
                        <label for="<%= txtCantidad.ClientID %>" class="col-form-label fw-bold">Cantidad:</label>
                    </div>
                    <div class="col-auto">
                        <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" min="1" Text="1" CssClass="form-control text-center" Style="width: 80px;" />
                    </div>
                    <div class="col-auto text-muted small">
                        (Disponibles: <%= ProductoSeleccionado.Stock %>)
                    </div>
                    <div class="col-12">
                        <asp:RequiredFieldValidator ID="rfvCantidad" runat="server" ControlToValidate="txtCantidad" ValidationGroup="carrito"
                            ErrorMessage="Ingresá una cantidad." CssClass="text-danger small" Display="Dynamic" />
                        <asp:RangeValidator ID="rvCantidad" runat="server" ControlToValidate="txtCantidad" ValidationGroup="carrito" Type="Integer" MinimumValue="1" MaximumValue="1"
                            CssClass="text-danger small" Display="Dynamic" />
                    </div>
                </div>

                <!-- Botón de Compra -->
                <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                    <asp:Button ID="btnAgregarCarrito" runat="server" Text="🛒 Agregar al Carrito" CssClass="btn btn-primary btn-lg px-4 me-md-2 shadow-sm" ValidationGroup="carrito" OnClick="btnAgregarCarrito_Click" />
                    <a href="Carrito.aspx" class="btn btn-outline-secondary btn-lg px-4">Ver Carrito</a>
                </div>

                <asp:Panel ID="pnlMensajeDetalle" runat="server" Visible="false" CssClass="alert alert-success mt-3 mb-0">
                    <asp:Label ID="lblMensajeDetalle" runat="server" Text=""></asp:Label>
                </asp:Panel>
                <% }
                else
                { %>
                <div class="alert alert-secondary fw-bold" role="alert">
                    Sin stock disponible.
                </div>
                <% } %>
            </div>
        </div>
    </div>
</asp:Content>