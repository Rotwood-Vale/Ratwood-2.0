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
		to_chat(joiner, span_warning("这局Three's Away对局已经开始了。"))
		return

	if(joiner in players)
		var/list/opts = list("离开游戏")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅里了。([players.len]/[max_players] 名玩家)", "Three's Away 对局") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开游戏")
			players -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了赛前大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("Three's Away 对局已经满员了([max_players]/[max_players])。"))
		return

	players += joiner
	scores[joiner] = 0
	rolled[joiner] = FALSE
	busted[joiner] = FALSE
	ante_doubled[joiner] = FALSE
	game_bag.visible_message(span_notice("[joiner]加入了Three's Away！([players.len]/[max_players] 名玩家)"))
	if(players.len >= max_players)
		start_game()

/datum/threes_away_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局Three's Away里。"))
		return

	var/leaver_index = players.Find(leaver)
	var/was_current = (leaver_index == current_player_index)

	players -= leaver
	scores -= leaver
	rolled -= leaver
	busted -= leaver
	ante_doubled -= leaver

	game_bag.visible_message(span_notice("[leaver]离开了Three's Away。([players.len]/[max_players] 名玩家剩余)"))

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
	game_bag.visible_message(span_warning("[canceller]取消了Three's Away！"))
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
	game_bag.visible_message(span_notice("Three's Away 对局开始了！玩家：[jointext(names, ", ")]。"))
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
		game_bag.visible_message(span_notice("--- [active]的回合 | [get_score_display()] ---"))
		to_chat(active, span_notice("打开骰袋菜单并选择“掷骰”。"))
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

	var/choice = input(active, "精确选择一个骰子留下，并在这轮搁到一旁。", "Three's Away 对局") as null|anything in menu
	if(!choice)
		for(var/f in 1 to 6)
			if(roll_counts[f] > 0)
				to_chat(active, span_notice("没有选择骰子；自动保留一个 [f]。"))
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

		game_bag.visible_message(span_notice("[active]掷出了([remaining_dice]枚6面骰)：[format_big_roll(current_roll, get_roll_color_for(active))]。"))

		if(count_threes_this_roll >= 4)
			busted[active] = TRUE
			rolled[active] = TRUE
			ante_doubled[active] = TRUE
			game_bag.visible_message(span_danger("[active]掷出了四个或更多的 3，直接爆掉！下个底池里，[active.p_their()]的底注翻倍。"))
			busy = FALSE
			if(all_players_done())
				end_round()
			else
				next_turn()
			return

		while(total_threes_rolled >= next_three_wipe_threshold)
			score_total = 0
			next_three_wipe_threshold += 3
			game_bag.visible_message(span_notice("[active]在这一回合里又掷出了三个 3！[active.p_their()]的分数再次清零。"))

		var/kept_now = choose_kept_die(active, current_roll)
		kept_values += kept_now
		if(kept_now != 3)
			score_total += kept_now
		remaining_dice--
		if(remaining_dice < 0)
			remaining_dice = 0
		to_chat(active, span_notice("你保留了 [format_big_die_value(kept_now, get_roll_color_for(active))]。还剩 [remaining_dice] 次掷骰。"))

	scores[active] = score_total
	rolled[active] = TRUE

	game_bag.visible_message(span_notice("[active]留出的骰子为：[format_big_roll(kept_values, get_roll_color_for(active))]。最终得分：[score_total]。"))

	busy = FALSE
	if(all_players_done())
		end_round()
	else
		next_turn()

/datum/threes_away_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("当前总分：[get_score_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return
	if(user != current_player)
		input(user, "还没轮到你。总分：[get_score_display()]", "Three's Away 对局") as null|anything in list("确定")
		return
	if(current_player_index < 1 || current_player_index > players.len)
		to_chat(user, span_warning("回合顺序正在重新同步。稍后再试。"))
		return
	if(user != players[current_player_index])
		to_chat(user, span_warning("现在还没轮到你。"))
		return
	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("你这回合已经掷过骰了。"))
		return
	if(action != "掷骰")
		to_chat(user, span_notice("请在菜单里选择“掷骰”。"))
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

	game_bag.visible_message(span_notice("--- Three's Away 本轮结束 ---<br>总分：[get_score_display()]"))

	if(!contenders.len)
		game_bag.visible_message(span_warning("无人获胜。所有人都爆掉了。"))
		announce_ante_doubles()
		game_bag.active_game = null
		qdel(src)
		return

	if(contenders.len == 1)
		var/mob/living/champion = contenders[1]
		game_bag.visible_message(span_green("<b>[champion]以最低分 [scores[champion]] 获胜！</b>"))
		announce_ante_doubles()
		game_bag.active_game = null
		qdel(src)
		return

	var/list/names = list()
	for(var/mob/living/M in contenders)
		names += "[M]"
	game_bag.visible_message(span_notice("[jointext(names, ", ")] 以最低分 ([best_score]) 打成平手。"))
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
		game_bag.visible_message(span_warning("加赛决胜！[jointext(names, ", ")] 再各掷一次。总分最低者获胜。"))

		var/best_total = 999999
		var/list/mob/living/new_contenders = list()

		for(var/mob/living/M in current_contenders)
			var/list/rolls = list(rand(1, 6), rand(1, 6), rand(1, 6), rand(1, 6), rand(1, 6))
			var/roll_total = 0
			for(var/v in rolls)
				roll_total += v
			game_bag.visible_message(span_notice("[M] 的加赛掷骰：[format_big_roll(rolls, get_roll_color_for(M))]（总分 [roll_total]）。"))

			if(roll_total < best_total)
				best_total = roll_total
				new_contenders = list(M)
			else if(roll_total == best_total)
				new_contenders += M

		current_contenders = new_contenders
		if(current_contenders.len > 1)
			game_bag.visible_message(span_notice("加赛仍以 [best_total] 平手。继续再掷。"))

	var/mob/living/champion = current_contenders[1]
	game_bag.visible_message(span_green("<b>[champion]以最低总分赢下了加赛！</b>"))
	announce_ante_doubles()
	game_bag.active_game = null
	qdel(src)

/datum/threes_away_game/proc/announce_ante_doubles()
	var/list/doubled = list()
	for(var/mob/living/M in players)
		if(ante_doubled[M])
			doubled += "[M]"
	if(doubled.len)
		game_bag.visible_message(span_warning("下个底池需要双倍底注的玩家：[jointext(doubled, ", ")]。"))

/datum/threes_away_game/proc/get_score_display()
	var/list/parts = list()
	for(var/mob/living/M in players)
		var/state = ""
		if(busted[M])
			state = "（爆掉）"
		else if(rolled[M])
			state = "（已掷）"
		parts += "[M]: [scores[M]][state]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/threes_away
	name = "Three's Away骰袋"
	desc = "一个用来游玩Three's Away的骰袋。手持激活（Z）即可开始或加入一局游戏。"
	var/datum/threes_away_game/active_game
	var/static/threes_away_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>Three's Away</h2>
<br>
<b>目标：</b>取得最低分。<br>
<br>
<b>规则：</b><br>
- 玩家依次掷 5 枚6面骰。<br>
- 每次掷完后，必须选择一个骰子搁到一旁。<br>
- 持续掷剩余骰子，直到五个骰子都被搁出。<br>
- 3 记作 0 分，1 是宝贵的低分骰。<br>
- 如果你在自己的回合内掷出三个 3，你的分数会被清零。<br>
- 如果你单次掷出四个或更多 3，你会爆掉并失去资格。<br>
<br>
<b>平局判定：</b><br>
如果回合结束时最低分出现平手，平手玩家需要再掷一次。<br>
每位平手玩家都重新掷一组 5 枚6面骰。<br>
将这一组的总分相加。<br>
总分最低者赢得加赛。<br>
如果加赛仍然平手，就会自动重复，直到只剩一名胜者。<br>
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
		menu += "开始游戏"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "开始游戏"
	else if(can_show_roll)
		menu += "掷骰"

	if(menu.len)
		menu += gap1
	menu += "规则"
	menu += gap2
	if(active_game && (user in active_game.players))
		menu += "离开游戏"
		menu += gap3
	menu += "结束游戏"

	var/choice = input(user, "选择一项操作。", "Three's Away 骰袋") as null|anything in menu
	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的Three's Away游戏。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的Three's Away游戏。"))
		return

	if(choice == "掷骰")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的Three's Away游戏。"))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.joining))
			to_chat(user, span_notice("你现在不能掷骰。"))
			return
		active_game.player_action(user, "掷骰")
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/count = input(user, "要几名玩家？\n（2 到 4 名玩家）", "Three's Away 对局") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/threes_away_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user]开始了一局Three's Away！还需要 [count - 1] 名玩家。激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
