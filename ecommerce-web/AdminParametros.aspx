<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AdminParametros.aspx.cs" Inherits="ecommerce_web.AdminParametros" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>✨ Gestion de Parametros TCG</h2>
            <a href="Admin.aspx" class="btn btn-outline-secondary">⬅ Volver al Dashboard</a>
        </div>
        <hr />

        <!-- SECCION RAREZAS -->
        <div class="card shadow-sm dark-mode-card mb-5">
            <div class="card-header d-flex justify-content-between align-items-center py-3">
                <h5 class="mb-0">💎 Rarezas</h5>
                <a href="AdminParametrosForm.aspx?tipo=rareza" class="btn btn-sm btn-primary">➕ Nueva rareza</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Id</th>
                                <th scope="col">Descripcion</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repRarezas" runat="server">
                                <itemtemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%# Eval("Id") %></td>
                                        <td><%# Eval("Descripcion") %></td>
                                        <td>
                                            <%# (bool)Eval("Activo") ? "<span class='badge bg-success'>Activa</span>" : "<span class='badge bg-danger'>Inactiva</span>" %>
                                        </td>
                                        <td class="text-center pe-4">
                                            <a href="AdminParametrosForm.aspx?tipo=rareza&id=<%# Eval("Id") %>" class="btn btn-sm btn-outline-warning">✏️ Editar</a>
                                        </td>
                                    </tr>
                                </itemtemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- SECCION CONDICIONES -->
        <div class="card shadow-sm dark-mode-card mb-5">
            <div class="card-header d-flex justify-content-between align-items-center py-3">
                <h5 class="mb-0">🃏 Condiciones</h5>
                <a href="AdminParametrosForm.aspx?tipo=condicion" class="btn btn-sm btn-primary">➕ Nueva condicion</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Id</th>
                                <th scope="col">Descripcion</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repCondiciones" runat="server">
                                <itemtemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%# Eval("Id") %></td>
                                        <td><%# Eval("Descripcion") %></td>
                                        <td><%# (bool)Eval("Activo") ? "<span class='badge bg-success'>Activa</span>" : "<span class='badge bg-danger'>Inactiva</span>" %></td>
                                        <td class="text-center pe-4">
                                            <a href="AdminParametrosForm.aspx?tipo=condicion&id=<%# Eval("Id") %>" class="btn btn-sm btn-outline-warning">✏️ Editar</a>
                                        </td>
                                    </tr>
                                </itemtemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- SECCION IDIOMAS -->
        <div class="card shadow-sm dark-mode-card">
            <div class="card-header d-flex justify-content-between align-items-center py-3">
                <h5 class="mb-0">🌐 Idiomas</h5>
                <a href="AdminParametrosForm.aspx?tipo=idioma" class="btn btn-sm btn-primary">➕ Nuevo idioma</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="ps-4">Id</th>
                                <th scope="col">Descripcion</th>
                                <th scope="col">Estado</th>
                                <th scope="col" class="text-center pe-4">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="repIdiomas" runat="server">
                                <itemtemplate>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%# Eval("Id") %></td>
                                        <td><%# Eval("Descripcion") %></td>
                                        <td><%# (bool)Eval("Activo") ? "<span class='badge bg-success'>Activa</span>" : "<span class='badge bg-danger'>Inactiva</span>" %></td>
                                        <td class="text-center pe-4">
                                            <a href="AdminParametrosForm.aspx?tipo=idioma&id=<%# Eval("Id") %>" class="btn btn-sm btn-outline-warning">✏️ Editar</a>
                                        </td>
                                    </tr>
                                </itemtemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
