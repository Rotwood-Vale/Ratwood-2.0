#define MANTICORE_TAIL_STRINGS_PATH "modular/code/datums/components/strings"

/datum/component/intimate_reaction/manticore_tail
	dupe_mode = COMPONENT_DUPE_UNIQUE
	movement_message_cooldown = 30 SECONDS
	/// Cooldown for sex-received flavor messages.
	var/last_receive_flavor_time = 0
	var/receive_flavor_cooldown = 20 SECONDS

/datum/component/intimate_reaction/manticore_tail/Initialize()
	if(!istype(parent, /obj/item/organ/tail))
		return COMPONENT_INCOMPATIBLE

/datum/component/intimate_reaction/manticore_tail/bind_to_wearer(mob/living/carbon/human/H)
	var/already_bound = (wearer == H)
	. = ..()
	if(!.)
		return FALSE
	if(already_bound)
		return TRUE
	register_movement_reaction(H)
	return TRUE

/datum/component/intimate_reaction/manticore_tail/unbind_from_wearer(mob/living/carbon/human/H)
	if(!H)
		H = wearer
	if(!H)
		return FALSE
	unregister_movement_reaction(H)
	return ..()

/datum/component/intimate_reaction/manticore_tail/is_valid_wearer_source(mob/living/carbon/human/source)
	if(!..())
		return FALSE
	var/obj/item/organ/tail/T = parent
	return T.owner == source

/datum/component/intimate_reaction/manticore_tail/try_handle_wearer_moved(mob/living/carbon/human/source)
	if(!is_valid_wearer_source(source))
		return FALSE
	if(source.stat != CONSCIOUS)
		return FALSE
	if(last_movement_message_time + movement_message_cooldown >= world.time)
		return FALSE
	if(!prob(18))
		return FALSE
	var/datum/sex_controller/sexcon = source.sexcon
	if(!sexcon || !source.client?.prefs?.sexable)
		return FALSE
	// Pick arousal-aware string key
	var/string_key = "manticore_tail_idle"
	if(sexcon.arousal > 50)
		string_key = "manticore_tail_aroused"
	var/message = pick_string_bank("manticore_tail_movement_messages.json", string_key, MANTICORE_TAIL_STRINGS_PATH)
	if(!message)
		return FALSE
	// Resolve [USER], [THEY], [THEM], [THEIR] etc. tokens
	message = resolve_tail_tokens(message, source)
	last_movement_message_time = world.time
	to_chat(source, span_warning(message))
	return TRUE

/datum/component/intimate_reaction/manticore_tail/try_handle_wearer_sex_action_received(mob/living/carbon/human/source, mob/living/carbon/human/acting_mob, datum/sex_controller/acting_sexcon, datum/sex_action/action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)
	if(!(receiver_part & (SEX_PART_TAIL | SEX_PART_TAIL_MAW)))
		return FALSE
	if(!is_valid_wearer_source(source))
		return FALSE
	if(source.stat != CONSCIOUS)
		return FALSE
	if(last_receive_flavor_time + receive_flavor_cooldown >= world.time)
		return FALSE
	if(!prob(15 + (applied_force * 4) + (applied_speed * 4)))
		return FALSE
	var/datum/sex_controller/sexcon = source.sexcon
	if(!sexcon || !source.client?.prefs?.sexable)
		return FALSE
	var/string_key = get_receive_flavor_key(receiver_part, action, sexcon)
	var/message = pick_string_bank("manticore_tail_receive_flavor.json", string_key, MANTICORE_TAIL_STRINGS_PATH)
	if(!message)
		return FALSE
	message = resolve_tail_tokens(message, source)
	last_receive_flavor_time = world.time
	to_chat(source, span_warning(message))
	return TRUE

/datum/component/intimate_reaction/manticore_tail/proc/get_receive_flavor_key(receiver_part, datum/sex_action/action, datum/sex_controller/sexcon)
	if(istype(action, /datum/sex_action/tailjob) || istype(action, /datum/sex_action/chastityplay/tailprod_cage) || istype(action, /datum/sex_action/manticore_tailjob) || istype(action, /datum/sex_action/manticore_tailjob_receive) || istype(action, /datum/sex_action/manticore_frot_engulf) || istype(action, /datum/sex_action/manticore_chastity_tease))
		return "manticore_tail_wrapping"
	if(istype(action, /datum/sex_action/tailpegging_anal))
		return "manticore_tail_penetrated"
	if(istype(action, /datum/sex_action/manticore_tail_oral_force) || istype(action, /datum/sex_action/manticore_tail_oral_receive))
		return "manticore_tail_oral"
	if(sexcon && sexcon.arousal > 85)
		return "manticore_tail_climax"
	return "manticore_tail_penetrated"

/datum/component/intimate_reaction/manticore_tail/proc/resolve_tail_tokens(message, mob/living/carbon/human/source)
	message = replacetext(message, "\[USER\]", "[source]")
	message = replacetext(message, "\[THEY\]", source.p_they())
	message = replacetext(message, "\[THEM\]", source.p_them())
	return replacetext(message, "\[THEIR\]", source.p_their())

#undef MANTICORE_TAIL_STRINGS_PATH
