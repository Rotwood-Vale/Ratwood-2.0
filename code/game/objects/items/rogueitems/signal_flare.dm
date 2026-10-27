#define FLARE_SHELTER_COLOR "orange"
#define FLARE_ILLUMINATION_COLOR "bright"

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
		"orange" = "'Drop everything. Run and hide.'"
	)

	return GLOB.signal_flare_codebook

// Shared by the canister and the Wolkenmaw itself: what a character's role tells them about the codes,
// independent of whether they're currently holding a live round.
/proc/get_signal_flare_codebook_lines(mob/user)
	var/list/lines = list()
	if(!user)
		return lines
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/static/list/townsfolk = GLOB.youngfolk_positions + GLOB.peasant_positions + GLOB.yeoman_positions + GLOB.church_positions + GLOB.courtier_positions
	if(user.job in can_interpret)
		lines += span_notice("You recognize the signal codes etched in cryptic shorthand markings:")
		for(var/color in codebook)
			lines += span_notice("&nbsp;&nbsp;<font color='[color]'><b>[color]</b></font>: [codebook[color]]")
	else if(user.job in townsfolk)
		lines += span_cult("You recognize the <font color='orange'><b>orange</b></font> flare: every man and woman knows it means [codebook[FLARE_SHELTER_COLOR]]")
	else
		lines += span_notice("The colors carry meaning, but you lack the training to interpret them.")
	return lines

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
	. += get_signal_flare_codebook_lines(user)

/obj/item/signal_flare/attack_self(mob/living/user)
	if(spent)
		to_chat(user, span_notice("It's spent. Nothing left but the smell of burnt powder."))
		return
	to_chat(user, span_notice("I need to load this into a Wolkenmaw to fire it."))

// Held to full charge like shooting a crossbow, so a stray click can't loose a signal.
/datum/intent/use/flaregun
	name = "aim"
	chargetime = 8
	no_early_release = TRUE
	charging_slowdown = 1

/obj/item/signal_flare_gun
	name = "Wolkenmaw"
	desc = "A magical handgonne of wood and dark iron with a wide mouth, a Grenzelhoftian import. Break it open, feed it an alchemical flare canister, and cock it shut to send a brilliant plume of colored smoke visible for miles, inviting either friend or foe. Be wise with it, you fool."
	icon = 'icons/roguetown/items/flaregun.dmi'
	icon_state = "flaregun_unload"
	item_state = "flaregun"
	lefthand_file = 'icons/mob/inhands/weapons/flaregun_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flaregun_righthand.dmi'
	experimental_inhand = FALSE
	experimental_onhip = TRUE
	possible_item_intents = list(/datum/intent/use/flaregun)
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	grid_width = 32
	grid_height = 32
	
	var/obj/item/signal_flare/canister
	var/cocked = FALSE
	var/spawn_loaded = FALSE
	/// Prevents the color menu from opening twice when a single click routes through multiple attack paths.
	var/firing = FALSE
	/// Signal chosen ahead of time. When set, firing skips the menu entirely.
	var/primed_color
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

/obj/item/signal_flare_gun/loaded
	spawn_loaded = TRUE

/obj/item/signal_flare_gun/Initialize(mapload)
	. = ..()
	if(spawn_loaded && !canister)
		canister = new(src)
	update_gun_icon()

/obj/item/signal_flare_gun/Destroy()
	if(canister)
		canister.forceMove(drop_location())
		canister = null
	return ..()

/obj/item/signal_flare_gun/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == canister)
		canister = null
		cocked = FALSE
		update_gun_icon()

// Closed and cocked shows the ready sprite, while broken open shows the unload sprite.
/obj/item/signal_flare_gun/proc/update_gun_icon()
	icon_state = cocked ? "flaregun_default" : "flaregun_unload"

/obj/item/signal_flare_gun/examine(mob/user)
	. = ..()
	if(!canister)
		. += span_notice("Its chamber is empty.")
	else if(canister.spent)
		. += span_notice("A spent canister sits in the chamber. It should be ejected.")
	else if(!cocked)
		. += span_notice("It's loaded, but must be cocked shut before it can fire.")
	else
		. += span_notice("It's loaded and ready to fire.")
	if(primed_color)
		. += span_notice("Its dial is set to [signal_label(primed_color)], ready to fire without further thought.")
	. += span_info("Middle-click it to set its dial ahead of time, so it fires without asking.")
	. += get_signal_flare_codebook_lines(user)

/obj/item/signal_flare_gun/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/signal_flare))
		var/obj/item/signal_flare/new_canister = W
		if(canister)
			to_chat(user, span_warning("There's already a canister in the chamber."))
			return
		if(cocked)
			to_chat(user, span_warning("[src] is snapped shut. I need to break it open before I can load it."))
			return
		if(new_canister.spent)
			to_chat(user, span_warning("This canister is spent. It would accomplish nothing."))
			return
		if(!user.transferItemToLoc(new_canister, src))
			return
		canister = new_canister
		update_gun_icon()
		playsound(src, load_sound, 100)
		user.visible_message(span_notice("[user] slots [new_canister] into [src]'s open chamber. It must be cocked shut before it can fire."))
		return
	return ..()

/obj/item/signal_flare_gun/attack_self(mob/living/user)
	if(!cocked && !canister?.spent)
		cocked = TRUE
		update_gun_icon()
		playsound(src, cock_sound, 100)
		user.visible_message(span_notice("[user] snaps [src] shut and cocks it[canister ? ". It's ready to fire" : ""]."))
		return
	eject_canister(user)

/obj/item/signal_flare_gun/proc/dry_fire(mob/living/user)
	playsound(src, dry_fire_sound, 30, TRUE)
	user.visible_message(span_danger("[src]'s hammer falls on an empty chamber. *click*"))

/obj/item/signal_flare_gun/proc/signal_label(signal)
	return signal == FLARE_ILLUMINATION_COLOR ? "illumination" : signal

/obj/item/signal_flare_gun/MiddleClick(mob/user, params)
	if(!isliving(user) || user.incapacitated())
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)
	set_signal_dial(user)

/obj/item/signal_flare_gun/proc/set_signal_dial(mob/living/user)
	// Labelled distinctly from the firing menu so the two are never mistaken for each other.
	var/list/choices = list()
	var/list/signals = build_flare_choices(user)
	for(var/label in signals)
		choices["Set dial: [label]"] = signals[label]
	choices["Ask each time"] = null
	var/picked = input(user, "Set which signal fires without prompting.", "Prime Signal") as null|anything in choices
	if(!picked)
		return
	if(QDELETED(src) || !Adjacent(user) || user.incapacitated())
		return
	primed_color = choices[picked]
	if(!primed_color)
		to_chat(user, span_notice("I clear [src]'s dial. It will ask before each shot."))
		return
	to_chat(user, span_notice("I set [src]'s dial to [signal_label(primed_color)]."))

/obj/item/signal_flare_gun/attack_right(mob/user)
	if(canister && isliving(user))
		eject_canister(user)
		return
	return ..()

/obj/item/signal_flare_gun/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(!istype(user))
		return
	if(proximity_flag && ((target in user.contents) || !isturf(target)))
		return
	if(!cocked)
		to_chat(user, span_warning("[src] needs to be cocked first."))
		return
	if(!canister || canister.spent)
		dry_fire(user)
		return
	// Checked here rather than in the click chain, as bows and crossbows do.
	if(user.client && user.client.chargedprog < 100)
		to_chat(user, span_warning("I didn't hold [src] skyward long enough."))
		return
	fire_flare(user)

/obj/item/signal_flare_gun/proc/eject_canister(mob/living/user)
	var/obj/item/signal_flare/ejected_canister = canister
	canister = null
	cocked = FALSE
	update_gun_icon()
	playsound(src, break_open_sound, 100)
	if(!ejected_canister)
		user.visible_message(span_notice("[user] breaks [src] open. The chamber is empty."))
		return
	ejected_canister.forceMove(get_turf(src))
	if(ejected_canister.spent)
		user.visible_message(span_notice("[user] breaks open [src], and the spent canister clatters to the ground."))
	else
		user.visible_message(span_notice("[user] breaks open [src], and the canister tumbles to the ground."))

/obj/item/signal_flare_gun/proc/fire_flare(mob/living/user)
	if(firing)
		return
	var/area/user_area = get_area(user)
	if(!user_area.outdoors)
		to_chat(user, span_warning("I need to be under open sky to fire this."))
		return
	firing = TRUE
	do_fire_flare(user)
	firing = FALSE

/obj/item/signal_flare_gun/proc/build_flare_choices(mob/living/user)
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/user_can_interpret = (user.job in can_interpret)
	var/list/choices = list()

	// Carries no code, so anyone can fire it and nobody reads meaning into it. Just light.
	choices["Illumination"] = FLARE_ILLUMINATION_COLOR

	for(var/color in codebook)
		if(color == FLARE_SHELTER_COLOR && !can_fire_shelter_signal(user))
			continue
		// Sorted by alphabet in both instances, cannot be cheesed by non-garrison players.
		if(user_can_interpret)
			// Sorted by meaning
			choices["[codebook[color]]: ([capitalize(color)])"] = color
		else
			// Sorted by color. So no ability to cheese by memorizing order, methinks?
			choices["[capitalize(color)]"] = color

	return choices

/obj/item/signal_flare_gun/proc/can_fire_shelter_signal(mob/living/user)
	var/static/list/shelter_authorized = list("Grand Duke", "Marshal", "Hand", "Knight Captain")
	return (user.job in shelter_authorized)

/obj/item/signal_flare_gun/proc/do_fire_flare(mob/living/user)
	var/list/codebook = get_signal_flare_codebook()
	var/static/list/can_interpret = GLOB.garrison_positions + GLOB.noble_positions
	var/chosen_color = primed_color

	// A signal primed by someone else doesn't grant their authority to fire it.
	if(chosen_color == FLARE_SHELTER_COLOR && !can_fire_shelter_signal(user))
		chosen_color = null

	if(!chosen_color)
		var/list/choices = build_flare_choices(user)
		var/picked = input(user, "Choose which signal to fire.", "Signal Flare") as null|anything in choices
		if(!picked)
			return
		chosen_color = choices[picked]

	if(!canister || canister.spent)
		return

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
	if(chosen_color == FLARE_ILLUMINATION_COLOR)
		colored_name = "<font color='white'><b>brilliant white</b></font>"

	user.visible_message(span_warning("[user] fires [src]! A [chosen_color] plume of smoke erupts skyward!"))
	playsound(user.loc, pick(fire_sound), 100, TRUE)
	canister.mark_spent()

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
		"orange" = "#ff9944",
		"bright" = "#ffffff"
	)

	var/hex = flare_hex[chosen_color]
	addtimer(CALLBACK(src, PROC_REF(flare_illuminate), origin, hex, meaning, colored_name, chosen_color, can_interpret), 2 SECONDS)

/obj/item/signal_flare_gun/proc/spawn_smoke_puff(turf/origin)
	new /obj/effect/particle_effect/smoke/arquebus(origin)

/obj/item/signal_flare_gun/proc/flare_illuminate(turf/origin, hex, meaning, colored_name, chosen_color, list/can_interpret)
	// Illumination rounds burn wider and longer. Everything else is a normal flare.
	var/illuminating = (chosen_color == FLARE_ILLUMINATION_COLOR)
	var/glow_range = illuminating ? 12 : 8
	var/glow_duration = illuminating ? 30 SECONDS : 10 SECONDS

	// Burn above the rooftops where there's open sky, so walls don't swallow the light.
	var/turf/glow_turf = origin
	var/turf/above = get_step_multiz(origin, UP)
	if(above && isopenspace(above))
		glow_turf = above

	var/obj/effect/signal_flare_light/glow = new(glow_turf)
	glow.set_light(glow_range, 4, 3, l_color = hex, l_on = TRUE)

	QDEL_IN(glow, glow_duration)

	playsound(origin, pick('sound/misc/explode/explosionfar (1).ogg', 'sound/misc/explode/explosionfar (2).ogg', 'sound/misc/explode/explosionfar (3).ogg'), 40, TRUE)

	var/list/scatter_turfs = list()
	var/area/turf_area

	for(var/turf/candidate_turf in range(7, origin))
		turf_area = get_area(candidate_turf)
		if(isopenturf(candidate_turf) && turf_area.outdoors)
			scatter_turfs += candidate_turf

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

		var/obj/effect/signal_flare_remnant/remnant = new(landing)

		remnant.color = hex
		var/mutable_appearance/ember_glow = mutable_appearance(remnant.icon, remnant.icon_state)
		ember_glow.blend_mode = BLEND_ADD
		ember_glow.color = hex
		remnant.overlays += ember_glow
		remnant.set_light(2, 1, 2, l_color = hex, l_on = TRUE)

		QDEL_IN(remnant, 60 SECONDS)

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

		if(can_interpret_flare && meaning)
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
