
/obj/effect/proc_holder/spell/invoked/song/dirge_fortune
	name = "Misfortunate Melody"
	desc = "Play a dirge which inflicts misfortune upon thy foes. -2 LUCK to non-audience members nearby. "
	invocations = list("plays the world's saddest song. The world around them seems to sulk.") 
	invocation_type = "emote"
	overlay_state = "dirge_t1_base"
	action_icon_state = "dirge_t1_base"
	sound = list('sound/magic/debuffroll.ogg')

/obj/effect/proc_holder/spell/invoked/song/dirge_fortune/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_dirge/misfortune)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return





/datum/status_effect/buff/playing_dirge/misfortune
	effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	debuff_to_apply = /datum/status_effect/debuff/song/dirge_misfortune

/datum/status_effect/debuff/song/dirge_misfortune
	id = "dirge_misfortune"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	effectedstats = list(STATKEY_LCK = -2)
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	name = "Dirge of Misfortune"
	desc = "I can feel the sky laughing at my back. This music is reminding me of my fleeting, insignificant life."
	icon_state = "restrained"
