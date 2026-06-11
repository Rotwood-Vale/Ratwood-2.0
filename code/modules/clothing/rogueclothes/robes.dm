/obj/item/clothing/suit/roguetown/shirt/robe
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "长袍"
	desc = ""
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "white_robe"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	boobed = TRUE
	flags_inv = HIDEBOOB|HIDECROTCH
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	experimental_inhand = FALSE
	dropshrink = null
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe/astrata
	name = "日辉长袍"
	icon_state = "astratarobe"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor //thanks to cre for abyssor clothing sprites
	name = "深渊长袍"
	icon_state = "abyssorrobe"

/obj/item/clothing/suit/roguetown/shirt/robe/noc
	name = "月辉长袍"
	icon_state = "nocrobe"

/obj/item/clothing/suit/roguetown/shirt/robe/necromancer
	name = "死灵法师长袍"
	icon_state = "necromrobe"

/obj/item/clothing/suit/roguetown/shirt/robe/dendor
	name = "荆棘长袍"
	icon_state = "dendorrobe"

/obj/item/clothing/suit/roguetown/shirt/robe/necra
	name = "悼亡长袍"
	icon_state = "necrarobe"

/obj/item/clothing/suit/roguetown/shirt/robe/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/robe/priest
	name = "圣日法衣"
	desc = "由神圣之手祝圣的法衣。若你并非信徒，最好谨慎一些。"
	icon_state = "priestrobe"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	armor = ARMOR_PADDED	//Equal to gamby

/obj/item/clothing/suit/roguetown/shirt/robe/priest/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CHOSEN, "VESTMENTS")

/obj/item/clothing/suit/roguetown/shirt/robe/priest/equipped(mob/living/user, slot)
	..()
	if(slot != SLOT_ARMOR|SLOT_SHIRT)
		return
	if(!HAS_TRAIT(user, TRAIT_CHOSEN)) //Requires this cus it's a priest-only thing.
		return
	ADD_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("持守清贫誓言并披上法衣后，我感到精力充沛，仿佛得到了神明加护！"))

/obj/item/clothing/suit/roguetown/shirt/robe/priest/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("我必须脱下长袍稍作歇息；即便是神选之人也需要休息……"))

//This for adventurers. Base type, same armor. No holy-bonus.
/obj/item/clothing/suit/roguetown/shirt/robe/monk
	name = "游僧法衣"
	desc = "为将信仰置于万事之上的人所穿的游行法衣。厚织并加垫的粗麻布可抵御朝圣途中可能遭遇的各种威胁，无论是刺骨严寒还是箭雨齐发。"
	icon_state = "priestunder"
	item_state = "priestunder"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	armor = ARMOR_PADDED_GOOD	//Equal to a padded gambeson, like before.
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)	 //Ensures that this inherits the padded gambeson's resistances, too.
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT

//This is for templars/psydonites. Gives a boon for wearing it to counter-act giving up plate and such.
/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	name = "圣洁僧侣法衣"
	desc = "圣洁法衣，属于将信仰置于一切之上的人。数百条厚重皮革被细致裁切并缝在布面上，带来无与伦比的舒适与防护。据说披上此衣者将永不知疲倦，这是坚不可摧之信念的恩赐。"
	icon_state = "monkvestments"
	item_state = "monkvestments"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/equipped(mob/living/user, slot)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN))	//Requires this cus it's a monk-only thing.
		return
	ADD_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("持守清贫誓言并披上法衣后，我感到精力充沛，仿佛得到了神明加护！"))

/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("我必须脱下长袍稍作歇息；即便是神选之人也需要休息……"))

/obj/item/clothing/suit/roguetown/shirt/robe/courtmage
	color = "#6c6c6c"

/obj/item/clothing/suit/roguetown/shirt/robe/mage/Initialize(mapload)
	color = pick("#4756d8", "#759259", "#bf6f39", "#c1b144", "#b8252c")
	. = ..()

/obj/item/clothing/suit/roguetown/shirt/robe/mageblue
	color = "#4756d8"

/obj/item/clothing/suit/roguetown/shirt/robe/magegreen
	color = "#759259"

/obj/item/clothing/suit/roguetown/shirt/robe/mageorange
	color = "#bf6f39"

/obj/item/clothing/suit/roguetown/shirt/robe/magered
	color = "#b8252c"

/obj/item/clothing/suit/roguetown/shirt/robe/mageyellow
	color = "#c1b144"

/obj/item/clothing/suit/roguetown/shirt/robe/merchant
	name = "行会外衣"
	icon_state = "merrobe"
	sellprice = 30
	color = null

/obj/item/clothing/suit/roguetown/shirt/robe/nun
	name = "修女服"
	color = null
	icon_state = "nun"
	item_state = "nun"
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/suit/roguetown/shirt/robe/wizard
	name = "法师长袍"
	desc = "宽大飘逸并绣有金色星纹的长袍，非常适合习艺中的法师。"
	icon_state = "wizardrobes"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 100

/obj/item/clothing/suit/roguetown/shirt/robe/physician
	name = "瘟疫医师外衣"
	desc = "以医术对抗病痛。"
	icon_state = "physcoat"
	slot_flags = ITEM_SLOT_ARMOR
	flags_inv = HIDEBOOB|HIDETAIL
	resistance_flags = FIRE_PROOF

//Eora content from Stonekeep

/obj/item/clothing/suit/roguetown/shirt/robe/eora
	name = "Eora长袍"
	desc = "供Eora信徒穿着的圣袍。"
	icon_state = "eorarobes"
	flags_inv = HIDEBOOB|HIDECROTCH
	var/fanatic_wear = FALSE

/obj/item/clothing/suit/roguetown/shirt/robe/eora/alt
	name = "敞开的Eora长袍"
	desc = "由Eora教会中更激进的信徒所穿。"
	body_parts_covered = null
	icon_state = "eorastraps"
	flags_inv = HIDEBOOB
	fanatic_wear = TRUE

/obj/item/clothing/suit/roguetown/shirt/robe/eora/attack_right(mob/user)
	switch(fanatic_wear)
		if(FALSE)
			name = "敞开的Eora长袍"
			desc = "由Eora教会中更激进的信徒所穿。"
			body_parts_covered = null
			icon_state = "eorastraps"
			fanatic_wear = TRUE
			flags_inv = HIDEBOOB
			to_chat(usr, span_warning("现在以激进方式穿着！"))
		if(TRUE)
			name = "Eora长袍"
			desc = "供Eora信徒穿着的圣袍。"
			body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
			icon_state = "eorarobes"
			fanatic_wear = FALSE
			flags_inv = HIDEBOOB|HIDECROTCH
			to_chat(usr, span_warning("现在以正常方式穿着！"))
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	name = "大祭司坎迪斯袍"
	desc = "穿在长袍内侧的一层薄布，可防止摩擦，也能在狂风袭来时保住体面。尽管布料轻薄，却仍能提供不错的保护。"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)
	armor = ARMOR_PADDED_GOOD
	armor_class = ARMOR_CLASS_LIGHT
	icon_state = "desertgown"
	item_state = "desertgown"
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	name = "最高祭司卡巴袍"
	desc = "以精细丝绸与布料制成的修身紧致长袍。不知为何，穿着它时你比赤身裸体还更灵活。尽管布料轻薄，却仍有可观防护。"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)
	armor = ARMOR_PADDED_GOOD
	armor_class = ARMOR_CLASS_LIGHT
	icon_state = "monkcloth"
	item_state = "monkcloth"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe/feld
	name = "军医长袍"
	desc = "做成红色，好把血迹遮住。"
	icon_state = "feldrobe"
	item_state = "feldrobe"

/obj/item/clothing/suit/roguetown/shirt/robe/phys
	name = "医师长袍"
	desc = "一半像长袍，一半像屠夫围裙。"
	icon_state = "surgrobe"
	item_state = "surgrobe"

// Agnostic versions of the unused robes, for use in the Loadout.

/obj/item/clothing/suit/roguetown/shirt/robe/tabardscarlet
	name = "绯红罩袍"
	desc = "无袖长袍，颜色如玫瑰一般。"
	color = null
	icon_state = "feldrobe"
	item_state = "feldrobe"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/suit/roguetown/shirt/robe/tabardblack
	name = "黑色罩袍"
	desc = "无袖长袍，色泽如木炭。"
	color = null
	icon_state = "surgrobe"
	item_state = "surgrobe"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite
	name = "白色罩袍"
	desc = "无袖长袍，白得如同骨骼。"
	color = null
	icon_state = "whiterobe"
	item_state = "whiterobe"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
