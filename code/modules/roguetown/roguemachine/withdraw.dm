/obj/structure/roguemachine/withdraw
	name = "vomitorium"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/stockpile_index = 1
	var/withdraw_title = "VOMITORIUM"
	var/free_withdraw = FALSE
	var/always_stocked = FALSE
	var/allow_remote = TRUE
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/withdraw/Initialize(mapload)
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(stockpile_index, src, build_stockpile_datums(), free_withdraw, always_stocked, allow_remote)

/obj/structure/roguemachine/withdraw/proc/build_stockpile_datums()
	return null

/obj/structure/roguemachine/withdraw/Destroy()
	SSroguemachine.stock_machines -= src
	return ..()

/obj/structure/roguemachine/withdraw/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy))
		return

	if(istype(P, /obj/item/roguecoin/inqcoin))	
		return

	if(istype(P, /obj/item/roguecoin))
		if(withdraw_tab?.free_withdraw)
			return
		if(!withdraw_tab)
			return
		withdraw_tab.insert_coins(P)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/withdraw/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(withdraw_tab.perform_action(href, href_list))
		if(href_list["withdraw"])
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			flick("submit_anim",src)
		return attack_hand(usr, "withdraw")
	return attack_hand(usr)

/obj/structure/roguemachine/withdraw/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/contents = withdraw_tab.get_contents(withdraw_title, FALSE)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/withdraw/kingsfield
	withdraw_title = "KINGSFIELD VOMITORIUM"
	free_withdraw = TRUE
	always_stocked = TRUE
	allow_remote = FALSE

/obj/structure/roguemachine/withdraw/kingsfield/build_stockpile_datums()
	var/list/stockpiles = list()
	for(var/path in subtypesof(/datum/roguestock/stockpile))
		var/datum/roguestock/stockpile/D = new path
		D.held_items[stockpile_index] = D.stockpile_limit
		stockpiles += D
	return stockpiles
