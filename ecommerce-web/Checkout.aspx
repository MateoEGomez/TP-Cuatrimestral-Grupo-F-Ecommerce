<%@ Page Title="Finalizar Compra" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="ecommerce_web.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <a href="Carrito.aspx" class="btn btn-outline-secondary">&larr; Volver al carrito
        </a>

        <h2 class="mb-4">Finalizar Compra</h2>

        <div class="row">
            <!-- Columna de Formularios izquierdo -->

            <div class="col-lg-8 mb-4">
                <!-- Organizador -->
                <div class="accordion shadow-sm dark-mode-card" id="accordionCheckout">
                    <!-- Forma de entrega -->
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseEntrega" aria-expanded="true" aria-controls="collapseEntrega">
                                1. Forma de Entrega
                            </button>
                        </h2>
                        <div id="collapseEntrega" class="accordion-collapse collapse show" data-bs-parent="#accordionCheckout">
                            <div class="accordion-body">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="formaEntrega" id="rbRetiro" value="1" />
                                    <label class="form-check-label" for="rbRetiro">
                                        Retiro en el local (Gratis)
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="formaEntrega" id="rbEnvio" value="2" checked />
                                    <label class="form-check-label" for="rbEnvio">
                                        Envio a domicilio
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Direccion de envio -->
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDireccion" aria-expanded="false" aria-controls="collapseDireccion">
                                2. Direccion de Envio
                            </button>
                        </h2>
                        <div id="collapseDireccion" class="accordion-collapse collapse" data-bs-parent="#accordionCheckout">
                            <div class="accordion-body">
                                <div class="row g-3">
                                    <div class="col-md-8">
                                        <label for="txtCalle" class="form-label">Calle</label>
                                        <input type="text" class="form-control" id="txtCalle" placeholder="Ej: Av. Hipolito Yrigoyen" />
                                    </div>
                                    <div class="col-md-4">
                                        <label for="txtNumero" class="form-label">Numero</label>
                                        <input type="text" class="form-control" id="txtNumero" placeholder="Ej: 288" />
                                    </div>
                                    <div class="col-md-8">
                                        <label for="txtLocalidad" class="form-label">Localidad</label>
                                        <input type="text" class="form-control" id="txtLocalidad" placeholder="Ej: General Pacheco" />
                                    </div>
                                    <div class="col-md-4">
                                        <label for="txtCP" class="form-label">Codigo postal</label>
                                        <input type="text" class="form-control" id="txtCP" placeholder="Ej: 1617" />
                                    </div>
                                    <div class="col-md-12">
                                        <label for="txtObservaciones" class="form-label">Observaciones</label>
                                        <input type="text" class="form-control" id="txtObservaciones" placeholder="Color de reja, timbre" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Forma de pago -->
                    <div class="accordion-item bg-transparent">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePago" aria-expanded="false" aria-controls="collapsePago">
                                3. Forma de pago
                            </button>
                        </h2>
                        <div id="collapsePago" class="accordion-collapse collapse" data-bs-parent="#accordionCheckout">
                            <div class="accordion-body">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="formaPago" id="rbEfectivo" />
                                    <label class="form-check-label" for="rbEfectivo">Efectivo</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="formaPago" id="rbTransferencia" checked />
                                    <label class="form-check-label" for="rbTransferencia">Transferencia bancaria</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="formaPago" id="rbTarjeta" />
                                    <label class="form-check-label" for="rbTarjeta">Tarjeta de credito / debito</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="formaPago" id="rbMercadoPago" />
                                    <label class="form-check-label" for="rbMercadoPago">MercadoPago</label>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
            <!-- Columna de Resumen derecha -->
            <div class="col-lg-4">
                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body">
                        <h5 class="card-title mb-4">Tu Pedido</h5>

                        <!-- items miniatura -->
                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                            <small class="text-muted">Charizard ex 199/165</small>
                            <small>$120,000.00</small>
                        </div>
                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                            <small class="text-muted">Sobre Fuerzas Temporales</small>
                            <small>$30,000.00</small>
                        </div>

                        <!-- Totales -->
                        <div class="d-flex justify-content-between mb-2 mt-3">
                            <span>Subtotal:</span>
                            <span>3,500.00</span>
                        </div>
                        <hr />
                        <div class="d-flex justify-content-between mb-4">
                            <strong class="fs-5">Total a Pagar</strong>
                            <strong class="fs-5 text-success">$153,500.00</strong>
                        </div>
                        <button type="button" class="btn btn-primary w-100 btn-lg shadow-sm">Confirmar Compra</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
