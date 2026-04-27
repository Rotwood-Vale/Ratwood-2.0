/*
	THE TAXMAN
	The Gutter King's crew owes a debt to the Kingsfield Syndicate each round.
	Each Scum member adds underbelly_debt_per_head mammon to the collective tab.
	The tab scales up and down as Scum join and leave.
	Insert coin to pay it down before the round ends.

	Mapper: place one in the Underbelly base. The debt is faction-wide.
*/

GLOBAL_VAR_INIT(underbelly_debt_paid, 0)
GLOBAL_VAR_INIT(underbelly_roundend_registered, FALSE)

///Returns total mammon owed based on faction headcount. Tiers escalate faster than headcount.
/proc/_underbelly_get_debt(scum_count)
	if(scum_count <= 0)
		return 0
	if(scum_count <= 3)
		return 250 * scum_count + 250  // 500 / 750 / 1000
	if(scum_count <= 6)
		return 650 * scum_count        // 2600 / 3250 / 3900
	if(scum_count <= 10)
		return 700 * scum_count        // 4900 → 7000
	return 1000 * scum_count           // 11000+

/obj/structure/roguemachine/taxman
	name = "The Taxman"
	desc = "A squat gold machine box fitted with a coin slot and a tally window. The number on the window is never enough."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "goldvendor"
	density = TRUE
	anchored = TRUE
	max_integrity = 999

/obj/structure/roguemachine/taxman/Initialize(mapload)
	. = ..()
	GLOB.underbelly_debt_paid = 0
	if(!GLOB.underbelly_roundend_registered)
		GLOB.underbelly_roundend_registered = TRUE
		SSticker.OnRoundend(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_underbelly_debt_roundend)))

/obj/structure/roguemachine/taxman/attack_hand(mob/user, list/modifiers)
	if(!isliving(user) || !HAS_TRAIT(user, TRAIT_UNDERBELLY_SCUM))
		to_chat(user, span_warning("This means nothing to you."))
		return
	var/scum_count = _underbelly_count_scum()
	var/owed = _underbelly_get_debt(scum_count)
	var/remaining = max(0, owed - GLOB.underbelly_debt_paid)
	if(remaining <= 0)
		to_chat(user, span_notice("The Taxman is satisfied. [GLOB.underbelly_debt_paid] of [owed] mammon paid. The debt is clear."))
	else
		to_chat(user, span_warning("Debt: [owed] mammon owed ([scum_count] head\s on the roll). [GLOB.underbelly_debt_paid] paid. [remaining] remaining."))

/obj/structure/roguemachine/taxman/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/roguecoin))
		return ..()
	var/obj/item/roguecoin/C = I
	var/value = C.get_real_price()
	if(!value)
		to_chat(user, span_warning("The slot rejects it."))
		return
	GLOB.underbelly_debt_paid += value
	playsound(loc, 'sound/misc/coininsert.ogg', 80, FALSE, -1)
	var/scum_count = _underbelly_count_scum()
	var/remaining = max(0, _underbelly_get_debt(scum_count) - GLOB.underbelly_debt_paid)
	if(remaining <= 0)
		to_chat(user, span_notice("[value] mammon accepted. The debt is paid."))
	else
		to_chat(user, span_notice("[value] mammon accepted. [remaining] mammon still owed."))
	qdel(C)

/proc/_underbelly_count_scum()
	var/count = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
			count++
	return count

/proc/_underbelly_debt_roundend()
	GLOB.underbelly_roundend_registered = FALSE
	var/scum_count = _underbelly_count_scum()
	if(!scum_count)
		return
	var/owed = _underbelly_get_debt(scum_count)
	var/paid = GLOB.underbelly_debt_paid
	// Partial payment tiers — 100% full reward, 75%+ one tier down, 50%+ two tiers down, <50% redtext only
	var/pay_ratio = owed > 0 ? (paid / owed) : 0
	var/base_tier  // 1=easy 2=medium 3=hard 4=expert
	if(scum_count <= 3)
		base_tier = 1
	else if(scum_count <= 6)
		base_tier = 2
	else if(scum_count <= 10)
		base_tier = 3
	else
		base_tier = 4

	var/effective_tier
	if(pay_ratio >= 1.0)
		effective_tier = base_tier
	else if(pay_ratio >= 0.75)
		effective_tier = max(1, base_tier - 1)
	else if(pay_ratio >= 0.5)
		effective_tier = max(1, base_tier - 2)
	else
		effective_tier = 0

	if(effective_tier)
		var/triumphs
		var/pq
		switch(effective_tier)
			if(1)
				triumphs = 10
				pq = 0.1
			if(2)
				triumphs = 15
				pq = 0.3
			if(3)
				triumphs = 20
				pq = 0.5
			if(4)
				triumphs = 25
				pq = 1.0
		if(pay_ratio >= 1.0)
			to_chat(world, span_greentext("The Underbelly has paid off their debt to Kingsfield's Crime Syndicate!"))
		else
			to_chat(world, span_greentext("The Underbelly paid [round(pay_ratio * 100)]% of their debt to Kingsfield. The Syndicate is somewhat satisfied."))
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(!HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
				continue
			H.adjust_triumphs(triumphs)
			if(H.ckey)
				adjust_playerquality(pq, H.ckey)
			to_chat(H, span_greentext("The Syndicate is satisfied. +[triumphs] Triumph\s awarded."))
	else
		var/shortfall = owed - paid
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(!HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
				continue
			to_chat(H, span_redtext("The Kingsfield Syndicate notes your failure. [shortfall] mammon unpaid of [owed] owed. They will remember."))

	// GK bonus — +1 Triumph per 2 living Scum (rounded up), fires if at least 50% was paid
	if(pay_ratio >= 0.5)
		var/gk_bonus = round(scum_count / 2 + 0.5)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.job != "Gutter King")
				continue
			H.adjust_triumphs(gk_bonus)
			to_chat(H, span_greentext("Your crew delivered. +[gk_bonus] Triumph\s for growing the operation."))
