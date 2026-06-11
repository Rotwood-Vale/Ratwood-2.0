/datum/keybinding/client
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST


/datum/keybinding/client/admin_help
	hotkey_keys = list("F1")
	name = "admin_help"
	full_name = "管理员求助"
	description = "向管理员请求帮助。"

/datum/keybinding/client/admin_help/down(client/user)
	user.get_adminhelp()
	return TRUE

/*
/datum/keybinding/client/screenshot
	hotkey_keys = list("F2")
	name = "screenshot"
	full_name = "Screenshot"
	description = "Take a screenshot."

/datum/keybinding/client/screenshot/down(client/user)
	winset(user, null, "command=.screenshot [!user.keys_held["shift"] ? "auto" : ""]")
	return TRUE

/datum/keybinding/client/minimal_hud
	hotkey_keys = list("F12")
	name = "minimal_hud"
	full_name = "Minimal HUD"
	description = "Hide most HUD features"

/datum/keybinding/client/minimal_hud/down(client/user)
	user.mob.button_pressed_F12()
	return TRUE */
