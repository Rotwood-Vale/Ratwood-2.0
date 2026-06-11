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
	return "<span style='color:#EF5350;font-size:larger;font-weight:bold;'>生命：[v]</span>"

/datum/dice_war_game/proc/get_opponent(mob/living/M)
	for(var/mob/living/P in players)
		if(P != M)
			return P
	return null

/datum/dice_war_game/proc/try_join(mob/living/joiner)
	if(!joiner || !joiner.client)
		return
	if(!joining)
		to_chat(joiner, span_warning("骰子战争已经开始了。"))
		return

	if(joiner in players)
		var/list/opts = list("离开游戏")
		if(players.len >= 2)
			opts += "立即开始"
		var/choice = input(joiner, "你已经在大厅中了。([players.len]/[max_players] 名玩家)", "骰子战争") as null|anything in opts
		if(choice == "立即开始")
			start_game()
		else if(choice == "离开游戏")
			players -= joiner
			hp -= joiner
			game_bag.visible_message(span_notice("[joiner]离开了赛前大厅。([players.len]/[max_players])"))
			if(!players.len)
				cancel_game(joiner)
		return

	if(players.len >= max_players)
		to_chat(joiner, span_warning("骰子战争人数已满（[max_players]/[max_players]）。"))
		return

	players += joiner
	hp[joiner] = 50
	game_bag.visible_message(span_notice("[joiner]加入了骰子战争！([players.len]/[max_players] 名玩家)"))
	if(players.len >= max_players)
		start_game()

/datum/dice_war_game/proc/leave_game(mob/living/leaver)
	if(!(leaver in players))
		to_chat(leaver, span_warning("你不在这局骰子战争中。"))
		return

	players -= leaver
	hp -= leaver

	game_bag.visible_message(span_notice("[leaver]离开了骰子战争。"))

	if(!players.len)
		cancel_game(leaver)
		return

	if(joining)
		if(players.len < 2)
			cancel_game(leaver)
		return

	var/mob/living/winner = players[1]
	end_game_with_winner(winner, "弃权")

/datum/dice_war_game/proc/cancel_game(mob/living/canceller)
	game_bag.visible_message(span_warning("[canceller]取消了骰子战争！"))
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

	game_bag.visible_message(span_notice("骰子战争开始！[players[1]] 对阵 [players[2]]，双方各有 50 点生命。"))
	next_turn()

/datum/dice_war_game/proc/next_turn()
	if(players.len < 2)
		if(players.len == 1)
			end_game_with_winner(players[1], "坚持到最后")
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
	game_bag.visible_message(span_notice("--- [active]的回合 | [get_hp_display()] ---"))
	to_chat(active, span_notice("从骰袋菜单中选择“掷骰”。"))

/datum/dice_war_game/proc/player_action(mob/living/user, action)
	if(!(user in players))
		to_chat(user, span_notice("当前生命：[get_hp_display()]"))
		return
	if(busy)
		to_chat(user, span_notice("请稍等片刻……"))
		return
	if(user != current_player)
		input(user, "还没轮到你。生命：[get_hp_display()]", "骰子战争") as null|anything in list("确定")
		return
	if(!can_initiate_turn_roll)
		to_chat(user, span_notice("这回合你已经掷过骰了。"))
		return
	if(action != "掷骰")
		to_chat(user, span_notice("请从菜单中选择“掷骰”。"))
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
	game_bag.visible_message(span_notice("[active]掷出了一个20面骰：[format_player_roll_value(active, roll)]！"))

	if(roll == 1)
		var/old_hp = hp[active]
		hp[active] = old_hp + 10
		game_bag.visible_message(span_notice("回光返照！[active]恢复了 10 点生命（[old_hp] -> [hp[active]]）。"))

	if(roll == 20)
		var/mob/living/target = get_opponent(active)
		if(target)
			var/crit = rand(1, 20)
			var/crit_color = "#EF5350"
			hp[target] -= crit
			game_bag.visible_message(span_danger("暴击！[active]掷出[format_big_die_value(crit, crit_color)]点直接伤害，命中[target]！"))
			if(hp[target] <= 0)
				busy = FALSE
				end_game_with_winner(active, "暴击")
				return

	if(got_natural_twenty)
		busy = FALSE
		can_initiate_turn_roll = TRUE
		game_bag.visible_message(span_notice("天生 20 奖励回合！[active]可在对手行动前再掷一次。"))
		to_chat(active, span_notice("奖励行动：再次选择“掷骰”。"))
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
		game_bag.visible_message(span_notice("交锋平手：[format_player_roll_value(p1, roll1)] 对 [format_player_roll_value(p2, roll2)]！未造成基础伤害。"))
		return

	var/base_damage = high_roll - low_roll
	var/damage = base_damage

	var/high_even = (high_roll % 2 == 0)
	var/low_even = (low_roll % 2 == 0)

	if(high_even == low_even)
		// Even/Even or Odd/Odd: full damage
		damage = base_damage
		game_bag.visible_message(span_notice("同步交锋（[format_player_roll_value(high_mob, high_roll)] 对 [format_player_roll_value(low_mob, low_roll)]）！[high_mob]对[low_mob]造成了[damage]点伤害。"))
	else if(!high_even && low_even)
		// High odd vs low even: halved damage
		damage = (base_damage - (base_damage % 2)) / 2
		game_bag.visible_message(span_notice("以弱胜强（[format_player_roll_value(high_mob, high_roll)]为奇数，对上[format_player_roll_value(low_mob, low_roll)]为偶数）！伤害减半至[damage]。"))
	else
		// High even vs low odd: full damage
		damage = base_damage
		game_bag.visible_message(span_notice("强力一击（[format_player_roll_value(high_mob, high_roll)]为偶数，对上[format_player_roll_value(low_mob, low_roll)]为奇数）！[high_mob]造成了[damage]点伤害。"))

	if(damage > 0)
		hp[low_mob] -= damage
	else
		game_bag.visible_message(span_notice("没有伤害穿透。"))

	damage = max(damage, 0)
	game_bag.visible_message(span_notice("[low_mob] [format_hp_value(hp[low_mob])] | [high_mob] [format_hp_value(hp[high_mob])]"))

/datum/dice_war_game/proc/check_end()
	for(var/mob/living/P in players)
		if(hp[P] <= 0)
			var/mob/living/winner = get_opponent(P)
			if(!winner)
				winner = P
			end_game_with_winner(winner, "战斗")
			return TRUE
	return FALSE

/datum/dice_war_game/proc/end_game_with_winner(mob/living/winner, reason)
	if(winner)
		game_bag.visible_message(span_green("<b>--- 骰子战争结束 --- [winner]因[reason]获胜！</b>"))
	else
		game_bag.visible_message(span_notice("--- 骰子战争结束 ---"))
	game_bag.active_game = null
	qdel(src)

/datum/dice_war_game/proc/get_hp_display()
	var/list/parts = list()
	for(var/mob/living/P in players)
		parts += "[P] [format_hp_value(hp[P])]"
	return jointext(parts, " | ")

/obj/item/storage/pill_bottle/dice/dice_war
	name = "骰子战争骰袋"
	desc = "一个用来玩骰子战争的骰袋。手持激活（Z）即可开始或加入游戏。"
	var/datum/dice_war_game/active_game
	var/static/dice_war_rules_text = {"<div style='padding:8px;font-family:Verdana,sans-serif;'>
	<h2 style='text-align:center;margin:0 0 6px 0;'>骰子战争</h2>
<br>
<b>目标：</b>将对手的生命降到 0。<br>
<br>
<b>规则：</b><br>
- 双方都以 50 点生命开始。<br>
- 双方轮流掷 1 枚20面骰。<br>
- 基础伤害 = 高点数与低点数的差值。例如：若玩家 1 掷出 15，玩家 2 掷出 10，则基础伤害为 5。<br>
- 同奇同偶：对低点数者造成全部伤害。例如：若一方掷出 12，另一方掷出 8，则造成 4 点完整伤害。<br>
- 高点为奇、低点为偶：伤害减半。例如：若一方掷出 15（奇数），对手掷出 8（偶数），则伤害减半为 3，向下取整。<br>
- 高点为偶、低点为奇：强力一击，造成全部伤害。例如：若一方掷出 16（偶数），对手掷出 7（奇数），则造成 9 点完整伤害。<br>
- 天生 1：恢复 10 点生命。<br>
- 天生 20：额外再掷一个20面骰造成直接伤害（无视减半规则）。
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

	var/choice = input(user, "选择一个选项。", "骰子战争") as null|anything in menu
	if(!choice)
		return

	if(choice == "规则")
		show_rules(user)
		return

	if(choice == "结束游戏")
		if(active_game)
			active_game.cancel_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的骰子战争。"))
		return

	if(choice == "离开游戏")
		if(active_game)
			active_game.leave_game(user)
		else
			to_chat(user, span_notice("当前没有正在进行的骰子战争。"))
		return

	if(choice == "掷骰")
		if(!active_game)
			to_chat(user, span_notice("当前没有正在进行的骰子战争。"))
			return
		if(!(user == active_game.current_player && active_game.can_initiate_turn_roll && !active_game.joining))
			to_chat(user, span_notice("你现在不能掷骰。"))
			return
		active_game.player_action(user, "掷骰")
		return

	if(choice != "开始游戏")
		return

	if(!active_game)
		var/datum/dice_war_game/new_game = new()
		new_game.game_bag = src
		new_game.max_players = 2
		active_game = new_game
		new_game.try_join(user)
		src.visible_message(span_notice("[user]正在发起一局骰子战争！还差 1 名玩家。手持激活（Z）骰袋即可加入！"))
		return

	if(active_game.joining)
		active_game.try_join(user)
	else
		active_game.player_action(user, null)
