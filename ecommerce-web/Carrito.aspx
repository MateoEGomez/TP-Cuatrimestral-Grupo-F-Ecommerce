<%@ Page Title="Carrito de Compras" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Carrito.aspx.cs" Inherits="ecommerce_web.Carrito" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <a href="Default.aspx" class="btn btn-outline-secondary mb-3">&larr; Seguir comprando</a>

        <h2 class="mb-4">Tu Carrito</h2>

        <asp:Panel ID="pnlVacio" runat="server" Visible="false" CssClass="alert alert-info">
            Todavía no agregaste productos al carrito.
        </asp:Panel>

        <asp:GridView ID="dgvCarrito" runat="server" AutoGenerateColumns="False"
            CssClass="table table-hover align-middle shadow-sm dark-mode-card" OnRowCommand="dgvCarrito_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="Producto">
                    <ItemTemplate>
                        <%# Eval("Producto.Nombre") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Precio Unitario">
                    <ItemTemplate>
                        <%# FormatearPrecioUnitarioItem(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                <asp:TemplateField HeaderText="Subtotal">
                    <ItemTemplate>
                        <%# FormatearSubtotalItem(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnSumar" runat="server" CommandName="Sumar" CommandArgument='<%# Eval("Producto.Id") %>' CssClass="btn btn-sm btn-outline-success">+</asp:LinkButton>
                        <asp:LinkButton ID="btnRestar" runat="server" CommandName="Restar" CommandArgument='<%# Eval("Producto.Id") %>' CssClass="btn btn-sm btn-outline-warning">-</asp:LinkButton>
                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("Producto.Id") %>' CssClass="btn btn-sm btn-outline-danger">Quitar</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <div class="d-flex justify-content-between align-items-center mt-4">
            <h4>Total: <asp:Label ID="lblTotalCarrito" runat="server" CssClass="text-success fw-bold" Text="$0,00"></asp:Label></h4>
            <a href="Checkout.aspx" class="btn btn-primary btn-lg">Ir a Finalizar Compra</a>
        </div>
    </div>
</asp:Content>