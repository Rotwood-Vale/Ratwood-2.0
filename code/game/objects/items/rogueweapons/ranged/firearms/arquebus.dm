/obj/item/gun/ballistic/firearm/arquebus
	name = "火绳枪"
	desc = "一把以烟火药发射破甲金属弹丸的武器。\
	它是真正的工艺杰作，由 Naledi 腐疫横行的深处之地里一群铁匠密会所铸。"
	icon = 'modular_helmsguard/icons/weapons/arquebus.dmi'
	icon_state = "arquebus"
	item_state = "arquebus"
	grid_height = 64
	grid_width = 96

/obj/item/gun/ballistic/firearm/arquebus_pistol
	name = "火绳手铳"
	desc = "一把小型烟火药武器，平衡得足以单手使用。\
	即便拥有如此威力，人们仍争执不休，直到 Naledi 密会的铁匠们终于让步，限量打造了这类兵器。\
	眼前这一把便是其中极其稀罕的成品，每一把都依照持用者的意志量身而制。"
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
	cartridge_wording = "铅弹"
	grid_height = 32
	grid_width = 96
	experimental_onhip = TRUE
	pixel_x = 0
	pixel_y = 0

/obj/item/gun/ballistic/firearm/arquebus_pistol/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
