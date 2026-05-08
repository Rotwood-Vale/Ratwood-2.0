/obj/item/storage/gadget
	name = "gadget"
	desc = "A gadget of some sort."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "gadget"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF

/obj/item/storage/gadget/messkit
	name = "mess kit"
	desc = "A small, portable mess kit. It can be used to cook food."
	slot_flags = ITEM_SLOT_HIP
	grid_width = 64
	grid_height = 32
	icon_state = "messkit"
	component_type = /datum/component/storage/concrete/roguetown/messkit

/obj/item/storage/gadget/messkit/PopulateContents()
	new /obj/item/cooking/platter(src)
	new /obj/item/reagent_containers/glass/bowl(src)
	new /obj/item/cooking/pan(src)
	new /obj/item/reagent_containers/glass/bucket/pot/kettle(src)

/obj/item/folding_table_stored
	name = "folding table"
	desc = "A folding table, useful for setting up a temporary workspace."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "foldingTableStored"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	grid_height = 32
	grid_width = 64
	var/unfolded_structure = /obj/structure/table/wood/folding

/obj/item/folding_table_stored/attack_self(mob/user)
	. = ..()
	//deploy the table if the user clicks on it with an open turf in front of them
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't deploy the [name] here!"))
		return NONE
	if(isopenturf(target_turf))
		deploy_folding_table(user, target_turf)
		return TRUE
	return NONE

/obj/item/folding_table_stored/proc/deploy_folding_table(mob/user, atom/location)
	if(do_after(user, 3 SECONDS))
		to_chat(user, "<span class='notice'>You deploy the [name].</span>")
		new unfolded_structure(location)
		qdel(src)

/obj/item/folding_table_stored/alchstation
	name = "alchemical station kit"
	desc = "A compact portable laboratory that stores everything necessary for the activities of a wandering alchemist."
	icon_state = "foldingAlchstationStored"
	grid_height = 64
	grid_width = 64
	unfolded_structure = /obj/structure/fluff/alch/folding

/obj/item/folding_table_stored/alchcauldron
	name = "folding cauldron"
	desc = "A folding table, useful for setting up a temporary workspace."
	icon_state = "FoldingCauldronStored"
	grid_height = 64
	grid_width = 64
	unfolded_structure = /obj/machinery/light/rogue/cauldron/folding

/datum/anvil_recipe/engineering/construct_skill_core
	name = "Golem Skill Exhibitor"
	created_item = /obj/item/construct_skill_core
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/roguegear, /obj/item/roguegear)
	craftdiff = 3
