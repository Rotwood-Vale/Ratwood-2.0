/obj/effect/proc_holder/spell/invoked/hawks_eyes
	name = "鹰眼术"
	overlay_state = "hawks_eyes"
	desc = "锐化目标的视觉。`+5 感知`"
	cost = 2
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	invocations = list("赐我鹰之锐目。") // Oculi - Eyes. Accipitris - Hawk, singular.
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/hawks_eyes/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user] 低声念诵咒文，[spelltarget] 的双眼随之泛起锐利光泽。")
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
		spelltarget.apply_status_effect(/datum/status_effect/buff/hawks_eyes/other)
	else
		user.visible_message("[user] 低声念诵咒文，双眼随之泛起锐利光泽。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/hawks_eyes)

	return TRUE

#define HAWKSEYES_FILTER "hawkseyes_glow"
/atom/movable/screen/alert/status_effect/buff/hawks_eyes
	name = "鹰眼术"
	desc = "我的视觉被锐化了。`+5 感知`"
	icon_state = "buff"

/datum/status_effect/buff/hawks_eyes
	var/outline_colour ="#ffff00" // Same color as perception potion
	id = "hawkseyes"
	alert_type = /atom/movable/screen/alert/status_effect/buff/hawks_eyes
	effectedstats = list(STATKEY_PER = 5)
	duration = 1.5 MINUTES

/datum/status_effect/buff/hawks_eyes/other
	duration = 3 MINUTES

/datum/status_effect/buff/hawks_eyes/on_apply()
	. = ..()
	var/filter = owner.get_filter(HAWKSEYES_FILTER)
	if (!filter)
		owner.add_filter(HAWKSEYES_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("我的视力变得如鹰一般敏锐。"))


/datum/status_effect/buff/hawks_eyes/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的视野重新变得模糊，失去了那份不自然的锐利。"))
	owner.remove_filter(HAWKSEYES_FILTER)

#undef HAWKSEYES_FILTER
