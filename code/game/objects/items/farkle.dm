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
			plays += list(list("name" = "顺子（1-6）", "score" = 1500, "dice" = dice_values.Copy()))
			return plays

	// Three pairs: exactly 6 dice forming three different pairs
	if(dice_values.len == 6)
		var/pair_count = 0
		for(var/f in 1 to 6)
			if(counts[f] == 2)
				pair_count++
		if(pair_count == 3)
			plays += list(list("name" = "三对", "score" = 750, "dice" = dice_values.Copy()))
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
			plays += list(list("name" = "[face]点[n]个", "score" = score, "dice" = used))
		else
			// Only 1s and 5s score as singles
			if(face == 1)
				plays += list(list("name" = "单个1", "score" = 100, "dice" = list(1)))
			if(face == 5)
				plays += list(list("name" = "单个5", "score" = 50, "dice" = list(5)))

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
		to_chat(joiner, span_warning("法克尔已经开始了。"))
		return

	if(joiner in players)
		// Already in - let them start early or leave
		var/list/opts = list("离开游戏")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅中了。([players.len]/[max_players] 名玩家)", "法克尔") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开游戏")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了准备大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("法克尔人数已满（[max_players]/[max_players]）。"))
		return

	players += joiner
	scores[joiner] = 0
	game_bag.visible_message(span_notice("[joiner]加入了法克尔！([players.len]/[max_players] 名玩家)"))
	if(players.len >= max_players)
		start_game()


// --- Cancel Game ---
/datum/farkle_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller]取消了法克尔！"))
	game_bag.active_game = null
	qdel(src)

/datum/farkle_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局法克尔中。"))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver

	game_bag.visible_message(span_notice("[leaver]离开了法克尔。([players.len]/[max_players] 名玩家剩余)"))

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
	game_bag.visible_message(span_notice("法克尔开始！先到[target_score]分者获胜。玩家：[jointext(names, ", ")]。祝好运！"))
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

	game_bag.visible_message(span_notice("--- [active]的回合 [final_round ? "(最终轮)" : ""] | [get_score_display()] ---"))
	to_chat(active, span_notice("轮到你了！激活（Z）骰袋来掷骰。"))


// --- Player Interaction Entry Point ---

/datum/farkle_game/proc/player_action(mob/living/user)
	if(!(user in players))
		to_chat(user, span_notice("当前分数：[get_score_display()]"))
		return

	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return

	if(user != current_player)
		// Not their turn
		input(user, "还没轮到你。分数：[get_score_display()]", "法克尔") as null|anything in list("确定")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("回合顺序正在重新同步，稍后再试。"))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("还没轮到你。"))
		return

	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("这回合你已经掷过骰了。请完成本回合选择，或等待下回合。"))
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
	game_bag.visible_message(span_notice("[active]摇晃着骰袋……"))
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
	game_bag.visible_message(span_notice("[active]倒出了骰子！([dice_to_roll]枚6面骰)：[format_big_roll(rolled, get_roll_color_for(active))]"))

	// Check for Farkle: no scoring dice at all
	if(!farkle_get_plays(rolled).len)
		game_bag.visible_message(span_danger("<b>法克尔！</b> [active]没有掷出任何计分骰，失去了累计的 [turn_score] 分！"))
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
			menu += "完成选择"

		var/list/rem_str = list()
		for(var/v in remaining)
			rem_str += "[v]"
		var/chosen = input(active, "剩余骰子：[jointext(rem_str, " - ")]\n本回合当前累计：[turn_score + turn_so_far] 分\n选择要保留的计分组合：", "法克尔") as null|anything in menu

		// Null = cancelled/disconnected - safety valve
		if(!chosen)
			null_count++
			if(null_count >= 3 || !first_pick)
				break
			continue

		null_count = 0

		if(chosen == "完成选择")
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
		game_bag.visible_message(span_notice("热骰！[active]已经用掉所有骰子！重新掷全部 6 颗。（本回合：[turn_score] 分）"))
		dice_to_roll = 6

	// --- Bank or keep rolling ---
	var/list/options = list(
		"存分 [turn_score] 分（总分将变为：[scores[active] + turn_score]）",
		"继续掷骰（[dice_to_roll] 颗）"
	)

	var/decision = input(active, "本回合当前累计：[turn_score] 分 | 若存分则总分为：[scores[active] + turn_score]\n你要怎么做？", "法克尔") as null|anything in options

	if(!decision || decision == "存分 [turn_score] 分（总分将变为：[scores[active] + turn_score]）")
		// Bank the points
		if(expected_turn_token != turn_token)
			busy = FALSE
			return
		scores[active] += turn_score
		game_bag.visible_message(span_notice("[active]存下了 [turn_score] 分！[active]现在总共有 [scores[active]] 分。"))

		if(scores[active] >= target_score && !final_round)
			winner_mob = active
			final_round = TRUE
			game_bag.visible_message(span_notice("[active]达到了 [scores[active]] 分！其余所有玩家都将获得最后一次超越它的机会！"))

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

	game_bag.visible_message(span_notice("--- 法克尔结束 ---<br>最终比分：[get_score_display()]"))
	if(champion)
		game_bag.visible_message(span_green("<b>[champion]以 [top] 分获胜！恭喜！</b>"))
	else
		game_bag.visible_message(span_notice("平局！"))

	game_bag.active_game = null
	qdel(src)


// ===================== DICE BAG EXTENSION =====================
// Adds active_game tracking and attack_self (activate-in-hand) interaction
// to the existing /obj/item/storage/pill_bottle/dice/farkle type.

/obj/item/storage/pill_bottle/dice/farkle
	desc = "六颗用于法克尔的骰子。手持激活（Z）即可开始或加入游戏！"
	var/datum/farkle_game/active_game
	var/static/farkle_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>法克尔</h2>
<br>
<b>目标：</b>成为总分超过 10000 后分数最高的玩家。<br>
<br>
 - 单独的 1 和 5 可以计分。<br>
 - 其他点数只有在一次掷骰中出现三颗或更多相同点数时才计分。<br>
 - 某些特殊组合也能计分，但必须来自同一次掷骰。注意：不同次掷骰的骰子不能合并成更高组合。例如你第一次留下一颗 5（50 分），第二次又留两颗 5（100 分），你总共只有 150 分，不能把它们合并算作三颗 5（500 分）。<br>
 - 每次掷骰后都必须移除至少一组可计分骰。<br>
 - 轮到你时，把六颗骰子放进骰杯里摇出结果；若有骰子滚出游玩区域，则重新掷出。<br>
 - 每次掷骰后，保留能计分的骰子，并继续掷剩下的骰子。你每次都至少要拿走一颗可计分骰，并累计本回合分数。<br>
 - 如果你幸运地把六颗骰子都用于计分，就可以重新掷满六颗骰子，继续累积本回合分数。<br>
 - 如果一次掷骰后没有任何骰子可以计分，就会发生“法克尔”。你将失去本回合累计的全部分数，回合交给下一位玩家。法克尔可能发生在第一次掷骰，也可能发生在掷剩余骰子时。<br>
<br>
<b>胜利条件：</b>当有玩家累计达到 10000 分或以上时，其余玩家各有最后一个回合尝试超越该分数，最终由总分最高者获胜。<br>
<br>
<b>计分表：</b><br>
单个 1 = 100<br>
单个 5 = 50<br>
三个 1 = 300<br>
三个 2 = 200<br>
三个 3 = 300<br>
三个 4 = 400<br>
三个 5 = 500<br>
三个 6 = 600<br>
任意四条 = 1000<br>
任意五条 = 2000<br>
任意六条 = 3000<br>
1-6 顺子 = 1500<br>
三对 = 1500<br>
四条加一对 = 1500<br>
双三条 = 2500
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
		menu += "开始游戏"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "开始游戏"
	else if(can_show_roll)
		menu += "掷骰"

	if(menu.len)
		menu += " "
	menu += "规则"
	menu += "  "
	if(active_game && (user in active_game.players))
		menu += "离开游戏"
		menu += "   "
	menu += "结束游戏"

	var/choice = input(user, "选择一个选项。", "法克尔骰子") as null|anything in menu

	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的法克尔。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的法克尔。"))
		return

	if(choice == "掷骰")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的法克尔。"))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll))
			to_chat(user, span_notice("你现在不能掷骰。"))
			return
		if(active_game.joining)
			to_chat(user, span_notice("至少需要两名玩家加入并开始游戏后，才能掷骰。"))
		else
			active_game.player_action(user)
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/count = input(user, "需要几名玩家？\n（2 到 4 名玩家）", "法克尔") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/farkle_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)

		if(count > 1)
			src.visible_message(span_notice("[user]正在发起一局法克尔！还需要 [count - 1] 名玩家。手持激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user)
