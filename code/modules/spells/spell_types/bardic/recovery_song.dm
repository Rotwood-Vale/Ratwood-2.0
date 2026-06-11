/obj/effect/proc_holder/spell/invoked/song/recovery_song
	name = "休憩狂想曲"
	desc = "用你的歌声抚慰盟友的精神！会持续恢复体力！"
	invocations = list("plays a gentle-yet-refreshing tune. The nearby air clears.") 
	invocation_type = "emote"
	overlay_state = "melody_t2_base"
	action_icon_state = "melody_t2_base"


/obj/effect/proc_holder/spell/invoked/song/recovery_song/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/recovery)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("我必须先演奏点什么，才能激励我的听众！"))
		return

/datum/status_effect/buff/playing_melody/recovery
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt2
	buff_to_apply = /datum/status_effect/buff/song/recovery
	buffs_to_apply_by_level = list(
		/datum/status_effect/buff/song/recovery,
		/datum/status_effect/buff/song/recovery/t2,
		/datum/status_effect/buff/song/recovery/t3,
	)



/atom/movable/screen/alert/status_effect/buff/song/recovery
	name = "乐声恢复"
	desc = "I breathe deeply. This melody refreshes me - I could run for hours."
	icon_state = "buff"

/datum/status_effect/buff/song/recovery
	id = "recoverysong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/recovery
	duration = 15 SECONDS
	var/stamina_on_tick = 4

/datum/status_effect/buff/song/recovery/t2
	stamina_on_tick = 5

/datum/status_effect/buff/song/recovery/t3
	stamina_on_tick = 6

/datum/status_effect/buff/song/recovery/tick()
	owner.stamina_add(-stamina_on_tick)
