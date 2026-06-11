#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_STOCK 3
#define TAB_IMPORT 4
#define TAB_BOUNTIES 5
#define TAB_LOG 6
#define TAB_STATISTICS 7
#define TAB_PAYDAY 8
#define TAB_SALTMINE 9

/obj/structure/roguemachine/steward
	name = "总务中枢"
	desc = "总管最可靠的伙伴。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	locked = FALSE
	var/keycontrol = "steward"
	var/current_tab = TAB_MAIN
	var/compact = TRUE
	var/total_deposit = 0
	var/list/excluded_jobs = list("Wretch","Vagabond","Adventurer")
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Foodstuffs", "Fruits", "Seafood")
	var/list/daily_payments = list() // Associative list: job name -> payment amount

/obj/structure/roguemachine/steward/Initialize(mapload)
	. = ..()
	if(SStreasury.steward_machine == null) //The "only one" mapped in Nerve Master at map start
		SStreasury.steward_machine = src
	setup_default_payments()

//	For competence of life I will allow you,
//	That lack of means enforce you not to evil:
/obj/structure/roguemachine/steward/proc/setup_default_payments()
	daily_payments["Knight Captain"] = 40
	if(SSmapping.current_map.map_name == "Dun World")
		daily_payments["Sergeant"] = 40 //Garrison
	if(SSmapping.current_map.map_name == "Desert Town")
		daily_payments["Slave Master"] = 50
		daily_payments["Cataphract"] = 40
		daily_payments["Janissary Sergeant"] = 40 //Garrison
		daily_payments["Janissary"] = 30
		daily_payments["Azeb Agha"] = 40
		daily_payments["Azeb"] = 20
	else
		daily_payments["Knight"] = 40
		daily_payments["Man at Arms"] = 30
		daily_payments["Warden"] = 25
		daily_payments["Dungeoneer"] = 30
	if(SSmapping.current_map.map_name == "Rockhill")
		daily_payments["Watch Captain"] = 45 //Don't get to live in a fancy keep with servants. More expenses.
		daily_payments["Master Warden"] = 35 //Garrison
		daily_payments["City Guard"] = 30
		daily_payments["Vanguard"] = 20
	daily_payments["Rookie"] = 20//paid more than squires because they don't get to live in a castle with maids cooking them dinner
	daily_payments["Veteran"] = 30
	daily_payments["Squire"] = 10
//courtiers
	daily_payments["Head Physician"] = 30 //Doctors
	daily_payments["Apothecary"] = 20 //paid by the keep to heal people, would make sense.
	daily_payments["Court Magician"] = 50 //University
	if(SSmapping.current_map.map_name == "Desert Town")
		daily_payments["Palace Chaplain"] = 30
		daily_payments["Headslave"] = 20 //Manor-House
	else
		daily_payments["Court Chaplain"] = 30
		daily_payments["Seneschal"] = 40 //Manor-House
		daily_payments["Servant"] = 20
	daily_payments["Archivist"] = 10
	daily_payments["Magicians Associate"] = 10
	daily_payments["Jester"] = 6

	if(SSmapping.current_map.map_name == "Roguetest")
		daily_payments["Shophand"] = 999

/obj/structure/roguemachine/steward/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord)) //Master key
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
			update_icon()
			return
		else
			to_chat(user, span_warning("钥匙不对。"))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		if(!K.contents.len)
			return
		var/list/keysy = K.contents.Copy()
		for(var/obj/item/roguekey/KE in keysy)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
				update_icon()
				return
		to_chat(user, span_warning("钥匙不对。"))
		return
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, P.get_real_price())
		SStreasury.give_money_treasury(P.get_real_price(), "NERVE MASTER deposit")
		qdel(P)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()


/obj/structure/roguemachine/steward/Topic(href, href_list)
	. = ..()
	var/realmname = SSmapping.map_adjustment.realm_name
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["switchtab"])
		current_tab = text2num(href_list["switchtab"])
	if(href_list["import"])
		var/datum/roguestock/D = locate(href_list["import"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(SStreasury.treasury_value < D.get_import_price())
			say("玛门不足。")
			return
		var/amt = D.get_import_price()
		SStreasury.treasury_value -= amt
		SStreasury.total_import += amt
		SStreasury.log_to_steward("-[amt] imported [D.name]")
		record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, amt)
		if(amt >= 100) //Only announce big spending.
			scom_announce("[realmname] 以 [amt] 枚 Mammon 的价格进口了 [D.name]。", )
		D.raise_demand()
		addtimer(CALLBACK(src, PROC_REF(do_import), D.type), 10 SECONDS)
	if(href_list["export"])
		var/datum/roguestock/D = locate(href_list["export"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!SStreasury.do_export(D))
			say("库存不足。")
			return
	if(href_list["togglewithdraw"])
		var/datum/roguestock/D = locate(href_list["togglewithdraw"]) in SStreasury.stockpile_datums
		if(!D)
			return
		D.withdraw_disabled = !D.withdraw_disabled
	if(href_list["setbounty"])
		var/datum/roguestock/D = locate(href_list["setbounty"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "为 [D.name] 设置新的价格", src, D.payout_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 0, 999)
				if(newtax > D.payout_price)
					scom_announce("[D.name] 的赏金已提高。")
				D.payout_price = newtax
		else
			var/newtax = input(usr, "为 [D.name] 设置新的百分比", src, D.payout_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 1, 99)
				if(newtax > D.payout_price)
					scom_announce("[D.name] 的赏金已提高。")
				D.payout_price = newtax
	if(href_list["setprice"])
		var/datum/roguestock/D = locate(href_list["setprice"]) in SStreasury.stockpile_datums
		if(!D)
			return
		if(!D.percent_bounty)
			var/newtax = input(usr, "为提取 [D.name] 设置新的价格", src, D.withdraw_price) as null|num
			if(newtax)
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				newtax = CLAMP(newtax, 0, 999)
				if(newtax < D.withdraw_price)
					scom_announce("[D.name] 的提取价格已降低。")
				D.withdraw_price = newtax
	if(href_list["setrate"])
		var/datum/roguestock/D = locate(href_list["setrate"]) in SStreasury.stockpile_datums
		if(!D)
			return              //Cheaper prices, no taxes, the price? Commitment. You can only change the rates at day. I'd like to make the window shorter,
		if(GLOB.tod == "night") //less chance to micromanage, incentivize doing other things at later hours, make it unable to be changed at dusk too, but this needs testing first
			say("只有在 阿斯特拉塔 照耀之时，供应商才愿意修改交易。")
			return
		var/newrate = input(usr, "为 [D.name] 设置新的远程进口速率", src, D.passive_generation) as null|num
		if(!isnull(newrate))
			if(!usr.canUseTopic(src, BE_CLOSE) || locked)
				return
			if(findtext(num2text(newrate), "."))
				return
			newrate = CLAMP(newrate, 0, D.generation_max)
			scom_announce("[realmname] 将[newrate ? "每 5 小时进口 [newrate] 个 [D.name]。" : "不再定期进口 [D.name]。"]")
			D.passive_generation = newrate
	if(href_list["setlimit"])
		var/datum/roguestock/D = locate(href_list["setlimit"]) in SStreasury.stockpile_datums
		if(!D)
			return
		var/newlimit = input(usr, "为 [D.name] 设置新的上限", src, D.stockpile_limit) as null|num
		if(newlimit)
			if(!usr.canUseTopic(src, BE_CLOSE) || locked)
				return
			if(findtext(num2text(newlimit), "."))
				return
			newlimit = CLAMP(newlimit, 0, 999)
			scom_announce("[D.name] 的仓储上限已改为 [newlimit]。")
			D.stockpile_limit = newlimit
	if(href_list["givemoney"])
		var/X = locate(href_list["givemoney"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/newtax = input(usr, "要给 [X] 多少？", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(newtax, A, "NERVE MASTER")
				break
	if(href_list["fineaccount"])
		var/X = locate(href_list["fineaccount"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				if(SStreasury.check_fine_exemption(A))
					say("奉领主之恩，此人不可罚款！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/newtax = input(usr, "要罚 [X] 多少？", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(-newtax, A, "NERVE MASTER")
				break
	if(href_list["payroll"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "选择一个职业", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/amount_to_pay = input(usr, "每位 [job_to_pay] 发多少？", src) as null|num
		if(!amount_to_pay)
			return
		if(amount_to_pay<1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_to_pay)
				record_round_statistic(STATS_WAGES_PAID)
				SStreasury.give_money_account(amount_to_pay, H, "NERVE MASTER")
	if(href_list["setdailypay"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "选择一个职业", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/amount_to_pay = input(usr, "设置 [job_to_pay] 的每日薪资（0 为移除）", src, daily_payments[job_to_pay] ? daily_payments[job_to_pay] : 0) as null|num
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		if(isnull(amount_to_pay))
			return
		amount_to_pay = CLAMP(amount_to_pay, 0, 999)
		if(amount_to_pay == 0)
			daily_payments -= job_to_pay
			say("[job_to_pay] 的每日薪资已移除。")
		else
			daily_payments[job_to_pay] = amount_to_pay
			say("[job_to_pay] 的每日薪资已设为 [amount_to_pay]m。")
	if(href_list["removedailypay"])
		var/job_to_remove = href_list["removedailypay"]
		daily_payments -= job_to_remove
		say("[job_to_remove] 的每日薪资已移除。")
	if(href_list["togglewages"])
		var/X = locate(href_list["togglewages"])
		if(!X)
			return
		for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
			if(A == X)
				// Check if user has permission (Steward, Clerk, Grand Duke, or Regent)
				var/is_authorized = FALSE
				if(usr.job == "Steward" || usr.job == "Clerk" || usr.job == "Grand Duke")
					is_authorized = TRUE
				if(SSticker.regentmob && usr == SSticker.regentmob)
					is_authorized = TRUE

				if(!is_authorized)
					say("只有 Steward、Clerk 或 Ruler 可以停发工资。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return

				if(HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED))
					REMOVE_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name] 的工资已恢复。")
					to_chat(A, span_notice("总务处已恢复我的工资。"))
				else
					ADD_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name] 的工资已被停发。")
					to_chat(A, span_danger("总务处已停发我的工资！"))
				break
	if(href_list["compact"])
		compact = !compact
	if(href_list["changecat"])
		current_category = href_list["changecat"]
	if(href_list["changeautoexport"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/new_autoexport = input(usr, "设置新的自动出口百分比（0 到 100）", src, SStreasury.autoexport_percentage * 100) as null|num
		if(!new_autoexport && new_autoexport != 0)
			return
		if(findtext(num2text(new_autoexport), "."))
			return
		if(new_autoexport < 0 || new_autoexport > 100)
			to_chat(usr, span_warning("自动出口百分比无效，必须在 0 到 100 之间。"))
			return
		new_autoexport = round(new_autoexport)
		SStreasury.autoexport_percentage = new_autoexport * 0.01

	return attack_hand(usr)

/obj/structure/roguemachine/steward/proc/do_import(datum/roguestock/D,number)
	if(!D)
		return
	D = new D
	if(number > D.importexport_amt)
		return
	testing("number1 is [number]")
	if(!number)
		number = 1
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!A)
		return
	var/obj/item/I = new D.item_type()
	var/list/turfs = list()
	for(var/turf/T in A)
		turfs += T
	var/turf/T = pick(turfs)
	I.forceMove(T)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	number += 1
	testing("number2 is [number]")
	addtimer(CALLBACK(src, PROC_REF(do_import), D.type, number), 3 SECONDS)

/obj/structure/roguemachine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked)
		to_chat(user, span_warning("它被锁住了。果然。"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	switch(current_tab)
		if(TAB_MAIN)
			contents += "<center>总务中枢<BR>"
			contents += "--------------<BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BANK]'>\[银行\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_STOCK]'>\[仓储\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_IMPORT]'>\[进口\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BOUNTIES]'>\[赏金\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_PAYDAY]'>\[每日薪资\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_LOG]'>\[日志\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_STATISTICS]'>\[统计\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_SALTMINE]'>\[盐矿报告\]</a><BR>"
			contents += "</center>"
		if(TAB_BANK)
			var/total_deposit = 0
			for(var/bank_account in SStreasury.bank_accounts)
				total_deposit += SStreasury.bank_accounts[bank_account]
			if(total_deposit == 0)
				total_deposit++ //Division by zero catch
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[紧凑：[compact? "启用" : "关闭"]\]</a><BR>"
			contents += "<center>银行<BR>"
			contents += "--------------<BR>"
			contents += "国库：[SStreasury.treasury_value]m<BR>"
			contents += "准备金率：[round(SStreasury.treasury_value / total_deposit * 100)]%</center><BR>"
			contents += "<a href='?src=\ref[src];payroll=1'>\[按职业发放\]</a><BR><BR>"
			if(compact)
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [SStreasury.bank_accounts[A]]m"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m"
					var/wage_status = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "恢复" : "停发"
					contents += " / <a href='?src=\ref[src];givemoney=\ref[A]'>\[发放\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[罚款\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status]\]</a><BR><BR>"
			else
				for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [SStreasury.bank_accounts[A]]m<BR>"
					else
						contents += "[A.real_name] - [SStreasury.bank_accounts[A]]m<BR>"
					var/wage_status = HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED) ? "恢复工资" : "停发工资"
					contents += "<a href='?src=\ref[src];givemoney=\ref[A]'>\[发放资金\]</a> <a href='?src=\ref[src];fineaccount=\ref[A]'>\[账户罚款\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status]\]</a><BR><BR>"
		if(TAB_STOCK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[紧凑：[compact? "启用" : "关闭"]\]</a><BR>"
			contents += "<center>仓储<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "国库：[SStreasury.treasury_value]m"
				contents += " / 领主税：[SStreasury.tax_value*100]%"
				contents += " / 行会税：[SStreasury.queens_tax*100]%</center><BR>"
				contents += "<center>超出此值自动出口仓储："
				contents += "<a href='?src=\ref[src];changeautoexport=1'>[SStreasury.autoexport_percentage * 100]%</a></center><BR>"
				contents += "<center>当前被动支出：[SStreasury.get_current_passive_spending()]m </center><BR>"
				var/selection = "<center>分类："
				for(var/category in categories)
					if(category == current_category)
						selection += "<b>[current_category]</b> "
					else
						selection += "<a href='?src=[REF(src)];changecat=[category]'>[category]</a> "
				contents += selection + "<BR>"
				contents += "--------------</center><BR>"
				for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
					if(A.category != current_category)
						continue
					contents += "<b>[A.name]:</b>"
					contents += " [A.held_items[1]] | [A.held_items[2]]"
					contents += " || 收购：<a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]m</a>"
					contents += " / 提取：<a href='?src=\ref[src];setprice=\ref[A]'>[A.withdraw_price]m</a>"
					contents += " / 上限：<a href='?src=\ref[src];setlimit=\ref[A]'>[A.stockpile_limit]</a>"
					if(!A.no_passive)
						contents += " / 被动导入：<a href='?src=\ref[src];setrate=\ref[A]'>[A.passive_generation] ([A.generation_price]m)</a>"
					if(!A.export_only)
						if(A.importexport_amt)
							contents += " <a href='?src=\ref[src];import=\ref[A]'>\[进口 [A.importexport_amt] ([A.get_import_price()])\]</a> <a href='?src=\ref[src];export=\ref[A]'>\[出口 [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					else
						if(A.importexport_amt)
							contents += " <a href='?src=\ref[src];export=\ref[A]'>\[出口 [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"

			else
				contents += "国库：[SStreasury.treasury_value]m<BR>"
				contents += "领主税：[SStreasury.tax_value*100]%<BR>"
				contents += "行会税：[SStreasury.queens_tax*100]%<BR>"
				contents += "当前被动支出：[SStreasury.get_current_passive_spending()]m</center><BR>"
				var/selection = "<center>分类："
				for(var/category in categories)
					if(category == current_category)
						selection += "<b>[current_category]</b> "
					else
						selection += "<a href='?src=[REF(src)];changecat=[category]'>[category]</a> "
				contents += selection + "<BR>"
				contents += "--------------<BR>"
				contents += "当前分类被动支出：[SStreasury.get_current_passive_spending(current_category)]m</center><BR>"
				for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
					if(A.category != current_category)
						continue
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					contents += "本地库存：[A.held_items[1]]<BR>"
					contents += "远程库存：[A.held_items[2]]<BR>"
					contents += "收购价格：<a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]</a><BR>"
					contents += "提取价格：<a href='?src=\ref[src];setprice=\ref[A]'>[A.withdraw_price]</a><BR>"
					if(!A.no_passive)
						contents += "远程被动导入率：<a href='?src=\ref[src];setrate=\ref[A]'>[A.passive_generation]</a><BR>"
						contents += "导入单价：[A.generation_price] | 总费率价格：[A.generation_price * A.passive_generation]<BR>"
					contents += "需求：[A.demand2word()]<BR>"
					if(!A.export_only)
						if(A.importexport_amt)
							contents += "<a href='?src=\ref[src];import=\ref[A]'>\[进口 [A.importexport_amt] ([A.get_import_price()])\]</a> <a href='?src=\ref[src];export=\ref[A]'>\[出口 [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					else
						if(A.importexport_amt)
							contents += " <a href='?src=\ref[src];export=\ref[A]'>\[出口 [A.importexport_amt] ([A.get_export_price()])\]</a> <BR>"
					contents += "<a href='?src=\ref[src];togglewithdraw=\ref[A]'>\[[A.withdraw_disabled ? "启用" : "禁用"]提取\]</a><BR><BR>"
		if(TAB_IMPORT)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[紧凑：[compact? "启用" : "关闭"]\]</a><BR>"
			contents += "<center>进口<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "国库：[SStreasury.treasury_value]m"
				contents += " / 领主税：[SStreasury.tax_value*100]%"
				contents += " / 行会税：[SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/roguestock/import/A in SStreasury.stockpile_datums)
					contents += "<b>[A.name]:</b>"
					contents += " <a href='?src=\ref[src];import=\ref[A]'>\[进口 [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
			else
				contents += "国库：[SStreasury.treasury_value]m<BR>"
				contents += "领主税：[SStreasury.tax_value*100]%<BR>"
				contents += "行会税：[SStreasury.queens_tax*100]%</center><BR>"
				for(var/datum/roguestock/import/A in SStreasury.stockpile_datums)
					contents += "[A.name]<BR>"
					contents += "[A.desc]<BR>"
					if(!A.stable_price)
						contents += "需求：[A.demand2word()]<BR>"
					contents += "<a href='?src=\ref[src];import=\ref[A]'>\[进口 [A.importexport_amt] ([A.get_import_price()])\]</a><BR><BR>"
		if(TAB_BOUNTIES)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a>"
			contents += "<center>赏金<BR>"
			contents += "--------------<BR>"
			contents += "国库：[SStreasury.treasury_value]m<BR>"
			contents += "领主税：[SStreasury.tax_value*100]%</center><BR>"
			for(var/datum/roguestock/bounty/A in SStreasury.stockpile_datums)
				contents += "[A.name]<BR>"
				contents += "[A.desc]<BR>"
				contents += "累计收集：[SStreasury.minted]<BR>"
				if(A.percent_bounty)
					contents += "赏金价格：<a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]%</a><BR><BR>"
				else
					contents += "赏金价格：<a href='?src=\ref[src];setbounty=\ref[A]'>[A.payout_price]</a><BR><BR>"
		if(TAB_LOG)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a><BR>"
			contents += "<center>日志<BR>"
			contents += "--------------</center><BR><BR>"
			for(var/i = SStreasury.log_entries.len to 1 step -1)
				contents += "<span class='info'>[SStreasury.log_entries[i]]</span><BR>"
		if(TAB_STATISTICS)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a><BR>"
			contents += "<center>统计：<BR>"
			contents += "已知经济产出：[SStreasury.economic_output]m<BR>"
			contents += "总乡税：[SStreasury.total_rural_tax]m<BR>"
			contents += "总存款税：[SStreasury.total_deposit_tax]m<BR>"
			contents += "总贵族地产收入：[SStreasury.total_noble_income]m<BR>"
			contents += "总进口：[SStreasury.total_import]m<BR>"
			contents += "总出口：[SStreasury.total_export]m<BR>"
			contents += "已铸造玛门总额：[SStreasury.minted]m<BR>"
			contents += "贸易差额：[SStreasury.total_export - SStreasury.total_import]m<BR>"
			contents  += "</center><BR>"
		if(TAB_PAYDAY)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a><BR>"
			contents += "<center>每日薪资<BR>"
			contents += "--------------<BR>"
			contents += "国库：[SStreasury.treasury_value]m</center><BR>"
			contents += "<a href='?src=\ref[src];setdailypay=1'>\[添加/修改职业薪资\]</a><BR><BR>"
			if(daily_payments.len)
				contents += "<center>已配置薪资：</center><BR>"
				for(var/job_name in daily_payments)
					var/amt = daily_payments[job_name]
					var/count = 0
					for(var/mob/living/carbon/human/H in GLOB.human_list)
						if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
							count++
					contents += "<b>[job_name]:</b> [amt]m/日"
					if(count > 0)
						contents += "（[count] 在职，每日总计 [amt * count]m）"
					contents += " <a href='?src=\ref[src];removedailypay=[job_name]'>\[移除\]</a><BR>"
			else
				contents += "<center>未配置每日薪资。</center><BR>"
		if(TAB_SALTMINE)
			var/obj/structure/roguemachine/stockpile_saltcamp/stockpile = null
			stockpile = locate(/obj/structure/roguemachine/stockpile_saltcamp) in GLOB.saltminestockpilemachines // we're assuming there is only ever one of these machines in the world
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			if(!isnull(stockpile))
				var/gambled_salt = round(stockpile.salt_spent_on_gambling, 1)
				var/total_accounts = length(stockpile.salt_accounts)
				contents += "<center>特罗伊特盐矿报告:<BR>"
				contents += "总赌博盐量: [gambled_salt] 堆盐</center><BR>"
				if(total_accounts > 0)
					contents += "--------------<BR>"
					contents += "<table><tr><th>囚犯姓名</th><th>已采盐量</th><th>利率</th></tr>"
					for(var/i = 1; i <= total_accounts; i++)
						var/name = stockpile.salt_accounts[i]
						var/salt = stockpile.salt_accounts[name]
						var/salt_max = stockpile.salt_accounts_max[name]
						var/interest = stockpile.salt_accounts_interest_max[name] * 100
						if(salt == 0 && stockpile.salt_ticket_win[name] > 0) // don't show ticket winners who have left the mines
							continue
						contents += "<tr><td>[name]</td><td>[salt]盐/[salt_max]上限</td><td>[interest]%</a></td>"
					contents += "</table>"

	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 700, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/steward/proc/job_filter(advj, j, compact = FALSE)
	if(advj in excluded_jobs)
		return "Adventurer"
	if(j in excluded_jobs)
		return "Adventurer"
	if(compact && j)
		return j
	else if(!compact && advj && j)
		return "[j] ([advj])"
	else if(j)
		return j
	else if(advj)
		return advj

#undef TAB_MAIN
#undef TAB_BANK
#undef TAB_STOCK
#undef TAB_IMPORT
#undef TAB_BOUNTIES
#undef TAB_LOG
#undef TAB_STATISTICS
#undef TAB_PAYDAY
#undef TAB_SALTMINE
