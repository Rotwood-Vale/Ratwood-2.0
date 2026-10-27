/datum/anvil_recipe/engineering
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
	i_type = "Engineering"
	appro_skill = /datum/skill/craft/engineering
	craftdiff = 4
	req_trait = TRAIT_ENGINEER
	hides_from_books = TRUE
	req_bar = /obj/item/ingot/blacksteel

/datum/anvil_recipe/engineeredsmithing/dolabra //exists solely to replace a stolen dolabra
	name = "Blacksteel Dolabra"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter/dolabra/blacksteel
	createditem_num = 1
	craftdiff = 4

/datum/anvil_recipe/engineeredsmithing/dolabra/albranze
	name = "Albranze Dolabra"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/rogueweapon/woodstaff/quarterstaff)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter/dolabra/albranze
	createditem_num = 1
	craftdiff = 4
