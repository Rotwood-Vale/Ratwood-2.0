/obj/item/clothing/suit/roguetown/shirt
	slot_flags = ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	equip_sound = 'sound/blank.ogg'
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	sleevetype = "shirt"
	edelay_type = 1
	equip_delay_self = 25
	bloody_icon_state = "bodyblood"
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = HIDEBOOB
	experimental_inhand = FALSE
	salvage_amount = 2

	grid_width = 64
	grid_height = 32

/obj/item/clothing/suit/roguetown/shirt/undershirt
	name = "衬衣"
	desc = "朴素而谦逊，让你在公共场合行走时仍能保有体面。"
	icon_state = "undershirt"
	item_state = "undershirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	name = "内法衣"
	desc = "柔软的内衬衣物，专为整日整夜穿着厚重长袍时防止磨蹭而设计。"
	icon_state = "priestunder"
	item_state = "priestunder"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	boobed = TRUE
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	color = "#6b5445"

/obj/item/clothing/suit/roguetown/shirt/undershirt/lord
	desc = ""
	color = "#616898"

/obj/item/clothing/suit/roguetown/shirt/undershirt/red
	color = "#851a16"

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/lordcolor(primary,secondary)
	if(secondary)
		color = secondary

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	name = "丝质衬衣"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "puritan_shirt"
	allowed_race = CLOTHED_RACES_TYPES
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "工匠套装"
	desc = "顶尖工匠与工程师们的典型穿着。"
	icon_state = "artishirt"
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	name = "低胸束腰衫"
	desc = "一件露出大半脖颈和……肩膀？！的束腰衫。真是有伤风化……"
	icon_state = "lowcut"

/obj/item/clothing/suit/roguetown/shirt/shadowshirt
	name = "丝质衬衣"
	desc = "由光泽面料编成的无袖衬衣。"
	icon_state = "shadowshirt"
	item_state = "shadowshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock
	allowed_race = NON_DWARVEN_RACE_TYPES
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/apothshirt
	name = "药剂师衬衣"
	desc = "在深秋森林中跋涉时，人总得想办法保暖。"
	icon_state = "apothshirt"
	item_state = "apothshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	name = "华丽外套"
	desc = "一套华丽的束腰衫与外套组合。真是优雅。"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "noblecoat"
	item_state = "noblecoat"
	sleevetype = "noblecoat"
	detail_tag = "_detail"
	detail_color = CLOTHING_AZURE
	color = CLOTHING_WHITE
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "工匠套装"
	desc = "顶尖工匠与工程师们的典型穿着。"
	icon_state = "artishirt"

//Royal clothing:
//................ Royal Dress (Ball Gown)............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	name = "皇家礼裙"
	desc = "一件繁复的舞会礼裙，是Enigma女王与高阶贵族偏爱的时尚。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "royaldress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/dress/royal/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/royal/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Princess Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "无瑕礼裙"
	desc = "由这片土地上最出色的裁缝为王室子嗣缝制的飘逸华美礼裙。"
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_BLUE

//................ Prince Shirt   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "镀金礼衬衫"
	desc = "专为王室子嗣量身定制、以金线刺绣的礼衬衫。"
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_MAGENTA

// End royal clothes

/obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light
	name = "冬日礼裙"
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	desc = "厚实舒适、在冬季深受贵族欢迎的礼裙。"
	body_parts_covered = COVERAGE_FULL
	icon_state = "winterdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

//Is this terrible, yes, but at this point ehhhhhhhh.
/obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "镀金礼衬衫"
	desc = "为君主右手心腹量身裁制、以金线刺绣的礼衬衫。"
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "无瑕礼裙"
	desc = "由这片土地上最出色的裁缝为君主右手心腹缝制的飘逸华美礼裙。"
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	name = "柔缎长裙"
	desc = "虽并非真正以丝绸制成，但缝制它所需的传奇技艺足以让品质比肩真丝。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "silkydress"
	item_state = "silkydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random/Initialize(mapload)
	color = pick("#e6e5e5", "#249589", "#a32121", "#428138", "#8747b1", "#007fff")
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/gown
	icon = 'icons/roguetown/clothing/shirts_gown.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_gown.dmi'
	name = "春日礼裙"
	desc = "一件精巧礼裙，恰好捕捉了万物复苏时节的神韵。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "springgown"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_gown.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_DARK_GREEN
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "夏日礼裙"
	desc = "轻盈飘逸，正适合温暖天气的礼裙。"
	icon_state = "summergown"
	boobed = TRUE
	detail_color = "#e395bb"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "秋日礼裙"
	desc = "一件庄重的长袖礼裙，象征着岁末时节的来临。"
	icon_state = "fallgown"
	boobed = TRUE
	detail_color = "#8b3f00"

/obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "冬日礼裙"
	desc = "一件温暖而优雅的礼裙，饰以柔软毛皮，专为寒冬而制。"
	icon_state = "wintergown"
	boobed = TRUE
	detail_color = "#45749d"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	icon_state = "sailorblues"

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored
	name = "striped shirt"
	icon_state = "sailorcolorable"
	item_state = "sailorcolorable"
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	boobed_detail = FALSE

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	icon_state = "sailorreds"

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_LEFT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_RIGHT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt
	name = "短衬衣"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/shortshirt/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	name = "短衬衣"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	color = "#9ac878"

/obj/item/clothing/suit/roguetown/shirt/rags
	slot_flags = ITEM_SLOT_ARMOR
	name = "破布衣"
	desc = "从破布到……不，还是破布。"
	body_parts_covered = CHEST|GROIN|VITALS
	color = "#b0b0b0"
	icon_state = "rags"
	item_state = "rags"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/tribalrag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "部族破布衣"
	desc = ""
	body_parts_covered = CHEST|VITALS
	icon_state = "tribalrag"
	item_state = "tribalrag"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	salvage_result = /obj/item/natural/hide
	salvage_amount = 1
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/robe/archivist
	name = "学者长袍"
	desc = "属于求知者的长袍。"
	icon_state = "archivist"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	color = null
	sellprice = 100

/obj/item/clothing/suit/roguetown/shirt/tunic
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "束腰衫"
	desc = "只要颜色搭得对，它既朴素又时髦。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "tunic"
	boobed = FALSE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/tunic/green
	color = CLOTHING_GREEN

/obj/item/clothing/suit/roguetown/shirt/tunic/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/tunic/red
	color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/shirt/tunic/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/tunic/white
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/tunic/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored
	color = COLOR_GRAY

/obj/item/clothing/suit/roguetown/shirt/tunic/random/Initialize(mapload)
	color = pick(CLOTHING_PURPLE, CLOTHING_RED, CLOTHING_BLUE, CLOTHING_GREEN, CLOTHING_BLACK, CLOTHING_WHITE, COLOR_GRAY)
	..()
/obj/item/clothing/suit/roguetown/shirt/dress
	slot_flags = ITEM_SLOT_ARMOR
	name = "连衣裙"
	desc = "一件简洁的连衣裙，适合女性与胆大之人。"
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dress"
	item_state = "dress"
	allowed_sex = list(MALE, FEMALE)
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/dress/gen
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "丝质内裙"
	desc = "舒适而优雅，兼具风格与日常穿着的舒适性。"
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dressgen"
	item_state = "dressgen"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "丝质长裙"
	desc = "以柔滑面料制成的优雅裙装，适合正式场合与体面出行。"
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "silkdress"
	item_state = "silkdress"
	color = "#e6e5e5"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/green
	color = CLOTHING_DARK_GREEN

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", "#52BE80", "#C39BD3", "#EC7063","#5DADE2")

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "轻透短裙"
	desc = "一件短得有些伤风败俗的裙装，以极细纤维制成，呈现半透明效果。"
	body_parts_covered = null
	icon_state = "sexydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random/Initialize(mapload)
	. = ..()
	color = pick(CLOTHING_WHITE, CLOTHING_RED, CLOTHING_PURPLE, CLOTHING_MAGENTA, CLOTHING_TEAL, CLOTHING_BLACK)

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/black/Initialize(mapload)
	. = ..()
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/slit
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "开衩长裙"
	desc = "一件裁缝精良、侧边开衩露出大腿的裙装，真是太伤风败俗了！"
	icon_state = "slitdress"
	item_state = "slitdress"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/webs
	name = "蛛丝上衣"
	desc = "异域丝线精细织成了……这玩意？简直像是把蜘蛛网披在身上。"
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS
	color = null
	color = null
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/jester
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "弄臣戏衣"
	desc = "无论是说笑话、耍闹剧，还是把贵族摔倒在地，这件戏衣都扛得住。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "jestershirt"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = FALSE // for some reason when boobed, the game likes to get rid of the detail and altdetail. I went ahead and just merged it into the main icon.
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE
	altdetail_color = CLOTHING_WHITE


/obj/item/clothing/suit/roguetown/shirt/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/jester/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	color = null
	name = "华饰丝裙"
	desc = "以最上等、最柔软丝绸织成的裙装。深沉的王室绯红间缀以金线，彰显穿戴者的奢华财富。"
	icon_state = "stewarddress"
	item_state = "stewarddress"

/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	name = "华饰丝质束腰衫"
	desc = "用上等丝绸与最柔软布料制成的飘逸束腰衫。金线嵌饰其间，是最富有者所追逐的时尚顶点。"
	icon_state = "stewardtunic"
	item_state = "stewardtunic"

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	color = null
	name = "传令官衣装"
	desc = "一件会替你大声发言的长袍！"
	icon_state = "loudmouthrobe"
	item_state = "loudmouthrobe"

//WEDDING CLOTHES
/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress
	name = "婚礼丝裙"
	desc = "以精细丝绸织成并嵌有金线的裙装，只为那个特别的日子而制。"
	icon_state = "weddingdress"
	item_state = "weddingdress"

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	name = "异域丝绸胸衣"
	desc = "以最上等丝绸制成并饰有金环的精致胸衣，几乎不给想象留下多少空间。"
	icon_state = "exoticsilkbra"
	item_state = "exoticsilkbra"
	body_parts_covered = CHEST
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	dropshrink = null

//................ Noble Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/noble
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "贵族礼裙"
	desc = "一件适合贵族穿着的优雅礼裙，以最上等的材料制成并饰有繁复细节。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "nobledress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'


/obj/item/clothing/suit/roguetown/shirt/dress/noble/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/noble/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/dress/noble/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/noble/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Velvet Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/velvet
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "天鹅绒礼裙"
	desc = "以最上等天鹅绒制成的奢华礼裙，触感柔软，外观华贵。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "velvetdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	dropshrink = 0.9

//Servant Clothing:
//................ Maid Dress   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/maid
	name = "女仆裙装"
	desc = "适合领主宅邸女管事穿着的裙装。虽不如王室服饰那般繁复，却足以体现家门地位。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	icon_state = "maiddress"
	item_state = "maiddress"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK

//................ Servant Gown   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/maid/servant
	name = "侍从长裙"
	desc = "庄园仆役与贵族侍从所穿的裙装。通常为黑色，不过有些宅邸会染成自家的家族色。"
	icon_state = "maidgown"
	item_state = "maidgown"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	detail_color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	name = "礼衬衫"
	desc = "舒适而实用的礼衬衫，常见于贵族宅邸的仆役穿着。"
	icon_state = "butlershirt"
	item_state = "butlershirt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
//End Servant Clothing

//kazengite content
/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "黑色异域衬衣"
	desc = "地痞恶徒常穿的一种衬衣。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt1"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "白色异域衬衣"
	desc = "外来帮派常穿的一种衬衣。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt2"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

//tattoo code
/obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
	name = "Bouhoi Bujeog纹身"
	desc = "Ruma氏族沿用的一种神秘纹身，仿效了Xinyi王朝武僧的古老做法。它既是识别同族成员的标记，也是同伴情谊与隐秘兄弟会的象征。纹样呈云形，由神秘墨汁绘成，墨色会像池水波纹般流动，并在你的皮肤受击处瞬间硬化。它的蠕动会让你不寒而栗。"
	resistance_flags = FIRE_PROOF
	icon_state = "easttats"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_race = NON_DWARVEN_RACE_TYPES
	max_integrity = 300 //Bad armor protection and very basic crit protection, but hard to break completely
	flags_inv = null //free the breast
	surgery_cover = FALSE // cauterize and surgery through it.
	var/repair_amount = 20 //The amount of integrity the tattoos will repair themselves
	var/repair_time = 60 SECONDS //The amount of time between each repair
	var/last_repair //last time the tattoos got repaired

/obj/item/clothing/suit/roguetown/shirt/undershirt/easttats/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/shirt/easttats/easttats/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/suit/roguetown/shirt/undershirt/easttats/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity < max_integrity)
		START_PROCESSING(SSobj, src)
		return

/obj/item/clothing/suit/roguetown/shirt/undershirt/easttats/process()
	if(obj_integrity >= max_integrity)
		STOP_PROCESSING(SSobj, src)
		src.visible_message(span_notice("[src]流动得更平缓了，它们已经休息完毕并恢复了力量。"), vision_distance = 1)
		return
	else if(world.time > src.last_repair + src.repair_time)
		src.last_repair = world.time
		obj_integrity = min(obj_integrity + src.repair_amount, src.max_integrity)
	..()
