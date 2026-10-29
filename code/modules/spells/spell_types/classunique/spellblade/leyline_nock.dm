#define NOCK_FILTER "nock_glow"

/datum/action/cooldown/spell/leyline_nock
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "Leyline Nock"
	desc = "Prime your next arrow with arcyne force. When an arrow from your bound bow strikes, \
		a leyline bolt bursts from the wound and carries on, striking the target and everyone in a line behind them. \
		At 3+ momentum: consumes 3 for a longer, more damaging bolt with light penetration."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "azurean_javelin" // Placeholder until bow sprites exist
	sound = 'sound/magic/antimagic.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("Sagitta Lineae!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	weapon_cast_penalized = FALSE
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

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

	if(H.has_status_effect(/datum/status_effect/buff/nock_ready))
		to_chat(H, span_warning("My arrow is already primed!"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered nock primed!"))

	var/datum/status_effect/buff/nock_ready/effect = H.apply_status_effect(/datum/status_effect/buff/nock_ready, bow)
	if(effect)
		effect.spell_ref = WEAKREF(src)
		effect.empowered = empowered

	H.visible_message(
		span_notice("[H] draws a thread of arcyne light along [H.p_their()] bowstring."),
		span_notice("My arrow is primed - the next to strike will carry a leyline bolt."))
	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)
	return TRUE

/datum/action/cooldown/spell/leyline_nock/proc/do_bolt(mob/living/carbon/human/user, mob/living/struck, empowered)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/obj/item/weapon = arcyne_get_weapon(user)
	if(!weapon)
		return

	var/turf/origin = get_turf(struck)
	if(!origin)
		return

	var/pierce_dir = get_dir(user, struck)
	if(!pierce_dir)
		pierce_dir = user.dir

	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? empowered_pierce_damage : pierce_damage
	var/length = empowered ? empowered_pierce_length : pierce_length
	var/ap = empowered ? empowered_ap : 0

	var/list/pierce_turfs = list()
	var/turf/current = origin
	for(var/i in 1 to length)
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

	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(M)
			M.add_stacks(1)
			to_chat(user, span_notice("DOUBLE PIERCE! ARCYNE SURGE!"))
		user.visible_message(span_danger("A leyline bolt bursts from [struck] and lances through those behind!"))
	else if(hit_count)
		user.visible_message(span_danger("A leyline bolt bursts from [struck]!"))

// statuses

/atom/movable/screen/alert/status_effect/buff/nock_ready
	name = "Leyline Nocked"
	desc = "My next arrow to strike will carry a leyline bolt through the target."
	icon_state = "buff"

/datum/status_effect/buff/nock_ready
	id = "nock_ready"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nock_ready
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/datum/weakref/spell_ref
	var/empowered = FALSE
	var/obj/item/bow

/datum/status_effect/buff/nock_ready/on_creation(mob/living/new_owner, obj/item/primed_bow)
	bow = primed_bow
	return ..()

/datum/status_effect/buff/nock_ready/on_apply()
	. = ..()
	if(!bow)
		return FALSE
	RegisterSignal(bow, COMSIG_PROJECTILE_ON_HIT, PROC_REF(on_arrow_hit))
	owner.add_filter(NOCK_FILTER, 2, list("type" = "outline", "color" = "#4488ff", "alpha" = 160, "size" = 2))

/datum/status_effect/buff/nock_ready/on_remove()
	if(bow)
		UnregisterSignal(bow, COMSIG_PROJECTILE_ON_HIT)
		bow = null
	owner.remove_filter(NOCK_FILTER)
	. = ..()

/datum/status_effect/buff/nock_ready/proc/on_arrow_hit(obj/item/source, mob/living/firer, atom/target, angle)
	SIGNAL_HANDLER
	if(firer != owner || !isliving(target) || target == owner)
		return
	var/mob/living/struck = target
	if(struck.stat == DEAD)
		return
	var/datum/action/cooldown/spell/leyline_nock/spell = spell_ref?.resolve()
	var/was_empowered = empowered
	owner.remove_status_effect(/datum/status_effect/buff/nock_ready)
	if(!spell)
		return
	INVOKE_ASYNC(spell, TYPE_PROC_REF(/datum/action/cooldown/spell/leyline_nock, do_bolt), firer, struck, was_empowered)

#undef NOCK_FILTER
