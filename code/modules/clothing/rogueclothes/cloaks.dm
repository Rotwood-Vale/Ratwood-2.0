/obj/item/clothing/cloak
	name = "斗篷"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_CLOAK
	desc = "既能为你遮风挡雨，也能向旁人隐藏身份。"
	edelay_type = 1
	equip_delay_self = 10
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE //Vrell - AFAIK, all cloaks are cloth ATM. Technically semi-less future-proof, but it removes a line of code from every subtype, which is worth it IMO.
	experimental_inhand = FALSE
	color = null
	allowed_sex = list(MALE, FEMALE)

	grid_width = 64
	grid_height = 64
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

//////////////////////////
/// TABARD
////////////////////////

/obj/item/clothing/cloak/tabard
	name = "罩袍"
	desc = "一种为骑士准备的长款外罩。"
	icon_state = "tabard"
	item_state = "tabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/picked
	var/overarmor = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/cloak/abyssortabard
	name = "Abyssor信徒罩袍"
	desc = "Abyssor虔诚信徒所穿的罩袍。"
	icon_state = "abyssortabard"
	item_state = "abyssortabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/overarmor = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/abyssortabard/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把罩袍穿在护甲外" : "把罩袍穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/reformtabard
	name = "改革派罩袍"
	desc = "黑底白色Psy十字。它属于那些仍在哀悼、却敢于在无尽悲伤中继续活下去的人。愿我们对祂的追忆抚平仍在流血的心。"
	icon_state = "reformtabard"
	item_state = "reformtabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/overarmor = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/psydontabard
	name = "Psydon罩袍"
	desc = "Psydon门徒所穿的罩袍。精致的刺绣自豪地彰显着Psy十字。"
	icon_state = "psydontabard"
	item_state = "psydontabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/open_wear = FALSE
	var/overarmor = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/psydontabard/alt
	name = "敞开的Psydon罩袍"
	desc = "Psydon门徒所穿的罩袍，衣襟被翻开，露出其坚忍不屈的内里。"
	body_parts_covered = GROIN
	icon_state = "psydontabardalt"
	item_state = "psydontabardalt"
	flags_inv = HIDECROTCH
	open_wear = TRUE

/obj/item/clothing/cloak/psydontabard/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把罩袍穿在护甲外" : "把罩袍穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/cloak/psydontabard/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "敞开的Psydon罩袍"
			desc = "Psydon门徒所穿的罩袍，衣襟被翻开，露出其坚忍不屈的内里。"
			body_parts_covered = GROIN
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH // BARE YOUR CHEST, NOT YOUR WEEN!
			to_chat(usr, span_warning("现在以激进方式穿着！"))
		if(TRUE)
			name = "Psydon罩袍"
			desc = "Psydon门徒所穿的罩袍。精致的刺绣自豪地彰显着Psy十字。"
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("现在以正常方式穿着！"))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把罩袍穿在护甲外" : "把罩袍穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()



/obj/item/clothing/cloak/tabard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("无", "徽记", "分割", "四分", "方格", "菱纹")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	var/symbol_chosen = FALSE
	if(design == "徽记")
		design = null
		design = input(user, "选择一个徽记。","罩袍样式") as null|anything in list("chalice","psy","peace","z","imp","skull","widow","arrow")
		if(!design)
			return
		design = "_[design]"
		symbol_chosen = TRUE
	var/colorone = input(user, "选择主色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
	if(!colorone)
		return
	var/colortwo
	if(design != "无")
		colortwo = input(user, "选择副色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design != "无")
		detail_tag = design
	switch(design)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	boobed_detail = !symbol_chosen
	color = clothing_color2hex(colorone)
	if(colortwo)
		detail_color = clothing_color2hex(colortwo)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		boobed_detail = initial(boobed_detail)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/knight
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/tabard/knight/attack_right(mob/user)
	return

/obj/item/clothing/cloak/tabard/knight/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/knight/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/crusader
	detail_tag = "_psy"
	detail_color = CLOTHING_RED
	boobed_detail = FALSE

/obj/item/clothing/cloak/tabard/crusader/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/tabard/crusader/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("默认", "金十字", "杰鲁亚", "黑金", "黑白")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "金十字")
		detail_color = "#b5b004"
	if(design == "杰鲁亚")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "黑金")
		detail_color = CLOTHING_YELLOW
		color = CLOTHING_BLACK
	if(design == "黑白")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/crusader/tief
	color = CLOTHING_RED
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/astrata
	color = "#9B7538"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/ravox
	color = CLOTHING_RED
	detail_color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/crusader/malum
	color = CLOTHING_RED
	detail_color = CLOTHING_YELLOW

/obj/item/clothing/cloak/tabard/crusader/abyssor
	color = "#373f69"
	detail_color = "#974305"

/obj/item/clothing/cloak/tabard/crusader/dendor
	color = "#4B5637"
	detail_color = "#3D1D1C"

/obj/item/clothing/cloak/tabard/crusader/necra
	color = "#222223"
	detail_color = "#CACBC5"

/obj/item/clothing/cloak/tabard/crusader/pestra
	color = CLOTHING_WHITE
	detail_color = CLOTHING_GREEN

/obj/item/clothing/cloak/tabard/crusader/noc
	color = "#2C2231"
	detail_color = "#9AB0B0"

/obj/item/clothing/cloak/tabard/crusader/psydon
	color = CLOTHING_BLACK
	detail_color = CLOTHING_WHITE

//Eora content from Stonekeep

/obj/item/clothing/cloak/tabard/crusader/eora
	color = "#4D1E49"
	detail_color = "#A95650"


/obj/item/clothing/cloak/tabard/crusader/tief/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("默认", "红黑", "黑红")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "红黑")
		detail_color = CLOTHING_BLACK
		color = CLOTHING_RED
	if(design == "黑红")
		detail_color = CLOTHING_RED
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/retinue
	desc = "带有领主纹章配色的罩袍。"
	color = CLOTHING_AZURE
	detail_tag = "_quad"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/retinue/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割", "四分", "方格", "菱纹")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/retinue/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/retinue/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/retinue/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/retinue/captain //Because of his other snowflake cloak we can't actually use the naming normally.
	name = "队长罩袍"

//////////////////////////
/// SOLDIER TABARD
////////////////////////

/obj/item/clothing/cloak/stabard
	name = "士兵罩袍"
	desc = "士兵们常穿的一种外罩衣物。"
	icon_state = "stabard"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/picked
	var/overarmor = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/stabard/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把罩袍穿在护甲外" : "把罩袍穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/stabard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("无","分割", "四分", "方格", "菱纹")
	if(!design)
		return
	var/colorone = input(user, "选择主色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
	if(!colorone)
		return
	var/colortwo
	if(design != "无")
		colortwo = input(user, "选择副色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	switch(design)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	color = clothing_color2hex(colorone)
	if(colortwo)
		detail_color = clothing_color2hex(colortwo)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		boobed_detail = initial(boobed_detail)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/guard
	name = "守卫罩袍"
	desc = "带有领主纹章配色的罩袍。"
	color = CLOTHING_AZURE
	detail_tag = "_spl"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/stabard/guard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割", "四分", "方格", "菱纹")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/stabard/guard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/guard/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/stabard/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/stabard/bog
	name = "沼民罩袍"
	desc = "一件以沼泽伟大守护者那荣耀绿色染成的罩袍。" // THE BOG DESERVES A BETTER DESCRIPTION!
	color = CLOTHING_GREEN
	detail_color = CLOTHING_DARK_GREEN

/obj/item/clothing/cloak/stabard/grenzelhoft
	name = "Grenzelhoft佣兵罩袍"
	desc = "一件采用Grenzelhoft帝国佣兵公会配色的罩袍。"
	color = CLOTHING_YELLOW
	detail_color = CLOTHING_RED
	detail_tag = "_box"

/obj/item/clothing/cloak/stabard/dungeon
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/stabard/dungeon/attack_right(mob/user)
	return

/obj/item/clothing/cloak/stabard/mercenary
	detail_tag = "_quad"

/obj/item/clothing/cloak/stabard/mercenary/Initialize(mapload)
	. = ..()
	detail_tag = pick("_quad", "_spl", "_box", "_dim")
	color = clothing_color2hex(pick(CLOTHING_COLOR_NAMES))
	detail_color = clothing_color2hex(pick(CLOTHING_COLOR_NAMES))
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

//////////////////////////
/// SURCOATS
////////////////////////

/obj/item/clothing/cloak/stabard/surcoat
	name = "战袍"
	icon_state = "surcoat"

/obj/item/clothing/cloak/stabard/surcoat/bailiff
	color = "#641E16"

/obj/item/clothing/cloak/stabard/surcoat/councillor
	color = "#2d2d2d"

/obj/item/clothing/cloak/stabard/surcoat/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一种样式。","罩袍样式") as null|anything in list("无","分割", "四分", "方格", "菱纹")
	if(!design)
		return
	var/colorone = input(user, "选择主色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
	if(!colorone)
		return
	var/colortwo
	if(design != "无")
		colortwo = input(user, "选择副色。","罩袍样式") as null|anything in CLOTHING_COLOR_NAMES
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	switch(design)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	color = clothing_color2hex(colorone)
	if(colortwo)
		detail_color = clothing_color2hex(colortwo)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/surcoat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/surcoat/guard
	desc = "带有领主纹章配色的战袍。"
	color = CLOTHING_AZURE
	detail_tag = "_quad"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/stabard/surcoat/guard/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割", "四分", "方格", "菱纹")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
		if("四分")
			detail_tag = "_quad"
		if("方格")
			detail_tag = "_box"
		if("菱纹")
			detail_tag = "_dim"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/surcoat/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/stabard/surcoat/guard/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/stabard/surcoat/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/stabard/black
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/lordcloak
	name = "领主斗篷"
	desc = "饰有白鼬毛边，代代相传。"
	icon_state = "lord_cloak"
	item_state = "lord_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
//	allowed_sex = list(MALE)
	detail_tag = "_det"
	detail_color = CLOTHING_AZURE
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/lordcloak/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/lordcloak/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/lordcloak/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/lordcloak/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/darkcloak
	name = "黑斗篷"
	desc = "它能温暖你的皮肉，却温暖不了你冰冷死寂的心。"
	icon_state = "dark_cloak"
	item_state = "dark_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_result = /obj/item/natural/fur
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/darkcloak/bear
	name = "恐熊斗篷"
	desc = "由最上等、最暖和的熊皮制成。它或许比你的命还值钱。"
	icon_state = "bear_cloak"
	item_state = "bear_cloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = CLOTHED_RACES_TYPES
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 3
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/darkcloak/bear/light
	name = "轻型恐熊斗篷"
	icon_state = "bbear_cloak"
	item_state = "bbear_cloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 3

/obj/item/clothing/cloak/darkcloak/bear/wardenmaster
	name = "守林总长战利斗篷"
	desc = "由最强壮、最凶猛的黑色恐熊毛皮制成，是杰出猎手的象征。"
	sellprice = 80
	color = "#99a39d"

/obj/item/clothing/cloak/darkcloak/minotaur
	name = "牛头怪斗篷"
	desc = "牛头怪毛皮与稻草被粗糙地缝成一件长披肩。"
	icon_state = "mino"
	item_state = "mino"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 4

/obj/item/clothing/cloak/darkcloak/minotaur/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/apron/maid
	name = "女仆围裙"
	desc = "宅邸管事穿的荷叶边围裙，上面有能放小东西的口袋。"
	detail_color = "_detail"
	slot_flags = ITEM_SLOT_ARMOR | ITEM_SLOT_CLOAK
	detail_color = CLOTHING_BLACK
	icon_state = "maidapron"
	item_state = "maidapron"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	boobed = FALSE
	grid_width = 64
	grid_height = 64

/obj/item/clothing/cloak/apron
	name = "围裙"
	desc = "许多工坊工人都会使用的围裙。"
	icon_state = "apron"
	item_state = "apron"
	color = "#c9c3bd"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	allowed_race = CLOTHED_RACES_TYPES
	flags_inv = HIDECROTCH|HIDEBOOB
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	dropshrink = null

/obj/item/clothing/cloak/apron/blacksmith
	name = "皮围裙"
	desc = "由锻冶金属、操作熔炉之人使用的皮围裙。"
	icon_state = "leather_apron"
	item_state = "leather_apron"
	body_parts_covered = CHEST|GROIN
	armor = ARMOR_CLOTHING
	boobed = TRUE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/apron/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/apron/waist
	name = "腰围裙"
	desc = "一条系在腰间的简便围裙，方便干活时使用。"
	color = "#c9c3bd" //default spawns are less eye-searingly white
	icon_state = "waistpron"
	item_state = "waistpron"
	body_parts_covered = GROIN
	boobed = FALSE
	flags_inv = HIDECROTCH

/obj/item/clothing/cloak/apron/waist/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/apron/waist/bar
	color = "#251f1d"


/obj/item/clothing/cloak/apron/cook
	name = "厨师围裙"
	desc = "一条专门用来彰显厨师有多干净的围裙。"
	icon_state = "aproncook"
	item_state = "aproncook"
	body_parts_covered = GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	boobed = FALSE

/*
/obj/item/clothing/cloak/apron/waist/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 1

/obj/item/clothing/cloak/apron/waist/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	CP.on_attack_hand(CP, user)
	return TRUE*/

/obj/item/clothing/cloak/raincloak
	name = "雨披"
	desc = "这件能帮你抵挡雨天。"
	icon_state = "rain_cloak"
	item_state = "rain_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = /obj/item/clothing/head/hooded/rainhood
	toggle_icon_state = FALSE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/raincloak/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/raincloak/mortus
	desc = "死亡始终笼罩着你。"
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/raincloak/brown
	color = CLOTHING_BROWN
	sellprice = 25

/obj/item/clothing/cloak/raincloak/green
	color = CLOTHING_GREEN

/obj/item/clothing/cloak/raincloak/blue
	color = CLOTHING_BLUE

/obj/item/clothing/cloak/raincloak/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/raincloak/drab
	color = CLOTHING_DRAB
/obj/item/clothing/cloak/raincloak/darkdrab
	color = CLOTHING_DARKDRAB

/obj/item/clothing/head/hooded/rainhood
	name = "兜帽"
	desc = "它既能替我遮挡风雨，也能掩住我的身份。"
	icon_state = "rain_hood"
	item_state = "rain_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
/obj/item/clothing/cloak/raincloak/furcloak
	name = "毛皮斗篷"
	desc = "这件华美斗篷由兽皮制成，十分柔软而温暖。"
	icon_state = "furgrey"
	inhand_mod = FALSE
	hoodtype = /obj/item/clothing/head/hooded/rainhood/furhood
	salvage_result = /obj/item/natural/fur
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/raincloak/furcloak/crafted/Initialize(mapload)
	. = ..()
	if(prob(50))
		color = pick("#685542","#66564d")

/obj/item/clothing/cloak/raincloak/furcloak/brown
	color = "#685542"

/obj/item/clothing/cloak/raincloak/furcloak/black
	color = "#2b292e"

/obj/item/clothing/cloak/raincloak/furcloak/darkgreen
	color = "#264d26"

/obj/item/clothing/cloak/raincloak/furcloak/woad
	name = "靛纹斗篷"
	desc = "一件以靛蓝染色的毛皮斗篷，既保暖又带着浓厚的林地风格。"
	color = "#597fb9"

/obj/item/clothing/head/hooded/rainhood/furhood
	icon_state = "fur_hood"
	block2add = FOV_BEHIND
	cold_protection = HEAD
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/lepoardcloak
	name = "豹皮斗篷"
	desc = "这件华贵斗篷由豹皮制成，唯有最富有、最显赫之人才配穿戴。"
	icon_state = "lepoardcape"
	inhand_mod = FALSE
	salvage_result = /obj/item/natural/fur
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/cape
	name = "披风"
	desc = "一件美丽而飘逸的披风。可惜太容易被植被挂住。"
	icon_state = "cape"
	item_state = "cape"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/cape/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/cape/knight
	color = CLOTHING_WHITE

/obj/item/clothing/cloak/cape/guard
	color = CLOTHING_AZURE

/obj/item/clothing/cloak/cape/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/cape/guard/lordcolor(primary,secondary)
	color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
/obj/item/clothing/cloak/cape/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/cloak/cape/puritan
	icon_state = "puritan_cape"
	allowed_race = CLOTHED_RACES_TYPES
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/cloak/cape/archivist
	icon_state = "puritan_cape"
	color = CLOTHING_BLACK
	allowed_race = CLOTHED_RACES_TYPES

/obj/item/clothing/cloak/cape/inquisitor
	name = "仲裁者斗篷"
	desc = "Otava仲裁者所披的斗篷，他们是宗教裁判所中的一种战士祭司。 \
	正如它的主人一样，这件斗篷多半也见过一些骇人的景象。"
	icon_state = "inquisitor_cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/cape/rogue
	name = "盗贼披风"
	icon_state = "roguecape"
	item_state = "roguecape"

/obj/item/clothing/cloak/cape/hood
	name = "连兜帽披风"
	icon_state = "hoodcape"
	item_state = "hoodcape"

/obj/item/clothing/cloak/chasuble
	name = "祭披"
	desc = ""
	icon_state = "chasuble"
	body_parts_covered = CHEST|GROIN|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES


/obj/item/clothing/cloak/stole
	name = "圣带"
	desc = ""
	icon_state = "stole_gold"
	item_state = "stole_gold"
	sleeved = null
	sleevetype = null
	body_parts_covered = null
	flags_inv = null
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/stole/red
	icon_state = "stole_red"
	item_state = "stole_red"

/obj/item/clothing/cloak/stole/purple
	icon_state = "stole_purple"

/obj/item/clothing/cloak/black_cloak
	name = "黑色斗篷"
	desc = "黑得深沉的斗篷，仿佛会把整个人都藏进阴影里。"
	icon_state = "black_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/cloak/heartfelt
	name = "心念斗篷"
	desc = ""
	icon_state = "heartfelt_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/undivided
	name = "教廷斗篷"
	desc = "教廷的象征。终末之日已近在眼前，羔羊啊。你仍要执着于希望吗？"
	icon_state = "seecloak"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

//don't make a subtype of this unless you can account for it flipping side to side when you right click
/obj/item/clothing/cloak/half
	name = "半斗篷"
	desc = ""
	icon_state = "halfcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	color = CLOTHING_BLACK
	flags_inv = null
	var/flipped = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/half/attack_right(mob/user)
	if(!flipped)
		icon_state += "_rev"
		flipped = TRUE
	else
		icon_state = initial(icon_state)
		flipped = FALSE
	user.regenerate_icons()

/obj/item/clothing/cloak/half/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/half/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/half/orange
	color = CLOTHING_ORANGE

/obj/item/clothing/cloak/half/rider
	name = "骑手斗篷"
	icon_state = "guardcloak"
	color = CLOTHING_AZURE
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE

/obj/item/clothing/cloak/half/rider/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/half/vet
	name = "城镇守卫斗篷"
	icon_state = "guardcloak"
	color = CLOTHING_AZURE
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE

/obj/item/clothing/cloak/half/vet/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/half/vet/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/shadowcloak
	name = "潜猎者斗篷"
	desc = "一件厚实的皮斗篷，以镀金别针扣住，上面刻着大公家徽。这是忠诚侍从的标志。"
	icon_state = "shadowcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/thief_cloak
	name = "无赖披巾"
	desc = "一条用廉价扣件固定的简单披巾。实用好使，只是布料粗糙而且已经磨旧。"
	icon_state = "thiefcloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = CLOTHING_ORANGE

/obj/item/clothing/cloak/thief_cloak/yoruku
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/templar
	var/overarmor = TRUE

/obj/item/clothing/cloak/templar/psydon
	name = "Psydon罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Psydon的标志。"
	icon_state = "tabard_weeping"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/astrata
	name = "Astrata罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Astrata的标志。"
	icon_state = "tabard_astrata_alt"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/noc
	name = "Noc罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Noc的标志。"
	icon_state = "tabard_noc"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/dendor
	name = "Dendor罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Dendor的标志。"
	icon_state = "tabard_dendor"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/necra
	name = "Necra罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Necra的标志。"
	icon_state = "tabard_necra"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/abyssor
	name = "Abyssor罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Abyssor的标志。"
	icon_state = "tabard_abyssor"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/malum
	name = "Malum罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Malum的标志。"
	icon_state = "tabard_malum"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/volfmantle
	name = "沃尔夫披肩"
	desc = "用被猎杀沃尔夫的皮与头制成的温暖斗篷。如果这都不算身份象征，那就没什么算了。"
	icon_state = "volfpelt"
	item_state = "volfpelt"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	dropshrink = null

/obj/item/clothing/cloak/wickercloak
	name = "柳枝斗篷"
	desc = "用泥巴、树枝和纤维临时搭成的斗篷。"
	icon_state = "wicker_cloak"
	item_state = "wicker_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK	
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/tribal
	name = "部族毛皮"
	desc = "一张随意硝制过的怪物皮，披在身体或护甲外侧，可额外御寒。就是有点扎人。"
	icon_state = "tribal"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	body_parts_covered = CHEST|GROIN|VITALS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	boobed = FALSE
	sellprice = 10
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	dropshrink = null

/obj/item/clothing/cloak/lordcloak/ladycloak
	name = "淑女短斗篷"
	desc = "短小精致的淑女斗篷，既得体又能衬出高贵气质。"
	icon_state = "shortcloak"
	item_state = "shortcloak"
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	cold_protection = ARM_LEFT | ARM_RIGHT

/obj/item/clothing/cloak/matron
	name = "主母斗篷"
	desc = "只有最刻薄的老妪才会费心去穿的斗篷。"
	icon_state = "matroncloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon ='icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/battlenun
	name = "修女法衣"
	desc = "贞洁、正直，对恶人绝不留情。"
	icon_state = "battlenun"
	item_state = "battlenun"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/templar/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把罩袍穿在护甲外" : "把罩袍穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/templar/eora
	name = "Eora罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Eora的标志。"
	icon_state = "tabard_eora"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/pestra
	name = "Pestra罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Pestra的标志。"
	icon_state = "tabard_pestra"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/cleric/ravox
	name = "Ravox罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Ravox的标志。"
	icon_state = "tabard_ravox"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/ravox
	name = "正义罩袍"
	desc = "带护颈的内甲法衣，由Ravox圣殿骑士穿戴。"
	icon_state = "justicetabard"
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK|ITEM_SLOT_MASK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/xylix
	name = "Xylix罩袍"
	desc = "士兵常穿的一种外罩衣物，这件上面带有Xylix的标志。"
	icon_state = "tabard_xylix"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/cape/blkknight
	name = "黑骑士披风"
	icon_state = "bkcape"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX


/obj/item/clothing/head/roguetown/helmet/heavy/blkknight
	name = "黑钢头盔"
	icon_state = "bkhelm"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]装到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]把[W]装到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)


/obj/item/clothing/cloak/tabard/blkknight
	name = "血绶带"
	icon_state = "bksash"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	dropshrink = null

/obj/item/clothing/under/roguetown/platelegs/blk
	name = "黑钢腿甲"
	icon_state = "bklegs"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/gloves/roguetown/plate/blk
	name = "黑钢臂铠"
	icon_state = "bkgloves"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/suit/roguetown/armor/plate/blkknight
	slot_flags = ITEM_SLOT_ARMOR
	name = "黑钢板甲"
	desc = "一件以黑钢打造的厚重板甲，足以让穿戴者看起来如灾厄降临。"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	icon_state = "bkarmor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/shoes/roguetown/boots/armor/blkknight
	name = "黑钢战靴"
	icon_state = "bkboots"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

//Short hoods for guards

/obj/item/clothing/cloak/stabard/guardhood
	name = "守卫兜帽"
	desc = "带有领主纹章配色的兜帽。"
	color = CLOTHING_AZURE
	detail_tag = "_spl"
	detail_color = CLOTHING_WHITE
	icon_state = "guard_hood"
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/stabard/guardhood/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "选择一种样式。","罩袍样式") as null|anything in list("分割")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("分割")
			detail_tag = "_spl"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "重选") != "满意")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/stabard/guardhood/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/stabard/guardhood/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/stabard/guardhood/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/stabard/guardhood/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/stabard/guardhood/elder
	name = "长老兜帽"

/obj/item/clothing/cloak/hierophant
	name = "大祭司绶带"
	icon_state = "naledisash"
	item_state = "naledisash"
	desc = "一条柔软布带，传统上用于束紧过于宽松的袋子，但在如今更多只是一种时尚宣言。"

/obj/item/clothing/cloak/stabard/grenzelmage
	name = "Grenzelhoft法师披肩"
	desc = "一件时髦的披肩，常见于天穹学院的法师穿着。"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	detail_tag = "_spl"
	icon_state = "guard_hood" // The same as the guard hood however to break it from using the lords colors it has been given its own item path
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/wardencloak
	name = "守林人斗篷"
	desc = "山谷森林守林人所穿的斗篷。"
	icon_state = "wardencloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection =  CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/poachercloak
	name = "风化守林人斗篷"
	desc = "一件破旧的斗篷，曾经为穿戴者保暖避雨，如今只能勉强让血别溅到衣服上。"
	icon_state = "poachercloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE

/obj/item/clothing/cloak/graggar
	name = "凶暴斗篷"
	desc = "这腐败世界里唯一真正推动万物的力量就是暴力。去成为它的掌控者，而不是牺牲品。"
	icon_state = "graggarcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection =  CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "CLOAK", "RENDERED ASUNDER")

/obj/item/clothing/cloak/forrestercloak
	name = "林务官斗篷"
	desc = "山谷黑橡守林者所穿的斗篷。"
	icon_state = "forestcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection =  CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/forrestercloak/snow
	name = "雪斗篷"
	desc = "一件能在山中严寒与山谷湿气里保持身体温暖的斗篷。"
	icon_state = "snowcloak"
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT

/// Dendor ritual reward variant of the forrester cloak — hallowed by the Treefather.
/obj/item/clothing/cloak/forrestercloak/blessed
	name = "赐福林务官斗篷"
	desc = "一件受树父仪式祝圣的林务官斗篷。活木纤维编织在布料之中，仿佛与森林静谧的生命一同呼吸。"
	color = "#73c47a"

/obj/item/clothing/cloak/forrestercloak/blessed/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/cloak/forrestercloak/blessed/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name]拒绝了我的触碰，唯有树父的信徒才配承此赠礼！"))

/obj/item/clothing/cloak/poncho
	name = "布制披衫"
	desc = "一种通常披在上半身的宽松衣物。没人真正说得清它最初来自哪种文化。"
	icon_state = "poncho"
	item_state = "poncho"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	color = CLOTHING_WHITE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE

//eastern update

/obj/item/clothing/cloak/eastcloak1
	name = "斩云者斗篷"
	desc = "一件带白色云纹的棕色斗篷。有些人会认出这是一种古老的军事象征。"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon_state = "eastcloak1"
	item_state = "eastcloak1"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/eastcloak2
	name = "皮斗篷"
	desc = "一件棕色斗篷，没什么特别之处。"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon_state = "eastcloak2"
	item_state = "eastcloak2"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/psyaltrist
	name = "诗班长圣带"
	desc = "一条丝质圣带，绣有银饰花纹，背后还藏有暗袋，可披在圣歌卷轴外。它是Otava大教堂诗班领袖学成后的传统装束，也是其身份象征。"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	icon_state = "psaltertabard"
	item_state = "psaltertabard"
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/ordinatorcape
	name = "训令官披风"
	desc = "一件飘逸的红披风，配有纹饰华美的钢制肩甲。为持久而造。为坚忍而造。为生存而造。"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "ordinatorcape"
	item_state = "ordinatorcape"
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/absolutionistrobe
	name = "赦罪者长袍"
	desc = "宽恕他们的痛苦。宽恕他们的渴望。如同PSYDON一般地生存。"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "absolutionistrobe"
	item_state = "absolutionistrobe"
	sleevetype = "shirt"
	inhand_mod = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/cotehardie
	name = "修身外套"
	desc = "也被称作cotehardie：一种无论平民还是贵族都会穿的长袖外衣，男女皆宜，四季可用。脱下时，里面装着的东西不会掉出来。"
	color = "#586849"
	icon_state = "cotehardie"
	item_state = "cotehardie"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN|ARMS
	boobed = TRUE
	slot_flags = ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_tag = "_detail"
	detail_color = "#36241f"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "cotehardie"
	nodismemsleeves = FALSE
	var/overarmor = TRUE

/obj/item/clothing/cloak/cotehardie/Initialize(mapload)
	..()
	update_icon()

/obj/item/clothing/cloak/cotehardie/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把外套穿在护甲外" : "把外套穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/captain
	name = "队长披风"
	desc = "一件绣有山谷金色纹章的披风。"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleevetype = "shirt"
	icon_state = "capcloak"
	detail_tag = "_detail"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	detail_color = "#39404d"
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/captain/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary, GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/knight/guard/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/captain/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/kazengun
	name = "阵羽织"
	desc = "一种简朴的东境战袍，在这片遥远战场上用来分辨敌我。"
	icon_state = "kazenguncoat"
	item_state = "kazenguncoat"
	detail_tag = "_detail"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = "#FFFFFF"
	detail_color = "#FFFFFF"

/obj/item/clothing/cloak/kazengun/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/duelistcape
	name = "决斗者披风"
	desc = "决斗者偏爱的一种短披风。"
	icon_state = "duelistcape"
	item_state = "duelistcape"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600
	dropshrink = null

/obj/item/clothing/cloak/citywatch
	name = "城巡披风"
	desc = "一件体面的披风，彰显着某种都市权威。"
	icon = 'icons/roguetown/clothing/licensed-infraredbaron/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/licensed-infraredbaron/onmob/cloaks.dmi'
	icon_state = "citywatch_cape"
	item_state = "citywatch_cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/citywatchcaptain
	name = "城巡队长斗篷"
	desc = "一件极为体面的斗篷，彰显着更上一层的都市权威。"
	icon_state = "shortcloak"
	item_state = "shortcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
