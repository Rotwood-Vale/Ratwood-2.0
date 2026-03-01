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

	if(P.anchored || !isturf(P.loc))
		return ..()

	if(istype(P, /obj/structure/handcart))
		return ..()

	var/prize = round(P.get_real_price())
	if(prize < 1)
		to_chat(user, span_warning("[P] is worthless to [src]."))
		return

	record_round_statistic(STATS_TRADE_VALUE_EXPORTED, prize)

	P.visible_message(span_warning("[P] is swallowed by [src]!"))
	qdel(P)

	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	budget2change(prize, get_turf(src))
	return
