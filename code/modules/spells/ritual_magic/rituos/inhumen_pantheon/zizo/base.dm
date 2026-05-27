/obj/structure/ritualcircle/zizo
	name = "Rune of Progress"
	desc = "A Holy Rune of ZIZO. Progress at any cost."
	icon_state = "zizo_chalky"
	var/zizorites = list("Rite of Armaments", "Rite of the Dark Crystal", "Conversion")

/obj/structure/ritualcircle/zizo/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Progress", src) as null|anything in zizorites
	switch(riteselection)
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_CABAL))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! DAME OF PROGRESS!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! HEED MY CALL!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! ARMS TO SLAY THE IGNORANT!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "zizo_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			zizoarmaments(target)
			spawn(120)
				icon_state = "zizo_chalky"
		if("Rite of the Dark Crystal")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! DAME OF PROGRESS!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! GRANT THE CABAL THEIR RELIC!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! THE DARK CRYSTAL TO COMMAND THE DEAD!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "zizo_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			new /obj/item/necro_relics/necro_crystal(loc)
			loc.visible_message(span_purple("A dark crystal materializes in the center of the ritual circle, pulsing with necromantic energy!"))
			spawn(120)
				icon_state = "zizo_chalky"
		if("Conversion")
			if(!Adjacent(user))
				to_chat(user, "You must stand close to the rune to receive Zizo's blessing.")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_CABAL))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "No valid targets on the rune!")
				return
			var/mob/living/carbon/human/target = input(user, "Choose a host") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! DAME OF PROGRESS!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! HEED MY CALL!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! LET THEM KNOW YOUR WORKS!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "zizo_active"
			zizoconversion(target) // removed CD bc it's gonna be coal to sit there and wait for it to go off rite cooldown, this one is purely social in its nature
			spawn(120)
				icon_state = "zizo_chalky"
