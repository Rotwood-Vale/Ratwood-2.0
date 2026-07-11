//Modular helper for adding excessive cum fetish options, primarily additional messages shown to participants
#define EXCESSIVE_CUM_CONTEXT_SOLO 1
#define EXCESSIVE_CUM_CONTEXT_ORAL 2
#define EXCESSIVE_CUM_CONTEXT_FACE 3
#define EXCESSIVE_CUM_CONTEXT_BODY 4
#define EXCESSIVE_CUM_CONTEXT_VAGINAL 5
#define EXCESSIVE_CUM_CONTEXT_ANAL 6
#define EXCESSIVE_CUM_CONTEXT_CONTAINER 7

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
		EXCESSIVE_CUM_CONTEXT_SOLO = list("user" = "I've wasted a huge load..."),
		EXCESSIVE_CUM_CONTEXT_ORAL = list("receiver" = "My belly is filled with hot spunk...", "user" = "I've pumped their belly full of hot spunk..."),
		EXCESSIVE_CUM_CONTEXT_FACE = list("receiver" = "My body has been completely painted in cum...", "user" = "I've painted them in cum..."),
		EXCESSIVE_CUM_CONTEXT_BODY = list("receiver" = "I feel a huge hot load splatter over me...", "user" = "I've painted them with a fat load..."),
		EXCESSIVE_CUM_CONTEXT_VAGINAL = list("receiver" = "My womb is completely full of their seed...", "user" = "I've pumped their womb full of my seed..."),
		EXCESSIVE_CUM_CONTEXT_ANAL = list("receiver" = "My ass is completely full of their seed...", "user" = "I've pumped their ass full of my seed..."),
	)
	if(context == EXCESSIVE_CUM_CONTEXT_CONTAINER)
		messages["user"] = "I've dumped a huge load into [cum_chalice]..."
		return messages
	var/list/selected_messages = summary_messages[context]
	if(!selected_messages)
		return messages
	if(selected_messages["receiver"])
		messages["receiver"] = selected_messages["receiver"]
	if(selected_messages["user"])
		messages["user"] = selected_messages["user"]
	return messages

/// Sends the summary messages for the current excessive-cum context.
/datum/sex_controller/proc/modular_announce_excessive_cum_summary(context = EXCESSIVE_CUM_CONTEXT_SOLO, mob/living/carbon/human/splashed_user = null, obj/item/reagent_containers/glass/cum_chalice = null)
	var/list/messages = modular_get_excessive_cum_summary_messages(context, splashed_user, cum_chalice)
	if(!messages || (!messages["user"] && !messages["receiver"]))
		return
	if(messages["receiver"] && splashed_user && splashed_user != user)
		to_chat(splashed_user, span_love(messages["receiver"]))
	if(messages["user"])
		to_chat(user, span_love(messages["user"]))

/// Emits the public/private spurt chat line for a single burst.
/datum/sex_controller/proc/modular_announce_spurt_message()
	if(modular_excessive_cum_enabled())
		user.visible_message(span_love("[user] spurts!"), span_love("<i>Spurt!</i>"), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
		return
	to_chat(user, span_love("<i>Spurt!</i>"))

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
