/*
	RIPPER INCOME SYSTEMS

	Two loops that give the Ripper active ways to earn coin:

	1. Sick Patient - an injured NPC spawns periodically in the Underbelly.
	   Only a Ripper can treat them. Apply medical supplies until the wounds close
	   and the patient pays out. Leaves after being healed.
	   Mapper: place /obj/effect/landmark/patient_spot in accessible Underbelly areas.

	2. Supply Board - a structure placed near Ripper spawn. Posts 3 rotating supply
	   requests every 25 minutes. Ripper hands matching items to the board for per-unit coin.
	   Mapper: place /obj/structure/underbelly_supply_board in the Ripper's area.
*/

// =====================================================
// SICK PATIENT
// =====================================================

GLOBAL_VAR(underbelly_patient_ward)

/obj/effect/landmark/patient_spot
	name = "patient spot"
	invisibility = INVISIBILITY_OBSERVER

/obj/effect/landmark/patient_spot/Initialize(mapload)
	. = ..()
	if(!GLOB.underbelly_patient_ward)
		GLOB.underbelly_patient_ward = new /datum/underbelly_patient_ward()

/datum/underbelly_patient_ward
	var/list/active_patients = list()

/datum/underbelly_patient_ward/New()
	addtimer(CALLBACK(src, PROC_REF(spawn_wave)), rand(20 MINUTES, 40 MINUTES))

/datum/underbelly_patient_ward/proc/spawn_wave(schedule_next = TRUE)
	for(var/mob/M in active_patients)
		if(!QDELETED(M))
			qdel(M)
	active_patients.Cut()

	var/list/spots = list()
	for(var/obj/effect/landmark/patient_spot/L in GLOB.landmarks_list)
		spots += L
	if(!spots.len)
		if(schedule_next)
			addtimer(CALLBACK(src, PROC_REF(spawn_wave)), rand(20 MINUTES, 40 MINUTES))
		return

	var/obj/effect/landmark/patient_spot/chosen = pick(spots)
	var/mob/living/carbon/human/species/human/northern/underbelly_patient/P = new(chosen.loc)
	active_patients += P

	for(var/client/C in GLOB.clients)
		if(!C.mob || !istype(C.mob, /mob/living/carbon/human))
			continue
		var/mob/living/carbon/human/H = C.mob
		if(H.job == "Ripper" && H.stat == CONSCIOUS)
			to_chat(H, span_warning("Word comes through the pipes: someone's bleeding out in the Underbelly. Find them before they go cold."))

	if(schedule_next)
		addtimer(CALLBACK(src, PROC_REF(spawn_wave)), rand(20 MINUTES, 40 MINUTES))

/datum/underbelly_patient_ward/proc/debug_spawn_now()
	for(var/mob/M in active_patients)
		if(!QDELETED(M))
			qdel(M)
	active_patients.Cut()

	var/list/spots = list()
	for(var/obj/effect/landmark/patient_spot/L in GLOB.landmarks_list)
		spots += L
	if(!spots.len)
		return

	var/obj/effect/landmark/patient_spot/chosen = pick(spots)
	var/mob/living/carbon/human/species/human/northern/underbelly_patient/P = new(chosen.loc)
	active_patients += P

	for(var/client/C in GLOB.clients)
		if(!C.mob || !istype(C.mob, /mob/living/carbon/human))
			continue
		var/mob/living/carbon/human/H = C.mob
		if(H.job == "Ripper" && H.stat == CONSCIOUS)
			to_chat(H, span_warning("Word comes through the pipes: someone's bleeding out in the Underbelly. Find them before they go cold."))

/client/verb/spawn_underbelly_test_patient()
	set name = "Spawn Underbelly Test Patient"
	set category = "Debug"
	if(!holder)
		return
	if(!GLOB.underbelly_patient_ward)
		GLOB.underbelly_patient_ward = new /datum/underbelly_patient_ward()
	var/datum/underbelly_patient_ward/W = GLOB.underbelly_patient_ward
	if(W)
		W.debug_spawn_now()
	to_chat(src, span_notice("Spawned an underbelly test patient."))

// =====================================================

/mob/living/carbon/human/species/human/northern/underbelly_patient
	name = "a wounded figure"
	wander = FALSE
	aggressive = 0
	mode = NPC_AI_IDLE
	flee_in_pain = FALSE
	rude = FALSE
	ambushable = FALSE
	possible_rmb_intents = list()
	faction = list("station")

	///ckey of the Ripper currently treating this patient - locked in on first treatment.
	var/treating_ckey
	///TRUE once the payout fires - prevents double pay.
	var/paid_out = FALSE
	///world.time when this patient expires if untreated.
	var/expire_at = 0
	///TRUE once extra treatment time has been granted.
	var/bonus_time_granted = FALSE
	///TRUE once an active-treatment grace extension has been used.
	var/treatment_grace_used = FALSE
	///TRUE once ozium has been used to buy extra time.
	var/ozium_used = FALSE
	///Pinned patient alias so after_creation can't randomize it.
	var/patient_alias

/mob/living/carbon/human/species/human/northern/underbelly_patient/Initialize(mapload)
	. = ..()
	set_species(/datum/species/human/northern)
	patient_alias = pick("a wounded Scum", "a bloodied vagrant", "a gutted figure", "a clutching wretch")
	real_name = patient_alias
	name = patient_alias
	SetKnockdown(100000, TRUE, TRUE)
	ADD_TRAIT(src, TRAIT_NODEATH, "underbelly_patient")
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, "underbelly_patient")
	expire_at = world.time + (3 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(_apply_patient_state)), 0)
	addtimer(CALLBACK(src, PROC_REF(_seed_wounds)), 0)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(idle_groan)), rand(10, 25) SECONDS)
	addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(check_despawn)), 3 MINUTES)

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_apply_patient_state()
	if(QDELETED(src))
		return
	set_resting(TRUE, TRUE)

/mob/living/carbon/human/species/human/northern/underbelly_patient/after_creation()
	..()
	if(!patient_alias)
		patient_alias = pick("a wounded Scum", "a bloodied vagrant", "a gutted figure", "a clutching wretch")
	fully_replace_character_name(null, patient_alias)
	name_override = patient_alias
	if(dna)
		dna.real_name = patient_alias

/mob/living/carbon/human/species/human/northern/underbelly_patient/set_resting(rest, silent = TRUE)
	return ..(TRUE, TRUE)

/mob/living/carbon/human/species/human/northern/underbelly_patient/update_mobility()
	. = ..()
	resting = TRUE
	lying = 90
	mobility_flags &= ~(MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_CANSTAND)

/mob/living/carbon/human/species/human/northern/underbelly_patient/resist_buckle()
	return

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_seed_wounds()
	adjustBruteLoss(rand(180, 240))
	blood_volume = max(0, blood_volume - rand(260, 360))
	var/list/zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	for(var/zone in zones)
		apply_damage(rand(20, 35), BRUTE, zone)
		var/obj/item/bodypart/BP = get_bodypart(zone)
		if(!BP)
			continue
		for(var/i = 1 to rand(1, 2))
			BP.bodypart_attacked_by(BCLASS_CUT, rand(45, 70), null, zone)

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_is_stable()
	if(getBruteLoss() > 35)
		return FALSE
	if(get_bleed_rate() > 0)
		return FALSE
	if(length(get_sewable_wounds()))
		return FALSE
	return TRUE

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_can_get_bonus_time()
	var/artery_count = 0
	for(var/datum/wound/W as anything in get_wounds())
		if(istype(W, /datum/wound/artery))
			artery_count++
	if(artery_count > 1)
		return FALSE
	if(get_bleed_rate() > 12)
		return FALSE
	return TRUE

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_find_treater()
	for(var/client/C in GLOB.clients)
		if(!C.mob || !istype(C.mob, /mob/living/carbon/human))
			continue
		var/mob/living/carbon/human/H = C.mob
		if(H.ckey == treating_ckey && H.job == "Ripper" && H.stat != DEAD)
			return H
	return null

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/treatment_tick()
	if(QDELETED(src) || paid_out)
		return
	if(!bonus_time_granted && treating_ckey && _can_get_bonus_time())
		bonus_time_granted = TRUE
		expire_at += 3 MINUTES
		var/mob/living/carbon/human/H_bonus = _find_treater()
		if(H_bonus)
			to_chat(H_bonus, span_notice("[src]'s bleeding is under control. You've bought 3 more minutes."))
	if(world.time >= expire_at)
		if(treating_ckey && !treatment_grace_used)
			treatment_grace_used = TRUE
			expire_at = world.time + (90 SECONDS)
			var/mob/living/carbon/human/H_warn = _find_treater()
			if(H_warn)
				to_chat(H_warn, span_danger("[src] is fading fast - finish up!"))
			addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 3 SECONDS)
		else
			check_despawn()
		return
	if(treating_ckey && _is_stable())
		if(stat != CONSCIOUS)
			SetKnockdown(0)
			stat = CONSCIOUS
		var/mob/living/carbon/human/H = _find_treater()
		if(H)
			_payout(H)
		else
			_payout(null)
		return
	addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 3 SECONDS)

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/idle_groan()
	if(QDELETED(src) || paid_out || stat != CONSCIOUS)
		return
	say(pick(
		"...help...",
		"*groans in pain",
		"Someone... please...",
		"It hurts...",
		"*clutches a wound",
	))
	addtimer(CALLBACK(src, PROC_REF(idle_groan)), rand(20, 40) SECONDS)

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/check_despawn()
	if(QDELETED(src))
		return
	if(paid_out)
		qdel(src)
		return
	if(world.time < expire_at)
		addtimer(CALLBACK(src, PROC_REF(check_despawn)), max(1 SECONDS, expire_at - world.time))
		return
	if(treating_ckey && !treatment_grace_used)
		treatment_grace_used = TRUE
		expire_at = world.time + (90 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(check_despawn)), 90 SECONDS)
		var/mob/living/carbon/human/H_warn = _find_treater()
		if(H_warn)
			to_chat(H_warn, span_danger("[src] is fading fast - finish up!"))
		return
	REMOVE_TRAIT(src, TRAIT_NODEATH, "underbelly_patient")
	REMOVE_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, "underbelly_patient")
	visible_message(span_warning("[src] slumps and goes still. Too late."))
	qdel(src)

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_heal_value(obj/item/I)
	return 0

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_spawn_coin_payout(atom/where, payout_mammon)
	if(payout_mammon <= 0 || !where)
		return
	var/gold = FLOOR(payout_mammon / 10, 1)
	var/silver = FLOOR((payout_mammon % 10) / 5, 1)
	var/copper = payout_mammon % 5
	if(gold)
		new /obj/item/roguecoin/gold(where, gold)
	if(silver)
		new /obj/item/roguecoin/silver(where, silver)
	if(copper)
		new /obj/item/roguecoin/copper(where, copper)

/mob/living/carbon/human/species/human/northern/underbelly_patient/attackby(obj/item/I, mob/living/user, params)
	if(paid_out || !istype(user, /mob/living/carbon/human))
		return ..()
	var/mob/living/carbon/human/H = user
	if(H.job != "Ripper")
		to_chat(H, span_warning("[src] weakly waves you off."))
		return TRUE
	if(treating_ckey && treating_ckey != H.ckey)
		to_chat(H, span_warning("Another Ripper's already on this one."))
		return TRUE
	treating_ckey = H.ckey
	if(istype(I, /obj/item/rogueweapon/surgery) || istype(I, /obj/item/needle))
		addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 1 SECONDS)
		return ..()
	var/liquid_heal = 0
	if(I.reagents)
		if(I.reagents.has_reagent(/datum/reagent/water, 1))
			I.reagents.remove_reagent(/datum/reagent/water, 10)
			blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume + 45)
			liquid_heal += 6
		if(I.reagents.has_reagent(/datum/reagent/medicine/healthpot, 1))
			I.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 8)
			blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume + 75)
			liquid_heal += 18
		if(!ozium_used && I.reagents.has_reagent(/datum/reagent/ozium, 1))
			I.reagents.remove_reagent(/datum/reagent/ozium, 5)
			ozium_used = TRUE
			expire_at += 2 MINUTES
			visible_message(span_notice("[H] doses [src] with ozium. [src]'s still breathing."))
			to_chat(H, span_notice("Ozium bought 2 more minutes. Use it."))
			addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 1 SECONDS)
			return TRUE
	if(liquid_heal)
		adjustBruteLoss(-liquid_heal)
		visible_message(span_notice("[H] coaxes [src] to drink."))
		addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 1 SECONDS)
		return TRUE
	var/heal = _heal_value(I)
	if(!heal)
		to_chat(H, span_warning("[src] needs real treatment. Use surgery tools, water, or health potions to stabilize them."))
		return TRUE
	adjustBruteLoss(-heal)
	qdel(I)
	visible_message(span_notice("[H] tends to [src]'s wounds."))
	addtimer(CALLBACK(src, PROC_REF(treatment_tick)), 1 SECONDS)
	return TRUE

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_payout(mob/living/carbon/human/H)
	paid_out = TRUE
	REMOVE_TRAIT(src, TRAIT_NODEATH, "underbelly_patient")
	REMOVE_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, "underbelly_patient")
	blood_volume = max(blood_volume, BLOOD_VOLUME_NORMAL)
	SetKnockdown(0)
	if(stat != CONSCIOUS)
		stat = CONSCIOUS
	var/payout_mammon = rand(80, 140)
	if(H)
		_spawn_coin_payout(H.loc, payout_mammon)
	else
		_spawn_coin_payout(get_turf(src), payout_mammon)
	say(pick(
		"You've got steady hands. Here.",
		"Didn't think anyone would come. Take it.",
		"Don't ask where the coin's from.",
		"*presses a handful of coins into your hands",
	))
	wander = FALSE
	density = FALSE
	visible_message(span_notice("[src] drags [p_them()]self back into the pipework."))
	QDEL_IN(src, 6 SECONDS)

/mob/living/carbon/human/species/human/northern/underbelly_patient/proc/_despawn()
	if(!QDELETED(src))
		qdel(src)


/mob/living/carbon/human/species/human/northern/underbelly_patient/human_modular_examine_extension(mob/user, observer_privilege, m1, m2, m3)
	. = ..()
	if(!.)
		. = list()
	if(!istype(user, /mob/living/carbon/human))
		return .
	if(paid_out)
		. += span_notice("They're patched up. The job's done.")
		return .
	var/seconds_left = max(0, (expire_at - world.time) / 10)
	var/estimate
	if(seconds_left > 120)
		estimate = "a few minutes"
	else if(seconds_left > 60)
		estimate = "about a minute"
	else if(seconds_left > 30)
		estimate = "half a minute, maybe"
	else if(seconds_left > 0)
		estimate = "seconds - move fast"
	else
		estimate = "none - they're on borrowed time"
	. += span_warning("Time left: [estimate].")
	return .

// =====================================================
// SUPPLY BOARD
// =====================================================

GLOBAL_VAR(underbelly_supply_board_datum)

/obj/structure/underbelly_supply_board
	name = "supply board"
	desc = "A scrawled board covered in unsigned requests. Someone needs things, and they're paying quietly."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "noticeboard1"
	density = TRUE
	anchored = TRUE

/obj/structure/underbelly_supply_board/Initialize(mapload)
	. = ..()
	if(!GLOB.underbelly_supply_board_datum)
		GLOB.underbelly_supply_board_datum = new /datum/underbelly_supply_orders()

/obj/structure/underbelly_supply_board/examine(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.job != "Ripper")
		to_chat(H, span_warning("The scrawled notes mean nothing to you."))
		return
	var/datum/underbelly_supply_orders/D = GLOB.underbelly_supply_board_datum
	if(D)
		D.sanitize_orders()
		D.show_to(H)

/obj/structure/underbelly_supply_board/attackby(obj/item/I, mob/living/user, params)
	if(!istype(user, /mob/living/carbon/human))
		return ..()
	var/mob/living/carbon/human/H = user
	if(H.job != "Ripper")
		to_chat(H, span_warning("This board isn't for you."))
		return
	var/datum/underbelly_supply_orders/D = GLOB.underbelly_supply_board_datum
	if(D)
		D.try_fulfill(H, I)

// =====================================================

/datum/underbelly_supply_orders
	var/list/active_orders = list()
	///world.time when the next refresh fires.
	var/next_refresh = 0

/datum/underbelly_supply_orders/New()
	roll_orders()
	addtimer(CALLBACK(src, PROC_REF(refresh_tick)), 25 MINUTES)

/datum/underbelly_supply_orders/proc/_spawn_coin_payout(atom/where, payout_mammon)
	if(payout_mammon <= 0 || !where)
		return
	var/gold = FLOOR(payout_mammon / 10, 1)
	var/silver = FLOOR((payout_mammon % 10) / 5, 1)
	var/copper = payout_mammon % 5
	if(gold)
		new /obj/item/roguecoin/gold(where, gold)
	if(silver)
		new /obj/item/roguecoin/silver(where, silver)
	if(copper)
		new /obj/item/roguecoin/copper(where, copper)

/datum/underbelly_supply_orders/proc/_format_coin_payout(payout_mammon)
	if(payout_mammon <= 0)
		return "no coin"
	var/list/chunks = list()
	var/gold = FLOOR(payout_mammon / 10, 1)
	var/silver = FLOOR((payout_mammon % 10) / 5, 1)
	var/copper = payout_mammon % 5
	if(gold)
		chunks += "[gold] gold"
	if(silver)
		chunks += "[silver] silver"
	if(copper)
		chunks += "[copper] copper"
	return english_list(chunks)

/datum/underbelly_supply_orders/proc/roll_orders()
	active_orders.Cut()
	var/list/pool = list(
		list("type" = /obj/item/reagent_containers/glass/bottle/rogue/healthpot,  "label" = "Red Elixir",      "payout" = 28,  "qty" = 4),
		list("type" = /obj/item/reagent_containers/glass/bottle/rogue/antidote,   "label" = "Antitoxin",       "payout" = 9,   "qty" = 5),
		list("type" = /obj/item/reagent_containers/glass/bottle/rogue/manapot,    "label" = "Blue Elixir",     "payout" = 18,  "qty" = 4),
		list("type" = /obj/item/reagent_containers/powder/herozium,               "label" = "Herozium",        "payout" = 55,  "qty" = 2),
		list("type" = /obj/item/reagent_containers/powder/spice,                  "label" = "Spice",           "payout" = 45,  "qty" = 3),
		list("type" = /obj/item/reagent_containers/powder/moondust,               "label" = "Moon Dust",       "payout" = 30,  "qty" = 3),
		list("type" = /obj/item/natural/bundle/cloth/bandage/full,                "label" = "Bandage Bundles", "payout" = 5,   "qty" = 5),
		list("type" = /obj/item/reagent_containers/glass/bottle/rogue/stampot,    "label" = "Green Elixir",    "payout" = 55,  "qty" = 2),
	)
	var/list/shuffled = shuffle(pool.Copy())
	for(var/i = 1 to min(3, shuffled.len))
		var/list/entry = shuffled[i]
		active_orders += list(list(
			"type"      = entry["type"],
			"label"     = entry["label"],
			"payout"    = entry["payout"],
			"remaining" = entry["qty"],
			"total"     = entry["qty"],
		))
	next_refresh = world.time + (25 MINUTES)

/datum/underbelly_supply_orders/proc/sanitize_orders()
	for(var/list/O in active_orders.Copy())
		if(O["type"] == /obj/item/reagent_containers/glass/bottle/rogue/blood_red || O["type"] == /obj/item/reagent_containers/glass/bottle/rogue/voss_serum)
			active_orders -= O

/datum/underbelly_supply_orders/proc/refresh_tick()
	roll_orders()
	sanitize_orders()
	addtimer(CALLBACK(src, PROC_REF(refresh_tick)), 25 MINUTES)
	for(var/client/C in GLOB.clients)
		if(!C.mob || !istype(C.mob, /mob/living/carbon/human))
			continue
		var/mob/living/carbon/human/H = C.mob
		if(H.job == "Ripper" && H.stat == CONSCIOUS)
			to_chat(H, span_notice("The supply board has new requests up."))

/datum/underbelly_supply_orders/proc/show_to(mob/living/carbon/human/H)
	var/secs = max(0, round((next_refresh - world.time) / 10))
	var/msg = "<b>Supply Board - Active Requests</b><br>"
	msg += "<font color='gray'>Refreshes in [floor(secs / 60)]m [secs % 60]s</font><br><hr>"
	if(!active_orders.len)
		msg += "<i>All orders filled. New ones soon.</i>"
	else
		for(var/list/O in active_orders)
			msg += "<b>[O["label"]]</b> - [O["remaining"]]/[O["total"]] remaining - [_format_coin_payout(O["payout"])] each<br>"
	to_chat(H, msg)

/datum/underbelly_supply_orders/proc/try_fulfill(mob/living/carbon/human/H, obj/item/I)
	for(var/list/O in active_orders)
		if(!istype(I, O["type"]))
			continue
		var/payout = O["payout"]
		qdel(I)
		_spawn_coin_payout(get_turf(H), payout)
		to_chat(H, span_notice("Order accepted: [O["label"]]. Payout: [_format_coin_payout(payout)]."))
		O["remaining"] -= 1
		if(O["remaining"] <= 0)
			active_orders -= O
			to_chat(H, span_notice("That order is now filled."))
		return
	to_chat(H, span_warning("Nothing on the board wants that right now."))
