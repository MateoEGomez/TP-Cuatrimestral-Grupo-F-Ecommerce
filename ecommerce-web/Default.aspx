<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ecommerce_web.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">
        <div class="text-center mb-4">
            <h1>¡Bienvenido!</h1>
            <p class="lead">Encontrá los mejores productos de tecnología en un solo lugar.</p>
        </div>

        <div class="row">
            <asp:Repeater ID="repeaterProductos" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 mb-3">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title"><%# Eval("Nombre") %></h5>
                                <p class="card-text"><%# Eval("Descripcion") %></p>
                                <p class="card-text text-success"><strong>$<%# Eval("Precio") %></strong></p>
                                <a href="#" class="btn btn-primary">Ver detalle</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>