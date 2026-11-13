/datum/action/cooldown/spell/leyline_nock
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "Leyline Nock"
	expose_caster_on_deflect = FALSE
	desc = "Nock an arrow of pure arcyne light and loose it at a target. Costs no arrows. \
		When it strikes, a leyline bolt bursts from the wound and carries on along the arrow's path, striking the target and everyone in a line behind them. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 for a longer, more damaging bolt with light penetration."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "azurean_javelin"
	sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_RANGED

	invocations = list("Sagitta Lineae!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/pierce_length = 3
	var/pierce_damage = 25
	var/empowered_pierce_length = 4
	var/empowered_pierce_damage = 40
	var/empowered_ap = PEN_LIGHT
	var/momentum_cost = 3

/datum/action/cooldown/spell/leyline_nock/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/bow = arcyne_get_weapon(H)
	if(!istype(bow, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		to_chat(H, span_warning("I need my bound bow in hand!"))
		return FALSE

	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf || target_turf == get_turf(H))
		to_chat(H, span_warning("Invalid target!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered nock!"))

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	var/obj/projectile/magic/leyline_arrow/P = new(H.loc)
	P.firer = H
	P.fired_from = get_turf(H)
	P.def_zone = def_zone
	P.spell_ref = WEAKREF(src)
	P.empowered = empowered
	if(empowered)
		P.color = "#B48CFF"
	H.apply_spell_accuracy(P)
	P.preparePixelProjectile(isliving(cast_on) ? cast_on : target_turf, H)
	P.fire()

	H.visible_message(
		span_warning("[H] draws a thread of arcyne light along [H.p_their()] bowstring and looses it!"),
		span_notice("I loose a leyline arrow!"))
	playsound(get_turf(H), 'sound/combat/Ranged/flatbow-shot-01.ogg', 70, TRUE)
	log_combat(H, cast_on, "used Leyline Nock[empowered ? " (empowered)" : ""] on", zone = def_zone)
	return TRUE

/datum/action/cooldown/spell/leyline_nock/proc/do_bolt(mob/living/carbon/human/user, mob/living/struck, empowered, turf/fired_turf)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/obj/item/weapon = arcyne_get_weapon(user)
	if(!weapon)
		return

	var/turf/origin = get_turf(struck)
	if(!origin)
		return

	var/turf/line_start = fired_turf || get_turf(user)
	var/pierce_dir = get_dir(line_start, origin) || user.dir

	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? empowered_pierce_damage : pierce_damage
	var/bolt_length = empowered ? empowered_pierce_length : pierce_length
	var/ap = empowered ? empowered_ap : 0

	var/list/pierce_turfs = list()
	if(line_start != origin)
		var/turf/far_end = get_ranged_target_turf_direct(line_start, origin, (get_dist(line_start, origin) + bolt_length) * 2)
		var/list/line = get_line(origin, far_end)
		line -= origin
		for(var/turf/T in line)
			if(length(pierce_turfs) >= bolt_length || !arcyne_can_leap_into(T))
				break
			pierce_turfs += T
	else
		var/turf/current = origin
		for(var/i in 1 to bolt_length)
			current = get_step(current, pierce_dir)
			if(!arcyne_can_leap_into(current))
				break
			pierce_turfs += current

	var/obj/effect/temp_visual/origin_burst = new /obj/effect/temp_visual/blade_stab(origin)
	origin_burst.dir = pierce_dir
	for(var/turf/T in pierce_turfs)
		var/obj/effect/temp_visual/V = new /obj/effect/temp_visual/blade_stab(T)
		V.dir = pierce_dir

	playsound(origin, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 70, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	var/list/already_hit = list()

	if(!QDELETED(struck) && struck.stat != DEAD)
		if(spell_guard_check(struck, FALSE, user))
			deflected = TRUE
		else
			if(arcyne_strike(user, struck, weapon, damage, def_zone, BCLASS_PIERCE, armor_penetration = ap, spell_name = "Leyline Nock", skip_animation = TRUE, allow_shield_check = TRUE) != ARCYNE_STRIKE_WARDED)
				hit_count++
			already_hit += struck

	for(var/turf/T in pierce_turfs)
		for(var/mob/living/victim in T)
			if(victim == user || victim == struck || victim.stat == DEAD || (victim in already_hit))
				continue
			if(spell_guard_check(victim, FALSE, user, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			arcyne_strike(user, victim, weapon, damage, def_zone, BCLASS_PIERCE, armor_penetration = ap, spell_name = "Leyline Nock", skip_animation = TRUE)
			hit_count++
			already_hit += victim

	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M)
		M.add_stacks(1)

	if(hit_count >= 2)
		if(M)
			M.add_stacks(1)
			to_chat(user, span_notice("DOUBLE PIERCE! ARCYNE SURGE!"))
		user.visible_message(span_danger("A leyline bolt bursts from [struck] and lances through those behind!"))
	else if(hit_count)
		user.visible_message(span_danger("A leyline bolt bursts from [struck]!"))

/obj/projectile/magic/leyline_arrow
	name = "leyline arrow"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	color = "#88BFFF"
	expose_caster_on_deflect = TRUE
	damage = 22
	damage_type = BRUTE
	nodamage = FALSE
	flag = "piercing"
	woundclass = BCLASS_PIERCE
	armor_penetration = PEN_LIGHT
	range = 15
	speed = 0.4
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	var/datum/weakref/spell_ref
	var/empowered = FALSE

/obj/projectile/magic/leyline_arrow/on_hit(target, blocked = FALSE)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with \the [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
	if(!isliving(target) || !isliving(firer) || target == firer)
		return
	var/mob/living/struck = target
	if(struck.stat == DEAD)
		return
	var/datum/action/cooldown/spell/leyline_nock/spell = spell_ref?.resolve()
	if(!spell)
		return
	INVOKE_ASYNC(spell, TYPE_PROC_REF(/datum/action/cooldown/spell/leyline_nock, do_bolt), firer, struck, empowered, starting)
