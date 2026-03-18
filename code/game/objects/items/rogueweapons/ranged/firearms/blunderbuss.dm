/obj/item/gun/ballistic/firearm/blunderbuss
	name = "blunderbuss"
	desc = "A makeshift smokepowder weapon, intended to shoot grapeshot. \
	Such weapons are that of the rabble. Put together from salvaged handgonnes and scrap."
	icon = 'icons/roguetown/weapons/guns32.dmi'
	icon_state = "blunderbuss"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	item_state = "blunderbuss"
	bigboy = FALSE
	gripsprite = FALSE
	mag_type = /obj/item/ammo_box/magazine/internal/firearm/blunderbuss
	cartridge_wording = "grapeshot"

/obj/item/gun/ballistic/firearm/blunderbuss/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/ammo_box/magazine/internal/firearm/blunderbuss
	name = "blunderbuss internal magazine"
	ammo_type = /obj/item/ammo_casing/caseless/bullet/grapeshot
	caliber = "grapeshot"
	max_ammo = 1
	start_empty = TRUE
