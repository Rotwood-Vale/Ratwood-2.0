/obj/item/rogueweapon/pick
	force = 17
	force_wielded = 21
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	name = "iron pick"
	desc = "This tool is essential to mine in the dark depths."
	icon_state = "pick"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_NORMAL
	max_integrity = 400
	slot_flags = ITEM_SLOT_HIP
	toolspeed = 1
	associated_skill = /datum/skill/labor/mining
	smeltresult = /obj/item/ingot/iron
	grid_width = 64
	grid_height = 64
	is_tool = TRUE

/obj/item/rogueweapon/pick/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/pick/steel
	name = "steel pick"
	desc = "With a reinforced handle and sturdy shaft, this is a superior tool for delving in the darkness."
	force = 21
	force_wielded = 28
	icon_state = "steelpick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 600
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/pick/bronze
	name = "dolabra"
	desc = "A so-called 'legionnaire's tool'; antiquated, but nevertheless beloved by many for its versatility. It offers an answer for labors both above-and-below, courtesy of its bronze axhead-and-picktip."
	force = 20
	force_wielded = 25
	icon_state = "bronzepick"
	possible_item_intents = list(/datum/intent/pick/bad, /datum/intent/axe/chop, /datum/intent/axe/cut, MACE_STRIKE)
	gripped_intents = list(/datum/intent/pick, /datum/intent/axe/chop, /datum/intent/till, /datum/intent/flailthresh)
	max_integrity = 500
	max_blade_int = 225
	sharpness = IS_SHARP
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/pick/woodcutter/dolabra
	name = "debug long dolabra"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "pdolabra"
	gripsprite = TRUE
	force = 28
	force_wielded = 32
	desc = "you shouldn't be seeing this, scream at a coder!"
	dropshrink = 0.7
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra, /datum/intent/pick/ranged/dolabra)
	max_integrity = 750
	max_blade_int = 1200
	associated_skill = /datum/skill/combat/axes
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK		//Needs to go on back.
	sharpness = IS_SHARP
	resistance_flags = FIRE_PROOF
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	special = /datum/special_intent/greatsword_swing
	
/obj/item/rogueweapon/pick/woodcutter/dolabra/pioneer
	name = "gilded eleonora"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "pdolabra"
	desc = "A long handled dolabra axe-pick with a carved grip made of hardened maple wood. This one has an axe-blade of frayed blacksteel, having lost its varnish long ago with a long pick-head behind the blade, this dolabra is decorated with golden reinforced bracers along the shaft and a heavy gold mace head at the top."
	force = 30
	force_wielded = 34
	max_integrity = 1000
	wdefense = 6
	wdefense_wbonus = 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra/pioneer, /datum/intent/axe/chop/long/woodcutter/pioneer, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick/ranged/dolabra/pioneer)
	special = /datum/special_intent/greatsword_swing
	smeltresult = /obj/item/ingot/gold

/obj/item/rogueweapon/pick/woodcutter/dolabra/blacksteel
	name = "blacksteel dolabra"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "edolabra"
	desc = "A long-handled dolabra axe-pick with a carved grip made of hardened maple wood. Fitted with an axe-blade of polished blacksteel and a long pick-head behind the blade."
	force = 30
	force_wielded = 34
	max_integrity = 1000 // more than a blacksteel pickaxe
	wdefense = 6
	wdefense_wbonus = 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra, /datum/intent/pick/ranged/dolabra)
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/pick/woodcutter/dolabra/albranze
	name = "albranze dolabra"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "bdolabra" // albranze is a bronze aluminium mix, aluminium was traditionally more expensive than even silver and gold combined
	desc = "a long handled dolabra axe-pick with a long shaft of treated oak. Fitted with an axe-head made of polished albranze with a fitted pick-head behind the blade."
	wdefense = 6
	wdefense_wbonus = 2
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/pick/woodcutter/dolabra/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/pick/blacksteel
	name = "blacksteel pick"
	desc = "Glimmering with silvered blackness, this is a pretigious tool for miners delving into the darkness. It looks like it will strike hard enough to shatter any boulders within a rocky surface instantly."
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	force = 25
	force_wielded = 32
	icon_state = "blacksteelpick1"
	item_state = "blacksteelpick1"
	max_integrity = 800
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/pick/stone
	name = "stone pick"
	desc = "Stone versus sharp stone, who wins?"
	force = 12
	force_wielded = 17
	icon_state = "stonepick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 250
	smeltresult = null

/obj/item/rogueweapon/pick/decrepit
	name = "decrepit pick"
	desc = "A chisel of wrought bronze, which once labored to gather the ores necessary for an ancient alloy; such was lost in the aftermath of Her ascension."
	force = 12
	force_wielded = 17
	icon_state = "apick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 150
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 15

/obj/item/rogueweapon/pick/copper
	name = "copper pick"
	desc = "A copper pick, slightly better than a stone pick."
	force = 15
	force_wielded = 19
	icon_state = "cpick"
	max_integrity = 325
	smeltresult = /obj/item/ingot/copper
