/obj/item/dildo
	name = "未完成的假阳具"
	desc = "你得先把它做完。"
	icon = 'modular/icons/obj/lewd/dildo.dmi'
	icon_state = "unfinished"
	item_state = "dildo"
	lefthand_file = 'modular/icons/mob/inhands/lewd/items_lefthand.dmi'
	righthand_file = 'modular/icons/mob/inhands/lewd/items_righthand.dmi'
	force = 1
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CAN_BE_HIT
	sellprice = 1
	var/dildo_type = "human"
	var/dildo_size = "small"
	var/pleasure = 4
	var/can_custom = TRUE
	var/dildo_material
	var/is_attached_to_belt = FALSE // used to track attached toys so they can't be attached to more than one belt

/obj/item/dildo/New()
	. = ..()
	name = "未完成的[dildo_material == "wooden" ? "木制" : dildo_material == "iron" ? "铁制" : dildo_material == "copper" ? "铜制" : dildo_material == "steel" ? "钢制" : dildo_material == "bronze" ? "青铜制" : dildo_material == "silver" ? "银制" : dildo_material == "golden" ? "金制" : dildo_material == "blacksteel" ? "黑钢制" : "未知材质"]假阳具"

/obj/item/dildo/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(can_custom)
		customize(user)

/obj/item/dildo/proc/customize(mob/living/user)
	if(!can_custom)
		return FALSE
	if(src && !user.incapacitated() && in_range(user,src))
		var/shape_choice = input(user, "为你的假阳具选择形状。","假阳具形状") as null|anything in list("打结", "人形", "喇叭口")
		if(src && shape_choice && !user.incapacitated() && in_range(user,src))
			dildo_type = shape_choice == "打结" ? "knotted" : shape_choice == "人形" ? "human" : "flared"
	update_appearance()
	if(src && !user.incapacitated() && in_range(user,src))
		var/size_choice = input(user, "为你的假阳具选择尺寸。","假阳具尺寸") as null|anything in list("小型", "中型", "大型")
		if(src && size_choice && !user.incapacitated() && in_range(user,src))
			dildo_size = size_choice == "小型" ? "small" : size_choice == "中型" ? "medium" : "big"
			switch(dildo_size)
				if("small")
					pleasure = 4
				if("medium")
					pleasure = 6
				if("big")
					pleasure = 8
	update_appearance()
	return TRUE

/obj/item/dildo/proc/update_appearance()
	icon_state = "dildo_[dildo_type]_[dildo_size]"
	name = "[dildo_size == "small" ? "小型" : dildo_size == "medium" ? "中型" : "大型"][dildo_type == "knotted" ? "打结" : dildo_type == "human" ? "人形" : "喇叭口"][(dildo_material == "wooden") ? "木制" : (dildo_material == "iron") ? "铁制" : (dildo_material == "copper") ? "铜制" : (dildo_material == "steel") ? "钢制" : (dildo_material == "bronze") ? "青铜制" : (dildo_material == "silver") ? "银制" : (dildo_material == "golden") ? "金制" : (dildo_material == "blacksteel") ? "黑钢制" : "未知材质"]假阳具"
	desc = "用来纾解欲火。"
	can_custom = FALSE

/obj/item/dildo/examine()
	. = ..()
	. += "[span_notice("它可以装到大多数腰带和贞操装置上。")]"

/obj/item/dildo/afterattack(atom/target, mob/user, proximity_flag, click_parameters)  // lets you mount the dildo directly onto a chastity device or belt by clicking on the mob wearing it with the dildo in hand
	. = ..()
	if(!proximity_flag || !ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	var/obj/item/chastity/device = H.chastity_device
	if(!istype(device) || device.attached_toy || is_attached_to_belt)
		return
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		to_chat(user, span_warning("[H]的腹股沟部位无法接触！"))
		return
	if(!user.transferItemToLoc(src, null))
		to_chat(user, span_warning("[src]粘在你的手上了！"))
		return
	if(device.attach_toy(src, user))
		user.visible_message(span_warning("[user]把[src]装到了[H]的[device]上。"))

/obj/item/dildo/proc/do_silver_check(mob/living/victim)
	if(!is_silver || !HAS_TRAIT(victim, TRAIT_SILVER_WEAK))
		return
	SEND_SIGNAL(victim, COMSIG_FORCE_UNDISGUISE)
	var/datum/component/silverbless/blesscomp = GetComponent(/datum/component/silverbless)
	if(blesscomp?.is_blessed)
		if(!victim.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
			to_chat(victim, span_danger("银器在排斥我的存在！我的命髓在闷燃，力量也在衰退！"))
		victim.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
	else
		if(!victim.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
			to_chat(victim, span_danger("受祝圣的银器在排斥我的存在！这火焰正鞭笞着我的灵魂！"))
		victim.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)
	victim.ignite_mob()

/obj/item/dildo/wood
	color = "#7D4033"
	resistance_flags = FLAMMABLE
	dildo_material = "wooden"
	sellprice = 1

/obj/item/dildo/iron
	color = "#9EA48E"
	dildo_material = "iron"
	sellprice = 5

/obj/item/dildo/copper
	color = "#8C4734"
	dildo_material = "copper"
	sellprice = 5

/obj/item/dildo/steel
	color = "#9BADB7"
	dildo_material = "steel"
	sellprice = 10

/obj/item/dildo/bronze
	color = "#cbbf9a"
	dildo_material = "bronze"
	sellprice = 12

/obj/item/dildo/silver
	color = "#C6D5E1"
	dildo_material = "silver"
	sellprice = 30
	is_silver = TRUE

/obj/item/dildo/gold
	color = "#c4b651"
	dildo_material = "golden"
	sellprice = 50

/obj/item/dildo/blacksteel
	color = "#A2CBE3"
	dildo_material = "blacksteel"
	sellprice = 150
