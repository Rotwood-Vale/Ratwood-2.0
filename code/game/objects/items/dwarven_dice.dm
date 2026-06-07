/*
 * DWARVEN DICE
 * A 2-4 player d6 game.
 *
 * Rules:
 * - One at a time, each player rolls 3d6.
 * - Highest total wins after everyone has rolled.
 * - One pair doubles your total.
 * - A triple would triple your total, but any triple is also an instant win.
 * - Instant WIN: 4-5-6 sequence OR any triple.
 * - Instant LOSE: 1-2-3 sequence OR any pair with at least one 1.
 */

/proc/dwarven_dice_eval(list/rolled) as list
	var/list/result = list(
		"instant_win" = FALSE,
		"instant_lose" = FALSE,
		"score" = 0,
		"reason" = "",
		"label" = ""
	)

	if(rolled.len != 3)
		result["reason"] = "Invalid roll."
		return result

	var/list/counts = list(0, 0, 0, 0, 0, 0)
	var/sum = 0
	for(var/v in rolled)
		counts[v]++
		sum += v

	var/is_triple = FALSE
	var/has_pair = FALSE
	for(var/f in 1 to 6)
		if(counts[f] == 3)
			is_triple = TRUE
		if(counts[f] == 2)
			has_pair = TRUE

	var/is_123 = (counts[1] && counts[2] && counts[3])
	var/is_456 = (counts[4] && counts[5] && counts[6])
	var/has_one = (counts[1] > 0)

	if(is_triple)
		result["instant_win"] = TRUE
		result["score"] = sum * 3
		result["reason"] = "TRIPLE! Instant win!"
		result["label"] = "Triple"
		return result

	if(is_456)
		result["instant_win"] = TRUE
		result["score"] = sum
		result["reason"] = "4-5-6! Instant win!"
		result["label"] = "4-5-6 Sequence"
		return result

	if(is_123)
		result["instant_lose"] = TRUE
		result["reason"] = "1-2-3! Instant loss!"
		result["label"] = "1-2-3 Sequence"
		return result

	if(has_pair && has_one)
		result["instant_lose"] = TRUE
		result["reason"] = "Pair with a snake eye! Instant loss!"
		result["label"] = "Pair + Snake Eye"
		return result

	if(has_pair)
		result["score"] = sum * 2
		result["label"] = "Pair (x2)"
	else
		result["score"] = sum
		result["label"] = "Normal"

	return result

/datum/dwarven_dice_game
	var/list/mob/living/players = list()
	var/list/scores = list()      // assoc: mob -> score
	var/list/rolled = list()      // assoc: mob -> TRUE/FALSE
	var/list/eliminated = list()  // assoc: mob -> TRUE/FALSE (instant lose)
	var/current_player_index = 0
	var/mob/living/current_player = null
	var/obj/item/storage/pill_bottle/dice/dwarven/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 4
	var/can_initiate_turn_roll = FALSE

/datum/dwarven_dice_game/proc/format_big_die_value(v, color = "#4FC3F7")
	return "<span style='color:[color];font-size:larger;font-weight:bold;'>[v]</span>"

/datum/dwarven_dice_game/proc/get_roll_color_for(mob/living/M)
	var/i = players.Find(M)
	switch(i)
		if(1)
			return "#4FC3F7"
		if(2)
			return "#FF3B3B"
		if(3)
			return "#C9A0DC"
		if(4)
			return "#FF00FF"
		else
			return "#E0E0E0"

/datum/dwarven_dice_game/proc/format_big_roll(list/dice_values, color = "#4FC3F7")
	var/list/parts = list()
	for(var/v in dice_values)
		parts += format_big_die_value(v, color)
	return jointext(parts, " - ")

/datum/dwarven_dice_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Dwarven Dice game has already started."))
		return

	if(joiner in players)
		var/list/opts = list("Leave game")
		if(players.len >= 2)
			opts += "Start game now"
		var/choice = input(joiner, "You are already in the lobby. ([players.len]/[max_players] players)", "Dwarven Dice") as null|anything in opts
		if(choice == "Start game now")
			start_game()
		else if(choice == "Leave game")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner] left the pre-game lobby. ([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("The Dwarven Dice game is full ([max_players]/[max_players])."))
		return

	players += joiner
	scores[joiner] = 0
	rolled[joiner] = FALSE
	eliminated[joiner] = FALSE
	game_bag.visible_message(span_notice("[joiner] joined Dwarven Dice! ([players.len]/[max_players] players)"))
	if(players.len >= max_players)
		start_game()

/datum/dwarven_dice_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller] has cancelled Dwarven Dice!"))
	game_bag.active_game = null
	qdel(src)

/datum/dwarven_dice_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("You are not in this Dwarven Dice game."))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver
	rolled -= leaver
	eliminated -= leaver

	game_bag.visible_message(span_notice("[leaver] leaves Dwarven Dice. ([players.len]/[max_players] players remain)"))

	if(!players.len)
		cancel_game(leaver)
		return

	if(current_player_index > players.len)
		current_player_index = players.len

	if(!joining)
		if(players.len < 2)
			end_round()
			return
		if(was_current)
			current_player_index--
			if(current_player_index < 0)
				current_player_index = 0
			current_player = null
			next_turn()
			return
		if(leaver_index < current_player_index)
			current_player_index--
			if(current_player_index < 0)
				current_player_index = 0
		if(current_player_index >= 1 && current_player_index <= players.len)
			current_player = players[current_player_index]
		else
			current_player = null

/datum/dwarven_dice_game/proc/start_game()
	if(!joining)
		return
	joining = FALSE
	current_player = null
	current_player_index = 0
	for(var/mob/living/M in players)
		scores[M] = 0
		rolled[M] = FALSE
		eliminated[M] = FALSE

	var/list/names = list()
	for(var/mob/living/M in players)
		names += "[M]"
	game_bag.visible_message(span_notice("Dwarven Dice begins! Players: [jointext(names, ", ")]."))
	next_turn()

/datum/dwarven_dice_game/proc/player_is_done(mob/living/M)
	if(!M)
		return TRUE
	if(eliminated[M])
		return TRUE
	if(rolled[M])
		return TRUE
	return FALSE

/datum/dwarven_dice_game/proc/all_players_done()
	for(var/mob/living/M in players)
		if(!player_is_done(M))
			return FALSE
	return TRUE

/datum/dwarven_dice_game/proc/next_turn()
	if(all_players_done())
		end_round()
		return

	var/attempts = 0
	while(attempts < players.len)
		current_player_index++
		if(current_player_index > players.len)
			current_player_index = 1

		var/mob/living/active = players[current_player_index]
		if(!active)
			attempts++
			continue
		if(player_is_done(active))
			attempts++
			continue

		current_player = active
		can_initiate_turn_roll = TRUE
		game_bag.visible_message(span_notice("--- [active]'s turn | [get_score_display()] ---"))
		to_chat(active, span_notice("Use the dice bag menu and choose Roll Dice."))
		return

	end_round()

/datum/dwarven_dice_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("Current totals: [get_score_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("Please wait a moment..."))
		return
	if(user != current_player)
		input(user, "It's not your turn. Totals: [get_score_display()]", "Dwarven Dice") as null|anything in list("OK")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("Turn order is resyncing. Try again in a moment."))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("It is not your turn yet."))
		return
	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("You have already rolled for this turn."))
		return
	if(action != "Roll Dice")
		to_chat(user, span_notice("Choose Roll Dice from the menu."))
		return

	can_initiate_turn_roll = FALSE
	do_roll(user)

/datum/dwarven_dice_game/proc/do_roll(mob/living/active)
	if(active != current_player)
		return
	if(active != players[current_player_index])
		return

	busy = TRUE
	playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)

	var/list/rolled_values = list(rand(1, 6), rand(1, 6), rand(1, 6))

	var/list/eval = dwarven_dice_eval(rolled_values)
	var/score = eval["score"]

	game_bag.visible_message(span_notice("[active] rolls: [format_big_roll(rolled_values, get_roll_color_for(active))]."))

	if(eval["instant_win"])
		scores[active] = score
		rolled[active] = TRUE
		game_bag.visible_message(span_notice("[active] triggers [eval["label"]]! [eval["reason"]]"))
		busy = FALSE
		end_game_with_winner(active)
		return

	if(eval["instant_lose"])
		eliminated[active] = TRUE
		rolled[active] = TRUE
		game_bag.visible_message(span_danger("[active] triggers [eval["label"]]! [eval["reason"]]"))
	else
		scores[active] = score
		rolled[active] = TRUE
		game_bag.visible_message(span_notice("[active] scores [score] ([eval["label"]])."))

	busy = FALSE
	if(all_players_done())
		end_round()
	else
		next_turn()

/datum/dwarven_dice_game/proc/end_game_with_winner(mob/living/winner)
	if(winner)
		game_bag.visible_message(span_green("<b>--- DWARVEN DICE OVER --- [winner] wins instantly!</b>"))
	else
		game_bag.visible_message(span_notice("--- DWARVEN DICE OVER ---"))
	game_bag.active_game = null
	qdel(src)

/datum/dwarven_dice_game/proc/end_round()
	var/list/contenders = list()
	var/best_total = -1

	for(var/mob/living/M in players)
		if(eliminated[M])
			continue
		if(!rolled[M])
			continue
		var/total = scores[M]
		if(total > best_total)
			best_total = total
			contenders = list(M)
		else if(total == best_total)
			contenders += M

	game_bag.visible_message(span_notice("--- DWARVEN DICE ROUND OVER ---<br>Totals: [get_score_display()]"))

	if(!contenders.len)
		game_bag.visible_message(span_warning("No winner. Everyone lost."))
		game_bag.active_game = null
		qdel(src)
		return

	if(contenders.len == 1)
		var/mob/living/champion = contenders[1]
		game_bag.visible_message(span_green("<b>[champion] wins with [scores[champion]]!</b>"))
		game_bag.active_game = null
		qdel(src)
		return

	var/list/names = list()
	for(var/mob/living/M in contenders)
		names += "[M]"
	game_bag.visible_message(span_notice("Tie at [best_total] between [jointext(names, ", ")]."))
	tie_break(contenders)

/datum/dwarven_dice_game/proc/tie_break(list/mob/living/contenders)
	if(!contenders || !contenders.len)
		game_bag.active_game = null
		qdel(src)
		return

	var/list/mob/living/current_contenders = contenders.Copy()
	while(current_contenders.len > 1)
		var/list/names = list()
		for(var/mob/living/M in current_contenders)
			names += "[M]"
		game_bag.visible_message(span_warning("Tie-break! [jointext(names, ", ")] each roll 1d20; highest total wins."))

		var/best_total = -1
		var/list/mob/living/new_contenders = list()
		for(var/mob/living/M in current_contenders)
			var/roll = rand(1, 20)
			scores[M] += roll
			game_bag.visible_message(span_notice("[M] tie-break rolls [format_big_die_value(roll, get_roll_color_for(M))] -> [scores[M]] total."))
			if(scores[M] > best_total)
				best_total = scores[M]
				new_contenders = list(M)
			else if(scores[M] == best_total)
				new_contenders += M

		current_contenders = new_contenders
		if(current_contenders.len > 1)
			game_bag.visible_message(span_notice("Tie-break is still tied at [best_total]. Rolling again."))

	var/mob/living/champion = current_contenders[1]
	game_bag.visible_message(span_green("<b>[champion] wins the tie-break with [scores[champion]]!</b>"))
	game_bag.active_game = null
	qdel(src)

/datum/dwarven_dice_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		var/state = ""
		if(eliminated[M])
			state = " (LOST)"
		else if(rolled[M])
			state = " (ROLLED)"
		parts += "[M]: [scores[M]][state]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/dwarven
	name = "bag of dwarven dice"
	desc = "A bag used to play Dwarven Dice. Activate in hand (Z) to start or join a game."
	var/datum/dwarven_dice_game/active_game
	var/static/dwarven_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>Dwarven Dice</h2>
<br>
<b>Objective:</b> Be the player with the highest total after all players have rolled three dice.<br>
<br>
<b>Rules:</b><br>
- One at a time, each player rolls a d6 three times.<br>
- Highest total wins after everyone has rolled.<br>
- One pair doubles your total.<br>
- Instant WIN: 4-5-6 sequence OR any triple same number.<br>
- Instant LOSE: 1-2-3 sequence OR any paired same number combined with a (1).<br>
</div>"}

/obj/item/storage/pill_bottle/dice/dwarven/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(dwarven_rules_text, "window=dwarven_dice_rules;size=700x450")

/obj/item/storage/pill_bottle/dice/dwarven/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/dice/d6(src)

/obj/item/storage/pill_bottle/dice/dwarven/attack_self(mob/living/user)
	if(active_game && active_game.joining && (user in active_game.players) && active_game.players.len >= 2)
		active_game.start_game()

	var/list/menu = list()
	var/can_show_roll = FALSE
	if(active_game && !active_game.joining)
		if(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.player_is_done(user))
			can_show_roll = TRUE

	if(!active_game)
		menu += "Start Game"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "Start Game"
	else if(can_show_roll)
		menu += "Roll Dice"

	if(menu.len)
		menu += " "
	menu += "Rules"
	menu += "  "
	if(active_game && (user in active_game.players))
		menu += "Leave Game"
		menu += "   "
	menu += "End Game"

	var/choice = input(user, "Select an option.", "Dwarven Dice") as null|anything in menu
	if(!choice)
		return

	if(choice == "Rules")
		show_rules(user)
		return

	if(choice == "End Game")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("No Dwarven Dice game is currently running."))
		return

	if(choice == "Leave Game")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("No Dwarven Dice game is currently running."))
		return

	if(choice == "Roll Dice")
		if(!active_game)
			to_chat(user, span_notice("No Dwarven Dice game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.joining))
			to_chat(user, span_notice("You cannot roll right now."))
			return
		active_game.player_action(user, "Roll Dice")
		return

	if(choice != "Start Game")
		return

	if(!active_game)
		var/count = input(user, "How many players?\n(2 to 4 players)", "Dwarven Dice") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/dwarven_dice_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user] is starting Dwarven Dice! [count - 1] more player(s) needed. Activate (Z) the dice bag to join!"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
