use ECOMMERCE_DB
go

if COL_LENGTH('RAREZAS', 'Activo') is null
	alter table RAREZAS add Activo bit not null constraint DF_RAREZAS_Activo default 1
go

if COL_LENGTH('CONDICIONES', 'Activo') is null
	alter table CONDICIONES add Activo bit not null constraint DF_CONDICIONES_Activo default 1
go

if COL_LENGTH('IDIOMAS', 'Activo') is null
	alter table IDIOMAS add Activo bit not null constraint DF_IDIOMAS_Activo default 1
go
