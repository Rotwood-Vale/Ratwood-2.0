#define CAPTURE_FACTION_KEEP "Keep"
#define CAPTURE_FACTION_OUTLANDERS "Outlanders"
#define CAPTURE_FACTION_CHURCH "Church"
#define CAPTURE_FACTION_PSYDON "Psydon"

#define CAPTURE_POINT_CHURCH "church"
#define CAPTURE_POINT_LOWTOWN "lowtown"
#define CAPTURE_POINT_HIGHTOWN "hightown"
#define CAPTURE_POINT_KEEP "keep"

#define CAPTURE_TICK_TIME 10 MINUTES
#define CAPTURE_TICK_VALUE 200
#define CAPTURE_WITHDRAW_PER_TICK 40

/datum/capture_point_data
	var/id
	var/owner_faction = CAPTURE_FACTION_KEEP
	var/pooled_mammon = 0
	var/last_tick_time = 0

/datum/capture_point_data/New(new_id)
	..()
	id = new_id
	last_tick_time = world.time

/datum/mind
	var/list/capture_withdrawals = list()

SUBSYSTEM_DEF(capturepoints)
	name = "capture points"
	wait = 10
	priority = FIRE_PRIORITY_WATER_LEVEL

	var/list/points = list()

/datum/controller/subsystem/capturepoints/Initialize()
	points[CAPTURE_POINT_CHURCH] = new /datum/capture_point_data(CAPTURE_POINT_CHURCH)
	points[CAPTURE_POINT_LOWTOWN] = new /datum/capture_point_data(CAPTURE_POINT_LOWTOWN)
	points[CAPTURE_POINT_HIGHTOWN] = new /datum/capture_point_data(CAPTURE_POINT_HIGHTOWN)
	points[CAPTURE_POINT_KEEP] = new /datum/capture_point_data(CAPTURE_POINT_KEEP)
	return ..()

/datum/controller/subsystem/capturepoints/fire(resumed = FALSE)
	for(var/point_id in points)
		var/datum/capture_point_data/P = points[point_id]
		if(!P)
			continue
		if(P.owner_faction == CAPTURE_FACTION_KEEP)
			continue
		if(world.time < P.last_tick_time + CAPTURE_TICK_TIME)
			continue

		P.last_tick_time = world.time

		if(SStreasury.treasury_value >= CAPTURE_TICK_VALUE)
			SStreasury.treasury_value -= CAPTURE_TICK_VALUE
			P.pooled_mammon += CAPTURE_TICK_VALUE
			SStreasury.log_to_steward("-[CAPTURE_TICK_VALUE] mammon diverted to [P.id] under [P.owner_faction] control.")
		else
			SStreasury.log_to_steward("Treasury too poor to fund [P.id] under [P.owner_faction] control.")

/datum/controller/subsystem/capturepoints/proc/set_owner(point_id, new_faction)
	var/datum/capture_point_data/P = points[point_id]
	if(!P)
		return FALSE
	P.owner_faction = new_faction
	P.last_tick_time = world.time
	return TRUE

/datum/controller/subsystem/capturepoints/proc/get_point(point_id)
	return points[point_id]

/datum/controller/subsystem/capturepoints/proc/withdraw_from_point(point_id, amount)
	var/datum/capture_point_data/P = points[point_id]
	if(!P)
		return FALSE
	if(amount < 1)
		return FALSE
	if(P.pooled_mammon < amount)
		return FALSE
	P.pooled_mammon -= amount
	return TRUE

/obj/structure/roguemachine/capturepoint
	name = "district capture point"
	desc = "A mechanism through which a district may be claimed."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	anchored = TRUE

	var/point_id = CAPTURE_POINT_LOWTOWN

/obj/structure/roguemachine/capturepoint/Initialize()
	. = ..()
	update_appearance()

/obj/structure/roguemachine/capturepoint/examine(mob/user)
	. = ..()
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(P)
		. += span_notice("District: [P.id].")
		. += span_notice("Held for: [P.owner_faction].")
		. += span_notice("Shared pool: [P.pooled_mammon] mammon.")

/obj/structure/roguemachine/capturepoint/proc/update_appearance()
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(!P)
		icon_state = "streetvendor1"
		return
	switch(P.owner_faction)
		if(CAPTURE_FACTION_KEEP)
			icon_state = "streetvendor1"
		if(CAPTURE_FACTION_OUTLANDERS)
			icon_state = "streetvendor1"
		if(CAPTURE_FACTION_CHURCH)
			icon_state = "streetvendor1"
		if(CAPTURE_FACTION_PSYDON)
			icon_state = "streetvendor1"
		else
			icon_state = "streetvendor1"

/obj/structure/roguemachine/capturepoint/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/list/options = list("Claim", "Withdraw")
	var/choice = input(user, "Choose an action.", src.name) as null|anything in options
	if(!choice)
		return
	switch(choice)
		if("Claim")
			claim_point(user)
		if("Withdraw")
			withdraw_from_point(user)

/obj/structure/roguemachine/capturepoint/proc/claim_point(mob/living/carbon/human/user)
	var/list/factions = list(
		CAPTURE_FACTION_KEEP,
		CAPTURE_FACTION_OUTLANDERS,
		CAPTURE_FACTION_CHURCH,
		CAPTURE_FACTION_PSYDON
	)
	var/faction_choice = input(user, "Claim this point in whose name?", src.name) as null|anything in factions
	if(!faction_choice)
		return
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(!P)
		return
	if(P.owner_faction == faction_choice)
		to_chat(user, span_warning("[src] is already held for [faction_choice]."))
		return
	user.visible_message(span_notice("[user] begins claiming [point_id] for [faction_choice]..."))
	if(!do_after(user, 10 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(get_dist(user, src) > 1)
		return
	SScapturepoints.set_owner(point_id, faction_choice)
	update_appearance()
	visible_message(span_notice("[user] claims [point_id] for [faction_choice]!"))

/obj/structure/roguemachine/capturepoint/proc/withdraw_from_point(mob/living/carbon/human/user)
	if(!user?.mind)
		return
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(!P)
		return
	var/key = "[point_id]::[P.owner_faction]"
	var/already_taken_ticks = user.mind.capture_withdrawals[key] || 0
	var/total_ticks_available = round(P.pooled_mammon / CAPTURE_TICK_VALUE)
	var/claimable_ticks = total_ticks_available - already_taken_ticks
	if(claimable_ticks <= 0)
		to_chat(user, span_warning("There is nothing ready for me to take yet."))
		return
	var/amount = claimable_ticks * CAPTURE_WITHDRAW_PER_TICK
	if(P.pooled_mammon < amount)
		to_chat(user, span_warning("The pool is not yet rich enough to pay my due."))
		return
	user.visible_message(span_notice("[user] begins withdrawing from [point_id]..."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(get_dist(user, src) > 1)
		return
	P = SScapturepoints.get_point(point_id)
	if(!P)
		return
	key = "[point_id]::[P.owner_faction]"
	already_taken_ticks = user.mind.capture_withdrawals[key] || 0
	total_ticks_available = round(P.pooled_mammon / CAPTURE_TICK_VALUE)
	claimable_ticks = total_ticks_available - already_taken_ticks
	if(claimable_ticks <= 0)
		to_chat(user, span_warning("There is nothing left ready for me to take."))
		return

	amount = claimable_ticks * CAPTURE_WITHDRAW_PER_TICK
	if(P.pooled_mammon < amount)
		to_chat(user, span_warning("The pool is not yet rich enough to pay my due."))
		return
	if(!SScapturepoints.withdraw_from_point(point_id, amount))
		to_chat(user, span_warning("The mechanism fails to release the funds."))
		return
	user.mind.capture_withdrawals[key] = already_taken_ticks + claimable_ticks
	budget2change(amount, get_turf(src))
	visible_message(span_notice("[user] withdraws [amount] mammon from [point_id]."))

/obj/structure/roguemachine/capturepoint/church
	name = "church capture point"
	desc = "A capture mechanism bound to church."
	point_id = CAPTURE_POINT_CHURCH

/obj/structure/roguemachine/capturepoint/lowtown
	name = "lowtown capture point"
	desc = "A capture mechanism bound to lowtown."
	point_id = CAPTURE_POINT_LOWTOWN

/obj/structure/roguemachine/capturepoint/hightown
	name = "hightown capture point"
	desc = "A capture mechanism bound to hightown."
	point_id = CAPTURE_POINT_HIGHTOWN

/obj/structure/roguemachine/capturepoint/keep
	name = "keep capture point"
	desc = "A capture mechanism bound to keep."
	point_id = CAPTURE_POINT_KEEP	


//Define dirty migrant adventurer goes here
