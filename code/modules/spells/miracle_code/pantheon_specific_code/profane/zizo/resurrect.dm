// Heresiarch-exclusive: Perfect Reanimation. Anastasis but evil. Requires a heart and a zizocross structure to revive somebody.

/obj/effect/proc_holder/spell/invoked/resurrect/zizo
	name = "Zizoid Rebirth"
	desc = "Revive a fallen ally by siphoning their potential. You gain their strength, whilst they gain a second chance.\
	If they die, you will lose their stolen strength."
	sound = 'sound/magic/zizo_snuff.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "noc_revive"
	action_icon_state = "revival"
	warnie = "sydwarning"
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	required_items = list(/obj/item/heart_blood_vial/filled = 3)
	alt_required_items = list(/obj/item/heart_blood_vial/filled = 1)
	// We apply zizo's debuff differently
	debuff_type = null
	required_structure = /obj/structure/fluff/psycross/zizocross

/obj/effect/proc_holder/spell/invoked/resurrect/zizo/cast(list/targets, mob/living/carbon/human/user)
	var/list/stat_pool = list(STATKEY_STR, STATKEY_SPD, STATKEY_CON, STATKEY_WIL, STATKEY_INT, STATKEY_PER, STATKEY_LCK)
	var/list/tithe_distribution = list()

	for(var/S in stat_pool)
		tithe_distribution[S] = 0

	// Distribute 7 points - max 2 per stat
	var/budget = 7
	var/list/active_pool = stat_pool.Copy()
	while(budget > 0 && length(active_pool))
		var/picked_stat = pick(active_pool)
		tithe_distribution[picked_stat]++
		budget--
		if(tithe_distribution[picked_stat] >= 2)
			active_pool -= picked_stat

	// Parent call
	. = ..()

	// check if parent returns TRUE
	if(.)
		var/mob/living/carbon/human/target = targets[1]
		user.apply_status_effect(/datum/status_effect/buff/zizo_tithe, tithe_distribution, target)
		target.apply_status_effect(/datum/status_effect/debuff/zizo_drain, tithe_distribution)

		to_chat(user, span_nicegreen("The victim's essence flows into you as they gasp for air."))
		to_chat(target, span_userdanger("You are alive, but Zizo has taken his tithe from your soul."))

/atom/movable/screen/alert/status_effect/debuff/zizo_drain
	name = "Zizo's drain"
	desc = "Zizo has deemed my return worthy, but at a dear expense."

/atom/movable/screen/alert/status_effect/buff/zizo_tithe
	name = "Zizo's tithe"
	desc = "Zizo has boosted my capabilities with their vitality."

// THE BOON - Caster
/datum/status_effect/buff/zizo_tithe
	id = "zizo_tithe"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/zizo_tithe
	var/mob/living/carbon/human/victim

/datum/status_effect/buff/zizo_tithe/on_creation(mob/living/new_owner, list/distribution, var/mob/living/carbon/human/H)
	for(var/S in distribution)
		effectedstats[S] = distribution[S]
	victim = H
	RegisterSignal(victim, COMSIG_LIVING_DEATH, .proc/cancel_early)
	return ..()

/datum/status_effect/buff/zizo_tithe/on_remove()
	UnregisterSignal(victim, COMSIG_LIVING_DEATH)
	. = ..()

/datum/status_effect/buff/zizo_tithe/proc/cancel_early()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/H = owner
	H.remove_status_effect(/datum/status_effect/buff/zizo_tithe)

// THE DRAIN - Victim
/datum/status_effect/debuff/zizo_drain
	id = "zizo_drain"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/zizo_drain

/datum/status_effect/debuff/zizo_drain/on_creation(mob/living/new_owner, list/distribution)
	for(var/S in distribution)
		effectedstats[S] = -distribution[S]
	return ..()
