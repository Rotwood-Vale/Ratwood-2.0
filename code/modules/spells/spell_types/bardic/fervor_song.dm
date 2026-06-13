/obj/effect/proc_holder/spell/invoked/song/fervor_song
	name = "奋战幻想曲"
	desc = "激扬战斗的节奏，使盟友的攻击与招架效果提升 20%！"
	warnie = "spellwarning"
	invocations = list("奏起一段雄浑而富有节律的进行曲！世界仿佛都沉稳了下来！") 
	invocation_type = "emote"
	overlay_state = "bardsong_t2_base"
	action_icon_state = "bardsong_t2_base"


/obj/effect/proc_holder/spell/invoked/song/fervor_song/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/fervor)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("我必须先演奏起来，才能鼓舞我的听众！"))
		return

/datum/status_effect/buff/playing_melody/fervor
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt2
	buff_to_apply = /datum/status_effect/buff/song/fervor


#define FERVOR_FILTER "fervor_glow"

/atom/movable/screen/alert/status_effect/buff/song/fervor // spicy guidance
	name = "乐律激昂"
	desc = "乐声正在引导我的双手。`+20%` 几率绕过招架/闪避，`+20%` 几率成功招架/闪避。"
	icon_state = "buff"

/datum/status_effect/buff/song/fervor
	var/outline_colour ="#f58e2d"
	id = "fervor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/fervor
	duration = 15 SECONDS

/datum/status_effect/buff/song/fervor/on_apply()
	. = ..()
	var/filter = owner.get_filter(FERVOR_FILTER)
	if (!filter)
		owner.add_filter(FERVOR_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("我感觉自己仿佛真正理解了战斗！这是一首值得为之奋战的曲子！"))
	ADD_TRAIT(owner, TRAIT_GUIDANCE, MAGIC_TRAIT)

/datum/status_effect/buff/song/fervor/on_remove()
	. = ..()
	to_chat(owner, span_warning("脑中的嗡鸣逐渐平息，肾上腺素也随之退去。"))
	owner.remove_filter(FERVOR_FILTER)
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, MAGIC_TRAIT)


#undef FERVOR_FILTER
