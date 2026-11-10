/// How long after a job or class outfit is applied before the credits portrait is captured.
/// Gives deferred icon updates (SSiconupdates) time to land, and coalesces back-to-back triggers.
#define CREDIT_CAPTURE_DELAY (2 SECONDS)

/**
 * Holds the end-of-round credits roster.
 *
 * Portraits are snapshots of the live mob's worn/body overlays, stored as a mutable_appearance.
 * No icon math happens at capture time; the client does the drawing when the credits roll.
 * The only flattening is lazy, for the handful of outlaw wanted posters on the round end panel.
 */
SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	flags = SS_NO_INIT | SS_NO_FIRE
	/// Assoc list of /datum/mind => /datum/credit_entry, in join order.
	var/list/entries = list()
	/// overlays_standing indexes that are transient state rather than how the character looks.
	/// Anything not listed here is kept, so new clothing/body layers show up without touching this file.
	var/static/list/excluded_layers = list(
		HANDS_LAYER,
		HANDS_BEHIND_LAYER,
		HANDCUFF_LAYER,
		LEGCUFF_LAYER,
		FIRE_LAYER,
		SUNDER_LAYER,
		HALO_LAYER,
		TURF_LAYER,
		DAMAGE_LAYER,
		ARM_DAMAGE_LAYER,
		LEG_DAMAGE_LAYER,
		MUTATIONS_LAYER,
		FRONT_MUTATIONS_LAYER,
		BLACK_ROT_LAYER,
		POTENCE_LAYER,
		JOYBRINGER_LAYER,
	)

/datum/credit_entry
	var/name
	var/title
	var/voice_color
	/// Clean, south-facing appearance of the character as they set out. FLOAT_PLANE, blank base icon.
	var/mutable_appearance/portrait
	/// Lazily flattened upper-body icon, only built for wanted posters.
	var/icon/poster_icon

/// Schedules a portrait capture for H. Safe to call repeatedly; the newest call wins.
/datum/controller/subsystem/crediticons/proc/queue_capture(mob/living/carbon/human/H)
	if(!istype(H))
		return
	addtimer(CALLBACK(src, PROC_REF(capture), H), CREDIT_CAPTURE_DELAY, TIMER_UNIQUE | TIMER_OVERRIDE)

/// Captures (or replaces) the credits entry for H's mind. Returns the entry, or null if H isn't eligible.
/datum/controller/subsystem/crediticons/proc/capture(mob/living/carbon/human/H)
	if(QDELETED(H))
		return null
	var/datum/mind/M = H.mind
	if(!M?.key) // player characters only; NPCs and admin-spawned bodies have no key
		return null
	var/datum/job/J = M.assigned_role // may hold a datum or a title string depending on who set it
	if(!istype(J))
		J = SSjob.GetJob(J)
	if(!J?.show_in_credits)
		return null

	var/datum/credit_entry/entry = entries[M]
	if(!entry)
		entry = new
		entries[M] = entry
	entry.name = H.real_name
	entry.title = H.get_role_title()
	entry.voice_color = H.voice_color
	entry.portrait = build_portrait(H)
	entry.poster_icon = null
	return entry

/// Builds a clean portrait from the mob's standing overlays.
/// Only overlays_standing is read, so typing indicators, emotes, status effects and anything else
/// added with add_overlay() never get in. The mob's own transform/alpha/color/dir are not copied.
/datum/controller/subsystem/crediticons/proc/build_portrait(mob/living/carbon/human/H)
	var/mutable_appearance/portrait = mutable_appearance('icons/blanks/32x32.dmi', "nothing")
	portrait.dir = SOUTH
	var/list/standing = H.overlays_standing
	for(var/i in 1 to length(standing))
		if(i in excluded_layers)
			continue
		var/overlay = standing[i]
		if(overlay)
			portrait.overlays += overlay
	return portrait

/// Upper-body icon for the wanted poster panel. Flattened once per entry, on first request.
/datum/controller/subsystem/crediticons/proc/get_poster_icon(datum/credit_entry/entry)
	if(!entry?.portrait)
		return null
	if(!entry.poster_icon)
		var/icon/flat = getFlatIcon(entry.portrait, SOUTH)
		flat.Crop(1, 17, 32, 32)
		flat.Scale(96, 48)
		entry.poster_icon = flat
	return entry.poster_icon

/// Entries for characters named in GLOB.outlawed_players.
/datum/controller/subsystem/crediticons/proc/get_outlaw_entries()
	. = list()
	for(var/datum/mind/M as anything in entries)
		var/datum/credit_entry/entry = entries[M]
		if(entry.name in GLOB.outlawed_players)
			. += entry

#undef CREDIT_CAPTURE_DELAY
