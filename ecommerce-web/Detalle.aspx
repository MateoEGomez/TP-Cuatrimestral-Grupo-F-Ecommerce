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

        <div class="row bg-body-tertiary p-4 rounded shadow-sm dark-mode-card">
            <!-- Columna Imagen -->
            <div class="col-md-5 text-center mb-4 mb-md-0">
                <div class="p-3 glow-ultra d-inline-block">
                    <img src="https://images.pokemontcg.io/sv3pt5/199_hires.png" alt="Charizard ex" class="img-fluid rounded" style="max-height: 500px; object-fit: contain;" />
                </div>
            </div>

            <!-- Columna Información -->
            <div class="col-md-7 d-flex flex-column justify-content-center">
                <h2 class="display-5 fw-bold mb-2">Charizard ex 199/165</h2>
                
                <div class="mb-3">
                    <span class="badge text-bg-warning fs-6 me-2">Rareza: Ilustración Especial</span>
                    <span class="badge text-bg-primary fs-6 me-2">Expansión: 151</span>
                    <span class="badge text-bg-success fs-6">Condición: Near Mint</span>
                </div>

                <h3 class="text-success fw-bold mb-4">$ 120,000.00</h3>

                <p class="lead mb-4">
                    Carta de ilustración especial de la expansión Escarlata y Púrpura 151. Guardada en folio protector desde el momento de apertura del sobre. Ideal para coleccionistas.
                </p>

                <hr class="mb-4" />

                <!-- Controles de Compra Estáticos -->
                <div class="row align-items-center mb-4">
                    <div class="col-auto">
                        <label for="txtCantidad" class="col-form-label fw-bold">Cantidad:</label>
                    </div>
                    <div class="col-auto">
                        <input type="number" id="txtCantidad" class="form-control text-center" value="1" min="1" max="5" style="width: 80px;" />
                    </div>
                    <div class="col-auto text-muted">
                        <small>(Stock disponible: 1)</small>
                    </div>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                    <button type="button" class="btn btn-primary btn-lg px-4 me-md-2 shadow-sm">
                        🛒 Agregar al Carrito
                    </button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
