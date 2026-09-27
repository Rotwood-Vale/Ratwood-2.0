/datum/config_entry/flag/disable_music_wall_muffle	// Music sources (instruments, bands, music boxes) play through walls unmuffled

/datum/config_entry/keyed_list/silence_point_ambience	// Point ambience categories that make NO sound at all, one config_name per line
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/number/point_ambience_mode	// 0 off, 1 live, 2 fallback loops. Seeds SSpoint_ambience at boot. The Point Ambience Mode verb switches 0 and 1 live but cannot enter or return to 2, so fallback is a boot-time choice only
	config_entry_value = 1
	min_val = 0
	max_val = 2

/datum/config_entry/number/point_ambience_move_interval	// Deciseconds between move-hook services of one client, 0 serves every step
	config_entry_value = 0
	min_val = 0

/datum/config_entry/number/point_ambience_move_interval_running_override	// Replaces the interval above for a RUNNING client. 0 means no override, not "uncapped"
	config_entry_value = 0
	min_val = 0

/datum/config_entry/number/point_ambience_move_steps	// Most steps a client takes between move-hook services at a natural pace, walking or running. The two intervals above stay as caps. 0 leaves them alone
	config_entry_value = 0
	min_val = 0

/datum/config_entry/number/point_ambience_speed_cutoff	// 1: a client stepping faster than a natural speed 15 run hears no point ambience while moving, a torch in hand excepted. 0 serves them like anyone else
	config_entry_value = 1
	min_val = 0
	max_val = 1

/datum/config_entry/number/point_ambience_max_services_per_tick	// Ceiling on move-hook ambience services in one tick across all clients. 0 is none and also turns off the tick-usage gate
	config_entry_value = 8
	min_val = 0

/datum/config_entry/number/point_ambience_queue	// 1: a step marks the client and the tick serves everyone marked back to back, up to the cap. 0: service inline inside Move() with the cap and tick gate
	config_entry_value = 1
	min_val = 0
	max_val = 1

/datum/config_entry/number/point_ambience_standing_skip	// Deciseconds within which the once-a-second walk passes over a client a step already served. 0 never skips and is smoothest for a moving listener, and a longer window skips more of those walks
	config_entry_value = 0
	min_val = 0

/datum/config_entry/number/point_ambience_falloff_hardness	// How point ambience decays with distance. 1 drops the same proportion every tile, an even fade in decibels. 0 keeps each category's band curve for its range, from sound_falloff_for_range(). Above 1 front-loads the drop for more separation close in, at the cost of that evenness. Categories whose curve is deliberate, the river, ignore this
	config_entry_value = 1
	min_val = 0
	max_val = 6

/datum/config_entry/number/point_ambience_pan_depth_floor	// 1 holds a point ambience source at a minimum depth close in, so its direction sweeps past continuously. 0 restores the one tile dead zone, which centres a source within a tile on an axis and then snaps it to 45 degrees
	config_entry_value = 1
	min_val = 0
	max_val = 1

/datum/config_entry/number/point_ambience_cross_floor	// 1 also ranks the floor above and below, served muffled. 0 ranks the listener's own floor only. Off by design, and on it adds a storey pass to any walk whose own floor leaves a category unanswered
	config_entry_value = 0
	min_val = 0
	max_val = 1

/**
 * Tiles of effective distance a floor adds between a source and a listener.
 *
 * At 0 crossing a floor is a flat halving that costs the same directly overhead as it does at the
 * edge of range. Above 0 the floor also counts as distance, so a listener walks out of a sound from
 * upstairs instead of only ever hearing it at half. Cached into GLOB at SSsounds init rather than
 * read per send, since playsound_local runs on every footstep in the game.
 */
/datum/config_entry/number/sound_storey_tiles
	config_entry_value = 4
	min_val = 0
	max_val = 20
