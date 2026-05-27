// T1 - Skulduggery, lets you slip behind people who attack you
// number of times scales from your miracle tier, then once those "free" dodges are spent, it takes enem skill vs miracle chance
// can grapple attackers by having throw intent on, if attacked again by your target or someone else, either slam them down, or slam them on the attacker

/obj/effect/proc_holder/spell/self/skulduggery
	name = "Skulduggery"
	desc = "Imbue your mind and eyes with the cunning of Matthios, reading strikes before they land and punishing them with brutal efficiency.<br><br>Toggle Throw mode to actively intercept and grapple attacks, otherwise, you'll try to avoid them however you can."
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "liberate"
	recharge_time = 120 SECONDS
	sound = 'sound/magic/haste.ogg'
	releasedrain = 10
	miracle = TRUE
	devotion_cost = 70
	antimagic_allowed = FALSE
	range = 0

/obj/effect/proc_holder/spell/self/skulduggery/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user

	if(!H.cmode)
		to_chat(H, span_warning("I need some adrenaline pumping for this, my good sire!"))
		revert_cast() 
		return FALSE

	if(H.resting)
		H.set_resting(FALSE, FALSE)
		H.visible_message(
			span_warning("[H] kips up!"),
			span_warning("No rest for the wicked!"))

	H.visible_message(
		span_notice("[H] shifts their stance into something more relaxed and open! Their eyes glow golden..."),
		span_notice("My gaze is grafted with truth, my mind wanders in freedom..."))
	H.apply_status_effect(/datum/status_effect/buff/skulduggery)
	H.OffBalance(30)
	return TRUE


//////////////////////////
/// Skulduggery-Utils ///
////////////////////////


/atom/movable/screen/alert/status_effect/buff/skulduggery 
	name = "Skulduggery" 
	desc = span_notice("I prepare to slip inside attacks and punish aggressors, like a true Free Man would.") 
	icon_state = "clash"

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	status_type = STATUS_EFFECT_REFRESH
	var/mob/living/carbon/human/grappled
	var/waiting_followup = FALSE
	var/list/grapple_counts = list() // free grapple can only happen twice vs players
	var/parries_left = 0 // only got X free parries based on miracle level
	tick_interval = 1 SECONDS

/datum/status_effect/buff/skulduggery/on_creation(mob/living/new_owner, ...)
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_Wfist))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_incapacitate))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_incapacitate))

	parries_left = new_owner.get_skill_level(/datum/skill/magic/holy)
	. = ..()

/datum/status_effect/buff/skulduggery/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_STUN)
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)

	owner.stop_pulling()
	waiting_followup = FALSE
	. = ..()

/datum/status_effect/buff/skulduggery/proc/trigger_afterimage(duration = 2)
	if(!owner) return
	if(owner.GetComponent(/datum/component/after_image))
		return
	var/datum/component/after_image/A = owner.AddComponent(/datum/component/after_image)
	spawn(duration)
		if(A)
			qdel(A)

/datum/status_effect/buff/skulduggery/proc/on_incapacitate()
	SIGNAL_HANDLER 
	if(!owner) 
		return 
	if(!owner.IsKnockdown() && !owner.IsStun()) 
		return 
	to_chat(owner, span_warning("My footing falters! Carkin'--!")) 
	qdel(src)

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!owner) return
	if(prob(40))
		trigger_afterimage(2)
		owner.Jitter(1)

	if(waiting_followup && grappled)
		if(owner.pulling != grappled)
			waiting_followup = FALSE
			grappled = null
			
	if((H.highest_ac_worn() <= ARMOR_CLASS_LIGHT)&&(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff)))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

// SIGNAL HOOKS
/datum/status_effect/buff/skulduggery/proc/process_Wfist(mob/living/carbon/human/parent,mob/living/carbon/human/attacker,mob/living/carbon/human/defender)
	if(!ishuman(defender)) return
	if(defender.process_skd(attacker, null))
		return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/skulduggery/proc/process_Wattack(mob/living/parent,mob/living/target,mob/user,obj/item/I)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.process_skd(user, I))
			return COMPONENT_NO_ATTACK

/mob/living/carbon/human/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	var/datum/status_effect/buff/skulduggery/S = has_status_effect(/datum/status_effect/buff/skulduggery)
	if(!S) return FALSE
	return S.process_skd(attacker, I)

// CORE LOGIC
/datum/status_effect/buff/skulduggery/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	if(!owner || !ishuman(owner) || !ishuman(attacker) || owner.IsKnockdown() || owner.lying || owner.IsParalyzed() || owner.IsStun() || owner.stat != CONSCIOUS || !(owner.mobility_flags & MOBILITY_STAND))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/A = attacker

	// FOLLOW-UP STATE
	if(waiting_followup)
		if(A == grappled)
			slam_target(A)
		else
			slam_into(A)
		return TRUE

	// PRONE CHECK
	if(A.IsKnockdown() || A.lying)
		return stomp_prone(A)

	// THROW MODE = INTERCEPT-GRAPPLE
	if(H.in_throw_mode)
		return attempt_grapple(H, A)

	// NPC BAMBOOZLING
	if(!A.mind)
		return auto_flank_move(H, A)

	// PLAYER STANDARD PARRY
	return attempt_parry(H, A, I)

/datum/status_effect/buff/skulduggery/proc/attempt_grapple(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(A.mind)
		if(!grapple_counts[A])
			grapple_counts[A] = 0

		if(grapple_counts[A] >= 2)
			H.visible_message(
				span_warning("[H] reaches for [A], but they anticipate it!"),
				span_notice("They've adapted... I can't grab them again!")
			)
			return FALSE
		grapple_counts[A]++

	H.start_pulling(A)
	H.setDir(get_dir(H, A))
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	H.visible_message(
		span_boldwarning("[H] intercepts [A] and seizes them!"),
		span_notice("Got them!")
	)

	H.balloon_alert_to_viewers("SKD!!", "SKD!!", 10)

	grappled = A
	waiting_followup = TRUE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/attempt_parry(mob/living/carbon/human/H, mob/living/carbon/human/A, obj/item/I)
	var/my_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/enemy_skill = A.get_skill_level(I.associated_skill)
	if(!enemy_skill)
		enemy_skill = 0

	// Skill difference
	var/skill_diff = my_skill - enemy_skill
	// Base success chance (10% per point of advantage)
	var/base_chance = skill_diff * 10
	// Parry bonus (+20% per remaining parry)
	var/parry_bonus = parries_left * 20
	// Final success chance
	var/success_chance = base_chance + parry_bonus
	success_chance = clamp(success_chance, 0, 90)

	// Roll
	if(!prob(success_chance))
		H.visible_message(
			span_warning("[H] tries to read [A]'s attack, but fails!"),
			span_notice("Gah, I can't keep up!")
		)
		parries_left--
		to_chat(owner, span_warning("Failed, [parries_left] left. ([success_chance]%)")) 
		return FALSE
	// Success
	if(parries_left > 0)
		parries_left--

	to_chat(owner, span_warning("Success, [parries_left] left. ([success_chance]%)")) 
	auto_flank_move(H, A)
	return TRUE

/datum/status_effect/buff/skulduggery/proc/is_valid_step(mob/living/carbon/human/H, turf/dest)
	if(!dest)
		return FALSE
	if(arcyne_validate_blink_dest(dest, H))
		return FALSE
	if(istransparentturf(dest))
		return FALSE
	return TRUE

/datum/status_effect/buff/skulduggery/proc/auto_flank_move(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(!H || !A)
		return FALSE

	var/original_dir = A.dir
	var/left_dir = turn(original_dir, 90)
	var/right_dir = turn(original_dir, -90)
	var/behind_dir = turn(original_dir, 180)
	var/turf/left = get_step(A, left_dir)
	var/turf/right = get_step(A, right_dir)
	var/turf/behind = get_step(A, behind_dir)
	var/dx = H.x - A.x
	var/dy = H.y - A.y
	var/use_left = (dx * dy >= 0)
	var/turf/side = use_left ? left : right
	var/turf/alt_side = use_left ? right : left

	if(!is_valid_step(H, side) || !is_valid_step(H, behind))
		side = alt_side

		if(!is_valid_step(H, side) || !is_valid_step(H, behind))
			if(!is_valid_step(H, behind))
				return FALSE

			trigger_afterimage(3)
			H.forceMove(behind)
		else
			trigger_afterimage(3)
			H.forceMove(side)

			sleep(1) 
			
			trigger_afterimage(3)
			H.forceMove(behind)
	else
		trigger_afterimage(3)
		H.forceMove(side)

		sleep(1) // 1 tick, enough to render
	
		H.forceMove(behind)
		trigger_afterimage(3)

	H.setDir(get_dir(H, A))

	if(!A.mind)
		A.Immobilize(8 SECONDS)
		A.OffBalance(8 SECONDS)
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		if(A.mob_biotypes != MOB_UNDEAD && prob(25))
			A.emote("huh")
	else
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	H.visible_message(
		span_boldwarning("[H] slips past [A] in a blur and appears at their back!"),
		span_notice("Too slow.")
	)

	return TRUE

// SKD - STOMP
/datum/status_effect/buff/skulduggery/proc/stomp_prone(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner
	H.visible_message(
			span_boldwarning("[H] delivers their foot onto [T] while they try to swing!"),
			span_notice("Deserved kick for trying that, fool!")
		)
	H.do_attack_animation(T)
	T.adjustBruteLoss(8)
	T.stamina_add(8)
	H.setDir(get_dir(H, T))

	if(!T.mind)
		T.stamina_add(12)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)
	return TRUE
	
// SKD - GROUND SLAM
/datum/status_effect/buff/skulduggery/proc/slam_target(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner

	var/power = H.get_skill_level(/datum/skill/combat/unarmed) + (H.get_skill_level(/datum/skill/magic/holy) / 2)
	var/resist = (T.get_stat(STAT_CONSTITUTION) + T.get_stat(STAT_SPEED)/4)

	var/chance = clamp(50 + (power - resist), 10, 90)
	if(prob(chance))
		H.stop_pulling()
		waiting_followup = FALSE
		grappled = null
		H.visible_message(
			span_boldwarning("[H] turns [T] upside their head and slams them into the ground!"),
			span_notice("<i>I drive them into the floor with sheer skill!</i>")
		)
		H.setDir(get_dir(H, T))
		H.balloon_alert_to_viewers(message = "SKD Slam!!", self_message = "SKD Slam!!", y_offset = 10)
		playsound(get_turf(T), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		T.Knockdown(4 SECONDS)
		sleep(3)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 4 SECONDS)
		T.adjustBruteLoss(40)
		T.stamina_add(60)
		shake_camera(H, 2, 1)
		shake_camera(T, 2, 1)
		var/da_slam = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
		playsound(T, da_slam, 100, TRUE)
		playsound(T, 'sound/combat/tf2crit.ogg', 100, TRUE)
		if(!T.mind && T.mob_biotypes != MOB_UNDEAD)
			if(prob(50))
				T.Unconscious(800)
	else
		H.visible_message(
			span_warning("[T] resists the slam, forcing [H] to kick them away!"),
			span_notice("They resist my attempt to slam! I have to kick them off!")
		)
		H.balloon_alert_to_viewers(message = "SKD Kick!!", self_message = "SKD Kick!!", y_offset = 10)
		H.setDir(get_dir(H, T))
		playsound(T, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		T.Knockdown(1 SECONDS)
		var/dir = turn(get_dir(T, H), 180)
		if(dir & (NORTH|SOUTH))
			dir = (dir & NORTH) ? NORTH : SOUTH
		else
			dir = (dir & EAST) ? EAST : WEST
		var/turf/current = get_turf(T)
		for(var/i = 1 to 3)
			var/turf/next = get_step(current, dir)
			if(!next || next.density)
				break
			current = next
		T.throw_at(current, 2, 4)
		waiting_followup = FALSE

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)

	grappled = null
	waiting_followup = FALSE

// SKD - SLAM INTO ANOTHER
/datum/status_effect/buff/skulduggery/proc/slam_into(mob/living/carbon/human/other)
	if(!other || !grappled) return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/G = grappled

	H.visible_message(
		span_boldwarning("[H] redirects [G] full force into [other]!"),
		span_notice("<i>Consecutive Skulduggery! Hells yae! Bring me more!</i>")
	)
	H.balloon_alert_to_viewers(message = "Consecutive SKD!!", self_message = "Consecutive SKD!!", y_offset = 10)
	H.setDir(get_dir(H, other))
	var/attack_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	playsound(other, attack_sound, 100, TRUE)

	G.forceMove(get_turf(other))

	G.adjustBruteLoss(30)
	other.adjustBruteLoss(30)
	other.stamina_add(25)

	G.Knockdown(1 SECONDS)
	other.Knockdown(1 SECONDS)

	shake_camera(H, 2, 1)
	shake_camera(G, 2, 1)
	shake_camera(other, 2, 1)

	var/dir = turn(get_dir(other, H), 180)

	if(dir & (NORTH|SOUTH))
		dir = (dir & NORTH) ? NORTH : SOUTH
	else
		dir = (dir & EAST) ? EAST : WEST

	var/turf/current = get_turf(other)

	for(var/i = 1 to 3)
		var/turf/next = get_step(current, dir)
		if(!next || next.density)
			break
		current = next

	other.throw_at(current, 1, 4)
	waiting_followup = FALSE

	addtimer(CALLBACK(src, .proc/_slam_followup, other, G), 0.5)

	grappled = null
	waiting_followup = FALSE

/datum/status_effect/buff/skulduggery/proc/_slam_followup(mob/living/carbon/human/other, mob/living/carbon/human/G)
	if(!other || !G) return

	G.forceMove(get_turf(other))

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	var/turf/T = get_step(G, pick(dirs))
	if(T && !T.density)
		G.forceMove(T)

	addtimer(CALLBACK(G, /mob/proc/slamdunked), 1)
	addtimer(CALLBACK(other, /mob/proc/slamdunked), 1)

	if(!G.mind && G.mob_biotypes != MOB_UNDEAD)
		if(prob(50))
			G.Unconscious(800)

// EFFECTS
/mob/proc/slamdunked()
	var/amp = 6
	animate(src, pixel_x = 0, time = 0)
	for(var/i in 1 to 5)
		animate(src, pixel_x = -amp, time = 1)
		animate(src, pixel_x = amp, time = 1)
		amp = round(amp * 0.6)
	animate(src, pixel_x = 0, time = 2)
