GLOBAL_LIST_EMPTY(expedition_level_entries)
GLOBAL_LIST_EMPTY(expedition_level_exits)
GLOBAL_LIST_EMPTY(expedition_departure_gates)

/obj/structure/expedition_gate
	name = "expedition portal"
	desc = "A flickering, warping rift in reality leading deep into uncharted depths."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	max_integrity = 0
	obj_flags = INDESTRUCTIBLE
	
	var/stage_number = 0
	var/requires_clear = FALSE
	var/is_activating = FALSE

/obj/structure/expedition_gate/Initialize(mapload)
	. = ..()
	GLOB.expedition_level_exits["[src.stage_number]"] = src

/obj/structure/expedition_gate/Destroy()
	GLOB.expedition_level_exits -= "[src.stage_number]"
	return ..()

/obj/structure/expedition_gate/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		attempt_travel(AM)

/obj/structure/expedition_gate/attack_hand(mob/user)
	attempt_travel(user)
	return ..()

/obj/structure/expedition_gate/attackby(obj/item/W, mob/user, params)
	attempt_travel(user)
	return ..()

/obj/structure/expedition_gate/attack_ghost(mob/dead/observer/user)
	if(invisibility)
		return ..()
	var/next_stage = stage_number + 1
	var/obj/structure/expedition_marker/entry/next_entry = GLOB.expedition_level_entries["[next_stage]"]
	if(next_entry)
		user.forceMove(get_turf(next_entry))
	return ..()

/obj/structure/expedition_gate/proc/attempt_travel(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(invisibility)
		return

	if(get_dist(src, H) > 1)
		return

	if(GLOB.expedition_status != EXPEDITION_ACTIVE)
		to_chat(H, span_warning("The portal remains dormant. No crusade is active."))
		return

	if(!HAS_TRAIT(H, TRAIT_EXPEDITION_MEMBER))
		to_chat(H, span_danger("An impenetrable magical barrier repels you! You are not consecrated for this crusade."))
		playsound(src, 'sound/misc/machineno.ogg', 50, FALSE)
		var/step_dir = get_dir(src, H) || pick(GLOB.alldirs)
		H.throw_at(get_edge_target_turf(H, step_dir), 2, 1)
		return

	if(is_activating)
		return

	if(requires_clear && !is_area_cleared())
		to_chat(H, span_warning("The portal remains dormant! Hostile fiends still lurk nearby!"))
		playsound(src, 'sound/misc/hiss.ogg', 50, FALSE)
		return

	var/next_stage = stage_number + 1
	var/obj/structure/expedition_marker/entry/destination = GLOB.expedition_level_entries["[next_stage]"]

	if(!destination)
		to_chat(H, span_danger("The portal leads into a dead end! (Level [next_stage] missing!)"))
		return

	INVOKE_ASYNC(src, PROC_REF(begin_party_transit), H, destination)

/obj/structure/expedition_gate/proc/is_area_cleared()
	var/area/A = get_area(src)
	for(var/mob/living/simple_animal/hostile/M in A)
		if(!QDELETED(M) && M.stat != DEAD)
			return FALSE
	return TRUE

/obj/structure/expedition_gate/proc/begin_party_transit(mob/living/carbon/human/initiator, obj/structure/expedition_marker/entry/dest)
	is_activating = TRUE
	to_chat(initiator, "<b>The portal hums with arcane energy as you assemble at the threshold...</b>")
	playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)

	if(!do_after(initiator, 3 SECONDS, target = src, needhand = FALSE))
		is_activating = FALSE
		to_chat(initiator, span_warning("The portal's light dims as the channelling is broken."))
		return

	var/list/travelers = list()
	if(initiator && !QDELETED(initiator) && (initiator in GLOB.expedition_party))
		travelers |= initiator

	for(var/mob/living/carbon/human/member in GLOB.expedition_party)
		if(QDELETED(member) || member.stat == DEAD)
			continue
		if(member.z == src.z && get_dist(member, src) <= 5)
			travelers |= member
		else
			to_chat(member, span_userdanger("Your vanguard is traversing the portal without you!"))

	if(!length(travelers))
		is_activating = FALSE
		return

	for(var/mob/living/carbon/human/traveler in travelers)
		if(!QDELETED(traveler))
			playsound(traveler, 'sound/misc/portal_enter.ogg', 100, TRUE)
			movable_travel_z_level(traveler, get_turf(dest))
			to_chat(traveler, "<h3 style='color: #4da6ff;'>You step through the rift into Depth [dest.stage_number]...</h3>")

	is_activating = FALSE


/obj/structure/expedition_gate/departure
	name = "borderlands passage"
	desc = "A swirling spatial tear leading to uncharted lands."
	color = "#4da6ff"
	stage_number = 0
	invisibility = INVISIBILITY_OBSERVER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/expedition_gate/departure/Initialize(mapload)
	. = ..()
	GLOB.expedition_departure_gates += src
	if(GLOB.expedition_status != EXPEDITION_ACTIVE)
		invisibility = INVISIBILITY_OBSERVER
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/expedition_gate/departure/Destroy()
	GLOB.expedition_departure_gates -= src
	return ..()

/obj/structure/expedition_gate/departure/proc/reveal_portal()
	invisibility = 0
	mouse_opacity = initial(mouse_opacity)
	playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)
	visible_message("<b>The borderlands passage rips open in a flare of arcane light!</b>")

/obj/structure/expedition_gate/departure/proc/hide_portal()
	invisibility = INVISIBILITY_OBSERVER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT


/obj/structure/expedition_gate/return_home
	name = "triumphant gateway"
	desc = "A radiant, golden breach in reality humming with homeward magic. It demands the entire surviving vanguard assemble."
	color = "#fcff5e"
	stage_number = 99

/obj/structure/expedition_gate/return_home/attempt_travel(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(get_dist(src, H) > 1)
		return

	if(!HAS_TRAIT(H, TRAIT_EXPEDITION_MEMBER))
		to_chat(H, span_warning("Only the victorious crusaders may claim the passage home."))
		return

	if(is_activating)
		to_chat(H, span_warning("The triumphant passage is already opening! Stand fast!"))
		return

	var/list/surviving_members = list()
	var/list/assembled_members = list()

	for(var/mob/living/carbon/human/member in GLOB.expedition_party)
		if(QDELETED(member) || member.stat == DEAD)
			continue
		surviving_members += member
		if(member.z == src.z && get_dist(member, src) <= 5)
			assembled_members += member

	if(length(assembled_members) < length(surviving_members))
		to_chat(H, span_userdanger("Not all surviving champions are assembled! Only [length(assembled_members)] of [length(surviving_members)] stand ready at the threshold."))
		playsound(src, 'sound/misc/machineno.ogg', 50, FALSE)
		return

	INVOKE_ASYNC(src, PROC_REF(evacuate_party), H, assembled_members)

/obj/structure/expedition_gate/return_home/proc/evacuate_party(mob/living/carbon/human/initiator, list/assembled_members)
	is_activating = TRUE
	visible_message(span_boldnotice("The triumphant passage blazes with blinding golden light! Channelling homeward rift..."))
	playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)

	if(!do_after(initiator, 3 SECONDS, target = src, needhand = FALSE))
		is_activating = FALSE
		visible_message(span_warning("The homeward light fades as the channelling is broken."))
		return

	var/turf/home_turf = null
	var/obj/structure/expedition_gate/departure/dep = null

	if(length(GLOB.expedition_departure_gates))
		dep = GLOB.expedition_departure_gates[1]

	if(dep)
		home_turf = get_step(dep, dep.dir) || dep.loc
	else if(GLOB.king_throne)
		var/obj/structure/roguethrone/throne = GLOB.king_throne
		home_turf = get_step(throne, throne.dir)

	if(!home_turf)
		is_activating = FALSE
		to_chat(initiator, span_danger("The passage cannot find the way back to the realm!"))
		return

	for(var/mob/living/carbon/human/traveler in assembled_members)
		if(!QDELETED(traveler))
			playsound(traveler, 'sound/misc/bell.ogg', 100, FALSE)
			movable_travel_z_level(traveler, home_turf)
			to_chat(traveler, "<h2 style='color: gold;'>You have returned from the depths in glory and victory!</h2>")

	complete_expedition(success = TRUE)

	if(dep && !QDELETED(dep))
		playsound(dep, 'sound/misc/portal_enter.ogg', 100, TRUE)
		dep.visible_message("<b>With a final groan of shattered space, the borderlands passage collapses into nothingness!</b>")
		qdel(dep)

	qdel(src)


/obj/structure/expedition_marker/entry
	name = "expedition arrival point"
	desc = "Arrival marker for the royal vanguard."
	icon = 'icons/effects/dungeon_helper.dmi'
	icon_state = "helper"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	density = FALSE
	var/stage_number = 1

/obj/structure/expedition_marker/entry/Initialize(mapload)
	. = ..()
	GLOB.expedition_level_entries["[src.stage_number]"] = src

/obj/structure/expedition_marker/entry/Destroy()
	GLOB.expedition_level_entries -= "[src.stage_number]"
	return ..()

/obj/structure/expedition_gate/level_1_exit
	name = "descending rift"
	stage_number = 1

/obj/structure/expedition_gate/level_2_exit
	name = "abyssal threshold"
	color = "#ff0d00"
	stage_number = 2

/obj/structure/expedition_gate/level_3_exit
	name = "abyssal threshold"
	color = "#ff0d00"
	stage_number = 3

/obj/structure/expedition_marker/entry/level_1
	stage_number = 1

/obj/structure/expedition_marker/entry/level_2
	stage_number = 2

/obj/structure/expedition_marker/entry/level_3
	stage_number = 3

/obj/structure/expedition_marker/entry/level_4
	stage_number = 4

/obj/structure/expedition_marker/entry/boss_chamber
	stage_number = 4
