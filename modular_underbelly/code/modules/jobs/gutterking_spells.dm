/*
	GUTTER KING SPELLS

	Three abilities exclusive to the Gutter King role:
	  - Convert to Scum: Recruits any living person into the Scum job.
	  - The Word: Broadcasts a message to all Underbelly members only.
	  - Lay Low: Corrupts a target's bounty entry for 10 minutes.
	  - Put a Price On It: Marks a target for 20 minutes, alerting all Scum.
*/

// -------------------------------------------------------------------------
// Convert to Scum
// -------------------------------------------------------------------------

/obj/effect/proc_holder/spell/self/convertrole/scum
	name = "Convert to Scum"
	desc = "Bring someone down to your level."
	overlay_state = "recruit_bog"
	new_role = "Scum"
	recruitment_faction = "Scum"
	recruitment_message = "You belong down here with the rest of us, %RECRUIT."
	accept_message = "...alright. Alright."
	refuse_message = "No. Never."
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/convertrole/scum/can_convert(mob/living/carbon/human/recruit)
	if(QDELETED(recruit))
		return FALSE
	if(!recruit.mind)
		return FALSE
	if(recruit.stat != CONSCIOUS)
		return FALSE
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/scum/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(recruit, TRAIT_UNDERBELLY_SCUM, "converted_scum")
	recruit.social_rank = SOCIAL_RANK_SCUM
	SSjob.EquipRank(recruit, "Scum", joined_late = TRUE)

// -------------------------------------------------------------------------
// The Word - sends Maurice to each Underbelly member with the boss' message
// -------------------------------------------------------------------------

/obj/effect/proc_holder/spell/self/gutterking_word
	name = "The Word"
	desc = "Send Maurice to deliver a message to every Scum in the Underbelly."
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 3 MINUTES

/obj/effect/proc_holder/spell/self/gutterking_word/cast(list/targets, mob/user)
	if(user.stat)
		return FALSE

	var/msg = input(user, "What's the word?", "The Word") as text|null
	if(!msg)
		return FALSE

	var/recipients = 0
	var/list/visited_turfs = list()
	for(var/mob/living/carbon/human/M in GLOB.player_list)
		if(!HAS_TRAIT(M, TRAIT_UNDERBELLY_SCUM))
			continue
		if(!M.client || M == user)
			continue
		var/turf/T = get_turf(M)
		if(T in visited_turfs)
			continue
		visited_turfs += T
		// Reuse a nearby permanent Maurice if one exists rather than spawning a second
		var/mob/living/simple_animal/pet/maurice/messenger = locate(/mob/living/simple_animal/pet/maurice) in range(5, T)
		if(!messenger)
			messenger = new /mob/living/simple_animal/pet/maurice(T)
		messenger.pending_message = msg
		messenger.sender_name = user.real_name
		INVOKE_ASYNC(messenger, TYPE_PROC_REF(/mob/living/simple_animal/pet/maurice, deliver), M)
		recipients++

	if(!recipients)
		to_chat(user, span_warning("Nobody to send Maurice to."))
		return FALSE

	to_chat(user, span_notice("Maurice is on his way."))
	..()

// -------------------------------------------------------------------------
// Lay Low - corrupts a target's bounty entry for 10 minutes
// -------------------------------------------------------------------------

/obj/effect/proc_holder/spell/self/gutterking_laylow
	name = "Lay Low"
	desc = "Scramble someone's record in the Excidium. Buys them ten minutes."
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 15 MINUTES

/obj/effect/proc_holder/spell/self/gutterking_laylow/cast(list/targets, mob/user)
	. = ..()
	if(user.stat)
		return FALSE

	var/list/nearby = list()
	for(var/mob/living/carbon/human/M in get_hearers_in_view(4, user))
		if(M == user)
			continue
		if(!M.mind)
			continue
		nearby[M.name] = M

	if(!length(nearby))
		to_chat(user, span_warning("Nobody nearby to cover for."))
		return

	var/choice = input(user, "Who do you want to pull from the files?", "Lay Low") as null|anything in nearby
	if(!choice)
		return

	var/mob/living/carbon/human/target = nearby[choice]
	if(QDELETED(target))
		return

	var/list/affected = list()
	for(var/datum/bounty/B in GLOB.head_bounties)
		if(B.target == target.real_name || B.target_hidden == target.real_name)
			affected += B

	if(!length(affected))
		to_chat(user, span_warning("No record found for [target.name]."))
		return

	// Cache originals and overwrite
	var/list/originals = list()
	for(var/datum/bounty/B in affected)
		originals[B] = B.banner
		B.banner = "<span class='danger'><b>[B.target || "UNKNOWN"]</b> -- <b>[!isnull(B.target_hidden) ? "UNKNOWN" : B.target]</b></span><br><span class='warning'>\[ERROR -- DATA EXPUNGED\]</span><BR>--------------<BR>"

	to_chat(user, span_notice("Done. Their file's a mess for the next ten minutes."))

	addtimer(CALLBACK(src, PROC_REF(restore_banners), originals), 10 MINUTES)

/obj/effect/proc_holder/spell/self/gutterking_laylow/proc/restore_banners(list/originals)
	for(var/datum/bounty/B in originals)
		if(QDELETED(B))
			continue
		B.banner = originals[B]

// -------------------------------------------------------------------------
// Put a Price On It - marks a nearby Flipside target, alerts all Scum
// -------------------------------------------------------------------------

/obj/effect/proc_holder/spell/self/gutterking_mark
	name = "Put a Price On It"
	desc = "Mark someone. Every Scum in the Underbelly will know their name and where you last saw them."
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 15 MINUTES
	/// Tracks recently marked targets to prevent double-marking within the window
	var/list/marked_names

/obj/effect/proc_holder/spell/self/gutterking_mark/New()
	..()
	marked_names = list()

/obj/effect/proc_holder/spell/self/gutterking_mark/cast(list/targets, mob/user)
	. = ..()
	if(user.stat)
		return FALSE

	var/list/nearby = list()
	for(var/mob/living/carbon/human/M in get_hearers_in_view(5, user))
		if(M == user)
			continue
		if(!M.mind)
			continue
		nearby[M.name] = M

	if(!length(nearby))
		to_chat(user, span_warning("Nobody close enough to mark."))
		return

	var/choice = input(user, "Who's got a price on their head?", "Put a Price On It") as null|anything in nearby
	if(!choice)
		return

	var/mob/living/carbon/human/target = nearby[choice]
	if(QDELETED(target))
		return

	if(target.real_name in marked_names)
		to_chat(user, span_warning("[target.name]'s already marked. Give it time."))
		return

	var/area/A = get_area(target)
	var/loc_name = A ? A.name : "unknown location"

	marked_names += target.real_name
	addtimer(CALLBACK(src, PROC_REF(clear_mark), target.real_name), 20 MINUTES)

	var/announcement = span_boldannounce("<b>The Word is out:</b> [target.name] was last spotted near [loc_name]. Act on it.")
	for(var/mob/living/carbon/human/M in GLOB.player_list)
		if(!HAS_TRAIT(M, TRAIT_UNDERBELLY_SCUM))
			continue
		if(!M.client)
			continue
		to_chat(M, announcement)

/obj/effect/proc_holder/spell/self/gutterking_mark/proc/clear_mark(name)
	marked_names -= name

// -------------------------------------------------------------------------
// Speak - global announcement from the Boss
// -------------------------------------------------------------------------

/obj/effect/proc_holder/spell/self/gutterking_announce
	name = "Speak"
	desc = "Your voice carries from the gutters to every ear in the vale."
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 20 MINUTES

/obj/effect/proc_holder/spell/self/gutterking_announce/cast(list/targets, mob/user)
	if(user.stat)
		return FALSE

	to_chat(user, span_warning("<b>Warning:</b> This is a server-wide announcement. Abusing it is grounds for a roleban."))
	var/msg = input(user, "What do you want the vale to hear?", "Speak") as text|null
	if(!msg)
		return FALSE

	priority_announce(msg, "A deep rumble stirs from the sewers...", 'modular_underbelly/sound/scummy_announcement.ogg', sender = user)

	..()
