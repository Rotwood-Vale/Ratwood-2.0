/**
 * Point-ambience state owned by one client.
 *
 * Stores per-category selection and playback, cached rankings, the hearing anchor and movement
 * scheduling. Created with the client.
 *
 * cache_turf, cache_version and cache_volume describe the inputs to cache_static. That selection
 * can include an occlusion-selected runner-up. Reuse requires unchanged listener inputs and valid
 * source history. The shared tile cache stores geometric rankings before occlusion.
 */
/datum/point_ambience_listener
	/// Selected source per category (category datum to atom). Always initialized as a list
	var/list/sources = list()
	/// Playback slots indexed by category.index, containing source, pan, volume, fade and
	/// clip-timer state
	var/list/slots = list()
	/// Inputs of the last clear river send. Null cost prevents reuse after muffling or a stop
	var/river_cost
	var/river_scale
	var/river_version
	/// At least one category slot has an expired clip for the next point ambience service to advance
	var/clip_due = FALSE
	/// Reusable sound datums indexed by category.index. Their existence alone does not indicate
	/// active playback
	var/list/sounds = list()
	/// Self source used by the last service. A changed carried torch invalidates the standing
	/// shortcut
	var/atom/cache_self
	/// Cached can_hear() result, valid until profile_until.
	/// Refreshed by an active service. The unchanged-standing shortcut leaves it untouched
	var/hearing = FALSE
	/// Alternate hearing anchor, normally a detached dullahan head. Null uses the mob's own
	/// position
	var/atom/movable/ear
	/// Tracks the detached head and its carrier
	var/datum/point_ambience_head_watch/head_watch
	var/profile_until = 0
	/// world.time before which the move hook will not service this client again, when
	/// SSpoint_ambience.move_service_interval is set
	var/next_service = 0
	/// world.time the move hook or the queue last served this client, queued clip and door services
	/// included. The standing walk passes over anyone served within SSpoint_ambience.standing_skip of now
	var/last_service = 0
	var/last_move
	/// world.time of the last move, forced or not, made at a step delay faster than a natural run. Null
	/// once a natural step ends the silence or a service finds it older than POINT_AMBIENCE_SPEED_STILL
	var/speed_moved
	/// Everything but a torch in hand faded for moving too fast, until a service finds them slowed
	var/speed_silenced = FALSE
	/// world.time before which a forced move or a floor change waits for the interval like a step
	var/jump_next = 0
	/// Nothing to hear from point ambience: off, its volume at zero or under the cutoff, or every
	/// category muted. Set at login and by the volume menu, never per step
	var/silenced = FALSE
	/// Bitmask of categories muted by this listener
	var/muted_mask = 0
	/// Hearing turf used for the cached listener selection
	var/turf/cache_turf
	var/cache_version
	var/cache_volume
	var/list/cache_static

/**
 * Playback state for one listener and category, indexed by category.index.
 *
 * Selection and playback have separate lifetimes: a fade-out removes its source from
 * point_ambience.sources but retains this slot until playback ends. A pending fade_next with null
 * fade_target identifies that exit fade. Re-entry can resume an ordinary loop without restarting
 * it.
 *
 * stop_for() cancels the category's timer and fade. stop_all_for() also clears slots and listener
 * caches. Reusable sound datums may remain allocated after stopping.
 *
 * Fields other than the two owners start null. Preserve these sentinels: null fade_target means
 * fade-out, and null last_volume means stopped playback.
 */
/datum/point_ambience_slot
	/// Client owning this slot, or null after disconnect
	var/client/listener_client
	var/datum/point_ambience_category/category
	var/turf/source_turf
	var/frequency
	var/last_volume
	var/file
	var/timer
	/// Second-ranked source used to blend the stereo direction between nearby sources
	var/runner_up
	/// The area environment of the last send. A carried torch is skipped only while this and the
	/// volume both still match
	var/environment
	/// A fade in progress: the world.time its next step is due. Null when the category is not fading
	var/fade_next
	/// Target volume for a fade in. null for a fade out
	var/fade_target
	/// Steps the fade may still send
	var/fade_left
	/// A clip-set timer expired and the next service must choose another clip for this category
	var/clip_due

/datum/point_ambience_slot/New(client/listener_client, datum/point_ambience_category/category)
	. = ..()
	src.listener_client = listener_client
	src.category = category
