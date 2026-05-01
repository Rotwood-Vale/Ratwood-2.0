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
GLOBAL_LIST_EMPTY(underbelly_debt_contributions)

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
	GLOB.underbelly_debt_contributions = list()
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
	if(isliving(user))
		var/mob/living/carbon/human/H = user
		var/contributor = H.real_name
		GLOB.underbelly_debt_contributions[contributor] = (GLOB.underbelly_debt_contributions[contributor] || 0) + value
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

	// Build top-3 contributor list sorted by amount
	var/list/sorted_names = list()
	for(var/name in GLOB.underbelly_debt_contributions)
		sorted_names += name
	// Bubble sort descending (at most a handful of names, perf is fine)
	for(var/i = 1 to sorted_names.len - 1)
		for(var/j = 1 to sorted_names.len - i)
			if(GLOB.underbelly_debt_contributions[sorted_names[j]] < GLOB.underbelly_debt_contributions[sorted_names[j+1]])
				var/tmp = sorted_names[j]
				sorted_names[j] = sorted_names[j+1]
				sorted_names[j+1] = tmp
	var/leaderboard = ""
	var/medals = list("1st", "2nd", "3rd")
	for(var/i = 1 to min(3, sorted_names.len))
		var/n = sorted_names[i]
		leaderboard += "\n  [medals[i]]: [n] — [GLOB.underbelly_debt_contributions[n]] mammon"

	if(effective_tier)
		var/triumphs
		var/pq
		switch(effective_tier)
			if(1)
				triumphs = 10
				pq = 0.5
			if(2)
				triumphs = 15
				pq = 1
			if(3)
				triumphs = 20
				pq = 2
			if(4)
				triumphs = 30
				pq = 3.5
		if(pay_ratio >= 1.0)
			to_chat(world, span_greentext("The Underbelly has paid off their [owed] mammon debt to Kingsfield's Crime Syndicate!"))
		else
			to_chat(world, span_greentext("The Underbelly paid [round(pay_ratio * 100)]% of their [owed] mammon debt to Kingsfield ([paid]/[owed]). The Syndicate is somewhat satisfied."))
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(!HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
				continue
			H.adjust_triumphs(triumphs)
			if(H.ckey)
				adjust_playerquality(pq, H.ckey)
			if(pay_ratio >= 1.0)
				to_chat(H, span_greentext("The Syndicate is satisfied. The [owed] mammon debt was paid in full. +[triumphs] Triumph\s awarded."))
			else
				to_chat(H, span_greentext("The Syndicate is somewhat satisfied. [round(pay_ratio * 100)]% of the [owed] mammon debt was paid ([paid]/[owed])."))
			if(leaderboard)
				to_chat(H, span_greentext("Top contributors:[leaderboard]"))
	else
		var/pct_paid = owed > 0 ? round((paid / owed) * 100) : 0
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(!HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
				continue
			to_chat(H, span_redtext("The Kingsfield Syndicate notes your failure. [owed] mammon was owed; only [pct_paid]% was paid ([paid]/[owed]). They will remember."))
			if(leaderboard)
				to_chat(H, span_redtext("What little was paid came from:[leaderboard]"))

	// GK bonus — +1 Triumph per 2 living Scum (rounded up), fires if at least 50% was paid
	if(pay_ratio >= 0.5)
		var/gk_bonus = round(scum_count / 2 + 0.5)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.job != "Gutter King")
				continue
			H.adjust_triumphs(gk_bonus)
			to_chat(H, span_greentext("Your crew delivered. +[gk_bonus] Triumph\s for growing the operation."))
