/obj/item/clothing/wrists/roguetown
	slot_flags = ITEM_SLOT_WRISTS
	sleeved = 'icons/roguetown/clothing/onmob/wrists.dmi'
	icon = 'icons/roguetown/clothing/wrists.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
	sleevetype = "shirt"
	resistance_flags = FLAMMABLE
	sewrepair = TRUE
	anvilrepair = null
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 64
	var/overarmor

/obj/item/clothing/wrists/roguetown/MiddleClick(mob/user, params)
	. = ..()
	overarmor = !overarmor
	to_chat(user, span_info("我[overarmor ? "把[src]戴在护甲外面" : "把[src]戴在护甲下面"]。"))
	if(overarmor)
		alternate_worn_layer = WRISTS_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/roguetown/bracers
	name = "臂甲"
	desc = "保护手臂的钢制臂甲。"
	body_parts_covered = ARMS
	icon_state = "bracers"
	item_state = "bracers"
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_STEEL
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/wrists/roguetown/bracers/ancient
	name = "远古臂甲"
	desc = "抛光的gilbranze护腕紧扣于手腕之上。唯有升格，凡躯的锁链方会断裂；唯有死亡，灵魂才有资格拥抱神性。"
	icon_state = "ancientbracers"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
	name = "残破臂甲"
	desc = "破旧的青铜护腕缠束在手腕上。别费心去数昔日军团士兵留下的刻痕了，因为他们没有一个从战场归来。"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/wrists/roguetown/bracers/psythorns
	name = "Psydon荆棘腕甲"
	desc = "以柔韧而耐用的黑钢制成的荆棘，彼此编织扣连，缠绕于双腕之上。"
	icon_state = "psybarbs"
	item_state = "psybarbs"
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	alternate_worn_layer = WRISTS_LAYER

/obj/item/clothing/wrists/roguetown/bracers/psythorns/equipped(mob/user, slot)
	. = ..()
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/roguetown/bracers/psythorns/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user]开始重塑[src]。"))
	if(do_after(user, 4 SECONDS))
		var/obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns/P = new /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		user.adjustBruteLoss(25)
		qdel(src)
	else
		user.visible_message(span_warning("[user]停止重塑[src]。"))
		return

/obj/item/clothing/wrists/roguetown/bracers/leather
	name = "皮臂甲"
	desc = "标准皮臂甲，能为手臂提供些许聊胜于无的保护。"
	icon_state = "lbracers"
	item_state = "lbracers"
	max_integrity = ARMOR_INT_SIDE_LEATHER
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	equip_sound = 'sound/foley/equip/rummaging-01.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	smeltresult = null
	dropshrink = null
	salvage_amount = 0 // sry
	salvage_result = /obj/item/natural/hide/cured
	color = "#684338"
	cold_protection = ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	name = "硬化皮臂甲"
	desc = "硬化皮护臂，能让你的手腕免受钝击之苦。"
	icon_state = "albracers"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	sellprice = 10
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	color = "#4d4d4d"
	cold_protection =  ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50
	dropshrink = 0.8

/obj/item/clothing/wrists/roguetown/bracers/copper
	name = "铜臂甲"
	desc = "铜制前臂护甲，既能提供一些防护，又颇具风格。"
	icon_state = "copperarm"
	item_state = "copperarm"
	smeltresult = /obj/item/ingot/copper
	armor = ARMOR_PLATE_BAD

/obj/item/clothing/wrists/roguetown/wrappings
	name = "日辉缠腕"
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "wrappings"
	item_state = "wrappings"
	nudist_approved = TRUE

/obj/item/clothing/wrists/roguetown/nocwrappings
	name = "月辉缠腕"
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "nocwrappings"
	item_state = "nocwrappings"
	nudist_approved = TRUE

/obj/item/clothing/wrists/roguetown/allwrappings
	name = "缠腕布"
	desc = "一条条布带，紧紧缠绕在你的手臂上。"
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "nocwrappings" //Greyscale. Accessable in the loadout.
	item_state = "nocwrappings"
	nudist_approved = TRUE

/obj/item/clothing/wrists/roguetown/bracers/cloth
	name = "布臂甲"
	desc = "这个本不该在代码里被直接使用。"
	smeltresult = null
	armor = ARMOR_PADDED_GOOD
	blade_dulling = DULLING_BASHCHOP
	icon_state = "nocwrappings"
	item_state = "nocwrappings"
	max_integrity = ARMOR_INT_SIDE_STEEL //Heavy leather-tier protection and critical resistances, steel-tier integrity. Integrity boost encourages hand-to-hand parrying. Weaker than the Psydonic Thorns. Uncraftable.
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	anvilrepair = null
	sewrepair = TRUE
	cold_protection = ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	name = "僧侣缠腕"
	desc = "裁切好的麻布与布料被细致缠在前臂上。绷紧的纤维能把流血的创口变成布面上的裂痕，让僧侣更有底气用空手去格挡刀刃。"
	color = "#BFB8A9"
	nudist_approved = TRUE

/obj/item/clothing/wrists/roguetown/bracers/cloth/naledi
	name = "旅者缠腕"
	desc = "裁切好的麻布与布料被细致缠在前臂上。接受Naledi训练的僧侣，很少像他们的Otava同门那样怀有宿命论心态，因此往往不愿把手腕缠进锯齿般的荆棘里。未染血的手指对秘法也确实更好使。</br>'……于是，当祂吐出最后一息时，他们所流下的巨大泪水，哀哭者之雨，标记了这寂静纪元的开端。愚人会告诉你Psydon已经死去，碎成了“十块更小的碎片”，可那说不通。祂们是内与外的一切，超越大小与形状。既然是一切，又怎会变成某物？不，祂们只是把耳朵从我们这里转开了。祂们在哀悼，为祂们最伟大的孩子，也为最糟的那个……'"
	color = "#48443B"
	nudist_approved = TRUE

//Queensleeves
/obj/item/clothing/wrists/roguetown/royalsleeves
	name = "皇家袖套"
	desc = "与华丽礼裙相称的袖套。"
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "royalsleeves"
	item_state = "royalsleeves"
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK

/obj/item/clothing/wrists/roguetown/royalsleeves/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/wrists/roguetown/royalsleeves/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/wrists/roguetown/royalsleeves/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/wrists/roguetown/royalsleeves/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/wrists/roguetown/splintarms
	name = "板条护臂"
	desc = "由板甲臂甲、肩甲与一组金属肘甲组成，在保护手臂的同时几乎不妨碍动作。"
	body_parts_covered = ARMS
	icon_state = "splintarms"
	item_state = "splintarms"
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_IRON
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE

/obj/item/clothing/wrists/roguetown/splintarms/iron
	name = "拼铁臂甲"
	desc = "一对皮护袖，背衬铁条、肘甲与肩片，既能保护双臂，又保持相当轻便。"
	body_parts_covered = ARMS
	icon_state = "ironsplintarms"
	item_state = "ironsplintarms"
	armor = ARMOR_LEATHER_STUDDED //not plate armor, is leather + iron bits
	max_integrity = ARMOR_INT_SIDE_LEATHER
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/wrists/roguetown/bracers/iron
	name = "铁臂甲"
	desc = "保护手臂的铁制臂甲。"
	body_parts_covered = ARMS
	icon_state = "ibracers"
	item_state = "ibracers"
	max_integrity = ARMOR_INT_SIDE_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/wrists/roguetown/bracers/jackchain
	name = "护臂链条"
	desc = "连接在小型肩甲与肘甲上的细钢条，佩戴于手臂外侧以防斩击。"
	icon_state = "jackchain"
	item_state = "jackchain"
	armor = ARMOR_LEATHER_STUDDED // Please help me make this make sense this has the same stab protection vro.
	max_integrity = ARMOR_INT_SIDE_LEATHER // Make it slightly worse
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	smeltresult = null

/obj/item/clothing/wrists/roguetown/gem
	name = "宝石手镯底件"
	desc = "你本不该看见这个。"
	slot_flags = ITEM_SLOT_WRISTS
	icon = 'icons/roguetown/clothing/wrists.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gembracelet.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_gembracelet.dmi'
	salvage_result = null
	sewrepair = FALSE

/obj/item/clothing/wrists/roguetown/gem/jadebracelet
	name = "玉石手镯"
	desc = "一套以玉石雕成的手镯。"
	icon_state = "br_jade"
	sellprice = 65

/obj/item/clothing/wrists/roguetown/gem/turqbracelet
	name = "蔚蓝石手镯"
	desc = "一套以蔚蓝石雕成的手镯。"
	icon_state = "br_turq"
	sellprice = 90

/obj/item/clothing/wrists/roguetown/gem/onyxabracelet
	name = "缟玛瑙手镯"
	desc = "一套以缟玛瑙雕成的手镯。"
	icon_state = "br_onyxa"
	sellprice = 45

/obj/item/clothing/wrists/roguetown/gem/coralbracelet
	name = "心石手镯"
	desc = "一套以心石雕成的手镯。"
	icon_state = "br_coral"
	sellprice = 75

/obj/item/clothing/wrists/roguetown/gem/amberbracelet
	name = "琥珀手镯"
	desc = "一套以琥珀雕成的手镯。"
	icon_state = "br_amber"
	sellprice = 65

/obj/item/clothing/wrists/roguetown/gem/shellbracelet
	name = "贝壳手镯"
	desc = "一套以贝壳雕成的手镯。"
	icon_state = "br_shell"
	sellprice = 25

/obj/item/clothing/wrists/roguetown/gem/rosebracelet
	name = "玫石手镯"
	desc = "一套以玫石雕成的手镯。"
	icon_state = "br_rose"
	sellprice = 30

/obj/item/clothing/wrists/roguetown/gem/chitinbracelet
	name = "甲壳手镯"
	desc = "一套以甲虫壳质雕成的手镯。"
	icon_state = "br_shell"
	color = "#7B8C5E"
	sellprice = 25

/obj/item/clothing/wrists/roguetown/gem/opalbracelet
	name = "欧泊手镯"
	desc = "一套以欧泊雕成的手镯。"
	icon_state = "br_opal"
	sellprice = 95
