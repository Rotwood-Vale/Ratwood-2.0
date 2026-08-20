/obj/effect/proc_holder/spell/self/martial_prowess
	name = "Appoint Protegé"
	desc = "Take on an individual as your protegé, allowing them to level up their weapon skills past Expert. This ability gains a charge with the passing of each dae."
	overlay_state = "craft_buff"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	antimagic_allowed = TRUE
	var/charges = 1

/obj/effect/proc_holder/spell/self/martial_prowess/cast(mob/user = usr)
	. = ..()
	if(charges < 1)
		to_chat(user, span_warning("I cannot take on another protegé yet."))
		revert_cast()
		return
	if(charges == 1)
		to_chat(user, span_notice("I have the potential to take on [charges] protegé."))
	else
		to_chat(user, span_notice("I have the potential to take on [charges] protégés."))
	var/list/nearbypeople = list()
	for(var/mob/living/carbon/human/potential_proteges in (view(1)))
		if(potential_proteges.job != "Veteran" && !potential_proteges.cmode) //prevent using in combat
			nearbypeople += potential_proteges
		var/target = input(user, "Take on as Protegé") as null|anything in nearbypeople
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/trainee = target
			if(!trainee)
				revert_cast()
				return
			if(trainee == user)
				revert_cast()
				return
			if(!trainee.mind)
				revert_cast()
				return
			if(HAS_TRAIT(trainee, TRAIT_MARTIAL_PROWESS))
				to_chat(user, span_warning("They've already been trained!"))
				revert_cast()
				return

			to_chat(user, span_notice("I offer my services."))
			var/prompt = alert(trainee, "[user.name] is offering to take you on as their protegé, allowing your martial skills to surpass that of mere Expertise. Do you accept?", "Veteran's Protegé", "SERVE AND LEARN", "I REFUSE")
			if(prompt == "I REFUSE")
				to_chat(user, span_warning("They decline my offer."))
				return
			to_chat(user, span_greentext("They accept my tutelage!"))
			to_chat(trainee, span_greentext("With [user.name]'s guidance, I feel much more confident in my ability to learn and master my arms!"))
			ADD_TRAIT(trainee, TRAIT_MARTIAL_PROWESS, TRAIT_GENERIC)
			charges--
