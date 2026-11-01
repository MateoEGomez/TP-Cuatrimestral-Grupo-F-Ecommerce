<%@ Page Title="Carrito de compra" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Carrito.aspx.cs" Inherits="ecommerce_web.Carrito" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <h2 class="mb-4">Mi Carrito de Compras</h2>

        <div class="row">
            <!-- Tabla de Productos -->
            <div class="col-lg-8 mb-4">
                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" class="ps-4">Producto</th>
                                        <th scope="col" class="text-center">Precio</th>
                                        <th scope="col" class="text-center">Cantidad</th>
                                        <th scope="col" class="text-center">Subtotal</th>
                                        <th scope="col" class="text-center pe-4">Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Ítem 1 (Estático) -->
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <img src="https://images.pokemontcg.io/sv3pt5/199.png" alt="Charizard ex" style="width: 50px; height: auto;" class="me-3 rounded shadow-sm">
                                                <div>
                                                    <h6 class="mb-0">Charizard ex 199/165</h6>
                                                    <small class="text-muted">Ilustración Especial</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">$120,000.00</td>
                                        <td class="text-center">
                                            <input type="number" class="form-control form-control-sm mx-auto text-center" value="1" min="1" style="width: 60px;">
                                        </td>
                                        <td class="text-center fw-bold">$120,000.00</td>
                                        <td class="text-center pe-4">
                                            <button type="button" class="btn btn-outline-danger btn-sm">🗑️</button>
                                        </td>
                                    </tr>
                                    <!-- Ítem 2 (Estático) -->
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <img src="https://images.pokemontcg.io/sv5/1.png" alt="Bulbasaur" style="width: 50px; height: auto;" class="me-3 rounded shadow-sm">
                                                <div>
                                                    <h6 class="mb-0">Sobre Fuerzas Temporales</h6>
                                                    <small class="text-muted">Booster Pack</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">$7,500.00</td>
                                        <td class="text-center">
                                            <input type="number" class="form-control form-control-sm mx-auto text-center" value="4" min="1" style="width: 60px;">
                                        </td>
                                        <td class="text-center fw-bold">$30,000.00</td>
                                        <td class="text-center pe-4">
                                            <button type="button" class="btn btn-outline-danger btn-sm">🗑️</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Resumen de Compra -->
            <div class="col-lg-4">
                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body">
                        <h5 class="card-title mb-4">Resumen de la compra</h5>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal (5 productos):</span>
                            <span>$150,000.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-success">
                            <span>Descuentos:</span>
                            <span>-$0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <strong class="fs-5">Total:</strong>
                            <strong class="fs-5">$150,000.00</strong>
                        </div>

                        <a href="Checkout.aspx" class="btn btn-success w-100 btn-lg shadow-sm">Ir a Pagar</a>
                        <a href="Default.aspx" class="btn btn-outline-secondary w-100 mt-2">Seguir comprando</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
