#define GET_AI_BEHAVIOR(behavior_type) SSai_behaviors.ai_behaviors[behavior_type]
#define HAS_AI_CONTROLLER_TYPE(thing, type) istype(thing?.ai_controller, type)
#define AI_STATUS_ON		1
#define AI_STATUS_OFF		2
#define AI_STATUS_IDLE		3

///Carbon checks
#define SHOULD_RESIST(source) (source.on_fire || source.buckled || HAS_TRAIT(source, TRAIT_RESTRAINED) || (source.pulledby && source.pulledby.grab_state > GRAB_PASSIVE))
#define IS_DEAD_OR_INCAP(source) (source.incapacitated() || source.stat)

// How far should we, by default, be looking for interesting things to de-idle?
#define AI_DEFAULT_INTERESTING_DIST 10

///Max pathing attempts before auto-fail
#define MAX_PATHING_ATTEMPTS 30
///Flags for ai_behavior new()
#define AI_CONTROLLER_INCOMPATIBLE (1<<0)
//Return flags for ai_behavior/perform()
///Update this behavior's cooldown
#define AI_BEHAVIOR_DELAY (1<<0)
///Finish the behavior successfully
#define AI_BEHAVIOR_SUCCEEDED (1<<1)
///Finish the behavior unsuccessfully
#define AI_BEHAVIOR_FAILED (1<<2)

///Does this task require movement from the AI before it can be performed?
#define AI_BEHAVIOR_REQUIRE_MOVEMENT (1<<0)
///Does this require the current_movement_target to be adjacent and in reach?
#define AI_BEHAVIOR_REQUIRE_REACH (1<<1)
///Does this task let you perform the action while you move closer? (Things like moving and shooting)
#define AI_BEHAVIOR_MOVE_AND_PERFORM (1<<2)
///Does finishing this task not null the current movement target?
#define AI_BEHAVIOR_KEEP_MOVE_TARGET_ON_FINISH (1<<3)
///Does finishing this task make the AI stop moving towards the target?
#define AI_BEHAVIOR_KEEP_MOVING_TOWARDS_TARGET_ON_FINISH (1<<4)
///Does this behavior NOT block planning?
#define AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION (1<<5)
///This behavior executes before all others and does not consume the process tick, allowing normal behaviors to run after it
#define AI_BEHAVIOR_EXECUTE_ALONGSIDE (1<<6)

///Cooldown on planning if planning failed last time
#define AI_FAILED_PLANNING_COOLDOWN 1.5 SECONDS

///Subtree defines
///This subtree should cancel any further planning, (Including from other subtrees)
#define SUBTREE_RETURN_FINISH_PLANNING 1

///AI flags
#define STOP_MOVING_WHEN_PULLED (1<<0)

//Blackboard

//Generic BB keys
#define BB_CURRENT_MIN_MOVE_DISTANCE "min_move_distance"

/// Signal sent when a blackboard key is set to a new value
#define COMSIG_AI_BLACKBOARD_KEY_SET(blackboard_key) "ai_blackboard_key_set_[blackboard_key]"

///Targetting keys for something to run away from, if you need to store this separately from current target
#define BB_BASIC_MOB_FLEE_TARGET "BB_basic_flee_target"
#define BB_BASIC_MOB_FLEE_TARGET_HIDING_LOCATION "BB_basic_flee_target_hiding_location"
#define BB_FLEE_TARGETTING_DATUM "flee_targetting_datum"

#define BB_FUTURE_MOVEMENT_PATH "BB_future_path"
#define BB_MOB_AGGRO_TABLE "aggro_table" // Associative list of [mob] -> threat_level
#define BB_HIGHEST_THREAT_MOB "highest_threat_mob"
#define BB_THREAT_THRESHOLD "threat_threshold" // Minimum threat to be considered hostile
#define BB_AGGRO_RANGE "aggro_range" // Range at which mobs can detect and add threats
#define BB_AGGRO_MAINTAIN_RANGE "aggro_maintain_range" // Range at which target is dropped if exceeded

///time until we should next eat, set by the generic hunger subtree
#define BB_NEXT_HUNGRY "BB_NEXT_HUNGRY"
///what we're going to eat next
#define BB_BASIC_MOB_FOOD_TARGET "BB_basic_food_target"
///what corpse we'll next try to eat
#define BB_BASIC_MOB_CORPSE_TARGET "BB_basic_mob_corpse_target"
///What creature we want to cocoon
#define BB_BASIC_MOB_COCOON_TARGET "BB_basic_mob_cocoon_target"
///Who we want dead above all else...
#define BB_MAIN_TARGET "BB_main_target"
///How many times we'll attack defendants before getting disinterested
#define BB_RETALIATE_ATTACKS_LEFT "BB_relatiate_attacks_left"
#define BB_RETALIATE_COOLDOWN "BB_retaliate_cooldown"

#define BB_BASIC_MOB_TAMED "BB_basic_mob_tamed"

#define BB_WANDER_POINT "BB_wander_point"
#define BB_MOB_EQUIP_TARGET "BB_equip_target"

//farm animals ai
#define BB_CHICKEN_LAY_EGG "BB_chicken_lay_egg"
#define BB_CHICKEN_NESTING_BOX "BB_chicken_nest_box"
#define BB_COW_TIP_REACTING "BB_cow_tip_reacting"
#define	BB_COW_TIPPER "BB_cow_tipper"

//Move then recheck ai
#define MOVEMENT_LOOP_START_FAST (1<<0)
#define BB_HUMAN_NPC_SWINGS_TAKEN		"human_npc_swings_taken"
#define BB_HUMAN_NPC_SWINGS_TARGET		"human_npc_swings_target"
#define BB_HUMAN_NPC_ZONE_COMMIT_COUNTER "human_npc_zone_commit_counter"
#define BB_HUMAN_NPC_WEAKPOINT			"human_npc_weakpoint"
#define BB_HUMAN_NPC_JUMP_COOLDOWN		"human_npc_jump_cooldown"
#define BB_HUMAN_NPC_FEINT_COOLDOWN		"human_npc_feint_cooldown"
#define BB_HUMAN_NPC_TECHNIQUE_CD		"human_npc_technique_cd"
#define BB_HUMAN_NPC_SPECIAL_EVAL_AT		"human_npc_special_eval_at"
#define BB_AI_ALERT_MODE_UNTIL			"ai_alert_mode_until"
#define BB_HUMAN_NPC_CURRENT_INTENT_ATTACKS_LEFT "human_npc_intent_attacks"
#define BB_ARCHER_NPC_TARGET_ARROW		"archer_target_arrow"
#define BB_ARCHER_NPC_STASHED_WEAPON	"archer_stashed_weapon"
#define BB_ARCHER_NPC_BOW				"archer_npc_bow"
#define BB_ARCHER_NPC_QUIVER			"archer_npc_quiver"
#define BB_ARCHER_NPC_NEXT_SHOT			"archer_next_shot"		// world.time the archer may next loose an arrow
#define BB_ARCHER_NPC_REPOSITION_TURF	"archer_reposition_turf"	// post-shot juke destination we're committed to
#define BB_ARCHER_NPC_REPOSITION_UNTIL	"archer_reposition_until" // world.time the post-shot juke commitment expires
#define BB_ARCHER_NPC_AIM_LOCK_TURF		"archer_aim_lock_turf"	// Where the target was when the shot is fired
#define BB_ARCHER_NPC_AIM_RELEASE		"archer_aim_release"		// The time where it was actually shot
#define BB_ARCHER_NPC_HOLD_UNTIL		"archer_hold_until"
#define BB_HELD_CONSUMABLE		"held_consumable"		// item we pulled out to use
#define BB_THROW_WINDUP_UNTIL	"throw_windup_until"	// world.time the drawn throwable may be loosed (NPC holds it visibly until then)
#define BB_FORCED_ATTACK_ZONE	"bb_forced_attack_zone"
#define BB_LOOT_TARGET "loot_target"
#define BB_LOOT_BLACKLIST "loot_blacklist"
#define BB_LOOT_NEXT_SCAN "loot_next_scan"
#define ARCHER_NPC_MIN_RANGE			4
#define ARCHER_NPC_KITE_FLOOR			1
#define ARCHER_NPC_KITE_RANGE			3
#define ARCHER_NPC_SHOOT_RANGE			6
#define ARCHER_NPC_RETREAT_PROJECT		4
#define ARCHER_NPC_JUKE_MIN_DIST		4
#define ARCHER_NPC_REPOSITION_TIME		(0.6 SECONDS) // how long a post-shot random juke commits before the straight retreat resumes
#define ARCHER_NPC_BURST_PER_TILE		(0.6 SECONDS)
#define ARCHER_NPC_PLANT_TIME			(1 SECONDS)
#define ARCHER_NPC_ARROW_SEARCH_RANGE	9
#define ARCHER_NPC_AIM_BASELINE			10
#define ARCHER_NPC_MAX_LEAD				2 // Overly large lead, especially with slow projectile often leads to wildly ridiculous shots from AI, so we clamp it to just range 2
#define ARCHER_NPC_STATIONARY_MISS		15
#define ARCHER_NPC_MOVING_TARGET_ERROR	10
#define ARCHER_NPC_LEAD_ERROR_PER_POINT 3
#define ARCHER_NPC_LEAD_ERROR_MAX_BONUS 15
#define ARCHER_NPC_LEAD_ERROR_PER_POOR	5
#define ARCHER_NPC_LEAD_ERROR_FLOOR		5
#define ARCHER_NPC_LEAD_ERROR_CEILING	85
#define ARCHER_NPC_MISS_OFFSET_TILES	1
#define ARCHER_NPC_BASE_SPREAD			30
#define ARCHER_NPC_SPREAD_BASELINE		15
#define ARCHER_NPC_SPREAD_PER_POINT		6
#define ARCHER_NPC_ARC_MISS_TILES		3
#define ARCHER_NPC_SCAVENGE_COMBAT_FLOOR 2
#define ARCHER_NPC_SCAVENGE_RESERVE		1
#define ARCHER_NPC_SCAVENGE_SAFE_DIST	3
#define ARCHER_NPC_LANE_SEARCH			3
#define ARCHER_NPC_DEFAULT_PROJECTILE_SPEED 0.8
#define AGGRO_CALL_FOR_HELP_THREAT	12
#define AGGRO_THREAT_CAP				300
#define AGGRO_THREAT_DECAY_MULT		0.75
#define AGGRO_THREAT_DECAY_FLAT		1
#define AGGRO_THREAT_SWITCH_MARGIN	10
#define AGGRO_THREAT_PEEL_BONUS		2
#define AGGRO_THREAT_TAUNT			250
#define AI_ITEM_THROWING		(1<<0)
// Azure equip signals and get_item_by_slot() speak small-int SLOT_* ids, not ITEM_SLOT_* bitflags.
#define AI_INVENTORY_WATCHED_SLOTS list(SLOT_BELT, SLOT_BELT_L, SLOT_BELT_R, SLOT_BACK, SLOT_BACK_L, \
	SLOT_BACK_R, SLOT_ARMOR, SLOT_PANTS, SLOT_SHIRT, SLOT_CLOAK, SLOT_NECK, SLOT_WRISTS)
