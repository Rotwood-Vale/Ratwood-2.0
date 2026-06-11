/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB


/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R")
	classic_keys = list("R") // END
	name = "toggle_throw_mode"
	full_name = "切换投掷模式"
	description = "切换是否投掷当前物品。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

//****** Base Intents ******

/datum/keybinding/carbon/intent_one
	hotkey_keys = list("1")
	name = "intent_one"
	full_name = "切换意图栏位 1"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_one/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(1)
/*	if(C.active_hand_index == 2)
		if(C.swap_hand(1))
			C.rog_intent_change(1)
	else
		if(C.l_index == 1)
			C.rog_intent_change(3)
		else
			C.rog_intent_change(1)*/

	return TRUE

/datum/keybinding/carbon/intent_two
	hotkey_keys = list("2")
	name = "intent_two"
	full_name = "切换意图栏位 2"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_two/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(2)
	return TRUE

/datum/keybinding/carbon/intent_three
	hotkey_keys = list("3")
	name = "intent_three"
	full_name = "切换意图栏位 3"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_three/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(3)
	return TRUE

/datum/keybinding/carbon/intent_four
	hotkey_keys = list("4")
	name = "intent_four"
	full_name = "切换意图栏位 4"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_four/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(4)
	return TRUE

//****** Quad Intents ******
/*
/datum/keybinding/carbon/give_intent
	hotkey_keys = list("G")
	name = "intent_give"
	full_name = "Select Give Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/give_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_GIVE)
	return TRUE*/

/datum/keybinding/carbon/bite_intent
	hotkey_keys = list("H")
	name = "intent_bite"
	full_name = "选择撕咬意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/bite_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_BITE)
	return TRUE

/datum/keybinding/carbon/jump_intent
	hotkey_keys = list("J")
	name = "intent_jump"
	full_name = "选择跳跃意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/jump_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP)
	return TRUE

/datum/keybinding/carbon/kick_intent
	hotkey_keys = list("K")
	name = "intent_kick"
	full_name = "选择踢击意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/kick_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_KICK)
	return TRUE

/datum/keybinding/carbon/steal_intent
	hotkey_keys = list("L")
	name = "intent_steal"
	full_name = "选择偷窃意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/steal_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_STEAL)
	return TRUE

/*

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = null
	name = "select_help_intent"
	full_name = "Select help intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_help_intent/down(client/user)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HELP)
	return TRUE


/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = null
	name = "select_disarm_intent"
	full_name = "Select disarm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_disarm_intent/down(client/user)
	user.mob?.a_intent_change(INTENT_DISARM)
	return TRUE


/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = null
	name = "select_grab_intent"
	full_name = "Select grab intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_grab_intent/down(client/user)
	user.mob?.a_intent_change(INTENT_GRAB)
	return TRUE


/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = null
	name = "select_harm_intent"
	full_name = "Select harm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_harm_intent/down(client/user)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HARM)
	return TRUE
*/

//****** RMB Intents ******

/datum/keybinding/carbon/rmb_intent_1
	hotkey_keys = list("Shift1")
	name = "rmb_intent_1"
	full_name = "选择佯攻架势"
	description = "选择右键佯攻架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_1/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 1)
	return TRUE

/datum/keybinding/carbon/rmb_intent_2
	hotkey_keys = list("Shift2")
	name = "rmb_intent_2"
	full_name = "选择瞄准架势"
	description = "选择右键瞄准架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_2/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 2)
	return TRUE

/datum/keybinding/carbon/rmb_intent_3
	hotkey_keys = list("Shift3")
	name = "rmb_intent_3"
	full_name = "选择强击架势"
	description = "选择右键强击架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_3/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 3)
	return TRUE

/datum/keybinding/carbon/rmb_intent_4
	hotkey_keys = list("Shift4")
	name = "rmb_intent_4"
	full_name = "选择迅捷架势"
	description = "选择右键迅捷架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_4/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 4)
	return TRUE

/datum/keybinding/carbon/rmb_intent_5
	hotkey_keys = list("Shift5")
	name = "rmb_intent_5"
	full_name = "选择防御架势"
	description = "选择右键防御架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_5/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 5)
	return TRUE

/datum/keybinding/carbon/rmb_intent_6
	hotkey_keys = list("Shift6")
	name = "rmb_intent_6"
	full_name = "选择虚招架势"
	description = "选择右键虚招架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_6/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 6)
	return TRUE

/datum/keybinding/carbon/cycle_rmb_intent
	hotkey_keys = list("N")
	name = "cycle_rmb_intent"
	full_name = "循环右键架势"
	description = "循环切换可用的右键架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/cycle_rmb_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.cycle_rmb_intent()
	return TRUE

// ** Action Buttons **
// I stopped at 6 because it is probably the maximum number you can comfortably reach on keyboard
/datum/keybinding/carbon/actions
	var/action_taken = 1
/datum/keybinding/carbon/actions/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	var/list/datum/action/actions = C.actions
	if(actions.len < action_taken) // Dodge a runtime
		return FALSE
	var/datum/action/action = actions[action_taken]
	if(!action)
		return FALSE
	action.Trigger()

/datum/keybinding/carbon/actions/action_1
	hotkey_keys = list("Alt1")
	name = "action_1"
	full_name = "动作 1"
	description = "触发第一个动作。"
	category = CATEGORY_CARBON
	action_taken = 1

/datum/keybinding/carbon/actions/action_2
	hotkey_keys = list("Alt2")
	name = "action_2"
	full_name = "动作 2"
	description = "触发第二个动作。"
	category = CATEGORY_CARBON
	action_taken = 2

/datum/keybinding/carbon/actions/action_3
	hotkey_keys = list("Alt3")
	name = "action_3"
	full_name = "动作 3"
	description = "触发第三个动作。"
	category = CATEGORY_CARBON
	action_taken = 3

/datum/keybinding/carbon/actions/action_4
	hotkey_keys = list("Alt4")
	name = "action_4"
	full_name = "动作 4"
	description = "触发第四个动作。"
	category = CATEGORY_CARBON
	action_taken = 4

/datum/keybinding/carbon/actions/action_5
	hotkey_keys = list("Alt5")
	name = "action_5"
	full_name = "动作 5"
	description = "触发第五个动作。"
	category = CATEGORY_CARBON
	action_taken = 5

/datum/keybinding/carbon/actions/action_6
	hotkey_keys = list("Alt6")
	name = "action_6"
	full_name = "动作 6"
	description = "触发第六个动作。"
	category = CATEGORY_CARBON
	action_taken = 6

/datum/keybinding/carbon/actions/action_7
	hotkey_keys = list("Alt7")
	name = "action_7"
	full_name = "动作 7"
	description = "触发第七个动作。"
	category = CATEGORY_CARBON
	action_taken = 7

	
/datum/keybinding/carbon/actions/action_8
	hotkey_keys = list("Alt8")
	name = "action_8"
	full_name = "动作 8"
	description = "触发第八个动作。"
	category = CATEGORY_CARBON
	action_taken = 8

	
/datum/keybinding/carbon/actions/action_9
	hotkey_keys = list("Alt9")
	name = "action_9"
	full_name = "动作 9"
	description = "触发第九个动作。"
	category = CATEGORY_CARBON
	action_taken = 9
