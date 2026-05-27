/obj/structure/ritualcircle/matthios/proc/matthiosconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "Selected target is not on the rune! [target.p_they(TRUE)] must be directly on top of the rune to receive Matthios' blessing.")
		return
	if(HAS_TRAIT(target, TRAIT_COMMIE))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WITH GREED IN THEIR HEART ALREADY PRESENT!!"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("BLOODY NIMROD!!"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "GOOD DEAL?",, "GOOD DEAL!", "NO DEAL!")
	if(prompt == "GOOD DEAL!")
		target.Stun(60)
		target.Knockdown(60)
		target.emote("Laugh")
		playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
		loc.visible_message(span_cult("[target]'s eyes gleam and shine with a glimmer of a thousand gems and jewels, as they give in to their lust for wealth."))
		spawn(20)
			playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
			target.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE) //fuck do they gotta get? a better grip
			target.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			target.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
			spawn(40)
				to_chat(target, span_cult("More to the maw, for [target] shall feed their own greed along with us!"))
				playsound(loc, 'sound/items/matidol2.ogg', 50)
				if(target.devotion == null) // why can't it just go 'huh null? yeah ok dont care let's continue' why do i have to write this
					target.set_patron(new /datum/patron/inhumen/matthios)
					return
				else
					var/previous_level = target.devotion.level // IF NULL JUST MOVE ON WHAT'S YOUR PROBLEM HOLY FUCKING SHIT!!!
					target.set_patron(new /datum/patron/inhumen/matthios) //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
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
	if(prompt == "NO DEAL!")
		to_chat(target, span_warning("All that does glimmer could be yours... if only you would submit to your own greedy nature. Only final death awaits now, you, fellow most austere."))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.emote("Agony")
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		loc.visible_message(span_cult("[target] is violently thrashing atop the rune, writhing, as they dare to defy MATTHIOS."))
