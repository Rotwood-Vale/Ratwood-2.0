/obj/structure/roguemachine/Hoardmaster
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "Hoardmaster"
	pixel_x = -32
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	var/upgrade_flags
	var/current_cat = "1"


/obj/structure/roguemachine/Hoardmaster/Initialize(mapload)
	. = ..()
	update_icon()
	var/namechance = rand(1,6)
	switch(namechance)
		if(1)
			name = "藏宝主宰 Skyblue"
		if(2)
			name = "藏宝主宰 Thea"
		if(3)
			name = "藏宝主宰 Radagon"
		if(4)
			name = "藏宝主宰 Shiver"
		if(5)
			name = "藏宝主宰 Deathbringer"
		if(6)
			name = "藏宝主宰 Darkstalker"

/obj/structure/roguemachine/Hoardmaster/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/bandit))
		. += "它曾是贪婪的生物，如今却与自由民分享自己的宝藏。它守护交易者的囤藏，并以此换取恩惠。"
		return
	else
		. += "一尊面相凶恶的龙形雕像。它让我有些不安，仿佛它的眼睛一直在盯着我。"
		return

/obj/structure/roguemachine/Hoardmaster/Topic(href, href_list)
	. = ..()
	if(!HAS_TRAIT(usr, TRAIT_COMMIE))
		return
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(!ishuman(usr))
		return
	if(href_list["buy"])
		var/mob/M = usr
		var/datum/antagonist/bandit/B = M.mind.has_antag_datum(/datum/antagonist/bandit)
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("silly MOTHERFUCKER [usr.key] IS TRYING TO BUY A [path] WITH THE HOARDMASTER")
			return
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		var/cost = PA.cost
		if(B.favor >= cost)
			B.favor -= cost
			playsound(loc, 'sound/misc/hoardmasterpurchase.ogg', 80, FALSE, -1)
		else
			say("先挣出你的身价再来！")
			return
		var/shoplength = PA.contains.len
		var/l
		for(l=1,l<=shoplength,l++)
			var/pathi = pick(PA.contains)
			var/atom/hmasteritem = new pathi(get_turf(M))
			hmasteritem.flags_1 |= HOARDMASTER_SPAWNED_1
			if(istype(hmasteritem, /obj/item))
				var/obj/item/newitem = hmasteritem
				newitem.sellprice = 0
				if(newitem.smeltresult)
					newitem.smeltresult = /obj/item/ash
				if(newitem.salvage_result)
					newitem.salvage_result = /obj/item/ash
	if(href_list["changecat"])
		current_cat = href_list["changecat"]
	return attack_hand(usr)

/obj/structure/roguemachine/Hoardmaster/attack_hand(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_COMMIE))
		return
	var/datum/antagonist/bandit/B = usr.mind.has_antag_datum(/datum/antagonist/bandit)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/contents
	contents = "<center>Wishes for the Free<BR>"
	contents += "<a href='?src=[REF(src)];change=1'>Your favor:</a> [B.favor]<BR>"


	var/list/unlocked_cats = list("Supplies", "Medicaments", "Clothing")
	switch(usr.advjob)
		if("Brigand")
			unlocked_cats+="Brigand"
		if("Sellsword")
			unlocked_cats+="Sellsword"
		if("Sawbones")
			unlocked_cats+="Sawbones"
		if("Hedge Knight")
			unlocked_cats+="Knight"
		if("Rogue Mage")
			unlocked_cats+="Mage"
		if("Knave")
			unlocked_cats+="Knave"
		if("Iconoclast")
			unlocked_cats+="Iconoclast"
		if("Pioneer")
			unlocked_cats+="Pioneer"

	if(!(current_cat in unlocked_cats))
		current_cat = "1"

	if(current_cat == "1")
		contents += "<center>"
		for(var/X in unlocked_cats)
			contents += "<a href='?src=[REF(src)];changecat=[X]'>[X]</a><BR>"
		contents += "</center>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == current_cat)
				pax += PA
		for(var/datum/supply_pack/PA in sortList(pax))
			contents += "[PA.name] [PA.contains.len > 1?"x[PA.contains.len]":""] - ([PA.cost])<a href='?src=[REF(src)];buy=[PA.type]'>BUY</a><BR>"

	var/datum/browser/popup = new(user, "HOARDMASTER", "", 370, 600)
	popup.set_content(contents)
	popup.open()


/obj/structure/roguemachine/hoardbarrier //Blocks sprite locations
	name = ""
	desc = "它曾是贪婪的生物，如今却与自由民分享自己的宝藏。它守护交易者的囤藏，并以此换取恩惠。"
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"
	density = TRUE
	anchored = TRUE
