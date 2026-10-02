/*
 * WHICH SOUND SYSTEM TO USE
 *
 * Five of them exist and they are not interchangeable. Each is billed by a different thing, which
 * is the whole basis for choosing: a design that is free at one population is the dearest at
 * another. Pick by what the sound IS, then check the cost note.
 *
 * ONE-SHOT: playsound() / playsound_local()
 *
 * A sound with an end. Footsteps, swings, doors, screams, a bell. Position, falloff and pan are
 * computed once at the instant it fires, which is correct because it is over before anyone has
 * moved. Costs a hearer gather at the source, one send per listener, and a line walk per listener for
 * any travel class but UNRESTRICTED. This is the default and most sound should be this.
 *
 * AMBIENT POINT SOURCE: SSpoint_ambience
 *
 * MANY static things of a FEW KINDS, each audible from a few tiles, that should be heard whenever
 * you are near one. Hearths, campfires, wall sconces, fountains, bone piles, rivers.
 *
 * Register a source with a category typepath and it is served to any listener in range, live: the
 * volume and pan sweep as you walk, it stops the instant the source does, and a wall between you
 * and it stops it. Only the NEAREST source per category is served, so a thousand hearths cost
 * at most one send per listener, and a source nobody is near costs only a range reject.
 *
 * Billed PER MOVING LISTENER, not per source. That is the trade: a source costs only the ranking
 * done by the listeners near it, while every moving player adds services of their own. Priced from
 * a live round's movement telemetry, 111 listeners on average, with each part timed locally on one
 * client, it came to about 3.6 ms/s, 2.2 to 6.0, and 6.4 in the round's busiest two seconds, at a
 * move interval of 7 with no step count. It is a projection from our own server's players and
 * population, not a load test, so it will not be accurate for another server. Local testing used at
 * most four clients, and it may be out of date.
 * The comparison with plain loops and any break-even population depend on movement, audible sources
 * and batching. Neither design's total cost is independent of listener count.
 *
 * Use it when: there are many sources, they are static, and they share a handful of sounds.
 * Do NOT use it for: anything with a per-source melody or a long clip. A category is one channel
 * and one slot, so two sources of a kind cannot be heard at once.
 *
 * AMBIENT AREA BED: SSdroning
 *
 * A sound belonging to a PLACE rather than a thing in it. Wind in a cave, the hum of a hall. Set
 * on the area, plays whole, no position, no falloff, no occlusion.
 *
 * Note it REPLACES rather than layers: play_loop kills the current area loop first, so an area
 * cannot have two, and an area bed cannot be mixed with another area bed. It can layer over point
 * ambience, which is on its own channels.
 *
 * Use it when: the sound has no source you could stand next to. If a player could walk up to the
 * thing making it, it wants point ambience instead.
 *
 * OBJECT LOOP: /datum/looping_sound, plain
 *
 * A repeating sound tied to one object, SHORT enough that nothing has moved before it plays again.
 * Position is snapshotted when each play STARTS and frozen until the next, so at walking speed
 * anything past about a second is stale before it ends.
 *
 * Billed PER ACTIVE SOURCE, once per mid_length, whether or not anyone is near. It has no stop
 * handle: each play takes a random channel, so a loop cannot be silenced mid-play, only prevented
 * from playing again.
 *
 * Use it when: few instances, short mid_length, and nobody minds a frozen volume between plays.
 * If there would be hundreds of them, it wants point ambience. If it runs for many seconds, it
 * wants a token.
 *
 * SOUND TOKEN: /datum/looping_sound with use_sound_tokens
 *
 * A LONG sound whose position must stay correct WHILE it plays. Instruments, music boxes, a
 * boiling pot, a 28 second alarm, spell charge hums. The token tracks listeners through the
 * spatial grid and re-sends per listener as they move, so volume and pan follow them mid-play.
 *
 * THE SOURCE DOES NOT HAVE TO MOVE. What matters is RELATIVE motion, and the listener supplies it
 * on their own. A fixed thing that sounds for half a minute needs a token as much as a carried one
 * does: the rat alarm is one blast from a lever that never moves, and on a plain loop its volume
 * would be frozen at whatever it was when it started, so walking toward it would do nothing.
 *
 * That makes tokens right for TEMPORARY things too, not only permanent ones. A one-off event that
 * runs for seconds and has a position wants a token even though it will be gone shortly: spell
 * charge hums are the common case, alive only while someone holds a cast. Being short-lived is an
 * argument FOR a token rather than against, since the channel and the grid registrations are
 * handed back when it ends, and the count that matters is how many exist AT ONCE.
 *
 * A token also has a real stop handle, which a plain loop does not: each plain play grabs a random
 * channel, so it can only be stopped from playing AGAIN, never cut off. An event sound that must
 * end when the event ends, rather than at the next replay boundary, needs the token for that alone.
 *
 * Costs a reserved channel from the ~950 pool and grid-signal registration per token, so it is
 * strictly worse than a timer at scale. All three of these must hold:
 *   1. one play lasts long enough for EITHER side to move during it (seconds, not fractions)
 *   2. few exist AT ONCE (tens, never hundreds), lifetime not mattering where overlap does
 *   3. it is positional at all (a `direct` loop has no distance term and gains nothing)
 *
 * Use it when: all three hold. Anything failing (2) belongs in point ambience. Anything failing
 * (1) or (3) is a plain object loop.
 *
 * WALL MUFFLING ON A TOKEN: muffle_behind_walls
 *
 * OFF by default and it should stay off unless the case is argued. It is not a fidelity setting to
 * be turned on everywhere for consistency. It is a per-listener line walk paid on every step, and
 * the cases where it costs the most are the ones where it changes the least.
 *
 * The check walks from listener to source and STOPS at the first opaque thing. So:
 *   INDOORS it is cheap. Walls are close, the walk ends after a tile or two, and the answer
 *   matters, because a listener in the next room really should not hear it.
 *   OUTDOORS it is dear and pointless. Nothing stops the line, so it walks the full range to
 *   conclude "clear" every time, for every listener, on every step.
 * That asymmetry is the whole rule: muffle indoor sounds, leave outdoor ones alone.
 *
 * Before setting it, all of these:
 *   1. the source lives INDOORS, where lines are short and end early
 *   2. its range is short (cost scales with line length. A range 12 source walks 12 tiles to find
 *      nothing, on every listener, on every step)
 *   3. few listeners are near it at once, since this is billed per listener per step
 *   4. NOTHING TACTICAL RIDES ON HEARING IT. A combat cue that becomes cover-dependent is a balance
 *      change, not an audio fix, and wants deciding as one. Spell charge hums are the example:
 *      hearing someone wind up is a warning to whoever is on the other side of the wall, so
 *      muffling it takes that warning away and hands the advantage to the caster.
 *
 * Set on the music loops and on boilloop. Deliberately NOT set on the rat alarm (long range and
 * outdoors, so the dearest check on the longest line) or on the spell charge hums, fliesloop among
 * them (criterion 4, and they land on combat ticks).
 *
 * Note point ambience does its own occlusion and does not use this. It reads turf opacity, and doors
 * as its door_mode says, only where a turf's sound_door_count says one may stand. A listener
 * standing still never re-sends, so a door that changes has the listeners near it served again. A
 * token re-evaluates every listener whenever either side moves.
 */

//max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
// A channel is a slot on ONE LISTENER'S mixer, not a handle on an object: 1019 on your client and
// 1019 on mine are unrelated. So a kind of sound needs as many numbers as one person can hear of it
// at once, never as many as exist. One heartbeat channel serves every player because you only hear
// your own. One torch channel serves every sconce on the map because point ambience plays only the
// nearest. 1016 is free, the only number above the pool that no channel claims
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023 //USED FOR MUSIC
/// Flies on a rotting body. Its own channel, so a corpse and a misc source in one room do not
/// displace each other
#define CHANNEL_ROT_AMBIENCE 1022
#define CHANNEL_JUKEBOX 1021
/// Grandfather and wall clocks. Their own channel, since a manor holds many and at misc's range they
/// would displace each other across it
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
/// Rivers, separate from fountains so the two layer instead of suppressing each other, and so a
/// river's reach can be set from the bank rather than from the middle of the water
#define CHANNEL_RIVER_AMBIENCE 1004

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

/**
 * The top of the channel pool SSsounds builds, 1 to this.
 *
 * Every number ABOVE it is reserved by hand, and every number at or below it can be handed to any
 * one-shot playsound(channel = 0), token or instrument. 1004 to 1024 is 21 numbers and 20 are taken,
 * 1016 being the only one left. Claiming a SECOND one means LOWERING THIS FIRST. Take 1003 without
 * lowering it and the pool still hands 1003 out, so the new sound and whatever borrowed it cut each
 * other off only when both happen to play, which is the kind of fault that survives a whole round of
 * testing.
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
 * A horizontal distance with the vertical one folded in, for a listener a floor away.
 *
 * Distance is otherwise 2D, so a listener directly overhead sits at distance 0 and the flat storey
 * multiplier is the only thing between them and full volume: the same penalty standing on top of a
 * source as at the edge of its range. Pythagorean, because that is what the distance is. The
 * multiplier stays as the obstruction term. GLOB.sound_storey_tiles is read from config at SSsounds
 * init, and at 0 this returns the distance unchanged.
 *
 * A MACRO, not a proc, and not two copies. playsound_local and SSpoint_ambience's slim_send are
 * hand-maintained mirrors of the same recipe, and a term added to one alone makes every cross-floor
 * send disagree. Anything both paths must compute identically belongs here, where they expand the
 * same source.
 *
 * PASS `dist` AS A LOCAL, NEVER AN EXPRESSION. It is named three times below and substitution is
 * textual, so an expression is evaluated up to twice: `sqrt(...)` becomes two square roots,
 * and a proc call becomes two calls. A proc would evaluate its arguments once. A macro does not.
 */
#define STOREY_ADJUSTED_DISTANCE(dist, storeys)\
	(((storeys) && GLOB.sound_storey_tiles) \
		? sqrt((dist) * (dist) + (storeys) * GLOB.sound_storey_tiles * (storeys) * GLOB.sound_storey_tiles) \
		: (dist))

/// Default range of a sound, the reach of the default view. TG's 15 would double every sound's reach
/// here, and the extrarange values in code were tuned against 7
#define SOUND_RANGE 7
/**
 * Percentage of sound's range where no falloff is applied.
 *
 * 0 on purpose: a flat zone near the source reads as broken rather than loud, since you walk several
 * tiles and nothing changes at all. The curve carries the near field instead, degrading from the
 * very first tile, evenly at the room-scale exponent and hardest in the close band, where the first
 * tile is meant to cost most.
 */
#define SOUND_DEFAULT_FALLOFF_DISTANCE 0
/**
 * Falloff curves, one per range band.
 *
 * The curve is computed against each sound's OWN range, so its shape is proportional: at half of its
 * range a sound sits at the same volume whether that range is 5 tiles or 50. Perception is not
 * proportional. Four tiles away is four tiles away, so a single exponent tuned for a room reads as
 * "no falloff at all" on anything that carries further. Hence four curves, picked by
 * sound_falloff_for_range().
 *
 * Tuned by hand, mostly to stop music cutting from full to nothing in one step as you walk out of a
 * noisy area. Every curve fades to the caller's min_volume at the edge rather than to zero, so a
 * sound stays audible to the edge of its own range.
 *
 * Below 1 the drop is back-loaded: gentle near the source, accelerating toward the edge. Above 1 it
 * inverts, front-loading the drop and then easing onto the floor. The value is the RECIPROCAL of the
 * power applied, so a HIGHER number is a steeper near field.
 *
 * This one is room scale, where most sounds land. Linear, so a tile costs the same wherever you are
 * in the range: a volume 100 source at SOUND_RANGE over SOUND_DEFAULT_MIN_VOLUME reads 100 86 72 58
 * 44 30 16 2 over tiles 0 to 7. A curve under 1 holds near full volume through half the range and
 * reads as no falloff at all on anything walked past closely.
 */
#define SOUND_FALLOFF_EXPONENT 1
/**
 * The curve for a range under SOUND_RANGE_CLOSE.
 *
 * Steeper than linear, so the first tile costs most. On the room curve a street of short range
 * sconces reads as one continuous bed, the nearest never far enough away to fade. Point ambience
 * categories this short take it only when they run their band curves, at a falloff hardness of 0.
 */
#define SOUND_FALLOFF_EXPONENT_CLOSE 1.5
/**
 * The curve for a range from SOUND_RANGE_MEDIUM, across a hall or a street rather than a room.
 *
 * Below 1, so the drop stays gentle near the source and steepens toward the edge, landing where the
 * sound is leaving earshot rather than while it is still filling the room. A volume 100 source at
 * range 17 over SOUND_DEFAULT_MIN_VOLUME reads roughly 100 97 93 89 84 79 73 68 62 56 50 43 37 30 23
 * 16 9, then the floor.
 */
#define SOUND_FALLOFF_EXPONENT_MEDIUM 0.8
/// The curve for a range from SOUND_RANGE_LONG, a sound that carries across the map such as the
/// church bell. Above 1, so the drop comes early and flattens toward the edge
#define SOUND_FALLOFF_EXPONENT_LONG 2

/// Range at which each band takes over. Most calls land in the 5 to 9 band, and the few that ask
/// for a range under 5 take the close curve
#define SOUND_RANGE_CLOSE 5
#define SOUND_RANGE_MEDIUM 10
#define SOUND_RANGE_LONG 28
/**
 * Volume a sound falls off TO at max range, rather than falling off to silence.
 *
 * Without a floor the curve ends at 0 and its last tiles fall under hearing well inside the range.
 * The curve reaches this floor exactly at max range rather than approaching it. It is applied
 * BEFORE the sliders, so it arrives scaled: 2 here is 1 for a listener whose Sound Effects under
 * Master comes to 50, and 0.5 at 25. There is no lift back afterwards, on purpose, so a player who
 * turned the game down hears the edge as quiet as they asked for. Point ambience floors are scaled
 * by the listener's effective Point Ambience volume instead.
 *
 * THE DEFAULT, NOT THE ONLY ONE. Point ambience passes its category's floor instead, because a
 * sustained loop and a transient are not audible at the same level: a clock's ticks carry at a floor
 * where a torch's crackle or a fountain does not. This is what one-shots and ERP audio land on, and
 * raising it lifts the last tile of every footstep and combat sound in the game, so raise a category
 * instead.
 */
#define SOUND_DEFAULT_MIN_VOLUME 2

/**
 * How much front-back depth a sound is given relative to its sideways offset, as a floor.
 *
 * A sound due east or west has no front-back component at all, and BYOND renders that as a
 * hard pan into one ear: fine on speakers, uncomfortable on headphones over a long session.
 * At 1.0 a purely sideways sound is placed at 45 degrees instead of 90, which is about 70%
 * pan rather than 100%, while still being unmistakably on that side. 0 restores hard panning.
 */
#define SOUND_PAN_MIN_DEPTH 1
/**
 * Point ambience only. The depth a source is held at close in.
 *
 * Direction stays continuous instead of switching off inside a one tile box: at 3 a source on the
 * next tile diagonally sits about 25 degrees off centre and one directly beside about 18, rather
 * than dead ahead. playsound_local keeps the dead zone.
 */
#define SOUND_PAN_NEAR_DEPTH 3
/// The floor under that, so a lateral the runner-up lean has nearly cancelled plays near centre
#define SOUND_PAN_MIN_DEPTH_ABS 1

/**
 * Volume multiplier for a listener one storey from the source.
 *
 * The obstruction term a floor adds on top of STOREY_ADJUSTED_DISTANCE. Two or more storeys is
 * inaudible. Applied in playsound_local(), which sound tokens send through, and in
 * SSpoint_ambience's slim_send(), so change both together.
 */
#define SOUND_STOREY_VOLUME_MULT 0.5

/**
 * HOW A SOUND GETS PAST A BARRIER.
 *
 * One axis, one vocabulary, used by every system that cares: ERP names CONTAINED or LEAKING at the
 * call, an emote carries one on its datum, and a bare playsound gets the default. Ordered by
 * containment, so the ladder reads: each is more contained than the one above it. A wall mode and a
 * sound class are one thing, so this is one enum.
 *
 * FLOORS ARE NOT PART OF THIS. They are `floor_volume` below, because the two axes come apart: a
 * CARRYING sound is dulled through walls AND attenuates normally through a ceiling, which no single
 * bundled class could express. Only the two ERP classes speak for both, since neither ever crosses a
 * floor.
 *
 * Costs a line walk per listener on everything but UNRESTRICTED, so that is the default, and nearly
 * every playsound call names no class. The rest are for things firing every few seconds, not
 * footsteps.
 */
#define SOUND_TRAVEL_UNRESTRICTED 0	// Barriers ignored, no walk. THE DEFAULT
#define SOUND_TRAVEL_CARRYING 1	// Through a barrier at full range, dulled. Equals TRUE, so a caller passing TRUE gets this
#define SOUND_TRAVEL_LEAKING 2	// ERP. Open doors and windows pass it; one shut opening on the direct line leaks one tile, capped at SOUND_TRAVEL_LEAK_VOLUME. Walls stop it. Soundproof areas seal open openings too. Never crosses a floor
#define SOUND_TRAVEL_CONTAINED 3	// ERP. Walls and shut openings stop it; open doors and windows pass it unless the source area is soundproof. Never crosses a floor, enforced by playsound and playsound_local

/**
 * What a floor does, separately from what a wall does.
 *
 * NULL attenuates and halves like any positional sound, which is what an ordinary sound and an emote
 * want. SOUND_FLOOR_NEVER does not cross at all and playsound skips gathering the floors either
 * side. Any positive number CAPS the volume there regardless of distance. LEAKING and CONTAINED never
 * cross a floor.
 *
 * Do not raise the caps. Audio through a floor is a common complaint and the only thing carrying
 * further buys is people breaking the door down. Lowering is always safe.
 */
#define SOUND_FLOOR_NEVER 0
/// The floor cap each travel class asks for by default, which playsound_erp and a named emote class
/// apply. CARRYING is heard faintly through a ceiling, and the ERP classes never cross one
#define SOUND_TRAVEL_FLOOR(travel) ((travel) == SOUND_TRAVEL_CARRYING ? 4 : SOUND_FLOOR_NEVER)
/**
 * The volume cap a LEAKING sound gets past a shut window or door.
 *
 * The muffle profile alone only dulls a sound, which through glass or a shut door is still too loud,
 * hence the cap. Ordinary falloff still runs underneath it
 */
#define SOUND_TRAVEL_LEAK_VOLUME 5
/**
 * What playsound_local is told about one listener.
 *
 * ERP uses a direct line: a permitted one-tile leak gets ENCLOSED; any other blocked path is not
 * sent. Other sound systems also use SOFT for floors or corners and WALL for stronger attenuation.
 * Ordered, so truthiness means "muffled at all" for a caller that passes TRUE or FALSE.
 */
#define SOUND_MUFFLE_NONE 0
#define SOUND_MUFFLE_SOFT 1	// Equals TRUE. The profile only, what a storey gives and what a boolean TRUE means
#define SOUND_MUFFLE_ENCLOSED 2	// The profile plus the leak cap. Only playsound produces it, for LEAKING past a shut window or door
#define SOUND_MUFFLE_WALL 3	// The profile with a deeper volume cut. A wall between a listener and a continuous source

/**
 * The muffle profile, for a sound heard through a wall, a floor or a dullahan's container.
 *
 * Grouped so the character can be tuned in one place rather than as literals buried in
 * playsound_local(). Volume and the falloff curve are only half of it. On their own they read as
 * "further away" rather than "behind something". The occlusion pair is what changes the timbre.
 */
#define SOUND_MUFFLE_VOLUME_MULT 0.75
/**
 * The volume cut for a wall against a sound that never stops.
 *
 * A quarter off is inaudible on music: the level is steady, so there is no onset to hear it in, and
 * the reverb half of the profile is overwritten by the next positional sound BYOND sends, environment
 * being a client-wide setting. Half off is a cut you can hear. 0.34 if it should read as nearly
 * gone. Point ambience takes the same cut for a source heard round a corner.
 */
#define SOUND_MUFFLE_WALL_VOLUME_MULT 0.5
/// Multiplies a muffled send's falloff exponent, a steeper near field. A wall uses the same curve and
/// differs only in its volume cut, since a steeper one cuts the sound off close enough to read as a bug
#define SOUND_MUFFLE_EXPONENT_MULT 1.5
/// BYOND reverb preset 11, "carpeted hallway": a dead, absorbent room with little reflection
#define SOUND_MUFFLE_ENVIRONMENT 11
/**
 * Preset 22, "underwater", for ERP audio through a wall.
 *
 * Obviously wrong for open air, which is the point: it should read as something you were not meant
 * to hear clearly rather than as a nearby sound turned down. Using it costs the occlusion filter,
 * since an echo array replaces the preset outright, so this is the preset OR the filter and not
 * both.
 */
#define SOUND_ERP_MUFFLE_ENVIRONMENT 22

/**
 * What a line between a listener and a source ran into.
 *
 * CLEAR: nothing opaque on it. SOLID: blocked, and no open line from either tile beside the
 * obstruction, an enclosure. Point ambience does not serve it. ERP uses its own direct walk.
 * MUFFLED: blocked on the direct line but open from a tile beside the obstruction, a corner, so it is
 * served dulled. A diagonal step is taken without testing the two tiles beside it, so a line between
 * two walls that meet at a corner, and a diagonal neighbour, reads CLEAR.
 */
#define OCCLUSION_CLEAR 0
#define OCCLUSION_SOLID 1
#define OCCLUSION_MUFFLED 2

/**
 * How an occlusion walk treats doors, which are objects where walls are turfs.
 *
 * NONE ignores them. FLANKS lets the line through a door open or shut, but a corner probe starting
 * beside a wall treats anything opaque on its first tile as a wall, which is what catches a shut door
 * in the gap. LIVE blocks at a shut door on the line and at the corners alike, reading the door as it
 * stands. ALWAYS also blocks at an open mineral door that shuts solid, and is there to compare by ear.
 */
#define SOUND_DOORS_NONE 0
#define SOUND_DOORS_FLANKS 1
#define SOUND_DOORS_LIVE 2
#define SOUND_DOORS_ALWAYS 3

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

/**
 * The per-category send state SSpoint_ambience keeps on a client, client.point_ambience_slots.
 *
 * One positional list per category: source turf and playback state, the volume last sent, fade
 * state, and the timer that advances a set of clips. A list PER CATEGORY, not one flat list with an
 * offset: flattening was measured and moved nothing, and an offset a caller carries can read the
 * neighbouring category's fields where a sublist cannot.
 *
 * point_ambience_sources records selection, not every channel still playing. A fade-out removes
 * its source but keeps playback until the fade ends. FADE_NEXT with a null FADE_TARGET identifies
 * that state, which service_client() can take over without restarting an ordinary loop.
 * stop_for() ends a category and cancels its timer and fade. stop_all_for() also clears slots and
 * listener caches. Sound datums can remain allocated after either stop, so their existence does
 * not establish playback. Head-watch subscriptions have their own lifetime and are released by
 * the listener lifecycle handlers, not by stopping audio.
 */
#define POINT_AMBIENCE_SLOT_TURF 1
#define POINT_AMBIENCE_SLOT_FREQUENCY 2
#define POINT_AMBIENCE_SLOT_LAST_VOLUME 3
#define POINT_AMBIENCE_SLOT_FILE 4
#define POINT_AMBIENCE_SLOT_TIMER 5
/// The source the last walk ranked second for this category, which the send leans the stereo
/// direction toward as the two trade places
#define POINT_AMBIENCE_SLOT_RUNNER_UP 6
/// The area environment of the last send. A carried torch is skipped only while this and the
/// volume both still match
#define POINT_AMBIENCE_SLOT_ENVIRONMENT 7
/// A fade in progress: the world.time its next step is due. Null when the category is not fading
#define POINT_AMBIENCE_SLOT_FADE_NEXT 8
/// The volume a fade in is climbing to. Null on a fade out, which is how the two are told apart
#define POINT_AMBIENCE_SLOT_FADE_TARGET 9
/// Steps the fade may still send
#define POINT_AMBIENCE_SLOT_FADE_LEFT 10
/// A clip-set timer expired and the next service must choose another clip for this category
#define POINT_AMBIENCE_SLOT_CLIP_DUE 11
#define POINT_AMBIENCE_SLOT_FIELDS 11

/// Deciseconds between the steps of a point ambience fade
#define POINT_AMBIENCE_FADE_STEP 1
/**
 * Fades in progress at once across every listener, a backstop on the list's length.
 *
 * What a tick may send is SSpoint_ambience.fade_budget's job. Past this a sound stops or starts at
 * once, with no fade. One walker on a torch lined route keeps about 0.2 running, measured.
 */
#define POINT_AMBIENCE_FADE_CAP 64
/**
 * Deciseconds a listener still counts as moving faster than a natural run after such a step.
 *
 * Longer than any such step takes, a diagonal's doubled one included, and apart from the standing
 * skip, which an admin can set to 0.
 */
#define POINT_AMBIENCE_SPEED_STILL 5
/// Least time between two forced moves of one listener that skip the move interval. Longer than the
/// shipped intervals, so a player carried along by forced moves is served no more often than one walking
#define POINT_AMBIENCE_JUMP_GAP (1 SECONDS)
/**
 * A listener's point ambience volume from their preferences.
 *
 * The slider alone when independent and under Master otherwise. The arithmetic is at_overall()'s in
 * the same order, so it equals point_ambience_volume() exactly. A macro because the standing walk runs
 * it for every listener standing still, and a proc call there costs more than the sum. Reads P three
 * times, so pass a var path, never a call.
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
#define POINT_AMBIENCE_STANDING_UNCHANGED(listener_client, listener_turf, ambience_volume) \
	((listener_turf) == (listener_client).point_ambience_cache_turf \
	&& (ambience_volume) == (listener_client).point_ambience_cache_volume \
	&& ((listener_client).point_ambience_cache_version == static_version \
		|| can_reuse_tile_listener((listener_turf), (listener_client).point_ambience_cache_version)))

/**
 * The densest candidate box SSpoint_ambience.drain_density_count gives its own bucket.
 *
 * Anything denser lands in the last one. The list is one longer, an empty cell taking the first
 * bucket. Twice the densest box on any shipped map, measured, leaving room for the corpses and
 * dropped torches that register on top. Lower it and a busy tile's percentiles read low.
 */
#define POINT_AMBIENCE_DENSITY_MAX 64

/// 8-tile cells: three per axis while max_range is 8 or less, nine probes a walk. Larger cells probe
/// fewer and rank nearly twice the sources, smaller invert it. Measured, so re-time any change
#define POINT_AMBIENCE_CELL_SHIFT 3
/// A tile's bucket in SSpoint_ambience.buckets_by_z[z], offset by 1 for DM's one-based list indexing
#define POINT_AMBIENCE_CELL_INDEX(x, y, stride) (((x) >> POINT_AMBIENCE_CELL_SHIFT) * (stride) + ((y) >> POINT_AMBIENCE_CELL_SHIFT) + 1)
/// Fields in one SSpoint_ambience.source_change_history entry, and the most entries it keeps
#define POINT_AMBIENCE_SOURCE_CHANGE_FIELDS 10
#define POINT_AMBIENCE_SOURCE_CHANGE_LIMIT 32
/// Index changes in one tick, outside any bulk update, that get the caller reported. A starting
/// heuristic rather than a measured break even
#define POINT_AMBIENCE_BULK_BURST 64
/// Steps the underground river fill walks out from underground water, the river category's range
#define POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS 8

/**
 * EAX Occlusion for a muffled send, slot 7 of the 18-slot sound.echo array, in millibels.
 *
 * The range is -10000 to 0. It low-passes the direct path, which is the only thing here that
 * genuinely alters the sound rather than its level. -1500 is roughly a closed door.
 * EXPERIMENTAL: slots 3 and 4 are proven by our own reverb-kill code, but BYOND's support for
 * the rest of the array is old and may be backend-dependent. If a playtest hears no difference
 * the array is not being honoured: set this to 0 and the volume and environment muffle remains.
 */
#define SOUND_MUFFLE_OCCLUSION -1500
/**
 * Slot 8, OcclusionLFRatio (0..1): how much of the occlusion applies to LOW frequencies.
 *
 * Lower lets more bass through, which is what a wall actually does. You hear the thump, not the
 * detail. 0.25 is the EAX default.
 */
#define SOUND_MUFFLE_OCCLUSION_LF 0.25

/**
 * Reverb used when the listener's area does not set its own soundenv, which is nearly all of them.
 *
 * Without it the case falls through to SOUND_ENVIRONMENT_NONE, which kills reverb outright and leaves
 * most of the game bone dry. That also makes muffling pointless: the muffle swaps in a dead room, and
 * a dead room is LIVELIER than no reverb at all, so a sound heard through a wall comes out slightly
 * more reverberant than one heard across an open room.
 * BYOND presets: 0 generic, 1 padded cell, 2 room, 4 living room, 5 stone room, 6 auditorium,
 * 7 concert hall, 8 cave, 13 stone corridor, 15 forest, 16 city, 17 mountains, 19 plain.
 * 5 suits stone-and-timber interiors and is clearly audible. Lower it toward 2 or 0 if it sounds
 * overdone outdoors, or set it to SOUND_ENVIRONMENT_NONE for no reverb at all.
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
 * The river point ambience category's own copies of the night beds above.
 *
 * Normalised with the other point ambience clips and played at every hour. The area beds keep the
 * originals. The day takes are archived as river_day_1 to 3 in the same folder, referenced by
 * nothing. Every one carries bird or frog calls over water measuring 5 dB thinner under 1 kHz and an
 * octave brighter than these, so one arriving reads as a different river rather than as this one
 * with something singing over it. A day set wants a take recorded over THIS water.
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
