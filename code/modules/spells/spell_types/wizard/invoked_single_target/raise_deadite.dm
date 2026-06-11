/obj/effect/proc_holder/spell/invoked/raise_deadite
	name = "唤起尸鬼"
	desc = "将迅速发作的腐坏灌入目标体内，使其化作尸鬼复起。它不会对你友善。"
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
	invocations = list("腐生，再起！")
	invocation_type = "shout"
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/raise_deadite/cast(list/targets, mob/user)
	. = ..()
	var/mob/living/potential_deadite = targets[1]
	if(HAS_TRAIT(potential_deadite, TRAIT_ZOMBIE_IMMUNE))
		to_chat(user, span_notice("它无法被复活！"))
		revert_cast()
		return
	if(potential_deadite.stat < DEAD && !potential_deadite.InCritical())
		to_chat(user, span_notice("这具尸体还不够彻底地死去！"))
		revert_cast()
		return
	
	if(ishuman(potential_deadite) && potential_deadite.mind)
		var/mob/living/carbon/human/human_target = potential_deadite
		playsound(get_turf(human_target), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
		user.visible_message("[user]低声念诵咒文，[human_target]以违逆天理的生命抽搐了起来！")
		human_target.blood_volume = BLOOD_VOLUME_NORMAL
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
		user.visible_message("[user]低声念诵咒文，[potential_deadite]以违逆天理的生命抽搐了起来！")
		new undead_type(potential_deadite.loc)
		potential_deadite.visible_message(span_danger("[potential_deadite]再度行走于世……化为一具恐怖的活尸！"))
		qdel(potential_deadite)
	else
		to_chat(user, span_notice("它无法被这样唤起！"))
		revert_cast()
		return
