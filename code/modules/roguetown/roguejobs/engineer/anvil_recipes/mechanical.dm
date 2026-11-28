/datum/anvil_recipe/engineering
	abstract_type = /datum/anvil_recipe/engineering
	i_type = "Engineering"
	appro_skill = /datum/skill/craft/engineering
	craftdiff = 1
	
//--------- TIN RECIPES -----------

/datum/anvil_recipe/engineering/nails
	name = "5x nails"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/construction/nail
	createditem_num = 5
	craftdiff = 1

// --------- IRON RECIPES -----------

/datum/anvil_recipe/engineering/jingle_bells
	name = "Jingling Bells"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/jingle_bells
	createditem_num = 5
	craftdiff = 1

/datum/anvil_recipe/engineering/flint
	name = "Flint (x3) (+1 stone)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/stone)
	created_item = /obj/item/flint
	createditem_num = 4
	craftdiff = 0

/datum/anvil_recipe/engineering/chains
	name = "Chains"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rope/chain
	createditem_num = 1
	craftdiff = 0

/datum/anvil_recipe/engineeredsmithing
	abstract_type = /datum/anvil_recipe/engineeredsmithing
	i_type = "Engineering"
	appro_skill = /datum/skill/craft/engineering
	craftdiff = 4
	req_trait = TRAIT_ENGINEER
	hides_from_books = TRUE
	req_bar = /obj/item/ingot/bronze

/datum/anvil_recipe/engineeredsmithing/dolabra
	name = "Copper Dolabra (+1 Copper)(+1 Quarterstaff)(Engineered)"
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/copper
	createditem_num = 1
	craftdiff = 2

/datum/anvil_recipe/engineeredsmithing/dolabra/iron
	name = "Iron Dolabra (+1 Iron)(+1 Quarterstaff)(Engineered)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/iron
	createditem_num = 1
	craftdiff = 3

/datum/anvil_recipe/engineeredsmithing/dolabra/albranze
	name = "Albranze Dolabra (+1 Bronze)(+1 Quarterstaff)(Engineered)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/albranze
	createditem_num = 1
	craftdiff = 4

/datum/anvil_recipe/engineeredsmithing/dolabra/steel
	name = "Steel Dolabra (+1 Steel)(+1 Quarterstaff)(Engineered)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/steel
	createditem_num = 1
	craftdiff = 4

/datum/anvil_recipe/engineeredsmithing/dolabra/silver
	name = "Silver Dolabra (+1 Silver)(+1 Quarterstaff)(Engineered)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/silver
	createditem_num = 1
	craftdiff = 5

/datum/anvil_recipe/engineeredsmithing/dolabra/gold
	name = "Gold Dolabra (+1 Gold, +1 Silk, +1 Silver, +1 Quarterstaff)(Engineered)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/natural/silk, /obj/item/ingot/silver, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/gold
	createditem_num = 1
	craftdiff = 5

/datum/anvil_recipe/engineeredsmithing/dolabra/blacksteel
	name = "Blacksteel Dolabra"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/pick/woodcutter/dolabra/blacksteel
	createditem_num = 1
	craftdiff = 5



