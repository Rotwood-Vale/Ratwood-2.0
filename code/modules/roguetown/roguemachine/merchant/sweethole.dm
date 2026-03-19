/obj/structure/roguemachine/cashface
	name = "CASHFACE"
	desc = "A machine that consumes goods and stores their worth within."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank_empty"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	var/stored_mammon = 0

/obj/structure/roguemachine/cashface/examine(mob/user)
	. = ..()
	. += span_notice("Feed it goods by hand and it stores their value within (based on real_value of item).")
	. += span_notice("Only Freeholders may operate it.")
	. += span_notice("Coins are rejected.")
	. += span_notice("Stored mammon may be withdrawn here as bronze, silver, or gold.")
	if(ishuman(user) && HAS_TRAIT(user, TRAIT_FREEHOLDER))
		. += span_info("It currently stores [stored_mammon] mammon.")

/obj/structure/roguemachine/cashface/proc/can_use_cashface(mob/living/user)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_FREEHOLDER))
		to_chat(user, span_warning("[src] does not respond to non-freeholders."))
		return FALSE
	return TRUE

/obj/structure/roguemachine/cashface/attack_hand(mob/user)
	. = ..()
	if(!can_use_cashface(user))
		return .
	if(!Adjacent(user))
		return .
	if(stored_mammon < 1)
		say("Nothing is stored within.")
		return .

	var/list/choices = list()
	if(stored_mammon > 10)
		choices += "GOLD"
	if(stored_mammon > 5)
		choices += "SILVER"
	choices += "BRONZE"

	var/selection = input(user, "There are [stored_mammon] mammon stored within. Choose which currency you'd like to withdraw.", src) as null|anything in choices
	if(!selection)
		return .
	if(QDELETED(src) || QDELETED(user))
		return .
	if(!Adjacent(user))
		return .

	var/mod = 1
	if(selection == "GOLD")
		mod = 10
	if(selection == "SILVER")
		mod = 5

	var/coin_amt = input(user, "There are [stored_mammon] mammon stored within. You may withdraw [floor(stored_mammon / mod)] [selection] COINS.", src) as null|num
	coin_amt = round(coin_amt)
	if(coin_amt < 1)
		return .
	if(QDELETED(src) || QDELETED(user))
		return .
	if(!Adjacent(user))
		return .

	var/max_coins = 20
	if(coin_amt > max_coins)
		to_chat(user, span_warning("Maximum withdrawal limit exceeded. You can only withdraw up to [max_coins] coins at once."))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return .
	if((coin_amt * mod) > stored_mammon)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return .

	stored_mammon -= (coin_amt * mod)
	playsound(src, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	budget2change(coin_amt * mod, user, selection)
	return .

/obj/structure/roguemachine/cashface/attackby(obj/item/item_used, mob/user, params)
	. = ..()
	if(!anchored)
		return .
	if(!can_use_cashface(user))
		return .
	if(istype(item_used, /obj/item/roguecoin))
		to_chat(user, span_warning("[src] rejects coin."))
		return .
	if(item_used.anchored)
		return .
	if(istype(item_used, /obj/structure/handcart))
		return .

	var/prize = round(item_used.get_real_price())
	if(prize < 1)
		to_chat(user, span_warning("[item_used] is worthless to [src]."))
		return .

	user.visible_message(span_warning("[user] feeds [item_used] into [src]!"))
	qdel(item_used)
	stored_mammon += prize
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	say("[prize] mammon stored.")
	return .

/obj/structure/roguemachine/freeholdinvite
	name = "Oathmarker"
	desc = "A solemn engine of blood and covenant, by which the willing are received into the people of the Freehold."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32

/obj/structure/roguemachine/freeholdinvite/examine(mob/user)
	. = ..()
	. += span_info("Its needles wait for any willing hand.")
	. += span_notice("Here the willing may be bound into the people of the Freehold.")
	. += span_notice("It takes blood in token of the oath.")
	. += span_notice("Those already sworn cannot be marked anew.")
	. += span_notice("Any guardsman who takes the oath shall forfeit his former station.")
	. += span_notice("Those so marked are counted among the outlanders.")

/obj/structure/roguemachine/freeholdinvite/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		return .

	var/mob/living/carbon/human/human_user = user
	if(HAS_TRAIT(human_user, TRAIT_FREEHOLDER))
		say("The mark is already upon you.")
		return .

	var/choice = alert(human_user, "The machine offers to bind you with the mark of the Freehold. Will you accept it?", src.name, "Accept", "Decline")
	if(choice != "Accept")
		return .
	if(!Adjacent(human_user))
		return .

	to_chat(human_user, span_warning("The machine bites my finger."))
	icon_state = "atm-b"
	human_user.flash_fullscreen("redflash3")
	playsound(human_user, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)

	if(HAS_TRAIT(human_user, TRAIT_GUARDSMAN))
		REMOVE_TRAIT(human_user, TRAIT_GUARDSMAN, JOB_TRAIT)
	ADD_TRAIT(human_user, TRAIT_FREEHOLDER, TRAIT_GENERIC)
	ADD_TRAIT(human_user, TRAIT_OUTLANDER, TRAIT_GENERIC)

	spawn(5)
		say("Blood accepted. The mark is yours.")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

	return .
