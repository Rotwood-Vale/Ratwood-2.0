/obj/item/clothing/head/roguetown/paddedcap
	name = "衬垫帽"
	desc = "一顶朴素的武装软帽。"
	icon_state = "armingcap"
	item_state = "armingcap"
	sleevetype = null
	sleeved = null
	body_parts_covered = HEAD|HAIR|EARS
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	armor = ARMOR_PADDED_BAD
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_CLOTH
	color = "#463C2B"
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2 // Major materials loss
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/helmet/leather
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "皮革头盔"
	desc = "一顶皮革制成的头盔。"
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "leatherhelm"
	armor = ARMOR_LEATHER
	sellprice = 10
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST)
	sewrepair = TRUE
	anvilrepair = null
	smeltresult = null
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_LEATHER
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	
/obj/item/clothing/head/roguetown/helmet/leather/chapeau
	name = "纳莱德便帽"
	desc = "一顶皮帽，以层层特制甲币加固，每一枚都刻有抵御超自然力量的护符。厚实可闭合的遮面垂片既很实用，能抵御风沙与寒夜，也能确保来自奥塔瓦的援助者不会因露面而触犯纳莱迪的习俗。</br>它与诗史学家阿莉丝·珀蒂及其记述纳莱迪远征的文字歌谣紧密相关，也因此常见于奥塔瓦的冒险吟游者。 "
	icon_state = "chapnaled"
	var/open_wear = TRUE
	flags_inv = HIDEHAIR
	body_parts_covered = HEAD|HAIR|EARS

/obj/item/clothing/head/roguetown/helmet/leather/chapeau/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			icon_state = "chapnaledalt"
			item_state = "chapnaledalt"
			open_wear = TRUE
			flags_inv = HIDESNOUT|HIDEHAIR
			body_parts_covered_dynamic = HEAD|HAIR|FACE
		if(TRUE)
			icon_state = "chapnaled"
			item_state = "chapnaled"
			open_wear = FALSE
			flags_inv = HIDEHAIR
			body_parts_covered_dynamic = HEAD|HAIR|EARS
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/leather/chapeau/AltRightClick(mob/user)
	if(!istype(loc, /mob/living/carbon))
		return
	var/mob/living/carbon/H = user
	if(icon_state == "[initial(icon_state)]_snout")
		icon_state = initial(icon_state)
		H.update_inv_head()
		update_icon()
		return

	var/icon/J = new('icons/roguetown/clothing/onmob/head.dmi')
	var/list/istates = J.IconStates()
	for(var/icon_s in istates)
		if(findtext(icon_s, "[icon_state]_snout"))
			icon_state += "_snout"
			H.update_inv_head()
			update_icon()
			return


/obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "沃尔夫头盔"
	desc = "一顶由沃尔夫头颅制成的皮革头盔。"
	body_parts_covered = HEAD|HAIR|EARS
	icon_state = "volfhead"
	item_state = "volfhead"
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/helmet/leather/saiga
	name = "赛加骨盔"
	desc = "一颗骇人的赛加羚头骨。看起来足以承受不少伤害。"
	icon_state = "saigahead"
	item_state = "saigahead"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/leather/advanced
	name = "硬化皮革头盔"
	desc = "结实、耐用、灵活。一顶由硬化皮革制成、舒适可靠的头盔。"
	icon_state = "leatherhelm"
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	sellprice = 15
	body_parts_covered = HEAD|EARS|HAIR|NOSE
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_LEATHER_GOOD
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	anvilrepair = null
	smeltresult = null
	blocksound = SOFTHIT
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/head/roguetown/spellcasterhat
	name = "咒剑士帽"
	desc = "一顶造型古怪、由紧密缝制皮革制成的帽子，常见于咒剑士。"
	icon_state = "spellcasterhat"
	item_state = "spellcasterhat"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	resistance_flags = FIRE_PROOF
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX //wide brim AND made out of silk

// Grenzel unique drip head. Pretend it is a secrete (A type of hat with a hidden helmet underneath). Same stats as kettle
/obj/item/clothing/head/roguetown/grenzelhofthat
	name = "格伦泽尔霍夫羽饰帽"
	desc = "无论怪物还是佳人，真正的格伦泽尔霍夫人都能一并征服。这顶帽子下方藏有金属内帽，可保护头部免受打击。"
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	icon = 'icons/roguetown/clothing/head.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	slot_flags = ITEM_SLOT_HEAD
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = ""
	max_integrity = ARMOR_INT_HELMET_LEATHER
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER // spellsinger hat stats
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	color = "#262927"
	detail_color = "#FFFFFF"
	altdetail_color = "#9c2525"
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/grenzelhofthat/attack_right(mob/user)
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
			H.update_inv_head()

/obj/item/clothing/head/roguetown/grenzelhofthat/update_icon()
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

//................ Briar Thorns ............... //	- Dendor Briar
/obj/item/clothing/head/roguetown/padded/briarthorns
	name = "荆棘冠"
	desc = "佩戴它带来的痛楚，也许能让你暂时忽略那位疯狂之神侵蚀理智的低语……"
	icon_state = "briarthorns"

/obj/item/clothing/head/roguetown/padded/briarthorns/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_warning ("荆棘刺痛了我。"))
	user.adjustBruteLoss(4)

//kazengite update
/obj/item/clothing/head/roguetown/mentorhat
	name = "旧竹笠"
	desc = "一顶经过加固的竹笠。"
	icon_state = "easthat"
	item_state = "easthat"
	armor = ARMOR_SPELLSINGER
	max_integrity = ARMOR_INT_HELMET_LEATHER
	blocksound = SOFTHIT
	flags_inv = HIDEEARS
	body_parts_covered = HEAD|HAIR|EARS|NOSE|EYES

/obj/item/clothing/head/roguetown/horsey
	name = "头部嚼具"
	desc = "一件由加固皮革制成的束缚头具。"
	icon_state = "hbit"
	item_state = "hbit"
	body_parts_covered = HEAD|FACE
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH

//Leather padded hood, ported from Scarlet Reach by RoachwithaRoach, from vide noir
/obj/item/clothing/head/roguetown/helmet/leather/armorhood
	name = "衬垫皮革兜帽"
	desc = "一顶带搭扣的衬垫皮革兜帽。"
	icon = 'modular_stonehedge/icons/clothing/armor/head.dmi'
	mob_overlay_icon = 'modular_stonehedge/icons/clothing/armor/onmob/head.dmi'
	icon_state = "studhood"
	item_state = "studhood"
	flags_inv =	HIDEHAIR|HIDEEARS|HIDEFACE
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_NECK
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES|NECK
	//Something between leather and metal helmet, worse than metal helmet by far.
	armor = list("blunt" = 70, "slash" = 65, "stab" = 60, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	block2add = FOV_BEHIND

/obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	name = "铆钉皮革兜帽"
	desc = "一顶厚实、带搭扣的铆钉皮革兜帽。"
	icon_state = "studhood" //make into new sprite
	item_state = "studhood"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_NECK
	max_integrity = 280
	//closer to metal helmet but still quite behind, same blunt resist of hardened leather helmet though.
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP, BCLASS_SMASH) //studded armor values with stab prot too

/obj/item/clothing/head/roguetown/helmet/leather/armorhood/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			block2add = null
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
				H.update_inv_neck()
				H.update_inv_wear_mask()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_head()
					H.update_inv_neck()
					H.update_inv_wear_mask()
