#define SEX_ZONE_NULL				0
#define SEX_ZONE_GROIN				(1<<0)
#define SEX_ZONE_GROIN_GRAB			(1<<1)
#define SEX_ZONE_L_FOOT				(1<<2)
#define SEX_ZONE_R_FOOT				(1<<3)
#define SEX_ZONE_MOUTH				(1<<4)
#define SEX_ZONE_CHEST				(1<<5)
#define SEX_ZONE_CHEST_GRAB			(1<<6)
#define SEX_SUBTLE_MESSAGE_REPEAT_INTERVAL	3

//Used to prevent sexcon messages repeating unless in subtle or through changes in intensity, speed, knot status or subtle usage. Also used for filtering sexcon messages that might be prefbreaking (i.e. chastity, gore stuff, etc.)
/mob/living/carbon/human/proc/sexcon_action_message(message, self_message = null, blind_message = null, vision_distance, list/ignored_mobs)
	if(!sexcon)
		return
	if(sexcon.suppress_action_messages)
		return
	if(!message)
		return
	vision_distance = sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE
	visible_message(message, self_message, blind_message, vision_distance, ignored_mobs = ignored_mobs)

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
	/// Partner captured when our action starts, separate from the selected UI target.
	var/mob/living/carbon/human/panel_triumph_target
	/// Other controllers currently performing partnered actions on us.
	var/list/panel_triumph_actions
	/// Identity and progress deadline of the current action loop.
	var/panel_action_session = 0
	var/panel_action_deadline = 0
	/// Invalidates oxygen-healing callbacks when a make-out action stops or restarts.
	var/kissing_oxygen_session = 0
	/// Recipient-side cooldown shared by every initiator; base recovery cannot stack.
	var/kissing_oxygen_next_heal = 0
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
	/// Quirk-only panel option; consent is checked on the affected partner at each attempt.
	var/deny_partner_climax = FALSE
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
	var/last_oral_drip_consume_time = 0
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
	/// Suppress repeated action messages unless key action state changes.
	var/suppress_action_messages = FALSE
	/// Tracks whether the one-time orison indulgence notice has been shown for the current action.
	var/orison_indulgence_notice_shown = FALSE
	/// Knot based variables
	var/do_knot_action = FALSE
	var/do_knot_action_as_bottom = FALSE
	var/knotted_status = KNOTTED_NULL // knotted state and used to prevent multiple knottings when we do not handle that case
	var/knotted_part = SEX_PART_NULL // which orifice was knotted (bitflag)
	var/knotted_part_partner = SEX_PART_NULL // which orifice was knotted on partner (bitflag)
	var/knotted_forced_by_bottom = FALSE
	var/tugging_knot = FALSE
	var/tugging_knot_check = 0
	var/tugging_knot_blocked = FALSE
	var/knot_movement_restoring = FALSE /// Suppresses movement callbacks while restoring a blocked large attachment
	var/mob/living/carbon/knotted_owner = null // whom has the knot
	var/mob/living/carbon/knotted_recipient = null // whom took the knot
	/// Allow crotch to be exposed and bypass clothes check
	var/bottom_exposed = FALSE
	/// If TRUE, hide genital visuals only. The organs still function but are now a True/False toggle
	var/hide_pintle_visuals = FALSE
	/// Bypasses positioning and exposure checks entirely
	var/freeuse = FALSE
	// If FALSE, the warning when in danger of belly-popping someone will display
	var/popwarning = FALSE
	// Moved here from proc/get_generic_force_adjective to reduce list initialization/destruction
	var/static/list/stealth_force_adjectives 	= list("subtly", "sneakily", "covertly", "stealthily", "quietly")
	var/static/list/low_force_adjectives 		= list("gently", "carefully", "tenderly", "gingerly", "delicately", "lazily")
	var/static/list/mid_force_adjectives 		= list("firmly", "vigorously", "eagerly", "steadily", "intently")
	var/static/list/high_force_adjectives 		= list("roughly", "carelessly", "forcefully", "fervently", "fiercely")
	var/static/list/extreme_force_adjectives 	= list("brutally", "violently", "relentlessly", "savagely", "mercilessly")
	var/static/list/ludicrous_force_adjectives 	= list("madly", "uncontrollably", "desperately", "deliriously", "freekishly")

/datum/sex_controller/New(mob/living/carbon/human/owner)
	user = owner
	charge = get_max_charge()

/datum/sex_controller/Destroy()
	clear_panel_triumph_action()
	for(var/datum/sex_controller/action_controller in panel_triumph_actions?.Copy())
		action_controller.clear_panel_triumph_action()
	panel_triumph_actions = null
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

/datum/sex_controller/proc/do_visual_effects(atom/movable/effect_target, datum/sex_action/action)
	if(do_subtle_action)
		return
	if(!action || !(action.category & SEX_CATEGORY_PENETRATE))
		return
	var/list/seers = list()
	if(user?.client?.prefs && user.client.prefs.erp_visuals)
		seers += user
	var/mob/living/carbon/human/H = effect_target
	if(istype(H) && H.client?.prefs && H.client.prefs.erp_visuals && H != user)
		seers += H
	if(!length(seers))
		return
	var/icon_state_name = (user?.cmode || (istype(H) && H.cmode)) ? "anger" : "redheart"
	var/atom/movable/spawn_target = effect_target || user
	for(var/i in 1 to rand(1, 3))
		new /obj/effect/temp_visual/heart/sex_effects/invisible(get_turf(spawn_target), seers, icon_state_name)
	for(var/mob/seer in seers)
		spawn_target.balloon_alert(seer, "plap!", rand(-15, 15), rand(0, 25))

/datum/sex_controller/proc/do_thrust_animate(atom/movable/target, pixels = 4, time = 2.7)
	var/obj/item/organ/breasts/target_breasts
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		target_breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
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

	if(target_breasts && force >= SEX_FORCE_HIGH)
		target_breasts.thrust_jiggle_on()
		addtimer(CALLBACK(target_breasts, TYPE_PROC_REF(/obj/item/organ/breasts, thrust_jiggle_off)), 0.8 SECONDS)

	var/t_oldx = target.pixel_x
	var/t_oldy = target.pixel_y
	var/t_target_x = t_oldx
	var/t_target_y = t_oldy
	var/t_pixels = pixels * 0.25
	if(force >= SEX_FORCE_HIGH)
		t_pixels = pixels * 0.5
	switch(dir)
		if(NORTH)
			t_target_y += t_pixels
		if(SOUTH)
			t_target_y -= t_pixels
		if(WEST)
			t_target_x -= t_pixels
		if(EAST)
			t_target_x += t_pixels
	animate(target, pixel_x = t_target_x, pixel_y = t_target_y, time = time)
	animate(pixel_x = t_oldx, pixel_y = t_oldy, time = time)

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
	if(!bodypart)
		return FALSE

	var/self_target = FALSE
	var/datum/sex_controller/user_controller = user.sexcon
	if(user_controller.target == user)
		self_target = TRUE

	// Freeuse: target has opted to skip positioning/exposure checks entirely.
	// Adjacency is still enforced so people can't reach across the map.
	if(target.sexcon.freeuse)
		if(src.ranged_los_action)
			if(!(target in view(src.ranged_los_distance, user)))
				return FALSE
		else if(!user.sexcon.Adjacent_Or_Closet(target))
			return FALSE

		if(!isnull(user_controller.current_action) && user_controller.current_action == src.type)
			target.sexcon.update_current_accessible_body_zones(location, grabs)

		if(user == target && !(bodypart in user_controller.using_zones) && user_controller.current_action == SEX_ACTION(src))
			user_controller.using_zones += location

		return TRUE

	var/signalargs = list(src, bodypart, self_target)
	signalargs += args

	var/sigbitflags = SEND_SIGNAL(target, COMSIG_ERP_LOCATION_ACCESSIBLE, signalargs)
	bodypart = signalargs[ERP_BODYPART]

	if(sigbitflags & SIG_CHECK_FAIL)
		return FALSE

	if(!bodypart)
		return FALSE

	if(!(sigbitflags & SKIP_ADJACENCY_CHECK))
		if(src.ranged_los_action)
			if(!(target in view(src.ranged_los_distance, user)))
				return FALSE
		else if(!user.sexcon.Adjacent_Or_Closet(target))
			return FALSE

	if(!self_target && !isnull(target.buckled) && istype(target.buckled, /obj/structure/bondage/gloryhole)) // gloryhole buckled mobs ignore tile/grab checks
		sigbitflags |= (SKIP_GRAB_CHECK|SKIP_TILE_CHECK)
		grabs = FALSE

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
	var/max_setting = (HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || HAS_TRAIT(user, TRAIT_DEPRAVED) || user.has_status_effect(/datum/status_effect/debuff/emberwine)) ? SEX_SPEED_MAX : SEX_SPEED_MAX - 1
	speed = clamp(speed + amt, SEX_SPEED_MIN, max_setting)

/datum/sex_controller/proc/adjust_force(amt)
	var/max_setting = (HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || HAS_TRAIT(user, TRAIT_DEPRAVED) || user.has_status_effect(/datum/status_effect/debuff/emberwine)) ? SEX_FORCE_MAX : SEX_FORCE_MAX - 1
	force = clamp(force + amt, SEX_FORCE_MIN, max_setting)
/datum/sex_controller/proc/adjust_arousal_manual(amt)
	manual_arousal = clamp(manual_arousal + amt, SEX_MANUAL_AROUSAL_MIN, SEX_MANUAL_AROUSAL_MAX)
	update_erect_state()

/datum/sex_controller/proc/update_pink_screen()
	if(!user?.client?.prefs?.erp_visuals)
		user?.clear_fullscreen("horny")
		return
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
	if(try_deny_panel_climax())
		return TRUE
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

/datum/sex_controller/proc/cum_onto(mob/living/carbon/human/splashed_user = null, cum_on_face = TRUE)
	if(try_resist_orgasm())
		return
	var/mob/living/carbon/human/effective_target = splashed_user || target
	log_combat(user, effective_target, "Came onto the target")
	if(effective_target)
		playsound(effective_target, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	add_cum_floor(get_turf(effective_target || user), do_big_puddle = get_production_testicle_size() > DEFAULT_TESTICLES_SIZE)
	if(splashed_user)
		if(cum_on_face)
			var/datum/status_effect/facial/facial = splashed_user.has_status_effect(/datum/status_effect/facial)
			if(!facial)
				splashed_user.apply_status_effect(/datum/status_effect/facial)
				if(splashed_user != user) // don't announce self-ejaculation (e.g. chastity overflow)
					splashed_user.visible_message(span_love("[splashed_user] takes a load on their face!"), span_love("I take a load on my face!"))
			else
				facial.refresh_cum()
		else
			var/datum/status_effect/facial/external/external = splashed_user.has_status_effect(/datum/status_effect/facial/external)
			if(!external)
				splashed_user.apply_status_effect(/datum/status_effect/facial/external)
				if(splashed_user != user) // don't announce self-ejaculation (e.g. chastity overflow)
					splashed_user.visible_message(span_love("[splashed_user] takes a load on their body!"), span_love("I take a load on my body!"))
			else
				external.refresh_cum()
		if(HAS_TRAIT(user, TRAIT_REDOLENT) && !HAS_TRAIT(splashed_user, TRAIT_REDOLENT))
			user.redolent_apply_contact_stink(splashed_user)
		modular_record_collar_receive_event(splashed_user, user)
	if(effective_target?.has_flaw(/datum/charflaw/addiction/lovefiend))
		effective_target.sate_addiction(/datum/charflaw/addiction/lovefiend)
	if(effective_target?.has_flaw(/datum/charflaw/addiction/baothamarked))
		effective_target.sate_addiction(/datum/charflaw/addiction/baothamarked)
	after_ejaculation()

/datum/sex_controller/proc/cum_into(oral = FALSE, mob/living/carbon/human/splashed_user = null, datum/sex_action/knot_action = null, knot_swap_roles = FALSE, mob/living/carbon/human/knot_btm = null, orifice = SEX_PART_NULL, skip_knot_try = FALSE, consume_charge = TRUE, source_part = SEX_PART_NULL, oral_extra_volume = null)
	// Later bursts belong to an already completed climax.
	if(consume_charge && try_deny_panel_climax())
		return
	// splashed_user is the bottom receiving; for top-initiated actions it matches target, for riding/blowjob it is the rider/sucker while target may be null
	var/mob/living/carbon/human/effective_target = splashed_user || target
	if((orifice & SEX_PART_TAIL_MAW) && !get_manticore_tail(effective_target))
		return
	if((source_part & SEX_PART_TAIL_MAW) && !get_manticore_tail(user))
		return
	log_combat(user, effective_target, "Came inside the target")
	deadite_sex_infect_attempt(user, effective_target)
	if(oral)
		playsound(user, pick(list('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg')), 100, FALSE, ignore_walls = FALSE)
	else
		playsound(user, 'sound/misc/mat/endin.ogg', 100, TRUE, ignore_walls = FALSE)
	if(!skip_knot_try && consume_charge && (knot_btm || (user != effective_target && !isnull(effective_target) && istype(effective_target))))
		knot_try(knot_action = knot_action, knot_swap_roles = knot_swap_roles, knot_btm = knot_btm)
	var/datum/sex_controller/receiver_sexcon = splashed_user?.sexcon
	var/is_receiver_actively_knotted_to_user = receiver_sexcon?.knotted_status == KNOTTED_AS_BTM && receiver_sexcon?.knotted_owner == user
	if(receiver_sexcon && (oral || (orifice & SEX_PART_TAIL_MAW) || !receiver_sexcon.knotted_status || is_receiver_actively_knotted_to_user))
		var/status_type = !oral ? /datum/status_effect/facial/internal : /datum/status_effect/facial
		if(!oral && (orifice & SEX_PART_TAIL_MAW))
			status_type = /datum/status_effect/facial/internal/tailmaw
		var/datum/status_effect/facial/splashed_type = splashed_user.has_status_effect(status_type)
		if(!splashed_type)
			splashed_user.apply_status_effect(status_type)
			if(oral)
				splashed_user.visible_message(span_love("[splashed_user] takes a load down their throat!"), span_love("I take a load down my throat!"))
			else
				splashed_user.visible_message(span_love("[splashed_user] takes a load inside them!"), span_love("I take a load inside me!"))
		else
			splashed_type.refresh_cum()
			if(oral)
				to_chat(splashed_user, span_love("I take another load down my throat..."))
		if(oral && splashed_user.reagents) //cum fills hunger if taking it orally
			if(user.getorganslot(ORGAN_SLOT_PENIS) && !(source_part & SEX_PART_TAIL_MAW))
				add_oral_intake_reagent(splashed_user, /datum/reagent/erpjuice/cum, get_semen_volume(), repeat_intake = !!splashed_type, extra_volume = oral_extra_volume)
			else
				add_oral_intake_reagent(splashed_user, /datum/reagent/erpjuice/femcum, 2)
			apply_cum_consumed_buff(splashed_user)
		if(!oral && user?.dna?.species?.id == "gnoll")
			splashed_user.has_gnoll_scent_this_round = TRUE
		var/user_redolent = HAS_TRAIT(user, TRAIT_REDOLENT)
		var/target_redolent = HAS_TRAIT(splashed_user, TRAIT_REDOLENT)
		if(user_redolent && !target_redolent)
			user.redolent_apply_contact_stink(splashed_user)
		else if(target_redolent && !user_redolent)
			splashed_user.redolent_apply_contact_stink(user)
		modular_record_collar_receive_event(splashed_user, user)
		if(!oral)
			if(consume_charge && ((orifice & SEX_PART_TAIL_MAW) || !is_receiver_actively_knotted_to_user))
				apply_creampie_drip(splashed_user, orifice, use_long = get_production_testicle_size() > DEFAULT_TESTICLES_SIZE, added_duration = get_leakage_duration())
	if(consume_charge)
		modular_try_oviposit(splashed_user, oral, orifice)
	if(effective_target?.has_flaw(/datum/charflaw/addiction/lovefiend))
		effective_target.sate_addiction(/datum/charflaw/addiction/lovefiend)
	if(effective_target?.has_flaw(/datum/charflaw/addiction/baothamarked))
		effective_target.sate_addiction(/datum/charflaw/addiction/baothamarked)
	if(!oral && (orifice & SEX_PART_TAIL_MAW) && !(source_part & SEX_PART_TAIL_MAW))
		user.try_impregnate(effective_target, SEX_PART_TAIL_MAW)
	after_ejaculation(consume_charge)
	if(consume_charge)
		after_intimate_climax(oral, splashed_user)

/// Applies or accumulates a creampie drip status effect, correctly ORing new orifice flags onto an existing drip rather than silently dropping the second application.
/proc/apply_creampie_drip(mob/living/carbon/human/target, orifice, use_long = FALSE, added_duration = 60 SECONDS)
	if(!ishuman(target) || QDELETED(target) || !isnum(added_duration) || added_duration <= 0)
		return FALSE
	var/datum/status_effect/creampie_leak/existing = target.has_status_effect(/datum/status_effect/creampie_leak/long)
	if(!istype(existing))
		existing = target.has_status_effect(/datum/status_effect/creampie_leak)
	if(istype(existing))
		existing.sync_leak_clock()
		existing.orifice |= orifice
		to_chat(target, span_love("I feel another warmth beginning to leak out of me."))
		existing.duration = world.time + min(max(existing.duration - world.time, 0) + added_duration, 60 MINUTES)
		target.check_stuffed_input(TRUE)
		return existing
	var/leak_type = use_long ? /datum/status_effect/creampie_leak/long : /datum/status_effect/creampie_leak
	var/datum/status_effect/creampie_leak/created = target.apply_status_effect(leak_type, orifice, min(added_duration, 60 MINUTES))
	if(istype(created))
		target.check_stuffed_input(TRUE)
	return created

/// Announce the incoming flavor directly so every successful intake has feedback.
/datum/sex_controller/proc/add_oral_intake_reagent(mob/living/carbon/human/consumer, reagent_type, amount, repeat_intake = FALSE, extra_volume = null)
	if(!ishuman(consumer) || QDELETED(consumer) || !consumer.reagents || !ispath(reagent_type, /datum/reagent/erpjuice))
		return FALSE
	if(!isnum(amount) || amount <= 0)
		return FALSE
	if(reagent_type == /datum/reagent/erpjuice/cum)
		// Burst callers divide one climax's allowance before the first delivery.
		if(isnull(extra_volume))
			extra_volume = get_oral_intake_extra_volume(repeat_intake)
		if(!isnum(extra_volume) || extra_volume < 0)
			return FALSE
		amount += extra_volume
	if(!consumer.reagents.add_reagent(reagent_type, amount))
		return FALSE
	if(consumer.get_taste_sensitivity() <= 100)
		var/datum/reagent/fluid = reagent_type
		to_chat(consumer, span_info("I can taste [initial(fluid.taste_description)]."))
	return TRUE

/// Match the container bonus at one unit per twelve seconds; missing donor organs retain the old minimum.
/datum/sex_controller/proc/get_leakage_duration()
	return max(60 SECONDS, floor(get_oral_intake_extra_volume()) * (12 SECONDS))

/// Calculation-only size override; visible anatomy remains untouched.
/datum/sex_controller/proc/get_production_testicle_size()
	if(!ishuman(user) || QDELETED(user))
		return null
	var/obj/item/organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
	if(!istype(testes) || !isnum(testes.ball_size))
		return null
	return HAS_TRAIT(user, TRAIT_HIGH_PRODUCTION) ? MAX_TESTICLES_SIZE : testes.ball_size

/// Size-based bonus shared with container collection; oral repeats grant half the amount.
/datum/sex_controller/proc/get_oral_intake_extra_volume(repeat_intake = FALSE)
	var/production_size = get_production_testicle_size()
	if(!isnum(production_size))
		return 0
	var/extra_volume = 10
	switch(clamp(production_size, MIN_TESTICLES_SIZE, MAX_TESTICLES_SIZE))
		if(MIN_TESTICLES_SIZE)
			extra_volume = 5
		if(MAX_TESTICLES_SIZE)
			extra_volume = 30
	var/obj/item/bodypart/taur/taur_parts = user.get_taur_tail()
	if(istype(taur_parts))
		extra_volume *= 1.5
	if(repeat_intake)
		extra_volume *= 0.5
	return extra_volume

/datum/sex_controller/proc/apply_cum_consumed_buff(mob/living/carbon/human/consumer)
	if(!consumer)
		return FALSE
	consumer.apply_status_effect(/datum/status_effect/buff/cum_consumed)
	return TRUE

/datum/sex_controller/proc/consume_oral_drips(mob/living/carbon/human/source)
	if(!source || !user || !source.sexcon)
		return FALSE

	var/datum/status_effect/creampie_leak/drip = source.has_status_effect(/datum/status_effect/creampie_leak/long)
	if(!drip)
		drip = source.has_status_effect(/datum/status_effect/creampie_leak)
	if(!drip)
		return FALSE

	drip.sync_leak_clock()
	if(last_oral_drip_consume_time + 3 SECONDS > world.time)
		return FALSE
	last_oral_drip_consume_time = world.time

	var/datum/status_effect/facial/facial = user.has_status_effect(/datum/status_effect/facial)
	if(!facial)
		user.apply_status_effect(/datum/status_effect/facial)
	else
		facial.refresh_cum()

	if(user.reagents)
		var/drip_type = drip.contents_to_drip || /datum/reagent/erpjuice/cum
		user.reagents.add_reagent(drip_type, 1)
	apply_cum_consumed_buff(user)

	user.visible_message(span_love("[user] laps up the fluids leaking from [source]!"), span_love("I lap up the fluids leaking from [source]!"))

	if(drip.duration <= world.time + 6 SECONDS)
		if(istype(drip, /datum/status_effect/creampie_leak/long))
			source.remove_status_effect(/datum/status_effect/creampie_leak/long)
		else
			source.remove_status_effect(/datum/status_effect/creampie_leak)
	else
		drip.duration -= 6 SECONDS
	return TRUE

/datum/status_effect/facial
	id = "facial"
	alert_type = null // don't show an alert on screen
	tick_interval = 12 MINUTES // use this time as our dry count down
	var/has_dried_up = FALSE // used as our dry status

/datum/status_effect/facial/internal
	id = "creampie"
	alert_type = null // don't show an alert on screen
	tick_interval = 7 MINUTES // use this time as our dry count down

/datum/status_effect/facial/internal/tailmaw
	id = "tailmaw_internal"

/datum/status_effect/facial/external
	id = "cumshot"
	alert_type = null // don't show an alert on screen
	tick_interval = 10 MINUTES // use this time as our dry count down

/datum/status_effect/creampie_leak
	id = "creampie_leak"
	alert_type = null // don't show an alert on screen
	tick_interval = 12 SECONDS
	duration = 60 SECONDS
	var/contents_to_drip = /datum/reagent/erpjuice/cum
	var/orifice = SEX_PART_NULL
	var/last_leak_clock
	var/next_clothing_check = 0
	var/clothing_allows_dripping = FALSE

/datum/status_effect/creampie_leak/on_creation(mob/living/new_owner, orifice_in = SEX_PART_NULL, added_duration = null)
	orifice = orifice_in
	if(isnum(added_duration))
		duration = clamp(added_duration, 1, 60 MINUTES)
	last_leak_clock = world.time
	return ..(new_owner)

/// Advance the absolute expiry and next-drip clocks only while actual leakage is blocked.
/datum/status_effect/creampie_leak/proc/sync_leak_clock()
	var/elapsed = max(world.time - last_leak_clock, 0)
	last_leak_clock = world.time
	if(elapsed && !can_drip())
		duration += elapsed
		tick_interval += elapsed

/datum/status_effect/creampie_leak/process(wait)
	if(QDELETED(owner))
		qdel(src)
		return
	sync_leak_clock()
	return ..()

/datum/status_effect/creampie_leak/proc/can_drip(force_clothing_check = FALSE)
	if(QDELETED(owner) || !isturf(get_turf(owner)))
		return FALSE
	var/tailmaw_leaking = (orifice & SEX_PART_TAIL_MAW) && get_manticore_tail(owner)
	if(tailmaw_leaking || owner.sexcon?.bottom_exposed)
		return TRUE
	// Limit routine equipment scans; a real drip always requests a fresh check.
	if(force_clothing_check || world.time >= next_clothing_check)
		clothing_allows_dripping = get_location_accessible(owner, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE)
		next_clothing_check = world.time + 1 SECONDS
	return !!clothing_allows_dripping

/datum/status_effect/creampie_leak/long
	id = "creampie_leak_long"
	alert_type = null // don't show an alert on screen
	tick_interval = 12 SECONDS
	duration = 120 SECONDS

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

/datum/status_effect/creampie_leak/on_apply()
	RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_up))
	to_chat(owner, span_love("I feel a warmth beginning to leak out of me."))
	return ..()

/datum/status_effect/creampie_leak/on_remove()
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	return ..()

/datum/status_effect/creampie_leak/proc/clean_up(datum/source, strength)
	if(strength >= CLEAN_WEAK && !QDELETED(owner))
		to_chat(owner, span_notice("I feel much cleaner now."))
		owner.remove_status_effect(src)

/datum/status_effect/creampie_leak/tick()
	if(!can_drip(TRUE))
		return
	var/cur_loc = get_turf(owner)
	if(!cur_loc || !isturf(cur_loc))
		return
	playsound(owner, pick('sound/misc/bleed (1).ogg', 'sound/misc/bleed (2).ogg', 'sound/misc/bleed (3).ogg'), 20, TRUE, -2, ignore_walls = FALSE)
	spill_floor_fluid(cur_loc, contents_to_drip, 1)

/datum/sex_controller/proc/ejaculate(climax_part = SEX_PART_NULL)
	var/from_tailmaw = get_manticore_tail(user) && ((climax_part & SEX_PART_TAIL_MAW) || (!user.getorganslot(ORGAN_SLOT_TESTICLES) && !user.getorganslot(ORGAN_SLOT_VAGINA)))
	if(try_resist_orgasm())
		return
	SEND_SIGNAL(user, COMSIG_MOB_EJACULATED)
	log_combat(user, user, "Ejaculated")
	if(!from_tailmaw && modular_try_handle_chastity_ejaculation())
		return
	if(!from_tailmaw && user.getorganslot(ORGAN_SLOT_PENIS) && knotted_status == KNOTTED_AS_TOP && knotted_owner == user && ishuman(knotted_recipient) && !QDELETED(knotted_recipient) && knotted_recipient?.sexcon)
		var/orifice = knotted_part_partner
		var/is_oral_knot = (orifice & SEX_PART_JAWS) != SEX_PART_NULL
		var/knotted_climax_msg = is_oral_knot ? "[user] climaxes down [knotted_recipient]'s throat!" : "[user] climaxes deep inside [knotted_recipient]!"
		user.visible_message(span_love(knotted_climax_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
		//Rolls impreg on deep climax in relevant scenarios
		if(!is_oral_knot)
			if(orifice & SEX_PART_CUNT)
				user.try_impregnate(knotted_recipient)
			else if((orifice & SEX_PART_ANUS) && HAS_TRAIT(knotted_recipient, TRAIT_BAOTHA_FERTILITY_BOON) && !knotted_recipient.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(knotted_recipient)
			else if((orifice & SEX_PART_ANUS) && HAS_TRAIT(knotted_recipient, TRAIT_OVERLY_FERTILE) && !knotted_recipient.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(knotted_recipient)
		cum_into(oral = is_oral_knot, splashed_user = knotted_recipient, orifice = orifice, skip_knot_try = TRUE)
		return
	var/climax_msg = "[user] makes a mess!"
	var/modular_climax_msg = from_tailmaw ? null : modular_get_chastity_climax_message(climax_msg)
	if(istext(modular_climax_msg) && modular_climax_msg != climax_msg)
		user.chastity_visible_message(span_love(modular_climax_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_love(climax_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
	playsound(user, 'sound/misc/mat/endout.ogg', suppress_moan ? 12 : 50, TRUE, ignore_walls = FALSE)
	var/semen_vol = get_semen_volume()
	var/do_big_puddle = get_production_testicle_size() > DEFAULT_TESTICLES_SIZE
	modular_lay_eggs_on_climax()
	after_ejaculation()

	var/cur_loc = get_turf(user)
	if(!cur_loc || !isturf(cur_loc))
		return
	if(from_tailmaw || (!user.getorganslot(ORGAN_SLOT_PENIS) && user.getorganslot(ORGAN_SLOT_VAGINA)))
		spill_floor_fluid(cur_loc, /datum/reagent/erpjuice/femcum, 1, do_big_puddle)
	else
		spill_floor_fluid(cur_loc, /datum/reagent/erpjuice/cum, semen_vol + floor(get_oral_intake_extra_volume()), do_big_puddle)

/datum/sex_controller/proc/ejaculate_container(obj/item/reagent_containers/glass/C)
	if(try_resist_orgasm())
		return
	if(C && istype(C))
		log_combat(user, user, "Ejaculated into a container")
		user.visible_message(span_love("[user] spills into [C]!"))
		playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
		if(user.getorganslot(ORGAN_SLOT_PENIS))
			C.reagents.add_reagent(/datum/reagent/erpjuice/cum, get_semen_volume() + floor(get_oral_intake_extra_volume()))
		else
			C.reagents.add_reagent(/datum/reagent/erpjuice/femcum, 2)
	after_ejaculation()

/datum/sex_controller/proc/get_semen_volume()
	var/production_size = get_production_testicle_size()
	if(!isnum(production_size))
		return 0
	var/volume
	switch(production_size)
		if(MIN_TESTICLES_SIZE)
			volume = 2
		if(MAX_TESTICLES_SIZE)
			volume = 4
		else
			volume = 3

	var/obj/item/organ/penis/shaft = user.getorganslot(ORGAN_SLOT_PENIS)
	if(shaft?.penis_type in list(PENIS_TYPE_KNOTTED, PENIS_TYPE_EQUINE, PENIS_TYPE_EQUINE_KNOTTED, PENIS_TYPE_TAPERED_KNOTTED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED))
		volume += 1

	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		volume *= 1.5
	if(HAS_TRAIT(user, TRAIT_BIGGUY))
		volume *= 1.5
	if(is_species(user, /datum/species/gnoll))
		volume *= 1.5
	return floor(volume)

/datum/sex_controller/proc/get_load_bursts()
	switch(get_semen_volume())
		if(3, 4)
			return 2
		if(5, 6)
			return 3
		if(7, 8)
			return 4
		if(9 to INFINITY)
			return 5
		else
			return 1

/datum/sex_controller/proc/get_max_loads()
	if(!ishuman(user) || QDELETED(user))
		return 0
	var/con = user.STACON
	var/minimum_loads = 3
	var/production_size = get_production_testicle_size()
	if(isnum(production_size))
		switch(production_size)
			if(MIN_TESTICLES_SIZE)
				minimum_loads = 2
			if(MAX_TESTICLES_SIZE)
				minimum_loads = 4
	var/loads = minimum_loads + floor(clamp((con - 10) * 2, 0, 99) / 2)
	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		loads *= 1.5
	if(HAS_TRAIT(user, TRAIT_BIGGUY))
		loads *= 1.5
	if(is_species(user, /datum/species/gnoll))
		loads *= 1.5
	return floor(loads)

/// Returns the max charge based on dynamic load count
/datum/sex_controller/proc/get_max_charge()
	return get_max_loads() * CHARGE_FOR_CLIMAX

/// Account pairings are kept in memory for this round only; nothing is saved to disk.
GLOBAL_LIST_EMPTY(panel_triumph_pairs)
GLOBAL_LIST_EMPTY(panel_triumph_received)

/// Shared reward for each eligible pairing, independently capped for each player.
/datum/sex_controller/proc/reward_panel_climax(mob/living/carbon/human/partner)
	if(QDELETED(user) || QDELETED(partner) || user == partner)
		return
	if(!user.client || !partner.client || !user.ckey || !partner.ckey || user.ckey == partner.ckey)
		return
	var/pair_key = sorttext(user.ckey, partner.ckey) > 0 ? "[user.ckey]:[partner.ckey]" : "[partner.ckey]:[user.ckey]"
	if(GLOB.panel_triumph_pairs[pair_key])
		return
	// Claim the pair before awarding either player, including when both climax together.
	GLOB.panel_triumph_pairs[pair_key] = TRUE
	// Each player has their own cap; a capped partner does not block the other's reward.
	for(var/mob/living/carbon/human/recipient in list(user, partner))
		var/received = GLOB.panel_triumph_received[recipient.ckey]
		if(isnull(received))
			received = 0
		if(received >= 3)
			continue
		GLOB.panel_triumph_received[recipient.ckey] = received + 1
		recipient.adjust_triumphs(1)

/// Stop tracking immediately on cancellation, completion or controller deletion.
/datum/sex_controller/proc/clear_panel_triumph_action()
	if(ishuman(panel_triumph_target) && !QDELETED(panel_triumph_target) && panel_triumph_target.sexcon)
		LAZYREMOVE(panel_triumph_target.sexcon.panel_triumph_actions, src)
	panel_triumph_target = null

/// A selected target alone does not qualify; require a live partnered action.
/datum/sex_controller/proc/has_partnered_vice_action()
	if(!ishuman(user) || QDELETED(user))
		return FALSE
	if(current_action)
		var/datum/sex_action/own_action = SEX_ACTION(current_action)
		if(istype(own_action) && own_action.solo)
			return FALSE
	var/list/active_actions = panel_triumph_actions ? panel_triumph_actions.Copy() : list()
	if(panel_triumph_target)
		active_actions |= src
	for(var/datum/sex_controller/action_controller in active_actions)
		if(QDELETED(action_controller))
			continue
		action_controller.expire_panel_action()
		if(!action_controller.current_action || action_controller.desire_stop)
			continue
		var/mob/living/carbon/human/actor = action_controller.user
		var/mob/living/carbon/human/recipient = action_controller.panel_triumph_target
		if(!ishuman(actor) || QDELETED(actor) || !ishuman(recipient) || QDELETED(recipient) || actor == recipient || actor.sexcon != action_controller || action_controller.target != recipient)
			continue
		if(user != actor && user != recipient)
			continue
		var/mob/living/carbon/human/partner = user == actor ? recipient : actor
		if(!partner.client)
			continue
		var/datum/sex_action/action = SEX_ACTION(action_controller.current_action)
		if(!istype(action) || action.solo)
			continue
		if(action_controller.can_perform_action(action_controller.current_action, actor.incapacitated()))
			return TRUE
	return FALSE

/// A climax qualifies while participating in a valid partnered panel action, regardless of its cause.
/datum/sex_controller/proc/reward_active_panel_climax()
	var/list/active_actions = panel_triumph_actions ? panel_triumph_actions.Copy() : list()
	if(panel_triumph_target)
		active_actions |= src
	for(var/datum/sex_controller/action_controller in active_actions)
		if(QDELETED(action_controller) || !action_controller.current_action || action_controller.desire_stop)
			continue
		var/mob/living/carbon/human/actor = action_controller.user
		var/mob/living/carbon/human/recipient = action_controller.panel_triumph_target
		if(QDELETED(actor) || QDELETED(recipient) || action_controller.target != recipient)
			continue
		if(user != actor && user != recipient)
			continue
		if(!action_controller.can_perform_action(action_controller.current_action, actor.incapacitated()))
			continue
		reward_panel_climax(user == actor ? recipient : actor)

/datum/sex_controller/proc/after_ejaculation(consume_charge = TRUE)
	user.remove_stress(/datum/stressevent/denied_release)
	set_arousal(40)
	if(consume_charge)
		adjust_charge(-CHARGE_FOR_CLIMAX)
	else
		to_chat(user, span_love("<i>Spurt!</i>"))
	if(user.has_status_effect(/datum/status_effect/debuff/false_sensation))
		to_chat(user, span_warning("Not enough..."))
	else
		if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
			user.sate_addiction(/datum/charflaw/addiction/lovefiend)
		if(user.has_flaw(/datum/charflaw/addiction/baothamarked))
			user.sate_addiction(/datum/charflaw/addiction/baothamarked)
	user.add_stress(/datum/stressevent/cumok)
	user.emote("sexmoanhvy", forced = TRUE)
	user.playsound_local(user, 'sound/misc/mat/end.ogg', 100)
	try_xylix_confetti_climax()
	last_ejaculation_time = world.time
	if(consume_charge)
		reward_active_panel_climax()
	record_round_statistic(STATS_PLEASURES)

/datum/sex_controller/proc/try_xylix_confetti_climax()
	if(user?.patron?.type != /datum/patron/divine/xylix)
		return
	if(user.get_skill_level(/datum/skill/magic/holy) < SKILL_LEVEL_NOVICE)
		return
	var/trigger_chance = user.has_status_effect(/datum/status_effect/debuff/emberwine) ? 2 : 1
	if(!prob(trigger_chance))
		return
	var/turf/center = get_turf(user)
	if(!center)
		return
	playsound(user, 'sound/misc/xylixconfetti.ogg', 50, TRUE, ignore_walls = FALSE)
	if(user.has_status_effect(/datum/status_effect/debuff/emberwine))
		for(var/turf/T in RANGE_TURFS(1, center))
			new /obj/effect/decal/cleanable/confetti/xylix(T)
		return

	var/turf/front = get_step(center, user.dir)
	if(!front)
		front = center
	var/left_dir = turn(user.dir, 90)
	var/right_dir = turn(user.dir, -90)
	var/turf/left = get_step(front, left_dir)
	var/turf/right = get_step(front, right_dir)
	new /obj/effect/decal/cleanable/confetti/xylix(front)
	if(left)
		new /obj/effect/decal/cleanable/confetti/xylix(left)
	if(right)
		new /obj/effect/decal/cleanable/confetti/xylix(right)

/datum/sex_controller/proc/after_intimate_climax(oral, mob/living/carbon/human/climax_target = null)
	var/mob/living/carbon/human/effective_target = climax_target || target
	if(user == effective_target || isnull(effective_target) || !istype(effective_target) || QDELETED(effective_target))
		return
	var/user_goodlover = HAS_TRAIT(user, TRAIT_GOODLOVER)
	var/target_goodlover = HAS_TRAIT(effective_target, TRAIT_GOODLOVER)
	if(!oral)
		if(target_goodlover)
			if(!user.mob_timers["cumtri"])
				user.mob_timers["cumtri"] = world.time
				user.adjust_triumphs(1)
				to_chat(user, span_love("Our loving is a true TRIUMPH!"))
		if(user_goodlover)
			if(!effective_target.mob_timers["cumtri"])
				effective_target.mob_timers["cumtri"] = world.time
				effective_target.adjust_triumphs(1)
				to_chat(effective_target, span_love("Our loving is a true TRIUMPH!"))
	var/user_beautiful = HAS_TRAIT(user, TRAIT_BEAUTIFUL)
	var/user_ugly = HAS_TRAIT(user, TRAIT_UNSEEMLY) || HAS_TRAIT(user, TRAIT_DISFIGURED)
	var/target_beautiful = HAS_TRAIT(effective_target, TRAIT_BEAUTIFUL)
	var/target_ugly = HAS_TRAIT(effective_target, TRAIT_UNSEEMLY) || HAS_TRAIT(effective_target, TRAIT_DISFIGURED)
	if(user_ugly && target_ugly || user_beautiful && target_beautiful) // both are ugly/beautiful, add made love buff
		user.add_stress(/datum/stressevent/cummax)
		effective_target.add_stress(/datum/stressevent/cummax)
	else // one of them is ugly, add debuff to non-ugly character
		if(target_ugly && !user_ugly && !user_goodlover) // good lover are immune to ugly characters
			if(user_beautiful) // stress event last longer
				user.add_stress(/datum/stressevent/unseemly_made_love/beautiful)
			else
				user.add_stress(/datum/stressevent/unseemly_made_love)
			effective_target.add_stress(/datum/stressevent/cummax)
		if(user_ugly && !target_ugly && !target_goodlover) // good lover are immune to ugly characters
			if(target_beautiful) // stress event last longer
				effective_target.add_stress(/datum/stressevent/unseemly_made_love/beautiful)
			else
				effective_target.add_stress(/datum/stressevent/unseemly_made_love)
			user.add_stress(/datum/stressevent/cummax)
	if(!oral && force >= SEX_FORCE_HIGH && (user.has_flaw(/datum/charflaw/addiction/sadist) || effective_target.has_flaw(/datum/charflaw/addiction/masochist)))
		// Original call retained for rollback; use a softer critical pain sound for quirk holders while retaining vice satisfaction.
		// effective_target.emote("paincrit", forced = TRUE) // this satiates the sadomasochists in range
		effective_target.panel_pain_emote("paincrit", forced = TRUE)
	if(ishuman(user) && ishuman(target) && user.client && target.client)
		eora_register_consensual_pair(user, target)

/datum/sex_controller/proc/just_ejaculated()
	return (last_ejaculation_time + 2 SECONDS >= world.time)

/datum/sex_controller/proc/set_charge(amount)
	var/empty = (charge < CHARGE_FOR_CLIMAX)
	charge = clamp(amount, 0, get_max_charge())
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

/datum/sex_controller/proc/try_apply_false_sensation()
	if(!user.has_flaw(/datum/charflaw/addiction/lovefiend) && !user.has_flaw(/datum/charflaw/addiction/baothamarked))
		return
	if(!user.has_status_effect(/datum/status_effect/debuff/false_sensation)) // So chat isn't spammed
		to_chat(user, span_warning("My arousal is hollow and false. It won't sate my urges."))
	user.apply_status_effect(/datum/status_effect/debuff/false_sensation)

/datum/sex_controller/proc/update_erect_state()
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)

	if(user.mind)
		var/datum/antagonist/werewolf/W = user.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(W && W.transformed == TRUE)
			user.regenerate_icons()

	if(penis && hascall(penis, "update_erect_state"))
		penis.update_erect_state()
	var/obj/item/organ/tail/manticore/tail = get_manticore_tail(user)
	tail?.update_maw_state()
	// The oviduct reads arousal directly; the body cache detects sprite changes.
	var/obj/item/organ/vagina/vagina = user.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina?.accessory_type == /datum/sprite_accessory/vagina/bee_tail)
		user.update_body_parts()

/datum/sex_controller/proc/update_exposure()
	user.regenerate_icons()

/datum/sex_controller/proc/adjust_arousal(amount, apply_sensitivity = TRUE)
	if(amount > 0 && apply_sensitivity)
		if(HAS_TRAIT(user, TRAIT_HEIGHTENED_SENSITIVITY))
			amount *= 4
		else if(HAS_TRAIT(user, TRAIT_DULLED_SENSITIVITY))
			amount *= 0.5
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
		if(SEX_FORCE_LUDICROUS)
			oxyloss_multiplier = 3.0
	oxyloss_amt *= oxyloss_multiplier
	if(oxyloss_amt <= 0)
		return
	// Original direct damage call retained for rollback; the helper applies the quirk resistance.
	// action_target.adjustOxyLoss(oxyloss_amt)
	action_target.adjust_panel_oxygen_loss(oxyloss_amt)

/// Keep this resistance scoped to panel mechanics, without changing general oxygen damage or healing.
/mob/living/carbon/human/proc/adjust_panel_oxygen_loss(amount)
	if(amount > 0 && HAS_TRAIT(src, TRAIT_RESILIENT_LOVER))
		amount /= 3
	return adjustOxyLoss(amount)

/// Scale only panel brute damage, so its contribution to bodily pain is reduced once.
/mob/living/carbon/human/proc/apply_panel_brute_damage(amount, zone)
	if(amount > 0 && HAS_TRAIT(src, TRAIT_RESILIENT_LOVER))
		amount /= 3
	return apply_damage(amount, BRUTE, zone)

/// Suppress panel pain text without changing combat messages or damage flashes.
/mob/living/carbon/human/proc/show_panel_pain_message(message, visible = FALSE, respect_quirk = TRUE)
	if(respect_quirk && HAS_TRAIT(src, TRAIT_RESILIENT_LOVER))
		return
	if(visible)
		return visible_message(message)
	return to_chat(src, message)

/// Keep ordinary panel emotes; substitute only the quirk holder's critical pain sound.
/mob/living/carbon/human/proc/panel_pain_emote(emote_name, forced = FALSE)
	if(emote_name == "paincrit" && HAS_TRAIT(src, TRAIT_RESILIENT_LOVER))
		return emote("resilientlovergroan", forced = forced)
	return emote(emote_name, forced = forced)

/// Inherit paincrit's successful-emote vice satisfaction, audience and eligibility unchanged.
/// Its original audio-only presentation also avoids adding another chat message.
/datum/emote/living/paincrit/resilientlover
	key = "resilientlovergroan"
	key_third_person = ""

/datum/emote/living/paincrit/resilientlover/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	if(intentional || !HAS_TRAIT(user, TRAIT_RESILIENT_LOVER))
		return FALSE
	return ..()

/datum/emote/living/paincrit/resilientlover/get_sound(mob/user)
	// Use the normal groan lookup, including the character's voice and muffling rules.
	for(var/datum/emote/living/groan/groan_emote in GLOB.emote_list["groan"])
		return groan_emote.get_sound(user)

/// Used by tiny penises to halve target arousal gain while doubling the users
/datum/sex_controller/proc/get_penis_size_arousal_multiplier(mob/living/carbon/human/action_target)
	if(!current_action || (action_target != user && action_target != target))
		return 1
	var/datum/sex_action/action = SEX_ACTION(current_action)
	if(!action)
		return 1
	var/multiplier = 1
	if((action.user_sex_part & SEX_PART_COCK) || (user == target && (action.target_sex_part & SEX_PART_COCK)))
		var/obj/item/organ/penis/user_penis = user.getorganslot(ORGAN_SLOT_PENIS)
		if(user_penis)
			multiplier *= user_penis.get_size_arousal_multiplier(action_target)
	if(target != user && (action.target_sex_part & SEX_PART_COCK))
		var/obj/item/organ/penis/target_penis = target?.getorganslot(ORGAN_SLOT_PENIS)
		if(target_penis)
			multiplier *= target_penis.get_size_arousal_multiplier(action_target)
	return multiplier

/datum/sex_controller/proc/perform_sex_action(mob/living/carbon/human/action_target, arousal_amt, pain_amt, giving, obj/item/organ/penis/involved_penis = null, apply_sensitivity = TRUE)
	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		arousal_amt *= 1.5
		if(prob(10))
			var/list/lover_list = list("This feels so good!","I am in heaven!","This is too good to be possible!","I can't stop, too good!")
			switch(action_target.patron?.type)
				if(/datum/patron/old_god)
					lover_list += "By PSYDON!"
				if(/datum/patron/inhumen/zizo)
					lover_list += "By ZIZO!"
				if(/datum/patron/inhumen/graggar)
					lover_list += "By GRAGGAR!"
				if(/datum/patron/inhumen/matthios)
					lover_list += "By MATTHIOS!"
				if(/datum/patron/inhumen/baotha)
					lover_list += "By BAOTHA!"
				else
					lover_list += "By the ten!"
			to_chat(action_target, span_love(pick(lover_list)))
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			pain_amt *= 2
	var/list/modular_adjustments = modular_adjust_action_for_target_chastity(action_target, arousal_amt, pain_amt)
	if(islist(modular_adjustments) && modular_adjustments.len >= 2)
		arousal_amt = modular_adjustments[1]
		pain_amt = modular_adjustments[2]
	if(arousal_amt > 0 && !(apply_sensitivity && (HAS_TRAIT(action_target, TRAIT_HEIGHTENED_SENSITIVITY) || HAS_TRAIT(action_target, TRAIT_DULLED_SENSITIVITY))))
		if(involved_penis)
			arousal_amt *= involved_penis.get_size_arousal_multiplier(action_target)
		else
			arousal_amt *= get_penis_size_arousal_multiplier(action_target)
	action_target.sexcon.receive_sex_action(arousal_amt, pain_amt, giving, force, speed, apply_sensitivity)
	/// modular signal to let other systems know about the sex action, currently used for chastity course to track arousal and apply pain, but can be used for other things in the future
	modular_emit_received_sex_action_signal(action_target, arousal_amt, pain_amt, giving)
	if(modular_should_play_chastitycourse_noise(action_target))
		chastitycourse_noise(action_target)

/datum/sex_controller/proc/receive_sex_action(arousal_amt, pain_amt, giving, applied_force, applied_speed, apply_sensitivity = TRUE)
	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		arousal_amt = 0
		pain_amt = 0

	if(!arousal_frozen)
		adjust_arousal(arousal_amt, apply_sensitivity)

	damage_from_pain(pain_amt)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving, TRUE)

// Original signature retained; the passive restraint call opts out of panel resistance.
// /datum/sex_controller/proc/damage_from_pain(pain_amt)
/datum/sex_controller/proc/damage_from_pain(pain_amt, panel_action = TRUE)
	if(pain_amt < PAIN_MINIMUM_FOR_DAMAGE)
		return
	var/damage = (pain_amt / PAIN_DAMAGE_DIVISOR)
	var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	if(!part)
		return
	// Original call retained for rollback; reduce panel damage once, including pain-derived damage.
	// user.apply_damage(damage, BRUTE, part)
	if(panel_action)
		user.apply_panel_brute_damage(damage, part)
	else
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

// Original signature retained; passive restraint complaints are not panel actions.
// /datum/sex_controller/proc/try_do_pain_effect(pain_amt, giving, allow_intimate_item_reaction = FALSE)
/datum/sex_controller/proc/try_do_pain_effect(pain_amt, giving, allow_intimate_item_reaction = FALSE, panel_action = TRUE)
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
		// Original call retained for rollback; suppress automatic pain text for this quirk.
		// to_chat(user, span_boldwarning(pain_msg))
		user.show_panel_pain_message(span_boldwarning(pain_msg), respect_quirk = panel_action)
		user.fullscreen_redflash("redflash2")
		if(prob(70) && user.stat == CONSCIOUS)
			// Original call retained for rollback; suppress automatic pain text for this quirk.
			// user.visible_message(span_warning("[user] shudders in pain!"))
			user.show_panel_pain_message(span_warning("[user] shudders in pain!"), visible = TRUE, respect_quirk = panel_action)
	else if(pain_amt >= PAIN_MED_EFFECT)
		var/pain_msg = pick(list("It hurts!", "It pains me!"))
		// Original call retained for rollback; suppress automatic pain text for this quirk.
		// to_chat(user, span_boldwarning(pain_msg))
		user.show_panel_pain_message(span_boldwarning(pain_msg), respect_quirk = panel_action)
		user.fullscreen_redflash("redflash1")
		if(prob(40) && user.stat == CONSCIOUS)
			// Original call retained for rollback; suppress automatic pain text for this quirk.
			// user.visible_message(span_warning("[user] shudders in pain!"))
			user.show_panel_pain_message(span_warning("[user] shudders in pain!"), visible = TRUE, respect_quirk = panel_action)
	else if(pain_amt >= PAIN_MILD_EFFECT)
		var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
		// Original call retained for rollback; suppress automatic pain text for this quirk.
		// to_chat(user, span_warning(pain_msg))
		user.show_panel_pain_message(span_warning(pain_msg), respect_quirk = panel_action)

/datum/sex_controller/proc/check_active_ejaculation()
	if(arousal < ACTIVE_EJAC_THRESHOLD)
		return FALSE
	if(is_spent())
		return FALSE
	if(!can_ejaculate())
		return FALSE
	if(try_deny_panel_climax())
		return FALSE
	return TRUE

/// Reuse paired-action tracking; only examine participants when a climax is attempted.
/datum/sex_controller/proc/try_deny_panel_climax()
	if(!user?.client?.prefs?.edging || !user.client.prefs.sexable || user.stat == DEAD)
		return FALSE
	if(!panel_triumph_target && !length(panel_triumph_actions))
		return FALSE
	var/list/active_actions = panel_triumph_actions ? panel_triumph_actions.Copy() : list()
	if(panel_triumph_target)
		active_actions |= src
	for(var/datum/sex_controller/action_controller in active_actions)
		if(QDELETED(action_controller) || !action_controller.current_action || action_controller.desire_stop)
			continue
		var/mob/living/carbon/human/actor = action_controller.user
		var/mob/living/carbon/human/recipient = action_controller.panel_triumph_target
		if(QDELETED(actor) || QDELETED(recipient) || actor == recipient || action_controller.target != recipient)
			continue
		if(user != actor && user != recipient)
			continue
		var/mob/living/carbon/human/partner = user == actor ? recipient : actor
		if(!partner.client?.prefs?.sexable || partner.stat == DEAD || !partner.sexcon?.deny_partner_climax || !HAS_TRAIT(partner, TRAIT_ORGASM_DENIER))
			continue
		if(!action_controller.can_perform_action(action_controller.current_action, actor.incapacitated()))
			continue
		set_arousal(30)
		user.add_stress(/datum/stressevent/denied_release)
		to_chat(user, span_info(span_italics("Just as release draws near, [partner] holds me back. The feeling fades, leaving me frustrated.")))
		to_chat(partner, span_info(span_italics("I hold [user] back from release, leaving them frustrated.")))
		return TRUE
	return FALSE

/datum/sex_controller/proc/can_ejaculate()
	if(!user.getorganslot(ORGAN_SLOT_TESTICLES) && !user.getorganslot(ORGAN_SLOT_VAGINA) && !get_manticore_tail(user))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	return TRUE

/datum/sex_controller/proc/handle_passive_ejaculation(mob/living/carbon/human/splashed_user = null, climax_part = SEX_PART_NULL)
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
				// Original call retained; passive restraint pain is outside panel-action protection.
				// damage_from_pain(chaffepain)
				damage_from_pain(chaffepain, panel_action = FALSE)
				// Original call retained; passive restraint pain is outside panel-action protection.
				// try_do_pain_effect(chaffepain)
				try_do_pain_effect(chaffepain, panel_action = FALSE)
				last_moan = 0
				M.visible_message(("<span class='love_mid'>[M] squirms uncomfortably in [M.p_their()] restraints.</span>"), \
					("<span class='love_extreme'>I feel [M.handcuffed] rub uncomfortably against my skin.</span>"))
			if(arousal < ACTIVE_EJAC_THRESHOLD)
				adjust_arousal(0.25)
			else
				if(prob(3))
					if(try_deny_panel_climax())
						return
					if(has_pending_panel_climax())
						return
					ejaculate(climax_part)
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
	if(try_deny_panel_climax())
		return
	if(has_pending_panel_climax())
		return
	ejaculate(climax_part)
	if(splashed_user)
		var/datum/status_effect/facial/facial = splashed_user.has_status_effect(/datum/status_effect/facial)
		if(!facial)
			splashed_user.apply_status_effect(/datum/status_effect/facial)
		else
			facial.refresh_cum()
		modular_record_collar_receive_event(splashed_user, user)

/// Let the scheduled action perform its own completion without replaying an
/// action tick here. The donor may be receiving an action, not initiating one.
/datum/sex_controller/proc/has_pending_panel_climax()
	if(!ishuman(user) || QDELETED(user) || is_spent() || !can_ejaculate())
		return FALSE
	var/list/active_actions = list(src)
	if(panel_triumph_actions)
		active_actions |= panel_triumph_actions
	for(var/datum/sex_controller/action_controller in active_actions)
		if(QDELETED(action_controller))
			continue
		action_controller.expire_panel_action()
		if(!action_controller.current_action || action_controller.desire_stop)
			continue
		var/mob/living/carbon/human/actor = action_controller.user
		var/mob/living/carbon/human/recipient = action_controller.target
		if(!ishuman(actor) || QDELETED(actor) || !ishuman(recipient) || QDELETED(recipient) || actor.sexcon != action_controller)
			continue
		if(!actor.client?.prefs?.sexable || !recipient.client?.prefs?.sexable)
			continue
		var/datum/sex_action/action = SEX_ACTION(action_controller.current_action)
		if(!istype(action) || arousal < action.climax_arousal_threshold)
			continue
		if(!((user == actor && action.handles_user_climax) || (user == recipient && action.handles_target_climax)))
			continue
		// Retargeting clears this captured partner before the old loop exits.
		if(!action.solo && action_controller.panel_triumph_target != recipient)
			continue
		if(!action_controller.can_perform_action(action_controller.current_action, actor.incapacitated()))
			continue
		// on_perform may still be delivering another participant's bursts even
		// after is_finished becomes true. Let loop cleanup release this priority.
		return TRUE
	return FALSE

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
	expire_panel_action()
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

/// Fixed cells keep changing labels and conditional controls from moving adjacent links.
/datum/sex_controller/proc/get_controls_html()
	var/list/dat = list()
	var/force_name = get_force_string()
	var/speed_name = get_speed_string()
	var/manual_arousal_name = get_manual_arousal_string()
	var/obj/item/organ/penis/got_cock = user.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/vagina/got_pussy = user.getorganslot(ORGAN_SLOT_VAGINA)
	dat += {"<style>
		.sexcon-settings { width: 100%; table-layout: fixed; border-spacing: 4px; margin: 0; }
		.sexcon-settings td { padding: 0; text-align: center; vertical-align: middle; }
		.sexcon-settings .sexcon-control { height: 26px; }
		.sexcon-settings .sexcon-label { display: block; background: none; border: none; margin: 0; padding: 0; font-size: 11px; line-height: 16px; }
		.sexcon-settings .sexcon-toggle { display: block; box-sizing: border-box; height: 26px; margin: 0; padding: 2px 3px; font-size: 13px; line-height: 20px; white-space: nowrap; }
		.sexcon-settings .sexcon-placeholder { background: #00000066; border: 1px solid #000000; }
		.sexcon-stepper { display: table; width: 100%; height: 30px; table-layout: fixed; }
		.sexcon-stepper a { display: table-cell; width: 20px; margin: 0; padding: 0; font-size: 16px; line-height: 28px; }
		.sexcon-stepper .sexcon-value { display: table-cell; width: auto; font-size: 12px; line-height: 13px; vertical-align: middle; word-wrap: normal; }
	</style>"}
	dat += "<table class='sexcon-settings'><colgroup><col style='width: 37%'><col style='width: 26%'><col style='width: 37%'></colgroup><tr>"
	dat += "<td><a class='sexcon-label' href='?src=[REF(src)];task=speed_up' oncontextmenu='window.location.href=\"?src=[REF(src)];task=speed_down\";return false;' title='Left-click to increase; right-click to decrease'>SPEED</a><div class='sexcon-stepper'><a href='?src=[REF(src)];task=speed_down'>&lt;</a><a class='sexcon-value' href='?src=[REF(src)];task=speed_up' oncontextmenu='window.location.href=\"?src=[REF(src)];task=speed_down\";return false;' title='Left-click to increase; right-click to decrease'>[speed_name]</a><a href='?src=[REF(src)];task=speed_up'>&gt;</a></div></td>"
	dat += "<td><a class='sexcon-label' href='?src=[REF(src)];task=force_up' oncontextmenu='window.location.href=\"?src=[REF(src)];task=force_down\";return false;' title='Left-click to increase; right-click to decrease'>FORCE</a><div class='sexcon-stepper'><a href='?src=[REF(src)];task=force_down'>&lt;</a><a class='sexcon-value' href='?src=[REF(src)];task=force_up' oncontextmenu='window.location.href=\"?src=[REF(src)];task=force_down\";return false;' title='Left-click to increase; right-click to decrease'>[force_name]</a><a href='?src=[REF(src)];task=force_up'>&gt;</a></div></td>"
	dat += "<td>"
	if(got_cock)
		dat += "<a class='sexcon-label' href='?src=[REF(src)];task=manual_arousal_up' oncontextmenu='window.location.href=\"?src=[REF(src)];task=manual_arousal_down\";return false;' title='Left-click to increase; right-click to decrease'>AROUSAL</a><div class='sexcon-stepper'><a href='?src=[REF(src)];task=manual_arousal_down'>&lt;</a><a class='sexcon-value' href='?src=[REF(src)];task=manual_arousal_up' oncontextmenu='window.location.href=\"?src=[REF(src)];task=manual_arousal_down\";return false;' title='Left-click to increase; right-click to decrease'>[manual_arousal_name]</a><a href='?src=[REF(src)];task=manual_arousal_up'>&gt;</a></div>"
	dat += "</td></tr></table>"
	dat += "<table class='sexcon-settings'><tr>"
	dat += "<td class='sexcon-control'><a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_freeuse'>[freeuse ? "FREEUSE ON" : "FREEUSE OFF"]</a></td>"
	dat += "<td class='sexcon-control'><a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_subtle'>[do_subtle_action ? "DOING SUBTLY" : "DOING VISIBLY"]</a></td>"
	dat += "<td class='sexcon-control'>"
	if(got_cock || got_pussy || user.getorganslot(ORGAN_SLOT_TESTICLES))
		dat += "<a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_hide_pintle_visuals' title='Show or hide genital sprites. This does not change physical access or examine descriptions.'>GENITALS [hide_pintle_visuals ? "HIDDEN" : "VISIBLE"]</a>"
	dat += "</td></tr></table>"
	dat += "<table class='sexcon-settings'><tr>"
	dat += "<td class='sexcon-control'><a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_finished'>[do_until_finished ? "UNTIL IM FINISHED" : "UNTIL I STOP"]</a></td>"
	dat += "<td class='sexcon-control'><a class='sexcon-toggle' href='?src=[REF(src)];task=set_arousal'>SET AROUSAL</a></td></tr><tr>"
	dat += "<td class='sexcon-control'><a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_bottom_exposed' title='Expose the crotch through clothing for access, examine descriptions, and permitted sprites.'>CROTCH [bottom_exposed ? "EXPOSED" : "CONCEALED"]</a></td>"
	dat += "<td class='sexcon-control'><a class='sexcon-toggle' href='?src=[REF(src)];task=freeze_arousal'>[arousal_frozen ? "UNFREEZE AROUSAL" : "FREEZE AROUSAL"]</a></td></tr></table>"
	var/knot_control = "<span class='sexcon-toggle sexcon-placeholder'></span>"
	if(current_action && !desire_stop)
		var/datum/sex_action/action = SEX_ACTION(current_action)
		if(action.knot_on_finish)
			if((action.user_sex_part & SEX_PART_COCK) && knot_penis_type())
				knot_control = "<a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_knot'><font color='[do_knot_action ? "#d146f5" : "#eac8de"]'>[do_knot_action ? "USING KNOT" : "NOT USING KNOT"]</font></a>"
			else if((action.target_sex_part & SEX_PART_COCK) && target?.sexcon?.knot_penis_type())
				knot_control = "<a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_knot_bottom'><font color='[do_knot_action_as_bottom ? "#d146f5" : "#eac8de"]'>[do_knot_action_as_bottom ? "FORCING KNOT" : "NOT FORCING KNOT"]</font></a>"
	dat += "<table class='sexcon-settings'><tr><td class='sexcon-control'>"
	if(HAS_TRAIT(user, TRAIT_ORGASM_DENIER))
		dat += "<a class='sexcon-toggle' href='?src=[REF(src)];task=toggle_partner_denial'>ORGASM DENIAL: [deny_partner_climax ? "ON" : "OFF"]</a>"
	else
		dat += "<span class='sexcon-toggle sexcon-placeholder'></span>"
	dat += "</td><td class='sexcon-control'>[knot_control]</td></tr></table>"
	return dat.Join()

/datum/sex_controller/proc/show_ui()
	var/list/dat = list()
	dat += get_controls_html()
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
		dat += "<td>"
		var/link = ""
		if(!can_perform_action(action_type, user_is_incapacitated))
			link = "linkOff"
		if(current_action == action_type)
			link = "linkOn"
		dat += "<center><a class='[link]' href='?src=[REF(src)];task=action;action_type=[action_type]'>[action.get_display_name(user, target)]</a></center>"
		dat += "</td>"
		i++
		if(i >= 2)
			i = 0
			dat += "</tr><tr>"

	dat += "</tr></table>"
	var/datum/browser/popup = new(user, "sexcon", "<center>Sate Desire</center>", 560, 550)
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
		if("toggle_partner_denial")
			if(HAS_TRAIT(user, TRAIT_ORGASM_DENIER))
				deny_partner_climax = !deny_partner_climax
		if("toggle_bottom_exposed")
			if(user.incapacitated(ignore_restraints = TRUE))
				to_chat(user, span_warning("I can't do that right now!"))
			else
				bottom_exposed = !bottom_exposed
				update_exposure()
		if("toggle_hide_pintle_visuals")
			hide_pintle_visuals = !hide_pintle_visuals
			update_exposure()
		if("toggle_freeuse")
			freeuse = !freeuse
			to_chat(user, span_notice("Positioning and exposure checks are now [freeuse ? "disabled" : "enabled"]."))
		if("set_arousal")
			var/amount = input(user, "Value above 120 will immediately cause orgasm!", "Set Arousal", arousal) as num
			if(!isnull(amount) && amount > arousal)
				try_apply_false_sensation()
			if(aphrodisiac > 1 && amount > 0)
				set_arousal(amount * aphrodisiac)
			else
				set_arousal(amount)
		if("freeze_arousal")
			if(aphrodisiac == 1)
				arousal_frozen = !arousal_frozen
				if(arousal > 60)
					try_apply_false_sensation()
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
		if("toggle_knot_bottom")
			do_knot_action_as_bottom = !do_knot_action_as_bottom
	show_ui()

/datum/sex_controller/proc/try_stop_current_action()
	clear_panel_triumph_action()
	if(!current_action)
		return
	desire_stop = TRUE
	user.doing = FALSE

/// Recover abandoned loops even when no completion is currently pending.
/datum/sex_controller/proc/expire_panel_action()
	if(current_action && world.time >= panel_action_deadline)
		stop_current_action()

/datum/sex_controller/proc/stop_current_action(session = null)
	if(!isnull(session) && session != panel_action_session)
		return
	clear_panel_triumph_action()
	if(!current_action)
		return
	var/datum/sex_action/action = SEX_ACTION(current_action)
	panel_action_session++
	panel_action_deadline = 0
	suppress_action_messages = FALSE
	desire_stop = FALSE
	if(ishuman(user) && !QDELETED(user))
		user.doing = FALSE
	orison_indulgence_notice_shown = FALSE
	current_action = null
	bed = null
	target_on_bed = FALSE
	table_or_pillory = null
	grassy_knoll = null
	collar_bell_user = FALSE
	collar_bell_target = FALSE
	popwarning = FALSE
	using_zones = list()
	// Clear state first: a failed finish callback must not strand this session.
	if(istype(action) && ishuman(user) && !QDELETED(user) && user.sexcon == src && !knotted_status && ishuman(target) && !QDELETED(target))
		action.on_finish(user, target)

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
	orison_indulgence_notice_shown = FALSE
	current_action = action_type
	bed = null
	target_on_bed = FALSE
	table_or_pillory = null
	grassy_knoll = null
	collar_bell_user = FALSE
	collar_bell_target = FALSE
	var/datum/sex_action/action = SEX_ACTION(current_action)
	if(!action.solo && target != user && target?.sexcon)
		panel_triumph_target = target
		LAZYOR(target.sexcon.panel_triumph_actions, src)
	log_combat(user, target, "Started sex action: [action.name]")
	panel_action_deadline = world.time + SEX_ACTION_PROGRESS_GRACE
	INVOKE_ASYNC(src, PROC_REF(sex_action_loop), ++panel_action_session)

/datum/sex_controller/proc/sex_action_loop(session)
	if(session != panel_action_session)
		return
	// Do action loop
	var/performed_action_type = current_action
	var/datum/sex_action/action = SEX_ACTION(current_action)
	var/base_speed = -1
	var/base_force = -1
	var/base_knot_mode = FALSE
	var/subtle_message_tick_counter = 0
	var/was_subtle_mode = do_subtle_action // By default, we set it to the same value as the panel toggle
	var/virgin_reaction_checked = FALSE
	show_progress = 1
	suppress_moan = FALSE
	action.on_start(user, target)
	find_occupying_furniture()
	find_occupying_grass()
	while(session == panel_action_session)
		if(!target?.client?.prefs?.sexable) // no prefs/sexability means we should safely stop the loop
			break
		var/stamina_cost = action.stamina_cost * get_stamina_cost_multiplier()
		var/athletics_xp = 0
		// Supply normal Athletics XP when the shared stamina system won't award it.
		if(stamina_cost > 0 && user.mind && !HAS_TRAIT(user, TRAIT_INFINITE_STAMINA) && !HAS_TRAIT(user, TRAIT_INFINITE_ENERGY))
			if(!(user.m_intent == MOVE_INTENT_RUN && (user.mobility_flags & MOBILITY_STAND) && isnull(user.buckled)))
				athletics_xp = user.STAINT * 0.02
		// Bad Drakian adjustment: halve panel stamina costs.
		if(!user.stamina_add(stamina_cost * 0.5, show_xp_popup = FALSE))
			break
		var/action_delay = action.do_time / get_speed_multiplier()
		panel_action_deadline = world.time + action_delay * user.do_after_coefficent() + SEX_ACTION_PROGRESS_GRACE
		if(!do_after(user, action_delay, target = target, progress = show_progress))
			break
		if(session != panel_action_session)
			return
		if(current_action == null || performed_action_type != current_action)
			break
		if(!can_perform_action(current_action, user.incapacitated()))
			break
		if(action.is_finished(user, target))
			break
		if(desire_stop)
			break
		var/current_knot_mode = FALSE
		if(action.knot_on_finish)
			if((action.user_sex_part & SEX_PART_COCK) && knot_penis_type())
				current_knot_mode = do_knot_action
			else if((action.target_sex_part & SEX_PART_COCK) && target?.sexcon?.knot_penis_type())
				current_knot_mode = do_knot_action_as_bottom
		var/show_action_message = (speed != base_speed || force != base_force)
		if(current_knot_mode != base_knot_mode)
			show_action_message = TRUE
		if(!do_subtle_action && was_subtle_mode)
			show_action_message = TRUE
		if(!show_action_message && do_subtle_action)
			subtle_message_tick_counter++
			if(subtle_message_tick_counter >= SEX_SUBTLE_MESSAGE_REPEAT_INTERVAL)
				show_action_message = TRUE
				subtle_message_tick_counter = 0
		else if(show_action_message)
			subtle_message_tick_counter = 0
		was_subtle_mode = do_subtle_action
		base_speed = speed
		base_force = force
		base_knot_mode = current_knot_mode
		suppress_action_messages = !show_action_message
		find_ringing_collar()
		if(athletics_xp > 0 && user.mind)
			user.mind.add_sleep_experience(/datum/skill/misc/athletics, athletics_xp, show_xp_popup = FALSE)
		// Shared body warmth stops just above the cold threshold.
		if(!action.solo && target != user)
			user.adjust_bodytemperature(3, max_temp = BODYTEMP_NORMAL_MIN + 5)
			target.adjust_bodytemperature(3, max_temp = BODYTEMP_NORMAL_MIN + 5)
			if(!virgin_reaction_checked)
				virgin_reaction_checked = TRUE
				user.react_to_virgin_affection(target)
				target.react_to_virgin_affection(user)
		// Existing delivery routines can sleep for up to ten one-second bursts.
		panel_action_deadline = world.time + SEX_ACTION_PROGRESS_GRACE
		action.on_perform(user, target)
		if(session != panel_action_session)
			return
		do_visual_effects(target, action)
		suppress_action_messages = FALSE
		// It could want to finish afterwards the performed action
		if(action.is_finished(user, target))
			break
		if(!action.continous)
			break
	stop_current_action(session)

/datum/sex_controller/proc/can_perform_action(action_type, incapacitated)
	if(!action_type)
		return FALSE
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(istype(action, /datum/sex_action/chastityplay) && !chastity_content_enabled_for_pair())
		return FALSE
	if(!inherent_perform_check(action_type, incapacitated))
		return FALSE
	if(!action.can_perform(user, target))
		return FALSE
	return TRUE

/datum/sex_controller/proc/chastity_content_enabled_for(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(!H.client?.prefs)
		return TRUE
	return !!H.client.prefs.chastenable

/datum/sex_controller/proc/chastity_content_enabled_for_pair()
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
	var/obj/item/clothing/neck/roguetown/collar
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
	if(new_target != target)
		clear_panel_triumph_action()
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
		if(SEX_SPEED_LUDICROUS)
			return 3

/datum/sex_controller/proc/get_stamina_cost_multiplier()
	switch(force)
		if(SEX_FORCE_LOW)
			return 1.0
		if(SEX_FORCE_MID)
			return 1.5
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 2.5
		if(SEX_FORCE_LUDICROUS)
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
		if(SEX_FORCE_LUDICROUS)
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
		if(SEX_FORCE_LUDICROUS)
			return 4.0

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
		if(SEX_SPEED_LUDICROUS)
			return 1.6

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
		if(SEX_FORCE_LUDICROUS)
			return "<font color='#d61a43'>FERAL</font>"
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
		if(SEX_SPEED_LUDICROUS)
			return "<font color='#d61a43'>FURIOUS</font>"
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

/datum/sex_controller/proc/get_knot_synonym()
	return pick(list("knot", "knot", "bulb", "plug"))

/datum/sex_controller/proc/get_generic_force_adjective(is_stealth = FALSE)
	if(is_stealth)
		return pick(stealth_force_adjectives)
	switch(force)
		if(SEX_FORCE_LOW)
			return pick(low_force_adjectives)
		if(SEX_FORCE_MID)
			return pick(mid_force_adjectives)
		if(SEX_FORCE_HIGH)
			return pick(high_force_adjectives)
		if(SEX_FORCE_EXTREME)
			return pick(extreme_force_adjectives)
		if(SEX_FORCE_LUDICROUS)
			return pick(ludicrous_force_adjectives)

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
		if(SEX_FORCE_LUDICROUS)
			return "<span class='love_ludicrous'>[string]</span>"

/datum/sex_controller/proc/try_pelvis_crush(mob/living/carbon/human/target)
	if(istype(user.rmb_intent, /datum/rmb_intent/strong) && force > SEX_FORCE_MID)
		if(prob(10) && !target.has_status_effect(/datum/status_effect/quivering))
			target.apply_status_effect(/datum/status_effect/quivering)
			target.confused += 25
			target.OffBalance(30 SECONDS)
		if(user?.client?.prefs?.extreme_erp && target?.client?.prefs?.extreme_erp)
			// Original fracture check retained for rollback.
			// if(!target.has_wound(/datum/wound/fracture/groin))
			// Protect only the fracture; the other effects of this action still apply.
			if(!HAS_TRAIT(target, TRAIT_RESILIENT_LOVER) && !target.has_wound(/datum/wound/fracture/groin))
				if(prob(10))
					var/obj/item/bodypart/groin = target.get_bodypart(check_zone(BODY_ZONE_PRECISE_GROIN))
					groin.add_wound(/datum/wound/fracture)

/datum/sex_controller/proc/try_belly_pop(mob/living/carbon/human/target)
	var/list/excluded = get_extreme_content_excluded_mobs(user)
	if(istype(user.rmb_intent, /datum/rmb_intent/strong) && force == SEX_FORCE_LUDICROUS)
		if(user?.client?.prefs?.extreme_erp && target?.client?.prefs?.extreme_erp)
			if(prob(10) && !target.has_status_effect(/datum/status_effect/quivering))
				target.apply_status_effect(/datum/status_effect/quivering)
				target.confused += 25
				target.OffBalance(30 SECONDS)
			if(!HAS_TRAIT(target, TRAIT_RESILIENT_LOVER) && !target.has_wound(/datum/wound/slash/disembowel))
				if(popwarning == FALSE)
					to_chat(user, span_danger("[target]'s body is straining around my shaft; I may <b><i>BREAK</i></b> them if I keep going."))
					to_chat(target, span_danger("[user] is being too rough... my skin can't take much more!"))
					popwarning = TRUE
				if(prob(5))
					var/obj/item/bodypart/belly = target.get_bodypart(check_zone(BODY_ZONE_PRECISE_STOMACH))
					user.visible_message(span_userdanger("[user]'s tip tears open [target]'s belly, their organs spilling out in a bloody burst!"), ignored_mobs = excluded)
					belly.add_wound(/datum/wound/slash/disembowel)
					popwarning = FALSE

/datum/sex_controller/proc/try_jaw_crush(mob/living/carbon/human/target)
	if(istype(user.rmb_intent, /datum/rmb_intent/strong) && force > SEX_FORCE_MID)
		if(user?.client?.prefs?.extreme_erp && target?.client?.prefs?.extreme_erp)
			// Original fracture check retained; only the panel jaw fracture is blocked by the quirk.
			// if(!target.has_wound(/datum/wound/fracture/mouth))
			if(!HAS_TRAIT(target, TRAIT_RESILIENT_LOVER) && !target.has_wound(/datum/wound/fracture/mouth))
				if(prob(10))
					var/obj/item/bodypart/mouth = target.get_bodypart(check_zone(BODY_ZONE_PRECISE_MOUTH))
					mouth.add_wound(/datum/wound/fracture)
		if(prob(10) && !target.has_status_effect(/datum/status_effect/jaw_gaped) && !target.has_wound(/datum/wound/fracture/mouth))
			target.apply_status_effect(/datum/status_effect/jaw_gaped)
			target.apply_status_effect(/datum/status_effect/debuff/dazed)

/datum/status_effect/quivering
	id = "quivering"
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/quivering
	effectedstats = list("speed" = -2)

/atom/movable/screen/alert/status_effect/quivering
	name = "Quivering"
	desc = "I can barely walk..."
	icon_state = "quivering"

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
