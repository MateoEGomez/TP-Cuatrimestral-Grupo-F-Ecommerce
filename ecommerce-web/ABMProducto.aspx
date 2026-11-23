<%@ Page Title="ABM Productos" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ABMProducto.aspx.cs" Inherits="ecommerce_web.ABMProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Panel de Administración - Productos</h2>
            <a href="Admin.aspx" class="btn btn-outline-secondary">⬅ Volver al Dashboard</a>
        </div>

        <div class="card shadow-sm p-4 mb-4 dark-mode-card">
            <h4 class="mb-3">
                <asp:Label ID="lblTituloForm" runat="server" Text="Nuevo producto" /></h4>

            <div class="row">
                <div class="col-md-9">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="txtNombre" class="form-label fw-bold">Nombre</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="Ingresá el nombre del producto." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="txtPrecio" class="form-label fw-bold">Precio ($)</label>
                            <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" placeholder="Ej: 1500" />
                            <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecio" ErrorMessage="Ingresá el precio." CssClass="text-danger small" Display="Dynamic" />
                            <asp:CompareValidator ID="cvPrecio" runat="server" ControlToValidate="txtPrecio" Type="Double" Operator="GreaterThan" ValueToCompare="0" ErrorMessage="El precio tiene que ser un número mayor a 0." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="txtStock" class="form-label fw-bold">Stock</label>
                            <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" MaxLength="6" />
                            <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock" ErrorMessage="Ingresá el stock." CssClass="text-danger small" Display="Dynamic" />
                            <asp:RangeValidator ID="rvStock" runat="server" ControlToValidate="txtStock" Type="Integer" MinimumValue="0" MaximumValue="100000" ErrorMessage="El stock tiene que ser un entero entre 0 y 100000." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="ddlCategoria" class="form-label fw-bold">Categoría</label>
                            <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select" />
                            <asp:RequiredFieldValidator ID="rfvCategoria" runat="server" ControlToValidate="ddlCategoria" InitialValue="0" ErrorMessage="Elegí una categoría." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="ddlExpansiones" class="form-label fw-bold">Expansión</label>
                            <asp:DropDownList ID="ddlExpansiones" runat="server" CssClass="form-select" />
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

                    <div class="row">
                        <div class="col-md-8 mb-3">
                            <label for="txtUrlImagen" class="form-label fw-bold">URL de la Imagen</label>
                            <asp:TextBox ID="txtUrlImagen" runat="server" CssClass="form-control" MaxLength="300" AutoPostBack="true" OnTextChanged="txtUrlImagen_TextChanged" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="txtCardId" class="form-label fw-bold">Código de carta</label>
                            <asp:TextBox ID="txtCardId" runat="server" CssClass="form-control" MaxLength="50" placeholder="Ej: base1-58" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="txtDescripcion" class="form-label fw-bold">Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" MaxLength="500" />
                    </div>
                </div>

                <div class="col-md-3 text-center">
                    <asp:Image ID="imgPreview" runat="server" CssClass="img-fluid rounded shadow-sm" Visible="false" />
                </div>
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Producto" CssClass="btn btn-success px-4" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-secondary px-4" CausesValidation="false" OnClick="btnLimpiar_Click" />
            </div>
        </div>

        <div class="card shadow-sm p-4 dark-mode-card">
            <h4 class="mb-3">Listado General de Cartas</h4>

            <div class="row g-2 mb-3">
                <div class="col-md-8">
                    <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control" placeholder="Buscar por nombre o código de carta (ej: Pikachu, base1-58)" />
                </div>
                <div class="col-md-4">
                    <asp:Button ID="btnBuscar" runat="server" Text="🔍 Buscar" CssClass="btn btn-outline-primary w-100" CausesValidation="false" OnClick="btnBuscar_Click" />
                </div>
            </div>
            <p class="text-muted small">Se muestran hasta 50 resultados. Usá el buscador para encontrar un producto puntual.</p>

            <div class="table-responsive">
                <asp:GridView ID="gvProductos" runat="server"
                    CssClass="table table-striped table-hover align-middle mb-0"
                    AutoGenerateColumns="false"
                    DataKeyNames="Id"
                    OnRowCommand="gvProductos_RowCommand"
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvProductos_PageIndexChanging"
                    EmptyDataText="No se encontraron productos.">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:TemplateField HeaderText="Expansión">
                            <ItemTemplate><%# Eval("Expansion.Nombre") %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Categoría">
                            <ItemTemplate><%# Eval("Categoria.Descripcion") %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Precio" HeaderText="Precio" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="Stock" HeaderText="Stock" />
                        <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:Button ID="btnModificar" runat="server" Text="Modificar" CssClass="btn btn-primary btn-sm me-1" CausesValidation="false" CommandName="ModificarItem" CommandArgument='<%# Eval("Id") %>' />
                                <asp:Button ID="btnEstado" runat="server" Text='<%# (bool)Eval("Activo") ? "Inactivar" : "Reactivar" %>' CssClass="btn btn-warning btn-sm" CausesValidation="false" CommandName="CambiarEstado" CommandArgument='<%# Eval("Id") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
