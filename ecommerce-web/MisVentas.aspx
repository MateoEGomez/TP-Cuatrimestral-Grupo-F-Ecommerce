<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisVentas.aspx.cs" Inherits="ecommerce_web.MisVentas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Mi Historial de Ventas</h2>
            <a href="Default.aspx" class="btn btn-outline-primary">Ir a la tienda</a>
        </div>

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Nro. Venta</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Carta vendida</th>
                                <th scope="col">Precio</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="ps-4 fw-bold">#VTA-000318</td>
                                <td>12/10/2026</td>
                                <td>Mew ex 151/165</td>
                                <td>$ 15,000.00</td>
                                <td><span class="badge bg-success">Pagada</span></td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-secondary">Ver detalle</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4 fw-bold">#VTA-000341</td>
                                <td>28/10/2026</td>
                                <td>Pikachu 173/165</td>
                                <td>$ 18,000.00</td>
                                <td><span class="badge bg-warning text-dark">Pago pendiente</span></td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-secondary">Ver detalle</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4 fw-bold">#VTA-000356</td>
                                <td>05/11/2026</td>
                                <td>Gengar 94/165</td>
                                <td>$ 4,000.00</td>
                                <td><span class="badge bg-secondary">Cancelada</span></td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-secondary">Ver detalle</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer text-muted text-center py-3">
                Mostrando las últimas 3 ventas de tus cartas publicadas.
            </div>
        </div>
    </div>
</asp:Content>
