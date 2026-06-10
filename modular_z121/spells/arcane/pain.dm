/datum/wound/magical/pain_spell
	name = "奥术痛灼"
	check_name = "奥术痛灼"
	severity = WOUND_SEVERITY_LIGHT
	mob_overlay = ""
	sewn_overlay = ""
	whp = 1
	sewn_whp = 1
	woundpain = 30
	sewn_woundpain = 0
	sleep_healing = 0
	passive_healing = 0
	qdel_on_droplimb = TRUE

/datum/wound/magical/pain_spell/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/magical/pain_spell))
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/pain
	name = "疼痛术"
	desc = "让人体会到仿佛睾丸被扭转的疼痛，真的很痛！"
	cost = 3
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 15 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "evocation"
	spell_tier = 2
	invocations = list("痛楚，加诸其身！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/pain/cast(list/targets, mob/living/user = usr)
	if(user?.curplaying)
		user.curplaying.on_mouse_up()

	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	if(target.anti_magic_check())
		target.visible_message(span_warning("[target] 周身泛起一阵反魔法涟漪，将袭来的痛楚咒力尽数震散！"))
		to_chat(user, span_warning("[target] 身上的反魔法抵消了疼痛术。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	if(!apply_pain_effect(target, user))
		to_chat(user, span_warning("[target] 似乎无法承受这道奥术痛楚。"))
		revert_cast()
		return FALSE

	target.emote("painscream")
	target.visible_message(span_warning("[target] 突然因无形的奥术痛楚而浑身一颤，忍不住发出痛呼！"))
	to_chat(target, span_userdanger("一股无形的奥术之力猛然撕扯着我的神经，剧痛瞬间贯穿全身！"))
	to_chat(user, span_notice("我将剧烈的奥术疼痛压进了 [target] 的身体。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/pain/proc/apply_pain_effect(mob/living/target, mob/living/user)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		clear_existing_pain_wounds(carbon_target)

		var/obj/item/bodypart/affected = carbon_target.get_bodypart(check_zone(user?.zone_selected))
		if(!affected && carbon_target.bodyparts?.len)
			affected = carbon_target.bodyparts[1]
		if(!affected)
			return FALSE

		var/datum/wound/magical/pain_spell/agony = affected.add_wound(/datum/wound/magical/pain_spell, TRUE)
		if(!agony)
			return FALSE

		addtimer(CALLBACK(src, PROC_REF(expire_bodypart_pain_wound), affected, agony), 10 SECONDS)
		return TRUE

	if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
		target.simple_remove_wound(/datum/wound/magical/pain_spell)
		var/datum/wound/magical/pain_spell/agony = target.simple_add_wound(/datum/wound/magical/pain_spell, TRUE)
		if(!agony)
			return FALSE

		addtimer(CALLBACK(src, PROC_REF(expire_simple_pain_wound), target, agony), 10 SECONDS)
		return TRUE

	target.apply_damage(30, STAMINA)
	return TRUE

/obj/effect/proc_holder/spell/invoked/pain/proc/clear_existing_pain_wounds(mob/living/carbon/target)
	for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
		bodypart.remove_wound(/datum/wound/magical/pain_spell)

/obj/effect/proc_holder/spell/invoked/pain/proc/expire_bodypart_pain_wound(obj/item/bodypart/affected, datum/wound/agony)
	if(QDELETED(affected) || QDELETED(agony))
		return
	affected.remove_wound(agony)

/obj/effect/proc_holder/spell/invoked/pain/proc/expire_simple_pain_wound(mob/living/target, datum/wound/agony)
	if(QDELETED(target) || QDELETED(agony))
		return
	target.simple_remove_wound(agony)
