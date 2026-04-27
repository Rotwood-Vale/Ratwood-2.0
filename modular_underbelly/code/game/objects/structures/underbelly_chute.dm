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
	var/credit = budgets[user.ckey] || 0
	if(!credit)
		to_chat(user, span_notice("No credit on file."))
		return
	var/list/choicez = list()
	if(credit >= 10)
		choicez += "GOLD"
	if(credit >= 5)
		choicez += "SILVER"
	choicez += "BRONZE"
	var/selection = input(user, "You have [credit] mammon on deposit. Choose which currency to withdraw.", src) as null|anything in choicez
	if(!selection)
		return
	var/mod = 1
	if(selection == "GOLD")
		mod = 10
	if(selection == "SILVER")
		mod = 5
	var/coin_amt = input(user, "You may withdraw up to [min(floor(credit / mod), 20)] [selection] coins.", src) as null|num
	coin_amt = round(coin_amt)
	if(coin_amt < 1)
		return
	if(coin_amt > 20)
		to_chat(user, span_warning("You can only withdraw up to 20 coins at once."))
		return
	if((coin_amt * mod) > (budgets[user.ckey] || 0))
		to_chat(user, span_warning("Insufficient credit."))
		return
	budgets[user.ckey] -= coin_amt * mod
	budget2change(coin_amt * mod, user, selection)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	to_chat(user, span_notice("The chute spits out [coin_amt] [lowertext(selection)] coin\s. Remaining credit: [budgets[user.ckey]]."))


