// GAMBESON ARMOUR

/obj/item/clothing/suit/roguetown/armor/gambeson
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "绗缝护甲衣"
	desc = "用于穿在盔甲里面的大号护衣。"
	icon_state = "gambeson"
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_PADDED
	prevent_crits = list(BCLASS_CUT,BCLASS_BLUNT)
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	color = "#c5ab8c"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	color = "#646464"

/obj/item/clothing/suit/roguetown/armor/gambeson/lord
	name = "武装短衣"
	icon_state = "dgamb"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	allowed_sex = list(MALE, FEMALE)
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT 
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
	name = "潜猎者长袍"
	desc = "厚实的皇家紫长袍，配得上王手之位，同时也方便其悄然行动。"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon_state = "shadowrobe"


/obj/item/clothing/suit/roguetown/armor/gambeson/light
	name = "轻型绗缝护甲衣"
	desc = "薄而几乎没有衬垫的绗缝护甲衣，平民常把它当作廉价却体面的全身护甲。或许能挡下一箭。"
	armor = ARMOR_PADDED_BAD
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	prevent_crits = null // It won't help, like, at all.
	sellprice = 10

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	name = "加厚绗缝护甲衣"
	desc = "增加了额外衬层并经硬化处理的绗缝护甲衣，更加耐用。它仍比不上皮革或金属，但多半能挡下一支弩矢，因此通常用来搭配正式护甲。"
	icon_state = "gambesonp"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25
	color = "#b49679"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	var/shiftable = TRUE
	var/shifted = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/attack_right(mob/user)
	if(!shiftable || !user)
		return

	if(shifted)
		if(alert("你想正常穿着这件绗缝护甲衣吗？- 恢复染色, 新款式。",, "是", "否") != "是")
			return
		icon_state = "gambesonp"
		color = "#976E6B"
		update_icon()
		shifted = FALSE
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()
		return

	if(alert("你想按传统方式穿着这件绗缝护甲衣吗？ -恢复染色, 旧款式。",, "是", "否") != "是")
		return
	icon_state = "gambesonpold"
	color = null
	update_icon()
	shifted = TRUE
	if(ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_shirt()
		H.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
	name = "皇家绗缝护甲衣"
	desc = "为王室准备的华贵绗缝护甲衣，额外装饰并增加了衬垫防护。"
	icon_state = "royalgamb"
	color = "#FFFFFF"
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	boobed = TRUE
	nodismemsleeves = TRUE
	sleeved_detail = TRUE
	boobed_detail = FALSE
	detail_tag = "_detail"
	detail_color = "#e2ab32"
	max_integrity = 250 //Same as grenzelshirt
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	name = "击剑绗缝护甲衣"
	desc = "带厚实衬垫的大号护衣，适合穿在盔甲里面。大概能挡住箭矢，但未必挡得住弩矢。"
	icon_state = "fancygamb"
	allowed_race = NON_DWARVEN_RACE_TYPES
	color = "#5058c1"
	detail_color = "#e98738"
	detail_tag = "_detail"
	shiftable = FALSE
	sellprice = 30
	dropshrink = 0.9
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择一种颜色。", "奥塔凡配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	name = "加垫击剑衬衣"
	desc = "结实而宽松的绗缝衬衣，对手臂负担很小，通常穿在坚固皮背心里面。它护不到你的腿。"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "fencingshirt"
	color = "#FFFFFF"
	detail_color = "#414143"
	altdetail_color = "#c08955"
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	shiftable = FALSE
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择一种颜色。", "击剑配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/update_icon()
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

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	name = "加垫长袍"
	desc = "一种常见于纳雷迪、卡曾贡、格隆与阿夫纳尔的长外衣，但更多让人联想到草原民与劫掠者。这一款在防护上足以媲美绗缝护甲衣。"
	icon_state = "chargah"
	color = "#ffffff"
	boobed = TRUE
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "格伦泽尔霍夫长摆衬衣"
	desc = "为额外舒适与防护而制的加垫衬衣，并饰以鲜艳色彩。"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "grenzelshirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	boobed = FALSE // Temporary fix, set to FALSE because for some reason boobed and details don't want to work together, removing the ability to dye it or it's details for the onmob
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	color = "#1d1d22"
	detail_color = "#FFFFFF"
	sellprice = 40
	shiftable = FALSE
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择一种颜色。", "格伦泽尔霍夫配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	name = "沙漠长衣"
	desc = "修身的谢尔瓦尼式长衣，拜班廷风格，专为耐受沙漠气候而制。"
	icon_state = "sherwani"
	color = CLOTHING_DARKDRAB

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	name = "加垫沙漠长衣"
	desc = "修身的谢尔瓦尼式长衣，拜班廷风格，专为耐受沙漠气候而制。这一件填充厚实，专供战士穿着。"
	icon_state = "sherwani"
	color = "#eec39a"
	shiftable = FALSE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	name = "大祭司披巾"
	icon_state = "desertrobe"
	item_state = "desertrobe"
	desc = "厚袍中交织着附有咒法的织物。它厚实而有防护，却仍轻盈透气；既能抵御烈日、沙漠与恶魔的威胁，又不妨碍施法。"
	naledicolor = TRUE
	shiftable = FALSE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	name = "教宗长衫"
	icon_state = "monkleather"
	item_state = "monkleather"
	desc = "紧身的煮制皮甲，能完美贴合穿戴者的身形。"
	shiftable = FALSE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	name = "宗审庭皮束衣"
	desc = "最上乘的皮束衣。为忍耐而制，为审问而制，无论面对异端还是地狱烈焰。"
	icon_state = "leathertunic"
	color = null
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)
	armor = ARMOR_PADDED
	shiftable = FALSE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	name = "潜猎者长袍"
	desc = "由虫蛀布料与廉价紫染做成的袍式绗缝衣。任何有自尊的精灵都不会穿它。"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon_state = "shadowrobe"
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM + 30 //280
