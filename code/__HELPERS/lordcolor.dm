GLOBAL_LIST_EMPTY(lordcolor)

GLOBAL_VAR(lordprimary)
GLOBAL_VAR(lordsecondary)

/obj/proc/lordcolor(primary,secondary)
	color = primary

/obj/item/clothing/cloak/lordcolor(primary,secondary)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_cloak()


/turf/proc/lordcolor(primary,secondary)
	color = primary

/mob/proc/lord_color_choice()
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(lord_color_choice)), 50)
		return
	var/prim
	var/sec
	var/choice = input(src, "Choose a Primary Color", "ROGUETOWN") as anything in colorlist
	if(choice)
		prim = colorlist[choice]
	choice = input(src, "Choose a Secondary Color", "ROGUETOWN") as anything in colorlist
	if(choice)
		sec = colorlist[choice]
	if(!prim || !sec)
		GLOB.lordcolor = list()
		return
	GLOB.lordprimary = prim
	GLOB.lordsecondary = sec
	for(var/obj/O in GLOB.lordcolor)
		O.lordcolor(prim,sec)
	for(var/turf/T in GLOB.lordcolor)
		T.lordcolor(prim,sec)

/proc/lord_color_default()
	GLOB.lordprimary = "#264d26" //DARK GREEN
	GLOB.lordsecondary = "#2b292e" //BLACK
	for(var/obj/O in GLOB.lordcolor)
		O.lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	for(var/turf/T in GLOB.lordcolor)
		T.lordcolor(GLOB.lordprimary,GLOB.lordsecondary)

// Ducal Scheme lordcolor implementation for dyed items
/obj/item/lordcolor(primary, secondary)
	// Check if this item uses any Ducal Scheme colors
	if(ducal_primary)
		add_atom_colour(primary, FIXED_COLOUR_PRIORITY)
	if(ducal_detail)
		detail_color = secondary
		update_icon()
	if(ducal_altdetail)
		altdetail_color = secondary
		update_icon()
