#define SEX_ZONE_NULL				0
#define SEX_ZONE_GROIN				(1<<0)
#define SEX_ZONE_GROIN_GRAB			(1<<1)
#define SEX_ZONE_L_FOOT				(1<<2)
#define SEX_ZONE_R_FOOT				(1<<3)
#define SEX_ZONE_MOUTH				(1<<4)
#define SEX_ZONE_CHEST				(1<<5)
#define SEX_ZONE_CHEST_GRAB			(1<<6)

/datum/sex_controller
	/// The user and the owner of the controller
	var/mob/living/carbon/human/user
	/// Target of our actions, can be ourself
	var/mob/living/carbon/human/target
	/// Who is targeting us
	// Disabled as it'd require properly stopping actions when the popup is closed.
	// Different behavior which might be invasive.
	//var/receiving = list()
	/// Whether the user desires to stop his current action
	var/desire_stop = FALSE
	/// What is the current performed action
	var/current_action = null
	/// Enum of desired speed
	var/speed = SEX_SPEED_MID
	/// Enum of desired force
	var/force = SEX_FORCE_MID
	/// Our arousal
	var/arousal = 0
	///Makes genital arousal automatic by default
	var/manual_arousal = SEX_MANUAL_AROUSAL_DEFAULT
	/// Our charge gauge
	var/charge = SEX_MAX_CHARGE
	/// Whether we want to screw until finished, or non stop
	var/do_until_finished = TRUE
	/// The bed (if) we're occupying, update on starting an action
	var/obj/structure/bed/rogue/bed = null
	var/target_on_bed = FALSE
	/// The table/pillory (if) target is lying/latching on, update on starting an action
	var/obj/structure/table_or_pillory = null
	/// The bush (if) we're on top of, update on starting an action
	var/obj/structure/flora/roguegrass/grassy_knoll = null
	/// If this person has a collar that rings on
	var/collar_bell_user = FALSE
	var/collar_bell_target = FALSE
	var/list/collar_sounds = SFX_COLLARJINGLE
	/// Arousal won't change if active.
	var/arousal_frozen = FALSE
	var/last_arousal_increase_time = 0
	var/last_ejaculation_time = 0
	var/last_moan = 0
	var/last_pain = 0
	var/aphrodisiac = 1 //1 by default, acts as a multiplier on arousal gain. If this is different than 1, set/freeze arousal is disabled.
	/// Which zones we are using in the current action.
	var/using_zones = list()
	/// Cache body parts used for accessibility check
	var/access_zone_bitfield = SEX_ZONE_NULL
	/// Menu based variables
	var/action_category = SEX_CATEGORY_MISC
	/// Show progress bar
	var/show_progress = 1
	/// When TRUE, try_do_moan does nothing (used for actions that can be done subtly)
	var/suppress_moan = FALSE
	/// Allow players to decide if they want to subtly do this action or not (only for actions that can be done subtly)
	var/do_subtle_action = FALSE
	/// Knot based variables
	var/do_knot_action = FALSE
	var/knotted_status = KNOTTED_NULL // knotted state and used to prevent multiple knottings when we do not handle that case
	var/knotted_part = SEX_PART_NULL // which orifice was knotted (bitflag)
	var/knotted_part_partner = SEX_PART_NULL // which orifice was knotted on partner (bitflag)
	var/tugging_knot = FALSE
	var/tugging_knot_check = 0
	var/tugging_knot_blocked = FALSE
	var/mob/living/carbon/knotted_owner = null // whom has the knot
	var/mob/living/carbon/knotted_recipient = null // whom took the knot
	/// Allow crotch to be exposed and bypass clothes check
	var/bottom_exposed = FALSE

/datum/sex_controller/New(mob/living/carbon/human/owner)
	user = owner

/datum/sex_controller/Destroy()
	//remove_from_target_receiving()
	user = null
	target = null
	bed = null
	table_or_pillory = null
	grassy_knoll = null
	collar_bell_user = FALSE
	collar_bell_target = FALSE
	if(knotted_status)
		knot_exit()
	//receiving = list()
	. = ..()

/datum/sex_controller/proc/do_thrust_animate(atom/movable/target, pixels = 4, time = 2.7)
	var/oldx = user.pixel_x
	var/oldy = user.pixel_y
	var/target_x = oldx
	var/target_y = oldy
	var/dir = get_dir(user, target)
	if(user.loc == target.loc)
		dir = user.dir
	if(speed > SEX_SPEED_MID && time > 1)
		time -= 0.25
	if(force < SEX_FORCE_MID && pixels > 2)
		pixels -= 1
	switch(dir)
		if(NORTH)
			target_y += pixels
		if(SOUTH)
			target_y -= pixels
		if(WEST)
			target_x -= pixels
		if(EAST)
			target_x += pixels

	animate(user, pixel_x = target_x, pixel_y = target_y, time = time)
	animate(pixel_x = oldx, pixel_y = oldy, time = time)
	if(bed && force > SEX_FORCE_MID)
		if(!istype(bed) || QDELETED(bed))
			bed = null
			target_on_bed = FALSE
			return
		oldy = bed.pixel_y
		target_y = oldy-1
		time /= 2
		animate(bed, pixel_y = target_y, time = time)
		animate(pixel_y = oldy, time = time)
		if(target_on_bed && target)
			oldy = target.pixel_y
			target_y = oldy-1
			animate(target, pixel_y = target_y, time = time)
			animate(pixel_y = oldy, time = time)
		bed.damage_bed(force > SEX_FORCE_HIGH ? 1.0 : 0.5)
	else if(table_or_pillory && target && force > SEX_FORCE_MID)
		if(!istype(table_or_pillory) || QDELETED(table_or_pillory))
			table_or_pillory = null
			return
		oldy = table_or_pillory.pixel_y
		target_y = oldy-1
		time /= 2
		animate(table_or_pillory, pixel_y = target_y, time = time)
		animate(pixel_y = oldy, time = time)
		oldy = target.pixel_y
		target_y = oldy-1
		animate(target, pixel_y = target_y, time = time)
		animate(pixel_y = oldy, time = time)
		playsound(table_or_pillory, pick(list('sound/misc/mat/table (1).ogg','sound/misc/mat/table (2).ogg','sound/misc/mat/table (3).ogg','sound/misc/mat/table (4).ogg')), 30, TRUE, ignore_walls = FALSE)
	else if(grassy_knoll)
		if(!istype(grassy_knoll) || QDELETED(grassy_knoll))
			grassy_knoll = null
			return
		SEND_SIGNAL(grassy_knoll, COMSIG_MOVABLE_CROSSED, user)
	
	if((collar_bell_user || collar_bell_target) && (force > SEX_FORCE_MID))
		playsound(collar_bell_target && target ? target : user, collar_sounds, 50, TRUE, ignore_walls = FALSE)

/datum/sex_controller/proc/is_spent()
	if(charge < CHARGE_FOR_CLIMAX)
		return TRUE
	return FALSE

// any new sex commands that target new locations, will need to be added here, and given a unique bitflag define
/datum/sex_controller/proc/update_all_accessible_body_zones()
	access_zone_bitfield = SEX_ZONE_NULL
	if(bottom_exposed || get_location_accessible(user, BODY_ZONE_PRECISE_GROIN, grabs = FALSE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_GROIN
	if(bottom_exposed || get_location_accessible(user, BODY_ZONE_PRECISE_GROIN, grabs = TRUE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_GROIN_GRAB
	if(get_location_accessible(user, BODY_ZONE_PRECISE_L_FOOT, grabs = FALSE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_L_FOOT
	if(get_location_accessible(user, BODY_ZONE_PRECISE_R_FOOT, grabs = FALSE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_R_FOOT
	if(get_location_accessible(user, BODY_ZONE_PRECISE_MOUTH, grabs = FALSE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_MOUTH
	if(get_location_accessible(user, BODY_ZONE_CHEST, grabs = FALSE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_CHEST
	if(get_location_accessible(user, BODY_ZONE_CHEST, grabs = TRUE, skipundies = TRUE))
		access_zone_bitfield |= SEX_ZONE_CHEST_GRAB

// only check active accessible body zones
/datum/sex_controller/proc/update_current_accessible_body_zones(body_zone, grabs)
	switch(body_zone)
		if(BODY_ZONE_PRECISE_GROIN)
			if(grabs)
				if((access_zone_bitfield&SEX_ZONE_GROIN_GRAB) && !bottom_exposed && !get_location_accessible(user, BODY_ZONE_PRECISE_GROIN, grabs = TRUE, skipundies = TRUE))
					access_zone_bitfield &= ~SEX_ZONE_GROIN_GRAB
			else if((access_zone_bitfield&SEX_ZONE_GROIN) && !bottom_exposed && !get_location_accessible(user, BODY_ZONE_PRECISE_GROIN, grabs = FALSE, skipundies = TRUE))
				access_zone_bitfield &= ~SEX_ZONE_GROIN
		if(BODY_ZONE_PRECISE_L_FOOT)
			if((access_zone_bitfield&SEX_ZONE_L_FOOT) && !get_location_accessible(user, BODY_ZONE_PRECISE_L_FOOT, grabs = FALSE, skipundies = TRUE))
				access_zone_bitfield &= ~SEX_ZONE_L_FOOT
		if(BODY_ZONE_PRECISE_R_FOOT)
			if((access_zone_bitfield&SEX_ZONE_R_FOOT) && !get_location_accessible(user, BODY_ZONE_PRECISE_R_FOOT, grabs = FALSE, skipundies = TRUE))
				access_zone_bitfield &= ~SEX_ZONE_R_FOOT
		if(BODY_ZONE_PRECISE_MOUTH)
			if((access_zone_bitfield&SEX_ZONE_MOUTH) && !get_location_accessible(user, BODY_ZONE_PRECISE_MOUTH, grabs = FALSE, skipundies = TRUE))
				access_zone_bitfield &= ~SEX_ZONE_MOUTH
		if(BODY_ZONE_CHEST)
			if(grabs)
				if((access_zone_bitfield&SEX_ZONE_CHEST_GRAB) && !get_location_accessible(user, BODY_ZONE_CHEST, grabs = TRUE, skipundies = TRUE))
					access_zone_bitfield &= ~SEX_ZONE_CHEST_GRAB
			else if((access_zone_bitfield&SEX_ZONE_CHEST) && !get_location_accessible(user, BODY_ZONE_CHEST, grabs = FALSE, skipundies = TRUE))
				access_zone_bitfield &= ~SEX_ZONE_CHEST
		else
			// hey YOU, add the new targeted zone to SEX_ZONE bitfield, and update update_all_accessible_body_zones()/get_accessible_body_zone()
			CRASH("sex_action: attempt to access non-existent bitfield for var body_zone_bitfield [body_zone]")

/datum/sex_controller/proc/get_accessible_body_zone(body_zone_bitfield, body_zone, grabs)
	switch(body_zone)
		if(BODY_ZONE_PRECISE_GROIN)
			if(grabs)
				return (body_zone_bitfield&SEX_ZONE_GROIN_GRAB) != SEX_ZONE_NULL
			return (body_zone_bitfield&SEX_ZONE_GROIN) != SEX_ZONE_NULL
		if(BODY_ZONE_PRECISE_L_FOOT)
			return (body_zone_bitfield&SEX_ZONE_L_FOOT) != SEX_ZONE_NULL
		if(BODY_ZONE_PRECISE_R_FOOT)
			return (body_zone_bitfield&SEX_ZONE_R_FOOT) != SEX_ZONE_NULL
		if(BODY_ZONE_PRECISE_MOUTH)
			return (body_zone_bitfield&SEX_ZONE_MOUTH) != SEX_ZONE_NULL
		if(BODY_ZONE_CHEST)
			if(grabs)
				return (body_zone_bitfield&SEX_ZONE_CHEST_GRAB) != SEX_ZONE_NULL
			return (body_zone_bitfield&SEX_ZONE_CHEST) != SEX_ZONE_NULL
	// hey YOU, add the new targeted zone to SEX_ZONE bitfield, and update update_all_accessible_body_zones()/update_current_accessible_body_zones()
	CRASH("sex_action: attempt to access non-existent bitfield for var body_zone_bitfield [body_zone]")

/datum/sex_action/proc/check_location_accessible(mob/living/carbon/human/user, mob/living/carbon/human/target, location = BODY_ZONE_CHEST, grabs = FALSE)
	var/obj/item/bodypart/bodypart = target.get_bodypart(location)

	var/self_target = FALSE
	var/datum/sex_controller/user_controller = user.sexcon
	if(user_controller.target == user)
		self_target = TRUE

	var/signalargs = list(src, bodypart, self_target)
	signalargs += args

	var/sigbitflags = SEND_SIGNAL(target, COMSIG_ERP_LOCATION_ACCESSIBLE, signalargs)
	bodypart = signalargs[ERP_BODYPART]

	if(sigbitflags & SIG_CHECK_FAIL)
		return FALSE

	if(!bodypart)
		return FALSE

	if(!(sigbitflags & SKIP_ADJACENCY_CHECK) && !user.sexcon.Adjacent_Or_Closet(target))
		return FALSE

	if(src.check_same_tile && (user != target || self_target) && !(sigbitflags & SKIP_TILE_CHECK))
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (src.aggro_grab_instead_same_tile && user.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		if(!same_tile && !grab_bypass)
			return FALSE

	if(src.require_grab && (user != target || self_target) && !(sigbitflags & SKIP_GRAB_CHECK))
		var/grabstate = user.get_highest_grab_state_on(target)
		if((grabstate == null || grabstate < src.required_grab_state))
			return FALSE

	if(!isnull(user_controller.current_action) && user_controller.current_action == src.type) // action is active, update the currently accessible body zones
		target.sexcon.update_current_accessible_body_zones(location, grabs)
	var/result = user_controller.get_accessible_body_zone(target.sexcon.access_zone_bitfield, location, grabs)
	if(result && user == target && !(bodypart in user_controller.using_zones) && user_controller.current_action == SEX_ACTION(src))
		user_controller.using_zones += location

	return result

/datum/sex_controller/proc/finished_check()
	if(!do_until_finished)
		return FALSE
	if(!just_ejaculated())
		return FALSE
	return TRUE

/datum/sex_controller/proc/adjust_speed(amt)
	speed = clamp(speed + amt, SEX_SPEED_MIN, SEX_SPEED_MAX)

/datum/sex_controller/proc/adjust_force(amt)
	force = clamp(force + amt, SEX_FORCE_MIN, SEX_FORCE_MAX)
/datum/sex_controller/proc/adjust_arousal_manual(amt)
	manual_arousal = clamp(manual_arousal + amt, SEX_MANUAL_AROUSAL_MIN, SEX_MANUAL_AROUSAL_MAX)

/datum/sex_controller/proc/update_pink_screen()
	var/severity = 0
	switch(arousal)
		if(1 to 10)
			severity = 1
		if(10 to 20)
			severity = 2
		if(20 to 30)
			severity = 3
		if(30 to 40)
			severity = 4
		if(40 to 50)
			severity = 5
		if(50 to 60)
			severity = 6
		if(60 to 70)
			severity = 7
		if(70 to 80)
			severity = 8
		if(80 to 90)
			severity = 9
		if(90 to INFINITY)
			severity = 10
	if(severity > 0)
		user.overlay_fullscreen("horny", /atom/movable/screen/fullscreen/love, severity)
	else
		user.clear_fullscreen("horny")

/datum/sex_controller/proc/start(mob/living/carbon/human/new_target)
	if(!ishuman(new_target))
		return
	set_target(new_target)
	show_ui()

// Try to resist orgasm, returns TRUE if we resisted, FALSE if we didn't. ENDVRE. EDGE. WEEP.
/datum/sex_controller/proc/try_resist_orgasm()
	if(!HAS_TRAIT(user, TRAIT_PSYDONIAN_GRIT) || !prob(40))
		return FALSE
	if(user.client.prefs.edging == FALSE)
		return FALSE
	var/resist_msg = pick(
		"[user] trembles and hisses, \"With every broken bone, I swore I lyved... HE hath gifted me the strength to ENDURE!\"",
		"[user] bows [user.p_their()] head and forces the urge back, clinging to faith as the night closes in.",
		"[user] gasps, \"PSYDON yet LYVES and PSYDON yet ENDURES,\" and denies [user.p_them()]self release.",
		"[user] clenches hard and steadies [user.p_their()] breathing, choosing the Saints' discipline over indulgence.",
		"[user] shudders and whispers a penitent prayer, meeting suffering with patience instead of surrender.",
	)
	user.visible_message(span_boldwarning(resist_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
	to_chat(user, span_notice("PSYDON, grant me silence and endurance; I will not yield."))
	set_arousal(60)
	user.emote("groan", forced = TRUE)
	return TRUE

/datum/sex_controller/proc/cum_onto(mob/living/carbon/human/splashed_user = null)
	if(try_resist_orgasm())
		return
	log_combat(user, target, "Came onto the target")
	playsound(target, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	var/obj/item/organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
	add_cum_floor(get_turf(target), do_big_puddle = testes?.ball_size > DEFAULT_TESTICLES_SIZE)
	if(splashed_user)
		var/datum/status_effect/facial/facial = splashed_user.has_status_effect(/datum/status_effect/facial)
		if(!facial)
			splashed_user.apply_status_effect(/datum/status_effect/facial)
		else
			facial.refresh_cum()
		modular_record_collar_receive_event(splashed_user, user)
	after_ejaculation()

/datum/sex_controller/proc/cum_into(oral = FALSE, mob/living/carbon/human/splashed_user = null)
	log_combat(user, target, "Came inside the target")
	werewolf_sex_infect_attempt(user, target)
	deadite_sex_infect_attempt(user, target)
	if(oral)
		playsound(user, pick(list('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg')), 100, FALSE, ignore_walls = FALSE)
	else
		playsound(user, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
	if(user != target && do_knot_action && !isnull(target) && istype(target))
		knot_try()
	if(splashed_user && !splashed_user.sexcon.knotted_status)
		var/status_type = !oral ? /datum/status_effect/facial/internal : /datum/status_effect/facial
		var/datum/status_effect/facial/splashed_type = splashed_user.has_status_effect(status_type)
		if(!splashed_type)
			splashed_user.apply_status_effect(status_type)
		else
			splashed_type.refresh_cum()
		modular_record_collar_receive_event(splashed_user, user)
		if(!oral)
			var/obj/item/organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testes?.ball_size > DEFAULT_TESTICLES_SIZE)
				splashed_user.apply_status_effect(/datum/status_effect/creampie_leak/long)
			else
				splashed_user.apply_status_effect(/datum/status_effect/creampie_leak)
	after_ejaculation()
	after_intimate_climax(oral)

/datum/status_effect/facial
	id = "facial"
	alert_type = null // don't show an alert on screen
	tick_interval = 12 MINUTES // use this time as our dry count down
	var/has_dried_up = FALSE // used as our dry status

/datum/status_effect/facial/internal
	id = "creampie"
	alert_type = null // don't show an alert on screen
	tick_interval = 7 MINUTES // use this time as our dry count down

/datum/status_effect/creampie_leak
	id = "creampie_leak"
	alert_type = null // don't show an alert on screen
	tick_interval = 12 SECONDS
	duration = 30 SECONDS
	var/contents_to_drip = /datum/reagent/erpjuice/cum

/datum/status_effect/creampie_leak/long
	id = "creampie_leak_long"
	alert_type = null // don't show an alert on screen
	tick_interval = 12 SECONDS
	duration = 60 SECONDS

/datum/status_effect/facial/on_apply()
	RegisterSignal(owner, list(COMSIG_COMPONENT_CLEAN_ACT, COMSIG_COMPONENT_CLEAN_FACE_ACT),PROC_REF(clean_up))
	has_dried_up = FALSE
	return ..()

/datum/status_effect/facial/on_remove()
	UnregisterSignal(owner, list(COMSIG_COMPONENT_CLEAN_ACT, COMSIG_COMPONENT_CLEAN_FACE_ACT))
	return ..()

/datum/status_effect/facial/tick()
	has_dried_up = TRUE

/datum/status_effect/facial/proc/refresh_cum()
	has_dried_up = FALSE
	tick_interval = world.time + initial(tick_interval)

///Callback to remove pearl necklace
/datum/status_effect/facial/proc/clean_up(datum/source, strength)
	if(strength >= CLEAN_WEAK && !QDELETED(owner))
		if(!owner.has_stress_event(/datum/stressevent/bathcleaned))
			to_chat(owner, span_notice("I feel much cleaner now!"))
			owner.add_stress(/datum/stressevent/bathcleaned)
		owner.remove_status_effect(src)

/datum/status_effect/creampie_leak/tick()
	if(!owner?.sexcon?.bottom_exposed && !get_location_accessible(owner, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		return
	var/cur_loc = get_turf(owner)
	if(!cur_loc || !isturf(cur_loc))
		return
	add_cum_floor(cur_loc)
	playsound(owner, pick('sound/misc/bleed (1).ogg', 'sound/misc/bleed (2).ogg', 'sound/misc/bleed (3).ogg'), 20, TRUE, -2, ignore_walls = FALSE)
	var/obj/item/reagent_containers/glass/cum_chalice = locate() in cur_loc
	if(!cum_chalice?.spillable) // leak contents underneath the first found open container
		return
	cum_chalice.reagents.add_reagent(contents_to_drip,1)

/datum/sex_controller/proc/ejaculate()
	if(try_resist_orgasm())
		return
	SEND_SIGNAL(user, COMSIG_MOB_EJACULATED)
	log_combat(user, user, "Ejaculated")
	if(modular_try_handle_chastity_ejaculation())
		return
	if((has_chastity_cage() || has_chastity_anal()) && prob(50))
		var/self_mess_msg = "[user] spills over [user.p_their()] own chastity!"
		user.visible_message(span_love(self_mess_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
		cum_onto(user)
		return
	var/climax_msg = "[user] makes a mess!"
	var/modular_climax_msg = modular_get_chastity_climax_message(climax_msg)
	if(istext(modular_climax_msg))
		climax_msg = modular_climax_msg
	else
		if(has_chastity_cage() || has_chastity_anal())
			climax_msg = "[user] climaxes and makes a mess in their chastity device!"
	user.visible_message(span_love(climax_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
	playsound(user, 'sound/misc/mat/endout.ogg', suppress_moan ? 12 : 50, TRUE, ignore_walls = FALSE)
	var/obj/item/organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
	add_cum_floor(get_turf(user), do_big_puddle = testes?.ball_size > DEFAULT_TESTICLES_SIZE)
	after_ejaculation()

	var/cur_loc = get_turf(user)
	if(!cur_loc || !isturf(cur_loc))
		return
	var/obj/item/reagent_containers/glass/cum_chalice = locate() in cur_loc
	if(!cum_chalice?.spillable) // leak contents underneath the first found open container
		return
	if(user.getorganslot(ORGAN_SLOT_VAGINA))
		cum_chalice.reagents.add_reagent(/datum/reagent/erpjuice/femcum,1)
	else
		cum_chalice.reagents.add_reagent(/datum/reagent/erpjuice/cum,2)

/datum/sex_controller/proc/ejaculate_container(obj/item/reagent_containers/glass/C)
	if(try_resist_orgasm())
		return
	if(C && istype(C))
		log_combat(user, user, "Ejaculated into a container")
		user.visible_message(span_love("[user] spills into [C]!"))
		playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
		if(user.getorganslot(ORGAN_SLOT_PENIS))
			var/obj/item/organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
			C.reagents.add_reagent(/datum/reagent/erpjuice/cum, testes?.ball_size > DEFAULT_TESTICLES_SIZE ? 6 : 3)
		else
			C.reagents.add_reagent(/datum/reagent/erpjuice/femcum, 2)
	after_ejaculation()

/datum/sex_controller/proc/after_ejaculation()
	set_arousal(40)
	adjust_charge(-CHARGE_FOR_CLIMAX)
	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		user.sate_addiction(/datum/charflaw/addiction/lovefiend)
	user.add_stress(/datum/stressevent/cumok)
	user.emote("sexmoanhvy", forced = TRUE)
	user.playsound_local(user, 'sound/misc/mat/end.ogg', 100)
	last_ejaculation_time = world.time
	record_round_statistic(STATS_PLEASURES)

/datum/sex_controller/proc/after_intimate_climax(oral)
	if(user == target || isnull(target) || !istype(target) || QDELETED(target))
		return
	var/user_goodlover = HAS_TRAIT(user, TRAIT_GOODLOVER)
	var/target_goodlover = HAS_TRAIT(target, TRAIT_GOODLOVER)
	if(!oral)
		if(target_goodlover)
			if(!user.mob_timers["cumtri"])
				user.mob_timers["cumtri"] = world.time
				user.adjust_triumphs(1)
				to_chat(user, span_love("Our loving is a true TRIUMPH!"))
		if(user_goodlover)
			if(!target.mob_timers["cumtri"])
				target.mob_timers["cumtri"] = world.time
				target.adjust_triumphs(1)
				to_chat(target, span_love("Our loving is a true TRIUMPH!"))
	var/user_beautiful = HAS_TRAIT(user, TRAIT_BEAUTIFUL)
	var/user_ugly = HAS_TRAIT(user, TRAIT_UNSEEMLY) || HAS_TRAIT(user, TRAIT_DISFIGURED)
	var/target_beautiful = HAS_TRAIT(target, TRAIT_BEAUTIFUL)
	var/target_ugly = HAS_TRAIT(target, TRAIT_UNSEEMLY) || HAS_TRAIT(target, TRAIT_DISFIGURED)
	if(user_ugly && target_ugly || user_beautiful && target_beautiful) // both are ugly/beautiful, add made love buff
		user.add_stress(/datum/stressevent/cummax)
		target.add_stress(/datum/stressevent/cummax)
	else // one of them is ugly, add debuff to non-ugly character
		if(target_ugly && !user_ugly && !user_goodlover) // good lover are immune to ugly characters
			if(user_beautiful) // stress event last longer
				user.add_stress(/datum/stressevent/unseemly_made_love/beautiful)
			else
				user.add_stress(/datum/stressevent/unseemly_made_love)
			target.add_stress(/datum/stressevent/cummax)
		if(user_ugly && !target_ugly && !target_goodlover) // good lover are immune to ugly characters
			if(target_beautiful) // stress event last longer
				target.add_stress(/datum/stressevent/unseemly_made_love/beautiful)
			else
				target.add_stress(/datum/stressevent/unseemly_made_love)
			user.add_stress(/datum/stressevent/cummax)
	if(!oral && force >= SEX_FORCE_HIGH && user.has_flaw(/datum/charflaw/addiction/sadist)) // force pain emote if top is a sadist
		target.emote("paincrit", forced = TRUE)

/datum/sex_controller/proc/just_ejaculated()
	return (last_ejaculation_time + 2 SECONDS >= world.time)

/datum/sex_controller/proc/set_charge(amount)
	var/empty = (charge < CHARGE_FOR_CLIMAX)
	charge = clamp(amount, 0, SEX_MAX_CHARGE)
	var/after_empty = (charge < CHARGE_FOR_CLIMAX)
	if(empty && !after_empty)
		to_chat(user, span_notice("I feel like I'm not so spent anymore"))
	if(!empty && after_empty)
		to_chat(user, span_notice("I'm spent!"))

/datum/sex_controller/proc/adjust_charge(amount)
	set_charge(charge + amount)

/datum/sex_controller/proc/handle_charge(dt)
	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		dt *= 2
	adjust_charge(dt * CHARGE_RECHARGE_RATE)
	if(is_spent())
		if(arousal > 60)
			to_chat(user, span_warning("I'm too spent!"))
			adjust_arousal(-20)
		adjust_arousal(-dt * SPENT_AROUSAL_RATE)

/datum/sex_controller/proc/set_arousal(amount)
	if(amount > arousal)
		last_arousal_increase_time = world.time
	arousal = clamp(amount, 0, MAX_AROUSAL)
	update_pink_screen()
	update_erect_state()

/datum/sex_controller/proc/update_erect_state()
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)

	if(user.mind)
		var/datum/antagonist/werewolf/W = user.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(W && W.transformed == TRUE)
			user.regenerate_icons()

	if(penis && hascall(penis, "update_erect_state"))
		penis.update_erect_state()

/datum/sex_controller/proc/update_exposure()
	user.regenerate_icons()

/datum/sex_controller/proc/adjust_arousal(amount)
	if(aphrodisiac > 1 && amount > 0)
		set_arousal(arousal + (amount * aphrodisiac))
	else set_arousal(arousal + amount)

/datum/sex_controller/proc/perform_deepthroat_oxyloss(mob/living/carbon/human/action_target, oxyloss_amt)
	var/oxyloss_multiplier = 0
	switch(force)
		if(SEX_FORCE_LOW)
			oxyloss_multiplier = 0
		if(SEX_FORCE_MID)
			oxyloss_multiplier = 0
		if(SEX_FORCE_HIGH)
			oxyloss_multiplier = 1.0
		if(SEX_FORCE_EXTREME)
			oxyloss_multiplier = 2.0
	oxyloss_amt *= oxyloss_multiplier
	if(oxyloss_amt <= 0)
		return
	action_target.adjustOxyLoss(oxyloss_amt)

/datum/sex_controller/proc/perform_sex_action(mob/living/carbon/human/action_target, arousal_amt, pain_amt, giving)
	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		arousal_amt *=1.5
		if(prob(10))
			var/lovermessage = pick("This feels so good!","I am in heaven!","This is too good to be possible!","By the ten!","I can't stop, too good!")
			to_chat(action_target, span_love(lovermessage))
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			pain_amt *= 2
	var/list/modular_adjustments = modular_adjust_action_for_target_chastity(action_target, arousal_amt, pain_amt)
	if(islist(modular_adjustments) && modular_adjustments.len >= 2)
		arousal_amt = modular_adjustments[1]
		pain_amt = modular_adjustments[2]
	action_target.sexcon.receive_sex_action(arousal_amt, pain_amt, giving, force, speed)
	/// modular signal to let other systems know about the sex action, currently used for chastity course to track arousal and apply pain, but can be used for other things in the future
	modular_emit_received_sex_action_signal(action_target, arousal_amt, pain_amt, giving)
	if(modular_should_play_chastitycourse_noise(action_target))
		chastitycourse_noise(action_target)

/datum/sex_controller/proc/receive_sex_action(arousal_amt, pain_amt, giving, applied_force, applied_speed)
	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		arousal_amt = 0
		pain_amt = 0

	if(!arousal_frozen)
		adjust_arousal(arousal_amt)

	damage_from_pain(pain_amt)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving, TRUE)

/datum/sex_controller/proc/damage_from_pain(pain_amt)
	if(pain_amt < PAIN_MINIMUM_FOR_DAMAGE)
		return
	var/damage = (pain_amt / PAIN_DAMAGE_DIVISOR)
	var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	if(!part)
		return
	user.apply_damage(damage, BRUTE, part)

/datum/sex_controller/proc/try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	if(suppress_moan)
		return
	if(arousal_amt < 1.5)
		return
	if(user.stat != CONSCIOUS)
		return
	if(last_moan + MOAN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	var/chosen_emote
	switch(arousal_amt)
		if(0 to 5)
			chosen_emote = "sexmoanlight"
		if(5 to INFINITY)
			chosen_emote = "sexmoanhvy"

	if(pain_amt >= PAIN_MILD_EFFECT)
		if(giving)
			if(prob(30))
				chosen_emote = "groan"
		else
			if(prob(40))
				chosen_emote = "painmoan"
	if(pain_amt >= PAIN_MED_EFFECT)
		if(giving)
			if(prob(50))
				chosen_emote = "groan"
		else
			if(prob(60))
				chosen_emote = "painmoan"

	last_moan = world.time
	user.emote(chosen_emote, forced = TRUE)

/datum/sex_controller/proc/is_masochist_in_spiked_chastity()
	var/modular_result = modular_is_masochist_in_spiked_chastity()
	if(!isnull(modular_result))
		return modular_result

	return FALSE

/datum/sex_controller/proc/try_do_pain_effect(pain_amt, giving, allow_intimate_item_reaction = FALSE)
	if(pain_amt < PAIN_MILD_EFFECT)
		return
	if(last_pain + PAIN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	last_pain = world.time
	if(allow_intimate_item_reaction && user?.chastity_device && HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		return
	if(pain_amt >= PAIN_HIGH_EFFECT)
		var/pain_msg = pick(list("IT HURTS!!!", "IT NEEDS TO STOP!!!", "I CAN'T TAKE IT ANYMORE!!!"))
		to_chat(user, span_boldwarning(pain_msg))
		user.flash_fullscreen("redflash2")
		if(prob(70) && user.stat == CONSCIOUS)
			user.visible_message(span_warning("[user] shudders in pain!"))
	else if(pain_amt >= PAIN_MED_EFFECT)
		var/pain_msg = pick(list("It hurts!", "It pains me!"))
		to_chat(user, span_boldwarning(pain_msg))
		user.flash_fullscreen("redflash1")
		if(prob(40) && user.stat == CONSCIOUS)
			user.visible_message(span_warning("[user] shudders in pain!"))
	else if(pain_amt >= PAIN_MILD_EFFECT)
		var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
		to_chat(user, span_warning(pain_msg))

/datum/sex_controller/proc/check_active_ejaculation()
	if(arousal < ACTIVE_EJAC_THRESHOLD)
		return FALSE
	if(is_spent())
		return FALSE
	if(!can_ejaculate())
		return FALSE
	return TRUE

/datum/sex_controller/proc/can_ejaculate()
	if(!user.getorganslot(ORGAN_SLOT_TESTICLES) && !user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	return TRUE

/datum/sex_controller/proc/handle_passive_ejaculation(mob/living/carbon/human/splashed_user = null)
	var/mob/living/carbon/human/M = user
	if(aphrodisiac > 1.5)
		if(M.check_handholding())
			if(prob(5)) //Yeah.
				try_do_moan(3, 0, 1, 0)
			if(arousal < 70)
				adjust_arousal(0.2)
		if(M.handcuffed)
			if(prob(8))
				var/chaffepain = pick(10,10,10,10,20,20,30)
				try_do_moan(3, chaffepain, 1, 0)
				damage_from_pain(chaffepain)
				try_do_pain_effect(chaffepain)
				last_moan = 0
				M.visible_message(("<span class='love_mid'>[M] squirms uncomfortably in [M.p_their()] restraints.</span>"), \
					("<span class='love_extreme'>I feel [M.handcuffed] rub uncomfortably against my skin.</span>"))
			if(arousal < ACTIVE_EJAC_THRESHOLD)
				adjust_arousal(0.25)
			else
				if(prob(3))
					ejaculate()
					if(splashed_user)
						var/datum/status_effect/facial/facial = splashed_user.has_status_effect(/datum/status_effect/facial)
						if(!facial)
							splashed_user.apply_status_effect(/datum/status_effect/facial)
						else
							facial.refresh_cum()
						modular_record_collar_receive_event(splashed_user, user)
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(is_spent())
		return
	if(!can_ejaculate())
		return FALSE
	ejaculate()
	if(splashed_user)
		var/datum/status_effect/facial/facial = splashed_user.has_status_effect(/datum/status_effect/facial)
		if(!facial)
			splashed_user.apply_status_effect(/datum/status_effect/facial)
		else
			facial.refresh_cum()
		modular_record_collar_receive_event(splashed_user, user)

/datum/sex_controller/proc/handle_container_ejaculation()
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(is_spent())
		return
	if(!can_ejaculate())
		return FALSE
	ejaculate_container(user.get_active_held_item())

/datum/sex_controller/proc/handle_cock_milking(mob/living/carbon/human/milker)
	if(arousal < ACTIVE_EJAC_THRESHOLD)
		return
	if(is_spent())
		return
	if(!can_ejaculate())
		return FALSE
	ejaculate_container(milker.get_active_held_item())

/datum/sex_controller/proc/can_use_penis()
	var/modular_result = modular_can_use_penis()
	if(!isnull(modular_result))
		return modular_result

	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	if(has_chastity_penis())
		return FALSE
	var/obj/item/organ/penis/penor = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penor)
		return FALSE
	if(!penor.functional)
		return FALSE
	return TRUE

/datum/sex_controller/proc/can_use_vagina()
	var/modular_result = modular_can_use_vagina()
	if(!isnull(modular_result))
		return modular_result

	if(has_chastity_vagina())
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/// Returns TRUE if the user's penis is currently blocked by a chastity device.
/// Base implementation checks TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_FULL, and TRAIT_CHASTITY_PENIS_BLOCKED.
/// Overridden in chastity_helpers.dm to handle cursed device modes before falling through to ..().
/datum/sex_controller/proc/has_chastity_penis()
	return HAS_TRAIT(user, TRAIT_CHASTITY_FULL) || HAS_TRAIT(user, TRAIT_CHASTITY_CAGE) || HAS_TRAIT(user, TRAIT_CHASTITY_PENIS_BLOCKED)

/// Returns TRUE if the user's vagina is currently blocked by a chastity device.
/// Base implementation checks TRAIT_CHASTITY_FULL and TRAIT_CHASTITY_VAGINA_BLOCKED.
/// Overridden in chastity_helpers.dm to handle cursed device modes before falling through to ..().
/datum/sex_controller/proc/has_chastity_vagina()
	return HAS_TRAIT(user, TRAIT_CHASTITY_FULL) || HAS_TRAIT(user, TRAIT_CHASTITY_VAGINA_BLOCKED)

/// Returns TRUE if any front anatomy (penis OR vagina) is blocked by chastity.
/// Delegates to has_chastity_penis() and has_chastity_vagina() so cursed device overrides apply automatically.
/datum/sex_controller/proc/has_chastity_cage()
	return has_chastity_penis() || has_chastity_vagina()

/// Returns TRUE if the user's chastity device is a flat-style cage (/obj/item/chastity/chastity_cage/flat).
/// Base always returns FALSE — flat detection requires device access; overridden in chastity_helpers.dm.
/datum/sex_controller/proc/has_chastity_flat()
	return FALSE

/// Returns TRUE if the user's anal access is currently blocked by a chastity device.
/// Base implementation checks TRAIT_CHASTITY_ANAL and TRAIT_CHASTITY_FULL.
/// Overridden in chastity_helpers.dm to handle cursed device modes before falling through to ..().
/datum/sex_controller/proc/has_chastity_anal()
	return HAS_TRAIT(user, TRAIT_CHASTITY_ANAL) || HAS_TRAIT(user, TRAIT_CHASTITY_FULL)

/datum/sex_controller/proc/considered_limp()
	if(arousal >= AROUSAL_HARD_ON_THRESHOLD)
		return FALSE
	return TRUE

/datum/sex_controller/proc/process_sexcon(dt)
	handle_arousal_unhorny(dt)
	handle_charge(dt)
	handle_passive_ejaculation()

/datum/sex_controller/proc/handle_arousal_unhorny(dt)
	if(arousal_frozen)
		return
	if(!can_ejaculate())
		adjust_arousal(-dt * IMPOTENT_AROUSAL_LOSS_RATE)
	if(last_arousal_increase_time + AROUSAL_TIME_TO_UNHORNY >= world.time)
		return
	var/rate
	switch(arousal)
		if(-INFINITY to 25)
			rate = AROUSAL_LOW_UNHORNY_RATE
		if(25 to 40)
			rate = AROUSAL_MID_UNHORNY_RATE
		if(40 to INFINITY)
			rate = AROUSAL_HIGH_UNHORNY_RATE
	adjust_arousal(-dt * rate)

/datum/sex_controller/proc/show_ui()
	var/list/dat = list()
	var/force_name = get_force_string()
	var/speed_name = get_speed_string()
	var/manual_arousal_name = get_manual_arousal_string()
	var/obj/item/organ/penis/got_cock = user.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/vagina/got_pussy = user.getorganslot(ORGAN_SLOT_VAGINA)
	dat += "<center><a href='?src=[REF(src)];task=speed_down'>\<</a> [speed_name] <a href='?src=[REF(src)];task=speed_up'>\></a> ~|~ <a href='?src=[REF(src)];task=force_down'>\<</a> [force_name] <a href='?src=[REF(src)];task=force_up'>\></a>"
	if(got_cock)
		dat += " ~|~ <a href='?src=[REF(src)];task=manual_arousal_down'>\<</a> [manual_arousal_name] <a href='?src=[REF(src)];task=manual_arousal_up'>\></a>"
	dat += "</center><center><a href='?src=[REF(src)];task=toggle_finished'>[do_until_finished ? "UNTIL IM FINISHED" : "UNTIL I STOP"]</a>"
	if(got_cock && !got_pussy)
		dat += "</center><center><a href='?src=[REF(src)];task=toggle_bottom_exposed'>[bottom_exposed ? "PINTLE EXPOSED" : "PINTLE CONCEALED"]</a>"
	else if(!got_cock && got_pussy)
		dat += "</center><center><a href='?src=[REF(src)];task=toggle_bottom_exposed'>[bottom_exposed ? "PUSSY EXPOSED" : "PUSSY CONCEALED"]</a>"
	else
		dat += "</center><center><a href='?src=[REF(src)];task=toggle_bottom_exposed'>[bottom_exposed ? "CROTCH EXPOSED" : "CROTCH CONCEALED"]</a>"
	if(current_action && !desire_stop)
		var/datum/sex_action/action = SEX_ACTION(current_action)
		if(action.subtle_supported)
			if(do_subtle_action)
				dat += " | <a href='?src=[REF(src)];task=toggle_subtle'>DOING SUBTLY</a>"
			else
				dat += " | <a href='?src=[REF(src)];task=toggle_subtle'>DOING VISIBLY</a>"
		else if(action.knot_on_finish && knot_penis_type())
			if(do_knot_action)
				dat += " | <a href='?src=[REF(src)];task=toggle_knot'><font color='#d146f5'>USING KNOT</font></a>"
			else
				dat += " | <a href='?src=[REF(src)];task=toggle_knot'><font color='#eac8de'>NOT USING KNOT</font></a>"
	dat += "</center><center><a href='?src=[REF(src)];task=set_arousal'>SET AROUSAL</a> | <a href='?src=[REF(src)];task=freeze_arousal'>[arousal_frozen ? "UNFREEZE AROUSAL" : "FREEZE AROUSAL"]</a></center>"
	if(target == user)
		dat += "<center>Doing unto yourself</center>"
	else
		dat += "<center>Doing unto [target]'s</center>"
	if(current_action && !desire_stop)
		dat += "<center><a href='?src=[REF(src)];task=stop'>Stop</a></center>"
	else
		dat += "<br>"
	dat += "<center><a href='?src=[REF(src)];task=category_misc'>[action_category == SEX_CATEGORY_MISC ? "<font color='#eac8de'>OTHER</font>" : "OTHER"]</a> | "
	dat += "<a href='?src=[REF(src)];task=category_hands'>[action_category == SEX_CATEGORY_HANDS ? "<font color='#eac8de'>HANDS</font>" : "HANDS"]</a> | "
	dat += "<a href='?src=[REF(src)];task=category_penetrate'>[action_category == SEX_CATEGORY_PENETRATE ? "<font color='#eac8de'>PENETRATE</font>" : "PENETRATE"]</a></center>"
	dat += "<table width='100%'><td width='50%'></td><td width='50%'></td><tr>"
	var/i = 0
	var/user_is_incapacitated = user.incapacitated()
	user.sexcon.update_all_accessible_body_zones()
	if(target && target != user)
		target.sexcon.update_all_accessible_body_zones()
	for(var/action_type in GLOB.sex_actions)
		var/datum/sex_action/action = SEX_ACTION(action_type)
		if(!(action_category&action.category))
			continue
		if(istype(action, /datum/sex_action/chastityplay) && !chastity_content_enabled_for_pair())
			continue
		if(!action.shows_on_menu(user, target))
			continue
		if(action_blocked_by_intimate_state(action, TRUE))
			continue
		dat += "<td>"
		var/link = ""
		if(!can_perform_action(action_type, user_is_incapacitated))
			link = "linkOff"
		if(current_action == action_type)
			link = "linkOn"
		dat += "<center><a class='[link]' href='?src=[REF(src)];task=action;action_type=[action_type]'>[action.name]</a></center>"
		dat += "</td>"
		i++
		if(i >= 2)
			i = 0
			dat += "</tr><tr>"

	dat += "</tr></table>"
	var/datum/browser/popup = new(user, "sexcon", "<center>Sate Desire</center>", 500, 550)
	popup.set_content(dat.Join())
	popup.open()
	return

/datum/sex_controller/Topic(href, href_list)
	if(usr != user)
		return
	switch(href_list["task"])
		if("action")
			var/action_path = text2path(href_list["action_type"])
			var/datum/sex_action/action = SEX_ACTION(action_path)
			if(!action)
				return
			try_start_action(action_path)
		if("stop")
			try_stop_current_action()
		if("speed_up")
			adjust_speed(1)
		if("speed_down")
			adjust_speed(-1)
		if("force_up")
			adjust_force(1)
		if("force_down")
			adjust_force(-1)
		if("manual_arousal_up")
			adjust_arousal_manual(1)
		if("manual_arousal_down")
			adjust_arousal_manual(-1)
		if("toggle_finished")
			do_until_finished = !do_until_finished
			update_exposure()
		if("toggle_bottom_exposed")
			bottom_exposed = !bottom_exposed
			update_exposure()
		if("set_arousal")
			var/amount = input(user, "Value above 120 will immediately cause orgasm!", "Set Arousal", arousal) as num
			if(aphrodisiac > 1 && amount > 0)
				set_arousal(amount * aphrodisiac)
			else
				set_arousal(amount)
		if("freeze_arousal")
			if(aphrodisiac == 1)
				arousal_frozen = !arousal_frozen
		if("category_misc")
			action_category = SEX_CATEGORY_MISC
		if("category_hands")
			action_category = SEX_CATEGORY_HANDS
		if("category_penetrate")
			action_category = SEX_CATEGORY_PENETRATE
		if("toggle_subtle")
			do_subtle_action = !do_subtle_action
		if("toggle_knot")
			do_knot_action = !do_knot_action
	show_ui()

/datum/sex_controller/proc/try_stop_current_action()
	if(!current_action)
		return
	desire_stop = TRUE
	user.doing = FALSE

/datum/sex_controller/proc/stop_current_action()
	if(!current_action)
		return
	var/datum/sex_action/action = SEX_ACTION(current_action)
	if(!user.sexcon.knotted_status) // never show the remove message, unless unknotted
		action.on_finish(user, target)
	desire_stop = FALSE
	user.doing = FALSE
	current_action = null
	bed = null
	target_on_bed = FALSE
	table_or_pillory = null
	grassy_knoll = null
	collar_bell_user = FALSE
	collar_bell_target = FALSE
	using_zones = list()

/datum/sex_controller/proc/try_start_action(action_type)
	if(action_type == current_action)
		try_stop_current_action()
		return
	if(current_action != null)
		try_stop_current_action()
		return
	if(!action_type)
		return
	if(!can_perform_action(action_type, user.incapacitated()))
		return
	knot_check_remove(action_type)
	// Set vars
	desire_stop = FALSE
	current_action = action_type
	bed = null
	target_on_bed = FALSE
	table_or_pillory = null
	grassy_knoll = null
	collar_bell_user = FALSE
	collar_bell_target = FALSE
	var/datum/sex_action/action = SEX_ACTION(current_action)
	log_combat(user, target, "Started sex action: [action.name]")
	INVOKE_ASYNC(src, PROC_REF(sex_action_loop))

/datum/sex_controller/proc/sex_action_loop()
	// Do action loop
	var/performed_action_type = current_action
	var/datum/sex_action/action = SEX_ACTION(current_action)
	show_progress = 1
	suppress_moan = FALSE
	do_subtle_action = TRUE // always start subtle supported actions with subtle mode on
	action.on_start(user, target)
	find_occupying_furniture()
	find_occupying_grass()
	while(TRUE)
		if(!isnull(target.client) && target.client.prefs.sexable == FALSE) //Vrell - Needs changed to let me test sex mechanics solo
			break
		if(!user.stamina_add(action.stamina_cost * get_stamina_cost_multiplier()))
			break
		if(!do_after(user, (action.do_time / get_speed_multiplier()), target = target, progress = show_progress))
			break
		if(current_action == null || performed_action_type != current_action)
			break
		if(!can_perform_action(current_action, user.incapacitated()))
			break
		if(action.is_finished(user, target))
			break
		if(desire_stop)
			break
		find_ringing_collar()
		action.on_perform(user, target)
		// It could want to finish afterwards the performed action
		if(action.is_finished(user, target))
			break
		if(!action.continous)
			break
	stop_current_action()

/datum/sex_controller/proc/can_perform_action(action_type, incapacitated)
	if(!action_type)
		return FALSE
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(istype(action, /datum/sex_action/chastityplay) && !chastity_content_enabled_for_pair())
		return FALSE
	if(!inherent_perform_check(action_type, incapacitated))
		return FALSE
	if(action_blocked_by_intimate_state(action))
		return FALSE
	if(!action.can_perform(user, target))
		return FALSE
	return TRUE
/// Checks if the action is blocked by an intimate state, such as chastity. If menu_check is TRUE, this is being called for the purpose of showing the action in the menu, and certain checks that would be redundant to do on every menu open (like checking for orgasm immunity from a collar) can be skipped.
/datum/sex_controller/proc/action_blocked_by_intimate_state(datum/sex_action/action, menu_check = FALSE)
	if(!action || !user)
		return FALSE
	if(action.intimate_check_flags == SEX_ACTION_INTIMATE_CHECK_NONE)
		return FALSE

	var/user_part = action.user_sex_part & (SEX_PART_COCK | SEX_PART_CUNT | SEX_PART_ANUS)
	if((action.intimate_check_flags & SEX_ACTION_INTIMATE_CHECK_USER) && user_part)
		if(SEND_SIGNAL(user, COMSIG_CARBON_SEX_ACTION_VALIDATE, action, target, user_part, TRUE, menu_check) & COMPONENT_SEX_ACTION_BLOCK)
			return TRUE

	var/target_part = action.target_sex_part & (SEX_PART_COCK | SEX_PART_CUNT | SEX_PART_ANUS)
	if(target && (action.intimate_check_flags & SEX_ACTION_INTIMATE_CHECK_TARGET) && target_part)
		if(SEND_SIGNAL(target, COMSIG_CARBON_SEX_ACTION_VALIDATE, action, user, target_part, FALSE, menu_check) & COMPONENT_SEX_ACTION_BLOCK)
			return TRUE

	return FALSE

/datum/sex_controller/proc/chastity_content_enabled_for(mob/living/carbon/human/H)
	var/modular_result = modular_chastity_content_enabled_for(H)
	if(!isnull(modular_result))
		return modular_result

	if(!H)
		return FALSE
	if(!H.client?.prefs)
		return TRUE
	return !!H.client.prefs.chastenable

/datum/sex_controller/proc/chastity_content_enabled_for_pair()
	var/modular_result = modular_chastity_content_enabled_for_pair()
	if(!isnull(modular_result))
		return modular_result

	if(!chastity_content_enabled_for(user))
		return FALSE
	if(target && target != user && !chastity_content_enabled_for(target))
		return FALSE
	return TRUE

/datum/sex_controller/proc/find_occupying_furniture()
	if(bed || table_or_pillory)
		return
	if(istype(user.loc, /obj/structure/closet) || istype(user.loc, /obj/structure/handcart)) // tom cruise, come out of the closet
		table_or_pillory = user.loc
		return
	if(target && isturf(target.loc)) // find target's bed/table
		if(!(target.mobility_flags & MOBILITY_STAND)) // if target is lying down
			bed = locate() in target.loc
			target_on_bed = TRUE
			if(!bed) // bed not found, try finding a table
				var/obj/structure/table/wood/table = locate() in target.loc
				table_or_pillory = table
		else // target standing up, check for pillory
			var/obj/structure/pillory/pillory = locate() in target.loc
			table_or_pillory = pillory
	if(!bed && !(user.mobility_flags & MOBILITY_STAND) && isturf(user.loc)) // find our bed
		bed = locate() in user.loc

/datum/sex_controller/proc/find_occupying_grass()
	if(grassy_knoll)
		return
	if(isturf(user.loc)) // find our grass
		grassy_knoll = locate() in user.loc

/datum/sex_controller/proc/find_ringing_collar()
	var/obj/item/clothing/neck/roguetown/collar/collar
	collar = user.get_item_by_slot(SLOT_NECK)
	if(collar && istype(collar) && collar.bellsound)
		collar_bell_user = TRUE
		var/datum/component/squeak/bell = collar.GetComponent(/datum/component/squeak)
		if(bell && LAZYLEN(bell.override_squeak_sounds))
			collar_sounds = bell.override_squeak_sounds
		else
			collar_sounds = SFX_COLLARJINGLE
	if(!target)
		collar_bell_target = FALSE
		return
	collar = target.get_item_by_slot(SLOT_NECK)
	if(collar && istype(collar) && collar.bellsound)
		collar_bell_target = TRUE
		var/datum/component/squeak/bell = collar.GetComponent(/datum/component/squeak)
		if(bell && LAZYLEN(bell.override_squeak_sounds))
			collar_sounds = bell.override_squeak_sounds
		else
			collar_sounds = SFX_COLLARJINGLE

/datum/sex_controller/proc/inherent_perform_check(action_type, incapacitated)
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(!target)
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(action.check_incapacitated && incapacitated)
		return FALSE
	return TRUE

/*
/datum/sex_controller/proc/remove_from_target_receiving()
	if(!target)
		return
	var/datum/sex_controller/target_con = target.sexcon
	if (user in target_con.receiving)
		target_con.receiving -= user
*/

/datum/sex_controller/proc/set_target(mob/living/carbon/human/new_target)
	//remove_from_target_receiving()
	target = new_target
	//var/datum/sex_controller/target_con = new_target.sexcon
	//target_con.receiving += user

/datum/sex_controller/proc/get_speed_multiplier()
	switch(speed)
		if(SEX_SPEED_LOW)
			return 1.0
		if(SEX_SPEED_MID)
			return 1.5
		if(SEX_SPEED_HIGH)
			return 2.0
		if(SEX_SPEED_EXTREME)
			return 2.5

/datum/sex_controller/proc/get_stamina_cost_multiplier()
	switch(force)
		if(SEX_FORCE_LOW)
			return 1.0
		if(SEX_FORCE_MID)
			return 1.5
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_SPEED_EXTREME)
			return 2.5

/datum/sex_controller/proc/get_force_pleasure_multiplier(passed_force, giving)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			if(giving)
				return 0.8
			else
				return 0.8
		if(SEX_FORCE_MID)
			if(giving)
				return 1.2
			else
				return 1.2
		if(SEX_FORCE_HIGH)
			if(giving)
				return 1.6
			else
				return 1.2
		if(SEX_FORCE_EXTREME)
			if(giving)
				return 2.0
			else
				return 0.8

/datum/sex_controller/proc/get_force_pain_multiplier(passed_force)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			return 0.5
		if(SEX_FORCE_MID)
			return 1.0
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 3.0

/datum/sex_controller/proc/get_speed_pain_multiplier(passed_speed)
	switch(passed_speed)
		if(SEX_SPEED_LOW)
			return 0.8
		if(SEX_SPEED_MID)
			return 1.0
		if(SEX_SPEED_HIGH)
			return 1.2
		if(SEX_SPEED_EXTREME)
			return 1.4

/datum/sex_controller/proc/get_force_string()
	switch(force)
		if(SEX_FORCE_LOW)
			return "<font color='#eac8de'>GENTLE</font>"
		if(SEX_FORCE_MID)
			return "<font color='#e9a8d1'>FIRM</font>"
		if(SEX_FORCE_HIGH)
			return "<font color='#f05ee1'>ROUGH</font>"
		if(SEX_FORCE_EXTREME)
			return "<font color='#d146f5'>BRUTAL</font>"

/datum/sex_controller/proc/get_speed_string()
	switch(speed)
		if(SEX_SPEED_LOW)
			return "<font color='#eac8de'>SLOW</font>"
		if(SEX_SPEED_MID)
			return "<font color='#e9a8d1'>STEADY</font>"
		if(SEX_SPEED_HIGH)
			return "<font color='#f05ee1'>QUICK</font>"
		if(SEX_SPEED_EXTREME)
			return "<font color='#d146f5'>UNRELENTING</font>"

/datum/sex_controller/proc/get_manual_arousal_string()
	switch(manual_arousal)
		if(SEX_MANUAL_AROUSAL_DEFAULT)
			return "<font color='#eac8de'>NATURAL</font>"
		if(SEX_MANUAL_AROUSAL_UNAROUSED)
			return "<font color='#e9a8d1'>UNAROUSED</font>"
		if(SEX_MANUAL_AROUSAL_PARTIAL)
			return "<font color='#f05ee1'>PARTIALLY ERECT</font>"
		if(SEX_MANUAL_AROUSAL_FULL)
			return "<font color='#d146f5'>FULLY ERECT</font>"

/datum/sex_controller/proc/get_generic_force_adjective(is_stealth = FALSE)
	if(is_stealth)
		return pick(list("subtly","sneakily","covertly","stealthily","quietly"))
	switch(force)
		if(SEX_FORCE_LOW)
			return pick(list("gently", "carefully", "tenderly", "gingerly", "delicately", "lazily"))
		if(SEX_FORCE_MID)
			return pick(list("firmly", "vigorously", "eagerly", "steadily", "intently"))
		if(SEX_FORCE_HIGH)
			return pick(list("roughly", "carelessly", "forcefully", "fervently", "fiercely"))
		if(SEX_FORCE_EXTREME)
			return pick(list("brutally", "violently", "relentlessly", "savagely", "mercilessly"))

/datum/sex_controller/proc/spanify_force(string)
	switch(force)
		if(SEX_FORCE_LOW)
			return "<span class='love_low'>[string]</span>"
		if(SEX_FORCE_MID)
			return "<span class='love_mid'>[string]</span>"
		if(SEX_FORCE_HIGH)
			return "<span class='love_high'>[string]</span>"
		if(SEX_FORCE_EXTREME)
			return "<span class='love_extreme'>[string]</span>"

/datum/sex_controller/proc/try_pelvis_crush(mob/living/carbon/human/target)
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		if(!target.has_wound(/datum/wound/fracture/groin))
			if(prob(10))
				var/obj/item/bodypart/groin = target.get_bodypart(check_zone(BODY_ZONE_PRECISE_GROIN))
				groin.add_wound(/datum/wound/fracture)

/datum/proc/werewolf_sex_infect_attempt(mob/living/carbon/human/top, mob/living/carbon/human/bottom)

	if(!top || !bottom || !top.mind || !bottom.mind)
		return

	var/datum/antagonist/werewolf/WWtop
	var/datum/antagonist/werewolf/WWbottom
	var/infection_probability = 40
	if(top.mind.has_antag_datum(/datum/antagonist/werewolf))
		WWtop = top.mind.has_antag_datum(/datum/antagonist/werewolf/)
	
	if(bottom.mind.has_antag_datum(/datum/antagonist/werewolf))
		WWbottom = bottom.mind.has_antag_datum(/datum/antagonist/werewolf/)

	if(WWtop && WWbottom)
		return
	
	if(WWtop && WWtop.transformed && !WWbottom)
		if(prob(infection_probability))
			var/answer = tgui_alert(top, "Infect your mate?", "Please answer in [DisplayTimeText(200)]!", list("Yae","Nae"),200)
			if(!answer || answer == "Nae")
				return
			if(answer == "Yae")
				bottom.werewolf_infect_attempt()
		return


	if(WWbottom && WWbottom.transformed && !WWtop)
		if(prob(infection_probability))
			var/answer = tgui_alert(bottom, "Infect your mate?", "Please answer in [DisplayTimeText(200)]!", list("Yae","Nae"),200)
			if(!answer || answer == "Nae")
				return
			if(answer == "Yae")
				top.werewolf_infect_attempt()
		return

/datum/proc/deadite_sex_infect_attempt(mob/living/carbon/human/top, mob/living/carbon/human/bottom)
	
	if(!top || !bottom || !top.mind || !bottom.mind)
		return
	var/datum/antagonist/zombie/ZMtop
	var/datum/antagonist/zombie/ZMbottom
	var/infection_probability = 40
	if(top.mind.has_antag_datum(/datum/antagonist/zombie))
		ZMtop = top.mind.has_antag_datum(/datum/antagonist/zombie/)
	
	if(bottom.mind.has_antag_datum(/datum/antagonist/zombie))
		ZMbottom = bottom.mind.has_antag_datum(/datum/antagonist/zombie/)
	
	if(ZMtop && ZMbottom)
		return
	
	if(ZMtop && ZMtop.has_turned && !ZMbottom)
		if(prob(infection_probability))
			var/answer = tgui_alert(top, "Spread HER gift?", "Please answer in [DisplayTimeText(200)]!", list("Yae","Nae"),200)
			if(!answer || answer == "Nae")
				return
			if(answer == "Yae")
				bottom.zaids_check()
		return

	if(ZMbottom && ZMbottom.has_turned && !ZMtop)
		if(prob(infection_probability))
			var/answer = tgui_alert(bottom, "Spread HER gift?", "Please answer in [DisplayTimeText(200)]!", list("Yae","Nae"),200)
			if(!answer || answer == "Nae")
				return
			if(answer == "Yae")
				top.zaids_check()
		return
///Making sure there're not any other antag or immune, then applies zombie infection
/mob/living/carbon/human/proc/zaids_check() 
	if(!mind)
		return
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if(mind.has_antag_datum(/datum/antagonist/zombie))
		return
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return
	return apply_status_effect(/datum/status_effect/zombie_infection)

#undef SEX_ZONE_NULL
#undef SEX_ZONE_GROIN
#undef SEX_ZONE_GROIN_GRAB
#undef SEX_ZONE_L_FOOT
#undef SEX_ZONE_R_FOOT
#undef SEX_ZONE_MOUTH
#undef SEX_ZONE_CHEST
#undef SEX_ZONE_CHEST_GRAB
