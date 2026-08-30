/obj/effect/quest_spawn
	name = "quest spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_OBSERVER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/atom/movable/contained_atom
	var/revealing = FALSE
	var/prox_range = 7

/obj/effect/quest_spawn/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, prox_range)

/obj/effect/quest_spawn/Destroy(force)
	QDEL_NULL(contained_atom)
	// Must QDEL, not null: only the monitor's own Destroy() runs QDEL_LIST(checkers), and this
	// spawner has 225 of them (range 7). Assigning null instead orphans every checker on the map
	// with a dangling monitor, and each one runtimes on Crossed() for the rest of the round.
	QDEL_NULL(proximity_monitor)
	. = ..()

/obj/effect/quest_spawn/HasProximity(mob/nearby)
	if(!contained_atom)
		return

	if(!istype(nearby))
		return

	var/datum/component/quest_object/quest_component = GetComponent(/datum/component/quest_object)
	if(!istype(quest_component))
		return

	var/datum/quest/quest = quest_component.quest_ref?.resolve()
	if(!istype(quest))
		return

	var/turf/our_turf = get_turf(src)
	var/turf/scroll_turf = get_turf(quest.quest_scroll_ref?.resolve())
	if(!our_turf || !scroll_turf)
		return

	// Matches blockade_defense's check_arrival() - get_dist alone lets a bearer one level up
	// or down trip the pod.
	if(our_turf.z != scroll_turf.z)
		return

	if(get_dist(our_turf, scroll_turf) > prox_range)
		return

	// Pop every spawner this quest owns at once so the whole encounter materializes together.
	quest.pop_all_spawners()

/obj/effect/quest_spawn/ex_act()
	return

/obj/effect/quest_spawn/notorious
	prox_range = NOTORIOUS_BOUNTY_PROX_RANGE

/obj/effect/quest_spawn/proc/reveal_contained()
	if(!contained_atom || revealing)
		return

	revealing = TRUE
	new /obj/effect/temp_visual/contract_phantom(get_turf(src), contained_atom)
	addtimer(CALLBACK(src, PROC_REF(finish_reveal)), QUEST_SPAWN_REVEAL_TIME)

/obj/effect/quest_spawn/proc/finish_reveal()
	if(!contained_atom)
		qdel(src)
		return
	if(isliving(contained_atom))
		var/datum/component/quest_object/quest_component = GetComponent(/datum/component/quest_object)
		var/datum/quest/kill/notorious_bounty/quest = quest_component?.quest_ref?.resolve()
		if(istype(quest))
			INVOKE_ASYNC(quest, TYPE_PROC_REF(/datum/quest/kill/notorious_bounty, offer_boss_control), contained_atom)
	return

/obj/effect/temp_visual/contract_phantom
	name = "approaching threat"
	desc = "Something is closing in..."
	anchored = TRUE
	randomdir = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = QUEST_SPAWN_REVEAL_TIME

/obj/effect/temp_visual/contract_phantom/Initialize(mapload, atom/movable/previewed)
	. = ..()
	if(QDELETED(previewed))
		return INITIALIZE_HINT_QDEL

	appearance = previewed.appearance
	name = initial(name)
	desc = initial(desc)
	invisibility = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	color = "#777777"
	alpha = 0
	animate(src, alpha = 200, time = duration, easing = EASE_IN)
