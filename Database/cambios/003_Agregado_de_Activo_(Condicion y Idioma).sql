Use ECOMMERCE_DB;
go

alter table Condiciones add Activo bit not null default 1;
alter table Idiomas add Activo bit not null default 1;
go