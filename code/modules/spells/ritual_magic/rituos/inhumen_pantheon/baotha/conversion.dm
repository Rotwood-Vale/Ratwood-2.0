/obj/structure/ritualcircle/baotha/proc/baothaconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "Selected target is not on the rune! [target.p_they(TRUE)] must be directly on top of the rune to receive Baotha's blessing.")
		return
	if(HAS_TRAIT(target, TRAIT_DEPRAVED))
		loc.visible_message(span_cult("THE RITE REJECTS ONE ALREADY DEPRAVED ENOUGH!!"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("BLOODY NIMROD!!"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "LEASH OF SUBMISSION OR LASH OF DEFIANCE?",, "LEASH", "LASH")
	if(prompt == "LEASH")
		to_chat(target, span_warning("Hedonistic visions of excess and indulgence echo in your brain, as a drug-addled haze settles over your mind. Your body yearns for more.")) // helloooOOOOOOOO
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("PLEASURE FOR PLEASURE'S SAKE!"))
		target.sexcon.set_arousal(300)
		loc.visible_message(span_cult("[target] writhes and moans as sensations of pleasure and pain surge through their body...")) // warhammer 3 slaaneshi daemonette quotes
		spawn(20)
			playsound(target, 'sound/health/fastbeat.ogg', 60)
			playsound(loc, 'sound/ambience/creepywind.ogg', 80)
			target.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			target.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
			target.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE) // haha get it?
			spawn(40)
				to_chat(target, span_purple("Enjoy yourself, for what is lyfe without pleasure, ha?")) // help
				if(target.devotion == null)
					target.set_patron(new /datum/patron/inhumen/baotha)
					return
				else
					var/previous_level = target.devotion.level //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
					target.set_patron(new /datum/patron/inhumen/baotha)
					var/datum/devotion/C = new /datum/devotion(target, target.patron)
					if(previous_level == 4)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
					if(previous_level == 3)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
					if(previous_level == 2)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
					if(previous_level == 1)
						target.mind?.RemoveAllMiracles()
						C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	if(prompt == "LASH")
		to_chat(target, span_warning("All too asutere, aloof and prudish, aren't you? Bah, I shall not waste any more of my time on you.")) // gotta change it too
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.emote("Agony")
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		loc.visible_message(span_cult("[target] is violently thrashing atop the rune, writhing, as they dare to defy Baotha."))
