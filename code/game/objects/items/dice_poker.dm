/*
 * DICE POKER (Simplified)
 * A 2-4 player, best-of-three d6 game.
 *
 * Round flow:
 * 1) Initial Bet
 * 2) First Roll
 * 3) Raise / Accept / Re-raise / Surrender
 * 4) Re-roll Selection
 * 5) Second Roll and Final Comparison
 *
 * If both final hands compare perfectly equal, Sudden Death repeats:
 * - extra raise phase
 * - extra re-roll phase
 * until one hand exceeds the other.
 */

#define DICE_POKER_RANK_NOTHING 0
#define DICE_POKER_RANK_PAIR 1
#define DICE_POKER_RANK_TWO_PAIR 2
#define DICE_POKER_RANK_TRIPS 3
#define DICE_POKER_RANK_STRAIGHT_5 4
#define DICE_POKER_RANK_STRAIGHT_6 5
#define DICE_POKER_RANK_FULL_HOUSE 6
#define DICE_POKER_RANK_FOUR_KIND 7
#define DICE_POKER_RANK_FIVE_KIND 8

/proc/dice_poker_rank_name(rank)
	switch(rank)
		if(DICE_POKER_RANK_FIVE_KIND)
			return "五同号"
		if(DICE_POKER_RANK_FOUR_KIND)
			return "四同号"
		if(DICE_POKER_RANK_FULL_HOUSE)
			return "葫芦"
		if(DICE_POKER_RANK_STRAIGHT_6)
			return "六高顺子"
		if(DICE_POKER_RANK_STRAIGHT_5)
			return "五高顺子"
		if(DICE_POKER_RANK_TRIPS)
			return "三同号"
		if(DICE_POKER_RANK_TWO_PAIR)
			return "两对"
		if(DICE_POKER_RANK_PAIR)
			return "一对"
		else
			return "散牌"

/proc/dice_poker_sorted_desc(list/L)
	var/list/out = L.Copy()
	for(var/i in 1 to out.len)
		for(var/j in i + 1 to out.len)
			if(out[j] > out[i])
				var/t = out[i]
				out[i] = out[j]
				out[j] = t
	return out

/proc/dice_poker_eval(list/hand) as list
	var/list/result = list(
		"rank" = DICE_POKER_RANK_NOTHING,
		"name" = "散牌",
		"vector" = list()
	)

	if(!hand || hand.len != 5)
		result["name"] = "无效"
		return result

	var/list/counts = list(0, 0, 0, 0, 0, 0)
	for(var/v in hand)
		if(v < 1 || v > 6)
			continue
		counts[v]++

	var/is_12345 = (counts[1] == 1 && counts[2] == 1 && counts[3] == 1 && counts[4] == 1 && counts[5] == 1)
	var/is_23456 = (counts[2] == 1 && counts[3] == 1 && counts[4] == 1 && counts[5] == 1 && counts[6] == 1)

	var/five_kind_face = 0
	var/four_kind_face = 0
	var/trips_face = 0
	var/list/pairs = list()
	var/list/singles = list()

	for(var/f in 1 to 6)
		if(counts[f] == 5)
			five_kind_face = f
		if(counts[f] == 4)
			four_kind_face = f
		if(counts[f] == 3)
			trips_face = f
		if(counts[f] == 2)
			pairs += f
		if(counts[f] == 1)
			singles += f

	if(five_kind_face)
		result["rank"] = DICE_POKER_RANK_FIVE_KIND
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_FIVE_KIND)
		result["vector"] = list(five_kind_face)
		return result

	if(four_kind_face)
		result["rank"] = DICE_POKER_RANK_FOUR_KIND
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_FOUR_KIND)
		var/list/ordered_single = dice_poker_sorted_desc(singles)
		result["vector"] = list(four_kind_face, ordered_single.len ? ordered_single[1] : 0)
		return result

	if(trips_face && pairs.len == 1)
		result["rank"] = DICE_POKER_RANK_FULL_HOUSE
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_FULL_HOUSE)
		result["vector"] = list(trips_face, pairs[1])
		return result

	if(is_23456)
		result["rank"] = DICE_POKER_RANK_STRAIGHT_6
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_STRAIGHT_6)
		result["vector"] = list(6)
		return result

	if(is_12345)
		result["rank"] = DICE_POKER_RANK_STRAIGHT_5
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_STRAIGHT_5)
		result["vector"] = list(5)
		return result

	if(trips_face)
		result["rank"] = DICE_POKER_RANK_TRIPS
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_TRIPS)
		var/list/kickers = dice_poker_sorted_desc(singles)
		var/list/vector = list(trips_face)
		for(var/k in kickers)
			vector += k
		result["vector"] = vector
		return result

	if(pairs.len == 2)
		var/list/ordered_pairs = dice_poker_sorted_desc(pairs)
		var/list/ordered_single2 = dice_poker_sorted_desc(singles)
		result["rank"] = DICE_POKER_RANK_TWO_PAIR
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_TWO_PAIR)
		result["vector"] = list(ordered_pairs[1], ordered_pairs[2], ordered_single2.len ? ordered_single2[1] : 0)
		return result

	if(pairs.len == 1)
		result["rank"] = DICE_POKER_RANK_PAIR
		result["name"] = dice_poker_rank_name(DICE_POKER_RANK_PAIR)
		var/list/kickers2 = dice_poker_sorted_desc(singles)
		var/list/vector2 = list(pairs[1])
		for(var/k2 in kickers2)
			vector2 += k2
		result["vector"] = vector2
		return result

	result["rank"] = DICE_POKER_RANK_NOTHING
	result["name"] = dice_poker_rank_name(DICE_POKER_RANK_NOTHING)
	result["vector"] = dice_poker_sorted_desc(hand)
	return result

/proc/dice_poker_compare(list/eval_a, list/eval_b)
	if(!eval_a || !eval_b)
		return 0
	var/rank_a = eval_a["rank"]
	var/rank_b = eval_b["rank"]
	if(rank_a > rank_b)
		return 1
	if(rank_b > rank_a)
		return -1

	var/list/vec_a = eval_a["vector"]
	var/list/vec_b = eval_b["vector"]
	var/max_len = max(vec_a ? vec_a.len : 0, vec_b ? vec_b.len : 0)
	for(var/i in 1 to max_len)
		var/av = (vec_a && i <= vec_a.len) ? vec_a[i] : 0
		var/bv = (vec_b && i <= vec_b.len) ? vec_b[i] : 0
		if(av > bv)
			return 1
		if(bv > av)
			return -1

	return 0

/proc/dice_poker_hand_to_text(list/hand)
	var/list/parts = list()
	for(var/v in hand)
		parts += "[v]"
	return jointext(parts, " - ")


/datum/dice_poker_game
	var/list/mob/living/players = list()
	var/list/round_active = list()     // players still contesting the current hand
	var/list/round_wins = list()       // assoc: mob -> int
	var/list/hands = list()            // assoc: mob -> list of five ints
	var/list/rolls_used = list()       // assoc: mob -> int (base round rolls, max 2)
	var/list/reroll_done = list()      // assoc: mob -> TRUE/FALSE for reroll phase
	var/list/selected_reroll = list()  // assoc: mob -> list of indexes (1..5)
	var/list/reroll_mask = list()      // assoc: mob -> bitmask of selected indexes (bit 1 = die 1)
	var/list/bet_caps = list()         // assoc: mob -> int (experience-scaled cap)
	var/list/raise_spent = list()      // assoc: mob -> total raised this round
	var/list/raised_this_round = list() // assoc: mob -> TRUE/FALSE (one raise max per round)

	var/current_player_index = 0
	var/mob/living/current_player = null
	var/mob/living/last_round_loser = null
	var/mob/living/round_starter = null

	var/current_bet = 10
	var/min_bet = 10
	var/round_number = 0

	var/phase = "joining" // joining, initial_roll, reroll_select, showdown, game_over
	var/busy = FALSE
	var/joining = TRUE
	var/max_players = 4
	var/can_take_action = FALSE
	var/max_sudden_death_cycles = 12

	var/obj/item/storage/pill_bottle/dice/dice_poker/game_bag

/datum/dice_poker_game/proc/get_exp_cap(mob/living/M)
	if(!M)
		return 20
	var/luck_val = 0
	if("STALUC" in M.vars)
		luck_val = text2num("[M.vars["STALUC"]]")
	luck_val = clamp(luck_val, 0, 20)
	return 20 + (luck_val * 2)

/datum/dice_poker_game/proc/get_opponent(mob/living/M)
	for(var/mob/living/P in players)
		if(P != M)
			return P
	return null

/datum/dice_poker_game/proc/get_next_player_in(list/pool, mob/living/current)
	if(!pool || !pool.len)
		return null
	var/start_idx = pool.Find(current)
	if(!start_idx)
		start_idx = 0
	for(var/step in 1 to pool.len)
		var/i = ((start_idx + step - 1) % pool.len) + 1
		var/mob/living/candidate = pool[i]
		if(candidate)
			return candidate
	return null

/datum/dice_poker_game/proc/get_hand_color_for(mob/living/M)
	var/i = players.Find(M)
	switch(i)
		if(1)
			return "#4FC3F7"
		if(2)
			return "#ee4040"
		if(3)
			return "#b759e2"
		if(4)
			return "#f53ff5"
		else
			return "#E0E0E0"

/datum/dice_poker_game/proc/format_player_colored_text(mob/living/M, text)
	var/color = get_hand_color_for(M)
	return "<span style='color:[color];font-size:larger;font-weight:bold;'>[text]</span>"

/datum/dice_poker_game/proc/format_colored_hand(mob/living/M)
	var/hand_text = dice_poker_hand_to_text(hands[M])
	return format_player_colored_text(M, hand_text)

/datum/dice_poker_game/proc/show_private_hand(mob/living/M)
	if(!M || !(M in players))
		return
	if(joining)
		to_chat(M, span_notice("游戏尚未开始。"))
		return
	var/list/hand = hands[M]
	if(!hand || hand.len != 5)
		to_chat(M, span_notice("你还没有掷出手牌。"))
		return
	to_chat(M, span_notice("你的隐藏手牌：[format_colored_hand(M)]"))

/datum/dice_poker_game/proc/get_next_unresponded(list/pool, mob/living/current, list/responded)
	if(!pool || !pool.len)
		return null
	var/start_idx = pool.Find(current)
	if(!start_idx)
		start_idx = 0
	for(var/step in 1 to pool.len)
		var/i = ((start_idx + step - 1) % pool.len) + 1
		var/mob/living/candidate = pool[i]
		if(candidate && !responded[candidate])
			return candidate
	return null

/datum/dice_poker_game/proc/get_remaining_raise_cap(mob/living/M)
	var/cap = bet_caps[M]
	var/spent = raise_spent[M]
	if(!isnum(cap))
		cap = 0
	if(!isnum(spent))
		spent = 0
	return max(cap - spent, 0)

/datum/dice_poker_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("骰子扑克已经开始了。"))
		return

	if(joiner in players)
		var/list/opts = list("离开游戏")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅中了。([players.len]/[max_players] 名玩家)", "骰子扑克") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开游戏")
			players -= joiner
			round_wins -= joiner
			hands -= joiner
			rolls_used -= joiner
			selected_reroll -= joiner
			bet_caps -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了赛前大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("骰子扑克人数已满（[max_players]/[max_players]）。"))
		return

	players += joiner
	round_wins[joiner] = 0
	round_active[joiner] = TRUE
	hands[joiner] = list()
	rolls_used[joiner] = 0
	reroll_done[joiner] = FALSE
	selected_reroll[joiner] = list()
	reroll_mask[joiner] = 0
	bet_caps[joiner] = get_exp_cap(joiner)
	raise_spent[joiner] = 0
	raised_this_round[joiner] = FALSE

	game_bag.visible_message(span_notice("[joiner]加入了骰子扑克！（[players.len]/[max_players] 名玩家）"))
	if(players.len == max_players)
		start_game()

/datum/dice_poker_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局骰子扑克中。"))
		return

	players -= leaver
	round_active -= leaver
	round_wins -= leaver
	hands -= leaver
	rolls_used -= leaver
	reroll_done -= leaver
	selected_reroll -= leaver
	reroll_mask -= leaver
	bet_caps -= leaver
	raise_spent -= leaver
	raised_this_round -= leaver

	game_bag.visible_message(span_notice("[leaver]离开了骰子扑克。"))

	if(!players.len)
		cancel_game(leaver)
		return

	if(joining)
		if(players.len < 2)
			cancel_game(leaver)
		return

	if(players.len < 2)
		end_game_with_winner(players.len ? players[1] : null, "弃权")
		return

	if(phase == "showdown" || phase == "reroll_select" || phase == "initial_roll")
		if(round_active && round_active.len)
			round_active -= leaver
			if(round_active.len == 1)
				award_round_win(round_active[1], null, "弃权")
				return

	if(current_player == leaver)
		current_player = get_next_player_in(players, leaver)
		current_player_index = players.Find(current_player)
		if(current_player_index < 1)
			current_player_index = 1

/datum/dice_poker_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller]取消了骰子扑克！"))
	game_bag.active_game = null
	qdel(src)

/datum/dice_poker_game/proc/start_game()
	if(!joining)
		return
	if(players.len < 2)
		return

	joining = FALSE
	phase = "initial_roll"
	current_player = null
	current_player_index = 0
	last_round_loser = null
	current_bet = min_bet
	round_number = 0

	for(var/mob/living/P in players)
		round_wins[P] = 0
		round_active[P] = TRUE
		rolls_used[P] = 0
		reroll_done[P] = FALSE
		selected_reroll[P] = list()
		reroll_mask[P] = 0
		bet_caps[P] = get_exp_cap(P)
		raise_spent[P] = 0
		raised_this_round[P] = FALSE
		hands[P] = list()

	game_bag.visible_message(span_notice("骰子扑克开始！三局两胜。"))
	start_round()

/datum/dice_poker_game/proc/start_round()
	if(phase == "game_over")
		return

	round_number++
	phase = "initial_roll"
	round_active = list()
	for(var/mob/living/P in players)
		round_active += P
		rolls_used[P] = 0
		reroll_done[P] = FALSE
		selected_reroll[P] = list()
		reroll_mask[P] = 0
		hands[P] = list()
		bet_caps[P] = get_exp_cap(P)
		raise_spent[P] = 0
		raised_this_round[P] = FALSE

	if(last_round_loser && (last_round_loser in round_active))
		current_player_index = players.Find(last_round_loser)
	else if(round_starter && (round_starter in round_active))
		current_player_index = players.Find(get_next_player_in(round_active, round_starter))
	else
		current_player_index = 1

	if(current_player_index < 1 || current_player_index > players.len)
		current_player_index = 1

	current_player = players[current_player_index]
	round_starter = current_player
	can_take_action = TRUE

	game_bag.visible_message(span_notice("--- 骰子扑克 第 [round_number] 轮 --- 比分：[get_round_score_display()]"))
	game_bag.visible_message(span_notice("[current_player]率先开始本轮。"))
	to_chat(current_player, span_notice("使用骰袋并选择“掷骰”。"))

/datum/dice_poker_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("当前比分：[get_round_score_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return
	if(!can_take_action)
		to_chat(user, span_notice("请等待当前动作结算完毕。"))
		return
	if(user != current_player)
		to_chat(user, span_notice("还没轮到你。当前阶段：[phase]。"))
		return

	if(action == "掷骰")
		if(phase != "initial_roll")
			to_chat(user, span_notice("“掷骰”只在首掷阶段可用。"))
			return
		do_initial_roll(user)
		return

	if(action == "选择重掷")
		if(phase != "reroll_select")
			to_chat(user, span_notice("当前未开放重掷选择。"))
			return
		do_select_and_reroll(user)
		return

	to_chat(user, span_notice("该选项当前不可用。"))

/datum/dice_poker_game/proc/do_initial_roll(mob/living/roller)
	if(roller != current_player)
		return
	if(!(roller in round_active))
		return
	if(rolls_used[roller] >= 1)
		to_chat(roller, span_notice("这回合你已经完成首掷。"))
		return

	busy = TRUE
	can_take_action = FALSE
	playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)

	var/list/hand = list()
	for(var/i in 1 to 5)
		hand += rand(1, 6)
	hands[roller] = hand
	rolls_used[roller] = 1
	selected_reroll[roller] = list()

	to_chat(roller, span_notice("你的首轮手牌：[format_colored_hand(roller)]"))
	game_bag.visible_message(span_notice("[roller]已完成首轮掷骰。"))

	busy = FALSE

	var/mob/living/next_unrolled = null
	for(var/mob/living/P in round_active)
		if(rolls_used[P] < 1)
			next_unrolled = P
			break

	if(next_unrolled)
		current_player = get_next_player_in(round_active, roller)
		while(current_player && rolls_used[current_player] >= 1)
			current_player = get_next_player_in(round_active, current_player)
		if(!current_player)
			current_player = next_unrolled
		current_player_index = players.Find(current_player)
		can_take_action = TRUE
		to_chat(current_player, span_notice("轮到你了：请选择“掷骰”。"))
		return

	phase = "reroll_select"
	current_player = round_starter
	if(!(current_player in round_active))
		current_player = round_active[1]
	current_player_index = players.Find(current_player)
	can_take_action = TRUE

	game_bag.visible_message(span_notice("双方首掷已完成。重掷选择阶段开始。"))
	to_chat(current_player, span_notice("请选择“选择重掷”。"))

/datum/dice_poker_game/proc/do_betting_phase(mob/living/opener)
	if(opener != current_player)
		return
	if(!round_active || round_active.len < 2)
		if(round_active && round_active.len == 1)
			award_round_win(round_active[1], null, "其余人都弃牌")
		return

	busy = TRUE
	can_take_action = FALSE

	var/context = (phase == "initial_bet") ? "初始下注" : "下注"
	var/mob/living/surrender_winner = perform_raise_chain(round_active.Copy(), opener, context)
	if(surrender_winner)
		busy = FALSE
		award_round_win(surrender_winner, null, "surrender")
		return

	busy = FALSE

	if(phase == "initial_bet")
		phase = "initial_roll"
		current_player = round_starter
		if(!(current_player in round_active))
			current_player = round_active[1]
		current_player_index = players.Find(current_player)
		if(current_player_index < 1)
			current_player_index = 1
		can_take_action = TRUE
		game_bag.visible_message(span_notice("初始赌注锁定为 [current_bet]。首掷阶段开始。"))
		to_chat(current_player, span_notice("请选择“掷骰”。"))
		return

	phase = "reroll_select"
	current_player = round_starter
	if(!(current_player in round_active))
		current_player = round_active[1]
	current_player_index = players.Find(current_player)
	if(current_player_index < 1)
		current_player_index = 1
	can_take_action = TRUE
	game_bag.visible_message(span_notice("赌注以 [current_bet] 成交。重掷选择阶段开始。"))
	to_chat(current_player, span_notice("请选择“选择重掷”。"))

/datum/dice_poker_game/proc/perform_raise_chain(list/participants, mob/living/starter, context = "下注")
	if(!participants || participants.len < 2)
		return null

	var/list/responded = list()
	for(var/mob/living/P in participants)
		responded[P] = FALSE

	var/mob/living/acting = starter
	if(!(acting in participants))
		acting = participants[1]

	while(TRUE)
		if(participants.len <= 1)
			return participants[1]

		var/mob/living/pending = null
		for(var/mob/living/P2 in participants)
			if(!responded[P2])
				pending = P2
				break
		if(!pending)
			return null

		if(!(acting in participants) || responded[acting])
			acting = get_next_unresponded(participants, acting, responded)
		if(!acting)
			return null

		var/cap_remaining = get_remaining_raise_cap(acting)
		var/list/options = list("接受", "弃牌")
		if(!raised_this_round[acting] && cap_remaining >= 1)
			options += "加注"

		var/prompt = "[context]。当前赌注：[current_bet]。"
		var/choice = input(acting, prompt, "骰子扑克") as null|anything in options
		if(!choice)
			choice = "接受"

		if(choice == "弃牌")
			game_bag.visible_message(span_warning("[acting]弃掉了这一手。"))
			participants -= acting
			round_active -= acting
			responded -= acting
			if(participants.len <= 1)
				return participants.len ? participants[1] : null
			acting = get_next_player_in(participants, acting)
			continue

		if(choice == "加注")
			var/raise_amt = prompt_raise_amount(acting, cap_remaining)
			if(raise_amt > 0)
				current_bet += raise_amt
				raise_spent[acting] = raise_spent[acting] + raise_amt
				raised_this_round[acting] = TRUE
				game_bag.visible_message(span_notice("[acting]加注了 [raise_amt]。新赌注为：[current_bet]。"))
				for(var/mob/living/P3 in participants)
					responded[P3] = FALSE
				responded[acting] = TRUE
				acting = get_next_player_in(participants, acting)
				continue

		responded[acting] = TRUE
		acting = get_next_player_in(participants, acting)

/datum/dice_poker_game/proc/prompt_raise_amount(mob/living/actor, raise_cap)
	if(raise_cap < 1)
		return 0
	var/list/raise_choices = build_raise_choices(raise_cap)
	var/amt_txt = input(actor, "要加注多少？（上限 [raise_cap]）", "骰子扑克") as null|anything in raise_choices
	if(!amt_txt)
		return 0
	return max(text2num("[amt_txt]"), 0)

/datum/dice_poker_game/proc/build_raise_choices(max_raise)
	var/list/out = list()
	var/cap = min(max_raise, 100)
	for(var/i in 1 to cap)
		out += "[i]"
	if(!out.len)
		out += "1"
	return out

/datum/dice_poker_game/proc/do_select_and_reroll(mob/living/actor)
	if(actor != current_player)
		return
	if(!(actor in round_active))
		return

	busy = TRUE
	can_take_action = FALSE

	var/list/hand = hands[actor]
	if(!hand || hand.len != 5)
		busy = FALSE
		return

	to_chat(actor, span_notice("当前手牌：[format_colored_hand(actor)]"))

	var/list/sel = list()
	while(TRUE)
		var/list/menu = list()
		var/list/choice_to_index = list()
		for(var/i in 1 to 5)
			var/mark = "( )"
			if(i in sel)
				mark = "(X)"
			var/line = "[mark] 第 [i] 颗骰子：[hand[i]]"
			menu += line
			choice_to_index[line] = i
		menu += "全部重掷"
		menu += "完成"

		var/choice = input(actor, "选择要重掷的骰子。切换条目后点“完成”。", "骰子扑克") as null|anything in menu
		if(!choice || choice == "完成")
			break

		if(choice == "全部重掷")
			sel = list(1, 2, 3, 4, 5)
			break

		var/chosen_index = choice_to_index[choice]

		if(chosen_index)
			if(chosen_index in sel)
				sel -= chosen_index
			else
				sel += chosen_index

	selected_reroll[actor] = sel.Copy()
	reroll_mask[actor] = selection_to_mask(sel)

	if(sel.len)
		playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 75, TRUE)
		for(var/i3 in sel)
			hand[i3] = rand(1, 6)
		game_bag.visible_message(span_notice("[actor]重掷了 [sel.len] 颗骰子。"))
	else
		game_bag.visible_message(span_notice("[actor]保留了全部骰子（未重掷）。"))

	hands[actor] = hand
	rolls_used[actor] = max(rolls_used[actor], 2)
	reroll_done[actor] = TRUE
	to_chat(actor, span_notice("你的最终手牌：[format_colored_hand(actor)]"))

	busy = FALSE

	var/mob/living/next_pending = null
	for(var/mob/living/P in round_active)
		if(!reroll_done[P])
			next_pending = P
			break

	if(next_pending)
		current_player = get_next_player_in(round_active, actor)
		while(current_player && reroll_done[current_player])
			current_player = get_next_player_in(round_active, current_player)
		if(!current_player)
			current_player = next_pending
		current_player_index = players.Find(current_player)
		can_take_action = TRUE
		to_chat(current_player, span_notice("轮到你了：请选择“选择重掷”。"))
		return

	phase = "showdown"
	resolve_showdown_chain()

/datum/dice_poker_game/proc/resolve_showdown_chain()
	if(!round_active || round_active.len < 1)
		return
	if(round_active.len == 1)
		award_round_win(round_active[1], null, "其余人都弃牌")
		return

	var/sd_cycles = 0

	while(TRUE)
		var/list/reveal_parts = list()
		var/list/leaders = list()
		var/list/best_eval = null

		for(var/mob/living/P in round_active)
			var/list/eval_p = dice_poker_eval(hands[P])
			var/eval_rank = eval_p["rank"]
			var/eval_name = dice_poker_rank_name(eval_rank)
			var/colored_eval_name = format_player_colored_text(P, eval_name)
			reveal_parts += "[P]掷出了 [format_colored_hand(P)]（[colored_eval_name]）"

			if(!best_eval)
				best_eval = eval_p
				leaders = list(P)
				continue

			var/cmp_p = dice_poker_compare(eval_p, best_eval)
			if(cmp_p > 0)
				best_eval = eval_p
				leaders = list(P)
			else if(cmp_p == 0)
				leaders += P

		var/reveal_text = jointext(reveal_parts, " | ")
		game_bag.visible_message(span_notice("亮牌：[reveal_text]。"))

		if(leaders.len == 1)
			award_round_win(leaders[1], null, "牌型更大")
			return

		sd_cycles++
		if(sd_cycles > max_sudden_death_cycles)
			var/mob/living/forced_winner = pick(leaders)
			game_bag.visible_message(span_warning("猝死局超过 [max_sudden_death_cycles] 轮。为防止僵局，本手判给 [forced_winner]。"))
			award_round_win(forced_winner, null, "sudden death limit")
			return

		game_bag.visible_message(span_warning("[leaders.len] 名玩家完全平局。触发猝死局：强制重掷。"))
		round_active = leaders.Copy()

		var/mob/living/sd_winner = sudden_death_cycle(round_active.Copy())
		if(sd_winner)
			award_round_win(sd_winner, null, "sudden death")
			return

/datum/dice_poker_game/proc/sudden_death_cycle(list/contenders)
	if(!contenders || contenders.len < 2)
		return contenders && contenders.len ? contenders[1] : null

	for(var/mob/living/P in contenders)
		var/list/sel = choose_reroll_indexes(P, TRUE)
		apply_reroll(P, sel)

	var/list/leaders = list()
	var/list/best_eval = null
	for(var/mob/living/P2 in contenders)
		var/list/eval_p2 = dice_poker_eval(hands[P2])
		if(!best_eval)
			best_eval = eval_p2
			leaders = list(P2)
			continue
		var/cmp2 = dice_poker_compare(eval_p2, best_eval)
		if(cmp2 > 0)
			best_eval = eval_p2
			leaders = list(P2)
		else if(cmp2 == 0)
			leaders += P2

	round_active = leaders.Copy()
	if(leaders.len == 1)
		return leaders[1]
	return null

/datum/dice_poker_game/proc/choose_reroll_indexes(mob/living/M, force_one = FALSE)
	var/list/hand = hands[M]
	var/list/sel = list()
	to_chat(M, span_notice("当前猝死局手牌：[format_colored_hand(M)]"))
	while(TRUE)
		var/list/menu = list()
		var/list/choice_to_index = list()
		for(var/i in 1 to 5)
			var/mark = "( )"
			if(i in sel)
				mark = "(X)"
			var/line = "[mark] 第 [i] 颗骰子：[hand[i]]"
			menu += line
			choice_to_index[line] = i
		menu += "全部重掷"
		menu += "完成"
		var/choice = input(M, "猝死局重掷选择。", "骰子扑克") as null|anything in menu
		if(!choice || choice == "完成")
			break
		if(choice == "全部重掷")
			sel = list(1, 2, 3, 4, 5)
			break
		var/j = choice_to_index[choice]
		if(j)
			if(j in sel)
				sel -= j
			else
				sel += j

	if(force_one && !sel.len)
		var/forced_idx = rand(1, 5)
		sel += forced_idx
		to_chat(M, span_warning("猝死局至少需要重掷一颗骰子。第 [forced_idx] 颗将被重掷。"))

	return sel

/datum/dice_poker_game/proc/selection_to_mask(list/sel)
	var/mask = 0
	if(!sel)
		return mask
	for(var/i in sel)
		if(i >= 1 && i <= 5)
			mask |= (1 << (i - 1))
	return mask

/datum/dice_poker_game/proc/apply_reroll(mob/living/M, list/indexes)
	var/list/hand = hands[M]
	if(!hand || hand.len != 5)
		return
	selected_reroll[M] = indexes ? indexes.Copy() : list()
	reroll_mask[M] = selection_to_mask(indexes)
	if(indexes && indexes.len)
		playsound(game_bag, 'sound/items/cup_dice_roll.ogg', 65, TRUE)
		for(var/i in indexes)
			hand[i] = rand(1, 6)
		hands[M] = hand
		to_chat(M, span_notice("猝死局手牌：[format_colored_hand(M)]"))
		game_bag.visible_message(span_notice("[M]在猝死局中重掷了 [indexes.len] 颗骰子。"))
	else
		game_bag.visible_message(span_notice("[M]在猝死局中保留了全部骰子。"))

/datum/dice_poker_game/proc/award_round_win(mob/living/winner, mob/living/loser, reason)
	if(!winner)
		return

	round_wins[winner]++
	if(loser && (loser in players))
		last_round_loser = loser
	else
		last_round_loser = get_next_player_in(players, winner)

	game_bag.visible_message(span_green("<b>[winner]赢下本轮（[reason]）！比分：[get_round_score_display()]。</b>"))

	if(round_wins[winner] >= 2)
		end_game_with_winner(winner, "三局两胜")
		return

	phase = "initial_roll"
	can_take_action = TRUE
	start_round()

/datum/dice_poker_game/proc/get_round_score_display()
	var/list/parts = list()
	for(var/mob/living/P in players)
		parts += "[P]: [round_wins[P]]"
	return jointext(parts, " | ")

/datum/dice_poker_game/proc/end_game_with_winner(mob/living/winner, reason)
	phase = "game_over"
	can_take_action = FALSE
	if(winner)
		game_bag.visible_message(span_green("<b>--- 骰子扑克结束 --- [winner]以[reason]获胜！最终比分：[get_round_score_display()]。</b>"))
	else
		game_bag.visible_message(span_warning("--- 骰子扑克结束 ---"))
	game_bag.active_game = null
	qdel(src)


/obj/item/storage/pill_bottle/dice/dice_poker
	name = "骰子扑克骰袋"
	desc = "一个用来玩骰子扑克的骰袋。手持激活（Z）即可开始或加入游戏。"
	var/datum/dice_poker_game/active_game
	var/static/dice_poker_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>骰子扑克</h2>
<br>
<b>目标：</b>在三局两胜中，以更强的牌型赢下 2 局。<br>
<br>
<b>回合流程：</b><br>
1) 首掷一次（每人 5 枚6面骰）。<br>
2) 选择要重掷的骰子，各可重掷一次。<br>
3) 亮牌并比较牌型。<br>
<br>
<b>牌型大小（从低到高）：</b><br>
散牌：五颗骰子互不成型。<br>
一对：两颗同点数骰子。<br>
两对：两组不同的对子。<br>
三条：三颗同点数骰子。<br>
五高顺：1、2、3、4、5。<br>
六高顺：2、3、4、5、6。<br>
葫芦：三条加一对。<br>
四条：四颗同点数骰子。<br>
五条：五颗骰子全部相同。<br>
<br>
<b>散牌：</b>凡是不成对子且不是五连顺的手牌，按最大散张依次比较。<br>
<br>
<b>平局规则：</b><br>
若双方手牌完全相同（包括散张比较），则进入猝死局：
强制重掷，直到有人分出胜负。<br>
</div>"}

/obj/item/storage/pill_bottle/dice/dice_poker/proc/show_rules(mob/living/user)
	if(!user)
		return
	user << browse(dice_poker_rules_text, "window=dice_poker_rules;size=720x520")

/obj/item/storage/pill_bottle/dice/dice_poker/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/dice/d6(src)

/obj/item/storage/pill_bottle/dice/dice_poker/attack_self(mob/living/user)
	if(active_game && active_game.joining && (user in active_game.players) && active_game.players.len >= 2)
		active_game.start_game()

	var/list/menu = list()
	var/list/spacers = list(" ", "  ", "   ", "    ", "     ")
	var/spacer_index = 1
	var/can_roll = FALSE
	var/can_reroll = FALSE
	var/can_check_hand = FALSE

	if(active_game && !active_game.joining && user == active_game.current_player && active_game.can_take_action)
		if(active_game.phase == "initial_roll")
			can_roll = TRUE
		else if(active_game.phase == "reroll_select")
			can_reroll = TRUE

	if(active_game && !active_game.joining && (user in active_game.players))
		can_check_hand = TRUE

	if(!active_game)
		menu += "开始游戏"
	else if(active_game.joining)
		if(!(user in active_game.players))
			menu += "加入游戏"
	else
		if(can_roll)
			menu += "掷骰"
		if(can_reroll)
			menu += "选择重掷"
		if(can_check_hand)
			if(menu.len)
				menu += spacers[spacer_index]
				spacer_index++
			menu += "查看我的手牌"

	if(menu.len)
		menu += spacers[spacer_index]
		spacer_index++
	menu += "规则"
	menu += spacers[spacer_index]
	spacer_index++
	if(active_game && (user in active_game.players))
		menu += "离开游戏"
		menu += spacers[spacer_index]
		spacer_index++
	menu += "结束游戏"

	var/choice = input(user, "选择一个选项。", "骰子扑克") as null|anything in menu
	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的骰子扑克。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的骰子扑克。"))
		return

	if(choice == "掷骰")
		if(active_game)
			active_game.player_action(user, "掷骰")
		return

	if(choice == "选择重掷")
		if(active_game)
			active_game.player_action(user, "选择重掷")
		return

	if(choice == "查看我的手牌")
		if(active_game && !active_game.joining && (user in active_game.players))
			active_game.show_private_hand(user)
		else
			to_chat(user, span_notice("你不在当前进行中的骰子扑克对局里。"))
		return

	if(choice == "加入游戏")
		if(active_game && active_game.joining)
			active_game.try_join(user)
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/count = input(user, "需要几名玩家？\n（2 到 4 名玩家）", "骰子扑克") as null|anything in list(2, 3, 4)
		if(!count)
			return

		var/datum/dice_poker_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = count
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user]正在发起骰子扑克！还需要 [count - 1] 名玩家。手持激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)

#undef DICE_POKER_RANK_NOTHING
#undef DICE_POKER_RANK_PAIR
#undef DICE_POKER_RANK_TWO_PAIR
#undef DICE_POKER_RANK_TRIPS
#undef DICE_POKER_RANK_STRAIGHT_5
#undef DICE_POKER_RANK_STRAIGHT_6
#undef DICE_POKER_RANK_FULL_HOUSE
#undef DICE_POKER_RANK_FOUR_KIND
#undef DICE_POKER_RANK_FIVE_KIND
