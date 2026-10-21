// Rebel Hermes support: head rebels request supplies and favors from rival duchies.
//
// Gate:     /datum/antagonist/prebel/head
// Access:   right-click a HERMES with no coin loaded (see the mail.dm patches)
// Currency: "rebel funds", held on the rebel team.
// Tiers:    the rebellion level (from how many rebels are alive) gates what can be bought and
//           how many nobles may be recruited to the cause.
//
// Only item paths that already appear in the uploaded files are used below. Add your own
// militia weapons and other wares as new /datum/rebel_ware subtypes.
// ---------------------------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------------------------

/proc/get_rebel_team()
	for(var/datum/antagonist/prebel/head/H in GLOB.antagonists)
		if(H.owner && H.rev_team)
			return H.rev_team
	return null

/proc/is_rebel_head(mob/user)
	return user?.mind?.has_antag_datum(/datum/antagonist/prebel/head) ? TRUE : FALSE

/// Whether a rebel speech may recruit this noble: needs a free noble slot from a Letter of
/// Patronage. The Lord and foreign nobility are never recruitable.
/proc/rebel_can_recruit_noble(datum/mind/M)
	var/datum/team/prebels/T = get_rebel_team()
	if(!T || T.noble_slots <= 0)
		return FALSE
	if(M.assigned_role in GLOB.foreign_positions)
		return FALSE
	if(M.current && M.current == SSticker.rulermob)
		return FALSE
	return TRUE

/// Funds from the Lord's misfortune, announced privately to the rebel leaders.
/proc/rebel_windfall(amount, reason)
	var/datum/team/prebels/T = get_rebel_team()
	if(!T || amount <= 0)
		return
	T.accrue_funds()
	T.funds += amount
	for(var/datum/mind/M in T.members)
		if(M.current && M.has_antag_datum(/datum/antagonist/prebel/head))
			to_chat(M.current, span_boldnotice("[reason] Rival duchies have sent word: [amount] funds are now available through the Hermes."))

// ---------------------------------------------------------------------------------------------
// Team state
// ---------------------------------------------------------------------------------------------

/datum/team/prebels
	var/funds = REBEL_FUNDS_START
	/// Nobles the rebels may still recruit (bought with a Letter of Patronage).
	var/noble_slots = 0
	/// Wares bought so far this round, keyed by ware type.
	var/list/bought = list()
	var/last_accrual

/datum/team/prebels/New(starting_members)
	. = ..()
	last_accrual = world.time

/datum/team/prebels/proc/get_living_members()
	var/n = 0
	for(var/datum/mind/M in members)
		if(considered_alive(M))
			n++
	return n

/// 1 to 3, from how many rebels are alive.
/datum/team/prebels/proc/get_level()
	var/n = get_living_members()
	if(n >= REBEL_LEVEL3_MEMBERS)
		return 3
	if(n >= REBEL_LEVEL2_MEMBERS)
		return 2
	return 1

/// Trickle income: funds per living rebel per period, credited lazily when the Hermes is used.
/datum/team/prebels/proc/accrue_funds()
	var/periods = round((world.time - last_accrual) / REBEL_FUNDS_PERIOD)
	if(periods <= 0)
		return
	last_accrual += periods * REBEL_FUNDS_PERIOD
	funds += periods * get_living_members() * REBEL_FUNDS_PER_MEMBER

/datum/team/prebels/proc/add_funds(amount)
	if(amount <= 0)
		return
	accrue_funds()
	funds += amount

/datum/team/prebels/proc/can_buy(datum/rebel_ware/W)
	if(get_level() < W.min_level)
		return FALSE
	if(funds < W.cost)
		return FALSE
	if(W.maximum && (bought[W.type] || 0) >= W.maximum)
		return FALSE
	return TRUE

// ---------------------------------------------------------------------------------------------
// Catalog
// ---------------------------------------------------------------------------------------------

/datum/rebel_ware
	var/name = "Supplies"
	var/desc = ""
	var/cost = 0
	var/min_level = 1
	/// Total purchasable per round. 0 = unlimited.
	var/maximum = 0
	/// Spawned at the Hermes after a short delay.
	var/list/item_types = list()
	/// Noble recruitment slots granted on purchase.
	var/noble_slots = 0

/// Runs after payment.
/datum/rebel_ware/proc/on_purchase(mob/user, datum/team/prebels/T)
	if(noble_slots)
		T.noble_slots += noble_slots
		to_chat(user, span_notice("Word spreads among the disaffected nobility. I may now recruit up to [noble_slots] noble(s) to the cause with my speech."))

GLOBAL_LIST_INIT(rebel_wares, init_rebel_wares())

/proc/init_rebel_wares()
	var/list/out = list()
	for(var/path in subtypesof(/datum/rebel_ware))
		out[path] = new path()
	return out

// Level 1: smuggled basics
/datum/rebel_ware/powder_kegs
	name = "Smuggled BlastPowder"
	desc = "Sticks of blasting powder, run in past the garrison."
	cost = 4
	min_level = 1
	maximum = 3
	item_types = list(/obj/item/tntstick, /obj/item/tntstick)

/datum/rebel_ware/bottle_bombs
	name = "Bottle bombs"
	desc = "Armor is irrelevant- Everyone burns the same."
	cost = 2
	min_level = 1
	maximum = 6
	item_types = list(/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/bomb,
	/obj/item/bomb,)

/datum/rebel_ware/health_potions
	name = "Health Potions"
	desc = "Health potions from abroad."
	cost = 3
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpot,)

/datum/rebel_ware/militia_spears
	name = "Militia spears"
	desc = "Converted pitchforks and hoes into weapons of peasantry"
	cost = 3
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/rogueweapon/spear/militia,
	/obj/item/rogueweapon/spear/militia,
	/obj/item/rogueweapon/spear/militia,)

/datum/rebel_ware/militia_axes
	name = "Militia war axe"
	desc = "Converted shovels into weapons of peasantry"
	cost = 3
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/rogueweapon/greataxe/militia,
	/obj/item/rogueweapon/greataxe/militia,
	/obj/item/rogueweapon/greataxe/militia,)

/datum/rebel_ware/militia_flail
	name = "Militia warflail"
	desc = "Converted threshers into weapons of peasantry"
	cost = 3
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/rogueweapon/flail/peasantwarflail,
	/obj/item/rogueweapon/flail/peasantwarflail,
	/obj/item/rogueweapon/flail/peasantwarflail,)

/datum/rebel_ware/militia_mace
	name = "Militia goedendag"
	desc = "A beastly club fashioned from tools, now weapons of peasantry"
	cost = 3
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/rogueweapon/woodstaff/militia,
	/obj/item/rogueweapon/woodstaff/militia,
	/obj/item/rogueweapon/woodstaff/militia)

/datum/rebel_ware/militia_pick
	name = "Militia war pick"
	desc = "Converted pickaxes into weapons of peasantry"
	cost = 3
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/rogueweapon/pick/militia,
	/obj/item/rogueweapon/pick/militia,
	/obj/item/rogueweapon/pick/militia)

/datum/rebel_ware/militia_gambeson
	name = "Gambesons for militia"
	desc = "Gambesons are suitable armor for a militia"
	cost = 2
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/clothing/suit/roguetown/armor/gambeson,
	/obj/item/clothing/suit/roguetown/armor/gambeson,
	/obj/item/clothing/suit/roguetown/armor/gambeson)

/datum/rebel_ware/padded_cap
	name = "Padded caps for militia"
	desc = "Armor minimal armor, but it's something."
	cost = 2
	min_level = 1
	maximum = 4
	item_types = list(/obj/item/clothing/head/roguetown/paddedcap,
	/obj/item/clothing/head/roguetown/paddedcap,
	/obj/item/clothing/head/roguetown/paddedcap,)

// Level 2: a growing rebellion earns foreign attention
/datum/rebel_ware/crossbow_kit
	name = "Foreign crossbows"
	desc = "A set of crossbows and bolt filled quivers."
	cost = 10
	min_level = 2
	maximum = 3
	item_types = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, /obj/item/quiver/bolts, /obj/item/quiver/bolts)

/datum/rebel_ware/impact_grenades
	name = "Impact Grenades"
	desc = "Contact explosives for breaking a line."
	cost = 12
	min_level = 2
	maximum = 3
	item_types = list(/obj/item/impact_grenade/explosion, /obj/item/impact_grenade/explosion)

/datum/rebel_ware/letter_of_patronage
	name = "Letter of Patronage"
	desc = "A rival duchy pledges to shelter a disaffected noble. Lets your speech recruit a noble."
	cost = 5
	min_level = 2
	maximum = 2
	noble_slots = 1

/datum/rebel_ware/mammon
	name = "Funds from abroad"
	desc = "Foreign funds sent from abroad."
	cost = 6
	min_level = 2
	maximum = 3
	item_types = list(/obj/item/roguecoin/silver/foreignsupport,
	/obj/item/roguecoin/silver/foreignsupport,
	/obj/item/roguecoin/silver/foreignsupport,
	/obj/item/roguecoin/silver/foreignsupport)

/datum/rebel_ware/heavy_gambeson
	name = "Padded gambesons for militia"
	desc = "A set of padded gambesons, hardened with extra layers."
	cost = 5
	min_level = 2
	maximum = 4
	item_types = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
	/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
	/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/rebel_ware/padded_hood
	name = "Padded leather hoods for militia"
	desc = "Armor minimal armor, but it's something."
	cost = 4
	min_level = 2
	maximum = 4
	item_types = list(/obj/item/clothing/head/roguetown/helmet/leather/armorhood,
	/obj/item/clothing/head/roguetown/helmet/leather/armorhood,
	/obj/item/clothing/head/roguetown/helmet/leather/armorhood,)

// Level 3: open support
/datum/rebel_ware/siege_bomb
	name = "Siege Bomb"
	desc = "A heavy charge for gates and walls."
	cost = 25
	min_level = 3
	maximum = 1
	item_types = list(/obj/item/satchel_bomb)

/datum/rebel_ware/killers_ice
	name = "Killers Ice"
	desc = "A near lethal poison."
	cost = 25
	min_level = 3
	maximum = 1
	item_types = list(/obj/item/reagent_containers/glass/bottle/rogue/poison)

// ---------------------------------------------------------------------------------------------
// Hermes interface
// ---------------------------------------------------------------------------------------------

/obj/structure/roguemachine/mail/proc/display_rebel_support(mob/user)
	var/datum/team/prebels/T = get_rebel_team()
	if(!T)
		return
	T.accrue_funds()
	var/contents = "<center>✤ ── WORD FROM RIVAL DUCHIES ── ✤<BR>"
	contents += "FUNDS: [T.funds] ── REBELLION LEVEL: [T.get_level()]<BR>"
	contents += "REBELS ALIVE: [T.get_living_members()]<BR>"
	contents += "(Level 2 at [REBEL_LEVEL2_MEMBERS] rebels, level 3 at [REBEL_LEVEL3_MEMBERS])<BR><BR>"
	var/list/sorted = list()
	for(var/path in GLOB.rebel_wares)
		var/datum/rebel_ware/W = GLOB.rebel_wares[path]
		var/i = 1
		while(i <= length(sorted))
			var/datum/rebel_ware/O = sorted[i]
			if(W.min_level < O.min_level || (W.min_level == O.min_level && W.cost < O.cost))
				break
			i++
		sorted.Insert(i, W)
	for(var/datum/rebel_ware/W in sorted)
		var/stock = ""
		if(W.maximum)
			stock = " ([max(0, W.maximum - (T.bought[W.type] || 0))]/[W.maximum] left)"
		var/line = "[uppertext(W.name)][stock] - cost [W.cost], level [W.min_level]"
		if(T.can_buy(W))
			contents += "<a href='?src=[REF(src)];rebel_buy=[W.type]' title='[W.desc]'>[line]</a><BR>"
		else
			contents += "[line]<BR>"
	contents += "</center>"
	var/datum/browser/popup = new(user, "REBELSUPPORT", "", 500, 600)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/mail/proc/rebel_support_buy(mob/user, path_text)
	if(!is_rebel_head(user))
		return
	var/datum/team/prebels/T = get_rebel_team()
	var/datum/rebel_ware/W = GLOB.rebel_wares[text2path(path_text)]
	if(!T || !W)
		return
	T.accrue_funds()
	if(!T.can_buy(W))
		to_chat(user, span_warning("That request cannot be made."))
		return display_rebel_support(user)
	T.funds -= W.cost
	T.bought[W.type] = (T.bought[W.type] || 0) + 1
	W.on_purchase(user, T)
	visible_message(span_warning("[user] sends something."))
	playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	if(length(W.item_types))
		addtimer(CALLBACK(src, PROC_REF(rebel_deliver), W), REBEL_DELIVERY_DELAY)
	log_game("REBEL SUPPORT: [key_name(user)] bought [W.name] for [W.cost] funds")
	return display_rebel_support(user)

/obj/structure/roguemachine/mail/proc/rebel_deliver(datum/rebel_ware/W)
	if(QDELETED(src))
		return
	playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	visible_message(span_warning("Something comes tumbling down from the HERMES."))
	for(var/path in W.item_types)
		new path(get_turf(src))
