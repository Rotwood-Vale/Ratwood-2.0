/obj/item/clothing/shoes/roguetown
	name = "鞋子"
	icon = 'icons/roguetown/clothing/feet.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/feet.dmi'
	desc = ""
	gender = PLURAL
	slot_flags = ITEM_SLOT_SHOES
	body_parts_covered = FEET
	body_parts_inherent = FEET
	bloody_icon_state = "shoeblood"
	equip_delay_self = 30
	resistance_flags = FIRE_PROOF
	experimental_inhand = FALSE
	salvage_amount = 0
	salvage_result = null
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/boots
	name = "深色长靴"
	//dropshrink = 0.75
	color = "#d5c2aa"
	desc = ""
	gender = PLURAL
	icon_state = "blackboots"
	item_state = "blackboots"
	max_integrity = ARMOR_INT_SIDE_LEATHER
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	armor = ARMOR_CLOTHING
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	var/atom/movable/holdingknife = null
	var/atom/movable/holdinglockpick = null

/obj/item/clothing/shoes/roguetown/boots/examine()
	. = ..()
	. += span_smallnotice("匕首和撬锁器可以藏在里面。")

/obj/item/clothing/shoes/roguetown/boots/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/rogueweapon/huntingknife))
		if(holdingknife == null)
			for(var/obj/item/clothing/shoes/roguetown/boots/B in user.get_equipped_items(TRUE))
				to_chat(loc, span_warning("我迅速把[W]塞进[B]！"))
				user.transferItemToLoc(W, holdingknife)
				holdingknife = W
				playsound(loc, 'sound/foley/equip/swordsmall1.ogg')
		else
			to_chat(loc, span_warning("我的靴子里已经藏着一把刀了。"))

	if(istype(W, /obj/item/lockpick))
		if(holdinglockpick == null)
			for(var/obj/item/clothing/shoes/roguetown/boots/B in user.get_equipped_items(TRUE))
				to_chat(loc, span_warning("我迅速把[W]塞进[B]！"))
				user.transferItemToLoc(W, holdinglockpick)
				holdinglockpick = W
				playsound(loc, 'sound/foley/equip/rummaging-01.ogg')
		else
			to_chat(loc, span_warning("我的靴子里已经藏着一根撬锁器了。"))

		return
	. = ..()

/obj/item/clothing/shoes/roguetown/boots/attack_right(mob/user)
	if(holdingknife != null)
		user.visible_message(span_warning("[user]正从[src]里抽出什么！"), span_warning("我开始从[src]里抽出一把刀！"))
		if(do_after(user, 2 SECONDS))
			if(!user.get_active_held_item())
				user.put_in_active_hand(holdingknife, user.active_hand_index)
				holdingknife = null
				playsound(loc, 'sound/foley/equip/swordsmall1.ogg')
				return TRUE

/obj/item/clothing/shoes/roguetown/boots/MiddleClick(mob/user)
	if(holdinglockpick != null)
		user.visible_message(span_warning("[user]正从[src]里抽出什么！"), span_warning("我开始从[src]里抽出一根撬锁器！"))
		if(do_after(user, 2 SECONDS))
			if(!user.get_active_held_item())
				user.put_in_active_hand(holdinglockpick, user.active_hand_index)
				holdinglockpick = null
				playsound(loc, 'sound/foley/equip/rummaging-01.ogg')
				return TRUE

/obj/item/clothing/shoes/roguetown/boots/psydonboots
	name = "Psydon皮靴"
	desc = "黑钢跟皮靴。无论你在这片土地上行军多远，皮革都几乎不会磨损。"
	icon_state = "psydonboots"
	item_state = "psydonboots"
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)	//On par with Heavy Leather Boots.
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/nobleboot
	name = "贵族长靴"
	//dropshrink = 0.75
	color = "#d5c2aa"
	desc = "精致的深色皮靴。"
	gender = PLURAL
	icon_state = "nobleboots"
	item_state = "nobleboots"
	armor = ARMOR_CLOTHING
	salvage_amount = 2
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	name = "阿夫尼骑靴"
	desc = "一双结实的骑靴，配有铁跟和黄铜马刺。"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER

/obj/item/clothing/shoes/roguetown/shortboots
	name = "短靴"
	color = "#d5c2aa"
	desc = ""
	gender = PLURAL
	icon_state = "shortboots"
	item_state = "shortboots"
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/ridingboots
	name = "骑靴"
	color = "#d5c2aa"
	desc = ""
	gender = PLURAL
	icon_state = "ridingboots"
	item_state = "ridingboots"
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

///obj/item/clothing/shoes/roguetown/ridingboots/Initialize()
//	. = ..()
//	AddComponent(/datum/component/squeak, list('sound/foley/spurs (1).ogg'sound/blank.ogg'=1), 50)

/obj/item/clothing/shoes/roguetown/simpleshoes
	name = "鞋子"
	desc = ""
	gender = PLURAL
	icon_state = "simpleshoe"
	item_state = "simpleshoe"
	resistance_flags = null
	color = "#473a30"
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/simpleshoes/white
	color = null


/obj/item/clothing/shoes/roguetown/simpleshoes/buckle
	name = "扣带鞋"
	icon_state = "buckleshoes"
	color = null

/obj/item/clothing/shoes/roguetown/simpleshoes/lord
	name = "鞋子"
	desc = "农民日常穿着的普通鞋子。"
	gender = PLURAL
	icon_state = "simpleshoe"
	item_state = "simpleshoe"
	resistance_flags = null
	color = "#cbcac9"

/obj/item/clothing/shoes/roguetown/gladiator
	name = "皮凉鞋"
	desc = ""
	gender = PLURAL
	icon_state = "gladiator"
	item_state = "gladiator"
	nudist_approved = TRUE

/obj/item/clothing/shoes/roguetown/sandals
	name = "凉鞋"
	desc = "一双朴素的凉鞋，带有可调节绑带，几乎任何人都能穿得合脚。"
	gender = PLURAL
	icon_state = "sandals"
	item_state = "sandals"
	nudist_approved = TRUE
	dropshrink = null

/obj/item/clothing/shoes/roguetown/sandals/ancient
	name = "远古甲胄凉鞋"
	desc = "抛光的gilbranze高底凉鞋向上卷起，恰好托住双足。它曾属于失落时代的角斗士，如今再度被唤醒来服役。这双凉鞋从不是为踏过沙地而造，而是为了高高站在敌人的尸体之上。"
	icon_state = "ancientsandals"
	max_integrity = 200
	armor = ARMOR_PLATE
	anvilrepair = /datum/skill/craft/armorsmithing
	nudist_approved = TRUE

/obj/item/clothing/shoes/roguetown/sandals/ancient/decrepit
	name = "残破甲胄凉鞋"
	desc = "破旧的青铜高底凉鞋向上卷起，托住双足。它曾踏过的海滩早已不复存在；珍珠般的沙地早在Syon彗星撞击时化为了琉璃。"
	max_integrity = 50
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/shoes/roguetown/shalal
	name = "巴布什鞋"
	desc = ""
	gender = PLURAL
	icon_state = "shalal"
	item_state = "shalal"
	armor = list("blunt" = 25, "slash" = 20, "stab" = 25,"fire" = 0, "acid" = 0)
	heat_protection = FOOT_LEFT | FOOT_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/shoes/roguetown/boots/leather
	name = "皮靴"
	//dropshrink = 0.75
	desc = "用鞣制皮革缝成的结实靴子，只是稍微有点漏水。"
	gender = PLURAL
	icon_state = "leatherboots"
	item_state = "leatherboots"
	armor = ARMOR_CLOTHING
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	name = "硬化皮靴"
	desc = "由熟皮缝制而成的结实靴子。样式体面、包裹牢靠，每一步都会发出令人满足的吱呀声。"
	icon_state = "alboots"
	item_state = "alboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)	//Same as gloves
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	armor = ARMOR_LEATHER_GOOD	//Better than regular leather.
	color = null
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	name = "礼靴"
	desc = "一双用熟皮缝成的结实靴子。比常见款更短，适合日常穿着和决斗。"
	icon_state = "albootsb"
	item_state = "albootsb"

/obj/item/clothing/shoes/roguetown/boots/otavan
	name = "Otava皮靴"
	desc = "工艺出众的靴子，你脆弱的双脚从未感受过如此的保护与舒适。"
	body_parts_covered = FEET
	icon_state = "fencerboots"
	item_state = "fencerboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	armor = ARMOR_LEATHER_GOOD
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	name = "Grenzelhoft长靴"
	icon_state = "grenzelboots"
	item_state = "grenzelboots"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_LEATHER_GOOD
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots
	name = "靛纹精灵靴"
	desc = "活木树干在春天仍会开花。它们会让水透过，却从不冰冷。"
	armor = list("blunt" = 100, "slash" = 10, "stab" = 100, "piercing" = 20, "fire" = 0, "acid" = 0) //Resistant to blunt and stab, but very weak to slash.
	prevent_crits = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfshoes"
	item_state = "welfshoes"
	anvilrepair = /datum/skill/craft/carpentry

/// Dendor ritual variant of the woad elven boots — blessed by the Treefather's Nature's Temper ritual.
/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots/druidic
	name = "赐福德鲁伊靴"
	desc = "以圣化根木塑成的靴子，至今仍脉动着树父的活力。它们给予稳固踏感，对刺击和斩击的抵御也略胜普通精灵工艺。"
	armor = list("blunt" = 100, "slash" = 65, "stab" = 130, "piercing" = 20, "fire" = 0, "acid" = 0)
	max_integrity = 200

/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots/druidic/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots/druidic/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name] 拒绝了我的触碰，唯有树父的信徒才配承受这份恩赐！"))

/obj/item/clothing/shoes/roguetown/boots/armor
	name = "板甲靴"
	desc = "由多片钢板锻成的靴子，用来保护你脆弱的脚趾。"
	body_parts_covered = FEET
	icon_state = "armorboots"
	item_state = "armorboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	color = null
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_STEEL
	armor = ARMOR_PLATE
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN

/obj/item/clothing/shoes/roguetown/boots/armor/ancient
	name = "远古战靴"
	desc = "抛光的gilbranze胫甲层层叠压，以保护脚踝与双足。那些无生而行者踏出的金属脚步声，无论在哪里响起，都预示着毁灭。"
	icon_state = "ancientboots"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/shoes/roguetown/boots/armor/ancient/decrepit
	name = "残破战靴"
	desc = "破旧的青铜胫甲叠覆在腐朽皮靴之上。昔日军团士兵的趾骨仍留在其中，每走一步都会在里头作响。"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/shoes/roguetown/boots/armor/graggar
	name = "凶暴战靴"
	desc = "这双板甲靴涌动着推动世界前行的同一种暴力。它们已踩碎过无数头骨。"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	armor = ARMOR_ASCENDANT
	icon_state = "graggarplateboots"

/obj/item/clothing/shoes/roguetown/boots/armor/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")


/obj/item/clothing/shoes/roguetown/boots/armor/matthios
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "镀金战靴"
	desc = "镀金的坟墓终将为蠕虫所拥。"
	icon_state = "matthiosboots"
	armor = ARMOR_ASCENDANT

/obj/item/clothing/shoes/roguetown/boots/armor/matthios/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/shoes/roguetown/boots/armor/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/shoes/roguetown/boots/armor/zizo
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "Avantyne战靴"
	desc = "板甲战靴。自本不该被知晓的边界被召来。奉她之名。"
	icon_state = "zizoboots"
	armor = ARMOR_ASCENDANT

/obj/item/clothing/shoes/roguetown/boots/armor/zizo/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/shoes/roguetown/boots/armor/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/shoes/roguetown/boots/armor/iron
	name = "轻型板甲靴"
	desc = "镶有铁片以增强防护的靴子。"
	icon_state = "soldierboots"
	item_state = "soldierboots"
	max_integrity = ARMOR_INT_SIDE_IRON
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/iron
	cold_protection = FOOT_LEFT | FOOT_RIGHT // These are still mostly leather, also at least ONE reason to wear them compared to their full steel counterparts
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	name = "甲片凉鞋"
	desc = "皮凉鞋，配有钢制踝甲和结实布袜。"
	icon_state = "kazengunboots"
	item_state = "kazengunboots"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择一种颜色。", "卡曾贡配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/shoes/roguetown/jester
	name = "滑稽鞋"
	desc = "铃铛让每一步都伴着叮叮当当的晃响。"
	icon_state = "jestershoes"
	detail_tag = "_detail"
	resistance_flags = null
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE

/obj/item/clothing/shoes/roguetown/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/shoes/roguetown/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/shoes/roguetown/jester/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/shoes/roguetown/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/shoes/roguetown/boots/furlinedboots
	name = "毛衬长靴"
	desc = "内衬毛皮的皮靴。"
	gender = PLURAL
	icon_state = "furlinedboots"
	item_state = "furlinedboots"
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	armor = ARMOR_CLOTHING
	salvage_amount = 1
	salvage_result = /obj/item/natural/fur
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	name = "毛衬踝套"
	desc = "内衬毛皮的皮制踝套，在裸足的同时提供少许额外防护。"
	gender = PLURAL
	icon_state = "furlinedanklets"
	item_state = "furlinedanklets"
	is_barefoot = TRUE
	armor = ARMOR_CLOTHING
	is_barefoot = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/shoes/roguetown/boots/clothlinedanklets
	name = "布衬踝套"
	desc = "内衬纤维的布质踝套，在裸足的同时提供温暖。"
	gender = PLURAL
	icon_state = "furlinedanklets"
	item_state = "furlinedanklets"
	is_barefoot = TRUE
	armor = ARMOR_CLOTHING

/obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	name = "审判官长靴"
	desc = "做工精良的长靴，生来便是为了将黑暗踩灭。"
	icon_state = "inqboots"
	item_state = "inqboots"
	allowed_race = ALL_RACES_TYPES


// ----------------- BLACKSTEEL -----------------------

/obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	name = "黑钢板甲靴"
	desc = "以耐用黑钢锻造的靴子，采用现代样式。"
	body_parts_covered = FEET
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplateboots"
	item_state = "bplateboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	color = null
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	armor = ARMOR_PLATE_BSTEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
	resistance_flags = FIRE_PROOF
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN

/obj/item/clothing/shoes/roguetown/boots/blacksteel/plateboots
	name = "远古黑钢板甲靴"
	desc = "以耐用黑钢锻造的靴子。"
	body_parts_covered = FEET
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkboots"
	item_state = "bkboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	color = null
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	armor = ARMOR_PLATE_BSTEEL
	sewrepair = null
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
	resistance_flags = FIRE_PROOF
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN

// ----------------- BLACKSTEEL END -----------------------

/obj/item/clothing/shoes/roguetown/anklets
	name = "金质踝饰"
	desc = "用上等黄金制成的奢华踝饰。它让双足裸露，却平添几分异域风情。"
	gender = PLURAL
	icon_state = "anklets"
	item_state = "anklets"
	is_barefoot = TRUE
	armor = ARMOR_CLOTHING
	nudist_approved = TRUE
	heat_protection = FOOT_LEFT | FOOT_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
	sewrepair = null
	anvilrepair = /datum/skill/craft/armorsmithing
	dropshrink = 0.6

//kazen update
/obj/item/clothing/shoes/roguetown/armor/rumaclan
	name = "高底凉鞋"
	desc = "一双古怪的凉鞋，能把你整个人抬离地面。"
	icon_state = "eastsandals"
	item_state = "eastsandals"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	armor = ARMOR_LEATHER_GOOD
	nudist_approved = TRUE

/obj/item/clothing/shoes/roguetown/boots/horsey
	name = "腿部束具"
	desc = "一套用于腿部的加固皮带与绑带。"
	icon_state = "hlegs"
	item_state = "hlegs"
	body_parts_covered = LEGS|FEET
	color = null
