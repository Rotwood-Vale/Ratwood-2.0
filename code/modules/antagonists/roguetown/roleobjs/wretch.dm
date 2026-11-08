// [DISABLED: zombie project] Everything below is commented out on purpose. Do not delete. See RULES_AND_LESSONS.md
// /datum/antagonist/wretch
// 	name = "Wretch"
// 	roundend_category = "wretches"
// 	antagpanel_category = "Wretches"
// 	show_name_in_check_antagonists = FALSE
// 
// /datum/antagonist/wretch/get_antag_cap_weight()
// 	return 0.5
// 
// /datum/antagonist/wretch/on_gain()
// 	. = ..()
// 	if(owner)
// 		owner.special_role = "Wretch"
// 
// /datum/antagonist/wretch/on_removal()
// 	. = ..()
// 	if(owner)
// 		owner.special_role = null
