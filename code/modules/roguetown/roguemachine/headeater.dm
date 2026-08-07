// Taxation 2 rework (ported from AP #6849/#7000): bounties credit the bearer's meister account
// at full sellprice, less the Lord-adjustable Crown's Headeater Levy (TAX_CATEGORY_HEADEATER_LEVY).
// Replaces the old flat 60% house cut that paid in loose coins.
// ES deviations: player accounts are integer ledger balances (bank_accounts), so the gross is
// minted straight onto the ledger (new money, mirroring AP's mint-to-account) and the levy is a
// ledger debit minted into the Crown's Purse. AP's no_head_bounty flag is not ported - ES heads
// carry their own sellprice semantics unchanged.
/obj/structure/roguemachine/headeater
	name = "HEADEATER"
	desc = "A machine that indulges in humenity's oldest profession; killing. The heads of Dendor's creechers, goblins, and brigands go in, and the bounty is credited directly to the bearer's account - less the Crown's Headeater Levy, of course."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/topay = 0

/obj/structure/roguemachine/headeater/examine()
	. = ..()
	. += span_info("Left-click to deposit a head into the machine, and right-click to deposit all heads in front of the machine.")
	. += span_smallnotice("Crown's Headeater Levy: [round(SStreasury.get_tax_rate(TAX_CATEGORY_HEADEATER_LEVY) * 100)]%")

/obj/structure/roguemachine/headeater/attackby(obj/item/H, mob/user, params)
	. = ..()
	if(!istype(H, /obj/item/natural/head) && !istype(H, /obj/item/bodypart/head))
		to_chat(user, span_danger("It seems uninterested by [H]"))
		return
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("[src] refuses the head - to benefit from the Crown's bounties you must be registered with a Nervelock."))
		return
	eathead(H, user)

/// Credits gross to the bearer's ledger, then skims the Crown's Headeater Levy into the Purse.
/// Returns the net amount credited.
/obj/structure/roguemachine/headeater/proc/payout(mob/user, gross)
	if(gross <= 0)
		return 0
	if(!SStreasury.has_account(user))
		return 0
	SStreasury.bank_accounts[user] += gross
	// Item 6 decrees: charter exemptions and rate caps apply to the levy (ES deviation:
	// integer ledger, so the AP apply_tax() fund path is inlined here).
	var/base_rate = SStreasury.get_tax_rate(TAX_CATEGORY_HEADEATER_LEVY)
	if(isliving(user) && SStreasury.is_tax_exempt(user, TAX_CATEGORY_HEADEATER_LEVY))
		SStreasury.record_tax_exemption(TAX_CATEGORY_HEADEATER_LEVY, FLOOR(gross * base_rate, 1))
		return gross
	var/rate = base_rate
	if(isliving(user))
		rate = min(rate, SStreasury.get_rate_cap(user, TAX_CATEGORY_HEADEATER_LEVY))
	if(rate < base_rate)
		SStreasury.record_tax_exemption(TAX_CATEGORY_HEADEATER_LEVY, FLOOR(gross * (base_rate - rate), 1))
	var/tax_amt = FLOOR(gross * rate, 1)
	if(tax_amt > 0)
		SStreasury.apply_concordat_tithe(gross, TAX_CATEGORY_HEADEATER_LEVY, src.name)
		SStreasury.bank_accounts[user] -= tax_amt
		SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "Headeater Levy")
		record_round_statistic(STATS_REVENUE_HEADEATER_LEVY, tax_amt)
		record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
		record_featured_stat(FEATURED_STATS_TAX_PAYERS, user, tax_amt)
	return gross - tax_amt

/obj/structure/roguemachine/headeater/proc/eathead(obj/item/H, mob/user, supress_message = FALSE, paynow = TRUE)
	var/sellprice = 0
	if(istype(H, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/E = H
		sellprice = E.sellprice
	else if(istype(H, /obj/item/natural/head))
		var/obj/item/natural/head/A = H
		sellprice = A.sellprice
	else
		return
	if(sellprice <= 0)
		return
	if(paynow)
		var/net = payout(user, sellprice)
		if(!supress_message)
			var/levy = sellprice - net
			if(levy > 0)
				to_chat(user, span_danger("the [src] consumes [H], crediting [net] mammons to your account, less [levy] mammon to the Crown's Levy."))
			else
				to_chat(user, span_danger("the [src] consumes [H], crediting [sellprice] mammons to your account."))
	else
		topay += sellprice
	qdel(H)

/obj/structure/roguemachine/headeater/attack_right(mob/user)
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("[src] refuses to process bounties without a registered account. Visit a Nervelock."))
		return
	if(ishuman(user))
		for(var/obj/I in get_turf(src))
			if(istype(I, /obj/item/natural/head))
				eathead(I, user, TRUE, FALSE)
			if(istype(I, /obj/item/bodypart/head))
				eathead(I, user, TRUE, FALSE)
	if(topay > 0)
		topay = round(topay)
		var/net = payout(user, topay)
		var/levy = topay - net
		if(levy > 0)
			to_chat(user, span_danger("The [src] credits [net] mammons to your account, less [levy] mammon to the Crown's Levy."))
		else
			to_chat(user, span_danger("The [src] credits [net] mammons to your account."))
		topay = 0
