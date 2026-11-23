<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ecommerce_web.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* ==========================================
           ESTILOS DE RESPLANDOR (GLOW) POR RAREZA
           ========================================== */
        .glow-comun {
            box-shadow: 0 0 30px 5px rgba(40, 167, 69, 0.7);
            background-color: rgba(40, 167, 69, 0.08);
            border-radius: 10px;
        }

        .glow-poco-comun {
            box-shadow: 0 0 35px 7px rgba(0, 123, 255, 0.75);
            background-color: rgba(0, 123, 255, 0.08);
            border-radius: 10px;
        }

        .glow-rara {
            box-shadow: 0 0 45px 10px rgba(111, 66, 193, 0.85);
            background-color: rgba(111, 66, 193, 0.1);
            border-radius: 10px;
        }

        .glow-ultra {
            box-shadow: 0 0 55px 12px rgba(255, 193, 7, 0.95);
            background-color: rgba(255, 193, 7, 0.12);
            border-radius: 10px;
        }

        /* ==========================================
           ESTILOS DE MODO OSCURO
           ========================================== */
        body.dark-mode {
            background-color: #121212 !important;
            color: #e0e0e0 !important;
        }

            body.dark-mode .card {
                background-color: #1e1e1e !important;
                color: #ffffff !important;
                border-color: #333333 !important;
            }

            body.dark-mode .card-title,
            body.dark-mode .card-text,
            body.dark-mode h1,
            body.dark-mode h5 {
                color: #ffffff !important;
            }

            body.dark-mode .text-muted {
                color: #b0b0b0 !important;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">

        <!-- ENCABEZADO Y BOTÓN DE MODO OSCURO ALINEADOS -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1>¡Bienvenido a la Tienda TCG!</h1>
                <p class="lead mb-0">Encontrá las mejores cartas y expansiones coleccionables en un solo lugar.</p>
            </div>
            <button type="button" class="btn btn-outline-secondary btn-sm" id="btnToggleTheme" onclick="toggleDarkMode()">
                🌙 Modo Oscuro
            </button>
        </div>

        <!-- SECCION COMPRA VENTA -->
        <div class="container text-center my-4">
            <div class="row">
                <div class="col-md-6">
                    <a href="Default.aspx" class="btn btn-primary btn-lg w-100 py-3 shadow-sm">
                        <i class="fas fa-shopping-cart"></i>QUIERO COMPRAR
                    </a>
                </div>
                <div class="col-md-6">
                    <a href="Publicar.aspx" class="btn btn-success btn-lg w-100 py-3 shadow-sm">
                        <i class="fas fa-tag"></i>QUIERO VENDER
                    </a>
                    </a>
                </div>
            </div>
        </div

        <!-- PANEL DE BUSQUEDA Y FILTROS DINAMICOS -->
        <asp:Panel ID="pnlFiltros" runat="server" DefaultButton="btnFiltrar" CssClass="card shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label for="<%= txtBuscarNombre.ClientID %>" class="form-label fw-bold">Buscar carta</label>
                        <asp:TextBox ID="txtBuscarNombre" runat="server" CssClass="form-control" placeholder="Ej: Charizard, Pikachu..."></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label for="<%= ddlSets.ClientID %>" class="form-label fw-bold">Expansión</label>
                        <asp:DropDownList ID="ddlSets" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSets_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label for="<%= txtPrecioMin.ClientID %>" class="form-label fw-bold">Precio Mín.</label>
                        <asp:TextBox ID="txtPrecioMin" runat="server" TextMode="Number" step="0.01" min="0" CssClass="form-control" placeholder="$ 0"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label for="<%= txtPrecioMax.ClientID %>" class="form-label fw-bold">Precio Máx.</label>
                        <asp:TextBox ID="txtPrecioMax" runat="server" TextMode="Number" step="0.01" min="0" CssClass="form-control" placeholder="$ Máx"></asp:TextBox>
                    </div>
                </div>

                <div class="d-flex flex-wrap justify-content-between align-items-center mt-3 pt-2 border-top">
                    <asp:Label ID="lblResultados" runat="server" CssClass="text-muted small" Text=""></asp:Label>
                    <div class="d-flex gap-2 ms-auto">
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar filtros" CssClass="btn btn-outline-secondary btn-sm" CausesValidation="false" OnClick="btnLimpiar_Click" />
                        <asp:Button ID="btnFiltrar" runat="server" Text="🔍 Buscar" CssClass="btn btn-primary btn-sm px-4" OnClick="btnFiltrar_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- AVISO SIN RESULTADOS -->
        <asp:Panel ID="pnlSinResultados" runat="server" Visible="false" CssClass="alert alert-info text-center my-4">
            No se encontraron cartas disponibles con los filtros aplicados. Probá ampliar el rango de precios o limpiar la búsqueda.
        </asp:Panel>

        <!-- GRILLA DE PRODUCTOS -->
        <div class="row">
            <asp:Repeater ID="repeaterProductos" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">

                            <!-- CONTENEDOR DE LA IMAGEN CON EL RESPLANDOR DE RAREZA -->
                            <div class="p-3 text-center">
                                <div class='d-inline-block p-1 <%# ObtenerClaseGlow(Eval("Descripcion")?.ToString() ?? "") %>'>
                                    <img src='<%# Eval("UrlImagen") != null ? ResolveUrl(Eval("UrlImagen").ToString()) : "" %>' class="img-fluid" alt='<%# Eval("Nombre") %>' style="height: 280px; object-fit: contain;" />
                                </div>
                            </div>

                            <!-- CUERPO DE LA TARJETA -->
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%# Eval("Nombre") %></h5>
                                <p class="card-text text-muted small"><%# Eval("Descripcion") %></p>

                                <p class="card-text text-success mt-auto"><strong>$<%# Eval("Precio") %></strong></p>
                                <a href='Detalle.aspx?id=<%# Eval("Id") %>' class="btn btn-outline-primary">Ver detalle</a>
                            </div>

                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- PAGINACIÓN -->
        <nav aria-label="Navegación de páginas" class="mt-4 mb-5">
            <ul class="pagination justify-content-center">
                <%= HtmlPaginacion %>
            </ul>
        </nav>

    </div>

    <!-- SCRIPT DE CONTROL PARA EL MODO OSCURO -->
    <script>
        function toggleDarkMode() {
            const body = document.body;
            const btn = document.getElementById('btnToggleTheme');
            
            body.classList.toggle('dark-mode');

            // Agregamos esta guarda para evitar el error de "is possibly null"
            if (!btn) return; 

            if (body.classList.contains('dark-mode')) {
                localStorage.setItem('theme', 'dark');
                btn.innerHTML = '☀️ Modo Día';
                btn.classList.replace('btn-outline-secondary', 'btn-outline-warning');
            } else {
                localStorage.setItem('theme', 'light');
                btn.innerHTML = '🌙 Modo Oscuro';
                btn.classList.replace('btn-outline-warning', 'btn-outline-secondary');
            }
        }

        // Al cargar la página, mantiene la preferencia guardada en el navegador
        window.addEventListener('DOMContentLoaded', () => {
            const savedTheme = localStorage.getItem('theme');
            const btn = document.getElementById('btnToggleTheme');
            
            if (savedTheme === 'dark') {
                document.body.classList.add('dark-mode');
                if (btn) {
                    btn.innerHTML = '☀️ Modo Día';
                    btn.classList.replace('btn-outline-secondary', 'btn-outline-warning');
                }
            }
        });
    </script>
</asp:Content>
