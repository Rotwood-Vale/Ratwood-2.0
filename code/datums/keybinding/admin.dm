/datum/keybinding/admin
	category = CATEGORY_ADMIN
	weight = WEIGHT_ADMIN

/datum/keybinding/admin/admin_say
	hotkey_keys = list("F3")
	name = "admin_say"
	full_name = "管理员频道"
	description = "与其他管理员交谈。"

/datum/keybinding/admin/admin_say/down(client/user)
	user.get_admin_say()
	return TRUE

/datum/keybinding/admin/rmbcontext
	hotkey_keys = list("F4")
	name = "rmbcontext"
	full_name = "管理员右键菜单切换"
	description = "切换是否用右键打开上下文菜单"

/datum/keybinding/admin/rmbcontext/down(client/user)
	user.set_context_menu_enabled()
	return TRUE

/datum/keybinding/admin/admin_ghost
	hotkey_keys = list("F5")
	name = "admin_ghost"
	full_name = "管理员幽灵化"
	description = "变成幽灵"

/datum/keybinding/admin/admin_ghost/down(client/user)
	user.admin_ghost()
	return TRUE

/datum/keybinding/admin/player_panel_new
	hotkey_keys = list("F6")
	name = "player_panel_new"
	full_name = "新版玩家面板"
	description = "打开新版玩家面板"

/datum/keybinding/admin/player_panel_new/down(client/user)
	if(!check_rights(R_ADMIN))
		to_chat(user, "<span class='warning'>你没有权限访问玩家面板。</span>")
		return
	user.holder.player_panel_new()
	return TRUE


/datum/keybinding/admin/toggle_buildmode_self
	hotkey_keys = list("F7")
	name = "toggle_buildmode_self"
	full_name = "管理员建造模式"
	description = "切换建造模式"

/datum/keybinding/admin/toggle_buildmode_self/down(client/user)
	user.togglebuildmodeself()
	return TRUE

/datum/keybinding/admin/stealthmode
	hotkey_keys = list("F8")
	name = "stealth_mode"
	full_name = "管理员潜行模式"
	description = "进入潜行模式（玩家会看到你是“Administrator”，而不是你的 ckey）"

/datum/keybinding/admin/stealthmode/down(client/user)
	user.stealth()
	return TRUE

/* Irrelevant to RT
/datum/keybinding/admin/deadsay
	hotkey_keys = list("F9")
	name = "dsay"
	full_name = "deadsay"
	description = "Allows you to send a message to dead chat"

/datum/keybinding/admin/deadsay/down(client/user)
	user.get_dead_say()
	return TRUE


/datum/keybinding/admin/invisimin
	hotkey_keys = list("F10")
	name = "invisimin"
	full_name = "Admin invisibility"
	description = "Toggles ghost-like invisibility on your mob"

/datum/keybinding/admin/invisimin/down(client/user)
	user.invisimin()
	return TRUE
*/
