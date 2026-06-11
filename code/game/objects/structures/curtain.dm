/obj/structure/curtain
	name = "帘子"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	var/icon_type = "curtain" // used in making the icon state
	icon_state = "curtain-open"
	color = "#ffffff" // Default color, mappers can easily change it.
	alpha = 255 // Mappers can set this to 200 if they want it slightly see-through
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	opacity = 0
	density = FALSE
	var/open = TRUE
	var/closedir = 0
	var/directional = FALSE//Do these care about which side you open from in the first place?

/obj/structure/curtain/directional
	icon_state = "curtaindir"
	directional = TRUE//Do these care about which side you open from in the first place?

//Because we don't want existing curtains to update on spawn like this.
/obj/structure/curtain/directional/Initialize(mapload)
	closedir = dir
	update_icon()
	..()

//Crafted directional curtain - only openable from one side
/obj/structure/curtain/directional/crafted

/obj/structure/curtain/directional/crafted/OnCrafted(dirin)
	dir = turn(dirin, 180)
	closedir = dir

/obj/structure/curtain/proc/toggle()
	open = !open
	update_icon()

/obj/structure/curtain/update_icon()
	if(!open)
		icon_state = "[icon_type]-closed"
		layer = ABOVE_MOB_LAYER
		set_opacity(TRUE)
		open = FALSE

	else
		icon_state = "[icon_type]-open"
		layer = ABOVE_MOB_LAYER
		set_opacity(FALSE)
		open = TRUE

/obj/structure/curtain/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 50)
	return TRUE

/obj/structure/curtain/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(anchored)
		return TRUE

	user.visible_message("<span class='warning'>[user]开始拆开[src]。</span>",
		"<span class='notice'>我开始拆开[src]。</span>", "<span class='hear'>我听见剪裁声。</span>")
	if(I.use_tool(src, user, 50, volume=100) && !anchored)
		to_chat(user, "<span class='notice'>我拆开了[src]。</span>")
		deconstruct()

	return TRUE


/obj/structure/curtain/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(directional)
		if(get_dir(src,user) == closedir)
			toggle()
			playsound(loc, 'sound/foley/doors/curtain.ogg', 50, TRUE)
		else
			to_chat(user, span_warning("这些帘子只能从另一侧操作。"))
	else
		toggle()
		playsound(loc, 'sound/foley/doors/curtain.ogg', 50, TRUE)


/obj/structure/curtain/deconstruct(disassembled = TRUE)
	qdel(src)

/obj/structure/curtain/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/blank.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/blank.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/blank.ogg', 80, TRUE)

/obj/structure/curtain/attackby(obj/item/dyingbrush, mob/living/user)
	if(!istype(dyingbrush, /obj/item/dye_brush))
		. = ..()
		return
	var/obj/item/dye_brush/brush = dyingbrush
	if(!brush.dye)
		to_chat(user, span_warning("The dye brush has no dye loaded."))
		return
	if(do_after(user, 2 SECONDS, target = src))
		user.visible_message(span_notice("[user] finishes <font color=[brush.dye]>painting</font> [src]."), \
			span_notice("I finish <font color=[brush.dye]>painting</font> [src].")
		)
		playsound(loc, "sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
		color = brush.dye

/obj/structure/curtain/red
	color = "#a32121"

/obj/structure/curtain/blue
	color = CLOTHING_BLUE

/obj/structure/curtain/green
	color = CLOTHING_DARK_GREEN

/obj/structure/curtain/brown
	color = CLOTHING_BROWN

/obj/structure/curtain/purple
	color = "#8747b1"

/obj/structure/curtain/magenta
	color = "#962e5c"

/obj/structure/curtain/black
	color = "#414143"

/obj/structure/curtain/drab
	color = CLOTHING_DRAB

/obj/structure/curtain/orange
	color = "#a3622c"

/obj/structure/curtain/yellow
	color = "#a18727"


//This is awful and I apologise.
/obj/structure/curtain/directional/red
	color = "#a32121"

/obj/structure/curtain/directional/blue
	color = CLOTHING_BLUE

/obj/structure/curtain/directional/green
	color = CLOTHING_DARK_GREEN

/obj/structure/curtain/directional/brown
	color = CLOTHING_BROWN

/obj/structure/curtain/directional/purple
	color = "#8747b1"

/obj/structure/curtain/directional/magenta
	color = "#962e5c"

/obj/structure/curtain/directional/black
	color = "#414143"

/obj/structure/curtain/directional/orange
	color = "#a3622c"

/obj/structure/curtain/directional/yellow
	color = "#a18727"
	
/obj/structure/curtain/directional/drab
	color = CLOTHING_DRAB
