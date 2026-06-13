/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo
	name = "潜行强奏"
	desc = "以猫般轻盈的步伐施加轻步效果于听众。"
	invocations = list("奏起一段狡黠而俏皮的旋律，仿佛整个世界都凑近来听这场玩笑。") 
	invocation_type = "emote"
	overlay_state = "bardsong_t1_base"
	action_icon_state = "bardsong_t1_base"


/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/furtive_fortissimo)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("我必须先演奏起来，才能鼓舞我的听众！"))
		return

/datum/status_effect/buff/playing_melody/furtive_fortissimo
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt1
	buff_to_apply = /datum/status_effect/buff/song/furtive_fortissimo


/atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	name = "潜行强奏"
	desc = "如猫般轻巧的潜行之歌已经奏响。"
	icon_state = "buff"

/datum/status_effect/buff/song/furtive_fortissimo
	id = "furtivefortissimo"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	duration = 15 SECONDS

/datum/status_effect/buff/song/furtive_fortissimo/on_apply()
	. = ..()
	to_chat(owner, span_warning("高草与枝杈都为我让开了路，前方豁然清晰。我觉得自己能自在穿行，不必担心伏击。"))
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, id)

/datum/status_effect/buff/song/furtive_fortissimo/on_remove()
	. = ..()
	to_chat(owner, span_warning("那段俏皮的旋律结束了。接下来我得重新提防伏击。"))
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, id)
