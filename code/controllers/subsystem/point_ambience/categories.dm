/**
 * # Point Ambience Category
 *
 * One kind of ambient sound, with its own clips, range, volume and reserved channel.
 *
 * A listener hears one source in each category, chosen by distance and occlusion. A hearth and a
 * sconce can play together, while two hearths compete for the fire channel. Splitting a category
 * adds a channel and a send. Sharing one means losing a separate voice.
 *
 * Sources register by category type path and can override their file and volume. Range belongs to
 * the category because the shared walk uses it to select candidates. Sources that need different
 * reach need separate categories.
 *
 * Point ambience clips are prepared to comparable levels. Their authored levels and category
 * volumes still differ, so the same volume number need not sound equally loud in every category.
 */
/datum/point_ambience_category
	/// Category name accepted by SILENCE_POINT_AMBIENCE in config/sound.txt
	var/config_name
	var/sound_file
	/// Per-listener clip set, advanced by advance_clip() without immediately repeating a clip.
	/// Uses successive clips instead of natively repeating sound_file
	var/list/files
	var/volume = 100
	/// Authored volume at the range edge. floor_ratio scales it with the effective source volume.
	/// Keep the floor proportional so quieter sources retain their attenuation curve
	var/min_volume = SOUND_DEFAULT_MIN_VOLUME
	/// min_volume / volume as authored, applied to the effective source volume by slim_send()
	var/floor_ratio = 0
	var/range = 5
	/// Squared range used to reject ranking candidates without taking a square root
	var/range_sq = 0
	var/channel
	/// Roll a random pitch per stretch, as a looping_sound's vary flag does
	var/vary_pitch = FALSE
	/// Whether sources of this category get a plain loop in fallback mode. Torches do not: a timer for
	/// every sconce on the map is the load fallback mode sheds
	var/fallback = TRUE
	/// Per-source sound-file overrides, from recording selection or an explicit sound_override
	var/list/source_sounds = list()
	/// Per-source multipliers of category volume.
	/// Preserve relative levels when the category is retuned. floor_ratio scales the edge volume too
	var/list/source_volumes = list()
	/// Explicit source multipliers before any indoor volume adjustment. An omitted scale preserves one.
	var/list/source_base_volumes = list()
	/// Base volume for indoor sources, when different from volume
	var/indoor_volume
	/// Position in categories, the index into each client's per-category sound datums. Set by
	/// SSpoint_ambience's New()
	var/index = 0
	/// This category's bit in a client's point_ambience.muted_mask, 1 << index, set by
	/// SSpoint_ambience's New()
	var/mask = 0
	/// The point_ambience_toggles bit that turns this category off for one listener, 0 where there is none
	var/disable_toggle = 0
	/// Distance falloff exponent. Zero selects a range-band default at construction. Later range
	/// edits retain it
	var/falloff_exponent = 0
	/// Reciprocal clear-path exponent, precomputed for playback
	var/inv_falloff_exponent = 0
	/// Reciprocal muffled exponent, including SOUND_MUFFLE_EXPONENT_MULT
	var/inv_muffled_exponent = 0
	/// Distance decay: 1 gives even decibel loss. Higher values drop faster near the source.
	/// Zero uses the category's range-band curve
	var/falloff_hardness = 1
	/// Precomputed falloff_hardness for muffled playback
	var/muffled_hardness = 0
	/// Excludes this category from global hardness overrides
	var/hardness_pinned = FALSE
	/// The null sound that stops this category's channel, built once and sent as is
	var/sound/stop_sound
	/// Excludes sources from indexing and playback.
	/// Loaded from SILENCE_POINT_AMBIENCE before live servicing begins
	var/silenced = FALSE
	/// Whether indexed sources use direct and corner occlusion. Rivers use their fill instead
	var/occlude = TRUE
	/// Applies position-derived pitch and playback phase to individual sources.
	/// Disabled for rhythmic loops such as clocks and for per-listener clip sets
	var/unique_voice = FALSE
	/// Position-selected recordings assigned during registration, without a clip-advance timer.
	/// New playback uses the winning source's recording. Handoffs keep the recording already playing
	var/list/voices
	/// Indoor recording variants. Voices supplies the outdoor set when this is present
	var/list/voices_indoors
	/// Whether a new stretch starts at a place in the loop chosen by source position.
	/// Source handoffs keep their current playback position.
	var/voice_place = TRUE
	/// Centres the first handoff packet to avoid a pan reversal. The next positional send restores pan.
	/// A stationary listener can stay centred until another event triggers that send
	var/centre_handoff = TRUE

/// Validates live range edits, protects derived range_sq, and invalidates rankings after accepted edits
/datum/point_ambience_category/vv_edit_var(var_name, var_value)
	if(var_name == "range" && (!isnum(var_value) || var_value <= SOUND_DEFAULT_FALLOFF_DISTANCE))
		return FALSE
	if(var_name == "range_sq")
		return FALSE
	. = ..()
	if(!. || SSpoint_ambience?.categories_by_path[type] != src)
		return
	if(var_name == "range")
		SSpoint_ambience.refresh_category_ranges()
	else
		if(var_name == "falloff_hardness")
			resolve_derived()
		SSpoint_ambience.clear_tile_cache()

/**
 * Refreshes squared range and the precomputed clear/muffled falloff values.
 *
 * Range and hardness edits call this. A range edit retains the exponent selected at construction.
 * The river editor also calls it after explicit exponent changes.
 */
/datum/point_ambience_category/proc/resolve_derived()
	range_sq = range * range
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(range)
	inv_falloff_exponent = 1 / falloff_exponent
	inv_muffled_exponent = 1 / (falloff_exponent * SOUND_MUFFLE_EXPONENT_MULT)
	muffled_hardness = falloff_hardness * SOUND_MUFFLE_EXPONENT_MULT

/// Returns whether the listener's preferences mute this category. Also used to determine whether to
/// detach movement hooks
/datum/point_ambience_category/proc/muted_for(datum/preferences/prefs)
	return disable_toggle && (prefs.point_ambience_toggles & disable_toggle)

/// Removes a source's sound and volume overrides, releasing the category's references to it
/datum/point_ambience_category/proc/forget_source(atom/source)
	source_sounds -= source
	source_volumes -= source
	source_base_volumes -= source

/datum/point_ambience_category/fire
	config_name = "fire"
	/// Default outdoor recording. Registration selects a position-derived take from the appropriate
	/// indoor/outdoor set
	sound_file = 'sound/ambience/point/fire_1.ogg'
	voices = list('sound/ambience/point/fire_1.ogg', 'sound/ambience/point/fire_2.ogg', 'sound/ambience/point/fire_3.ogg')
	voices_indoors = list('sound/ambience/point/fire_in_1.ogg', 'sound/ambience/point/fire_in_2.ogg', 'sound/ambience/point/fire_in_3.ogg')
	/// Base volume for outdoor fire sources
	volume = 32
	/// Base volume for indoor fire sources
	indoor_volume = 32
	range = 6
	unique_voice = TRUE
	voice_place = TRUE
	min_volume = 4
	channel = CHANNEL_FIRE_AMBIENCE
	vary_pitch = TRUE

/// Shared ambience for supernatural landmarks, including bone piles, evil trees and goblin portals
/datum/point_ambience_category/misc
	config_name = "misc"
	sound_file = 'sound/vo/mobs/ghost/skullpile_loop.ogg'
	volume = 100
	range = 6
	min_volume = 8
	channel = CHANNEL_MISC_AMBIENCE

/// Short-range fly ambience from rotting corpses
/datum/point_ambience_category/rot
	config_name = "rot"
	/// Normalized fly recording for ambience. Spell effects use the original asset
	sound_file = 'sound/ambience/point/flies.ogg'
	volume = 50
	range = 3
	min_volume = 8
	channel = CHANNEL_ROT_AMBIENCE

/// Short-range ticking from grandfather and wall clocks
/datum/point_ambience_category/clock
	config_name = "clock"
	/// Normalized clock recording. Traps and contraptions use the original asset
	sound_file = 'sound/ambience/point/clock.ogg'
	volume = 14
	range = 4
	min_volume = 3
	channel = CHANNEL_CLOCK_AMBIENCE

/**
 * Fountain ambience.
 *
 * This category sets the largest indexed range with the default settings. Increasing it expands
 * candidate gathering for every indexed category. River fill is separate.
 */
/datum/point_ambience_category/water
	config_name = "water"
	sound_file = 'sound/misc/waterloop.ogg'
	volume = 35
	range = 7
	min_volume = 8
	channel = CHANNEL_WATER_AMBIENCE

/**
 * Plays one centred river bed per listener, using the fill's path distance for attenuation.
 *
 * Eligible water seeds a same-floor fill, and walls and openings block it. No river speakers are
 * indexed. Each listener advances through POINT_AMBIENCE_RIVER without restarting on movement.
 * The same set plays at every hour. Reach is fixed because changing it requires rebuilding the fill
 */
/datum/point_ambience_category/river
	config_name = "river"
	sound_file = 'sound/ambience/point/river_night_1.ogg'
	files = POINT_AMBIENCE_RIVER
	volume = 45
	range = POINT_AMBIENCE_RIVER_FILL_RANGE
	fallback = FALSE
	/// River playback stays centred, and moving the hearing turf carrier is not a source handoff
	centre_handoff = FALSE
	/// Gradual attenuation away from the river bank
	falloff_exponent = 0.5
	/// Uses the river's band curve rather than the shared hardness curve
	falloff_hardness = 0
	hardness_pinned = TRUE
	min_volume = 6.5
	channel = CHANNEL_RIVER_AMBIENCE
	occlude = FALSE

/// Keeps fill reach fixed while allowing live river volume, floor and curve tuning
/datum/point_ambience_category/river/vv_edit_var(var_name, var_value)
	if(var_name == "range")
		return FALSE
	if(var_name == "falloff_exponent" && (!isnum(var_value) || var_value <= 0))
		return FALSE
	if(var_name == "min_volume" && (!isnum(var_value) || var_value < 0))
		return FALSE
	. = ..()
	if(!.)
		return
	if(var_name == "falloff_exponent")
		resolve_derived()
	if(var_name == "min_volume")
		floor_ratio = clamp(min_volume / max(volume, 1), 0.001, 1)

/**
 * Wall sconces, standing fires and the listener's carried torch.
 *
 * Carried torches are heard only by their holder and stay outside the index. Placed sources use
 * position-derived pitch and phase without an additional random pitch roll.
 */
/datum/point_ambience_category/torch
	config_name = "torch"
	fallback = FALSE
	/// Disables placed and carried torch ambience
	disable_toggle = SOUND_DISABLE_TORCH_AMBIENCE
	sound_file = 'sound/ambience/point/torch.ogg'
	volume = 12
	range = 4
	unique_voice = TRUE
	min_volume = 3
	channel = CHANNEL_TORCH_AMBIENCE
