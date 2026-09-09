/*
 * DICE WAR
 * A 2-player d20 dice fighting game.
 *
 * Objective: reduce your opponent to 0 HP.
 * - Both players start at 50 HP.
 * - Players take turns rolling 1d20.
 * - Compare both rolls to determine base damage (difference between high and low).
 * - Even/Even or Odd/Odd: full damage to lower roll.
 * - High Odd vs Low Even: damage is halved.
 * - High Even vs Low Odd: full damage (Power Stroke).
 * - Natural 1: heal 10 HP (Second Wind).
 * - Natural 20: roll extra d20 for direct damage (ignores halving rules).
 */

/datum/dice_war_game
	var/list/mob/living/players = list()
	var/list/hp = list() // assoc: mob -> hp
	var/current_player_index = 0
	var/mob/living/current_player = null
	var/obj/item/storage/pill_bottle/dice/dice_war/game_bag
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 2
	var/can_initiate_turn_roll = FALSE
	var/mob/living/pending_roller = null
	var/pending_roll = 0

/datum/dice_war_game/proc/format_big_die_value(v, color = "#4FC3F7")
	return "<span style='color:[color];font-size:larger;font-weight:bold;'>[v]</span>"

/datum/dice_war_game/proc/get_roll_color_for(mob/living/M)
	if(players.Find(M) == 2)
		return "#26882c"
	return "#4FC3F7"

/datum/dice_war_game/proc/format_player_roll_value(mob/living/M, v)
	return format_big_die_value(v, get_roll_color_for(M))

/datum/dice_war_game/proc/format_hp_value(v)
	return "<span style='color:#EF5350;font-size:larger;font-weight:bold;'>HP: [v]</span>"

/datum/dice_war_game/proc/get_opponent(mob/living/M)
	for(var/mob/living/P in players)
		if(P != M)
			return P
	return null

/datum/dice_war_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("The Dice War has already started."))
		return

	if(joiner in players)
		var/list/opts = list("Leave game")
		if(players.len >= 2)
			opts += "Start game now"
		var/choice = input(joiner, "You are already in the lobby. ([players.len]/[max_players] players)", "Dice War") as null|anything in opts
		if(choice == "Start game now")
			start_game()
		else if(choice == "Leave game")
			players -= joiner
			hp -= joiner
			game_bag.visible_message(span_notice("[joiner] left the pre-game lobby. ([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("Dice War is full ([max_players]/[max_players])."))
		return

	players += joiner
	hp[joiner] = 50
	game_bag.visible_message(span_notice("[joiner] joined Dice War! ([players.len]/[max_players] players)"))
	if(players.len >= max_players)
		start_game()

/datum/dice_war_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("You are not in this Dice War game."))
		return

	players -= leaver
	hp -= leaver

	game_bag.visible_message(span_notice("[leaver] leaves Dice War."))

	if(!players.len)
		cancel_game(leaver)
		return

	if(joining)
		if(players.len < 2)
			cancel_game(leaver)
		return

	var/mob/living/winner = players[1]
	end_game_with_winner(winner, "forfeit")

/datum/dice_war_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller] has cancelled Dice War!"))
	game_bag.active_game = null
	qdel(src)

/datum/dice_war_game/proc/start_game()
	if(!joining)
		return
	if(players.len < 2)
		return
	joining = FALSE
	current_player = null
	current_player_index = 0
	pending_roller = null
	pending_roll = 0
	for(var/mob/living/P in players)
		hp[P] = 50

	game_bag.visible_message(span_notice("Dice War begins! [players[1]] vs [players[2]] - 50 HP each."))
	next_turn()

/datum/dice_war_game/proc/next_turn()
	if(players.len < 2)
		if(players.len == 1)
			end_game_with_winner(players[1], "last fighter standing")
		else
			cancel_game(game_bag)
		return

	current_player_index++
	if(current_player_index > players.len)
		current_player_index = 1

	var/mob/living/active = players[current_player_index]
	if(!active)
		next_turn()
		return

	current_player = active
	can_initiate_turn_roll = TRUE
	game_bag.visible_message(span_notice("--- [active]'s turn | [get_hp_display()] ---"))
	to_chat(active, span_notice("Choose Roll Dice from the dice bag menu."))

/datum/dice_war_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("Current HP: [get_hp_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("Please wait a moment..."))
		return
	if(user != current_player)
		input(user, "It's not your turn. HP: [get_hp_display()]", "Dice War") as null|anything in list("OK")
		return
	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("You have already rolled this turn."))
		return
	if(action != "Roll Dice")
		to_chat(user, span_notice("Choose Roll Dice from the menu."))
		return

	can_initiate_turn_roll = FALSE
	do_roll(user)

/datum/dice_war_game/proc/do_roll(mob/living/active)
	if(active != current_player)
		return

	busy = TRUE
	playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)

	var/roll = rand(1, 20)
	var/got_natural_twenty = (roll == 20)
	game_bag.visible_message(span_notice("[active] rolls a d20: [format_player_roll_value(active, roll)]!"))

	if(roll == 1)
		var/old_hp = hp[active]
		hp[active] = old_hp + 10
		game_bag.visible_message(span_notice("Second Wind! [active] heals 10 HP ([old_hp] -> [hp[active]])."))

	if(roll == 20)
		var/mob/living/target = get_opponent(active)
		if(target)
			var/crit = rand(1, 20)
			var/crit_color = "#EF5350"
			hp[target] -= crit
			game_bag.visible_message(span_danger("Critical Strike! [active] rolls [format_big_die_value(crit, crit_color)] direct damage on [target]!"))
			if(hp[target] <= 0)
				busy = FALSE
				end_game_with_winner(active, "critical strike")
				return

	if(got_natural_twenty)
		busy = FALSE
		can_initiate_turn_roll = TRUE
		game_bag.visible_message(span_notice("Natural 20 bonus turn! [active] may roll again before the opponent acts."))
		to_chat(active, span_notice("Bonus action: choose Roll Dice again."))
		return

	if(!pending_roller)
		pending_roller = active
		pending_roll = roll
		busy = FALSE
		next_turn()
		return

	if(pending_roller == active)
		// Safety fallback for unexpected duplicate turn state
		pending_roll = roll
		busy = FALSE
		next_turn()
		return

	resolve_exchange(pending_roller, pending_roll, active, roll)
	pending_roller = null
	pending_roll = 0

	busy = FALSE
	if(check_end())
		return
	next_turn()

/datum/dice_war_game/proc/resolve_exchange(mob/living/p1, roll1, mob/living/p2, roll2)
	var/mob/living/high_mob = p1
	var/mob/living/low_mob = p2
	var/high_roll = roll1
	var/low_roll = roll2
	if(roll2 > roll1)
		high_mob = p2
		low_mob = p1
		high_roll = roll2
		low_roll = roll1
	else if(roll2 == roll1)
		game_bag.visible_message(span_notice("Clash tied at [format_player_roll_value(p1, roll1)] vs [format_player_roll_value(p2, roll2)]! No base damage dealt."))
		return

	var/base_damage = high_roll - low_roll
	var/damage = base_damage

	var/high_even = (high_roll % 2 == 0)
	var/low_even = (low_roll % 2 == 0)

	if(high_even == low_even)
		// Even/Even or Odd/Odd: full damage
		damage = base_damage
		game_bag.visible_message(span_notice("In sync clash ([format_player_roll_value(high_mob, high_roll)] vs [format_player_roll_value(low_mob, low_roll)])! [high_mob] deals [damage] damage to [low_mob]."))
	else if(!high_even && low_even)
		// High odd vs low even: halved damage
		damage = (base_damage - (base_damage % 2)) / 2
		game_bag.visible_message(span_notice("Weak overcomes Strong ([format_player_roll_value(high_mob, high_roll)] odd vs [format_player_roll_value(low_mob, low_roll)] even)! Damage halved to [damage]."))
	else
		// High even vs low odd: full damage
		damage = base_damage
		game_bag.visible_message(span_notice("Power Stroke ([format_player_roll_value(high_mob, high_roll)] even vs [format_player_roll_value(low_mob, low_roll)] odd)! [high_mob] deals [damage] damage."))

	if(damage > 0)
		hp[low_mob] -= damage
	else
		game_bag.visible_message(span_notice("No damage gets through."))

	damage = max(damage, 0)
	game_bag.visible_message(span_notice("[low_mob] [format_hp_value(hp[low_mob])] | [high_mob] [format_hp_value(hp[high_mob])]"))

/datum/dice_war_game/proc/check_end()
	for(var/mob/living/P in players)
		if(hp[P] <= 0)
			var/mob/living/winner = get_opponent(P)
			if(!winner)
				winner = P
			end_game_with_winner(winner, "combat")
			return TRUE
	return FALSE

/datum/dice_war_game/proc/end_game_with_winner(mob/living/winner, reason)
	if(winner)
		game_bag.visible_message(span_green("<b>--- DICE WAR OVER --- [winner] wins by [reason]!</b>"))
	else
		game_bag.visible_message(span_notice("--- DICE WAR OVER ---"))
	game_bag.active_game = null
	qdel(src)

/datum/dice_war_game/proc/get_hp_display()
	var/list/parts = list()
	for(var/mob/living/P in players)
		parts += "[P] [format_hp_value(hp[P])]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/dice_war
	name = "bag of war dice"
	desc = "A bag used to play Dice War. Activate in hand (Z) to start or join a game."
	var/datum/dice_war_game/active_game
	var/static/dice_war_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>Dice War</h2>
<br>
<b>Objective:</b> Reduce your opponent to 0 HP.<br>
<br>
<b>Rules:</b><br>
- Both players start with 50 HP.<br>
- Both players roll 1d20, taking turns.<br>
- Base Damage = difference between the high and low roll. Example: if Player 1 rolls 15 and Player 2 rolls 10, the base damage is 5.<br>
- Even/Even or Odd/Odd: full damage to lower roll. Example: if a player rolls 12 and the opponent rolls 8, the full damage of 4 is dealt.<br>
- High Odd vs Low Even: damage is halved. Example: if a player rolls 15 (odd) and the opponent rolls 8 (even), the damage is halved to 3 rounding down.<br>
- High Even vs Low Odd: Power Stroke, full damage. Example: if a player rolls 16 (even) and the opponent rolls 7 (odd), the full damage of 9 is dealt.<br>
- Natural 1: heal 10 HP.<br>
- Natural 20: roll another d20 for direct damage (ignores halving rules).
</div>"}

/obj/item/storage/pill_bottle/dice/dice_war/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(dice_war_rules_text, "window=dice_war_rules;size=700x450")

/obj/item/storage/pill_bottle/dice/dice_war/PopulateContents()
	new /obj/item/dice/d20(src)
	new /obj/item/dice/d20(src)

/obj/item/storage/pill_bottle/dice/dice_war/attack_self(mob/living/user)
	if(active_game && active_game.joining && (user in active_game.players) && active_game.players.len >= 2)
		active_game.start_game()

	var/list/menu = list()
	var/gap1 = " "
	var/gap2 = "  "
	var/gap3 = "   "
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
		menu += gap1
	menu += "Rules"
	menu += gap2
	if(active_game && (user in active_game.players))
		menu += "Leave Game"
		menu += gap3
	menu += "End Game"

	var/choice = input(user, "Select an option.", "Dice War") as null|anything in menu
	if(!choice)
		return

	if(choice == "Rules")
		show_rules(user)
		return

	if(choice == "End Game")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("No Dice War game is currently running."))
		return

	if(choice == "Leave Game")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("No Dice War game is currently running."))
		return

	if(choice == "Roll Dice")
		if(!active_game)
			to_chat(user, span_notice("No Dice War game is currently running."))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.joining))
			to_chat(user, span_notice("You cannot roll right now."))
			return
		active_game.player_action(user, "Roll Dice")
		return

	if(choice != "Start Game")
		return

	if(!active_game)
		var/datum/dice_war_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = 2
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user] is starting Dice War! 1 more player needed. Activate (Z) the dice bag to join!"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
