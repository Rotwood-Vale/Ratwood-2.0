/atom/movable/screen/alert/status_effect/buff/xray_vision
	name = "透视术"
	desc = "我的视线能够穿透墙壁与遮挡，看见另一侧的事物。"
	icon_state = "buff"

/datum/status_effect/buff/xray_vision
	id = "xray_vision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/xray_vision
	duration = 10 SECONDS

/datum/status_effect/buff/xray_vision/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	return ..()

/datum/status_effect/buff/xray_vision/on_apply()
	. = ..()
	if(!.)
		return FALSE

	ADD_TRAIT(owner, TRAIT_XRAY_VISION, id)
	owner.update_vision_cone()
	to_chat(owner, span_notice("我的双眼被奥术之力浸染，墙壁与遮挡在我眼前都变得通透。"))
	return TRUE

/datum/status_effect/buff/xray_vision/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_XRAY_VISION, id)
	owner.update_vision_cone()
	to_chat(owner, span_warning("透视的力量从我眼中褪去，视线重新恢复如常。"))

/obj/effect/proc_holder/spell/invoked/xray_vision
	name = "透视术"
	desc = "赋予目标 10 秒的透视能力，使其能够看穿墙壁与遮挡。"
	cost = 2
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 5 SECONDS
	recharge_time = 30 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "darkvision"
	spell_tier = 2
	invocations = list("赐我洞穿障壁之目。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/xray_vision/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		revert_cast()
		return FALSE

	var/mob/living/spelltarget = target_atom
	var/already_enchanted = spelltarget.has_status_effect(/datum/status_effect/buff/xray_vision)
	spelltarget.apply_status_effect(/datum/status_effect/buff/xray_vision, 10 SECONDS)
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 70, TRUE, soundping = TRUE)

	if(spelltarget == user)
		if(already_enchanted)
			user.visible_message(span_notice("[user] 的眼中再度泛起洞穿障壁的奥术辉光。"))
			to_chat(user, span_notice("我重新续上了自身的透视术。"))
		else
			user.visible_message(span_notice("[user] 的双眼泛起幽邃的奥术光辉。"))
			to_chat(user, span_notice("奥术之力浸染了我的双眼，让我得以看穿遮挡。"))
	else
		if(already_enchanted)
			user.visible_message(span_notice("[user] 重新续接了 [spelltarget] 身上的透视术。"))
			to_chat(user, span_notice("我重新续上了 [spelltarget] 身上的透视之力。"))
			to_chat(spelltarget, span_notice("我眼中的透视之力再次充盈起来。"))
		else
			user.visible_message(span_notice("[user] 对 [spelltarget] 低声施法，[spelltarget] 的双眼随之泛起幽邃光辉。"))
			to_chat(user, span_notice("我将透视之力注入了 [spelltarget] 的双眼。"))
			to_chat(spelltarget, span_notice("我的双眼被奥术之力浸染，墙壁与遮挡在我眼前变得通透。"))

	return TRUE
