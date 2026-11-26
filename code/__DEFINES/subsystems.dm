//! Defines for subsystems and overlays
//!
//! Lots of important stuff in here, make sure you have your brain switched on
//! when editing this file

//! ## DB defines
/**
 * DB major schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MAJOR_VERSION 5

/**
 * DB minor schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MINOR_VERSION 11

/// When a query has been queued up for execution/is being executed
#define DB_QUERY_STARTED 0
/// When a query is finished executing
#define DB_QUERY_FINISHED 1
/// When there was a problem with the execution of a query.
#define DB_QUERY_BROKEN 2


//! ## Timing subsystem
/**
 * Don't run if there is an identical unique timer active
 *
 * if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
 * and returns the id of the existing timer
 */
#define TIMER_UNIQUE			(1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE			(1<<1)

/**
 * Timing should be based on how timing progresses on clients, not the server.
 *
 * Tracking this is more expensive,
 * should only be used in conjuction with things that have to progress client side, such as
 * animate() or sound()
 */
#define TIMER_CLIENT_TIME		(1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE			(1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT		(1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP				(1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME			(1<<6)

///Empty ID define
#define TIMER_ID_NULL -1

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
	* * timer_subsystem the subsystem to insert this timer into
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

//! ## Initialization subsystem

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 2
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 1

//! ### Initialization hints

///Nothing happens
#define INITIALIZE_HINT_NORMAL 0
/**
 * call LateInitialize at the end of all atom Initalization
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

///Call qdel on the atom after intialization
#define INITIALIZE_HINT_QDEL 2

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(flags_1 & INITIALIZED_1)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

//! ### SS initialization hints
/**
 * Negative values indicate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guaranteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2

/// The default return value which must be overridden. Will succeed with a warning.
#define SS_INIT_NONE -1

/// Subsystem initialized successfully.
#define SS_INIT_SUCCESS 2

/// If your system doesn't need to be initialized (by being disabled or something)
#define SS_INIT_NO_NEED 3

/// Successfully initialized, BUT do not announce it to players (generally to hide game mechanics it would otherwise spoil)
#define SS_INIT_NO_MESSAGE 4

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)

#define FIRE_PRIORITY_IDLE_NPC		5
#define FIRE_PRIORITY_SLOW_OBJECTS 5
#define FIRE_PRIORITY_ROLE_CLASS_HANDLER 10
#define FIRE_PRIORITY_PING			10
#define FIRE_PRIORITY_WET_FLOORS	10
#define FIRE_PRIORITY_WATER_LEVEL	10
#define FIRE_PRIORITY_SERVER_MAINT	10
#define FIRE_PRIORITY_RESEARCH		10
#define FIRE_PRIORITY_VIS			10
#define FIRE_PRIORITY_AMBIENCE    10
#define FIRE_PRIORITY_TRACKS		10
#define FIRE_PRIORITY_GARBAGE		15
#define FIRE_PRIORITY_DATABASE		16
#define FIRE_PRIORITY_INCONE		19
#define FIRE_PRIORITY_MOUSECHARGE	20
#define FIRE_PRIORITY_HOTSPOTS		20
#define FIRE_PRIORITY_NPC			20
#define FIRE_PRIORITY_ASSETS		20
#define FIRE_PRIORITY_NPC_MOVEMENT 	21
#define FIRE_PRIORITY_NPC_ACTIONS 	22
#define FIRE_PRIORITY_PROCESS		25
#define FIRE_PRIORITY_THROWING		25
#define FIRE_PRIORITY_SPACEDRIFT	30
#define FIRE_PRIORITY_SMOOTHING		35
#define FIRE_PRIORITY_HUDS			40
#define FIRE_PRIORITY_NETWORKS		40
#define FIRE_PRIORITY_OBJ			40
#define FIRE_PRIORITY_ACID			40
#define FIRE_PRIORITY_BURNING		40
#define FIRE_PRIORITY_DEFAULT		50
#define FIRE_PRIORITY_SOUND_LOOPS	55 // TG: 800
#define FIRE_PRIORITY_PARALLAX		65
#define FIRE_PRIORITY_MOBS			100
#define FIRE_PRIORITY_TGUI			110
#define FIRE_PRIORITY_TICKER		200
#define FIRE_PRIORITY_ATMOS_ADJACENCY	300
#define FIRE_PRIORITY_CHAT			400
#define FIRE_PRIORITY_RUNECHAT		410
#define FIRE_PRIORITY_OVERLAYS		500
#define FIRE_PRIORITY_INPUT			1000 // This must always always be the max highest priority. Player input must never be lost.

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)



//! ## Overlays subsystem
// A reasonable number of maximum overlays an object needs
// If you think you need more, rethink it
// On TGStation this is 100. Roguecode / Vanderlin uses 200 - so let's stick to this.
#define MAX_ATOM_OVERLAYS 200

///Compile all the overlays for an atom from the cache lists
#define POST_OVERLAY_CHANGE(changed_on) \
	if(length(changed_on.overlays) >= MAX_ATOM_OVERLAYS) { \
		var/text_lays = overlays2text(changed_on.overlays); \
		stack_trace("Too many overlays on [changed_on.type] - [length(changed_on.overlays)].\
			\n What follows is a printout of all existing overlays at the time of the overflow \n[text_lays]"); \
	} \
	if(alternate_appearances) { \
		for(var/I in changed_on.alternate_appearances){\
			var/datum/atom_hud/alternate_appearance/AA = changed_on.alternate_appearances[I];\
			if(AA.transfer_overlays){\
				AA.copy_overlays(changed_on, TRUE);\
			}\
		} \
	}

// Vote subsystem counting methods
/// First past the post. One selection per person, and the selection with the most votes wins.
#define VOTE_COUNT_METHOD_SINGLE 1
/// Approval voting. Any number of selections per person, and the selection with the most votes wins.
#define VOTE_COUNT_METHOD_MULTI 2

/// The choice with the most votes wins. Ties are broken by the first choice to reach that number of votes.
#define VOTE_WINNER_METHOD_SIMPLE "Simple"
/// The winning choice is selected randomly based on the number of votes each choice has.
#define VOTE_WINNER_METHOD_WEIGHTED_RANDOM "Weighted Random"
/// There is no winner for this vote.
#define VOTE_WINNER_METHOD_NONE "None"

/// Returned by [/datum/vote/proc/can_be_initiated] to denote the vote is valid and can be initiated.
#define VOTE_AVAILABLE "Vote Available"
