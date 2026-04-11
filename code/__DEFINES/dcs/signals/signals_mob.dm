#define COMSIG_MOB_MOVESPEED_UPDATED "mob_updated_movespeed"
///from base of /mob/Login(): ()
#define COMSIG_MOB_LOGIN "mob_login"
///from base of /mob/Logout(): ()
#define COMSIG_MOB_LOGOUT "mob_logout"
//seems somewhat useful
#define COMSIG_MOB_STATCHANGE "mob_statchange"

///before attackingtarget has happened, source is the attacker and target is the attacked
#define COMSIG_HOSTILE_PRE_ATTACKINGTARGET "hostile_pre_attackingtarget"
	#define COMPONENT_HOSTILE_NO_PREATTACK (1<<0) //cancel the attack, only works before attack happens
//#define COMPONENT_HOSTILE_NO_ATTACK COMPONENT_CANCEL_ATTACK_CHAIN //cancel the attack, only works before attack happens
///after attackingtarget has happened, source is the attacker and target is the attacked, extra argument for if the attackingtarget was successful
#define COMSIG_HOSTILE_POST_ATTACKINGTARGET "hostile_post_attackingtarget"

///Called when a /mob/living/simple_animal/hostile finds a new target: (atom/source, new_target)
#define COMSIG_HOSTILE_FOUND_TARGET "comsig_hostile_found_target"

#define COMSIG_MOB_ABILITY_STARTED "comsig_mob_ability_started"
#define COMSIG_MOB_ABILITY_FINISHED "comsig_mob_ability_finished"

#define COMSIG_SIMPLEMOB_PRE_ATTACK_RANGED "basicmob_pre_attack_ranged"
	#define COMPONENT_CANCEL_RANGED_ATTACK COMPONENT_CANCEL_ATTACK_CHAIN //! Cancel to prevent the attack from happening

///from the ranged_attacks component for basic mobs: (mob/living/basic/firer, atom/target, modifiers)
#define COMSIG_SIMPLEMOB_POST_ATTACK_RANGED "basicmob_post_attack_ranged"

///Check for /datum/emote/living/pray/run_emote(): message
#define COMSIG_CARBON_PRAY "carbon_prayed"
///Prevents the carbon's patron from hearing this prayer due to cancelation.
#define CARBON_PRAY_CANCEL (1<<0)

/// Called from the base of '/obj/item/bodypart/proc/drop_limb(special)' ()
#define COMSIG_MOB_DISMEMBER "mob_drop_limb"
	#define COMPONENT_CANCEL_DISMEMBER (1<<0) //cancel the drop limb

// Collar and chastity signals, arguments are the carbon mob and the item that was gained or lost
#define COMSIG_CARBON_GAIN_COLLAR "carbon_gain_collar"
#define COMSIG_CARBON_LOSE_COLLAR "carbon_lose_collar"
#define COMSIG_CARBON_GAIN_CHASTITY "carbon_gain_chastity"
#define COMSIG_CARBON_LOSE_CHASTITY "carbon_lose_chastity"

///Chastity state changed on a wearer (mob/living/carbon/human/wearer, obj/item/chastity/device, reason)
#define COMSIG_CARBON_CHASTITY_STATE_CHANGED "carbon_chastity_state_changed"

///Intimate accessory state changed on a wearer (mob/living/carbon/human/wearer, obj/item/intimate_accessory/device, reason)
#define COMSIG_CARBON_INTIMATE_STATE_CHANGED "carbon_intimate_state_changed"

/// Standardized received-sex-action hook emitted on the receiving carbon (mob/living/carbon/human/acting_mob, datum/sex_controller/acting_sexcon, datum/sex_action/action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)
#define COMSIG_CARBON_SEX_ACTION_RECEIVED "carbon_sex_action_received"

/// Pre-validation hook emitted on an involved carbon during sex action menu/execution checks (datum/sex_action/action, mob/living/carbon/human/other, checked_part, is_user_role, menu_check)
#define COMSIG_CARBON_SEX_ACTION_VALIDATE "carbon_sex_action_validate"
	/// Return to hide or block the action.
	#define COMPONENT_SEX_ACTION_BLOCK (1<<0)

/// Pre-command hook for collar masters targeting a pet (mob/living/carbon/human/pet, datum/component/collar_master/controller, command_id, command_value)
#define COMSIG_CARBON_COLLAR_COMMAND "carbon_collar_command"
	/// Return to block execution of a collar command.
	#define COMPONENT_COLLAR_COMMAND_BLOCK (1<<0)
	#define COLLAR_COMMAND_SHOCK "shock"
	#define COLLAR_COMMAND_FORCE_STRIP "force_strip"
	#define COLLAR_COMMAND_FORCE_SURRENDER "force_surrender"
	#define COLLAR_COMMAND_TOGGLE_AROUSAL "toggle_arousal"
	#define COLLAR_COMMAND_TOGGLE_SPEECH "toggle_speech"
	#define COLLAR_COMMAND_TOGGLE_DENIAL "toggle_denial"
	#define COLLAR_COMMAND_SET_CHASTITY_LOCK "set_chastity_lock"
	#define COLLAR_COMMAND_SET_CHASTITY_FRONT_MODE "set_chastity_front_mode"
	#define COLLAR_COMMAND_SET_CHASTITY_ANAL_OPEN "set_chastity_anal_open"
	#define COLLAR_COMMAND_SET_CHASTITY_SPIKES "set_chastity_spikes"
	#define COLLAR_COMMAND_SET_CHASTITY_FLAT "set_chastity_flat"

/// Fired when a pet is released/cleaned up from collar control (mob/living/carbon/human/pet, datum/component/collar_master/controller)
#define COMSIG_CARBON_COLLAR_RELEASED "carbon_collar_released"

/// Called before a cursed collar finalizes on a wearer (mob/living/carbon/human/wearer, datum/mind/master, obj/item/clothing/neck/roguetown/cursed_collar/collar)
#define COMSIG_CARBON_COLLAR_BIND_ATTEMPT "carbon_collar_bind_attempt"
	/// Return to prevent the collar from binding.
	#define COMPONENT_COLLAR_BIND_BLOCK (1<<0)

/// Called after a cursed collar binds successfully (mob/living/carbon/human/wearer, datum/mind/master, obj/item/clothing/neck/roguetown/cursed_collar/collar)
#define COMSIG_CARBON_COLLAR_BOUND "carbon_collar_bound"

/// Called before lock state manipulation on chastity devices (mob/living/carbon/human/wearer, mob/living/actor, obj/item/source_item, new_locked_state, method)
#define COMSIG_CARBON_CHASTITY_LOCK_INTERACT "carbon_chastity_lock_interact"
	/// Return to prevent lock state changes from key/lockpick interactions.
	#define COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK (1<<0)

/// Called after lock state changes on chastity devices (mob/living/carbon/human/wearer, mob/living/actor, obj/item/source_item, new_locked_state, method)
#define COMSIG_CARBON_CHASTITY_LOCK_CHANGED "carbon_chastity_lock_changed"

///From living/Life() (seconds, times_fired)
#define COMSIG_LIVING_LIFE "living_life"

/// From /obj/item/grabbing/bite/drinklimb() (mob/living/target)
#define COMSIG_LIVING_DRINKED_LIMB_BLOOD "living_drinked_limb_blood"

/// From /obj/item/organ/proc/Remove() (mob/living/carbon/lost_organ, obj/item/organ/removed, special, drop_if_replaced)
#define COMSIG_MOB_ORGAN_REMOVED "mob_organ_removed"
