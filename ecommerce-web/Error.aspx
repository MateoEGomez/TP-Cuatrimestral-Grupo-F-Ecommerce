<%@ Page Title="Error" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="ecommerce_web.Error" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5 text-center">
        <div class="card shadow p-4 border-danger">
            <h2 class="text-danger">¡Ups! Ocurrió un error inesperado</h2>
            <hr />
            <p class="text-muted">Lo sentimos, ha ocurrido un problema al procesar tu solicitud.</p>
            
            <div class="mt-3">
                <asp:Label ID="lblMensajeError" runat="server" CssClass="fw-bold text-dark" />
            </div>

            <div class="mt-4">
                <a href="Default.aspx" class="btn btn-primary">Volver al Inicio</a>
            </div>
        </div>
    </div>
</asp:Content>