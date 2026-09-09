/*
 * LIAR'S DICE
 * A 2-6 player bluffing/deduction game.
 *
 * Rules:
 * - Each player starts with 5 dice, rolled secretly under their cup.
 * - Players take turns bidding: a quantity and a face value (e.g., "Three 4s").
 * - Each new bid must increase the quantity (same face), or name a higher face value (any quantity).
 * - Any player may call "Liar!" to challenge the current bid.
 * - On a challenge, all dice are revealed. 1s are wild and count toward any non-1 face.
 * - If the real count meets or exceeds the bid: the challenger loses one die.
 * - If the real count falls short: the bidder loses one die.
 * - A player eliminated at zero dice is out of the game.
 * - The loser of each round starts the next round's bidding.
 * - Last player with dice wins.
 */

/datum/liars_dice_game
	var/list/mob/living/players = list()
	var/list/die_counts = list()    // assoc: mob -> int (dice remaining, starts at 5)
	var/list/cups = list()          // assoc: mob -> list of int (current hidden roll)
	var/list/round_rolled = list()  // assoc: mob -> TRUE/FALSE (has rolled secret dice this round)
	var/list/eliminated = list()    // assoc: mob -> TRUE/FALSE
	var/current_player_index = 0
	var/mob/living/current_player = null
	var/mob/living/last_loser = null
	var/bid_quantity = 0            // 0 = no bid placed yet this round
	var/bid_face = 0                // 0 = no bid placed yet this round
	var/mob/living/current_bidder = null
	var/obj/item/storage/pill_bottle/dice/liars_dice/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 6
	var/can_take_action = FALSE

/datum/liars_dice_game/proc/recompute_current_index()
	if(!current_player)
		current_player_index = 0
		return
	var/i = players.Find(current_player)
	current_player_index = i ? i : 0

/datum/liars_dice_game/proc/get_next_active_player_after(mob/living/after_player)
	if(!players.len)
		return null

	var/start_idx = players.Find(after_player)
	if(!start_idx)
		start_idx = 0

	for(var/step in 1 to players.len)
		var/check_idx = ((start_idx + step - 1) % players.len) + 1
		var/mob/living/candidate = players[check_idx]
		if(candidate && !eliminated[candidate])
			return candidate

	return null

/datum/liars_dice_game/proc/get_previous_active_player_before(mob/living/before_player)
	if(!players.len)
		return null

	var/start_idx = players.Find(before_player)
	if(!start_idx)
		start_idx = 1

	for(var/step in 1 to players.len)
		var/check_idx = start_idx - step
		if(check_idx < 1)
			check_idx += players.len

		var/mob/living/candidate = players[check_idx]
		if(candidate && !eliminated[candidate])
			return candidate

	return null

/datum/liars_dice_game/proc/all_active_players_rolled()
	for(var/mob/living/M in players)
		if(eliminated[M])
			continue
		if(!round_rolled[M])
			return FALSE
	return TRUE

/datum/liars_dice_game/proc/get_unrolled_players_text()
	var/list/pending = list()
	for(var/mob/living/M in players)
		if(eliminated[M])
			continue
		if(!round_rolled[M])
			pending += "[M]"
	return pending.len ? jointext(pending, ", ") : "none"

/datum/liars_dice_game/proc/roll_secret_dice(mob/living/M)
	if(!M || !(M in players))
		return
	if(joining)
		to_chat(M, span_notice("The game has not started yet."))
		return
	if(eliminated[M])
		to_chat(M, span_warning("You are eliminated and cannot roll."))
		return
	if(round_rolled[M])
		show_private_cup(M)
		return

	var/count = die_counts[M]
	var/list/roll = list()
	for(var/i in 1 to count)
		roll += rand(1, 6)
	cups[M] = roll
	round_rolled[M] = TRUE

	playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 60, TRUE)
	game_bag.visible_message(span_notice("[M] rolls their secret dice."))
	show_private_cup(M)

	if(all_active_players_rolled())
		game_bag.visible_message("<span style='color:#EF5350;font-size:larger;font-weight:bold;'>All players have rolled their secret dice. Bidding is now open.</span>")

/datum/liars_dice_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Liar's Dice game has already started."))
		return

	if(joiner in players)
		var/list/opts = list("Leave game")
		if(players.len >= 2)
			opts += "Start game now"
		var/choice = input(joiner, "You are already in the lobby. ([players.len]/[max_players] players)", "Liar's Dice") as null|anything in opts
		if(choice == "Start game now")
			start_game()
		else if(choice == "Leave game")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner] left the pre-game lobby. ([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("The Liar's Dice game is full ([max_players]/[max_players])."))
		return

	players += joiner
	die_counts[joiner] = 5
	cups[joiner] = list()
	round_rolled[joiner] = FALSE
	eliminated[joiner] = FALSE
	game_bag.visible_message(span_notice("[joiner] joined Liar's Dice! ([players.len]/[max_players] players)"))
	if(players.len == max_players)
		start_game()

/datum/liars_dice_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller] has cancelled Liar's Dice!"))
	game_bag.active_game = null
	qdel(src)

/datum/liars_dice_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("You are not in this Liar's Dice game."))
		return

	var/was_current = (leaver == current_player)
	var/mob/living/next_after_current = null
	if(!joining && was_current)
		next_after_current = get_next_active_player_after(leaver)

	players -= leaver
	die_counts -= leaver
	cups -= leaver
	round_rolled -= leaver
	eliminated -= leaver

	if(last_loser == leaver)
		last_loser = null

	game_bag.visible_message(span_notice("[leaver] leaves Liar's Dice. ([players.len] players remain)"))

	if(!players.len)
		cancel_game(leaver)
		return

	if(current_player == leaver)
		current_player = null

	if(!joining)
		var/list/remaining = list()
		for(var/mob/living/M in players)
			if(!eliminated[M])
				remaining += M
		if(remaining.len <= 1)
			check_win_condition()
			return

		if(was_current)
			if(next_after_current && (next_after_current in players) && !eliminated[next_after_current])
				current_player = get_previous_active_player_before(next_after_current)
			else
				current_player = players[players.len]
			recompute_current_index()
			can_take_action = FALSE
			next_turn()
			return

		recompute_current_index()

/datum/liars_dice_game/proc/start_game()
	if(!joining)
		return
	joining = FALSE
	current_player = null
	current_player_index = 0
	last_loser = null
	bid_quantity = 0
	bid_face = 0
	current_bidder = null

	for(var/mob/living/M in players)
		die_counts[M] = 5
		cups[M] = list()
		round_rolled[M] = FALSE
		eliminated[M] = FALSE

	var/list/names = list()
	for(var/mob/living/M in players)
		names += "[M]"
	game_bag.visible_message(span_notice("Liar's Dice begins! Players: [jointext(names, ", ")]. Everyone starts with 5 dice."))
	start_round()

/datum/liars_dice_game/proc/start_round()
	bid_quantity = 0
	bid_face = 0
	current_bidder = null

	for(var/mob/living/M in players)
		cups[M] = list()
		round_rolled[M] = FALSE

	game_bag.visible_message(span_notice("--- NEW ROUND --- Dice counts: [get_dice_display()]."))
	game_bag.visible_message(span_notice("Each active player must roll their secret dice first (use Roll My Secret Dice)."))

	// Loser of previous round goes first; next_turn() advances from current_player.
	if(last_loser && (last_loser in players) && !eliminated[last_loser])
		current_player = get_previous_active_player_before(last_loser)
	else
		current_player = players[players.len]

	recompute_current_index()

	next_turn()

/datum/liars_dice_game/proc/show_private_cup(mob/living/M)
	if(!M)
		return
	if(!round_rolled[M])
		to_chat(M, span_notice("You have not rolled your secret dice yet. Use Roll My Secret Dice."))
		return
	var/list/cup_str = list()
	for(var/v in cups[M])
		cup_str += "<span style='color:#4FC3F7;font-size:larger;font-weight:bold;'>[v]</span>"
	to_chat(M, span_notice("Your hidden dice ([die_counts[M]] dice): [jointext(cup_str, " - ")]"))

/datum/liars_dice_game/proc/count_on_table(face)
	// Count all dice showing the bid face, plus wild 1s (when bidding on non-1 faces)
	var/total = 0
	for(var/mob/living/M in players)
		if(eliminated[M])
			continue
		for(var/v in cups[M])
			if(v == face)
				total++
			else if(v == 1 && face != 1)
				total++ // wild 1s count toward any non-1 face
	return total

/datum/liars_dice_game/proc/total_dice_on_table()
	var/total = 0
	for(var/mob/living/M in players)
		if(!eliminated[M])
			total += die_counts[M]
	return total

/datum/liars_dice_game/proc/next_turn()
	var/list/active = list()
	for(var/mob/living/M in players)
		if(!eliminated[M])
			active += M

	if(active.len <= 1)
		check_win_condition()
		return

	var/mob/living/next = get_next_active_player_after(current_player)
	if(next)
		current_player = next
		recompute_current_index()

		can_take_action = TRUE

		if(!all_active_players_rolled())
			var/pending = get_unrolled_players_text()
			game_bag.visible_message(span_notice("--- [next]'s turn | Waiting for secret rolls: [pending] | [get_dice_display()] ---"))
			if(!round_rolled[next])
				to_chat(next, span_notice("Roll your secret dice first. Activate the dice bag and choose Roll My Secret Dice."))
			else
				to_chat(next, span_notice("You already rolled. Waiting on: [pending]."))
			return

		if(bid_quantity == 0)
			game_bag.visible_message(span_notice("--- [next]'s turn to open the bidding. [get_dice_display()] ---"))
			to_chat(next, span_notice("No bid yet. You must open with a bid. Activate the dice bag to act."))
		else
			game_bag.visible_message(span_notice("--- [next]'s turn | Bid: [bid_quantity] x [bid_face]s (by [current_bidder]) | [get_dice_display()] ---"))
			to_chat(next, span_notice("Current bid: [bid_quantity] x [bid_face]s (by [current_bidder]). Raise the bid or Call Liar. Activate the dice bag to act."))
			show_private_cup(next)
		return

	check_win_condition()

/datum/liars_dice_game/proc/player_action(mob/living/user)
	if(!(user in players))
		to_chat(user, span_notice("Dice counts: [get_dice_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("Please wait a moment..."))
		return
	if(user != current_player)
		if(bid_quantity > 0)
			input(user, "It's not your turn. Current bid: [bid_quantity] x [bid_face]s (by [current_bidder]).", "Liar's Dice") as null|anything in list("OK")
		else
			input(user, "It's not your turn. No bid has been placed yet.", "Liar's Dice") as null|anything in list("OK")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("Turn order is resyncing. Try again in a moment."))
		return
	if(user != current_player)
		to_chat(user, span_warning("It is not your turn yet."))
		return
	if(!all_active_players_rolled())
		to_chat(user, span_notice("Bidding is locked until all active players roll their secret dice. Pending: [get_unrolled_players_text()]."))
		return
	if(!can_take_action)
		to_chat(user, span_notice("You have already acted this turn."))
		return

	can_take_action = FALSE
	do_bid_or_liar(user)

/datum/liars_dice_game/proc/do_bid_or_liar(mob/living/active)
	show_private_cup(active)

	var/list/options = list()
	if(bid_quantity == 0)
		options += "Make Opening Bid"
	else
		options += "Raise Bid"
		options += "Call Liar!"

	var/bid_display = (bid_quantity > 0) ? "[bid_quantity] x [bid_face]s (by [current_bidder])" : "(none)"
	var/choice = input(active, "Current bid: [bid_display]\nChoose your action:", "Liar's Dice") as null|anything in options

	if(!choice || !(active in players) || eliminated[active])
		can_take_action = TRUE
		if(bid_quantity == 0)
			to_chat(active, span_notice("You must open with a bid. Activate the dice bag again."))
		else
			to_chat(active, span_notice("You must raise or call. Activate the dice bag again."))
		return

	if(choice == "Call Liar!")
		busy = TRUE
		resolve_challenge(active)
		return

	// "Make Opening Bid" or "Raise Bid"
	do_place_bid(active)

/datum/liars_dice_game/proc/do_place_bid(mob/living/active)
	// Build face value options: on raising, cannot bid a lower face than current
	var/list/face_opts = list()
	if(bid_face == 0)
		face_opts = list("1", "2", "3", "4", "5", "6")
	else
		for(var/f in bid_face to 6)
			face_opts += "[f]"

	var/chosen_face_str = input(active, "Which face value are you bidding on?\n(1s are wild when counting — a bid of 2+ allows 1s to count)", "Liar's Dice") as null|anything in face_opts

	if(!chosen_face_str || !(active in players))
		can_take_action = TRUE
		to_chat(active, span_notice("Bid cancelled. Activate the dice bag again to re-bid."))
		return

	var/chosen_face = text2num(chosen_face_str)

	// Minimum quantity for the chosen face
	var/min_qty = 1
	if(bid_quantity > 0)
		if(chosen_face == bid_face)
			min_qty = bid_quantity + 1
		else if(chosen_face > bid_face)
			min_qty = bid_quantity

	var/max_qty = total_dice_on_table()

	// Build quantity options
	var/list/qty_opts = list()
	for(var/q in min_qty to max_qty)
		qty_opts += "[q]"

	if(!qty_opts.len)
		can_take_action = TRUE
		to_chat(active, span_notice("No valid quantity for [chosen_face]s at this point. Choose a different face."))
		do_bid_or_liar(active)
		return

	var/chosen_qty_str = input(active, "How many [chosen_face]s? (min [min_qty], max [max_qty] | total dice on table: [max_qty])", "Liar's Dice") as null|anything in qty_opts

	if(!chosen_qty_str || !(active in players))
		can_take_action = TRUE
		to_chat(active, span_notice("Bid cancelled. Activate the dice bag again to re-bid."))
		return

	var/chosen_qty = text2num(chosen_qty_str)

	bid_quantity = chosen_qty
	bid_face = chosen_face
	current_bidder = active

	game_bag.visible_message(span_notice("[active] bids: [bid_quantity] x [bid_face]s!"))
	next_turn()

/datum/liars_dice_game/proc/resolve_challenge(mob/living/challenger)
	// Reveal all cups
	var/list/reveal_parts = list()
	for(var/mob/living/M in players)
		if(eliminated[M])
			continue
		var/list/cup_str = list()
		for(var/v in cups[M])
			cup_str += "<span style='color:#4CAF50;font-size:larger;font-weight:bold;'>[v]</span>"
		reveal_parts += "[M] ([die_counts[M]] dice): [jointext(cup_str, " - ")]"

	game_bag.visible_message(span_notice("[challenger] calls [span_red("<b>LIAR</b>")] on [current_bidder]'s bid of [bid_quantity] x [bid_face]s!"))
	game_bag.visible_message(span_notice("All dice revealed!<br>[jointext(reveal_parts, "<br>")]"))

	var/actual_count = count_on_table(bid_face)
	var/wild_note = (bid_face != 1) ? " (1s counted as wild)" : ""
	game_bag.visible_message(span_notice("Actual count of [bid_face]s[wild_note]: [actual_count]. The bid was [bid_quantity]."))

	var/mob/living/loser
	if(actual_count >= bid_quantity)
		loser = challenger
		game_bag.visible_message(span_notice("The bid was [span_green("<b>TRUE</b>")] ([actual_count] >= [bid_quantity])! [challenger] loses one die."))
	else
		loser = current_bidder
		game_bag.visible_message(span_notice("The bid was [span_red("<b>FALSE</b>")] ([actual_count] < [bid_quantity])! [current_bidder] loses one die."))

	last_loser = loser
	apply_penalty(loser)

/datum/liars_dice_game/proc/apply_penalty(mob/living/loser)
	if(!loser)
		busy = FALSE
		start_round()
		return

	die_counts[loser]--

	if(die_counts[loser] <= 0)
		die_counts[loser] = 0
		eliminated[loser] = TRUE
		game_bag.visible_message(span_danger("[loser] has lost their last die and is ELIMINATED from Liar's Dice!"))
	else
		game_bag.visible_message(span_notice("[loser] now has [die_counts[loser]] dice remaining."))

	busy = FALSE

	var/list/remaining = list()
	for(var/mob/living/M in players)
		if(!eliminated[M])
			remaining += M

	if(remaining.len <= 1)
		check_win_condition()
		return

	start_round()

/datum/liars_dice_game/proc/check_win_condition()
	var/list/remaining = list()
	for(var/mob/living/M in players)
		if(!eliminated[M])
			remaining += M

	if(!remaining.len)
		game_bag.visible_message(span_warning("--- LIAR'S DICE OVER --- No players remain!"))
		game_bag.active_game = null
		qdel(src)
		return

	if(remaining.len == 1)
		var/mob/living/winner = remaining[1]
		game_bag.visible_message(span_green("<b>--- LIAR'S DICE OVER --- [winner] wins with [die_counts[winner]] dice remaining!</b>"))
		game_bag.active_game = null
		qdel(src)
		return

	// More than one remains — start next round
	start_round()

/datum/liars_dice_game/proc/get_dice_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		if(eliminated[M])
			parts += "[M]: OUT"
		else
			parts += "[M]: [die_counts[M]]d"
	return jointext(parts, " | ")


// =====================================================================
//  ITEM: Liar's Dice bag
// =====================================================================

/obj/item/storage/pill_bottle/dice/liars_dice
	name = "bag of liar's dice"
	desc = "A bag used to play Liar's Dice. Activate in hand (Z) to start or join a game."
	var/datum/liars_dice_game/active_game
	var/static/liars_dice_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>Liar's Dice</h2>
<br>
<b>Objective:</b> Be the last player with at least one die.<br>
<br>
<b>Setup:</b><br>
Each player starts with 5 dice, rolled in secret. You see only your own dice.<br>
<br>
<b>Bidding:</b><br>
- The opening player bids a dice quantity and a face value (e.g., <i>Three 4s</i>).<br>
- Their bid claims that many dice showing that face exist across all cups combined.<br>
- Each player in turn must: <b>Raise the Bid</b> or <b>Call Liar!</b><br>
<br>
<b>Valid Raises:</b><br>
- Increase the quantity (same face), OR<br>
- Name a higher face value (quantity must stay the same or increase).<br>
<br>
<b>Wild 1s:</b> When resolving a challenge, 1s count toward any non-1 face bid.<br>
(e.g., a bid of <i>Three 4s</i> counts all 4s and all 1s on the table)<br>
<br>
<b>Challenge (Call Liar!):</b><br>
- All dice are revealed.<br>
- If the real count (with wilds) <b>equals or exceeds</b> the bid: the <b>challenger</b> loses a die.<br>
- If the real count <b>falls short</b> of the bid: the <b>bidder</b> loses a die.<br>
<br>
<b>Elimination:</b> A player who loses their last die is eliminated.<br>
<br>
<b>Next Round:</b> The loser of the round starts the next round's bidding. All dice re-roll.<br>
</div>"}

/obj/item/storage/pill_bottle/dice/liars_dice/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(liars_dice_rules_text, "window=liars_dice_rules;size=700x520")

/obj/item/storage/pill_bottle/dice/liars_dice/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/dice/d6(src)

/obj/item/storage/pill_bottle/dice/liars_dice/attack_self(mob/living/user)
	if(active_game && active_game.joining && (user in active_game.players) && active_game.players.len >= 2)
		active_game.start_game()

	var/list/menu = list()
	var/list/spacers = list(" ", "  ", "   ", "    ", "     ")
	var/spacer_index = 1
	var/can_show_action = FALSE
	var/can_roll_secret = FALSE
	var/can_check_dice = FALSE
	if(active_game && !active_game.joining)
		if((user in active_game.players) && !active_game.eliminated[user])
			if(!active_game.round_rolled[user])
				can_roll_secret = TRUE
			can_check_dice = TRUE
		if(user == active_game.current_player && active_game.can_take_action && !active_game.eliminated[user])
			can_show_action = TRUE

	if(!active_game)
		menu += "Start Game"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "Join Game"
	else
		if(can_show_action)
			menu += "Place Bid / Call"
		if(can_roll_secret)
			if(menu.len)
				menu += spacers[spacer_index]
				spacer_index++
			menu += "Roll My Secret Dice"

	if(can_check_dice)
		if(menu.len)
			menu += spacers[spacer_index]
			spacer_index++
		menu += "Check My Dice"

	if(menu.len)
		menu += spacers[spacer_index]
		spacer_index++
	menu += "Rules"

	if(active_game && (user in active_game.players))
		menu += spacers[spacer_index]
		spacer_index++
		menu += "Leave Game"

	menu += spacers[spacer_index]
	menu += "End Game"

	var/choice = input(user, "Select an option.", "Liar's Dice") as null|anything in menu
	if(!choice)
		return

	if(choice == "Rules")
		show_rules(user)
		return

	if(choice == "End Game")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("No Liar's Dice game is currently running."))
		return

	if(choice == "Leave Game")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("No Liar's Dice game is currently running."))
		return

	if(choice == "Check My Dice")
		if(active_game && !active_game.joining && (user in active_game.players) && !active_game.eliminated[user])
			active_game.show_private_cup(user)
		return

	if(choice == "Roll My Secret Dice")
		if(active_game && !active_game.joining && (user in active_game.players) && !active_game.eliminated[user])
			active_game.roll_secret_dice(user)
		return

	if(choice == "Place Bid / Call")
		if(!active_game)
			to_chat(user, span_notice("No Liar's Dice game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_take_action && !active_game.joining))
			to_chat(user, span_notice("You cannot act right now."))
			return
		active_game.player_action(user)
		return

	if(choice == "Join Game")
		if(active_game && active_game.joining)
			active_game.try_join(user)
		return

	if(choice != "Start Game")
		return

	if(!active_game)
		var/count = input(user, "How many players?\n(2 to 6 players)", "Liar's Dice") as null|anything in list(2, 3, 4, 5, 6)
		if(!count)
			return

		var/datum/liars_dice_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user] is starting Liar's Dice! [count - 1] more player(s) needed. Activate (Z) the dice bag to join!"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user)
