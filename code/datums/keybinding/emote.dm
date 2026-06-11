/datum/keybinding/emote
	category = CATEGORY_EMOTE
	weight = WEIGHT_EMOTE
	var/emote_key

/datum/keybinding/emote/proc/link_to_emote(datum/emote/faketype)
	hotkey_keys = list("未绑定")
	emote_key = initial(faketype.key)
	name = initial(faketype.key)
	full_name = capitalize(initial(faketype.key))
	description = "执行表情 `*[emote_key]`"

/datum/keybinding/emote/down(client/user)
	. = ..()
	user.mob.emote(emote_key)
