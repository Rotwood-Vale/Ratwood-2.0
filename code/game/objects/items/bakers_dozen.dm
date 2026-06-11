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
		to_chat(joiner, span_warning("这局“面包师十三”已经开始了。"))
		return

	if(joiner in players)
		var/list/opts = list("离开牌局")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅里了。([players.len]/[max_players] 名玩家)", "面包师十三") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开牌局")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了赛前大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("“面包师十三”已经满员了。([max_players]/[max_players])"))
		return

	players += joiner
	game_bag.visible_message(span_notice("[joiner]加入了“面包师十三”！([players.len]/[max_players] 名玩家)"))
	if(players.len >= max_players)
		start_game()

/datum/bakers_dozen_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局“面包师十三”里。"))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver
	mandatory_rolls -= leaver
	stayed -= leaver
	busted -= leaver

	game_bag.visible_message(span_notice("[leaver]离开了“面包师十三”。(剩余 [players.len]/[max_players] 名玩家)"))

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
	game_bag.visible_message(span_warning("[canceller]取消了“面包师十三”！"))
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
	game_bag.visible_message(span_notice("“面包师十三”开始了！目标点数：[target_score]。玩家：[jointext(names, ", ")]。"))
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

		game_bag.visible_message(span_notice("--- [active]的回合 | [get_score_display()] ---"))
		if(mandatory_rolls[active] < 2)
			to_chat(active, span_notice("起手阶段：从骰袋菜单里选择“投起手骰”。"))
		else
			to_chat(active, span_notice("从骰袋菜单里选择“补牌”或“停牌”。目标点数：[target_score]。"))
		return

	end_round()

/datum/bakers_dozen_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("当前总点数：[get_score_display()]"))
		return

	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return

	if(user != current_player)
		input(user, "还没轮到你。当前总点数：[get_score_display()]", "面包师十三") as null|anything in list("确定")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("回合顺序正在重新同步。稍后再试。"))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("现在还没轮到你。"))
		return
	if(!can_take_turn_action)
		to_chat(user, span_notice("你这回合已经行动过了。"))
		return

	if(player_is_done(user))
		to_chat(user, span_notice("你这轮已经结束了。当前总点数：[get_score_display()]"))
		next_turn()
		return

	if(mandatory_rolls[user] < 2)
		if(action != "投起手骰")
			to_chat(user, span_notice("请从菜单中选择“投起手骰”。"))
			return
		can_take_turn_action = FALSE
		do_opening_rolls(user)
		return

	if(action == "停牌")
		can_take_turn_action = FALSE
		stayed[user] = TRUE
		game_bag.visible_message(span_notice("[user]以 [scores[user]] 点停牌。"))
		if(all_players_done())
			end_round()
		else
			next_turn()
		return
	if(action != "补牌 - 掷1枚6面骰")
		to_chat(user, span_notice("请从菜单中选择“补牌”或“停牌”。"))
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

	game_bag.visible_message(span_notice("[active]掷出了[format_big_die_value(roll, get_roll_color_for(active))]！总点数：[scores[active]] / [target_score]。"))

	if(scores[active] > target_score)
		busted[active] = TRUE
		game_bag.visible_message(span_danger("[active]爆牌了，点数来到 [scores[active]]！"))
	else if(scores[active] == target_score)
		game_bag.visible_message(span_green("<b>[active]正好命中“面包师十三”！</b>"))

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

	game_bag.visible_message(span_notice("--- “面包师十三”本轮结束 ---<br>总点数：[get_score_display()]"))

	if(!contenders.len)
		game_bag.visible_message(span_warning("所有人都爆牌了。本轮无人获胜。"))
		game_bag.active_game = null
		qdel(src)
		return

	if(contenders.len == 1)
		var/mob/living/champion = contenders[1]
		game_bag.visible_message(span_green("<b>[champion]以 [scores[champion]] 点获胜！</b>"))
		game_bag.active_game = null
		qdel(src)
		return

	tie_break(contenders)

/datum/bakers_dozen_game/proc/tie_break(list/mob/living/contenders)
	while(contenders.len > 1)
		var/list/names = list()
		for(var/mob/living/M in contenders)
			names += "[M]"
		game_bag.visible_message(span_warning("[jointext(names, ", ")]同以 [scores[contenders[1]]] 点打平！开始加赛掷骰！"))

		var/list/new_contenders = list()
		var/best_total = -1
		for(var/mob/living/M in contenders)
			var/roll = rand(1, 6)
			scores[M] += roll
			game_bag.visible_message(span_notice("[M]在加赛中掷出[format_big_die_value(roll, get_roll_color_for(M))] -> 总点数 [scores[M]]。"))
			if(scores[M] > best_total)
				best_total = scores[M]
				new_contenders = list(M)
			else if(scores[M] == best_total)
				new_contenders += M

		if(!new_contenders.len)
			game_bag.visible_message(span_warning("加赛结束时没有有效竞争者。"))
			game_bag.active_game = null
			qdel(src)
			return

		contenders = new_contenders

	var/mob/living/champion = contenders[1]
	game_bag.visible_message(span_green("<b>[champion]以 [scores[champion]] 点赢得了“面包师十三”！</b>"))
	game_bag.active_game = null
	qdel(src)

/datum/bakers_dozen_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		var/state = ""
		if(busted[M])
			state = "（爆牌）"
		else if(stayed[M])
			state = "（停牌）"
		else if(scores[M] == target_score)
			state = "（面包师十三）"
		parts += "[M]: [scores[M]][state]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/bakers_dozen
	name = "面包师十三骰袋"
	desc = "一套用于“面包师十三”的骰子。手持时激活（Z）即可开始或加入一局游戏。"
	var/datum/bakers_dozen_game/active_game
	var/static/bakers_dozen_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
<h2 style='text-align:center;margin:0 0 6px 0;'>面包师十三</h2>
<br>
<b>目标：</b> 一种适合 1 到 4 名玩家的类黑杰克6面骰游戏，目标是尽可能接近 13 点。<br>
<br>
<b>规则：</b><br>
- 每位玩家都必须先投 2 次6面骰（一次一颗）。<br>
- 两次强制投掷结束后，玩家可以选择再投 1 颗6面骰（补牌）或停牌。<br>
- 一旦超过 13 点，立即爆牌。<br>
- 当所有玩家都停牌、正好达到 13 点或爆牌时，本轮结束。<br>
- 未爆牌者中点数最高的玩家获胜。<br>
- 若最高点数相同，则打平玩家持续各自加投 1 颗6面骰，直到有人点数最高为止。<br>
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
		menu += "开始游戏"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "开始游戏"
	else if(can_show_opening_roll)
		menu += "投起手骰"
	else if(can_show_actions)
		menu += "补牌 - 掷1枚6面骰"
		menu += gap1
		menu += "停牌"

	if(menu.len)
		menu += gap2
	menu += "规则"
	menu += gap3
	if(active_game && (user in active_game.players))
		menu += "离开游戏"
		menu += gap4
	menu += "结束游戏"

	var/choice = input(user, "请选择一个选项。", "面包师十三骰袋") as null|anything in menu

	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的“面包师十三”对局。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的“面包师十三”对局。"))
		return

	if(choice == "投起手骰")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的“面包师十三”对局。"))
			return
		if(!(user == active_game.current_player && active_game.can_take_turn_action && !active_game.joining && active_game.mandatory_rolls[user] < 2))
			to_chat(user, span_notice("你现在还不能投起手骰。"))
			return
		active_game.player_action(user, "投起手骰")
		return

	if(choice == "补牌 - 掷1枚6面骰")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的“面包师十三”对局。"))
			return
		if(!(user == active_game.current_player && active_game.can_take_turn_action && !active_game.joining))
			to_chat(user, span_notice("你现在还不能补牌。"))
			return
		active_game.player_action(user, "补牌 - 掷1枚6面骰")
		return

	if(choice == "停牌")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的“面包师十三”对局。"))
			return
		if(!(user == active_game.current_player && active_game.can_take_turn_action && !active_game.joining))
			to_chat(user, span_notice("你现在还不能停牌。"))
			return
		active_game.player_action(user, "停牌")
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/count = input(user, "要几名玩家？\n（2 到 4 名玩家）", "面包师十三") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/bakers_dozen_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)

		src.visible_message(span_notice("[user]开始了一局“面包师十三”！还需要 [count - 1] 名玩家。激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
