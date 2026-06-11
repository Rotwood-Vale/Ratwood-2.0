/obj/item/clothing/neck
	name = "项链"
	icon = 'icons/obj/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40
	bloody_icon_state = "bodyblood"
	grid_width = 64
	grid_height = 32

/obj/item/clothing/neck/worn_overlays(isinhands = FALSE)
	. = list()
//	if(!isinhands)
//		if(body_parts_covered & HEAD)
//			if(damaged_clothes)
//				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
//			if(HAS_BLOOD_DNA(src))
//				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "领带"
	desc = ""
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = 15

/obj/item/clothing/neck/tie/blue
	name = "蓝色领带"
	icon_state = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "红色领带"
	icon_state = "redtie"

/obj/item/clothing/neck/tie/black
	name = "黑色领带"
	icon_state = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "糟糕的领带"
	desc = ""
	icon_state = "horribletie"

/obj/item/clothing/neck/tie/detective
	name = "松垮领带"
	desc = ""
	icon_state = "detective"

/obj/item/clothing/neck/stethoscope
	name = "听诊器"
	desc = ""
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]把[src]贴在[user.p_their()]胸口！看起来[user.p_they()]什么也听不到！"))
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.used_intent.type == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)

			var/heart_strength = span_danger("没有")
			var/lung_strength = span_danger("没有")

			var/obj/item/organ/heart/heart = M.getorganslot(ORGAN_SLOT_HEART)
			var/obj/item/organ/lungs/lungs = M.getorganslot(ORGAN_SLOT_LUNGS)

			if(!(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH))))
				if(heart && istype(heart))
					heart_strength = span_danger("不稳定的")
					if(heart.beating)
						heart_strength = "健康的"
				if(lungs && istype(lungs))
					lung_strength = span_danger("吃力的")
					if(!(M.failed_last_breath || M.losebreath))
						lung_strength = "平稳的"

			if(M.stat == DEAD && heart && world.time - M.timeofdeath < DEFIB_TIME_LIMIT * 10)
				heart_strength = span_boldannounce("微弱颤动的")

			var/diagnosis = (body_part == BODY_ZONE_CHEST ? "你听到了[heart_strength]脉搏和[lung_strength]呼吸。" : "你隐约听到了[heart_strength]脉搏。")
			user.visible_message(span_notice("[user]将[src]贴在[M]的[body_part]上，专注地听着。"), span_notice("我把[src]贴在[M]的[body_part]上。[diagnosis]"))
			return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "白色围巾"
	icon_state = "scarf"
	desc = ""
	dog_fashion = /datum/dog_fashion/head
	custom_price = 10

/obj/item/clothing/neck/scarf/black
	name = "黑色围巾"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/pink
	name = "粉色围巾"
	icon_state = "scarf"
	color = "#F699CD" //Pink

/obj/item/clothing/neck/scarf/red
	name = "红色围巾"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "绿色围巾"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "深蓝色围巾"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "紫色围巾"
	icon_state = "scarf"
	color = "#9557C5" //Purple

/obj/item/clothing/neck/scarf/yellow
	name = "黄色围巾"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "橙色围巾"
	icon_state = "scarf"
	color = "#C67A4B" //Orange

/obj/item/clothing/neck/scarf/cyan
	name = "青色围巾"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "斑马纹围巾"
	icon_state = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "圣诞围巾"
	icon_state = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "红色条纹围巾"
	icon_state = "stripedredscarf"
	custom_price = 10

/obj/item/clothing/neck/stripedgreenscarf
	name = "绿色条纹围巾"
	icon_state = "stripedgreenscarf"
	custom_price = 10

/obj/item/clothing/neck/stripedbluescarf
	name = "蓝色条纹围巾"
	icon_state = "stripedbluescarf"
	custom_price = 10

/obj/item/clothing/neck/petcollar
	name = "宠物项圈"
	desc = ""
	icon_state = "petcollar"
	var/tagname = null

/obj/item/clothing/neck/petcollar/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(ishuman(M))
		return FALSE
	return ..()

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = copytext(sanitize(input(user, "你想更改铭牌上的名字吗？", "Name your new pet", "小斑点") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "金项链"
	desc = ""
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/neckerchief
	icon = 'icons/obj/clothing/masks.dmi' //In order to reuse the bandana sprite
	w_class = WEIGHT_CLASS_TINY
	var/sourceBandanaType

/obj/item/clothing/neck/neckerchief/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/realOverlay = mutable_appearance('icons/mob/clothing/mask.dmi', icon_state)
		realOverlay.pixel_y = -3
		. += realOverlay

/obj/item/clothing/neck/neckerchief/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(SLOT_NECK) == src)
			to_chat(user, span_warning("我穿着[src]时没法把它解开！"))
			return
		if(user.is_holding(src))
			var/obj/item/clothing/mask/bandana/newBand = new sourceBandanaType(user)
			var/currentHandIndex = user.get_held_index_of_item(src)
			var/oldName = src.name
			qdel(src)
			user.put_in_hand(newBand, currentHandIndex)
			user.visible_message(span_notice("我把[oldName]解开，重新变成[newBand.name]。"), span_notice("[user]把[oldName]解开，重新变成[newBand.name]。"))
		else
			to_chat(user, span_warning("我必须先把[src]拿在手里才能解开它！"))
