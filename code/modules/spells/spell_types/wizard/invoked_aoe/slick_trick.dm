/obj/effect/proc_holder/spell/invoked/slick_trick
	name = "Slick Trick"
	desc = "Temporarily create a slippery area that sends victims flying to the floor."
	cost = 5
	range = 4
	ignore_los = FALSE
	releasedrain = 50
	chargedrain = 2
	chargetime = 4 SECONDS
	recharge_time = 45 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	spell_tier = 3 // AOE
	invocations = list("Dolus Lubricus!") //"Slick Trick" in Latin
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_HIGH //Big warning as its AoE

	var/slip_effect_duration = 10 SECONDS
	var/pre_slip_buffer_delay = 0.5 SECONDS
	var/slip_effect_type = TURF_WET_LUBE
	var/area_of_effect_radius = 1 // 1 = 3x3

/obj/effect/proc_holder/spell/invoked/slick_trick/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])

	// Get all turfs in a 3x3 area
	var/list/affected_turfs = list(T)
	for(var/turf/open/O in range(area_of_effect_radius, T))
		affected_turfs += O

	if(affected_turfs.len)
		user.visible_message("<span class='warning'>[user] creates slick patches on the floor!</span>")

		// Apply effect to all open turfs in range
		for(var/turf/open/O in affected_turfs)
			playsound(O, 'sound/foley/waterenter.ogg', 25, TRUE)

			new /obj/effect/temp_visual/slick_warning(O)

			//wait before actually adding the slip for "Slip buffering"
			addtimer(CALLBACK(O, TYPE_PROC_REF(/turf/open, MakeSlippery), slip_effect_type, slip_effect_duration, 0, slip_effect_duration), pre_slip_buffer_delay)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/temp_visual/slick_warning
	name = "slippery patch"
	desc = "Watch your step!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "purplesparkles"
	color = "#0099FF" // Blue tint for water-like appearance
	randomdir = FALSE
	layer = MASSIVE_OBJ_LAYER
	duration = 13 SECONDS //add a couple seconds because the slip lasts longer than intended for some freaking reason

//smaller slick trick for arcane trickster

/obj/effect/proc_holder/spell/invoked/slick_trick_small
	name = "Calistra's Sneaky Slipsquare" //honoring DnD tradition of naming shit after some random MF. who's Calistra? who knows! make some shit up, roleplayer!
	desc = "Sneakily create a temporary slippery square that sends victims flying to the floor."
	cost = 2 
	range = 6 //slightly bigger range for prank purposes
	ignore_los = FALSE
	releasedrain = 25 //half cost bc it's way smaller
	chargedrain = 2
	chargetime = 20 //repel-sized
	recharge_time = 30 SECONDS //smaller cooldown
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	spell_tier = 2 // non AOE version of slick trip
	invocations = list("Lapsus Maximus!") // :)
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_MEDIUM //Not an AOE, but make it flashy and silly still. There's not many other tells that you're the one slipping people. 

	var/slip_effect_duration = 10 SECONDS //same duration bc apparently duration is weird and I don't wanna mess with it, plus it's only one tile
	var/pre_slip_buffer_delay = 0.5 SECONDS
	var/slip_effect_type = TURF_WET_LUBE
	var/area_of_effect_radius = 0 // does 0 make it 1 tile?

/obj/effect/proc_holder/spell/invoked/slick_trick_small/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])

	// make the 1 tile slippery. or get the one tile? idk how this code works i just made area_of_effect_radius 0
	var/list/affected_turfs = list(T)
	for(var/turf/open/O in range(area_of_effect_radius, T))
		affected_turfs += O

	if(affected_turfs.len)
		

		// Apply effect to all open turfs in range
		for(var/turf/open/O in affected_turfs)
			playsound(O, 'sound/foley/waterenter.ogg', 25, TRUE)

			new /obj/effect/temp_visual/slick_warning(O)

			//wait before actually adding the slip for "Slip buffering"
			addtimer(CALLBACK(O, TYPE_PROC_REF(/turf/open, MakeSlippery), slip_effect_type, slip_effect_duration, 0, slip_effect_duration), pre_slip_buffer_delay)
		return TRUE
	revert_cast()
	return FALSE
