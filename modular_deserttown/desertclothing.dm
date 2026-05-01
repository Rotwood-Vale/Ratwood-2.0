//can sort these into other folders later if we really wanna

//armor
//Common workhorse armour for men at arms? Seems like it should be decent alround basic protection, like a hauberk (but not underarmour)
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	slot_flags = ITEM_SLOT_ARMOR
	name = "janissary chainmail"
	desc = "A longer steel maille that protects the legs."
	sleeved = null
	sleevetype = null
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	icon_state = "mamaluke"
	item_state = "mamaluke"

//I remember cataphracts were supposed to be knights and that this is supposed to be heavy armour.
//Judging by the sprite it feels like the torso should be more heavily armoured but idk how to do that
//Some good clean -all-over protection again. Like scalemail but all-over. That'll do it right?
//Actually nah plate heavy armour should be heavier than that...
/obj/item/clothing/suit/roguetown/armor/plate/cataphract
	slot_flags = ITEM_SLOT_ARMOR
	name = "cataphract armor"
	desc = "Metal scales interwoven intricately to form flexible protection!"
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	icon_state = "cataphract"
	icon_state = "cataphract"
	body_parts_covered = COVERAGE_FULL
	sleeved = null
	sleevetype = null
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	// anvilrepair = /datum/skill/craft/armorsmithing
	// smeltresult = /obj/item/ingot/steel
	// armor_class = ARMOR_CLASS_HEAVY
	equip_delay_self = 4 SECONDS
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/cataphract/sultan
	name = "sultan scale"
	desc = "Impenetrable scales like an ancient black dragon!"
	color = "#5e5d5d"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/clothing/head/roguetown/helmet/heavy/cataphract/sultan
	name = "sultan helm"
	desc = "Impenetrable scales like an ancient black dragon!"
	color = "#5e5d5d"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel

// /obj/item/clothing/suit/roguetown/armor/chainmail/janissary //SPRITE ALREADY USED BY ATGERVI STUFF!
// 	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
// 	name = "Janissary Mail"
// 	desc = "A longer steel maille that protects the legs, still doesn't protect against arrows though."
// 	body_parts_covered = COVERAGE_FULL
// 	icon_state = "atgervi_raider_mail"
// 	item_state = "atgervi_raider_mail"
// 	max_integrity = 220
// 	armor = ARMOR_CUIRASS
// 	anvilrepair = /datum/skill/craft/blacksmithing
// 	smeltresult = /obj/item/ingot/steel
// 	armor_class = ARMOR_CLASS_MEDIUM
// 	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/suit/roguetown/armor/brigandine/agha
	name = "Agha Scale"
	desc = "Fine armor made of treated animal scales, denoting an esteemd career in the dunes."
	icon_state = "huus"
	item_state = "huus"
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = CHEST|GROIN|LEGS|VITALS|ARMS
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	armor_class = ARMOR_CLASS_MEDIUM

//armorhelmets

/obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	name = "cataphracts helm"
	desc = "A helmet with a menacing visage."
	icon_state = "cathelm"
	item_state = "cathelm"
	icon = 'modular_deserttown/icons/clothing/head32x48.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/head/roguetown/helmet/janissaryhelm
	name = "Janissary Helmet"
	desc = "A helmet with too much style."
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "mamhelm"
	max_integrity = 250
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR

// /obj/item/clothing/head/roguetown/helmet/janissary
// 	name = "Janissaries Helm"
// 	desc = "A helmet with too much style."
// 	icon_state = "atgervi_raider"
// 	item_state = "atgervi_raider"
// 	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
// 	max_integrity = 250
// 	body_parts_covered = HEAD|HAIR|EARS|NOSE
// 	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACE|HIDEFACIALHAIR
	
///VEST

/obj/item/clothing/suit/roguetown/armor/leather/vest/open
	name = "open vest"
	desc = "A leather vest. Not very protective when worn like this."
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	icon_state = "openvest"
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/blue
	color = "#2f51b8"

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/red
	color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/orange
	color = CLOTHING_ORANGE

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/green
	color = CLOTHING_GREEN

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/brown
	color = "#514339"

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/random

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/random/Initialize()
	color = pick("#2f51b8", CLOTHING_RED, CLOTHING_ORANGE, CLOTHING_GREEN, CLOTHING_PURPLE)
	..()

/obj/item/clothing/suit/roguetown/shirt/robe/bisht
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "bisht"
	desc = "A long robe typical in Zybantine."
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "greythawb"
	item_state = "greythawb"
	color = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|VITALS
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/grey
	color = "#989898"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/red
	color = "#9c4744"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/blue
	color = "#2f51b8"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/brown
	color = "#846145"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/beige
	color = "#e9c792"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/random

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/random/Initialize()
	color = pick("#989898", "#FFFFFF", "#9c4744", "#2f51b8", "#846145", "#e9c792", CLOTHING_BLACK)
	..()

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "grey bisht"
	icon_state = "bluethawb"
	item_state = "bluethawb"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "purple bisht"
	icon_state = "purplethawb"
	item_state = "purplethawb"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/merchantbisht
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	name = "guild bisht"
	desc = "An open robe, made from luxurious silks."
	armor = ARMOR_PADDED
	icon_state = "merbisht"
	item_state = "merbisht"
	color = null

/datum/crafting_recipe/roguetown/sewing/bisht
	name = "bisht"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/bisht/beige)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bisht/fancy
	name = "fine bisht"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey)
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	craftdiff = 4

//SHIRTS

//Easternclothes 
/obj/item/clothing/suit/roguetown/shirt/dress/thawb
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "thawb"
	desc = "A long, loose Zybantine robe."
	armor = ARMOR_CLOTHING
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "thawb"
	item_state = "thawb"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/blue
	color = "#2f51b8"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/red
	color = "#9c4744"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige
	color = "#e9c792"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/brown
	color = "#846145"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/grey
	color = "#989898"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/random

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/random/Initialize()
	color = pick("#989898", "#FFFFFF", "#9c4744", "#2f51b8", "#846145", "#e9c792", CLOTHING_BLACK)
	..()

/datum/crafting_recipe/roguetown/sewing/thawb
	name = "thawb"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "gold-trimmed thawb"
	desc = "A long, loose Zybantine robe. This one is trimmed with gold-silk thread."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "thawbgold"
	item_state = "thawbgold"

/obj/item/clothing/suit/roguetown/shirt/dress/amiradress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "amira's dress"
	desc = "A red skirt and binder, embroidened with infinitely intricate gold-thread patterns, and made of silk as light as air. Fit for a princess of Zybantine."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "dprince"
	item_state = "dprince"


/obj/item/clothing/suit/roguetown/shirt/sultan
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "sultans robes"
	desc = "A Zybantine Sultans noble robes."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	boobed = FALSE
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "sultan"
	item_state = "sultan"
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/sultana
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "sultanas dress"
	desc = "A Zybantine Sultanas noble Dress."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	boobed = FALSE
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "sultana"
	item_state = "sultana"
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/jafar
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "zybantine magos robes"
	desc = "A Zybantine magos noble robes."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	boobed = FALSE
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "jafar"
	item_state = "jafar"
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor = ARMOR_PADDED


//Eastern Clothing by Infrared Baron

/obj/item/clothing/head/roguetown/turban
	name = "turban"
	desc = "A long cloth, wound around the head."
	color = null
	body_parts_covered = HEAD|HAIR|EARS|NECK
	flags_inv = HIDEHAIR|HIDEEARS
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "turban"
	item_state = "turban"

/obj/item/clothing/head/roguetown/turban/tan
	color = "#93714b"

/obj/item/clothing/head/roguetown/turban/brown
	color = "#684f41"
	
/obj/item/clothing/head/roguetown/turban/dark
	color = "#414141"

/obj/item/clothing/head/roguetown/turban/grey
	color = "#848484"

/obj/item/clothing/head/roguetown/turban/red
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/turban/random

/obj/item/clothing/head/roguetown/turban/random/Initialize()
	color = pick("#414141", "#684f41", "#93714b", "#FFFFFF", "#848484")
	..()

/datum/crafting_recipe/roguetown/sewing/turban
	name = "turban"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 1

/obj/item/clothing/head/roguetown/turban/fancypurple
	name = "fancy purple turban"
	desc = "A long, luxurious cloth, wound around the head."
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "purple_hood"
	item_state = "purple_hood"

/datum/crafting_recipe/roguetown/sewing/turban/fancy
	name = "fancy turban"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/head/roguetown/tagelmust
	name = "Tagelmust"
	desc = "A long cloth, wound around the head, and a veil."
	body_parts_covered = HEAD|EARS|HAIR|NECK|NOSE|MOUTH
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "blue_hood"
	item_state = "blue_hood"

/datum/crafting_recipe/roguetown/sewing/tagelmust
	name = "tagelmust"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 3
//
/obj/item/clothing/head/roguetown/sultan
	name = "sultan's turban"
	desc = "Bask in its noble size and granduer!."
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	icon_state = "sultan"
	item_state = "sultan"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultan/merchant
	name = "merchant's turban"
	desc = "A turban, large and elaborate, made of the finest silk money can buy."
	icon_state = "merchant"
	item_state = "merchant"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultan/amir
	name = "amir's turban"
	desc = "Soft, decadent, grandiouse, but above all - princely."
	icon_state = "amir"
	item_state = "amir"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultana
	name = "sultana's headdress"
	desc = "Silky smooth Zybantine silk headress!"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "sultana"
	item_state = "sultana"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/jafar
	name = "zybantine magos hat"
	desc = "Bask in its noble size and granduer!"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	icon_state = "jafar"
	item_state = "jafar"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR	
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD
//pants


/obj/item/clothing/under/roguetown/sirwal
	name = "sirwal"
	desc = "Long, baggy trousers from Zybantium."
	color = null
	icon = 'modular_deserttown/icons/clothing/pants.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/pants.dmi'
	icon_state = "sirwal"
	item_state = "sirwal"

/obj/item/clothing/under/roguetown/sirwal/beige
	color = "#edc6a5"

/obj/item/clothing/under/roguetown/sirwal/brown
	color = "#927351"

/obj/item/clothing/under/roguetown/sirwal/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/sirwal/plainrandom

/obj/item/clothing/under/roguetown/sirwal/plainrandom/Initialize()
	color = pick("#FFFFFF", "#edc6a5", "#927351", CLOTHING_BLACK)
	..()

/obj/item/clothing/under/roguetown/sirwal/fancy
	color = null
	name = "fancy sirwal"
	desc = "Long, baggy trousers from Zybantine dyed in expensive, exotic colours."

/obj/item/clothing/under/roguetown/sirwal/fancy/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/sirwal/fancy/blue
	color = CLOTHING_BLUE

/obj/item/clothing/under/roguetown/sirwal/fancy/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/under/roguetown/sirwal/fancy/yellow
	color = CLOTHING_YELLOW

/obj/item/clothing/under/roguetown/sirwal/fancy/random

/obj/item/clothing/under/roguetown/sirwal/fancy/random/Initialize()
	color = pick(CLOTHING_BLACK, CLOTHING_BLUE, CLOTHING_PURPLE, CLOTHING_RED, CLOTHING_YELLOW)
	..()

/datum/crafting_recipe/roguetown/sewing/sirwal
	name = "sirwal"
	result = list(/obj/item/clothing/under/roguetown/sirwal)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 1

/obj/item/clothing/under/roguetown/thong
	name = "thong"
	desc = "Underwear so thin it barely covers ones bits. Barely."
	gender = PLURAL
	icon = 'modular_deserttown/icons/clothing/pants.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/pants.dmi'
	icon_state = "thong"
	item_state = "thong"
	body_parts_covered = GROIN

/datum/crafting_recipe/roguetown/sewing/thong
	name = "thong"
	result = list(/obj/item/clothing/under/roguetown/thong)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

//cloak
/obj/item/clothing/cloak/catcloak
	name = "cataphracts cloak"
	desc = "Noble red cloak of a Zybantine Cataphract"
	icon = 'modular_deserttown/icons/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	icon_state = "catcloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	sellprice = 50
	nodismemsleeves = TRUE
	
/obj/item/clothing/cloak/raincloak/amir
	name = "amir's cloak"
	desc = "A silky red cloak as light as a feather, embroidened with gold patterns. Fit for a prince of Zybantine."
	icon = 'modular_deserttown/icons/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	sleeved = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	hoodtype = /obj/item/clothing/head/hooded/rainhood/amirhood
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/head/hooded/rainhood/amirhood
	name = "amir's hood"
	desc = "A silky red hood as light as a feather, embroidened with gold patterns. Fit for a prince of Zybantine."
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	block2add = FOV_BEHIND
	flags_inv = HIDEHAIR

/obj/item/clothing/cloak/dunestalker
	name = "dunestalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin, depicting the Grand Sultan's house. The sign of a faithful servant."
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "shadowcloak"
	sleeved = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	sleevetype = "shirt"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	allowed_sex = list(MALE, FEMALE)
	flags_inv = null

/obj/item/clothing/cloak/citywatch/janissary
	name = "janissary cape"
	desc = "A light cloak held together by a gilded badge, depicting the Grand Sultan's house. The sign of a faithful servant."
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "jan"
	item_state = "jan"

//////BELTS

/obj/item/storage/belt/rogue/leather/cloth/sash
	name = "simple zybantine sash"
	desc = "A simple cloth sash."
	color = null
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "sashgrey"
	item_state = "sashgrey"

/datum/crafting_recipe/roguetown/sewing/zybsash
	name = "sash (zybantine)"
	result = list(/obj/item/storage/belt/rogue/leather/cloth/sash)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/obj/item/storage/belt/rogue/leather/cloth/sash/yellow
	color = CLOTHING_YELLOW

/obj/item/storage/belt/rogue/leather/cloth/sash/red
	color = CLOTHING_RED

/obj/item/storage/belt/rogue/leather/cloth/sash/orange
	color = CLOTHING_ORANGE

/obj/item/storage/belt/rogue/leather/cloth/sash/brown
	color = CLOTHING_BROWN

/obj/item/storage/belt/rogue/leather/cloth/sash/purple
	color = CLOTHING_PURPLE

/obj/item/storage/belt/rogue/leather/cloth/sash/random

/obj/item/storage/belt/rogue/leather/cloth/sash/random/Initialize()
	color = pick(CLOTHING_BROWN, CLOTHING_RED, CLOTHING_ORANGE, CLOTHING_YELLOW, CLOTHING_WHITE, CLOTHING_PURPLE)
	..()
	
/obj/item/storage/belt/rogue/leather/noblesash
	name = "Zybantine noble sash"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "noblesash"
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/zybnoblesash
	name = "sash (zybantine noble)"
	result = list(/obj/item/storage/belt/rogue/leather/noblesash)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/storage/belt/rogue/leather/sultbelt
	name = "Zybantine Sultans Sash"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "sultbelt"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/jafar
	name = "Zybantine magos Sash"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "jafar"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen
	name = "green exotic silk skirt"
	desc = "A gold adorned belt with the softest of silk skirts barely concealing one's bits."
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "exoticsilkskirt2"
	item_state = "exoticsilkskirt2"

/datum/crafting_recipe/roguetown/sewing/skirtgreen
	name = "exotic silk belt (green)"
	result = list(/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
	name = "red exotic silk skirt"
	desc = "A gold adorned belt with the softest of silk skirts barely concealing one's bits."
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "exoticsilkskirt"
	item_state = "exoticsilkskirt"

/datum/crafting_recipe/roguetown/sewing/skirtred
	name = "exotic silk belt (red)"
	result = list(/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

////////

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "exoticsilkbrag"
	item_state = "exoticsilkbrag"

/datum/crafting_recipe/roguetown/sewing/bragreen
	name = "exotic silk bra(green)"
	result = list(/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
	desc = "Fanciful gold laced silks barely able to conceal what little it covers. Long, flowing sleeves droop from the upper arms to a ring on each hand, fluttering in the wind and with every movement."
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "exoticsilkbrar"
	item_state = "exoticsilkbrar"

/datum/crafting_recipe/roguetown/sewing/brared
	name = "exotic silk bra (red)"
	result = list(/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/mask/rogue/exoticsilkmask/green
	icon = 'modular_deserttown/icons/clothing/masks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/masks.dmi'
	icon_state = "exoticsilkmaskg"
	item_state = "exoticsilkmaskg"

/datum/crafting_recipe/roguetown/sewing/maskgreen
	name = "exotic silk mask (green)"
	result = list(/obj/item/clothing/mask/rogue/exoticsilkmask/green)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/mask/rogue/exoticsilkmask/red
	icon = 'modular_deserttown/icons/clothing/masks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/masks.dmi'
	icon_state = "exoticsilkmaskr"
	item_state = "exoticsilkmaskr"

/datum/crafting_recipe/roguetown/sewing/maskred
	name = "exotic silk mask (red)"
	result = list(/obj/item/clothing/mask/rogue/exoticsilkmask/red)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

//Because some people can't live without BiS
/obj/item/clothing/shoes/roguetown/shalal/reinforced
	name = "fine babouche"
	desc = "Sturdy boots stitched together from cured leather. Stylish, firm, and sport a satisfying 'squeek' with each step."
	icon_state = "shalal"//change when I get around to it
	item_state = "shalal"
	color = "#d4c7bf"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)	//Same as gloves
	max_integrity = 100			//Half that of iron boots

	
/obj/item/clothing/shoes/roguetown/boots/armor/shalal
	name = "plated babouche"
	desc = "Sturdy boots stitched together from cured leather. Stylish, firm, and sport a satisfying 'squeek' with each step."
	icon_state = "shalal"//change when I get around to it
	item_state = "shalal"
