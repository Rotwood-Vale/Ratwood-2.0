// categories
GLOBAL_LIST_INIT(pref_categories, list(
	"Identity" = /datum/preferences/proc/page_identity,
	"Origin" = /datum/preferences/proc/page_origin,
	"Customization" = /datum/preferences/proc/page_loadout,
	"Stats" = /datum/preferences/proc/page_stats,
	"Character Settings" = /datum/preferences/proc/page_character_settings,
	"Voice" = /datum/preferences/proc/page_voice,
	"Body" = /datum/preferences/proc/page_features,
	"Flavor Text" = /datum/preferences/proc/page_flavor_text,
))

// skips char preview update on these options 2 avoid topic lag
GLOBAL_LIST_INIT(no_preview_prefs, list("category", "background", "flavortext", "nsfwflavortext", "ooc_notes", "erpprefs", "headshot", "rumour", "gossip", "rumour_preview", "ooc_extra", "ooc_extra_img", "nsfw_ooc_extra_img", "change_title", "change_artist", "img_gallery", "nsfw_img_gallery", "clear_gallery", "clear_nsfw_gallery", "ooc_preview", "formathelp", "voicetype", "voicepack", "voice", "voice_pitch", "char_accent", "char_mannerism", "barksound", "barkspeed", "barkpitch", "barkvary", "barkpreview", "combat_music", "dnr", "preferred_map", "familiar_prefs", "gnoll_prefs", "nickname", "highlight_color", "pronouns", "culinary", "tgui_theme", "parchment_skin", "tgui_ui_prefs", "playerquality", "triumphs", "setspouse", "family", "gender_choice", "species_choice"))

GLOBAL_LIST_INIT(pref_columns, list(
	list("Identity", "Origin", "Customization", "Stats"),
	list("Character Settings", "Voice", "Body", "Flavor Text"),
))

GLOBAL_LIST_INIT(selectable_languages, list(
	/datum/language/elvish,
	/datum/language/dwarvish,
	/datum/language/orcish,
	/datum/language/hellspeak,
	/datum/language/draconic,
	/datum/language/celestial,
	/datum/language/canilunzt,
	/datum/language/grenzelhoftian,
	/datum/language/kazengunese,
	/datum/language/etruscan,
	/datum/language/gronnic,
	/datum/language/hammerholdian,
	/datum/language/otavan,
	/datum/language/aavnic,
	/datum/language/merar,
	/datum/language/thievescant/signlanguage,
	/datum/language/abyssal,
))

/datum/preferences
	var/list/open_categories = list()

/datum/preferences/proc/yes_no(value)
	if(value)
		return "Yes"
	return "No"

/datum/preferences/proc/pref_link(label, preference, task = "input")
	var/href = "?_src_=prefs;preference=[preference]"
	if(task)
		href += ";task=[task]"
	return "<a href='[href]'>[label]</a>"

/datum/preferences/proc/bg_link(label, bg, slot)
	return "<a href='?_src_=prefs;preference=background;bg=[bg];slot=[slot]'>[label]</a>"

/datum/preferences/proc/pref_item(label, value)
	return "<b>[label]:</b> [value]"

/datum/preferences/proc/pref_line(list/items)
	return "<div class='r'>[items.Join("<br>")]</div>"

/datum/preferences/proc/pref_box(header, body, details, key)
	var/footer = ""
	if(details)
		var/label = "Expand Details"
		if(key in open_categories)
			label = "Shrink Details"
			if(body)
				body += "<br>"
			body += details
		footer = "<div><a href='?_src_=prefs;preference=category;name=[url_encode(key)]'>\[[label]\]</a></div>"
	return "<div class='box'>[header]<div>[body]</div>[footer]</div>"

/datum/preferences/proc/pref_color_row(label, hex, preference)
	return pref_line(list(pref_item(label, "<span style='border: 1px solid #161616; background-color: #[hex];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> [pref_link("Change", preference)]")))

/datum/preferences/proc/pref_image(link)
	if(link == null)
		return ""
	return "<img src='[link]' width='100px' height='100px'><br>"

// da categories get built here
/datum/preferences/proc/get_character_page(mob/user)
	validate_background()
	var/html = {"<style>
		body { font-size: 14px; }
		table { table-layout: fixed; }
		td { word-wrap: break-word; }
		.r { line-height: 1.5; font-size: 14px; margin: 2px 0; }
		.lab { font-weight: bold; color: #c9a96e; margin: 4px 0 1px 2px; }
		.cbox { border: 1px solid #7b5353; background: #00000033; padding: 3px 6px; margin: 0 0 6px 0; }
		.box { border: 1px solid #7b5353; background: #1a0707; padding: 3px 6px; margin: 3px 0; }
		.cbox a, .box a { background: none; border-color: transparent; padding: 0; margin: 0 8px 0 0; }
		</style>[get_top_html(user)]<table width='100%'><tr>"}
	for(var/list/column in GLOB.pref_columns)
		if(column == GLOB.pref_columns[1])
			html += "<td width='35%' valign='top'>"
		else
			html += "<td width='40%' valign='top'>"
		for(var/category in column)
			var/page = call(src, GLOB.pref_categories[category])(user)
			if(category == "Stats")
				html += "[page]<br>"
			else
				html += "<div class='lab'>[category]</div><div class='cbox'>[page]</div>"
		html += "</td>"
		if(column == GLOB.pref_columns[1])
			html += "<td width='25%'></td>"
	return "[html]</tr></table>"

/datum/preferences/proc/get_top_html(mob/user)
	var/triumphs = "None"
	if(user.get_triumphs())
		triumphs = "\Roman [user.get_triumphs()]"
	var/html = "<center>"
	html += "[pref_link("Change Character", "changeslot", "")] | [pref_link("Class Selection", "job", "menu")] | [pref_link("Villain Selection", "antag", "menu")] | [pref_link("Keybinds", "keybinds", "menu")]<br>"
	html += "[pref_link("PQ:", "playerquality", "menu")] [get_playerquality(user.ckey, text = TRUE)] | [pref_link("TRIUMPHS:", "triumphs", "menu")] [triumphs]"
	if(SStriumphs.triumph_buys_enabled)
		html += " [pref_link("Triumph Buy", "triumph_buy_menu", null)]"
	html += "<br>[pref_link(get_ui_style_name(), "tgui_ui_prefs", "menu")] | [pref_link("Theme: [get_tgui_theme_display_name()]", "tgui_theme", "")] | [pref_link("Parchment: [get_parchment_skin_display_name()]", "parchment_skin", "")]<br>"
	html += get_preview_html()
	html += "</center><hr>"
	return html

/datum/preferences/proc/get_ui_style_name()
	if(tgui_pref)
		return "TGUI"
	return "Legacy"

/datum/preferences/proc/get_preview_html()
	var/html = ""
	var/datum/job/highest_pref
	for(var/job in job_preferences)
		if(job_preferences[job] > highest_pref)
			highest_pref = SSjob.GetJob(job)
	if(!isnull(highest_pref) && !istype(highest_pref, /datum/job/roguetown/jester))
		var/subclass_name = "None"
		if(preview_subclass)
			subclass_name = preview_subclass.name
		html += "Subclass Preview: [pref_link(subclass_name, "subclassoutfit")] | "
	else
		preview_subclass = null
	var/arousal_label = "None"
	if(preview_erect_state == ERECT_STATE_PARTIAL)
		arousal_label = "Partial"
	if(preview_erect_state == ERECT_STATE_HARD)
		arousal_label = "Hard"
	html += "Arousal Preview: [pref_link(arousal_label, "preview_erect_state", "")]"
	return html

/datum/preferences/proc/second_virtue_allowed()
	return statpack.name == "Virtuous"

// annoying shit that makes sure u ain't cheating, runs on like every refresh (IDK might change it to be more selective)
/datum/preferences/proc/validate_background()
	if(length(pref_species.restricted_virtues))
		if(virtue.type in pref_species.restricted_virtues)
			virtue = GLOB.virtues[/datum/virtue/none]
		if(virtuetwo.type in pref_species.restricted_virtues)
			virtuetwo = GLOB.virtues[/datum/virtue/none]
	if(length(pref_species.restricted_quirks))
		for(var/datum/quirk/Q in quirks.Copy())
			if(Q.type in pref_species.restricted_quirks)
				quirks -= Q
	if(!second_virtue_allowed() || virtuetwo.type == virtue.type)
		virtuetwo = GLOB.virtues[/datum/virtue/none]
	var/list/seen_quirks = list()
	for(var/datum/quirk/Q in quirks.Copy())
		if((Q.type in seen_quirks) || istype(Q, /datum/quirk/none))
			quirks -= Q
		seen_quirks += Q.type

/datum/preferences/proc/page_identity(mob/user)
	var/html = ""
	if(is_banned_from(user.ckey, "Appearance"))
		html += "<b>Thou are banned from using custom names and appearances. Thou can continue to adjust thy characters, but thee will be randomised once thee joins the game.</b><br>"
	var/name_link = "[pref_link(real_name, "name")] [pref_link("\[R\]", "name", "random")]"
	if(check_nameban(user.ckey))
		name_link = pref_link("NAMEBANNED", "name")
	html += pref_line(list(pref_item("Name", name_link)))
	html += pref_line(list(pref_item("Nickname", pref_link(nickname || real_name, "nickname"))))
	html += pref_line(list(pref_item("Nickname Color", pref_link("Change", "highlight_color"))))
	html += pref_line(list(pref_item("Pronouns", pref_link(pronouns, "pronouns")), pref_item("Age", pref_link(age, "age"))))
	var/race_flag = ""
	if(!spec_check(user))
		race_flag = " (!)"
	var/list/race_items = list(pref_item("Race", "[pref_link(pref_species.name, "species")][race_flag]"))
	if(pref_species.use_titles)
		race_items += pref_item("Race Title", pref_link(selected_title || "None", "race_title"))
	if(length(pref_species.custom_selection))
		var/race_bonus_display = "None"
		for(var/bonus in pref_species.custom_selection)
			if(race_bonus && pref_species.custom_selection[bonus] == race_bonus)
				race_bonus_display = bonus
				break
		race_items += pref_item("Race Bonus", pref_link(race_bonus_display, "race_bonus_select"))
	else
		race_bonus = null
	html += pref_line(race_items)
	var/hand = "Right-handed"
	if(domhand == 1)
		hand = "Left-handed"
	if(!(AGENDER in pref_species.species_traits))
		var/body_type = "Other"
		if(gender == MALE)
			body_type = "Masculine"
		if(gender == FEMALE)
			body_type = "Feminine"
		html += pref_line(list(pref_item("Body Type", pref_link(body_type, "gender", ""))))
	html += pref_line(list(pref_item("Dominance", pref_link(hand, "domhand", ""))))
	if(!(AGENDER in pref_species.species_traits))
		if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG])
			html += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER]'>Always Random Bodytype: [yes_no(randomise[RANDOM_GENDER])]</a> "
			html += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER_ANTAG]'>When Antagonist: [yes_no(randomise[RANDOM_GENDER_ANTAG])]</a><br>"
	return html

/datum/preferences/proc/page_origin(mob/user)
	var/html = ""
	var/origin_name = "None"
	if(origin)
		origin_name = origin.name
	html += pref_line(list(pref_item("Origin", pref_link(origin_name, "origin")), pref_item("Family", pref_link(family || "None", "family", ""))))
	if(family != FAMILY_NONE)
		var/spousename = "Preferred Spouse"
		if(family == FAMILY_PARTIAL)
			spousename = "Preferred Parent"
		var/species_text = "<font color='#1cb308'>Unrestricted</font>"
		if(xenophobe_pref == 1)
			species_text = "<font color='#FFA500'>Same Race</font>"
		if(xenophobe_pref == 2 && restricted_species_pref)
			species_text = "<font color='#aa0202'>[restricted_species_pref] Only</font>"
		html += pref_line(list(pref_item(spousename, pref_link(setspouse || "None", "setspouse", "")), pref_item("Preferred Gender", pref_link(gender_choice || "Any Gender", "gender_choice", "")), pref_item("Restrict Species", pref_link(species_text, "species_choice", ""))))
	var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
	html += pref_line(list(pref_item("Faith", pref_link(selected_faith?.name || "INVALID", "faith")), pref_item("Patron", pref_link(selected_patron?.name || "INVALID", "patron"))))
	var/language_text = "Locked by origin"
	if(!origin?.origin_language)
		language_text = get_language_link(extra_language, "lang_free")
	html += pref_line(list(pref_item("Language", language_text), pref_item("Food Preferences", pref_link("Change", "culinary", "menu"))))
	return html

/datum/preferences/proc/page_loadout(mob/user)
	var/html = pref_line(list(pref_item("Loadout Menu", pref_link("Change", "loadout", "menu"))))
	html += pref_line(list(pref_item("Presets", pref_link("Change", "loadout", "presets"))))
	return html

/datum/preferences/proc/page_stats(mob/user)
	var/html = ""
	html += pref_box(pref_item("Statpack", bg_link(statpack.name, "statpack")), statpack.generate_modifier_string())
	html += get_virtue_html("Primary Virtue", virtue, 1)
	if(second_virtue_allowed())
		html += get_virtue_html("Second Virtue", virtuetwo, 2)
	html += "<div class='lab'>Quirks</div>"
	var/triumph_gain = get_quirk_points_remaining()
	var/gain_color = "#e3c06f"
	var/gain_text = "[triumph_gain]"
	if(triumph_gain > 0)
		gain_color = "#91cf68"
		gain_text = "+[triumph_gain]"
	if(triumph_gain < 0)
		triumph_gain = -get_triumph_collateral()
		gain_color = "#cf2a2a"
		gain_text = "[triumph_gain]"
	html += "<div class='r'><font color='#c9a96e'><b>Triumph Gain: <font color='[gain_color]'>[gain_text]</font></b></font></div>"
	for(var/i in 1 to length(quirks))
		var/datum/quirk/current_quirk = quirks[i]
		var/quirk_header = "<b>[current_quirk.name]</b> ([current_quirk.point_cost]) [bg_link("\[Remove\]", "quirk_remove", i)]"
		if(current_quirk.configurable)
			quirk_header += " [bg_link("\[Configure\]", "quirk_config", i)]<br>[current_quirk.config_summary()]"
		var/quirk_details = get_trait_details_html(current_quirk)
		if(current_quirk.warning_text)
			if(quirk_details)
				quirk_details += "<br>"
			quirk_details += "<font color='#f44336'>[current_quirk.warning_text]</font>"
		html += pref_box(quirk_header, current_quirk.desc, quirk_details, current_quirk.name)
	html += pref_line(list(bg_link("Add Quirk", "quirk_add")))
	html += "<div class='lab'>Vices</div>"
	var/vice_count = 0
	for(var/i in 1 to VICE_SLOTS)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice)
			vice_count++
			html += pref_box("<b>[vice.name]</b> (+[vice.point_value]) [bg_link("\[Remove\]", "vice_remove", i)]", vice.desc)
	if(vice_count < VICE_SLOTS)
		html += pref_line(list(bg_link("Add Vice", "vice_add")))
	return html

/datum/preferences/proc/get_virtue_html(label, datum/virtue/V, slot)
	var/html = "<b>[label]:</b> [bg_link(V.name, "virtue", slot)]"
	if(!istype(V, /datum/virtue/none))
		html += " [bg_link("\[Clear\]", "virtue_clear", slot)]"
	return pref_box(html, V.desc, get_trait_details_html(V), "[label]")

/datum/preferences/proc/get_trait_details_html(datum/customization_trait/T)
	var/list/lines = list()
	if(T.custom_text)
		lines += "<i>[T.custom_text]</i>"
	if(LAZYLEN(T.added_traits))
		lines += "<b>Traits granted:</b> [T.added_traits.Join(", ")]"
	var/list/skill_lines = list()
	for(var/skill in T.added_skills)
		if(islist(skill))
			var/list/skill_block = skill
			var/datum/skill/S = skill_block[1]
			skill_lines += "[initial(S.name)] +[skill_block[2]] (max [skill_block[3]])"
		else
			var/datum/skill/S = skill
			skill_lines += "[initial(S.name)] +[T.added_skills[skill]]"
	if(length(skill_lines))
		lines += "<b>Skills granted:</b> [skill_lines.Join(", ")]"
	if(LAZYLEN(T.added_stashed_items))
		lines += "<b>Stashed items:</b> [T.added_stashed_items.Join(", ")]"
	return lines.Join("<br>")

/datum/preferences/proc/get_language_link(language_path, bg)
	if(!ispath(language_path, /datum/language))
		return bg_link("Select", bg)
	var/datum/language/L = language_path
	return bg_link(initial(L.name), bg)

/datum/preferences/proc/get_language_choices()
	var/list/choices = list("None")
	for(var/language in GLOB.selectable_languages)
		if(language in pref_species.languages)
			continue
		var/datum/language/a_language = language
		choices[initial(a_language.name)] = language
	return choices

/datum/preferences/proc/page_character_settings(mob/user)
	var/html = pref_line(list(pref_item("Unrevivable", pref_link(yes_no(dnr_pref), "dnr"))))
	html += pref_line(list(pref_item("Combat Music", pref_link(combat_music.shortname || combat_music.name || "INVALID", "combat_music"))))
	html += pref_line(list(pref_item("Map Preferences", pref_link(preferred_map || "No Preference", "preferred_map"))))
	html += pref_line(list(pref_item("Familiar Preferences", pref_link("Change", "familiar_prefs")), pref_item("Gnoll Preferences", pref_link("Change", "gnoll_prefs"))))
	return html

/datum/preferences/proc/page_voice(mob/user)
	if(!voice_pack)
		voice_pack = "Default"
	var/datum/bark/B = GLOB.bark_list[bark_id]
	var/bark_name = "INVALID"
	if(B)
		bark_name = initial(B.name)
	var/html = pref_line(list(pref_item("Voice", pref_link(voice_type, "voicetype")), pref_item("Voice Pack", pref_link(voice_pack, "voicepack"))))
	html += pref_line(list(pref_item("Voice Color", pref_link("Change", "voice")), pref_item("Voice Pitch", pref_link(voice_pitch, "voice_pitch"))))
	html += pref_line(list(pref_item("Accent", pref_link(char_accent, "char_accent"))))
	html += pref_line(list(pref_item("Speech Mannerism", pref_link(char_mannerism, "char_mannerism"))))
	html += pref_line(list(pref_item("Vocal Bark", pref_link(bark_name, "barksound")), pref_link("<b>Preview Bark</b>", "barkpreview")))
	html += pref_line(list(pref_item("Vocal Bark Speed", pref_link(bark_speed, "barkspeed")), pref_item("Vocal Bark Pitch", pref_link(bark_pitch, "barkpitch")), pref_item("Vocal Bark Variance", pref_link(bark_variance, "barkvary"))))
	return html

/datum/preferences/proc/page_features(mob/user)
	var/html = ""
	var/list/appearance_items = list()
	if(pref_species.use_skintones)
		appearance_items += pref_item(pref_species.skin_tone_wording, pref_link("Change", "s_tone"))
		if(pref_species.mutant_skin_option)
			appearance_items += pref_item("Mutant Skintone", pref_link(yes_no(mutant_skin), "mutant_skin"))
	appearance_items += pref_item("Sprite Scale", pref_link("[features["body_size"] * 100]%", "body_size"))
	html += pref_line(appearance_items)
	if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
		html += pref_color_row("Mutant Color #1", features["mcolor"], "mutant_color")
		html += pref_color_row("Mutant Color #2", features["mcolor2"], "mutant_color2")
		html += pref_color_row("Mutant Color #3", features["mcolor3"], "mutant_color3")
	if(LAZYLEN(pref_species.allowed_taur_types))
		var/obj/item/bodypart/taur/T = taur_type
		var/taur_name = "None"
		if(ispath(T))
			taur_name = T::name
		html += pref_line(list(pref_item("Taur Body Type", pref_link(taur_name, "taur_type"))))
		html += pref_color_row("Taur Color", taur_color, "taur_color")
		html += pref_color_row("Taur Markings", taur_markings, "taur_markings")
		html += pref_color_row("Taur Tertiary", taur_tertiary, "taur_tertiary")
	html += pref_line(list(pref_item("Features", pref_link("Change", "customizers", "menu")), pref_item("Markings", pref_link("Change", "markings", "menu"))))
	html += pref_line(list(pref_item("Descriptors", pref_link("Change", "descriptors", "menu"))))
	html += pref_line(list(pref_item("Update feature colors with change", pref_link(yes_no(update_mutant_colors), "update_mutant_colors"))))
	return html

/datum/preferences/proc/page_flavor_text(mob/user)
	var/flavor_label = "Flavortext"
	if(length(flavortext) < MINIMUM_FLAVOR_TEXT)
		flavor_label = "<font color='#802929'>Flavortext</font>"
	var/ooc_label = "OOC Notes"
	if(length(ooc_notes) < MINIMUM_OOC_NOTES)
		ooc_label = "<font color='#802929'>OOC Notes</font>"
	var/help = pref_link("(?)", "formathelp")
	var/html = pref_line(list(pref_item(flavor_label, "[help] [pref_link("Change", "flavortext")]")))
	html += pref_line(list(pref_item("NSFW Flavortext", "[help] [pref_link("Change", "nsfwflavortext")]")))
	html += pref_line(list(pref_item(ooc_label, "[help] [pref_link("Change", "ooc_notes")]")))
	html += pref_line(list(pref_item("ERP Preferences", "[help] [pref_link("Change", "erpprefs")]")))
	html += pref_line(list(pref_item("Headshot", pref_link("Change", "headshot"))))
	html += pref_image(headshot_link)
	html += pref_line(list(pref_item("Rumours & Noble Gossip", help), "[pref_link("Set Rumours", "rumour")] [pref_link("Set Gossip", "gossip")] [pref_link("<i>Preview</i>", "rumour_preview")]"))
	html += pref_line(list(pref_item("Song", ""), "[pref_link("Change URL", "ooc_extra")] [pref_link("Title", "change_title")] [pref_link("Artist", "change_artist")]"))
	html += pref_line(list(pref_item("OOC Extra", pref_link("Change", "ooc_extra_img"))))
	html += pref_image(ooc_extra_img_link)
	html += pref_line(list(pref_item("NSFW OOC Extra", pref_link("Change", "nsfw_ooc_extra_img"))))
	html += pref_image(nsfw_ooc_extra_img_link)
	html += pref_line(list(pref_item("Image Gallery", ""), "[pref_link("Add", "img_gallery")] [pref_link("Clear Gallery", "clear_gallery")]"))
	html += pref_line(list(pref_item("Nsfw Image Gallery", ""), "[pref_link("Add", "nsfw_img_gallery")] [pref_link("Clear Nsfw Gallery", "clear_nsfw_gallery")]"))
	html += pref_line(list(pref_link("<b>Preview Examine</b>", "ooc_preview")))
	return html

// this controls all the mechanical customization shit. Nasty nasty code!
// handles background options w bg_link
/datum/preferences/proc/process_background_link(mob/user, list/href_list)
	var/slot = text2num(href_list["slot"])
	switch(href_list["bg"])
		if("statpack")
			var/list/statpacks_available = list()
			for(var/path as anything in GLOB.statpacks)
				var/datum/statpack/SP = GLOB.statpacks[path]
				if(!SP.name)
					continue
				var/display_name = SP.name
				var/stats = SP.generate_modifier_string()
				if(stats)
					display_name = "[SP.name] [stats]"
				statpacks_available[display_name] = SP
			statpacks_available = sort_list(statpacks_available)
			var/choice = tgui_input_list(user, "Choose your statpack:", "Statpack Selection", statpacks_available)
			if(choice)
				var/datum/statpack/selected = statpacks_available[choice]
				statpack = selected
				to_chat(user, span_notice("Selected [choice] statpack."))
				to_chat(user, "<span class='info'>[selected.description_string()]</span>")
		if("virtue")
			if(slot == 2 && !second_virtue_allowed())
				to_chat(user, span_warning("Second virtue is not available!"))
				return
			var/datum/virtue/other = virtuetwo
			if(slot == 2)
				other = virtue
			var/list/available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(!V.name)
					continue
				if(V.type in pref_species.restricted_virtues)
					continue
				if(other && V.type == other.type)
					continue
				if(check_pick_vice_conflict(V.type, TRUE, user))
					continue
				if(other && check_pick_virtue_conflict(V.type, other.type, TRUE, user))
					continue
				if(check_virtue_quirk_conflict(V.type, TRUE, user))
					continue
				available[V.name] = V
			available = sort_list(available)
			var/choice = tgui_input_list(user, "Choose your virtue:", "Virtue Selection", available)
			if(choice)
				var/datum/virtue/selected = available[choice]
				if(slot == 2)
					virtuetwo = selected
				else
					virtue = selected
				to_chat(user, span_notice("Selected [selected.name] as virtue."))
				to_chat(user, "<span class='info'>[selected.desc]</span>")
		if("virtue_clear")
			if(slot == 2)
				virtuetwo = GLOB.virtues[/datum/virtue/none]
			else
				virtue = GLOB.virtues[/datum/virtue/none]
		if("quirk_add")
			var/list/available = list()
			for(var/path as anything in GLOB.quirks)
				var/datum/quirk/Q = GLOB.quirks[path]
				if(!Q.name || istype(Q, /datum/quirk/none) || has_quirk(Q.type))
					continue
				if(Q.type in pref_species.restricted_quirks)
					continue
				if(check_quirk_virtue_conflict(Q.type, TRUE, user) || check_pick_vice_conflict(Q.type, TRUE, user) || check_pick_quirk_conflict(Q.type, TRUE, user))
					continue
				available["[Q.name] ([Q.point_cost] point\s)"] = Q
			if(!length(available))
				to_chat(user, span_warning("No quirks available to add - you already have everything that doesn't conflict with your virtues or vices."))
				return
			available = sort_list(available)
			var/prompt_text = "Choose a quirk to add ([get_quirk_points_remaining()] point\s left)"
			var/triumph_collateral = get_triumph_collateral()
			if(triumph_collateral)
				prompt_text += "\n(Costs [triumph_collateral] TRIUMPHS)"
			var/choice = tgui_input_list(user, prompt_text, "Quirk Selection", available)
			if(choice)
				var/datum/quirk/selected = available[choice]
				if(has_quirk(selected.type))
					return
				quirks += new selected.type()
				to_chat(user, span_notice("Added [selected.name] as a quirk."))
		if("quirk_remove")
			if(slot && slot <= length(quirks))
				quirks.Cut(slot, slot + 1)
		// quirks run their own procs 4 this, it's Less hardcoded for quirk options
		if("quirk_config")
			if(slot && slot <= length(quirks))
				var/datum/quirk/Q = quirks[slot]
				if(Q.configurable)
					Q.configure(user)
		if("vice_add")
			var/list/current_types = list()
			for(var/i in 1 to VICE_SLOTS)
				var/datum/charflaw/existing_vice = vars["vice[i]"]
				if(existing_vice)
					current_types += existing_vice.type
			if((/datum/charflaw/noflaw in current_types) || (/datum/charflaw/randflaw in current_types))
				current_types = list()
			var/list/all_vices = GLOB.character_flaws.Copy()
			all_vices["No Flaw (-3 TRI)"] = /datum/charflaw/noflaw
			var/list/available = list()
			for(var/vice_name in all_vices)
				var/vice_type = all_vices[vice_name]
				if((vice_type in current_types) || check_vice_pick_conflict(vice_type) || check_vice_vice_conflict(vice_type, current_types))
					continue
				if(length(current_types) && (vice_type == /datum/charflaw/noflaw || vice_type == /datum/charflaw/randflaw))
					continue
				available[vice_name] = vice_type
			if(length(current_types) >= VICE_SLOTS || !length(available))
				to_chat(user, span_warning("No vices available to add."))
				return
			available = sort_list(available)
			var/choice = tgui_input_list(user, "Choose a vice to add.", "Vice Selection", available)
			if(choice)
				var/new_vice_type = available[choice]
				if(!length(current_types))
					for(var/i in 1 to VICE_SLOTS)
						vars["vice[i]"] = null
				for(var/i in 1 to VICE_SLOTS)
					if(!vars["vice[i]"])
						vars["vice[i]"] = new new_vice_type()
						break
				charflaw = null
				to_chat(user, span_notice("Added [choice] as a vice."))
		if("vice_remove")
			if(slot && slot <= VICE_SLOTS)
				for(var/i in slot to VICE_SLOTS - 1)
					vars["vice[i]"] = vars["vice[i + 1]"]
				vars["vice[VICE_SLOTS]"] = null
				if(!vice1)
					vice1 = new /datum/charflaw/noflaw()
				charflaw = null
		if("lang_free")
			var/list/choices = get_language_choices()
			var/chosen_language = tgui_input_list(user, "Choose your character's extra language:", "EXTRA LANGUAGE", choices)
			if(chosen_language)
				extra_language = choices[chosen_language] || "None"

// this shit sucks !
/datum/preferences/proc/get_customization_pick(typepath)
	if(!typepath)
		return null
	return GLOB.virtues[typepath] || GLOB.quirks[typepath]

/datum/preferences/proc/get_virtue_effective_types(virtue_typepath)
	var/list/types = list()
	if(!virtue_typepath)
		return types
	types += virtue_typepath
	if(ispath(virtue_typepath, /datum/virtue/pack))
		var/datum/virtue/pack/P = GLOB.virtues[virtue_typepath]
		if(P)
			types += P.granted_virtues
	return types

/datum/preferences/proc/check_pick_virtue_conflict(pick_type, existing_type, show_message = FALSE, mob/user = null)
	if(!pick_type || !existing_type)
		return FALSE
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	var/datum/customization_trait/existing = get_customization_pick(existing_type)
	if(!pick || !existing)
		return FALSE
	var/list/pick_effective = get_virtue_effective_types(pick_type)
	var/list/existing_effective = get_virtue_effective_types(existing_type)
	if(length(pick.incompatible_virtues))
		for(var/t in existing_effective)
			if(t in pick.incompatible_virtues)
				if(show_message && user)
					to_chat(user, span_warning("[pick.name] conflicts with [existing.name]!"))
				return TRUE
	if(length(existing.incompatible_virtues))
		for(var/t in pick_effective)
			if(t in existing.incompatible_virtues)
				if(show_message && user)
					to_chat(user, span_warning("[pick.name] conflicts with [existing.name]!"))
				return TRUE
	return FALSE

/datum/preferences/proc/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick || !length(pick.incompatible_vices))
		return FALSE
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice && (vice.type in pick.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [vice.name] vice!"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_pick_quirk_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick)
		return FALSE
	for(var/datum/quirk/Q in quirks)
		if(!Q || Q.type == pick_type)
			continue
		if(length(pick.incompatible_quirks) && (Q.type in pick.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [Q.name]!"))
			return TRUE
		if(length(Q.incompatible_quirks) && (pick_type in Q.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [Q.name]!"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_vice_pick_conflict(vice_type, show_message = FALSE, mob/user = null)
	if(!vice_type)
		return FALSE
	var/list/held = list()
	if(virtue)
		held += virtue
	if(virtuetwo)
		held += virtuetwo
	held += quirks
	for(var/datum/customization_trait/pick in held)
		if(length(pick.incompatible_vices) && (vice_type in pick.incompatible_vices))
			if(show_message && user)
				var/datum/charflaw/vice = GLOB.charflaw_singletons[vice_type]
				to_chat(user, span_warning("[vice?.name || "This vice"] conflicts with [pick.name]!"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_quirk_virtue_conflict(quirk_type, show_message = FALSE, mob/user = null)
	for(var/datum/virtue/virt in list(virtue, virtuetwo))
		if(virt && check_pick_virtue_conflict(quirk_type, virt.type, show_message, user))
			return TRUE
	return FALSE

/datum/preferences/proc/check_virtue_quirk_conflict(virtue_type, show_message = FALSE, mob/user = null)
	for(var/datum/quirk/Q in quirks)
		if(Q && check_pick_virtue_conflict(virtue_type, Q.type, show_message, user))
			return TRUE
	return FALSE

/datum/preferences/proc/check_vice_vice_conflict(vice_type, list/selected_vices, show_message = FALSE, mob/user = null)
	var/datum/charflaw/vice = GLOB.charflaw_singletons[vice_type]
	for(var/other in selected_vices)
		if(vice && (other in vice.incompatible_vices))
			if(show_message && user)
				var/datum/charflaw/other_vice = GLOB.charflaw_singletons[other]
				to_chat(user, span_warning("[vice.name] vice conflicts with [other_vice?.name] vice!"))
			return TRUE
	return FALSE
