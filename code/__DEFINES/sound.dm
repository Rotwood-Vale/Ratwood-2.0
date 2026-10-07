/*
 * WHICH SOUND SYSTEM TO USE
 *
 * Choose by playback behavior first, then consider active sources, listeners and update frequency.
 * These systems handle different jobs. A sound lasting several seconds may need different
 * tracking from a short effect even when its source never moves.
 *
 * ONE-SHOT: playsound() / playsound_local()
 *
 * Use for short effects such as footsteps, impacts and door clicks, or sounds whose position can
 * stay fixed during playback. playsound() gathers nearby listeners. playsound_local() sends to
 * one mob. Position, attenuation and pan are calculated when sent and do not follow later movement.
 *
 * Work follows the number of calls and listeners reached. Restricted travel classes add barrier
 * checks. A long event sound that must follow movement or stop early may need a token instead.
 *
 * AMBIENT POINT SOURCE: SSpoint_ambience
 *
 * Use for many interchangeable environmental sources in a few categories, such as fires,
 * sconces, fountains, clocks and corpse flies. Register with a category type path, unregister
 * when inactive or deleted, and register again when the source moves. Prefer static sources
 * where possible because movement also updates the index and invalidates cached rankings.
 *
 * Each listener hears at most one selected source per category, with volume and pan refreshed
 * during servicing. Categories layer on separate channels. Ranking selects nearby sources.
 * Occlusion can reject the winner or use its runner-up. Rivers use a path-distance fill rather
 * than indexed source objects.
 *
 * In LIVE mode, sources do not each run a playback timer. Work follows listener services, with
 * nearby source density, cache reuse, occlusion and queue batching affecting each service's cost.
 * Movement settings trade update frequency against spatial fidelity. Periodic standing checks,
 * clip changes, fades and source changes also contribute work.
 *
 * Do not use a shared category for instruments or other sources that must retain their own song
 * or be heard simultaneously. A source handoff preserves the category's current recording.
 * Do not restore object loops for listeners who mute point ambience: that adds per-source work
 * alongside the listener service. FALLBACK is a separate server-wide mode, not a per-user fallback.
 *
 * AMBIENT AREA BED: SSdroning
 *
 * Use for an unpositioned background belonging to an area, such as cave wind. Configure it on
 * the area rather than placing a source. Area beds have no distance falloff or source occlusion.
 * play_loop() replaces the listener's previous area loop, so these beds do not layer with one
 * another. They can layer with point ambience, which uses separate channels.
 *
 * If the player should hear a sound approach, move across the stereo field and recede as they
 * pass an object, use a positional system instead.
 *
 * OBJECT LOOP: /datum/looping_sound without use_sound_tokens
 *
 * Use when repeated sends are sufficient and position can stay fixed between them, or for direct
 * playback to one recipient. Each replay recalculates listener volume and position. Movement
 * during the clip does not update them. A longer replay interval can leave audible lag.
 *
 * Each active loop schedules its own callbacks, including when nobody is nearby. The spatial
 * probe can skip a listener gather but does not remove that timer. Many always-active sources
 * can therefore be a poor fit even when most are out of earshot.
 *
 * stop() cancels future playback, but an ordinary positional loop does not retain every listener's
 * channel to stop a clip already sent. Direct mob loops with a specified channel can stop that
 * channel. Use a token when an event needs reliable stopping for its positional audience.
 *
 * SOUND TOKEN: /datum/looping_sound with use_sound_tokens, or playsoundtoken()
 *
 * Use for positional audio that must follow source or listener movement while playing, such as
 * instruments, music boxes, machinery, alarms and spell charges. A stationary source still needs
 * movement updates when its listeners walk. Temporary events can use tokens too. Simultaneous
 * token count matters more than whether the source is permanent.
 *
 * Tokens track listeners through the spatial grid and update volume and pan without restarting
 * the recording. They retain a channel and listener state so playback can stop before the file
 * ends. Eligible single-file loops use native repeat. Loops that select clips or depend on timed
 * callbacks still need their timer behavior. See can_native_repeat().
 *
 * Each token reserves a channel from SSsounds' finite pool and maintains spatial and listener
 * tracking. Updates scale with the active source/listener relationships. Check how many tokens
 * can overlap and whether all those distinct sounds need to play together. Use point ambience
 * when one interchangeable voice per category is sufficient. Direct unpositioned playback does
 * not need token movement tracking.
 *
 * WALL MUFFLING ON A TOKEN: muffle_behind_walls
 *
 * Enable when obstruction should change how this sound is heard. This adds a same-floor line
 * check for each relevant listener update. A nearby blocker ends the trace early. A clear path
 * can require the full trace. Cost therefore depends on range, geometry, listener count and
 * movement, not simply whether the source is indoors or outdoors.
 *
 * Consider the gameplay consequence as well as cost. Muffling a spell charge or alarm can hide
 * a warning behind cover. Music loops and boiling use muffling. Alarms and spell-charge loops
 * leave it disabled. Avoid enabling it across all tokens without considering those differences.
 *
 * Token muffling reads live opacity when an update occurs. A door changing alone does not
 * refresh a stationary source/listener pair. Point ambience has its own occlusion policy and
 * nearby door-change refreshes. River fill has a separate barrier policy. See sound_occlusion.dm.
 */

//max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
// Channels are independent mixer slots on each client. Reserve distinct numbers for sounds a
// listener can hear simultaneously. Fixed channels must stay above the dynamic pool
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023 //USED FOR MUSIC
/// Fly ambience around rotting corpses
#define CHANNEL_ROT_AMBIENCE 1022
#define CHANNEL_JUKEBOX 1021
/// Ticking clocks
#define CHANNEL_CLOCK_AMBIENCE 1020
#define CHANNEL_HEARTBEAT 1019 //sound channel for heartbeats
#define CHANNEL_AMBIENCE 1018
#define CHANNEL_BUZZ 1017
#define CHANNEL_RAIN 1015
#define CHANNEL_MUSIC 1014
#define CHANNEL_WEATHER 1013
#define CHANNEL_CMUSIC4 1012
#define CHANNEL_CMUSIC3 1011
#define CHANNEL_CMUSIC2 1010
#define CHANNEL_CMUSIC1 1009
#define CHANNEL_FIRE_AMBIENCE 1008
#define CHANNEL_MISC_AMBIENCE 1007
#define CHANNEL_TORCH_AMBIENCE 1006
#define CHANNEL_WATER_AMBIENCE 1005
/// River ambience
#define CHANNEL_RIVER_AMBIENCE 1004

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

/**
 * Highest dynamically allocated sound channel.
 *
 * Fixed channels must stay above this bound. Lower it before reserving additional fixed channels
 * within the pool.
 */
#define CHANNEL_HIGHEST_AVAILABLE 1003


#define SOUND_MINIMUM_PRESSURE 10

/* Calculates the volume of a sound based on distance
 *
 * https://www.desmos.com/calculator/ing6lxgd0m Update this when changed please
 *
 * Arguments:
 * * volume: The initial volume of the sound being played
 * * distance: How far away the sound is in tiles from the source
 * * falloff_distance: Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * falloff_exponent: Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * Returns: The max distance of a sound based on audible volume range
 */
#define CALCULATE_SOUND_VOLUME_RATIO(volume, distance, max_distance, falloff_distance, falloff_exponent)\
	((max(distance - falloff_distance, 0) / (max(max_distance, distance) - falloff_distance)) ** (1 / falloff_exponent))

/**
 * Adds vertical separation to a sound's horizontal distance using GLOB.sound_storey_tiles.
 *
 * A storey distance of zero leaves horizontal distance unchanged. Floor obstruction is applied
 * separately from this geometric distance.
 *
 * The macro evaluates its distance argument more than once. Pass a local value rather than a proc
 * call.
 */
#define STOREY_ADJUSTED_DISTANCE(dist, storeys)\
	(((storeys) && GLOB.sound_storey_tiles) \
		? sqrt((dist) * (dist) + (storeys) * GLOB.sound_storey_tiles * (storeys) * GLOB.sound_storey_tiles) \
		: (dist))

/// Default audible range in tiles, extended by a caller's extra_range
#define SOUND_RANGE 7
/// Distance from the source at which attenuation begins. Zero starts attenuation immediately
#define SOUND_DEFAULT_FALLOFF_DISTANCE 0
/**
 * Falloff exponent for ordinary short-range sounds.
 *
 * These range-band curves were tuned by hand to avoid abrupt volume changes as listeners move.
 * Retuning requires in-game listening checks across the affected ranges. Do not adjust them from
 * the formula alone.
 *
 * The volume curve uses the reciprocal of this value. Values above one reduce volume more sharply
 * near the source. Values below one keep the near field louder and steepen the drop near maximum
 * range.
 */
#define SOUND_FALLOFF_EXPONENT 1
/**
 * Falloff exponent for sounds with a range below SOUND_RANGE_CLOSE.
 *
 * The steep initial drop helps separate closely spaced sources, such as rows of sconces, that can
 * otherwise sound like one constant-volume bed. This curve was tuned by hand. Check changes in
 * game. Point ambience uses it on the band-curve path selected by falloff_hardness = 0.
 */
#define SOUND_FALLOFF_EXPONENT_CLOSE 1.5
/// Falloff exponent for medium-range sounds, keeping volume higher near the source and dropping
/// faster near the edge
#define SOUND_FALLOFF_EXPONENT_MEDIUM 0.8
/// Falloff exponent for long-range sounds, with an early volume drop that flattens toward the edge
#define SOUND_FALLOFF_EXPONENT_LONG 2

/// Range thresholds used to select the falloff exponent
#define SOUND_RANGE_CLOSE 5
#define SOUND_RANGE_MEDIUM 10
#define SOUND_RANGE_LONG 28
/**
 * Volume floor reached at maximum range, before listener preferences are applied.
 *
 * Keeps the outer part of a sound's range audible. Sliders still scale this floor down. It does not
 * override the listener's volume choice.
 *
 * Raising this default also raises the edge volume of footsteps and combat sounds. Point ambience
 * has category-specific floors. Tune those when only one ambience category needs adjustment.
 */
#define SOUND_DEFAULT_MIN_VOLUME 2

/**
 * Minimum front-back depth relative to a sound's lateral offset.
 *
 * Softens hard left/right panning for sounds directly beside the listener, reducing prolonged
 * one-ear playback on headphones. Zero restores full lateral panning.
 */
#define SOUND_PAN_MIN_DEPTH 1
/**
 * Near-field depth for point ambience panning.
 *
 * Keeps direction continuous as a source passes close to the listener. Ordinary playsound_local()
 * calls retain their one-tile dead zone.
 */
#define SOUND_PAN_NEAR_DEPTH 3
/// Minimum absolute pan depth when runner-up blending nearly cancels the lateral offset
#define SOUND_PAN_MIN_DEPTH_ABS 1

/**
 * Volume multiplier for a listener one storey from the source.
 *
 * Applied separately from STOREY_ADJUSTED_DISTANCE by playsound_local() and point ambience
 * slim_send(). Two or more storeys are inaudible.
 */
#define SOUND_STOREY_VOLUME_MULT 0.5

/**
 * Barrier handling for positional sounds, ordered from unrestricted to contained.
 *
 * Only restricted classes require a line check. Floor handling is configured separately, except
 * LEAKING and CONTAINED always stay on the source floor.
 */
#define SOUND_TRAVEL_UNRESTRICTED 0	// Ignores barriers. The default travel class
#define SOUND_TRAVEL_CARRYING 1	// Muffled through barriers at normal range
#define SOUND_TRAVEL_LEAKING 2	// Allows capped leakage through one closed opening to the tile immediately beyond it
#define SOUND_TRAVEL_CONTAINED 3	// Blocked by walls and closed openings. Soundproof areas also block open openings

/**
 * Prevents sound from reaching another floor.
 *
 * For floor_volume arguments, null uses ordinary floor attenuation and a positive value caps
 * cross-floor volume. LEAKING and CONTAINED never cross floors regardless of that argument.
 */
#define SOUND_FLOOR_NEVER 0
/// Default floor cap for explicit travel classes: faint cross-floor audio for CARRYING, none for
/// ERP classes
#define SOUND_TRAVEL_FLOOR(travel) ((travel) == SOUND_TRAVEL_CARRYING ? 4 : SOUND_FLOOR_NEVER)
/**
 * Maximum volume of leakage through a closed door or window.
 *
 * Filtering alone dulls the sound without making it quiet enough behind a closed opening. This cap
 * limits its loudness. Ordinary distance attenuation still applies.
 */
#define SOUND_TRAVEL_LEAK_VOLUME 5
/**
 * Muffling applied to an individual listener's sound.
 *
 * A permitted ERP leak uses ENCLOSED. Other positional sounds use SOFT for light obstruction or
 * WALL for stronger attenuation. Any nonzero value indicates muffling.
 */
#define SOUND_MUFFLE_NONE 0
#define SOUND_MUFFLE_SOFT 1	// Filter profile only. Also accepts boolean TRUE
#define SOUND_MUFFLE_ENCLOSED 2	// Filter profile plus the closed-opening leakage cap
#define SOUND_MUFFLE_WALL 3	// Filter profile with a stronger volume reduction

/**
 * Shared volume, falloff and filtering settings for muffled positional sounds.
 *
 * Volume and falloff make a sound quieter. The occlusion filter changes its character to suggest a
 * barrier. Tune both aspects when adjusting muffling.
 */
#define SOUND_MUFFLE_VOLUME_MULT 0.75
/**
 * Volume multiplier for wall muffling, also used for point ambience corner paths.
 *
 * The stronger reduction makes obstruction noticeable in continuous sounds such as music, where a
 * small volume change can be hard to hear. Lower values make the obstructed sound quieter.
 */
#define SOUND_MUFFLE_WALL_VOLUME_MULT 0.5
/// Falloff exponent multiplier for muffled sounds. Higher values steepen the initial drop. Wall
/// muffling gets its stronger reduction from SOUND_MUFFLE_WALL_VOLUME_MULT
#define SOUND_MUFFLE_EXPONENT_MULT 1.5
/// BYOND reverb preset 11, "carpeted hallway": a dead, absorbent room with little reflection
#define SOUND_MUFFLE_ENVIRONMENT 11
/**
 * Underwater reverb preset for muffled ERP audio.
 *
 * Chosen for its strong muffling of sound leaking through closed openings. An echo array replaces
 * the preset, so this path uses the preset without the ordinary occlusion filter.
 */
#define SOUND_ERP_MUFFLE_ENVIRONMENT 22

/**
 * Occlusion grades for direct traces and optional corner probes.
 *
 * CLEAR means the direct line passed. A blocked direct trace returns SOLID. sound_occlusion_grade()
 * can refine it to MUFFLED when a flank has a path to the source. Diagonal stepping does not test
 * both adjacent flank tiles unless a blocked trace triggers a probe.
 */
#define OCCLUSION_CLEAR 0
#define OCCLUSION_SOLID 1
#define OCCLUSION_MUFFLED 2

/**
 * Door policy for sound occlusion.
 *
 * NONE ignores doors. FLANKS checks opaque contents only at corner-probe origins. LIVE checks
 * current door opacity on direct lines and probes. ALWAYS also blocks open mineral doors that would
 * close solid.
 */
#define SOUND_DOORS_NONE 0
#define SOUND_DOORS_FLANKS 1
#define SOUND_DOORS_LIVE 2
#define SOUND_DOORS_ALWAYS 3

/// Cancels the clip timer a slot holds, if it holds one, and forgets it
#define POINT_AMBIENCE_CANCEL_CLIP_TIMER(slot) if(slot.timer) { deltimer(slot.timer); slot.timer = null; }
/// Forgets a slot's fade, in or out, without sending anything
#define POINT_AMBIENCE_CLEAR_FADE(slot) slot.fade_next = null; slot.fade_target = null; slot.fade_left = null

/// Stable position seed from 0 to 96, shared by recording selection and starting phase.
/// Reads source_turf three times, so pass an already resolved turf variable
#define POINT_AMBIENCE_VOICE_SEED(source_turf) (((source_turf).x * 73 + (source_turf).y * 179 + (source_turf).z * 283) % 97)

/**
 * SSpoint_ambience modes.
 *
 * LIVE serves each client the nearest sources as they step, throttled, and on a periodic walk while
 * they stand. FALLBACK gives each source a plain timer loop instead, billed per source rather than per
 * listener, attenuation frozen between replays, torches silent. OFF is silent.
 */
#define POINT_AMBIENCE_OFF 0
#define POINT_AMBIENCE_LIVE 1
#define POINT_AMBIENCE_FALLBACK 2

/// Deciseconds between the steps of a point ambience fade
#define POINT_AMBIENCE_FADE_STEP 1
/**
 * Global limit on concurrent fades, separate from the per-run packet budget.
 *
 * When the list is full, sounds start or stop immediately instead of fading.
 */
#define POINT_AMBIENCE_FADE_CAP 64
/**
 * Deciseconds a listener still counts as moving faster than a natural run after such a step.
 *
 * Longer than any such step takes, a diagonal's doubled one included, and apart from the standing
 * skip, which an admin can set to 0.
 */
#define POINT_AMBIENCE_SPEED_STILL 5
/// Minimum time between forced-movement refreshes that bypass the ordinary movement interval
#define POINT_AMBIENCE_JUMP_GAP (1 SECONDS)
/**
 * Effective point ambience volume from a resolved preference datum.
 *
 * Uses the slider alone when independent, or scales it by Master in the same order as
 * point_ambience_volume(). P is read repeatedly. Pass a variable, not a proc call.
 */
#define POINT_AMBIENCE_VOLUME(P) (P.pointambience_independent ? P.pointambiencevol : P.pointambiencevol * P.overallvol * 0.01)

/**
 * Whether position, volume and source history allow reuse of a listener's selected sources.
 *
 * service_client() and fire()'s standing walk share this predicate to avoid separate versions of
 * these checks. The client selection may contain an occlusion-resolved runner-up or omit a blocked
 * category. It is separate from tile_cache's immutable distance rankings.
 *
 * | Dependency | How it reaches the selection |
 * | --- | --- |
 * | Listener turf and effective volume | Compared here |
 * | Registered source changes | static_version and can_reuse_tile_listener() |
 * | Preferences, tracked ear movement and gathered door changes | Their handlers stop or mark the listener |
 * | Hearing, room environment and enclosure | Read by prepare_serving() after the shortcut |
 *
 * Hearing expiry alone does not break this shortcut. Wall edits have no invalidation hook, and a
 * remote ear can be outside the door gather. Those changes can wait until another event causes a
 * service to pass the shortcut. This predicate is not a complete check of acoustic validity.
 * SSpoint_ambience procs only, since it reads static_version off src. listener_turf is named twice,
 * so pass a local.
 */
#define POINT_AMBIENCE_STANDING_UNCHANGED(listener_state, listener_turf, ambience_volume) \
	((listener_turf) == (listener_state).cache_turf \
	&& (ambience_volume) == (listener_state).cache_volume \
	&& ((listener_state).cache_version == static_version \
		|| can_reuse_tile_listener((listener_turf), (listener_state).cache_version)))

/// Coordinate shift for eight-tile source buckets
#define POINT_AMBIENCE_CELL_SHIFT 3
/// A tile's bucket in SSpoint_ambience.buckets_by_z[z], offset by 1 for DM's one-based list indexing
#define POINT_AMBIENCE_CELL_INDEX(x, y, stride) (((x) >> POINT_AMBIENCE_CELL_SHIFT) * (stride) + ((y) >> POINT_AMBIENCE_CELL_SHIFT) + 1)
/**
 * A source in a bucket is a quad of four flat entries: x, y, category index, then the source.
 *
 * Offsets from the quad's first entry, its x, which a loop reads as list[i] with no offset so a
 * ranking pays nothing for the names
 */
#define POINT_AMBIENCE_QUAD_Y 1
#define POINT_AMBIENCE_QUAD_CATEGORY 2
#define POINT_AMBIENCE_QUAD_SOURCE 3
#define POINT_AMBIENCE_QUAD_SIZE 4
/**
 * Packed ranking record: category, nearest source and squared distance, then runner-up source and
 * squared distance.
 *
 * Offsets are relative to the start of each record.
 */
#define POINT_AMBIENCE_RANK_SOURCE 1
/// Squared distance from the ranked tile to the nearest source
#define POINT_AMBIENCE_RANK_DISTANCE_SQ 2
/// Second-nearest source, available if live occlusion rejects the nearest
#define POINT_AMBIENCE_RANK_RUNNER_UP 3
/// Squared distance from the ranked tile to the runner-up
#define POINT_AMBIENCE_RANK_RUNNER_UP_DISTANCE_SQ 4
/// Number of fields in each cached category record
#define POINT_AMBIENCE_RANK_SIZE 5
/**
 * One SSpoint_ambience.source_change_history entry: static_version before the change and after it,
 * then the source's end FROM, its x, y, z and range before the change, and its end TO, the same after.
 *
 * Offsets from the entry's first field, the version before, which a loop reads as list[i]. Y, Z and
 * RANGE are offsets within one end, from its x
 */
#define POINT_AMBIENCE_SOURCE_CHANGE_VERSION_AFTER 1
#define POINT_AMBIENCE_SOURCE_CHANGE_FROM 2
#define POINT_AMBIENCE_SOURCE_CHANGE_TO 6
#define POINT_AMBIENCE_SOURCE_CHANGE_Y 1
#define POINT_AMBIENCE_SOURCE_CHANGE_Z 2
#define POINT_AMBIENCE_SOURCE_CHANGE_RANGE 3
/// Fields in one SSpoint_ambience.source_change_history entry, and the most entries it keeps
#define POINT_AMBIENCE_SOURCE_CHANGE_FIELDS 10
#define POINT_AMBIENCE_SOURCE_CHANGE_LIMIT 32
/// Source changes in one tick that trigger the unbatched-burst diagnostic. This reporting threshold
/// does not start a bulk update or limit source changes
#define POINT_AMBIENCE_BULK_BURST 64
/// Authored river reach in tiles. The fill walks it in half steps, a cardinal 2 and a diagonal 3,
/// so its budget is twice this
#define POINT_AMBIENCE_RIVER_FILL_RANGE 8
#define POINT_AMBIENCE_RIVER_FILL_BUDGET (POINT_AMBIENCE_RIVER_FILL_RANGE * 2)
/// Packed fill marks keep blocker dependencies without making those turfs audible. Null means absent
#define RIVER_FILL_BLOCKED_BIT 1
#define RIVER_FILL_MARK(cost, blocked) (((cost) << 1) | (blocked))
#define RIVER_FILL_COST(mark) ((mark) >> 1)
#define RIVER_FILL_AUDIBLE(mark) (!isnull(mark) && !((mark) & RIVER_FILL_BLOCKED_BIT))

/**
 * EAX occlusion level in millibels, written to sound.echo slot 7 for muffled sounds.
 *
 * Zero disables the occlusion array and leaves volume and environment muffling. Filter support
 * depends on the audio backend.
 */
#define SOUND_MUFFLE_OCCLUSION -1500
/// Low-frequency fraction of occlusion, written to sound.echo slot 8. Lower values preserve more
/// bass
#define SOUND_MUFFLE_OCCLUSION_LF 0.25

/**
 * Default reverb for positional sounds whose area has no soundenv override.
 *
 * The stone-room preset suits stone-and-timber interiors. It also reaches outdoor areas without an
 * override, so check indoor and outdoor playback when changing it. Use area overrides for local
 * differences.
 */
#define SOUND_DEFAULT_ENVIRONMENT 5

/// BYOND sound environment for "no environment". An area soundenv of this, or of 0, its default,
/// reads as unset
#define SOUND_ENVIRONMENT_NONE -1



//Ambience types

#define GENERIC list('sound/blank.ogg',\
								'sound/blank.ogg',\
								'sound/blank.ogg',\
								'sound/blank.ogg',\
								'sound/blank.ogg',\
								'sound/blank.ogg')

#define HOLY list('sound/blank.ogg',\
										'sound/blank.ogg',\
										'sound/blank.ogg')

#define HIGHSEC list('sound/blank.ogg')

#define RUINS list('sound/blank.ogg',\
									'sound/blank.ogg',\
									'sound/blank.ogg',\
									'sound/blank.ogg',\
									'sound/blank.ogg')

#define ENGINEERING list('sound/blank.ogg',\
										'sound/blank.ogg')

#define MINING list('sound/blank.ogg',\
											'sound/blank.ogg',\
											'sound/blank.ogg',\
											'sound/blank.ogg')

#define MEDICAL list('sound/blank.ogg')

#define SPOOKY list('sound/blank.ogg',\
										'sound/blank.ogg')

#define SPACE list('sound/blank.ogg')

#define MAINTENANCE list('sound/blank.ogg',\
											'sound/blank.ogg' )

#define AWAY_MISSION list('sound/blank.ogg',\
									'sound/blank.ogg',\
									'sound/blank.ogg',\
									'sound/blank.ogg',\
									'sound/blank.ogg')

#define REEBE list('sound/blank.ogg')



#define CREEPY_SOUNDS list('sound/blank.ogg',\
	'sound/blank.ogg',\
	'sound/blank.ogg',\
	'sound/blank.ogg',\
	'sound/blank.ogg')


#define RAIN_IN list('sound/ambience/rainin.ogg')

#define RAIN_SEWER list('sound/ambience/rainsewer.ogg')

#define RAIN_OUT list('sound/ambience/rainout.ogg')

#define AMB_GENCAVE list('sound/ambience/cave.ogg')

#define AMB_TOWNDAY list('sound/ambience/townday.ogg')

#define AMB_MOUNTAIN list('sound/ambience/MOUNTAIN (1).ogg',\
						'sound/ambience/MOUNTAIN (2).ogg')

#define AMB_TOWNNIGHT list('sound/ambience/townnight (1).ogg',\
						'sound/ambience/townnight (2).ogg',\
						'sound/ambience/townnight (3).ogg')

#define AMB_BOGDAY list('sound/ambience/bogday (1).ogg',\
						'sound/ambience/bogday (2).ogg',\
						'sound/ambience/bogday (3).ogg')

#define AMB_BOGNIGHT list('sound/ambience/bognight.ogg')

#define AMB_FORESTDAY list('sound/ambience/forestday.ogg')

#define AMB_ABISLAND list('sound/ambience/waves.ogg')

#define AMB_FORESTNIGHT list('sound/ambience/forestnight.ogg')

#define AMB_INGEN list('sound/ambience/indoorgen.ogg')


#define AMB_BASEMENT list('sound/ambience/basement.ogg')

#define AMB_JUNGLENIGHT list('sound/ambience/jungleday.ogg')

#define AMB_JUNGLEDAY list('sound/ambience/jungleday.ogg')

#define AMB_BEACH list('sound/ambience/lake (1).ogg',\
						'sound/ambience/lake (2).ogg',\
						'sound/ambience/lake (3).ogg')

#define AMB_BOAT list('sound/ambience/boat (1).ogg',\
						'sound/ambience/boat (2).ogg')

#define AMB_RIVERDAY list('sound/ambience/riverday (1).ogg',\
						'sound/ambience/riverday (2).ogg',\
						'sound/ambience/riverday (3).ogg')

#define AMB_RIVERNIGHT list('sound/ambience/rivernight (1).ogg',\
						'sound/ambience/rivernight (2).ogg',\
						'sound/ambience/rivernight (3).ogg')

/**
 * River clip sets used by positional river ambience.
 *
 * The current day set uses the night recordings as a continuous bed. Area ambience recordings are
 * independent of these sets.
 */
#define POINT_AMBIENCE_RIVER list('sound/ambience/point/river_night_1.ogg',\
						'sound/ambience/point/river_night_2.ogg',\
						'sound/ambience/point/river_night_3.ogg')

#define AMB_CAVEWATER list('sound/ambience/cavewater (1).ogg',\
						'sound/ambience/cavewater (2).ogg',\
						'sound/ambience/cavewater (3).ogg')

#define AMB_CAVELAVA list('sound/ambience/cavelava (1).ogg',\
						'sound/ambience/cavelava (2).ogg',\
						'sound/ambience/cavelava (3).ogg')

//******* SPOOKED YA

#define SPOOKY_CAVE list('sound/ambience/noises/cave (1).ogg',\
						'sound/ambience/noises/cave (2).ogg',\
						'sound/ambience/noises/cave (3).ogg')

#define SPOOKY_FOREST list('sound/ambience/noises/owl.ogg',\
						'sound/ambience/noises/wolf (1).ogg',\
						'sound/ambience/noises/wolf (2).ogg',\
						'sound/ambience/noises/wolf (3).ogg')

#define SPOOKY_GEN list('sound/ambience/noises/genspooky (1).ogg',\
						'sound/ambience/noises/genspooky (4).ogg',\
						'sound/ambience/noises/genspooky (2).ogg',\
						'sound/ambience/noises/genspooky (3).ogg',\
						'sound/ambience/noises/genspooky (5).ogg')

#define SPOOKY_DUNGEON list('sound/ambience/noises/dungeon (1).ogg',\
						'sound/ambience/noises/dungeon (4).ogg',\
						'sound/ambience/noises/dungeon (2).ogg',\
						'sound/ambience/noises/dungeon (3).ogg',\
						'sound/ambience/noises/dungeon (5).ogg')

#define SPOOKY_RATS list('sound/ambience/noises/RAT1.ogg',\
						'sound/ambience/noises/RAT2.ogg')

#define SPOOKY_FROG list('sound/ambience/noises/frog (1).ogg',\
						'sound/ambience/noises/frog (2).ogg')

#define SPOOKY_MYSTICAL list('sound/ambience/noises/mystical (1).ogg',\
						'sound/ambience/noises/mystical (2).ogg',\
						'sound/ambience/noises/mystical (3).ogg',\
						'sound/ambience/noises/mystical (4).ogg',\
						'sound/ambience/noises/mystical (5).ogg',\
						'sound/ambience/noises/mystical (6).ogg')

#define SPOOKY_CROWS list('sound/ambience/noises/birds (1).ogg',\
						'sound/ambience/noises/birds (2).ogg',\
						'sound/ambience/noises/birds (3).ogg',\
						'sound/ambience/noises/birds (4).ogg',\
						'sound/ambience/noises/birds (5).ogg',\
						'sound/ambience/noises/birds (6).ogg',\
						'sound/ambience/noises/birds (7).ogg')

#define LEVEL_UP_SOUNDS list('sound/misc/levelup1.ogg',\
					'sound/misc/levelup2.ogg',\
					'sound/misc/levelup3.ogg')


#define SFX_CHAIN_STEP "chain_step"
#define SFX_PLATE_STEP	"plate_step"
#define SFX_PLATE_COAT_STEP "plate_coat_step"
#define SFX_JINGLE_BELLS "jingle_bells"
#define SFX_WOOD_ARMOR "wood_armor"

#define SFX_COLLARJINGLE list('sound/items/jinglebell1.ogg',\
							'sound/items/jinglebell2.ogg',\
							'sound/items/jinglebell3.ogg',\
							'sound/items/jinglebell4.ogg',\
							'sound/items/jinglebell5.ogg',\
							'sound/items/jinglebell6.ogg')
#define SFX_CBJINGLE list('sound/items/cbjingle1.ogg',\
							'sound/items/cbjingle2.ogg',\
							'sound/items/cbjingle3.ogg')

#define INTERACTION_SOUND_RANGE_MODIFIER 0
#define EQUIP_SOUND_VOLUME 100
#define PICKUP_SOUND_VOLUME 100
#define DROP_SOUND_VOLUME 100
#define YEET_SOUND_VOLUME 100
#define HOLSTER_SOUND_VOLUME 15

/// Where instruments and the dwarven music box save player uploads, and how an upload is told apart
#define SONG_UPLOAD_FOLDER "data/jukeboxuploads/"
/// A stock song is a compiled resource whose path starts at sound/, an upload a file under the folder
#define IS_UPLOADED_SONG(song) (findtext("[song]", SONG_UPLOAD_FOLDER) == 1)
