GLOBAL_VAR(underbelly_chute)

/obj/structure/roguemachine/underbelly_chute
	name = "coin chute"
	desc = "A battered iron slot bolted to the wall. A crude sign above it reads: 'PAY THE MAN'."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "feedinghole"
	density = FALSE
	anchored = TRUE
	var/list/budgets = list()

/obj/structure/roguemachine/underbelly_chute/Initialize(mapload)
	. = ..()
	GLOB.underbelly_chute = src

/obj/structure/roguemachine/underbelly_chute/Destroy()
	GLOB.underbelly_chute = null
	return ..()

/obj/structure/roguemachine/underbelly_chute/attackby(obj/item/P, mob/user, params)
	if(!istype(P, /obj/item/roguecoin))
		return ..()
	budgets[user.ckey] = (budgets[user.ckey] || 0) + P.get_real_price()
	qdel(P)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	to_chat(user, span_notice("The coin clinks down into the chute. Credit: [budgets[user.ckey]]."))

/obj/structure/roguemachine/underbelly_chute/attack_hand(mob/user, list/modifiers)
	to_chat(user, span_notice("The chute has [budgets[user.ckey] || 0] mammon deposited for your ckey."))
