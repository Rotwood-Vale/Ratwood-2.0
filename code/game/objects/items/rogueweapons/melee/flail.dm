/obj/item/rogueweapon/flail
	force = 25
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flail)
	name = "铁连枷"
	desc = "一柄灵巧的铁制连枷，打得又狠又远。"
	icon_state = "iflail"
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	sharpness = IS_BLUNT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/whipsflails
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	throwforce = 5
	wdefense = 0
	minstr = 4
	grid_width = 32
	grid_height = 96
	special = /datum/special_intent/flail_sweep

/datum/intent/flail/strike
	name = "打击"
	blade_class = BCLASS_BLUNT
	attack_verb = list("打击", "砸中")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK

/datum/intent/flail/strike/matthiosflail
	reach = 2
	damfactor = 1.3 // More damage than peasant flail, not sure why the gilded one had worse intents before, but here we are!


/datum/intent/flail/strikerange
	name = "远距打击"
	blade_class = BCLASS_BLUNT
	attack_verb = list("打击", "砸中")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 15
	damfactor = 1.2 // Extra damage. Flail babe flail.
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_CHARGED // Higher delay for a powerful ranged attack
	reach = 2
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK

/datum/intent/mace/smash/flail
	name = "连枷猛砸"
	chargetime = 0.8 SECONDS
	damfactor = 1.4 // Flail smash has higher damage due to a longer charge.
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	icon_state = "insmash"
	blade_class = BCLASS_SMASH
	attack_verb = list("猛砸")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	item_d_type = "blunt"

/datum/intent/mace/smash/flail/matthiosflail
	reach = 2
	damfactor = 1.6 // so it's better than the militia counterpart.

/datum/intent/mace/smash/flail/militia
	damfactor = 0.9

/datum/intent/mace/smash/flail/golgotha
	hitsound = list('sound/items/beartrap2.ogg')

/datum/intent/mace/smash/flailrange
	name = "远距猛砸"
	chargetime = 1.2 SECONDS
	chargedrain = 1
	recovery = 30
	damfactor = 1.5
	reach = 2
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	attack_verb = list("猛砸")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	item_d_type = "blunt"

/obj/item/rogueweapon/flail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/flail/sflail
	force = 30
	icon_state = "flail"
	desc = "一柄灵巧的钢制连枷，打得又狠又远。"
	smeltresult = /obj/item/ingot/steel
	minstr = 5

/obj/item/rogueweapon/flail/sflail/ancient
	name = "远古连枷"
	desc = "一颗抛光吉尔布兰泽钉球，以锁链连在加固手柄之上。人们说祂的子民曾将连枷奉若至宝，因为它旋舞时的轨迹仿佛重现了西翁彗星炽烈的飞行。"
	icon_state = "aflail"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/flail/sflail/ancient/decrepit
	name = "破旧连枷"
	desc = "一颗锻造青铜钉球，以锁链连在朽木握柄之上。每一次挥转，锁链都会发出呻吟，承受着千年来未曾再遇的力量；若挥得太狠，枷头甚至可能整颗甩飞出去。"
	force = 22
	max_integrity = 175
	color = "#bb9696"
	anvilrepair = null

/obj/item/rogueweapon/flail/sflail/silver
	force = 35
	icon_state = "silverflail"
	name = "白银晨星连枷"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flailrange)
	desc = "一柄沉重的白银连枷。它采用格伦泽霍夫式的“晨星”设计，以更长的链条延展攻击距离。虽然它比钢连枷更强，但也需要更大的力气才能挥得得心应手。"
	smeltresult = /obj/item/ingot/silver
	minstr = 12
	is_silver = TRUE

/obj/item/rogueweapon/flail/sflail/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/necraflail
	name = "“迅捷旅途”"
	desc = "这颗打击头上嵌满牙齿，每一次击中、每一次旋转都会发出凶恶的咯响。每一副牙都来自被持用者亲手送去安息之人，而将它们随身携带，正是最高形式的敬意。"
	icon_state = "necraflail"
	force = 35
	is_silver = TRUE

/obj/item/rogueweapon/flail/sflail/necraflail/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/psyflail
	name = "普赛顿连枷"
	desc = "一柄装饰华丽的连枷，表面覆有礼仪性的银层薄镀。它的翼棱枷头足以砸瘪最坚韧的黑钢锁甲。"
	icon_state = "psyflail"
	force = 35
	minstr = 10
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/flail/sflail/psyflail/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/psyflail/old
	name = "耐战连枷"
	desc = "一柄装饰华丽的连枷，只是表面的白银因疏于保养而失去光泽。让彗星坠向那些不洁之物吧。"
	icon_state = "psyflail"
	force = 30
	minstr = 5
	wdefense = 0
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/flail/sflail/psyflail/old/ComponentInitialize()
	return

/obj/item/rogueweapon/flail/sflail/psyflail/relic
	name = "“圣誓”"
	desc = "祂的悲恸、祂的痛苦、祂的希望，以及祂对人类的爱，尽皆悬于这条臂链末端那颗装饰华美的银钢枷头之上。 <br><br>它是献给普赛顿所珍视一切的爱之宣言，也是对宿敌的一记沉重警告：只要祂仍存世，他们便永无胜机。"
	icon_state = "psymorningstar"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flailrange)

/obj/item/rogueweapon/flail/sflail/psyflail/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/peasantwarflail
	force = 10
	force_wielded = 35
	possible_item_intents = list(/datum/intent/flail/strike)
	gripped_intents = list(/datum/intent/flail/strikerange, /datum/intent/mace/smash/flailrange)
	name = "民兵长连枷"
	desc = "正如投石索的弹丸也能击倒巨人，这柄大连枷同样遵循着将“动量”转化为“裂甲之力”的原则。"
	icon_state = "peasantwarflail"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	minstr = 9
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	anvilrepair = /datum/skill/craft/carpentry
	dropshrink = 0.9
	wdefense = 4
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/flail/peasantwarflail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/flail/peasantwarflail/matthios
	name = "鎏金连枷"
	desc = "将财富的分量，铸进这致命的一击末端。"
	icon_state = "matthiosflail"
	sellprice = 250
	smeltresult = /obj/item/ingot/steel
	possible_item_intents = list(/datum/intent/flail/strike/matthiosflail)
	gripped_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/mace/smash/flail/matthiosflail)
	associated_skill = /datum/skill/combat/whipsflails
	slot_flags = ITEM_SLOT_BACK
	anvilrepair = /datum/skill/craft/weaponsmithing
	wdefense = 5 //+1 compared to the peasant version, the magic golden babysmasher should be better than a shitty threasher.

/obj/item/rogueweapon/flail/peasantwarflail/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "FLAIL")

/obj/item/rogueweapon/flail/militia
	name = "民兵连枷"
	desc = "若是在另一种人生里，这柄朴素的打谷连枷原本只是拿来把麦穗敲成谷粒的工具。但落入民兵手中后，它也找到了新的使命：用伤筋断骨的重击教训那些自负过头的强盗。"
	icon_state = "milflail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flail/militia)
	force = 27
	wdefense = 3
	wbalance = WBALANCE_HEAVY
