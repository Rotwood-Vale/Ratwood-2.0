
/////////////
/// Ammo ///
///////////

/datum/artificer_recipe/ammo
	i_type = "Ammo"
	hammers_per_item = 6
	skill_level = 2

/datum/artificer_recipe/ammo/bolts
	name = "Crossbow Bolts 20x (+2 planks, +1 Iron)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank, /obj/item/natural/wood/plank, /obj/item/ingot/iron)
	created_item = list(/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt, /obj/item/ammo_casing/caseless/rogue/bolt)

/datum/artificer_recipe/ammo/arrows
	name = "Arrows 20x (+2 Planks, +1 Iron)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank, /obj/item/natural/wood/plank,  /obj/item/ingot/iron)
	created_item = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron,
						/obj/item/ammo_casing/caseless/rogue/arrow/iron, /obj/item/ammo_casing/caseless/rogue/arrow/iron)

/datum/artificer_recipe/ammo/pyrobolt_five
	name = "pyroclastic bolt x5 (+1 iron) (+1 fyritius)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius)
	created_item = list(/obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/pyro,
						/obj/item/ammo_casing/caseless/rogue/bolt/pyro, /obj/item/ammo_casing/caseless/rogue/bolt/pyro,
						/obj/item/ammo_casing/caseless/rogue/bolt/pyro)

/datum/artificer_recipe/ammo/pyroarrow_five
	name = "pyroclastic arrow x5 (+1 iron) (+1 fyritius)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/ingot/iron, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius)
	created_item = list(/obj/item/ammo_casing/caseless/rogue/arrow/pyro, /obj/item/ammo_casing/caseless/rogue/arrow/pyro,
						/obj/item/ammo_casing/caseless/rogue/arrow/pyro, /obj/item/ammo_casing/caseless/rogue/arrow/pyro,
						/obj/item/ammo_casing/caseless/rogue/arrow/pyro)

/datum/artificer_recipe/ammo/lead_ball
	name = "lead ball x8 (+2 iron)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = list(/obj/item/ammo_casing/caseless/bullet/lead, /obj/item/ammo_casing/caseless/bullet/lead,
						/obj/item/ammo_casing/caseless/bullet/lead, /obj/item/ammo_casing/caseless/bullet/lead,
						/obj/item/ammo_casing/caseless/bullet/lead, /obj/item/ammo_casing/caseless/bullet/lead,
						/obj/item/ammo_casing/caseless/bullet/lead, /obj/item/ammo_casing/caseless/bullet/lead)
	skill_level = 4

/datum/artificer_recipe/ammo/grapeshot
	name = "grapeshot x8 (+3 iron)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = list(/obj/item/ammo_casing/caseless/bullet/grapeshot, /obj/item/ammo_casing/caseless/bullet/grapeshot,
						/obj/item/ammo_casing/caseless/bullet/grapeshot, /obj/item/ammo_casing/caseless/bullet/grapeshot,
						/obj/item/ammo_casing/caseless/bullet/grapeshot, /obj/item/ammo_casing/caseless/bullet/grapeshot,
						/obj/item/ammo_casing/caseless/bullet/grapeshot, /obj/item/ammo_casing/caseless/bullet/grapeshot)
	skill_level = 4
