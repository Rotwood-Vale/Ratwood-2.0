/obj/effect/proc_holder/spell/invoked/song/resolute_refrain
	name = "Resolute Refrain"
	desc = "A steadying melody that bolsters your allies' constitution."
	overlay_state = "melody_t1_base"
	action_icon_state = "melody_t1_base"

/obj/effect/proc_holder/spell/invoked/song/resolute_refrain/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/resolute_refrain)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return

/datum/status_effect/buff/playing_melody/resolute_refrain
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	buff_to_apply = /datum/status_effect/buff/song/resolute_refrain
	buffs_to_apply_by_level = list(
		/datum/status_effect/buff/song/resolute_refrain,
		/datum/status_effect/buff/song/resolute_refrain/t2,
		/datum/status_effect/buff/song/resolute_refrain/t3,
	)

/atom/movable/screen/alert/status_effect/buff/song/resolute_refrain
	name = "Resolute Refrain"
	desc = "This steady melody hardens my resolve. I feel tougher, more resilient."
	icon_state = "buff"

/datum/status_effect/buff/song/resolute_refrain
	id = "resoluterefrain"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/resolute_refrain
	duration = 15 SECONDS
	effectedstats = list(STATKEY_CON = 1)

/datum/status_effect/buff/song/resolute_refrain/t2
	effectedstats = list(STATKEY_CON = 2)

/datum/status_effect/buff/song/resolute_refrain/t3
	effectedstats = list(STATKEY_CON = 3)
