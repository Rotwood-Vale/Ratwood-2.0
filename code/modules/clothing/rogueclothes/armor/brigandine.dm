
/obj/item/clothing/suit/roguetown/armor/brigandine
	slot_flags = ITEM_SLOT_ARMOR
	name = "布里甘丁甲"
	desc = "遵循伊特鲁斯坎传统制成的复合护甲。它是优质的弧形板片胸甲，以染色皮革缝合，并配有宽下摆以遮护腹股沟。"
	icon_state = "brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM //good idea suggested by lamaster
	sleeved_detail = FALSE
	boobed_detail = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_COAT_STEP)

/obj/item/clothing/suit/roguetown/armor/brigandine/attack_right(mob/user)
	if(detail_tag)
		return
	var/the_time = world.time
	var/pickedcolor = input(user, "选择颜色。","布里甘丁配色") as null|anything in CLOTHING_COLOR_NAMES
	if(!pickedcolor)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	detail_tag = "_det"
	detail_color = clothing_color2hex(pickedcolor)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/lordcolor(primary,secondary)
	detail_tag = "_det"
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/armor/brigandine/heartfelt
	slot_flags = ITEM_SLOT_ARMOR
	name = "心誓式布里甘丁甲"
	desc = "遵循 Heartfelt 传统制成的复合护甲。它是优质的弧形板片胸甲，以染色皮革缝合，并配有宽下摆以遮护腹股沟。"
	icon_state = "brigandine2"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM //good idea suggested by lamaster
	sleeved_detail = FALSE
	boobed_detail = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/heartfelt/attack_right(mob/user)
	if(detail_tag)
		return
	var/the_time = world.time
	var/pickedcolor = input(user, "选择颜色。","布里甘丁配色") as null|anything in CLOTHING_COLOR_NAMES
	if(!pickedcolor)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	detail_tag = "_det"
	detail_color = clothing_color2hex(pickedcolor)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/heartfelt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
	name = "板片外衣"
	desc = "缀有板片的皮革外衣，在保留机动性的同时提升防护。下层皮革或许还能挡住匕首。"
	icon_state = "coat_of_plates"
	blocksound = PLATEHIT
	smelt_bar_num = 2
	armor_class = ARMOR_CLASS_HEAVY
	peel_threshold = 4
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/coat
	name = "指挥官外衣"
	desc = "厚实的煮制皮革罩衣，褶层中藏有足够多的板片以提供卓越防护。它沉重无比，唯有强者才能穿上。"
	icon_state = "leathercoat"
	item_state = "leathercoat"
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50
	var/picked = FALSE
	sleeved_detail = TRUE
	boobed_detail = TRUE

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/coat/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/pickedvalue = input(user, "选择颜色", "弑君者装束") as null|anything in list("卡其", "黑色")
	if(!pickedvalue)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(pickedvalue == "卡其")
		picked = TRUE
	else if(pickedvalue == "黑色")
		picked = TRUE
		icon_state = "bleathercoat"
		item_state = "bleathercoat"
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_armor()


/obj/item/clothing/suit/roguetown/armor/brigandine/light
	slot_flags = ITEM_SLOT_ARMOR
	name = "轻型布里甘丁甲"
	desc = "轻便的铆接外衣，板片藏在外层布料内。很容易被匕首从肋间捅入。"
	icon_state = "light_brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 25//Same define as studded leather armor which this has the same resistance/coverage as.
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_LIGHT//steel version of the studded leather armor now
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/suit/roguetown/armor/brigandine/light/attack_right(mob/user)
	if(detail_tag)
		return
	var/the_time = world.time
	var/pickedcolor = input(user, "选择颜色。","布里甘丁配色") as null|anything in CLOTHING_COLOR_NAMES
	if(!pickedcolor)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	detail_tag = "_detail"
	detail_color = clothing_color2hex(pickedcolor)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/light/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue/lordcolor(primary,secondary)
	detail_tag = "_detail"
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/armor/brigandine/captain
	name = "队长布里甘丁甲"
	desc = "专为山谷队长量身打造并锻造的板片外衣。"
	icon_state = "capplate"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	detail_tag = "_detail"
	detail_color = "#39404d"
	blocksound = SOFTHIT
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	armor = ARMOR_CUIRASS // Unique armor, uniquely good value coverage.
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL // Makes the armor equivilient w/ darkened steel plate.
	sellprice = 363 // On par w/ judgement and ichor fang cuz why not
	smelt_bar_num = 2
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate
	name = "韩心海胸甲"
	desc = "较常见的卡曾贡式护甲，由数块彼此咬合的黑钢镀层钢板构成。比整套护甲便宜得多，常见于民兵与常备军。"
	icon_state = "kazengunmedium"
	boobed = FALSE
	item_state = "kazengunmedium"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择颜色。", "制服配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
