/obj/structure/sacrificealtar
	name = "献祭祭坛"
	desc = ""
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "sacrificealtar"
	anchored = TRUE
	density = FALSE
	can_buckle = 1

/obj/structure/sacrificealtar/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!has_buckled_mobs())
		return
	var/mob/living/L = locate() in buckled_mobs
	if(!L)
		return
	to_chat(user, span_notice("我开始吟诵献祭仪式，试图将[L]作为祭品。"))
	L.gib()
	message_admins("[ADMIN_LOOKUPFLW(user)] has sacrificed [key_name_admin(L)] on the sacrificial altar at [AREACOORD(src)].")

/obj/structure/healingfountain
	name = "治疗喷泉"
	desc = ""
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "fountain"
	anchored = TRUE
	density = TRUE
	var/time_between_uses = 1800
	var/last_process = 0

/obj/structure/healingfountain/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("这座喷泉看起来已经空了。"))
		return
	last_process = world.time
	to_chat(user, span_notice("我触到的鲜血仍带着温热，而喷泉也随即迅速干涸了。"))
	user.reagents.add_reagent(/datum/reagent/medicine/healthpot,40)
	update_icon()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), time_between_uses)


/obj/structure/healingfountain/update_icon()
	if(last_process + time_between_uses > world.time)
		icon_state = "fountain"
	else
		icon_state = "fountain-red"
