/obj/item/clothing/under/roguetown/platelegs
	name = "钢制板甲腿铠"
	desc = "用于保护双腿的加固甲胄。"
	gender = PLURAL
	icon_state = "plate_legs"
	item_state = "plate_legs"
//	adjustable = CAN_CADJUST
	sewrepair = FALSE
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_LEG_STEEL_PLATE
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	smelt_bar_num = 2
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_HEAVY
	peel_threshold = 4

/obj/item/clothing/under/roguetown/platelegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/under/roguetown/platelegs/iron
	name = "铁制板甲腿铠"
	desc = "用于保护双腿的加固甲胄。"
	icon_state = "iplate_legs"
	item_state = "iplate_legs"
	max_integrity = ARMOR_INT_LEG_IRON_PLATE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/platelegs/ancient
	name = "远古板甲腿铠"
	desc = "抛光的gilbranze甲片层叠于丝质腿铠之上。唯有少数拥抱不死之人得以在Zizo升格时幸存；如今，他们统御着那些奉她之名进军、誓要撕裂造物的不死军团。"
	icon_state = "ancientplate_legs"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
	name = "残破板甲腿铠"
	desc = "破旧的青铜甲片叠覆在腐坏的皮革与锁甲腿铠之上。昔日军团士兵所剩下的，只有一副空空如也的腹腔。"
	max_integrity = ARMOR_INT_LEG_DECREPIT_PLATE
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/under/roguetown/platelegs/graggar
	name = "凶暴护腿"
	desc = "这副板甲腿铠涌动着推动世界运转的原初暴力。"
	icon_state = "graggarplatelegs"
	armor = ARMOR_ASCENDANT
	max_integrity = ARMOR_INT_LEG_ANTAG

/obj/item/clothing/under/roguetown/platelegs/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/under/roguetown/platelegs/matthios
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "镀金护腿"
	desc = "且看我这副外在之貌："
	icon_state = "matthioslegs"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)
	armor = ARMOR_ASCENDANT

/obj/item/clothing/under/roguetown/platelegs/matthios/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "ARMOR")

/obj/item/clothing/under/roguetown/platelegs/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/under/roguetown/platelegs/zizo
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "Avantyne下装"
	desc = "唯有野心之女士真正受膏者才会穿上的腿部衣装。奉她之名。"
	icon_state = "zizocloth"
	armor = ARMOR_ASCENDANT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)

/obj/item/clothing/under/roguetown/platelegs/zizo/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/under/roguetown/platelegs/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/under/roguetown/platelegs/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/under/roguetown/platelegs/skirt
	name = "钢制垂腿甲"
	desc = "一组悬挂式钢板，用来保护髋部与大腿，同时不过分增加负担。"
	gender = PLURAL
	icon_state = "plate_skirt"
	item_state = "plate_skirt"
	body_parts_covered = GROIN
	armor_class = ARMOR_CLASS_LIGHT
	dropshrink = null
