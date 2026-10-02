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
	/// The name a SILENCE_POINT_AMBIENCE line in config/sound.txt names this category by
	var/config_name
	var/sound_file
	/**
	 * A set of short clips to draw from instead of sound_file, advanced per listener.
	 *
	 * advance_clip() requests a service when one clip ends, and the listener picks another without
	 * immediately repeating it. Native repeat alone would play the same short clip indefinitely
	 */
	var/list/files
	var/volume = 100
	/**
	 * Authored volume at the edge of this category's range.
	 *
	 * SSpoint_ambience stores min_volume / volume in floor_ratio. slim_send() applies that ratio to
	 * the current source volume, preserving the falloff shape when a source or category is lowered.
	 * The exit fade handles the ending, so this edge volume need not be the threshold of hearing.
	 * An absolute floor of 8 would leave only 8 dB of falloff at volume 20, compared with 17.5 dB
	 * at volume 60. At or below the floor, there would be no falloff at all
	 */
	var/min_volume = SOUND_DEFAULT_MIN_VOLUME
	/// min_volume / volume as authored, applied to the effective source volume by slim_send()
	var/floor_ratio = 0
	var/range = 5
	/// range squared. The walk gates on squared distance, so this is the comparison it makes
	var/range_sq = 0
	var/channel
	/// Roll a random pitch per stretch, as a looping_sound's vary flag does
	var/vary_pitch = FALSE
	/// Whether sources of this category get a plain loop in fallback mode. Torches do not: a timer for
	/// every sconce on the map is the load fallback mode sheds
	var/fallback = TRUE
	/// source -> its own file where it plays something other than the category's: the take voices
	/// picks for it, or a caller's sound_override
	var/list/source_sounds = list()
	/**
	 * Per-source multiplier of category volume, not an absolute volume.
	 *
	 * source_volumes[source] keeps a quieter fire's offset when category volume changes.
	 * slim_send() applies floor_ratio to the resulting source volume, keeping its edge proportional
	 */
	var/list/source_volumes = list()
	/// Explicit source multipliers before any indoor volume adjustment. An omitted scale preserves one.
	var/list/source_base_volumes = list()
	/**
	 * Marks a voice as part of one continuous feature rather than an isolated point.
	 *
	 * River handoffs can switch between voices on opposite sides of the listener. When
	 * source_continuous[source] is set, slim_send() keeps them centred to avoid a stereo reversal.
	 * Distance still changes volume. An update needs no packet when volume and environment match
	 * the last send and playback does not restart
	 */
	var/list/source_continuous = list()
	/**
	 * Volume multiplier for a listener under a roof.
	 *
	 * Point sources use occlusion to check the path through walls and doorways. A river is one
	 * continuous feature, so slim_send() applies indoors_volume_mult from the listener's roof
	 * state, or for underground water from the underground river fill, instead of walking a wall path for every
	 * river voice
	 */
	var/indoors_volume_mult = 1
	/// Base volume for indoor sources, when different from volume
	var/indoor_volume
	/// Position in categories, the index into each client's per-category sound datums. Set by
	/// SSpoint_ambience's New()
	var/index = 0
	/// This category's bit in a client's point_ambience_muted_mask, 1 << index, set by
	/// SSpoint_ambience's New()
	var/mask = 0
	/// The point_ambience_toggles bit that turns this category off for one listener, 0 where there is none
	var/disable_toggle = 0
	/// The falloff curve. Left at 0, SSpoint_ambience's New() resolves it to the band for this range,
	/// as playsound_local does per send. A live range edit keeps that band. A category can set its own
	var/falloff_exponent = 0
	/// 1 / falloff_exponent, so a send reads it rather than dividing
	var/inv_falloff_exponent = 0
	/// The same for a muffled send, whose exponent is SOUND_MUFFLE_EXPONENT_MULT times the clear one,
	/// a heavier falloff. Cached beside it because every source heard round a corner takes this path
	var/inv_muffled_exponent = 0
	/**
	 * How this category decays with distance.
	 *
	 * 1 drops the same proportion every tile, an even fade in decibels, ending on min_volume with slope
	 * still on it. Above 1 front-loads the drop for separation close in, less evenly. 0 keeps the band
	 * power curve above, which is what a category whose shape was chosen deliberately wants
	 */
	var/falloff_hardness = 1
	/// falloff_hardness for a muffled send, resolved with the exponents rather than per send
	var/muffled_hardness = 0
	/// Set where the curve is deliberate, so a global hardness override leaves it alone
	var/hardness_pinned = FALSE
	/// The null sound that stops this category's channel, built once and sent as is
	var/sound/stop_sound
	/**
	 * This category makes NO sound at all and its sources are kept out of the index.
	 *
	 * Set from SILENCE_POINT_AMBIENCE at the first fire() only, since de-indexing a whole category's
	 * sources is a bulk operation that must not land on a running server
	 */
	var/silenced = FALSE
	/**
	 * Whether a wall between listener and source stops or muffles this category.
	 *
	 * Off for anything whose sources are one long thing rather than a point: consecutive voices of a
	 * line sit close enough that one rock face takes both, so the whole run goes quiet from a spot
	 * where plenty of it is in the open. The river's wall walks would also be the longest, its range
	 * being the widest
	 */
	var/occlude = TRUE
	/**
	 * Whether each source gets a voice of its own, fixed by where it stands.
	 *
	 * The voice is a pitch lean and a place in the loop. Off for anything with a rhythm to keep, a
	 * clock must tick once a second, and for a clip set, whose file changes under it
	 */
	var/unique_voice = FALSE
	/**
	 * Files a source picks ONE of by where it stands, registered as its own sound.
	 *
	 * Neighbours then play different takes. Not a set the listener rotates through: that is files,
	 * above, and it costs a timer per listener where this costs nothing. A listener keeps its loaded
	 * take across handoffs, while a new stretch starts from the winning source's take
	 */
	var/list/voices
	/// The takes for a source whose area is not outdoors, where a category wants a fire in a room to
	/// be a different sound from one in the open. voices is then the outdoor set
	var/list/voices_indoors
	/// Whether a new stretch starts at a place in the loop chosen by source position.
	/// Source handoffs keep their current playback position.
	var/voice_place = TRUE
	/**
	 * Sends a source handoff from the centre before panning toward the new source.
	 *
	 * This prevents a sudden jump between ears without restarting the clip.
	 *
	 * A listener who stops after the switch can stay centred while standing services reuse the
	 * unchanged answer. Movement or another change that causes a send restores the pan. Clearing
	 * that answer to re-pan would force a full service on handoffs.
	 * At a switch, the two sources are similarly distant, so centring is close to the intended pan
	 */
	var/centre_handoff = TRUE
	/// Since boot, the source changing while this category plays
	var/handoffs = 0

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
 * Recomputes what a send reads in place of the authored numbers.
 *
 * Called wherever range or falloff_hardness is written. A band exponent resolved at boot is kept
 * across a range edit. A VV edit of falloff_exponent does not call this, so sends keep the curve of
 * the exponent the reciprocals were built from
 */
/datum/point_ambience_category/proc/resolve_derived()
	range_sq = range * range
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(range)
	inv_falloff_exponent = 1 / falloff_exponent
	inv_muffled_exponent = 1 / (falloff_exponent * SOUND_MUFFLE_EXPONENT_MULT)
	muffled_hardness = falloff_hardness * SOUND_MUFFLE_EXPONENT_MULT

/// Whether one listener has muted this category. Everything a listener's preferences can do to one
/// category goes here, so update_silenced sees it and a listener with nothing left on is unhooked
/datum/point_ambience_category/proc/muted_for(datum/preferences/prefs)
	return disable_toggle && (prefs.point_ambience_toggles & disable_toggle)

/// Drops a source's per source overrides. They hold a hard reference to it, so every path that
/// takes a source out of this category calls this
/datum/point_ambience_category/proc/forget_source(atom/source)
	source_sounds -= source
	source_volumes -= source
	source_base_volumes -= source
	source_continuous -= source

/datum/point_ambience_category/fire
	config_name = "fire"
	/**
	 * Gives each fire a take chosen by position and whether it is outdoors.
	 *
	 * The takes vary crackle timing, but each set shares the same source recordings.
	 *
	 * Braziers and campfires keep the roar whole, with its lows and top end cut, beneath varying
	 * stretches of crackle and without flares. Chopping the roar makes the loop audibly drop out,
	 * so it keeps its own crossfaded seam.
	 * Hearths, ovens and forges use quieter indoor takes with less low roar and softer crackle.
	 * Their takes start at different places, so nearby fires do not all repeat in step.
	 */
	sound_file = 'sound/ambience/point/fire_1.ogg'
	voices = list('sound/ambience/point/fire_1.ogg', 'sound/ambience/point/fire_2.ogg', 'sound/ambience/point/fire_3.ogg')
	voices_indoors = list('sound/ambience/point/fire_in_1.ogg', 'sound/ambience/point/fire_in_2.ogg', 'sound/ambience/point/fire_in_3.ogg')
	/// Outdoor level, set by ear against other point ambience categories
	volume = 32
	/// Indoor fire level, matching the outdoor one. Lower it to make a fire in a room quieter than one in the open
	indoor_volume = 32
	range = 6
	unique_voice = TRUE
	voice_place = TRUE
	/// Chosen to keep an 18.1 dB walk from the volume above to the range edge, the floor being read as
	/// a share of the volume
	min_volume = 4
	channel = CHANNEL_FIRE_AMBIENCE
	vary_pitch = TRUE

/**
 * Bone piles, evil trees and goblin portals.
 *
 * Supernatural landmarks meant to be felt before they are seen, hence full volume. They are mapped
 * sparsely, so sharing one voice costs little.
 *
 * A category is ONE voice, so flies or clocks riding this one would cut each other off, and range,
 * which a source cannot override, differs for each. So each has a category of its own.
 */
/datum/point_ambience_category/misc
	config_name = "misc"
	sound_file = 'sound/vo/mobs/ghost/skullpile_loop.ogg'
	volume = 100
	range = 6
	/// A starting guess for a sustained broadband loop. UNTESTED
	min_volume = 8
	channel = CHANNEL_MISC_AMBIENCE

/**
 * Flies on a rotting body.
 *
 * Short range on purpose: a fly cloud is an intimate sound, tighter than a sconce's range, and at
 * misc's range a corpse is heard two rooms away. Corpses are the one source here that turns up
 * ANYWHERE, indoors included, and their count scales with how much dying happens
 */
/datum/point_ambience_category/rot
	config_name = "rot"
	/// Its own copy normalised with the other point ambience clips, the original is shared with
	/// spells that were tuned against it
	sound_file = 'sound/ambience/point/flies.ogg'
	volume = 50
	range = 3
	/// A starting guess for a sustained broadband loop. UNTESTED
	min_volume = 8
	channel = CHANNEL_ROT_AMBIENCE

/// Grandfather and wall clocks. Short range, since at misc's range a manor's clocks reach each
/// other and a category plays one voice
/datum/point_ambience_category/clock
	config_name = "clock"
	/// Its own normalised copy, the original is shared with the trap and contraption ticks
	sound_file = 'sound/ambience/point/clock.ogg'
	volume = 14
	range = 4
	/// The one floor with a confirmed reading behind it: a clock at 3.5 is audible in play. Ticks are
	/// transients with a sharp attack and stay audible lower than the sustained crackle and hiss
	min_volume = 3
	channel = CHANNEL_CLOCK_AMBIENCE

/**
 * Fountains.
 *
 * A category is one voice, so anything else riding this one is cut by any nearer fountain. Rivers
 * have their own category, see /river below.
 *
 * A RANGE UP TO THE RIVER'S COSTS NOTHING. max_range is the largest range of any category and it
 * sizes the walk's box for every service on the map, so one above the river's would be paid by
 * everyone. At hardness 1 the walk from volume to floor is spread evenly across the range, so a
 * longer range buys both audible tiles and a gentler step
 */
/datum/point_ambience_category/water
	config_name = "water"
	sound_file = 'sound/misc/waterloop.ogg'
	volume = 35
	range = 7
	/// A starting guess for a sustained broadband loop. UNTESTED, and the first to raise if fountains
	/// cut out before their range edge
	min_volume = 8
	channel = CHANNEL_WATER_AMBIENCE

/**
 * Gives river voices their own range and channel, separate from fountains.
 *
 * Voices sit on river turfs, so their range must reach the bank before it reaches a listener. At
 * range 5, a seven-tile river leaves about a tile and a half of audible bank.
 *
 * Range 8 sets max_range and widens the candidate box for every service, including those far from
 * water. register_spread_source() leaves every river tile within RIVER_SPREAD of a voice, so a
 * listener one tile off the water is at most RIVER_SPREAD + 1 away. Range 8 covers a spread of 6
 * with a tile to spare and still fits three cells per axis.
 *
 * Each listener advances through the short POINT_AMBIENCE_RIVER clips instead of repeating one
 * file. The same set plays at every hour
 */
/datum/point_ambience_category/river
	config_name = "river"
	/// Its own normalised copies, the originals are the river areas' ambience beds. Matches the set
	/// rather than the day takes, or an empty set would fall back to a clip with calls on it
	sound_file = 'sound/ambience/point/river_night_1.ogg'
	files = POINT_AMBIENCE_RIVER
	volume = 45
	range = 8
	/// Its voices are one continuous line and always sent centred, so a switch has nothing to centre
	centre_handoff = FALSE
	/// Gentler than the band sound_falloff_for_range() gives this range. A river is a bed of sound
	/// stood beside, and on that band it falls away within a few tiles of the bank
	falloff_exponent = 0.5
	/// A bank is stood beside rather than walked past, so it keeps the curve above and a global
	/// hardness override does not reach it
	falloff_hardness = 0
	hardness_pinned = TRUE
	/// The band curve above holds near full volume and drops at the edge, so the floor is where it
	/// lands rather than what it fades through. 6.5 keeps the last tile's step at 7.5 dB
	min_volume = 6.5
	channel = CHANNEL_RIVER_AMBIENCE
	occlude = FALSE
	/// Faint through a roof. A river carries through a wall in a way a fountain does not, so this
	/// is a level rather than a silence, and it is what a riverside house gets instead of occlusion
	indoors_volume_mult = 0.3

/**
 * Wall sconces and standing fires. A handheld torch is heard by its carrier alone, off the index.
 *
 * No vary_pitch, unlike fire: the clip carries its own flicker and a roll on top of it doubles up.
 * Each sconce still sounds unlike its neighbour through unique_voice below: a pitch lean and a
 * place in the loop, both fixed by where it stands
 */
/datum/point_ambience_category/torch
	config_name = "torch"
	fallback = FALSE
	/// Sconces, standing fires and the listener's own torch are all this category, so one toggle turns
	/// off every torch they can hear rather than only the ones on the map
	disable_toggle = SOUND_DISABLE_TORCH_AMBIENCE
	/// The crackle recording. The fire takes use the heavier roar as their bed
	sound_file = 'sound/ambience/point/torch.ogg'
	/// Faint against the rest by design. Set by ear
	volume = 12
	range = 4
	unique_voice = TRUE
	/// Chosen to keep a 12 dB walk from the volume above to the range edge, the floor being read
	/// as a share of the volume
	min_volume = 3
	channel = CHANNEL_TORCH_AMBIENCE
