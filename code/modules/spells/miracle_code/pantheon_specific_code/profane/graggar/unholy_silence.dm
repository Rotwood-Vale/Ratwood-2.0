//T2: Unholy Silence - Silences a target, preventing them from speaking or casting spells.
/datum/action/cooldown/spell/silence/graggar
	name = "Unholy Silence"
	desc = "Tie up the tongue of your foe, making them unable to speak or cast spells/miracles."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "unholy_silence"
	miracle = TRUE
	devotion_cost = 50
	releasedrain = 20
	chargedrain = 2
	chargetime = 3 SECONDS
	range = 4
	recharge_time = 2 MINUTES //This lasts 25 SECONDS at max holy rank so for purposes of it not being chainable solo.
	associated_skill = /datum/skill/magic/holy
	invocation_type = "shout"
	sound = 'sound/magic/graggar_silence.ogg'
	invocations = list("BE SILENT!", "QUIET!", "NOT ANOTHER WORD!")
	zizo_spell = FALSE // Graggar wants his car back.

/datum/action/cooldown/spell/silence/graggar/cast(list/targets, mob/user = usr)//This one does actually work on mages, fully.
	if(iscarbon(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(user == target) //self target
			to_chat(user, "<span class='warning'>I may not silence myself.</span>")
			revert_cast()
			return
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>The spell fizzles, it won't work on them!</span>")
			revert_cast()
			return
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] resists the silencing magic!"))
			return TRUE
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("The wind in my voice goes still. I can't speak!"))
		var/dur = max((2 + (user.get_skill_level(associated_skill, 2))))//10 seconds at lvl 6 HOLY
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE
	else //misfire
		to_chat(user, "<span class='warning'>I must attempt to silence a speaking, thinking being.</span>")
		revert_cast()
		return
