<%@ Page Title="Panel de Administración" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="ecommerce_web.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card shadow p-4 mb-4">
                    <h2 class="mb-3">Panel de Administración</h2>
                    <hr />
                    <p class="text-muted">
                        Desde aquí podés actualizar de forma masiva los precios en pesos argentinos (<span class="fw-bold">PrecioARS</span>) 
                        de todo el catálogo de cartas utilizando la cotización oficial en tiempo real del Dólar Blue.
                    </p>
                    
                    <div class="mb-3 mt-4">
                        <asp:Button ID="btnActualizarPrecios" runat="server" 
                            Text="🔄 Actualizar Precios con Dólar API" 
                            CssClass="btn btn-success btn-lg w-100" 
                            OnClick="btnActualizarPrecios_Click" />
                    </div>

                    <!-- Etiqueta para mostrar mensajes de éxito o error -->
                    <div class="mt-3">
                        <asp:Label ID="lblMensajeResultado" runat="server" CssClass="d-block p-3 rounded" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>