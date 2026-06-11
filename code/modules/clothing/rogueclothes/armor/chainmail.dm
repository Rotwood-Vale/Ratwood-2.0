//LIGHT ARMOR//
/obj/item/clothing/suit/roguetown/armor/chainmail
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "短链甲"
	desc = "钢制锁子甲衫。箭矢和小匕首会直接穿过它的缝隙。"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "haubergeon"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = CHAINHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_LIGHT //Experimental change; leave unlisted for now? Offers a weight-class advantage over the otherwise-superior hauberk. We'll see how it goes.

/obj/item/clothing/suit/roguetown/armor/chainmail/iron
	icon_state = "ihaubergeon"
	name = "铁制短链甲"
	desc = "由沉重铁环制成的锁甲背心。总比没有强。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/chainmail/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	name = "远古短链甲"
	desc = "抛光的吉尔布兰兹环与丝绸交织成短式 maille-atekon。百万人的死亡成就了齐佐的升格；若还需再有百万人赴死才能完成她的伟业，那便如此。"
	icon_state = "ancientchain"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	name = "破败短链甲"
	desc = "磨损的青铜环与腐烂皮革交织成短式 maille-atekon。环链间有一道裂口，皮革沾着黑色污渍，那是数个世纪前致命创伤留下的痕迹。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	anvilrepair = null

//MEDIUM ARMOR//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "长链甲"
	desc = "更长的钢制锁子甲，连腿部也能保护，不过依然挡不住箭矢。"
	body_parts_covered = COVERAGE_FULL
	icon_state = "hauberk"
	item_state = "hauberk"
	armor = ARMOR_MAILLE
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	name = "铁制长链甲"
	desc = "更长的铁制锁子甲，连腿部也能保护，不过依然挡不住箭矢。"
	icon_state = "ihauberk"
	item_state = "ihauberk"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	name = "远古长链甲"
	desc = "抛光的吉尔布兰兹环与丝绸交织成带袖的 maille-atekon。让无生者自腐朽中归来，将他们抬升至昔日不可企及的高度；那便是齐佐显现于世的意志。"
	icon_state = "ancienthauberk"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit
	name = "破败长链甲"
	desc = "磨损的青铜环与腐烂皮革交织成带袖的 maille-atekon。曾经是圣骑士的武装法衣，如今却成了齐佐不死军团枯槁的披幕。"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate
	slot_flags = ITEM_SLOT_ARMOR
	armor_class = ARMOR_CLASS_HEAVY
	peel_threshold = 4
	armor = ARMOR_CUIRASS
	name = "赛顿长链甲"
	desc = "精美的钢制胸甲，以受祝银饰出沟槽纹，穿在厚重锁子甲之上。虽然它面对箭矢与弩矢时略显无力，但这些层层相扣的防护极擅抵御非人利爪与战斧的打击。 </br>'..邪恶的知识，以及将普赛多尼亚的希望扛在肩上的重负..' </br>... </br>若再添一些受祝银并请铁匠协助，我就能把这件长链甲改造成一套全身板甲。"
	icon_state = "ornatehauberk"
	item_state = "ornatehauberk"
	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini
	name = "锁子甲胸衣"	// corslet, from the old French 'cors' or bodice, with the diminutive 'let', used to describe lightweight military armor since 1500. Chosen here to replace 'bikini', an extreme anachronism.
	desc = "献给胆大者，以轻盈之姿换取锁甲的防护。"
	icon_state = "chainkini"
	item_state = "chainkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES
	body_parts_covered = CHEST|GROIN
	armor_class = ARMOR_CLASS_LIGHT //placed in the medium category to keep it with its parent obj
