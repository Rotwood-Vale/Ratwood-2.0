/obj/structure/ritualcircle/baotha
	name = "Rune of Hedonism"
	desc = "A Holy Rune of Baotha. Relief for the broken hearted."
	icon_state = "baotha_chalky"
	var/baotharites = list("Conversion", "Unholy Boon of Fertility", "Rite of Armaments", "Rite of Joy")

/obj/structure/ritualcircle/baotha/attack_hand(mob/living/user)
	if((user.patron?.type) != /datum/patron/inhumen/baotha)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	if(!Adjacent(user))
		to_chat(user, "You must stand close to the rune to receive Baotha's blessing.")
		return
	var/riteselection = input(user, "Rituals of Desire", src) as null|anything in baotharites
	switch(riteselection) // put ur rite selection here
		if("Conversion")
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_DEPRAVED))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "No valid targets on the rune!")
				return
			var/mob/living/carbon/human/target = input(user, "Choose a host") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 50))
				user.say("#Lady pleasure, comfort and please us...")
				if(do_after(user, 50))
					user.say("#We are alone. Abandoned. Embrace us both...")
					if(do_after(user, 50))
						user.say("#The world's momentary pleasures have left us wanting...") // can someone else write this instead of me
						if(do_after(user, 50))
							icon_state = "baotha_active"
							baothaconversion(target) // removed CD bc it's gonna be coal to sit there and wait for it to go off rite cooldown, this one is purely social in its nature
							spawn(120)
								icon_state = "baotha_chalky"
		if("Unholy Boon of Fertility")
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "No valid targets on the rune!")
				return
			var/mob/living/carbon/human/target = input(user, "Choose a host") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 50))
				user.say("Purple flame, awaken desire!")
				if(do_after(user, 50))
					user.say("Claim this body, shape it to your will!")
					if(do_after(user, 50))
						user.say("Let them burn for thee alone!")
						if(do_after(user, 50))
							icon_state = "baotha_active"
							baothablessing(target)
							spawn(120)
								icon_state = "baotha_chalky"
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_DEPRAVED))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				user.say("Lady, my Lady...")
				if(!do_after(user, 5 SECONDS))
					user.say("Wrap thee in darkness, swaddle thee in cold bliss, and armor thee in desire...")
					if(!do_after(user, 5 SECONDS))
						user.say("Let all those who look upon me see thy beauty and despair!!")
						if(!do_after(user, 5 SECONDS))
						icon_state = "baotha_active"
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						baothaarmor(target)
						spawn(120)
							icon_state = "baotha_chalky"
		if("Rite of Joy")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_DEPRAVED))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return FALSE
			if(!do_after(user, 5 SECONDS))
				user.say("Let the wine flow, let the music crash!")
				if(!do_after(user, 5 SECONDS))
					user.say("Away with tears, away with shame!")
					to_chat(user, span_notice("The memory of sorrow fades into a haze of bliss."))
					if(!do_after(user, 5 SECONDS))
						user.say("Baotha, fill my cup with endless mirth!")
						playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
						icon_state = "baotha_active"

						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						user.apply_status_effect(/datum/status_effect/joybringer)

						spawn(120)
							icon_state = "zizo_chalky"
