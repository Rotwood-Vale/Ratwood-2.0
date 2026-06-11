// Folder for any status effects that is shared between more than one spell. For now, just Frostbite
/datum/status_effect/buff/frost
	id = "frost"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost
	duration = 25 SECONDS
	effectedstats = list("speed" = -1)

/atom/movable/screen/alert/status_effect/buff/frost
	name = "战栗"
	desc = "我的身体止不住地发抖。"
	icon_state = "debuff"

/datum/status_effect/buff/frost/tick()
	var/mob/living/target = owner
	if(prob(20))
		target.emote(pick("shiver"))

/datum/status_effect/buff/frost/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.stamina_add(25)

/datum/status_effect/buff/frostbite
	id = "frostbite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frostbite
	duration = 6 SECONDS
	effectedstats = list("speed" = -2)

/atom/movable/screen/alert/status_effect/buff/frostbite
	name = "冻僵"
	desc = "我的四肢都冻得僵硬了！"
	icon_state = "debuff"

/datum/status_effect/buff/frostbite/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	var/newcolor = rgb(136, 191, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 20 SECONDS)
	target.add_movespeed_modifier(MOVESPEED_ID_ADMIN_VAREDIT, update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)
	target.stamina_add(25)

/datum/status_effect/buff/frostbite/tick()
	var/mob/living/target = owner
	target.stamina_add(5)

/datum/status_effect/buff/frostbite/on_remove()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.remove_movespeed_modifier(MOVESPEED_ID_ADMIN_VAREDIT, TRUE)
	. = ..()

/datum/status_effect/buff/witherd
	id = "withered"
	alert_type = /atom/movable/screen/alert/status_effect/buff/witherd
	duration = 90 SECONDS
	effectedstats = list(STATKEY_SPD = -2,STATKEY_STR = -2,STATKEY_CON= -2,STATKEY_WIL = -2)

/atom/movable/screen/alert/status_effect/buff/witherd
	name = "衰朽"
	desc = "我能感觉到自己的体魄正在衰弱。"
	icon_state = "debuff"
	color = "#b884f8" //talk about a coder sprite x2


/datum/status_effect/buff/witherd/on_apply()
	. = ..()
	to_chat(owner, span_warning("我感觉生命力正被抽走！"))
	var/mob/living/target = owner
	target.update_vision_cone()
	var/newcolor = rgb(207, 135, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 30 SECONDS)

/datum/status_effect/buff/witherd/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的体魄正在恢复。"))

/datum/status_effect/buff/lightningstruck
	id = "lightningstruck"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lightningstruck
	duration = 6 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/buff/lightningstruck
	name = "雷击余痕"
	desc = "我能感觉到电流仍在体内窜动。"
	icon_state = "debuff"
	color = "#ffff00"

/datum/status_effect/buff/lightningstruck/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.add_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)

/datum/status_effect/buff/lightningstruck/on_remove()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.remove_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, TRUE)
