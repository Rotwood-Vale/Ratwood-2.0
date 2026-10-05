#define DRUGRADE_MONEYA				(1<<0)
#define DRUGRADE_MONEYB 	      	(1<<1)
#define DRUGRADE_WINE 	          	(1<<2)
#define DRUGRADE_WEAPONS 	      	(1<<3)
#define DRUGRADE_CLOTHES 	      	(1<<4)
#define DRUGRADE_NOTAX				(1<<5)

#define PURITY_CUT_A_COST			30
#define PURITY_CUT_B_COST			105

/obj/structure/roguemachine/drugmachine
	name = "PURITY"
	desc = "You want to destroy your life."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "purity"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	light_outer_range = 6
	light_color = "#ff13d8ff"
	var/list/held_items = list()
	locked = FALSE
	lockid = "nightman"
	var/secret_budget = 0
	var/recent_payments = 0
	var/last_payout = 0
	var/drugrade_flags
	var/budget
	/// Motto displayed at the top of the TGUI interface.
	var/motto = "PURITY - In the name of pleasure."
	/// Running tally of Crown import tariff actually collected via this machine.
	var/tariff_collected_here = 0
	/// Running tally of tariff dodged via DRUGRADE_NOTAX, for the Bathmaster's audit.
	var/tariff_evaded_here = 0

/obj/structure/roguemachine/drugmachine/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == lockid)
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			update_icon()
			if(locked)
				SStgui.close_uis(src)
				return
			return attack_hand(user)
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/right_key = FALSE
		for(var/obj/item/roguekey/KE in P.contents)
			if(KE.lockid == lockid)
				right_key = TRUE
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				update_icon()
				if(locked)
					SStgui.close_uis(src)
					return
				return attack_hand(user)
		if(!right_key)
			to_chat(user, span_warning("Wrong key."))
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

/obj/structure/roguemachine/drugmachine/process()
	if(recent_payments)
		if(world.time > last_payout + rand(6 MINUTES,8 MINUTES))
			var/amt = recent_payments * 0.10
			if(drugrade_flags & DRUGRADE_MONEYA)
				amt = recent_payments * 0.25
			if(drugrade_flags & DRUGRADE_MONEYB)
				amt = recent_payments * 0.50
			recent_payments = 0
			send_ooc_note("<b>Income from PURITY:</b> [amt]", job = "Bathmaster")
			secret_budget += amt
			last_payout = world.time

/obj/structure/roguemachine/drugmachine/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/drugmachine/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/drugmachine/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(user))
		return
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, "Purity", name)
		ui.open()

/obj/structure/roguemachine/drugmachine/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/drugmachine/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/H = user
	var/can_read = istype(H) ? H.can_read(src, TRUE) : FALSE
	var/is_proprietor = istype(H) && H.job == "Bathmaster"
	var/dodging = (drugrade_flags & DRUGRADE_NOTAX) ? TRUE : FALSE
	data["motto"] = motto
	data["budget"] = budget
	data["locked"] = locked ? TRUE : FALSE
	data["can_read"] = can_read
	data["is_proprietor"] = is_proprietor
	data["dodging"] = dodging
	data["tariff_rate_pct"] = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * 100)
	data["tariff_paid"] = tariff_collected_here
	data["tariff_evaded"] = tariff_evaded_here
	var/cut_pct = 10
	if(drugrade_flags & DRUGRADE_MONEYA)
		cut_pct = 25
	if(drugrade_flags & DRUGRADE_MONEYB)
		cut_pct = 50
	data["recent_payments"] = recent_payments
	data["secret_budget"] = secret_budget
	data["cut_pct"] = cut_pct
	data["upgrade_a_unlocked"] = (drugrade_flags & DRUGRADE_MONEYA) ? TRUE : FALSE
	data["upgrade_b_unlocked"] = (drugrade_flags & DRUGRADE_MONEYB) ? TRUE : FALSE
	data["upgrade_a_cost"] = PURITY_CUT_A_COST
	data["upgrade_b_cost"] = PURITY_CUT_B_COST
	var/tariff_rate = SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF)
	var/cut_floor = floor(secret_budget)
	var/cut_tax = FLOOR(cut_floor * tariff_rate, 1)
	data["withdraw_tax"] = cut_tax
	data["withdraw_net"] = cut_floor - cut_tax
	var/list/items = list()
	for(var/I in held_items)
		var/base = held_items[I]["PRICE"]
		var/tariff = dodging ? 0 : FLOOR(tariff_rate * base, 1)
		items += list(list(
			"ref" = "[I]",
			"name" = held_items[I]["NAME"] || "thing",
			"category" = "Vice",
			"qty" = 1,
			"price_base" = base,
			"price_tariff" = tariff,
			"price" = base + tariff,
		))
	data["items"] = items
	return data

/obj/structure/roguemachine/drugmachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(locked)
		return
	var/mob/living/carbon/human/H = usr
	switch(action)
		if("change")
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
			return TRUE
		if("buy")
			var/O = text2path(params["ref"])
			if(!ispath(O) || !(O in held_items))
				return TRUE
			var/base = held_items[O]["PRICE"]
			if(!base)
				return TRUE
			var/tax_amt = FLOOR(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * base, 1)
			var/full_price = base
			if(drugrade_flags & DRUGRADE_NOTAX)
				record_round_statistic(STATS_TAXES_EVADED, tax_amt)
				tariff_evaded_here += tax_amt
			else
				full_price += tax_amt
			if(budget < full_price)
				say("Not enough!")
				return TRUE
			budget -= full_price
			record_round_statistic(STATS_PURITY_VALUE_SPENT, full_price)
			recent_payments += base
			playsound(loc, 'sound/misc/gold_misc.ogg', 70, FALSE, -1)
			// AP tariff routing: PURITY is a bathhouse stew machine, so the Ordinance of
			// the Baths diverts its tariff to the Church the same as the BRASSFACE.
			if(!(drugrade_flags & DRUGRADE_NOTAX))
				if(SStreasury.bathhouse_ordinance_active)
					var/bathhouse_tithe = SStreasury.compute_bathhouse_tithe(base, BATHHOUSE_BRASSFACE_TITHE_RATE)
					if(bathhouse_tithe > 0)
						SStreasury.mint(SStreasury.church_fund, bathhouse_tithe, "Ordinance of the Baths tithe ([src.name])")
					// While the Ordinance holds the Crown has no claim upon the Baths - the
					// tariff charged on the sale is diverted to the Church instead.
					if(tax_amt > 0)
						SStreasury.mint(SStreasury.church_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] diverted to the Church ([src.name])")
					tariff_collected_here += tax_amt
				else
					SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] ([src.name])")
					record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, tax_amt)
					record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
					record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
					tariff_collected_here += tax_amt
			var/obj/item/I = new O(get_turf(src))
			H.put_in_hands(I)
			return TRUE
		if("toggle_tax")
			if(H.job != "Bathmaster")
				return TRUE
			if(drugrade_flags & DRUGRADE_NOTAX)
				drugrade_flags &= ~DRUGRADE_NOTAX
			else
				drugrade_flags |= DRUGRADE_NOTAX
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			return TRUE
		if("unlock_cut")
			if(H.job != "Bathmaster")
				return TRUE
			var/level = "[params["level"]]"
			if(level == "a")
				if(drugrade_flags & DRUGRADE_MONEYA)
					return TRUE
				if(budget < PURITY_CUT_A_COST)
					say("Ask again when you're serious.")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return TRUE
				budget -= PURITY_CUT_A_COST
				drugrade_flags |= DRUGRADE_MONEYA
			else if(level == "b")
				if(!(drugrade_flags & DRUGRADE_MONEYA) || (drugrade_flags & DRUGRADE_MONEYB))
					return TRUE
				if(budget < PURITY_CUT_B_COST)
					say("Ask again when you're serious.")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return TRUE
				budget -= PURITY_CUT_B_COST
				drugrade_flags |= DRUGRADE_MONEYB
			else
				return TRUE
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			return TRUE
		if("withdraw_cut")
			if(H.job != "Bathmaster")
				return TRUE
			if(secret_budget < 1)
				say("There is no mammon to move, Master.")
				return TRUE
			var/mode = "[params["mode"]]"
			switch(mode)
				if("bank")
					var/cut = floor(secret_budget)
					var/tax_amt = FLOOR(cut * SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF), 1)
					var/deposit = cut - tax_amt
					if(deposit < 1)
						say("The duty would swallow your whole cut, Master. Take it in coin instead.")
						return TRUE
					if(!(SStreasury.generate_money_account(deposit, H))) //We returned false on executing the transfer
						say("I could not put your cut in your account, Master. My apologies.")
						return TRUE
					secret_budget = 0
					// Banking the cut launders it through the ledger, so the Crown takes its
					// import duty off the top - diverted to the Church as a tithe while the
					// Ordinance of the Baths is in force, same as PURITY's sales tariff.
					if(tax_amt > 0)
						if(SStreasury.bathhouse_ordinance_active)
							var/bathhouse_tithe = SStreasury.compute_bathhouse_tithe(cut, BATHHOUSE_BRASSFACE_TITHE_RATE)
							if(bathhouse_tithe > 0)
								SStreasury.mint(SStreasury.church_fund, bathhouse_tithe, "Ordinance of the Baths tithe ([src.name])")
							// The Crown's duty on the banked cut is diverted to the Church
							// while the Ordinance of the Baths is in force.
							SStreasury.mint(SStreasury.church_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] diverted to the Church ([src.name])")
						else
							SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] ([src.name])")
							record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, tax_amt)
							record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
							record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
						tariff_collected_here += tax_amt
					if(SStreasury.bathhouse_ordinance_active)
						say("[deposit]m to your account, Master. The Church keeps [tax_amt]m.")
					else
						say("[deposit]m to your account, Master. The Crown keeps [tax_amt]m.")
				if("direct")
					// The cut leaves as untraced coin, so the Crown's duty is dodged entirely.
					var/cut = floor(secret_budget)
					var/dodged_amt = FLOOR(cut * SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF), 1)
					budget2change(cut, usr)
					secret_budget = 0
					if(dodged_amt > 0)
						record_round_statistic(STATS_TAXES_EVADED, dodged_amt)
						tariff_evaded_here += dodged_amt
				else
					return TRUE
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			return TRUE

/obj/structure/roguemachine/drugmachine/obj_break(damage_flag)
	..()
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "streetvendor0"

/obj/structure/roguemachine/drugmachine/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-drug"))


/obj/structure/roguemachine/drugmachine/Destroy()
	set_light(0)
	STOP_PROCESSING(SSroguemachine, src)
	return ..()

/obj/structure/roguemachine/drugmachine/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	update_icon()
	held_items[/obj/item/reagent_containers/powder/spice] = list("PRICE" = rand(41,55),"NAME" = "chuckledust")
	held_items[/obj/item/reagent_containers/powder/ozium] = list("PRICE" = rand(6,15),"NAME" = "ozium")
	held_items[/obj/item/reagent_containers/powder/moondust] = list("PRICE" = rand(13,25),"NAME" = "moondust")
	held_items[/obj/item/clothing/mask/cigarette/rollie/cannabis] = list("PRICE" = rand(12,18),"NAME" = "swampweed zig")
	held_items[/obj/item/clothing/mask/cigarette/rollie/mentha] = list("PRICE" = rand(6,11),"NAME" = "mentha zig")
	held_items[/obj/item/clothing/mask/cigarette/rollie/nicotine] = list("PRICE" = rand(5,10),"NAME" = "zig")
	held_items[/obj/item/storage/fancy/shhig] = list("PRICE" = rand(40,60), "NAME" = "Shhig brand premium zigs")
	held_items[/obj/item/alch/transisdust] = list("PRICE" = rand(80,120), "NAME" = "sui dust")
	held_items[/obj/item/portable_hookah] = list("PRICE" = rand(90,130), "NAME" = "portable hookah")
	// azure peak addition start - lipstick
	held_items[/obj/item/azure_lipstick] = list("PRICE" = rand(33,50),"NAME" = "red lipstick")
	held_items[/obj/item/azure_lipstick/jade] = list("PRICE" = rand(33,50),"NAME" = "jade lipstick")
	held_items[/obj/item/azure_lipstick/purple] = list("PRICE" = rand(33,50),"NAME" = "purple lipstick")
	held_items[/obj/item/azure_lipstick/black] = list("PRICE" = rand(33,50),"NAME" = "black lipstick")
	//azure peak addition - zigbox
	held_items[/obj/item/quiver/zigs] = list("PRICE" = rand(5,10), "NAME" = "zigbox, empty")
	held_items[/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab] = list("PRICE" = rand(50,70), "NAME" = "fermented crab")
	// azure peak addition end
	held_items[/obj/item/reagent_containers/glass/bottle/rogue/emberwine] = list("PRICE" = rand(100,140),"NAME" = "unlabeled emberwine")

#undef DRUGRADE_MONEYA
#undef DRUGRADE_MONEYB
#undef DRUGRADE_WINE
#undef DRUGRADE_WEAPONS
#undef DRUGRADE_CLOTHES
#undef DRUGRADE_NOTAX
#undef PURITY_CUT_A_COST
#undef PURITY_CUT_B_COST
