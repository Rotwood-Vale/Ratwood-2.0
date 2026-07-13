//Modular helper for adding excessive cum fetish options, primarily additional messages shown to participants

/proc/modular_excessive_knot_spurt_store()
	var/static/list/store = list()
	return store

/proc/modular_excessive_knot_spurt_key(mob/living/carbon/human/top, mob/living/carbon/human/btm, orifice)
	return "[REF(top)]|[REF(btm)]|[orifice]"

/proc/modular_get_knot_release_phonetic_list()
	var/static/list/phonetics = list("Spurt...", "Splurt...", "Squelch...", "Splosh...", "Glop...", "Squirk...")
	return phonetics

/// Returns TRUE if the excessive cum feature is enabled for the current action.
/// Requires the user to opt in, and if there is a separate target, requires the target to opt in as well.
/datum/sex_controller/proc/modular_excessive_cum_enabled()
	if(!user?.client?.prefs?.excessive_cum)
		return FALSE
	if(!target || target == user)
		return TRUE
	return !!target.client?.prefs?.excessive_cum

/// Resolves the context for the final excessive-cum summary message.
/datum/sex_controller/proc/modular_excessive_cum_context(mob/living/carbon/human/splashed_user = null, oral = FALSE, cum_on_face = TRUE, orifice = SEX_PART_NULL, obj/item/reagent_containers/glass/cum_chalice = null)
	if(!splashed_user || splashed_user == user)
		return cum_chalice ? EXCESSIVE_CUM_CONTEXT_CONTAINER : EXCESSIVE_CUM_CONTEXT_SOLO
	if(oral)
		return EXCESSIVE_CUM_CONTEXT_ORAL
	if(orifice & SEX_PART_CUNT && !(orifice & SEX_PART_ANUS))
		return EXCESSIVE_CUM_CONTEXT_VAGINAL
	if(orifice & SEX_PART_ANUS && !(orifice & SEX_PART_CUNT))
		return EXCESSIVE_CUM_CONTEXT_ANAL
	if(cum_on_face)
		return EXCESSIVE_CUM_CONTEXT_FACE
	return EXCESSIVE_CUM_CONTEXT_BODY

/// Returns the user-facing summary strings for an excessive-cum event.
/datum/sex_controller/proc/modular_get_excessive_cum_summary_messages(context = EXCESSIVE_CUM_CONTEXT_SOLO, mob/living/carbon/human/splashed_user = null, obj/item/reagent_containers/glass/cum_chalice = null)
	var/list/messages = list(
		"user" = null,
		"receiver" = null,
	)
	if(!modular_excessive_cum_enabled())
		return messages
	var/static/list/summary_messages = list(
		"[EXCESSIVE_CUM_CONTEXT_SOLO]" = list("user" = "I've wasted a huge load..."),
		"[EXCESSIVE_CUM_CONTEXT_ORAL]" = list("receiver" = "My belly is filled with hot spunk...", "user" = "I've pumped their belly full of hot spunk..."),
		"[EXCESSIVE_CUM_CONTEXT_FACE]" = list("receiver" = "My face has been completely painted in cum...", "user" = "I've painted their face in cum..."),
		"[EXCESSIVE_CUM_CONTEXT_BODY]" = list("receiver" = "I feel a huge hot load splatter over me...", "user" = "I've painted them with a fat load..."),
		"[EXCESSIVE_CUM_CONTEXT_VAGINAL]" = list("receiver" = "My womb is completely full of their seed...", "user" = "I've pumped their womb full of my seed..."),
		"[EXCESSIVE_CUM_CONTEXT_ANAL]" = list("receiver" = "My ass is completely full of their seed...", "user" = "I've pumped their ass full of my seed..."),
	)
	if(context == EXCESSIVE_CUM_CONTEXT_CONTAINER)
		messages["user"] = cum_chalice ? "I've dumped a huge load into [cum_chalice]..." : "I've dumped a huge load..."
		return messages
	var/list/selected_messages = summary_messages["[context]"]
	if(!selected_messages)
		return messages
	if(selected_messages["receiver"])
		messages["receiver"] = selected_messages["receiver"]
	if(selected_messages["user"])
		messages["user"] = selected_messages["user"]
	return messages

/// Sends the summary messages for the current excessive-cum context.
/datum/sex_controller/proc/modular_announce_excessive_cum_summary(context = EXCESSIVE_CUM_CONTEXT_SOLO, mob/living/carbon/human/splashed_user = null, obj/item/reagent_containers/glass/cum_chalice = null)
	if(get_load_bursts() < 3)
		return
	var/list/messages = modular_get_excessive_cum_summary_messages(context, splashed_user, cum_chalice)
	if(!messages || (!messages["user"] && !messages["receiver"]))
		return
	if(messages["receiver"] && splashed_user && splashed_user != user)
		to_chat(splashed_user, span_love(messages["receiver"]))
	if(messages["user"])
		to_chat(user, span_love(messages["user"]))

/// Delays summary delivery slightly so burst lines are consistently seen first.
/datum/sex_controller/proc/modular_schedule_excessive_cum_summary(context = EXCESSIVE_CUM_CONTEXT_SOLO, mob/living/carbon/human/splashed_user = null, obj/item/reagent_containers/glass/cum_chalice = null, delay = 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(modular_announce_excessive_cum_summary), context, splashed_user, cum_chalice), delay)

/// Emits the public/private spurt chat line for a single burst.
/datum/sex_controller/proc/modular_announce_spurt_message()
	var/has_penis = !!user.getorganslot(ORGAN_SLOT_PENIS)
	var/has_vagina = !!user.getorganslot(ORGAN_SLOT_VAGINA)
	var/public_verb = "spurts"
	var/private_text = "Spurt!"
	if(has_vagina && !has_penis)
		public_verb = "squirts"
		private_text = "Squirt!"
	if(modular_excessive_cum_enabled())
		user.visible_message(span_love("[user] [public_verb]!"), span_love("<i>[private_text]</i>"), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
		return
	to_chat(user, span_love("<i>[private_text]</i>"))

/// Emits additional solo/container spurts for the excessive-cum feature.
/datum/sex_controller/proc/modular_emit_excessive_solo_spurts(obj/item/reagent_containers/glass/cum_chalice = null, add_floor = TRUE)
	if(!modular_excessive_cum_enabled())
		return
	for(var/i = 1; i <= get_additional_spurts(); i++)
		modular_announce_spurt_message()
		playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
		if(add_floor)
			add_cum_floor(get_turf(user), do_big_puddle = should_make_big_cum_puddle())
		if(cum_chalice?.spillable)
			if(user.getorganslot(ORGAN_SLOT_VAGINA))
				cum_chalice.reagents.add_reagent(/datum/reagent/erpjuice/femcum, 1)
			else
				cum_chalice.reagents.add_reagent(/datum/reagent/erpjuice/cum, get_semen_volume())

/datum/sex_controller/proc/modular_track_knot_spurt(mob/living/carbon/human/splashed_user = null, oral = FALSE, orifice = SEX_PART_NULL)
	if(!modular_excessive_cum_enabled())
		return
	if(!ishuman(splashed_user) || splashed_user == user)
		return
	if(knotted_status != KNOTTED_AS_TOP || knotted_recipient != splashed_user)
		return
	if(!splashed_user?.client?.prefs?.excessive_cum)
		return
	var/tracked_orifice = SEX_PART_NULL
	if(oral || (orifice & SEX_PART_JAWS))
		tracked_orifice = SEX_PART_JAWS
	else if(orifice & SEX_PART_CUNT)
		tracked_orifice = SEX_PART_CUNT
	else if(orifice & SEX_PART_ANUS)
		tracked_orifice = SEX_PART_ANUS
	if(!tracked_orifice)
		return
	var/list/store = modular_excessive_knot_spurt_store()
	var/key = modular_excessive_knot_spurt_key(user, splashed_user, tracked_orifice)
	store[key] = (store[key] || 0) + 1

/datum/sex_controller/proc/modular_get_knot_release_messages(orifice, mob/living/carbon/human/top, mob/living/carbon/human/btm)
	var/list/messages = list(
		"giver" = null,
		"receiver" = null,
		"nearby" = null,
	)
	if(orifice & SEX_PART_JAWS)
		messages["giver"] = "As my knot slips free, seed spurts from their lips..."
		messages["receiver"] = "As the knot slips free, seed spurts from my lips..."
		messages["nearby"] = "As [top] slips free of [btm], seed spurts from [btm.p_their()] lips."
		return messages
	if(orifice & SEX_PART_CUNT)
		messages["giver"] = "As my knot slips free, spunk spurts from their cunt..."
		messages["receiver"] = "As the knot slips free, spunk spurts from my cunt..."
		messages["nearby"] = "As [top] slips free of [btm], spunk spurts from [btm.p_their()] cunt."
		return messages
	if(orifice & SEX_PART_ANUS)
		messages["giver"] = "As my knot slips free, cum spurts from their asshole..."
		messages["receiver"] = "As the knot slips free, cum spurts from my asshole..."
		messages["nearby"] = "As [top] slips free of [btm], cum spurts from [btm.p_their()] asshole."
		return messages
	return messages

/datum/sex_controller/proc/modular_get_knot_release_splatter_candidates(mob/living/carbon/human/leaker, turf/release_turf)
	if(!ishuman(leaker) || !release_turf)
		return list()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in RANGE_TURFS(1, release_turf))
		if(H == leaker)
			continue
		if(!H.client?.prefs?.excessive_cum)
			continue
		candidates += H
	return candidates

/datum/sex_controller/proc/modular_get_knot_release_observers(mob/living/carbon/human/leaker, mob/living/carbon/human/victim, turf/release_turf)
	if(!release_turf)
		return list()
	var/list/observers = list()
	for(var/mob/living/carbon/human/H in viewers(5, release_turf))
		if(H == leaker || H == victim)
			continue
		if(!H.client?.prefs?.excessive_cum)
			continue
		observers += H
	return observers

/datum/sex_controller/proc/modular_announce_knot_release_splatter(mob/living/carbon/human/leaker, mob/living/carbon/human/victim, list/observers = null)
	if(!ishuman(leaker) || !ishuman(victim))
		return
	to_chat(victim, span_love("I'm spattered with some of the seed spilling from [leaker]"))
	to_chat(leaker, span_love("[victim] is spattered with some of the seed spilling out of me"))
	for(var/mob/living/carbon/human/H in (observers || list()))
		if(H == victim)
			continue
		to_chat(H, span_love("[victim] is spattered with some of the seed spilling from [leaker]"))


/datum/sex_controller/proc/modular_announce_knot_release_spurt_message(mob/living/carbon/human/top, mob/living/carbon/human/btm, turf/release_turf, list/recipients = null)
	if(!ishuman(top) || !ishuman(btm) || !release_turf)
		return
	if(!top.client?.prefs?.excessive_cum || !btm.client?.prefs?.excessive_cum)
		return
	var/list/phonetics = modular_get_knot_release_phonetic_list()
	if(!islist(phonetics) || !length(phonetics))
		return
	if(!islist(recipients) || !length(recipients))
		recipients = list(top, btm)
		for(var/mob/living/carbon/human/H in viewers(5, release_turf))
			if(H == top || H == btm)
				continue
			recipients += H
	var/phonetic = pick(phonetics)
	var/message = span_love("[phonetic]")
	for(var/mob/living/carbon/human/H in recipients)
		if(!H.client?.prefs?.excessive_cum)
			continue
		to_chat(H, message)

/datum/sex_controller/proc/modular_release_knot_spurt_pool(mob/living/carbon/human/top, mob/living/carbon/human/btm, knot_orifice = SEX_PART_NULL)
	if(!ishuman(top) || !ishuman(btm))
		return
	var/tracked_orifice = SEX_PART_NULL
	if(knot_orifice & SEX_PART_JAWS)
		tracked_orifice = SEX_PART_JAWS
	else if(knot_orifice & SEX_PART_CUNT)
		tracked_orifice = SEX_PART_CUNT
	else if(knot_orifice & SEX_PART_ANUS)
		tracked_orifice = SEX_PART_ANUS
	if(!tracked_orifice)
		return
	var/list/store = modular_excessive_knot_spurt_store()
	var/key = modular_excessive_knot_spurt_key(top, btm, tracked_orifice)
	var/spurt_count = store[key] || 0
	store -= key
	if(spurt_count <= 0)
		return
	if(!top.client?.prefs?.excessive_cum || !btm.client?.prefs?.excessive_cum)
		return
	var/turf/origin_turf = get_turf(btm)
	if(!origin_turf)
		return
	var/turf/release_turf = origin_turf
	var/list/adjacent_turfs = list()
	for(var/turf/T in RANGE_TURFS(1, origin_turf))
		if(T != origin_turf)
			adjacent_turfs += T
	if(length(adjacent_turfs))
		release_turf = pick(adjacent_turfs)
	var/list/nearby_recipients = list(top, btm)
	for(var/mob/living/carbon/human/H in viewers(5, release_turf))
		if(H == top || H == btm)
			continue
		if(!H.client?.prefs?.excessive_cum)
			continue
		nearby_recipients += H
	// Check "nearby" from the victim's tile, but keep floor splatter on an adjacent tile.
	var/list/splatter_candidates = modular_get_knot_release_splatter_candidates(btm, origin_turf)
	var/list/splatter_observers = modular_get_knot_release_observers(btm, null, origin_turf)
	for(var/i = 1; i <= spurt_count; i++)
		var/splatter_diverted = FALSE
		if(prob(20) && length(splatter_candidates))
			var/mob/living/carbon/human/splatter_target = pick(splatter_candidates)
			if(splatter_target)
				var/spurt_intensity = max(spurt_count, 1)
				var/datum/status_effect/facial/external/external = splatter_target.has_status_effect(/datum/status_effect/facial/external)
				if(!external)
					splatter_target.apply_status_effect(/datum/status_effect/facial/external, spurt_intensity)
				else
					external.refresh_cum(spurt_intensity)
				modular_announce_knot_release_splatter(btm, splatter_target, splatter_observers)
				splatter_diverted = TRUE
		if(!splatter_diverted)
			add_cum_floor(release_turf)
		modular_announce_knot_release_spurt_message(top, btm, release_turf, nearby_recipients)
		playsound(release_turf, 'sound/misc/mat/endout.ogg', 12, TRUE, -2, ignore_walls = FALSE)
		if(i < spurt_count)
			sleep(10)
	var/list/messages = modular_get_knot_release_messages(tracked_orifice, top, btm)
	if(messages["giver"])
		to_chat(top, span_love(messages["giver"]))
	if(messages["receiver"])
		to_chat(btm, span_love(messages["receiver"]))
	if(messages["nearby"])
		for(var/mob/living/carbon/human/H in nearby_recipients)
			if(H == top || H == btm)
				continue
			to_chat(H, span_love(messages["nearby"]))
