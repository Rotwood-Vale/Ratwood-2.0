/// How long after a job or class outfit is applied before the credits portrait is captured.
/// Gives deferred icon updates (SSiconupdates) time to land, and coalesces back-to-back triggers.
#define CREDIT_CAPTURE_DELAY (2 SECONDS)

/**
 * Holds the end-of-round credits roster.
 *
 * Portraits are snapshots of the live mob's worn/body overlays, stored as a mutable_appearance.
 * No icon math happens at capture time; the client does the drawing when the credits roll.
 * The only flattening is lazy and cached, for wanted posters (bandit notices, round end Outlaws tab).
 */
SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	flags = SS_NO_INIT | SS_NO_FIRE
	/// Assoc list of /datum/mind => /datum/credit_entry, in join order.
	var/list/entries = list()
	/// Wanted name => portrait source, captured from the actual mob when they were declared or bountied.
	/// Holds their /datum/credit_entry if they have one (so recaptures carry over), else a fallback
	/// mutable_appearance for uncredited jobs. Kept apart from entries so fallbacks never roll in the credits.
	var/list/wanted_portraits = list()
	/// portrait => base64 PNG for wanted posters. Each portrait is flattened at most once.
	var/list/poster_cache = list()
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
	var/datum/mind/mind
	/// Name at the last capture or lookup. Read it through current_name(); antags often rename after spawning.
	var/name
	var/title
	var/voice_color
	/// Clean, south-facing appearance of the character as they set out. FLOAT_PLANE, blank base icon.
	/// Change it through set_portrait() so the cached poster and portrait object are dropped.
	var/mutable_appearance/portrait
	/// Scaled, masked portrait shown inside every client's credit for this entry. Built once, on first roll.
	var/atom/movable/screen/credit_portrait/portrait_holder
	/// Lazy list of credit screen objects showing this entry right now, across all clients.
	var/list/live_credits

/// Refreshes name from the character's body while it exists, so post-spawn renames are picked up, and returns it.
/// Wildshape and werewolf forms are separate human bodies with their own names; while the mind is in
/// one of those, the last name read from the real body is kept.
/datum/credit_entry/proc/current_name()
	var/mob/living/carbon/human/body = mind?.current
	if(ishuman(body) && !QDELETED(body) && !body.is_shapeshift_shell() && body.real_name)
		name = body.real_name
	return name

/datum/credit_entry/proc/set_portrait(mutable_appearance/new_portrait)
	SScrediticons.poster_cache -= portrait
	portrait = new_portrait
	if(!portrait_holder)
		return
	for(var/atom/movable/screen/credit/credit as anything in live_credits)
		credit.vis_contents -= portrait_holder
	QDEL_NULL(portrait_holder)

/// The shared portrait object for credits to show in their vis_contents, or null if there's no portrait.
/datum/credit_entry/proc/get_portrait_holder()
	if(!portrait)
		return null
	if(!portrait_holder)
		portrait_holder = new(null, portrait)
	return portrait_holder

/// Every credits entry, in join order.
/datum/controller/subsystem/crediticons/proc/get_roster()
	. = list()
	for(var/datum/mind/M as anything in entries)
		. += entries[M]

/// Schedules a portrait capture for H. Safe to call repeatedly; the newest call wins.
/// The mind is pinned now, so the capture still lands if it leaves the body (wildshape) before the timer fires.
/datum/controller/subsystem/crediticons/proc/queue_capture(mob/living/carbon/human/H)
	if(!istype(H))
		return
	addtimer(CALLBACK(src, PROC_REF(capture), H, H.mind), CREDIT_CAPTURE_DELAY, TIMER_UNIQUE | TIMER_OVERRIDE)

/// Captures (or replaces) the credits entry for M (default: H's mind) from H's body.
/// Returns the entry, or null if they aren't eligible.
/datum/controller/subsystem/crediticons/proc/capture(mob/living/carbon/human/H, datum/mind/M)
	if(QDELETED(H))
		return null
	if(!M)
		M = H.mind
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
	entry.mind = M
	entry.name = H.real_name
	entry.title = H.get_role_title()
	entry.voice_color = H.voice_color
	entry.set_portrait(build_portrait(H))
	return entry

/// Schedules a wanted-poster portrait for someone just declared an outlaw or bountied.
/datum/controller/subsystem/crediticons/proc/queue_wanted_capture(mob/living/carbon/human/H)
	if(!istype(H))
		return
	addtimer(CALLBACK(src, PROC_REF(capture_wanted), H), CREDIT_CAPTURE_DELAY, TIMER_UNIQUE | TIMER_OVERRIDE)

/// Ties H's name to H's own portrait, so same-named characters can't swap faces on the posters.
/datum/controller/subsystem/crediticons/proc/capture_wanted(mob/living/carbon/human/H)
	if(QDELETED(H))
		return
	poster_cache -= wanted_portraits[H.real_name]
	var/datum/credit_entry/entry = H.mind && entries[H.mind]
	wanted_portraits[H.real_name] = entry || build_portrait(H)

/// Best portrait for a wanted name: the one captured when they were declared, else a credits entry
/// with that name, else null.
/datum/controller/subsystem/crediticons/proc/get_portrait_by_name(name)
	var/wanted = wanted_portraits[name]
	if(istype(wanted, /datum/credit_entry))
		var/datum/credit_entry/wanted_entry = wanted
		return wanted_entry.portrait
	if(wanted)
		return wanted
	for(var/datum/mind/M as anything in entries)
		var/datum/credit_entry/entry = entries[M]
		if(entry.current_name() == name)
			return entry.portrait

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
		var/layer_overlays = standing[i]
		if(islist(layer_overlays))
			for(var/overlay in layer_overlays)
				add_clean_overlay(portrait, overlay)
		else if(layer_overlays)
			add_clean_overlay(portrait, layer_overlays)
	return portrait

/// Adds overlay to portrait, minus any blood (tagged BLOOD_OVERLAY_NAME where it's applied).
/// The live mob's overlay is never edited; a copy is made only when there is blood to strip.
/datum/controller/subsystem/crediticons/proc/add_clean_overlay(mutable_appearance/portrait, mutable_appearance/overlay)
	if(overlay.name == BLOOD_OVERLAY_NAME)
		return
	var/list/kept = list()
	var/had_blood = FALSE
	for(var/mutable_appearance/nested as anything in overlay.overlays)
		if(nested.name == BLOOD_OVERLAY_NAME)
			had_blood = TRUE
		else
			kept += nested
	if(!had_blood)
		portrait.overlays += overlay
		return
	var/mutable_appearance/clean = new(overlay)
	clean.overlays.Cut()
	clean.overlays += kept
	portrait.overlays += clean

/// Upper-body PNG (base64) of a portrait, for wanted posters. Flattened once, on first request.
/datum/controller/subsystem/crediticons/proc/get_poster_base64(mutable_appearance/portrait)
	if(!portrait)
		return null
	. = poster_cache[portrait]
	if(.)
		return
	. = icon2base64(build_poster_icon(portrait))
	poster_cache[portrait] = .

/// Flattens a portrait to the upper-body icon used on wanted posters.
/// Each overlay is flattened on its own and blended onto a fixed 32x32 frame, so oversized layers
/// (64x64 weapons with negative pixel offsets) are clipped like the client clips them. Running
/// getFlatIcon() on the whole portrait doesn't work: its canvas-resize path mixes up its bounds and
/// draws every later layer off-canvas, giving a blank poster.
/// Sleeps between overlays if the tick runs long; callers are UI handlers, which may sleep.
/datum/controller/subsystem/crediticons/proc/build_poster_icon(mutable_appearance/portrait)
	var/list/sorted = list()
	for(var/image/overlay as anything in portrait.overlays)
		if(overlay.alpha)
			sorted += overlay
	sortTim(sorted, GLOBAL_PROC_REF(cmp_atom_layer_asc))

	var/icon/canvas = icon('icons/blanks/32x32.dmi', "nothing")
	for(var/image/overlay as anything in sorted)
		var/icon/part = getFlatIcon(image(overlay), SOUTH)
		if(part)
			canvas.Blend(part, ICON_OVERLAY, overlay.pixel_x + 1, overlay.pixel_y + 1)
		CHECK_TICK
	canvas.Crop(1, 17, 32, 32)
	canvas.Scale(96, 48)
	return canvas

#undef CREDIT_CAPTURE_DELAY
