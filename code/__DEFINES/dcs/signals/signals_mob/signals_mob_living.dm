/// From base of /mob/living/proc/update_turf_movespeed()
#define COMSIG_LIVING_UPDATE_TURF_MOVESPEED "update_turf_movespeed"
	/// Return value if the movespeed update is blocked
	#define TURF_MOVESPEED_BLOCKED (1<<0)

/// Sent from /mob/living/proc/look_around()
#define COMSIG_LOOK_AROUND_SPOTTED "look_around_spotted"

/// From the top of /mob/living/carbon/human/death(), before anything dies: (gibbed)
#define COMSIG_LIVING_PRE_DEATH "living_pre_death"
	/// Cancel death entirely
	#define COMPONENT_CANCEL_DEATH (1<<0)

/// From /mob/living/verb/succumb(): ()
#define COMSIG_LIVING_SUCCUMBED "living_succumbed"
/// Return a list of custom warnings before you succumb: (list/warnings)
#define COMSIG_LIVING_GET_SUCCUMB_WARNINGS "living_get_succumb_warnings"

/// Clicking on the close eyes button, excludes forced closings: ()
#define COMSIG_LIVING_CLOSED_EYES "living_closed_eyes"

/// When a mob opens their eyes: ()
#define COMSIG_LIVING_TRY_OPEN_EYES "living_try_open_eyes"
	/// Prevents opening the eyes
	#define COMPONENT_BLOCK_OPEN_EYES (1<<0)

/// Check if target can be staked: (mob/living/user, obj/item/stake)
#define COMSIG_LIVING_CAN_BE_STAKED "living_can_be_staked"
	/// Return if driving a stake through this mob's heart would do anything
	#define COMPONENT_STAKE_VULNERABLE (1<<0)
/// Sent once a stake has been driven through the mob's heart: (mob/living/user, obj/item/stake)
#define COMSIG_LIVING_STAKED "living_staked"
	/// Return if the staking was handled elsewhere
	#define COMPONENT_STAKE_HANDLED (1<<0)
