/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

// DESIGN NOTE
// The copperface exists once in the forest ruins near the bandit exit.
// Prices are steeper to not necessarily give the merchant in town competition.
// The intended customers are wretches, bandits and other outlaws.
// This provides especially wretches reasons to harrass adventurers and get vital items they usually can't out of town like lockpicks, red or prosthetics

/obj/structure/roguemachine/blackmarket
	name = "COPPERFACE"
	desc = "Never gets tired, does not ask questions, only minor signs of tampering. Alas, fashioned with copper of low quality."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "copperface"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/held_items = list()
	locked = FALSE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = "1"
	var/list/categories = list(
		"General Labour",
		"Beverages",
		"Health and Hygiene"
	)
	var/list/categories_gamer = list(
		"Self Defense",
		"Diplomacy and Persuasion",
		"Exotic Import"
	)

/obj/structure/roguemachine/blackmarket/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/roguemachine/blackmarket/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))

/obj/structure/roguemachine/blackmarket/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/blackmarket/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["buy"])
		var/mob/M = usr
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("[usr.key] IS TRYING TO BUY A [path] WITH THE COPPERFACE. THIS SHOULDN'T BE POSSIBLE.")
			return
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		var/cost = PA.cost
		if(budget >= cost)
			budget -= cost
		else
			say("Not enough!")
			return
		var/shoplength = PA.contains.len
		var/l
		for(l=1,l<=shoplength,l++)
			var/pathi = pick(PA.contains)
			new pathi(get_turf(M))
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		current_cat = href_list["changecat"]
	return attack_hand(usr)

/obj/structure/roguemachine/blackmarket/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents = "<center>COPPERFACE - What's Yours.<BR>"
	contents += "<a href='?src=[REF(src)];change=1'>CURRENT BUDGET:</a> [budget]<BR>"
	contents += "</center><BR>"
	if(current_cat == "1")
		contents += "<table style='width: 100%' line-height: 20px;'>"
		for(var/i = 1, i <= categories.len, i++)
			contents += "<tr>"
			contents += "<td style='width: 50%; text-align: center;'>\
				<a href='?src=[REF(src)];changecat=[categories[i]]'>[categories[i]]</a>\
				</td>"
			if(i <= categories_gamer.len)
				contents += "<td style='width: 50%; text-align: center;'>\
					<a href='?src=[REF(src)];changecat=[categories_gamer[i]]'>[categories_gamer[i]]</a>\
				</td>"
			contents += "</tr>"
		contents += "</table>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == current_cat)
				pax += PA
		for(var/datum/supply_pack/PA in sortNames(pax))
			var/costy = PA.cost
			contents += "[PA.name] - ([costy])<a href='?src=[REF(src)];buy=[PA.type]'>BUY</a><BR>"

	if(!canread)
		contents = stars(contents)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 500, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/blackmarket/obj_break(damage_flag)
	..()
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "goldvendor0"

/obj/structure/roguemachine/blackmarket/Destroy()
	set_light(0)
	return ..()

/obj/structure/roguemachine/blackmarket/Initialize(mapload)
	. = ..()
	update_icon()

