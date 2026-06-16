/obj/effect/proc_holder/spell/invoked/song/discordant_dirge
	name = "不谐哀歌"
	desc = "奏响一首不谐的哀歌，减缓敌人的速度。降低附近非听众目标的SPD。"
	invocations = list("plays a grinding, dissonant melody. The air grows heavy and sluggish.")
	invocation_type = "emote"
	overlay_state = "dirge_t1_base"
	action_icon_state = "dirge_t1_base"
	sound = list('sound/magic/debuffroll.ogg')

/obj/effect/proc_holder/spell/invoked/song/discordant_dirge/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_dirge/discordant_dirge)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return

/datum/status_effect/buff/playing_dirge/discordant_dirge
	effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	debuff_to_apply = /datum/status_effect/debuff/song/discordant_dirge
	debuffs_to_apply_by_level = list(
		/datum/status_effect/debuff/song/discordant_dirge,
		/datum/status_effect/debuff/song/discordant_dirge/t2,
		/datum/status_effect/debuff/song/discordant_dirge/t3,
	)

/atom/movable/screen/alert/status_effect/debuff/song/discordant_dirge
	name = "不谐哀歌"
	desc = "一段可怕的旋律压在我的四肢上。一切都感觉更慢了。"
	icon_state = "debuff"

/datum/status_effect/debuff/song/discordant_dirge
	id = "discordant_dirge"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/discordant_dirge
	effectedstats = list(STATKEY_SPD = -2)
	duration = 15 SECONDS

/datum/status_effect/debuff/song/discordant_dirge/t2
	effectedstats = list(STATKEY_SPD = -3)

/datum/status_effect/debuff/song/discordant_dirge/t3
	effectedstats = list(STATKEY_SPD = -4)
