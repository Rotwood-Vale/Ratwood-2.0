//Mostly garbage related to the ending "cutscene"
/obj/item/clothing/head/roguetown/cyberdeck
	name = "赛博甲板头戴装置"
	desc = "做个好梦……"
	icon = 'icons/roguetown/maniac/clothing.dmi'
	mob_overlay_icon = 'icons/roguetown/maniac/clothing_mob.dmi'
	icon_state = "cyberdeck"
	armor = ARMOR_CLOTHING
	tint = TINT_BLIND //it covers ya eyes

/obj/item/clothing/head/roguetown/cyberdeck/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/roguetown/cyberdeck/dropped(mob/living/carbon/human/user)
	. = ..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/suit/roguetown/shirt/formal
	name = "正装衬衫"
	desc = "这是我所知最体面的公司制服。"
	icon = 'icons/roguetown/maniac/clothing.dmi'
	mob_overlay_icon = 'icons/roguetown/maniac/clothing_mob.dmi'
	icon_state = "shirt"
	dropshrink = null

/obj/item/clothing/under/roguetown/tights/formal
	name = "正装长裤"
	desc = "这是我所知最体面的公司制服。"
	gender = PLURAL
	icon = 'icons/roguetown/maniac/clothing.dmi'
	mob_overlay_icon = 'icons/roguetown/maniac/clothing_mob.dmi'
	icon_state = "pants"

/datum/outfit/treyliam
	name = "特雷·利亚姆"
	head = /obj/item/clothing/head/roguetown/cyberdeck
	shirt = /obj/item/clothing/suit/roguetown/shirt/formal
	pants = /obj/item/clothing/under/roguetown/tights/formal

/obj/effect/landmark/treyliam
	name = "trey"

/obj/item/gun/ballistic/revolver/last_resort
	name = "\proper 最后手段"
	desc = "总会有一条出路。"
