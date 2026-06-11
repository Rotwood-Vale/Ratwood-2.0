/obj/structure/roguemachine/atm
	name = "神经锁"
	desc = "为谷地大公管理的账户存取货币。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/mammonsiphoned = 0
	var/drilling = FALSE
	var/drilled = FALSE
	var/has_reported = FALSE
	var/location_tag

/obj/structure/roguemachine/atm/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		to_chat(H, span_warning("这台机器拒绝了你，它感应到你在这片土地上是法外之徒。"))
		return
//Remove the comment on the below block to re-enable outsiders and such not having access.
//Mind that this makes it impossible for adventurers and the like to engage with quests.
/*
	if(HAS_TRAIT(user, TRAIT_OUTLANDER) && !HAS_TRAIT(user, TRAIT_NOBLE) && !HAS_TRAIT(user, TRAIT_INQUISITION))
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		loc.visible_message(span_warning("The nervelock turns its nose up at [user]'s hand."))
		to_chat(user, span_danger("这台机器鄙夷你卑微的异乡血脉。"))
		return
*/
	if(drilled)
		if(HAS_TRAIT(H, TRAIT_NOBLE))
			if(!HAS_TRAIT(H, TRAIT_COMMIE))
				var/def_zone = "[(H.active_hand_index == 2) ? "r" : "l" ]_arm"
				playsound(src, 'sound/items/beartrap.ogg', 100, TRUE)
				to_chat(user, "<font color='red'>神经锁渴望我的贵族之血！</font>")
				loc.visible_message(span_warning("神经锁锁住了[H]的手臂！"))
				H.Stun(80)
				H.apply_damage(50, BRUTE, def_zone)
				H.emote("agony")
				spawn(5)
				say("为自由民献上蓝血！")
				playsound(src, 'sound/vo/mobs/ghost/laugh (5).ogg', 100, TRUE)
				return
	if(H in SStreasury.bank_accounts)
		var/amt = SStreasury.bank_accounts[H]
		if(!amt)
			say("您的余额为零。")
			return
		if(amt < 0)
			say("您的余额为负。")
			return
		var/list/choicez = list()
		if(amt > 10)
			choicez += "金币"
		if(amt > 5)
			choicez += "银币"
		choicez += "铜币"
		var/selection = input(user, "你的账户中有 [amt] 玛门。选择你想提取的货币。", src) as null|anything in choicez
		if(!selection)
			return
		amt = SStreasury.bank_accounts[H]
		var/mod = 1
		if(selection == "金币")
			mod = 10
		if(selection == "银币")
			mod = 5
		var/coin_amt = input(user, "国库中有 [SStreasury.treasury_value] 玛门，你的账户中有 [amt] 玛门。你可以提取 [floor(amt/mod)] 枚 [selection]币。", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		// checks the maximum coin limit before deducting balance; prevents stacks of >=20
		var/max_coins = 20
		if(coin_amt > max_coins)
			to_chat(user, span_warning("超过最大提款限额。你一次最多只能提取 [max_coins] 枚硬币。"))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		amt = SStreasury.bank_accounts[H]
		if(!Adjacent(user))
			return
		if((coin_amt*mod) > amt)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SStreasury.withdraw_money_account(coin_amt*mod, H))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		record_round_statistic(STATS_MAMMONS_WITHDRAWN, coin_amt * mod)
		budget2change(coin_amt*mod, user, selection)
	else
		to_chat(user, span_warning("这台机器咬了我的手指。"))
		if(!drilled)
			icon_state = "atm-b"
		H.flash_fullscreen("redflash3")
		playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		SStreasury.create_bank_account(H)
		if(H.mind)
			var/datum/job/target_job = SSjob.GetJob(H.mind.assigned_role)
			if(target_job && target_job.noble_income)
				SStreasury.noble_incomes[H] = target_job.noble_income
		spawn(5)
			say("新账户已创建。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

/*
/obj/structure/roguemachine/atm/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
*/

/obj/structure/roguemachine/atm/attackby(obj/item/P, mob/user, params)
	if(ishuman(user))
		if(istype(P, /obj/item/roguecoin/gilbranze))
			return

		if(istype(P, /obj/item/roguecoin/inqcoin))
			return

		if(istype(P, /obj/item/roguecoin))
			var/mob/living/carbon/human/H = user
			if(H in SStreasury.bank_accounts)
				var/list/deposit_results = SStreasury.generate_money_account(P.get_real_price(), H)
				if(islist(deposit_results))
					record_round_statistic(STATS_MAMMONS_DEPOSITED, deposit_results[1] - deposit_results[2])
				if(deposit_results[2] != 0)
					say("您的存款被征税 [deposit_results[2]] 玛门。")
					record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, deposit_results[2])
					record_round_statistic(STATS_TAXES_COLLECTED, deposit_results[2])
				qdel(P)
				playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
				return

		if(istype(P, /obj/item/coveter))
			var/mob/living/carbon/human/H = user
			if(!HAS_TRAIT(H, TRAIT_COMMIE))
				to_chat(user, "<font color='red'>我不知道该拿这东西怎么办！</font>")
				return
			var/can_anyone_know = FALSE
			for(var/mob/living/carbon/human/HJ in GLOB.player_list)
				if(HJ.job == "Steward" || HJ.job == "Grand Duke")
					can_anyone_know = TRUE
			if(!can_anyone_know)
				to_chat(user, span_info("没有重要人物来处理这笔交易。"))
				return
			if(SStreasury.treasury_value <50)
				to_chat(user, "<font color='red'>这些傻瓜彻底破产了。我们从中捞不到任何好处...</font>")
				return
			if(mammonsiphoned >499)
				to_chat(user, "<font color='red'>这台机器已经被榨干了...</font>")
				return
			else
				user.visible_message(span_warning("[user]正在把王冠装到神经锁上！"))
				if(do_after(user, 50))
					if(!drilling)
						user.visible_message(span_warning("[user]把王冠装在了神经锁顶上！"))
						icon_state = "atm_crown"
						has_reported = FALSE
						drilling = TRUE
						drill(src)
						qdel(P)
						message_admins("[usr.key] has applied the Crustacean to a Nervelock.")
						return
		else
			say("未找到账户。请放入手指进行检查。")
	return ..()

/obj/structure/roguemachine/atm/examine(mob/user)
	. += ..()
	var/tax_rate = SStreasury.get_tax_value_for(user) * 100 // proc returns a decimal, multiply by 100 for percentage
	var/job_text // what tax bracket the user falls into, for examine text purpose
	var/fine_exempt_status = SStreasury.check_fine_exemption(user) ? "免于罚款。" : "不免于罚款。" // returns TRUE/FALSE

	if(HAS_TRAIT(user, TRAIT_OUTLANDER))
		job_text = "Outlanders"
	else if(HAS_TRAIT(user, TRAIT_NOBLE))
		job_text = "Nobles"
	else if(HAS_TRAIT(user, TRAIT_RESIDENT) || (user.job in GLOB.yeoman_positions))
		job_text = "Yeomen"
	else if(user.job in GLOB.church_positions)
		job_text = "Clergymen"
	else
		job_text = "Peasants"

	. += span_info("For [job_text], the current tax rate on deposits is [tax_rate] percent. [fine_exempt_status]")

/obj/structure/roguemachine/atm/proc/drill(obj/structure/roguemachine/atm)
	if(!drilling)
		return
	if(SStreasury.treasury_value <50)
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("随着国库的最后一点钱从神经锁中涌出，王冠嘎然而止！"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "atm"
		drilling = FALSE
		has_reported = FALSE
		return
	if(mammonsiphoned >199) // The cap variable for siphoning.
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("达到最大提款限额！神经锁在哭泣。"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "atm_broken"
		drilled = TRUE
		drilling = FALSE
		has_reported = FALSE
		return
	else
		loc.visible_message(span_warning("当王冠工作时，发出可怕的刮擦声..."))
		if(!has_reported)
			send_ooc_note("A parasite of the Freefolk is draining a Nervelock! Location: [location_tag ? location_tag : "Unknown"]", job = list("Grand Duke", "Steward", "Clerk"))
			has_reported = TRUE
		playsound(src, 'sound/misc/TheDrill.ogg', 70, TRUE)
		spawn(100) // The time it takes to complete an interval. If you adjust this, please adjust the sound too. It's 'about' perfect at 100. Anything less It'll start overlapping.
			loc.visible_message(span_warning("神经锁倾泻出它的赏金！"))
			SStreasury.treasury_value -= 20 // Takes from the treasury
			mammonsiphoned += 20
			budget2change(20, null, "银")
			playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
			SStreasury.log_to_steward("-[20] exported mammon to the Freefolks!")
			drill(src)

/obj/structure/roguemachine/atm/attack_right(mob/living/carbon/human/user)
	if(drilling)
		to_chat(user,"<font color='yellow'>我开始从神经锁上卸下王冠...</font>" )
		if(do_after(user, 30, src))
			if(!drilling)
				return
			new /obj/item/coveter(loc)
			user.visible_message(span_warning("[user]卸下了王冠！"))
			icon_state = "atm"
			drilling = !drilling
	else
		return

/obj/item/coveter
	name = "贪婪之冠"
	desc = "一顶渴求 miester 眉心与金库颚钳的王冠；紧要关头，也能被安在受制者头上，榨干其 miester 账户。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "crown_object"
	force = 10
	throwforce = 10
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = CAN_BE_HIT
	var/is_active
	var/needed_cycles
	var/slow_drain = 10
	var/slow_delay = 10
	var/fast_drain = 50
	var/static/list/fast_effects =	list("agony","crunch","whimper","cry","silence")
	var/static/list/slow_effects =	list("whimper","cry","silence")
	sellprice = 100

/obj/item/coveter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)	//Not adjacent
		return
	if(!ishuman(target)) //We're not robbing goats with this
		return
	if(is_active)		//We're already draining
		to_chat(user,span_info("它已经开始抽取了！"))
		return
	var/mob/living/carbon/human/H = target
	if(!H.client)	//The target's DCed or bugged out or is an NPC
		return
	if(H.stat)	//They're dead
		to_chat(user,span_info("对方的血已经停了。你得找个活人来用这个。"))
		return
	if(!H.restrained())
		to_chat(user,span_info("对方必须先被控制住。"))
		return
	if(H.head)
		to_chat(user,span_info("对方的头被遮住了。"))
		return
	if(H in SStreasury.bank_accounts)
		if(SStreasury.bank_accounts[H] > 0)
			var/turf/T = get_turf(H)
			var/sum
			var/choice = alert(user,"你想怎么取走它？迅猛张扬，还是缓慢安静？","选择","迅猛","缓慢","算了")
			switch(choice)
				if("迅猛")
					is_active = TRUE
					needed_cycles = round(SStreasury.bank_accounts[H] / fast_drain)
					if(needed_cycles == 0)	//If you have less than 50 mammon, you'll still get drained at least once.
						needed_cycles = 1
					user.visible_message(span_warn("[user]猛地将[src]刺进了[H]的前额！"))
					playsound(H, 'sound/combat/hits/pick/genpick (1).ogg', 100)
					playsound(src, 'sound/misc/TheDrill.ogg', 70, TRUE)
					to_chat(H,span_info("<font color ='red'>锋利的爪钩刺进了你的头骨。有股温热的液体正顺着你的头往下淌。</font>"))
					for(var/i = 1,i<=needed_cycles,i++)
						if(do_after(user, 25))
							SStreasury.bank_accounts[H] -= fast_drain
							sum += fast_drain
							new /obj/item/roguecoin/gold(T, fast_drain / 10)
							SStreasury.log_to_steward("-[fast_drain] exported mammon to the Freefolks!")
							if(prob(needed_cycles*2))
								drain_effect_fast(H)
							if(i == needed_cycles)	//Last cycle.
								playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
								is_active = FALSE
								to_chat(H,span_info("<font color ='red'>你感到自己被抽空了。</font>"))
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
						else
							is_active = FALSE
							if(sum)
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
							break
				if("缓慢")
					is_active = TRUE
					needed_cycles = round(SStreasury.bank_accounts[H] / slow_drain)
					if(needed_cycles == 0)	//If you have less than 10 mammon, you'll still get drained at least once.
						needed_cycles = 1
					user.visible_message(span_warn("[user]小心而有条不紊地将[src]对准了[H]的额头……"))
					to_chat(H,span_info("细小的爪钩扎进了你的头里。有股温热的液体正顺着你的脸颊流下。"))
					playsound(H, 'sound/gore/flesh_eat_01.ogg', 100)
					var/obj/item/bodypart/head = H.get_bodypart(BODY_ZONE_HEAD)
					head.add_wound(/datum/wound/slash)
					head.update_disabled()
					H.apply_damage(10, BRUTE, head)
					for(var/i = 1,i<=needed_cycles,i++)
						if(do_after(user, 10))
							SStreasury.bank_accounts[H] -= slow_drain
							sum += slow_drain
							new /obj/item/roguecoin/gold(T, slow_drain / 10)
							SStreasury.log_to_steward("-[slow_drain] exported mammon to the Freefolks!")
							if(prob(needed_cycles*2))
								drain_effect_fast(H)
							if(i == needed_cycles)	//Last cycle.
								is_active = FALSE
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
						else
							is_active = FALSE
							if(sum)
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
							break
				if("算了")
					return
				else
					return
		else
			to_chat(user,span_info("对方已经没什么可让我们拿走的了。"))
			return

	else
		to_chat(user,span_info("对方的血未受公国神经主宰污染。没有什么可拿的。"))
		return

/obj/item/coveter/proc/drain_effect_fast(mob/living/carbon/human/H)
	var/consequence = pick(fast_effects)
	var/obj/item/bodypart/head = H.get_bodypart(BODY_ZONE_HEAD)
	switch(consequence)
		if("crunch")
			playsound(src.loc, 'sound/items/beartrap.ogg', 300, TRUE, -1)
			visible_message(span_info("<font color ='red'>它在抽取时直接刺穿了骨头！</font>"))
			head.add_wound(/datum/wound/fracture)
			head.update_disabled()
			H.apply_damage(50, BRUTE, head)
			H.emote("agony")
		if("agony")
			H.apply_damage(10, BRUTE, head)
			H.emote("agony")
		if("whimper")
			H.apply_damage(10, BRUTE, head)
			H.emote("whimper")
		if("cry")
			H.apply_damage(10, BRUTE, head)
			H.emote("cry")
		if("silence")
			return
		else
			return

/obj/item/coveter/proc/drain_effect_slow(mob/living/carbon/human/H)
	var/consequence = pick(slow_effects)
	switch(consequence)
		if("whimper")
			H.emote("whimper")
		if("cry")
			H.emote("cry")
		if("silence")
			return
		else
			return
