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

/datum/anvil_recipe/engineering/roughbarrel
	name = "Rough Iron Barrel (+5 iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/bombard_roughbarrel
	createditem_num = 1
	craftdiff = 5

/datum/anvil_recipe/engineering/sandedbarrel
	name = "Sanded Iron Barrel (+3 sand, +2 stone dust, +1 partially refined barrel)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/sand, /obj/item/alch/stonedust, /obj/item/alch/stonedust, /obj/item/bombard_partiallyrefinedbarrel)
	created_item = /obj/item/bombard_sandedbarrel
	createditem_num = 1
	craftdiff = 5

/datum/anvil_recipe/engineering/repairedsandedbarrel
	name = "Repair Sanded Barrel (+4 iron, +1 Sanded Iron Barrel)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/bombard_sandedbarrel)
	created_item = /obj/item/bombard_sandedrepairedbarrel
	createditem_num = 1
	craftdiff = 5
