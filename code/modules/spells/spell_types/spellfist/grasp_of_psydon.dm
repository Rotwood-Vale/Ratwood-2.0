/obj/effect/proc_holder/spell/invoked/spellfist/grasp_of_psydon
	name = "Grasp of Psydon"
	desc = "Slam your open palm forward, sending forth tendrils of arcyne force to a target area up to 4 paces away on the same level. After a brief telegraph, all targets in the area are yanked toward you. \
		Requires 3 Momentum to cast. At 6+ momentum: consumes 6 to deal 40 blunt damage to the aimed bodypart on each yanked target.\n\n\
		'Push forth your hand with your conduit open, and imagine, with His will, seizing upon the very object or person you desire within your grasp, then, pull your hand backward. Close, and clench your fist, pushing forward slightly, opening your conduit again, and you shall seize your enemy from afar, and pull them toward you.'"
	overlay_state = "grasp_of_psydon"
	overlay_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	action_icon_state = "grasp_of_psydon"
	releasedrain = 20
	chargedrain = 1
	chargetime = 5
	charging_slowdown = 2
	recharge_time = 20 SECONDS
	range = 5
	spell_tier = 2
	invocations = list("Iqbid!")
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	
	var/min_momentum_cost = 3
	momentum_cost = 6 
	var/area_of_effect = 1
	var/pull_distance = 7
	var/telegraph_delay = 0.8 SECONDS
	var/base_damage = 15
	var/empowered_damage = 40

/obj/effect/proc_holder/spell/invoked/spellfist/grasp_of_psydon/can_cast(mob/user = usr)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum_cost)
		to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum_cost] stacks!"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/grasp_of_psydon/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	if(!istype(user) || !T)
		revert_cast()
		return FALSE

	var/turf/caster_turf = get_turf(user)
	if(T.z != caster_turf.z)
		to_chat(user, span_warning("The tendrils can't reach across planes!"))
		revert_cast()
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum_cost)
		revert_cast()
		return FALSE

	var/empowered = try_empower(user)
	if(!empowered)
		M.consume_stacks(min_momentum_cost)

	user.emote("attack", forced = TRUE)

	for(var/turf/affected_turf in view(area_of_effect, T))
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/grasp_telegraph(affected_turf)

	playsound(T, 'sound/magic/webspin.ogg', 50, TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_grasp), user, T, empowered), telegraph_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/grasp_of_psydon/proc/resolve_grasp(mob/living/carbon/human/user, turf/center, empowered = FALSE)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/turf/caster_turf = get_turf(user)
	playsound(center, 'sound/combat/grabbreak.ogg', 80, TRUE)

	var/hit_count = 0
	for(var/mob/living/victim in range(area_of_effect, center))
		if(victim == user || victim.stat == DEAD)
			continue
		
		var/def_zone = user.zone_selected || BODY_ZONE_CHEST
		
		if(!psydon_strike(user, victim, empowered ? empowered_damage : base_damage, def_zone))
			continue
			
		victim.throw_at(caster_turf, pull_distance, 4)
		victim.visible_message(
			span_warning("[victim] is yanked toward [user] by tendrils of arcyne force!"),
			span_userdanger("You are yanked toward [user] by tendrils of arcyne force!")
		)
		new /obj/effect/temp_visual/grasp_telegraph/long(get_turf(victim))
		hit_count++

	if(hit_count)
		user.visible_message(span_danger("[user] clenches [user.p_their()] fist, pulling [hit_count > 1 ? "enemies" : "an enemy"] toward [user.p_them()]!"))

	log_combat(user, null, "used Grasp of Psydon[empowered ? " (empowered)" : ""]")

/obj/effect/temp_visual/grasp_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	duration = 1 SECONDS

/obj/effect/temp_visual/grasp_telegraph/long
	duration = 2 SECONDS
