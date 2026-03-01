/obj/item/dildo
	name = "unfinished dildo"
	desc = "You have to finish it first."
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
	name = "unfinished [dildo_material] dildo"

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
		var/shape_choice = input(user, "Choose a shape for your dildo.","Dildo Shape") as null|anything in list("knotted", "human", "flared")
		if(src && shape_choice && !user.incapacitated() && in_range(user,src))
			dildo_type = shape_choice
	update_appearance()
	if(src && !user.incapacitated() && in_range(user,src))
		var/size_choice = input(user, "Choose a size for your dildo.","Dildo Size") as null|anything in list("small", "medium", "big")
		if(src && size_choice && !user.incapacitated() && in_range(user,src))
			dildo_size = size_choice
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
	name = "[dildo_size] [dildo_type] [dildo_material] dildo"
	desc = "To quench the woman's thirst."
	can_custom = FALSE

/obj/item/dildo/examine()
	. = ..()
	. += "[span_notice("It can be attached onto most belts.")]"

/obj/item/dildo/proc/do_silver_check(mob/living/victim)
	if(!is_silver || !HAS_TRAIT(victim, TRAIT_SILVER_WEAK))
		return
	SEND_SIGNAL(victim, COMSIG_FORCE_UNDISGUISE)
	var/datum/component/silverbless/blesscomp = GetComponent(/datum/component/silverbless)
	if(blesscomp?.is_blessed)
		if(!victim.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
			to_chat(victim, span_danger("Silver rebukes my presence! My vitae smolders, and my powers wane!"))
		victim.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
	else
		if(!victim.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
			to_chat(victim, span_danger("Blessed silver rebukes my presence! These fires are lashing at my very soul!"))
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
