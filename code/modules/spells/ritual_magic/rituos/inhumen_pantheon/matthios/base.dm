/obj/structure/ritualcircle/matthios
	name = "Rune of Transaction"
	desc = "A Holy Rune of Matthios. All has a price."
	icon_state = "matthios_chalky"
	var/matthiosrites = list("Rite of Armaments", "Defenestration", "Conversion")


/obj/structure/ritualcircle/matthios/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/matthios)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Transaction", src) as null|anything in matthiosrites
	switch(riteselection) // put ur rite selection here
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_COMMIE))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Gold and Silver, he feeds!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Pieces Tens, Hundreds, Thousands. The transactor feeds 'pon them all!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Arms to claim, Arms to take!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			matthiosarmaments(target)
			spawn(120)
				icon_state = "matthios_chalky"
		if("Defenestration")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("The window is open, the transaction is made!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Pieces Tens, Hundreds, Thousands. The transactor feeds 'pon them all!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("The Transactor, feast upon this gluttonous pig!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			if(defenestration())
				to_chat(user, span_cultsmall("The ritual is complete, the noble gift of Astrata has been taken!"))
				user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			else
				to_chat(user, span_cultsmall("The ritual fails. A noble must be in the center of the circle!"))
			spawn(120)
				icon_state = "matthios_chalky"
		if("Conversion")
			if(!Adjacent(user))
				to_chat(user, "You must stand close to the rune to receive Matthios' blessing.")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_COMMIE))
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
			user.say("Hear my call, maw of Avarice!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Once a slave, now of your cause!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Break this fool's bonds!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			matthiosconversion(target)
			spawn(120)
				icon_state = "matthios_chalky"
