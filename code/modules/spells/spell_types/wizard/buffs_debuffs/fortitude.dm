/obj/effect/proc_holder/spell/invoked/fortitude
	name = "坚韧术"
	desc = "使身心机能更能承受肉体疲劳。(-50% 体力消耗)"
	cost = 3 // Halving stamina cost is INSANE so it cost the same as before adjustment to 3x spellpoint basis.
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "fortitude"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("赐我坚韧。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/fortitude/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user]低声念诵咒文，[spelltarget]短暂泛起绿色光辉。")
		to_chat(user, span_notice("借由他人作为媒介，我的法术持续时间翻倍了。"))
		spelltarget.apply_status_effect(/datum/status_effect/buff/fortitude/other)
	else
		user.visible_message("[user]低声念诵咒文，身上短暂泛起绿色光辉。")
		spelltarget.apply_status_effect(/datum/status_effect/buff/fortitude)

	return TRUE

/atom/movable/screen/alert/status_effect/buff/fortitude
	name = "坚韧术"
	desc = "我的身心机能已能更好地承受肉体疲劳。(-50% 体力消耗)"
	icon_state = "buff"

#define FORTITUDE_FILTER "fortitude_glow"
/datum/status_effect/buff/fortitude
	var/outline_colour ="#008000" // Forest green to avoid le sparkle mage
	id = "fortitude"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortitude
	duration = 1.5 MINUTES

/datum/status_effect/buff/fortitude/other
	duration = 3 MINUTES

/datum/status_effect/buff/fortitude/on_apply()
	. = ..()
	var/filter = owner.get_filter(FORTITUDE_FILTER)
	if (!filter)
		owner.add_filter(FORTITUDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("我的身体感觉轻盈了许多......"))
	ADD_TRAIT(owner, TRAIT_FORTITUDE, MAGIC_TRAIT)

/datum/status_effect/buff/fortitude/on_remove()
	. = ..()
	owner.remove_filter(FORTITUDE_FILTER)
	to_chat(owner, span_warning("世界的重压再次落回了我的肩头。"))
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, MAGIC_TRAIT)
