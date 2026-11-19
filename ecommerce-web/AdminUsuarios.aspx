<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminUsuarios.aspx.cs" Inherits="ecommerce_web.AdminUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>👥 Gestión de Usuarios</h2>
            <a href="Admin.aspx" class="btn btn-outline-secondary">⬅ Volver al Dashboard</a>
        </div>
        <hr />

        <div class="mb-4 d-flex justify-content-end">
            <a href="AdminUsuariosForm.aspx" class="btn btn-primary">➕ Agregar nuevo usuario</a>
        </div>

        <div class="card shadow-sm dark-mode-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Id</th>
                                <th scope="col">Email</th>
                                <th scope="col">Nombre</th>
                                <th scope="col">Teléfono</th>
                                <th scope="col">Perfil</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repUsuarios" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%# Eval("Id") %></td>
                                        <td><%# Eval("Email") %></td>
                                        <td><%# Eval("Nombre") %> <%# Eval("Apellido") %></td>
                                        <td><%# Eval("Telefono") %></td>
                                        <td><%# Eval("Perfil.Descripcion") %></td>
                                        <td>
                                            <%# (bool)Eval("Activo") ? "<span class='badge bg-success'>Activo</span>" : "<span class='badge bg-danger'>Inactivo</span>" %>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href="AdminUsuariosForm.aspx?id=<%# Eval("Id") %>" class="btn btn-sm btn-outline-warning">✏️ Editar</a>
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
