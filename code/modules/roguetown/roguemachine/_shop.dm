/// Coin-fed shop machine. Shoppers put coin in to buy; the owner unlocks it with its key to stock it and take the profits.
/obj/structure/roguemachine/shop
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
	locked = TRUE
	/// Shopper coin put in and not yet spent
	var/budget = 0
	var/profits = 0
	/// lockid of the key that opens it, or null if it has no owner yet
	var/keycontrol = "merchant"
	/// Crafted shops come with their own key
	var/is_crafted = FALSE
	/// Name and icon of the key made for crafted or claimed shops
	var/key_name = "shop key"
	var/key_icon_state = "brownkey"
	/// Carts can be pulled around, and their owner can secure or free the wheels
	var/is_cart = FALSE
	var/next_hawk = 0
	var/will_hawk = TRUE
	/// icon states are this plus 1 (locked) or 0 (open or broken)
	var/icon_prefix = "streetvendor"
	/// tgui interface the shop opens
	var/tgui_id

/obj/structure/roguemachine/shop/Initialize(mapload)
	. = ..()
	if(is_crafted)
		make_key(get_turf(src))
	update_icon()
	START_PROCESSING(SSroguemachine, src)

/obj/structure/roguemachine/shop/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	refund_budget()
	set_light(0)
	return ..()

/obj/structure/roguemachine/shop/obj_break(damage_flag)
	..()
	refund_budget()
	update_icon()

/// Binds the shop to a new key with a fresh random lock and returns it
/obj/structure/roguemachine/shop/proc/make_key(atom/destination)
	var/obj/item/roguekey/key = new(destination)
	key.lockid = "shop_key_[world.time]_[rand(1, 9999999)]"
	key.name = key_name
	// the base key's "iron" state isn't in keys.dmi
	key.icon_state = key_icon_state
	keycontrol = key.lockid
	return key

/// Whether a key, or any key on a keyring, opens this shop
/obj/structure/roguemachine/shop/proc/key_fits(obj/item/I)
	if(istype(I, /obj/item/roguekey))
		var/obj/item/roguekey/K = I
		return K.lockid == keycontrol
	for(var/obj/item/roguekey/K in I)
		if(K.lockid == keycontrol)
			return TRUE
	return FALSE

/obj/structure/roguemachine/shop/proc/toggle_lock()
	locked = !locked
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	update_icon()
	SStgui.update_uis(src)

/// Pays the shopper's unspent coin back out
/obj/structure/roguemachine/shop/proc/refund_budget(mob/user)
	if(budget > 0)
		budget2change(budget, user)
	budget = 0

/// Whether there's anything for sale, which lights it up while locked
/obj/structure/roguemachine/shop/proc/has_stock()
	return FALSE

/// Calls out something for sale
/obj/structure/roguemachine/shop/proc/hawk()
	return

/// Handles an item that isn't coin or its key. Returns TRUE if the item was used.
/obj/structure/roguemachine/shop/proc/handle_item(obj/item/I, mob/user)
	return FALSE

/// Items a shop with no owner turns away
/obj/structure/roguemachine/shop/proc/refuses_unowned(obj/item/I)
	return istype(I, /obj/item/roguecoin) || istype(I, /obj/item/roguekey) || istype(I, /obj/item/storage/keyring)

/// Right-click loading from the floor in front. Returns FALSE if this shop doesn't take from the floor.
/obj/structure/roguemachine/shop/proc/sweep_floor(mob/living/user)
	return FALSE

/// Right-click loading from a held bag
/obj/structure/roguemachine/shop/proc/load_from_storage(datum/component/storage/STR, mob/living/user)
	return

/obj/structure/roguemachine/shop/attackby(obj/item/P, mob/user, params)
	if(obj_broken)
		return ..()
	if(istype(P, /obj/item/roguecoin/gilbranze) || istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(!keycontrol && refuses_unowned(P))
		to_chat(user, span_warning("\The [src] has no owner yet."))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		SStgui.update_uis(src)
		return
	if(istype(P, /obj/item/roguekey) || istype(P, /obj/item/storage/keyring))
		if(key_fits(P))
			toggle_lock()
			return
		// an open shop can take other keys as stock
		if(locked)
			to_chat(user, span_warning("Wrong key."))
			return
	if(handle_item(P, user))
		return
	..()

/obj/structure/roguemachine/shop/attack_hand(mob/living/user)
	if(try_claim(user))
		return TRUE
	. = ..()
	if(.)
		return
	if(!ishuman(user) || obj_broken)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/shop/attack_right(mob/user)
	if(try_claim(user))
		return TRUE
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
		if(!sweep_floor(user))
			ui_interact(user)
		return
	if(!istype(held, /obj/item/storage/keyring))
		var/datum/component/storage/STR = held.GetComponent(/datum/component/storage)
		if(STR && length(STR.contents()))
			load_from_storage(STR, user)
			return
	attackby(held, user)

/obj/structure/roguemachine/shop/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/shop/ui_status(mob/user, datum/ui_state/state)
	if(obj_broken || !isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/shop/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, tgui_id, name)
		ui.open()

/obj/structure/roguemachine/shop/ui_data(mob/user)
	var/list/data = list()
	data["locked"] = locked ? TRUE : FALSE
	data["can_read"] = user.can_read(src, TRUE) ? TRUE : FALSE
	data["budget"] = budget
	data["profits"] = profits
	data["is_cart"] = is_cart
	data["wheels_secured"] = anchored ? TRUE : FALSE
	return data

/obj/structure/roguemachine/shop/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return

	switch(action)
		if("change")
			if(!locked)
				return
			refund_budget(H)
			return TRUE

		if("withdraw_profits")
			if(locked)
				return
			if(profits > 0)
				budget2change(profits, H)
				profits = 0
			return TRUE

		if("toggle_wheels")
			if(!is_cart || locked)
				return
			anchored = !anchored
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			to_chat(H, span_notice("You [anchored ? "secure" : "free"] the wheels."))
			return TRUE

/obj/structure/roguemachine/shop/process()
	if(obj_broken || !will_hawk || world.time < next_hawk)
		return
	next_hawk = world.time + rand(1 MINUTES, 2 MINUTES)
	hawk()

/obj/structure/roguemachine/shop/update_icon()
	cut_overlays()
	set_light(0)
	var/open = !locked || obj_broken
	icon_state = "[icon_prefix][open ? 0 : 1]"
	if(!open && has_stock())
		set_light(1, 1, 1, l_color = "#1b7bf1")
		add_overlay(mutable_appearance(icon, "vendor-gen"))

/obj/structure/roguemachine/shop/examine(mob/user)
	. = ..()
	if(!keycontrol)
		. += span_info("It has no owner. Anyone could take ownership of it.")
	if(is_cart && anchored)
		. += span_info("Its wheels are secured.")

// OWNERLESS SHOPS

/obj/structure/roguemachine/shop/proc/try_claim(mob/user)
	if(keycontrol || obj_broken || !ishuman(user))
		return FALSE
	user.changeNext_move(CLICK_CD_INTENTCAP)
	INVOKE_ASYNC(src, PROC_REF(offer_ownership), user)
	return TRUE

/obj/structure/roguemachine/shop/proc/offer_ownership(mob/living/carbon/human/user)
	if(tgui_alert(user, "This [name] has no owner. Take ownership?", capitalize(name), list("Yes", "No")) != "Yes")
		return
	// someone else may have claimed it, or the user wandered off, while the prompt was up
	if(keycontrol || obj_broken || QDELETED(src) || !user.Adjacent(src) || user.incapacitated())
		return
	user.put_in_hands(make_key(get_turf(user)))
	to_chat(user, span_notice("You take ownership of \the [src]. Its key is yours."))
	if(locked)
		toggle_lock()
	ui_interact(user)

// CARTS

/obj/structure/roguemachine/shop/Move() // secured wheels keep it from being shoved around by explosions and such
	if(is_cart && anchored)
		return FALSE
	return ..()

/obj/structure/roguemachine/shop/can_be_pulled(user, grab_state, force)
	if(is_cart && anchored)
		return FALSE
	return ..()
