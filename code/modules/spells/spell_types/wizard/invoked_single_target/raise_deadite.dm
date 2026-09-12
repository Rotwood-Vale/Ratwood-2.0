/obj/effect/proc_holder/spell/invoked/raise_deadite
	name = "Raise Deadite"
	desc = "Infuse the target with quick acting Rot, raising them as a deadite. They will not be friendly to you."
	cost = 3
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 60
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "raisedead"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("Vivere Putrescere!")
	invocation_type = "shout"
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/raise_deadite/cast(list/targets, mob/user)
	. = ..()
	var/mob/living/potential_deadite = targets[1]
	if(HAS_TRAIT(potential_deadite, TRAIT_ZOMBIE_IMMUNE))
		to_chat(user, span_notice("They can not be raised!"))
		revert_cast()
		return
	if(potential_deadite.stat < DEAD && !potential_deadite.InCritical())
		to_chat(user, span_notice("They aren't dead enough yet!"))
		revert_cast()
		return

	if(ishuman(potential_deadite) && potential_deadite.mind)
		var/mob/living/carbon/human/human_target = potential_deadite
		playsound(get_turf(human_target), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
		user.visible_message("[user] mutters an incantation and [human_target] twitches with unnatural life!")
		human_target.set_blood_volume(BLOOD_VOLUME_NORMAL)
		human_target.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
		human_target.setToxLoss(0, updating_health = FALSE, forced = TRUE)
		human_target.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		human_target.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		human_target.heal_wounds(INFINITY)
		human_target.zombie_check_can_convert()
		var/datum/antagonist/zombie/Z = human_target.mind.has_antag_datum(/datum/antagonist/zombie)
		if(Z)
			Z.wake_zombie(TRUE)
		human_target.emote("scream")

	else if (potential_deadite.type in GLOB.animal_to_undead)
		var/undead_type = GLOB.animal_to_undead[potential_deadite.type]
		playsound(get_turf(potential_deadite), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
		user.visible_message("[user] mutters an incantation and [potential_deadite] twitches with unnatural life!")
		new undead_type(potential_deadite.loc)
		potential_deadite.visible_message(span_danger("[potential_deadite] walks again... As a terrifying deadite!"))
		qdel(potential_deadite)
	else
		to_chat(user, span_notice("They can not be raised!"))
		revert_cast()
		return
