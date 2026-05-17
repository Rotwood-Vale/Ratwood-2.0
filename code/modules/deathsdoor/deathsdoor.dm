GLOBAL_LIST_INIT(deaths_door_entries,list())
GLOBAL_VAR(deaths_door_exit)//turf at necra's shrine on each map

/proc/get_deathsdoor_companion(mob/living/user)
	if(!user)
		return null
	for(var/mob/living/M in get_turf(user))
		if(M != user && M.buckled == user)
			return M
	if(istype(user.pulling, /mob/living) && user.grab_state >= GRAB_PASSIVE)
		var/mob/living/pulled = user.pulling
		if(pulled.pulledby == user)
			return pulled
	return null

/proc/apply_deathsdoor_holy_fire(mob/living/target)
	if(!target)
		return
	if(!target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(target, span_danger("The Undermaiden's holy fire sears your body!"))
	target.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
	target.ignite_mob()

/proc/reject_deathsdoor_body(mob/living/user, mob/living/target, source_name)
	if(!user || !target)
		return
	new /obj/effect/temp_visual/explosion(get_turf(target))
	playsound(get_turf(target), 'sound/misc/explode/explosion.ogg', 100, TRUE, -1)
	user.visible_message(span_warning("[user] is rejected by [source_name] as [user.p_they()] tries to force [target] through it."))
	if(target.mob_biotypes & MOB_UNDEAD)
		apply_deathsdoor_holy_fire(target)

/proc/is_excluded_aalloy_projectile(obj/item/I)
	if(!I)
		return FALSE
	if(istype(I, /obj/item/quiver) || istype(I, /obj/item/ammo_casing))
		return TRUE
	var/type_text = lowertext("[I.type]")
	if(findtext(type_text, "arrow") || findtext(type_text, "bolt") || findtext(type_text, "javelin"))
		return TRUE
	return FALSE

/proc/is_aalloy_portal_offering(obj/item/I)
	if(!I)
		return FALSE
	var/type_text = lowertext("[I.type]")
	if(!findtext(type_text, "aalloy"))
		return FALSE
	if(is_excluded_aalloy_projectile(I))
		return FALSE
	if(istype(I, /obj/item/rogueweapon))
		return TRUE
	if(istype(I, /obj/item/clothing))
		return TRUE
	return FALSE

/proc/ash_carried_tolls_on_exit(mob/living/target)
	if(!target)
		return
	var/turf/current_turf = get_turf(target)
	var/ashed_any = FALSE
	for(var/obj/item/thetoll/toll_item in target.GetAllContents(/obj/item/thetoll))
		if(QDELETED(toll_item))
			continue
		qdel(toll_item)
		ashed_any = TRUE
	if(ashed_any)
		ensure_underworld_toll_present()
		if(current_turf)
			new /obj/item/ash(current_turf)
		to_chat(target, span_warning("Necra's toll crumbles into ash as you leave her realm."))

/proc/get_deathsdoor_entry_turf()
	if(!length(GLOB.deaths_door_entries))
		return null
	var/turf/entry = pick(GLOB.deaths_door_entries)
	if(!entry)
		return null
	for(var/turf/open/open_turf in range(1, entry))
		if(!open_turf.density)
			return open_turf
	return entry

/obj/structure/deaths_door_shrine
	name = "A Way Out"
	desc = "The eerie calm comes to an end, one way or another."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "doorway"
	opacity = FALSE
	density = TRUE
	max_integrity = 0

/obj/structure/deaths_door_shrine/attack_hand(mob/living/user)
	to_chat(user, span_notice("You reach for the glowing portal..."))
	var/mob/living/companion = get_deathsdoor_companion(user)
	if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		// Necra's chosen move through her realm's portal without hesitation
		if(user.mob_biotypes & MOB_UNDEAD)
			user.visible_message(span_danger("The Undermaiden churns the undead!"))
			explosion(get_turf(user), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			return
		exit_deaths_door(user, user)
		if(companion && !QDELETED(companion))
			exit_deaths_door(user, companion)
		return
	if(!do_after(user, 2 SECONDS, src))
		return

	if(user.mob_biotypes & MOB_UNDEAD)
		user.visible_message(span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(user), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	exit_deaths_door(user, user)
	if(companion && !QDELETED(companion))
		exit_deaths_door(user, companion)

/obj/structure/deaths_door_shrine/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O, /mob/living))
		return
	var/mob/living/target = O
	var/is_necran = HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)

	if(target.stat == DEAD && !is_necran)
		reject_deathsdoor_body(user, target, "A Way Out")
		return

	if(target.mob_biotypes & MOB_UNDEAD)
		target.visible_message(span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	if(user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(target))
		return
	if(!do_after_mob(user, target, 1 SECONDS))
		return

	exit_deaths_door(user, target)

	user.visible_message(
		span_notice("[user] guides [target] through Necra's shrine.")
	)

/obj/structure/deaths_door_shrine/proc/exit_deaths_door(mob/living/user, mob/living/target = null)
	var/list/dests = list()
	var/turf/default_exit = user.get_adventurer_latejoin_turf()
	if(default_exit)
		dests[default_exit] = "A Strange Place"

	// Acolytes can choose exits
	if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		var/list/sight_dests = get_necras_sight_entries(user)
		if(length(sight_dests))
			for(var/turf/T in sight_dests)
				dests[T] = sight_dests[T]

	// Always allow shrine exit
	if(GLOB.deaths_door_exit)
		dests[GLOB.deaths_door_exit] = "Necra's Shrine"
	// Warn Necra followers without sight
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		if(user.patron == /datum/patron/divine/necra)
			to_chat(user, span_warning("Necra's paths blur before you. You lack the sight to choose."))

	if(!length(dests))
		message_admins("Death's Door Shrine: No exit destinations! Inform a mapper!")	//You're missing /obj/effect/landmark/deaths_door/exit from the map
		return

	var/turf/T = prompt_deaths_door_exit(user, dests)
	if(!T)
		return
	ash_carried_tolls_on_exit(target)
	target.forceMove(T)
	playsound(get_turf(target), 'sound/misc/portalenter.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	target.visible_message(span_danger("The air warps and rapidly chills as [user] stumbles out of a deathly calm realm."))

/proc/prompt_deaths_door_exit(mob/living/user, list/dests)
	if(!length(dests))
		return null

	if(length(dests) == 1)
		return dests[1]

	// Build display list: label -> turf
	var/list/named = list()
	for(var/turf/T as anything in dests)
		var/label = dests[T]
		if(!label)
			label = "[get_area(T)]"
		named[label] = T

	var/choice = input(user, "Choose a path from Death's Edge:", "Necra's Way") \
		as null|anything in named
	if(!choice)
		return null

	return named[choice]

/proc/get_necras_sight_entries(mob/living/user)
	var/list/targets = list()
	var/obj/effect/proc_holder/spell/invoked/necras_sight/spell = \
		locate(/obj/effect/proc_holder/spell/invoked/necras_sight) in user.mind?.spell_list
	if(!spell)
		return targets

	for(var/obj/O in spell.marked_objects.Copy())
		// prune deleted objects
		if(!O || QDELETED(O))
			spell.marked_objects -= O
			continue

		if(!isturf(O.loc))
			spell.marked_objects -= O
			continue
		var/turf/T = O.loc
		var/label = spell.marked_objects[O]

		// Fallback safety
		if(!label || !length(label))
			label = O.name

		targets[T] = label

	return targets

/obj/structure/deaths_door_portal
	name = "death's door"
	icon = 'icons/mob/actions/necramiracles.dmi'
	icon_state = "necraportal"
	anchored = TRUE
	density = FALSE
	var/turf/destination

/obj/structure/deaths_door_portal/Initialize(mapload, mob/living/_caster)
	. = ..()
	if(!length(GLOB.deaths_door_entries))
		message_admins("Death's Door Portal: No entry destinations! Inform a mapper!")	//You're missing any landmarks that are subtypes of /obj/effect/landmark/deaths_door/entry in deaths precipice
		return

	destination = get_deathsdoor_entry_turf()
	addtimer(CALLBACK(src, PROC_REF(expire)), 30 SECONDS)

/obj/structure/deaths_door_portal/proc/expire()
	if(QDELETED(src))
		return
	visible_message(span_notice("The glowing portal closes shut!"))
	playsound(get_turf(src), 'sound/misc/deadbell.ogg', 50, TRUE, -2)
	qdel(src)

/obj/structure/deaths_door_portal/attack_hand(mob/living/user)
	playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	to_chat(user, span_notice("You reach for the glowing portal..."))
	var/mob/living/passenger = get_deathsdoor_companion(user)
	if(!do_after(user, 2 SECONDS, src))
		return
	enter_portal(user)
	// Bring any fireman-carried or aggressively grabbed companion through with the Necran
	if(passenger && !QDELETED(passenger))
		// NPC corpses are left behind; only living mobs or player bodies cross
		if(passenger.stat == DEAD && !passenger.mind?.key)
			passenger.visible_message(span_warning("[passenger] slips from [user]'s grasp at the threshold, denying its entry."))
		else
			enter_portal(passenger)

/obj/structure/deaths_door_portal/MouseDrop_T(atom/movable/O, mob/living/user)
	if(user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return

	// Necrans can drag burial shrouds into the portal
	if(istype(O, /obj/structure/closet/burial_shroud))
		if(!HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
			to_chat(user, span_warning("You cannot draw this through the portal."))
			return
		playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
		if(!do_after(user, 2 SECONDS, src))
			return
		if(destination && !QDELETED(O))
			O.forceMove(destination)
			user.visible_message(span_warning("[user] guides \the [O] through Death's Door!"))
		return

	if(!istype(O, /mob/living))
		return
	var/mob/living/M = O

	var/is_necran = HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)
	var/is_undead = (M.mob_biotypes & MOB_UNDEAD)
	var/is_dead = (istype(M, /mob/living/carbon) && M.stat == DEAD)
	var/has_player = (M.mind?.key != null)

	if(is_dead && !is_necran)
		reject_deathsdoor_body(user, M, "Death's Door")
		return

	// Non-Necrans explode undead they try to drag in
	if(is_undead && !is_necran)
		to_chat(user, span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(M), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	playsound(get_turf(src), 'sound/misc/carriage2.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	if(!do_after_mob(user, M, 2 SECONDS))
		return

	// Player corpses with ckey pass through freely; living undead still explode for non-Necrans (already handled above)
	if(is_undead && !is_necran)
		to_chat(user, span_danger("The Undermaiden churns the undead!"))
		explosion(get_turf(M), light_impact_range = 1, flame_range = 1, smoke = FALSE)
		return

	enter_portal(M)

	// Necrans who guide a dead body (not a player soul) through receive 5 tokens of gratitude
	if(is_necran && is_dead && !has_player && !M.burialrited)
		var/obj/item/roguecoin/necra_token/body_reward = new(get_turf(user), 5)
		body_reward.pixel_x = rand(-6, 6)
		body_reward.pixel_y = rand(-6, 6)

	user.visible_message(
		span_warning("[user] drags [M] into Death's Door!")
	)

/obj/structure/deaths_door_portal/proc/enter_portal(mob/living/target)
	if(!destination)
		return
	// NPC corpses (no mind.key) crumble to ash; player bodies pass through to the Carriageman
	if(target.stat == DEAD && !target.mind?.key)
		target.visible_message(span_warning("[target] crumbles into ash as it crosses the threshold!"))
		target.dust(just_ash = TRUE)
		return
	playsound(get_turf(src), 'sound/misc/portalenter.ogg', 50, TRUE, -2, ignore_walls = TRUE)
	var/turf/spawn_turf = destination
	var/is_necran = HAS_TRAIT(target, TRAIT_SOUL_EXAMINE)
	
	// Non-Necran players spawn at random underworld locations
	if(target.mind?.key && !is_necran)
		var/list/valid_spawns = list()
		for(var/obj/effect/landmark/underworld/L in GLOB.landmarks_list)
			valid_spawns += L
		if(length(valid_spawns))
			var/obj/effect/landmark/underworld/spawn_landmark = pick(valid_spawns)
			spawn_turf = get_turf(spawn_landmark)
			// Apply underworld mood penalty for non-necrans
			target.apply_status_effect(/datum/status_effect/debuff/underworld_malaise)
			to_chat(target, span_warning("The Undermaiden's realm is cold and unwelcoming. You feel dread settle upon your shoulders, with your mind and soul waning."))
	// Necra's chosen appear near the Carriageman
	else if(is_necran || target.mind?.key)
		var/obj/structure/underworld/carriageman/CM = locate(/obj/structure/underworld/carriageman) in world
		if(CM)
			var/turf/CM_turf = get_turf(CM)
			if(CM_turf.z == destination.z)
				for(var/turf/T in range(2, CM))
					if(T == CM_turf)
						continue
					if(T.density)
						continue
					var/blocked = FALSE
					for(var/atom/movable/AM in T)
						if(AM.density)
							blocked = TRUE
							break
					if(!blocked)
						spawn_turf = T
						break
	target.forceMove(spawn_turf)
	// Apply holy fire to undead players (but not plain dead ones without the undead flag)
	if(target.mind?.key && (target.mob_biotypes & MOB_UNDEAD) && target.stat != DEAD)
		if(!target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
			to_chat(target, span_danger("The Undermaiden's holy fire consumes your unholy body!"))
		apply_deathsdoor_holy_fire(target)

/// Bones, skulls, severed limbs, and whole bodies fed to the portal yield tokens of gratitude.
/obj/structure/deaths_door_portal/attackby(obj/item/I, mob/living/user, params)
	if(!HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		return ..()
	// Bone bundles — reward scales with number of bones in the bundle
	if(istype(I, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bundle = I
		var/bundle_count = bundle.amount
		to_chat(user, span_notice("The portal hungrily accepts the bundle of [bundle_count] bones."))
		var/obj/item/roguecoin/necra_token/bundle_reward = new(get_turf(user), bundle_count)
		bundle_reward.pixel_x = rand(-6, 6)
		bundle_reward.pixel_y = rand(-6, 6)
		qdel(I)
		return
	// Single bones
	if(istype(I, /obj/item/natural/bone))
		to_chat(user, span_notice("The portal hungrily accepts the offering."))
		var/obj/item/roguecoin/necra_token/coin = new(get_turf(user))
		coin.pixel_x = rand(-6, 6)
		coin.pixel_y = rand(-6, 6)
		qdel(I)
		return
	// Severed heads — excluding spirit bodyparts and heads still bound to a living player
	if(istype(I, /obj/item/bodypart/head) && !istype(I, /obj/item/bodypart/head/spirit))
		var/obj/item/bodypart/head/H = I
		if(H.brainmob?.mind?.key)
			to_chat(user, span_warning("The portal recoils — this soul has not yet departed."))
			return
		to_chat(user, span_notice("The portal consumes the fallen's head in offering."))
		var/obj/item/roguecoin/necra_token/head_coin = new(get_turf(user))
		head_coin.pixel_x = rand(-6, 6)
		head_coin.pixel_y = rand(-6, 6)
		qdel(I)
		return
	// Other bodyparts (limbs) — 1 token each
	if(istype(I, /obj/item/bodypart) && !istype(I, /obj/item/bodypart/head))
		to_chat(user, span_notice("The portal accepts the severed remains."))
		var/obj/item/roguecoin/necra_token/limb_coin = new(get_turf(user))
		limb_coin.pixel_x = rand(-6, 6)
		limb_coin.pixel_y = rand(-6, 6)
		qdel(I)
		return
	// Skulls and loose organs offered to the portal yield psilen
	if(istype(I, /obj/item/skull) || istype(I, /obj/item/organ))
		to_chat(user, span_notice("The portal consumes [I] in offering."))
		var/obj/item/roguecoin/aalloy/psilen_coin = new(get_turf(user))
		psilen_coin.pixel_x = rand(-6, 6)
		psilen_coin.pixel_y = rand(-6, 6)
		qdel(I)
		return
	// Aalloy armor and weapons (excluding arrows/bolts/javelins) are accepted for 1 token each
	if(is_aalloy_portal_offering(I))
		to_chat(user, span_notice("The portal accepts the decrepit offering."))
		var/obj/item/roguecoin/necra_token/aalloy_reward = new(get_turf(user))
		aalloy_reward.pixel_x = rand(-6, 6)
		aalloy_reward.pixel_y = rand(-6, 6)
		qdel(I)
		return
	// A sack or bag filled with the accepted offerings can be dumped in all at once
	if(istype(I, /obj/item/storage))
		var/obj/item/storage/sack = I
		var/total_tokens = 0
		var/total_psilen = 0
		var/list/sack_contents = sack.contents.Copy()
		for(var/obj/item/sack_item in sack_contents)
			if(istype(sack_item, /obj/item/natural/bundle/bone))
				var/obj/item/natural/bundle/bone/bundle = sack_item
				total_tokens += bundle.amount
				qdel(sack_item)
			else if(istype(sack_item, /obj/item/natural/bone) || istype(sack_item, /obj/item/bodypart))
				total_tokens++
				qdel(sack_item)
			else if(istype(sack_item, /obj/item/skull) || istype(sack_item, /obj/item/organ))
				total_psilen++
				qdel(sack_item)
			else if(is_aalloy_portal_offering(sack_item))
				total_tokens++
				qdel(sack_item)
		if(total_tokens > 0)
			var/obj/item/roguecoin/necra_token/sack_tokens = new(get_turf(user), total_tokens)
			sack_tokens.pixel_x = rand(-6, 6)
			sack_tokens.pixel_y = rand(-6, 6)
		if(total_psilen > 0)
			var/obj/item/roguecoin/aalloy/sack_psilen = new(get_turf(user), total_psilen)
			sack_psilen.pixel_x = rand(-6, 6)
			sack_psilen.pixel_y = rand(-6, 6)
		if(total_tokens > 0 || total_psilen > 0)
			to_chat(user, span_notice("The portal greedily accepts the offerings from [I]."))
			return
	return ..()

GLOBAL_VAR_INIT(underworld_strands, 0)
/obj/effect/landmark/underworldstrands
	var/spawn_timer

/obj/effect/landmark/underworldstrands/Initialize(mapload)
	. = ..()
	start_timer()

/obj/effect/landmark/underworldstrands/Destroy()
	if(spawn_timer)
		deltimer(spawn_timer)
	return ..()

/obj/effect/landmark/underworldstrands/proc/start_timer()
	if(spawn_timer)
		deltimer(spawn_timer)

	var/delay = rand(15 MINUTES, 30 MINUTES)
	spawn_timer = addtimer(
		CALLBACK(src, PROC_REF(try_spawn)),
		delay,
		TIMER_STOPPABLE
	)
/obj/effect/landmark/underworldstrands/proc/try_spawn()
	spawn_timer = null
	if(GLOB.underworld_strands >= 4)
		start_timer()
		return
	var/turf/T = get_turf(src)
	if(!T)
		start_timer()
		return

	// If lux already present, reset timer
	for(var/obj/item/soulthread/deathsdoor/L in T)
		start_timer()
		return

	// Otherwise spawn new lux
	new /obj/item/soulthread/deathsdoor(T)

	start_timer()
/obj/item/soulthread/deathsdoor
	name = "shimmering lux-thread"
	desc = "Eerie glowing thread, cometh from the grave"
	var/should_track = TRUE

/obj/item/soulthread/deathsdoor/Initialize(mapload)
	. = ..()
	if(should_track)
		GLOB.underworld_strands += 1

/obj/item/soulthread/deathsdoor/Destroy()
	if(should_track)
		GLOB.underworld_strands -= 1
	return ..()

/obj/item/soulthread/deathsdoor/pickup(mob/user)
	..()
	if(should_track)
		GLOB.underworld_strands -= 1

/obj/item/soulthread/deathsdoor/dropped(mob/user)
	..()
	if(should_track)
		GLOB.underworld_strands += 1

/mob/living/proc/extract_from_deaths_edge()//for total exhaustion in death's precipice
	// Already unconscious? Don't loop
	if(stat >= UNCONSCIOUS)
		return
	src.apply_status_effect(/datum/status_effect/debuff/devitalised)
	src.SetSleeping(20 SECONDS)
	var/turf/T = get_adventurer_latejoin_turf()
	if(!T)
		return

	visible_message(
		span_danger("[src] collapses as Necra's grasp tightens."),
		span_cultboldtalic("The last thing you see before you collapse is a spirit tugging strands of lux straight out of your chest.")
	)

	src.forceMove(T)

/// Returns a random adventurer latejoin turf for safe extraction and shrine fallback exits.
/mob/living/proc/get_adventurer_latejoin_turf()
	var/list/candidates = list()

	for(var/obj/effect/landmark/start/adventurerlate/L in GLOB.landmarks_list)
		if(L.loc && isturf(L.loc))
			candidates += L.loc

	if(!length(candidates))
		return null

	return pick(candidates)

/obj/structure/waywardspirit
	name = "A Wayward Soul"
	desc = "Lost in the deathly tranquility, never to return."
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "hollow"
	opacity = FALSE
	density = FALSE
	max_integrity = 0
