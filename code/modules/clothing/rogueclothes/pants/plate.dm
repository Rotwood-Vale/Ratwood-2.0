/obj/item/clothing/under/roguetown/platelegs
	name = "steel plate chausses"
	desc = "Reinforced armor to protect the legs."
	gender = PLURAL
	icon_state = "plate_legs"
	item_state = "plate_legs"
//	adjustable = CAN_CADJUST
	sewrepair = FALSE
	armor = ARMOR_PLATE
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

/obj/item/clothing/under/roguetown/platelegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_MAGEDEXTERITY)

/obj/item/clothing/under/roguetown/platelegs/iron
	name = "iron plate chausses"
	desc = "Reinforced armor to protect the legs."
	icon_state = "iplate_legs"
	item_state = "iplate_legs"
	max_integrity = ARMOR_INT_LEG_IRON_PLATE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/platelegs/ancient
	name = "ancient plate chausses"
	desc = "Polished gilbranze plates, layered atop silken chausses. Only the few who had embraced undeath were spared from Zizo's ascension; now, they command the undying legionnaires who march forth to sunder creation in Her name."
	icon_state = "ancientplate_legs"
	smeltresult = /obj/item/ingot/aaslag
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/under/roguetown/platelegs/ancient/decrepit
	name = "decrepit plate chausses"
	desc = "Frayed bronze plates, shingled over chausses of rotting leather-and-maille. Voided bowels are all that remains of its former legionnaire."
	max_integrity = ARMOR_INT_LEG_DECREPIT_PLATE
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/under/roguetown/platelegs/graggar
	name = "vicious leggings"
	desc = "Plate chausses which stir with the innate violence driving our world"
	icon_state = "graggarplatelegs"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_LEG_ANTAG

/obj/item/clothing/under/roguetown/platelegs/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/under/roguetown/platelegs/matthios
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "gilded leggings"
	desc = "But my outside to behold:"
	icon_state = "matthioslegs"
	armor = ARMOR_PLATE_BSTEEL

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
	name = "avantyne garments"
	desc = "<font color='A50021'>Nothing beside remains. Round the decay of that colossal wreck, boundless and bare.</font>"
	icon_state = "zizocloth"
	armor = ARMOR_PLATE_BSTEEL
	chunkcolor = "#363030"

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

/obj/item/clothing/under/roguetown/platelegs/medium/zizo
	name = "avantyne vestments"
	desc = "<font color='A50021'>Nothing beside remains. Round the decay of that colossal wreck, boundless and bare.</font>"
	icon_state = "zizoplatelegs_med"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_LEG_ANTAG
	armor_class = ARMOR_CLASS_MEDIUM
	chunkcolor = "#363030"

/obj/item/clothing/under/roguetown/platelegs/medium/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/under/roguetown/platelegs/skirt
	name = "steel plate tassets"
	desc = "A set of hanging plates of steel to protect the hips and thighs without too much burden."
	gender = PLURAL
	icon_state = "plate_skirt"
	item_state = "plate_skirt"
	body_parts_covered = LEGS
	armor_class = ARMOR_CLASS_MEDIUM
	dropshrink = null
