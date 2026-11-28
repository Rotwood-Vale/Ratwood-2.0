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
	icon_state = "copperdolabra"
	gripsprite = TRUE
	force = 28
	force_wielded = 32
	desc = "you shouldn't be seeing this, scream at a coder!"
	dropshrink = 0.7
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra, /datum/intent/pick/ranged/dolabra)
	max_integrity = 750
	max_blade_int = 550
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

/obj/item/rogueweapon/pick/woodcutter/dolabra/copper
	name = "copper dolabra"
	force = 15
	force_wielded = 18
	desc = "A long handled dolabra axe-pick with a carved long handle of hardened oak. This one has an axe-blade of pure copper that looks rather flimsey behind it a long pick-head."
	max_integrity = 250
	max_blade_int = 250
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra/copper, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra/copper, /datum/intent/pick/ranged/dolabra/copper)
	wdefense = 3
	wdefense_wbonus = 2
	smeltresult = /obj/item/ingot/copper

/obj/item/rogueweapon/pick/woodcutter/dolabra/iron
	name = "iron dolabra"
	icon_state = "irondolabra"
	force = 22
	force_wielded = 28
	desc = "A long handled dolabra axe-pick with a carved long handle of hardened oak. This one has an axe-blade of pure iron engineered to perfection.\
	Behind it is a long sharpened pick-head standing behind the blade as sharp as a needle."
	max_integrity = 400
	max_blade_int = 350
	wdefense = 4
	wdefense_wbonus = 2
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/pick/woodcutter/dolabra/albranze
	name = "albranze dolabra"
	icon_state = "bronzedolabra"
	desc = "A long handled dolabra axe-pick with a carved long handle of hardened oak. This one has an axe-blade of precious albranze, an expensive mix of Alum and Bronze rumored to be stronger than steel.\
	Behind it is an equally sharp pick-head standing behind it stronger than the strongest steel mixes in Psydonia."
	wdefense = 6
	wdefense_wbonus = 2
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/pick/woodcutter/dolabra/steel
	name = "steel dolabra"
	icon_state = "steeldolabra"
	force = 24
	force_wielded = 30
	desc = "A recent development in dolabra's this one is made of steel compared to the usual albranze, fitted with a polished axe-head of modern steel with a wicked edge, this one seems to be as strong as its older counterpart.\
	The pick-head behind it however has seen better days, it seems that in the end Albranze still has its used which is favored by engineer's all over Psydonia"
	max_integrity = 490
	max_blade_int = 450
	wdefense = 5
	wdefense_wbonus = 2
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/pick/woodcutter/dolabra/silver
	name = "silver dolabra"
	icon_state = "silverdolabra"
	force = 24 // same as steel should be lowered if this becomes a problem
	force_wielded = 30
	desc = "Developed out of a need for engineer's and miners to arm themselves with silver weaponry during needs of crisis. A dolabra forged out of pure holy silver this is the bane of all the inhumen that encounter it.\
	An axe-blade of wicked sharp silver with an equally sharp pick-head, those who see this weapon cower before it."
	max_integrity = 500
	max_blade_int = 450
	wdefense = 6
	wdefense_wbonus = 2
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/pick/woodcutter/dolabra/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/pick/woodcutter/dolabra/gold
	name = "gold dolabra"
	icon_state = "golddolabra"
	force = 34
	force_wielded = 42 // OUCH
	desc = "A dolabra produced from pure gold more out of a desire to show off, this if you could call it a weapon or tool serves no practical use in or off the field.\
	Fitted with an axe-blade as well as a long pick-head of pure gold, it has a shaft of pure silver, this should really be left in the display rack where you found it."
	max_integrity = 50 //you won't be using this in combat ever
	max_blade_int = 75 // will retain its blade however
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra/gold, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra/gold, /datum/intent/pick/ranged/dolabra/gold)
	smeltresult = /obj/item/ingot/gold

/obj/item/rogueweapon/pick/woodcutter/dolabra/blacksteel
	name = "blacksteel dolabra"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "blacksteeldolabra"
	desc = " A dolabra produced from blacksteel, this is the pinnicale of materials that you can produce, a refined version of the albranze dolabra this version is a much more refined and more sturdy version.\
	Fitted with a razor-sharp axe-blade and an needle thin pick-head of pure blacksteel, this tool will withstand whatever you throw at it."
	force = 30
	force_wielded = 34
	max_integrity = 1000 // more than a blacksteel pickaxe
	wdefense = 6
	wdefense_wbonus = 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra/pioneer, /datum/intent/axe/chop/long/woodcutter/pioneer, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick/ranged/dolabra/pioneer)
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/pick/woodcutter/dolabra/pioneer
	name = "gilded eleonora"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "eleonora"
	desc = "A long handled dolabra axe-pick with a carved grip made of hardened maple wood. This one has an axe-blade of frayed blacksteel, having lost its varnish long ago with a long pick-head behind the blade, this dolabra is decorated with golden reinforced bracers along the shaft and a heavy gold mace head at the top."
	force = 30
	force_wielded = 34
	max_integrity = 1000
	wdefense = 8
	wdefense_wbonus = 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra/pioneer, /datum/intent/axe/chop/long/woodcutter/pioneer, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick/ranged/dolabra/pioneer)
	special = /datum/special_intent/greatsword_swing
	smeltresult = /obj/item/ingot/gold


/datum/intent/axe/cut/long/dolabra/copper //its copper so it gets even less demolition modifiers
	demolition_mod = 2

/datum/intent/axe/bash/dolabra/copper
	demolition_mod = 2

/datum/intent/pick/ranged/dolabra/copper
	demolition_mod = 2

/datum/intent/axe/cut/long/dolabra
	demolition_mod = 4

/datum/intent/axe/bash/dolabra
	demolition_mod = 4

/datum/intent/pick/ranged/dolabra
	demolition_mod = 4

/datum/intent/axe/cut/long/dolabra/pioneer
	demolition_mod = 7

/datum/intent/axe/bash/dolabra/pioneer
	demolition_mod = 7

/datum/intent/pick/ranged/dolabra/pioneer
	demolition_mod = 7

/datum/intent/axe/cut/long/dolabra/gold
	demolition_mod = 10

/datum/intent/axe/bash/dolabra/gold
	demolition_mod = 10

/datum/intent/pick/ranged/dolabra/gold
	demolition_mod = 10

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
