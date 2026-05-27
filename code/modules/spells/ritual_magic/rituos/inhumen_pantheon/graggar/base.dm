/obj/structure/ritualcircle/graggar
	name = "Rune of Violence"
	desc = "A Holy Rune of Graggar. Fate broken once, His gift is true freedom for all."
	icon_state = "graggar_chalky"
	var/graggarrites = list("Rite of Armaments", "War Ritual", "Conversion")

/obj/structure/ritualcircle/graggar/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/graggar)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Violence", src) as null|anything in graggarrites
	switch(riteselection) // put ur rite selection here
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_HORDE))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("MOTIVE FORCE, OH VIOLENCE!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("A GORGEOUS FEAST OF VIOLENCE, FOR YOU, FOR YOU!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("A SLAUGHTER AWAITS!!") // see the numbers taste the violence
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			graggararmor(target)
			spawn(120)
				icon_state = "graggar_chalky"
		if("War Ritual")
			to_chat(user, span_userdanger("This rite will get me more tired than usual... I wonder, should I proceed?"))
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Blood for the war god, the circle is drawn!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Let noble flesh be the price for the horde!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Let portals open, let the goblins swarm!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			if(perform_warritual())
				user.apply_status_effect(/datum/status_effect/debuff/ritesexpended_heavy)
			else
				to_chat(user, span_smallred("The ritual fails. A noble, member of the inquisition or a tennite churchling body must be in the center of the circle!"))
			spawn(120)
				icon_state = "graggar_chalky"
		if("Conversion")
			if(!Adjacent(user))
				to_chat(user, "You must stand close to the rune to receive Graggar's blessing.")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_HORDE))
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
			user.say("GLORIOUS SLAUGHTER!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("FIELD OF CRIMSON!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ANOTHER CONQUEST, IN YOUR VISION!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			graggarconversion(target)
			spawn(120)
				icon_state = "graggar_chalky"
