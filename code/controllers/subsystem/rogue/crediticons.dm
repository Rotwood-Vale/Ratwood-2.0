/// How long after a job or class outfit is applied before the credits portrait is captured.
/// Gives deferred icon updates (SSiconupdates) time to land, and coalesces back-to-back triggers.
#define CREDIT_CAPTURE_DELAY (2 SECONDS)
#define POSTER_PAGE_LOAD_DELAY (1 SECONDS)

/**
 * Holds the end-of-round credits roster.
 *
 * Portraits are snapshots of the live mob's worn/body overlays, stored as a mutable_appearance.
 * No icon math happens at capture time; the client does the drawing when the credits roll.
 * The only flattening is for wanted posters (town wanted boards, round end Outlaws tab). It is cached,
 */
SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	flags = SS_NO_INIT | SS_BACKGROUND
	wait = 1
	var/mutable_appearance/building_portrait
	var/list/building_overlays
	var/icon/building_canvas
	var/list/poster_pushes = list()
	/// Assoc list of /datum/mind => /datum/credit_entry, in join order.
	var/list/entries = list()
	/// Wanted name => portrait source, captured from the actual mob when they were declared or bountied.
	/// Holds their /datum/credit_entry if they have one (so recaptures carry over), else a fallback
	/// mutable_appearance for uncredited jobs. Kept apart from entries so fallbacks never roll in the credits.
	var/list/wanted_portraits = list()
	/// portrait => base64 PNG for wanted posters. Each portrait is flattened at most once.
	var/list/poster_cache = list()
	/// portrait => TRUE if it's being flattened currenly, can be cleared by drop_poster()
	var/list/poster_building = list()
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
	var/had_poster = SScrediticons.drop_poster(portrait)
	portrait = new_portrait
	if(had_poster)
		SScrediticons.queue_poster(portrait)
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
	var/old = wanted_portraits[H.real_name]
	if(!istype(old, /datum/credit_entry))
		drop_poster(old)
	var/datum/credit_entry/entry = H.mind && entries[H.mind]
	var/mutable_appearance/portrait = entry ? entry.portrait : build_portrait(H)
	wanted_portraits[H.real_name] = entry || portrait
	queue_poster(portrait)

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

/// Upper-body PNG (base64) of a portrait, for wanted posters. Never sleeps.
/// If the poster isn't built yet, starts the background build and returns null.
/datum/controller/subsystem/crediticons/proc/get_poster_base64(mutable_appearance/portrait)
	if(!portrait)
		return null
	. = poster_cache[portrait]
	if(.)
		return
	queue_poster(portrait)
	return null

/datum/controller/subsystem/crediticons/proc/push_pending_posters(client/viewer, window_id, list/pending)
	set waitfor = FALSE
	// lets make sure nobody can just spam queue it up
	var/push_key = "[viewer.ckey]|[window_id]"
	poster_pushes[push_key] = pending
	sleep(POSTER_PAGE_LOAD_DELAY)
	while(length(pending) && viewer && poster_pushes[push_key] == pending)
		for(var/element_id in pending)
			var/mutable_appearance/portrait = pending[element_id]
			var/poster_base64 = poster_cache[portrait]
			if(poster_base64)
				viewer << output(list2params(list(element_id, poster_base64)), "[window_id].browser:wanted_poster_ready")
			else if(poster_building[portrait])
				continue
			pending -= element_id
		sleep(0.5 SECONDS)
	if(poster_pushes[push_key] == pending)
		poster_pushes -= push_key

/datum/controller/subsystem/crediticons/proc/queue_poster(mutable_appearance/portrait)
	if(!portrait || poster_cache[portrait] || poster_building[portrait])
		return
	poster_building[portrait] = TRUE

/datum/controller/subsystem/crediticons/proc/drop_poster(mutable_appearance/portrait)
	if(!portrait)
		return FALSE
	. = !!(poster_cache[portrait] || poster_building[portrait])
	poster_cache -= portrait
	poster_building -= portrait
	if(portrait == building_portrait)
		building_portrait = null

/// Flattens a portrait to the upper-body icon used on wanted posters.
/// Each overlay is flattened on its own and blended onto a fixed 32x32 frame, so oversized layers
/// (64x64 weapons with negative pixel offsets) are clipped like the client clips them. Running
/// getFlatIcon() on the whole portrait doesn't work: its canvas-resize path mixes up its bounds and
/// draws every later layer off-canvas, giving a blank poster.
/datum/controller/subsystem/crediticons/proc/build_poster_icon(mutable_appearance/portrait)
	var/icon/canvas = icon('icons/blanks/32x32.dmi', "nothing")
	for(var/image/overlay as anything in sorted_poster_overlays(portrait))
		blend_poster_overlay(canvas, overlay)
	finish_poster_icon(canvas)
	return canvas

/datum/controller/subsystem/crediticons/proc/sorted_poster_overlays(mutable_appearance/portrait)
	. = list()
	for(var/image/overlay as anything in portrait.overlays)
		if(overlay.alpha)
			. += overlay
	sortTim(., GLOBAL_PROC_REF(cmp_atom_layer_asc))

/datum/controller/subsystem/crediticons/proc/blend_poster_overlay(icon/canvas, image/overlay)
	var/icon/part = getFlatIcon(image(overlay), SOUTH)
	if(part)
		canvas.Blend(part, ICON_OVERLAY, overlay.pixel_x + 1, overlay.pixel_y + 1)

/datum/controller/subsystem/crediticons/proc/finish_poster_icon(icon/canvas)
	canvas.Crop(1, 17, 32, 32)
	canvas.Scale(96, 48)

/datum/controller/subsystem/crediticons/fire(resumed = FALSE)
	while(length(poster_building))
		var/mutable_appearance/portrait = poster_building[1]
		if(portrait != building_portrait)
			building_portrait = portrait
			building_overlays = sorted_poster_overlays(portrait)
			building_canvas = icon('icons/blanks/32x32.dmi', "nothing")

		while(length(building_overlays))
			var/image/overlay = building_overlays[1]
			building_overlays.Cut(1, 2)
			blend_poster_overlay(building_canvas, overlay)
			if(MC_TICK_CHECK)
				return

		var/icon/canvas = building_canvas
		poster_building -= portrait
		building_portrait = null
		building_overlays = null
		building_canvas = null
		finish_poster_icon(canvas)
		poster_cache[portrait] = icon2base64(canvas)
		if(MC_TICK_CHECK)
			return

#undef CREDIT_CAPTURE_DELAY
#undef POSTER_PAGE_LOAD_DELAY
