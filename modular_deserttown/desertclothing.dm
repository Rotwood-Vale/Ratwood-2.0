//can sort these into other folders later if we really wanna

//armor
//Common workhorse armour for men at arms? Seems like it should be decent alround basic protection, like a hauberk (but not underarmour)
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	slot_flags = ITEM_SLOT_ARMOR
	name = "耶尼切里锁子甲"
	desc = "一件较长的钢制锁甲，可保护腿部。"
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
	name = "铁甲骑兵甲"
	desc = "金属甲片精妙交织而成，提供灵活防护！"
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
	name = "苏丹鳞甲"
	desc = "如同远古黑龙般坚不可摧的鳞甲！"
	color = "#5e5d5d"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/clothing/head/roguetown/helmet/heavy/cataphract/sultan
	name = "苏丹头盔"
	desc = "如同远古黑龙般坚不可摧的鳞甲！"
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
	name = "阿迦鳞甲"
	desc = "以精制兽鳞制成的优良铠甲，象征着沙丘中的尊荣生涯。"
	icon_state = "huus"
	item_state = "huus"
	armor = ARMOR_LEATHER_STUDDED
	body_parts_covered = CHEST|GROIN|LEGS|VITALS|ARMS
	sewrepair = TRUE
	armor_class = ARMOR_CLASS_MEDIUM

//armorhelmets

/obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	name = "铁甲骑兵头盔"
	desc = "一顶面容狰狞的头盔。"
	icon_state = "cathelm"
	item_state = "cathelm"
	icon = 'modular_deserttown/icons/clothing/head32x48.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/janissaryhelm
	name = "耶尼切里头盔"
	desc = "一顶风格过多的头盔。"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "mamhelm"
	max_integrity = 250
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	dropshrink = null

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
	name = "敞口马甲"
	desc = "一件皮马甲。这样穿着保护力不强。"
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
	name = "比什特长袍"
	desc = "兹班图典型的罩袍。"
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
	name = "灰色比什特长袍"
	icon_state = "bluethawb"
	item_state = "bluethawb"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "紫色比什特长袍"
	icon_state = "purplethawb"
	item_state = "purplethawb"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/merchantbisht
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	name = "行会比什特长袍"
	desc = "一件敞开的罩袍，以奢华丝绸制成。"
	armor = ARMOR_PADDED
	icon_state = "merbisht"
	item_state = "merbisht"
	color = null

/datum/crafting_recipe/roguetown/sewing/bisht
	name = "比什特长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/bisht/beige)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bisht/fancy
	name = "精致比什特长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey)
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	craftdiff = 4

//SHIRTS

//Easternclothes 
/obj/item/clothing/suit/roguetown/shirt/dress/thawb
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "索布长袍"
	desc = "一件宽松的兹班图罩袍。"
	armor = ARMOR_CLOTHING
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "thawb"
	item_state = "thawb"
	dropshrink = null

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
	name = "索布长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "金边索布长袍"
	desc = "一件宽松的兹班图罩袍。这件镶有金丝线装饰。"
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "thawbgold"
	item_state = "thawbgold"

/obj/item/clothing/suit/roguetown/shirt/dress/amiradress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "阿米拉长裙"
	desc = "红色裙装与束胸，绣有无尽精妙的金线图案，以轻如空气的丝绸制成。堪配兹班图的公主。"
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "dprince"
	item_state = "dprince"


/obj/item/clothing/suit/roguetown/shirt/sultan
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "苏丹长袍"
	desc = "兹班图苏丹的高贵长袍。"
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
	name = "苏丹娜长裙"
	desc = "兹班图苏丹娜的高贵长裙。"
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
	name = "兹班图魔导长袍"
	desc = "兹班图魔导的高贵长袍。"
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
	name = "头巾"
	desc = "一条长布，缠绕在头上。"
	color = null
	body_parts_covered = HEAD|HAIR|EARS|NECK
	flags_inv = HIDEHAIR|HIDEEARS
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "turban"
	item_state = "turban"
	dropshrink = null

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
	name = "头巾"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 1

/obj/item/clothing/head/roguetown/turban/fancypurple
	name = "华丽紫色头巾"
	desc = "一条长而奢华的布，缠绕在头上。"
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "purple_hood"
	item_state = "purple_hood"

/datum/crafting_recipe/roguetown/sewing/turban/fancy
	name = "华丽头巾"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/head/roguetown/tagelmust
	name = "塔杰尔穆斯特"
	desc = "一条长布缠绕在头上，并配有面纱。"
	body_parts_covered = HEAD|EARS|HAIR|NECK|NOSE|MOUTH
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "blue_hood"
	item_state = "blue_hood"

/datum/crafting_recipe/roguetown/sewing/tagelmust
	name = "塔杰尔穆斯特"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 3
//
/obj/item/clothing/head/roguetown/sultan
	name = "苏丹头巾"
	desc = "尽享其尊贵气派与宏伟之姿！"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	icon_state = "sultan"
	item_state = "sultan"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultan/merchant
	name = "商贾头巾"
	desc = "一顶宽大精美的头巾，以金钱能买到的最上等丝绸制成。"
	icon_state = "merchant"
	item_state = "merchant"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultan/amir
	name = "埃米尔头巾"
	desc = "柔软、奢华、宏伟，但最重要的是——尽显王侯风范。"
	icon_state = "amir"
	item_state = "amir"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultana
	name = "苏丹娜头饰"
	desc = "丝滑的兹班图丝绸头饰！"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "sultana"
	item_state = "sultana"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/jafar
	name = "兹班图魔导帽"
	desc = "尽享其尊贵气派与宏伟之姿！"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	icon_state = "jafar"
	item_state = "jafar"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR	
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD
//pants


/obj/item/clothing/under/roguetown/sirwal
	name = "西尔瓦裤"
	desc = "来自兹班图的宽松长裤。"
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
	name = "精致西尔瓦裤"
	desc = "来自兹班图的宽松长裤，以昂贵的异域色彩染成。"

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
	name = "西尔瓦裤"
	result = list(/obj/item/clothing/under/roguetown/sirwal)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 1

/obj/item/clothing/under/roguetown/thong
	name = "丁字裤"
	desc = "薄到几乎遮不住私处的内衣。勉强遮住。"
	gender = PLURAL
	icon = 'modular_deserttown/icons/clothing/pants.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/pants.dmi'
	icon_state = "thong"
	item_state = "thong"
	body_parts_covered = GROIN

/datum/crafting_recipe/roguetown/sewing/thong
	name = "丁字裤"
	result = list(/obj/item/clothing/under/roguetown/thong)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

//cloak
/obj/item/clothing/cloak/catcloak
	name = "铁甲骑兵披风"
	desc = "兹班图铁甲骑兵的尊贵红色披风"
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
	name = "埃米尔披风"
	desc = "一件轻如羽毛的丝绸红色披风，绣有金线图案。堪配兹班图的王子。"
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
	name = "埃米尔兜帽"
	desc = "一顶轻如羽毛的丝绸红色兜帽，绣有金线图案。堪配兹班图的王子。"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	block2add = FOV_BEHIND
	flags_inv = HIDEHAIR

/obj/item/clothing/cloak/dunestalker
	name = "沙丘行者披风"
	desc = "一件厚重的皮披风，以镀金别针固定，描绘着大苏丹家族的纹章。忠诚仆从的标志。"
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
	name = "耶尼切里披肩"
	desc = "一件轻便披风，以镀金徽章固定，描绘着大苏丹家族的纹章。忠诚仆从的标志。"
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "jan"
	item_state = "jan"

//////BELTS

/obj/item/storage/belt/rogue/leather/cloth/sash
	name = "简单兹班图腰带"
	desc = "一条简单的布腰带。"
	color = null
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "sashgrey"
	item_state = "sashgrey"

/datum/crafting_recipe/roguetown/sewing/zybsash
	name = "腰带（兹班图式）"
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
	name = "兹班图贵族腰带"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "noblesash"
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/zybnoblesash
	name = "腰带（兹班图贵族式）"
	result = list(/obj/item/storage/belt/rogue/leather/noblesash)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/storage/belt/rogue/leather/sultbelt
	name = "兹班图苏丹腰带"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "sultbelt"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/jafar
	name = "兹班图魔导腰带"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "jafar"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen
	name = "绿色异域丝绸裙"
	desc = "一条饰金腰带，配以最柔软的丝绸裙摆，勉强遮掩私处。"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "exoticsilkskirt2"
	item_state = "exoticsilkskirt2"

/datum/crafting_recipe/roguetown/sewing/skirtgreen
	name = "异域丝绸腰带（绿色）"
	result = list(/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
	name = "红色异域丝绸裙"
	desc = "一条饰金腰带，配以最柔软的丝绸裙摆，勉强遮掩私处。"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "exoticsilkskirt"
	item_state = "exoticsilkskirt"

/datum/crafting_recipe/roguetown/sewing/skirtred
	name = "异域丝绸腰带（红色）"
	result = list(/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

////////

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "exoticsilkbrag"
	item_state = "exoticsilkbrag"
	dropshrink = null

/datum/crafting_recipe/roguetown/sewing/bragreen
	name = "异域丝绸胸衣（绿色）"
	result = list(/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
	desc = "精致的金边丝绸，几乎遮不住它所覆盖的微末之处。长而飘逸的袖子从上臂垂至双手的指环，随风与每一个动作飘动。"
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "exoticsilkbrar"
	item_state = "exoticsilkbrar"
	dropshrink = null

/datum/crafting_recipe/roguetown/sewing/brared
	name = "异域丝绸胸衣（红色）"
	result = list(/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/mask/rogue/exoticsilkmask/green
	icon = 'modular_deserttown/icons/clothing/masks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/masks.dmi'
	icon_state = "exoticsilkmaskg"
	item_state = "exoticsilkmaskg"
	dropshrink = null

/datum/crafting_recipe/roguetown/sewing/maskgreen
	name = "异域丝绸面纱（绿色）"
	result = list(/obj/item/clothing/mask/rogue/exoticsilkmask/green)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/clothing/mask/rogue/exoticsilkmask/red
	icon = 'modular_deserttown/icons/clothing/masks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/masks.dmi'
	icon_state = "exoticsilkmaskr"
	item_state = "exoticsilkmaskr"

/datum/crafting_recipe/roguetown/sewing/maskred
	name = "异域丝绸面纱（红色）"
	result = list(/obj/item/clothing/mask/rogue/exoticsilkmask/red)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

//Because some people can't live without BiS
/obj/item/clothing/shoes/roguetown/shalal/reinforced
	name = "精致巴布什鞋"
	desc = "以鞣制皮革缝制而成的结实靴子。时髦、坚固，每一步都发出令人满意的嘎吱声。"
	icon_state = "shalal"//change when I get around to it
	item_state = "shalal"
	color = "#d4c7bf"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)	//Same as gloves
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER

	
/obj/item/clothing/shoes/roguetown/boots/armor/shalal
	name = "镶板巴布什鞋"
	desc = "以鞣制皮革缝制而成的结实靴子。时髦、坚固，每一步都发出令人满意的嘎吱声。"
	icon_state = "shalal"//change when I get around to it
	item_state = "shalal"
