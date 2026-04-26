#define FLARE_SHELTER_COLOR "orange"

GLOBAL_LIST_EMPTY(signal_flare_codebook)

/proc/get_signal_flare_codebook()
	/*
		Sets meanings to each signal flare code and color. This ensures that every round that the meaning for each color is randomized.
		Only the Garrison and Keep Noblemen can interpret its meaning, except for the orange shelter signal which is universally known.
	*/

	// If initialized, return codebook and color meanings immediately. Avoids reshuffling again, you dummy.
	if(length(GLOB.signal_flare_codebook))
		return GLOB.signal_flare_codebook

	// Otherwise, set meaning to each pretty color! :D
	var/list/meanings = shuffle(list(
		"'Distress!'",
		"'All Clear!'",
		"'Enemy Sighted!'",
		"'Reinforcements Requested!'",
		"'Fall Back!'",
		"'Regroup Here!'"
	))

	// Assign the meaning to each color. Order is shuffled, so colors will always have unique meaning each round
	GLOB.signal_flare_codebook = list(
		"red"    = meanings[1],
		"blue"   = meanings[2],
		"green"  = meanings[3],
		"yellow" = meanings[4],
		"white"  = meanings[5],
		"purple" = meanings[6],	
		"orange" = "'Drop everything. Run and hide!'"
	)

	return GLOB.signal_flare_codebook

/obj/item/signal_flare
	name = "signal flare"
	desc = "A magical bundle of flammable material, alchemical powder, and cloth. Strike it with a source of fire to send a brilliant plume of colored smoke visible for miles. One use only. Be wise with it, you fool."
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "flint"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	grid_height = 32
	grid_width = 32

/obj/item/signal_flare/examine(mob/user)
	// This allows garrison to read the code for each color and share this information. Good for interrogation or for hired mercenaries, me thinks.
	. = ..()
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions
	if(user.job in can_interpret)
		. += span_notice("You recognize the signal codes etched in cryptic shorthand markings:")
		for(var/color in codebook)
			. += span_notice("&nbsp;&nbsp;<font color='[color]'><b>[color]</b></font>: [codebook[color]]")
	else if(user.job in townsfolk)
		. += span_cult("You recognize the <font color='orange'><b>orange</b></font> flare — every man and woman knows it means [codebook[FLARE_SHELTER_COLOR]]")
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
	var/area/user_area = get_area(user)
	if(!user_area.outdoors)
		to_chat(user, span_warning("I need to be under open sky to fire this."))
		return

	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/user_can_interpret = (user.job in can_interpret)
	var/static/list/shelter_authorized = list("Grand Duke", "Marshal", "Hand", "Knight Captain")
	var/list/choices = list()

	for(var/color in codebook)
		if(color == FLARE_SHELTER_COLOR && !(user.job in shelter_authorized))
			continue
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

		var/static/list/flare_hex = list(
			"red"    = "#ff8877",
			"blue"   = "#6688ff",
			"green"  = "#66ffaa",
			"yellow" = "#ffdd66",
			"white"  = "#ffffff",
			"purple" = "#bb66ff",
			"orange" = "#ff9944"
		)

		var/hex = flare_hex[chosen_color]
		addtimer(CALLBACK(src, PROC_REF(flare_illuminate), origin, hex, meaning, colored_name, chosen_color, can_interpret), 2 SECONDS)
	else
		to_chat(user, span_warning("I was interrupted!"))

/obj/item/signal_flare/proc/flare_illuminate(turf/origin, hex, meaning, colored_name, chosen_color, list/can_interpret)
	var/obj/effect/signal_flare_light/glow = new(origin)
	glow.set_light(8, 4, 3, l_color = hex, l_on = TRUE)

	QDEL_IN(glow, 10 SECONDS)

	playsound(origin, pick('sound/misc/explode/explosionfar (1).ogg', 'sound/misc/explode/explosionfar (2).ogg', 'sound/misc/explode/explosionfar (3).ogg'), 40, TRUE)

	var/list/scatter_turfs = list()
	var/area/TA

	for(var/turf/T in range(7, origin))
		TA = get_area(T)
		if(isopenturf(T) && TA.outdoors)
			scatter_turfs += T

	for(var/i in 1 to 4)
		if(!length(scatter_turfs))
			break

		var/turf/landing = pick(scatter_turfs)

		scatter_turfs -= landing

		var/turf/below = get_step_multiz(landing, DOWN)

		while(isopenspace(landing) && below)
			landing = below
			below = get_step_multiz(landing, DOWN)

		if(isopenspace(landing))
			continue

		var/obj/effect/signal_flare_remnant/R = new(landing)

		R.color = hex
		var/mutable_appearance/ember_glow = mutable_appearance(R.icon, R.icon_state)
		ember_glow.blend_mode = BLEND_ADD
		ember_glow.color = hex
		R.overlays += ember_glow
		R.set_light(2, 1, 2, l_color = hex, l_on = TRUE)

		QDEL_IN(R, 60 SECONDS)

	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD || isbrain(player))
			continue

		var/distance = get_dist(player, origin)
		if(distance > 200)
			continue

		var/can_interpret_flare = (player.job in can_interpret)
		var/is_townsfolk_and_shelter_signal = (chosen_color == FLARE_SHELTER_COLOR) && (player.job in townsfolk)

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
		else if(is_townsfolk_and_shelter_signal)
			msg += span_userdanger(" You know what this means: [meaning]")

		to_chat(player, span_boldnotice(msg))

	qdel(src)

/obj/effect/signal_flare_light
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/signal_flare_remnant
	name = "smoldering ash"
	desc = "Glowing embers from a signal flare."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
