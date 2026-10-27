//pulled in from vanderlin
/obj/item/rotation_contraption
	name = ""
	desc = ""

	w_class =  WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 32

	var/obj/structure/placed_type
	var/in_stack = 1
	var/can_stack = TRUE
	var/place_behavior
	var/resize_factor = 0.95
	/// Optional item-side appearance overrides, so the held/dropped item can differ from the
	/// structure it places. When unset, the item mirrors the placed structure (icon + "[name] item").
	var/item_icon
	var/item_icon_state
	var/item_name
	/// Whether to apply the shared "diamond" look (half scale + 45° turn) to the held/dropped item.
	/// Reskinned items turn this off to show their own sprite normally (upright, full size).
	var/contraption_transform = TRUE

/obj/item/rotation_contraption/Initialize(mapload)
	. = ..()
	if(placed_type)
		set_type(placed_type)
	if(can_stack)
		for(var/obj/item/rotation_contraption/contraption in loc)
			if(QDELETED(contraption))
				continue
			if(contraption == src)
				continue
			if(!istype(contraption, src.type))
				continue
			if(placed_type != contraption.placed_type)
				continue

			in_stack += contraption.in_stack
			qdel(contraption)
	//update_appearance(UPDATE_NAME)
	vand_update_appearance(UPDATE_NAME)

// ES adaptation: afterpickup/afterdrop are never invoked in our inventory code, and the base
// update_transform() nulls the matrix on every drop/throw — reapply our look there instead.
/obj/item/rotation_contraption/update_transform()
	. = ..()
	if(!contraption_transform)
		return
	var/matrix/resize = matrix()
	resize.Scale(0.5, 0.5)
	resize.Turn(45)
	transform = resize
	if(resize_factor)
		transform = transform.Scale(resize_factor, resize_factor)

/obj/item/rotation_contraption/proc/set_type(obj/structure/parent_type)
	icon = item_icon || initial(parent_type.icon)
	icon_state = item_icon_state || initial(parent_type.icon_state)
	if(contraption_transform)
		var/matrix/resize = matrix()
		resize.Scale(0.5, 0.5)
		resize.Turn(45)
		transform = resize
		if(resize_factor)
			transform = transform.Scale(resize_factor, resize_factor)
	name = item_name || (initial(parent_type.name) + " item")
	desc = initial(parent_type.desc)
	placed_type = parent_type

/obj/item/rotation_contraption/attack_turf(turf/T, mob/living/user)
	. = ..()
	if(!istype(T))
		return
	// if(is_blocked_turf(T))
	// 	return
	for(var/obj/structure/structure in T.contents)

		if(structure.rotation_structure)// && !ispath(placed_type, /obj/structure/water_pipe))//commenting out water pipes for now 
			return

		if(structure.accepts_water_input && !ispath(placed_type, /obj/structure/rotation_piece))
			return

		if(istype(structure, placed_type))
			return

	visible_message("[user] starts placing down [src].", "You start to place [src].")
	if(!do_after(user, 1.2 SECONDS - user?.get_skill_level(/datum/skill/craft/engineering), T))
		return
	var/obj/structure/structure = new placed_type(T)
	if(place_behavior == PLACE_TOWARDS_USER)
		if(get_turf(user) == T)
			structure.setDir(REVERSE_DIR(user.dir))
		else
			structure.setDir(get_cardinal_dir(T, user))
	else
		if(get_turf(user) == T)
			structure.setDir(user.dir)
		else
			structure.setDir(get_cardinal_dir(user, T))

	in_stack--
	if(in_stack <= 0)
		qdel(src)
	else
		//update_appearance(UPDATE_NAME)
		vand_update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/vand_update_name()
	. = ..()
	if(in_stack > 1)
		var/base = item_name || initial(placed_type.name)
		var/suffix = "s"
		if(copytext(base, length(base)) in list("s", "x", "z")) // "gearboxes", not "gearboxs"
			suffix = "es"
		name = "pile of [base][suffix] x [in_stack]"
	else
		name = item_name || (initial(placed_type.name) + " item")

/obj/item/rotation_contraption/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!can_stack)
		return
	if(!istype(I, src.type))
		return
	if(placed_type != I:placed_type)
		return

	I:in_stack += in_stack
	visible_message("[user] collects [src].")
	qdel(src)
	//I.update_appearance(UPDATE_NAME)
	I.vand_update_appearance(UPDATE_NAME)

/obj/item/rotation_contraption/cog
	placed_type = /obj/structure/rotation_piece/cog

/obj/item/rotation_contraption/shaft
	placed_type = /obj/structure/rotation_piece
	// reskin to the wood-shaft sprite and a distinct name (it still places a rotation_piece)
	item_icon = 'icons/roguetown/misc/shafts.dmi'
	item_icon_state = "woodshaft"
	item_name = "engineering shaft"
	contraption_transform = FALSE // show the wood-shaft sprite upright, not the diamond look

/obj/item/rotation_contraption/large_cog
	placed_type = /obj/structure/rotation_piece/cog/large

/obj/item/rotation_contraption/horizontal
	placed_type = /obj/structure/gearbox

/obj/item/rotation_contraption/vertical
	placed_type = /obj/structure/vertical_gearbox

/obj/item/rotation_contraption/waterwheel
	placed_type = /obj/structure/waterwheel

	grid_height = 96
	grid_width = 96


/obj/item/rotation_contraption/minecart_rail
	placed_type = /obj/structure/minecart_rail

	grid_height = 64
	grid_width = 32

/obj/item/rotation_contraption/minecart_rail/railbreak
	placed_type = /obj/structure/minecart_rail/railbreak

	grid_height = 64
	grid_width = 32

/* commenting out water pipes for now 
/obj/item/rotation_contraption/water_pipe
	placed_type = /obj/structure/water_pipe
/obj/item/rotation_contraption/pump
	placed_type = /obj/structure/water_pump
	can_stack = FALSE
	grid_height = 96
	grid_width = 96
	place_behavior = PLACE_TOWARDS_USER
/obj/item/rotation_contraption/boiler
	placed_type = /obj/structure/boiler
	can_stack = FALSE
	grid_height = 96
	grid_width = 96
	place_behavior = PLACE_TOWARDS_USER
/obj/item/rotation_contraption/steam_recharger
	placed_type = /obj/structure/steam_recharger
	can_stack = FALSE
	grid_height = 96
	grid_width = 96
	place_behavior = PLACE_TOWARDS_USER
/obj/item/rotation_contraption/water_vent
	placed_type = /obj/structure/water_vent
	grid_height = 64
	grid_width = 64
	place_behavior = PLACE_TOWARDS_USER
*/
