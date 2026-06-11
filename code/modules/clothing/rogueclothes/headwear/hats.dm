// Hats not meant to have armor
/obj/item/clothing/head/roguetown/strawhat
	name = "草编帽子"
	desc = "它粗糙又朴实，但至少能在你田间劳作时替你挡住头顶的太阳。"
	icon_state = "strawhat"
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2 // Minor materials loss
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/puritan
	name = "扣饰帽子"
	icon_state = "puritan_hat"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/puritan/armored
	name = "清修者帽子" 
	desc = "一顶带扣高筒帽，织在钢制护顶盔之上。它低调得足以出席外交场合，却也结实得足以挡下异教徒的刀刃。"
	icon_state = "puritan_hat"
	sewrepair = FALSE
	armor = ARMOR_PLATE
	blocksound = PLATEHIT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	body_parts_covered = HEAD|HAIR
	max_integrity = ARMOR_INT_HELMET_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	nudist_approved = FALSE // armored
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/nightman
	name = "说书人帽子"
	icon_state = "tophat"
	color = CLOTHING_BLACK
	nudist_approved = TRUE
	dropshrink = null

/obj/item/clothing/head/roguetown/bardhat
	name = "吟游诗人的帽子"
	icon_state = "bardhat"
	nudist_approved = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/smokingcap
	name = "便帽帽"
	icon_state = "smokingc"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/fancyhat
	name = "华丽帽子"
	desc = "一顶外观华丽的帽子，上面插着五彩羽毛。"
	icon_state = "fancy_hat"
	item_state = "fancyhat"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/fedora
	name = "考古学家的帽子"
	desc = "一顶造型古怪的帽子，陈旧的皮革上蒙着尘土。"
	icon_state = "curator"
	item_state = "curator"
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/head/roguetown/hatfur
	name = "毛皮帽子"
	desc = "一顶衬有毛皮、舒适暖和的帽子。"
	icon_state = "hatfur"
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/papakha
	name = "帕帕哈帽"
	icon_state = "papakha"
	item_state = "papakha"
	armor = ARMOR_CLOTHING
	blocksound = SOFTHIT
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/loadoutpapakha
	name = "Soft-sided papakha"
	icon_state = "papakha"
	item_state = "papakha"
	resistance_flags = FIRE_PROOF //doesnt spawn, only a cosmetic loadout item. Keep the swag.
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/hatblu
	name = "毛皮帽子"
	desc = "一顶衬有毛皮的蓝色帽子。"
	icon_state = "hatblu"
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/fisherhat
	name = "草编帽子"
	desc = "渔夫为了遮阳而佩戴的一顶帽子。"
	icon_state = "fisherhat"
	item_state = "fisherhat"
	nudist_approved = TRUE
//	color = "#fbc588"
	//dropshrink = 0.75
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/flathat
	name = "平顶帽"
	icon_state = "flathat"
	item_state = "flathat"
	nudist_approved = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
	dropshrink = null

/obj/item/clothing/head/roguetown/chaperon
	name = "头巾帽"
	desc = "一种由兜帽传统演变而来的实用又时髦的帽子，通常作为身份象征佩戴。"
	icon_state = "chaperon"
	item_state = "chaperon"
	nudist_approved = TRUE
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/chaperon/brown
	color = CLOTHING_BROWN

/obj/item/clothing/head/roguetown/cookhat
	name = "厨师帽子"
	desc = "一顶表明佩戴者精通烹饪之道的帽子。"
	icon_state = "chef"
	item_state = "chef"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/chaperon/greyscale
	name = "头巾帽"
	desc = "一种由兜帽传统演变而来的实用又时髦的帽子。这顶经过处理，更容易上染。"
	icon_state = "chap_alt"
	item_state = "chap_alt"
	color = "#dbcde0"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/chaperon/noble
	name = "贵族头巾帽"
	desc = "一顶装饰华美的头巾帽，通常由社会中更有影响力的人士佩戴。"
	icon_state = "noblechaperon"
	item_state = "noblechaperon"
	detail_tag = "_detail"
	nudist_approved = TRUE
	color = CLOTHING_WHITE
	detail_color = COLOR_ASSEMBLY_GOLD

/obj/item/clothing/head/roguetown/chaperon/noble/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/chaperon/noble/bailiff
	name = "治安官头巾帽"
	desc = "一顶为本地治安官打造的贵族头巾帽。\"你可真是不走运啊！\""
	color = "#641E16"
	detail_color = "#b68e37ff"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER // spellsinger hat stats. Drip or drown.
	nudist_approved = FALSE // armored

/obj/item/clothing/head/roguetown/chaperon/noble/guildmaster
	name = "公会长头巾帽"
	desc = "一顶为公会长打造的贵族头巾帽。"
	color = "#1b1717ff"
	detail_color = "#b68e37ff"

/obj/item/clothing/head/roguetown/chaperon/noble/hand
	name = "副手头巾帽"
	desc = "一顶为掌权者副手打造的贵族头巾帽。\"欲戴王冠，必承其重。\""
	color = CLOTHING_AZURE
	detail_color = CLOTHING_WHITE

/obj/item/clothing/head/roguetown/chaperon/councillor
	name = "头巾帽"
	desc = "一顶贵族佩戴的华美帽子。"
	icon_state = "chap_alt"
	item_state = "chap_alt"
	color = "#7dcea0"

/obj/item/clothing/head/roguetown/chaperon/greyscale/elder
	name = "长老头巾帽"
	color = "#007fff"

/obj/item/clothing/head/roguetown/chef
	name = "主厨帽子"
	desc = "一顶表明佩戴者精通烹饪之道的帽子。"
	icon_state = "chef"
	nudist_approved = TRUE
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/armingcap
	name = "皮帽"
	desc = "一顶由皮革制成的轻便帽，通常戴在头盔下面。"
	icon_state = "armingcap"
	item_state = "armingcap"
	flags_inv = HIDEEARS
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/hide/cured
	//dropshrink = 0.75
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	dropshrink = null

/obj/item/clothing/head/roguetown/knitcap
	name = "针织帽"
	desc = "一顶简单的针织帽。"
	icon_state = "knitcap"
	nudist_approved = TRUE
	//dropshrink = 0.75
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/armingcap/dwarf
	color = "#cb3434"

/obj/item/clothing/head/roguetown/headband
	name = "头带"
	desc = "一条简单的头带，用来防止汗水流进眼睛里。"
	icon_state = "headband"
	item_state = "headband"
	//dropshrink = 0.75
	dynamic_hair_suffix = null
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/headband/bloodied
	name = "染血头带"
	desc = "一条浸透可怖夜兽之血的头带。诅咒之血的凝结特性让布料硬化，质感近似柔韧皮革。佩戴它会让你心中涌起决绝的勇气。"
	icon_state = "headband"
	item_state = "headband"
	color = "#851a16"
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_HELMET_LEATHER
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_TWIST) //Themed to protect against deadites and nitebeasts. Doesn't stop blunt-, smash-, or stabbing crits.
	//dropshrink = 0.75
	dynamic_hair_suffix = null

	///Reen's work. Should make it so that you obtain special traits when taking it on-and-off, without outright removing inherent traits.
	var/traited = FALSE

/obj/item/clothing/head/roguetown/headband/bloodied/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/headband/bloodied/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.head == src)
		REMOVE_TRAIT(user, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/headband/monk
	name = "修士头带"
	desc = "一条盘绕缠裹的布带，细致嵌着厚皮条。零碎打击会被挡开，视野却丝毫不受影响；这正适合修士，他们要用紧握的布道让恶徒顿悟。 </br>'..我为主而狠狠干架！'"
	icon_state = "headband"
	color = "#bfb8a9"
	resistance_flags = FIRE_PROOF
	armor = ARMOR_SPELLSINGER //Highest preset protection value for head armor, without leaving people unable to sleep with the headband on. Should be appropriate for the Monk's role.
	body_parts_covered = HEAD|HAIR|EARS
	max_integrity = ARMOR_INT_SIDE_STEEL //High leather-tier protection and critical resistances, steel-tier integrity.
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	nudist_approved = FALSE // armored
	//dropshrink = 0.75
	dynamic_hair_suffix = null

/obj/item/clothing/head/roguetown/headband/monk/barbarian
	name = "猎手头带"
	desc = "一条盘绕缠裹的布带，细致嵌着厚皮条。零碎打击会被挡开，视野却丝毫不受影响；这正适合那些以蛮力直面怪物的人。 </br>'..邪恶得逞，只因善人无所作为。'"
	max_integrity = ARMOR_INT_HELMET_LEATHER //Far less durable than the Monk's variant. Remember that the Barbarian retrieves solid weapon skills and armor, even as a pugilist.

/obj/item/clothing/head/roguetown/inqhat
	name = "审判官帽子"
	desc = "一顶上等皮革软帽，插着绯红羽毛，内里还嵌有隐藏的钢制护顶帽。它提醒着人们，神圣奥塔瓦宗审庭在某一方面凌驾众人之上: 时尚。 </br>'让目光远离苍穹，只专注于泥土之下的罪恶。'"
	icon_state = "inqhat"
	item_state = "inqhat"
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	armor = ARMOR_SPELLSINGER
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
	resistance_flags = FIRE_PROOF // drip is eternal

/obj/item/clothing/head/roguetown/headband/red
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/maidband
	name = "女仆头带"
	desc = "一条带褶的布质头带。它因贵族出行时常带着仆从而广受欢迎。"
	icon = 'icons/roguetown/clothing/head.dmi'
	icon_state = "maidband"
	item_state = "maidband"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = NONE
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/priesthat
	name = "祭司帽子"
	desc = ""
	icon_state = "priest"
	//dropshrink = 0
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	dynamic_hair_suffix = "+generic"
	sellprice = 77
	worn_x_dimension = 64
	worn_y_dimension = 64
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/reqhat
	name = "蛇王冠"
	desc = ""
	icon_state = "reqhat"
	sellprice = 100
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/head/roguetown/headdress
	name = "涅墨斯头饰"
	desc = "一顶异域丝质头饰。"
	icon_state = "headdress"
	sellprice = 10
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/headdress/alt
	icon_state = "headdressalt"

/obj/item/clothing/head/roguetown/nun
	name = "修女面纱"
	desc = "一顶献给虔信者的朴素帽饰。"
	icon_state = "nun"
	sellprice = 5
	nudist_approved = TRUE
	dropshrink = null

/obj/item/clothing/head/roguetown/hennin
	name = "亨宁高帽"
	desc = "贵族女性常戴的一种帽子。"
	icon_state = "hennin"
	sellprice = 19
	dynamic_hair_suffix = "+generic"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/bucklehat //lifeweb sprite
	name = "折边帽子"
	desc = "一顶朴素的皮帽，饰有装饰性搭扣。它因伊特鲁斯卡的不法之徒而流行起来。"
	icon_state = "bucklehat"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/duelhat //lifeweb sprite
	name = "决斗者帽子"
	desc = "一顶插羽的皮帽，好让所有人都看出你的高人一等。"
	icon_state = "duelhat"
	color = COLOR_ALMOST_BLACK
	detail_tag = "_detail"
	detail_color = COLOR_SILVER
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/duelisthat
	name = "决斗者帽子"
	desc = "一顶插羽的皮帽，好让所有人都看出你的高人一等。"
	icon_state = "duelisthat"
	detail_tag = "_detail"
	detail_color = COLOR_SILVER
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/wizhat
	name = "法师帽子"
	desc = "用来区分危险法师和痴呆老头的帽子。"
	icon_state = "wizardhat"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	dynamic_hair_suffix = "+generic"
	worn_x_dimension = 64
	worn_y_dimension = 64
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/wizhat/red
	icon_state = "wizardhatred"

/obj/item/clothing/head/roguetown/wizhat/yellow
	icon_state = "wizardhatyellow"

/obj/item/clothing/head/roguetown/wizhat/green
	icon_state = "wizardhatgreen"

/obj/item/clothing/head/roguetown/wizhat/black
	icon_state = "wizardhatblack"

/obj/item/clothing/head/roguetown/wizhat/gen
	icon_state = "wizardhatgen"

/obj/item/clothing/head/roguetown/wizhat/gen/wise
	name = "智者帽子"
	sellprice = 100
	desc = "只有最有智慧的笨蛋才会戴这个。"

/obj/item/clothing/head/roguetown/wizhat/gen/wise/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/wise = user
	if(slot == SLOT_HEAD)
		wise.change_stat(STATKEY_INT, 2, "wisehat")
		to_chat(wise, span_green("我获得了智慧。"))

/obj/item/clothing/head/roguetown/wizhat/gen/wise/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wise = user
	if(wise.get_item_by_slot(SLOT_HEAD) == src)
		wise.change_stat(STATKEY_INT, -2, "wisehat")
		to_chat(wise, span_red("我失去了智慧。"))

/obj/item/clothing/head/roguetown/shawl
	name = "披巾"
	desc = "能把头发收拾利落，也显得很得体。"
	icon_state = "shawl"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/articap
	name = "工匠帽"
	desc = "一顶运动风便帽，饰有一个小齿轮。很受工程师欢迎。"
	icon_state = "articap"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/brimmed
	desc = "一顶简单的宽檐帽，能稍微缓解烈日曝晒。"
	icon_state = "brimmed"
	nudist_approved = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
// azure addition - random wizard hats

/obj/item/clothing/head/roguetown/wizhat/random/Initialize(mapload)
	icon_state = pick("wizardhatred", "wizardhatyellow", "wizardhatgreen", "wizardhat")
	..()

/obj/item/clothing/head/roguetown/witchhat
	name = "女巫帽子"
	desc = ""
	icon_state = "witch"
	item_state = "witch"
	detail_tag = "_detail"
	icon = 'icons/roguetown/clothing/head.dmi'
	nudist_approved = TRUE
	color = CLOTHING_BLACK
	detail_color = CLOTHING_BROWN

/obj/item/clothing/head/roguetown/witchhat/old
	name = "破旧女巫帽子"
	desc = "我们三人何时再会；在雷鸣、电闪，还是雨中。"
	icon_state = "witchold"
	item_state = "witchold"
	color = CLOTHING_WHITE

/obj/item/clothing/head/roguetown/archercap
	name = "弓手帽"
	desc = "献给那些快活的绿林好汉。"
	icon_state = "archercap"
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/physician
	name = "医生帽子"
	desc = "我的疗法最为有效。"
	icon_state = "physhat"
	nudist_approved = TRUE


/obj/item/clothing/head/roguetown/helmet/tricorn
	slot_flags = ITEM_SLOT_HEAD
	name = "三角帽"
	desc = ""
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "tricorn"
	armor = ARMOR_CLOTHING
	max_integrity = 100
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST)
	anvilrepair = null
	smeltresult = null
	blocksound = SOFTHIT
	nudist_approved = TRUE // this gets an exception for being ARMOR_CLOTHING but why does it prevent crits???
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/helmet/tricorn/skull
	icon_state = "tricorn_skull"
	desc = "上面缝着一颗骷髅头，这是海盗的明显标志。"

/obj/item/clothing/head/roguetown/helmet/tricorn/lucky
	name = "幸运三角帽"
	desc = "一顶饱经风霜的三角帽，经历过无数次冲突。把它戴在头上，你会觉得自己走运起来。"
	armor = ARMOR_LEATHER

/obj/item/clothing/head/roguetown/helmet/bandana
	slot_flags = ITEM_SLOT_HEAD
	name = "头巾"
	desc = ""
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "bandana"
	armor = ARMOR_CLOTHING
	prevent_crits = list(BCLASS_TWIST)
	anvilrepair = null
	smeltresult = null
	blocksound = SOFTHIT
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/head/roguetown/veiled
	name = "护士面纱"
	desc = "一顶医师便帽，蒙着塞有花瓣的亚麻面纱。这种针线活常见于游方瘟疫医生与教士，尤其是那些侍奉佩丝特拉与赛顿的人。"
	icon_state = "veil"
	item_state = "veil"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT|HIDEEARS
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|HAIR|EARS|NECK|MOUTH|NOSE|EYES
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = SOFTHIT
	max_integrity = 100
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/veiled/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/veiled/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, (NECK|HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/foley/equip/cloak (3).ogg', null, (UPD_HEAD|UPD_MASK))

/obj/item/clothing/head/roguetown/veiled/loudmouth
	name = "大嗓门头罩"
	desc = "据说只有最吵闹、最招摇的人才会戴。面罩可调节。"
	icon_state = "loudmouth"
	item_state = "loudmouth"
	color = CLOTHING_RED
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/scarf
	name = "围巾"
	desc = "一条简单的围巾，设计成披在肩上穿戴。"
	item_state = "hijab_t"
	icon_state = "deserthood_t"
	color = "#b8252c"
	flags_inv = null
	sleevetype = null
	sleeved = null
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	alternate_worn_layer  = 8.9 //On top of helmet
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 0, "acid" = 0)
	dynamic_hair_suffix = ""
	edelay_type = 1
	blocksound = SOFTHIT
	max_integrity = 100
	muteinmouth = FALSE
	spitoutmouth = FALSE
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/scarf/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我把\the [src][overarmor ? "戴在头发里面" : "戴在头发外面"]。"))
	if(overarmor)
		alternate_worn_layer = HOOD_LAYER //Below Hair Layer
	else
		alternate_worn_layer = BACK_LAYER //Above Hair Layer
	user.update_inv_wear_mask()
	user.update_inv_head()

// The exact same as the Grenzelhoft hat w/ the cap, but capless; no armor stats. Allows for drip with the helmet aesthetic PR
/obj/item/clothing/head/roguetown/caplessgrenzelhofthat
	name = "无内帽格伦泽尔霍夫羽饰帽"
	desc = "无论怪物还是佳人，真正的格伦泽尔霍夫人都能一并征服。只是这顶下面没有任何防护。"
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	icon = 'icons/roguetown/clothing/head.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	slot_flags = ITEM_SLOT_HEAD
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = ""
	resistance_flags = FIRE_PROOF //doesnt spawn, only a cosmetic loadout item. Keep the swag.
	color = "#262927"
	detail_color = "#FFFFFF"
	altdetail_color = "#9c2525"


