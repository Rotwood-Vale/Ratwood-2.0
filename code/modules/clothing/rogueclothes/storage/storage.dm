/obj/item/storage/belt/rogue
	name = ""
	desc = ""
	icon = 'icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = ""
	item_state = ""
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("抽打", "鞭击")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	experimental_inhand = FALSE
	component_type = /datum/component/storage/concrete/roguetown/belt
	grid_width = 64
	grid_height = 64

/obj/item/storage/belt/rogue/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE
	..()

/obj/item/storage/belt/rogue/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/rogueweapon/huntingknife))
		var/obj/item/rogueweapon/huntingknife/K = W
		if(K.sheathe_icon)
			for(var/obj/item/rogueweapon/scabbard/sheath/sheath in contents)
				if(!sheath.sheathed) // if no weapon in there
					if(sheath.eat_sword(user, K, TRUE))
						user.visible_message(
							span_notice("[user]把[W]滑入了[src]的鞘中。"),
							span_notice("我把[W]滑入了[src]的鞘中。")
						)
						return
	..()	

/obj/item/storage/belt/rogue/leather
	name = "腰带"
	desc = "一条优质皮带，上面打好了孔，用以扣合固定。"
	icon_state = "leather"
	item_state = "leather"
	equip_sound = 'sound/blank.ogg'
	sewrepair = TRUE
	sellprice = 10
	resistance_flags = FIRE_PROOF
	dropshrink = 0.8

/obj/item/storage/belt/rogue/leather/plaquegold
	name = "饰牌腰带"
	icon_state = "goldplaque"
	sellprice = 50
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/storage/belt/rogue/leather/shalal
	name = "shalal腰带"
	icon_state = "shalal"
	sellprice = 5

/obj/item/storage/belt/rogue/leather/shalal/purple
	name = "紫色shalal腰带"
	icon_state = "shalal"
	color = CLOTHING_PURPLE
	sellprice = 5

/obj/item/storage/belt/rogue/leather/black
	name = "黑腰带"
	icon_state = "blackbelt"
	item_state = "blackbelt"
	sellprice = 10

/obj/item/storage/belt/rogue/leather/double
	name = "双腰带"
	desc = "一对缠在腰间的纤细黑色腰带。"
	icon_state = "belt_double"
	item_state = "belt_double"

/obj/item/storage/belt/rogue/leather/plaquesilver
	name = "银饰牌腰带"
	icon_state = "silverplaque"
	sellprice = 30
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	is_silver = TRUE

/obj/item/storage/belt/rogue/leather/battleskirt
	name = "布制军裙"
	icon_state = "battleskirt"
	sewrepair = FALSE
	detail_tag = "_belt"

/obj/item/storage/belt/rogue/leather/battleskirt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/storage/belt/rogue/leather/battleskirt/black
	color = CLOTHING_BLACK

/obj/item/storage/belt/rogue/leather/battleskirt/barbarian
	color = "#48443b"

/obj/item/storage/belt/rogue/leather/battleskirt/faulds
	name = "垂甲腰带"
	icon_state = "faulds"
	sewrepair = FALSE
	detail_tag = "_belt"

/obj/item/storage/belt/rogue/leather/steel
	name = "钢腰带"
	icon_state = "steelplaque"
	sellprice = 30
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/storage/belt/rogue/leather/steel/tasset
	name = "腿甲腰带"
	icon_state = "steeltasset"
	sellprice = 35

/obj/item/storage/belt/rogue/leather/rope
	name = "绳腰带"
	desc = "一段结实绳索被改造成腰带。总比没有强。"
	icon_state = "rope"
	item_state = "rope"
	color = "#b9a286"
	component_type = /datum/component/storage/concrete/roguetown/belt/cloth

/obj/item/storage/belt/rogue/leather/cloth
	name = "布腰带"
	desc = "一条两端打结的布带，临时充作腰带。总比没有强。"
	icon_state = "cloth"
	component_type = /datum/component/storage/concrete/roguetown/belt/cloth

/obj/item/storage/belt/rogue/leather/cloth/lady
	color = "#575160"

/obj/item/storage/belt/rogue/leather/cloth/bandit
	color = "#ff0000"
	component_type = /datum/component/storage/concrete/roguetown/belt

/obj/item/storage/belt/rogue/leather/sash
	name = "精制腰带"		//Like the cloth sash but with better storage. More expensive.
	desc = "由羊毛制成的柔韧腰带，专门用来紧紧缠住腰身，尤其受穿宽松上衣的旅人欢迎。"
	icon_state = "clothsash"
	item_state = "clothsash"

/obj/item/storage/belt/rogue/leather/suspenders/butler
	name = "背带"
	desc = "一副绕过肩膀的背带，用来固定裤子，而且不得不承认还挺时髦。"
	icon = 'icons/roguetown/clothing/belts.dmi'
	icon_state = "butlersuspenders"
	item_state = "butlersuspenders"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	slot_flags = ITEM_SLOT_BELT

/obj/item/storage/belt/rogue/leather/suspenders/butler/colored
	name = "suspenders"
	desc = "A pair of suspenders which go over the shoulders. Used for keeping one's pants in place in an admittably fashionable style."
	icon = 'icons/roguetown/clothing/belts.dmi'
	icon_state = "butlersuspenderscolorable"
	item_state = "butlersuspenderscolorable"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	slot_flags = ITEM_SLOT_BELT

/obj/item/storage/backpack/rogue/satchel
	sewrepair = TRUE

/obj/item/storage/backpack/rogue/satchel
	name = "挎包"
	desc = "朴素轻便，对肩膀友好，且容量可观。"
	icon_state = "satchel"
	item_state = "satchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 300
	sellprice = 10
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	component_type = /datum/component/storage/concrete/roguetown/satchel

/obj/item/storage/backpack/rogue/satchel/heartfelt
	populate_contents = list(
		/obj/item/natural/feather,
		/obj/item/paper,
	)

/obj/item/storage/backpack/rogue/satchel/otavan
	name = "Otava皮挎包"
	desc = "来自Otava、经久耐用的皮包，出自Psydon信仰的心脏地带。这就是Otava的上乘工艺。"
	icon_state = "osatchel"
	item_state = "osatchel"

/obj/item/storage/backpack/rogue/satchel/mule/PopulateContents()
	for(var/i in 1 to 3)
		switch(rand(1,4))
			if(1)
				new /obj/item/reagent_containers/powder/moondust_purest(src)
			if(2)
				new /obj/item/reagent_containers/powder/moondust_purest(src)
			if(3)
				new /obj/item/reagent_containers/powder/ozium(src)
			if(4)
				new /obj/item/reagent_containers/powder/spice(src)

/obj/item/storage/backpack/rogue/satchel/black
	color = CLOTHING_BLACK

/obj/item/storage/backpack/rogue/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE

/obj/item/storage/backpack/rogue/satchel/short
	name = "短挂挎包"
	desc = "一种可挂在腰带或裤装上的皮挎包，让肩膀不再承受负重。"
	icon_state = "satchelshort"
	item_state = "satchelshort"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP //Implement a check in the future that prevents more than one being worn at once.
	component_type = /datum/component/storage/concrete/roguetown/satchelshort

/obj/item/storage/backpack/rogue/satchel/beltpack
	name = "腰包" //Satchel that fits on the cloak or belt slot. Should be exceptionally rare for on-spawn loadouts, unless a flag's added to make it incompatable with regular satchels.
	desc = "一种贴在臀后的轻便挎包，让肩膀不必负重。传统上它常被当作腰带或披风位来穿戴。"
	icon_state = "gamesatchel" //Later down the line, take the unused belt-satchel onmob and rename it to 'gamesatchel'.
	item_state = "satchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BELT //Implement a check that prevents one from being worn on both slots at once. Another coder's duty, I think.
	edelay_type = 1
	equip_delay_self = 10
	max_integrity = 300
	component_type = /datum/component/storage/concrete/roguetown/satchel

/obj/item/storage/backpack/rogue/backpack
	name = "背包"
	desc = "携带大量物品同时解放双手的最佳方式之一。"
	icon_state = "backpack"
	item_state = "backpack"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	max_integrity = 300
	sellprice = 15
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	component_type = /datum/component/storage/concrete/roguetown/backpack

/obj/item/storage/backpack/rogue/artibackpack
	name = "冷却背包"
	desc = "一只内部布满复杂管路的皮背包。它不断发出低鸣并轻微震动。"
	icon_state = "artibackpack"
	item_state = "artibackpack" 
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	component_type = /datum/component/storage/concrete/roguetown/backpack

/obj/item/storage/backpack/rogue/backpack/bagpack
	name = "行囊"
	desc = "一只用绳子束起的口袋。只要扎紧了，就能甩到肩上背着走。"
	icon_state = "rucksack_untied"
	item_state = "rucksack"
	component_type = /datum/component/storage/concrete/roguetown/sack/bag
	max_integrity = 100
	var/tied = FALSE

/obj/item/storage/backpack/rogue/backpack/bagpack/attack_right(mob/user)
	tied = !tied
	to_chat(user, span_info("我[tied ? "扎紧" : "松开"]了行囊。"))
	playsound(src, 'sound/foley/equip/rummaging-01.ogg', 100)
	update_icon()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(tied)
		STR.click_gather = FALSE
		STR.allow_quick_gather = FALSE
		STR.allow_quick_empty = FALSE
	else
		STR.click_gather = TRUE
		STR.allow_quick_gather = TRUE
		STR.allow_quick_empty = TRUE

/obj/item/storage/backpack/rogue/backpack/bagpack/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!tied && (slot == SLOT_BACK_L || slot == SLOT_BACK_R))
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		var/list/things = STR.contents()
		if(length(things))
			visible_message(span_warning("这只松开的袋子在甩上[user]肩头时把里面的东西全倒了出来！"))
			STR.quick_empty(user)

/obj/item/storage/backpack/rogue/backpack/bagpack/update_icon()
	. = ..()
	if(tied)
		icon_state = "rucksack_tied_sling"
	else
		icon_state = "rucksack_untied"

/obj/item/storage/belt/rogue/leather/plaquegold/steward
	name = "华丽金腰带"
	desc = "一条深色腰带，扣具与装饰都是真金打造。真够阔气。"
	icon_state = "stewardbelt"
	item_state = "stewardbelt"

//Knifeblade belts, act as quivers mixed with belts. Lower storage size of a belt, but holds knives without taking space.
/obj/item/storage/belt/rogue/leather/knifebelt
	name = "飞刃腰带"
	desc = "专为飞刀设计的五槽腰带，几乎不剩多少额外空间。"
	icon_state = "knife"
	item_state = "knife"
	strip_delay = 20
	var/max_storage = 5			//Javelin bag is 4 and they can't hold items. So, more fair having it like this since these are pretty decent weapons.
	var/list/knives = list()
	component_type = /datum/component/storage/concrete/roguetown/belt/knife_belt

/obj/item/storage/belt/rogue/leather/knifebelt/attack_turf(turf/T, mob/living/user)
	if(knives.len >= max_storage)
		to_chat(user, span_warning("你的[src.name]已经满了！"))
		return
	to_chat(user, span_notice("你开始收拢这些弹药……"))
	for(var/obj/item/rogueweapon/huntingknife/throwingknife/K in T.contents)
		if(do_after(user, 5))
			if(!eatknife(K))
				break

/obj/item/storage/belt/rogue/leather/knifebelt/proc/eatknife(obj/A)
	if(A.type in typesof(/obj/item/rogueweapon/huntingknife/throwingknife))
		if(knives.len < max_storage)
			A.forceMove(src)
			knives += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/storage/belt/rogue/leather/knifebelt/attackby(obj/A, loc, params)
	if(A.type in typesof(/obj/item/rogueweapon/huntingknife/throwingknife))
		if(knives.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			knives += A
			update_icon()
			to_chat(usr, span_notice("我悄悄把[A]塞进了[src]。"))
		else
			to_chat(loc, span_warning("满了！"))
		return
	..()

/obj/item/storage/belt/rogue/leather/knifebelt/attack_right(mob/user)
	if(knives.len)
		var/obj/O = knives[knives.len]
		knives -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/storage/belt/rogue/leather/knifebelt/examine(mob/user)
	. = ..()
	if(knives.len)
		. += span_notice("里面有[knives.len]把。")

/obj/item/storage/belt/rogue/leather/knifebelt/iron/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black
	icon_state = "blackknife"
	item_state = "blackknife"

/obj/item/storage/belt/rogue/leather/knifebelt/black/iron/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/steel/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/steel/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/silver/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/silver/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/psydon/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/psydon/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/kazengun/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/exoticsilkbelt
	name = "异域丝绸腰带"
	desc = "以黄金点缀、配有极柔软丝绸的腰带，几乎遮不住身上的关键部位。"
	icon_state = "exoticsilkbelt"
	var/max_storage = 5

///////////////////////////////////////////////

/obj/item/storage/hip/headhook
	name = "头颅挂钩"
	desc = "一个能挂放6颗头颅的铁钩。"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi' //N/A uncomment when a mob_overlay icon is made and added
	icon_state = "ironheadhook"
	item_state = "ironheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	dropshrink = 0.8
	//content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/iron
	component_type = /datum/component/storage/concrete/grid/headhook

/obj/item/storage/hip/headhook/bronze
	name = "青铜头颅挂钩"
	desc = "一个能挂放12颗头颅的青铜钩。"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "bronzeheadhook"
	item_state = "bronzeheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 400
	equip_sound = 'sound/blank.ogg'
	//content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/bronze
	component_type = /datum/component/storage/concrete/grid/headhook/bronze

/obj/item/clothing/climbing_gear
	name = "攀爬装备"
	desc = "让你做到本不可能做到的事。"
	color = null
	icon = 'icons/roguetown/clothing/storage.dmi'
	item_state = "climbing_gear" // sprites from lfwb kitbashed with grappler for inventory sprite
	icon_state = "climbing_gear" // sprites from lfwb kitbashed among each other for onmob sprite
	alternate_worn_layer = UNDER_CLOAK_LAYER
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK

/obj/item/clothing/climbing_gear/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	playsound(loc, 'sound/items/garrotegrab.ogg', 100, TRUE)

/obj/item/storage/hip/orestore/bronze
	name = "机械化矿石袋"
	desc = "一只能滴答作响、用于分类压缩矿石、锭块与宝石的矿袋。"
	icon = 'icons/roguetown/items/misc.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "rucksack"
	item_state = "rucksack"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 400
	equip_sound = 'sound/blank.ogg'
	//content_overlays = FALSE
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/bronze
	component_type = /datum/component/storage/concrete/grid/orestore/bronze
