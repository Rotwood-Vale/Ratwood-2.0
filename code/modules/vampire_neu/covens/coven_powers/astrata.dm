/**
 * Astrata Coven — Solar miracles with a vampiric twist
 * T1: Lesser Heal analogue (self heal over time)
 * T2: Ignition analogue (ranged ignite)
 * T3: Fire Lance analogue (holy fire projectile)
 * T4: Immolation analogue (AoE burning presence)
 */
/datum/coven/astrata
	name = "Astrata"
	desc = "The Sun's Paradox. Vampires wielding Astrata's solar grace through discipline and faith, channeling dawn's fire without being consumed."
	power_type = /datum/coven_power/astrata
	max_level = 4
	icon_state = "astrata"
	is_god_coven = TRUE

/datum/coven_power/astrata

// T1 — Solar Mending (lesser heal variant)
/datum/coven_power/astrata/solar_mending
	name = "Solar Mending"
	desc = "Channel ordered sunlight to slowly heal yourself. The paradox of wielding that which should harm you."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 60 SECONDS
	var/duration = 30 SECONDS

/datum/coven_power/astrata/solar_mending/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(user.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("I am already mending."))
		return FALSE
	
	user.visible_message(span_info("Pale golden light wraps around [user]."), span_notice("Disciplined dawn mends my wounds."))
	user.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
	return TRUE

// T2 — Ember Touch (ignition variant)
/datum/coven_power/astrata/ember_touch
	name = "Ember Touch"
	desc = "Touch of solar will, igniting flammable objects or searing foes with controlled flame."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 4
	cooldown_length = 30 SECONDS

/datum/coven_power/astrata/ember_touch/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(isobj(target))
		var/obj/O = target
		if(O.fire_act())
			user.visible_message(span_warning("[user] gestures; [O] ignites!"))
			playsound(get_turf(target), 'sound/magic/bless.ogg', 60, TRUE)
			return TRUE
		else
			to_chat(user, span_warning("[O] resists ignition."))
			return FALSE
	
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(2)
		L.ignite_mob()
		L.visible_message(span_danger("[user] touches [L] with ember!"), span_userdanger("Controlled flame sears my flesh!"))
		L.adjustFireLoss(8)
		playsound(get_turf(target), 'sound/magic/bless.ogg', 60, TRUE)
		return TRUE
	
	return FALSE

// T3 — Scorching Lance (fire lance variant)
/datum/coven_power/astrata/scorching_lance
	name = "Scorching Lance"
	desc = "Hurl a disciplined lance of holy fire. Burns all, but undead suffer grievously."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 45 SECONDS

/datum/coven_power/astrata/scorching_lance/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("Nothing to smite."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("A lance of golden fire streaks from [user] to [victim]!"))
	playsound(get_turf(user), 'sound/magic/bless.ogg', 100, TRUE)
	
	var/damage = 22
	if(victim.mob_biotypes & MOB_UNDEAD)
		damage = 45
		victim.adjust_fire_stacks(10)
		victim.visible_message(span_warning("[victim] erupts in flame!"))
		to_chat(victim, span_userdanger("Holy fire consumes my unliving flesh!"))
	else
		victim.adjust_fire_stacks(4)
	
	victim.adjustFireLoss(damage)
	victim.ignite_mob()
	return TRUE

// T4 — Dawn's Wrath (immolation variant)
/datum/coven_power/astrata/dawns_wrath
	name = "Dawn's Wrath"
	desc = "Become a walking pyre of controlled dawn, burning nearby foes. Potent but restrained presence."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 180 SECONDS
	var/duration = 35 SECONDS

/datum/coven_power/astrata/dawns_wrath/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I embody restrained dawn!"))
	user.visible_message(span_danger("[user] ignites with golden radiance!"))
	user.set_light(7, 4, "#ffeb9e")
	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, PROC_REF(end_wrath), user), duration)
	return TRUE

/datum/coven_power/astrata/dawns_wrath/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_wrath(user)
		return
	
	for(var/mob/living/L in view(3, user))
		if(L == user)
			continue
		var/damage = (L.mob_biotypes & MOB_UNDEAD) ? 6 : 3
		L.adjustFireLoss(damage)
		if(prob(15))
			L.adjust_fire_stacks(1)

/datum/coven_power/astrata/dawns_wrath/proc/end_wrath(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	if(user)
		user.set_light(0)
		to_chat(user, span_warning("The dawn recedes."))
