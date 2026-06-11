///////////////
//Repair Kits//
///////////////

/obj/item/construction/repairkit/structure
	name = "建筑修理工具包"
	desc = "一套用于修理破损门窗的建筑修理工具包。技艺高超的木匠还能用它来加固它们。"
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "strucrepairkit"
	grid_width = 32
	grid_height = 32
	attacked_sound = 'sound/misc/woodhit.ogg'
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 1
	throwforce = 0
	obj_flags = null
	resistance_flags = FIRE_PROOF
	slot_flags = null
	max_integrity = 20
	w_class = WEIGHT_CLASS_NORMAL
	sellprice = 0

/obj/item/construction/repairkit/structure/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(!(isliving(user)))
		return
	if(!istype(user.get_active_held_item(), /obj/item/construction/repairkit/structure))
		return

	var/obj/item/construction/repairkit/structure/I = user.get_active_held_item()
	if(istype(O, /obj/structure/mineral_door/))
		var/obj/structure/mineral_door/doorrepair = O
		if(doorrepair.obj_integrity < doorrepair.max_integrity)
			to_chat(user, span_warning("[doorrepair.obj_integrity]"))	
			user.visible_message(span_notice("[user]开始修理[doorrepair.name]。"), \
			span_notice("我开始修理[doorrepair.name]。"))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (150 / user.get_skill_level(/datum/skill/craft/carpentry)), target = O)) // making this generic carpentry, even though it could be masonry
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				doorrepair.icon_state = "[doorrepair.base_state]"
				doorrepair.density = TRUE
				doorrepair.opacity = TRUE
				doorrepair.brokenstate = FALSE
				doorrepair.obj_broken = FALSE
				doorrepair.obj_integrity = doorrepair.max_integrity
				doorrepair.repair_state = 0		
				if(HAS_TRAIT(user,TRAIT_MASTER_CARPENTER)) //carpenter roles can buff the integrity of doors another 1000 over max
					doorrepair.obj_integrity = doorrepair.max_integrity	
					doorrepair.obj_integrity += 1000
				else
					doorrepair.obj_integrity = doorrepair.max_integrity							
				user.visible_message(span_notice("[user]修好了[doorrepair.name]。"), \
				span_notice("我修好了[doorrepair.name]。"))	
	if(istype(O, /obj/structure/roguewindow/))
		var/obj/structure/roguewindow/windowrepair = O
		if(windowrepair.obj_integrity < windowrepair.max_integrity)
			to_chat(user, span_warning("[windowrepair.obj_integrity]"))	
			user.visible_message(span_notice("[user]开始修理[windowrepair.name]。"), \
			span_notice("我开始修理[windowrepair.name]。"))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (150 / user.get_skill_level(/datum/skill/craft/carpentry)), target = O)) // making this generic carpentry, even though it could be masonry
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				windowrepair.icon_state = "[windowrepair.base_state]"
				windowrepair.density = TRUE
				//windowrepair.opacity = TRUE //we're boarding up the window on this, but leaving this out for now.
				windowrepair.brokenstate = FALSE
				windowrepair.obj_broken = FALSE
				if(HAS_TRAIT(user,TRAIT_MASTER_CARPENTER)) //carpenter roles can buff the integrity of windows another 500 over max
					windowrepair.obj_integrity = windowrepair.max_integrity
					windowrepair.obj_integrity += 500
				else
					windowrepair.obj_integrity = windowrepair.max_integrity						
				user.visible_message(span_notice("[user]修好了[windowrepair.name]。"), \
				span_notice("我修好了[windowrepair.name]。"))	
