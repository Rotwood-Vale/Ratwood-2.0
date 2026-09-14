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
 * moved. Costs nothing but the send. This is the default and most sound should be this.
 *
 * AMBIENT POINT SOURCE: SSpoint_ambience
 *
 * MANY static things of a FEW KINDS, each audible from a few tiles, that should be heard whenever
 * you are near one. Hearths, campfires, wall sconces, fountains, bone piles, rivers.
 *
 * Register a source with a category typepath and it is served to any listener in range, live: the
 * volume and pan sweep as you walk, it stops the instant the source does, and a wall between you
 * and it silences it. Only the NEAREST source per category is served, so a thousand hearths cost
 * at most one send per listener, and a source nobody is near costs only a range reject.
 *
 * Billed PER MOVING LISTENER, not per source. That is the trade: adding sources is nearly free,
 * adding players is not. A model based on local timings projected 2 to 7 ms/s for 150 in-round players;
 * 150 was the assumed population, not a tested player count. Client testing used at most two
 * clients. The comparison with plain loops and any break-even population depend on movement,
 * audible sources and batching; neither design's total cost is independent of listener count.
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
 *   2. few exist AT ONCE (tens, never hundreds) — lifetime does not matter, overlap does
 *   3. it is positional at all (a `direct` loop has no distance term and gains nothing)
 *
 * Use it when: all three hold. Anything failing (2) belongs in point ambience; anything failing
 * (1) or (3) is a plain object loop.
 *
 * WALL MUFFLING ON A TOKEN: muffle_behind_walls
 *
 * OFF by default and it should stay off unless the case is argued. It is not a fidelity setting to
 * be turned on everywhere for consistency; it is a per-listener line walk paid on every step, and
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
 *   2. its range is short (cost scales with line length; a range 12 source walks 12 tiles to find
 *      nothing, on every listener, on every step)
 *   3. few listeners are near it at once, since this is billed per listener per step
 *   4. NOTHING TACTICAL RIDES ON HEARING IT. A combat cue that becomes cover-dependent is a balance
 *      change, not an audio fix, and wants deciding as one. Spell charge hums are the example:
 *      hearing someone wind up is a warning to whoever is on the other side of the wall, so
 *      muffling it takes that warning away and hands the advantage to the caster.
 *
 * Set on the four music loops and on boilloop. Deliberately NOT set on the rat alarm (range 15
 * outdoors, so the dearest check on the longest line), the spell charge hums (criterion 4, and they
 * land on combat ticks), or fliesloop (one per rotting corpse, so the instance count is unbounded).
 *
 * Note point ambience does its own occlusion and does not use this. It reads turf opacity ONLY,
 * where a token also reads turf CONTENTS and so catches doors: a token re-evaluates every listener
 * whenever either side moves, while a point ambience listener standing still never re-sends, so a
 * door's state would freeze into the sound until they walked.
 */

//max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
//A channel is a slot on ONE LISTENER'S mixer, not a handle on an object: 1019 on your client and
//1019 on mine are unrelated. So a kind of sound needs as many numbers as one person can hear of it
//at once, never as many as exist. One heartbeat channel serves every player because you only hear
//your own; one torch channel serves 1112 sconces because point ambience plays only the nearest.
//FREE: 1016 alone now. It and the two below were held by VOX, JUSTICAR_ARK and BICYCLE, none of
//which this codebase ever played, and were taken back rather than lowering the pool ceiling.
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023 //USED FOR MUSIC
///Flies on a rotting body. Split off misc so a corpse and a clock in one room do not silence each
///other, which they did while both rode misc's single voice.
#define CHANNEL_ROT_AMBIENCE 1022
#define CHANNEL_JUKEBOX 1021
///Grandfather and wall clocks. Its own voice for the same reason, and because there are about 70 of
///them per map: at misc's range they would have muted each other across a manor.
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
///Rivers, separate from fountains and waterwheels so the two layer instead of suppressing each
///other, and so a river's reach can be set from the bank rather than from the middle of the water.
#define CHANNEL_RIVER_AMBIENCE 1004

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

//SSsounds builds its pool as 1 to this, so every number ABOVE it is reserved by hand and every
//number at or below it can be handed to any one-shot playsound(channel = 0), token or instrument.
//1004 to 1024 is 21 numbers and 20 are taken, 1016 being the only one left. Claiming a SECOND one
//means LOWERING THIS FIRST. Take 1003 without lowering it and the pool still hands
//1003 out, so the new sound and whatever borrowed it cut each other off only when both happen to
//play, which is the kind of fault that survives a whole round of testing.
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
 * source as at the edge of its range. Pythagorean, because that is what the distance is; the
 * multiplier stays as the obstruction term. GLOB.sound_storey_tiles is 0 by default and this
 * returns the distance unchanged then.
 *
 * A MACRO, not a proc, and not two copies. playsound_local and SSpoint_ambience's slim_send are
 * hand-maintained mirrors of the same recipe: adding this term to one and not the other made every
 * cross-floor send disagree, which the Send Diff verb caught at 1000 mismatches. Anything both
 * paths must compute identically belongs here, where they expand the same source.
 *
 * PASS `dist` AS A LOCAL, NEVER AN EXPRESSION. It is named three times below and substitution is
 * textual, so an expression is evaluated up to three times: `sqrt(...)` becomes two square roots,
 * and a proc call becomes two calls. A proc would evaluate its arguments once; a macro does not.
 */
#define STOREY_ADJUSTED_DISTANCE(dist, storeys)\
	(((storeys) && GLOB.sound_storey_tiles) \
		? sqrt((dist) * (dist) + (storeys) * GLOB.sound_storey_tiles * (storeys) * GLOB.sound_storey_tiles) \
		: (dist))

///Default range of a sound. TG uses 15 for its 15x15 view; our world.view is 7, so adopting
///15 would double every sound's reach. All the mapped extra_range values were tuned against 7.
#define SOUND_RANGE 7
///extra range for sounds considered to be quieter. TG: -3 against range 15, scaled to our 7.
#define MEDIUM_RANGE_SOUND_EXTRARANGE -1
///default extra range for sounds considered to be quieter still. TG: -7 against range 15.
#define SHORT_RANGE_SOUND_EXTRARANGE -3
///Percentage of sound's range where no falloff is applied. 0 on purpose: a flat zone near the
///source reads as broken rather than loud: you walk several tiles and nothing changes at all.
///The near-field is kept gentle by SOUND_FALLOFF_EXPONENT being below 1 instead, which degrades
///from the very first tile but slowly.
#define SOUND_DEFAULT_FALLOFF_DISTANCE 0
///Falloff curves, one per range band. The curve is computed against each sound's OWN range, so
///its shape is proportional: at half of its range a sound sits at the same volume whether that
///range is 5 tiles or 50. Perception is not proportional. Four tiles away is four tiles away,
///so a single exponent tuned for a room reads as "no falloff at all" on anything that carries
///further. Hence three models, picked by sound_falloff_for_range().
///
///Tuned by hand, mostly to stop music cutting from full to nothing in one step as you walk out of
///a noisy area. Every curve fades to SOUND_DEFAULT_MIN_VOLUME at the edge instead of reaching zero
///early, which is what made sounds vanish while still well inside their own range.
///
///Below 1 the drop is back-loaded: gentle near the source, accelerating toward the edge.
///Above 1 it inverts, front-loading the drop and then easing onto the floor.
///
///Room scale, and the overwhelming majority of sounds: 100 98 92 82 68 50 28 2 over tiles 0-7,
///for a volume 100 source landing on the default floor.
#define SOUND_FALLOFF_EXPONENT 0.5
///Carries across a hall or a street rather than a room. Below 1 for the same reason the short
///curve is: the drop stays gentle near the source and steepens toward the edge, so the falloff
///lands where the sound is leaving earshot rather than while it is still filling the room.
///At range 17, roughly: 100 97 93 89 84 79 73 68 62 56 50 43 37 30 23 16 9, then the floor.
#define SOUND_FALLOFF_EXPONENT_MEDIUM 0.8
///Carries across the map. In practice only the church bell: about 100 at the bell, 77 at 8 tiles,
///43 at 50, 15 at 110, and the floor at the edge.
#define SOUND_FALLOFF_EXPONENT_LONG 2

///Range at which each band takes over. Nearly every call site lands in the short band.
#define SOUND_RANGE_MEDIUM 10
#define SOUND_RANGE_LONG 28
/**
 * Volume a sound falls off TO at max range, rather than falling off to silence. Without a floor
 * the curve reaches 0 before the edge and sounds vanish well inside their range.
 *
 * This is the curve's asymptote, applied BEFORE mastervol, so it arrives scaled: 2 here is 1 for a
 * listener at 50 and 0.5 at 25. There is no lift back afterwards, on purpose, so a player who
 * turned the game down hears the edge as quiet as they asked for. Point ambience floors are scaled
 * by the point ambience slider instead of mastervol.
 *
 * THE DEFAULT, NOT THE ONLY ONE. Point ambience passes its category's floor instead, because a
 * sustained loop and a transient are not audible at the same level: ERP at 1 is heard clearly
 * where a fountain at 1 is not, and 3 carries for a clock's ticks while a torch's crackle at 3 does
 * not. Two is what one-shots and ERP audio land on, and raising it lifts the last tile of every
 * footstep and combat sound in the game, so raise a category instead
 */
#define SOUND_DEFAULT_MIN_VOLUME 2

///How much front-back depth a sound is given relative to its sideways offset, as a floor.
///A sound due east or west has no front-back component at all, and BYOND renders that as a
///hard pan into one ear: fine on speakers, uncomfortable on headphones over a long session.
///At 1.0 a purely sideways sound is placed at 45 degrees instead of 90, which is about 70%
///pan rather than 100%, while still being unmistakably on that side. 0 restores hard panning.
#define SOUND_PAN_MIN_DEPTH 1

///Volume multiplier per storey between source and listener. Distance here is horizontal only, so
///without an explicit rule someone directly above a sound is at distance 0 and hears it at full
///volume. One floor away is halved, two or more is inaudible. Shared by playsound_local() and
////datum/sound_token so the two paths cannot drift apart.
#define SOUND_STOREY_VOLUME_MULT 0.5

///HOW A SOUND GETS PAST A BARRIER. One axis, one vocabulary, used by every system that cares: ERP
///names one at the call, an emote carries one on its datum, and a bare playsound gets the default.
///
///Ordered by containment, so the ladder reads: each is more contained than the one above it. The
///A wall mode and a sound class were always the same thing described twice, so this is one enum
///where there were two.
///
///FLOORS ARE NOT PART OF THIS. They are `floor_volume` below, because the two axes come apart: an
///emote carries through walls dulled AND attenuates normally through a ceiling, which no single
///bundled class could express. Only SOUND_TRAVEL_CONTAINED speaks for both, and only because
///"contained" means contained.
///
///Costs a line walk per listener on everything but UNRESTRICTED, so that is the default for the
///~1400 bare call sites; the rest are for things firing every few seconds, not footsteps.
#define SOUND_TRAVEL_UNRESTRICTED 0	//barriers ignored, no walk. THE DEFAULT.
#define SOUND_TRAVEL_CARRYING 1	//through a barrier at full range, dulled. == TRUE, so a caller still passing TRUE gets what it did.
#define SOUND_TRAVEL_LEAKING 2	//a few tiles past a barrier and no further: capped at SOUND_TRAVEL_LEAK_VOLUME, reaching SOUND_TRAVEL_LEAK_RANGE tiles PAST IT, wherever the source stands.
#define SOUND_TRAVEL_CONTAINED 3	//stops at a barrier, and never crosses a floor. A guarantee, not a default: playsound and playsound_local both enforce it.

///What a floor does, separately from what a wall does. NULL attenuates and halves like any
///positional sound, which is what an ordinary sound and an emote want. SOUND_FLOOR_NEVER does not
///cross at all and playsound skips gathering the floors either side. Any positive number CAPS the
///volume there regardless of distance, which is how sex audio is held quiet through a ceiling
///without being silenced.
///
///Do not raise the caps; audio through a floor is a common complaint and the only thing carrying
///further buys is people breaking the door down. Lowering is always safe.
#define SOUND_FLOOR_NEVER 0
///The cap each travel class asks for by default, which playsound_erp applies and any caller may
///override. CONTAINED cannot be overridden: see the enforcement in playsound().
#define SOUND_TRAVEL_FLOOR(travel) ((travel) == SOUND_TRAVEL_CARRYING ? 4 : ((travel) == SOUND_TRAVEL_LEAKING ? 2 : SOUND_FLOOR_NEVER))
///What SOUND_TRAVEL_LEAKING gives a listener properly enclosed behind a barrier: this volume as a CAP,
///for this many tiles past the barrier, and nothing beyond. The muffle profile alone only dulls a
///sound and leaves it audible across its whole range, which is why a cap exists at all.
///
///The two do different jobs and should be tuned apart. The cap decides how LOUD it is through a wall
///and dominates most of the zone; the range decides how FAR, and is the only thing that stops it.
///Ordinary falloff still runs underneath, so the last tile or two fade rather than cutting flat.
///
///LEAKING is the only class that reaches these: CONTAINED stops at the barrier and CARRYING is
///meant to carry. An emote categorised as LEAKING gets them too.
#define SOUND_TRAVEL_LEAK_VOLUME 5
///THE LAST TILE STILL AUDIBLE, measured FROM THE BARRIER. One is standing against the wall, so this
///is that tile plus two more.
///
///From the barrier and not the source, which is the whole point: opacity_between walks listener ->
///source, so the tile it stops on is the first wall on the LISTENER'S side and the distance to it is
///how far past the wall they are. Measured from the source instead, what you heard outside a room
///depended on how deep into it the bed sat, and a source three tiles in was inaudible from the far
///side of its own wall.
#define SOUND_TRAVEL_LEAK_RANGE 3
///ROUND A CORNER IS NOT THROUGH A WALL. Every class but UNRESTRICTED muffles at full range where an
///open path exists, because a sound really does reach you round a corner; only a listener properly
///enclosed is stopped or capped. That is why the grading exists at all.
///
///What playsound_local is told about one listener. Ordered, so truthiness still means "muffled at
///all" for every caller that only ever knew TRUE and FALSE.
#define SOUND_MUFFLE_NONE 0
#define SOUND_MUFFLE_SOFT 1	//== TRUE. The profile only: what a storey gives, and what every boolean caller has always meant.
#define SOUND_MUFFLE_ENCLOSED 2	//the profile plus the leak cap. Only playsound produces it, from SOUND_TRAVEL_LEAKING.

///The muffle profile, used when a sound reaches a listener through a wall, a floor, or (for a
///dullahan) a container the head is shut inside. Grouped so the character can be tuned in one
///place rather than as literals buried in playsound_local().
///Volume and the falloff curve are only half of it. On their own they read as "further away"
///rather than "behind something". The occlusion pair is what changes the timbre.
#define SOUND_MUFFLE_VOLUME_MULT 0.75
#define SOUND_MUFFLE_EXPONENT_MULT 1.5
///BYOND reverb preset 11, "carpeted hallway": a dead, absorbent room with little reflection.
#define SOUND_MUFFLE_ENVIRONMENT 11
///Preset 22, "underwater", for ERP audio through a wall. Obviously wrong for open air, which is
///the point: it should read as something you were not meant to hear clearly rather than as a
///nearby sound turned down. Using it costs the occlusion filter, since an echo array replaces the
///preset outright, so this is the preset OR the filter and not both.
#define SOUND_ERP_MUFFLE_ENVIRONMENT 22

///What a line between a listener and a source ran into. CLEAR: nothing opaque on it. SOLID: blocked,
///and no open line from either tile beside the obstruction, so the source is enclosed and not served.
///MUFFLED: blocked on the direct line but open from a tile beside the obstruction, a corner, so it is
///served dulled. A test for a diagonal step slipping between two corner-to-corner walls was measured
///and never fired; the line lands on walls rather than between them.
#define OCCLUSION_CLEAR 0
#define OCCLUSION_SOLID 1
#define OCCLUSION_MUFFLED 2

///SSpoint_ambience modes. LIVE serves each client the nearest sources per step and per tick;
///FALLBACK gives each source a plain timer loop instead, cheaper on a full server, attenuation
///frozen between replays, torches silent; OFF is silent.
///Not a mode. The Mode verb's "leave it alone" option, so the settings after the mode prompt can be
///reached without changing it. Never assigned to SSpoint_ambience.mode.
#define POINT_AMBIENCE_MODE_UNCHANGED -1
#define POINT_AMBIENCE_OFF 0
#define POINT_AMBIENCE_LIVE 1
#define POINT_AMBIENCE_FALLBACK 2

///The per-category send state SSpoint_ambience keeps on a client (client.point_ambience_slots),
///one positional list per category: what the source decided when it last changed, the volume
///last sent, and the timer that advances a set of clips.
///
///A list PER CATEGORY, not one flat list with an offset: flattening was measured and moved nothing,
///and an offset a caller carries can read the neighbouring category's fields where a sublist cannot.
#define POINT_AMBIENCE_SLOT_TURF 1
#define POINT_AMBIENCE_SLOT_VOLUME 2
#define POINT_AMBIENCE_SLOT_CONTINUOUS 3
#define POINT_AMBIENCE_SLOT_FREQUENCY 4
#define POINT_AMBIENCE_SLOT_LAST_VOLUME 5
#define POINT_AMBIENCE_SLOT_FILE 6
#define POINT_AMBIENCE_SLOT_TIMER 7
#define POINT_AMBIENCE_SLOT_FIELDS 7

///Densest candidate box SSpoint_ambience.drain_density_count gives its own bucket, anything denser
///landing in the last one. The list is one longer, an empty cell taking the first bucket. Twice the
///densest box on any shipped map, measured, leaving room for the corpses and dropped torches that
///register on top; lower it and a busy tile's percentiles read low.
#define POINT_AMBIENCE_DENSITY_MAX 64

///sound.echo is the 18-slot EAX property array; slot 7 is Occlusion, in millibels (-10000..0).
///It low-passes the direct path, which is the only thing here that genuinely alters the sound
///rather than its level. -1500 is roughly a closed door.
///EXPERIMENTAL: slots 3 and 4 are proven by our own reverb-kill code, but BYOND's support for
///the rest of the array is old and may be backend-dependent. If a playtest hears no difference
///the array is not being honoured: set this to 0 and the volume/environment muffle remains.
#define SOUND_MUFFLE_OCCLUSION -1500
///Slot 8, OcclusionLFRatio (0..1): how much of the occlusion applies to LOW frequencies. Lower
///lets more bass through, which is what a wall actually does. You hear the thump, not the
///detail. 0.25 is the EAX default.
#define SOUND_MUFFLE_OCCLUSION_LF 0.25

///Reverb used when the listener's area does not set its own soundenv, which is nearly all of
///them. Previously that case fell through to SOUND_ENVIRONMENT_NONE, which kills reverb outright
///and left most of the game bone dry. It also made muffling pointless: the muffle swaps in a dead
///room, and a dead room is LIVELIER than no reverb at all, so a sound heard through a wall came
///out slightly more reverberant than one heard across an open room.
///BYOND presets: 0 generic, 1 padded cell, 2 room, 4 living room, 5 stone room, 6 auditorium,
///7 concert hall, 8 cave, 13 stone corridor, 15 forest, 16 city, 17 mountains, 19 plain.
///5 suits stone-and-timber interiors and is clearly audible. Lower it toward 2 or 0 if it sounds
///overdone outdoors, or set it to SOUND_ENVIRONMENT_NONE to restore the old dry behaviour.
#define SOUND_DEFAULT_ENVIRONMENT 5

///byond sound environment for "no environment"; area soundenv uses this as its off value
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
