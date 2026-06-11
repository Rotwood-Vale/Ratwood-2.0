/////////////
//  Nails  //
////////////

/obj/item/construction/nail
	name = "钉子"
	desc = "一枚小钉子，用来把木头固定在别的东西上。"
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "nails1"
	grid_width = 32
	grid_height = 32
	attacked_sound = 'sound/foley/coinphy (1).ogg'
	drop_sound = 'sound/foley/coinphy (1).ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 1
	throwforce = 0
	dropshrink = 0.8
	obj_flags = null
	resistance_flags = FIRE_PROOF
	slot_flags = null
	max_integrity = 20
	w_class = WEIGHT_CLASS_TINY
	sellprice = 0
	bundletype = /obj/item/construction/bundle/nail
	slot_flags = ITEM_SLOT_MOUTH

/obj/item/construction/nail/attack_right(mob/living/user)
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("我开始收集[src]……"))
	if(move_after(user, 4 SECONDS, target = src))
		var/stackcount = 0
		for(var/obj/item/construction/nail/F in get_turf(src))
			stackcount++
		while(stackcount > 0)
			if(stackcount == 1)
				var/obj/item/construction/nail/S = new(get_turf(user))
				user.put_in_hands(S)
				stackcount--
			else if(stackcount >= 2)
				var/obj/item/construction/bundle/nail/B = new(get_turf(user))
				B.amount = clamp(stackcount, 2, 5)
				B.update_bundle()
				stackcount -= clamp(stackcount, 2, 5)
				user.put_in_hands(B)
		for(var/obj/item/construction/nail/F in get_turf(src))
			playsound(get_turf(user.loc), 'sound/foley/coinphy (1).ogg', 80)
			qdel(F)

/obj/item/construction/bundle/nail
	name = "一堆钉子"
	desc = "堆在一起的几枚钉子。"
	icon_state = "nail1"
	item_state = "plankbundle"
	icon = 'icons/roguetown/items/crafting.dmi'
	grid_width = 32
	grid_height = 32
	drop_sound = 'sound/foley/coinphy (1).ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 0
	dropshrink = 0.8
	throwforce = 0
	throw_range = 5
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	stackname = "钉子"
	stacktype = /obj/item/construction/nail
	maxamount = 5
	icon1 = "nails3"
	icon1step = 3
	icon2 = "nails"
	icon2step = 5
