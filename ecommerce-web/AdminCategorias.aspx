<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminCategorias.aspx.cs" Inherits="ecommerce_web.AdminCategorias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>🗂️ Gestión de Categorías</h2>
            <a href="Admin.aspx" class="btn btn-outline-secondary">⬅ Volver al Dashboard</a>
        </div>
        <hr />

        <div class="mb-4 d-flex justify-content-end">
            <a href="AdminCategoriasForm.aspx" class="btn btn-primary">➕ Agregar nueva categoría</a>
        </div>

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Id</th>
                                <th scope="col">Descripción</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repCategorias" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%# Eval("Id") %></td>
                                        <td><%# Eval("Descripcion") %></td>
                                        <td>
                                            <%# (bool)Eval("Activo") ? "<span class='badge bg-success'>Activa</span>" : "<span class='badge bg-danger'>Inactiva</span>" %>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href="AdminCategoriasForm.aspx?id=<%# Eval("Id") %>" class="btn btn-sm btn-outline-warning">✏️ Editar</a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
