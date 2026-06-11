// I want to refactor Stoneskin to give ablative layer of armor but in the meantime Crit Res is too strong so I'll just nerf it and lower cost
/obj/effect/proc_holder/spell/invoked/stoneskin
	name = "石肤术"
	overlay_state = "stoneskin"
	desc = "令目标的皮肤如岩石般坚硬。`+5 体质`"
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
	invocations = list("如磐石般屹立。") // Endure like Stone
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/stoneskin/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user] 低声念诵咒文，[spelltarget] 的皮肤随之变得如石般坚硬。")
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
		spelltarget.apply_status_effect(/datum/status_effect/buff/stoneskin/other)
	else
		user.visible_message("[user] 低声念诵咒文，皮肤随之渐渐硬化。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/stoneskin)

	return TRUE

#define STONESKIN_FILTER "stoneskin_glow"
/atom/movable/screen/alert/status_effect/buff/stoneskin
	name = "石肤术"
	desc = "我的皮肤如岩石般坚硬。`+5 体质`"
	icon_state = "buff"

/datum/status_effect/buff/stoneskin
	var/outline_colour ="#808080" // Granite Grey
	id = "stoneskin"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stoneskin
	effectedstats = list(STATKEY_CON = 5)
	var/hadcritres = FALSE
	duration = 1.5 MINUTES

/datum/status_effect/buff/stoneskin/other
	duration = 3 MINUTES

/datum/status_effect/buff/stoneskin/on_apply()
	. = ..()
	var/filter = owner.get_filter(STONESKIN_FILTER)
	if (!filter)
		owner.add_filter(STONESKIN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("我的皮肤正变得像石头一样坚硬。"))

/datum/status_effect/buff/stoneskin/on_remove()
	. = ..()
	to_chat(owner, span_warning("覆在我身上的石壳正在碎裂剥落。"))
	owner.remove_filter(STONESKIN_FILTER)

#undef STONESKIN_FILTER
