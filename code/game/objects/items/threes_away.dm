/*
 * THREE'S AWAY
 * A 2-4 player d6 game.
 *
 * Rules:
 * - One at a time, all players roll 5d6.
 * - After every roll, one dice must be set aside.
 * - Continue rolling remaining dice until all five are set aside.
 * - Lowest score wins.
 * - 3s are worth 0, 1s are valuable low dice.
 * - If you roll three 3s during your turn, your score is wiped to 0.
 * - If you roll four or more 3s on a roll, you bust and are disqualified.
 */

/datum/threes_away_game
	var/list/mob/living/players = list()
	var/list/scores = list()         // assoc: mob -> score
	var/list/rolled = list()         // assoc: mob -> TRUE/FALSE
	var/list/busted = list()         // assoc: mob -> TRUE/FALSE
	var/list/ante_doubled = list()   // assoc: mob -> TRUE/FALSE (round reminder)
	var/current_player_index = 0
	var/mob/living/current_player = null
	var/obj/item/storage/pill_bottle/dice/threes_away/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 4
	var/can_initiate_turn_roll = FALSE

/datum/threes_away_game/proc/format_big_die_value(v, color = null)
	if(!color)
		color = (v == 3) ? "#bb2c29" : "#4FC3F7"
	return "<span style='color:[color];font-size:larger;font-weight:bold;'>[v]</span>"

/datum/threes_away_game/proc/get_roll_color_for(mob/living/M)
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

/datum/threes_away_game/proc/format_big_roll(list/dice_values, color = null)
	var/list/parts = list()
	for(var/v in dice_values)
		parts += format_big_die_value(v, color)
	return jointext(parts, " - ")

/datum/threes_away_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Three's Away game has already started."))
		return

	if(joiner in players)
		var/list/opts = list("Leave game")
		if(players.len >= 2)
			opts += "Start game now"
		var/choice = input(joiner, "You are already in the lobby. ([players.len]/[max_players] players)", "Three's Away") as null|anything in opts
		if(choice == "Start game now")
			start_game()
		else if(choice == "Leave game")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner] left the pre-game lobby. ([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("The Three's Away game is full ([max_players]/[max_players])."))
		return

	players += joiner
	scores[joiner] = 0
	rolled[joiner] = FALSE
	busted[joiner] = FALSE
	ante_doubled[joiner] = FALSE
	game_bag.visible_message(span_notice("[joiner] joined Three's Away! ([players.len]/[max_players] players)"))
	if(players.len >= max_players)
		start_game()

/datum/threes_away_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("You are not in this Three's Away game."))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver
	rolled -= leaver
	busted -= leaver
	ante_doubled -= leaver

	game_bag.visible_message(span_notice("[leaver] leaves Three's Away. ([players.len]/[max_players] players remain)"))

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

/datum/threes_away_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller] has cancelled Three's Away!"))
	game_bag.active_game = null
	qdel(src)

/datum/threes_away_game/proc/start_game()
	if(!joining)
		return
	joining = FALSE
	current_player = null
	current_player_index = 0
	for(var/mob/living/M in players)
		scores[M] = 0
		rolled[M] = FALSE
		busted[M] = FALSE
		ante_doubled[M] = FALSE

	var/list/names = list()
	for(var/mob/living/M in players)
		names += "[M]"
	game_bag.visible_message(span_notice("Three's Away begins! Players: [jointext(names, ", ")]."))
	next_turn()

/datum/threes_away_game/proc/player_is_done(mob/living/M)
	if(!M)
		return TRUE
	if(rolled[M])
		return TRUE
	return FALSE

/datum/threes_away_game/proc/all_players_done()
	for(var/mob/living/M in players)
		if(!player_is_done(M))
			return FALSE
	return TRUE

/datum/threes_away_game/proc/next_turn()
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


/datum/threes_away_game/proc/choose_kept_die(mob/living/active, list/current_roll)
	var/list/roll_counts = list(0, 0, 0, 0, 0, 0)
	for(var/v in current_roll)
		roll_counts[v]++

	var/list/menu = list()
	for(var/face in 1 to 6)
		if(roll_counts[face] > 0)
			menu += "[face]"

	var/choice = input(active, "Select exactly one die to keep & set aside this roll.", "Three's Away") as null|anything in menu
	if(!choice)
		for(var/f in 1 to 6)
			if(roll_counts[f] > 0)
				to_chat(active, span_notice("No die selected; automatically keeping one [f]."))
				return f
		return current_roll[1]

	for(var/f in 1 to 6)
		if(roll_counts[f] <= 0)
			continue
		if(choice == "[f]")
			return f

	return current_roll[1]

/datum/threes_away_game/proc/do_full_turn_roll(mob/living/active)
	busy = TRUE

	var/remaining_dice = 5
	var/list/kept_values = list()
	var/total_threes_rolled = 0
	var/next_three_wipe_threshold = 3
	var/score_total = 0

	while(remaining_dice > 0)
		playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)
		var/list/current_roll = list()
		for(var/i in 1 to remaining_dice)
			current_roll += rand(1, 6)

		var/count_threes_this_roll = 0
		for(var/v in current_roll)
			if(v == 3)
				count_threes_this_roll++
		total_threes_rolled += count_threes_this_roll

		game_bag.visible_message(span_notice("[active] rolls ([remaining_dice]d6): [format_big_roll(current_roll, get_roll_color_for(active))]."))

		if(count_threes_this_roll >= 4)
			busted[active] = TRUE
			rolled[active] = TRUE
			ante_doubled[active] = TRUE
			game_bag.visible_message(span_danger("[active] rolled four or more 3s and BUSTS! Their ante is doubled for the next pot."))
			busy = FALSE
			if(all_players_done())
				end_round()
			else
				next_turn()
			return

		while(total_threes_rolled >= next_three_wipe_threshold)
			score_total = 0
			next_three_wipe_threshold += 3
			game_bag.visible_message(span_notice("[active] has rolled three more 3s during the turn! Their score is wiped to 0 again."))

		var/kept_now = choose_kept_die(active, current_roll)
		kept_values += kept_now
		if(kept_now != 3)
			score_total += kept_now
		remaining_dice--
		if(remaining_dice < 0)
			remaining_dice = 0
		to_chat(active, span_notice("You keep [format_big_die_value(kept_now, get_roll_color_for(active))]. [remaining_dice] roll(s) left."))

	scores[active] = score_total
	rolled[active] = TRUE

	game_bag.visible_message(span_notice("[active] sets aside: [format_big_roll(kept_values, get_roll_color_for(active))]. Final score: [score_total]."))

	busy = FALSE
	if(all_players_done())
		end_round()
	else
		next_turn()

/datum/threes_away_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("Current totals: [get_score_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("Please wait a moment..."))
		return
	if(user != current_player)
		input(user, "It's not your turn. Totals: [get_score_display()]", "Three's Away") as null|anything in list("OK")
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
	do_full_turn_roll(user)

/datum/threes_away_game/proc/end_round()
	var/list/contenders = list()
	var/best_score = 999999

	for(var/mob/living/M in players)
		if(busted[M])
			continue
		if(!rolled[M])
			continue
		var/total = scores[M]
		if(total < best_score)
			best_score = total
			contenders = list(M)
		else if(total == best_score)
			contenders += M

	game_bag.visible_message(span_notice("--- THREE'S AWAY ROUND OVER ---<br>Totals: [get_score_display()]"))

	if(!contenders.len)
		game_bag.visible_message(span_warning("No winner. Everyone busted."))
		announce_ante_doubles()
		game_bag.active_game = null
		qdel(src)
		return

	if(contenders.len == 1)
		var/mob/living/champion = contenders[1]
		game_bag.visible_message(span_green("<b>[champion] wins with the lowest score: [scores[champion]]!</b>"))
		announce_ante_doubles()
		game_bag.active_game = null
		qdel(src)
		return

	var/list/names = list()
	for(var/mob/living/M in contenders)
		names += "[M]"
	game_bag.visible_message(span_notice("Tie for lowest score ([best_score]) between [jointext(names, ", ")]."))
	tie_break(contenders)

/datum/threes_away_game/proc/tie_break(list/mob/living/contenders)
	if(!contenders || !contenders.len)
		announce_ante_doubles()
		game_bag.active_game = null
		qdel(src)
		return

	var/list/mob/living/current_contenders = contenders.Copy()
	while(current_contenders.len > 1)
		var/list/names = list()
		for(var/mob/living/M in current_contenders)
			names += "[M]"
		game_bag.visible_message(span_warning("Tie-break! [jointext(names, ", ")] roll once more. Lowest total wins."))

		var/best_total = 999999
		var/list/mob/living/new_contenders = list()

		for(var/mob/living/M in current_contenders)
			var/list/rolls = list(rand(1, 6), rand(1, 6), rand(1, 6), rand(1, 6), rand(1, 6))
			var/roll_total = 0
			for(var/v in rolls)
				roll_total += v
			game_bag.visible_message(span_notice("[M] tie-break rolls: [format_big_roll(rolls, get_roll_color_for(M))] (total [roll_total])."))

			if(roll_total < best_total)
				best_total = roll_total
				new_contenders = list(M)
			else if(roll_total == best_total)
				new_contenders += M

		current_contenders = new_contenders
		if(current_contenders.len > 1)
			game_bag.visible_message(span_notice("Tie-break is still tied at [best_total]. Rolling again."))

	var/mob/living/champion = current_contenders[1]
	game_bag.visible_message(span_green("<b>[champion] wins the tie-break with the lowest total!</b>"))
	announce_ante_doubles()
	game_bag.active_game = null
	qdel(src)

/datum/threes_away_game/proc/announce_ante_doubles()
	var/list/doubled = list()
	for(var/mob/living/M in players)
		if(ante_doubled[M])
			doubled += "[M]"
	if(doubled.len)
		game_bag.visible_message(span_warning("Ante doubled next pot for: [jointext(doubled, ", ")]."))

/datum/threes_away_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		var/state = ""
		if(busted[M])
			state = " (BUST)"
		else if(rolled[M])
			state = " (ROLLED)"
		parts += "[M]: [scores[M]][state]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/threes_away
	name = "bag of three's away dice"
	desc = "A bag used to play Three's Away. Activate in hand (Z) to start or join a game."
	var/datum/threes_away_game/active_game
	var/static/threes_away_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>Three's Away</h2>
<br>
<b>Objective:</b> Achieve the lowest score.<br>
<br>
<b>Rules:</b><br>
- One at a time, all players roll 5d6.<br>
- After every roll, players choose one dice that must be set aside.<br>
- Continue rolling remaining dice until all five are set aside.<br>
- 3s are worth 0, 1s are valuable low dice.<br>
- If you roll three 3s during your turn, your score is wiped to 0.<br>
- If you roll four or more 3s on a roll, you bust and are disqualified.<br>
<br>
<b>Tie-breaking:</b><br>
If round-end has a tie for lowest score, the tied players are told to roll once more.<br>
Each tied player rolls a fresh set of 5d6.<br>
The total of that set is summed.<br>
Lowest total wins the tie-break.<br>
If tie-break itself ties, it repeats automatically until one winner remains.<br>
</div>"}

/obj/item/storage/pill_bottle/dice/threes_away/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(threes_away_rules_text, "window=threes_away_rules;size=700x450")

/obj/item/storage/pill_bottle/dice/threes_away/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/dice/d6(src)

/obj/item/storage/pill_bottle/dice/threes_away/attack_self(mob/living/user)
	if(active_game && active_game.joining && (user in active_game.players) && active_game.players.len >= 2)
		active_game.start_game()

	var/list/menu = list()
	var/gap1 = " "
	var/gap2 = "  "
	var/gap3 = "   "
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
		menu += gap1
	menu += "Rules"
	menu += gap2
	if(active_game && (user in active_game.players))
		menu += "Leave Game"
		menu += gap3
	menu += "End Game"

	var/choice = input(user, "Select an option.", "Three's Away Dice") as null|anything in menu
	if(!choice)
		return

	if(choice == "Rules")
		show_rules(user)
		return

	if(choice == "End Game")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("No Three's Away game is currently running."))
		return

	if(choice == "Leave Game")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("No Three's Away game is currently running."))
		return

	if(choice == "Roll Dice")
		if(!active_game)
			to_chat(user, span_notice("No Three's Away game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.joining))
			to_chat(user, span_notice("You cannot roll right now."))
			return
		active_game.player_action(user, "Roll Dice")
		return

	if(choice != "Start Game")
		return

	if(!active_game)
		var/count = input(user, "How many players?\n(2 to 4 players)", "Three's Away") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/threes_away_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user] is starting Three's Away! [count - 1] more player(s) needed. Activate (Z) the dice bag to join!"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
