// Shared scroll state must be declared before any procs use it.
/obj/item/paper/scroll
	var/open = FALSE
	name = "卷轴"
	icon_state = "scroll"
	slot_flags = null
	dropshrink = 0.6
	firefuel = 30 SECONDS
	sellprice = 2
	textper = 108
	maxlen = 5000
	throw_range = 3
	open_empty_icon_state = "scroll"
	open_written_icon_state = "scrollwrite"
	folded_icon_state = "scroll_folded"
	sealed_icon_state = "scroll_sealed"
	sealed_tint_icon_state = "scroll_sealed_tint"

// Only show the 'Read' prompt if the scroll is open and has info
/obj/item/paper/scroll/examine(mob/user)
	. = ..()
	if(!isobserver(user) || !IsAdminGhost(user))
		if(info && open)
			. += "<a href='?src=[REF(src)];read=1'>阅读</a>"

/obj/item/paper/scroll/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, span_warning("先把我打开。"))
			return
	if(P.get_sharpness())
		to_chat(user, span_warning("[user]撕碎了[src]。"))
		new /obj/item/paper(get_turf(src))
		new /obj/item/paper(get_turf(src))
		qdel(src)
		return
	..()

/obj/item/paper/scroll/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.3,"sx" = 0,"sy" = -1,"nx" = 13,"ny" = -1,"wx" = 4,"wy" = 0,"ex" = 7,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 2,"sflip" = 0,"wflip" = 0,"eflip" = 8)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,"sx" = 0,"sy" = 0,"nx" = 13,"ny" = 1,"wx" = 0,"wy" = 2,"ex" = 5,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 63,"wturn" = -27,"eturn" = 63,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/paper/scroll/attack_self(mob/user)
	if(mailer)
		user.visible_message(span_notice("[user]打开了来自[mailer]的信函。"))
		mailer = null
		mailedto = null
		update_icon()
		return
	if(seal_label && !seal_broken)
		seal_broken = TRUE
		update_icon_state()
		to_chat(user, span_notice("我拆开了[src]上的蜡封。"))
		return
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/paper/scroll/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/paper/scroll/attack_right(mob/user)
	if(seal_label && !seal_broken)
		to_chat(user, span_warning("蜡封还完好无损。我得先拆封。"))
		return
	if(open)
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/scroll_close.ogg', 100, FALSE)
	else
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/scroll_open.ogg', 100, FALSE)
	update_icon_state()
	user.update_inv_hands()

/obj/item/paper/scroll/update_icon_state()
	if(mailer)
		icon_state = sealed_icon_state
		open = FALSE
		name = "信函"
		slot_flags |= ITEM_SLOT_HIP
		throw_range = 7
		apply_seal_tint()
		return
	throw_range = initial(throw_range)
	if(seal_label && !seal_broken)
		icon_state = sealed_icon_state
		open = FALSE
		name = "封缄卷轴"
		slot_flags |= ITEM_SLOT_HIP
		apply_seal_tint()
		return
	clear_seal_tint()
	if(open)
		if(info)
			icon_state = open_written_icon_state
		else
			icon_state = open_empty_icon_state
		name = initial(name)
	else
		icon_state = folded_icon_state
		name = "折叠卷轴"

//Fake reskin of a scroll for the dwarf mercs -- just a fluffy toy
/obj/item/paper/scroll/grudge
	name = "怨仇之书"
	desc = "这是你随身带着的一份副本。可惜旅途中受了潮，已经无法阅读了。不过你仍然可以继续添写新条目。它看起来也够厚重，能当作轻型钝器使用。"
	icon_state ="grudge_closed"
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	grid_width = 32
	grid_height = 32
	force = 10
	possible_item_intents = list(/datum/intent/mace/strike)

/obj/item/paper/scroll/grudge/update_icon_state()
	if(open)
		if(info)
			icon_state = "grudgewrite"
		else
			icon_state = "grudge"
	else
		icon_state = "grudge_closed"

/obj/item/paper/scroll/grudge/attack_right(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	update_icon_state()
	user.update_inv_hands()

/obj/item/paper/scroll/custom
	name = "自定义书本"
	desc = "一本可书写的书本外观。拿在手里即可自定义。"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "book_0"
	maxlen = 10000
	var/stage = 0
	var/base_icon_state = "book"
	var/customized = FALSE

/obj/item/paper/scroll/custom/attack_self(mob/user)
	if(stage == 0)
		var/name_input = stripped_input(user, "给你的书命名，留空则使用默认名称。", "书本", max_length = MAX_NAME_LEN)
		if(name_input)
			name = name_input
		stage++
		return

	if(stage == 1)
		var/desc_input = stripped_input(user, "描述你的书，留空则使用默认描述。", "书本", max_length = MAX_BROADCAST_LEN)
		if(desc_input)
			desc = desc_input
		stage++
		return

	if(stage == 2)
		var/icon/J = new('icons/roguetown/items/books.dmi')
		var/list/istates = J.IconStates()
		var/list/icon_choice = list()
		for(var/icon_s in istates)
			if(icon_s == icon_state)
				continue
			if(!findtext(icon_s, "_0"))
				continue
			icon_choice += list(
				"[icon_s]" = icon(icon = 'icons/roguetown/items/books.dmi', icon_state = icon_s)
			)

		var/icon_input = show_radial_menu(user, src, icon_choice, require_near = TRUE, tooltips = FALSE)
		if(icon_input)
			icon_state = icon_input
			base_icon_state = replacetextEx(icon_input, regex(@"_[0-1]"), "")
			if(alert(user, "你对这个样式满意吗？", "书封", "是", "否") != "是")
				icon_state = initial(icon_state)
				base_icon_state = initial(base_icon_state)
				return
		stage++
		customized = TRUE
		to_chat(user, span_notice("书已经准备好了。右键打开，使用羽毛笔书写。"))
		return

	..()

/obj/item/paper/scroll/custom/update_icon_state()
	if(!customized)
		return
	if(open)
		icon_state = "[base_icon_state]_1"
	else
		icon_state = "[base_icon_state]_0"

/obj/item/paper/scroll/custom/attack_right(mob/user)
	if(open)
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/book_close.ogg', 100, FALSE)
	else
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/book_open.ogg', 100, FALSE)
	update_icon_state()
	user.update_inv_hands()


/obj/item/paper/scroll/cargo
	name = "货运订单"
	icon_state = "contractunsigned"
	var/signedname
	var/signedjob
	var/list/orders = list()
	open = TRUE
	textper = 150

/obj/item/paper/scroll/cargo/Destroy()
	for(var/datum/supply_pack/SO in orders)
		orders -= SO
	return ..()

/obj/item/paper/scroll/cargo/examine(mob/user)
	. = ..()
	. += span_notice(desc)

/obj/item/paper/scroll/cargo/update_icon_state()
	if(open)
		if(signedname)
			icon_state = "contractsigned"
		else
			icon_state = "contractunsigned"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = "卷轴"


/obj/item/paper/scroll/cargo/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/feather))
		if(user.is_literate() && open)
			if(signedname)
				to_chat(user, span_warning("[signedname]"))
				return
			switch(alert("要签上你的名字吗？",,"是","否"))
				if("是")
					if(user.mind && user.mind.assigned_role)
						if(do_after(user, 20, target = src))
							signedname = user.real_name
							signedjob = user.mind.assigned_role
							icon_state = "contractsigned"
							user.visible_message(span_notice("[user]在[src]上签了名。"))
							update_icon_state()
							playsound(src, 'sound/items/write.ogg', 100, FALSE)
							rebuild_info()
				if("否")
					return

/obj/item/paper/scroll/cargo/proc/rebuild_info()
	info = null
	info += "<h2>货运订单</h2>"
	info += "<hr/>"
	var/realmname = SSmapping.map_adjustment.realm_name
	var/display_signedjob = signedjob
	if(signedjob)
		var/datum/job/signed_job_datum = SSjob.GetJob(signedjob)
		if(signed_job_datum && signed_job_datum.display_title)
			display_signedjob = signed_job_datum.display_title

	if(orders.len)
		info += "订单内容：<br/>"
		info += "<ul>"
		for(var/datum/supply_pack/A in orders)
			info += "<li>[A.name]</li><br/>"
		info += "</ul>"

	info += "<br/></font>"

	if(signedname)
		info += "签署人：<br/>"
		info += "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[signedname]，[realmname]的[display_signedjob]</font>"

/obj/item/paper/inqslip
	name = "审判庭文书"
	var/base_icon_state = "slip"
	dropshrink = 0.75
	icon_state = "slip"
	obj_flags = CAN_BE_HIT
	var/signed
	var/mob/living/carbon/signee
	var/marquevalue = 2
	var/sealed
	var/waxed
	var/sliptype = 1
	var/obj/item/inqarticles/indexer/paired

/obj/item/paper/inqslip/accusation
	name = "控告状"
	desc = "一份印在奥塔瓦羊皮纸上的宗教嫌疑文书：它不是用墨水，而是用鲜血签署。将控告状按在自己流血的伤口上即可取得签名。随后再与一台装满被告之血的编目机配对。完成后，它就可以寄回奥塔瓦了。把它折起并封好，这才合乎礼数。"
	marquevalue = 4
	sliptype = 0

/obj/item/paper/inqslip/confession
	name = "供述状"
	base_icon_state = "confession"
	marquevalue = 6
	desc = "一份印在奥塔瓦羊皮纸上的宗教认罪文书：它不是用墨水，而是用鲜血签署。将供述状按在嫌疑人流血的伤口上，即可取得他们的签名。完成后，它就可以寄回奥塔瓦了。把它折起并封好，这才合乎礼数。"
	sliptype = 2

/obj/item/paper/inqslip/arrival
	name = "到任文书"
	desc = "一份印在奥塔瓦羊皮纸上的到任文书：它不是用墨水，而是用鲜血签署。只为某一个特定之人准备。将文书按在自己渗血的伤口上，即可取得合适的签名。完成后，它就可以寄回奥塔瓦了。"

/obj/item/paper/inqslip/arrival/ortho
	marquevalue = 4

/obj/item/paper/inqslip/arrival/adju
	marquevalue = 5

/obj/item/paper/inqslip/arrival/inq
	marquevalue = 10

/obj/item/paper/inqslip/arrival/abso
	marquevalue = 6

/obj/item/paper/inqslip/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		if(waxed)
			to_chat(user, span_notice("这份文书已由[signee.real_name]签署，并以审判庭蜡脂封缄，现在可以通过赫尔墨斯寄回去了。大主教会对这份文书感到满意。"))
		if(signed)
			to_chat(user, span_notice("这份文书已由[signee.real_name]签署，现在可以通过赫尔墨斯寄回去了。若再用审判庭蜡脂将其封缄，将更能博得大主教的青睐。"))
		else if(signee)
			to_chat(user, span_notice("这份文书应由[signee.real_name]签署。"))
		else
			to_chat(user, span_notice("这份文书尚未签署。"))


/obj/item/paper/inqslip/proc/attemptsign(mob/user, mob/living/carbon/human/M)
	if(sliptype == 2)
		if(paired)
			if(paired.subject != user)
				to_chat(M, span_warning("为什么我要在配错了[paired]的情况下让他们签这份文书？"))
				return
			else if(alert(user, "签署供述状？", "确认或拒绝", "是", "否") != "否")
				signed = TRUE
				signee = user
				update_icon()
		else if(alert(user, "签署供述状？", "确认或拒绝", "是", "否") != "否")
			signed = TRUE
			signee = user
			update_icon()
		else
			return
	else if(alert(user, "签署文书？", "确认或拒绝", "是", "否") != "否")
		signed = TRUE
		signee = user
		update_icon()
	else
		return

/obj/item/paper/inqslip/attack(mob/living/carbon/human/M, mob/user)
	if(sealed)
		return
	if(signed)
		to_chat(user, span_warning("它已经签过了。"))
		return
	if(paired && !paired.full)
		to_chat(user, span_warning("我应该先把[paired]和[src]分开，再进行签署。"))
		return
	if(sliptype != 2)
		if(M != user)
			to_chat(user, span_warning("这份文书应由持有者本人签署。"))
			return
	if(!M.get_bleed_rate())
		to_chat(user, span_warning("它必须以血签署。"))
		return
	if(sliptype == 1)
		if(signee == M)
			attemptsign(user)
		else
			to_chat(user, span_warning("这份文书不是给我签的。"))
	else if(!sliptype)
		attemptsign(user)
	else
		attemptsign(M, user)

/obj/item/paper/inqslip/attack_self(mob/user)
	if(!signed)
		to_chat(user, span_warning("它还没签署，我为什么要封它？"))
		return
	if(waxed)
		to_chat(user, span_notice("它已经封好了，可以寄回奥塔瓦了。"))
		return
	else if(!sealed)
		sealed = TRUE
		update_icon()
	else
		sealed = FALSE
		update_icon()

/obj/item/paper/inqslip/attack_right(mob/user)
	if(paired && !user.get_active_held_item())
		user.put_in_active_hand(paired, user.active_hand_index)
		paired = null
		update_icon()
		return TRUE
	attack_self(user)
	return TRUE

/obj/item/paper/inqslip/update_icon_state()
	. = ..()
	throw_range = initial(throw_range)
	if(!sealed)
		if(paired)
			if(!paired.full)
				icon_state = "[base_icon_state]_indexer"
			else
				icon_state = "[base_icon_state]_indexer[signed ? "_signed" : "_blood"]"
				if(paired.cursedblood)
					icon_state = "[icon_state]_c"
		else
			icon_state = "[base_icon_state][signed ? "_signed" : ""]"
	else
		if(!waxed)
			icon_state = "[base_icon_state]_unsealed"
		else
			icon_state = "[base_icon_state]_sealed"
	return

/obj/item/paper/inqslip/arrival/equipped(mob/user, slot, initial)
	. = ..()
	if(!signee)
		signee = user

/obj/item/paper/inqslip/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(istype(I, /obj/item/seal))
		to_chat(user, span_warning("审判庭文书必须使用印戒来封缄"))
		return

	if(istype(I, /obj/item/clothing/ring/signet))
		var/obj/item/clothing/ring/signet/S = I
		if(waxed)
			to_chat(user,  span_warning("它已经用蜡封好了。"))
			return
		if(S.tallowed && sealed)
			waxed = TRUE
			update_icon()
			S.tallowed = FALSE
			S.update_icon()
			playsound(src, 'sound/items/inqslip_sealed.ogg', 75, TRUE, 4)
			marquevalue += 2
			return
		else if(S.tallowed && !sealed)
			to_chat(user,  span_warning("我得先把[src]折起来。"))
			return
		else
			to_chat(user,  span_warning("这枚戒指还没有沾蜡。"))
			return

	if(sliptype != 1)
		if(istype(I, /obj/item/inqarticles/indexer))
			var/obj/item/inqarticles/indexer/Q = I
			if(paired)
				return
			if(!Q.subject)
				if(signed)
					to_chat(user, span_warning("我应该先填满[Q]，再把它与[src]配对。"))
					return
				else
					paired = Q
					user.transferItemToLoc(Q, src, TRUE)
					update_icon()
			else if(Q.subject && Q.full)
				if(sliptype == 2)
					if(Q.subject == signee)
						paired = Q
						user.transferItemToLoc(Q, src, TRUE)
						update_icon()
					else
						if(signed)
							to_chat(user, span_warning("[Q]里装的不是签署[src]之人的血。"))
						else
							to_chat(user, span_warning("我应该先取得签名，再把[Q]与[src]配对。"))
						return
				else
					paired = Q
					user.transferItemToLoc(Q, src, TRUE)
					update_icon()
			else
				to_chat(user,  span_warning("[Q]还没有装满。"))
			return

	return ..()

/obj/item/paper/scroll/sell_price_changes
	name = "更新后的采购价格"
	icon_state = "contractsigned"

	var/list/sell_prices
	var/writers_name
	var/faction

/obj/item/paper/scroll/sell_price_changes/New(loc, list/prices, faction_name)
	. = ..()

	faction = faction_name
	if(!faction)
		faction = pick("Heartfelt", "Hammerhold", "Grenzelhoft", "Kingsfield")		//add more as time goes, idk

	sell_prices = prices
	if(!length(sell_prices))
		sell_prices = generated_test_data()
	writers_name = pick( world.file2list("strings/rt/names/human/humnorm.txt") )
	rebuild_info()

/obj/item/paper/scroll/sell_price_changes/update_icon_state()
	if(open)
		icon_state = "contractsigned"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = "卷轴"


/obj/item/paper/scroll/sell_price_changes/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>采购价格</h2>"
	info += "<hr/>"
	var/display_faction = faction
	switch(faction)
		if("Heartfelt")
			display_faction = "赤心"
		if("Hammerhold")
			display_faction = "铁锤堡"
		if("Grenzelhoft")
			display_faction = "格伦泽尔霍夫特"
		if("Kingsfield")
			display_faction = "王田"

	if(sell_prices.len)
		info += "<ul>"
		for(var/atom/type_path as anything in sell_prices)
			var/list/prices = sell_prices[type_path]
			info += "<li style='color:#06080F;font-size:9px;font-family:\"Segoe Script\"'>[initial(type_path.name)] [prices[1]] > [prices[2]] 玛门</li><br/>"
		info += "</ul>"

	info += "<br/></font>"

	info += "<font size=\"2\" face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[writers_name]，[display_faction]的造船匠</font>"

	info += "</div>"

/obj/item/paper/scroll/sell_price_changes/proc/generated_test_data()

	var/list/prices = list()
	for(var/i = 1 to rand(2, 4))
		var/datum/supply_pack/pack = pick(SSmerchant.supply_packs)
		if(islist(pack.contains))
			continue
		var/path = pack.contains
		if(!path)
			continue
		prices |= path
		var/starting_rand  = rand(100, 50)
		prices[path] = list("[starting_rand]", "[round(starting_rand * 0.5, 1)]")
	sell_prices = prices
/obj/item/paper/scroll/writ_of_esteem
	name = "褒信文书"
	icon_state = "contractsigned"

/obj/item/paper/scroll/writ_of_esteem/update_icon_state()
	if(open)
		icon_state = "contractsigned"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = initial(name)

/obj/item/paper/scroll/writ_of_esteem/zybantine
	desc = "一份用于证明使节身份真实的正式褒信文书。这一份带有兹班图女皇的印戒。"
	info = "奉哈里发、兹班图至高女皇萨伊吉特·阿尔-哈鲁伊克、石膏玫瑰之主之帝谕，并以至仁至慈的普赛顿之名。\
	朕，兹班图帝国之女皇、沙漠与宫廷之主，特颁此诏。持此文书者，乃朕亲命之远行统领，得享完全盟约与安全通行之权，可代表\
	朕之疆域与臣民进行洽谈、征收、立誓与盖印。凡总督与领主，皆当尊重此书；其于朕之封印下有效，并由朕之维齐尔与书记作证。违逆者\
	必受清算；襄助者自得恩宠。此言此令，皆发自兹班图帝国宫廷。"
	icon_state = "contractsigned"

/obj/item/paper/scroll/writ_of_esteem/grenzel
	desc = "一份用于证明使节身份真实的正式褒信文书。这一份带有格伦泽尔霍夫特教廷的印戒。"
	info = "奉我等皇帝陛下之命，并经选帝侯议会之手，特授此文书。兹告天下，持此书者获准代表皇帝进行谈判、\
	发言与行事，其言行等同于陛下亲口所出。凡人不得否认此等权柄；此书已加封印，并由齐聚的选帝侯共同见证。\
	费迪南德三世，格伦泽尔霍夫特教廷之皇帝。"
	icon_state = "contractsigned"

/obj/item/paper/scroll/writ_of_esteem/otavan
	desc = "一份用于证明使节身份真实的正式褒信文书。这一份带有奥塔瓦亲王国的封印。"
	info = "奉银血亲王亨利之令，并经大审判官阿奇博尔德核准之印，此文书得享唯有真正受普赛顿祝福之男女方可拥有的权柄。持此文书者获准以亲王国之名发言、谈判与行事，并得到奥塔瓦教廷的全力支持。此外，凡真正信奉普赛顿及其圣名之人，皆应向持书者提供一切援助，因为他们代行其意志，承载其力量。须知，凡尊重此诏者，必将永得恩宠与敬意；若有人冒犯普赛顿与教廷的男女信众，则其土地必将承受祂的怒火。"
	icon_state = "contractsigned"
