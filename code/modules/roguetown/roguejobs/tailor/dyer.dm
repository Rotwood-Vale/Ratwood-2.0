var/global/list/colorlist = list(
	"Swan White"="#ffffff",
	"Chalk White" = "#f4ecde",
	"Cream" = "#fffdd0",
	"Light Grey" = "#999999",
	"Dunked in Water" = "#bbbbbb",
	"Mage Grey" = "#6c6c6c",
	"Sow's skin"="#CE929F",
	"Knight's Red"="#933030",
	"Royal Red"="#8b2323",
	"Red Ochre" = "#913831",
	"Maroon" = "#550000",
	"Scarlet" = "#bb0a1e",
	"Royal Orange" = "#df8405",
	"Madroot Red"="#AD4545",
	"Marigold Orange"="#E2A844",
	"Chestnut" = "#613613",
	"Dirt" = "#7c6d5c",
	"Peasant Brown" = "#685542",
	"Russet" = "#7f461b",
	"Yellow Weld" = "#f4c430",
	"Yarrow" = "#f0cb76",
	"Yellow Ochre" = "#cb9d06",
	"Mage Yellow" = "#c1b144",
	"Astrata's Yellow"="#FFFD8D",
	"Olive" = "#98bf64",
	"Royal Green" = "#264d26",
	"Forest Green" = "#428138",
	"Mage Green" = "#759259",
	"Bog Green"="#375B48",
	"Seafoam Green"="#49938B",
	"Royal Teal" = "#249589",
	"Cornflower Blue"="#749EE8",
	"Royal Blue" = "#173266",
	"Woad Blue"="#395480",
	"Mage Blue" = "#4756d8",
	"Periwinkle Blue" = "#8f99fb",
	"Lavender"="#865c9c",
	"Royal Purple"="#5E4687",
	"Orchil" = "#66023C",
	"Wine Rouge"="#752B55",
	"Royal Magenta" = "#962e5c",
	"Blacksteel Grey"="#404040",
	"Dark Grey" = "#505050",
	"Darkest Night" = "#414143"
	)

var/global/list/pridelist = list(
	"RAINBOW" = "#fcfcfc"
)

// DYE BIN

/obj/machinery/gear_painter
	name = "Dye Station"
	desc = "A station to give your apparel a fresh new color! Recommended to use with white items for best results."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "dyestation"
	density = TRUE
	anchored = TRUE
	var/atom/movable/inserted
	var/activecolor = "#FFFFFF"
	var/activecolor_detail = "#FFFFFF"
	var/activecolor_altdetail = "#FFFFFF"
	var/ducal_scheme = FALSE // Whether primary color is using Ducal Scheme
	var/ducal_scheme_detail = FALSE // Whether detail color is using Ducal Scheme
	var/ducal_scheme_altdetail = FALSE // Whether altdetail color is using Ducal Scheme
	var/list/allowed_types = list(
			/obj/item/clothing,
			/obj/item/storage,
			/obj/item/bedroll,
			/obj/item/flowercrown,
			/obj/item/legwears,
			/obj/item/undies
			)
	var/list/used_colors

/obj/machinery/gear_painter/Initialize()
	..()
	used_colors = colorlist

/obj/machinery/gear_painter/Destroy()
	if(inserted)
		inserted.forceMove(drop_location())
	return ..()

/obj/machinery/gear_painter/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/book/rogue/swatchbook))
		var/obj/item/book/rogue/swatchbook/S = I
		if(!S.open)
			to_chat(user, span_info("The swatchbook expressly forbids the use of its cover color!"))
			return ..()
		if(S.swatchbookcolor == "#000000")
			to_chat(user, span_info("You haven't picked out a color!"))
			return ..()
		else
			to_chat(user, span_info("You mix the swatch's color in the dye bin."))
			activecolor = "[S.swatchbookcolor]"
			activecolor_detail = "[S.swatchbookcolor]"
			activecolor_altdetail = "[S.swatchbookcolor]"
			ui_interact(user)
			return ..()
	if(inserted)
		to_chat(user, span_warning("Something is already inside!"))
		return ..()
	if(!is_type_in_list(I, allowed_types))
		to_chat(user, span_warning("[I] cannot be dyed!"))
		return ..()
	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return ..()

	user.visible_message(span_notice("[user] inserts [I] into [src]'s receptable."))

	inserted = I
	interact(user)

/obj/machinery/gear_painter/AllowDrop()
	return FALSE

/obj/machinery/gear_painter/attack_hand(mob/living/user)
	interact(user)

/obj/machinery/gear_painter/interact(mob/user)
	if(!is_operational())
		return ..()
	user.set_machine(src)
	var/datum/browser/menu = new(user, "colormate","Dye Station", 400, 400, src)
	var/list/dat = list("<TITLE>Dye Bin</TITLE><BR>")
	if(!inserted)
		dat += "No item inserted."
		menu.set_content("<html>[dat.Join("")]</html>")
		menu.open()
		return

	var/obj/item/inserted_item = inserted

	dat += "Item inserted: [inserted]<HR>"
	dat += "Color: <font color='[activecolor]'>&#10070;</font> "
	dat += "<A href='?src=\ref[src];select=1'>Select new color.</A><BR>"

	if(inserted_item.detail_color)
		dat += "Detail Color: <font color='[activecolor_detail]'>&#10070;</font> "
		dat += "<A href='?src=\ref[src];select_detail=1'>Select new detail color.</A><BR>"

	if(inserted_item.altdetail_color)
		dat += "Alt. Detail Color: <font color='[activecolor_altdetail]'>&#10070;</font> "
		dat += "<A href='?src=\ref[src];select_altdetail=1'>Select new tertiary color.</A><BR>"

	dat += "<BR><A href='?src=\ref[src];paint=1'>Apply new color</A> | "
	dat += "<A href='?src=\ref[src];clear=1'>Remove paintjob</A><BR><BR>"
	dat += "<A href='?src=\ref[src];eject=1'>Eject item.</A><BR><BR>"
	menu.set_content("<html>[dat.Join("")]</html>")
	menu.open()

/obj/machinery/gear_painter/Topic(href, href_list)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)

	if(href_list["close"])
		usr << browse(null, "window=colormate")
		return

	if(href_list["select"])
		ducal_scheme = FALSE
		if(HAS_TRAIT(usr, TRAIT_DYES))
			var/choice
			var/input_type = alert(usr, "Input Choice", "Primary Dye", "Color Wheel", "Color Preset", "Ducal Scheme")
			if(input_type == "Ducal Scheme")
				ducal_scheme = TRUE
				activecolor = GLOB.lordprimary ? GLOB.lordprimary : "#264d26"
			else if(input_type != "Color Wheel")
				choice = input(usr, "Choose your dye:", "Dyes", null) as null|anything in used_colors
				if(!choice)
					return
				activecolor = used_colors[choice]
			else
				activecolor = sanitize_hexcolor(color_pick_sanitized(usr, "Choose your dye:", "Dyes", choice ? choice : activecolor, 0.2, 1), 6, TRUE)
				if(activecolor == "#000000")
					activecolor = "#FFFFFF"
			interact(usr)
		else
			var/choice_list = colorlist.Copy()
			choice_list["Ducal Scheme"] = "#DUCAL"
			var/choice = input(usr,"Choose your dye:","Dyes",null) as null|anything in choice_list
			if(!choice)
				return
			if(choice == "Ducal Scheme")
				ducal_scheme = TRUE
				activecolor = GLOB.lordprimary ? GLOB.lordprimary : "#264d26"
			else
				activecolor = colorlist[choice]
			interact(usr)

	if(href_list["select_detail"])
		ducal_scheme_detail = FALSE
		if(HAS_TRAIT(usr, TRAIT_DYES))
			var/choice
			var/input_type = alert(usr, "Input Choice", "Detail Dye", "Color Wheel", "Color Preset", "Ducal Scheme")
			if(input_type == "Ducal Scheme")
				ducal_scheme_detail = TRUE
				activecolor_detail = GLOB.lordsecondary ? GLOB.lordsecondary : "#2b292e"
			else if(input_type != "Color Wheel")
				choice = input(usr, "Choose your dye:", "Dyes", null) as null|anything in used_colors
				if(!choice)
					return
				activecolor_detail = used_colors[choice]
			else
				activecolor_detail = sanitize_hexcolor(color_pick_sanitized(usr, "Choose your dye:", "Dyes", choice ? choice : activecolor_detail, 0.2, 1), 6, TRUE)
				if(activecolor_detail == "#000000")
					activecolor_detail = "#FFFFFF"
			interact(usr)
		else
			var/choice_list = colorlist.Copy()
			choice_list["Ducal Scheme"] = "#DUCAL"
			var/choice = input(usr,"Choose your dye:","Dyes",null) as null|anything in choice_list
			if(!choice)
				return
			if(choice == "Ducal Scheme")
				ducal_scheme_detail = TRUE
				activecolor_detail = GLOB.lordsecondary ? GLOB.lordsecondary : "#2b292e"
			else
				activecolor_detail = colorlist[choice]
			interact(usr)

	if(href_list["select_altdetail"])
		ducal_scheme_altdetail = FALSE
		if(HAS_TRAIT(usr, TRAIT_DYES))
			var/choice
			var/input_type = alert(usr, "Input Choice", "Tertiary Dye", "Color Wheel", "Color Preset", "Ducal Scheme")
			if(input_type == "Ducal Scheme")
				ducal_scheme_altdetail = TRUE
				activecolor_altdetail = GLOB.lordsecondary ? GLOB.lordsecondary : "#2b292e"
			else if(input_type != "Color Wheel")
				choice = input(usr, "Choose your dye:", "Dyes", null) as null|anything in used_colors
				if(!choice)
					return
				activecolor_altdetail = used_colors[choice]
			else
				activecolor_altdetail = sanitize_hexcolor(color_pick_sanitized(usr, "Choose your dye:", "Dyes", choice ? choice : activecolor_altdetail, 0.2, 1), 6, TRUE)
				if(activecolor_altdetail == "#000000")
					activecolor_altdetail = "#FFFFFF"
			interact(usr)
		else
			var/choice_list = colorlist.Copy()
			choice_list["Ducal Scheme"] = "#DUCAL"
			var/choice = input(usr,"Choose your dye:","Dyes",null) as null|anything in choice_list
			if(!choice)
				return
			if(choice == "Ducal Scheme")
				ducal_scheme_altdetail = TRUE
				activecolor_altdetail = GLOB.lordsecondary ? GLOB.lordsecondary : "#2b292e"
			else
				activecolor_altdetail = colorlist[choice]
			interact(usr)

	if(href_list["paint"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		
		// Apply primary color
		if(ducal_scheme)
			inserted_item.ducal_primary = TRUE
			inserted.add_atom_colour(activecolor, FIXED_COLOUR_PRIORITY)
			if(!(inserted in GLOB.lordcolor))
				GLOB.lordcolor += inserted
		else
			inserted_item.ducal_primary = FALSE
			inserted.add_atom_colour(activecolor, FIXED_COLOUR_PRIORITY)
			if(!inserted_item.ducal_detail && !inserted_item.ducal_altdetail && (inserted in GLOB.lordcolor))
				GLOB.lordcolor -= inserted
		
		// Apply detail color if available
		if(inserted_item.detail_color)
			inserted_item.detail_color = activecolor_detail
			if(ducal_scheme_detail)
				inserted_item.ducal_detail = TRUE
				if(!(inserted_item in GLOB.lordcolor))
					GLOB.lordcolor += inserted_item
			else
				inserted_item.ducal_detail = FALSE
				if(!inserted_item.ducal_primary && !inserted_item.ducal_altdetail && (inserted_item in GLOB.lordcolor))
					GLOB.lordcolor -= inserted_item
		
		// Apply altdetail color if available
		if(inserted_item.altdetail_color)
			inserted_item.altdetail_color = activecolor_altdetail
			if(ducal_scheme_altdetail)
				inserted_item.ducal_altdetail = TRUE
				if(!(inserted_item in GLOB.lordcolor))
					GLOB.lordcolor += inserted_item
			else
				inserted_item.ducal_altdetail = FALSE
				if(!inserted_item.ducal_primary && !inserted_item.ducal_detail && (inserted_item in GLOB.lordcolor))
					GLOB.lordcolor -= inserted_item
		
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		// Always eject after applying colors
		inserted.forceMove(drop_location())
		inserted = null
		interact(usr)

	if(href_list["clear"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		// Remove primary color
		inserted.remove_atom_colour(FIXED_COLOUR_PRIORITY)
		// Clear detail color if available
		if(inserted_item.detail_color)
			inserted_item.detail_color = "#FFFFFF"
		// Clear altdetail color if available
		if(inserted_item.altdetail_color)
			inserted_item.altdetail_color = "#FFFFFF"
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		// Always eject after clearing
		inserted.forceMove(drop_location())
		inserted = null
		interact(usr)

	if(href_list["eject"])
		if(!inserted)
			return
		inserted.forceMove(drop_location())
		inserted = null
		interact(usr)


// PAINTBRUSH

/obj/item/dye_brush
	icon = 'icons/roguetown/items/misc.dmi'
	name = "dye brush"
	desc = "A sizeable brush made of the finest mane-hairs. Thick dye adheres to it well."
	icon_state = "dbrush"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8
	grid_width = 32
	grid_height = 32

	var/dye = null

/obj/item/dye_brush/update_icon()
	if(dye)
		var/mutable_appearance/M = mutable_appearance('icons/roguetown/items/misc.dmi', "dbrush_colour")
		M.color = dye
		M.alpha = 150
		add_overlay(M)
	else
		cut_overlays()

/obj/item/dye_brush/examine(mob/user)
	. = ..()

	if(dye)
		. += span_notice("It is currently lathering <font color=[dye]>paint</font>.")
	else
		. += span_notice("Use in active hand to pick a paint.")

/obj/item/dye_brush/attack_self(mob/user)
	..()

	var/hexdye
	if(dye)
		to_chat(user, span_warning("[src] is already carrying <font color=[dye]>dye</font>. I need to wash it."))
		return

	hexdye = sanitize_hexcolor(color_pick_sanitized(usr, "Choose your dye:", "Dyes", null), 6, TRUE)
	if (hexdye == "#000000")
		return
	dye = hexdye
	update_icon()

/obj/item/dye_brush/attack_turf(turf/T, mob/living/user)
	if(!iswallturf(T))
		return
	if(!dye)
		to_chat(user, span_warning("[src] has no dye!"))
		return
	if(T.color)
		to_chat(user, span_warning("[T] is already painted by a <font color=[T.color]>dye</font>!"))
		return

	if(!do_after(user, 6 SECONDS, TRUE, T))
		return
	user.visible_message(span_notice("[user] finishes <font color=[dye]>painting</font> [T]."), \
		span_notice("I finish <font color=[dye]>painting</font> [T].")
	)
	playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	T.color = dye

	..()

/obj/item/dye_brush/attack_obj(obj/O, mob/living/user)
	if(!isstructure(O))
		return
	if(!dye)
		to_chat(user, span_warning("[src] has no dye!"))
		return
	if(O.color)
		to_chat(user, span_warning("[O] is already painted by a <font color=[O.color]>dye</font>!"))
		return

	if(!do_after(user, 3 SECONDS, TRUE, O))
		return
	user.visible_message(span_notice("[user] finishes <font color=[dye]>painting</font> [O]."), \
		span_notice("I finish <font color=[dye]>painting</font> [O].")
	)
	playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	O.color = dye

	..()

/obj/item/dye_brush/wash_act(clean)
	if(!dye)
		return
	dye = null
	update_icon()

