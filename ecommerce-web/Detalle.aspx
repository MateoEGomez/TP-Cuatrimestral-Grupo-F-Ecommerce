<%@ Page Title="Detalle" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Detalle.aspx.cs" Inherits="ecommerce_web.Detalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="container mt-5 mb-5">
        
        <!-- Botón Volver -->
        <div class="mb-4">
            <a href="Default.aspx" class="btn btn-outline-secondary">
                &larr; Volver al catálogo
            </a>
        </div>

<!-- Columna Imagen Dinámica -->
<div class="col-md-5 text-center mb-4 mb-md-0">
    <div class="p-3 glow-ultra d-inline-block">
        <img src="<%= ProductoSeleccionado != null && !string.IsNullOrEmpty(ProductoSeleccionado.UrlImagen) ? ResolveUrl(ProductoSeleccionado.UrlImagen) : "" %>" alt="Carta TCG" class="img-fluid rounded" style="max-height: 500px; object-fit: contain;" />
    </div>
</div>

<!-- Columna Información Dinámica -->
<div class="col-md-7 d-flex flex-column justify-content-center">
    <h2 class="display-5 fw-bold mb-2"><%= ProductoSeleccionado != null ? ProductoSeleccionado.Nombre : "" %></h2>
    
    <h3 class="text-success fw-bold mb-4">$ <%= ProductoSeleccionado != null ? ProductoSeleccionado.Precio.ToString("N2") : "0.00" %></h3>

    <p class="lead mb-4">
        <%= ProductoSeleccionado != null ? ProductoSeleccionado.Descripcion : "" %>
    </p>

    <hr class="mb-4" />

    <% if (EsPublicacionPropia) { %>
        <div class="alert alert-info fw-bold" role="alert">
            Esta carta fue publicada por vos. Podés administrarla desde <a href="MisVentas.aspx" class="alert-link">Mis Ventas</a>.
        </div>
    <% } else if (ProductoSeleccionado != null && ProductoSeleccionado.Stock > 0) { %>
        <!-- Selector de Cantidad -->
        <div class="row align-items-center mb-4">
            <div class="col-auto">
                <label for="txtCantidad" class="col-form-label fw-bold">Cantidad:</label>
            </div>
            <div class="col-auto">
                <input type="number" id="txtCantidad" class="form-control text-center" value="1" min="1" max="<%= ProductoSeleccionado.Stock %>" style="width: 80px;" />
            </div>
            <div class="col-auto text-muted small">
                (Disponibles: <%= ProductoSeleccionado.Stock %>)
            </div>
        </div>

        <!-- Botón de Compra -->
        <div class="d-grid gap-2 d-md-flex justify-content-md-start">
            <button type="button" class="btn btn-primary btn-lg px-4 me-md-2 shadow-sm">
                🛒 Agregar al Carrito
            </button>
        </div>
    <% } else { %>
        <div class="alert alert-secondary fw-bold" role="alert">
            Sin stock disponible.
        </div>
    <% } %>
</div>

</asp:Content>