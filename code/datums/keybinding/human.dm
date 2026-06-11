/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	return TRUE

// Left commented because quick equip can put items into slots that are not in the UI, blame Roguetown.
/* /datum/keybinding/human/quick_equip
	hotkey_keys = list() // Keeping it empty lets the user set their own keybind since E is used
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/datum/keybinding/human/quick_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE */

/datum/keybinding/human/quick_equipbelt
	hotkey_keys = list("ShiftB")
	name = "quick_equipbelt"
	full_name = "快捷腰带收纳"
	description = "将手持物放入腰带，或从腰带中取出最近放入的物品"

/datum/keybinding/human/quick_equipbelt/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbelt()
	return TRUE

/datum/keybinding/human/bag_equip_backl
	hotkey_keys = list("ShiftQ")
	name = "bag_equip_backl"
	full_name = "左侧背包快捷收纳"
	description = "将手持物放入左侧背包槽位，或从左侧背包槽位取出最近放入的物品"

/datum/keybinding/human/bag_equip_backl/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BACK_R) // These fucking shits are reversed in the UI, so keep it like this for symmetry
	return TRUE

/datum/keybinding/human/bag_equip_backr
	hotkey_keys = list("ShiftE")
	name = "bag_equip_backr"
	full_name = "右侧背包快捷收纳"
	description = "将手持物放入右侧背包槽位，或从右侧背包槽位取出最近放入的物品"

/datum/keybinding/human/bag_equip_backr/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BACK_L) // These fucking shits are reversed in the UI, so keep it like this for symmetry
	return TRUE

/datum/keybinding/human/bag_equip_beltl
	hotkey_keys = list("AltQ")
	name = "bag_equip_beltl"
	full_name = "左侧腰带槽快捷收纳"
	description = "将手持物放入左侧腰带槽位，或从左侧腰带槽位取出最近放入的物品"

/datum/keybinding/human/bag_equip_beltl/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BELT_R)
	return TRUE

/datum/keybinding/human/bag_equip_beltr
	hotkey_keys = list("AltE")
	name = "bag_equip_beltr"
	full_name = "右侧腰带槽快捷收纳"
	description = "将手持物放入右侧腰带槽位，或从右侧腰带槽位取出最近放入的物品"

/datum/keybinding/human/bag_equip_beltr/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BELT_L)
	return TRUE

/datum/keybinding/human/fixeye
	hotkey_keys = list("F")
	name = "fix_eye"
	full_name = "固定视角"
	description = "将视线固定在一个方向。"

/datum/keybinding/human/fixeye/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.toggle_eye_intent(H)
	return TRUE

/datum/keybinding/human/set_temp_ft
	hotkey_keys = list("Unbound")
	name = "set_pose"
	full_name = "设置临时风味文本"
	description = "修改临时风味文本。"

/datum/keybinding/human/set_temp_ft/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.temp_flavor()
	return TRUE
