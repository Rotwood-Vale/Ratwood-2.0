/obj/item/gun/ballistic/firearm/arquebus
	name = "arquebus rifle"
	desc = "A smokepowder weapon that shoots an armor piercing metal ball. \
	A true work of art, manufactured by a conclave of smiths deep within the rot plagued lands of Naledi."
	icon = 'modular_helmsguard/icons/weapons/arquebus.dmi'
	icon_state = "arquebus"
	item_state = "arquebus"
	grid_height = 64
	grid_width = 96

/obj/item/gun/ballistic/firearm/arquebus_pistol
	name = "arquebus pistol"
	desc = "A small smokepowder weapon, balanced for use in a single hand. \
	Even with great power, men squabbled until the conclave smiths of Naledi relented, producing these in limited batches. \
	This is an incredibly rare example of such. Each tailored to its user's will."
	icon = 'icons/roguetown/weapons/guns32.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	force = 10
	possible_item_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, /datum/intent/mace/strike/wood)
	gripped_intents = null
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	walking_stick = FALSE
	bigboy = FALSE
	gripsprite = FALSE
	cartridge_wording = "lead ball"
	grid_height = 32
	grid_width = 96
	experimental_onhip = TRUE

/obj/item/gun/ballistic/firearm/arquebus_pistol/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
