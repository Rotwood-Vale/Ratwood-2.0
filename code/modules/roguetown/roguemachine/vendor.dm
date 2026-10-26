/obj/structure/roguemachine/vendor
	parent_type = /obj/structure/roguemachine/shop
	name = "PEDDLER"
	desc = "The stomach of this thing can been stuffed with fun things for you to buy."
	tgui_id = "Peddler"
	var/list/held_items = list()
	var/max_items = 60
	/// Items still waiting on a UI icon, flattened a few per tick so bulk loads don't lag
	var/list/icon_queue = list()
	var/generating_icons = FALSE

/obj/structure/roguemachine/vendor/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	held_items -= gone
	icon_queue -= gone

/// Items of the same type sold under the same name are one product group
/obj/structure/roguemachine/vendor/proc/make_group_key(item_type, item_name)
	return "[item_type]_[item_name]"

/obj/structure/roguemachine/vendor/proc/group_key(obj/item/I)
	return make_group_key(I.type, held_items[I]["NAME"] || I.name)

/// Returns the held_items keys (actual obj/item refs) belonging to the given group key
/obj/structure/roguemachine/vendor/proc/get_group_items(key)
	var/list/matches = list()
	for(var/obj/item/O in held_items)
		if(group_key(O) == key)
			matches += O
	return matches

/obj/structure/roguemachine/vendor/proc/is_full()
	return length(held_items) >= max_items

/// Records an item that is already inside, priced like the group it joins unless a price is given
/obj/structure/roguemachine/vendor/proc/store_item(obj/item/P, price)
	var/list/group = get_group_items(make_group_key(P.type, P.name))
	if(isnull(price))
		price = length(group) ? held_items[group[1]]["PRICE"] : 0
	// joining a group shares its icon; kept per item so renaming the group doesn't lose it
	var/icon_data = length(group) ? held_items[group[1]]["ICON"] : null
	held_items[P] = list("NAME" = P.name, "PRICE" = price, "ICON" = icon_data)
	if(!icon_data)
		icon_queue += P
		if(!generating_icons)
			INVOKE_ASYNC(src, PROC_REF(generate_icons))

/// Flattens the queued items' icons for the UI, spread across ticks
/obj/structure/roguemachine/vendor/proc/generate_icons()
	generating_icons = TRUE
	while(length(icon_queue))
		var/obj/item/I = icon_queue[1]
		icon_queue.Cut(1, 2)
		// gone, or given its group's icon while it waited
		if(!held_items[I] || held_items[I]["ICON"])
			continue
		var/icon_data = icon2base64(getFlatIcon(I, no_anim = TRUE))
		for(var/obj/item/O as anything in get_group_items(group_key(I)))
			if(!held_items[O]["ICON"])
				held_items[O]["ICON"] = icon_data
		CHECK_TICK
		if(QDELETED(src))
			return
	generating_icons = FALSE
	SStgui.update_uis(src)

/// Stocks a new item of each type at the given price
/obj/structure/roguemachine/vendor/proc/stock_new(list/item_types, price)
	for(var/item_type in item_types)
		store_item(new item_type(src), price)

/obj/structure/roguemachine/vendor/proc/insert(obj/item/P, mob/living/user)
	if(P.w_class > WEIGHT_CLASS_BULKY)
		return
	if(is_full())
		to_chat(user, span_warning("Full."))
		return
	if(!user.transferItemToLoc(P, src))
		to_chat(user, span_warning("[P] is stuck to your hand!"))
		return
	store_item(P)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	update_icon()
	SStgui.update_uis(src)

/// Stores as many of the items as fit. Pass the storage they're taken from, if any.
/obj/structure/roguemachine/vendor/proc/load_items(list/items, mob/living/user, datum/component/storage/from_storage)
	var/stored = 0
	var/full = FALSE
	for(var/obj/item/I as anything in items)
		if(I.w_class > WEIGHT_CLASS_BULKY)
			continue
		if(is_full())
			full = TRUE
			break
		if(from_storage)
			from_storage.remove_from_storage(I, src)
		else
			I.forceMove(src)
		store_item(I)
		stored++

	if(stored)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		to_chat(user, span_notice("\The [src] swallows [stored] item\s."))
		update_icon()
		SStgui.update_uis(src)
	if(full)
		to_chat(user, span_warning("\The [src] is full."))
	else if(!stored)
		to_chat(user, span_warning("There is nothing \the [src] can take."))

/obj/structure/roguemachine/vendor/proc/is_loadable(obj/item/I)
	if(I.anchored || (I.item_flags & ABSTRACT))
		return FALSE
	if(istype(I, /obj/item/roguecoin))
		return FALSE
	return TRUE

/// Loads every loose item on the tile on the user's side of the machine
/obj/structure/roguemachine/vendor/sweep_floor(mob/living/user)
	. = TRUE
	var/turf/front = get_step(src, get_dir(src, user))
	if(!front)
		return
	var/list/candidates = list()
	for(var/obj/item/I in front)
		if(is_loadable(I))
			candidates += I
	load_items(candidates, user)

/// Loads the top-level contents of a bag; nested bags go in whole
/obj/structure/roguemachine/vendor/load_from_storage(datum/component/storage/STR, mob/living/user)
	var/list/candidates = list()
	for(var/obj/item/I in STR.contents())
		if(is_loadable(I))
			candidates += I
	load_items(candidates, user, STR)

/obj/structure/roguemachine/vendor/handle_item(obj/item/I, mob/user)
	if(locked)
		return FALSE
	insert(I, user)
	return TRUE

/obj/structure/roguemachine/vendor/has_stock()
	return length(held_items)

/obj/structure/roguemachine/vendor/ui_data(mob/user)
	var/list/data = ..()
	data["stored"] = length(held_items)
	data["capacity"] = max_items

	var/list/groups = list()
	var/list/group_order = list()
	for(var/obj/item/I in held_items)
		var/key = group_key(I)
		if(!groups[key])
			groups[key] = list(
				"key" = key,
				// names are stored html-encoded for hawking; tgui escapes text itself
				"name" = html_decode(held_items[I]["NAME"] || "thing"),
				"price" = held_items[I]["PRICE"] || 0,
				"count" = 0,
				"desc" = I.desc,
				// null until generate_icons gets to it
				"icon" = null,
			)
			group_order += key
		groups[key]["count"] += 1
		// a merged group can have members with and without an icon yet
		if(!groups[key]["icon"])
			groups[key]["icon"] = held_items[I]["ICON"]

	var/list/group_data = list()
	for(var/key in group_order)
		group_data += list(groups[key])
	data["groups"] = group_data
	return data

/// Hands the first item to the user and drops the rest at their feet
/obj/structure/roguemachine/vendor/proc/dispense(list/items, mob/living/user)
	var/turf/T = get_turf(user)
	var/first = TRUE
	for(var/obj/item/O as anything in items)
		held_items -= O
		if(!first || !user.put_in_hands(O))
			O.forceMove(T)
		first = FALSE
	update_icon()

/obj/structure/roguemachine/vendor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return

	switch(action)
		if("buy")
			if(!locked)
				return
			var/list/matches = get_group_items(params["key"])
			if(!length(matches))
				return
			var/amount = clamp(round(text2num("[params["amount"]]")), 1, length(matches))
			var/price = held_items[matches[1]]["PRICE"] || 0
			var/total = price * amount
			if(total > 0)
				if(budget < total)
					say("NO MONEY NO HONEY!")
					return TRUE
				budget -= total
				profits += total
				record_round_statistic(STATS_PEDDLER_REVENUE, total)
			dispense(matches.Copy(1, amount + 1), H)
			return TRUE

		if("take")
			if(locked)
				return
			var/list/matches = get_group_items(params["key"])
			if(!length(matches))
				return
			var/amount = params["all"] ? length(matches) : 1
			dispense(matches.Copy(1, amount + 1), H)
			return TRUE

		if("set_name")
			if(locked || !H.can_read(src, TRUE))
				return
			var/list/matches = get_group_items(params["key"])
			var/newname = sanitize(copytext(trim("[params["name"]]"), 1, MAX_NAME_LEN + 1))
			if(!length(matches) || !length(newname))
				return
			// renaming into an existing group merges with it, so take that group's price
			var/obj/item/first = matches[1]
			var/price = held_items[first]["PRICE"]
			var/list/joining = get_group_items(make_group_key(first.type, newname)) - matches
			if(length(joining))
				price = held_items[joining[1]]["PRICE"]
			for(var/obj/item/I in matches)
				held_items[I]["NAME"] = newname
				held_items[I]["PRICE"] = price
			return TRUE

		if("set_price")
			if(locked)
				return
			var/list/matches = get_group_items(params["key"])
			var/newprice = text2num("[params["price"]]")
			// no negative prices, no decimals
			if(!length(matches) || isnull(newprice) || newprice < 0 || newprice != round(newprice))
				return
			newprice = min(newprice, SHOP_MAX_PRICE)
			for(var/obj/item/I in matches)
				held_items[I]["PRICE"] = newprice
			return TRUE

/obj/structure/roguemachine/vendor/obj_break(damage_flag)
	..()
	for(var/obj/item/I in held_items)
		I.forceMove(src.loc)

/obj/structure/roguemachine/vendor/Destroy()
	for(var/obj/item/I in held_items)
		I.forceMove(src.loc)
	return ..()

/obj/structure/roguemachine/vendor/hawk()
	if(!length(held_items))
		return
	var/obj/item/I = pick(held_items)
	var/namer = held_items[I]["NAME"]
	namer = capitalize(namer)

	if(!findtext(namer, "s", -1)) // doesn't already end with "s"
		for(var/obj/item/O in held_items)
			if(O == I)
				continue
			if(O.type == I.type && (held_items[O]["NAME"]) == held_items[I]["NAME"])
				namer += "s" //add a plural s!
				break

	say("[namer] for sale! [held_items[I]["PRICE"]] mammons!")

/obj/structure/roguemachine/vendor/centcom
	name = "LANDLORD"
	desc = "Give this thing money, and you will immediately buy a neat property in the capital."
	max_integrity = 0
	icon_state = "streetvendor1"
	keycontrol = "dhjlashfdg"
	var/list/cachey = list()

/obj/structure/roguemachine/vendor/centcom/attack_hand(mob/living/user)
	return

/obj/structure/roguemachine/vendor/centcom/attack_right(mob/user)
	return

/obj/structure/roguemachine/vendor/centcom/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin))
		if(!cachey[user])
			cachey[user] = list()
		cachey[user]["moneydonate"] += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)

		if(cachey[user]["moneydonate"] > 99)
			if(!cachey[user]["trisawarded"])
				cachey[user]["trisawarded"] = 1
				user.adjust_triumphs(1)
				say("[user] has purchased a prole dwelling.")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(cachey[user]["moneydonate"] > 499)
			if(cachey[user]["trisawarded"] < 2)
				cachey[user]["trisawarded"] = 2
				user.adjust_triumphs(1)
				say("[user] has been upgraded to a space in a serf apartment.")
				playsound(src, pick('sound/misc/machinetalk.ogg'), 100, FALSE, -1)
		if(cachey[user]["moneydonate"] > 999)
			if(cachey[user]["trisawarded"] < 3)
				cachey[user]["trisawarded"] = 3
				user.adjust_triumphs(1)
				say("[user] HAS BEEN UPGRADED TO A NOBLE BEDCHAMBER!")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vendor/inn
	keycontrol = "tavern"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/inn/Initialize(mapload)
	. = ..()

	// Add room keys with a price of 20
	stock_new(list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv, /obj/item/roguekey/roomvi, /obj/item/roguekey/roomvii, /obj/item/roguekey/roomviii), 20)

	// Add fancy keys with a price of 100
	stock_new(list(/obj/item/storage/keyring/innfancyi, /obj/item/roguekey/fancyroomii, /obj/item/storage/keyring/innfancyiii, /obj/item/storage/keyring/innfancyiv, /obj/item/storage/keyring/innfancyv), 100)

	update_icon()

/obj/structure/roguemachine/vendor/innrockhill
	keycontrol = "tavern"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/innrockhill/Initialize(mapload)
	. = ..()

	// Add room keys with a price of 20
	stock_new(list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv, /obj/item/roguekey/roomvi, /obj/item/roguekey/roomvii, /obj/item/roguekey/roomviii, /obj/item/roguekey/roomix, /obj/item/roguekey/roomx), 20)

	// Add fancy keys with a price of 100
	stock_new(list(/obj/item/storage/keyring/innfancyi, /obj/item/storage/keyring/innfancyii, /obj/item/storage/keyring/innfancyiii), 100)

	update_icon()


/obj/structure/roguemachine/vendor/bathhouse
	keycontrol = "nightmaiden"//used to be nightman but it's nice for them to be able to stock the shelves too when the master isn't around

/obj/structure/roguemachine/vendor/bathhouse/locker
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/bathhouse/locker/Initialize(mapload)
	. = ..()

	// Add locker keys with a price of 10
	stock_new(list(/obj/item/roguekey/bathlocker1, /obj/item/roguekey/bathlocker2, /obj/item/roguekey/bathlocker3, /obj/item/roguekey/bathlocker4, /obj/item/roguekey/bathlocker5, /obj/item/roguekey/bathlocker6), 5)

	update_icon()


/obj/structure/roguemachine/vendor/merchant
	keycontrol = "merchant"

/obj/structure/roguemachine/vendor/merchant/Initialize(mapload)
	. = ..()
	stock_new(list(/obj/item/roguekey/apartments/stall1,/obj/item/roguekey/apartments/stall2,/obj/item/roguekey/apartments/stall3), 10)
	update_icon()

/obj/structure/roguemachine/vendor/stablemaster
	keycontrol = "stablemaster"

/obj/structure/roguemachine/vendor/stablemaster/Initialize(mapload)
	. = ..()
	stock_new(list(/obj/item/roguekey/apartments/stablemaster_1,/obj/item/roguekey/apartments/stablemaster_2,/obj/item/roguekey/apartments/stablemaster_3,/obj/item/roguekey/apartments/stablemaster_4,/obj/item/roguekey/apartments/stablemaster_5), 30)
	update_icon()

// PEDDLER CARTS

/obj/structure/roguemachine/vendor/mobile
	name = "peddler cart"
	desc = "A smaller, wheeled PEDDLER that can be moved around."
	icon_state = "svendorcart1"
	icon_prefix = "svendorcart"
	anchored = FALSE
	is_cart = TRUE
	max_items = 20
	max_integrity = 400
	climbable = TRUE
	// no owner until it's claimed, or crafted with its key
	keycontrol = null
	key_name = "peddler cart key"

/obj/structure/roguemachine/vendor/mobile/crafted
	is_crafted = TRUE

/obj/structure/roguemachine/vendor/mobile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking an unowned PEDDLER CART offers to make you its owner and hands you its key. Keys can be passed on to whoever you like.")
	. += span_info("Left-clicking a PEDDLER CART with an open hand lets you browse and purchase its wares.")
	. += span_info("Owners can UNLOCK it with its key to restock wares, withdraw profits, and secure or free its wheels. Secured wheels can't be pulled or pushed.")
