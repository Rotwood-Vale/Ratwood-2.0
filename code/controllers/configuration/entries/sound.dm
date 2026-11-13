/datum/config_entry/flag/disable_music_wall_muffle

/// Category names disabled at startup
/datum/config_entry/keyed_list/silence_point_ambience
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/// Startup mode: 0 off, 1 live, 2 fallback. The admin menu cannot enter fallback during a round
/datum/config_entry/number/point_ambience_mode
	config_entry_value = 1
	min_val = 0
	max_val = 2

/// Minimum deciseconds between movement requests. Zero requests on every eligible step. Larger
/// intervals reduce services but delay volume and position updates
/datum/config_entry/number/point_ambience_move_interval
	config_entry_value = 0
	min_val = 0

/// Running interval override in deciseconds. Zero retains the ordinary movement interval. Has no
/// effect when that interval is zero
/datum/config_entry/number/point_ambience_move_interval_running_override
	config_entry_value = 0
	min_val = 0

/// Maximum natural steps between movement requests. Can shorten the time interval but never
/// lengthen it. Zero disables this additional limit
/datum/config_entry/number/point_ambience_move_steps
	config_entry_value = 0
	min_val = 0

/// Silences unusually fast movers except for their held torch. Zero disables the cutoff
/datum/config_entry/number/point_ambience_speed_cutoff
	config_entry_value = 1
	min_val = 0
	max_val = 1

/// Movement service cap per tick. Zero disables the cap and inline tick-usage gate
/datum/config_entry/number/point_ambience_max_services_per_tick
	config_entry_value = 8
	min_val = 0

/// Queue movement requests for budgeted processing instead of servicing them inside Move()
/datum/config_entry/number/point_ambience_queue
	config_entry_value = 1
	min_val = 0
	max_val = 1

/// Deciseconds after service during which the standing sweep skips a listener. Zero disables it.
/// Longer skips save visits but delay the final position update after stopping
/datum/config_entry/number/point_ambience_standing_skip
	config_entry_value = 0
	min_val = 0

/// Decay shape: zero uses the range-band curve, one gives even decibel decay, higher values drop
/// faster near the source.  Pinned categories, including rivers, keep their own curve. This changes
/// volume with distance, not service frequency
/datum/config_entry/number/point_ambience_falloff_hardness
	config_entry_value = 1
	min_val = 0
	max_val = 6

/// Smooth near-source panning. Zero restores the one-tile axis dead zone
/datum/config_entry/number/point_ambience_pan_depth_floor
	config_entry_value = 1
	min_val = 0
	max_val = 1

/**
 * Effective vertical distance in tiles for sounds allowed to cross floors.
 *
 * Zero adds no geometric distance. Positive values combine with horizontal distance before falloff.
 * Separate floor attenuation still applies. Loaded into GLOB.sound_storey_tiles at subsystem
 * initialization.
 */
/datum/config_entry/number/sound_storey_tiles
	config_entry_value = 4
	min_val = 0
	max_val = 20
