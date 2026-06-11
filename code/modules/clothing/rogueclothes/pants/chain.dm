/obj/item/clothing/under/roguetown/chainlegs
	name = "钢制锁甲腿铠"
	desc = "由环环相扣的金属圆环构成的锁甲护腿。"
	gender = PLURAL
	icon_state = "chain_legs"
	item_state = "chain_legs"
	sewrepair = FALSE
	armor = ARMOR_MAILLE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_LEG_STEEL_CHAIN
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_MEDIUM
	dropshrink = null

/obj/item/clothing/under/roguetown/chainlegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/obj/item/clothing/under/roguetown/splintlegs
	name = "板条腿铠"
	desc = "由拼甲与板条甲构成的腿铠，在保护双腿的同时几乎不影响自由活动。"
	icon_state = "splintlegs"
	item_state = "splintlegs"
	max_integrity = ARMOR_INT_LEG_BRIGANDINE
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = SOFTHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	armor_class = ARMOR_CLASS_LIGHT//Steel version of splint leggings
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/steel
	dropshrink = 0.9

/obj/item/clothing/under/roguetown/splintlegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/under/roguetown/splintlegs/iron
	name = "拼铁护腿"
	desc = "一条背衬铁条的皮裤，在保持轻便的同时提供更强防护。"
	icon_state = "ironsplintlegs"
	item_state = "ironsplintlegs"
	max_integrity = ARMOR_INT_LEG_IRON_CHAIN
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = SOFTHIT
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	armor_class = ARMOR_CLASS_LIGHT//splint leggings
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/chainlegs/iron
	name = "铁制锁甲腿铠"
	icon_state = "ichain_legs"
	max_integrity = ARMOR_INT_LEG_IRON_CHAIN
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/chainlegs/skirt
	name = "钢制锁甲裙"
	desc = "一件及膝锁甲裙，能保护大腿免受斩击，却不会拖慢步伐。"
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	body_parts_covered = GROIN
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/under/roguetown/chainlegs/kilt
	name = "钢制锁甲裙铠"
	desc = "环环相扣的金属圆环一路垂落至脚踝。"
	icon_state = "chainkilt"
	item_state = "chainkilt"
	sleevetype = "chainkilt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	dropshrink = 0.8

/obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	name = "远古锁甲裙铠"
	desc = "抛光的gilbranze环片以丝带相连，组成腰间护衣。这些不死军团士兵曾为Vheslyn而行军，后来又追随Zizo；而如今，他们彻底听命于唤醒他们之人的心意。"
	icon_state = "achainkilt"
	sleevetype = "achainkilt"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	name = "残破锁甲裙铠"
	desc = "破旧的青铜圆环以腐朽皮带相连，形成垂挂于腰间的护片。锁甲随着每一步发出叮当声，仿佛唱着昔日军团行军者所钟爱的节律圣歌。"
	max_integrity = ARMOR_INT_LEG_DECREPIT_CHAIN
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	name = "铁制锁甲裙铠"
	desc = "环环相扣的金属圆环一路垂落至脚踝。"
	icon_state = "ichainkilt"
	item_state = "ichainkilt"
	sleevetype = "ichainkilt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	dropshrink = 0.8

/obj/item/clothing/under/roguetown/chainlegs/captain
	name = "队长腿铠"
	desc = "以钢板制成的腿甲，对钝击和投射物有额外防护。这一套是专门为队长量身打造的。"
	icon_state = "capplateleg"
	item_state = "capplateleg"
	armor = ARMOR_CUIRASS // Unique armor, uniquely good value coverage.
	max_integrity = ARMOR_INT_LEG_STEEL_PLATE // Integrity of plate chausses.
	armor_class = ARMOR_CLASS_HEAVY
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	dropshrink = 0.8
