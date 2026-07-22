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
	name = "signal flare canister"
	desc = "A sealed alchemical canister brimming with flammable powder and colored cloth. Load it into a Wolkenmaw to send a brilliant plume of colored smoke visible for miles. One use only. Be wise with it, you fool."
	icon = 'icons/roguetown/items/flaregun.dmi'
	icon_state = "flarecanister_ready"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	grid_height = 32
	grid_width = 32
	var/spent = FALSE

/obj/item/signal_flare/proc/mark_spent()
	spent = TRUE
	name = "spent flare canister"
	desc = "An empty flare canister reeking of burnt powder. Useless now."
	icon_state = "flarecanister_empty"

/obj/item/signal_flare/examine(mob/user)
	// This allows garrison to read the code for each color and share this information. Good for interrogation or for hired mercenaries, me thinks.
	. = ..()
	if(spent)
		return
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions
	if(user.job in can_interpret)
		. += span_notice("You recognize the signal codes etched in cryptic shorthand markings:")
		for(var/color in codebook)
			. += span_notice("&nbsp;&nbsp;<font color='[color]'><b>[color]</b></font>: [codebook[color]]")
	else if(user.job in townsfolk)
		. += span_cult("You recognize the <font color='orange'><b>orange</b></font> flare: every man and woman knows it means [codebook[FLARE_SHELTER_COLOR]]")
	else
		. += span_notice("The colors carry meaning, but you lack the training to interpret them.")

/obj/item/signal_flare/attack_self(mob/living/user)
	if(spent)
		to_chat(user, span_notice("It's spent. Nothing left but the smell of burnt powder."))
		return
	to_chat(user, span_notice("I need to load this into a Wolkenmaw to fire it."))

/obj/item/flaregun
	name = "Wolkenmaw"
	desc = "A magical handgonne of wood and dark iron with a wide mouth, a Grenzelhoftian import. Break it open, feed it an alchemical flare canister, and cock it shut to send a brilliant plume of colored smoke visible for miles, inviting either friend or foe. Be wise with it, you fool."
	icon = 'icons/roguetown/items/flaregun.dmi'
	icon_state = "flaregun_unload"
	item_state = "flaregun"
	lefthand_file = 'icons/mob/inhands/weapons/flaregun_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flaregun_righthand.dmi'
	experimental_inhand = FALSE
	experimental_onhip = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	grid_width = 32
	grid_height = 32
	var/obj/item/signal_flare/canister
	var/cocked = FALSE
	var/spawn_loaded = FALSE
	/// Prevents the color menu from opening twice when a single click routes through multiple attack paths.
	var/firing = FALSE
	var/list/fire_sound = list(
		'modular_helmsguard/sound/arquebus/arquefire.ogg',
		'modular_helmsguard/sound/arquebus/arquefire2.ogg',
		'modular_helmsguard/sound/arquebus/arquefire3.ogg',
		'modular_helmsguard/sound/arquebus/arquefire4.ogg',
		'modular_helmsguard/sound/arquebus/arquefire5.ogg',
	)
	var/load_sound = 'modular_helmsguard/sound/arquebus/musketload.ogg'
	var/cock_sound = 'modular_helmsguard/sound/arquebus/musketcock.ogg'
	var/fuse_sound = 'modular_helmsguard/sound/arquebus/fuse.ogg'
	var/break_open_sound = 'sound/items/knife_open.ogg'
	var/dry_fire_sound = 'modular_helmsguard/sound/arquebus/musketcock.ogg'

/obj/item/flaregun/loaded
	spawn_loaded = TRUE

/obj/item/flaregun/Initialize(mapload)
	. = ..()
	if(spawn_loaded && !canister)
		canister = new(src)
	update_gun_icon()

/obj/item/flaregun/Destroy()
	if(canister)
		canister.forceMove(drop_location())
		canister = null
	return ..()

/obj/item/flaregun/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == canister)
		canister = null
		cocked = FALSE
		update_gun_icon()

// Closed and cocked shows the ready sprite, while broken open shows the unload sprite.
/obj/item/flaregun/proc/update_gun_icon()
	icon_state = cocked ? "flaregun_default" : "flaregun_unload"

/obj/item/flaregun/examine(mob/user)
	. = ..()
	if(!canister)
		. += span_notice("Its chamber is empty.")
	else if(canister.spent)
		. += span_notice("A spent canister sits in the chamber. It should be ejected.")
	else if(!cocked)
		. += span_notice("It's loaded, but must be cocked shut before it can fire.")
	else
		. += span_notice("It's loaded and ready to fire.")

/obj/item/flaregun/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/signal_flare))
		var/obj/item/signal_flare/C = W
		if(canister)
			to_chat(user, span_warning("There's already a canister in the chamber."))
			return
		if(cocked)
			to_chat(user, span_warning("[src] is snapped shut. I need to break it open before I can load it."))
			return
		if(C.spent)
			to_chat(user, span_warning("This canister is spent. It would accomplish nothing."))
			return
		if(!user.transferItemToLoc(C, src))
			return
		canister = C
		update_gun_icon()
		playsound(src, load_sound, 100)
		user.visible_message(span_notice("[user] slots [C] into [src]'s open chamber. It must be cocked shut before it can fire."))
		return
	return ..()

/obj/item/flaregun/attack_self(mob/living/user)
	if(canister?.spent)
		eject_canister(user)
		return
	if(!cocked)
		cocked = TRUE
		update_gun_icon()
		playsound(src, cock_sound, 100)
		user.visible_message(span_notice("[user] snaps [src] shut and cocks it[canister ? ". It's ready to fire" : ""]."))
		return
	if(!canister)
		dry_fire(user)
		return
	fire_flare(user)

/obj/item/flaregun/proc/dry_fire(mob/living/user)
	cocked = FALSE
	update_gun_icon()
	playsound(src, dry_fire_sound, 30, TRUE)
	user.visible_message(span_danger("[src]'s hammer falls on an empty chamber. *click*"))

/obj/item/flaregun/attack_right(mob/user)
	if(canister && isliving(user))
		eject_canister(user)
		return
	return ..()

/obj/item/flaregun/afterattack(atom/target, mob/living/user, proximity, params)
	. = ..()
	if(!istype(user))
		return
	if(proximity && ((target in user.contents) || !isturf(target)))
		return
	if(!cocked)
		to_chat(user, span_warning("[src] needs to be cocked first."))
		return
	if(!canister || canister.spent)
		dry_fire(user)
		return
	fire_flare(user)

/obj/item/flaregun/proc/eject_canister(mob/living/user)
	var/obj/item/signal_flare/C = canister
	canister = null
	cocked = FALSE
	update_gun_icon()
	playsound(src, break_open_sound, 100)
	C.forceMove(get_turf(src))
	if(C.spent)
		user.visible_message(span_notice("[user] breaks open [src], and the spent canister clatters to the ground."))
	else
		user.put_in_hands(C)
		user.visible_message(span_notice("[user] breaks open [src] and unloads [C]."))


/obj/item/flaregun/proc/fire_flare(mob/living/user)
	if(firing)
		return
	var/area/user_area = get_area(user)
	if(!user_area.outdoors)
		to_chat(user, span_warning("I need to be under open sky to fire this."))
		return
	firing = TRUE
	do_fire_flare(user)
	firing = FALSE

/obj/item/flaregun/proc/do_fire_flare(mob/living/user)
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
	if(!canister || canister.spent)
		return

	var/chosen_color = choices[picked]

	user.visible_message(span_warning("[user] raises [src] skyward, preparing to fire..."))
	playsound(src, fuse_sound, 80)
	if(!do_after(user, 1.5 SECONDS, target = src))
		to_chat(user, span_warning("I was interrupted!"))
		return

	if(!canister || canister.spent || !cocked)
		return
		
	// Re-check outdoors, the wind-up takes time, and the shooter may have stepped inside since.
	var/area/user_area = get_area(user)
	if(!user_area.outdoors)
		to_chat(user, span_warning("I'm no longer under open sky!"))
		return

	var/turf/origin = get_turf(user)
	var/meaning = codebook[chosen_color]
	var/colored_name = "<font color='[chosen_color]'><b>[chosen_color]</b></font>"

	user.visible_message(span_warning("[user] fires [src]! A [chosen_color] plume of smoke erupts skyward!"))
	playsound(user.loc, pick(fire_sound), 100, TRUE)
	canister.mark_spent()
	cocked = FALSE
	update_gun_icon()

	var/obj/effect/signal_flare_light/muzzle_flash = new(origin)
	muzzle_flash.set_light(4, 2, 2, l_color = "#ffddaa", l_on = TRUE)
	QDEL_IN(muzzle_flash, 0.5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(spawn_smoke_puff), origin), 5)
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke_puff), origin), 10)
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke_puff), origin), 16)

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

/obj/item/flaregun/proc/spawn_smoke_puff(turf/origin)
	new /obj/effect/particle_effect/smoke/arquebus(origin)

/obj/item/flaregun/proc/flare_illuminate(turf/origin, hex, meaning, colored_name, chosen_color, list/can_interpret)
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

		// Embers have a chance to set fire where they land
		if(prob(10)) 	
			new /obj/effect/hotspot(landing)

	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD || isbrain(player))
			continue

		var/distance = get_dist(player, origin)
		if(distance <= 7 || distance > 200)
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
