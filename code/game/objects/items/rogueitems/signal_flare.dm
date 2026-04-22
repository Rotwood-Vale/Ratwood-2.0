var/list/signal_flare_codebook

/proc/get_signal_flare_codebook()
	/*
		Sets meanings to each signal flare code and color. This ensures that every round that the meaning for each color is randomized.
		Only the Garrison and Keep Noblemen can interpret its meaning.
	*/

	// If initialized, return codebook and color meanings immediately. Avoids reshuffling again, you dummy.
	if(signal_flare_codebook)
		return signal_flare_codebook

	// Otherwise, set meaning to each pretty color! :D
	var/list/meanings = shuffle(list(
		"'Distress!'",
		"'All Clear!'",
		"'Enemy Sighted!'",
		"'Request Reinforcements!'",
		"'Fall Back!'",
		"'Regroup Here!'"
	))

	// Assign the meaning to each color. Order is shuffled, so colors will always have unique meaning each round
	signal_flare_codebook = list(
		"red"    = meanings[1],
		"blue"   = meanings[2],
		"green"  = meanings[3],
		"yellow" = meanings[4],
		"white"  = meanings[5],
		"purple" = meanings[6]
	)
	return signal_flare_codebook

/obj/item/signal_flare
	name = "signal flare"
	desc = "A magical bundle of flammable material, alchemical powder, and cloth. Strike it with a source of fire to send a brilliant plume of colored smoke visible for miles. One use only. Be wise with it, you fool."
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "flint"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP

/obj/item/signal_flare/examine(mob/user)
	// This allows garrison to read the code for each color and share this information. Good for interrogation or for hired mercenaries.
	. = ..()
	var/list/codebook = get_signal_flare_codebook()
	var/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	if(user.job in can_interpret)
		. += span_notice("You recognize the signal codes etched in cryptic shorthand markings:")
		for(var/color in codebook)
			. += span_notice("&nbsp;&nbsp;<font color='[color]'><b>[color]</b></font>: [codebook[color]]")
	else
		. += span_notice("The colors carry meaning, but you lack the training to interpret them.")

/obj/item/signal_flare/attack_self(mob/living/user)
	to_chat(user, span_notice("I need to strike this with a source of fire to ignite it."))

/obj/item/signal_flare/afterattack(atom/movable/A, mob/living/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(istype(A, /obj/machinery/light/rogue/campfire))
		var/obj/machinery/light/rogue/campfire/fire = A
		if(!fire.on)
			to_chat(user, span_warning("That fire isn't lit."))
			return
		ignite_flare(user)


/obj/item/signal_flare/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/T = W
		if(!T.on)
			to_chat(user, span_warning("The torch isn't lit."))
			return
	else if(istype(W, /obj/item/flint))
		playsound(src.loc, 'sound/items/flint.ogg', 100)
		if(!prob(50))
			user.visible_message(span_notice("[user] strikes [W] against [src], but the flare fails to catch."))
			return
	else
		return ..()

	// Could have weather effects like rain here... TBD.

	ignite_flare(user)

/obj/item/signal_flare/proc/ignite_flare(mob/living/user)

	var/area/A = get_area(user)
	if(!A.outdoors)
		to_chat(user, span_warning("I need to be under open sky to fire this."))
		return

	var/list/codebook = get_signal_flare_codebook()
	var/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/user_can_interpret = (user.job in can_interpret)
	var/list/choices = list()

	for(var/color in codebook)
		// Sorted by alphabet in both instances, cannot be cheesed by non-garrison players.
		if(user_can_interpret)
			// Sorted by meaning
			choices["[codebook[color]]: ([capitalize(color)])"] = color
		else
			// Sorted by color. So no ability to cheese by memorizing order, methinks?
			choices["[capitalize(color)]"] = color

	var/picked = input(user, "Choose which signal to fire.", "Signal Flare") as null|anything in choices

	if(!picked)
		return

	var/chosen_color = choices[picked]

	user.visible_message(span_warning("[user] readies [src], preparing to ignite it..."))
	if(do_after(user, 3 SECONDS, target = src))

		var/turf/origin = get_turf(user)
		var/meaning = codebook[chosen_color]
		var/colored_name = "<font color='[chosen_color]'><b>[chosen_color]</b></font>"

		user.visible_message(span_warning("[user] ignites [src]! A [chosen_color] plume of smoke erupts skyward!"))
		playsound(user.loc, 'sound/effects/hood_ignite.ogg', 200, TRUE)

		var/list/flare_hex = list(
			"red"    = "#ff8877",
			"blue"   = "#6688ff",
			"green"  = "#66ffaa",
			"yellow" = "#ffdd66",
			"white"  = "#ffffff",
			"purple" = "#bb66ff"
		)
		
		var/obj/effect/signal_flare_light/glow = new(origin)
		glow.set_light(8, 4, 3, l_color = flare_hex[chosen_color], l_on = TRUE)
		QDEL_IN(glow, 10 SECONDS)

		// Ripping this from signal horn, but apparently loud_message could be suitable too?
		for(var/mob/living/player in GLOB.player_list)
			if(player.stat == DEAD || isbrain(player))
				continue
				
			var/distance = get_dist(player, origin)
			var/can_interpret_flare = (player.job in can_interpret)

			if(distance < 8 || distance > 200)
				continue

			var/dirtext = "to the "
			var/direction = angle2dir(Get_Angle(player, origin))

			switch(direction)
				if(NORTH)
					dirtext += "north"
				if(SOUTH)
					dirtext += "south"
				if(EAST)
					dirtext += "east"
				if(WEST)
					dirtext += "west"
				if(NORTHWEST)
					dirtext += "northwest"
				if(NORTHEAST)
					dirtext += "northeast"
				if(SOUTHWEST)
					dirtext += "southwest"
				if(SOUTHEAST)
					dirtext += "southeast"
				else
					dirtext = "although I cannot make out an exact direction"

			var/disttext

			if(distance < 50)
				disttext = "somewhat close"
			else if(distance < 100)
				disttext = "some distance away"
			else
				disttext = "an appreciable distance away"

			var/msg = "<big>A [colored_name] signal flare illuminates the sky [dirtext], [disttext]!</big>"

			if(can_interpret_flare)
				msg += " <i>You know this color to mean: [meaning]</i>"

			to_chat(player, span_boldnotice(msg))

		new /obj/item/ash(get_turf(user))
		qdel(src)
	else
		to_chat(user, span_warning("I was interrupted!"))

/obj/effect/signal_flare_light
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT
