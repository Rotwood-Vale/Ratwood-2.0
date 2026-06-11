/obj/item/clothing/head/roguetown/helmet/heavy/astratan
	name = "阿斯特拉塔头盔"
	desc = "鎏金与镀银的金属交相辉映，这顶受祝圣的头盔散发着属于阿斯特拉塔圣战士的明亮炽烈色彩。"
	icon_state = "astratanhelm"
	item_state = "astratahnelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2


/obj/item/clothing/head/roguetown/helmet/heavy/malum
	name = "玛勒姆之盔"
	desc = "这顶头盔锻成煤黑之色，面甲上铭有一柄带徽记的利刃，时刻提醒着佩戴者玛勒姆那强而有力的注视。"
	icon_state = "malumhelm"
	item_state = "malumhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2


/obj/item/clothing/head/roguetown/helmet/heavy/necran
	name = "内克拉头盔"
	desc = "这是最幽深的黑色。这顶带兜盔让人联想到刽子手的头颅，使见者不禁心生恐惧，仿佛自己也将很快面对冥下少女。"
	icon_state = "necranhelm"
	item_state = "necranhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/pestran
	name = "佩斯特拉头盔"
	desc = "这是她的圣殿武士所佩戴的兜帽头盔，无论疫病横行之时还是鏖战正酣之际都极为合适。"
	icon_state = "pestranhelm"
	item_state = "pestranhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/pestran/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_NOSTINK, "[type]")

/obj/item/clothing/head/roguetown/helmet/heavy/pestran/dropped(mob/living/carbon/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_NOSTINK, "[type]")

/obj/item/clothing/head/roguetown/helmet/heavy/eoran
	name = "伊欧拉头盔"
	desc = "这顶以柔和粉色与米色打造的头盔呈现出一副美丽面容，使人想起伊欧拉的优雅。"
	icon_state = "eorahelm"
	item_state = "eorahelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
