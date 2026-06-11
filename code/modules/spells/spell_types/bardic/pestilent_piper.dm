/obj/effect/proc_holder/spell/invoked/song/pestilent_piedpiper
	name = "疫病吹笛人"
	desc = "奏出一曲受佩斯特拉启发的哀歌，让虫群的嗡鸣残留在敌人耳畔！非听众成员将受到 `-1 意志 -2 体质`。"
	overlay_state = "dirge_t2_base"
	action_icon_state = "dirge_t2_base"
	warnie = "spellwarning"
	invocations = list("plays a droning, shrill dirge! The world around them dries and crackles!") 
	invocation_type = "emote"
	sound = list('sound/magic/debuffroll.ogg')


/obj/effect/proc_holder/spell/invoked/song/pestilent_piedpiper/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_dirge/pestilent_piedpiper)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("我必须先演奏起来，才能影响我的听众！"))
		return





/datum/status_effect/buff/playing_dirge/pestilent_piedpiper
	effect = /obj/effect/temp_visual/songs/inspiration_dirget2
	debuff_to_apply = /datum/status_effect/debuff/song/pestilentpiper
	debuffs_to_apply_by_level = list(
		/datum/status_effect/debuff/song/pestilentpiper,
		/datum/status_effect/debuff/song/pestilentpiper/t2,
		/datum/status_effect/debuff/song/pestilentpiper/t3,
	)


/atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	name = "虫鸣缠耳！"
	desc = "这曲乐声令人胆寒！魔法削弱着我，我的心都提到了嗓子眼！"
	icon_state = "debuff"

/datum/status_effect/debuff/song/pestilentpiper
	id = "pestilentpiper"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	duration = 15 SECONDS
	effectedstats = list(STATKEY_WIL = -1, STATKEY_CON = -2)

/datum/status_effect/debuff/song/pestilentpiper/t2
	effectedstats = list(STATKEY_WIL = -1, STATKEY_CON = -3)

/datum/status_effect/debuff/song/pestilentpiper/t3
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -3)
