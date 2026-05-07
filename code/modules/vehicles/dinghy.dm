
//a ridable boat so players can traverse water tiles without drowning

/obj/vehicle/ridden/dinghy
	name = "dinghy"
	desc = "An unpretentious craft of pitch-sealed planks."
	icon = 'icons/obj/boat.dmi'
	icon_state = "dinghy"
	can_buckle = TRUE
	max_buckled_mobs = 2
	max_occupants = 2
	max_drivers = 2
	layer = ABOVE_MOB_LAYER
	move_resist = 0
	var/allowed_turf = /turf/open/water //includes all subtypes of water

/obj/vehicle/ridden/dinghy/Initialize(mapload)
	. = ..()
	var/datum/component/riding/base_riding = GetComponent(/datum/component/riding)
	if(base_riding && !istype(base_riding, /datum/component/riding/dinghy))
		qdel(base_riding)
	var/datum/component/riding/D = LoadComponent(/datum/component/riding/dinghy)
	D.keytype = /obj/item/rogueweapon/mace/oar
	D.allowed_turf_typecache = typecacheof(allowed_turf)
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 3), TEXT_SOUTH = list(0, 3), TEXT_EAST = list(-2, 3), TEXT_WEST = list(2, 3)))
	D.set_riding_offsets(2, list(TEXT_NORTH = list(0, -5), TEXT_SOUTH = list(0, 11), TEXT_EAST = list(-10, 3), TEXT_WEST = list(10, 3)))

/obj/vehicle/ridden/dinghy/relaymove(mob/user, direction)
	if(user?.buckled != src)
		if(is_occupant(user))
			remove_occupant(user)
		return FALSE
	if(!is_occupant(user))
		add_occupant(user)
	return driver_move(user, direction)

/obj/vehicle/ridden/dinghy/handle_buckled_mob_movement(newloc, direct, glide_size_override)
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(!buckled_mob || buckled_mob.loc == newloc)
			continue
		buckled_mob.forceMove(newloc)
		buckled_mob.set_glide_size(glide_size_override || glide_size)
		if(direct && !buckled_mob.throwing)
			buckled_mob.setDir(direct)
	return TRUE

/obj/vehicle/ridden/dinghy/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["ctrl"])
		var/mob/user = usr
		if(!isliving(user))
			return
		if(user.buckled != src)
			return
		// Ctrl+click to face a direction based on click location
		var/new_dir = get_dir(src, location)
		if(new_dir)
			user.setDir(new_dir)
		return TRUE

/obj/item/rogueweapon/mace/oar
	name = "oar"
	desc = "A wooden club with a flattened head for paddling boats about."
	icon = 'icons/obj/boat_accessories.dmi'
	icon_state = "oar"
	gripped_intents = null
	force = 15
	wdefense = 10
	smeltresult = null

/datum/crafting_recipe/roguetown/survival/oar
	name = "Oar (1 Log, 2 Fibers)"
	category = "Tools"
	result = /obj/item/rogueweapon/mace/oar
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/fibers = 2,
		)
	time = 15

/datum/crafting_recipe/roguetown/survival/boat
	name = "Dinghy (4 Logs, 3 Ash, 5 Fibers)"
	category = "Tools"
	result = /obj/vehicle/ridden/dinghy
	reqs = list(
		/obj/item/grown/log/tree = 4,
		/obj/item/ash = 3,
		/obj/item/natural/fibers = 5
		)
	time = 50
