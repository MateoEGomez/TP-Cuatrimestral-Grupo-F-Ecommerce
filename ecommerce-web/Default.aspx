<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ecommerce_web.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- 
        EXPLICACIÓN PARA EL EQUIPO:
        Agregamos estilos CSS personalizados en el Head. Usamos 'box-shadow' y 'border' 
        para lograr el efecto de resplandor (glow) dinámico que sugirió Magu según la rareza.
    -->
    <style>
        .glow-comun { box-shadow: 0 0 10px rgba(40, 167, 69, 0.3); border: 1px solid rgba(40, 167, 69, 0.5); }
        .glow-poco-comun { box-shadow: 0 0 12px rgba(0, 123, 255, 0.4); border: 1px solid rgba(0, 123, 255, 0.6); }
        .glow-rara { box-shadow: 0 0 15px rgba(111, 66, 193, 0.5); border: 1px solid rgba(111, 66, 193, 0.7); }
        .glow-ultra { box-shadow: 0 0 20px rgba(255, 193, 7, 0.7); border: 2px solid rgba(255, 193, 7, 0.9); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">
        
        <!-- Encabezado adaptado a la temática del proyecto de Pokémon TCG -->
        <div class="text-center mb-4">
            <h1>¡Bienvenido a la Tienda TCG!</h1>
            <p class="lead">Encontrá las mejores cartas y expansiones coleccionables en un solo lugar.</p>
        </div>

        <!-- Grilla de productos con Repeater -->
        <div class="row">
            <asp:Repeater ID="repeaterProductos" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 mb-4">
                        <!-- 
                            EXPLICACIÓN: Inyectamos la función ObtenerClaseGlow() en la clase de la tarjeta 
                            para que pinte el borde y la sombra acorde al texto de la descripción.
                        -->
                        <div class="card h-100 shadow-sm <%# ObtenerClaseGlow(Eval("Descripcion").ToString()) %>">
                            
                            <!-- Imagen oficial de la carta obtenida mediante la API -->
                            <img src='<%# Eval("UrlImagen") %>' class="card-img-top p-3" alt='<%# Eval("Nombre") %>' style="height: 280px; object-fit: contain;" />
                            
                            <!-- 
                                EXPLICACIÓN: Usamos clases de Bootstrap 'd-flex flex-column' 
                                para convertir el cuerpo de la tarjeta en un contenedor flexible vertical.
                            -->
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%# Eval("Nombre") %></h5>
                                <p class="card-text text-muted small"><%# Eval("Descripcion") %></p>
                                
                                <!-- 'mt-auto' (margin-top: auto) empuja empuja este elemento siempre al piso de la tarjeta -->
                                <p class="card-text text-success mt-auto"><strong>$<%# Eval("Precio") %></strong></p>
                                <a href="#" class="btn btn-primary mt-2">Ver detalle</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- BARRA DE PAGINACIÓN ROBUSTA -->
    <nav aria-label="Navegación de páginas" class="mt-4 mb-5">
        <ul class="pagination justify-content-center">
            
            <!-- Botón Anterior -->
            <% if (PaginaActual > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="Default.aspx?page=<%= PaginaActual - 1 %>">Anterior</a>
                </li>
            <% } else { %>
                <li class="page-item disabled">
                    <span class="page-link">Anterior</span>
                </li>
            <% } %>

            <!-- Números de página dinámicos -->
            <% for (int i = 1; i <= TotalPaginas; i++) { %>
                <li class="page-item <%= i == PaginaActual ? "active" : "" %>">
                    <a class="page-link" href="Default.aspx?page=<%= i %>"><%= i %></a>
                </li>
            <% } %>

            <!-- Botón Siguiente -->
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
</asp:Content>