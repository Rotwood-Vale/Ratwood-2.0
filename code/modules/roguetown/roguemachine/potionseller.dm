#define POTIONSELLER_TANKS 3
#define POTIONSELLER_TANK_VOLUME 500

/obj/structure/roguemachine/potionseller
	parent_type = /obj/structure/roguemachine/shop
	name = "POTION SELLER"
	desc = "The stomach of this thing can been stuffed with fluids for you to buy."
	debris = list(/obj/item/grown/log/tree/small, /obj/item/roguegear, /obj/item/natural/glass)
	tgui_id = "PotionSeller"
	key_name = "potion seller key"
	key_icon_state = "greenkey"
	/// The container in the slot, bought into or poured from
	var/obj/item/reagent_containers/inserted
	var/bottle_price = 10
	var/max_bottles = 20
	/// Empty bottles for sale
	var/list/bottle_stock = list()
	/// One reagent holder per tank, each holding any mixture
	var/list/tanks = list()
	var/list/tank_labels = list()
	/// Price per dram, in 0.1 steps
	var/list/tank_prices = list()
	/// Which tank right-click bag loading pours into
	var/loading_tank = 1
	var/tank_volume = POTIONSELLER_TANK_VOLUME

/obj/structure/roguemachine/potionseller/crafted
	is_crafted = TRUE
	max_integrity = 100

/obj/structure/roguemachine/potionseller/Initialize(mapload)
	. = ..()
	for(var/i in 1 to POTIONSELLER_TANKS)
		var/datum/reagents/tank = new(tank_volume, NO_REACT)
		tank.my_atom = src
		tanks += tank
		tank_labels += null
		tank_prices += 0
	if(!is_crafted)
		for(var/i in 1 to 10)
			bottle_stock += new /obj/item/reagent_containers/glass/bottle/rogue(src)

/obj/structure/roguemachine/potionseller/Destroy()
	drop_bottles()
	QDEL_LIST(tanks)
	return ..()

/obj/structure/roguemachine/potionseller/obj_break(damage_flag)
	..()
	for(var/datum/reagents/tank as anything in tanks)
		splash_tank(tank)
	drop_bottles()

/// Drops the container in the slot and the bottle shelf
/obj/structure/roguemachine/potionseller/proc/drop_bottles()
	if(inserted)
		inserted.forceMove(drop_location())
		inserted = null
	for(var/obj/item/B in bottle_stock.Copy())
		B.forceMove(drop_location())
	bottle_stock.Cut()

/obj/structure/roguemachine/potionseller/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == inserted)
		inserted = null
	bottle_stock -= gone

/obj/structure/roguemachine/potionseller/proc/default_tank_label(index)
	return "Tank [index]"

/obj/structure/roguemachine/potionseller/proc/tank_label(index)
	return tank_labels[index] || default_tank_label(index)

/// Parses a tank number from ui params, or null if it isn't a valid tank
/obj/structure/roguemachine/potionseller/proc/tank_index(param)
	var/index = text2num("[param]")
	if(!isnum(index) || index != round(index) || index < 1 || index > length(tanks))
		return null
	return index

/obj/structure/roguemachine/potionseller/proc/is_liquid_container(obj/item/I)
	if(!istype(I, /obj/item/reagent_containers/glass) || !I.reagents)
		return FALSE
	if(istype(I, /obj/item/reagent_containers/glass/mortar) || istype(I, /obj/item/reagent_containers/glass/crucible) || istype(I, /obj/item/reagent_containers/glass/rag))
		return FALSE
	return TRUE

/// Only plain bottles are kept as stock for sale
/obj/structure/roguemachine/potionseller/proc/is_stock_bottle(obj/item/I)
	return istype(I, /obj/item/reagent_containers/glass/bottle/rogue) || istype(I, /obj/item/reagent_containers/glass/bottle/alchemical)

/// Pours from a container into a tank, returning drams moved
/obj/structure/roguemachine/potionseller/proc/pour_into_tank(obj/item/reagent_containers/C, index, amount, mob/user)
	var/datum/reagents/tank = tanks[index]
	if(!C.reagents.total_volume || tank.total_volume >= tank.maximum_volume)
		return 0
	return C.reagents.trans_to(tank, amount, no_react = TRUE, transfered_by = user) || 0

/obj/structure/roguemachine/potionseller/proc/stock_bottle(obj/item/I, mob/user)
	if(length(bottle_stock) >= max_bottles)
		to_chat(user, span_warning("The bottle shelf is full."))
		return FALSE
	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return FALSE
	bottle_stock += I
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	SStgui.update_uis(src)
	return TRUE

/// Empties the filled liquid containers in a bag into the loading tank, as far as it has room,
/// and moves empty stock bottles from the bag onto the bottle shelf
/obj/structure/roguemachine/potionseller/load_from_storage(datum/component/storage/STR, mob/living/user)
	var/poured = 0
	var/shelved = 0
	var/tank_full = FALSE
	var/shelf_full = FALSE
	for(var/obj/item/reagent_containers/C in STR.contents())
		if(!is_liquid_container(C))
			continue
		if(C.reagents.total_volume)
			poured += pour_into_tank(C, loading_tank, C.reagents.total_volume, user)
			// anything left over didn't fit
			if(C.reagents.total_volume)
				tank_full = TRUE
			// a bottle emptied here isn't shelved until the next right-click
			continue
		if(is_stock_bottle(C))
			if(length(bottle_stock) >= max_bottles)
				shelf_full = TRUE
				continue
			STR.remove_from_storage(C, src)
			bottle_stock += C
			shelved++

	if(poured || shelved)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		var/list/parts = list()
		if(poured)
			parts += "pours [round(poured)] dram\s into [tank_label(loading_tank)]"
		if(shelved)
			parts += "shelves [shelved] bottle\s"
		to_chat(user, span_notice("\The [src] [english_list(parts)]."))
		update_icon()
		SStgui.update_uis(src)
	if(tank_full)
		to_chat(user, span_warning("[tank_label(loading_tank)] is full."))
	if(shelf_full)
		to_chat(user, span_warning("The bottle shelf is full."))
	if(!poured && !shelved && !tank_full && !shelf_full)
		to_chat(user, span_warning("There is nothing \the [src] can take."))

/obj/structure/roguemachine/potionseller/refuses_unowned(obj/item/I)
	return ..() || is_liquid_container(I)

/obj/structure/roguemachine/potionseller/handle_item(obj/item/I, mob/user)
	if(is_liquid_container(I))
		if(!locked && is_stock_bottle(I) && !I.reagents.total_volume)
			stock_bottle(I, user)
			return TRUE
		if(inserted)
			to_chat(user, span_warning("Something is already inside!"))
			return TRUE
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I] is stuck to your hand!"))
			return TRUE
		inserted = I
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		SStgui.update_uis(src)
		return TRUE
	if(!locked)
		to_chat(user, span_warning("Not a container."))
		return TRUE
	return FALSE

/obj/structure/roguemachine/potionseller/has_stock()
	for(var/datum/reagents/tank as anything in tanks)
		if(tank.total_volume >= 1)
			return TRUE
	return FALSE

/obj/structure/roguemachine/potionseller/ui_data(mob/user)
	var/list/data = ..()
	data["bottle_price"] = bottle_price
	data["bottles"] = length(bottle_stock)
	data["max_bottles"] = max_bottles
	data["loading_tank"] = loading_tank

	var/list/tank_data = list()
	for(var/i in 1 to length(tanks))
		var/datum/reagents/tank = tanks[i]
		tank_data += list(list(
			// labels are stored html-encoded for hawking; tgui escapes text itself
			"label" = html_decode(tank_label(i)),
			"default_label" = default_tank_label(i),
			"price" = tank_prices[i],
			"volume" = round(tank.total_volume, 0.1),
			"drawable" = floor(tank.total_volume),
			"max" = tank.maximum_volume,
			"color" = tank.total_volume ? mix_color_from_reagents(tank.reagent_list) : null,
		))
	data["tanks"] = tank_data

	// always sent: tgui merges updates, so an omitted key would keep showing the old container
	data["container"] = null
	if(inserted)
		data["container"] = list(
			"name" = html_decode(inserted.name),
			"volume" = round(inserted.reagents.total_volume, 0.1),
			"max" = inserted.reagents.maximum_volume,
			"color" = inserted.reagents.total_volume ? mix_color_from_reagents(inserted.reagents.reagent_list) : null,
		)
	return data

/// Hands an item to the user, or drops it at their feet
/obj/structure/roguemachine/potionseller/proc/give_to(obj/item/I, mob/living/user)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))

/obj/structure/roguemachine/potionseller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return

	switch(action)
		if("eject")
			if(!inserted)
				return
			var/obj/item/I = inserted
			inserted = null
			give_to(I, H)
			return TRUE

		if("pour")
			if(!inserted)
				return
			var/list/draws = params["draws"]
			if(!islist(draws) || length(draws) != length(tanks))
				return
			var/space = inserted.reagents.maximum_volume - inserted.reagents.total_volume
			var/total_drams = 0
			var/cost = 0
			for(var/i in 1 to length(tanks))
				var/datum/reagents/tank = tanks[i]
				var/amount = round(text2num("[draws[i]]"))
				if(!amount)
					draws[i] = 0
					continue
				// !(x >= 0) rather than x < 0 so NaN is rejected too
				if(!(amount >= 0) || amount > tank.total_volume)
					return
				draws[i] = amount
				total_drams += amount
				cost += tank_prices[i] * amount
			if(!total_drams || total_drams > space)
				return
			if(locked)
				cost = CEILING(round(cost, 0.1), 1)
				if(cost > budget)
					say("MY POTIONS ARE TOO EXPENSIVE FOR YOU, TRAVELER")
					return TRUE
				budget -= cost
				profits += cost
				record_round_statistic(STATS_PEDDLER_REVENUE, cost)
			for(var/i in 1 to length(tanks))
				if(draws[i])
					var/datum/reagents/tank = tanks[i]
					tank.trans_to(inserted, draws[i], no_react = TRUE, transfered_by = H)
			inserted.reagents.handle_reactions()
			playsound(loc, 'sound/misc/potionseller.ogg', 100, TRUE, -1)
			update_icon()
			return TRUE

		if("buy_bottle")
			if(!length(bottle_stock))
				say("MY BOTTLES ARE ALL SOLD OUT, TRAVELER")
				return TRUE
			// a bought bottle goes into the slot, so it has to be free
			if(locked && inserted)
				say("TAKE YOUR CONTAINER FIRST, TRAVELER")
				return TRUE
			if(locked && bottle_price > 0)
				if(budget < bottle_price)
					say("MY BOTTLES ARE TOO EXPENSIVE FOR YOU, TRAVELER")
					return TRUE
				budget -= bottle_price
				profits += bottle_price
				record_round_statistic(STATS_PEDDLER_REVENUE, bottle_price)
			var/obj/item/B = bottle_stock[length(bottle_stock)]
			bottle_stock -= B
			if(inserted)
				give_to(B, H)
			else
				inserted = B
			return TRUE

		if("pour_in")
			if(locked || !inserted)
				return
			var/index = tank_index(params["tank"])
			if(!index)
				return
			var/amount = isnull(params["amount"]) ? inserted.reagents.total_volume : round(text2num("[params["amount"]]"))
			if(!(amount > 0))
				return
			var/datum/reagents/tank = tanks[index]
			if(tank.total_volume >= tank.maximum_volume)
				to_chat(H, span_warning("[tank_label(index)] is full."))
				return TRUE
			if(!pour_into_tank(inserted, index, amount, H))
				return TRUE
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			update_icon()
			return TRUE

		if("flush")
			if(locked)
				return
			var/index = tank_index(params["tank"])
			if(!index)
				return
			splash_tank(tanks[index])
			update_icon()
			return TRUE

		if("set_loading_tank")
			if(locked)
				return
			var/index = tank_index(params["tank"])
			if(index)
				loading_tank = index
			return TRUE

		if("set_label")
			if(locked || !H.can_read(src, TRUE))
				return
			var/index = tank_index(params["tank"])
			if(!index)
				return
			var/newlabel = sanitize(copytext(trim("[params["label"]]"), 1, MAX_NAME_LEN + 1))
			// blank or the default name means no label, so the tank keeps the default
			tank_labels[index] = (length(newlabel) && newlabel != default_tank_label(index)) ? newlabel : null
			return TRUE

		if("set_price")
			if(locked)
				return
			var/index = tank_index(params["tank"])
			var/newprice = text2num("[params["price"]]")
			if(!index || isnull(newprice) || !(newprice >= 0))
				return
			tank_prices[index] = round(min(newprice, SHOP_MAX_PRICE), 0.1)
			return TRUE

		if("set_bottle_price")
			if(locked)
				return
			var/newprice = text2num("[params["price"]]")
			if(isnull(newprice) || !(newprice >= 0))
				return
			bottle_price = round(min(newprice, SHOP_MAX_PRICE))
			return TRUE

/obj/structure/roguemachine/potionseller/proc/splash_tank(datum/reagents/tank)
	if(!tank.total_volume)
		return
	var/turf/T = get_turf(src)
	visible_message(span_warning("\The [src] gushes liquid all over the floor!"))
	playsound(T, 'sound/foley/water_land1.ogg', 100, TRUE)
	tank.reaction(T, TOUCH)
	tank.clear_reagents()

/obj/structure/roguemachine/potionseller/hawk()
	var/list/stocked = list()
	for(var/i in 1 to length(tanks))
		var/datum/reagents/tank = tanks[i]
		if(tank.total_volume >= 1)
			stocked += i
	if(!length(stocked))
		return
	var/index = pick(stocked)
	var/label = capitalize(tank_label(index))
	if(tank_prices[index])
		say("[label] for sale! [tank_prices[index]] mammon\s a dram!")
	else
		say("Free [label]! Bring a bottle!")

// POTION CARTS

/obj/structure/roguemachine/potionseller/mobile
	name = "potion cart"
	desc = "A smaller, wheeled POTION SELLER that can be moved around."
	icon_state = "svendorcart1"
	icon_prefix = "svendorcart"
	anchored = FALSE
	is_cart = TRUE
	max_integrity = 400
	climbable = TRUE
	tank_volume = 250
	max_bottles = 10
	// no owner until it's claimed, or crafted with its key
	keycontrol = null
	key_name = "potion cart key"

/obj/structure/roguemachine/potionseller/mobile/crafted
	is_crafted = TRUE

/obj/structure/roguemachine/potionseller/mobile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking an unowned POTION CART offers to make you its owner and hands you its key. Keys can be passed on to whoever you like.")
	. += span_info("Left-clicking a POTION CART with an open hand lets you buy from its tanks and its bottle shelf.")
	. += span_info("Owners can UNLOCK it with its key to fill tanks, withdraw profits, and secure or free its wheels. Secured wheels can't be pulled or pushed.")

#undef POTIONSELLER_TANKS
#undef POTIONSELLER_TANK_VOLUME
