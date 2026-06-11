/obj/structure/roguemachine/mail
	name = "赫尔墨斯"
	desc = "自从这种液压气动邮递系统问世后，信差 ZAD告示台 就严重过时了。投币槽会启动机关，分发羊皮纸（一枚 zenny）和羽毛笔（一枚 ziliqua）。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/coin_loaded = FALSE
	var/inqcoins = 0
	var/inqonly = FALSE // Has the Inquisitor locked Marque-spending for lessers?
	var/keycontrol = "puritan"
	var/cat_current = "1"
	var/list/all_category = list(
		"✤ RELIQUARY ✤",
		"✤ SUPPLIES ✤",
		"✤ ARTICLES ✤",
		"✤ EQUIPMENT ✤",
		"✤ WARDROBE ✤"
	)
	var/list/category = list(
		"✤ SUPPLIES ✤",
		"✤ ARTICLES ✤",
		"✤ EQUIPMENT ✤",
		"✤ WARDROBE ✤"
	)
	var/list/inq_category = list("✤ RELIQUARY ✤")
	var/ournum
	var/mailtag
	var/obfuscated = FALSE

/obj/structure/roguemachine/mail/Initialize(mapload)
	. = ..()
	SSroguemachine.hermailers += src
	ournum = SSroguemachine.hermailers.len
	name = "[name] #[ournum]"
	update_icon()

/obj/structure/roguemachine/mail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	return ..()

/obj/structure/roguemachine/mail/attack_hand(mob/user)
	if(ishuman(user) && GLOB.carebox.try_retrieve_carebox(user, src))
		return TRUE
	if(SSroguemachine.hermailermaster && ishuman(user))
		var/obj/item/roguemachine/mastermail/M = SSroguemachine.hermailermaster
		var/mob/living/carbon/human/H = user
		var/addl_mail = FALSE
		for(var/obj/item/I in M.contents)
			if(I.mailedto == H.real_name)
				if(!addl_mail)
					I.forceMove(src.loc)
					user.put_in_hands(I)
					addl_mail = TRUE
				else
					say("你还有额外邮件可取。")
					break
		if(!any_additional_mail(M, H.real_name))
			if(!addl_mail && H.has_status_effect(/datum/status_effect/ugotmail)) // we apparently got mail, but never got mail (hint: it was stolen by someone with access to the master mailer)
				to_chat(user, span_notice("我往机器里一看，居然没有信，真是奇怪。"))
			H.remove_status_effect(/datum/status_effect/ugotmail)
	if(!ishuman(user))
		return
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(!coin_loaded && !inqcoins)
			to_chat(user, span_notice("它需要一枚 印记。"))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		display_marquette(usr)

/obj/structure/roguemachine/mail/examine(mob/user)
	. = ..()
	. += span_info("先投入一枚硬币，再右键发送信件。")
	. += span_info("手持纸张左键点击，可免费寄出预先写好的信。")
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_info("<br>印记终端 可通过赫尔墨斯内部的暗格进入。装入一枚 印记 即可访问。")

		. += span_info("你可以在这里寄送到达单、控诉单、已填满的 编目机 或供词。")
		. += span_info("请正确署名。需要时附上 编目机。加盖印章需额外两枚 印记。")

/obj/structure/roguemachine/mail/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(!coin_loaded)
		to_chat(user, span_warning("机器没有反应。它需要一枚硬币。"))
		return
	if(inqcoins)
		to_chat(user, span_warning("机器没有反应。"))
		return
	var/send2place = input(user, "寄往何处？（人名或 #编号）", "ROGUETOWN", null)
	if(!send2place)
		return
	var/sentfrom = input(user, "这封信是谁寄出的？", "ROGUETOWN", null)
	if(!sentfrom)
		sentfrom = "匿名"
	var/t = stripped_multiline_input("书写你的信件", "ROGUETOWN", no_trim=TRUE)
	if(t)
		if(length(t) > 2000)
			to_chat(user, span_warning("太长了。请重试。"))
			return
	if(!coin_loaded)
		return
	if(!Adjacent(user))
		return
	var/obj/item/paper/P = new
	P.info += t
	P.mailer = sentfrom
	P.mailedto = send2place
	P.update_icon()
	if(findtext(send2place, "#"))
		var/box2find = text2num(copytext(send2place, findtext(send2place, "#")+1))
		var/found = FALSE
		for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
			if(X.ournum == box2find)
				found = TRUE
				P.mailer = sentfrom
				P.mailedto = send2place
				P.update_icon()
				P.forceMove(X.loc)
				X.say("有新邮件！")
				playsound(X, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				break
		if(found)
			visible_message(span_warning("[user]寄出了东西。"))
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			SStreasury.give_money_treasury(coin_loaded, "Mail Income")
			coin_loaded = FALSE
			update_icon()
			return
		else
			to_chat(user, span_warning("发送失败。编号不对？"))
	else
		if(!send2place)
			return
		if(SSroguemachine.hermailermaster)
			var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
			P.mailer = sentfrom
			P.mailedto = send2place
			P.update_icon()
			P.forceMove(X.loc)
			var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
			STR.handle_item_insertion(P, prevent_warning=TRUE)
			X.new_mail=TRUE
			X.update_icon()
			send_ooc_note("New letter from <b>[sentfrom].</b>", name = send2place)
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.real_name == send2place)
					H.apply_status_effect(/datum/status_effect/ugotmail)
					H.playsound_local(H, 'sound/misc/mail.ogg', 100, FALSE, -1)
		else
			to_chat(user, span_warning("邮务总管已经不在了？"))
			return
		visible_message(span_warning("[user]寄出了东西。"))
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		SStreasury.give_money_treasury(coin_loaded, "Mail")
		coin_loaded = FALSE
		update_icon()

/obj/structure/roguemachine/mail/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/merctoken))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.mind.assigned_role != "Mercenary")
				to_chat(H, "<span class='warning'>这东西对我没用，我可以把它交给佣兵，让他们自己寄出去。</span>")
				return
			if(H.mind.assigned_role == "Mercenary")
				if(H.tokenclaimed == TRUE)
					to_chat(H, "<span class='warning'>我已经领过表彰了。期待下周吧！</span>")
					return
			var/obj/item/merctoken/C = P
			if(C.signed == 1)
				qdel(C)
				visible_message("<span class='warning'>[H]寄出了东西。</span>")
				playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
				sleep(20)
				playsound(loc, 'sound/misc/triumph.ogg', 100, FALSE, -1)
				playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				H.visible_message("<span class='warning'>一件小饰物从机器里滚落下来。这是你功绩的证明。</span>")
				H.adjust_triumphs(3)
				H.tokenclaimed = TRUE
				switch(H.merctype)
					if(0)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal(src.loc)
					if(1)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/atgervi(src.loc)
					if(2)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/blackoak(src.loc)
					if(3)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/condottiero(src.loc)
					if(4)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/desertrider(src.loc)
					if(5)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/forlorn(src.loc)
					if(6)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/freifechter(src.loc)
					if(7)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grenzelhoft(src.loc)
					if(8)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grudgebearer(src.loc)
					if(9)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal(src.loc) // NOT CURRENTLY IMPLEMENTED
					if(10)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/routier(src.loc)
					if(11)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/steppesman(src.loc)
					if(12)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/underdweller(src.loc)
					if(13)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/vaquero(src.loc)
					if(14)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/warscholar(src.loc)
					if(15)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/anthrax(src.loc)
					if(16)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/oathmarked(src.loc)
			if(C.signed == 0)
				to_chat(H, "<span class='warning'>我不能寄出一枚未签名的凭证。</span>")
				return
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(istype(P, /obj/item/roguekey))
			var/obj/item/roguekey/K = P
			if(K.lockid == keycontrol) // Inquisitor's Key
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				for(var/obj/structure/roguemachine/mail/everyhermes in SSroguemachine.hermailers)
					everyhermes.inqlock()
				to_chat(user, span_warning("我[inqonly ? "启用" : "停用"]了清教徒锁。"))
				return display_marquette(user)
			to_chat(user, span_warning("钥匙不对。"))
			return
		if(istype(P, /obj/item/storage/keyring))
			var/obj/item/storage/keyring/K = P
			if(!K.contents.len)
				return
			var/list/keysy = K.contents.Copy()
			for(var/obj/item/roguekey/KE in keysy)
				if(KE.lockid == keycontrol)
					playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
					for(var/obj/structure/roguemachine/mail/everyhermes in SSroguemachine.hermailers)
						everyhermes.inqlock()
					to_chat(user, span_warning("我[inqonly ? "启用" : "停用"]了清教徒锁。"))
					return display_marquette(user)

	if(istype(P, /obj/item/inqarticles/bmirror))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			var/obj/item/inqarticles/bmirror/I = P
			if(I.broken && !I.bloody)
				visible_message(span_warning("[user]寄出了东西。"))
				budget2change(2, user, "MARQUE")
				qdel(I)
				record_round_statistic(STATS_MARQUES_MADE, 2)
				playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
				playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			else
				if(!I.broken)
					to_chat(user, (span_warning("它并没有坏。")))
				if(I.broken)
					to_chat(user, (span_warning("先把它清理干净。")))

	if(istype(P, /obj/item/paper/inqslip/confession))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			var/obj/item/paper/inqslip/confession/I = P
			if(I.signee && I.signed)
				var/no
				var/accused
				var/stopfarming
				var/bonuses = 2
				var/cursedblood
				var/indexed
				var/selfreport
				var/correct
				if(HAS_TRAIT(I.signee, TRAIT_INQUISITION))
					selfreport = TRUE
				if(HAS_TRAIT(I.signee, TRAIT_CABAL) || HAS_TRAIT(I.signee, TRAIT_HORDE) || HAS_TRAIT(I.signee, TRAIT_DEPRAVED) || HAS_TRAIT(I.signee, TRAIT_COMMIE))
					correct = TRUE
				if(I.signee.name in GLOB.excommunicated_players)
					correct = TRUE
				if(I.paired)
					if(HAS_TRAIT(I.paired.subject, TRAIT_INQUISITION))
						selfreport = TRUE
						indexed = TRUE
					if(I.paired.subject && I.paired.full && !selfreport)
						if(I.paired.cursedblood)
							if(HAS_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD))
								stopfarming = TRUE
							else
								ADD_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD, "mail")
								cursedblood = TRUE
								if(GLOB.cursedsamples.len)
									GLOB.cursedsamples += ", [I.paired.subject.mind]"
								else
									GLOB.cursedsamples += "[I.paired.subject.mind]"
						if(GLOB.indexed)
							if(HAS_TRAIT(I.paired.subject.mind, TRAIT_INDEXED))
								indexed = TRUE
							if(!indexed)
								ADD_TRAIT(I.paired.subject.mind, TRAIT_INDEXED, "mail")
								if(GLOB.indexed.len)
									GLOB.indexed += ", [I.signee]"
								else
									GLOB.indexed += "[I.signee]"
				if(GLOB.accused && !selfreport)
					if(HAS_TRAIT(I.signee.mind, TRAIT_ACCUSED))
						accused = TRUE
				if(GLOB.confessors && !selfreport)
					if(HAS_TRAIT(I.signee.mind, TRAIT_CONFESSED))
						no = TRUE
					if(!no)
						ADD_TRAIT(I.signee.mind, TRAIT_CONFESSED, "mail")
						if(GLOB.confessors.len)
							GLOB.confessors += ", [I.signee]"
						else
							GLOB.confessors += "[I.signee]"
				if(no | selfreport)
					if(I.paired)
						qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user]寄出了东西。"))
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					if(no)
						to_chat(user, span_notice("他们已经招供了。"))
					else if(stopfarming)
						to_chat(user, span_notice("我们已经采集过他们那被诅咒的血样了。"))
					if(selfreport)
						to_chat(user, span_notice("为什么那份供词会由一名裁判所成员签署？什么情况？"))
					if(indexed)
						visible_message(span_warning("[user]收到了一样东西。"))
						var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer/
						user.put_in_hands(replacement)
					return
				else
					if(!correct)
						if(cursedblood)
							bonuses = bonuses + bonuses * I.paired.cursedblood
							if(I.waxed)
								bonuses += 2
							budget2change(bonuses, user, "MARQUE")
							record_round_statistic(STATS_MARQUES_MADE, bonuses)
						if(I.paired && !indexed && !correct && !cursedblood)
							if(I.waxed)
								bonuses += 2
						budget2change(bonuses, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, bonuses)
					else
						if(I.paired && !indexed && !cursedblood)
							I.marquevalue += bonuses
						if(cursedblood)
							bonuses = bonuses + bonuses * I.paired.cursedblood
							I.marquevalue += bonuses
						if(accused)
							I.marquevalue -= 4
						budget2change(I.marquevalue, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)
					if(I.paired)
						qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user]寄出了东西。"))
					playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			return

	if(istype(P, /obj/item/inqarticles/indexer))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			to_chat(user, span_warning("它必须和单据或供词配套使用。"))
			return

	if(istype(P, /obj/item/paper/inqslip/arrival))
		if(!(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			to_chat(user, span_warning("只有裁判所才能提交到达单。"))
			return
		var/obj/item/paper/inqslip/arrival/I = P
		if(I.signee && I.signed)
			message_admins("INQ ARRIVAL: [user.real_name] ([user.ckey]) has just arrived as a [user.job], earning [I.marquevalue] Marques.")
			log_game("INQ ARRIVAL: [user.real_name] ([user.ckey]) has just arrived as a [user.job], earning [I.marquevalue] Marques.")
			budget2change(I.marquevalue, user, "MARQUE")
			record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)
			qdel(I)
			visible_message(span_warning("[user]寄出了东西。"))
			playsound(loc, 'sound/misc/otavasent.ogg', 100, FALSE, -1)
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		return

	if(istype(P, /obj/item/paper/inqslip/accusation))
		if(!(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			to_chat(user, span_warning("只有裁判所才能提交控诉单。"))
			return
		var/obj/item/paper/inqslip/accusation/I = P
		if(I.paired)
			if(I.signee && I.paired.full && I.paired.subject)
				var/no
				var/specialno
				var/stopfarming
				var/indexed
				var/bonuses = 2
				var/correct
				var/cursedblood
				var/selfreport
				if(HAS_TRAIT(I.paired.subject, TRAIT_INQUISITION))
					selfreport = TRUE
				if(HAS_TRAIT(I.paired.subject, TRAIT_CABAL) || HAS_TRAIT(I.paired.subject, TRAIT_HORDE) || HAS_TRAIT(I.paired.subject, TRAIT_DEPRAVED) || HAS_TRAIT(I.paired.subject, TRAIT_COMMIE))
					correct = TRUE
				if(I.paired.subject.name in GLOB.excommunicated_players)
					correct = TRUE
				if(GLOB.indexed && !selfreport)
					if(HAS_TRAIT(I.paired.subject.mind, TRAIT_INDEXED))
						indexed = TRUE
					if(!indexed && !selfreport)
						ADD_TRAIT(I.paired.subject.mind, TRAIT_INDEXED, "mail")
						if(GLOB.indexed.len)
							GLOB.indexed += ", [I.paired.subject]"
						else
							GLOB.indexed += "[I.paired.subject]"
				if(I.paired.cursedblood)
					if(HAS_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD))
						stopfarming = TRUE
					if(!stopfarming)
						cursedblood = TRUE
						ADD_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD, "mail")
						if(GLOB.cursedsamples.len)
							GLOB.cursedsamples += ", [I.paired.subject.mind]"
						else
							GLOB.cursedsamples += "[I.paired.subject.mind]"
				if(GLOB.accused && !selfreport)
					if(HAS_TRAIT(I.paired.subject.mind, TRAIT_ACCUSED))
						no = TRUE
					if(!no)
						ADD_TRAIT(I.paired.subject.mind, TRAIT_ACCUSED, "mail")
						if(GLOB.accused.len)
							GLOB.accused += ", [I.paired.subject]"
						else
							GLOB.accused += "[I.paired.subject]"
				if(GLOB.confessors && !selfreport)
					if(HAS_TRAIT(I.paired.subject.mind, TRAIT_CONFESSED))
						no = TRUE
						specialno = TRUE
				if(cursedblood)
					bonuses = bonuses + bonuses * I.paired.cursedblood
					if(I.waxed)
						bonuses += 2
					budget2change(bonuses, user, "MARQUE")
					record_round_statistic(STATS_MARQUES_MADE, bonuses)
				if(no || selfreport || stopfarming)
					qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user]寄出了东西。"))
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					if(!cursedblood)
						visible_message(span_warning("[user]收到了一样东西。"))
						var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer/
						user.put_in_hands(replacement)
						if(specialno)
							to_chat(user, span_notice("他们已经招供了。"))
						else if(selfreport)
							to_chat(user, span_notice("我们怎么开始控诉自己人了？事情怎么会变成这样？"))
						else if(stopfarming)
							to_chat(user, span_notice("我们已经采集过他们那被诅咒的血样了。"))
						else
							to_chat(user, span_notice("他们已经被控诉过了。"))
					return
				else
					if(!indexed && !correct && !cursedblood)
						(I.marquevalue -= 4) += bonuses
						budget2change(I.marquevalue, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)
					if(correct)
						if(!indexed)
							I.marquevalue += bonuses
						budget2change(I.marquevalue, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)
					qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user]寄出了东西。"))
					playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					return
			else
				if(!I.paired.full)
					to_chat(user, span_warning("[I.paired]里必须装满被告者的血。"))
					return
				to_chat(user, span_warning("[I]缺少签名。"))
				return
		else
			to_chat(user, span_warning("[I]缺少 编目机。"))
			return

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/smallDelivery))
		if(inqcoins)
			to_chat(user, span_warning("机器没有反应。"))
			return
		if(alert(user, "寄送邮件？",,"是","否") == "是")
			var/send2place = input(user, "寄往何处？（人名或 #编号）", "ROGUETOWN", null)
			var/sentfrom = input(user, "这是谁寄来的？（留空则匿名寄出）", "ROGUETOWN", null)
			if(!sentfrom)
				sentfrom = "匿名"
			if(findtext(send2place, "#"))
				var/box2find = text2num(copytext(send2place, findtext(send2place, "#")+1))
				testing("box2find [box2find]")
				var/found = FALSE
				for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
					if(X.ournum == box2find)
						found = TRUE
						P.mailer = sentfrom
						P.mailedto = send2place
						P.update_icon()
						P.forceMove(X.loc)
						X.say("有新邮件！")
						playsound(X, 'sound/misc/hiss.ogg', 100, FALSE, -1)
						break
				if(found)
					visible_message(span_warning("[user]寄出了东西。"))
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					return
				else
					to_chat(user, span_warning("无法寄出。编号不对？"))
			else
				if(!send2place)
					return
				var/mob/living/carbon/human/mailrecipient = null
				for(var/mob/living/carbon/human/H in GLOB.human_list)
					if(H.real_name == send2place)
						mailrecipient = H
				if(!mailrecipient && (alert("找不到收件人 [send2place]。仍要寄出这封信吗？", "", "是", "否") == "否")) // ask player if they still want to send a letter to a non-found character
					return
				var/findmaster
				if(SSroguemachine.hermailermaster)
					var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
					findmaster = TRUE
					P.mailer = sentfrom
					P.mailedto = send2place
					P.update_icon()
					P.forceMove(X.loc)
					var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
					STR.handle_item_insertion(P, prevent_warning=TRUE)
					X.new_mail=TRUE
					X.update_icon()
					playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				if(!findmaster)
					to_chat(user, span_warning("邮务总管已经不在了？"))
				else
					visible_message(span_warning("[user]寄出了东西。"))
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					send_ooc_note("New letter from <b>[sentfrom].</b>", name = send2place)
					if(mailrecipient)
						mailrecipient.apply_status_effect(/datum/status_effect/ugotmail)
						mailrecipient.playsound_local(mailrecipient, 'sound/misc/mail.ogg', 100, FALSE, -1)
					return

	if(istype(P, /obj/item/roguecoin/gilbranze))
		return

	if(istype(P, /obj/item/roguecoin/inqcoin))
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(coin_loaded && !inqcoins)
				return
			var/obj/item/roguecoin/M = P
			coin_loaded = TRUE
			inqcoins += M.quantity
			update_icon()
			qdel(M)
			playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
			return display_marquette(usr)
		else
			return

	if(istype(P, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = P
		switch(C.get_real_price())
			if(1)
				qdel(C)
				var/obj/item/paper/papier = new
				user.put_in_hands(papier)
			if(5)
				qdel(C)
				var/obj/item/natural/feather/quill = new
				user.put_in_hands(quill)
			else
				to_chat(user, span_warning("币值无效！投入 1 玛门可买纸张，投入 5 玛门可买羽毛笔。"))
				return
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	..()

/obj/structure/roguemachine/mail/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/mail/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/mail/update_icon()
	cut_overlays()
	if(coin_loaded)
		if(inqcoins > 0)
			add_overlay(mutable_appearance(icon, "mail-i"))
			set_light(1, 1, 1, l_color = "#ffffff")
		else
			add_overlay(mutable_appearance(icon, "mail-f"))
			set_light(1, 1, 1, l_color = "#1b7bf1")
	else
		add_overlay(mutable_appearance(icon, "mail-s"))
		set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/structure/roguemachine/mail/examine(mob/user)
	. = ..()
	. += "<a href='?src=[REF(src)];directory=1'>目录：</a> [mailtag]"

/obj/structure/roguemachine/mail/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["directory"])
		view_directory(usr)

/obj/structure/roguemachine/mail/proc/view_directory(mob/user)
	var/dat
	for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
		if(X.obfuscated)
			continue
		if(X.mailtag)
			dat += "#[X.ournum] [X.mailtag]<br>"
		else
			dat += "#[X.ournum] [capitalize(get_area_name(X))]<br>"

	var/datum/browser/popup = new(user, "hermes_directory", "<center>赫尔墨斯目录</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)

/obj/item/roguemachine/mastermail
	name = "邮务总管"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mailspecial"
	pixel_y = 32
	max_integrity = 0
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	var/new_mail

/obj/item/roguemachine/mastermail/update_icon()
	cut_overlays()
	if(new_mail)
		icon_state = "mailspecial-get"
	else
		icon_state = "mailspecial"
	set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/item/roguemachine/mastermail/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/mailmaster)

/obj/item/roguemachine/mastermail/attack_hand(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		if(new_mail)
			new_mail = FALSE
			update_icon()
		CP.rmb_show(user)
		return TRUE

/obj/item/roguemachine/mastermail/Initialize(mapload)
	. = ..()
	SSroguemachine.hermailermaster = src
	update_icon()

/obj/item/roguemachine/mastermail/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/paper))
		var/obj/item/paper/PA = P
		if(!PA.mailer && !PA.mailedto && PA.cached_mailer && PA.cached_mailedto)
			PA.mailer = PA.cached_mailer
			PA.mailedto = PA.cached_mailedto
			PA.cached_mailer = null
			PA.cached_mailedto = null
			PA.update_icon()
			to_chat(user, span_warning("我小心地重新封好这封信，把它放回机器里，没人会知道。"))
		if(PA.mailer && PA.mailedto)
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.real_name == PA.mailedto && !H.has_status_effect(/datum/status_effect/ugotmail)) // quietly readd the status if they tried to check their mail while the letter was being spied on
					H.apply_status_effect(/datum/status_effect/ugotmail)
		P.forceMove(loc)
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.handle_item_insertion(P, prevent_warning=TRUE)
	..()

/obj/item/roguemachine/mastermail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
	return ..()

/obj/structure/roguemachine/mail/proc/any_additional_mail(obj/item/roguemachine/mastermail/M, name)
	for(var/obj/item/I in M.contents)
		if(I.mailedto == name)
			return TRUE
	return FALSE


/*
	INQUISITION INTERACTIONS - START
*/

/obj/structure/roguemachine/mail/proc/inqlock()
	inqonly = !inqonly

/obj/structure/roguemachine/mail/proc/decreaseremaining(datum/inqports/PA)
	PA.remaining -= 1
	PA.name = "[initial(PA.name)] ([PA.remaining]/[PA.maximum]) - ᛉ [PA.marquescost] ᛉ"
	if(!PA.remaining)
		PA.name = "[initial(PA.name)] (已售罄) - ᛉ [PA.marquescost] ᛉ"
	return

/obj/structure/roguemachine/mail/proc/display_marquette(mob/user)
	var/contents
	contents = "<center>✤ ── 奥塔瓦裁判所配给册 ── ✤<BR>"
	contents += "为根除异端，只要 普赛顿 仍在。<BR>"
	if(HAS_TRAIT(user, TRAIT_PURITAN))
		contents += "✤ ── <a href='?src=[REF(src)];locktoggle=1]'> 清教徒锁：[inqonly ? "开":"关"]</a> ── ✤<BR>"
	else
		contents += "✤ ── 清教徒锁：[inqonly ? "开":"关"] ── ✤<BR>"
	contents += "ᛉ <a href='?src=[REF(src)];eject=1'>已装入 印记：[inqcoins]</a>ᛉ<BR>"

	if(cat_current == "1")
		contents += "<BR> <table style='width: 100%' line-height: 40px;'>"
/*		if(HAS_TRAIT(user, TRAIT_PURITAN))
			for(var/i = 1, i <= inq_category.len, i++)
				contents += "<tr>"
				contents += "<td style='width: 100%; text-align: center;'>\
					<a href='?src=[REF(src)];changecat=[inq_category[i]]'>[inq_category[i]]</a>\
					</td>"
				contents += "</tr>"*/
		for(var/i = 1, i <= category.len, i++)
			contents += "<tr>"
			contents += "<td style='width: 100%; text-align: center;'>\
				<a href='?src=[REF(src)];changecat=[category[i]]'>[category[i]]</a>\
				</td>"
			contents += "</tr>"
		contents += "</table>"
	else
		contents += "<center>[cat_current]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[返回\]</a><BR><BR></center>"
		contents += "<center>"
		var/list/items = list()
		for(var/pack in GLOB.inqsupplies)
			var/datum/inqports/PA = pack
			if(all_category[PA.category] == cat_current && PA.name)
				items += GLOB.inqsupplies[pack]
				if(PA.name == "Seizing Garrote" && !HAS_TRAIT(user, TRAIT_BLACKBAGGER))
					items -= GLOB.inqsupplies[pack]
		for(var/pack in sortNames(items, order=0))
			var/datum/inqports/PA = pack
			var/name = uppertext(PA.name)
			if(inqonly && !HAS_TRAIT(user, TRAIT_PURITAN) || (PA.maximum && !PA.remaining) || inqcoins < PA.marquescost)
				contents += "[name]<BR>"
			else
				contents += "<a href='?src=[REF(src)];buy=[PA.type]'>[name]</a><BR>"
		contents += "</center>"
	var/datum/browser/popup = new(user, "VENDORTHING", "", 500, 600)
	popup.set_content(contents)
	if(inqcoins == 0)
		popup.close()
		return
	else
		popup.open()

/obj/structure/roguemachine/mail/Topic(href, href_list)
	..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["eject"])
		if(inqcoins <= 0)
			return
		coin_loaded = FALSE
		update_icon()
		budget2change(inqcoins, usr, "MARQUE")
		inqcoins = 0

	if(href_list["changecat"])
		cat_current = href_list["changecat"]

	if(href_list["locktoggle"])
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		for(var/obj/structure/roguemachine/mail/everyhermes in SSroguemachine.hermailers)
			everyhermes.inqlock()

	if(href_list["buy"])
		var/path = text2path(href_list["buy"])
		var/datum/inqports/PA = GLOB.inqsupplies[path]

		inqcoins -= PA.marquescost
		if(PA.maximum)
			decreaseremaining(PA)
		visible_message(span_warning("[usr]寄出了东西。"))
		if(!inqcoins)
			coin_loaded = FALSE
			update_icon()
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		var/area/A = GLOB.areas_by_type[/area/rogue/indoors/inq/import]
		if(!A)
			return
		var/list/turfs = list()
		for(var/turf/T in A)
			turfs += T
		var/turf/T = pick(turfs)
		var/pathi = pick(PA.item_type)
		playsound(T, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		new pathi(get_turf(T))

	return display_marquette(usr)

/*
	INQUISITION INTERACTIONS - END
*/
