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
	var/turn_score = 0
	var/dice_to_roll = 6
	var/target_score = 10000
	var/obj/item/storage/pill_bottle/dice/farkle/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 4
	var/winner_mob = null             // first player to reach target
	var/final_round = FALSE


// --- Joining Phase ---

/datum/farkle_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Farkle game has already started."))
		return

	if(joiner in players)
		// Already in - let them start early, leave, or cancel the whole game
		var/list/opts = list("Leave game", "Cancel game")
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
		else if(choice == "Cancel game")
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


// --- Game Start ---

/datum/farkle_game/proc/start_game()
	joining = FALSE
	var/list/names = list()
	for(var/mob/M in players)
		names += "[M]"
	game_bag.visible_message(span_notice("Farkle begins! First to [target_score] points wins. Players: [jointext(names, ", ")]. Good luck!"))
	next_turn()


// --- Turn Management ---

/datum/farkle_game/proc/next_turn()
	current_player_index++
	if(current_player_index > players.len)
		current_player_index = 1
	var/mob/living/active = players[current_player_index]

	// End the game when winner_mob comes around again in the final round
	if(final_round && active == winner_mob)
		end_game()
		return

	// Skip disconnected players
	if(!active.client)
		if(players.len <= 1)
			end_game()
			return
		next_turn()
		return

	turn_score = 0
	dice_to_roll = 6

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

	if(user != players[current_player_index])
		// Not their turn - offer a cancel option so someone can still bail out
		var/choice = input(user, "It's not your turn. Scores: [get_score_display()]", "Farkle") as null|anything in list("OK", "Cancel game")
		if(choice == "Cancel game")
			cancel_game(user)
		return

	// Active player options
	var/choice = input(user, "It's your turn! Scores: [get_score_display()]", "Farkle") as null|anything in list("Roll dice", "Cancel game")
	if(choice == "Cancel game")
		cancel_game(user)
		return

	do_roll(user)


// --- Roll and Scoring Phase ---

/datum/farkle_game/proc/do_roll(mob/living/active)
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
	var/list/roll_strings = list()
	for(var/v in rolled)
		roll_strings += "[v]"
	game_bag.visible_message(span_notice("[active] dumps the dice! ([dice_to_roll]d6): [jointext(roll_strings, " - ")]"))

	// Check for Farkle: no scoring dice at all
	if(!farkle_get_plays(rolled).len)
		game_bag.visible_message(span_danger("FARKLE! [active] has no scoring dice and loses [turn_score] accumulated points!"))
		busy = FALSE
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
		scores[active] += turn_score
		game_bag.visible_message(span_notice("[active] banks [turn_score] pts! [active] now has [scores[active]] total."))

		if(scores[active] >= target_score && !final_round)
			winner_mob = active
			final_round = TRUE
			game_bag.visible_message(span_notice("[active] reached [scores[active]] points! All remaining players get ONE final turn to beat it!"))

		busy = FALSE
		next_turn()
	else
		// Roll again (spawn to avoid proc stack buildup across many re-rolls)
		busy = FALSE
		var/datum/farkle_game/game_ref = src
		spawn(0)
			game_ref.do_roll(active)


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

	game_bag.visible_message(span_notice("--- FARKLE GAME OVER --- Final scores: [get_score_display()]"))
	if(champion)
		game_bag.visible_message(span_notice("[champion] wins with [top] points! Congratulations!"))
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

/obj/item/storage/pill_bottle/dice/farkle/attack_self(mob/living/user)
	if(!active_game)
		// No game running - offer to start one
		var/choice = input(user, "No Farkle game is running.\n\nActivate a game to start playing!", "Farkle Dice") as null|anything in list("Start a new game", "Cancel")
		if(choice != "Start a new game")
			return

		var/count = input(user, "How many players?\n(Choose 1 for solitaire - try to hit [10000] points!)", "Farkle") as null|anything in list(1, 2, 3, 4)
		if(!count)
			return

		var/datum/farkle_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)

		if(count > 1)
			src.visible_message(span_notice("[user] is starting a Farkle game! [count - 1] more player(s) needed. Activate (Z) the dice bag to join!"))

	else if(active_game.joining)
		// Game waiting for players - join the lobby
		active_game.try_join(user)

	else
		// Game in progress - take your turn or check scores
		active_game.player_action(user)
