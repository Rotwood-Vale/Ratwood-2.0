// Round-start crisis selection for Peasant Rebel rounds.
//
// Call SStreasury.queue_crisis_selection() when a Head Rebel is created (see the one-line patch
// to /datum/antagonist/prebel/head/on_gain()). It fires once per round: after a short delay
// it asks the Lord which crisis has befallen the realm, with a timeout that picks at random.

#define CRISIS_PROMPT_DELAY (30 SECONDS)
#define CRISIS_RETRY_PERIOD (15 SECONDS)
#define CRISIS_MAX_RETRIES 12 // waits about 3 minutes for a Lord before choosing at random
#define CRISIS_CHOICE_TIMEOUT (3 MINUTES)
// TRUE while testing alone: offers every crisis regardless of how many players are online.
// (Goals can't be completed solo, but its the best testing we can do alone.)
#define CRISIS_DEBUG_OFFER_ALL FALSE

/datum/controller/subsystem/treasury
	var/crisis_selection_started = FALSE
	var/datum/decree/crisis/active_crisis

/datum/controller/subsystem/treasury/proc/queue_crisis_selection()
	if(crisis_selection_started)
		return
	crisis_selection_started = TRUE
	addtimer(CALLBACK(src, PROC_REF(prompt_lord_for_crisis), 0), CRISIS_PROMPT_DELAY)

/// Crises that can be offered right now, keyed by title.
/datum/controller/subsystem/treasury/proc/get_available_crises()
	var/list/out = list()
	for(var/decree_id in decrees)
		var/datum/decree/crisis/C = decrees[decree_id]
		if(!istype(C) || !C.id || C.has_ever_been_active || !C.offerable)
			continue
		if(CRISIS_DEBUG_OFFER_ALL || C.is_available())
			out[C.crisis_title] = C
	return out

/datum/controller/subsystem/treasury/proc/prompt_lord_for_crisis(attempt)
	if(active_crisis)
		return
	var/mob/living/carbon/human/lord = SSticker.rulermob
	if(!istype(lord) || !lord.client)
		if(attempt >= CRISIS_MAX_RETRIES)
			autopick_crisis()
			return
		addtimer(CALLBACK(src, PROC_REF(prompt_lord_for_crisis), attempt + 1), CRISIS_RETRY_PERIOD)
		return
	var/list/options = get_available_crises()
	if(!length(options))
		autopick_crisis()
		return
	var/list/briefing = list("<b>A crisis has befallen the realm. You must choose how your reign is tested:</b>")
	for(var/title in options)
		var/datum/decree/crisis/C = options[title]
		briefing += "<b>[title]:</b> [C.duke_briefing]"
	to_chat(lord, span_notice(jointext(briefing, "<br>")))
	addtimer(CALLBACK(src, PROC_REF(autopick_crisis)), CRISIS_CHOICE_TIMEOUT)
	INVOKE_ASYNC(src, PROC_REF(ask_lord_for_crisis), lord, options)

/datum/controller/subsystem/treasury/proc/ask_lord_for_crisis(mob/living/carbon/human/lord, list/options)
	var/choice = input(lord, "A crisis has befallen the realm. How will your reign be tested?", "The Realm in Peril") as null|anything in options
	if(active_crisis)
		return // the timeout already chose for the Lord
	if(!choice)
		autopick_crisis()
		return
	var/datum/decree/crisis/C = options[choice]
	if(!C)
		autopick_crisis()
		return
	// Re-check: players may have left since the list was built. Never silently swap the Lord's
	// choice for a random one; tell them and let them choose again.
	if(!CRISIS_DEBUG_OFFER_ALL && !C.is_available())
		to_chat(lord, span_warning("[choice] can no longer be imposed. Choose again."))
		var/list/refreshed = get_available_crises()
		if(!length(refreshed))
			autopick_crisis()
			return
		ask_lord_for_crisis(lord, refreshed)
		return
	C.impose()

/// Picks at random from what is available, falling back to the Grenzelhoft debt.
/datum/controller/subsystem/treasury/proc/autopick_crisis()
	if(active_crisis)
		return
	var/list/options = get_available_crises()
	var/datum/decree/crisis/C
	if(length(options))
		C = options[pick(options)]
	else
		C = get_decree(DECREE_CRISIS_GRENZELHOFT)
	C?.impose()
