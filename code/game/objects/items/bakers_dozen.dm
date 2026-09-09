/*
 * BAKER'S DOZEN
 * A blackjack-style d6 game for 1-4 players where the target is 13.
 *
 * Rules:
 * - Each player must roll 2d6 (one die at a time).
 * - After the two mandatory rolls, players may either roll one d6 (hit) or stay.
 * - Going over 13 is an immediate bust.
 * - Round ends when every player has stayed, hit exactly 13, or busted.
 * - Highest non-bust total wins.
 * - If top totals tie, tied players repeatedly roll one extra d6 each until one is highest.
 */

/datum/bakers_dozen_game
	var/list/mob/living/players = list()
	var/list/scores = list() // assoc: mob -> current total
	var/list/mandatory_rolls = list() // assoc: mob -> number of required opening rolls completed
	var/list/stayed = list() // assoc: mob -> TRUE/FALSE
	var/list/busted = list() // assoc: mob -> TRUE/FALSE
	var/current_player_index = 0
	var/mob/living/current_player = null
	var/target_score = 13
	var/obj/item/storage/pill_bottle/dice/bakers_dozen/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 4
	var/can_take_turn_action = FALSE

/datum/bakers_dozen_game/proc/format_big_die_value(v, color = "#4FC3F7")
	return "<span style='color:[color];font-size:larger;font-weight:bold;'>[v]</span>"

/datum/bakers_dozen_game/proc/get_roll_color_for(mob/living/M)
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

/datum/bakers_dozen_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Baker's Dozen game has already started."))
		return

	if(joiner in players)
		var/list/opts = list("Leave game")
		if(players.len >= 2)
			opts += "Start game now"
		var/choice = input(joiner, "You are already in the lobby. ([players.len]/[max_players] players)", "Baker's Dozen") as null|anything in opts
		if(choice == "Start game now")
			start_game()
		else if(choice == "Leave game")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner] left the pre-game lobby. ([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("The Baker's Dozen game is full ([max_players]/[max_players])."))
		return

	players += joiner
	game_bag.visible_message(span_notice("[joiner] joined Baker's Dozen! ([players.len]/[max_players] players)"))
	if(players.len >= max_players)
		start_game()

/datum/bakers_dozen_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("You are not in this Baker's Dozen game."))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver
	mandatory_rolls -= leaver
	stayed -= leaver
	busted -= leaver

	game_bag.visible_message(span_notice("[leaver] leaves Baker's Dozen. ([players.len]/[max_players] players remain)"))

	if(!players.len)
		cancel_game(leaver)
		return

	if(current_player_index > players.len)
		current_player_index = players.len

	if(!joining)
		if(players.len == 1)
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

/datum/bakers_dozen_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller] has cancelled Baker's Dozen!"))
	game_bag.active_game = null
	qdel(src)

/datum/bakers_dozen_game/proc/start_game()
	joining = FALSE
	current_player = null
	current_player_index = 0
	for(var/mob/living/M in players)
		scores[M] = 0
		mandatory_rolls[M] = 0
		stayed[M] = FALSE
		busted[M] = FALSE

	var/list/names = list()
	for(var/mob/living/M in players)
		names += "[M]"
	game_bag.visible_message(span_notice("Baker's Dozen begins! Target: [target_score]. Players: [jointext(names, ", ")]."))
	next_turn()

/datum/bakers_dozen_game/proc/player_is_done(mob/living/M)
	if(!M)
		return TRUE
	if(busted[M])
		return TRUE
	if(stayed[M])
		return TRUE
	if(scores[M] >= target_score)
		return TRUE
	return FALSE

/datum/bakers_dozen_game/proc/all_players_done()
	for(var/mob/living/M in players)
		if(!player_is_done(M))
			return FALSE
	return TRUE

/datum/bakers_dozen_game/proc/next_turn()
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
		can_take_turn_action = TRUE

		game_bag.visible_message(span_notice("--- [active]'s turn | [get_score_display()] ---"))
		if(mandatory_rolls[active] < 2)
			to_chat(active, span_notice("Opening phase: choose Roll Opening Dice from the dice bag menu."))
		else
			to_chat(active, span_notice("Choose Hit or Stay from the dice bag menu. Target: [target_score]."))
		return

	end_round()

/datum/bakers_dozen_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("Current totals: [get_score_display()]"))
		return

	if(busy)
		to_chat(user, span_notice("Please wait a moment..."))
		return

	if(user != current_player)
		input(user, "It's not your turn. Totals: [get_score_display()]", "Baker's Dozen") as null|anything in list("OK")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("Turn order is resyncing. Try again in a moment."))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("It is not your turn yet."))
		return
	if(!can_take_turn_action)
		to_chat(user, span_notice("You have already acted this turn."))
		return

	if(player_is_done(user))
		to_chat(user, span_notice("You're done for this round. Totals: [get_score_display()]"))
		next_turn()
		return

	if(mandatory_rolls[user] < 2)
		if(action != "Roll Opening Dice")
			to_chat(user, span_notice("Choose Roll Opening Dice from the menu."))
			return
		can_take_turn_action = FALSE
		do_opening_rolls(user)
		return

	if(action == "Stay")
		can_take_turn_action = FALSE
		stayed[user] = TRUE
		game_bag.visible_message(span_notice("[user] stays at [scores[user]]."))
		if(all_players_done())
			end_round()
		else
			next_turn()
		return
	if(action != "Hit - roll 1d6")
		to_chat(user, span_notice("Choose Hit or Stay from the menu."))
		return
	can_take_turn_action = FALSE
	do_roll(user, FALSE)

/datum/bakers_dozen_game/proc/do_opening_rolls(mob/living/active)
	while(mandatory_rolls[active] < 2 && !busted[active] && scores[active] < target_score)
		do_roll(active, TRUE, FALSE)
		if(all_players_done())
			break

	if(all_players_done())
		end_round()
	else
		next_turn()

/datum/bakers_dozen_game/proc/do_roll(mob/living/active, mandatory = FALSE, advance_turn = TRUE)
	busy = TRUE
	playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)

	var/roll = rand(1, 6)
	var/old_total = scores[active]
	scores[active] = old_total + roll
	if(mandatory)
		mandatory_rolls[active]++

	game_bag.visible_message(span_notice("[active] rolls [format_big_die_value(roll, get_roll_color_for(active))]! Total: [scores[active]] / [target_score]."))

	if(scores[active] > target_score)
		busted[active] = TRUE
		game_bag.visible_message(span_danger("[active] busts at [scores[active]]!"))
	else if(scores[active] == target_score)
		game_bag.visible_message(span_green("<b>[active] hit BAKER'S DOZEN exactly!</b>"))

	busy = FALSE

	if(!advance_turn)
		return

	if(all_players_done())
		end_round()
	else
		next_turn()

/datum/bakers_dozen_game/proc/end_round()
	var/list/contenders = list()
	var/best_total = -1

	for(var/mob/living/M in players)
		if(busted[M])
			continue
		var/total = scores[M]
		if(total > best_total)
			best_total = total
			contenders = list(M)
		else if(total == best_total)
			contenders += M

	game_bag.visible_message(span_notice("--- BAKER'S DOZEN ROUND OVER ---<br>Totals: [get_score_display()]"))

	if(!contenders.len)
		game_bag.visible_message(span_warning("Everyone busted. No winner this round."))
		game_bag.active_game = null
		qdel(src)
		return

	if(contenders.len == 1)
		var/mob/living/champion = contenders[1]
		game_bag.visible_message(span_green("<b>[champion] wins with [scores[champion]]!</b>"))
		game_bag.active_game = null
		qdel(src)
		return

	tie_break(contenders)

/datum/bakers_dozen_game/proc/tie_break(list/mob/living/contenders)
	while(contenders.len > 1)
		var/list/names = list()
		for(var/mob/living/M in contenders)
			names += "[M]"
		game_bag.visible_message(span_warning("Tie at [scores[contenders[1]]] between [jointext(names, ", ")]! Tie-break roll!"))

		var/list/new_contenders = list()
		var/best_total = -1
		for(var/mob/living/M in contenders)
			var/roll = rand(1, 6)
			scores[M] += roll
			game_bag.visible_message(span_notice("[M] tie-break rolls [format_big_die_value(roll, get_roll_color_for(M))] -> [scores[M]] total."))
			if(scores[M] > best_total)
				best_total = scores[M]
				new_contenders = list(M)
			else if(scores[M] == best_total)
				new_contenders += M

		if(!new_contenders.len)
			game_bag.visible_message(span_warning("Tie-break ended with no active contenders."))
			game_bag.active_game = null
			qdel(src)
			return

		contenders = new_contenders

	var/mob/living/champion = contenders[1]
	game_bag.visible_message(span_green("<b>[champion] wins Baker's Dozen with [scores[champion]]!</b>"))
	game_bag.active_game = null
	qdel(src)

/datum/bakers_dozen_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		var/state = ""
		if(busted[M])
			state = " (BUST)"
		else if(stayed[M])
			state = " (STAY)"
		else if(scores[M] == target_score)
			state = " (BAKER'S DOZEN)"
		parts += "[M]: [scores[M]][state]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/bakers_dozen
	name = "bag of baker's dozen dice"
	desc = "A set of dice for Baker's Dozen. Activate in hand (Z) to start or join a game."
	var/datum/bakers_dozen_game/active_game
	var/static/bakers_dozen_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
<h2 style='text-align:center;margin:0 0 6px 0;'>Baker's Dozen</h2>
<br>
<b>Objective:</b> A blackjack-style d6 game for 1-4 players where the target is to get as close to 13 as possible.<br>
<br>
<b>Rules:</b><br>
- Each player must roll 2d6 (one die at a time).<br>
- After the two mandatory rolls, players may either roll one d6 (hit) or stay.<br>
- Going over 13 is an immediate bust.<br>
- The round ends when every player has stayed, hits exactly 13, or busted.<br>
- Highest non-bust total wins.<br>
- If top totals tie, tied players repeatedly roll one extra d6 each until whoever gets the highest.<br>
</div>"}

/obj/item/storage/pill_bottle/dice/bakers_dozen/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(bakers_dozen_rules_text, "window=bakers_dozen_rules;size=700x450")

/obj/item/storage/pill_bottle/dice/bakers_dozen/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/dice/d6(src)

/obj/item/storage/pill_bottle/dice/bakers_dozen/attack_self(mob/living/user)
	if(active_game && active_game.joining && (user in active_game.players) && active_game.players.len >= 2)
		active_game.start_game()

	var/list/menu = list()
	var/gap1 = " "
	var/gap2 = "  "
	var/gap3 = "   "
	var/gap4 = "    "
	var/can_show_opening_roll = FALSE
	var/can_show_actions = FALSE
	if(active_game && !active_game.joining)
		if(user == active_game.current_player && active_game.can_take_turn_action && !active_game.player_is_done(user) && active_game.mandatory_rolls[user] < 2)
			can_show_opening_roll = TRUE
		if(user == active_game.current_player && active_game.can_take_turn_action && !active_game.player_is_done(user) && active_game.mandatory_rolls[user] >= 2)
			can_show_actions = TRUE

	if(!active_game)
		menu += "Start Game"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "Start Game"
	else if(can_show_opening_roll)
		menu += "Roll Opening Dice"
	else if(can_show_actions)
		menu += "Hit - roll 1d6"
		menu += gap1
		menu += "Stay"

	if(menu.len)
		menu += gap2
	menu += "Rules"
	menu += gap3
	if(active_game && (user in active_game.players))
		menu += "Leave Game"
		menu += gap4
	menu += "End Game"

	var/choice = input(user, "Select an option.", "Baker's Dozen Dice") as null|anything in menu

	if(!choice)
		return

	if(choice == "Rules")
		show_rules(user)
		return

	if(choice == "End Game")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("No Baker's Dozen game is currently running."))
		return

	if(choice == "Leave Game")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("No Baker's Dozen game is currently running."))
		return

	if(choice == "Roll Opening Dice")
		if(!active_game)
			to_chat(user, span_notice("No Baker's Dozen game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_take_turn_action && !active_game.joining && active_game.mandatory_rolls[user] < 2))
			to_chat(user, span_notice("You cannot roll opening dice right now."))
			return
		active_game.player_action(user, "Roll Opening Dice")
		return

	if(choice == "Hit - roll 1d6")
		if(!active_game)
			to_chat(user, span_notice("No Baker's Dozen game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_take_turn_action && !active_game.joining))
			to_chat(user, span_notice("You cannot hit right now."))
			return
		active_game.player_action(user, "Hit - roll 1d6")
		return

	if(choice == "Stay")
		if(!active_game)
			to_chat(user, span_notice("No Baker's Dozen game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_take_turn_action && !active_game.joining))
			to_chat(user, span_notice("You cannot stay right now."))
			return
		active_game.player_action(user, "Stay")
		return

	if(choice != "Start Game")
		return

	if(!active_game)
		var/count = input(user, "How many players?\n(2 to 4 players)", "Baker's Dozen") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/bakers_dozen_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)

		src.visible_message(span_notice("[user] is starting Baker's Dozen! [count - 1] more player(s) needed. Activate (Z) the dice bag to join!"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
