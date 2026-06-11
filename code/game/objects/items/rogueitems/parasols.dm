/obj/item/rogueweapon/mace/parasol
	force = 6
	force_wielded = 6
	name = "纸伞"
	desc = "一件精巧的器具，专为替娇贵的脑袋遮雨挡阳而制。"
	icon = 'icons/roguetown/items/parasols32.dmi'
	icon_state = "parasol1"
	wbalance = WBALANCE_SWIFT
	wdefense = 1
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = null
	smeltresult = /obj/item/ash
	anvilrepair = /datum/skill/craft/sewing
	max_integrity = 150 // The working man's parasol
	minstr = 1
	resistance_flags = FLAMMABLE
	slot_flags = null
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64
	dropshrink = 0.75

/obj/item/rogueweapon/mace/parasol/New()
	..()
	icon_state = "parasol[rand(1,6)]"

/obj/item/rogueweapon/mace/parasol/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -6,"sy" = 8,"nx" = 6,"ny" = 9,"wx" = 0,"wy" = 7,"ex" = -1,"ey" = 9,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/mace/parasol/noble
	name = "精致阳伞"
	desc = "一件精巧的器具，专为替娇贵的脑袋遮雨挡阳而制。这把则是华美的白金配色，还缀有流苏。"
	icon = 'icons/roguetown/items/parasols64.dmi'
	icon_state = "parasol1"
	max_integrity = 75 // Fashion over function
	sellprice = 45 // Takes master sewing and silk to create
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	pixel_x = -16
	pixel_y = -16
	dropshrink = 0.8

/obj/item/rogueweapon/mace/parasol/noble/New()
	..()
	icon_state = "parasol[rand(1,2)]"

/obj/item/rogueweapon/mace/parasol/noble/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 8,"nx" = 6,"ny" = 9,"wx" = 0,"wy" = 7,"ex" = -1,"ey" = 9,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
