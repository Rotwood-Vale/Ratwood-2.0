/datum/action/cooldown/mob_cooldown
	/// Toggles whether this action is usable or not
	var/action_disabled = FALSE

/// Re-enables this cooldown action
/datum/action/cooldown/mob_cooldown/proc/enable()
	action_disabled = FALSE

/// Disables this cooldown action
/datum/action/cooldown/mob_cooldown/proc/disable()
	action_disabled = TRUE

/// Re-enables all cooldown actions
/datum/action/cooldown/mob_cooldown/proc/enable_cooldown_actions()
	for(var/datum/action/cooldown/mob_cooldown/cd_action in owner.actions)
		cd_action.enable()

/// Disables all cooldown actions
/datum/action/cooldown/mob_cooldown/proc/disable_cooldown_actions()
	for(var/datum/action/cooldown/mob_cooldown/cd_action in owner.actions)
		cd_action.disable()
