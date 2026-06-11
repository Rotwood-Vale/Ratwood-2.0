/datum/action/cooldown/mob_cooldown/bear_swipe
	name = "熊掌猛挥"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "explosion"
	desc = "用巨大的熊掌猛挥敌人"
	cooldown_time = 10 SECONDS
	var/cast_time = 1 SECONDS
	var/def_zone = BODY_ZONE_CHEST
	var/range = 2
	var/swipe_damage = 40

/datum/action/cooldown/mob_cooldown/bear_swipe/Activate(atom/target)
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist <= 1) //can see, in range and adjacent
		owner.visible_message(span_boldwarning("[owner]猛地立起身来，朝[target]挥出一掌！"))
		disable_cooldown_actions()
		addtimer(CALLBACK(src, PROC_REF(do_swipe), target), cast_time)
		StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/bear_swipe/proc/do_swipe(atom/target, mob/living/L)
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist <= 1)
		playsound(owner.loc, 'sound/combat/shieldraise.ogg', 100)
		if(ismob(target))
			var/mob/living/victim = target
			def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			victim.apply_damage(swipe_damage, BRUTE, def_zone, victim.run_armor_check(def_zone, "stab", damage = swipe_damage))
			victim.apply_status_effect(/datum/status_effect/debuff/staggered)
			var/turf/target_turf = get_turf(target)
			new /obj/effect/temp_visual/paw_swipe(target_turf)
			to_chat(target, span_userdanger("我被这记沉重的猛挥击中了！"))
			playsound(target, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
	else
		owner.visible_message(span_alert("[owner]见你躲开了它的挥击，恼怒地咆哮起来。"))
	return

/obj/effect/temp_visual/paw_swipe
	icon = 'icons/effects/effects.dmi'
	icon_state = "claw"
	name = "熊掌"
	desc = "这玩意大得吓人。"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
