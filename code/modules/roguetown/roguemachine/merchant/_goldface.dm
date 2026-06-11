/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

// DESIGN NOTE
// Merchants need to be able to sell nearly all items that adventurers and combat roles need.
// At a price designed to be undercuttable by economic roles
// But also keep them honest so producer cannot charge a 2x margin and still be competitive
// Merchant provides the primary source of money sinks in the economy, an alternative to producer roles

#define UPGRADE_NOTAX		(1<<0)

/obj/structure/roguemachine/goldface
	name = "金面"
	desc = "镀金的墓穴，终会被蠕虫包裹。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	locked = FALSE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = "1"
	// Motto displayed at the top of the vendor interface
	var/motto = "金面 - 以贪欲之名。"
	lockid = "merchant"
	// Which job can access profit from this vendor
	var/profit_id = list("Merchant", "Shophand")
	/// How much % of the base price is added as profit
	var/profit_margin = 0 // Goldface makes no profit since it's the merchant buying at the best price
	/// The profit stored in the vendor
	var/wgain = 0
	// Where to record value spent
	var/value_record_key = STATS_GOLDFACE_VALUE_SPENT
	// True to make sure it bypass all taxes no matter what
	var/bypass_tax = FALSE
	var/list/categories = list(
		"Alcohols",
		"Food",
		"Games",
		"Substances",
		"Gems",
		"Luxury",
		"Cosmetics",
		"Instruments",
		"Magic",
		"Livestock",
		"Raw Materials",
		"Seeds",
		"Tools",
		"Apparel",
		"Wardrobe",
	)
	var/list/categories_gamer = list(
		"Adventuring Supplies",
		"Armor (Light)",
		"Armor (Iron)",
		"Armor (Steel)",
		"Armor (Exotic)",
		"Potions",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Weapons (Steel)",
		"Weapons (Exotic)",
	)
	var/is_public = FALSE // Whether it is a public access vendor.
	var/extra_fee = 0 // Extra Guild Fees on purchases. Meant to make publicface very unprofitable.

/obj/structure/roguemachine/goldface/public
	name = "银面"
	extra_fee = 0.5
	profit_margin = 0.5
	is_public = TRUE
	locked = FALSE
	motto = "银面 - 人人皆可经商。"
	// There's no profit but this is for futureproofing
	profit_id = list("Merchant", "Shophand")
	value_record_key = STATS_SILVERFACE_VALUE_SPENT
	categories = list(
		"Adventuring Supplies",
		"Alcohols",
		"Food",
		"Games",
		"Substances",
		"Gems",
		"Instruments",
		"Luxury",
		"Magic",
		"Livestock",
		"Cosmetics",
		"Raw Materials",
		"Seeds",
		"Tools",
		"Weapons (Exotic)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/examine()
	. = ..()
	. += "<span class='info'>GOLDFACE 的公开版。公会会为其使用收取高额费用。上锁时，仍可用来浏览商人当前的货品清单。</span>"
	. += "<span class='info'>工艺公会与商人公会之间的协议规定，某些受保护商品必须通过独立贩卖机出售，并可由公会成员上锁。</span>"
	. += "<span class='info'>这台贩卖机可以用钥匙上锁。由于公会会为自动化处理收取极高加价，商人无法从公开贩卖机中获得任何利润。</span>"

/obj/structure/roguemachine/goldface/public/smith
	name = "铁匠的银面"
	lockid = "crafterguild"
	profit_id = list("Guildsman", "Guildmaster", "Tailor")
	categories = list(
		"Armor (Iron)",
		"Armor (Steel)",
		"Armor (Exotic)",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Weapons (Steel)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/smith/examine()
	. = ..()
	. += span_info("它可以用公会钥匙锁上。")

/obj/structure/roguemachine/goldface/public/tailor
	name = "裁缝的银面"
	lockid = "tailor"
	profit_id = list("Guildsman", "Guildmaster", "Tailor")
	categories = list(
		"Apparel",
		"Wardrobe",
		"Armor (Light)",
		"Imported Armor (Light)",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/tailor/examine()
	. = ..()
	. += span_info("它可以用裁缝钥匙锁上。")

/obj/structure/roguemachine/goldface/public/apothecary
	name = "药剂师的银面"
	lockid = "physician"
	profit_id = list("Head Physician","Apothecary")
	categories = list(
		"Potions",
	)
	categories_gamer = list()

/obj/structure/roguemachine/goldface/public/apothecary/examine()
	. = ..()
	. += span_info("它可以用医师钥匙锁上。")

/obj/structure/roguemachine/goldface/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/roguemachine/goldface/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))


/obj/structure/roguemachine/goldface/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == lockid)
			locked = !locked
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			to_chat(user, span_warning("钥匙不对。"))
			return
	else if(istype(P, /obj/item/storage/keyring))
		var/right_key = FALSE
		for(var/obj/item/roguekey/KE in P.contents)
			if(KE.lockid == lockid)
				right_key = TRUE
				locked = !locked
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
		if(!right_key)
			to_chat(user, span_warning("钥匙不对。"))
			return
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/goldface/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/human_mob = usr
	if(!usr.canUseTopic(src, BE_CLOSE) || (locked && !is_public))
		return
	if(href_list["buy"])
		var/mob/M = usr
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("silly MOTHERFUCKER [usr.key] IS TRYING TO BUY A [path] WITH THE GOLDFACE")
			return
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		var/profit = ROUND_UP(PA.cost * profit_margin)
		var/cost = PA.cost + PA.cost * extra_fee
		var/tax_amt = round(SStreasury.tax_value * PA.cost)
		if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
			cost = cost + tax_amt
		cost = round(cost)
		if(budget < cost)
			say("不够！")
			return
		budget -= cost
		wgain += profit
		record_round_statistic(value_record_key, cost)
		record_round_statistic(STATS_TRADE_VALUE_IMPORTED, cost)
		if(!(upgrade_flags & UPGRADE_NOTAX) && !bypass_tax)
			SStreasury.give_money_treasury(tax_amt, "goldface import tax")
			record_featured_stat(FEATURED_STATS_TAX_PAYERS, human_mob, tax_amt)
			record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
		else
			record_round_statistic(STATS_TAXES_EVADED, tax_amt)
		var/shoplength = PA.contains.len
		for(var/l=1,l<=shoplength,l++)
			var/pathi = PA.contains[l]
			new pathi(get_turf(M))
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		current_cat = href_list["changecat"]
	if(href_list["withdrawgain"])
		if(!usr.canUseTopic(src, BE_CLOSE))
			return
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(wgain <= 0)
				return
			if(!(H.job in profit_id))
				return
			budget2change(wgain, usr)
			wgain = 0

	if(href_list["secrets"])
		var/list/options = list()
		if(upgrade_flags & UPGRADE_NOTAX)
			options += "Enable Paying Taxes"
		else
			options += "Stop Paying Taxes"
		var/select = input(usr, "请选择一个选项。", "", null) as null|anything in options
		if(!select)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || (locked & !is_public))
			return
		switch(select)
			if("Enable Paying Taxes")
				upgrade_flags &= ~UPGRADE_NOTAX
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			if("Stop Paying Taxes")
				upgrade_flags |= UPGRADE_NOTAX
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
	return attack_hand(usr)

/obj/structure/roguemachine/goldface/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(locked && !is_public)
		to_chat(user, span_warning("锁着呢，当然。"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	contents = "<center>[motto]<BR>"

	if(locked)
		contents += "<a href='?src=[REF(src)];withdrawgain=1'>已存利润：</a> [wgain]<BR>"
	else
		contents += "<a href='?src=[REF(src)];change=1'>已装入玛门：</a> [budget]<BR>"

	var/mob/living/carbon/human/H = user
	if(H.job in profit_id)
		if(!is_public)
			if(canread)
				contents += "<a href='?src=[REF(src)];secrets=1'>秘项</a>"
			else
				contents += "<a href='?src=[REF(src)];secrets=1'>[stars("秘项")]</a>"
	contents += "</center><BR>"

	if(current_cat == "1")
		contents += "<table style='width: 100%' line-height: 20px;'>"
		for(var/i = 1, i <= categories.len, i++)
			contents += "<tr>"
			contents += "<td style='width: 50%; text-align: center;'>\
				<a href='?src=[REF(src)];changecat=[categories[i]]'>[categories[i]]</a>\
				</td>"
			if(i <= categories_gamer.len)
				contents += "<td style='width: 50%; text-align: center;'>\
					<a href='?src=[REF(src)];changecat=[categories_gamer[i]]'>[categories_gamer[i]]</a>\
				</td>"
			contents += "</tr>"
		contents += "</table>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[返回\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.not_in_public && is_public)
				continue
			if(PA.group == current_cat)
				pax += PA
		for(var/datum/supply_pack/PA in sortNames(pax))
			var/costy = PA.cost + PA.cost * extra_fee
			if(!(upgrade_flags & UPGRADE_NOTAX))
				costy = costy + round(SStreasury.tax_value * PA.cost)
			costy = round(costy)
			var/quantified_name = PA.no_name_quantity ? PA.name : "[PA.name] [PA.contains.len > 1?"x[PA.contains.len]":""]"
			if(is_public && locked)
				contents += "[quantified_name]<BR>"
			else
				contents += "[quantified_name] - ([costy])<a href='?src=[REF(src)];buy=[PA.type]'>购买</a><BR>"

	if(!canread)
		contents = stars(contents)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 500, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/goldface/obj_break(damage_flag)
	..()
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "goldvendor0"

/obj/structure/roguemachine/goldface/Destroy()
	set_light(0)
	return ..()

/obj/structure/roguemachine/goldface/Initialize(mapload)
	. = ..()
	update_icon()

#undef UPGRADE_NOTAX
