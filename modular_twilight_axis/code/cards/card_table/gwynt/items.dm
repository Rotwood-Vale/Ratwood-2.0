/obj/item/ccg_deck
	name = "Arlette deck"
	desc = "A prepared deck for a round-based game of Arlette."
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_deck"
	w_class = WEIGHT_CLASS_SMALL
	var/list/card_ids = list()
	var/faction_id = CCG_FACTION_AZURIA
	var/leader_id = "azuria_ducal_marshal"
	var/datum/ccg_match/match
	var/obj/item/ccg_deck/match_host
	var/owner_ckey
	var/inviter_ckey
	var/inviter_name
	var/load_from_preferences = FALSE
	var/loaded_from_preferences = FALSE

/obj/item/ccg_deck/Initialize(mapload)
	. = ..()
	if(!length(GLOB.ccg_base_card_ids))
		ccg_build_card_registry()

/obj/item/ccg_deck/Destroy()
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match?.owner == src)
		qdel(active_match)
	else if(active_match?.challenger == src)
		active_match.challenger = null
	match = null
	match_host = null
	return ..()

/obj/item/ccg_deck/proc/set_cards(list/new_cards)
	card_ids = list()
	var/list/card_counts = list()
	for(var/card_id in new_cards)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card || !ccg_card_allowed_for_faction(card_id, faction_id) || card_ids.len >= CCG_DECK_SIZE)
			continue
		var/card_count = card_counts[card_id]
		if(!card_count)
			card_count = 0
		if(card_count >= ccg_card_deck_limit(card))
			continue
		card_counts[card_id] = card_count + 1
		card_ids += card_id

/obj/item/ccg_deck/proc/set_faction(new_faction_id, new_leader_id)
	var/datum/ccg_faction/faction = ccg_faction(new_faction_id)
	if(!faction)
		return FALSE
	faction_id = faction.id
	var/datum/ccg_leader/leader = ccg_leader(new_leader_id)
	if(!leader || leader.faction != faction_id)
		leader_id = faction.default_leader
	else
		leader_id = leader.id
	return TRUE

/obj/item/ccg_deck/proc/load_saved_deck(mob/user)
	if(loaded_from_preferences || !user?.client?.prefs)
		return FALSE
	var/datum/preferences/P = user.client.prefs
	P.ccg_clean_cards()
	var/datum/ccg_faction/faction = ccg_faction(P.ccg_saved_deck_faction)
	if(!faction)
		faction = ccg_faction(CCG_FACTION_AZURIA)
	set_faction(faction.id, P.ccg_saved_deck_leader)
	var/list/saved_cards = length(P.ccg_saved_deck_cards) ? P.ccg_saved_deck_cards : P.ccg_first_deck_cards(faction.id)
	set_cards(P.ccg_owned_deck_cards(saved_cards))
	owner_ckey = user.ckey
	var/owner_name = user.real_name || user.name
	if(owner_name)
		name = "Arlette Deck of [owner_name]"
	loaded_from_preferences = TRUE
	return TRUE

/obj/item/ccg_deck/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(load_from_preferences)
		load_saved_deck(user)

/obj/item/ccg_deck/proc/remove_cards_not_in_faction()
	var/list/removed = list()
	var/list/kept = list()
	for(var/card_id in card_ids)
		if(ccg_card_allowed_for_faction(card_id, faction_id))
			kept += card_id
		else
			removed += card_id
	card_ids = kept
	return removed

/obj/item/ccg_deck/proc/is_owner(mob/user)
	return user?.ckey && owner_ckey == user.ckey

/obj/item/ccg_deck/proc/is_on_table()
	var/turf/T = get_turf(src)
	return T && locate(/obj/structure/table) in T

/obj/item/ccg_deck/proc/open_deck_view(mob/user)
	if(!user?.client)
		return FALSE
	user.client.ccg_open_deckbuilder(src, user, !is_owner(user))
	return TRUE

/obj/item/ccg_deck/attack_self(mob/user)
	if(!user)
		return
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		ui_interact(user)
		return TRUE
	if(active_match)
		release_finished_match()
	if(!is_owner(user))
		open_deck_view(user)
	else if(inviter_ckey && inviter_ckey != user.ckey)
		to_chat(user, span_notice("Strike this deck with your own Arlette deck to begin."))
	else
		open_deck_view(user)
	return TRUE

/obj/item/ccg_deck/attack_hand(mob/user, params)
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		ui_interact(user)
		return TRUE
	if(active_match)
		release_finished_match()
	if(is_on_table())
		open_deck_view(user)
		return TRUE
	return ..()

/obj/item/ccg_deck/MouseDrop(atom/over_object)
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		return
	if(active_match)
		release_finished_match()
	. = ..()
	var/mob/living/user = usr
	if(!istype(user) || !(user.mobility_flags & MOBILITY_PICKUP) || !Adjacent(user))
		return
	if(over_object == user && loc != user)
		user.put_in_hands(src)
	else if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/hand = over_object
		user.putItemFromInventoryInHandIfPossible(src, hand.held_index)

/obj/item/ccg_deck/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ccg_deck))
		var/obj/item/ccg_deck/other = I
		release_finished_match()
		other.release_finished_match()
		if(get_active_match() || other.get_active_match())
			return TRUE
		try_start_match(user, other)
		return TRUE
	if(istype(I, /obj/item/ccg_card_single))
		var/obj/item/ccg_card_single/single = I
		add_single_card(user, single)
		return TRUE
	return ..()

/obj/item/ccg_deck/dropped(mob/user, silent = FALSE)
	. = ..()
	if(get_active_match()?.result_text)
		release_finished_match()
	if(get_active_match())
		return
	var/turf/T = get_turf(src)
	if(T && locate(/obj/structure/table) in T)
		inviter_ckey = user?.ckey
		inviter_name = user?.real_name ? user.real_name : user?.name
		if(user)
			to_chat(user, span_notice("You place the deck as an Arlette invitation."))
	else
		clear_invitation()

/obj/item/ccg_deck/proc/clear_invitation()
	inviter_ckey = null
	inviter_name = null

/obj/item/ccg_deck/proc/get_active_match()
	if(match)
		return match
	if(match_host?.match)
		return match_host.match
	return null

/obj/item/ccg_deck/proc/release_finished_match()
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match?.result_text)
		return FALSE
	return clear_match(active_match)

/obj/item/ccg_deck/proc/collect_finished_match()
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match?.result_text)
		return FALSE
	return clear_match(active_match)

/obj/item/ccg_deck/proc/clear_match(datum/ccg_match/active_match)
	if(!active_match)
		return FALSE
	active_match.stop_soundtracks()
	var/obj/item/ccg_deck/host = active_match.owner
	var/obj/item/ccg_deck/guest = active_match.challenger
	if(host)
		SStgui.close_uis(host)
	if(guest)
		SStgui.close_uis(guest)
	if(host)
		host.match = null
		host.match_host = null
		host.clear_invitation()
	if(guest)
		guest.match = null
		guest.match_host = null
		guest.clear_invitation()
	var/list/spectator_ckeys = active_match.spectator_ckeys.Copy()
	for(var/spectator_ckey in spectator_ckeys)
		var/mob/spectator = ccg_find_mob_by_ckey(spectator_ckey)
		if(spectator)
			SStgui.close_user_uis(spectator, host)
			SStgui.close_user_uis(spectator, guest)
	qdel(active_match)
	return TRUE

/obj/item/ccg_deck/proc/return_to_match_player(obj/item/ccg_deck/deck, ckey)
	if(!deck || !ckey)
		return FALSE
	var/mob/living/player = ccg_find_mob_by_ckey(ckey)
	if(!player)
		return FALSE
	if(player.put_in_hands(deck))
		return TRUE
	deck.forceMove(get_turf(player))
	return TRUE

/obj/item/ccg_deck/proc/end_match_session(datum/ccg_match/active_match)
	if(!active_match)
		return FALSE
	var/obj/item/ccg_deck/host_deck = active_match.owner
	var/obj/item/ccg_deck/guest_deck = active_match.challenger
	var/host_ckey = active_match.player_ckeys["one"]
	var/guest_ckey = active_match.player_ckeys["two"]
	if(!clear_match(active_match))
		return FALSE
	return_to_match_player(host_deck, host_ckey)
	return_to_match_player(guest_deck, guest_ckey)
	return TRUE

/obj/item/ccg_deck/proc/add_single_card(mob/user, obj/item/ccg_card_single/single)
	if(!user || !single)
		return FALSE
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		to_chat(user, span_warning("Finish the card match before changing this deck."))
		return FALSE
	if(active_match)
		release_finished_match()
	if(!ccg_card(single.card_id))
		to_chat(user, span_warning("This card cannot be added to the deck."))
		return FALSE
	var/datum/ccg_card/card = ccg_card(single.card_id)
	if(!ccg_card_allowed_for_faction(single.card_id, faction_id))
		to_chat(user, span_warning("This card belongs to another deck faction."))
		return FALSE
	var/datum/preferences/P = user.client?.prefs
	if(!P)
		to_chat(user, span_warning("The card collection is unavailable. The card was not added."))
		return FALSE
	if(!single.pooled && P.ccg_card_pool_count(single.card_id) >= ccg_card_pool_limit(card))
		to_chat(user, span_warning("The card was not added. Your collection already has the maximum of [ccg_card_pool_limit(card)] copies."))
		return FALSE
	if(!single.pooled && !P.ccg_add_known_card(single.card_id))
		to_chat(user, span_warning("The card could not be added to your collection. Try again."))
		return FALSE
	if(card_ids.len >= CCG_DECK_SIZE || ccg_card_count_in_list(card_ids, single.card_id) >= ccg_card_deck_limit(card))
		var/deck_reason = card_ids.len >= CCG_DECK_SIZE ? "the deck is full" : "this card has reached its deck limit"
		to_chat(user, span_notice("Added [card.name] to your collection ([P.ccg_card_pool_count(single.card_id)]/[ccg_card_pool_limit(card)]), but not to this deck: [deck_reason]."))
		if(!single.pooled && single.source_ckey && single.source_ckey != user.ckey)
			ccg_award_trade_progress(single.source_ckey, user)
		SStgui.update_user_uis(user)
		qdel(single)
		return FALSE
	card_ids += single.card_id
	if(!P.ccg_save_deck_snapshot(card_ids, faction_id, leader_id))
		card_ids.Cut(card_ids.len, card_ids.len + 1)
		if(!single.pooled)
			to_chat(user, span_warning("The card was saved to your collection, but the deck failed to save."))
			SStgui.update_user_uis(user)
			qdel(single)
		else
			to_chat(user, span_warning("The Arlette deck failed to save. The card was not added."))
		return FALSE
	if(!single.pooled && single.source_ckey && single.source_ckey != user.ckey)
		ccg_award_trade_progress(single.source_ckey, user)
	to_chat(user, span_notice("Added [card.name] to your collection ([P.ccg_card_pool_count(single.card_id)]/[ccg_card_pool_limit(card)]) and this deck ([ccg_card_count_in_list(card_ids, single.card_id)]/[ccg_card_deck_limit(card)])."))
	SStgui.update_user_uis(user)
	qdel(single)
	return TRUE

/obj/item/ccg_deck/proc/try_start_match(mob/user, obj/item/ccg_deck/challenger_deck)
	if(!user || !challenger_deck || challenger_deck == src)
		return FALSE
	if(get_active_match() || challenger_deck.get_active_match())
		to_chat(user, span_warning("One of these decks is already in a match."))
		return FALSE
	if(!inviter_ckey)
		to_chat(user, span_warning("This deck is not offering a match."))
		return FALSE
	if(inviter_ckey == user.ckey)
		to_chat(user, span_warning("You need another player for this match."))
		return FALSE
	var/mob/player_one = ccg_find_mob_by_ckey(inviter_ckey)
	if(!player_one)
		to_chat(user, span_warning("The player who offered this match is not here."))
		return FALSE
	if(!user.dropItemToGround(challenger_deck))
		return FALSE
	challenger_deck.forceMove(get_turf(src))
	clear_invitation()
	challenger_deck.clear_invitation()
	match = new(src, player_one, src, user, challenger_deck)
	challenger_deck.match_host = src
	challenger_deck.match = match
	ui_interact(player_one)
	challenger_deck.ui_interact(user)
	return TRUE

/obj/item/ccg_deck/ui_state(mob/user)
	return GLOB.always_state

/obj/item/ccg_deck/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/ccg_cards))

/obj/item/ccg_deck/ui_interact(mob/user, datum/tgui/ui)
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match)
		return
	active_match.add_spectator(user)
	active_match.sync_soundtrack_for(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GwyntTable", name)
		ui.open()

/obj/item/ccg_deck/ui_close(mob/user)
	var/datum/ccg_match/active_match = get_active_match()
	active_match?.remove_spectator(user)
	active_match?.stop_soundtrack_for(user)

/obj/item/ccg_deck/ui_data(mob/user)
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match)
		return list("waiting" = !!inviter_ckey, "offeredName" = inviter_name)
	return active_match.ui_data_for(user, src)

/obj/item/ccg_deck/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match)
		return FALSE
	var/mob/user = ui.user
	switch(action)
		if("leave_spectator")
			if(active_match.remove_spectator(user))
				active_match.stop_soundtrack_for(user)
				SStgui.close_user_uis(user, src)
				return TRUE
			return FALSE
		if("toggle_soundtrack")
			if(user?.client?.prefs)
				user.client.prefs.ccg_soundtrack_enabled = !user.client.prefs.ccg_soundtrack_enabled
				user.client.prefs.ccg_save_settings_sql()
				active_match.sync_soundtrack_for(user)
				active_match.update_deck_uis()
				return TRUE
		if("collect")
			if(!active_match.side_for_user(user, src))
				return FALSE
		if("play")
			if(active_match.play_card(user, params["card"], src, params))
				active_match.update_deck_uis()
				return TRUE
		if("mulligan")
			if(active_match.mulligan_card(user, params["card"], src))
				active_match.update_deck_uis()
				return TRUE
		if("ready_mulligan")
			if(active_match.ready_mulligan(user, src))
				active_match.update_deck_uis()
				return TRUE
		if("leader")
			if(active_match.use_leader(user, src))
				active_match.update_deck_uis()
				return TRUE
		if("pass")
			if(active_match.pass(user, src))
				active_match.update_deck_uis()
				return TRUE
		if("collect")
			if(end_match_session(active_match))
				return TRUE
	return FALSE

/obj/item/ccg_deck/attack_right(mob/user)
	if(!user)
		return
	if(!user.is_holding(src))
		return FALSE
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		ui_interact(user)
		return TRUE
	if(active_match)
		release_finished_match()
	if(!is_owner(user))
		open_deck_view(user)
		return TRUE
	return_to_stash(user)
	return TRUE

/obj/item/ccg_deck/proc/return_to_stash(mob/user)
	if(!user?.mind || !isliving(user))
		return FALSE
	if(!user.is_holding(src))
		return FALSE
	if(!owner_ckey || owner_ckey != user.ckey)
		to_chat(user, span_warning("This Arlette deck is not bound to your stash."))
		return TRUE
	if(!length(card_ids))
		to_chat(user, span_warning("This Arlette deck has no cards to stash."))
		return TRUE
	if(ccg_mind_has_stashed_deck(user.mind))
		to_chat(user, span_warning("You already have an Arlette deck in your stash."))
		return TRUE
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		user.client?.prefs?.ccg_sync_cards_from_inventory(H)
	if(!user.mind.special_items)
		user.mind.special_items = list()
	var/owner_name = user.real_name || user.name
	user.mind.special_items["Arlette Deck of [owner_name]"] = /obj/item/ccg_deck/stashed
	to_chat(user, span_notice("You return the Arlette deck to your stash."))
	qdel(src)
	return TRUE

/obj/item/ccg_deck/stashed
	name = "card deck"
	load_from_preferences = TRUE

/obj/item/ccg_card_single
	name = "collectible card"
	desc = "A single collectible card."
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_card"
	w_class = WEIGHT_CLASS_TINY
	var/card_id
	var/pooled = FALSE
	var/source_ckey

/obj/item/ccg_card_single/proc/set_card(new_card_id)
	card_id = new_card_id
	var/datum/ccg_card/card = ccg_card(card_id)
	if(card)
		name = card.name
		desc = card.desc

/obj/item/ccg_card_single/Initialize(mapload)
	. = ..()
	if(card_id)
		set_card(card_id)

/obj/item/ccg_card_single/attack_self(mob/user)
	if(pooled)
		to_chat(user, span_notice("The card is already in your known collection."))
		qdel(src)
		return
	var/datum/preferences/P = user?.client?.prefs
	var/datum/ccg_card/card = ccg_card(card_id)
	if(P && card && P.ccg_card_pool_count(card_id) >= ccg_card_pool_limit(card))
		to_chat(user, span_warning("The card was not added. Your collection already has the maximum of [ccg_card_pool_limit(card)] copies."))
		return
	if(P && P.ccg_add_known_card(card_id))
		to_chat(user, span_notice("Added [card.name] to your collection ([P.ccg_card_pool_count(card_id)]/[ccg_card_pool_limit(card)])."))
		if(source_ckey && source_ckey != user.ckey)
			ccg_award_trade_progress(source_ckey, user)
		SStgui.update_user_uis(user)
		qdel(src)
	else
		to_chat(user, span_warning("The card could not be added to your collection. Try again."))

/obj/item/ccg_card_generator
	name = "sealed card packet"
	desc = "A sealed packet containing a random collectible card."
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_card"
	w_class = WEIGHT_CLASS_TINY
	var/card_rarity = CCG_RARITY_RARE
	var/limited_only = FALSE

/obj/item/ccg_card_generator/Initialize(mapload)
	. = ..()
	var/card_id = pick_random_card()
	if(!card_id)
		return
	var/obj/item/ccg_card_single/single = new(loc)
	single.set_card(card_id)
	return INITIALIZE_HINT_QDEL

/obj/item/ccg_card_generator/proc/pick_random_card()
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	var/list/candidates = list()
	for(var/card_id in GLOB.ccg_cards_by_id)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(card?.rarity == card_rarity && (!limited_only || card.limited))
			candidates += card_id
	if(!length(candidates))
		return null
	return pick(candidates)

/obj/item/ccg_card_generator/common
	name = "creased common card packet"
	desc = "A battered packet containing a random common collectible card."
	card_rarity = CCG_RARITY_BASE

/obj/item/ccg_card_generator/rare
	name = "sealed rare card packet"
	desc = "A sealed packet containing a random rare collectible card."
	card_rarity = CCG_RARITY_RARE

/obj/item/ccg_card_generator/unique
	name = "sealed unique card packet"
	desc = "A sealed packet containing a random unique collectible card."
	card_rarity = CCG_RARITY_UNIQUE

/obj/item/ccg_card_booster
	name = "sealed card booster"
	desc = "A sealed booster containing three random collectible cards."
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_card"
	w_class = WEIGHT_CLASS_SMALL
	var/list/card_weights = list(
		"common_repeatable" = 8,
		"common_limited" = 5,
		"rare" = 2,
		"unique" = 1,
	)

/obj/item/ccg_card_booster/attack_self(mob/user)
	var/turf/drop_turf = get_turf(user)
	if(!drop_turf)
		return
	for(var/i in 1 to 3)
		var/card_id = pick_random_card()
		if(!card_id)
			continue
		var/obj/item/ccg_card_single/single = new(drop_turf)
		single.set_card(card_id)
		to_chat(user, span_notice("A [single.name] slips out of [src]."))
	qdel(src)

/obj/item/ccg_card_booster/proc/pick_random_card()
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	var/list/category_candidates = list()
	var/list/available_weights = list()
	for(var/category_key in card_weights)
		var/list/candidates = list()
		for(var/card_id in GLOB.ccg_cards_by_id)
			var/datum/ccg_card/card = ccg_card(card_id)
			if(!card)
				continue
			if(card_matches_category(card, category_key))
				candidates += card_id
		if(length(candidates))
			category_candidates[category_key] = candidates
			available_weights[category_key] = card_weights[category_key]
	if(!length(available_weights))
		return null
	var/selected_category = pickweight(available_weights)
	var/list/candidates = category_candidates[selected_category]
	return pick(candidates)

/obj/item/ccg_card_booster/proc/card_matches_category(datum/ccg_card/card, category)
	switch(category)
		if("common_repeatable")
			return card.rarity == CCG_RARITY_BASE && !card.limited && card.row != CCG_ROW_WEATHER && card.row != CCG_ROW_SPECIAL
		if("common_limited")
			return card.rarity == CCG_RARITY_BASE && card.limited && card.row != CCG_ROW_WEATHER && card.row != CCG_ROW_SPECIAL
		if("rare")
			return card.rarity == CCG_RARITY_RARE
		if("unique")
			return card.rarity == CCG_RARITY_UNIQUE
	return FALSE

/obj/item/ccg_card_booster/premium
	name = "premium sealed card booster"
	desc = "A premium sealed booster containing three random collectible cards."
	card_weights = list(
		"common_repeatable" = 5,
		"common_limited" = 8,
		"rare" = 3,
		"unique" = 2,
	)

/obj/item/ccg_card_single/rare_captain
	card_id = "rare_captain"

/obj/item/ccg_card_single/rare_saboteur
	card_id = "rare_saboteur"

/obj/item/ccg_card_single/unique_spy
	card_id = "unique_spy"

/proc/ccg_find_mob_by_ckey(ckey)
	if(!ckey)
		return null
	for(var/client/C)
		if(C.ckey == ckey)
			return C.mob
	return null
