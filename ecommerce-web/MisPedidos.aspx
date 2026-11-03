<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MisPedidos.aspx.cs" Inherits="ecommerce_web.MisPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Mi Historial de Compras</h2>
            <a href="Default.aspx" class="btn btn-outline-primary">Ir a la tienda</a>
        </div>

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Nro. Orden</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Total</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Accion</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Pedido Estatico 1 -->
                            <tr>
                                <td class="ps-4 fw-bold">#ORD-001042</td>
                                <td>15/10/2026</td>
                                <td>$ 153,500.00</td>
                                <td><span class="badge bg-success">Entregado</span></td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-secondary">Ver detalle</button>
                                </td>
                            </tr>
                            <!-- Pedido Estatico 2 -->
                            <tr>
                                <td class="ps-4 fw-bold">#ORD-001089</td>
                                <td>20/10/2026</td>
                                <td>$ 45,000.00</td>
                                <td><span class="badge bg-warning text-dark">En camino</span></td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-secondary">Ver detalle</button>
                                </td>
                            </tr>
                            <!-- Pedido Estatico 3 -->
                            <tr>
                                <td class="ps-4 fw-bold">#ORD-001105</td>
                                <td>02/11/2026</td>
                                <td>$ 12,500.00</td>
                                <td><span class="badge bg-primary">procesando pago</span></td>
                                <td class="text-center pe-4">
                                    <button type="button" class="btn btn-sm btn-outline-secondary">Ver detalle</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer text-muted text-center py-3">
                Mostrando los ultimos 3 pedidos realizados.
            </div>
        </div>
    </div>
</asp:Content>
