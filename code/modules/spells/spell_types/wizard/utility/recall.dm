//Wizard teleportation. Intended to be locked to Magos / Lich. Don't hand this out.
//Pulled from SR, or wherever they got it. Cheers.
/obj/effect/proc_holder/spell/self/recall
	name = "Recall"
	desc = "Memorize your current location, allowing you to return to it after a delay."
	school = "transmutation"
	charge_type = "recharge"
	recharge_time = 3 MINUTES
	clothes_req = FALSE
	cost = 4
	spell_tier = 4//Why do you think?
	cooldown_min = 3 MINUTES
	associated_skill = /datum/skill/magic/arcane
	xp_gain = TRUE
	invocations = list("Vale, dico tibi.")
	invocation_type = "whisper"
	action_icon_state = "spell0"

	var/turf/marked_location = null
	var/recall_delay = 15 SECONDS

/obj/effect/proc_holder/spell/self/recall/cast(mob/user = usr)
	if(!istype(user, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = user

	// First cast - mark the location
	if(!marked_location)
		var/turf/T = get_turf(H)
		marked_location = T
		to_chat(H, span_notice("You attune yourself to this location. Future casts will return you here."))
		start_recharge()
		revert_cast()
		return TRUE

	// Subsequent casts - begin channeling
	H.visible_message(span_warning("[H] closes [H.p_their()] eyes and begins to focus intently..."))
	H.apply_status_effect(/datum/status_effect/buff/recalling)
	if(do_after(H, recall_delay, target = H, progress = TRUE))
		// Get any grabbed mobs
		var/list/to_teleport = list(H)
		if(H.pulling && isliving(H.pulling))
			to_teleport += H.pulling

		// Teleport caster and grabbed mob if any
		for(var/mob/living/L in to_teleport)
			do_teleport(L, marked_location, no_effects = FALSE, channel = TELEPORT_CHANNEL_MAGIC)

		H.visible_message(span_warning("[H] vanishes in a swirl of energy!"))
		playsound(H, 'sound/magic/unmagnet.ogg', 50, TRUE)

		// Visual effects at both locations
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(3, marked_location)
		smoke.start()
		H.remove_status_effect(/datum/status_effect/buff/recalling)
		start_recharge()
	else
		H.remove_status_effect(/datum/status_effect/buff/recalling)
		to_chat(H, span_warning("Your concentration was broken!"))
		start_recharge()
		revert_cast()

//Buff. Could this be elsewhere? Sure. I suppose.
/atom/movable/screen/alert/status_effect/buff/recalling
	name = "Recalling"
	desc = "I'm in the middle of casting Recall. I need to stand still!"
	icon_state = "buff"

/datum/status_effect/buff/recalling
	id = "recalling"
	alert_type = /atom/movable/screen/alert/status_effect/buff/recalling
	var/effect_color
	var/datum/stressevent/stress_to_apply
	var/pulse = 0
	var/ticks_to_apply = 5

/datum/status_effect/buff/recalling/tick()
	var/obj/effect/temp_visual/recall_smoke/M = new /obj/effect/temp_visual/recall_smoke(get_turf(owner))
	M.color = effect_color
	pulse += 1

//Again. Effects for recall. Could probably be elsewhere. Cleaner to keep here, IMO.
/obj/effect/temp_visual/recall_smoke
	name = "recall smoke"
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = "steam_cloud_1"
	duration = 20
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/recall_smoke/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-15, 15)
	pixel_y = rand(-15, 15)
