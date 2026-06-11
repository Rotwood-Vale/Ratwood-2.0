// BASE
/obj/item/clothing/suit/roguetown/armor/plate
	slot_flags = ITEM_SLOT_ARMOR
	name = "钢制半身板甲"
	desc = "带肩甲的“冒险者款”板甲。贴合度欠佳，留下不少足以让匕首或弩矢刺中要害的缝隙，因此建议配一件绗缝护甲衣。"
	body_parts_covered = COVERAGE_TORSO
	icon_state = "halfplate"
	item_state = "halfplate"
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	allowed_sex = list(MALE, FEMALE)
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_HEAVY
	peel_threshold = 4
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/plate/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/suit/roguetown/armor/plate/iron
	name = "铁制半身板甲"
	desc = "基础款铁制半身板甲，防护不错，耐用性中等。"
	body_parts_covered = CHEST | VITALS | LEGS // Reflects the sprite, which lacks pauldrons.
	icon_state = "ihalfplate"
	item_state = "ihalfplate"
	boobed = FALSE	//the armor just looks better with this, makes sense and is 8 sprites less
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/plate/ancient
	name = "远古半身板甲"
	desc = "抛光的吉尔青铜层片经魔焊铸成板甲。不可让任何人阻碍野心的步伐，让她的勇士迫使未开悟的群众屈膝。"
	icon_state = "ancientplate"
	item_state = "ancientplate"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/plate/ancient/decrepit
	name = "破败半身板甲"
	desc = "磨损的青铜层片铆接成板甲。曾是新星勇士的护甲，如今不过是一座蠢人的坟墓。"
	max_integrity = ARMOR_INT_CHEST_PLATE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer
	name = "工巧半身板甲"
	desc = "抛光的吉尔布兰兹层片经魔焊铸成轻型板甲。它留有一个槽位，可嵌入奥能熔件作为动力源。"
	icon_state = "artificerplate"
	item_state = "artificerplate"
	armor_class = ARMOR_CLASS_LIGHT // Artificer made gilbranze.
	var/powered = FALSE
	var/mode = 1
	var/active_item = FALSE //Prevents issues like dragon ring giving negative str instead
	var/legendaryarcane = FALSE
	var/legendaryathletics = FALSE
/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/Initialize(mapload)
	.=..()
	update_description()

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/tongs))
		if(user.get_skill_level(/datum/skill/craft/engineering) >= 3)
			toggle_mode(user)
			return
	if(istype(I, /obj/item/magic/melded/t1) && !powered)
		user.visible_message(span_notice("[user] 开始小心地把 [I] 安装进去，作为动力源。"))
		if(do_after(user, 5 SECONDS, target = src))
			qdel(I)
			powered = TRUE
			icon_state ="artificerplate_powered"
			item_state = "artificerplate_powered"
	.=..()

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/proc/toggle_mode(mob/user)
	if(!src.ontable())
		to_chat(user, span_notice("我得先把它放到桌上。")) //prevents stats staying on a person if tinkered on self
	else
		mode = (mode == 1) ? 2 : 1
		user.visible_message(span_notice("[user] 摆弄着 [src]，调整它的强化效果。"))
		update_description()

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/equipped(mob/living/user, slot)
	. = ..()
	if(!powered || active_item || slot != SLOT_ARMOR)
		return
	if(mode == 1) // Arcane mode
		var/current_arcane = user.get_skill_level(/datum/skill/magic/arcane)
		if(current_arcane)
			if(current_arcane < 6) // Only add if not already capped
				active_item = TRUE
				legendaryarcane = FALSE
				user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
				user.change_stat("intelligence", 3)
				to_chat(user, span_notice("魔力流遍我的全身。"))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				user.change_stat("intelligence", 3)
				legendaryarcane = TRUE
				active_item = TRUE
				to_chat(user, span_warning("[src] 微微嗡鸣，但你早已是奥术大师。"))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
		else
			to_chat(user, span_warning("对不通奥术之人而言，[src] 冰冷而死寂。"))
	if(mode == 2)
		if(slot != SLOT_ARMOR)
			return
		var/current_athletics = user.get_skill_level(/datum/skill/misc/athletics)
		if(current_athletics)
			if(current_athletics < 6)// Only add if not already capped
				user.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
				legendaryathletics = FALSE
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				legendaryathletics = TRUE
			active_item = TRUE
			to_chat(user, span_notice("力量流遍我的全身。"))
			user.change_stat("strength", 2)
			user.change_stat("willpower", 2)
			icon_state ="artificerplate_powered"
			item_state = "artificerplate_powered"
			return
		else
			to_chat(user, span_warning("这件胸甲冰冷而死寂。"))

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/dropped(mob/living/user)
	.=..()
	if(active_item)
		if(mode == 1)
			if(user.get_skill_level(/datum/skill/magic/arcane))
				var/mob/living/carbon/human/H = user
				if(!legendaryarcane)
					H.adjust_skillrank(/datum/skill/magic/arcane, -1, TRUE)
				if(H.get_item_by_slot(SLOT_ARMOR) == src)
					to_chat(H, span_notice("增强我能力的奥术魔力消散了……"))
					H.change_stat("intelligence", -3)
					active_item = FALSE
					return
			else
				return
		if(mode == 2)
			if(user.get_skill_level(/datum/skill/misc/athletics))
				var/mob/living/carbon/human/H = user
				if(!legendaryathletics)
					H.adjust_skillrank(/datum/skill/misc/athletics, -1, TRUE)
				if(H.get_item_by_slot(SLOT_ARMOR) == src)
					to_chat(H, span_notice("增强我能力的力量消散了……"))
					user.change_stat("strength", -2)
					user.change_stat("willpower", -2)
					active_item = FALSE
					return
			else
				return

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/proc/update_description()
	if(mode == 1)
		desc = "抛光的吉尔布兰兹层片经魔焊铸成轻型板甲。它嗡鸣着奥能之力，强化施法造诣。"
	else
		desc = "抛光的吉尔布兰兹层片经魔焊铸成轻型板甲。它散发原始力量，强化穿戴者的肉体威能。"

/obj/item/clothing/suit/roguetown/armor/plate/fluted
	name = "沟槽半身板甲"
	desc = "华丽的钢制胸甲，配有垂甲与肩甲以增加覆盖。这种轻量化的“板甲”变体深受普赛多尼亚各地胸甲骑兵喜爱，也受那些至今最激烈战斗仍只发生在便桶上的新晋男爵追捧。"
	icon_state = "ornatehalfplate"

	equip_delay_self = 6 SECONDS
	unequip_delay_self = 6 SECONDS

	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	body_parts_covered = COVERAGE_FULL // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	name = "凶暴半身板甲"
	desc = "一套涌动着与世界同源暴力的沟槽半身板甲。这股内在驱力使它束缚感大为减轻。"
	armor_class = ARMOR_CLASS_MEDIUM
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL // We are probably one of the best medium armor sets. At higher integ than most.
	armor = ARMOR_ASCENDANT
	icon_state = "graggarplate"

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	name = "赛顿半身板甲"
	desc = "精美的钢制胸甲，配有垂甲与肩甲以增加覆盖。普赛顿的低阶教士常用染布装饰这些护甲，好让伤者在战场的疯狂中仍能寻得救赎。 </br>'..疯狂的鼓动，让你以为自己的苦难于阿多奈的祭羔而言毫无意义..' </br>... </br>若再添一些受祝银并请铁匠协助，我就能把这件半身板甲改造成一套全身板甲。"
	icon_state = "ornatehalfplate"
	smeltresult = /obj/item/ingot/silverblessed
	body_parts_covered = COVERAGE_FULL // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.

	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON
	is_silver = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		user.apply_status_effect(/datum/status_effect/buff/psydonic_endurance)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_armor == src)
		user.remove_status_effect(/datum/status_effect/buff/psydonic_endurance)

// Full plate armor

/obj/item/clothing/suit/roguetown/armor/plate/full
	name = "板甲"
	desc = "全套钢制板甲。没有优秀侍从帮忙的话，穿脱都很慢。"
	icon_state = "plate"
	body_parts_covered = COVERAGE_FULL
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/plate/full/iron
	name = "铁制板甲"
	icon_state = "ironplate"
	desc = "全套铁制板甲。没有优秀侍从帮忙的话，穿脱都很慢。"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa
	name = "samsibsa鳞板甲"
	desc = "远方卡曾贡的 kouken 所穿的重型护甲。不同于普赛多尼亚与西方常见的板甲，samsiba-cheolpan 由三十四排复合鳞片构成，每片都是镀覆黑钢的超薄钢片。 </br> 在单独鳞片上刻字极为常见，比如“幸运”、“荣耀”或“天命”。"
	icon_state = "kazengunheavy"
	item_state = "kazengunheavy"
	detail_tag = "_detail"
	boobed_detail = FALSE
	color = null
	detail_color = CLOTHING_WHITE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL - 50 //slightly worse
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa/attack_right(mob/user)
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

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	name = "沟槽板甲"
	desc = "一套华丽的板甲，无论外观还是防护都尽显高贵。这般辉煌的甲胄传统上只属于上层贵族: 老练骑士、受人敬仰的国王，以及想向泥腿子炫耀富贵的大腹议员。"
	icon_state = "ornateplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	name = "赛顿板甲"
	desc = "一套精美的板甲，以受祝银细致雕出沟槽纹。其设计源于一位传奇铠匠之手，他试图重现普赛顿天使昔日所披的天界甲胄。 </br>'..拒绝绝望，并立誓在普赛多尼亚最黑暗的时刻守护它..'"
	icon_state = "ornateplate"
	smeltresult = /obj/item/ingot/silverblessed

	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON
	is_silver = TRUE

	/// Whether the user has the Heavy Armour Trait prior to donning.
	var/traited = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		user.apply_status_effect(/datum/status_effect/buff/psydonic_endurance)

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_armor == src)
		user.remove_status_effect(/datum/status_effect/buff/psydonic_endurance)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	name = "灾厄胸甲"
	desc = "这套护甲更重外形胜于实用，适合展示威势而非真正厮杀。陈旧的镀金花纹正缓缓失去光泽。"
	icon_state = "shadowplate"
	item_state = "shadowplate"
	armor_class = ARMOR_CLASS_MEDIUM
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator
	name = "宗审庭裁决官板甲"
	desc = "据说是从格伦泽尔霍夫-奥塔凡战争中幸存下来的遗物，经翻修后以普赛顿之名再度用于诛灭宿敌。 <br> 一件加厚衬垫并额外增设肩甲的沟槽胸甲。你将坚持到底。"
	icon_state = "ordinatorplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	name = "镀金全板甲"
	desc = "你常听人如此传唱，"
	icon_state = "matthiosarmor"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.
	armor = ARMOR_ASCENDANT

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	name = "阿凡泰因全板甲"
	desc = "全身板甲。自应被知晓之界的边缘之外呼唤而来。以她之名。"
	icon_state = "zizoplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.
	armor = ARMOR_ASCENDANT

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/suit/roguetown/armor/plate/full/bikini
	name = "全板甲胸衣"
	desc = "胸甲、肩甲、肘甲、腿甲……你是不是忘了点什么？"
	icon_state = "platekini"
	allowed_sex = list(MALE, FEMALE)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	equip_delay_self = 8 SECONDS
	unequip_delay_self = 8 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/heartfelt
	slot_flags = ITEM_SLOT_ARMOR
	name = "甲衣外套"
	desc = "一件贵气十足的甲衣外套。"
	body_parts_covered = COVERAGE_FULL
	icon_state = "heartfelt"
	item_state = "heartfelt"
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_HEAVY
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	icon_state = "heartfelt_hand"
	item_state = "heartfelt_hand"

/obj/item/clothing/suit/roguetown/armor/plate/otavan
	name = "奥塔凡半身板甲"
	desc = "带肩甲的半身板甲。建议与奥塔凡绗缝护甲衣叠穿。"
	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_TORSO
	icon_state = "corsethalfplate"
	item_state = "corsethalfplate"
	adjustable = CAN_CADJUST
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#5058c1"
	var/swapped_color // holder for corset colour when the corset is toggled off.

/obj/item/clothing/suit/roguetown/armor/plate/otavan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/plate/otavan/AdjustClothes(mob/user)
	if(loc == user)
		playsound(user, "sound/foley/dropsound/cloth_drop.ogg", 100, TRUE, -1)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			icon_state = "fancyhalfplate"
			body_parts_covered = CHEST|GROIN|VITALS
			flags_cover = null
			emote_environment = 0
			swapped_color = detail_color
			detail_color = "#ffffff"
			update_icon()
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_armor()
			block2add = null
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			detail_color = swapped_color
			emote_environment = 3
			update_icon()
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/plate/hussar
	name = "翼饰板甲"
	desc = "覆盖上半身、背后装有“翅翼”的恰尔瓦特基板甲。骠骑冲锋时足以令敌人心生畏惧。"
	icon_state = "hussar"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/czwarteki.dmi'
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	equip_delay_self = 8 SECONDS
	unequip_delay_self = 8 SECONDS
	equip_delay_other = 2 SECONDS
	strip_delay = 4 SECONDS
	smelt_bar_num = 2
	boobed = FALSE
	worn_x_dimension = 32
	worn_y_dimension = 36
	allowed_race = NON_DWARVEN_RACE_TYPES

// MEDIUM
/obj/item/clothing/suit/roguetown/armor/plate/bikini
	name = "半身板甲胸衣"
	desc = "高胸甲与髋甲兼具灵活与强大防护，唯独腹部仍有空缺。"
	body_parts_covered = CHEST|GROIN
	icon_state = "halfplatekini"
	item_state = "halfplatekini"
	armor = ARMOR_CUIRASS // Identical to steel cuirass, but covering the groin instead of the vitals.
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL	// Identical to steel cuirasss. Same steel price.
	allowed_sex = list(MALE, FEMALE)
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/half
	slot_flags = ITEM_SLOT_ARMOR
	name = "钢胸甲"
	desc = "基础款钢制胸甲。轻便且耐用。弩矢大概会直接穿透，但箭矢未必。"
	body_parts_covered = COVERAGE_VEST
	icon_state = "cuirass"
	item_state = "cuirass"
	armor = ARMOR_CUIRASS
	allowed_race = CLOTHED_RACES_TYPES
	nodismemsleeves = TRUE
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	name = "击剑手胸甲"
	desc = "锻造精妙、贴合身形的钢制胸甲，更轻也更灵活。内衬柔软皮革与丝绸，不仅防护出色，穿着也十分奢华。"
	armor = ARMOR_CUIRASS// Experimental.
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL //costly to make, competes with Light Brigandine. Compare to it and Studded/Hardened Leather.
	smelt_bar_num = 1
	icon_state = "fencercuirass"
	item_state = "fencercuirass"

/obj/item/clothing/suit/roguetown/armor/plate/half/fencer/psydon
	name = "赛顿胸甲"
	desc = "锻造精妙、贴合身形的钢制胸甲，更轻也更灵活，但也更容易损坏。它更薄，却以丝绸与皮革为衬。"
	smelt_bar_num = 1
	smeltresult = /obj/item/ingot/silverblessed
	icon_state = "ornatechestplate"
	item_state = "ornatechestplate"
	is_silver = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	name = "远古胸甲"
	desc = "抛光的吉尔布兰兹弯制成胸甲。它不是为不再跳动的心脏而铸，而是献给流经无光骨髓的灵意; 这是她诸多恩赐之一。"
	icon_state = "ancientcuirass"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/plate/half/ancient/decrepit
	name = "破败胸甲"
	desc = "磨损的青铜锻成胸甲。它更像束身衣而非胸甲; 狭窄得几乎不给那对疼痛的肺留下呼吸空间。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/plate/half/fluted
	name = "沟槽胸甲"
	icon_state = "ornatecuirass"
	desc = "华丽的钢制胸甲，配有垂甲以增加覆盖。精细的沟槽纹不仅吸引佳人，也增强了钢材抵御反复冲击的能力。"

	body_parts_covered = CHEST | VITALS | LEGS
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL

/obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate
	name = "赛顿胸甲"
	icon_state = "ornatecuirass"
	desc = "精美的钢制胸甲，配有垂甲以增加覆盖。受祝银条被细致嵌入沟槽纹之中; 这项费工装饰表明它出自银色灵十字修会。 </br>'..感受永世之手落在你肩上，把世界的重负交予血肉与骨骼..' </br>... </br>若再添一些受祝银并请铁匠协助，我就能把这件胸甲改造成一套半身板甲。"
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/half/iron
	name = "铁胸甲"
	desc = "基础款铁制胸甲，防护不错，耐用性中等。"
	icon_state = "ibreastplate"
	boobed = FALSE	//the armor just looks better with this, makes sense and is 8 sprites less
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/half/copper
	name = "护心甲"
	desc = "非常简陋粗糙的胸部防具。古代战士也曾用过类似装备，只是质量更好……"
	icon_state = "copperchest"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	armor = list("blunt" = 75, "slash" = 75, "stab" = 75, "piercing" = 40, "fire" = 0, "acid" = 0)	//idk what this armor is but I ain't making a define for it
	smeltresult = /obj/item/ingot/copper
	body_parts_covered = CHEST
	armor_class = ARMOR_CLASS_LIGHT
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/half/elven
	name = "精灵守卫胸甲"
	desc = "由钢材制成、外覆薄层装饰性镀金的胸甲。轻便而耐用。"
	color = COLOR_ASSEMBLY_GOLD

/obj/item/clothing/suit/roguetown/armor/plate/scale
	slot_flags = ITEM_SLOT_ARMOR
	name = "鳞甲"
	desc = "精巧交织的金属鳞片，构成灵活的防护！"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	allowed_sex = list(MALE, FEMALE)
	icon_state = "lamellar"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
	name = "钢制重札甲"
	desc = "阿夫尼克风格的胸甲，由易于更换的细小矩形层钢片用金属丝成排串联而成。柔韧而有防护，最适合骑兵。"
	icon_state = "hudesutu"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL + 50

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	slot_flags = ITEM_SLOT_ARMOR
	slot_flags = ITEM_SLOT_ARMOR
	name = "宗审庭长风衣"
	desc = "厚重长风衣，皮革之下暗藏层层锁甲，由神圣奥塔凡宗审庭的精锐穿用。 </br>这件长风衣还能嵌入一件赛顿胸甲，在不牺牲风度的前提下抵御更致命的打击。"
	body_parts_covered = COVERAGE_FULL
	allowed_sex = list(MALE, FEMALE)
	allowed_sex = list(MALE, FEMALE)
	icon_state = "inqcoat"
	item_state = "inqcoat"
	sleevetype = "shirt"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sewrepair = TRUE
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_LEATHER_STUDDED
	blocksound = SOFTHIT
	cold_protection = CHEST | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/ComponentInitialize()	//No movement rustle component.
	return

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate))
		user.visible_message(span_warning("[user] 开始把 [W] 装入 [src]。"))
		if(do_after(user, 12 SECONDS))
			var/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored/P = new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			user.put_in_hands(P)
			P.obj_integrity = src.obj_integrity
			qdel(src)
			qdel(W)
		else
			user.visible_message(span_warning("[user] 停止把 [W] 装入 [src]。"))
		return


/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored
	slot_flags = ITEM_SLOT_ARMOR
	name = "装甲宗审庭长风衣"
	desc = "厚重长风衣，皮革之下暗藏层层锁甲，由神圣奥塔凡宗审庭的精锐穿用。长风衣开衩之处藏着惊喜: 一件穿在皮革之下、足以挡下重创的华丽钢胸甲。"
	smeltresult = /obj/item/ingot/steel
	icon_state = "inqcoata"
	item_state = "inqcoata"
	equip_delay_self = 4 SECONDS
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	armor_class = ARMOR_CLASS_MEDIUM
	armor = ARMOR_CUIRASS
	smelt_bar_num = 2
	smeltresult = /obj/item/ingot/steel
	blocksound = PLATEHIT

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored/ComponentInitialize()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)
	return

// Armored Inqcoat is medium armour, disabling inspector's dodge expert. Psydonic endurance ensures it becomes a side grade rather than a downgrade.
/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		user.apply_status_effect(/datum/status_effect/buff/psydonic_endurance)

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_armor == src)
		user.remove_status_effect(/datum/status_effect/buff/psydonic_endurance)

/obj/item/clothing/suit/roguetown/armor/plate/bronze
	name = "青铜胸甲"
	desc = "雕刻感十足的青铜胸甲，内衬兽皮以提升穿着舒适。甲片被精心锻造成普赛多尼亚古代英雄般的雕像体态。穿上它会令你充满决心。"
	body_parts_covered = CHEST | VITALS | LEGS
	icon_state = "bronzecuirass"
	armor = ARMOR_CUIRASS
	smeltresult = /obj/item/ingot/bronze
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	armor_class = ARMOR_CLASS_MEDIUM
	boobed = FALSE
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	name = "青铜护心甲"
	desc = "厚重的青铜护板，精心雕塑以贴合穿戴者身形，并守护其心口免遭重创。可惜它对情感上的打击几乎毫无还手之力。"
	icon_state = "bronzeprotector"
	item_state = "bronzeprotector"
	body_parts_covered = CHEST
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_CUIRASS

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze
	name = "青铜全装板甲"
	desc = "只能被称作“披袍式甲胄”的装备; 厚重青铜板层层叠覆，并以束带彼此连接 \
	构成一整套分段式板甲。尽管沉重笨拙得惊人，它却注定能扛住迎面而来的任何风暴。 \
	</br>学者们常将这套护甲称作“全装甲”，据说它本就是为普赛多尼亚最早期的亚西玛尔体型量身打造。"
	icon_state = "bronzeplate"
	item_state = "bronzeplate"
	armor = ARMOR_CUIRASS
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON
	armor_class = ARMOR_CLASS_HEAVY
	smeltresult = /obj/item/ingot/bronze
	smelt_bar_num = 3
	var/bronzeplatecumbersome = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		to_chat(user, span_suicide("这套全装甲咔嗒作响地就位，我感到双肩在其重量下低垂，可即便如此，我也觉得自己前所未有地结实……"))
		user.change_stat(STATKEY_CON, 1)
		user.change_stat(STATKEY_SPD, -1)
		bronzeplatecumbersome = TRUE
	return

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/dropped(mob/living/carbon/human/user)
	. = ..()
	if(bronzeplatecumbersome == TRUE)
		to_chat(user, span_hypnophrase("……我终于松了口气，这套全装甲的重量不再压在我的肩上。"))
		user.change_stat(STATKEY_CON, -1)
		user.change_stat(STATKEY_SPD, 1)
		bronzeplatecumbersome = FALSE
	return

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
	name = "青铜全装甲组件"
	icon_state = "bronzeplatealt"
	item_state = "bronzeplatealt"
	body_parts_covered = CHEST | VITALS | LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON //Halfplate analogue. Still heavy as hell.

//----------------- INFAREDBARON SPRITEWORK/ARMOR.DM ---------------------
/obj/item/clothing/suit/roguetown/armor/plate/citywatch
	slot_flags = ITEM_SLOT_ARMOR
	name = "城卫护甲"
	desc = "厚重而久经使用的护甲。对各种伤害都异常坚韧。是发给城卫的制式装备。"
	icon = 'icons/roguetown/clothing/licensed-infraredbaron/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/licensed-infraredbaron/onmob/armor.dmi'
	icon_state = "citywatch"
	item_state = "citywatch"
	blocksound = PLATEHIT
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50 //need to make it cover arms so that it displays the sprite properly. Still, giving it atypically good integrity
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2
	sewrepair = FALSE
	allowed_sex = list(MALE, FEMALE)
	equip_delay_self = 4 SECONDS
	sleevetype = null
	sleeved = null
