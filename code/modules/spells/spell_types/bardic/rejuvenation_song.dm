/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song
	name = "Healing Hymn"
	desc = "Recuperate your allies bodies with your song! Refills health slowly over time!"
	invocations = list("plays a beautiful, stirring song. The world around them becomes more vivid.") 
	invocation_type = "emote"
	overlay_state = "melody_t3_base"
	action_icon_state = "melody_t3_base"


/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song/cast(mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/rejuvenation)
		return TRUE
	else
		revert_cast()
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return



/datum/status_effect/buff/playing_melody/rejuvenation
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt3
	buff_to_apply = /datum/status_effect/buff/healing/rejuvenationsong
	buffs_to_apply_by_level = list(
		/datum/status_effect/buff/healing/rejuvenationsong,
		/datum/status_effect/buff/healing/rejuvenationsong/t2,
		/datum/status_effect/buff/healing/rejuvenationsong/t3,
	)
	
/datum/status_effect/buff/healing/rejuvenationsong
	id = "healingrejuvesong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 15 SECONDS
	healing_on_tick = 0.6
	outline_colour = "#c92f2f"

/datum/status_effect/buff/healing/rejuvenationsong/t2
	healing_on_tick = 0.7

/datum/status_effect/buff/healing/rejuvenationsong/t3
	healing_on_tick = 1

/datum/status_effect/buff/healing/rejuvenationsong/on_creation(mob/living/new_owner, new_healing_on_tick = healing_on_tick, is_inhumen = FALSE)
	return ..(new_owner, new_healing_on_tick, is_inhumen)

/datum/status_effect/buff/healing/rejuvenationsong/on_apply()
	return ..()

/datum/status_effect/buff/healing/rejuvenationsong/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#660759"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + (healing_on_tick + 1), BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise))
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)
