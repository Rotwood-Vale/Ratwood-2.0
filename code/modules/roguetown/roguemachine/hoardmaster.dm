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
	/// ckey -> the category that player has open ("1" is the category menu). Per player, so one bandit's browsing never resets another's.
	var/list/current_cats = list()
	/// ckey -> world.time before which that player's refused purchases are logged but not alerted to admins
	var/list/refusal_alert_cooldowns = list()


/obj/structure/roguemachine/Hoardmaster/Initialize(mapload)
	. = ..()
	update_icon()
	var/namechance = rand(1,6)
	switch(namechance)
		if(1)
			name = "Hoardmaster Skyblue"
		if(2)
			name = "Hoardmaster Thea"
		if(3)
			name = "Hoardmaster Radagon"
		if(4)
			name = "Hoardmaster Shiver"
		if(5)
			name = "Hoardmaster Deathbringer"
		if(6)
			name = "Hoardmaster Darkstalker"

/obj/structure/roguemachine/Hoardmaster/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/bandit))
		. += "Formerly a covetous creature, this one now shares its Hoard with the Freefolk. Protecting the transactor's Hoard, and trading it for Favor."
		return
	else
		. += "Some mean looking statue of a dragon. Something about it makes me uneasy, like its eyes are following me."
		return

/obj/structure/roguemachine/Hoardmaster/Topic(href, href_list)
	. = ..()
	if(!HAS_TRAIT(usr, TRAIT_COMMIE))
		return
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(!ishuman(usr))
		return
	var/datum/antagonist/bandit/B = usr.mind?.has_antag_datum(/datum/antagonist/bandit)
	if(!B) // Matthios's other faithful share the trait, but only the band holds favor
		return
	if(href_list["buy"])
		var/mob/M = usr
		var/path = text2path(href_list["buy"])
		var/datum/supply_pack/PA = ispath(path, /datum/supply_pack) ? SSmerchant.supply_packs[path] : null
		// Only packs listed under a category this bandit has unlocked: the link can be edited to name any pack
		if(!PA || !(PA.group in unlocked_categories(M)))
			log_admin("[key_name(usr)] tried to buy [path] from the Hoardmaster, which is not in their unlocked categories.")
			if(world.time >= refusal_alert_cooldowns[usr.ckey]) // edited links can be clicked endlessly; alert admins once a minute per player
				refusal_alert_cooldowns[usr.ckey] = world.time + 1 MINUTES
				message_admins("[ADMIN_LOOKUPFLW(usr)] tried to buy [path] from the Hoardmaster, which is not in their unlocked categories.")
			return
		var/cost = PA.cost
		if(B.favor >= cost)
			B.favor -= cost
			playsound(loc, 'sound/misc/hoardmasterpurchase.ogg', 80, FALSE, -1)
		else
			say("Earn your keep first!")
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
		current_cats[usr.ckey] = href_list["changecat"]
	return attack_hand(usr)

/// The Hoardmaster categories user may browse and buy from: the shared three, plus their own bandit class's
/obj/structure/roguemachine/Hoardmaster/proc/unlocked_categories(mob/user)
	. = list("Supplies", "Medicaments", "Clothing")
	switch(user.advjob)
		if("Brigand")
			. += "Brigand"
		if("Sellsword")
			. += "Sellsword"
		if("Sawbones")
			. += "Sawbones"
		if("Hedge Knight")
			. += "Knight"
		if("Hedge Mage")
			. += "Mage"
		if("Knave")
			. += "Knave"
		if("Iconoclast")
			. += "Iconoclast"
		if("Pioneer")
			. += "Pioneer"

/obj/structure/roguemachine/Hoardmaster/attack_hand(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_COMMIE))
		return
	var/datum/antagonist/bandit/B = user.mind?.has_antag_datum(/datum/antagonist/bandit)
	if(!B) // Matthios's other faithful share the trait, but only the band trades here
		to_chat(user, span_warning("The Hoardmaster's eyes pass over me. It trades only with the Freefolk."))
		return
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/contents
	contents = "<center>Wishes for the Free<BR>"
	contents += "<a href='?src=[REF(src)];change=1'>Your favor:</a> [B.favor]<BR>"

	var/list/unlocked_cats = unlocked_categories(user)

	var/current_cat = current_cats[user.ckey] || "1"
	if(!(current_cat in unlocked_cats))
		current_cat = "1"
		current_cats[user.ckey] = current_cat

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
	desc = "Formerly a covetous creature, this one now shares its Hoard with the Freefolk. Protecting the transactor's Hoard, and trading it for Favor."
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"
	density = TRUE
	anchored = TRUE
