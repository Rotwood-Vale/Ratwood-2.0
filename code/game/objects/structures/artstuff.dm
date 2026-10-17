/obj/item/canvas
	name = "canvas"
	desc = "A perfect place to paint"

	icon = 'icons/roguetown/items/paint_supplies/canvas_32.dmi'
	icon_state = "canvas"

	var/easel_offset = 9
	var/canvas_size_x = 32
	var/canvas_size_y = 32

	var/atom/movable/screen/canvas/used_canvas
	var/list/showers = list()

	var/icon/draw
	var/icon/base

	var/title
	var/author
	var/author_ckey
	var/canvas_size = "32x32"
	var/reject = FALSE
	/// Whether anything has been painted on this canvas.
	var/painted = FALSE
	/// Whether this canvas displays a painting loaded from the archive, which cannot be signed or archived again.
	var/archived = FALSE

	var/canvas_icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	var/canvas_icon_state = "canvas"
	var/canvas_screen_loc = "6,6"
	var/canvas_divider_x = 5
	var/canvas_divider_y = 5
	var/pixel_size_x = 4
	var/pixel_size_y = 4

	var/list/overlay_to_index = list()
	var/current_overlays = 0

/obj/item/canvas/Initialize(mapload)
	. = ..()
	used_canvas = new
	used_canvas.host = src
	used_canvas.base_icon = icon(icon, icon_state)
	used_canvas.icon = canvas_icon
	used_canvas.screen_loc = canvas_screen_loc
	used_canvas.icon_state = canvas_icon_state
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	underlays += base
	icon = draw
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_showers))

/obj/item/canvas/Destroy()
	. = ..()
	if(used_canvas?.host == src)
		used_canvas.host = null
	for(var/mob/mob in showers)
		remove_shower(mob)

/obj/item/canvas/examine(mob/user)
	. = ..()
	if(archived)
		return
	if(title)
		. += span_info("It can be archived at a printing press.")
	else
		. += span_info("It can be signed with a feather, then archived at a printing press.")

/obj/item/canvas/attack_hand(mob/user)
	. = ..()
	if(user.cmode)
		if(anchored)
			to_chat(user, "You start unmounting [src]")
			if(!do_after(user, 3 SECONDS, target = src))
				return
			anchored = FALSE
			to_chat(user, "You unmount [src]")

/obj/item/canvas/attack_right(mob/user)
	. = ..()
	if(user.get_active_held_item())
		return
	if(user in showers)
		return
	user?.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_shower))

/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/natural/feather))
		if(archived)
			to_chat(user, span_warning("This painting has already been signed."))
			return
		var/new_title = stripped_input(user, "What's the title of this painting?", "Title", "", MAX_NAME_LEN)
		if(!new_title)
			to_chat(user, span_warning("A painting needs a title to be signed."))
			return
		if(!player_archive_filename(new_title))
			to_chat(user, span_warning("Choose a shorter title that does not begin with an underscore."))
			return
		author = player_archive_author_name(user)
		author_ckey = user.ckey
		title = new_title
		reject = FALSE
		name = title
		desc = "Painted by: [author]."
		return

	if(!istype(I, /obj/item/paint_brush))
		return
	if(user in showers)
		return
	user?.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_shower))

/obj/item/canvas/proc/remove_showers()
	for(var/mob/mob in showers)
		remove_shower(mob)

/obj/item/canvas/attack_turf(turf/T, mob/living/user)
	. = ..()
	to_chat(user, "You start mounting [src] to [T]")
	if(!do_after(user, 3 SECONDS, target = T))
		return
	forceMove(T)
	pixel_x = 0
	pixel_y = 0
	anchored = TRUE
	to_chat(user, "You mount [src] to [T]")

/obj/item/canvas/proc/remove_shower(mob/source)
	showers -= source
	source.client?.screen -= used_canvas
	UnregisterSignal(source, COMSIG_MOVABLE_TURF_ENTERED)

/obj/item/canvas/proc/update_drawing(x, y, current_color)
	painted = TRUE
	if("[x][y]" in overlay_to_index)
		cut_overlay(overlay_to_index["[x][y]"])
		overlay_to_index -= "[x][y]"
	var/mutable_appearance/MA = mutable_appearance('icons/roguetown/items/paint_supplies/pixel.dmi', "pixel")
	MA.color = current_color
	MA.pixel_x = x
	MA.pixel_y = y
	add_overlay(MA)
	overlay_to_index |= "[x][y]"
	overlay_to_index["[x][y]"] = MA
	current_overlays++
	if(current_overlays > 150)
		icon = usr.client.RenderIcon(src)
		current_overlays = 0
		cut_overlays()
		overlay_to_index = list()

/// Whether this canvas is unpainted and unsigned, so it can be used to print an archived painting.
/obj/item/canvas/proc/is_blank()
	return !painted && !archived && !title

/// Displays the archived painting stored under a filename on this canvas. Returns FALSE if it is missing or a different size.
/obj/item/canvas/proc/load_archived_painting(file_name)
	var/list/painting_data = SSpaintings.file2playerpainting(file_name)
	var/image_path = SSpaintings.get_painting_image_path(file_name)
	if(!painting_data["painting_title"] || painting_data["canvas_size"] != canvas_size || !fexists(image_path))
		return FALSE
	icon = icon(file(image_path))
	name = painting_data["painting_title"]
	if(painting_data["author"])
		desc = "Painted by: [painting_data["author"]][painting_data["ic_date"] ? ", [painting_data["ic_date"]]" : ""]."
	var/icon/new_icon = getFlatIcon(src)
	new_icon.Scale(canvas_size_x * canvas_divider_x, canvas_size_y * canvas_divider_y)
	used_canvas.draw.Blend(new_icon, ICON_OVERLAY)
	used_canvas.icon = used_canvas.draw
	archived = TRUE
	return TRUE

/obj/item/canvas/proc/upload_painting(mob/user)
	if(!author || !title || !user?.client)
		player_archive_feedback(user, "A painting needs a title and an author before it can be archived.")
		return FALSE
	var/icon/rendered = user.client.RenderIcon(src)
	if(!rendered)
		player_archive_feedback(user, "The painting could not be rendered for the archive.")
		return FALSE
	cut_overlays()
	icon = rendered
	return SSpaintings.playerpainting2file(icon, title, author, author_ckey, canvas_size, src, user)

/atom/movable/screen/canvas
	icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	icon_state = "canvas"
	screen_loc = "6,6"

	var/obj/item/canvas/host
	var/list/modified_areas = list()
	var/icon/base_icon
	var/icon/draw
	var/icon/base

	var/list/overlay_to_index = list()
	var/current_overlays = 0

/atom/movable/screen/canvas/Initialize(mapload, ...)
	. = ..()
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	icon = draw
	underlays += base

/atom/movable/screen/canvas/Click(location, control, params)
	. = ..()
	if(host.item_flags & IN_STORAGE)
		return
	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	if(!istype(brush))
		return
	var/current_color = brush.current_color
	if(!current_color)
		return
	var/list/param_list = params2list(params)

	var/x = text2num(param_list["icon-x"])
	var/y = text2num(param_list["icon-y"])

	y = min(FLOOR(y / host.canvas_divider_y, 1), host.canvas_size_y-1)
	x = min(FLOOR(x / host.canvas_divider_x, 1), host.canvas_size_x-1)

	if(param_list["right"])
		var/original_color = base_icon.GetPixel(x, y)
		current_color = original_color
		modified_areas -= "[x][y]"
		if("[x][y]" in overlay_to_index)
			cut_overlay(overlay_to_index["[x][y]"])
	else

		if("[x][y]" in modified_areas)
			var/pre_merge = draw.GetPixel(x+1, y+1)
			if(pre_merge != current_color)
				current_color = BlendRGB(current_color, pre_merge, 0.5)
		modified_areas |= "[x][y]"
		if("[x][y]" in overlay_to_index)
			cut_overlay(overlay_to_index["[x][y]"])

	var/mutable_appearance/MA = mutable_appearance(host.canvas_icon, "pixel")
	MA.color = current_color
	MA.pixel_x = (x) * host.canvas_divider_y
	MA.pixel_y = (y) * host.canvas_divider_x
	MA.layer = layer +1
	MA.plane = plane
	add_overlay(MA)
	current_overlays++
	overlay_to_index |= "[x][y]"
	overlay_to_index["[x][y]"] = MA
	if(current_overlays > 150)
		icon = usr.client.RenderIcon(src)
		current_overlays = 0
		cut_overlays()
		overlay_to_index = list()

	host.update_drawing(x, y, current_color)

/// Mapping helper: hangs a random archived player painting at its mapped position, each painting at most once per round. Deletes itself if none are left, with the empty spots picked at random.
/obj/item/canvas/random_painting
	anchored = TRUE

/obj/item/canvas/random_painting/Initialize(mapload)
	var/mapped_pixel_x = pixel_x
	var/mapped_pixel_y = pixel_y
	..()
	// /obj/item/Initialize() jitters items mapped without a pixel offset.
	pixel_x = mapped_pixel_x
	pixel_y = mapped_pixel_y
	SSpaintings.pending_random_paintings += src
	return INITIALIZE_HINT_LATELOAD

/obj/item/canvas/random_painting/LateInitialize()
	SSpaintings.hang_random_paintings()

/obj/item/canvas/random_painting/Destroy()
	SSpaintings.pending_random_paintings -= src
	return ..()

///////////
// EASEL //
///////////

/obj/structure/easel
	name = "easel"
	desc = ""
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "easel"
	density = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 60
	var/obj/item/canvas/painting = null
	anchored = 0

//Adding canvases
/obj/structure/easel/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/canvas))
		var/obj/item/canvas/C = I
		user.dropItemToGround(C)
		painting = C
		painting.pixel_x = 0
		painting.pixel_y = painting.easel_offset
		C.forceMove(get_turf(src))
		C.layer = layer+0.1
		user.visible_message("<span class='notice'>[user] puts \the [C] on \the [src].</span>","<span class='notice'>I place \the [C] on \the [src].</span>")
	else
		return ..()


//Stick to the easel like glue
/obj/structure/easel/Move()
	var/turf/T = get_turf(src)
	. = ..()
	if(painting && painting.loc == T) //Only move if it's near us.
		painting.forceMove(get_turf(src))
	else
		painting = null

///////////
// BRUSH //
///////////

/obj/item/paint_brush
	name = "paint brush"
	desc = "A tool used for painting"
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "paintbrush"

	grid_height = 32
	grid_width = 64
	var/current_color


/obj/item/paint_brush/update_overlays()
	. = ..()
	cut_overlays()
	if(!current_color)
		return

	var/mutable_appearance/MA = mutable_appearance(icon, "paintbrush-color")
	MA.color = current_color
	add_overlay(MA)

/obj/item/paint_brush/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target, /obj/item/paint_palette))
		var/merge_color = input(user, "Choose a color to blend") as anything in target:colors
		if(!merge_color)
			return
		var/list/colors = target:colors
		merge_color = colors[merge_color]
		if(!current_color)
			current_color = merge_color
		else
			current_color = BlendRGB(current_color, merge_color, 0.5)
		update_overlays()
		return

	if(!target.reagents)
		return
	if(!(target.reagents.flags & OPENCONTAINER))
		return

	if(target.reagents.has_reagent(/datum/reagent/water))
		to_chat(user, span_notice("You start to wash [src] in [target]."))
		if(!do_after(user, 1 SECONDS, target = target))
			return
		current_color = null
		update_overlays()

/obj/item/paint_palette/filled
	colors = list(
		"Red" = COLOR_RED,
		"Blue" = COLOR_BLUE,
		"Green" = COLOR_GREEN,
		"Purple" = COLOR_PURPLE,
		"Cyan" = COLOR_CYAN
	)

///////////
// Palette //
///////////

/obj/item/paint_palette
	name = "paint palette"
	desc = "A tool used for painting"
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "palette"

	grid_height = 32
	grid_width = 64
	var/list/colors = list()


/obj/item/paint_palette/Initialize(mapload)
	. = ..()
	update_overlays()

/obj/item/paint_palette/proc/add_color(mob/user)
	if(length(colors) >= 5)
		return
	var/add_color = input(user, "Choose a color to add") as color|null
	if(!add_color)
		return
	var/color_name = input(user, "Choose a name for this color")
	if(!color_name)
		return
	if(length(colors) >= 5)
		return
	colors |= color_name
	colors[color_name] = add_color
	update_overlays()

/obj/item/paint_palette/proc/remove_color(mob/user)
	var/remove_color = input(user, "Choose a color to remove") as anything in colors
	if(!remove_color)
		return
	colors -= remove_color
	update_overlays()


/obj/item/paint_palette/attack_right(mob/user)
	. = ..()
	remove_color(user)

/obj/item/paint_palette/attack_self(mob/user)
	. = ..()
	add_color(user)

/obj/item/paint_palette/update_overlays()
	. = ..()
	cut_overlays()

	for(var/i = 1 to length(colors))
		var/mutable_appearance/MA = mutable_appearance(icon, "palette-greyscale[i]")
		var/color_name = colors[i]
		MA.color = colors[color_name]
		add_overlay(MA)
