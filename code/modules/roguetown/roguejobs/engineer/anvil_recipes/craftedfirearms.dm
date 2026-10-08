/datum/anvil_recipe/firearms
	i_type = "Engineering"
	abstract_type = /datum/anvil_recipe/firearms
	appro_skill = /datum/skill/craft/engineering
	req_trait = TRAIT_GUNSMITH
	craftdiff = 4
	hides_from_books = TRUE

	// firearms

/datum/anvil_recipe/firearms/arquebuspistol
	name = "Arquebus Pistol"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/flint, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank)
	created_item = /obj/item/gun/ballistic/firearm/arquebus_pistol
	createditem_num = 1
	craftdiff = 4

/datum/anvil_recipe/firearms/arquebusrifle
	name = "Arquebus Rifle"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/flint, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank)
	created_item = /obj/item/gun/ballistic/firearm/arquebus
	createditem_num = 1
	craftdiff = 4

/datum/anvil_recipe/firearms/flintgonne
	name = "Flintgonne"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/flint, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank)
	created_item = /obj/item/gun/ballistic/firearm/flintgonne
	createditem_num = 1
	craftdiff = 4

/*/datum/anvil_recipe/firearms/engineeredrifle
	name = "Jaeger Rifle"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/flint, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank)
	created_item = /obj/item/gun/ballistic/firearm/jaeger_rifle
	createditem_num = 1
	craftdiff = 4

/datum/anvil_recipe/firearms/engineeredpistol
	name = "Jaeger Pistol"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/flint, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/natural/wood/plank)
	created_item = /obj/item/gun/ballistic/firearm/jaeger_pistol
	createditem_num = 1
	craftdiff = 4
