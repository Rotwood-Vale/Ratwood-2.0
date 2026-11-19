/datum/action/cooldown/spell/withdraw
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "Withdraw"
	desc = "Leap up to 3 tiles directly away from your target, passing through enemies. \
		At 3+ momentum: consumes 3 to leave an arcyne burst where you stood, \
		battering everyone adjacent and hurling them back 2 tiles. Can be deflected by Defend stance."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "advance" 
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list()
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/leap_range = 3
	var/burst_damage = 20
	var/burst_push = 2
	var/momentum_cost = 3
	var/step_delay = 1

/datum/action/cooldown/spell/withdraw/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	H.say("Recede!", forced = "spell", language = /datum/language/common)

	var/turf/start = get_turf(H)
	var/turf/target_turf = get_turf(cast_on)
	var/facing = get_dir(target_turf, start) || REVERSE_DIR(H.dir)

	if(!arcyne_can_leap_into(get_step(start, facing)))
		to_chat(H, span_warning("There's no room to leap back!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered withdraw!"))

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.visible_message(
		span_warning("[H] springs backward in a flash of arcyne light!"),
		span_notice("I withdraw!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	var/old_dir = H.dir
	var/old_pass = H.pass_flags
	var/old_throwing = H.throwing
	H.pass_flags |= PASSMOB
	H.throwing = TRUE
	var/prev_pixel_z = H.pixel_z

	animate(H, pixel_z = prev_pixel_z + 14, time = 1, easing = EASE_OUT)

	var/max_steps = leap_range
	if(facing & (facing - 1))
		max_steps = max(1, round(leap_range / sqrt(2), 1))

	for(var/i in 1 to max_steps)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/completed = arcyne_leap_step(H, facing)
		H.setDir(old_dir)
		if(!completed)
			break
		if(i < max_steps)
			sleep(step_delay)

	animate(H, pixel_z = prev_pixel_z, time = 1, easing = EASE_IN)
	H.pass_flags = old_pass
	H.throwing = old_throwing

	var/turf/landing_turf = get_turf(H)
	if(landing_turf?.zFall(H))
		return TRUE

	if(empowered)
		do_burst(H, held_weapon, start)

	log_combat(H, null, "used Withdraw[empowered ? " (empowered)" : ""]")
	return TRUE

/datum/action/cooldown/spell/withdraw/proc/do_burst(mob/living/carbon/human/H, obj/item/weapon, turf/origin)
	new /obj/effect/temp_visual/kinetic_blast(origin)
	playsound(origin, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 70, TRUE)

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/deflected = FALSE
	for(var/mob/living/victim in range(1, origin))
		if(victim == H || victim.stat == DEAD)
			continue
		if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
			deflected = TRUE
			continue
		if(arcyne_strike(H, victim, weapon, burst_damage, def_zone, BCLASS_BLUNT, spell_name = "Withdraw", skip_animation = TRUE) == ARCYNE_STRIKE_WARDED)
			continue
		var/push_dir = get_dir(origin, victim) || pick(GLOB.cardinals)
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, burst_push), burst_push, 1, H, force = MOVE_FORCE_STRONG)
