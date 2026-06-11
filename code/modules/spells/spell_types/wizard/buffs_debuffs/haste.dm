/obj/effect/proc_holder/spell/invoked/haste
	name = "加速术"
	desc = "令目标获得魔法加速效果。(+5 速度，0.85 倍行动冷却)"
	cost = 4
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "haste" // Temporary icon from RW
	spell_tier = 2
	invocations = list("迅捷加诸其身！")
	invocation_type = "shout" // I mean, it is fast
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/haste/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user]低声念诵咒文，[spelltarget]短暂泛起黄色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/haste, 2 MINUTES)
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
	else
		user.visible_message("[user]低声念诵咒文，身上短暂泛起黄色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/haste, 1 MINUTES)

	return TRUE

/atom/movable/screen/alert/status_effect/buff/haste
	name = "加速术"
	desc = "我正受到魔法加速。"
	icon_state = "buff"

#define HASTE_FILTER "haste_glow"

/datum/status_effect/buff/haste
	var/outline_colour ="#F0E68C" // Hopefully not TOO yellow
	id = "haste"
	alert_type = /atom/movable/screen/alert/status_effect/buff/haste
	effectedstats = list(STATKEY_SPD = 5)
	duration = 1.5 MINUTES

/datum/status_effect/buff/haste/other
	duration = 3 MINUTES

/datum/status_effect/buff/haste/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/haste/on_apply()
	. = ..()
	var/filter = owner.get_filter(HASTE_FILTER)
	if (!filter)
		owner.add_filter(HASTE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("我的四肢以不可思议的速度动了起来。"))

/datum/status_effect/buff/haste/on_remove()
	. = ..()
	owner.remove_filter(HASTE_FILTER)
	to_chat(owner, span_warning("我的身体又慢了下来......"))

#undef HASTE_FILTER

/datum/status_effect/buff/haste/nextmove_modifier()
	return 0.85
