/**
 * # Point Ambience Category
 *
 * One kind of ambient sound: what plays, how loud, how far, and on which reserved channel.
 *
 * Sources register under a category TYPEPATH, and each category serves its nearest source to a
 * listener independently, so a hearth and a wall sconce are heard at the same time while two
 * hearths are not. A category is therefore one voice and one reserved channel, which is what makes
 * splitting one expensive and sharing one lossy.
 *
 * File and volume can be overridden per source, so things that share neither theme nor loudness can
 * still share a category. RANGE cannot: it is the gate the shared walk filters on, so a kind that
 * needs its own reach needs its own category.
 */
/datum/point_ambience_category
	/// The name a SILENCE_POINT_AMBIENCE line in config/sound.txt names this category by
	var/config_name
	var/sound_file
	/**
	 * A set of short clips to draw from instead of sound_file, advanced per listener: when the
	 * clip a listener is hearing runs out they are served afresh and pick another, never the one
	 * just played. For a sound whose files are a few seconds each, which native-repeated one at a
	 * time is one clip forever
	 */
	var/list/files
	var/volume = 100
	/**
	 * Volume this category fades TO at its range edge, AT THE VOLUME AUTHORED BESIDE IT. What is
	 * kept is the ratio between the two, floor_ratio below, and that is what the send reads: the
	 * floor sets the walk's shape, dB per tile across the range, and a shape is a proportion. Held as
	 * a number here because 8 at 60 reads and 0.133 does not.
	 *
	 * A ratio rather than an absolute, for two reasons. Every clip is normalised to one level, so a
	 * number means the same loudness in any category, and the fade owns the ending, so the edge does
	 * not have to land at the threshold of hearing. An absolute floor under a lowered volume crushes
	 * the walk: fire at 20 over a floor of 8 has 8 dB of falloff where 60 over 8 has 17.5, and at or
	 * below the floor it has none
	 */
	var/min_volume = SOUND_DEFAULT_MIN_VOLUME
	/// min_volume / volume as authored, resolved on New(). The Volume knob leaves it alone, so the
	/// floor follows. The Floor knob rewrites it from the number typed
	var/floor_ratio = 0
	var/range = 5
	/// range squared. The walk gates on squared distance, so this is the comparison it makes
	var/range_sq = 0
	var/channel
	/// Roll a random pitch per stretch, like the old loops' vary flag
	var/vary_pitch = FALSE
	/// Whether sources of this category get a plain loop in fallback mode. Torches do not:
	/// hundreds of them on timers is the load that got torch crackle disabled in the first place
	var/fallback = TRUE
	/**
	 * source -> its own file, where it wants something other than the category's. A category is a
	 * channel and a slot, not necessarily one sound, so things that share neither theme nor loudness
	 * can still share one. Range stays per-category, since it is the per-source gate the shared walk
	 * filters on
	 */
	var/list/source_sounds = list()
	/**
	 * source -> a MULTIPLE of the category volume, not a volume. A kind of fire two dB under the
	 * rest keeps that offset when the category moves, and min_volume keeps meaning the edge for
	 * every source, the floor being a share of whatever this resolves to. An absolute here made a
	 * category's own volume unreachable for any source carrying one, and made the floor a lie for it
	 */
	var/list/source_volumes = list()
	/**
	 * source -> TRUE where the source is one voice of something long rather than a thing at a point.
	 * A river's nearest voice keeps changing as you walk, so the sound must NOT restart on a handoff
	 * and must NOT pan, the two voices being equidistant on opposite sides at that moment. Falloff
	 * still applies, so the run swells as you approach
	 */
	var/list/source_continuous = list()
	/**
	 * What this category is multiplied by for a listener under a roof. 1 is no change and is the
	 * default, since everything else answers a wall with occlusion, which is the finer instrument:
	 * it asks about THIS line and finds a doorway with its corner probe, where a roof is all this
	 * knows. For the river occlusion is the wrong question, so this is the only one it can ask
	 */
	var/indoors_volume_mult = 1
	/// Position in categories, the index into each client's per-category sound datums. Set on New()
	var/index = 0
	/// This category's bit in a client's point_ambience_muted_mask, 1 << index, set on New()
	var/mask = 0
	/// The preference toggle that turns this category off for one listener, 0 where there is none
	var/disable_toggle = 0
	/// The falloff curve. Left at 0, it is the band for this range, resolved once on New() and the
	/// same answer playsound_local computes per send. A category can set its own instead
	var/falloff_exponent = 0
	/// 1 / falloff_exponent, so a send reads it rather than dividing
	var/inv_falloff_exponent = 0
	/// The same for a muffled send, which uses a shallower curve. Cached beside it because muffling
	/// is no longer rare: every source heard round a corner takes this path
	var/inv_muffled_exponent = 0
	/**
	 * How this category decays with distance. 1 drops the same proportion every tile, an even
	 * fade in decibels, ending on min_volume with slope still on it. Above 1 front-loads the
	 * drop for separation close in, less evenly. 0 keeps the band power curve above, which is
	 * what a category whose shape was chosen deliberately wants
	 */
	var/falloff_hardness = 1
	/// falloff_hardness for a muffled send, resolved with the exponents rather than per send
	var/muffled_hardness = 0
	/// Set where the curve is deliberate, so a global hardness override leaves it alone
	var/hardness_pinned = FALSE
	/// The null sound that stops this category's channel, built once and sent as is
	var/sound/stop_sound
	/**
	 * This category makes NO sound at all and its sources are kept out of the index. Set from
	 * SILENCE_POINT_AMBIENCE at the first fire() only, since de-indexing hundreds of sources is a
	 * bulk operation that must not land on a running server
	 */
	var/silenced = FALSE
	/**
	 * Whether a wall between listener and source silences this category. Off for anything whose
	 * sources are one long thing rather than a point: consecutive voices of a line sit close enough
	 * that one rock face takes both, so the whole run goes quiet from a spot where plenty of it is
	 * in the open. It is also the dearest check on the map, the widest range walking furthest
	 */
	var/occlude = TRUE
	/**
	 * Whether each source gets a voice of its own, a pitch lean and a place in the loop fixed by
	 * where it stands. Off for anything with a rhythm to keep, a clock must tick once a second,
	 * and for a clip set, whose file changes under it
	 */
	var/unique_voice = FALSE
	/**
	 * Files a source picks ONE of by where it stands, registered as its own sound, so neighbours
	 * play different takes. Not a set the listener rotates through: that is files, above, and it
	 * costs a timer per listener where this costs nothing. A listener keeps its loaded take across
	 * handoffs, while a new stretch starts from the winning source's take
	 */
	var/list/voices
	/// The takes for a source whose area is not outdoors, where a category wants a fire in a room to
	/// be a different sound from one in the open. voices is then the outdoor set
	var/list/voices_indoors
	/**
	 * Whether unique_voice also gives each source its own starting place in the loop. Off where the
	 * takes above already tell sources apart, since a new stretch already differs by its file
	 */
	var/voice_place = TRUE
	/**
	 * The send that switches this category from one source to the next goes out centred, and the next
	 * update pans to the new source. So a switch between two sources on opposite sides passes through
	 * the middle rather than leaping from one ear to the other. The clip carries on either way.
	 *
	 * A listener who stops right after a switch keeps the centre until they move, since standing still
	 * sends nothing. Not refreshed on purpose: a switch lands on the first update past the halfway
	 * point, so they are within a few tiles of it, where centred is close to right, and clearing the
	 * cached answer to re-pan them cost a full service on about a third of switches for anyone walking
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

/// Recomputes what a send reads in place of the authored numbers. Called wherever range or
/// falloff_hardness is written, so the copies never disagree with what they copy
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
	return disable_toggle && (prefs.toggles & disable_toggle)

/// Drops a source's per source overrides. They hold a hard reference to it, so every path that
/// takes a source out of this category calls this
/datum/point_ambience_category/proc/forget_source(atom/source)
	source_sounds -= source
	source_volumes -= source
	source_continuous -= source

/datum/point_ambience_category/fire
	config_name = "fire"
	/**
	 * Two sets of three takes, and each fire plays the take its position picks, so two hearths are
	 * two fires and not one. OUTSIDE, braziers and campfires: the old torch recording as the bed
	 * (heavier than the old fire recording, which the torch has now), WHOLE and uncut, looped with
	 * one crossfade at its own seam, 7 dB off its lows, 12 dB off everything over 2 kHz, no flares,
	 * and stretches of the old fire recording's crackle laced on top, 6 dB under the bed, swelling
	 * gently busier and calmer. Cutting a continuous roar into short shuffled pieces was heard as
	 * drops and a loop that did not join, and the roar's own even hiss up top, as loud there as the
	 * crackle, was heard as back to back crackle with no variety. INSIDE, hearths, ovens and forges:
	 * the other way round, the crackle recording as the base, pitched down a tenth as a whole so a
	 * hearth crackles deeper than a sconce, re-laced whole into 14 s, and the roar 12 dB under it
	 * with 9 dB off its lows and flares of 2 dB at most, crossfaded back into its own start so it
	 * loops. Takes differ in where the roar starts and where the crackles fall. A listener keeps the
	 * loaded take across a handoff, while a new stretch uses the nearest fire
	 */
	sound_file = 'sound/ambience/point/fire_1.ogg'
	voices = list('sound/ambience/point/fire_1.ogg', 'sound/ambience/point/fire_2.ogg', 'sound/ambience/point/fire_3.ogg')
	voices_indoors = list('sound/ambience/point/fire_in_1.ogg', 'sound/ambience/point/fire_in_2.ogg', 'sound/ambience/point/fire_in_3.ogg')
	/// Halved by ear. 60 was chosen against a recording 16 dB under the rest of the set, so once
	/// every clip was normalised it put a hearth above a fountain. This puts it just under one
	volume = 30
	range = 6
	unique_voice = TRUE
	voice_place = FALSE
	/**
	 * Sustained and broadband like the torch, so it starts where the torch does. Follows the
	 * halved volume above, the floor being read as a fraction of it: left at 8 it would flatten
	 * the walk from 17.5 dB to 11.5
	 */
	min_volume = 4
	channel = CHANNEL_FIRE_AMBIENCE
	vary_pitch = TRUE

/**
 * Bone piles, evil trees and goblin portals.
 *
 * Supernatural landmarks meant to be felt before they are seen, hence the long range and full
 * volume. Only a handful are mapped, so they never crowd each other.
 *
 * A category is ONE voice: flies and clocks on this one muted each other, and RANGE, the one
 * property that is per-category, is why they are separate categories rather than overrides.
 */
/datum/point_ambience_category/misc
	config_name = "misc"
	sound_file = 'sound/vo/mobs/ghost/skullpile_loop.ogg'
	volume = 100
	range = 6
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED
	min_volume = 8
	channel = CHANNEL_MISC_AMBIENCE

/**
 * Flies on a rotting body. Short range on purpose: a fly cloud is an intimate sound, tighter than
 * the four tiles a hand-held torch carries, and at misc's six you heard a corpse two rooms away.
 * Corpses are the one source here that turns up ANYWHERE, indoors included, and there is no fixed
 * count of them: it scales with how much dying happens
 */
/datum/point_ambience_category/rot
	config_name = "rot"
	/// Its own copy normalised with the other point ambience clips, the original is shared with
	/// spells that were tuned against it
	sound_file = 'sound/ambience/point/flies.ogg'
	volume = 50
	range = 3
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED
	min_volume = 8
	channel = CHANNEL_ROT_AMBIENCE

/// Grandfather and wall clocks over 4 tiles. At misc's 6 a manor's clocks reached each other. The
/// loop this replaced played at 10 and read too quiet once the clips were normalised
/datum/point_ambience_category/clock
	config_name = "clock"
	/// Its own normalised copy, the original is shared with the trap and contraption ticks
	sound_file = 'sound/ambience/point/clock.ogg'
	volume = 14
	range = 4
	/// The one floor with a confirmed reading behind it: a clock at 3.5 is audible in play. Ticks are
	/// transients with a sharp attack and carry far lower than the crackles and hiss below
	min_volume = 3
	channel = CHANNEL_CLOCK_AMBIENCE

/**
 * Fountains and wells. The waterwheel rode this briefly and came back out: it never had a sound to
 * restore, and a fountain nearer than the wheel silenced it. Rivers split off for the same reason
 * plus a longer range. See /river below.
 *
 * SEVEN COSTS NOTHING. max_range is the largest range of any category and it sizes the walk's box
 * for every service on the map, so this is free at anything up to the river's eight and would be
 * paid by everyone above it. It buys audible tiles rather than a gentler ending: the curve is
 * proportional to range, so raising it stretches the same shape and the last tile still drops from
 * about eleven to the floor. That last step is the exponent's, not this one's
 */
/datum/point_ambience_category/water
	config_name = "water"
	sound_file = 'sound/misc/waterloop.ogg'
	volume = 35
	range = 7
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED, and the
	/// one most reported as cutting out, so this is the first to raise if 8 is not enough
	min_volume = 8
	channel = CHANNEL_WATER_AMBIENCE

/**
 * Rivers only, split off water for range and for a channel of its own.
 *
 * Voices sit on river TURFS, mid-water, so the range pays for crossing to the bank before it reaches
 * anyone: at water's range of 5 a seven-tile river leaves about a tile and a half of audible bank,
 * which is why you had to stand on the edge to hear it.
 *
 * RANGE 8 IS NOT FREE. It is the widest of any category and max_range sets the walk's box for every
 * service on the map, so this is ~30% more sources ranked per step by everyone, water or not. 8
 * specifically: voices sit at most RIVER_SPREAD apart, so a listener midway between two is
 * hypot(spread/2, half the width) from the nearer, which 8 covers on rivers up to 14 tiles wide
 * where 6 gives out at 9. It is also the largest range still fitting three cells per axis.
 *
 * The clips are four to seven seconds each, so they are a set advanced per listener rather than one
 * file looped. The same set plays at every hour, POINT_AMBIENCE_RIVER says why there is no day set
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
	/// The old curve, kept on purpose. The steeper band suits something walked past, and a river is
	/// a bed of sound stood beside: at 1 it fell away within a few tiles of the bank
	falloff_exponent = 0.5
	/// A bank is stood beside rather than walked past, so it keeps the curve above and a global
	/// hardness override does not reach it
	falloff_hardness = 0
	hardness_pinned = TRUE
	/**
	 * The band curve above holds near full volume and then drops at the edge, so the floor is where
	 * it lands rather than what it fades through. 6.5 keeps the last tile's step at 7.5 dB, and moved
	 * with the volume above so the whole curve dropped a level without changing shape
	 */
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
 * Each sconce still sounds unlike its neighbour through unique_voice below, which leans the pitch
 * and sets the starting loop position from where playback begins
 */
/datum/point_ambience_category/torch
	config_name = "torch"
	fallback = FALSE
	/// Sconces, standing fires and the listener's own torch are all this category, so one toggle turns
	/// off every torch they can hear rather than only the ones on the map
	disable_toggle = SOUND_DISABLE_TORCH_AMBIENCE
	/// The old fire recording, swapped with the torch's by ear. See the fire category above
	sound_file = 'sound/ambience/point/torch.ogg'
	/**
	 * Halved by ear for the same reason as fire above, then another quarter off. A sconce is meant
	 * to be faint against the rest, and this still leaves it ~7 dB over the level that was
	 * inaudible before normalising
	 */
	volume = 11
	range = 4
	unique_voice = TRUE
	/**
	 * Follows the volume above, the floor being read as a fraction of it, so a sconce keeps the
	 * ~11.5 dB walk it had at 30 over 8.
	 *
	 * Point ambience clips are normalised to about -30 dB A-weighted, as loud as the set goes
	 * without clipping, so a volume or a floor is the same loudness on any category and the numbers
	 * alone carry how loud each one is
	 */
	min_volume = 3
	channel = CHANNEL_TORCH_AMBIENCE
