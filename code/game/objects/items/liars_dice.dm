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
	return pending.len ? jointext(pending, ", ") : "无"

/datum/liars_dice_game/proc/roll_secret_dice(mob/living/M)
	if(!M || !(M in players))
		return
	if(joining)
		to_chat(M, span_notice("游戏尚未开始。"))
		return
	if(eliminated[M])
		to_chat(M, span_warning("你已被淘汰，不能再掷骰。"))
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
	game_bag.visible_message(span_notice("[M]掷出了自己的暗骰。"))
	show_private_cup(M)

	if(all_active_players_rolled())
		game_bag.visible_message("<span style='color:#EF5350;font-size:larger;font-weight:bold;'>所有玩家都已掷出暗骰。现在可以开始叫点了。</span>")

/datum/liars_dice_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("吹牛骰已经开始了。"))
		return

	if(joiner in players)
		var/list/opts = list("离开游戏")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅中了。([players.len]/[max_players] 名玩家)", "吹牛骰") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开游戏")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了准备大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("吹牛骰人数已满（[max_players]/[max_players]）。"))
		return

	players += joiner
	die_counts[joiner] = 5
	cups[joiner] = list()
	round_rolled[joiner] = FALSE
	eliminated[joiner] = FALSE
	game_bag.visible_message(span_notice("[joiner]加入了吹牛骰！([players.len]/[max_players] 名玩家)"))
	if(players.len == max_players)
		start_game()

/datum/liars_dice_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller]取消了吹牛骰！"))
	game_bag.active_game = null
	qdel(src)

/datum/liars_dice_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局吹牛骰中。"))
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

	game_bag.visible_message(span_notice("[leaver]离开了吹牛骰。([players.len] 名玩家剩余)"))

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
	game_bag.visible_message(span_notice("吹牛骰开始！玩家：[jointext(names, ", ")]。每人起始 5 颗骰子。"))
	start_round()

/datum/liars_dice_game/proc/start_round()
	bid_quantity = 0
	bid_face = 0
	current_bidder = null

	for(var/mob/living/M in players)
		cups[M] = list()
		round_rolled[M] = FALSE

	game_bag.visible_message(span_notice("--- 新回合 --- 骰子数量：[get_dice_display()]。"))
	game_bag.visible_message(span_notice("每位仍在局中的玩家都必须先掷自己的暗骰（使用“掷我的暗骰”）。"))

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
		to_chat(M, span_notice("你还没掷暗骰。请使用“掷我的暗骰”。"))
		return
	var/list/cup_str = list()
	for(var/v in cups[M])
		cup_str += "<span style='color:#4FC3F7;font-size:larger;font-weight:bold;'>[v]</span>"
	to_chat(M, span_notice("你的暗骰（[die_counts[M]] 颗）：[jointext(cup_str, " - ")]"))

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
			game_bag.visible_message(span_notice("--- [next]的回合 | 等待暗骰： [pending] | [get_dice_display()] ---"))
			if(!round_rolled[next])
				to_chat(next, span_notice("先掷你的暗骰。激活骰袋并选择“掷我的暗骰”。"))
			else
				to_chat(next, span_notice("你已经掷过了。正在等待：[pending]。"))
			return

		if(bid_quantity == 0)
			game_bag.visible_message(span_notice("--- [next]的回合，负责先手开叫。 [get_dice_display()] ---"))
			to_chat(next, span_notice("还没有叫点。你必须先开叫。激活骰袋来行动。"))
		else
			game_bag.visible_message(span_notice("--- [next]的回合 | 当前叫点：[current_bidder] 叫了 [bid_quantity] 个 [bid_face] 点 | [get_dice_display()] ---"))
			to_chat(next, span_notice("当前叫点：[bid_quantity] 个 [bid_face] 点（由 [current_bidder] 叫出）。你可以加码，或喊“吹牛！”。激活骰袋来行动。"))
			show_private_cup(next)
		return

	check_win_condition()

/datum/liars_dice_game/proc/player_action(mob/living/user)
	if(!(user in players))
		to_chat(user, span_notice("骰子数量：[get_dice_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return
	if(user != current_player)
		if(bid_quantity > 0)
			input(user, "还没轮到你。当前叫点：[bid_quantity] 个 [bid_face] 点（由 [current_bidder] 叫出）。", "吹牛骰") as null|anything in list("确定")
		else
			input(user, "还没轮到你。当前还没有人叫点。", "吹牛骰") as null|anything in list("确定")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("回合顺序正在重新同步，稍后再试。"))
		return
	if(user != current_player)
		to_chat(user, span_warning("还没轮到你。"))
		return
	if(!all_active_players_rolled())
		to_chat(user, span_notice("在所有在场玩家都掷完暗骰前，叫点会被锁定。未完成者：[get_unrolled_players_text()]。"))
		return
	if(!can_take_action)
		to_chat(user, span_notice("这回合你已经行动过了。"))
		return

	can_take_action = FALSE
	do_bid_or_liar(user)

/datum/liars_dice_game/proc/do_bid_or_liar(mob/living/active)
	show_private_cup(active)

	var/list/options = list()
	if(bid_quantity == 0)
		options += "先手开叫"
	else
		options += "加码"
		options += "喊吹牛"

	var/bid_display = (bid_quantity > 0) ? "[current_bidder] 叫了 [bid_quantity] 个 [bid_face] 点" : "（当前无人叫点）"
	var/choice = input(active, "当前叫点：[bid_display]\n选择你的行动：", "吹牛骰") as null|anything in options

	if(!choice || !(active in players) || eliminated[active])
		can_take_action = TRUE
		if(bid_quantity == 0)
			to_chat(active, span_notice("你必须先开叫。请再次激活骰袋。"))
		else
			to_chat(active, span_notice("你必须加码或喊“吹牛！”。请再次激活骰袋。"))
		return

	if(choice == "喊吹牛")
		busy = TRUE
		resolve_challenge(active)
		return

	// “先手开叫”或“加码”
	do_place_bid(active)

/datum/liars_dice_game/proc/do_place_bid(mob/living/active)
	// Build face value options: on raising, cannot bid a lower face than current
	var/list/face_opts = list()
	if(bid_face == 0)
		face_opts = list("1", "2", "3", "4", "5", "6")
	else
		for(var/f in bid_face to 6)
			face_opts += "[f]"

	var/chosen_face_str = input(active, "你要叫哪个点数？\n（结算时 1 可作为万能点数；若叫 2 点及以上，则 1 也会计入）", "吹牛骰") as null|anything in face_opts

	if(!chosen_face_str || !(active in players))
		can_take_action = TRUE
		to_chat(active, span_notice("叫点已取消。再次激活骰袋以重新叫点。"))
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
		to_chat(active, span_notice("当前没有可用于 [chosen_face] 点的有效数量。请换一个点数。"))
		do_bid_or_liar(active)
		return

	var/chosen_qty_str = input(active, "要叫多少个 [chosen_face] 点？（最少 [min_qty]，最多 [max_qty] | 场上总骰数：[max_qty]）", "吹牛骰") as null|anything in qty_opts

	if(!chosen_qty_str || !(active in players))
		can_take_action = TRUE
		to_chat(active, span_notice("叫点已取消。再次激活骰袋以重新叫点。"))
		return

	var/chosen_qty = text2num(chosen_qty_str)

	bid_quantity = chosen_qty
	bid_face = chosen_face
	current_bidder = active

	game_bag.visible_message(span_notice("[active]叫出：[bid_quantity] 个 [bid_face] 点！"))
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
		reveal_parts += "[M]（[die_counts[M]] 颗骰子）：[jointext(cup_str, " - ")]"

	game_bag.visible_message(span_notice("[challenger]对[current_bidder]的 [bid_quantity] 个 [bid_face] 点喊了 [span_red("<b>吹牛</b>")]！"))
	game_bag.visible_message(span_notice("所有骰子揭晓！<br>[jointext(reveal_parts, "<br>")]"))

	var/actual_count = count_on_table(bid_face)
	var/wild_note = (bid_face != 1) ? "（1 作为万能点数计入）" : ""
	game_bag.visible_message(span_notice("实际共有 [actual_count] 个 [bid_face] 点[wild_note]。当前叫点为 [bid_quantity]。"))

	var/mob/living/loser
	if(actual_count >= bid_quantity)
		loser = challenger
		game_bag.visible_message(span_notice("这次叫点是 [span_green("<b>真实</b>")]（[actual_count] >= [bid_quantity]）！[challenger]失去一颗骰子。"))
	else
		loser = current_bidder
		game_bag.visible_message(span_notice("这次叫点是 [span_red("<b>吹牛</b>")]（[actual_count] < [bid_quantity]）！[current_bidder]失去一颗骰子。"))

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
		game_bag.visible_message(span_danger("[loser]失去了最后一颗骰子，被淘汰出吹牛骰！"))
	else
		game_bag.visible_message(span_notice("[loser]现在还剩 [die_counts[loser]] 颗骰子。"))

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
		game_bag.visible_message(span_warning("--- 吹牛骰结束 --- 没有玩家剩余！"))
		game_bag.active_game = null
		qdel(src)
		return

	if(remaining.len == 1)
		var/mob/living/winner = remaining[1]
		game_bag.visible_message(span_green("<b>--- 吹牛骰结束 --- [winner]以剩余 [die_counts[winner]] 颗骰子获胜！</b>"))
		game_bag.active_game = null
		qdel(src)
		return

	// More than one remains — start next round
	start_round()

/datum/liars_dice_game/proc/get_dice_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		if(eliminated[M])
			parts += "[M]：出局"
		else
			parts += "[M]：[die_counts[M]]颗"
	return jointext(parts, " | ")


// =====================================================================
//  ITEM: Liar's Dice bag
// =====================================================================

/obj/item/storage/pill_bottle/dice/liars_dice
	name = "吹牛骰骰袋"
	desc = "一个用来玩吹牛骰的骰袋。手持激活（Z）即可开始或加入游戏。"
	var/datum/liars_dice_game/active_game
	var/static/liars_dice_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>吹牛骰</h2>
<br>
<b>目标：</b>成为最后一名仍至少持有一颗骰子的玩家。<br>
<br>
<b>准备：</b><br>
每位玩家起始有 5 颗骰子，并以暗骰形式掷出。你只能看到自己的骰子。<br>
<br>
<b>叫点：</b><br>
- 先手玩家需要叫出一个数量和点数（例如：<i>三个 4</i>）。<br>
- 这代表他声称所有玩家暗骰合计中，至少有这么多个该点数。<br>
- 之后每位玩家轮流只能选择：<b>加码</b> 或 <b>喊吹牛</b>。<br>
<br>
<b>有效加码：</b><br>
- 提高数量（点数不变），或<br>
- 叫更高的点数（数量必须保持不变或更高）。<br>
<br>
<b>万能 1：</b>在结算质疑时，若叫点不是 1，则所有 1 都算作该点数。<br>
（例如叫了 <i>三个 4</i>，则场上的所有 4 和所有 1 都会计入）<br>
<br>
<b>质疑（喊吹牛）：</b><br>
- 所有暗骰都会揭晓。<br>
- 如果真实数量（含万能 1）<b>等于或大于</b>当前叫点：则<b>质疑者</b>失去一颗骰子。<br>
- 如果真实数量<b>小于</b>当前叫点：则<b>叫点者</b>失去一颗骰子。<br>
<br>
<b>淘汰：</b>失去最后一颗骰子的玩家会被淘汰。<br>
<br>
<b>下一轮：</b>本轮失败者在下一轮先手开叫，所有骰子重新掷出。<br>
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
		menu += "开始游戏"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "加入游戏"
	else
		if(can_show_action)
			menu += "叫点 / 质疑"
		if(can_roll_secret)
			if(menu.len)
				menu += spacers[spacer_index]
				spacer_index++
			menu += "掷我的暗骰"

	if(can_check_dice)
		if(menu.len)
			menu += spacers[spacer_index]
			spacer_index++
		menu += "查看我的骰子"

	if(menu.len)
		menu += spacers[spacer_index]
		spacer_index++
	menu += "规则"

	if(active_game && (user in active_game.players))
		menu += spacers[spacer_index]
		spacer_index++
		menu += "离开游戏"

	menu += spacers[spacer_index]
	menu += "结束游戏"

	var/choice = input(user, "选择一个选项。", "吹牛骰") as null|anything in menu
	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的吹牛骰。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的吹牛骰。"))
		return

	if(choice == "查看我的骰子")
		if(active_game && !active_game.joining && (user in active_game.players) && !active_game.eliminated[user])
			active_game.show_private_cup(user)
		return

	if(choice == "掷我的暗骰")
		if(active_game && !active_game.joining && (user in active_game.players) && !active_game.eliminated[user])
			active_game.roll_secret_dice(user)
		return

	if(choice == "叫点 / 质疑")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的吹牛骰。"))
			return
		if(!(user == active_game.current_player && active_game.can_take_action && !active_game.joining))
			to_chat(user, span_notice("你现在不能行动。"))
			return
		active_game.player_action(user)
		return

	if(choice == "加入游戏")
		if(active_game && active_game.joining)
			active_game.try_join(user)
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/count = input(user, "需要几名玩家？\n（2 到 6 名玩家）", "吹牛骰") as null|anything in list(2, 3, 4, 5, 6)
		if(!count)
			return

		var/datum/liars_dice_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user]正在发起吹牛骰！还需要 [count - 1] 名玩家。手持激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user)
