<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MiPerfil.aspx.cs" Inherits="ecommerce_web.MiPerfil" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4 mb-5">
        <h2 class="mb-4">Mi Perfil</h2>

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
            <asp:Label ID="lblMensaje" runat="server" />
        </asp:Panel>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="card shadow-sm dark-mode-card mb-4">
                    <div class="card-header"><h5 class="mb-0">Mis datos</h5></div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="<%= txtEmail.ClientID %>" class="form-label">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" />
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="<%= txtNombre.ClientID %>" class="form-label">Nombre</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50" />
                            </div>
                            <div class="col-md-6">
                                <label for="<%= txtApellido.ClientID %>" class="form-label">Apellido</label>
                                <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" MaxLength="50" />
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="<%= txtTelefono.ClientID %>" class="form-label">Teléfono</label>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" TextMode="Phone" MaxLength="30" />
                            <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" ValidationGroup="datos"
                                ErrorMessage="El teléfono solo puede tener números, espacios, + o -." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[0-9 +\-]{6,30}$" />
                        </div>
                        <asp:Button ID="btnGuardarDatos" runat="server" Text="💾 Guardar datos" CssClass="btn btn-primary" ValidationGroup="datos" OnClick="btnGuardarDatos_Click" />
                    </div>
                </div>

                <div class="card shadow-sm dark-mode-card">
                    <div class="card-header"><h5 class="mb-0">Cambiar contraseña</h5></div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="<%= txtPassActual.ClientID %>" class="form-label">Contraseña actual</label>
                            <asp:TextBox ID="txtPassActual" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvPassActual" runat="server" ControlToValidate="txtPassActual" ValidationGroup="pass"
                                ErrorMessage="Ingresá tu contraseña actual." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="mb-3">
                            <label for="<%= txtPassNueva.ClientID %>" class="form-label">Contraseña nueva</label>
                            <asp:TextBox ID="txtPassNueva" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvPassNueva" runat="server" ControlToValidate="txtPassNueva" ValidationGroup="pass"
                                ErrorMessage="Ingresá la contraseña nueva." CssClass="text-danger small" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revPassNueva" runat="server" ControlToValidate="txtPassNueva" ValidationGroup="pass"
                                ErrorMessage="La contraseña debe tener al menos 6 caracteres." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^.{6,50}$" />
                        </div>
                        <div class="mb-3">
                            <label for="<%= txtPassRepetir.ClientID %>" class="form-label">Repetir contraseña nueva</label>
                            <asp:TextBox ID="txtPassRepetir" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvPassRepetir" runat="server" ControlToValidate="txtPassRepetir" ValidationGroup="pass"
                                ErrorMessage="Repetí la contraseña nueva." CssClass="text-danger small" Display="Dynamic" />
                            <asp:CompareValidator ID="cvPassRepetir" runat="server" ControlToValidate="txtPassRepetir" ControlToCompare="txtPassNueva" ValidationGroup="pass"
                                ErrorMessage="Las contraseñas no coinciden." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <asp:Button ID="btnCambiarPass" runat="server" Text="🔒 Cambiar contraseña" CssClass="btn btn-outline-primary" ValidationGroup="pass" OnClick="btnCambiarPass_Click" />
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="card shadow-sm dark-mode-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Mis direcciones</h5>
                        <asp:Button ID="btnNuevaDireccion" runat="server" Text="➕ Agregar" CssClass="btn btn-sm btn-outline-success" CausesValidation="false" OnClick="btnNuevaDireccion_Click" />
                    </div>
                    <div class="card-body">
                        <asp:Label ID="lblSinDirecciones" runat="server" CssClass="text-muted d-block" Text="Todavía no cargaste ninguna dirección." />

                        <asp:Repeater ID="repDirecciones" runat="server" OnItemCommand="repDirecciones_ItemCommand">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-start border-bottom py-2">
                                    <div>
                                        <div class="fw-bold"><%#: Eval("Calle") %> <%#: Eval("Numero") %></div>
                                        <div class="small text-muted"><%#: Eval("Localidad") %> (CP <%#: Eval("CodigoPostal") %>)</div>
                                        <div class="small text-muted"><%#: Eval("Observaciones") %></div>
                                    </div>
                                    <div class="d-flex gap-1">
                                        <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("Id") %>' CausesValidation="false"
                                            CssClass="btn btn-sm btn-outline-warning">✏️</asp:LinkButton>
                                        <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("Id") %>' CausesValidation="false"
                                            CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('¿Eliminar esta dirección?');">🗑️</asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlFormDireccion" runat="server" Visible="false" CssClass="mt-3 p-3 border rounded">
                            <h6><asp:Label ID="lblTituloDireccion" runat="server" Text="Nueva dirección" /></h6>
                            <asp:HiddenField ID="hfIdDireccion" runat="server" Value="0" />
                            <div class="row g-2">
                                <div class="col-8">
                                    <label for="<%= txtCalle.ClientID %>" class="form-label small">Calle</label>
                                    <asp:TextBox ID="txtCalle" runat="server" CssClass="form-control form-control-sm" MaxLength="100" />
                                    <asp:RequiredFieldValidator ID="rfvCalle" runat="server" ControlToValidate="txtCalle" ValidationGroup="direccion"
                                        ErrorMessage="Ingresá la calle." CssClass="text-danger small" Display="Dynamic" />
                                </div>
                                <div class="col-4">
                                    <label for="<%= txtNumero.ClientID %>" class="form-label small">Número</label>
                                    <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control form-control-sm" MaxLength="10" />
                                    <asp:RequiredFieldValidator ID="rfvNumero" runat="server" ControlToValidate="txtNumero" ValidationGroup="direccion"
                                        ErrorMessage="Ingresá el número." CssClass="text-danger small" Display="Dynamic" />
                                </div>
                                <div class="col-8">
                                    <label for="<%= txtLocalidad.ClientID %>" class="form-label small">Localidad</label>
                                    <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control form-control-sm" MaxLength="100" />
                                    <asp:RequiredFieldValidator ID="rfvLocalidad" runat="server" ControlToValidate="txtLocalidad" ValidationGroup="direccion"
                                        ErrorMessage="Ingresá la localidad." CssClass="text-danger small" Display="Dynamic" />
                                </div>
                                <div class="col-4">
                                    <label for="<%= txtCodigoPostal.ClientID %>" class="form-label small">Código postal</label>
                                    <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control form-control-sm" MaxLength="10" />
                                    <asp:RequiredFieldValidator ID="rfvCodigoPostal" runat="server" ControlToValidate="txtCodigoPostal" ValidationGroup="direccion"
                                        ErrorMessage="Ingresá el CP." CssClass="text-danger small" Display="Dynamic" />
                                    <asp:RegularExpressionValidator ID="revCodigoPostal" runat="server" ControlToValidate="txtCodigoPostal" ValidationGroup="direccion"
                                        ErrorMessage="CP inválido." CssClass="text-danger small" Display="Dynamic" ValidationExpression="^[A-Za-z0-9]{4,10}$" />
                                </div>
                                <div class="col-12">
                                    <label for="<%= txtObservaciones.ClientID %>" class="form-label small">Observaciones (opcional)</label>
                                    <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control form-control-sm" MaxLength="200" placeholder="Piso, departamento, referencias..." />
                                </div>
                            </div>
                            <div class="d-flex gap-2 mt-3">
                                <asp:Button ID="btnGuardarDireccion" runat="server" Text="💾 Guardar dirección" CssClass="btn btn-sm btn-primary" ValidationGroup="direccion" OnClick="btnGuardarDireccion_Click" />
                                <asp:Button ID="btnCancelarDireccion" runat="server" Text="Cancelar" CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" OnClick="btnCancelarDireccion_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
