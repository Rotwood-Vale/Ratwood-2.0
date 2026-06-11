/obj/item/clothing/suit/roguetown/armor/leather
	name = "皮甲"
	desc = "柔韧牛皮甲。轻便，总比没有强。"
	icon_state = "roguearmor"
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT,BCLASS_BLUNT)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	sellprice = 20
	armor_class = ARMOR_CLASS_LIGHT
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket
	name = "冬季夹克"
	desc = "将最优雅的毛皮与最鲜艳的皇家染料结合而成的华美夹克。"
	icon_state = "winterjacket"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_BLACK
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/armor/gambeson/tailcoat
	name = "燕尾服"
	desc = "精细缝制的燕尾服，常由接近阿斯特拉坦上层阶级的人士穿着。"
	icon = 'icons/roguetown/clothing/armor.dmi'
	icon_state = "butlercoat"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	item_state = "butlercoat"
	detail_tag = "_detail"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	detail_color = CLOTHING_BLACK
	slot_flags = ITEM_SLOT_ARMOR
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	name = "工匠夹克"
	icon_state = "artijacket"
	desc = "厚实皮夹克，饰有毛皮与齿轮纹样。Heartfelt 时尚的巅峰。"
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/cuirass
	name = "皮胸甲"
	desc = "由皮革制成的胸甲。"
	icon_state = "leather"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/suit/roguetown/armor/leather/hide
	name = "兽皮甲"
	desc = "由野兽皮制成的轻甲。比普通皮甲耐用得多。"
	icon_state = "hidearmor"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	cold_protection = CHEST
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	name = "林地守卫甲"
	desc = "套在锁子甲外、带有大肩甲的硬化皮革挽具，是林地守卫的标志。"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "forestleather"
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	name = "林地守卫布里甘丁甲"
	desc = "套在带垂片布里甘丁甲外、带有大肩甲的硬化皮革挽具，灌注了登多尔的精华。"
	icon_state = "forestbrig"
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50
	equip_delay_self = 4 SECONDS
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/leather/studded
	name = "铆钉皮甲"
	desc = "铆钉皮革是所有兽皮与皮革中最耐用的一种，同时也同样轻便。"
	icon_state = "studleather"
	item_state = "studleather"
	blocksound = SOFTHIT
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	nodismemsleeves = TRUE
	body_parts_covered = COVERAGE_TORSO
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	smeltresult = /obj/item/ingot/iron
	sellprice = 25
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	name = "煮革甲"
	desc = "经处理、水煮并以复合层压工艺制成的优质奥塔凡皮甲。"
	icon_state = "cuirbouilli"
	item_state = "cuirbouilli"

/obj/item/clothing/suit/roguetown/armor/leather/heavy
	name = "硬化皮甲"
	desc = "厚重的公牛皮短上衣，硬挺得几乎能自行站立。它形成一道坚实而护身的披甲 \
	为穿戴者抵挡打击与风霜。"
	icon_state = "roguearmor_belt"
	item_state = "roguearmor_belt"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 20
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	name = "硬化皮大衣"
	desc = "厚重的公牛皮短上衣，下摆过胯，能更好地保护要害。"
	icon_state = "roguearmor_coat"
	item_state = "roguearmor_coat"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
	name = "忏悔官大衣"
	desc = "坚固的雨披外套罩在紧束的煮制皮胸甲之上。圣阿斯特拉坦的年轻人常会缝些纪念小物在大衣内袋里，提醒忏悔官们他们的事业是正直的，不可忘却真正重要之物。"
	icon_state = "confessorcoat"
	item_state = "confessorcoat"
	body_parts_covered = COVERAGE_FULL
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	name = "巨颚兽鳞甲大衣"
	desc = "以拜班廷“巨颚兽”的鳞片制成的轻型护甲。那是一种披甲爬行生物，会在河岸伏击猎物并将其拖入深渊主的领地。"
	icon_state = "pangolin"
	item_state = "pangolin"
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	name = "毛织哈坦嘎大衣"
	desc = "精细织成的哈坦嘎大衣，以上好毛皮与强化衬垫取代了大量鳞甲，更适合轻骑穿用。"
	icon_state = "hatangafur"
	item_state = "hatangafur"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	name = "硬化皮夹克"
	desc = "厚重的皮夹克，可覆盖双臂并保护要害。"
	icon_state = "leatherjacketo"
	item_state = "leatherjacketo"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	cold_protection = CHEST | ARM_LEFT | ARM_RIGHT
	sellprice = 25

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	name = "击剑夹克"
	desc = "轻便灵活、可系扣的皮夹克，能让你的要害远离伤害。"
	icon_state = "freijacket"
	item_state = "freijacket"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	detail_tag = "_detail"
	color = "#5E4440"
	detail_color = "#c08955"
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter/Initialize(mapload)
	..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/leather/trophyfur
	name = "鞣制战利品毛皮袍"
	desc = "厚重的硬化长袍，内衬毛皮。其皮革取自数种极难以箭矢放倒的生物，是许多游侠身份的证明。"
	icon_state = "hatanga"
	item_state = "hatanga"
	armor = list("blunt" = 90, "slash" = 30, "stab" = 40, "piercing" = 60, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_STAB, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK, BCLASS_TWIST)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 100
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/bikini
	name = "皮胸衣"
	desc = "柔韧牛皮甲。轻便，总比没有强。剪裁后专门保护心口与髋部。"
	body_parts_covered = CHEST|GROIN
	icon_state = "leatherkini"
	item_state = "leatherkini"
	allowed_sex = list(FEMALE, MALE)
	allowed_race = CLOTHED_RACES_TYPES
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT

/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
	name = "铆钉皮胸衣"
	desc = "铆钉皮革是所有兽皮与皮革中最耐用的一种，同时也同样轻便。剪裁后专门保护心口与髋部。"
	body_parts_covered = CHEST|GROIN
	icon_state = "studleatherkini"
	item_state = "studleatherkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES

/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	name = "兽皮胸衣"
	desc = "由野兽皮制成的轻甲，比普通皮甲耐用得多。剪裁后专门保护心口与髋部。"
	body_parts_covered = CHEST|GROIN
	icon_state = "hidearmorkini"
	item_state = "hidearmorkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT

/obj/item/clothing/suit/roguetown/armor/leather/vest
	name = "皮背心"
	desc = "一件皮背心。防护性不强，但很时髦。"
	icon_state = "vest"
	item_state = "vest"
	color = "#514339"
	armor = ARMOR_LEATHER_BAD
	prevent_crits = list(BCLASS_CUT)
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = COVERAGE_TORSO
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sleevetype = null
	sleeved = null
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	name = "水手夹克"
	desc = "水手装束。"
	icon_state = "sailorvest"
	color = null
	slot_flags = ITEM_SLOT_ARMOR
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "shirt"

/obj/item/clothing/suit/roguetown/armor/leather/vest/white
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
	name = "丝绸夹克"
	desc = "柔软舒适的夹克。"
	icon_state = "nightman"
	sleeved = 'icons/roguetown/clothing/onmob/armor.dmi'
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	name = "执政官背心"
	desc = "以上等面料制成的柔软背心。"
	icon_state = "handcoat"
	color = null
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	name = "皮大衣"
	desc = "瓦洛里亚决斗者所穿的时髦大衣。轻便灵活，不会妨碍他们著称的复杂动作，而且衬垫充足。"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "bwleathercoat"
	item_state = "bwleathercoat"
	boobed = TRUE

	slot_flags = ITEM_SLOT_ARMOR
	armor = ARMOR_LEATHER_GOOD
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	prevent_crits = list(BCLASS_CUT, BCLASS_TWIST, BCLASS_STAB)

	detail_tag = "_detail"
	detail_color = "#FFFFFF"

/obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/
	icon = 'icons/roguetown/clothing/licensed-infraredbaron/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/licensed-infraredbaron/onmob/armor.dmi'
	sleevetype = null
	sleeved = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sellprice = 50

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/duchess
	name = "公爵夫人礼裙"
	desc = ""
	icon_state = "duchess"
	item_state = "duchess"
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|VITALS

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/duke
	name = "公爵制服"
	desc = ""
	icon_state = "duke"
	item_state = "duke"
	body_parts_covered = CHEST|VITALS|ARMS

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/hand
	name = "执政官夹克"
	desc = "以精良而耐磨的布料制成的厚重大衣，并经过加固。毕竟世事难料。"
	icon_state = "hand"
	item_state = "hand"
	armor = ARMOR_LEATHER_STUDDED
	body_parts_covered = COVERAGE_ALL_BUT_LEGS

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/heir
	name = "继承人制服"
	desc = ""
	icon_state = "heir"
	item_state = "heir"
	body_parts_covered = BELOW_HEAD

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/heiress
	name = "女继承人制服"
	desc = ""
	icon_state = "heiress"
	item_state = "heiress"
	body_parts_covered = BELOW_HEAD

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/councillor
	name = "议政官制服"
	desc = ""
	icon_state = "councillor"
	item_state = "councillor"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/magos
	name = "魔导师长袍"
	desc = ""
	icon_state = "magos"
	item_state = "magos"
	slot_flags = ITEM_SLOT_ARMOR
	body_parts_covered = COVERAGE_ALL_BUT_LEGS

/obj/item/clothing/suit/roguetown/armor/leather/newkeep/steward
	name = "管家背心"
	desc = "利落而现代的装束，以真金刺绣。"
	icon_state = "steward"
	item_state = "steward"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor = ARMOR_PADDED_BAD
	
/obj/item/clothing/head/roguetown/duchess_hood
	name = "公爵夫人兜帽"
	icon = 'icons/roguetown/clothing/licensed-infraredbaron/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/licensed-infraredbaron/onmob/head.dmi'
	icon_state = "duchess_hood"
	item_state = "duchess_hood"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	armor = ARMOR_PADDED_BAD

/obj/item/clothing/suit/roguetown/armor/gambeson/fur
	name = "毛皮内甲"
	desc = "厚重的硬化长袍，内衬毛皮。其皮革取自数种极难以箭矢放倒的生物，是许多游侠身份的证明。"
	icon_state = "hatanga"
	item_state = "hatanga"
