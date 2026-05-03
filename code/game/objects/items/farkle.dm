/*
 * FARKLE
 * A classic roll-and-bank dice game for 1-4 players.
 * First to 10,000 points wins!
 *
 * Scoring:
 *   Single 1                   = 100 pts
 *   Single 5                   = 50 pts
 *   Three of a kind            = face × 100 pts (1s = 1000)
 *   Four / Five / Six of a kind = 2× / 3× / 4× the three-of-a-kind score
 *   Straight (1-2-3-4-5-6)    = 1500 pts
 *   Three pairs                = 750 pts
 *   Farkle (no scoring dice)   = lose all accumulated turn points
 *
 * To play: Hold the bag of farkle dice and press Z (activate in hand),
 * or right-click it and choose "Activate".
 * Other players join by activating the same bag before the game starts.
 */

// ===================== SCORING PROC =====================
// Returns a list of available scoring plays given a set of dice values.
// Each play is an associative list: ("name", "score", "dice")
// where "dice" is a list of the face values consumed by that play.

/proc/farkle_get_plays(list/dice_values) as list
	var/list/plays = list()
	if(!dice_values.len)
		return plays

	// Tally face counts (counts[1] = number of 1s, etc.)
	var/list/counts = list(0, 0, 0, 0, 0, 0)
	for(var/v in dice_values)
		counts[v]++

	// Straight: exactly 6 dice, one of each face (1-2-3-4-5-6)
	if(dice_values.len == 6)
		var/is_straight = TRUE
		for(var/f in 1 to 6)
			if(counts[f] != 1)
				is_straight = FALSE
				break
		if(is_straight)
			plays += list(list("name" = "Straight (1-6)", "score" = 1500, "dice" = dice_values.Copy()))
			return plays

	// Three pairs: exactly 6 dice forming three different pairs
	if(dice_values.len == 6)
		var/pair_count = 0
		for(var/f in 1 to 6)
			if(counts[f] == 2)
				pair_count++
		if(pair_count == 3)
			plays += list(list("name" = "Three Pairs", "score" = 750, "dice" = dice_values.Copy()))
			return plays

	// N-of-a-kind for each face, plus singles for 1s and 5s
	for(var/face in 1 to 6)
		var/cnt = counts[face]
		if(!cnt)
			continue
		var/base = (face == 1) ? 1000 : (face * 100)
		if(cnt >= 3)
			var/n = min(cnt, 6)
			var/score = base
			if(n == 4)      score *= 2
			else if(n == 5) score *= 3
			else if(n == 6) score *= 4
			var/list/used = list()
			for(var/i in 1 to n)
				used += face
			plays += list(list("name" = "[n]x [face]s", "score" = score, "dice" = used))
		else
			// Only 1s and 5s score as singles
			if(face == 1)
				plays += list(list("name" = "Single 1", "score" = 100, "dice" = list(1)))
			if(face == 5)
				plays += list(list("name" = "Single 5", "score" = 50, "dice" = list(5)))

	return plays


// ===================== GAME DATUM =====================

/datum/farkle_game
	var/list/mob/living/players = list()
	var/list/scores = list()          // assoc: mob -> score
	var/current_player_index = 0
	var/mob/living/current_player = null
	var/turn_score = 0
	var/dice_to_roll = 6
	var/target_score = 10000
	var/obj/item/storage/pill_bottle/dice/farkle/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 4
	var/winner_mob = null             // first player to reach target
	var/final_round = FALSE
	var/turn_token = 0                // incremented every new turn to invalidate stale roll requests
	var/can_initiate_turn_roll = FALSE // only the queued player may trigger one menu roll per turn

/datum/farkle_game/proc/format_big_die_value(v, color = "#4FC3F7")
	return "<span style='color:[color];font-size:larger;font-weight:bold;'>[v]</span>"

/datum/farkle_game/proc/get_roll_color_for(mob/living/M)
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

/datum/farkle_game/proc/format_big_roll(list/dice_values, color = "#4FC3F7")
	var/list/parts = list()
	for(var/v in dice_values)
		parts += format_big_die_value(v, color)
	return jointext(parts, " - ")


// --- Joining Phase ---

/datum/farkle_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Farkle game has already started."))
		return

	if(joiner in players)
		// Already in - let them start early or leave
		var/list/opts = list("Leave game")
		if(players.len >= 2)
			opts += "Start game now"
		var/choice = input(joiner, "You are already in the lobby. ([players.len]/[max_players] players)", "Farkle") as null|anything in opts
		if(choice == "Start game now")
			start_game()
		else if(choice == "Leave game")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner] left the pre-game lobby. ([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("The Farkle game is full ([max_players]/[max_players])."))
		return

	players += joiner
	scores[joiner] = 0
	game_bag.visible_message(span_notice("[joiner] joined the Farkle game! ([players.len]/[max_players] players)"))
	if(players.len >= max_players)
		start_game()


// --- Cancel Game ---
/datum/farkle_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller] has cancelled the Farkle game!"))
	game_bag.active_game = null
	qdel(src)

/datum/farkle_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("You are not in this Farkle game."))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver

	game_bag.visible_message(span_notice("[leaver] leaves the Farkle game. ([players.len]/[max_players] players remain)"))

	if(!players.len)
		cancel_game(leaver)
		return

	if(!joining)
		if(players.len == 1)
			end_game()
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


// --- Game Start ---

/datum/farkle_game/proc/start_game()
	joining = FALSE
	current_player = null
	current_player_index = 0
	var/list/names = list()
	for(var/mob/M in players)
		names += "[M]"
	game_bag.visible_message(span_notice("Farkle begins! First to [target_score] points wins. Players: [jointext(names, ", ")]. Good luck!"))
	next_turn()


// --- Turn Management ---

/datum/farkle_game/proc/next_turn()
	if(!players.len)
		end_game()
		return

	current_player_index++
	if(current_player_index > players.len)
		current_player_index = 1

	var/mob/living/active = players[current_player_index]
	if(!active)
		end_game()
		return

	current_player = active

	// End the game when winner_mob comes around again in the final round
	if(final_round && active == winner_mob)
		end_game()
		return

	turn_score = 0
	dice_to_roll = 6
	turn_token++
	can_initiate_turn_roll = TRUE

	game_bag.visible_message(span_notice("--- [active]'s turn [final_round ? "(FINAL ROUND)" : ""] | [get_score_display()] ---"))
	to_chat(active, span_notice("It's your turn! Activate (Z) the dice bag to roll."))


// --- Player Interaction Entry Point ---

/datum/farkle_game/proc/player_action(mob/living/user)
	if(!(user in players))
		to_chat(user, span_notice("Current scores: [get_score_display()]"))
		return

	if(busy)
		to_chat(user, span_notice("Please wait a moment..."))
		return

	if(user != current_player)
		// Not their turn
		input(user, "It's not your turn. Scores: [get_score_display()]", "Farkle") as null|anything in list("OK")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("Turn order is resyncing. Try again in a moment."))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("It is not your turn yet."))
		return

	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("You have already rolled for this turn. Finish your turn prompts or wait for the next turn."))
		return

	can_initiate_turn_roll = FALSE

	// Active player action is immediate from the main menu Roll Dice button.
	do_roll(user, turn_token)


// --- Roll and Scoring Phase ---

/datum/farkle_game/proc/do_roll(mob/living/active, expected_turn_token)
	if(expected_turn_token != turn_token)
		return
	if(active != current_player)
		return
	if(current_player_index < 1 || current_player_index > players.len)
		return
	if(active != players[current_player_index])
		return
	busy = TRUE

	// Wind-up: shake animation + sound, then a short pause before revealing results
	game_bag.visible_message(span_notice("[active] rattles the dice bag..."))
	playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)

	// Pixel shake animation on the bag
	var/oldx = game_bag.pixel_x
	for(var/i in 1 to 3)
		animate(game_bag, pixel_x = oldx + 3, time = 1)
		animate(pixel_x = oldx - 3, time = 1)
		animate(pixel_x = oldx, time = 1)
	sleep(8)  // ~0.8s pause - enough to feel deliberate

	// Roll all active dice
	var/list/rolled = list()
	for(var/i in 1 to dice_to_roll)
		rolled += rand(1, 6)
	game_bag.visible_message(span_notice("[active] dumps the dice! ([dice_to_roll]d6): [format_big_roll(rolled, get_roll_color_for(active))]"))

	// Check for Farkle: no scoring dice at all
	if(!farkle_get_plays(rolled).len)
		game_bag.visible_message(span_danger("<b>FARKLE!</b> [active] has no scoring dice and loses [turn_score] accumulated points!"))
		busy = FALSE
		if(expected_turn_token != turn_token)
			return
		can_initiate_turn_roll = FALSE
		next_turn()
		return

	// --- Scoring selection loop ---
	var/list/remaining = rolled.Copy()
	var/turn_so_far = 0
	var/first_pick = TRUE
	var/null_count = 0

	while(remaining.len)
		var/list/available = farkle_get_plays(remaining)
		if(!available.len)
			break  // no more scoring plays in the remaining dice

		// Build the input menu
		var/list/menu = list()
		for(var/list/play in available)
			menu += "[play["name"]] (+[play["score"]] pts)"
		if(!first_pick)
			menu += "Done picking"

		var/list/rem_str = list()
		for(var/v in remaining)
			rem_str += "[v]"
		var/chosen = input(active, "Remaining dice: [jointext(rem_str, " - ")]\nTurn total so far: [turn_score + turn_so_far] pts\nPick a scoring combination to keep:", "Farkle") as null|anything in menu

		// Null = cancelled/disconnected - safety valve
		if(!chosen)
			null_count++
			if(null_count >= 3 || !first_pick)
				break
			continue

		null_count = 0

		if(chosen == "Done picking")
			break

		// Match the selection to a play
		var/list/chosen_play = null
		for(var/list/play in available)
			if("[play["name"]] (+[play["score"]] pts)" == chosen)
				chosen_play = play
				break
		if(!chosen_play)
			break

		turn_so_far += chosen_play["score"]
		// Remove used dice from the remaining pool (one at a time)
		for(var/v in chosen_play["dice"])
			remaining.Remove(v)

		first_pick = FALSE

	// If nothing was scored (disconnect edge case), just pass the turn
	if(!turn_so_far)
		busy = FALSE
		if(expected_turn_token != turn_token)
			return
		can_initiate_turn_roll = FALSE
		next_turn()
		return

	turn_score += turn_so_far
	dice_to_roll = remaining.len

	// Hot dice: all 6 used up - player may roll all 6 again
	if(!dice_to_roll)
		game_bag.visible_message(span_notice("HOT DICE! [active] used all their dice! Rolling all 6 again. (Turn: [turn_score] pts)"))
		dice_to_roll = 6

	// --- Bank or keep rolling ---
	var/list/options = list(
		"Bank [turn_score] pts (total would be: [scores[active] + turn_score])",
		"Keep rolling ([dice_to_roll] dice)"
	)

	var/decision = input(active, "Turn so far: [turn_score] pts | Score if banked: [scores[active] + turn_score]\nWhat do you do?", "Farkle") as null|anything in options

	if(!decision || decision == "Bank [turn_score] pts (total would be: [scores[active] + turn_score])")
		// Bank the points
		if(expected_turn_token != turn_token)
			busy = FALSE
			return
		scores[active] += turn_score
		game_bag.visible_message(span_notice("[active] banks [turn_score] pts! [active] now has [scores[active]] total."))

		if(scores[active] >= target_score && !final_round)
			winner_mob = active
			final_round = TRUE
			game_bag.visible_message(span_notice("[active] reached [scores[active]] points! All remaining players get ONE final turn to beat it!"))

		busy = FALSE
		can_initiate_turn_roll = FALSE
		next_turn()
	else
		// Roll again (spawn to avoid proc stack buildup across many re-rolls)
		var/datum/farkle_game/game_ref = src
		var/token_snapshot = expected_turn_token
		spawn(0)
			game_ref.do_roll(active, token_snapshot)


// --- Utilities ---

/datum/farkle_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/M in players)
		parts += "[M]: [scores[M]] pts"
	return jointext(parts, " | ")


/datum/farkle_game/proc/end_game()
	var/mob/living/champion = null
	var/top = -1
	for(var/mob/M in players)
		if(scores[M] > top)
			top = scores[M]
			champion = M

	game_bag.visible_message(span_notice("--- FARKLE GAME OVER ---<br>Final scores: [get_score_display()]"))
	if(champion)
		game_bag.visible_message(span_green("<b>[champion] wins with [top] points! Congratulations!</b>"))
	else
		game_bag.visible_message(span_notice("It's a tie!"))

	game_bag.active_game = null
	qdel(src)


// ===================== DICE BAG EXTENSION =====================
// Adds active_game tracking and attack_self (activate-in-hand) interaction
// to the existing /obj/item/storage/pill_bottle/dice/farkle type.

/obj/item/storage/pill_bottle/dice/farkle
	desc = "Six dice for the game of Farkle. Activate in hand (Z) to start or join a game!"
	var/datum/farkle_game/active_game
	var/static/farkle_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>Farkle</h2>
<br>
<b>Objective:</b> Be the player with the highest score over 10,000.<br>
<br>
- Single 1s and 5s are worth points.<br>
- Other numbers count if you get three or more of the same number in a single roll.<br>
- Other combinations of numbers are worth points if you get them in a single roll. Note: Dice from multiple rolls cannot be added together. For example, if you set aside one 5 (50 points) on your first roll and two 5s (100 points) on your second roll, you have 150 points. You cannot add them together to make three 5s (500 points).<br>
- Some scoring dice must be removed after every roll.<br>
- When it's your turn, place the six Dice in the Shaker Cup and roll 'em. Any Dice that roll off the playing area are rolled again.<br>
- After each roll, set aside Dice that are worth points and roll the rest of them. You must remove at least one Die after each roll and keep a running total of your points for that turn.<br>
- If you're lucky enough to set aside all six Dice, you can roll them all again to build your running total.<br>
- If you cannot set aside any Dice after a roll, that's a Farkle. You lose your running total of points for that turn and play passes to the left. A Farkle could happen on your first roll or when you roll the remaining Dice.<br>
<br>
<b>Winning:</b> When a player's accumulated score is 10,000 or more, each of the other players has one last turn to beat that total. The player with the highest score wins.<br>
<br>
<b>Scoring:</b><br>
Single 1 = 100<br>
Single 5 = 50<br>
Three 1s = 300<br>
Three 2s = 200<br>
Three 3s = 300<br>
Three 4s = 400<br>
Three 5s = 500<br>
Three 6s = 600<br>
Four of any number = 1,000<br>
Five of any number = 2,000<br>
Six of any number = 3,000<br>
1-6 straight = 1,500<br>
Three pairs = 1,500<br>
Four of any number with a pair = 1,500<br>
Two triplets = 2,500
</div>"}

/obj/item/storage/pill_bottle/dice/farkle/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(farkle_rules_text, "window=farkle_rules;size=700x700")

/obj/item/storage/pill_bottle/dice/farkle/attack_self(mob/living/user)
	var/list/menu = list()
	var/can_show_roll = FALSE
	if(active_game && !active_game.joining)
		if(user == active_game.current_player && active_game.can_initiate_turn_roll)
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

	var/choice = input(user, "Select an option.", "Farkle Dice") as null|anything in menu

	if(!choice)
		return

	if(choice == "Rules")
		show_rules(user)
		return

	if(choice == "End Game")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("No Farkle game is currently running."))
		return

	if(choice == "Leave Game")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("No Farkle game is currently running."))
		return

	if(choice == "Roll Dice")
		if(!active_game)
			to_chat(user, span_notice("No Farkle game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll))
			to_chat(user, span_notice("You cannot roll right now."))
			return
		if(active_game.joining)
			to_chat(user, span_notice("At least two players must join, then start the game before rolling."))
		else
			active_game.player_action(user)
		return

	if(choice != "Start Game")
		return

	if(!active_game)
		var/count = input(user, "How many players?\n(2 to 4 players)", "Farkle") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/farkle_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)

		if(count > 1)
			src.visible_message(span_notice("[user] is starting a Farkle game! [count - 1] more player(s) needed. Activate (Z) the dice bag to join!"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user)
