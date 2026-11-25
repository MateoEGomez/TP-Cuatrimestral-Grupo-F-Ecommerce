use ECOMMERCE_DB
go

if exists (select 1 from sys.columns where object_id = OBJECT_ID('Productos') and name = 'Nombre' and TYPE_NAME(user_type_id) = 'varchar')
	alter table Productos alter column Nombre nvarchar(100) not null
go

create or alter procedure storedAltaProducto
	@Nombre nvarchar(100),
	@Descripcion varchar(500),
	@Precio decimal(18, 2),
	@Stock int,
	@UrlImagen varchar(300),
	@IdCategoria int,
	@IdExpansion varchar(50),
	@IdRareza int,
	@IdCondicion int,
	@IdIdioma int,
	@CardId varchar(50),
	@IdVendedor int
as
	insert into Productos (Nombre, Descripcion, Precio, Stock, UrlImagen, IdCategoria, IdExpansion,
		IdRareza, IdCondicion, IdIdioma, CardId, IdVendedor, IdEstadoPublicacion, Activo)
	values (@Nombre, @Descripcion, @Precio, @Stock, @UrlImagen, @IdCategoria, @IdExpansion,
		@IdRareza, @IdCondicion, @IdIdioma, @CardId, @IdVendedor, 2, 1)
go

create or alter procedure storedModificarProducto
	@Id int,
	@Nombre nvarchar(100),
	@Descripcion varchar(500),
	@Precio decimal(18, 2),
	@Stock int,
	@UrlImagen varchar(300),
	@IdCategoria int,
	@IdExpansion varchar(50),
	@IdRareza int,
	@IdCondicion int,
	@IdIdioma int,
	@CardId varchar(50)
as
	update Productos set Nombre = @Nombre, Descripcion = @Descripcion, Precio = @Precio, Stock = @Stock,
		UrlImagen = @UrlImagen, IdCategoria = @IdCategoria, IdExpansion = @IdExpansion,
		IdRareza = @IdRareza, IdCondicion = @IdCondicion, IdIdioma = @IdIdioma, CardId = @CardId
	where Id = @Id
go

update Productos set Nombre = N'Nidoran ♂' where CardId = 'base1-55' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'base2-57' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'base4-82' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'base4-83' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'base6-82' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'base6-83' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'_____''s Pikachu' where CardId = 'basep-24' and Nombre <> N'_____''s Pikachu' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'bw9-40' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'bw9-43' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'dp2-91' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'dp3-97' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Unown [?]' where CardId = 'dp6-82' and Nombre <> N'Unown [?]' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'ecard2-96' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Miracle Sphere γ' where CardId = 'ecard3-131' and Nombre <> N'Miracle Sphere γ' collate Latin1_General_BIN
update Productos set Nombre = N'Mystery Plate γ' where CardId = 'ecard3-135' and Nombre <> N'Mystery Plate γ' collate Latin1_General_BIN
update Productos set Nombre = N'Mystery Plate δ' where CardId = 'ecard3-136' and Nombre <> N'Mystery Plate δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'ecard3-81' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'ecard3-82' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Entei ★' where CardId = 'ex10-113' and Nombre <> N'Entei ★' collate Latin1_General_BIN
update Productos set Nombre = N'Raikou ★' where CardId = 'ex10-114' and Nombre <> N'Raikou ★' collate Latin1_General_BIN
update Productos set Nombre = N'Suicune ★' where CardId = 'ex10-115' and Nombre <> N'Suicune ★' collate Latin1_General_BIN
update Productos set Nombre = N'Beedrill δ' where CardId = 'ex11-1' and Nombre <> N'Beedrill δ' collate Latin1_General_BIN
update Productos set Nombre = N'Marowak δ' where CardId = 'ex11-10' and Nombre <> N'Marowak δ' collate Latin1_General_BIN
update Productos set Nombre = N'Metagross δ' where CardId = 'ex11-11' and Nombre <> N'Metagross δ' collate Latin1_General_BIN
update Productos set Nombre = N'Groudon ★' where CardId = 'ex11-111' and Nombre <> N'Groudon ★' collate Latin1_General_BIN
update Productos set Nombre = N'Kyogre ★' where CardId = 'ex11-112' and Nombre <> N'Kyogre ★' collate Latin1_General_BIN
update Productos set Nombre = N'Metagross ★' where CardId = 'ex11-113' and Nombre <> N'Metagross ★' collate Latin1_General_BIN
update Productos set Nombre = N'Mewtwo δ' where CardId = 'ex11-12' and Nombre <> N'Mewtwo δ' collate Latin1_General_BIN
update Productos set Nombre = N'Rayquaza δ' where CardId = 'ex11-13' and Nombre <> N'Rayquaza δ' collate Latin1_General_BIN
update Productos set Nombre = N'Salamence δ' where CardId = 'ex11-14' and Nombre <> N'Salamence δ' collate Latin1_General_BIN
update Productos set Nombre = N'Starmie δ' where CardId = 'ex11-15' and Nombre <> N'Starmie δ' collate Latin1_General_BIN
update Productos set Nombre = N'Tyranitar δ' where CardId = 'ex11-16' and Nombre <> N'Tyranitar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Umbreon δ' where CardId = 'ex11-17' and Nombre <> N'Umbreon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Vaporeon δ' where CardId = 'ex11-18' and Nombre <> N'Vaporeon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Azumarill δ' where CardId = 'ex11-19' and Nombre <> N'Azumarill δ' collate Latin1_General_BIN
update Productos set Nombre = N'Crobat δ' where CardId = 'ex11-2' and Nombre <> N'Crobat δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mightyena δ' where CardId = 'ex11-24' and Nombre <> N'Mightyena δ' collate Latin1_General_BIN
update Productos set Nombre = N'Sandslash δ' where CardId = 'ex11-27' and Nombre <> N'Sandslash δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dragonite δ' where CardId = 'ex11-3' and Nombre <> N'Dragonite δ' collate Latin1_General_BIN
update Productos set Nombre = N'Starmie δ' where CardId = 'ex11-30' and Nombre <> N'Starmie δ' collate Latin1_General_BIN
update Productos set Nombre = N'Espeon δ' where CardId = 'ex11-4' and Nombre <> N'Espeon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dragonair δ' where CardId = 'ex11-41' and Nombre <> N'Dragonair δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dragonair δ' where CardId = 'ex11-42' and Nombre <> N'Dragonair δ' collate Latin1_General_BIN
update Productos set Nombre = N'Metang δ' where CardId = 'ex11-49' and Nombre <> N'Metang δ' collate Latin1_General_BIN
update Productos set Nombre = N'Flareon δ' where CardId = 'ex11-5' and Nombre <> N'Flareon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pupitar δ' where CardId = 'ex11-51' and Nombre <> N'Pupitar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Shelgon δ' where CardId = 'ex11-53' and Nombre <> N'Shelgon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Shelgon δ' where CardId = 'ex11-54' and Nombre <> N'Shelgon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Bagon δ' where CardId = 'ex11-57' and Nombre <> N'Bagon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Bagon δ' where CardId = 'ex11-58' and Nombre <> N'Bagon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Beldum δ' where CardId = 'ex11-59' and Nombre <> N'Beldum δ' collate Latin1_General_BIN
update Productos set Nombre = N'Gardevoir δ' where CardId = 'ex11-6' and Nombre <> N'Gardevoir δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dratini δ' where CardId = 'ex11-65' and Nombre <> N'Dratini δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dratini δ' where CardId = 'ex11-66' and Nombre <> N'Dratini δ' collate Latin1_General_BIN
update Productos set Nombre = N'Eevee δ' where CardId = 'ex11-68' and Nombre <> N'Eevee δ' collate Latin1_General_BIN
update Productos set Nombre = N'Jolteon δ' where CardId = 'ex11-7' and Nombre <> N'Jolteon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Larvitar δ' where CardId = 'ex11-73' and Nombre <> N'Larvitar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latias δ' where CardId = 'ex11-8' and Nombre <> N'Latias δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latios δ' where CardId = 'ex11-9' and Nombre <> N'Latios δ' collate Latin1_General_BIN
update Productos set Nombre = N'Regice ★' where CardId = 'ex12-90' and Nombre <> N'Regice ★' collate Latin1_General_BIN
update Productos set Nombre = N'Regirock ★' where CardId = 'ex12-91' and Nombre <> N'Regirock ★' collate Latin1_General_BIN
update Productos set Nombre = N'Registeel ★' where CardId = 'ex12-92' and Nombre <> N'Registeel ★' collate Latin1_General_BIN
update Productos set Nombre = N'Pikachu δ' where CardId = 'ex12-93' and Nombre <> N'Pikachu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Armaldo δ' where CardId = 'ex13-1' and Nombre <> N'Armaldo δ' collate Latin1_General_BIN
update Productos set Nombre = N'Kingdra δ' where CardId = 'ex13-10' and Nombre <> N'Kingdra δ' collate Latin1_General_BIN
update Productos set Nombre = N'Gyarados ★ δ' where CardId = 'ex13-102' and Nombre <> N'Gyarados ★ δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mewtwo ★' where CardId = 'ex13-103' and Nombre <> N'Mewtwo ★' collate Latin1_General_BIN
update Productos set Nombre = N'Pikachu ★' where CardId = 'ex13-104' and Nombre <> N'Pikachu ★' collate Latin1_General_BIN
update Productos set Nombre = N'Latias δ' where CardId = 'ex13-11' and Nombre <> N'Latias δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latios δ' where CardId = 'ex13-12' and Nombre <> N'Latios δ' collate Latin1_General_BIN
update Productos set Nombre = N'Omastar δ' where CardId = 'ex13-13' and Nombre <> N'Omastar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pidgeot δ' where CardId = 'ex13-14' and Nombre <> N'Pidgeot δ' collate Latin1_General_BIN
update Productos set Nombre = N'Raichu δ' where CardId = 'ex13-15' and Nombre <> N'Raichu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Rayquaza δ' where CardId = 'ex13-16' and Nombre <> N'Rayquaza δ' collate Latin1_General_BIN
update Productos set Nombre = N'Vileplume δ' where CardId = 'ex13-17' and Nombre <> N'Vileplume δ' collate Latin1_General_BIN
update Productos set Nombre = N'Bellossom δ' where CardId = 'ex13-19' and Nombre <> N'Bellossom δ' collate Latin1_General_BIN
update Productos set Nombre = N'Cradily δ' where CardId = 'ex13-2' and Nombre <> N'Cradily δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latias δ' where CardId = 'ex13-21' and Nombre <> N'Latias δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latios δ' where CardId = 'ex13-22' and Nombre <> N'Latios δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mewtwo δ' where CardId = 'ex13-24' and Nombre <> N'Mewtwo δ' collate Latin1_General_BIN
update Productos set Nombre = N'Rayquaza δ' where CardId = 'ex13-26' and Nombre <> N'Rayquaza δ' collate Latin1_General_BIN
update Productos set Nombre = N'Deoxys δ' where CardId = 'ex13-3' and Nombre <> N'Deoxys δ' collate Latin1_General_BIN
update Productos set Nombre = N'Aerodactyl δ' where CardId = 'ex13-35' and Nombre <> N'Aerodactyl δ' collate Latin1_General_BIN
update Productos set Nombre = N'Chimecho δ' where CardId = 'ex13-37' and Nombre <> N'Chimecho δ' collate Latin1_General_BIN
update Productos set Nombre = N'Deoxys δ' where CardId = 'ex13-4' and Nombre <> N'Deoxys δ' collate Latin1_General_BIN
update Productos set Nombre = N'Exeggutor δ' where CardId = 'ex13-41' and Nombre <> N'Exeggutor δ' collate Latin1_General_BIN
update Productos set Nombre = N'Gloom δ' where CardId = 'ex13-42' and Nombre <> N'Gloom δ' collate Latin1_General_BIN
update Productos set Nombre = N'Golduck δ' where CardId = 'ex13-43' and Nombre <> N'Golduck δ' collate Latin1_General_BIN
update Productos set Nombre = N'Persian δ' where CardId = 'ex13-48' and Nombre <> N'Persian δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pidgeotto δ' where CardId = 'ex13-49' and Nombre <> N'Pidgeotto δ' collate Latin1_General_BIN
update Productos set Nombre = N'Deoxys δ' where CardId = 'ex13-5' and Nombre <> N'Deoxys δ' collate Latin1_General_BIN
update Productos set Nombre = N'Primeape δ' where CardId = 'ex13-50' and Nombre <> N'Primeape δ' collate Latin1_General_BIN
update Productos set Nombre = N'Seadra δ' where CardId = 'ex13-52' and Nombre <> N'Seadra δ' collate Latin1_General_BIN
update Productos set Nombre = N'Sharpedo δ' where CardId = 'ex13-53' and Nombre <> N'Sharpedo δ' collate Latin1_General_BIN
update Productos set Nombre = N'Vibrava δ' where CardId = 'ex13-54' and Nombre <> N'Vibrava δ' collate Latin1_General_BIN
update Productos set Nombre = N'Anorith δ' where CardId = 'ex13-57' and Nombre <> N'Anorith δ' collate Latin1_General_BIN
update Productos set Nombre = N'Deoxys δ' where CardId = 'ex13-6' and Nombre <> N'Deoxys δ' collate Latin1_General_BIN
update Productos set Nombre = N'Carvanha δ' where CardId = 'ex13-61' and Nombre <> N'Carvanha δ' collate Latin1_General_BIN
update Productos set Nombre = N'Exeggcute δ' where CardId = 'ex13-65' and Nombre <> N'Exeggcute δ' collate Latin1_General_BIN
update Productos set Nombre = N'Horsea δ' where CardId = 'ex13-66' and Nombre <> N'Horsea δ' collate Latin1_General_BIN
update Productos set Nombre = N'Kabuto δ' where CardId = 'ex13-67' and Nombre <> N'Kabuto δ' collate Latin1_General_BIN
update Productos set Nombre = N'Lileep δ' where CardId = 'ex13-68' and Nombre <> N'Lileep δ' collate Latin1_General_BIN
update Productos set Nombre = N'Magikarp δ' where CardId = 'ex13-69' and Nombre <> N'Magikarp δ' collate Latin1_General_BIN
update Productos set Nombre = N'Flygon δ' where CardId = 'ex13-7' and Nombre <> N'Flygon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mankey δ' where CardId = 'ex13-70' and Nombre <> N'Mankey δ' collate Latin1_General_BIN
update Productos set Nombre = N'Meowth δ' where CardId = 'ex13-71' and Nombre <> N'Meowth δ' collate Latin1_General_BIN
update Productos set Nombre = N'Oddish δ' where CardId = 'ex13-73' and Nombre <> N'Oddish δ' collate Latin1_General_BIN
update Productos set Nombre = N'Omanyte δ' where CardId = 'ex13-74' and Nombre <> N'Omanyte δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pichu δ' where CardId = 'ex13-76' and Nombre <> N'Pichu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pidgey δ' where CardId = 'ex13-77' and Nombre <> N'Pidgey δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pikachu δ' where CardId = 'ex13-79' and Nombre <> N'Pikachu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Gyarados δ' where CardId = 'ex13-8' and Nombre <> N'Gyarados δ' collate Latin1_General_BIN
update Productos set Nombre = N'Psyduck δ' where CardId = 'ex13-81' and Nombre <> N'Psyduck δ' collate Latin1_General_BIN
update Productos set Nombre = N'Trapinch δ' where CardId = 'ex13-84' and Nombre <> N'Trapinch δ' collate Latin1_General_BIN
update Productos set Nombre = N'Kabutops δ' where CardId = 'ex13-9' and Nombre <> N'Kabutops δ' collate Latin1_General_BIN
update Productos set Nombre = N'Celebi ★' where CardId = 'ex14-100' and Nombre <> N'Celebi ★' collate Latin1_General_BIN
update Productos set Nombre = N'Cacturne δ' where CardId = 'ex14-15' and Nombre <> N'Cacturne δ' collate Latin1_General_BIN
update Productos set Nombre = N'Fearow δ' where CardId = 'ex14-18' and Nombre <> N'Fearow δ' collate Latin1_General_BIN
update Productos set Nombre = N'Grovyle δ' where CardId = 'ex14-19' and Nombre <> N'Grovyle δ' collate Latin1_General_BIN
update Productos set Nombre = N'Blastoise δ' where CardId = 'ex14-2' and Nombre <> N'Blastoise δ' collate Latin1_General_BIN
update Productos set Nombre = N'Kingler δ' where CardId = 'ex14-22' and Nombre <> N'Kingler δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pelipper δ' where CardId = 'ex14-26' and Nombre <> N'Pelipper δ' collate Latin1_General_BIN
update Productos set Nombre = N'Charmeleon δ' where CardId = 'ex14-30' and Nombre <> N'Charmeleon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Charizard δ' where CardId = 'ex14-4' and Nombre <> N'Charizard δ' collate Latin1_General_BIN
update Productos set Nombre = N'Charmander δ' where CardId = 'ex14-49' and Nombre <> N'Charmander δ' collate Latin1_General_BIN
update Productos set Nombre = N'Ludicolo δ' where CardId = 'ex14-6' and Nombre <> N'Ludicolo δ' collate Latin1_General_BIN
update Productos set Nombre = N'Treecko δ' where CardId = 'ex14-68' and Nombre <> N'Treecko δ' collate Latin1_General_BIN
update Productos set Nombre = N'Sceptile ex δ' where CardId = 'ex14-96' and Nombre <> N'Sceptile ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Alakazam ★' where CardId = 'ex14-99' and Nombre <> N'Alakazam ★' collate Latin1_General_BIN
update Productos set Nombre = N'Ampharos δ' where CardId = 'ex15-1' and Nombre <> N'Ampharos δ' collate Latin1_General_BIN
update Productos set Nombre = N'Snorlax δ' where CardId = 'ex15-10' and Nombre <> N'Snorlax δ' collate Latin1_General_BIN
update Productos set Nombre = N'Charizard ★ δ' where CardId = 'ex15-100' and Nombre <> N'Charizard ★ δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mew ★ δ' where CardId = 'ex15-101' and Nombre <> N'Mew ★ δ' collate Latin1_General_BIN
update Productos set Nombre = N'Togetic δ' where CardId = 'ex15-11' and Nombre <> N'Togetic δ' collate Latin1_General_BIN
update Productos set Nombre = N'Typhlosion δ' where CardId = 'ex15-12' and Nombre <> N'Typhlosion δ' collate Latin1_General_BIN
update Productos set Nombre = N'Arbok δ' where CardId = 'ex15-13' and Nombre <> N'Arbok δ' collate Latin1_General_BIN
update Productos set Nombre = N'Cloyster δ' where CardId = 'ex15-14' and Nombre <> N'Cloyster δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dewgong δ' where CardId = 'ex15-15' and Nombre <> N'Dewgong δ' collate Latin1_General_BIN
update Productos set Nombre = N'Gligar δ' where CardId = 'ex15-16' and Nombre <> N'Gligar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Jynx δ' where CardId = 'ex15-17' and Nombre <> N'Jynx δ' collate Latin1_General_BIN
update Productos set Nombre = N'Ledian δ' where CardId = 'ex15-18' and Nombre <> N'Ledian δ' collate Latin1_General_BIN
update Productos set Nombre = N'Lickitung δ' where CardId = 'ex15-19' and Nombre <> N'Lickitung δ' collate Latin1_General_BIN
update Productos set Nombre = N'Feraligatr δ' where CardId = 'ex15-2' and Nombre <> N'Feraligatr δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mantine δ' where CardId = 'ex15-20' and Nombre <> N'Mantine δ' collate Latin1_General_BIN
update Productos set Nombre = N'Quagsire δ' where CardId = 'ex15-21' and Nombre <> N'Quagsire δ' collate Latin1_General_BIN
update Productos set Nombre = N'Seadra δ' where CardId = 'ex15-22' and Nombre <> N'Seadra δ' collate Latin1_General_BIN
update Productos set Nombre = N'Tropius δ' where CardId = 'ex15-23' and Nombre <> N'Tropius δ' collate Latin1_General_BIN
update Productos set Nombre = N'Vibrava δ' where CardId = 'ex15-24' and Nombre <> N'Vibrava δ' collate Latin1_General_BIN
update Productos set Nombre = N'Xatu δ' where CardId = 'ex15-25' and Nombre <> N'Xatu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Bayleef δ' where CardId = 'ex15-26' and Nombre <> N'Bayleef δ' collate Latin1_General_BIN
update Productos set Nombre = N'Croconaw δ' where CardId = 'ex15-27' and Nombre <> N'Croconaw δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dragonair δ' where CardId = 'ex15-28' and Nombre <> N'Dragonair δ' collate Latin1_General_BIN
update Productos set Nombre = N'Electabuzz δ' where CardId = 'ex15-29' and Nombre <> N'Electabuzz δ' collate Latin1_General_BIN
update Productos set Nombre = N'Heracross δ' where CardId = 'ex15-3' and Nombre <> N'Heracross δ' collate Latin1_General_BIN
update Productos set Nombre = N'Flaaffy δ' where CardId = 'ex15-30' and Nombre <> N'Flaaffy δ' collate Latin1_General_BIN
update Productos set Nombre = N'Horsea δ' where CardId = 'ex15-31' and Nombre <> N'Horsea δ' collate Latin1_General_BIN
update Productos set Nombre = N'Kirlia δ' where CardId = 'ex15-33' and Nombre <> N'Kirlia δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidorina δ' where CardId = 'ex15-34' and Nombre <> N'Nidorina δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidorino δ' where CardId = 'ex15-35' and Nombre <> N'Nidorino δ' collate Latin1_General_BIN
update Productos set Nombre = N'Quilava δ' where CardId = 'ex15-36' and Nombre <> N'Quilava δ' collate Latin1_General_BIN
update Productos set Nombre = N'Seadra δ' where CardId = 'ex15-37' and Nombre <> N'Seadra δ' collate Latin1_General_BIN
update Productos set Nombre = N'Shelgon δ' where CardId = 'ex15-38' and Nombre <> N'Shelgon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Smeargle δ' where CardId = 'ex15-39' and Nombre <> N'Smeargle δ' collate Latin1_General_BIN
update Productos set Nombre = N'Meganium δ' where CardId = 'ex15-4' and Nombre <> N'Meganium δ' collate Latin1_General_BIN
update Productos set Nombre = N'Swellow δ' where CardId = 'ex15-40' and Nombre <> N'Swellow δ' collate Latin1_General_BIN
update Productos set Nombre = N'Togepi δ' where CardId = 'ex15-41' and Nombre <> N'Togepi δ' collate Latin1_General_BIN
update Productos set Nombre = N'Vibrava δ' where CardId = 'ex15-42' and Nombre <> N'Vibrava δ' collate Latin1_General_BIN
update Productos set Nombre = N'Bagon δ' where CardId = 'ex15-43' and Nombre <> N'Bagon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Chikorita δ' where CardId = 'ex15-44' and Nombre <> N'Chikorita δ' collate Latin1_General_BIN
update Productos set Nombre = N'Cyndaquil δ' where CardId = 'ex15-45' and Nombre <> N'Cyndaquil δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dratini δ' where CardId = 'ex15-46' and Nombre <> N'Dratini δ' collate Latin1_General_BIN
update Productos set Nombre = N'Ekans δ' where CardId = 'ex15-47' and Nombre <> N'Ekans δ' collate Latin1_General_BIN
update Productos set Nombre = N'Elekid δ' where CardId = 'ex15-48' and Nombre <> N'Elekid δ' collate Latin1_General_BIN
update Productos set Nombre = N'Feebas δ' where CardId = 'ex15-49' and Nombre <> N'Feebas δ' collate Latin1_General_BIN
update Productos set Nombre = N'Milotic δ' where CardId = 'ex15-5' and Nombre <> N'Milotic δ' collate Latin1_General_BIN
update Productos set Nombre = N'Horsea δ' where CardId = 'ex15-50' and Nombre <> N'Horsea δ' collate Latin1_General_BIN
update Productos set Nombre = N'Larvitar δ' where CardId = 'ex15-52' and Nombre <> N'Larvitar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Ledyba δ' where CardId = 'ex15-53' and Nombre <> N'Ledyba δ' collate Latin1_General_BIN
update Productos set Nombre = N'Mareep δ' where CardId = 'ex15-54' and Nombre <> N'Mareep δ' collate Latin1_General_BIN
update Productos set Nombre = N'Natu δ' where CardId = 'ex15-55' and Nombre <> N'Natu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀ δ' where CardId = 'ex15-56' and Nombre <> N'Nidoran ♀ δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂ δ' where CardId = 'ex15-57' and Nombre <> N'Nidoran ♂ δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pupitar δ' where CardId = 'ex15-59' and Nombre <> N'Pupitar δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoking δ' where CardId = 'ex15-6' and Nombre <> N'Nidoking δ' collate Latin1_General_BIN
update Productos set Nombre = N'Ralts δ' where CardId = 'ex15-61' and Nombre <> N'Ralts δ' collate Latin1_General_BIN
update Productos set Nombre = N'Seel δ' where CardId = 'ex15-62' and Nombre <> N'Seel δ' collate Latin1_General_BIN
update Productos set Nombre = N'Shellder δ' where CardId = 'ex15-63' and Nombre <> N'Shellder δ' collate Latin1_General_BIN
update Productos set Nombre = N'Smoochum δ' where CardId = 'ex15-64' and Nombre <> N'Smoochum δ' collate Latin1_General_BIN
update Productos set Nombre = N'Swablu δ' where CardId = 'ex15-65' and Nombre <> N'Swablu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Taillow δ' where CardId = 'ex15-66' and Nombre <> N'Taillow δ' collate Latin1_General_BIN
update Productos set Nombre = N'Totodile δ' where CardId = 'ex15-67' and Nombre <> N'Totodile δ' collate Latin1_General_BIN
update Productos set Nombre = N'Trapinch δ' where CardId = 'ex15-68' and Nombre <> N'Trapinch δ' collate Latin1_General_BIN
update Productos set Nombre = N'Trapinch δ' where CardId = 'ex15-69' and Nombre <> N'Trapinch δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoqueen δ' where CardId = 'ex15-7' and Nombre <> N'Nidoqueen δ' collate Latin1_General_BIN
update Productos set Nombre = N'Vulpix δ' where CardId = 'ex15-70' and Nombre <> N'Vulpix δ' collate Latin1_General_BIN
update Productos set Nombre = N'Wooper δ' where CardId = 'ex15-71' and Nombre <> N'Wooper δ' collate Latin1_General_BIN
update Productos set Nombre = N'Ninetales δ' where CardId = 'ex15-8' and Nombre <> N'Ninetales δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pinsir δ' where CardId = 'ex15-9' and Nombre <> N'Pinsir δ' collate Latin1_General_BIN
update Productos set Nombre = N'Altaria ex δ' where CardId = 'ex15-90' and Nombre <> N'Altaria ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Dragonite ex δ' where CardId = 'ex15-91' and Nombre <> N'Dragonite ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Flygon ex δ' where CardId = 'ex15-92' and Nombre <> N'Flygon ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Gardevoir ex δ' where CardId = 'ex15-93' and Nombre <> N'Gardevoir ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Kingdra ex δ' where CardId = 'ex15-94' and Nombre <> N'Kingdra ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latias ex δ' where CardId = 'ex15-95' and Nombre <> N'Latias ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Latios ex δ' where CardId = 'ex15-96' and Nombre <> N'Latios ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Rayquaza ex δ' where CardId = 'ex15-97' and Nombre <> N'Rayquaza ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Salamence ex δ' where CardId = 'ex15-98' and Nombre <> N'Salamence ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Tyranitar ex δ' where CardId = 'ex15-99' and Nombre <> N'Tyranitar ex δ' collate Latin1_General_BIN
update Productos set Nombre = N'Flareon ★' where CardId = 'ex16-100' and Nombre <> N'Flareon ★' collate Latin1_General_BIN
update Productos set Nombre = N'Jolteon ★' where CardId = 'ex16-101' and Nombre <> N'Jolteon ★' collate Latin1_General_BIN
update Productos set Nombre = N'Vaporeon ★' where CardId = 'ex16-102' and Nombre <> N'Vaporeon ★' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'ex6-70' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'ex6-71' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Mudkip ★' where CardId = 'ex7-107' and Nombre <> N'Mudkip ★' collate Latin1_General_BIN
update Productos set Nombre = N'Torchic ★' where CardId = 'ex7-108' and Nombre <> N'Torchic ★' collate Latin1_General_BIN
update Productos set Nombre = N'Treecko ★' where CardId = 'ex7-109' and Nombre <> N'Treecko ★' collate Latin1_General_BIN
update Productos set Nombre = N'Latias ★' where CardId = 'ex8-105' and Nombre <> N'Latias ★' collate Latin1_General_BIN
update Productos set Nombre = N'Latios ★' where CardId = 'ex8-106' and Nombre <> N'Latios ★' collate Latin1_General_BIN
update Productos set Nombre = N'Rayquaza ★' where CardId = 'ex8-107' and Nombre <> N'Rayquaza ★' collate Latin1_General_BIN
update Productos set Nombre = N'Imakuni?' where CardId = 'g1-63' and Nombre <> N'Imakuni?' collate Latin1_General_BIN
update Productos set Nombre = N'Giovanni''s Nidoran ♀' where CardId = 'gym2-75' and Nombre <> N'Giovanni''s Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Giovanni''s Nidoran ♂' where CardId = 'gym2-76' and Nombre <> N'Giovanni''s Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'hgss4-69' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'hgss4-70' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Pikachu δ' where CardId = 'np-35' and Nombre <> N'Pikachu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'pl2-71' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'pl2-72' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Chimecho δ' where CardId = 'pop4-1' and Nombre <> N'Chimecho δ' collate Latin1_General_BIN
update Productos set Nombre = N'Treecko δ' where CardId = 'pop4-15' and Nombre <> N'Treecko δ' collate Latin1_General_BIN
update Productos set Nombre = N'Deoxys δ' where CardId = 'pop4-2' and Nombre <> N'Deoxys δ' collate Latin1_General_BIN
update Productos set Nombre = N'Charmander δ' where CardId = 'pop5-10' and Nombre <> N'Charmander δ' collate Latin1_General_BIN
update Productos set Nombre = N'Meowth δ' where CardId = 'pop5-11' and Nombre <> N'Meowth δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pikachu δ' where CardId = 'pop5-13' and Nombre <> N'Pikachu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Pelipper δ' where CardId = 'pop5-14' and Nombre <> N'Pelipper δ' collate Latin1_General_BIN
update Productos set Nombre = N'Zangoose δ' where CardId = 'pop5-15' and Nombre <> N'Zangoose δ' collate Latin1_General_BIN
update Productos set Nombre = N'Espeon ★' where CardId = 'pop5-16' and Nombre <> N'Espeon ★' collate Latin1_General_BIN
update Productos set Nombre = N'Umbreon ★' where CardId = 'pop5-17' and Nombre <> N'Umbreon ★' collate Latin1_General_BIN
update Productos set Nombre = N'Mew δ' where CardId = 'pop5-3' and Nombre <> N'Mew δ' collate Latin1_General_BIN
update Productos set Nombre = N'Charmeleon δ' where CardId = 'pop5-5' and Nombre <> N'Charmeleon δ' collate Latin1_General_BIN
update Productos set Nombre = N'Cyrus ◇' where CardId = 'sm5-120' and Nombre <> N'Cyrus ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Super Boost Energy ◇' where CardId = 'sm5-136' and Nombre <> N'Super Boost Energy ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Giratina ◇' where CardId = 'sm5-58' and Nombre <> N'Giratina ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Lunala ◇' where CardId = 'sm5-62' and Nombre <> N'Lunala ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Darkrai ◇' where CardId = 'sm5-77' and Nombre <> N'Darkrai ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Solgaleo ◇' where CardId = 'sm5-89' and Nombre <> N'Solgaleo ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Lysandre ◇' where CardId = 'sm6-110' and Nombre <> N'Lysandre ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Beast Energy ◇' where CardId = 'sm6-117' and Nombre <> N'Beast Energy ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Volcanion ◇' where CardId = 'sm6-31' and Nombre <> N'Volcanion ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Diancie ◇' where CardId = 'sm6-74' and Nombre <> N'Diancie ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Arceus ◇' where CardId = 'sm6-96' and Nombre <> N'Arceus ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Latias ◇' where CardId = 'sm7-107' and Nombre <> N'Latias ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Latios ◇' where CardId = 'sm7-108' and Nombre <> N'Latios ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Lance ◇' where CardId = 'sm75-61' and Nombre <> N'Lance ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Victini ◇' where CardId = 'sm75-7' and Nombre <> N'Victini ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Jirachi ◇' where CardId = 'sm7-97' and Nombre <> N'Jirachi ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Xerneas ◇' where CardId = 'sm8-144' and Nombre <> N'Xerneas ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Ditto ◇' where CardId = 'sm8-154' and Nombre <> N'Ditto ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Heat Factory ◇' where CardId = 'sm8-178' and Nombre <> N'Heat Factory ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Life Forest ◇' where CardId = 'sm8-180' and Nombre <> N'Life Forest ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Lusamine ◇' where CardId = 'sm8-182' and Nombre <> N'Lusamine ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Celebi ◇' where CardId = 'sm8-19' and Nombre <> N'Celebi ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Thunder Mountain ◇' where CardId = 'sm8-191' and Nombre <> N'Thunder Mountain ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Shaymin ◇' where CardId = 'sm9-10' and Nombre <> N'Shaymin ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Black Market ◇' where CardId = 'sm9-134' and Nombre <> N'Black Market ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Wondrous Labyrinth ◇' where CardId = 'sm9-158' and Nombre <> N'Wondrous Labyrinth ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Tapu Koko ◇' where CardId = 'sm9-51' and Nombre <> N'Tapu Koko ◇' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'sm9-54' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'sm9-57' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Team Rocket''s Nidoran♀' where CardId = 'sv10-114' and Nombre <> N'Team Rocket''s Nidoran♀' collate Latin1_General_BIN
update Productos set Nombre = N'Team Rocket''s Nidoran♂' where CardId = 'sv10-117' and Nombre <> N'Team Rocket''s Nidoran♂' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'sv3pt5-29' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'sv3pt5-32' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Mimikyu δ' where CardId = 'swshp-SWSH136' and Nombre <> N'Mimikyu δ' collate Latin1_General_BIN
update Productos set Nombre = N'Greninja ★' where CardId = 'swshp-SWSH144' and Nombre <> N'Greninja ★' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'xy11-43' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'ナッシー[Exeggutor]' where CardId = 'xy12-109' and Nombre <> N'ナッシー[Exeggutor]' collate Latin1_General_BIN
update Productos set Nombre = N'Imakuni?''s Doduo' where CardId = 'xy12-112' and Nombre <> N'Imakuni?''s Doduo' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♂' where CardId = 'xy12-43' and Nombre <> N'Nidoran ♂' collate Latin1_General_BIN
update Productos set Nombre = N'Nidoran ♀' where CardId = 'xy5-66' and Nombre <> N'Nidoran ♀' collate Latin1_General_BIN
update Productos set Nombre = N'Umbreon ★' where CardId = 'cel25c-17' and Nombre <> N'Umbreon ★' collate Latin1_General_BIN
update Productos set Nombre = N'_____''s Pikachu' where CardId = 'cel25c-24' and Nombre <> N'_____''s Pikachu' collate Latin1_General_BIN
update Productos set Nombre = N'Gardevoir ex δ' where CardId = 'cel25c-93' and Nombre <> N'Gardevoir ex δ' collate Latin1_General_BIN
go
