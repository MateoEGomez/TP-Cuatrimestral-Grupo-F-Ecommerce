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

        <!-- GRILLA DE PRODUCTOS -->
        <div class="row">
            <asp:Repeater ID="repeaterProductos" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            
                            <!-- CONTENEDOR DE LA IMAGEN CON EL RESPLANDOR DE RAREZA -->
                            <div class="p-3 text-center">
                                <div class='d-inline-block p-1 <%# ObtenerClaseGlow(Eval("Descripcion").ToString()) %>'>
                                    <img src='<%# Eval("UrlImagen") %>' class="img-fluid" alt='<%# Eval("Nombre") %>' style="height: 280px; object-fit: contain;" />
                                </div>
                            </div>
                            
                            <!-- CUERPO DE LA TARJETA -->
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%# Eval("Nombre") %></h5>
                                <p class="card-text text-muted small"><%# Eval("Descripcion") %></p>
                                
                                <p class="card-text text-success mt-auto"><strong>$<%# Eval("Precio") %></strong></p>
                                <a href="#" class="btn btn-primary mt-2">Ver detalle</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- PAGINACIÓN -->
        <nav aria-label="Navegación de páginas" class="mt-4 mb-5">
            <ul class="pagination justify-content-center">
                <% if (PaginaActual > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="Default.aspx?page=<%= PaginaActual - 1 %>">Anterior</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled">
                        <span class="page-link">Anterior</span>
                    </li>
                <% } %>

                <% for (int i = 1; i <= TotalPaginas; i++) { %>
                    <li class="page-item <%= i == PaginaActual ? "active" : "" %>">
                        <a class="page-link" href="Default.aspx?page=<%= i %>"><%= i %></a>
                    </li>
                <% } %>

                <% if (PaginaActual < TotalPaginas) { %>
                    <li class="page-item">
                        <a class="page-link" href="Default.aspx?page=<%= PaginaActual + 1 %>">Siguiente</a>
                    </li>
                <% } else { %>
                    <li class="page-item disabled">
                        <span class="page-link">Siguiente</span>
                    </li>
                <% } %>
            </ul>
        </nav>

    </div>

    <!-- SCRIPT DE CONTROL PARA EL MODO OSCURO -->
    <script>
        function toggleDarkMode() {
            const body = document.body;
            const btn = document.getElementById('btnToggleTheme');
            
            body.classList.toggle('dark-mode');

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