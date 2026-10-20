// Get the display names of the underlying TGUI themes
/proc/get_tgui_theme_display_name()
	var/static/list/theme_names = list(
		"azure_default" = "Ascendant",
		"azure_ascendant" = "New Ascendant",
		"azure_green" = "Oaken",
		"azure_lane" = "Cerulean",
		"azure_purple" = "Zybantium",
		"azure_gilbranze" = "Gilbranze",
		"azure_psydonic" = "Psydonic",
		"azure_lingyue" = "Cinnabar",
		"trey_liam" = "Trey Liam"
	)
	return theme_names

// Open TGUI theme picker
/datum/preferences/proc/setTguiStyle(mob/user)
	var/datum/theme_picker/picker = new(user)
	picker.ui_interact(user)
	
// Parchment skin variants (AP parity): themed-parchment interfaces resolve through the
// player's parchment_skin pref in tgui Layout - plain parchment, leatherbound, or vellum.
/proc/get_parchment_skins()
	var/static/list/skins = list(
		"vellum" = "Vellum",
		"parchment" = "Parchment",
		"leatherbound" = "Leatherbound",
	)
	return skins

/proc/sanitize_parchment_skin(value)
	var/list/skins = get_parchment_skins()
	if(value in skins)
		return value
	return "leatherbound"

/datum/preferences/proc/get_parchment_skin_display_name()
	var/list/skins = get_parchment_skins()
	return skins[parchment_skin] || skins["leatherbound"]

/datum/preferences/proc/cycle_parchment_skin()
	var/list/skins = get_parchment_skins()
	var/list/keys = list()
	for(var/k in skins)
		keys += k
	var/idx = keys.Find(parchment_skin)
	if(!idx)
		idx = 1
	parchment_skin = keys[(idx % keys.len) + 1]
