/// From base of /mob/living/proc/update_turf_movespeed()
#define COMSIG_LIVING_UPDATE_TURF_MOVESPEED "update_turf_movespeed"
	/// Return value if the movespeed update is blocked
	#define TURF_MOVESPEED_BLOCKED (1<<0)

/// Sent from /mob/living/proc/look_around()
#define COMSIG_LOOK_AROUND_SPOTTED "look_around_spotted"

/// After eyelid blindness is applied or removed: (eyesclosed)
#define COMSIG_LIVING_EYELIDS_UPDATED "living_eyelids_updated"

/// After carbon/update_stat() changes consciousness: (old_stat, new_stat)
#define COMSIG_LIVING_CONSCIOUSNESS_CHANGED "living_consciousness_changed"
