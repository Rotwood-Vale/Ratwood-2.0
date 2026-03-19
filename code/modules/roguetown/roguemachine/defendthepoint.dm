#define CAPTURE_FACTION_KEEP "The Keep"
#define CAPTURE_FACTION_OUTLANDERS "The Outlanders"
#define CAPTURE_FACTION_CHURCH "The Church"
#define CAPTURE_FACTION_FREEHOLD "The Freehold"

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
	name = "district standard"
	desc = "A raised standard by which a district may be sworn to a cause."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	anchored = TRUE

	var/point_id = CAPTURE_POINT_LOWTOWN

/obj/structure/roguemachine/capturepoint/Initialize(mapload)
	. = ..()

/obj/structure/roguemachine/capturepoint/examine(mob/user)
	. = ..()
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(P)
		. += span_notice("Ward: [P.id].")
		. += span_notice("Sworn to: [P.owner_faction].")
		. += span_notice("Stored tribute: [P.pooled_mammon] mammon.")

/obj/structure/roguemachine/capturepoint/proc/is_church_member(mob/living/carbon/human/user)
	if(!user?.mind)
		return FALSE
	var/datum/job/target_job = SSjob.GetJob(user.mind.assigned_role)
	if(target_job?.type in list(CHURCH_ROLES))
		return TRUE
	return FALSE

/obj/structure/roguemachine/capturepoint/proc/is_freehold_member(mob/living/carbon/human/user)
	if(!user)
		return FALSE
	return HAS_TRAIT(user, TRAIT_FREEHOLDER)

/obj/structure/roguemachine/capturepoint/proc/is_outlander_member(mob/living/carbon/human/user)
	if(!user)
		return FALSE
	return HAS_TRAIT(user, TRAIT_OUTLANDER)

/obj/structure/roguemachine/capturepoint/proc/is_keep_member(mob/living/carbon/human/user)
	if(!user)
		return FALSE
	if(is_church_member(user))
		return FALSE
	if(is_freehold_member(user))
		return FALSE
	if(is_outlander_member(user))
		return FALSE
	return TRUE

/obj/structure/roguemachine/capturepoint/proc/can_collect_for_faction(mob/living/carbon/human/user, faction)
	switch(faction)
		if(CAPTURE_FACTION_CHURCH)
			return is_church_member(user)
		if(CAPTURE_FACTION_FREEHOLD)
			return is_freehold_member(user)
		if(CAPTURE_FACTION_OUTLANDERS)
			return is_outlander_member(user)
		if(CAPTURE_FACTION_KEEP)
			return is_keep_member(user)
	return FALSE

/obj/structure/roguemachine/capturepoint/attack_hand(mob/user)
	if(!ishuman(user))
		return
	if(!Adjacent(user))
		return

	var/list/options = list("Swear", "Collect Tribute")
	var/choice = input(user, "Choose an action.", src.name) as null|anything in options

	if(!choice)
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(!Adjacent(user))
		return

	switch(choice)
		if("Swear")
			claim_point(user)
		if("Collect Tribute")
			withdraw_from_point(user)

/obj/structure/roguemachine/capturepoint/proc/claim_point(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return

	var/list/factions = list(
		CAPTURE_FACTION_KEEP,
		CAPTURE_FACTION_OUTLANDERS,
		CAPTURE_FACTION_CHURCH,
		CAPTURE_FACTION_FREEHOLD
	)

	var/faction_choice = input(user, "Swear this ward in whose name?", src.name) as null|anything in factions

	if(!faction_choice)
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(!Adjacent(user))
		return
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(!P)
		return
	if(P.owner_faction == faction_choice)
		to_chat(user, span_warning("[src] is already sworn to [faction_choice]."))
		return
	user.visible_message(span_notice("[user] begins swearing [point_id] to [faction_choice]..."))
	if(!do_after(user, 1 MINUTES, target = src))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(!Adjacent(user))
		return
	SScapturepoints.set_owner(point_id, faction_choice)
	visible_message(span_notice("[user] swears [point_id] to [faction_choice]!"))

/obj/structure/roguemachine/capturepoint/proc/withdraw_from_point(mob/living/carbon/human/user)
	if(!user?.mind)
		return
	if(!Adjacent(user))
		return
	var/datum/capture_point_data/P = SScapturepoints.get_point(point_id)
	if(!P)
		return
	if(!can_collect_for_faction(user, P.owner_faction))
		to_chat(user, span_warning("This standard does not answer to my faction."))
		return
	var/key = "[point_id]::[P.owner_faction]"
	var/already_taken_ticks = user.mind.capture_withdrawals[key] || 0
	var/total_ticks_available = round(P.pooled_mammon / CAPTURE_TICK_VALUE)
	var/claimable_ticks = total_ticks_available - already_taken_ticks
	if(claimable_ticks <= 0)
		to_chat(user, span_warning("There is no tribute ready for me to collect yet."))
		return
	var/amount = claimable_ticks * CAPTURE_WITHDRAW_PER_TICK
	if(amount < 1)
		to_chat(user, span_warning("There is no tribute ready for me to collect yet."))
		return
	if(P.pooled_mammon < amount)
		to_chat(user, span_warning("The tribute store is not yet rich enough to pay my due."))
		return
	user.visible_message(span_notice("[user] begins collecting tribute from [point_id]..."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(!Adjacent(user))
		return
	P = SScapturepoints.get_point(point_id)
	if(!P)
		return
	if(!can_collect_for_faction(user, P.owner_faction))
		to_chat(user, span_warning("This standard no longer answers to my faction."))
		return
	key = "[point_id]::[P.owner_faction]"
	already_taken_ticks = user.mind.capture_withdrawals[key] || 0
	total_ticks_available = round(P.pooled_mammon / CAPTURE_TICK_VALUE)
	claimable_ticks = total_ticks_available - already_taken_ticks
	amount = claimable_ticks * CAPTURE_WITHDRAW_PER_TICK
	if(claimable_ticks <= 0 || amount < 1)
		to_chat(user, span_warning("There is no tribute left ready for me to collect."))
		return
	if(P.pooled_mammon < amount)
		to_chat(user, span_warning("The tribute store is not yet rich enough to pay my due."))
		return
	if(!SScapturepoints.withdraw_from_point(point_id, amount))
		to_chat(user, span_warning("The standard fails to yield its tribute."))
		return
	user.mind.capture_withdrawals[key] = already_taken_ticks + claimable_ticks
	budget2change(amount, user)
	visible_message(span_notice("[user] collects [amount] mammon from [point_id]."))

/obj/structure/roguemachine/capturepoint/church
	name = "church standard"
	desc = "A standard raised over the church."
	point_id = CAPTURE_POINT_CHURCH

/obj/structure/roguemachine/capturepoint/lowtown
	name = "lowtown standard"
	desc = "A standard raised over lowtown."
	point_id = CAPTURE_POINT_LOWTOWN

/obj/structure/roguemachine/capturepoint/hightown
	name = "hightown standard"
	desc = "A standard raised over hightown."
	point_id = CAPTURE_POINT_HIGHTOWN

/obj/structure/roguemachine/capturepoint/keep
	name = "keep standard"
	desc = "A standard raised over the keep."
	point_id = CAPTURE_POINT_KEEP
