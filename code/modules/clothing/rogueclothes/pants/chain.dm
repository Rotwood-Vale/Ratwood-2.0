/obj/item/clothing/under/roguetown/chainlegs
	name = "steel chain chausses"
	desc = "Chain leggings composed of interlinked metal rings."
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
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/under/roguetown/splintlegs
	name = "brigandine chausses"
	desc = "Splint mail and brigandine chausses, designed to protect the legs while still providing almost complete free range of movement."
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
	name = "splinted leggings"
	desc = "A pair of leather pants backed with iron splints, offering superior protection while remaining lightweight."
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
	name = "iron chain chausses"
	icon_state = "ichain_legs"
	max_integrity = ARMOR_INT_LEG_IRON_CHAIN
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/chainlegs/skirt
	name = "steel chain skirt"
	desc = "A knee-length maille skirt, warding cuts against the thighs without slowing the feet."
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	body_parts_covered = GROIN
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/under/roguetown/chainlegs/kilt
	name = "steel chain kilt"
	desc = "Interlinked metal rings that drape down all the way to the ankles."
	icon_state = "chainkilt"
	item_state = "chainkilt"
	sleevetype = "chainkilt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	dropshrink = 0.8

/obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	name = "ancient chain kilt"
	desc = "Polished gilbranze rings, linked together with bindings of silk to form a waist's vestment. These undying legionnaires once marched for Vheslyn, and again for Zizo; but now, they are utterly beholden to the whims of their resurrector."
	icon_state = "achainkilt"
	sleevetype = "achainkilt"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	name = "decrepit chain kilt"
	desc = "Frayed bronze rings, linked together with bindings of rotting leather to form a waist's drape. The maille jingles with every step, singing the hymn to a cadence once savored by marching legionnaires."
	max_integrity = ARMOR_INT_LEG_DECREPIT_CHAIN
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/under/roguetown/chainlegs/kilt/bronze
	name = "bronze chain kilt"
	desc = "An ankle-length bronze maille skirt, warding cuts against the thighs without slowing the feet."
	icon_state = "bchainkilt"
	item_state = "bchainkilt"
	sleevetype = "bchainkilt"
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_LEG_BRONZE + 25//275, slight big extra cause medium
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	name = "iron chain kilt"
	desc = "Interlinked metal rings that drape down all the way to the ankles."
	icon_state = "ichainkilt"
	item_state = "ichainkilt"
	sleevetype = "ichainkilt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	dropshrink = 0.8

/obj/item/clothing/under/roguetown/chainlegs/captain
	name = "captain's chausses"
	desc = "Cuisses made of plated steel, offering additional protection against blunt force and projectiles. These are specially fitted for the captain."
	icon_state = "capplateleg"
	item_state = "capplateleg"
	armor = ARMOR_CUIRASS // Unique armor, uniquely good value coverage.
	max_integrity = ARMOR_INT_LEG_STEEL_PLATE // Integrity of plate chausses.
	armor_class = ARMOR_CLASS_HEAVY
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	dropshrink = 0.8

/obj/item/clothing/under/roguetown/chainlegs/hose
	name = "steel chain hosen"
	icon_state = "chainhose"
	desc = "A set of maille-armored leggings, composed from interlinked steel rings and lightly padded for comfort. Worn in conjunction with one's \
	shortclothes to cover the lower body, the maille socks pair nicely with custom-fitted sabatons. For those seeking to flaunt more regal colors, it \
	can be combined with a pair of cloth hosen."
	body_parts_covered = LEGS|FEET
	flags_inv = null

/obj/item/clothing/under/roguetown/chainlegs/hose/dyeable
	name = "steel chain hosen with coverings"
	icon_state = "upchainhose"
	item_state = "upchainhose"
	desc = "A set of maille-armored leggings, composed from interlinked steel rings and lightly padded for comfort. Worn in conjunction with one's \
	shortclothes to cover the lower body, the maille socks pair nicely with custom-fitted sabatons. For a more personalized look, a second pair of \
	cloth hosen has been secured to cover the maille."
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	color = null
	detail_color = CLOTHING_WHITE
	altdetail_color = CLOTHING_WHITE

/obj/item/clothing/under/roguetown/chainlegs/hose/dyeable/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/chainlegs/hose/dyeable/update_icon()
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

/obj/item/clothing/under/roguetown/chainlegs/tights
	name = "steel chain tights"
	icon_state = "chaintights"
	item_state = "chaintights"
	desc = "A set of maille-armored tights, composed from interlinked steel rings and lightly padded for comfort. The leather codpiece works in conjunction with one's \
	shortclothes to cover the lower body, the maille socks pair nicely with custom-fitted sabatons. For those seeking to flaunt more regal colors, it \
	can be combined with a pair of cloth hosen."
	body_parts_covered = GROIN|LEGS|FEET
	detail_tag = "_detail"
	detail_color = CLOTHING_BROWN

/obj/item/clothing/under/roguetown/chainlegs/tights/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/chainlegs/tights/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/chainlegs/tights/dyeable
	name = "steel chain tights with coverings"
	icon_state = "upchaintights"
	item_state = "upchaintights"
	desc = "A set of maille-armored tights, composed from interlinked steel rings and lightly padded for comfort. The leather codpiece works in conjunction with one's \
	shortclothes to cover the lower body, the maille socks pair nicely with custom-fitted sabatons. For a more personalized look, a pair of \
	cloth hosen has been secured to cover the maille."
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	color = null
	detail_color = CLOTHING_WHITE
	altdetail_color = CLOTHING_WHITE

/obj/item/clothing/under/roguetown/chainlegs/tights/dyeable/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/chainlegs/tights/dyeable/update_icon()
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

///////// CRAFTING DATUMS FOR CHAIN / CLOTH HOSE COMBINATIONS /////////

/datum/crafting_recipe/roguetown/sewing/steelandclothhose
	name = "layer a cloth hose atop steel chain hosen"
	result = list(/obj/item/clothing/under/roguetown/chainlegs/hose/dyeable)
	reqs = list(/obj/item/clothing/under/roguetown/tights/hose = 1, /obj/item/clothing/under/roguetown/chainlegs/hose = 1)
	craftdiff = 0 //Straight-forward. Note that this is a copy of Draganfrukt's helmet-and-hat combination system, which also has the slight caveat..
	req_table = TRUE //..of resetting the durability of both items, when crafted and uncrafted. This check helps to reduce a lot of potential cheese, but should be tweaked later.

/datum/crafting_recipe/roguetown/sewing/steelandclothtights
	name = "layer a cloth hose stop steel chain tights"
	result = list(/obj/item/clothing/under/roguetown/chainlegs/tights/dyeable)
	reqs = list (/obj/item/clothing/under/roguetown/tights/hose = 1, /obj/item/clothing/under/roguetown/chainlegs/tights = 1)
	craftdiff = 0
	req_table = TRUE
