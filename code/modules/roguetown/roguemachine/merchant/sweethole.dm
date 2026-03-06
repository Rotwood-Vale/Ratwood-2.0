/obj/structure/roguemachine/cashface
	name = "CASHFACE"
	desc = "A machine that consumes goods and immediately returns mammons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank_empty"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0

/obj/structure/roguemachine/cashface/examine()
	. = ..()
	. += span_notice("Feed it goods by hand and it pays immediately.")
	. += span_notice("Only freeholders may operate it.")

/obj/structure/roguemachine/cashface/proc/can_use_cashface(mob/living/user)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_FREEHOLDER))
		to_chat(user, span_warning("[src] does not respond to non-freeholders."))
		return FALSE
	return TRUE
/obj/structure/roguemachine/cashface/attackby(obj/item/P, mob/user, params)
	if(!anchored)
		return ..()
	if(!can_use_cashface(user))
		return
	if(istype(P, /obj/item/roguecoin))
		to_chat(user, span_warning("[src] rejects coin."))
		return
	if(P.anchored)
		return ..()
	if(istype(P, /obj/structure/handcart))
		return ..()
	var/prize = round(P.get_real_price())
	if(prize < 1)
		to_chat(user, span_warning("[P] is worthless to [src]."))
		return
	user.visible_message(span_warning("[user] feeds [P] into [src]!"))
	qdel(P)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	budget2change(prize, get_turf(src))
	return

/obj/structure/roguemachine/freeholdinvite
	name = "Oathmarker"
	desc = "A solemn engine of blood and covenant, by which the willing are received into the people of the Freehold."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32

/obj/structure/roguemachine/freeholdinvite/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(HAS_TRAIT(H, TRAIT_FREEHOLDER))
		say("The mark is already upon you.")
		return

	var/choice = alert(user, "The machine offers to bind you with the mark of the Freehold. Will you accept it?", src.name, "Accept", "Decline")
	if(choice != "Accept")
		return

	if(!Adjacent(user))
		return

	to_chat(user, span_warning("The machine bites my finger."))
	icon_state = "atm-b"
	H.flash_fullscreen("redflash3")
	playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)

	ADD_TRAIT(H, TRAIT_FREEHOLDER, TRAIT_GENERIC)

	spawn(5)
		say("Blood accepted. The mark is yours.")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	return

/obj/structure/roguemachine/freeholdinvite/examine(mob/user)
	. += ..()
	. += span_info("Its needles wait for any willing hand.")
