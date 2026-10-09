GLOBAL_LIST_INIT(pref_categories, list(
	"Identity" = /datum/preferences/proc/page_identity,
	"Background" = /datum/preferences/proc/page_background,
	"Character Settings" = /datum/preferences/proc/page_character_settings,
	"Voice" = /datum/preferences/proc/page_voice,
	"Features" = /datum/preferences/proc/page_features,
	"Flavor Text" = /datum/preferences/proc/page_flavor_text,
))

GLOBAL_LIST_INIT(pref_columns, list(
	list("Identity", "Background"),
	list("Character Settings", "Voice", "Features", "Flavor Text"),
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

GLOBAL_LIST_INIT(vice_conflict_groups, list(
	list(/datum/charflaw/badsight, /datum/charflaw/noeyer, /datum/charflaw/noeyel, /datum/charflaw/noeyeall, /datum/charflaw/colorblind),
	list(/datum/charflaw/narcoleptic, /datum/charflaw/sleepless),
	list(/datum/charflaw/mute, /datum/charflaw/unintelligible),
))

/datum/preferences
	var/list/open_categories = list("Identity", "Background", "Features", "Flavor Text")

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
	return "<div class='r'>[items.Join(" | ")]</div>"

/datum/preferences/proc/pref_sub(label)
	return "<div class='sub'>[label]</div>"

/datum/preferences/proc/pref_color_row(label, hex, preference)
	return pref_line(list(pref_item(label, "<span style='border: 1px solid #161616; background-color: #[hex];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> [pref_link("Change", preference)]")))

/datum/preferences/proc/pref_image(link)
	if(link == null)
		return ""
	return "<img src='[link]' width='100px' height='100px'><br>"

/datum/preferences/proc/get_character_page(mob/user)
	validate_background()
	var/html = {"<style>
		body { font-size: 15px; }
		table { table-layout: fixed; }
		td { word-wrap: break-word; }
		.r { line-height: 1.35; font-size: 15px; }
		a.cat { display: inline-block; text-decoration: none; background: #2a0a0a; border-bottom: 1px solid #7b5353; margin: 6px 0 3px 0; padding: 2px 14px; font-size: 18px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; }
		.sub { border-bottom: 1px dotted #7b5353; margin: 5px 0 1px 0; font-size: 15px; font-weight: bold; color: #c9a96e; }
		</style>[get_top_html(user)]<table width='100%'><tr>"}
	for(var/list/column in GLOB.pref_columns)
		html += "<td width='40%' valign='top'>"
		for(var/category in column)
			var/arrow = "+"
			var/body = ""
			if(category in open_categories)
				arrow = "-"
				body = call(src, GLOB.pref_categories[category])(user)
			html += "<div><a class='cat' href='?_src_=prefs;preference=category;name=[url_encode(category)]'>[arrow] [category]</a></div>[body]"
		html += "</td>"
		if(column == GLOB.pref_columns[1])
			html += "<td width='20%'></td>"
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

// ppl can choose between your RACIAL stat bonus or one from your ORIGIN.
/datum/preferences/proc/get_stat_bonuses()
	if(stat_source == "race")
		return pref_species.race_bonus
	var/list/bonuses = list()
	for(var/stat in pref_species.race_bonus)
		if(pref_species.race_bonus[stat] < 0)
			bonuses[stat] = pref_species.race_bonus[stat]
	if(stat_source == "origin" && pref_species.origin_stats_allowed && origin)
		if(!origin.choose_stat)
			for(var/stat in origin.stat_bonuses)
				bonuses[stat] += origin.stat_bonuses[stat]
		else if(origin_bonus_stat in (GLOB.budget_stats + STATKEY_LCK))
			bonuses[origin_bonus_stat] += 1
	return bonuses

/datum/preferences/proc/second_virtue_allowed()
	return stat_source == "virtue"

// checks for overspending & whatnot
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
	if(stat_source == "origin" && !pref_species.origin_stats_allowed)
		stat_source = "race"
	if(!second_virtue_allowed() || virtuetwo.type == virtue.type)
		virtuetwo = GLOB.virtues[/datum/virtue/none]
	var/list/seen_quirks = list()
	for(var/datum/quirk/Q in quirks.Copy())
		if((Q.type in seen_quirks) || istype(Q, /datum/quirk/none))
			quirks -= Q
		seen_quirks += Q.type
	while(get_points_remaining() < 0 && length(quirks))
		quirks.Cut(length(quirks))
	if(get_points_remaining() < 0)
		virtuetwo = GLOB.virtues[/datum/virtue/none]
	if(get_points_remaining() < 0)
		virtue = GLOB.virtues[/datum/virtue/none]
	if(!second_virtue_allowed())
		virtuetwo = GLOB.virtues[/datum/virtue/none]
	if(get_points_remaining() < 0)
		stat_pack = null
		stat_caps = list()

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
		race_items += pref_item("Title", pref_link(selected_title || "None", "race_title"))
	if(length(pref_species.custom_selection))
		var/race_bonus_display = "None"
		for(var/bonus in pref_species.custom_selection)
			if(race_bonus && pref_species.custom_selection[bonus] == race_bonus)
				race_bonus_display = bonus
				break
		race_items += pref_item("Bonus", pref_link(race_bonus_display, "race_bonus_select"))
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

/datum/preferences/proc/page_background(mob/user)
	var/html = ""
	var/origin_name = "None"
	if(origin)
		origin_name = origin.name
	html += pref_line(list(pref_item("Origin", pref_link(origin_name, "origin")), pref_item("Family", pref_link(family || "None", "family", ""))))
	if(family != FAMILY_NONE)
		var/spousename = "Spouse"
		if(family == FAMILY_PARTIAL)
			spousename = "Parent"
		var/species_text = "<font color='#1cb308'>Unrestricted</font>"
		if(xenophobe_pref == 1)
			species_text = "<font color='#FFA500'>Same Race</font>"
		if(xenophobe_pref == 2 && restricted_species_pref)
			species_text = "<font color='#aa0202'>[restricted_species_pref] Only</font>"
		html += pref_line(list(pref_item(spousename, pref_link(setspouse || "None", "setspouse", "")), pref_item("Gender", pref_link(gender_choice || "Any", "gender_choice", "")), pref_item("Species", pref_link(species_text, "species_choice", ""))))
	var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
	html += pref_line(list(pref_item("Faith", pref_link(selected_faith?.name || "INVALID", "faith")), pref_item("Patron", pref_link(selected_patron?.name || "INVALID", "patron"))))
	var/language_text = "Locked by origin"
	if(!origin?.origin_language)
		language_text = get_language_link(extra_language, "lang_free")
	html += pref_line(list(pref_item("Language", language_text), pref_item("Food", pref_link("Change", "culinary", "menu"))))
	var/list/favored_stats
	var/budget = STAT_BUDGET_BASE
	var/preview_label = ""
	if(preview_subclass)
		budget = preview_subclass.stat_budget
		favored_stats = preview_subclass.favored_stats
		preview_label = " - [preview_subclass.name]"
	// subclass preview shows stats for that role!
	var/list/final_stats = calculate_role_stats(budget, favored_stats, stat_caps, TRUE, GLOB.stat_packs[stat_pack])
	var/list/forced_stats = preview_subclass?.forced_stats
	if(forced_stats)
		final_stats = forced_stats
	html += pref_sub("Stats[preview_label]")
	html += "<div class='r'><font size='4' color='#e3c06f'><b>Points: [get_points_remaining()]</b></font></div>"
	html += pref_line(list(pref_item("Statpack", bg_link(stat_pack || "Custom", "statpack"))))
	var/source_name = "Racial"
	if(stat_source == "origin")
		source_name = "Origin"
	if(stat_source == "virtue")
		source_name = "Second Virtue"
	var/list/source_items = list(pref_item("Stat Source", bg_link(source_name, "stat_source")), pref_link("(?)", "statshelp"))
	if(stat_source == "origin" && origin?.choose_stat)
		source_items += pref_item("Bonus", bg_link(capitalize(origin_bonus_stat) || "Choose", "origin_stat"))
	html += pref_line(source_items)
	var/list/stat_bonuses_list = get_stat_bonuses()
	var/list/age_bonuses = GLOB.age_stat_bonuses[age]
	var/list/stat_items = list()
	for(var/stat in GLOB.budget_stats)
		var/list/others = stat_caps.Copy()
		others -= stat
		var/natural = calculate_role_stats(budget, favored_stats, others)[stat]
		var/color = "#d9d9d9"
		if(stat_caps[stat] && stat_caps[stat] + stat_cap_shift(stat, favored_stats) > natural)
			color = "#91cf68"
		if(stat_caps[stat] && stat_caps[stat] + stat_cap_shift(stat, favored_stats) < natural)
			color = "#cf2a2a"
		var/race_value = stat_bonuses_list[stat] || 0
		var/shown_stat = min(final_stats[stat] + race_value + LAZYACCESS(age_bonuses, stat), max(final_stats[stat], STAT_BASE_MAX + stat_cap_shift(stat, favored_stats) + STAT_MODIFIER_OVERCAP))
		if(forced_stats)
			shown_stat = final_stats[stat] + race_value + LAZYACCESS(age_bonuses, stat)
		var/boost_mark = ""
		if(race_value > 0)
			boost_mark = "<font color='#91cf68'>^</font>"
		var/label_color = "#d9d9d9"
		var/tier = LAZYACCESS(favored_stats, stat)
		if(tier == STAT_VERY_FAVORED)
			label_color = "#4fd64f"
		if(tier == STAT_FAVORED)
			label_color = "#91cf68"
		if(tier == STAT_DISFAVORED)
			label_color = "#e07070"
		if(tier == STAT_VERY_DISFAVORED)
			label_color = "#cf2a2a"
		var/pack_level = LAZYACCESS(GLOB.stat_packs[stat_pack], stat)
		if(pack_level > 0)
			color = "#91cf68"
		if(pack_level < 0)
			color = "#cf2a2a"
		var/stat_text = "<font color='[color]'>[shown_stat]</font>"
		if(!stat_pack)
			stat_text = "<a href='?_src_=prefs;preference=background;bg=stat;stat=[stat]'>[stat_text]</a>"
		stat_items += "<b><font color='[label_color]'>[uppertext(copytext(stat, 1, 4))]</font></b> [stat_text][boost_mark]"
		if(length(stat_items) == 3)
			html += pref_line(stat_items)
			stat_items = list()
	if(stat_bonuses_list[STATKEY_LCK] > 0)
		html += "<div class='r'><b>+[stat_bonuses_list[STATKEY_LCK]] LUCK</b></div>"
	html += pref_sub("Virtues")
	html += get_virtue_html("Primary Virtue", virtue, 1)
	if(second_virtue_allowed())
		html += get_virtue_html("Second Virtue", virtuetwo, 2)
	html += pref_sub("Quirks")
	for(var/i in 1 to length(quirks))
		var/datum/quirk/current_quirk = quirks[i]
		html += "<b>[current_quirk.name]</b> ([current_quirk.point_cost]) [bg_link("\[Remove\]", "quirk_remove", i)]"
		if(istype(current_quirk, /datum/quirk/redolent))
			var/scent_display = redolent_scent || get_default_redolent_scent(redolent_type)
			html += " [bg_link("\[Configure Scent\]", "redolent", i)]<br><b>[redolent_type]</b>: [scent_display]"
		html += get_trait_details_html(current_quirk)
		if(current_quirk.warning_text)
			html += "<br><font color='#f44336'>[current_quirk.warning_text]</font>"
		html += "<br>"
	html += pref_line(list(bg_link("Add a Quirk", "quirk_add"), pref_link("Loadout Menu", "loadout", "menu")))
	var/list/vice_names = list()
	for(var/i in 1 to VICE_SLOTS)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice)
			vice_names += "[vice.name] (+[vice.point_value])"
	html += pref_sub("Vices")
	html += pref_line(list(pref_item("Selected", bg_link(vice_names.Join(", ") || "None", "vice"))))
	return html

/datum/preferences/proc/get_virtue_html(label, datum/virtue/V, slot)
	var/cost_text = ""
	if(V.point_cost)
		cost_text = " ([V.point_cost])"
	var/html = "<b>[label]:</b> [bg_link("[V.name][cost_text]", "virtue", slot)]"
	if(!istype(V, /datum/virtue/none))
		html += " [bg_link("\[Clear\]", "virtue_clear", slot)]"
	return "[html]<br>[V.desc][get_trait_details_html(V)]<br>"

/datum/preferences/proc/get_trait_details_html(datum/customization_trait/T)
	var/html = ""
	if(T.custom_text)
		html += "<br><i>[T.custom_text]</i>"
	if(LAZYLEN(T.added_traits))
		html += "<br>Traits granted: [T.added_traits.Join(", ")]"
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
		html += "<br>Skills granted: [skill_lines.Join(", ")]"
	if(LAZYLEN(T.added_stashed_items))
		html += "<br>Stashed items: [T.added_stashed_items.Join(", ")]"
	return html

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
	html += pref_line(list(pref_item("Map", pref_link(preferred_map || "None", "preferred_map"))))
	html += pref_line(list(pref_item("Familiar", pref_link("Preferences", "familiar_prefs")), pref_item("Gnoll", pref_link("Preferences", "gnoll_prefs"))))
	return html

/datum/preferences/proc/page_voice(mob/user)
	if(!voice_pack)
		voice_pack = "Default"
	var/datum/bark/B = GLOB.bark_list[bark_id]
	var/bark_name = "INVALID"
	if(B)
		bark_name = initial(B.name)
	var/html = pref_line(list(pref_item("Identity", pref_link(voice_type, "voicetype")), pref_item("Pack", pref_link(voice_pack, "voicepack"))))
	html += pref_line(list(pref_item("Color", pref_link("Change", "voice")), pref_item("Emote Pitch", pref_link(voice_pitch, "voice_pitch"))))
	html += pref_line(list(pref_item("Accent", pref_link(char_accent, "char_accent"))))
	html += pref_line(list(pref_item("Mannerism", pref_link(char_mannerism, "char_mannerism"))))
	html += pref_line(list(pref_item("Bark", pref_link(bark_name, "barksound")), pref_link("Preview", "barkpreview")))
	html += pref_line(list(pref_item("Speed", pref_link(bark_speed, "barkspeed")), pref_item("Pitch", pref_link(bark_pitch, "barkpitch")), pref_item("Variance", pref_link(bark_variance, "barkvary"))))
	return html

/datum/preferences/proc/page_features(mob/user)
	var/html = ""
	var/list/appearance_items = list()
	if(pref_species.use_skintones)
		appearance_items += pref_item("Skin Tone", pref_link("Change", "s_tone"))
		if(pref_species.mutant_skin_option)
			appearance_items += pref_item("Mutant Skin", pref_link(yes_no(mutant_skin), "mutant_skin"))
	appearance_items += pref_item("Scale", pref_link("[features["body_size"] * 100]%", "body_size"))
	html += pref_line(appearance_items)
	if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))
		html += pref_color_row("Colors", features["mcolor"], "mutant_color")
		html += pref_color_row("Color 2", features["mcolor2"], "mutant_color2")
		html += pref_color_row("Color 3", features["mcolor3"], "mutant_color3")
	if(LAZYLEN(pref_species.allowed_taur_types))
		var/obj/item/bodypart/taur/T = taur_type
		var/taur_name = "None"
		if(ispath(T))
			taur_name = T::name
		html += pref_line(list(pref_item("Taur", pref_link(taur_name, "taur_type"))))
		html += pref_color_row("Taur Color", taur_color, "taur_color")
		html += pref_color_row("Taur Markings", taur_markings, "taur_markings")
		html += pref_color_row("Taur Tertiary", taur_tertiary, "taur_tertiary")
	html += pref_line(list(pref_item("Features", pref_link("Change", "customizers", "menu")), pref_item("Markings", pref_link("Change", "markings", "menu"))))
	html += pref_line(list(pref_item("Descriptors", pref_link("Change", "descriptors", "menu"))))
	html += pref_line(list(pref_item("Update colors with change", pref_link(yes_no(update_mutant_colors), "update_mutant_colors"))))
	return html

/datum/preferences/proc/page_flavor_text(mob/user)
	var/flavor_label = "Examine"
	if(length(flavortext) < MINIMUM_FLAVOR_TEXT)
		flavor_label = "<font color='#802929'>Examine</font>"
	var/ooc_label = "OOC Notes"
	if(length(ooc_notes) < MINIMUM_OOC_NOTES)
		ooc_label = "<font color='#802929'>OOC Notes</font>"
	var/html = pref_line(list(pref_item(flavor_label, pref_link("Change", "flavortext")), pref_item("NSFW", pref_link("Change", "nsfwflavortext")), pref_link("(?)", "formathelp")))
	html += pref_line(list(pref_item(ooc_label, pref_link("Change", "ooc_notes"))))
	html += pref_line(list(pref_item("NSFW Notes", pref_link("Change", "erpprefs"))))
	html += pref_line(list(pref_item("Headshot", pref_link("Change", "headshot"))))
	html += pref_image(headshot_link)
	html += pref_line(list(pref_item("Rumours", pref_link("Set", "rumour")), pref_item("Gossip", pref_link("Set", "gossip")), pref_link("<i>Preview</i>", "rumour_preview")))
	html += pref_line(list(pref_item("Song", pref_link("URL", "ooc_extra")), pref_link("Title", "change_title"), pref_link("Artist", "change_artist")))
	html += pref_line(list(pref_item("OOC Image", pref_link("Change", "ooc_extra_img"))))
	html += pref_image(ooc_extra_img_link)
	html += pref_line(list(pref_item("NSFW Image", pref_link("Change", "nsfw_ooc_extra_img"))))
	html += pref_image(nsfw_ooc_extra_img_link)
	html += pref_line(list(pref_item("Gallery", "[pref_link("Add", "img_gallery")] [pref_link("Clear", "clear_gallery")]")))
	html += pref_line(list(pref_item("NSFW Gallery", "[pref_link("Add", "nsfw_img_gallery")] [pref_link("Clear", "clear_nsfw_gallery")]")))
	html += pref_line(list(pref_link("<b>Preview Examine</b>", "ooc_preview")))
	return html

// this controls all the mechanical customization shit. Nasty nasty code!
/datum/preferences/proc/process_background_link(mob/user, list/href_list)
	var/slot = text2num(href_list["slot"])
	switch(href_list["bg"])
		if("stat")
			var/stat = href_list["stat"]
			if(!(stat in GLOB.budget_stats))
				return
			if(preview_subclass?.forced_stats)
				return
			if(stat_pack)
				return
			var/shift = stat_cap_shift(stat, preview_subclass?.favored_stats)
			var/list/others = stat_caps.Copy()
			others -= stat
			var/natural = calculate_role_stats(preview_subclass?.stat_budget || STAT_BUDGET_BASE, preview_subclass?.favored_stats, others)[stat]
			var/bonus = get_stat_bonuses()[stat] + LAZYACCESS(GLOB.age_stat_bonuses[age], stat)
			var/min_shown = 8 + shift + bonus
			var/max_shown = min(STAT_BASE_MAX + shift + bonus, STAT_BASE_MAX + shift + STAT_MODIFIER_OVERCAP)
			if(min_shown >= max_shown)
				return
			var/target_budget = preview_subclass?.stat_budget || STAT_BUDGET_BASE
			var/default_shown = clamp(calculate_role_stats(target_budget, preview_subclass?.favored_stats, list())[stat] + bonus, min_shown, max_shown)
			var/list/step_values = list(min_shown, round((min_shown + default_shown) / 2), default_shown, round((default_shown + max_shown) / 2), max_shown)
			var/list/step_labels = list("Min", "Low", "Default", "High", "Max")
			var/list/steps = list()
			var/list/current_spread = calculate_role_stats(target_budget, preview_subclass?.favored_stats, stat_caps)
			for(var/i in 1 to 5)
				var/list/test = others.Copy()
				if(i != 3)
					test[stat] = clamp(step_values[i] - bonus, 8 + shift, STAT_BASE_MAX + shift) - shift
				var/list/free_test = test.Copy()
				if(i == 3)
					free_test[stat] = clamp(natural, 8 + shift, STAT_BASE_MAX + shift) - shift
				var/list/spread = calculate_role_stats(target_budget, preview_subclass?.favored_stats, free_test, FALSE)
				var/list/full_spread = calculate_role_stats(target_budget, preview_subclass?.favored_stats, test)
				var/reached = full_spread[stat]
				var/list/changes = list()
				for(var/other in GLOB.budget_stats)
					if(other != stat && full_spread[other] != current_spread[other])
						changes += list(list("stat" = uppertext(copytext(other, 1, 4)), "amount" = full_spread[other] - current_spread[other]))
				var/warn = ""
				if(i != 3 && reached < clamp(step_values[i] - bonus, 8 + shift, STAT_BASE_MAX + shift))
					warn = "Too expensive! (Highest Possible: [reached + bonus])"
				steps += list(list("label" = step_labels[i], "target" = step_values[i], "actual" = reached + bonus, "free" = round(target_budget - stat_values_cost(spread), 0.1), "warn" = warn, "changes" = changes))
			var/new_step = tgui_input_number(user, "", capitalize(stat), 2, 4, 0, slider = TRUE, steps = steps)
			if(isnull(new_step))
				return
			var/list/new_caps = stat_caps.Copy()
			if(new_step == 2)
				new_caps -= stat
			else
				new_caps[stat] = clamp(step_values[new_step + 1] - bonus, 8 + shift, STAT_BASE_MAX + shift) - shift
				if(new_caps[stat] + shift == natural)
					new_caps -= stat
			if(stat_pref_points_used(new_caps) + get_quirk_points_spent() > get_points_total())
				to_chat(user, span_warning("Not enough points!"))
				return
			stat_caps = new_caps
		if("statpack")
			var/list/options = list("Custom" = "")
			var/list/symbols = list("2" = "++", "1" = "+", "-1" = "-", "-2" = "--")
			for(var/pack_name in GLOB.stat_packs)
				var/list/pack_stats = GLOB.stat_packs[pack_name]
				var/label = pack_name
				if(length(pack_stats))
					label += " ("
					for(var/pack_stat in pack_stats)
						label += "[uppertext(copytext(pack_stat, 1, 4))][symbols["[pack_stats[pack_stat]]"]] "
					label = "[copytext(label, 1, length(label))])"
				options[label] = pack_name
			var/choice = tgui_input_list(user, "Choosing a statpack costs 3 points! Stats are distributed via class budget.", "Statpack", options)
			if(!choice)
				return
			var/new_pack = options[choice]
			if(stat_pref_points_used(list(), new_pack) > get_points_remaining() + stat_pref_points_used(stat_caps, stat_pack))
				to_chat(user, span_warning("Not enough points!"))
				return
			stat_pack = new_pack
			stat_caps = list()
		if("stat_source")
			var/list/sources = list("Racial" = "race", "Second Virtue" = "virtue")
			if(pref_species.origin_stats_allowed)
				sources["Origin"] = "origin"
			var/choice = tgui_input_list(user, "What defines you?", "Stat Source", sources)
			if(choice)
				stat_source = sources[choice]
		if("origin_stat")
			var/list/choices = list()
			for(var/stat in GLOB.budget_stats + STATKEY_LCK)
				choices[capitalize(stat)] = stat
			var/choice = tgui_input_list(user, "Choose your origin's +1 stat:", "Origin Bonus", choices)
			if(choice)
				origin_bonus_stat = choices[choice]
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
				var/datum/virtue/current_virtue = virtue
				if(slot == 2)
					current_virtue = virtuetwo
				if(V.point_cost > get_points_remaining() + current_virtue?.point_cost)
					continue
				var/virtue_label = V.name
				if(V.point_cost)
					virtue_label = "[V.name] ([V.point_cost] point\s)"
				available[virtue_label] = V
			available = sort_list(available)
			var/choice = tgui_input_list(user, "Choose your virtue:", "Virtue Selection", available)
			if(choice)
				var/datum/virtue/selected = available[choice]
				var/datum/virtue/replaced = virtue
				if(slot == 2)
					replaced = virtuetwo
				if(selected.point_cost > get_points_remaining() + replaced?.point_cost)
					to_chat(user, span_warning("Not enough points!"))
					return
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
			var/prompt_text = "Choose a quirk to add ([get_points_remaining()] point\s left)"
			var/choice = tgui_input_list(user, prompt_text, "Quirk Selection", available)
			if(choice)
				var/datum/quirk/selected = available[choice]
				if(selected.point_cost > get_points_remaining() || has_quirk(selected.type))
					to_chat(user, span_warning("Not enough points!"))
					return
				quirks += new selected.type()
				to_chat(user, span_notice("Added [selected.name] as a quirk."))
				if(selected.desc)
					to_chat(user, "<span class='info'>[selected.desc]</span>")
		if("quirk_remove")
			if(slot && slot <= length(quirks))
				quirks.Cut(slot, slot + 1)
		if("redolent")
			if(!has_quirk(/datum/quirk/redolent))
				return
			var/list/scent_types = list("Gross", "Neutral", "Pleasant")
			var/new_scent_type = tgui_input_list(user, "Choose how others perceive your scent:", "Redolent", scent_types)
			if(!new_scent_type)
				return
			var/scent_action = tgui_input_list(user, "Describe the scent:", "Redolent", list("Describe scent", "Use default"))
			if(!scent_action)
				return
			var/new_scent = get_default_redolent_scent(new_scent_type)
			if(scent_action == "Describe scent")
				new_scent = tgui_input_text(user, "Describe the scent - a preview of the output in game is shown below:", "Redolent", redolent_scent, max_length = 100, multiline = TRUE, preview_leadin = redolent_scent_leadin(new_scent_type))
				if(isnull(new_scent))
					return
				if(!length(trim(new_scent)))
					new_scent = get_default_redolent_scent(new_scent_type)
			redolent_type = new_scent_type
			redolent_scent = new_scent
			to_chat(user, span_notice("Set my Redolent scent to [redolent_type]."))
		if("vice")
			var/list/items = list()
			var/list/descriptions = list()
			var/list/default_checked = list()
			var/list/labels = list()
			var/list/current_types = list()
			for(var/i in 1 to VICE_SLOTS)
				var/datum/charflaw/existing_vice = vars["vice[i]"]
				if(existing_vice)
					current_types += existing_vice.type
			for(var/vice_name in GLOB.character_flaws)
				var/vice_type = GLOB.character_flaws[vice_name]
				var/datum/charflaw/singleton = GLOB.charflaw_singletons[vice_type]
				var/vice_label = "[vice_name] (+[singleton?.point_value || 0])"
				labels[vice_label] = vice_type
				items += vice_label
				descriptions[vice_label] = singleton?.desc
				if(vice_type in current_types)
					default_checked += vice_label
			// i love TGUI checklist!!!
			var/list/picked = tgui_input_checkboxes(user, "Select your vices.", "Vice Selection", items, 1, VICE_SLOTS, default_checked = default_checked, descriptions = descriptions, strict_modern = TRUE, window_width = 500, window_height = 500)
			if(!length(picked))
				return
			var/list/picked_types = list()
			for(var/vice_label in picked)
				picked_types += labels[vice_label]
			if(((/datum/charflaw/noflaw in picked_types) || (/datum/charflaw/randflaw in picked_types)) && length(picked_types) > 1)
				to_chat(user, span_warning("No Flaw can't be combined with other vices."))
				return
			for(var/vice_type in picked_types)
				if(check_vice_pick_conflict(vice_type, TRUE, user) || check_vice_vice_conflict(vice_type, picked_types, TRUE, user))
					return
			var/list/ordered_types = list()
			for(var/vice_type in current_types)
				if(vice_type in picked_types)
					ordered_types += vice_type
			for(var/vice_type in picked_types)
				if(!(vice_type in ordered_types))
					ordered_types += vice_type
			var/list/old_vices = list()
			for(var/i in 1 to VICE_SLOTS)
				old_vices += vars["vice[i]"]
				vars["vice[i]"] = null
				if(i <= length(ordered_types))
					var/new_vice_type = ordered_types[i]
					vars["vice[i]"] = new new_vice_type()
			if(get_points_remaining() < 0)
				for(var/i in 1 to VICE_SLOTS)
					vars["vice[i]"] = old_vices[i]
				to_chat(user, span_warning("Those vices would leave your stat picks and quirks overspent. Remove some first."))
				return
			charflaw = null
			to_chat(user, span_notice("Vices updated."))
		if("lang_free")
			var/list/choices = get_language_choices()
			var/chosen_language = tgui_input_list(user, "Choose your character's extra language:", "EXTRA LANGUAGE", choices)
			if(chosen_language)
				extra_language = choices[chosen_language] || "None"
