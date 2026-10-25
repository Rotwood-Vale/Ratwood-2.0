#define PEDDLER_MAX_PRICE 9999

/obj/structure/roguemachine/vendor
	name = "PEDDLER"
	desc = "The stomach of this thing can been stuffed with fun things for you to buy."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	// No INTERACT_ATOM_UI_INTERACT: the UI is opened explicitly so right-click loading doesn't pop it
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	var/list/held_items = list()
	locked = TRUE
	var/wgain = 0
	var/keycontrol = "merchant"
	var/next_hawk = 0
	var/will_hawk = TRUE
	var/max_items = 60
	var/budget = 0
	/// icon states are this plus 1 (locked) or 0 (open or broken)
	var/icon_prefix = "streetvendor"
	/// base64 icons per product group key, so the UI doesn't flatten icons every update
	var/list/icon_cache = list()

/obj/structure/roguemachine/vendor/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	held_items -= gone

/obj/structure/roguemachine/vendor/proc/group_key(obj/item/I)
	return "[I.type]_[held_items[I]["NAME"] || I.name]"

/// Returns the held_items keys (actual obj/item refs) belonging to the given group key
/obj/structure/roguemachine/vendor/proc/get_group_items(key)
	var/list/matches = list()
	for(var/obj/item/O in held_items)
		if(group_key(O) == key)
			matches += O
	return matches

/obj/structure/roguemachine/vendor/proc/can_store(obj/item/P)
	return P.w_class <= WEIGHT_CLASS_BULKY && length(held_items) < max_items

/obj/structure/roguemachine/vendor/proc/store_item(obj/item/P)
	var/price_to_set = 0
	for(var/obj/item/I in held_items)
		if(I.name == P.name)
			price_to_set = held_items[I]["PRICE"]
			break

	held_items[P] = list()
	held_items[P]["NAME"] = P.name
	held_items[P]["PRICE"] = price_to_set

	P.forceMove(src)

/obj/structure/roguemachine/vendor/proc/insert(obj/item/P, mob/living/user)
	if(P.w_class > WEIGHT_CLASS_BULKY)
		return
	if(length(held_items) >= max_items)
		to_chat(user, span_warning("Full."))
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
		if(!can_store(I))
			full = TRUE
			break
		if(from_storage)
			from_storage.remove_from_storage(I, src)
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
/obj/structure/roguemachine/vendor/proc/sweep_floor(mob/living/user)
	var/turf/front = get_step(src, get_dir(src, user))
	if(!front)
		return
	var/list/candidates = list()
	for(var/obj/item/I in front)
		if(is_loadable(I))
			candidates += I
	load_items(candidates, user)

/// Loads the top-level contents of a bag; nested bags go in whole
/obj/structure/roguemachine/vendor/proc/empty_storage(datum/component/storage/STR, mob/living/user)
	var/list/candidates = list()
	for(var/obj/item/I in STR.contents())
		if(is_loadable(I))
			candidates += I
	load_items(candidates, user, STR)

/obj/structure/roguemachine/vendor/proc/toggle_lock()
	locked = !locked
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	update_icon()
	SStgui.update_uis(src)

/obj/structure/roguemachine/vendor/attackby(obj/item/P, mob/user, params)
	if(obj_broken)
		return ..()
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		SStgui.update_uis(src)
		return
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol)
			toggle_lock()
			return
		if(locked)
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K)
			if(KE.lockid == keycontrol)
				toggle_lock()
				return
	if(!locked)
		insert(P, user)
		return
	..()

/obj/structure/roguemachine/vendor/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user) || obj_broken)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/vendor/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user) || obj_broken)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(locked)
		ui_interact(user)
		return
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		sweep_floor(user)
		return
	if(!istype(held, /obj/item/storage/keyring))
		var/datum/component/storage/STR = held.GetComponent(/datum/component/storage)
		if(STR && length(STR.contents()))
			empty_storage(STR, user)
			return
	attackby(held, user)

/obj/structure/roguemachine/vendor/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/vendor/ui_status(mob/user, datum/ui_state/state)
	if(obj_broken || !isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/vendor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, "Peddler", name)
		ui.open()

/obj/structure/roguemachine/vendor/ui_data(mob/user)
	var/list/data = list()
	data["locked"] = locked ? TRUE : FALSE
	data["can_read"] = user.can_read(src, TRUE) ? TRUE : FALSE
	data["budget"] = budget || 0
	data["profits"] = wgain
	data["stored"] = length(held_items)
	data["capacity"] = max_items

	var/list/groups = list()
	var/list/group_order = list()
	var/list/icons = list()
	for(var/obj/item/I in held_items)
		var/key = group_key(I)
		if(!groups[key])
			icons[key] = icon_cache[key] || icon2base64(getFlatIcon(I, no_anim = TRUE))
			groups[key] = list(
				"key" = key,
				// names are stored html-encoded for hawking; tgui escapes text itself
				"name" = html_decode(held_items[I]["NAME"] || "thing"),
				"price" = held_items[I]["PRICE"] || 0,
				"count" = 0,
				"desc" = I.desc,
				"icon" = icons[key],
			)
			group_order += key
		groups[key]["count"] += 1
	// rebuilt each update so emptied or renamed groups drop out
	icon_cache = icons

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
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
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
				wgain += total
			record_round_statistic(STATS_PEDDLER_REVENUE, total)
			dispense(matches.Copy(1, amount + 1), user)
			return TRUE

		if("take")
			if(locked)
				return
			var/list/matches = get_group_items(params["key"])
			if(!length(matches))
				return
			var/amount = params["all"] ? length(matches) : 1
			dispense(matches.Copy(1, amount + 1), user)
			return TRUE

		if("change")
			if(!locked)
				return
			if(budget > 0)
				budget2change(budget, user)
				budget = 0
			return TRUE

		if("withdraw_profits")
			if(locked)
				return
			if(wgain > 0)
				budget2change(wgain, user)
				wgain = 0
			return TRUE

		if("set_name")
			if(locked || !user.can_read(src, TRUE))
				return
			var/list/matches = get_group_items(params["key"])
			var/newname = sanitize(copytext(trim("[params["name"]]"), 1, MAX_NAME_LEN + 1))
			if(!length(matches) || !length(newname))
				return
			// renaming into an existing group merges with it, so take that group's price
			var/obj/item/first = matches[1]
			var/price = held_items[first]["PRICE"]
			var/list/joining = get_group_items("[first.type]_[newname]") - matches
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
			newprice = min(newprice, PEDDLER_MAX_PRICE)
			for(var/obj/item/I in matches)
				held_items[I]["PRICE"] = newprice
			return TRUE

/obj/structure/roguemachine/vendor/obj_break(damage_flag)
	..()
	for(var/obj/item/I in held_items)
		I.forceMove(src.loc)
		held_items -= I
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "[icon_prefix]0"

/obj/structure/roguemachine/vendor/Initialize(mapload)
	. = ..()
	update_icon()
	START_PROCESSING(SSroguemachine, src)

/obj/structure/roguemachine/vendor/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	if(!locked)
		icon_state = "[icon_prefix]0"
		return
	else
		icon_state = "[icon_prefix]1"
	if(held_items.len)
		set_light(1, 1, 1, l_color = "#1b7bf1")
		add_overlay(mutable_appearance(icon, "vendor-gen"))

/obj/structure/roguemachine/vendor/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	for(var/obj/item/I in held_items)
		I.forceMove(src.loc)
		held_items -= I
	set_light(0)
	return ..()

/obj/structure/roguemachine/vendor/process()
	if(obj_broken)
		return
	if(!will_hawk)
		return
	if(world.time > next_hawk)
		next_hawk = world.time + rand(1 MINUTES, 2 MINUTES)
		if(length(held_items))
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
	for (var/X in list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv, /obj/item/roguekey/roomvi, /obj/item/roguekey/roomvii, /obj/item/roguekey/roomviii))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 20

	// Add fancy keys with a price of 100
	for (var/Y in list(/obj/item/storage/keyring/innfancyi, /obj/item/roguekey/fancyroomii, /obj/item/storage/keyring/innfancyiii, /obj/item/storage/keyring/innfancyiv, /obj/item/storage/keyring/innfancyv))
		var/obj/Q = new Y(src)
		held_items[Q] = list()
		held_items[Q]["NAME"] = Q.name
		held_items[Q]["PRICE"] = 100

	update_icon()

/obj/structure/roguemachine/vendor/innrockhill
	keycontrol = "tavern"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/innrockhill/Initialize(mapload)
	. = ..()

	// Add room keys with a price of 20
	for (var/X in list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv, /obj/item/roguekey/roomvi, /obj/item/roguekey/roomvii, /obj/item/roguekey/roomviii, /obj/item/roguekey/roomix, /obj/item/roguekey/roomx))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 20

	// Add fancy keys with a price of 100
	for (var/Y in list(/obj/item/storage/keyring/innfancyi, /obj/item/storage/keyring/innfancyii, /obj/item/storage/keyring/innfancyiii))
		var/obj/Q = new Y(src)
		held_items[Q] = list()
		held_items[Q]["NAME"] = Q.name
		held_items[Q]["PRICE"] = 100

	update_icon()


/obj/structure/roguemachine/vendor/bathhouse
	keycontrol = "nightmaiden"//used to be nightman but it's nice for them to be able to stock the shelves too when the master isn't around

/obj/structure/roguemachine/vendor/bathhouse/locker
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/bathhouse/locker/Initialize(mapload)
	. = ..()

	// Add locker keys with a price of 10
	for (var/X in list(/obj/item/roguekey/bathlocker1, /obj/item/roguekey/bathlocker2, /obj/item/roguekey/bathlocker3, /obj/item/roguekey/bathlocker4, /obj/item/roguekey/bathlocker5, /obj/item/roguekey/bathlocker6))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 5

	update_icon()


/obj/structure/roguemachine/vendor/merchant
	keycontrol = "merchant"

/obj/structure/roguemachine/vendor/merchant/Initialize(mapload)
	. = ..()
	for(var/X in list(/obj/item/roguekey/apartments/stall1,/obj/item/roguekey/apartments/stall2,/obj/item/roguekey/apartments/stall3))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 10
	update_icon()

/obj/structure/roguemachine/vendor/stablemaster
	keycontrol = "stablemaster"

/obj/structure/roguemachine/vendor/stablemaster/Initialize(mapload)
	. = ..()
	for(var/X in list(/obj/item/roguekey/apartments/stablemaster_1,/obj/item/roguekey/apartments/stablemaster_2,/obj/item/roguekey/apartments/stablemaster_3,/obj/item/roguekey/apartments/stablemaster_4,/obj/item/roguekey/apartments/stablemaster_5))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 30
	update_icon()

// PEDDLER CARTS

/obj/structure/roguemachine/vendor/mobile
	name = "peddler cart"
	desc = "A smaller, wheeled PEDDLER that can be moved around."
	icon_state = "svendorcart1"
	icon_prefix = "svendorcart"
	anchored = FALSE
	max_items = 20
	max_integrity = 400
	climbable = TRUE
	// no owner until it's claimed, or crafted with its key
	keycontrol = null
	var/is_crafted = FALSE

/obj/structure/roguemachine/vendor/mobile/crafted
	is_crafted = TRUE

/obj/structure/roguemachine/vendor/mobile/Initialize(mapload)
	. = ..()
	if(is_crafted)
		make_key(get_turf(src))

/// Binds the cart to a new key and returns it
/obj/structure/roguemachine/vendor/mobile/proc/make_key(atom/destination)
	var/obj/item/roguekey/key = new(destination)
	key.lockid = "peddler_cart_[world.time]_[rand(1, 9999999)]"
	key.name = "peddler cart key"
	keycontrol = key.lockid
	return key

/obj/structure/roguemachine/vendor/mobile/proc/offer_ownership(mob/living/carbon/human/user)
	if(tgui_alert(user, "This cart has no owner. Take ownership?", "Peddler Cart", list("Yes", "No")) != "Yes")
		return
	// someone else may have claimed it, or the user wandered off, while the prompt was up
	if(keycontrol || obj_broken || QDELETED(src) || !user.Adjacent(src) || user.incapacitated())
		return
	user.put_in_hands(make_key(get_turf(user)))
	to_chat(user, span_notice("You take ownership of \the [src]. Its key is yours."))
	if(locked)
		toggle_lock()
	ui_interact(user)

/obj/structure/roguemachine/vendor/mobile/proc/try_claim(mob/user)
	if(keycontrol || obj_broken || !ishuman(user))
		return FALSE
	user.changeNext_move(CLICK_CD_INTENTCAP)
	INVOKE_ASYNC(src, PROC_REF(offer_ownership), user)
	return TRUE

/obj/structure/roguemachine/vendor/mobile/attack_hand(mob/living/user)
	if(try_claim(user))
		return TRUE
	return ..()

/obj/structure/roguemachine/vendor/mobile/attack_right(mob/user)
	if(try_claim(user))
		return TRUE
	return ..()

/obj/structure/roguemachine/vendor/mobile/attackby(obj/item/P, mob/user, params)
	if(!keycontrol && !obj_broken && (istype(P, /obj/item/roguekey) || istype(P, /obj/item/storage/keyring) || istype(P, /obj/item/roguecoin)))
		to_chat(user, span_warning("\The [src] has no owner yet."))
		return
	return ..()

/obj/structure/roguemachine/vendor/mobile/Move() // secured wheels keep it from being shoved around by explosions and such
	if(anchored)
		return FALSE
	return ..()

/obj/structure/roguemachine/vendor/mobile/can_be_pulled(user, grab_state, force)
	if(anchored)
		return FALSE
	return ..()

/obj/structure/roguemachine/vendor/mobile/examine(mob/user)
	. = ..()
	if(!keycontrol)
		. += span_info("It has no owner. Anyone could take ownership of it.")
	if(anchored)
		. += span_info("Its wheels are secured.")

/obj/structure/roguemachine/vendor/mobile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking an unowned PEDDLER CART offers to make you its owner and hands you its key. Keys can be passed on to whoever you like.")
	. += span_info("Left-clicking a PEDDLER CART with an open hand lets you browse and purchase its wares.")
	. += span_info("Owners can UNLOCK it with its key to restock wares, withdraw profits, and secure or free its wheels. Secured wheels can't be pulled or pushed.")

/obj/structure/roguemachine/vendor/mobile/ui_data(mob/user)
	. = ..()
	.["is_cart"] = TRUE
	.["wheels_secured"] = anchored ? TRUE : FALSE

/obj/structure/roguemachine/vendor/mobile/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "toggle_wheels" && !locked)
		anchored = !anchored
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		to_chat(usr, span_notice("You [anchored ? "secure" : "free"] the wheels."))
		return TRUE

#undef PEDDLER_MAX_PRICE
