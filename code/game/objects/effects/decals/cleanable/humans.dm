
/obj/effect/decal/cleanable/coom
	name = "mess"
	desc = ""
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "mess1"
	random_icon_states = list("mess1", "mess2", "mess3")
	beauty = -100
	alpha = 150
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = NO_CLIENT_COLOR
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/coom/Initialize(mapload)
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)
	if(prob(75))
		var/matrix/M = new
		M.Turn(90 * rand(1, 3)) // turn by 90 degrees
		transform = M

/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6")
	blood_state = BLOOD_STATE_HUMAN
	bloodiness = BLOOD_AMOUNT_PER_DECAL
	beauty = -100
	alpha = 200
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = NO_CLIENT_COLOR
	var/blood_timer
	/// Donor tint. The sprite is a greyscale mask; this color multiplies it.
	var/blood_color = BLOOD_COLOR_DEFAULT
	/// Chosen when the stain is made, so drying does not guess from the wet hex later.
	var/dried_color = BLOOD_COLOR_DRIED
	/// Icon file the states were taken from, kept after icon is swapped for a greyscale mask.
	var/blood_icon_file
	var/dried = FALSE

/obj/effect/decal/cleanable/blood/Initialize(mapload, new_blood_color)
	if(!blood_icon_file)
		blood_icon_file = icon
	if(new_blood_color)
		blood_color = new_blood_color
	dried_color = get_dried_blood_color(blood_color)
	. = ..()
	GLOB.weather_act_upon_list += src
	if(. == INITIALIZE_HINT_QDEL)
		return .
	pixel_x = rand(-5,5)
	pixel_y = rand(5,5)
	blood_timer = addtimer(CALLBACK(src, PROC_REF(become_dry)), rand(5 MINUTES,8 MINUTES), TIMER_STOPPABLE)
	apply_blood_visual()

/obj/effect/decal/cleanable/blood/proc/set_blood_color(new_color)
	if(!new_color || dried)
		return
	blood_color = new_color
	dried_color = get_dried_blood_color(blood_color)
	apply_blood_visual()

/obj/effect/decal/cleanable/blood/proc/apply_blood_visual()
	if(!blood_icon_file || !icon_state)
		return
	var/icon/mask = get_greyscale_blood_icon(blood_icon_file, icon_state)
	if(mask)
		icon = mask
	color = dried ? dried_color : blood_color

/obj/effect/decal/cleanable/blood/add_blood_DNA(list/dna, new_blood_color)
	if(new_blood_color)
		set_blood_color(new_blood_color)
	return ..()

/obj/effect/decal/cleanable/blood/proc/become_dry()
	if(QDELETED(src))
		return
	name = "dry [initial(name)]"
	dried = TRUE
	bloodiness = 0
	color = dried_color

/obj/effect/decal/cleanable/blood/replace_decal(obj/effect/decal/cleanable/C)
	. = ..()
	if(C)
		var/obj/effect/decal/cleanable/blood/existing = C
		existing.alpha = initial(alpha)
		existing.bloodiness = initial(bloodiness)
		existing.name = initial(name)
		existing.dried = FALSE
		if(blood_color)
			existing.blood_color = blood_color
			existing.dried_color = dried_color
		existing.apply_blood_visual()

/obj/effect/decal/cleanable/blood/Destroy()
	GLOB.weather_act_upon_list -= src
	deltimer(blood_timer)
	blood_timer = null
	return ..()

/obj/effect/decal/cleanable/blood/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN)
		return
	qdel(src)

/obj/effect/decal/cleanable/blood/old
	name = "dried blood"
	desc = ""
	bloodiness = 0
	icon_state = "floor1-old"

/obj/effect/decal/cleanable/blood/old/Initialize(mapload, new_blood_color)
	add_blood_DNA(list("Non-human DNA" = random_blood_type())) // Needs to happen before ..()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return .
	icon_state = "[icon_state]-old" //change from the normal blood icon selected from random_icon_states in the parent's Initialize to the old dried up blood.
	apply_blood_visual()

/obj/effect/decal/cleanable/blood/splatter
	icon_state = "gibbl1"
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")
	var/drips = 1

/obj/effect/decal/cleanable/blood/splatter/replace_decal(obj/effect/decal/cleanable/C) // Returns true if we should give up in favor of the pre-existing decal
	if(..())
		var/obj/effect/decal/cleanable/blood/splatter/P = C
		P.drips++
		if(P.drips > 2)
			var/turf/T = loc
			if(istype(T))
				new /obj/effect/decal/cleanable/blood(T, P.blood_color)
				qdel(P)
		return TRUE


/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = ""
	random_icon_states = null
	beauty = -50

/obj/effect/decal/cleanable/trail_holder //not a child of blood on purpose
	name = "blood"
	icon = 'icons/effects/blood.dmi'
	desc = ""
	beauty = -50
	var/list/existing_dirs = list()
	alpha = 200
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = NO_CLIENT_COLOR
	var/blood_timer
	var/blood_color = BLOOD_COLOR_DEFAULT
	var/dried_color = BLOOD_COLOR_DRIED
	var/dried = FALSE
	var/list/trail_pieces

/obj/effect/decal/cleanable/trail_holder/Initialize(mapload, new_blood_color)
	if(new_blood_color)
		blood_color = new_blood_color
	dried_color = get_dried_blood_color(blood_color)
	color = null
	icon_state = ""
	. = ..()
	GLOB.weather_act_upon_list += src
	if(. == INITIALIZE_HINT_QDEL)
		return .
	blood_timer = addtimer(CALLBACK(src, PROC_REF(become_dry)), rand(5 MINUTES,8 MINUTES), TIMER_STOPPABLE)

/obj/effect/decal/cleanable/trail_holder/Destroy()
	GLOB.weather_act_upon_list -= src
	deltimer(blood_timer)
	blood_timer = null
	return ..()

/obj/effect/decal/cleanable/trail_holder/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN)
		return
	qdel(src)

/obj/effect/decal/cleanable/trail_holder/proc/add_trail(trail_type, newdir)
	if(!trail_type)
		return
	LAZYINITLIST(trail_pieces)
	trail_pieces.len++
	trail_pieces[trail_pieces.len] = list("state" = trail_type, "dir" = newdir)
	update_trail_visuals()

/obj/effect/decal/cleanable/trail_holder/proc/update_trail_visuals()
	cut_overlays()
	color = null
	var/use_color = dried ? dried_color : blood_color
	if(!use_color)
		use_color = BLOOD_COLOR_DEFAULT
	for(var/list/piece in trail_pieces)
		var/image/trail_image = image(get_colored_blood_mask('icons/effects/blood.dmi', piece["state"], use_color), null, piece["state"], , piece["dir"])
		trail_image.alpha = alpha
		add_overlay(trail_image)

/obj/effect/decal/cleanable/trail_holder/proc/set_blood_color(new_color)
	if(!new_color || dried)
		return
	blood_color = new_color
	dried_color = get_dried_blood_color(blood_color)
	update_trail_visuals()

/obj/effect/decal/cleanable/trail_holder/proc/become_dry()
	if(QDELETED(src))
		return
	name = "dry [initial(name)]"
	dried = TRUE
	alpha = 100
	color = null
	update_trail_visuals()
	bloodiness = 0

/obj/effect/decal/cleanable/trail_holder/can_bloodcrawl_in()
	return TRUE

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	icon_state = "gib1"
	layer = LOW_OBJ_LAYER
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	mergeable_decal = FALSE

	var/already_rotting = FALSE


/obj/effect/decal/cleanable/blood/gibs/Crossed(mob/living/L)
	if(istype(L))
		playsound(loc, 'sound/blank.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 20 : 50, TRUE)
	. = ..()

/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions)
	set waitfor = FALSE
	var/list/diseases = list()
	SEND_SIGNAL(src, COMSIG_GIBS_STREAK, directions, diseases)
	var/direction = pick(directions)
	for(var/i in 0 to rand(1,3))
		sleep(2)
		if(i > 0)
			new /obj/effect/decal/cleanable/blood/splatter(loc, blood_color)
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/blood/gibs/up
	icon_state = "gibup1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	icon_state = "gibdown1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	icon_state = "gibtorso"
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/torso
	icon_state = "gibtorso"
	random_icon_states = null

/obj/effect/decal/cleanable/blood/gibs/limb
	icon_state = "gibleg"
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	icon_state = "gibmid1"
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = ""
	bloodiness = 0
	already_rotting = TRUE

/obj/effect/decal/cleanable/blood/gibs/old/Initialize(mapload, new_blood_color)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return .
	setDir(pick(1,2,4,8))
	icon_state += "-old"
	add_blood_DNA(list("Non-human DNA" = random_blood_type()))
	apply_blood_visual()

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = ""
	icon_state = "drip1"
	bloodiness = 0
	alpha = 150
	var/drips = 1
	var/blood_vol = 1
	random_icon_states = null

/obj/effect/decal/cleanable/blood/drip/Initialize(mapload, new_blood_color)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return .
	setDir(pick(1,2,4,8))

/obj/effect/decal/cleanable/blood/drip/can_bloodcrawl_in()
	return TRUE

/obj/effect/decal/cleanable/blood/drip/update_icon()
	icon_state = "drip[drips]"
	apply_blood_visual()
	if(drips > 5)
		var/turf/T = loc
		if(istype(T))
			var/obj/effect/decal/cleanable/blood/puddle/PUD = locate() in T
			if(!PUD)
				PUD = new(T, blood_color)
				PUD.blood_vol = blood_vol
				PUD.update_icon()

/obj/effect/decal/cleanable/blood/drip/replace_decal(obj/effect/decal/cleanable/C) // Returns true if we should give up in favor of the pre-existing decal
	if(..())
		var/obj/effect/decal/cleanable/blood/drip/P = C
		P.drips++
		if(P.drips > 5)
			var/turf/T = loc
			if(istype(T))
				var/obj/effect/decal/cleanable/blood/puddle/PUD = new(T, P.blood_color)
				PUD.blood_vol = blood_vol
				PUD.update_icon()
				qdel(P)
		else
			P.update_icon()
		return TRUE

/obj/effect/decal/cleanable/blood/puddle
	name = "puddle of blood"
	desc = ""
	icon_state = "pool1"
	bloodiness = 0
	alpha = 150
	var/blood_vol = 10
	random_icon_states = null

/obj/effect/decal/cleanable/blood/puddle/update_icon()
	switch(blood_vol)
		if(450 to INFINITY)
			icon_state = "pool5"
		if(350 to 450)
			icon_state = "pool4"
		if(250 to 350)
			icon_state = "pool3"
		if(50 to 250)
			icon_state = "pool2"
		if(1 to 50)
			icon_state = "pool1"
	apply_blood_visual()

/obj/effect/decal/cleanable/blood/puddle/replace_decal(obj/effect/decal/cleanable/C) // Returns true if we should give up in favor of the pre-existing decal
	if(..())
		var/obj/effect/decal/cleanable/blood/puddle/P = C
		P.blood_vol += 10
		P.update_icon()
		return TRUE

/obj/effect/decal/cleanable/blood/puddle/attack_hand(mob/living/user)
	. = ..()
	if(!ishuman(user) || blood_vol <= 0)
		return

	var/mob/living/carbon/human/H = user
	if(H.dna?.species?.id != "gnoll")
		return

	if(!H.gnoll_bloodpool_feed())
		return

	playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)
	H.changeNext_move(CLICK_CD_MELEE)
	blood_vol = max(blood_vol - 25, 0)
	if(blood_vol <= 0)
		qdel(src)
	else
		update_icon()


//BLOODY/MUDDY/SNOWY FOOTPRINTS
/obj/effect/decal/cleanable/blood/footprints
	name = "footprints"
	desc = ""
	icon = 'icons/effects/footprints.dmi'
	icon_state = "blood1"
	random_icon_states = null
	blood_state = BLOOD_STATE_HUMAN //the icon state to load images from
	var/entered_dirs = 0
	var/exited_dirs = 0
	alpha = 140
	bloodiness = 0
	var/list/shoe_types = list()

/obj/effect/decal/cleanable/blood/footprints/mud
	icon_state = "mud1"
	blood_state = BLOOD_STATE_MUD

/obj/effect/decal/cleanable/blood/footprints/apply_blood_visual()
	if(blood_state != BLOOD_STATE_HUMAN)
		color = null
		return
	color = null
	update_icon()

/obj/effect/decal/cleanable/blood/footprints/become_dry()
	if(QDELETED(src))
		return
	name = "dry [initial(name)]"
	dried = TRUE
	bloodiness = 0
	color = null
	apply_blood_visual()

/obj/effect/decal/cleanable/blood/footprints/Initialize(mapload, new_blood_color)
	. = ..()
	icon_state = "" //All of the footprint visuals come from overlays
	if(mapload)
		entered_dirs |= dir //Keep the same appearance as in the map editor
		update_icon()

//Rotate all of the footprint directions too
/obj/effect/decal/cleanable/blood/footprints/setDir(newdir)
	if(dir == newdir)
		return ..()

	var/ang_change = dir2angle(newdir) - dir2angle(dir)
	var/old_entered_dirs = entered_dirs
	var/old_exited_dirs = exited_dirs
	entered_dirs = 0
	exited_dirs = 0

	for(var/Ddir in GLOB.cardinals)
		if(old_entered_dirs & Ddir)
			entered_dirs |= angle2dir_cardinal(dir2angle(Ddir) + ang_change)
		if(old_exited_dirs & Ddir)
			exited_dirs |= angle2dir_cardinal(dir2angle(Ddir) + ang_change)

	update_icon()
	return ..()

/obj/effect/decal/cleanable/blood/footprints/Crossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(istype(S) && S.bloody_shoes[blood_state])
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			shoe_types |= S.type
			if (!(entered_dirs & H.dir))
				entered_dirs |= H.dir
				update_icon()

/obj/effect/decal/cleanable/blood/footprints/Uncrossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		if(istype(S) && S.bloody_shoes[blood_state])
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			shoe_types  |= S.type
			if (!(exited_dirs & H.dir))
				exited_dirs |= H.dir
				update_icon()


/obj/effect/decal/cleanable/blood/footprints/update_icon()
	cut_overlays()
	var/tint_steps = (blood_state == BLOOD_STATE_HUMAN)
	var/step_icon = blood_icon_file || icon
	var/print_color = dried ? dried_color : (blood_color || BLOOD_COLOR_DEFAULT)

	for(var/Ddir in GLOB.cardinals)
		if(entered_dirs & Ddir)
			var/entered_key = "entered-[blood_state]-[Ddir][(tint_steps) ? "-[print_color]" : ""]"
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache[entered_key]
			if(!bloodstep_overlay)
				if(tint_steps)
					bloodstep_overlay = image(get_colored_blood_mask(step_icon, "[blood_state]1", print_color), null, "[blood_state]1", , Ddir)
				else
					bloodstep_overlay = image(step_icon, null, "[blood_state]1", , Ddir)
				GLOB.bloody_footprints_cache[entered_key] = bloodstep_overlay
			bloodstep_overlay.alpha = alpha
			add_overlay(bloodstep_overlay)
		if(exited_dirs & Ddir)
			var/exited_key = "exited-[blood_state]-[Ddir][(tint_steps) ? "-[print_color]" : ""]"
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache[exited_key]
			if(!bloodstep_overlay)
				if(tint_steps)
					bloodstep_overlay = image(get_colored_blood_mask(step_icon, "[blood_state]2", print_color), null, "[blood_state]2", , Ddir)
				else
					bloodstep_overlay = image(step_icon, null, "[blood_state]2", , Ddir)
				GLOB.bloody_footprints_cache[exited_key] = bloodstep_overlay
			bloodstep_overlay.alpha = alpha
			add_overlay(bloodstep_overlay)

//	alpha = BLOODY_FOOTPRINT_BASE_ALPHA+bloodiness


/obj/effect/decal/cleanable/blood/footprints/examine(mob/user)
	. = ..()
	if(isliving(user))
		var/mob/living/L = user
		if(L.STAINT < 12)
			return
	if(shoe_types.len)
		. += "You recognise the footprints as belonging to:\n"
		for(var/shoe in shoe_types)
			var/obj/item/clothing/shoes/S = shoe
			. += "[icon2html(initial(S.icon), user)] Some <B>[initial(S.name)]</B>.\n"

/obj/effect/decal/cleanable/blood/footprints/replace_decal(obj/effect/decal/cleanable/C)
	if(blood_state != C.blood_state) //We only replace footprints of the same type as us
		return
	return TRUE //no special overlay code

/obj/effect/decal/cleanable/blood/footprints/can_bloodcrawl_in()
	if((blood_state != BLOOD_STATE_OIL) && (blood_state != BLOOD_STATE_NOT_BLOODY))
		return 1
	return 0

//For fancy wall messes...
/obj/effect/decal/cleanable/blood/splatter/walls
	icon_state = "splatter1"
	plane = GAME_PLANE
	layer = BULLET_HOLE_LAYER //For obvious reasons.
	random_icon_states = list("splatter1", "splatter2", "splatter3", "splatter4", "splatter5", "splatter6")

/obj/effect/decal/cleanable/blood/splatter/walls/Initialize(mapload, new_blood_color)
	. = ..()
	auto_turn_destructive()
	dir = GLOB.reverse_dir[dir]
	if(dir == NORTH)
		src.pixel_y = -32
	if(dir == EAST)
		src.pixel_x = -32
	if(dir == SOUTH)
		src.pixel_y = 32
	if(dir == WEST)
		src.pixel_x = 32
	pixel_x += rand(-5,5)
	pixel_y += rand(-5,5)

/obj/effect/decal/cleanable/blood/splatter/walls/replace_decal(obj/effect/decal/cleanable/C)
	return //We don't want to replace decals for wall turfs since these are unique. May be changed in the future if it's too much.
