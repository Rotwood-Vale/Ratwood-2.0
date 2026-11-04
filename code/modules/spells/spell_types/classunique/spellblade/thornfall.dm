/datum/action/cooldown/spell/thornfall
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "Thornfall"
	expose_caster_on_deflect = FALSE
	desc = "Loose an arrow skyward and let the leyline split it into a hail of arcyne thorns, falling on a 3x3 area up to 7 tiles away. \
		The thorns fall after a short telegraph - aim where they will be. Costs no arrows. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. (25/50 damage, LIGHT PENETRATION)"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "air_strike"
	sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("Imber Spinarum!")
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
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN 

	var/damage = 35
	var/armor_pen = PEN_LIGHT
	var/empowered_mult = 2
	var/momentum_cost = 3
	var/fall_delay = 8

/datum/action/cooldown/spell/thornfall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/bow = arcyne_get_weapon(H)
	if(!istype(bow, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		to_chat(H, span_warning("I need my bound bow in hand!"))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center || center.density)
		to_chat(H, span_warning("I need open ground to rain upon!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered thornfall!"))

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/final_damage = empowered ? (damage * empowered_mult) : damage

	var/list/affected_turfs = list()
	for(var/turf/T in range(1, center))
		if(T.density)
			continue
		affected_turfs += T
		new /obj/effect/temp_visual/telegraph/thornfall(T)

	H.visible_message(span_warning("[H] looses an arrow high into the sky, splintering into arcane light!"))
	log_combat(H, cast_on, "used Thornfall on", zone=def_zone)

	addtimer(CALLBACK(src, PROC_REF(resolve_thornfall), H, bow, affected_turfs, final_damage, def_zone, empowered), fall_delay)
	return TRUE

/datum/action/cooldown/spell/thornfall/proc/resolve_thornfall(mob/living/carbon/human/H, obj/item/bow, list/affected_turfs, final_damage, def_zone, empowered)
	if(QDELETED(H) || H.stat == DEAD)
		return

	for(var/turf/T in affected_turfs)
		var/obj/effect/temp_visual/blade_stab/V = new(T)
		V.dir = SOUTH
	playsound(affected_turfs[1], 'sound/combat/hits/hi_arrow2.ogg', 80, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/T in affected_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, H, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			if(empowered)
				var/first_strike = arcyne_strike(H, victim, bow, round(final_damage / 2), def_zone, BCLASS_PIERCE, armor_penetration = armor_pen, spell_name = "Thornfall", skip_animation = TRUE, skip_message = TRUE)
				var/second_strike = arcyne_strike(H, victim, bow, round(final_damage / 2), def_zone, BCLASS_PIERCE, armor_penetration = armor_pen, spell_name = "Thornfall", skip_animation = TRUE)
				if(first_strike != ARCYNE_STRIKE_WARDED || second_strike != ARCYNE_STRIKE_WARDED)
					hit_count++
			else if(arcyne_strike(H, victim, bow, final_damage, def_zone, BCLASS_PIERCE, armor_penetration = armor_pen, spell_name = "Thornfall", skip_animation = TRUE) != ARCYNE_STRIKE_WARDED)
				hit_count++

	if(hit_count)
		var/datum/status_effect/buff/arcyne_momentum/surge = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)

/obj/effect/temp_visual/telegraph/thornfall
	light_outer_range = 1
	duration = 8
