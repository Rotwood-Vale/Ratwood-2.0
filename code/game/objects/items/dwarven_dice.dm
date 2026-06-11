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
		result["reason"] = "无效掷骰。"
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
		result["reason"] = "三同号！立刻获胜！"
		result["label"] = "三同号"
		return result

	if(is_456)
		result["instant_win"] = TRUE
		result["score"] = sum
		result["reason"] = "4-5-6！立刻获胜！"
		result["label"] = "4-5-6 顺子"
		return result

	if(is_123)
		result["instant_lose"] = TRUE
		result["reason"] = "1-2-3！立刻落败！"
		result["label"] = "1-2-3 顺子"
		return result

	if(has_pair && has_one)
		result["instant_lose"] = TRUE
		result["reason"] = "对子加蛇眼！立刻落败！"
		result["label"] = "对子加蛇眼"
		return result

	if(has_pair)
		result["score"] = sum * 2
		result["label"] = "对子（双倍）"
	else
		result["score"] = sum
		result["label"] = "普通"

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
		to_chat(joiner, span_warning("矮人骰局已经开始了。"))
		return

	if(joiner in players)
		var/list/opts = list("离开游戏")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅中了。([players.len]/[max_players] 名玩家)", "矮人骰局") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开游戏")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了准备大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("矮人骰局人数已满（[max_players]/[max_players]）。"))
		return

	players += joiner
	scores[joiner] = 0
	rolled[joiner] = FALSE
	eliminated[joiner] = FALSE
	game_bag.visible_message(span_notice("[joiner]加入了矮人骰！([players.len]/[max_players] 名玩家)"))
	if(players.len >= max_players)
		start_game()

/datum/dwarven_dice_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller]取消了矮人骰！"))
	game_bag.active_game = null
	qdel(src)

/datum/dwarven_dice_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局矮人骰中。"))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver
	rolled -= leaver
	eliminated -= leaver

	game_bag.visible_message(span_notice("[leaver]离开了矮人骰。([players.len]/[max_players] 名玩家剩余)"))

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
	game_bag.visible_message(span_notice("矮人骰开始！玩家：[jointext(names, ", ")]。"))
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
		game_bag.visible_message(span_notice("--- [active]的回合 | [get_score_display()] ---"))
		to_chat(active, span_notice("打开骰袋菜单并选择“掷骰”。"))
		return

	end_round()

/datum/dwarven_dice_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("当前总分：[get_score_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return
	if(user != current_player)
		input(user, "还没轮到你。总分：[get_score_display()]", "矮人骰局") as null|anything in list("确定")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("回合顺序正在重新同步，稍后再试。"))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("还没轮到你。"))
		return
	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("这回合你已经掷过骰了。"))
		return
	if(action != "掷骰")
		to_chat(user, span_notice("请从菜单中选择“掷骰”。"))
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

	game_bag.visible_message(span_notice("[active]掷出了：[format_big_roll(rolled_values, get_roll_color_for(active))]。"))

	if(eval["instant_win"])
		scores[active] = score
		rolled[active] = TRUE
		game_bag.visible_message(span_notice("[active]触发了[eval["label"]]！[eval["reason"]]"))
		busy = FALSE
		end_game_with_winner(active)
		return

	if(eval["instant_lose"])
		eliminated[active] = TRUE
		rolled[active] = TRUE
		game_bag.visible_message(span_danger("[active]触发了[eval["label"]]！[eval["reason"]]"))
	else
		scores[active] = score
		rolled[active] = TRUE
		game_bag.visible_message(span_notice("[active]得到[score]分（[eval["label"]]）。"))

	busy = FALSE
	if(all_players_done())
		end_round()
	else
		next_turn()

/datum/dwarven_dice_game/proc/end_game_with_winner(mob/living/winner)
	if(winner)
		game_bag.visible_message(span_green("<b>--- 矮人骰结束 --- [winner]直接获胜！</b>"))
	else
		game_bag.visible_message(span_notice("--- 矮人骰结束 ---"))
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

	game_bag.visible_message(span_notice("--- 矮人骰本轮结束 ---<br>总分：[get_score_display()]"))

	if(!contenders.len)
		game_bag.visible_message(span_warning("无人获胜。所有人都输了。"))
		game_bag.active_game = null
		qdel(src)
		return

	if(contenders.len == 1)
		var/mob/living/champion = contenders[1]
		game_bag.visible_message(span_green("<b>[champion]以[scores[champion]]分获胜！</b>"))
		game_bag.active_game = null
		qdel(src)
		return

	var/list/names = list()
	for(var/mob/living/M in contenders)
		names += "[M]"
	game_bag.visible_message(span_notice("[jointext(names, ", ")]以[best_total]分打平。"))
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
		game_bag.visible_message(span_warning("进入加赛！[jointext(names, ", ")]各掷 1 枚20面骰，总点数最高者胜。"))

		var/best_total = -1
		var/list/mob/living/new_contenders = list()
		for(var/mob/living/M in current_contenders)
			var/roll = rand(1, 20)
			scores[M] += roll
			game_bag.visible_message(span_notice("[M]在加赛中掷出了 [format_big_die_value(roll, get_roll_color_for(M))] -> 总分变为 [scores[M]]。"))
			if(scores[M] > best_total)
				best_total = scores[M]
				new_contenders = list(M)
			else if(scores[M] == best_total)
				new_contenders += M

		current_contenders = new_contenders
		if(current_contenders.len > 1)
			game_bag.visible_message(span_notice("加赛仍以[best_total]打平。再次掷骰。"))

	var/mob/living/champion = current_contenders[1]
	game_bag.visible_message(span_green("<b>[champion]以 [scores[champion]] 分赢下了加赛！</b>"))
	game_bag.active_game = null
	qdel(src)

/datum/dwarven_dice_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		var/state = ""
		if(eliminated[M])
			state = "（已败）"
		else if(rolled[M])
			state = "（已掷）"
		parts += "[M]: [scores[M]][state]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/dwarven
	name = "矮人骰骰袋"
	desc = "一个用来玩矮人骰的骰袋。手持激活（Z）即可开始或加入游戏。"
	var/datum/dwarven_dice_game/active_game
	var/static/dwarven_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>矮人骰</h2>
<br>
<b>目标：</b>在所有玩家都掷完三颗骰子后，成为总点数最高的玩家。<br>
<br>
<b>规则：</b><br>
- 每位玩家轮流掷三次 6面骰。<br>
- 所有人都掷完后，总点数最高者获胜。<br>
- 若掷出一对，则你的总点数翻倍。<br>
- 立即获胜：掷出 4-5-6 顺子，或任意豹子。<br>
- 立即落败：掷出 1-2-3 顺子，或任意对子外加一个 1。<br>
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

	var/choice = input(user, "选择一个选项。", "矮人骰局") as null|anything in menu
	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的矮人骰局。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的矮人骰局。"))
		return

	if(choice == "掷骰")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的矮人骰局。"))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.joining))
			to_chat(user, span_notice("你现在不能掷骰。"))
			return
		active_game.player_action(user, "掷骰")
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/count = input(user, "需要几名玩家？\n（2 到 4 名玩家）", "矮人骰") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/dwarven_dice_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user]正在发起矮人骰！还需要 [count - 1] 名玩家。手持激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
