//drape
/obj/structure/drape/
	plane = -3

/obj/structure/drape/desert
	name = "desert drape"
	desc = "Made from durable fabric, it serves its purpose."
	icon = 'modular_deserttown/icons/drapes.dmi'
	icon_state = "desertdrape"

/datum/crafting_recipe/roguetown/structure/zybdrape
	name = "desert drape"
	result = /obj/structure/drape/desert
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1
	ignoredensity = TRUE

/obj/structure/drape/zybantine
	name = "zybantine drape"
	desc = "Made from prestigious fabric, a display of wealth."
	icon = 'modular_deserttown/icons/drapes.dmi'
	icon_state = "zybantinedrape1"
	color = "#a3a3a3"

/obj/structure/drape/zybantine/Initialize()
	. = ..()
	icon_state = "zybantinedrape[rand(1, 2)]"

/datum/crafting_recipe/roguetown/structure/zybdrapefancy
	name = "fancy zybantine drape"
	result = /obj/structure/drape/zybantine
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 2 )
	craftdiff = 4
	ignoredensity = TRUE
	wallcraft = TRUE

//cushion
/obj/item/cushion/desert1
	name = "desert cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "desertcushion1"

/obj/item/cushion/desert2
	name = "desert cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "desertcushion2"

/obj/item/cushion/zybantine
	name = "zybantine cushion"
	icon = 'modular_deserttown/icons/cushions.dmi'
	icon_state = "zybantinecushion"

/datum/crafting_recipe/roguetown/sewing/zybcushion1
	name = "desert cushion (yellow)"
	result = list(/obj/item/cushion/desert1)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/zybcushion2
	name = "desert cushion (grey)"
	result = list(/obj/item/cushion/desert2)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/zybcushionfancy
	name = "zybantine cushion"
	result = list(/obj/item/cushion/zybantine)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

//kegs

/// The original hierarchy for barrels and buckets is kind of messy, and I didn't want to refactor it all to have sane subtypes.


/obj/structure/fermentation_keg/sandpot
	name = "sand pot"
	desc = "A common clay pot used for storing and sometimes fermenting fluids. Favoured over wooden barrels in the desert of Zybantium due to the relative scarcity of wood."
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "sandpot1"

/datum/crafting_recipe/roguetown/structure/sandpot
	name = "sand pot"
	result = /obj/structure/fermentation_keg/sandpot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 1

/obj/structure/fermentation_keg/fancypot
	name = "fancy pot"
	desc = "Decorative and Practical!"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "fancypot1"

/datum/crafting_recipe/roguetown/structure/fancypot
	name = "sand pot (fancy)"
	result = /obj/structure/fermentation_keg/fancypot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 3

/obj/item/reagent_containers/glass/bucket/tinypot
	name = "tiny pot"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "tinypot1"

/datum/crafting_recipe/roguetown/structure/tinypot
	name = "small clay pot"
	result = /obj/item/reagent_containers/glass/bucket/tinypot
	reqs = list(/obj/item/natural/clay = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/ceramics
	craftdiff = 2

/obj/structure/fermentation_keg/sandpot/Initialize()
	. = ..()
	icon_state = "sandpot[rand(1, 2)]"

/obj/structure/fermentation_keg/fancypot/Initialize()
	. = ..()
	icon_state = "fancypot[rand(1, 2)]"


// Subtypes for sandpots
/obj/structure/fermentation_keg/sandpot/random/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/sandpot/water/Initialize()
	. = ..()
	icon_state = "sandpot1"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/sandpot/beer/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/sandpot/wine/Initialize()
	. = ..()
	icon_state = "sandpot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)


// Subtypes for fancypots
/obj/structure/fermentation_keg/fancypot/random/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/fancypot/water/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/fancypot/beer/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/fancypot/wine/Initialize()
	. = ..()
	icon_state = "fancypot2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)

///
/obj/machinery/light/rogue/campfire/fireplace/desert
	name = "desert fireplace"
	icon = 'modular_deserttown/icons/fireplace.dmi'
	icon_state = "fireplace1"
	base_state = "fireplace"
	fueluse = 0
	density = FALSE
	anchored = TRUE
	cookonme = FALSE

/datum/crafting_recipe/roguetown/structure/fireplace/desert
	name = "desert fireplace"
	result = /obj/machinery/light/rogue/campfire/fireplace/desert
	// reqs = list(/obj/item/grown/log/tree/small = 1,
	// 			/obj/item/natural/stoneblock = 3)
	// verbage_simple = "build"
	// verbage = "builds"
	// skillcraft = /datum/skill/craft/masonry
	// wallcraft = TRUE


///////////

/obj/structure/pillar
	name = "pillar"
	desc = ""
	icon = 'modular_deserttown/icons/sandpillar.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	pixel_x = -16
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/pillar

/obj/structure/pillar/sand1
	icon_state = "sandpillar1"

/datum/crafting_recipe/roguetown/structure/pillar/desert
	name = "sandstone pillar"
	result = /obj/structure/pillar/sand1
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "builds"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 4

/obj/structure/large_pillar
	name = "pillar"
	desc = ""
	icon = 'modular_deserttown/icons/temple_objects_tall.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER
	abstract_type = /obj/structure/large_pillar

/obj/structure/large_pillar/broken
	icon_state = "tall_pillar_1"

/obj/structure/large_pillar/broken2
	icon_state = "tall_pillar_4"

/obj/structure/large_pillar/damaged1
	icon_state = "tall_pillar_2"

/obj/structure/large_pillar/damaged2
	icon_state = "tall_pillar_3"

/obj/structure/large_pillar/normal
	icon_state = "tall_pillar_5"

/obj/structure/obelisk
	name = "ancient obelisk"
	desc = "An ancient obelisk. It has archaic inscriptions in the stone work- ancient Drakian, maybe?"
	icon = 'modular_deserttown/icons/temple_objects_verytall.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER
	pixel_x = -16
	abstract_type = /obj/structure/obelisk
	var/translation // set per instance in the map

/obj/structure/obelisk/attack_hand(mob/user)
	.=..()
	attempt_translate(user)

/obj/structure/obelisk/proc/attempt_translate(mob/living/user)
	if(!translation)
		to_chat(user, span_notice("You find nothing decipherable on the obelisk."))
		return
	to_chat(user, span_notice("You begin studying the archaic inscriptions..."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	var/chance = 	clamp(20 + (user.STAINT - 10) * 6, 0, 100)
	if(prob(chance))
		to_chat(user, span_notice("Understanding dawns on you: [translation]"))
	else
		to_chat(user, span_warning("The drakian script remains indecipherable to you."))

/obj/structure/obelisk/destroyed
	desc = "An ancient obelisk. Whatever magic it once held is long since gone, damaged beyond function."
	icon_state = "obelisk_destroyed"

/obj/structure/obelisk/active
	desc = "An ancient obelisk"
	icon_state = "obelisk_short"
	var/scan_range = 3					// how far it reaches out to players
	var/list/mob/living/carbon/human/targets = list()
	var/list/datum/beam/active_beams = list()	// assoc: mob -> beam
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/obelisk/active/tall
	icon_state = "obelisk_tall"

/obj/structure/obelisk/active/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/obelisk/active/Destroy()
	STOP_PROCESSING(SSobj, src)
	clear_all_beams()
	return ..()

/obj/structure/obelisk/active
	var/current_beam_night = FALSE   // tracks which colour state the active beams are in

/obj/structure/obelisk/active/process()
	var/list/found = list()
	for(var/mob/living/carbon/human/H in view(scan_range, src))
		if(H.stat == DEAD)
			continue
		found += H

	// drop anyone who wandered off - their buff/debuff will just expire naturally
	// since we stop refreshing it (see apply_obelisk_effect)
	for(var/mob/living/carbon/human/old in targets)
		if(!(old in found))
			remove_target(old)

	var/night
	if(GLOB.tod == "night")
		night = TRUE
	else
		night = FALSE

	// day/night flipped while people were already standing here - refresh their beam colour
	if(night != current_beam_night && length(targets))
		refresh_beam_colour(night)
	current_beam_night = night

	for(var/mob/living/carbon/human/H in found)
		if(!(H in targets))
			add_target(H, night)
		apply_obelisk_effect(H, night)

/obj/structure/obelisk/active/proc/add_target(mob/living/carbon/human/H, night)
	targets += H
	var/beam_icon_state = night ? "drainbeam" : "medbeam"
	var/datum/beam/B = src.Beam(H, icon_state = beam_icon_state, time = 35 SECONDS, maxdistance = scan_range + 2)
	if(B)
		active_beams[H] = B

/obj/structure/obelisk/active/proc/remove_target(mob/living/carbon/human/H)
	targets -= H
	var/datum/beam/B = active_beams[H]
	if(B && !QDELETED(B))
		qdel(B)
	active_beams -= H

/obj/structure/obelisk/active/proc/refresh_beam_colour(night)
	var/beam_icon_state = night ? "drainbeam" : "medbeam"
	for(var/mob/living/carbon/human/H in targets)
		var/datum/beam/old_beam = active_beams[H]
		if(old_beam && !QDELETED(old_beam))
			qdel(old_beam)
		var/datum/beam/B = src.Beam(H, icon_state = beam_icon_state, time = 35 SECONDS, maxdistance = scan_range + 2)
		if(B)
			active_beams[H] = B

/obj/structure/obelisk/active/proc/apply_obelisk_effect(mob/living/carbon/human/H, night)
	if(night)
		H.apply_status_effect(/datum/status_effect/buff/energy_shift/leyline_drain, 5 SECONDS)
	else
		H.apply_status_effect(/datum/status_effect/buff/energy_shift/obelisk_power, 5 SECONDS)

/obj/structure/obelisk/active/proc/clear_all_beams()
	for(var/mob/living/carbon/human/H in active_beams)
		var/datum/beam/B = active_beams[H]
		if(B && !QDELETED(B))
			qdel(B)
	active_beams.Cut()
	targets.Cut()

#define OBELISK_ENERGY_FILTER "obelisk_energy_filter"

/datum/status_effect/buff/energy_shift
	id = "energy_shift"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	var/amount = 5			// always positive, direction comes from sign
	var/sign = 1			// 1 = restore, -1 = drain
	var/outline_colour = "#3a86ff"

/datum/status_effect/buff/energy_shift/on_apply()
	owner.add_filter(OBELISK_ENERGY_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 80, "size" = 1))
	return TRUE

/datum/status_effect/buff/energy_shift/tick()
	. = ..()
	if(QDELETED(owner))
		qdel(src)
		return
	if(owner.stat == DEAD)
		return
	owner.energy_add(sign * amount)

/datum/status_effect/buff/energy_shift/on_remove()
	owner.remove_filter(OBELISK_ENERGY_FILTER)
	return ..()

#undef OBELISK_ENERGY_FILTER

// --- Restore variant ---

/atom/movable/screen/alert/status_effect/buff/obelisk_power
	name = "Invigorated"
	desc = "The obelisk replenishes my energy."
	icon_state = "buff"

/datum/status_effect/buff/energy_shift/obelisk_power
	id = "obelisk_power"
	alert_type = /atom/movable/screen/alert/status_effect/buff/obelisk_power
	amount = 5
	sign = 1
	outline_colour = "#3a86ff"

// --- Drain variant ---

/atom/movable/screen/alert/status_effect/debuff/leyline_drain
	name = "Drained"
	desc = "The obelisk pulls energy from my body."
	icon_state = "leyline_drain"

/datum/status_effect/buff/energy_shift/leyline_drain
	id = "leyline_drain"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/leyline_drain
	amount = 5
	sign = -1
	outline_colour = "#d62828"

/obj/structure/obelisk/tall
	icon_state = "obelisk_tall"

/obj/structure/obelisk/writing
	icon_state = "obelisk_writing"

/obj/structure/obelisk/tall/damaged
	icon_state = "obelisk_writing_damaged"

/obj/structure/ozymandias
	name = "ruined ancient statue"
	desc = "Look upon my works ye Mighty, and despair!"
	icon = 'modular_deserttown/icons/temple_objects_big.dmi'
	icon_state = "ozymandias"
	opacity = 0
	max_integrity = 20000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER

/obj/structure/ancienthead
	name = "ruined ancient statue"
	desc = "Colors fade, temples crumble, empires fall..."
	icon = 'modular_deserttown/icons/temple_objects_big.dmi'
	icon_state = "head"
	opacity = 0
	max_integrity = 20000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER

/obj/structure/dualpillar
	name = "dual pillar"
	desc = ""
	icon = 'modular_deserttown/icons/temple_objects_big.dmi'
	icon_state = "dual_pillar_1"
	opacity = 0
	max_integrity = 1000
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	plane = GAME_PLANE_UPPER
	pixel_x = -16

/obj/structure/dualpillar/type2
	icon_state = "dual_pillar_2"

/obj/structure/dualpillar/type3
	icon_state = "dual_pillar_3"

/obj/structure/dualpillar/type4
	icon_state = "dual_pillar_4"

/obj/structure/dualpillar/type5
	icon_state = "dual_pillar_5"

/obj/structure/dualpillar/type6
	icon_state = "dual_pillar_6"



/obj/structure/table/templestoneslab
	name = "stone slab"
	desc = ""
	icon = 'modular_deserttown/icons/temple_objects.dmi'
	icon_state = "slab_1"
	max_integrity = 400
	smooth = 0
	climb_offset = 10
	debris = list(/obj/item/natural/stoneblock = 1)

/obj/structure/table/templestoneslab/slab2
	icon_state = "slab_2"

/obj/structure/table/templestoneslab/slab3
	icon_state = "slab_3"

/obj/structure/table/templestoneslab/slab4
	icon_state = "slab_4"

/obj/structure/table/templestoneslab/slab5
	icon_state = "slab_5"

/client/proc/admin_move_oasis()
	set name = "Move Mirage Oasis"
	set category = "-GameMaster-"
	set desc = "Force the mirage oasis to relocate to a random marker now"

	if(!GLOB.mirage_controller)
		to_chat(usr, span_warning("No mirage controller exists - has one been initialized this round?"))
		return

	if(!GLOB.mirage_markers.len)
		to_chat(usr, span_warning("No mirage markers found on this map."))
		return

	var/success = GLOB.mirage_controller.MoveOasis()
	if(success)
		message_admins("[key_name(usr)] forced the mirage oasis to relocate.")
		log_admin("[key_name(usr)] forced the mirage oasis to relocate.")
	else
		to_chat(usr, span_warning("Couldn't find a clear marker to relocate to - all candidates may be occupied."))

/// Quicksand

/obj/structure/quicksand
	name = "quicksand"
	desc = "The sand shifts unnaturally beneath your feet."
	icon = 'modular_deserttown/icons/quicksand.dmi'
	icon_state = "quicksand"

	density = FALSE
	anchored = TRUE

	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	max_integrity = -1
	alpha = 175
	plane = -8

/obj/structure/quicksand/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/mob_overlay_effect, 2, -2, 100)

/obj/structure/quicksand/Crossed(atom/movable/AtomMovable)
	. = ..()
	if(has_buckled_mobs())
		return
	if(!ishuman(AtomMovable))
		return
	var/mob/living/carbon/human/Living = AtomMovable
	if(Living.buckled)
		return
	if(Living.m_intent == MOVE_INTENT_SNEAK)
		return
	buckle_mob(Living, TRUE, check_loc = FALSE)
	SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, Living)
	visible_message(span_warning("[Living] sinks into the quicksand!"))
	START_PROCESSING(SSobj, src)

/obj/structure/quicksand/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	var/mob/living/carbon/human/Human = buckled_mob
	var/escape_amount = max(CEILING((20 - user.STASTR) / 2, 1), 2)
	var/escape_time = escape_amount SECONDS
	user.visible_message(span_warning("[user] struggles to escape the quicksand!"))

	if(!do_after(user, escape_time, FALSE, src))
		return

	playsound(src, FOOTSTEP_MUD, 50)

	unbuckle_mob(Human)
	SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, Human)
	Human.stamina_add(75)

	visible_message(span_notice("[buckled_mob] drags themselves free of the quicksand!"))

/obj/structure/quicksand/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/rogueweapon/shovel))
		playsound(loc,'sound/items/dig_shovel.ogg', 100, TRUE)
		to_chat(user, span_info("I start digging up \the [name]..."))
		if(do_after(user, 5 SECONDS, src))
			playsound(loc,'sound/items/empty_shovel.ogg', 100, TRUE)
			qdel(src)
			return
	return

/obj/structure/quicksand/attack_hand(mob/user)
	if(has_buckled_mobs())
		var/person = buckled_mobs[1].name
		if(user == buckled_mobs[1])
			person = "themself"
		user.visible_message(span_warning("[user.name] starts to pull [person] out of the quicksand!"))
		if(do_after(user, 2 SECONDS))
			unbuckle_mob(buckled_mobs[1], TRUE)
			user.visible_message(span_warning("[user.name] pulls [person] out of the quicksand."))
	. = ..()

/obj/structure/quicksand/process()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
		return
	for(var/mob/living/carbon/human/L in buckled_mobs)
		L.energy_add(-2)

/obj/structure/quicksand/user_buckle_mob(mob/living/buckled_mob, mob/living/user)
	return

/datum/crafting_recipe/roguetown/quicksand
	name = "quicksand pit"
	result = /obj/structure/quicksand
	reqs = list(/datum/reagent/water = 240)
	time = 10 SECONDS
	verbage_simple = "mixes together"
	verbage = "mixes together"
	craftsound = 'sound/foley/Building-01.ogg'
	craftdiff = 0

/datum/crafting_recipe/roguetown/quicksand/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue/dunes))
		return
	return TRUE


////decorative templestuff

/obj/structure/fluff/templedebris
	name = "sand pile"
	desc = "A pile of loose sand."
	icon_state = "sandpile"
	var/sandamt = 5
	icon = 'modular_deserttown/icons/temple_objects.dmi'
	climbable = FALSE
	density = FALSE
	climb_offset = 10

/obj/structure/fluff/templedebris/pillar
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_1"
/obj/structure/fluff/templedebris/pillar2
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_2"
/obj/structure/fluff/templedebris/pillar3
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_3"
/obj/structure/fluff/templedebris/pillar4
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "pillar_4"
/obj/structure/fluff/templedebris/debris
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "debris_1"
/obj/structure/fluff/templedebris/debris2
	name = "ruined pillar"
	desc = "The destroyed remains of a pillar."
	icon_state = "debris_2"
/obj/structure/fluff/templedebris/debris3
	name = "rocky debris"
	desc = "The destroyed remains of some old stone object."
	icon_state = "debris_3"
/obj/structure/fluff/templedebris/debris4
	name = "rocky debris"
	desc = "The destroyed remains of some old stone object."
	icon_state = "debris_4"
/obj/structure/fluff/templedebris/debris5
	name = "rocky debris"
	desc = "The destroyed remains of some old stone object."
	icon_state = "debris_5"
/obj/structure/fluff/templedebris/ruinedslab
	name = "cracked slab"
	desc = "A stone slab now ruined and broken."
	icon_state = "slab_6"
/obj/structure/fluff/templedebris/ruinedslab2
	name = "cracked slab"
	desc = "A stone slab now ruined and broken."
	icon_state = "slab_7"
/obj/structure/fluff/templedebris/bricks
	name = "pile of bricks"
	desc = "A some stone bricks left about."
	icon_state = "smallbricks_1"
/obj/structure/fluff/templedebris/bricks2
	name = "pile of bricks"
	desc = "A some stone bricks left about."
	icon_state = "smallbricks_2"
/obj/structure/fluff/templedebris/bricks3
	name = "pile of bricks"
	desc = "A some stone bricks left about."
	icon_state = "smallbricks_3"
////chairs

/obj/structure/chair/wood/zybantine
	name = "zybantine chair"
	icon = 'modular_deserttown/icons/chairs.dmi'
	icon_state = "zybantinechair"

/obj/structure/chair/wood/rogue/throne/zybantine
	name = "zybantine throne"
	icon_state = "zybantinethrone"
	icon = 'modular_deserttown/icons/throne.dmi'
	pixel_x = -16

/datum/crafting_recipe/roguetown/structure/chair/zyb
	name = "wooden chair"
	result = /obj/structure/chair/wood/zybantine
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry


/obj/structure/chair/sofa
	name = "old ratty sofa"
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/chair/sofa/corner
	icon_state = "sofacorner"


/obj/structure/chair/zybantine_sofa/right
	name = "zybantine sofa"
	icon_state = "zybantinesofa_right"
	icon = 'modular_deserttown/icons/chairs.dmi'
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/zybantine_sofa/left
	name = "zybantine sofa"
	icon_state = "zybantinesofa_left"
	icon = 'modular_deserttown/icons/chairs.dmi'
	buildstackamount = 1
	item_chair = null

//Sandrocks

/obj/structure/sandrock
	name = "sandrock"
	desc = "A large desert rock protuding from the ground."
	icon_state = "rock1"
	icon = 'modular_deserttown/icons/sandrock.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	pixel_x = -48
	pixel_y = -18
	layer = 4.81
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/sandrock

/obj/structure/sandrock/sandrock1
	icon_state = "sandrock1"

/obj/structure/sandrock/sandrock2
	icon_state = "sandrock2"

/obj/structure/sandrock/sandrock3
	icon_state = "sandrock3"

/obj/structure/sandrock/sandrock4
	icon_state = "sandrock4"

/obj/item/natural/rock/desert
	name = "sand rock"
	icon = 'modular_deserttown/icons/small_sandrock.dmi'
	icon_state = "sandrock1"

/obj/item/natural/rock/desert/Initialize()
	. = ..()
	icon_state = "sandrock[rand(1,2)]"


//bush

/obj/structure/flora/roguegrass/bush/desert
	name = "saigahorn"
	desc = ""
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "saigahorn1"

/obj/structure/flora/roguegrass/bush/desert/Initialize()
	. = ..()
	icon_state = "saigahorn[rand(1, 3)]"

/obj/structure/flora/roguegrass/bush/desertshrub
	name = "treelet"
	desc = "A rounded bush-like tree or perhaps tree-like bush native to Zybantium. A valuable source of wood in the sparse desert."
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "bushshrub1"
	attacked_sound = 'sound/misc/woodhit.ogg'
	max_integrity = 100
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)

/obj/structure/flora/roguegrass/bush/desertshrub/Initialize()
	. = ..()
	icon_state = "bushshrub[pick(1,2)]"

/obj/structure/flora/roguetree/palm
	name = "palm tree"
	desc = "Scant, precious shade."
	icon = 'modular_deserttown/icons/bigpalm.dmi'
	icon_state = "palm1"
	stump_type = /obj/structure/flora/roguetree/stump/palm
	pixel_x = -32
	opacity = 0 //palm trees are skinny
	density = 0

/obj/structure/flora/roguetree/palm/Initialize()
	. = ..()
	icon_state = "palm[rand(1,2)]"

/obj/structure/flora/roguetree/stump/palm
	name = "tree stump"
	desc = "Shade no more."
	icon_state = "palmstump1"
	icon = 'modular_deserttown/icons/bigpalm.dmi'
	stump_type = null
	pixel_x = -32
	density = 0

/obj/structure/flora/roguetree/stump/palm/Initialize()
	. = ..()
	icon_state = "palmstump[rand(1,2)]"

/obj/structure/flora/roguegrass/bush/wall/tall/desert
	icon = 'modular_deserttown/icons/alt/foliagetall.dmi'

// /obj/structure/flora/roguegrass/bush/wall/tall/desert/Initialize()
// 	. = ..()
// 	icon_state = "tallbush[pick(1,2)]"

//Stairs

/obj/structure/stairs/desert
	name = "sand stairs"
	icon = 'modular_deserttown/icons/sandstairs.dmi'
	icon_state = "sandstairs"
	max_integrity = 600

//If we need to change the number of rooms
// /obj/structure/roguemachine/vendor/inndesert
// 	keycontrol = "tavern"

// /obj/structure/roguemachine/vendor/inndesert/Initialize()
// 	. = ..()

// 	// Add room keys with a price of 20
// 	for (var/X in list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv))
// 		var/obj/P = new X(src)
// 		held_items[P] = list()
// 		held_items[P]["NAME"] = P.name
// 		held_items[P]["PRICE"] = 20

// 	// Add fancy keys with a price of 100
// 	for (var/Y in list(/obj/item/roguekey/fancyroomi, /obj/item/roguekey/fancyroomii, /obj/item/roguekey/fancyroomiii))
// 		var/obj/Q = new Y(src)
// 		held_items[Q] = list()
// 		held_items[Q]["NAME"] = Q.name
// 		held_items[Q]["PRICE"] = 100

// 	update_icon()

//weapons

/obj/item/rogueweapon/shield/iron/zybantine
	name = "brass shield"
	desc = "A sturdy shield of Zybantium make."
	icon = 'modular_deserttown/icons/items/desertweapons32.dmi'
	icon_state = "zybshield"
	max_integrity = 250
	blade_dulling = DULLING_BASH
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	sellprice = 30
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent
	name = "\improper Staff of the Serpent"
	desc = "A mysterious golden staff shaped like a snake. You could swear its staring at you"
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "snakestaff"


// /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
// 	name = "heavy scimitar"
// 	desc = "A large zybantine sword with a single-edged blade, a crossguard and a knife-like hilt. "
// 	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
// 	icon_state = "Kmesser"

/obj/structure/fluff/traveltile/alashurentrance
	desc = "Awake from this dream. The road to Al-Ashur awaits."
	name = "To Al-Ashur"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "underworldportal"

// Effects
/obj/effect/decal/edge/desert_gray
	color = "#655653"

/obj/effect/decal/edge_corner/desert_gray
	color = "#655653"

//Decor
/obj/structure/vase
	name = "fancy pot"
	desc = "Decorative and Practical!"
	icon = 'modular_deserttown/icons/pots.dmi'
	icon_state = "fancypot1"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	max_integrity = 100

//Noc Window
/obj/structure/roguewindow/stained/blue
	icon = 'modular_deserttown/icons/windows.dmi'
	icon_state = "stained-blue"
	base_state = "stained-blue"

/obj/structure/flora/roguegrass/desertgrass
	name = "desert grass"
	desc = "Dry grass struggling to survive in the arid climate."
	icon = 'modular_deserttown/icons/flora.dmi'
	icon_state = "desertgrass1"

/obj/structure/flora/roguegrass/desertgrass/update_icon()
	icon_state = "desertgrass[rand(1, 5)]"
