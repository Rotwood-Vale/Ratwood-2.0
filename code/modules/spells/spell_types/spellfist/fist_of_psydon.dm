/obj/effect/proc_holder/spell/invoked/spellfist/fist_of_psydon
	name = "Fist of Psydon"
	desc = "Slam your fist downward, sending arcyne force crashing into a 3x3 target area up to 5 paces away. \
		Brief telegraph before the strike lands. Deals blunt damage to the aimed bodypart. \
		At 3+ momentum: consumes 3 to double damage. \
		Can be deflected by Defend stance.\n\n\
		'Step forward, rotating your fist into the punch. And, as you strike, envision yourself repeating the same strike in your mynd, and open the arcyne conduit of your arms, but close that of your legs, so that all of your body's weight is behind the strike. Then, at the very last moment, close the conduit of your arms as well, and thus arrest the strike before it come out, and you shall strike as if the fist of Psydon Himself were behind the blow.'"
	overlay_state = "fist_of_psydon"
	overlay_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	action_icon_state = "fist_of_psydon"
	releasedrain = 25
	chargedrain = 1
	chargetime = 5
	charging_slowdown = 1
	recharge_time = 12 SECONDS
	range = 5
	spell_tier = 2
	invocations = list("Idrib!")
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	
	momentum_cost = 3
	var/base_damage = 40
	var/empowered_mult = 2
	var/area_of_effect = 1
	var/telegraph_delay = 0.8 SECONDS

/obj/effect/proc_holder/spell/invoked/spellfist/fist_of_psydon/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	if(!istype(user) || !T)
		revert_cast()
		return FALSE

	var/empowered = try_empower(user)
	var/damage = empowered ? (base_damage * empowered_mult) : base_damage
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST

	for(var/turf/affected_turf in range(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/air_strike_telegraph(affected_turf)
	
	playsound(T, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 60, TRUE)
	user.emote("attackgrunt", forced = TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_fist), user, T, damage, def_zone, empowered), telegraph_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/fist_of_psydon/proc/resolve_fist(mob/living/carbon/human/user, turf/center, damage, def_zone, empowered = FALSE)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/affected_turf in range(area_of_effect, center))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		for(var/mob/living/victim in affected_turf)
			if(victim == user || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : user))
				deflected = TRUE
				continue
			
			arcyne_strike(user, victim, null, damage, def_zone, BCLASS_BLUNT, spell_name = "Fist of Psydon")
			hit_count++

	playsound(center, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)
	user.emote("attack", forced = TRUE)

	if(hit_count)
		user.visible_message(span_danger("[user] slams [user.p_their()] fist down, sending a shockwave of arcyne force crashing into the ground!"))
	else
		user.visible_message(span_notice("[user] slams [user.p_their()] fist down, sending a shockwave into empty ground!"))

	log_combat(user, null, "used Fist of Psydon[empowered ? " (empowered)" : ""]")

/obj/effect/proc_holder/spell/invoked/spellfist/fist_of_psydon/proc/spell_guard_check(mob/living/target, check_parry, mob/living/attacker)
	return FALSE

/obj/effect/proc_holder/spell/invoked/spellfist/fist_of_psydon/proc/arcyne_strike(mob/living/user, mob/living/target, weapon, damage, zone, damagetype, spell_name, exact_zone)
	target.visible_message(span_danger("[user] hits [target] with [spell_name]!"))
	return psydon_strike(user, target, damage, zone)
