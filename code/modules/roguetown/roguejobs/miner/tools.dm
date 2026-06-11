/obj/item/rogueweapon/pick
	force = 17
	force_wielded = 21
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	name = "铁镐"
	desc = "这件工具是在幽暗深处采矿的必需品。"
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
	name = "钢镐"
	desc = "它有加固的握柄和坚固的镐柄，是深入黑暗矿脉时更为上乘的工具。"
	force = 21
	force_wielded = 28
	icon_state = "steelpick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 600
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/pick/blacksteel
	name = "黑钢镐"
	desc = "它泛着银黑色的微光，是矿工深入黑暗时所用的名贵工具。"
	force_wielded = 30
	icon_state = "blacksteelpick1"
	item_state = "blacksteelpick1"
	possible_item_intents = list(/datum/intent/pick)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 800
	smeltresult = /obj/item/ingot/blacksteel


/obj/item/rogueweapon/pick/stone
	name = "石镐"
	desc = "石头对上尖石，究竟谁更胜一筹？"
	force = 12
	force_wielded = 17
	icon_state = "stonepick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 250
	smeltresult = null

/obj/item/rogueweapon/pick/decrepit
	name = "衰朽镐"
	desc = "一把锻造青铜制成的凿镐，曾被用来采集铸造某种古老合金所需的矿石；而那一切都在她升格之后湮没了。"
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
	name = "铜镐"
	desc = "一把铜镐，性能比石镐稍好一些。"
	force = 15
	force_wielded = 19
	icon_state = "cpick"
	max_integrity = 325
	smeltresult = /obj/item/ingot/copper
