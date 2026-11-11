// Card table mode for the regular deck of cards. Right-click a deck to set it up as a table
// for blackjack or poker; right-click it again (once everyone has left) to pack it away.
// The deck's own attack_hand/attack_self/MouseDrop in code/game/objects/items/toys.dm check card_table_mode.

/obj/item/toy/cards/deck
	var/card_table_mode = FALSE
	var/datum/card_table_session/card_table
	var/card_table_range_timer

/obj/item/toy/cards/deck/Destroy()
	if(card_table_range_timer)
		deltimer(card_table_range_timer)
		card_table_range_timer = null
	QDEL_NULL(card_table)
	return ..()

/obj/item/toy/cards/deck/proc/ensure_card_table() as /datum/card_table_session
	if(!card_table)
		card_table = new(src)
	return card_table

/obj/item/toy/cards/deck/proc/start_card_table_range_loop()
	if(card_table_range_timer)
		return
	card_table_range_timer = addtimer(CALLBACK(src, PROC_REF(card_table_range_tick)), CARD_TABLE_RANGE_CHECK_TIME, TIMER_STOPPABLE)

/obj/item/toy/cards/deck/proc/card_table_range_tick()
	card_table_range_timer = null
	if(!card_table_mode || QDELETED(src))
		return
	if(card_table)
		card_table.check_player_ranges()
		SStgui.update_uis(src)
	start_card_table_range_loop()

/obj/item/toy/cards/deck/proc/enter_card_table_mode(mob/user)
	if(user && user.is_holding(src))
		user.dropItemToGround(src)
	if(!isturf(loc) && user)
		forceMove(get_turf(user))
	card_table_mode = TRUE
	ensure_card_table()
	start_card_table_range_loop()
	if(user)
		user.visible_message(span_notice("[user] sets the deck up as a card table."), span_notice("I set the deck up as a card table."))

/obj/item/toy/cards/deck/proc/leave_card_table_mode(mob/user)
	if(!card_table_mode)
		return FALSE
	if(card_table && !card_table.can_pack())
		to_chat(user, span_warning("The card table can only be packed up once everyone has left."))
		return FALSE
	card_table_mode = FALSE
	if(card_table_range_timer)
		deltimer(card_table_range_timer)
		card_table_range_timer = null
	QDEL_NULL(card_table)
	SStgui.close_uis(src)
	if(user)
		user.visible_message(span_notice("[user] packs the card table back into a normal deck."), span_notice("I pack the card table back into a normal deck."))
	return TRUE

/obj/item/toy/cards/deck/attack_right(mob/user, params)
	if(!user)
		return ..()
	if(card_table_mode)
		return leave_card_table_mode(user)
	// Tarot decks aren't playing cards, so they can't become card tables.
	if(istype(src, /obj/item/toy/cards/deck/tarot))
		return ..()
	enter_card_table_mode(user)
	return TRUE

/obj/item/toy/cards/deck/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/toy/cards/deck/ui_interact(mob/user, datum/tgui/ui)
	if(!card_table_mode)
		return
	ensure_card_table()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CardTable", "Card Table")
		ui.open()

/obj/item/toy/cards/deck/ui_data(mob/user)
	if(!card_table_mode)
		return list()
	return ensure_card_table().build_ui_data(user)

/obj/item/toy/cards/deck/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!card_table_mode || !card_table)
		return FALSE
	var/mob/user = usr
	if(!user || !user.canUseTopic(src, be_close = TRUE))
		return FALSE
	switch(action)
		if("set_game")
			. = card_table.set_game(params["game"], user)
		if("set_poker_variant")
			. = card_table.set_poker_variant(params["variant"], user)
		if("set_blackjack_variant")
			. = card_table.set_blackjack_variant(params["variant"], user)
		if("set_dealer_rotation")
			. = card_table.set_dealer_rotation(params["rotates"], user)
		if("join_player")
			. = card_table.join_player(user)
		if("join_observer")
			. = card_table.join_observer(user)
		if("leave")
			. = card_table.release_user(user)
		if("start")
			. = card_table.start_game(user)
		if("reset_lobby")
			if(card_table.stage == CARD_TABLE_STAGE_FINISHED || !card_table.players.len)
				card_table.reset_to_lobby()
				. = TRUE
		if("blackjack_hit")
			. = card_table.blackjack_hit(user)
		if("blackjack_stand")
			. = card_table.blackjack_stand(user)
		if("xylix_choose_card")
			. = card_table.xylix_choose_deck_card(user, params["card_index"])
		if("poker_discard")
			. = card_table.poker_discard(user, params["card_index"])
		if("poker_ready")
			. = card_table.poker_ready(user)
		if("poker_finish_turn")
			. = card_table.poker_finish_turn(user, params["card_index"])
		if("poker_check")
			. = card_table.poker_check(user)
		if("poker_bet")
			. = card_table.poker_bet(user, params["amount"])
		if("poker_all_in")
			. = card_table.poker_all_in(user)
		if("poker_fold")
			. = card_table.poker_fold(user)
	if(.)
		SStgui.update_uis(src)
	return .
