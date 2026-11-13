// Because no one fucking know about inheritance in this bleak codebase.
/obj/item/clothing/gloves/roguetown/leather
	name = "leather gloves"
	desc = "Gloves made out of sturdy leather. Barely offer any protection, but are better than nothing."
	icon_state = "leather_gloves"
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_SIDE_LEATHER
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	unarmed_bonus = 1
	color = "#66584c"
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/gloves/roguetown/leather/black
	color = CLOTHING_BLACK

/obj/item/clothing/gloves/roguetown/fingerless
	name = "fingerless gloves"
	desc = "Cloth gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	icon_state = "fingerless_gloves"
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	nudist_approved = TRUE

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	name = "fingerless gloves"
	desc = "Cloth gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	icon_state = "shadowgloves"
	allowed_race = NON_DWARVEN_RACE_TYPES
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	name = "fingerless gloves"
	desc = "Cloth gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	icon_state = "shadowgloves"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/gloves/roguetown/fingerless_leather
	name = "fingerless leather gloves"
	desc = "A pair of protective gloves favored by learned mages, lockshimmers, laborers, and smokers for maintaining manual dexterity over regular gloves."
	icon_state = "roguegloves"
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_CLOTH
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/fingerless_leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/gloves/roguetown/otavan
	name = "otavan leather gloves"
	desc = "A pair of heavy Otavan leather gloves, commonly used by fencers, renowned for their quality."
	icon_state = "fencergloves"
	item_state = "fencergloves"
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	allowed_race = NON_DWARVEN_RACE_TYPES
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/otavan/inqgloves
	name = "inquisitorial leather gloves"
	desc = "Masterworked leather gloves, reinforced with a light weave of maille. Hanging from the left glove's cuff is a small rosary necklace; a warm reminder that even the Inquisitors are beholden to His authority."
	icon_state = "inqgloves"
	item_state = "inqgloves"
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/otavan/psygloves
	name = "psydonic leather gloves"
	desc = "Thick leather mittens, stitched and cuffed to guard His children's palms from perforation."
	armor = ARMOR_LEATHER
	icon_state = "psydongloves"
	item_state = "psydongloves"
	salvage_result = /obj/item/natural/hide/cured
	allowed_race = ALL_RACES_TYPES

// Eastern gloves
/obj/item/clothing/gloves/roguetown/eastgloves1
	name = "black gloves"
	desc = "Sleek gloves typically used by swordsmen."
	icon_state = "eastgloves1"
	item_state = "eastgloves1"
	armor = ARMOR_LEATHER
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/gloves/roguetown/eastgloves2
	name = "stylish gloves"
	desc = "Unusual gloves worn by foreign gangs."
	icon_state = "eastgloves2"
	item_state = "eastgloves2"
	armor = ARMOR_LEATHER
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/gloves/roguetown/leather/horsey
	name = "arm harness"
	desc = "Reinforced leather bindings for the arms."
	icon_state = "harms"
	item_state = "harms"
	slot_flags = ITEM_SLOT_GLOVES|ITEM_SLOT_HANDS
	body_parts_covered = HANDS|ARMS
	// sleeved = FALSE
	color = null

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
	name = "hand's gloves"
	desc = "Supple silk, cut at the fingertips to ensure absolute precision."
	icon_state = "handgloves"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/gloves.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/gloves.dmi'

/obj/item/clothing/gloves/roguetown/rosa
	name = "ivory gloves"
	desc = "Finely crafted gloves of silk and leather."
	icon_state = "rosagloves1"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/rosa/eight
	name = "courtly gloves"
	icon_state = "rosagloves8"

/obj/item/clothing/gloves/roguetown/rosa/five
	name = "sable gloves"
	icon_state = "rosagloves5"

/obj/item/clothing/gloves/roguetown/rosa/four
	name = "obsidian gloves"
	icon_state = "rosagloves4"

/obj/item/clothing/gloves/roguetown/rosa/nine
	name = "royal gloves"
	icon_state = "rosagloves9"

/obj/item/clothing/gloves/roguetown/rosa/seven
	name = "regal gloves"
	icon_state = "rosagloves7"

/obj/item/clothing/gloves/roguetown/rosa/six
	name = "maroon gloves"
	icon_state = "rosagloves6"

/obj/item/clothing/gloves/roguetown/rosa/ten
	name = "stately gloves"
	icon_state = "rosagloves10"

/obj/item/clothing/gloves/roguetown/rosa/three
	name = "silvered gloves"
	icon_state = "rosagloves3"
