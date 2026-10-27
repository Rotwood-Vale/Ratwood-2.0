#define UPGRADE_NOTAX		(1<<0)
/// Max entries kept in the BMtreasury hoard ledger.
#define BM_HOARD_LOG_MAX 50

/obj/structure/roguemachine/bathvend
	name = "BRASSFACE"
	desc = "Sweet, sweet, addiction. Love in the veins, comfort in my heart."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "brassface"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	locked = FALSE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = ""
	var/search_query = ""
	var/static/search_result_cap = 30
	lockid = "nightman"
	/// Motto displayed at the top of the TGUI interface.
	var/motto = "BRASSFACE - Sweet Dreams for Cheap"
	/// Running tally of Crown import tariff actually collected via this machine.
	var/tariff_collected_here = 0
	/// Running tally of tariff dodged via UPGRADE_NOTAX, for the Bathmaster's audit.
	var/tariff_evaded_here = 0
	var/list/categories = list(
		"Alcohols",
		"Discreet Zads",
		"Drugs",
		"Exotic Apparel",
		"Instruments",
		"Perfumes",
		"Roguery",
		"Toys",
		)

/obj/structure/roguemachine/bathvend/Initialize(mapload)
	. = ..()
	SSBMtreasury.brassface = src
	update_icon()

/obj/structure/roguemachine/bathvend/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))


/obj/structure/roguemachine/bathvend/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == lockid)
			locked = !locked
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			update_icon()
			if(locked)
				SStgui.close_uis(src)
				return
			return attack_hand(user)
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K.keys)
			if(KE.lockid == lockid)
				locked = !locked
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				update_icon()
				if(locked)
					SStgui.close_uis(src)
					return
				return attack_hand(user)
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/bathvend/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/bathvend/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/bathvend/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(user))
		return
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
		ui = new(user, src, "Brassface", name)
		ui.open()

/obj/structure/roguemachine/bathvend/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_FAST)
	ui_interact(user)

/obj/structure/roguemachine/bathvend/proc/serialize_pack(datum/supply_pack/PA, tariff_active)
	var/base = PA.cost
	var/tariff = tariff_active ? round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * PA.cost) : 0
	return list(
		"ref" = "[PA.type]",
		"name" = PA.name,
		"category" = PA.group,
		"qty" = PA.contains.len,
		"price_base" = base,
		"price_tariff" = tariff,
		"price" = base + tariff,
	)

/obj/structure/roguemachine/bathvend/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/H = user
	var/can_read = istype(H) ? H.can_read(src, TRUE) : FALSE
	var/is_proprietor = istype(H) && (H.job in list("Bathmaster","Bathhouse Attendant"))
	var/dodging = (upgrade_flags & UPGRADE_NOTAX) ? TRUE : FALSE
	data["motto"] = motto
	data["budget"] = budget
	data["locked"] = locked ? TRUE : FALSE
	data["can_read"] = can_read
	data["is_proprietor"] = is_proprietor
	data["dodging"] = dodging
	data["tariff_rate_pct"] = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * 100)
	data["tariff_paid"] = tariff_collected_here
	data["tariff_evaded"] = tariff_evaded_here
	var/list/all_cats = list()
	for(var/c in categories)
		all_cats += c
	data["categories"] = all_cats
	data["current_category"] = current_cat
	data["search"] = search_query
	data["search_mode"] = (search_query != "") ? TRUE : FALSE
	data["result_cap"] = search_result_cap
	var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX)
	var/list/packs_data = list()
	var/total_matches = 0
	if(search_query != "")
		var/needle = LOWER_TEXT(search_query)
		var/list/matches = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(!(PA.group in categories))
				continue
			if(findtext(LOWER_TEXT(PA.name), needle) || findtext(LOWER_TEXT(PA.group), needle))
				matches += PA
		total_matches = length(matches)
		var/shown = 0
		for(var/datum/supply_pack/PA in sortNames(matches))
			if(shown >= search_result_cap)
				break
			shown++
			packs_data += list(serialize_pack(PA, tariff_active))
	else if(current_cat)
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == current_cat)
				pax += PA
		total_matches = length(pax)
		for(var/datum/supply_pack/PA in sortNames(pax))
			packs_data += list(serialize_pack(PA, tariff_active))
	data["packs"] = packs_data
	data["total_matches"] = total_matches
	var/list/hoard_entries = list()
	for(var/list/entry in SSBMtreasury.hoard_log)
		hoard_entries += list(list(
			"kind" = entry["kind"],
			"time" = entry["time"],
			"text" = entry["text"],
			"amount" = entry["amount"],
			"who" = entry["who"],
		))
	data["hoard_log"] = hoard_entries
	return data

/obj/structure/roguemachine/bathvend/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(locked)
		return
	var/mob/living/carbon/human/H = usr
	switch(action)
		if("changecat")
			var/cat = "[params["category"]]"
			if(cat == "")
				current_cat = ""
			else if(cat in categories)
				current_cat = cat
				search_query = ""
			return TRUE
		if("set_search")
			search_query = "[params["search"]]"
			return TRUE
		if("clear_search")
			search_query = ""
			return TRUE
		if("change")
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
			return TRUE
		if("toggle_tax")
			if(!(H.job in list("Bathmaster","Bathhouse Attendant")))
				return TRUE
			if(upgrade_flags & UPGRADE_NOTAX)
				upgrade_flags &= ~UPGRADE_NOTAX
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			else
				upgrade_flags |= UPGRADE_NOTAX
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				playsound(loc, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
			return TRUE
		if("buy")
			var/path = text2path(params["ref"])
			if(!ispath(path, /datum/supply_pack))
				message_admins("silly MOTHERFUCKER [usr.key] IS TRYING TO BUY A [path] WITH THE BRASSFACE")
				return TRUE
			var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
			if(!PA)
				return TRUE
			if(!(PA.group in categories))
				return TRUE
			var/tax_amt = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * PA.cost)
			var/cost = PA.cost
			if(!(upgrade_flags & UPGRADE_NOTAX))
				cost += tax_amt
			if(budget < cost)
				say("Not enough!")
				return TRUE
			budget -= cost
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			// AP tariff routing: under the Ordinance of the Baths the tariff diverts to the
			// Church as a tithe; broken, it flows to the Crown as standard import duty.
			if(upgrade_flags & UPGRADE_NOTAX)
				record_round_statistic(STATS_TAXES_EVADED, tax_amt)
				tariff_evaded_here += tax_amt
			else if(SStreasury.bathhouse_ordinance_active)
				var/bathhouse_tithe = SStreasury.compute_bathhouse_tithe(PA.cost, BATHHOUSE_BRASSFACE_TITHE_RATE)
				if(bathhouse_tithe > 0)
					SStreasury.mint(SStreasury.church_fund, bathhouse_tithe, "Ordinance of the Baths tithe ([src.name])")
				// While the Ordinance holds the Crown has no claim upon the Baths, so the
				// tariff charged on the sale is diverted to the Church rather than the Crown.
				if(tax_amt > 0)
					SStreasury.mint(SStreasury.church_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] diverted to the Church ([src.name])")
				tariff_collected_here += tax_amt
			else
				SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] ([src.name])")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, tax_amt)
				record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
				record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
				tariff_collected_here += tax_amt
			var/shoplength = PA.contains.len
			for(var/l in 1 to shoplength)
				var/pathi = pick(PA.contains)
				new pathi(get_turf(H))
			return TRUE

/obj/structure/roguemachine/bathvend/obj_break(damage_flag)
	..()
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "goldvendor0"

/obj/structure/roguemachine/bathvend/Destroy()
	set_light(0)
	SSBMtreasury.brassface = null // Clear our reference from the bath treasury subsystem.
	return ..()


#undef UPGRADE_NOTAX

SUBSYSTEM_DEF(BMtreasury)
	name = "BMtreasury"
	wait = 60 SECONDS // this should not need to run very often.
	priority = FIRE_PRIORITY_WATER_LEVEL
	var/treasury_value = 0
	var/multiple_item_penalty = 0.7
	var/interest_rate = 0.15 // Bit more interest, since it's gonna be much harder for the BMaster to get valuables.
	var/next_treasury_check = 0
	var/list/vault_accounting = list()
	/// The reference to the map's brassface, populated when it initializes.
	var/obj/structure/roguemachine/bathvend/brassface
	/// Reverse-chronological ledger of hoard payouts and TREASURE SEEKER consignments.
	var/list/hoard_log = list()

/// Adds an entry to the hoard ledger. kind is "payout" or "deposit".
/datum/controller/subsystem/BMtreasury/proc/add_hoard_log(kind, text, amount, who)
	hoard_log.Insert(1, list(list(
		"kind" = kind,
		"time" = station_time_timestamp("hh:mm"),
		"text" = text,
		"amount" = amount,
		"who" = who,
	)))
	if(length(hoard_log) > BM_HOARD_LOG_MAX)
		hoard_log.Cut(BM_HOARD_LOG_MAX + 1)

/// TRUE if the item would earn the hoard interest while lying in the vault -
/// worthless dross, loose coin and containers are all refused.
/datum/controller/subsystem/BMtreasury/proc/generates_profit(obj/item/I)
	if(I.get_real_price() <= 0 || istype(I, /obj/item/roguecoin) || istype(I, /obj/item/storage))
		return FALSE
	return TRUE

/datum/controller/subsystem/BMtreasury/proc/add_to_vault(obj/item/I)
	if(!generates_profit(I))
		return
	if(I.type in vault_accounting)
		vault_accounting[I.type] *= multiple_item_penalty
	else
		vault_accounting[I.type] = I.get_real_price()
	return (vault_accounting[I.type]*interest_rate)

/datum/controller/subsystem/BMtreasury/fire()
	if(!brassface) // If there's no brassface there's no point in calculating the money it would be collecting.
		return

	if(!(world.time > next_treasury_check)) // Skip this fire if it's not time for another check.
		return

	next_treasury_check = world.time + rand(5 MINUTES, 8 MINUTES) // If we are going through with our check, set the time for the next one 5-8 minutes in the future.

	vault_accounting = list()
	var/amt_to_generate = 0

	// The hoard tallies whatever treasures lie within the Nightmistress's vault (the bath vault area),
	// including anything consigned there by a TREASURE SEEKER.
	var/area/vault_area = GLOB.areas_by_type[/area/rogue/outdoors/exposed/bath/vault]
	if(vault_area)
		for(var/turf/vault_turf in vault_area)
			for(var/obj/item/item in vault_turf.contents)
				if(!isturf(item.loc)) // This shouldn't pick up things that aren't on the turf anyway-- should always be false.
					continue
				amt_to_generate += add_to_vault(item)

			for(var/obj/structure/closet/closet in vault_turf.contents)
				for(var/obj/item/item in closet)
					amt_to_generate += add_to_vault(item)

	amt_to_generate = round(amt_to_generate, 1)
	// AP parity: hoard generation accrues to the Bathhouse Fund rather than the BRASSFACE budget,
	// less the vault tithe to the Church while the Ordinance of the Baths holds.
	if(SStreasury?.bathhouse_fund)
		var/tithe = SStreasury.compute_bathhouse_tithe(amt_to_generate, BATHHOUSE_VAULT_TITHE_RATE)
		if(tithe > 0 && SStreasury.church_fund)
			amt_to_generate -= tithe
			SStreasury.church_fund.balance += tithe
		SStreasury.bathhouse_fund.balance += amt_to_generate
		send_ooc_note("Income from smuggling hoard (deposited to Bathhouse Fund): +[amt_to_generate][tithe > 0 ? " (after [tithe]m tithe to the Church)" : ""]", job = "Bathmaster")
	else
		brassface.budget += amt_to_generate
		send_ooc_note("Income from smuggling hoard to the BRASSFACE: +[amt_to_generate]", job = "Bathmaster")
	if(amt_to_generate > 0)
		add_hoard_log("payout", "Income from smuggling hoard", amt_to_generate)
	record_round_statistic(STATS_BATHMATRON_VAULT_TOTAL_REVENUE, amt_to_generate)


/datum/controller/subsystem/BMtreasury/Destroy()
	brassface = null // If this somehow gets deleted, clean up the reference.
	return ..()

#undef BM_HOARD_LOG_MAX
