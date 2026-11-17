<%@ Page Title="ABM Productos" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ABMProducto.aspx.cs" Inherits="ecommerce_web.ABMProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <h2 class="mb-4">Panel de Administración - Productos</h2>

        <!-- FORMULARIO DE CARGA / EDICIÓN -->
        <div class="card shadow-sm p-4 mb-4">
            <h4 class="mb-3">Detalle del Producto</h4>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="txtNombre" class="form-label fw-bold">Nombre</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-6 mb-3">
                    <label for="txtPrecio" class="form-label fw-bold">Precio ($)</label>
                    <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" TextMode="Number" step="0.01" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="txtStock" class="form-label fw-bold">Stock</label>
                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="col-md-4 mb-3">
                    <label for="ddlExpansiones" class="form-label fw-bold">Expansión</label>
                    <asp:DropDownList ID="ddlExpansiones" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-4 mb-3">
                    <label for="ddlCategoria" class="form-label fw-bold">Categoría</label>
                    <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="ddlRareza" class="form-label fw-bold">Rareza</label>
                    <asp:DropDownList ID="ddlRareza" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-4 mb-3">
                    <label for="ddlCondicion" class="form-label fw-bold">Condición</label>
                    <asp:DropDownList ID="ddlCondicion" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-4 mb-3">
                    <label for="ddlIdioma" class="form-label fw-bold">Idioma</label>
                    <asp:DropDownList ID="ddlIdioma" runat="server" CssClass="form-select" />
                </div>
            </div>

            <div class="mb-3">
                <label for="txtUrlImagen" class="form-label fw-bold">URL de la Imagen</label>
                <asp:TextBox ID="txtUrlImagen" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label for="txtDescripcion" class="form-label fw-bold">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" CssClass="btn btn-success px-4" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-secondary px-4" />
            </div>
        </div>

        <!-- GRILLA DE LISTADO -->
        <div class="card shadow-sm p-4">
            <h4 class="mb-3">Listado General de Cartas</h4>
            <div class="table-responsive">
                <asp:GridView ID="gvProductos" runat="server" CssClass="table table-striped table-hover align-middle" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="Precio" HeaderText="Precio" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Stock" HeaderText="Stock" />
                        <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:Button ID="btnModificar" runat="server" Text="Modificar" CssClass="btn btn-primary btn-sm me-1" />
                                <asp:Button ID="btnEstado" runat="server" Text="Cambiar Estado" CssClass="btn btn-warning btn-sm" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>