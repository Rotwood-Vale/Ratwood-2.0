// Get the display names of the underlying TGUI themes
/datum/preferences/proc/get_tgui_theme_display_name()
	var/static/list/theme_names = list(
		"azure_default" = "Ascendant",
		"azure_green" = "Undivided",
		"azure_lane" = "Cerulean",
		// "azure_gold" = "Lirvas",
		"azure_purple" = "Zybantium",
		// "azure_gilbranze" = "Gilbranze", - Coming soon :tm:
		"trey_liam" = "Trey Liam"
	)
	return theme_names[tgui_theme] || tgui_theme

// Cycle through TGUI styles
/datum/preferences/proc/setTguiStyle(mob/user)
	var/static/list/styles = list("azure_default", "azure_green", "azure_lane", "azure_purple", "trey_liam")
	var/current_index = styles.Find(tgui_theme)
	if(!current_index)
		current_index = 1
	var/next_index = (current_index % styles.len) + 1
	tgui_theme = styles[next_index]
	to_chat(usr, "<span class='notice'>TGUI style set to [get_tgui_theme_display_name()].</span>")
	save_preferences()
	

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
