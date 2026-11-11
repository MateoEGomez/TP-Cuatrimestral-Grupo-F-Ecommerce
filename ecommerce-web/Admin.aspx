<%@ Page Title="Panel de Administración" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="ecommerce_web.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

            .admin-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.2) !important
            }

        body.dark-mode .admin-card:hover {
            box-shadow: 0 10px 20px rgba(255,255,255,0.1) !important
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">

        <div class="d-flex justify-content-between aling-items-center mb-4">
            <h2>Dashboard de Administracion</h2>
            <span class="badge bg-primary fs-6">Perfil: Administrador</span>
        </div>
        <hr />

        <!-- Seccion 1: Acciones rapidas Dolar Api -->
        <div class="row mb-5">
            <div class="col-12">
                <div class="card shadow-sm dark-mode-card">
                    <div class="card-body d-flex justify-content-between aling-items-center flex-wrap gap-3">
                        <div>
                            <h5 class="card-title mb-1">Cotizacion y precios</h5>
                            <p class="card-text text-muted mb-0">Actualizacion masiva del catalogo basada en el Dolar Blue oficial.</p>
                        </div>
                        <asp:Button ID="btnActualizarPrecios" runat="server"
                            Text="🔄 Actualizar Precios con Dolar API"
                            CssClass="btn btn-success"
                            OnClick="btnActualizarPrecios_Click" />
                    </div>
                    <asp:Label ID="lblMensajeResultado" runat="server" CssClass="d-block px-3 pb-2 text-center" />
                </div>
            </div>
        </div>

        <!-- Seccion 2: Gestion de catalogo maestro y parametros -->
        <h4 class="mb-4">📦 Gestion del Catalogo Maestro</h4>
        <div class="row g-4 mb-5">

            <!-- ABM Expansiones -->
            <div class="col-md-6 col-lg-4">
                <a href="AdminExpansiones.aspx" class="card h-100 shadow-sm dark-mode-card admin-card p-3">
                    <div class="card-body text-center">
                        <h1 class="display-4 mb-3">📚</h1>
                        <h5 class="card-title">Expansiones</h5>
                        <p class="card-text-muted small">Alta, baja y modificacion de los sets de cartas.</p>
                    </div>
                </a>
            </div>

            <!--ABM Parametros TCG -->
            <div class="col-md-6 col-lg-4">
                <a href="AdminParametros.aspx" class="card h-100 shadow-sm dark-mode-card admin-card p-3">
                    <div class="card-body text-center">
                        <h1 class="display-4 mb-3">✨</h1>
                        <h5 class="card-title">Parametros</h5>
                        <p class="card-text-muted small">Gestionar Rarezas, Condiciones e Idiomas.</p>
                    </div>
                </a>
            </div>

            <!--ABM Categorias-->
            <div class="col-md-6 col-lg-4">
                <a href="AdminCategorias.aspx" class="card h-100 shadow-sm dark-mode-card admin-card p-3">
                    <div class="card-body text-center">
                        <h1 class="display-4 mb-3">🗂️</h1>
                        <h5 class="card-title">Categorias</h5>
                        <p class="card-text-muted small">Administrar las familias de productos (Cartas sueltas Sobres, Accesorios).</p>
                    </div>
                </a>
            </div>

        </div>

        <!-- Seccion 3: Moderacion y usuarios -->
        <h4 class="mb-4">🛡️ Moderacion y Comunidad</h4>
        <div class="row g-4">

            <!-- Moderacion de publicaciones -->
            <div class="col-md-6">
                <a href="AdminModeracion.aspx" class="card h-100 shadow-sm border-warning dark-mode-card admin-card p-3">
                    <div class="card-body text-center">
                        <h1 class="display-4 mb-3">⚖️</h1>
                        <h5 class="card-title text-warning">Moderacion de publicaciones</h5>
                        <p class="card-text text-muted small">Gestion de denuncias.</p>
                    </div>
                </a>
            </div>

            <!-- ABM Usuarios y Perfiles -->
            <div class="col-md-6">
                <a href="AdminUsuarios.aspx" class="card h-100 shadow-sm border-warning dark-mode-card admin-card p-3">
                    <div class="card-body text-center">
                        <h1 class="display-4 mb-3">👥</h1>
                        <h5 class="card-title text-warning">Usuarios y Perfiles</h5>
                        <p class="card-text text-muted small">Administrar cuentas, suspender usuarios y asignar roles de Administrador.</p>
                    </div>
                </a>
            </div>

        </div>


    </div>

</asp:Content>
