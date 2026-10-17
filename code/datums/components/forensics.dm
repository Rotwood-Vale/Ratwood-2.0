/// Most entries View Forensics keeps in each of an atom's two action lists. The oldest drops off first.
#define FORENSIC_ACTIONS_MAX 30

/datum/component/forensics
	dupe_mode = COMPONENT_DUPE_UNIQUE
	can_transfer = TRUE
	var/list/fingerprints		//assoc print = print
	var/list/hiddenprints		//assoc ckey = realname/gloves/ckey
	var/list/blood_DNA			//assoc dna = bloodtype
	var/list/fibers				//assoc print = print
	/// Admin only, never wiped. Picks, breaks, pickups and drops oldest first, each packed as "round time|count|ckey|name|action".
	/// Strings rather than lists, as every item players handle can hold these all round. See forensic_action_fields()
	var/list/actions
	/// The same for plain opening, closing and keyed locking, capped apart so a busy door cannot push the evidence out of actions
	var/list/routine_actions

/datum/component/forensics/InheritComponent(datum/component/forensics/F, original)		//Use of | and |= being different here is INTENTIONAL.
	fingerprints = fingerprints | F.fingerprints
	hiddenprints = hiddenprints | F.hiddenprints
	blood_DNA = blood_DNA | F.blood_DNA
	fibers = fibers | F.fibers
	actions = merge_actions(actions, F.actions)
	routine_actions = merge_actions(routine_actions, F.routine_actions)
	check_blood()
	return ..()

/datum/component/forensics/Initialize(new_fingerprints, new_hiddenprints, new_blood_DNA, new_fibers)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	fingerprints = new_fingerprints
	hiddenprints = new_hiddenprints
	blood_DNA = new_blood_DNA
	fibers = new_fibers
	check_blood()

/datum/component/forensics/RegisterWithParent()
	check_blood()
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_act))

/datum/component/forensics/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_COMPONENT_CLEAN_ACT))

/datum/component/forensics/PostTransfer()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/forensics/proc/wipe_fingerprints()
	fingerprints = null
	return TRUE

/datum/component/forensics/proc/wipe_hiddenprints()
	return	//no.

/datum/component/forensics/proc/wipe_blood_DNA()
	blood_DNA = null
	if(isitem(parent))
		qdel(parent.GetComponent(/datum/component/decal/blood))
	return TRUE

/datum/component/forensics/proc/wipe_fibers()
	fibers = null
	return TRUE

/datum/component/forensics/proc/clean_act(datum/source, strength)
	if(strength >= CLEAN_STRENGTH_FINGERPRINTS)
		wipe_fingerprints()
	if(strength >= CLEAN_STRENGTH_BLOOD)
		wipe_blood_DNA()
	if(strength >= CLEAN_STRENGTH_FIBERS)
		wipe_fibers()

/datum/component/forensics/proc/add_fingerprint_list(list/_fingerprints)	//list(text)
	if(!length(_fingerprints))
		return
	LAZYINITLIST(fingerprints)
	for(var/i in _fingerprints)	//We use an associative list, make sure we don't just merge a non-associative list into ours.
		fingerprints[i] = i
	return TRUE

/datum/component/forensics/proc/add_fingerprint(mob/living/M, ignoregloves = FALSE)
	if(!isliving(M))
		if(!iscameramob(M))
			return
	add_hiddenprint(M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		add_fibers(H)
		if(H.gloves) //Check if the gloves (if any) hide fingerprints
			if(!istype(H.gloves, /obj/item/clothing/gloves))
				return
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.transfer_prints)
				ignoregloves = TRUE
			if(!ignoregloves)
				H.gloves.add_fingerprint(H, TRUE) //ignoregloves = 1 to avoid infinite loop.
				return
		if(H.dna)
			var/full_print = md5(H.dna.uni_identity)
			LAZYSET(fingerprints, full_print, full_print)
	return TRUE

/datum/component/forensics/proc/add_fiber_list(list/_fibertext)		//list(text)
	if(!length(_fibertext))
		return
	LAZYINITLIST(fibers)
	for(var/i in _fibertext)	//We use an associative list, make sure we don't just merge a non-associative list into ours.
		fibers[i] = i
	return TRUE

/datum/component/forensics/proc/add_fibers(mob/living/carbon/human/M)
	var/fibertext
	var/item_multiplier = isitem(src)?1.2:1
	if(M.wear_armor)
		fibertext = "Material from \a [M.wear_armor]."
		if(prob(10*item_multiplier) && !LAZYACCESS(fibers, fibertext))
			LAZYSET(fibers, fibertext, fibertext)
		if(!(M.wear_armor.body_parts_covered & CHEST))
			if(M.wear_pants)
				fibertext = "Fibers from \a [M.wear_pants]."
				if(prob(12*item_multiplier) && !LAZYACCESS(fibers, fibertext)) //Wearing a suit means less of the uniform exposed.
					LAZYSET(fibers, fibertext, fibertext)
		if(!(M.wear_armor.body_parts_covered & HANDS))
			if(M.gloves)
				fibertext = "Material from a pair of [M.gloves.name]."
				if(prob(20*item_multiplier) && !LAZYACCESS(fibers, fibertext))
					LAZYSET(fibers, fibertext, fibertext)
	else if(M.wear_pants)
		fibertext = "Fibers from \a [M.wear_pants]."
		if(prob(15*item_multiplier) && !LAZYACCESS(fibers, fibertext))
			// "Added fibertext: [fibertext]"
			LAZYSET(fibers, fibertext, fibertext)
		if(M.gloves)
			fibertext = "Material from a pair of [M.gloves.name]."
			if(prob(20*item_multiplier) && !LAZYACCESS(fibers, fibertext))
				LAZYSET(fibers, fibertext, fibertext)
	else if(M.gloves)
		fibertext = "Material from a pair of [M.gloves.name]."
		if(prob(20*item_multiplier) && !LAZYACCESS(fibers, fibertext))
			LAZYSET(fibers, fibertext, fibertext)
	return TRUE

/datum/component/forensics/proc/add_hiddenprint_list(list/_hiddenprints)	//list(ckey = text)
	if(!length(_hiddenprints))
		return
	LAZYINITLIST(hiddenprints)
	for(var/i in _hiddenprints)	//We use an associative list, make sure we don't just merge a non-associative list into ours.
		hiddenprints[i] = _hiddenprints[i]
	return TRUE

/datum/component/forensics/proc/add_hiddenprint(mob/M)
	if(!isliving(M))
		if(!iscameramob(M))
			return
	if(!M.key)
		return
	var/hasgloves = ""
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.gloves)
			hasgloves = "(gloves)"
	var/current_time = time_stamp()
	if(!LAZYACCESS(hiddenprints, M.key))
		LAZYSET(hiddenprints, M.key, "First: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]")
	else
		var/laststamppos = findtext(LAZYACCESS(hiddenprints, M.key), " Last: ")
		if(laststamppos)
			LAZYSET(hiddenprints, M.key, copytext(hiddenprints[M.key], 1, laststamppos))
		hiddenprints[M.key] += " Last: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]"	//made sure to be existing by if(!LAZYACCESS);else
	var/atom/A = parent
	A.fingerprintslast = M.ckey
	return TRUE

/datum/component/forensics/proc/add_action(mob/user, action, routine = FALSE)
	if(routine)
		routine_actions = record_action(routine_actions, user, action)
	else
		actions = record_action(actions, user, action)

/// Repeats of the same action by the same player fold into one entry. Returns the list, which may have been created.
/datum/component/forensics/proc/record_action(list/action_log, mob/user, action)
	// Everything after the count, so a repeat is a suffix match with no parsing
	var/who_and_what = "|[user.ckey]|[user.real_name]|[action]"
	var/last_index = LAZYLEN(action_log)
	if(last_index)
		var/last = action_log[last_index]
		var/suffix_start = length(last) - length(who_and_what) + 1
		if(suffix_start > 1 && copytext(last, suffix_start) == who_and_what)
			var/count_start = findtext(last, "|") + 1
			var/count = text2num(copytext(last, count_start, suffix_start))
			action_log[last_index] = "[STATION_TIME_PASSED()]|[count + 1][who_and_what]"
			return action_log
	LAZYADD(action_log, "[STATION_TIME_PASSED()]|1[who_and_what]")
	if(length(action_log) > FORENSIC_ACTIONS_MAX)
		action_log.Cut(1, 2)
	return action_log

/// Re-sorted by time, as the incoming entries can be older than ones already here, then the oldest trimmed past the cap.
/datum/component/forensics/proc/merge_actions(list/action_log, list/incoming)
	if(!length(incoming))
		return action_log
	action_log = LAZYLEN(action_log) ? action_log + incoming : incoming.Copy()
	sortTim(action_log, GLOBAL_PROC_REF(cmp_forensic_action_time_asc))
	if(length(action_log) > FORENSIC_ACTIONS_MAX)
		action_log.Cut(1, length(action_log) - FORENSIC_ACTIONS_MAX + 1)
	return action_log

/proc/forensic_action_time(entry)
	return text2num(copytext(entry, 1, findtext(entry, "|")))

/// Unpacks an action entry into list("time", "count", "ckey", "name", "action"). The action is last, so a "|" in it survives.
/proc/forensic_action_fields(entry)
	var/list/fields = splittext(entry, "|")
	return list(
		"time" = text2num(fields[1]),
		"count" = text2num(fields[2]),
		"ckey" = fields[3],
		"name" = fields[4],
		"action" = jointext(fields.Copy(5), "|"),
	)

/datum/component/forensics/proc/add_blood_DNA(list/dna)		//list(dna_enzymes = type)
	if(!length(dna))
		return
	LAZYINITLIST(blood_DNA)
	for(var/i in dna)
		blood_DNA[i] = dna[i]
	check_blood()
	return TRUE

/datum/component/forensics/proc/check_blood()
	if(!isitem(parent))
		return
	if(!length(blood_DNA))
		return
	parent.LoadComponent(/datum/component/decal/blood)

#undef FORENSIC_ACTIONS_MAX
