GLOBAL_LIST_EMPTY(baronycolor)

GLOBAL_VAR(baronprimary)
GLOBAL_VAR(baronsecondary)

/obj/proc/baronycolor(primary,secondary)
	color = primary

/turf/proc/baronycolor(primary,secondary)
	color = primary

/mob/proc/baron_color_choice()
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(baron_color_choice)), 50)
		return
	var/prim
	var/sec
	var/choice = input(src, "Choose a Primary Color", "ROGUETOWN") as anything in GLOB.colorlist
	if(choice)
		prim = GLOB.colorlist[choice]
	choice = input(src, "Choose a Secondary Color", "ROGUETOWN") as anything in GLOB.colorlist
	if(choice)
		sec = GLOB.colorlist[choice]
	if(!prim || !sec)
		GLOB.baronycolor = list()
		return
	GLOB.baronprimary = prim
	GLOB.baronsecondary = sec
	for(var/obj/O in GLOB.baronycolor)
		O.baronycolor(prim,sec)
	for(var/turf/T in GLOB.baronycolor)
		T.baronycolor(prim,sec)

/proc/barony_color_default()
	GLOB.baronprimary = "#685542" //PEASANT BROWN
	GLOB.baronsecondary = "#505050" //DARK GREY
	for(var/obj/O in GLOB.baronycolor)
		O.baronycolor(GLOB.baronprimary,GLOB.baronsecondary)
	for(var/turf/T in GLOB.baronycolor)
		T.baronycolor(GLOB.baronprimary,GLOB.baronsecondary)

// Barony Scheme baronycolor implementation for dyed items
/obj/item/baronycolor(primary, secondary)
	// Check if this item uses any Barony Scheme colors
	if(barony_primary)
		add_atom_colour(primary, FIXED_COLOUR_PRIORITY)
	if(barony_detail)
		detail_color = secondary
		update_icon()
	if(barony_altdetail)
		altdetail_color = secondary
		update_icon()
