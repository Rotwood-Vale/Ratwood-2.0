GLOBAL_LIST_EMPTY(preferences_datums)

GLOBAL_LIST_EMPTY(chosen_names)

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 60

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#c43b23"
	var/asaycolor = "#ff4500"			//This won't change the color for current admins, only incoming ones.
	var/triumphs = 0
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds
	// Commend variable on prefs instead of client to prevent reconnect abuse (is persistant on prefs, opposed to not on client)
	var/commendedsomeone = FALSE
	// History tracking for character customization undo
	var/list/customization_history = list()
	// Loadout preset storage - 3 slots for saving/loading character customization
	var/list/loadout_preset_1
	var/list/loadout_preset_2
	var/list/loadout_preset_3
	// Temporary storage for loadout item selection (per-user to prevent race conditions)
	var/list/temp_loadout_selection

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = null
	var/hud_colorblind_palette = HUD_COLORBLIND_NONE
	var/buttons_locked = TRUE
	var/hotkeys = TRUE

	var/chat_on_map = TRUE
	var/showrolls = TRUE
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	var/see_chat_non_mob = TRUE

	// Custom Keybindings
	var/list/key_bindings = list()
	/// Whether closing keybind setup should return to character preferences.
	var/keybinds_return_to_prefs = TRUE

	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/tgui_theme = "azure_default"
	var/windowflashing = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/floating_text_toggles = TOGGLES_TEXT_DEFAULT
	var/admin_chat_toggles = TOGGLES_DEFAULT_CHAT_ADMIN
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/pda_style = MONO
	var/pda_color = "#808000"

	var/uses_glasses_colour = 0

	//character preferences
	var/slot_randomized					//keeps track of round-to-round randomization of the character slot, prevents overwriting
	var/real_name						//our character's name
	var/gender = MALE					//gender of character (well duh) (LETHALSTONE EDIT: this no longer references anything but whether the masculine or feminine model is used)
	var/pronouns = HE_HIM				// LETHALSTONE EDIT: character's pronouns (well duh)
	var/voice_pack = "Default"
	var/voice_type = VOICE_TYPE_MASC	// LETHALSTONE EDIT: the type of soundpack the mob should use
	var/datum/statpack/statpack	= new /datum/statpack/wildcard/fated // LETHALSTONE EDIT: the statpack we're giving our char instead of racial bonuses
	var/datum/virtue/virtue = new /datum/virtue/none // LETHALSTONE EDIT: the virtue we get for not picking a statpack
	var/datum/virtue/virtuetwo = new /datum/virtue/none
	var/selected_title = "None"
	var/age = AGE_ADULT						//age of character
	var/datum/origin/origin
	var/accessory = "Nothing"
	var/detail = "Nothing"
	var/backpack = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hairstyle = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/facial_hairstyle = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color = "000"				//Eye color
	var/extra_language = "None" // Extra language
	var/extra_language_1 = "None" // Additional triumph language slot 1
	var/extra_language_2 = "None" // Additional triumph language slot 2
	var/voice_color = "a0a0a0"
	var/voice_pitch = 1
	var/detail_color = "000"
	var/datum/species/pref_species = new /datum/species/human/northern()	//Mutant race
	var/static/datum/species/default_species = new /datum/species/human/northern()
	var/datum/patron/selected_patron
	var/static/datum/patron/default_patron = /datum/patron/divine/astrata
	var/list/features = MANDATORY_FEATURE_LIST
	var/list/randomise = list(RANDOM_UNDERWEAR = TRUE, RANDOM_UNDERWEAR_COLOR = TRUE, RANDOM_UNDERSHIRT = TRUE, RANDOM_SOCKS = TRUE, RANDOM_BACKPACK = TRUE, RANDOM_JUMPSUIT_STYLE = FALSE, RANDOM_SKIN_TONE = TRUE, RANDOM_EYE_COLOR = TRUE)
	var/list/friendlyGenders = list("male" = "masculine", "female" = "feminine")
	var/phobia = "spiders"
	var/shake = TRUE
	var/sexable = FALSE
	var/chastenable = FALSE
	var/chastity_hardmode = CHASTITY_HARDMODE_DISABLED
	var/extreme_erp = FALSE
	var/edging = FALSE
	var/sensitive_brands = FALSE
	var/facial_brands = FALSE
	/// If a cursed collar can be equipped to them at all
	var/cursed_collarable = FALSE
	var/voting_popup = TRUE
	var/compliance_notifs = TRUE
	var/skillcap_notifs = TRUE
	var/restricted_species_pref = null
	var/wildshape_name = TRUE
	var/xenophobe_pref = 0

	var/list/custom_names = list()
	var/preferred_ai_core_display = "Blue"
	var/prefered_security_department = SEC_DEPT_RANDOM

	//Quirk list
	var/list/all_quirks = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = RETURNTOLOBBY  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0

// Point-buy system helpers
// Base points available to every character
/datum/preferences/proc/get_base_points()
	return 10

// Points gained from selected vices (+1 per selected vice)
/datum/preferences/proc/get_vice_points()
	var/points = 0
	for(var/i = 1 to 5)
		if(vars["vice[i]"])
			points++
	return points

// Points spent on selected loadout items (uses triumph_cost as point cost)
/datum/preferences/proc/get_loadout_points_spent()
	var/spent = 0
	for(var/i = 1 to 10)
		var/datum/loadout_item/L = vars[i == 1 ? "loadout" : "loadout[i]"]
		if(L && L.triumph_cost)
			spent += L.triumph_cost
	return spent

// DEPRECATED - Languages now use actual triumph pool, not vice points
// Kept for backwards compatibility but no longer used in calculations
/datum/preferences/proc/get_language_points_spent()
	var/spent = 0
	if(extra_language_1 && extra_language_1 != "None")
		spent += 2
	if(extra_language_2 && extra_language_2 != "None")
		spent += 4
	return spent

// Total points available = base + points from vices
/datum/preferences/proc/get_total_points()
	return get_base_points() + get_vice_points()

// Legacy proc - remaining points after accounting for both loadouts and languages
// NOTE: Languages now use ACTUAL triumphs (player.get_triumphs()), not vice points
// This proc only calculates loadout point usage now
/datum/preferences/proc/get_remaining_points()
	var/total = get_total_points()
	var/spent = get_loadout_points_spent() // Languages no longer count toward this
	return total - spent


/datum/preferences
	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = 100//0 is sync

	var/parallax

	var/ambientocclusion = TRUE
	var/auto_fit_viewport = FALSE
	var/widescreenpref = TRUE

	var/musicvol = 50
	var/combatmusicvol = 50
	var/lobbymusicvol = 50
	var/ambiencevol = 50
	var/mastervol = 50

	var/anonymize = TRUE
	var/masked_examine = FALSE
	var/nsfw_examine_always = FALSE
	var/mute_animal_emotes = FALSE
	var/autoconsume = FALSE
	var/autowoodcut = TRUE
	var/autopicking = TRUE
	var/runmode = FALSE
	var/no_examine_blocks = FALSE
	var/no_autopunctuate = FALSE
	var/no_language_fonts = FALSE
	var/no_language_icon = FALSE
	var/hide_unavailable_emotes = FALSE
	var/hide_tongue_noise_warnings = FALSE
	var/ghost_protection = FALSE
	var/lastclass

	var/uplink_spawn_loc = UPLINK_PDA

	var/list/exp = list()
	var/list/menuoptions

	var/datum/loadout_menu/loadout_menu

	var/datum/migrant_pref/migrant
	var/next_special_trait = null

	var/action_buttons_screen_locs = list()

	var/domhand = 2
	var/nickname = "Please Change Me"
	var/highlight_color = "#FF0000"
	var/datum/charflaw/charflaw
	// Multiple vice selection (up to 5, at least 1 required)
	var/datum/charflaw/vice1
	var/datum/charflaw/vice2
	var/datum/charflaw/vice3
	var/datum/charflaw/vice4
	var/datum/charflaw/vice5

	var/setspouse = ""
	var/gender_choice = ANY_GENDER

	var/static/default_cmusic_type = /datum/combat_music/default
	var/datum/combat_music/combat_music
	var/combat_music_helptext_shown = FALSE

	var/family = FAMILY_NONE

	var/crt = FALSE
	var/grain = TRUE
	var/dnr_pref = FALSE

	var/list/customizer_entries = list()
	var/list/list/body_markings = list()
	var/update_mutant_colors = TRUE

	var/headshot_link
	var/chatheadshot = FALSE
	var/ooc_extra
	var/ooc_extra_img
	var/ooc_extra_img_link
	var/song_artist
	var/song_title
	var/list/descriptor_entries = list()
	var/list/custom_descriptors = list()

	var/char_accent = "No accent"

	// Vocal bark prefs
	var/bark_id = "mutedc3"
	var/bark_speed = 4
	var/bark_pitch = 1
	var/bark_variance = 0.2
	COOLDOWN_DECLARE(bark_previewing)
	var/hear_barks = TRUE

	// PATREON
	// Vrell - I fucking hate how inconsistent the variable style is for this shit. underscores? all lowercase? camelcase?
	var/patreon_say_color = "ff7a05"
	var/patreon_say_color_enabled = FALSE
	// END PATREON


	var/datum/loadout_item/loadout
	var/datum/loadout_item/loadout2
	var/datum/loadout_item/loadout3
	var/datum/loadout_item/loadout4
	var/datum/loadout_item/loadout5
	var/datum/loadout_item/loadout6
	var/datum/loadout_item/loadout7
	var/datum/loadout_item/loadout8
	var/datum/loadout_item/loadout9
	var/datum/loadout_item/loadout10

	var/loadout_1_hex
	var/loadout_2_hex
	var/loadout_3_hex
	var/loadout_4_hex
	var/loadout_5_hex
	var/loadout_6_hex
	var/loadout_7_hex
	var/loadout_8_hex
	var/loadout_9_hex
	var/loadout_10_hex

	// Custom names for loadout items
	var/loadout_1_name
	var/loadout_2_name
	var/loadout_3_name
	var/loadout_4_name
	var/loadout_5_name
	var/loadout_6_name
	var/loadout_7_name
	var/loadout_8_name
	var/loadout_9_name
	var/loadout_10_name

	// Custom descriptions for loadout items
	var/loadout_1_desc
	var/loadout_2_desc
	var/loadout_3_desc
	var/loadout_4_desc
	var/loadout_5_desc
	var/loadout_6_desc
	var/loadout_7_desc
	var/loadout_8_desc
	var/loadout_9_desc
	var/loadout_10_desc

	var/flavortext
	var/flavortext_display

	var/ooc_notes

	var/rumour

	var/noble_gossip

	var/nsfwflavortext

	var/nsfw_ooc_extra_img
	var/nsfw_ooc_extra_img_link

	var/erpprefs

	var/list/img_gallery = list()

	var/list/nsfw_img_gallery = list()

	var/datum/familiar_prefs/familiar_prefs
	var/datum/gnoll_prefs/gnoll_prefs

	var/taur_type = null
	var/taur_color = "ffffff"
	var/taur_markings = "ffffff"
	var/taur_tertiary = "ffffff"

	/// Assoc list of culinary preferences, where the key is the type of the culinary preference, and value is food/drink typepath
	var/list/culinary_preferences = list()

	var/datum/advclass/preview_subclass

	var/tgui_pref = TRUE

	var/race_bonus

/datum/preferences/New(client/C)
	parent = C
	migrant  = new /datum/migrant_pref(src)
	familiar_prefs = new /datum/familiar_prefs(src)
	gnoll_prefs = new /datum/gnoll_prefs(src)

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			unlock_content = C.IsByondMember()
			if(unlock_content)
				max_save_slots = 100
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			if(check_nameban(C.ckey) || (C.blacklisted() == 1))
				real_name = pref_species.random_name(gender,1)
			return
	//Set the race to properly run race setter logic
	set_new_race(pref_species, null)
	if(!charflaw)
		charflaw = pick(GLOB.character_flaws)
		charflaw = GLOB.character_flaws[charflaw]
		charflaw = new charflaw()
	if(!selected_patron)
		selected_patron = GLOB.patronlist[default_patron]
	if(!combat_music)
		combat_music = GLOB.cmode_tracks_by_type[default_cmusic_type]
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	C.update_movement_keys()
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

/datum/preferences/proc/get_roguehud_icon()
	return roguehud_icon_for_palette(hud_colorblind_palette)

/datum/preferences/proc/get_rogueheat_icon()
	return rogueheat_icon_for_palette(hud_colorblind_palette)

/datum/preferences/proc/set_hud_colorblind_palette(new_palette)
	if(!is_hud_colorblind_palette(new_palette))
		return FALSE
	hud_colorblind_palette = new_palette
	return TRUE

/datum/preferences/proc/set_new_race(datum/species/new_race, user)
	pref_species = new_race
	real_name = pref_species.random_name(gender,1)
	ResetJobs()
	if(user)
		if(pref_species.desc)
			to_chat(user, "[pref_species.desc]")
		if(pref_species.expanded_desc)
			to_chat(user, "<a href='?src=[REF(user)];view_species_info=[pref_species.expanded_desc]'>Read More</a>")
		to_chat(user, "<font color='red'>Classes reset.</font>")
	random_character(gender, FALSE, FALSE)
	accessory = "Nothing"

	if(pref_species.forced_taur && pref_species.allowed_taur_types.len)
		taur_type = pick(pref_species.allowed_taur_types)
	else
		taur_type = null

	selected_title = "None"

	customizer_entries = list()
	validate_customizer_entries()
	reset_all_customizer_accessory_colors()
	randomize_all_customizer_accessories()
	reset_descriptors()


#define APPEARANCE_CATEGORY_COLUMN "<td valign='top' width='14%'>"
#define MAX_MUTANT_ROWS 4

/datum/preferences/proc/ShowChoices(mob/user, tabchoice)
	if(!user || !user.client)
		return
	if(slot_randomized)
		load_character(default_slot) // Reloads the character slot. Prevents random features from overwriting the slot if saved.
		slot_randomized = FALSE
	var/list/dat = list("<center>")
	if(tabchoice)
		current_tab = tabchoice
	if(tabchoice == 4)
		current_tab = 0

//	dat += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character Sheet</a>"
//	dat += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Preferences</a>"
//	dat += "<a href='?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>OOC Preferences</a>"
//	dat += "<a href='?_src_=prefs;preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>Keybinds</a>"

	dat += "</center>"

	var/used_title
	switch(current_tab)
		if (0) // Character Settings#
			used_title = "角色卡"

			// Top-level menu table
			dat += "<table style='width: 100%; line-height: 20px;'>"
			// NEXT ROW
			dat += "<tr>"
			dat += "<td style='width:33%;text-align:left'>"
			dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;'>切换角色</a>"
			dat += "</td>"

			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=job;task=menu'>职业选择</a>"
			dat += "</td>"

			dat += "<td style='width:33%;text-align:right'>"
			dat += "<a href='?_src_=prefs;preference=keybinds;task=menu'>按键绑定</a>"
			dat += "</td>"
			dat += "</tr>"

			// ANOTHA ROW
			dat += "<tr style='padding-top: 0px;padding-bottom:0px'>"
			dat += "<td style='width:33%;text-align:left'>"
			dat += "<a href='?_src_=prefs;preference=tgui_ui_prefs;task=menu'>[tgui_pref ? "TGUI" : "传统"]</a>"
			dat += "<br>"
			dat += "<a href='?_src_=prefs;preference=tgui_theme'>主题：[get_tgui_theme_display_name()]</a>"
			dat += "</td>"

			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=antag;task=menu'>反派选择</a>"
			dat += "</td>"

			dat += "<td style='width:33%;text-align:right'>"
			dat += "</td>"
			dat += "</tr>"

			// ANOTHER ROW HOLY SHIT WE FINALLY A GOD DAMN GRID NOW! WHOA!
			dat += "<tr style='padding-top: 0px;padding-bottom:0px'>"
			dat += "<td style='width:33%; text-align:left'>"
			dat += "<a href='?_src_=prefs;preference=playerquality;task=menu'><b>玩家品质:</b></a> [get_playerquality(user.ckey, text = TRUE)]"
			dat += "</td>"

			dat += "<td style='width:33%;text-align:center'>"
			dat += "<a href='?_src_=prefs;preference=triumphs;task=menu'><b>胜利点:</b></a> [user.get_triumphs() ? "\Roman [user.get_triumphs()]" : "无"]"
			if(SStriumphs.triumph_buys_enabled)
				dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=triumph_buy_menu'>胜利点购买</a>"
			dat += "</td>"

			if(CONFIG_GET(flag/roundstart_traits))
				dat += "<center><h2>特质设置</h2>"
				dat += "<a href='?_src_=prefs;preference=trait;task=menu'>配置特质</a><br></center>"
				dat += "<center><b>当前特质:</b> [all_quirks.len ? all_quirks.Join(", ") : "无"]</center>"

			// Encapsulating table
			dat += "<table width = '100%'>"
			// Only one Row
			dat += "<tr>"
			// Leftmost Column, 40% width
			dat += "<td width=40% valign='top'>"

// 			-----------START OF IDENT TABLE-----------
			dat += "<h2>身份</h2>"
			dat += "<table width='100%'><tr><td width='75%' valign='top'>"
			if(is_banned_from(user.ckey, "Appearance"))
				dat += "<b>您已被禁止使用自定义名称和外观。您仍可继续调整角色，但在加入游戏时会被随机化。</b><br>"
//			dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_NAME]'>Always Random Name: [(randomise[RANDOM_NAME]) ? "Yes" : "No"]</a>"
//			dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_NAME_ANTAG]'>When Antagonist: [(randomise[RANDOM_NAME_ANTAG]) ? "Yes" : "No"]</a>"
			dat += "<b>姓名:</b> "
			if(check_nameban(user.ckey))
				dat += "<a href='?_src_=prefs;preference=name;task=input'>名称已被禁用</a><BR>"
			else
				dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a> <a href='?_src_=prefs;preference=name;task=random'>\[R\]</a>"
			dat += "<BR>"
			dat += "<b>昵称:</b> "
			dat += "<a href='?_src_=prefs;preference=nickname;task=input'>[nickname]</a><BR>"
			// LETHALSTONE EDIT BEGIN: add pronoun prefs
			dat += "<b>人称代词:</b> <a href='?_src_=prefs;preference=pronouns;task=input'>[pronouns]</a><BR>"
			// LETHALSTONE EDIT END
			if(!voice_pack)
				voice_pack = "默认"
			// LETHALSTONE EDIT BEGIN: add voice type prefs
			dat += "<b>语音身份</b>: <a href='?_src_=prefs;preference=voicetype;task=input'>[voice_type]</a><BR>"
			// LETHALSTONE EDIT END
			dat += "<b>语音包</b>: <a href='?_src_=prefs;preference=voicepack;task=input'>[voice_pack]</a><BR>"

			dat += "<BR>"
			dat += "<b>种族:</b> <a href='?_src_=prefs;preference=species;task=input'>[pref_species.name]</a>[spec_check(user) ? "" : " (!)"]<BR>"
			if(pref_species.use_titles)
				var/display_title = selected_title ? selected_title : "无"
				dat += "<b>种族头衔:</b> <a href='?_src_=prefs;preference=race_title;task=input'>[display_title]</a><BR>"
			dat += "<b>家族:</b> <a href='?_src_=prefs;preference=family'>[family ? family : "无"]</a><BR>"
			if(family != FAMILY_NONE)
				var/spousename = "首选配偶"
				if(family == FAMILY_PARTIAL)
					spousename = "首选父母"
				dat += "<b>[spousename]:</b> <a href='?_src_=prefs;preference=setspouse'>[setspouse ? setspouse : "无"]</a><BR>"
				if(family != FAMILY_NONE)
					dat += "<b>首选性别:</b> <a href='?_src_=prefs;preference=gender_choice'>[gender_choice ? gender_choice : "任意性别"]</a><BR>"
					var/species_text
					if(xenophobe_pref == 1)
						species_text = "<font color='#FFA500'>同种族</font>"
					else if(xenophobe_pref == 2 && restricted_species_pref)
						species_text = "<font color='#aa0202'>仅[restricted_species_pref]</font>"
					else
						species_text = "<font color='#1cb308'>不限制</font>"
					dat += "<b>限制种族:</b> <a href='?_src_=prefs;preference=species_choice'>[species_text]</a><BR>"
			if(length(pref_species.custom_selection))
				var/race_bonus_display
				if(race_bonus)
					for(var/bonus in pref_species.custom_selection)
						if(pref_species.custom_selection[bonus] == race_bonus)
							race_bonus_display = bonus
							break
				dat += "<b>种族奖励:</b> <a href='?_src_=prefs;preference=race_bonus_select;task=input'>[race_bonus_display ? "[race_bonus_display]" : "无"]</a><BR>"
			else
				race_bonus = null
				dat += "<BR>"

//			dat += "<a href='?_src_=prefs;preference=species;task=random'>Random Species</A> "
//			dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_SPECIES]'>Always Random Species: [(randomise[RANDOM_SPECIES]) ? "Yes" : "No"]</A><br>"

			if(!(AGENDER in pref_species.species_traits))
				var/dispGender
				if(gender == MALE)
					dispGender = "男性化" // LETHALSTONE EDIT: repurpose gender as bodytype, display accordingly
				else if(gender == FEMALE)
					dispGender = "女性化" // LETHALSTONE EDIT: repurpose gender as bodytype, display accordingly
				else
					dispGender = "其他"
				dat += "<b>体型:</b> <a href='?_src_=prefs;preference=gender'>[dispGender]</a><BR>"
				if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG]) //doesn't work unless random body
					dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER]'>总是随机体型: [(randomise[RANDOM_GENDER]) ? "是" : "否"]</A>"
					dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_GENDER_ANTAG]'>反派时: [(randomise[RANDOM_GENDER_ANTAG]) ? "是" : "否"]</A>"

			if(LAZYLEN(pref_species.allowed_taur_types))
				var/obj/item/bodypart/taur/T = taur_type
				var/name = ispath(T) ? T::name : "无"
				dat += "<b>半兽体型:</b> <a href='?_src_=prefs;preference=taur_type;task=input'>[name]</a><BR>"
				dat += "<b>半兽颜色:</b> <span style='border: 1px solid #161616; background-color: #[taur_color];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=taur_color;task=input'>更改</a><BR>"
				dat += "<b>半兽斑纹:</b> <span style='border: 1px solid #161616; background-color: #[taur_markings];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=taur_markings;task=input'>更改</a><BR>"
				dat += "<b>半兽第三色:</b> <span style='border: 1px solid #161616; background-color: #[taur_tertiary];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=taur_tertiary;task=input'>更改</a><BR>"

			dat += "<b>年龄:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"
			dat += "<b>出身:</b> <a href='?_src_=prefs;preference=origin;task=input'>[origin ? origin.name : "无"]</a><BR>"

//			dat += "<br><b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a>"
//			if(randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG]) //doesn't work unless random body
//				dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_AGE]'>Always Random Age: [(randomise[RANDOM_AGE]) ? "Yes" : "No"]</A>"
//				dat += "<a href='?_src_=prefs;preference=toggle_random;random_type=[RANDOM_AGE_ANTAG]'>When Antagonist: [(randomise[RANDOM_AGE_ANTAG]) ? "Yes" : "No"]</A>"

//			dat += "<b><a href='?_src_=prefs;preference=name;task=random'>Random Name</A></b><BR>"
			if(length(pref_species.restricted_virtues))
				if(virtue.type in pref_species.restricted_virtues)
					virtue = GLOB.virtues[/datum/virtue/none]
				if(virtuetwo.type in pref_species.restricted_virtues)
					virtuetwo = GLOB.virtues[/datum/virtue/none]
			if(statpack.name != "德能") //需对齐modular_azurepeak/statpacks/wildcard.dm datum/statpack/wildcard/virtuous 的名字
				virtuetwo = GLOB.virtues[/datum/virtue/none]
			dat += "<b>角色自定义:</b> <a href='?_src_=prefs;preference=vices_menu;task=input'>配置全部</a><BR>"
			var/datum/faith/selected_faith = GLOB.faithlist[selected_patron?.associated_faith]
			dat += "<b>信仰:</b> <a href='?_src_=prefs;preference=faith;task=input'>[selected_faith?.name || "错误"]</a><BR>"
			dat += "<b>庇护者:</b> <a href='?_src_=prefs;preference=patron;task=input'>[selected_patron?.name || "错误"]</a><BR>"
			dat += "<b>惯用手:</b> <a href='?_src_=prefs;preference=domhand'>[domhand == 1 ? "左利手" : "右利手"]</a><BR>"
			dat += "<b>食物偏好:</b> <a href='?_src_=prefs;preference=culinary;task=menu'>更改</a><BR>"

			var/musicname = (combat_music.shortname ? combat_music.shortname : combat_music.name)
			dat += "<b>战斗音乐:</b> <a href='?_src_=prefs;preference=combat_music;task=input'>[musicname || "错误"]</a><BR>"

			dat += "<b>不可复活:</b> <a href='?_src_=prefs;preference=dnr;task=input'>[dnr_pref ? "是" : "否"]</a><BR>"

			dat += "<b>成为魔宠:</b><a href='?_src_=prefs;preference=familiar_prefs;task=input'>Familiar Preferences</a><br>"

			dat += "<b>偏好地图:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[preferred_map || "No Preference"]</a><br>"

			dat += "<br><b>豺狼人自定义:</b><a href='?_src_=prefs;preference=gnoll_prefs;task=input'>豺狼人偏好</a>"

/*
			dat += "<br><br><b>Special Names:</b><BR>"
			var/old_group
			for(var/custom_name_id in GLOB.preferences_custom_names)
				var/namedata = GLOB.preferences_custom_names[custom_name_id]
				if(!old_group)
					old_group = namedata["group"]
				else if(old_group != namedata["group"])
					old_group = namedata["group"]
					dat += "<br>"
				dat += "<a href ='?_src_=prefs;preference=[custom_name_id];task=input'><b>[namedata["pref_name"]]:</b> [custom_names[custom_name_id]]</a> "
			dat += "<br><br>"

			dat += "<b>Custom Job Preferences:</b><BR>"
			dat += "<a href='?_src_=prefs;preference=ai_core_icon;task=input'><b>Preferred AI Core Display:</b> [preferred_ai_core_display]</a><br>"
			dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Preferred Security Department:</b> [prefered_security_department]</a><BR></td>"
*/
			var/datum/bark/B = GLOB.bark_list[bark_id]
			dat += "<br>"
			dat += "<b>叫声类型:</b><br>"
			dat += "<a href='?_src_=prefs;preference=barksound;task=input'>[B ? initial(B.name) : "无效"]</a><br>"
			dat += "<b>叫声速度:</b> <a href='?_src_=prefs;preference=barkspeed;task=input'>[bark_speed]</a><br>"
			dat += "<b>叫声音高:</b> <a href='?_src_=prefs;preference=barkpitch;task=input'>[bark_pitch]</a><br>"
			dat += "<b>叫声变调:</b> <a href='?_src_=prefs;preference=barkvary;task=input'>[bark_variance]</a><br>"
			dat += "<b><a href='?_src_=prefs;preference=barkpreview;task=input'>预览叫声</a></b><br>"
			dat += "</td>"
			dat += "</tr></table>"
// 			-----------END OF IDENT TABLE-----------


			// Middle dummy Column, 20% width
			dat += "</td>"
			dat += "<td width=20% valign='top'>"
			var/datum/job/highest_pref
			for(var/job in job_preferences)
				if(job_preferences[job] > highest_pref)
					highest_pref = SSjob.GetJob(job)
			if(!isnull(highest_pref) && !istype(highest_pref, /datum/job/roguetown/jester))
				dat += "<div style='text-align: center'><br>子职业预览:<br> <a href='?_src_=prefs;preference=subclassoutfit;task=input'>[preview_subclass ? "[preview_subclass.name]" : "无"]</a></div>"
			else
				preview_subclass = null
			// Rightmost column, 40% width
			dat += "<td width=40% valign='top'>"
			dat += "<h2>身体</h2>"

//			-----------START OF BODY TABLE-----------
			dat += "<table width='100%'><tr><td width='1%' valign='top'>"
			dat += "<b>更改时更新特征颜色:</b> <a href='?_src_=prefs;preference=update_mutant_colors;task=input'>[update_mutant_colors ? "是" : "否"]</a><BR>"
			var/use_skintones = pref_species.use_skintones
			if(use_skintones)

				var/skin_tone_wording = pref_species.skin_tone_wording // Both the skintone names and the word swap here is useless fluff

				dat += "<b>[skin_tone_wording]: </b><a href='?_src_=prefs;preference=s_tone;task=input'>更改 </a>"
				dat += "<br>"

			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))

				dat += "<b>突变颜色 #1:</b> <span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color;task=input'>更改</a><BR>"
				dat += "<b>突变颜色 #2:</b> <span style='border: 1px solid #161616; background-color: #[features["mcolor2"]];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color2;task=input'>更改</a><BR>"
				dat += "<b>突变颜色 #3:</b> <span style='border: 1px solid #161616; background-color: #[features["mcolor3"]];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color3;task=input'>更改</a><BR>"

			dat += "<br><b>声音颜色: </b><a href='?_src_=prefs;preference=voice;task=input'>更改</a>"
			dat += "<br><b>昵称颜色: </b> </b><a href='?_src_=prefs;preference=highlight_color;task=input'>更改</a>"
			dat += "<br><b>语音音高: </b><a href='?_src_=prefs;preference=voice_pitch;task=input'>[voice_pitch]</a>"
			dat += "<br><b>口音:</b> <a href='?_src_=prefs;preference=char_accent;task=input'>[char_accent]</a>"
			dat += "<br><b>特征:</b> <a href='?_src_=prefs;preference=customizers;task=menu'>更改</a>"
			dat += "<br><b>图像缩放:</b><a href='?_src_=prefs;preference=body_size;task=input'>[(features["body_size"] * 100)]%</a>"
			dat += "<br><b>斑纹:</b> <a href='?_src_=prefs;preference=markings;task=menu'>更改</a>"
			dat += "<br><b>描述词:</b> <a href='?_src_=prefs;preference=descriptors;task=menu'>更改</a>"

			dat += "<br><b>头像:</b> <a href='?_src_=prefs;preference=headshot;task=input'>更改</a>"
			if(headshot_link != null)
				dat += "<br><img src='[headshot_link]' width='100px' height='100px'>"

			dat += "<br><b>[(length(flavortext) < MINIMUM_FLAVOR_TEXT) ? "<font color = '#802929'>" : ""]风味文本:[(length(flavortext) < MINIMUM_FLAVOR_TEXT) ? "</font>" : ""]</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=flavortext;task=input'>更改</a>"
			dat += "<br><b>NSFW风味文本:</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=nsfwflavortext;task=input'>更改</a>"
			dat += "<br><b>[(length(ooc_notes) < MINIMUM_OOC_NOTES) ? "<font color = '#802929'>" : ""]OOC备注:[(length(ooc_notes) < MINIMUM_OOC_NOTES) ? "</font>" : ""]</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=ooc_notes;task=input'>更改</a>"

			// Rumours / Gossip
			dat += "<br><b>传闻与贵族流言:</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><br><a href='?_src_=prefs;preference=rumour;task=input'>设置传闻</a><a href='?_src_=prefs;preference=gossip;task=input'>设置流言</a><a href='?_src_=prefs;preference=rumour_preview;task=input'><i>预览</i></a>"

			dat += "<br><b>ERP偏好:</b><a href='?_src_=prefs;preference=formathelp;task=input'>(?)</a><a href='?_src_=prefs;preference=erpprefs;task=input'>更改</a>"
			dat += "<br><b>歌曲:</b> <a href='?_src_=prefs;preference=ooc_extra;task=input'>更改URL</a>"
			dat += "<a href='?_src_=prefs;preference=change_title;task=input'>更改标题</a>"
			dat += "<a href='?_src_=prefs;preference=change_artist;task=input'>更改艺术家</a>"
			dat += "<br><b>OOC额外图片/视频/GIF（风味文本）:</b> <a href='?_src_=prefs;preference=ooc_extra_img;task=input'>更改</a>"
			if(ooc_extra_img_link != null)
				dat += "<br><img src='[ooc_extra_img_link]' width='100px' height='100px'>"
			dat += "<br><b>NSFW OOC额外图片/视频/GIF（风味文本）:</b> <a href='?_src_=prefs;preference=nsfw_ooc_extra_img;task=input'>更改</a>"
			if(nsfw_ooc_extra_img_link != null)
				dat += "<br><img src='[nsfw_ooc_extra_img_link]' width='100px' height='100px'>"
			dat += "<br><B>图片库:</b> <a href='?_src_=prefs;preference=img_gallery;task=input'>添加</a>"
			dat+= "<a href='?_src_=prefs;preference=clear_gallery;task=input'>清空图片库</a>"
			dat += "<br><B>NSFW图片库:</b> <a href='?_src_=prefs;preference=nsfw_img_gallery;task=input'>添加</a>"
			dat+= "<a href='?_src_=prefs;preference=clear_nsfw_gallery;task=input'>清空NSFW图片库</a>"
			dat += "<br><a href='?_src_=prefs;preference=ooc_preview;task=input'><b>预览查看</b></a>"

			dat += "</td>"

			dat += "</tr></table>"
//			-----------END OF BODY TABLE-----------
			dat += "</td>"
			dat += "</tr>"
			dat += "</table>"

		if (1) // Game Preferences
			used_title = "设置"
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>常规设置</h2>"
//			dat += "<b>UI Style:</b> <a href='?_src_=prefs;task=input;preference=ui'>[UI_style]</a><br>"
			dat += "<b>tgui 显示器:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "主显示器" : "所有"]</a><br>"
//			dat += "<b>tgui Style:</b> <a href='?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy" : "No Frills"]</a><br>"
//			dat += "<b>Show Runechat Chat Bubbles:</b> <a href='?_src_=prefs;preference=chat_on_map'>[chat_on_map ? "Enabled" : "Disabled"]</a><br>"
//			dat += "<b>Runechat message char limit:</b> <a href='?_src_=prefs;preference=max_chat_length;task=input'>[max_chat_length]</a><br>"
//			dat += "<b>See Runechat for non-mobs:</b> <a href='?_src_=prefs;preference=see_chat_non_mob'>[see_chat_non_mob ? "Enabled" : "Disabled"]</a><br>"
//			dat += "<br>"
//			dat += "<b>Action Buttons:</b> <a href='?_src_=prefs;preference=action_buttons'>[(buttons_locked) ? "Locked In Place" : "Unlocked"]</a><br>"
//			dat += "<b>Hotkey mode:</b> <a href='?_src_=prefs;preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Default"]</a><br>"
//			dat += "<br>"
//			dat += "<b>PDA Color:</b> <span style='border:1px solid #161616; background-color: [pda_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=pda_color;task=input'>Change</a><BR>"
//			dat += "<b>PDA Style:</b> <a href='?_src_=prefs;task=input;preference=pda_style'>[pda_style]</a><br>"
//			dat += "<br>"
//			dat += "<b>Ghost Ears:</b> <a href='?_src_=prefs;preference=ghost_ears'>[(chat_toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</a><br>"
//			dat += "<b>Ghost Radio:</b> <a href='?_src_=prefs;preference=ghost_radio'>[(chat_toggles & CHAT_GHOSTRADIO) ? "All Messages":"No Messages"]</a><br>"
//			dat += "<b>Ghost Sight:</b> <a href='?_src_=prefs;preference=ghost_sight'>[(chat_toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</a><br>"
//			dat += "<b>Ghost Whispers:</b> <a href='?_src_=prefs;preference=ghost_whispers'>[(chat_toggles & CHAT_GHOSTWHISPER) ? "All Speech" : "Nearest Creatures"]</a><br>"
//			dat += "<b>Ghost PDA:</b> <a href='?_src_=prefs;preference=ghost_pda'>[(chat_toggles & CHAT_GHOSTPDA) ? "All Messages" : "Nearest Creatures"]</a><br>"

/*			if(unlock_content)
				dat += "<b>Ghost Form:</b> <a href='?_src_=prefs;task=input;preference=ghostform'>[ghost_form]</a><br>"
				dat += "<B>Ghost Orbit: </B> <a href='?_src_=prefs;task=input;preference=ghostorbit'>[ghost_orbit]</a><br>"

			var/button_name = "If you see this something went wrong."
			switch(ghost_accs)
				if(GHOST_ACCS_FULL)
					button_name = GHOST_ACCS_FULL_NAME
				if(GHOST_ACCS_DIR)
					button_name = GHOST_ACCS_DIR_NAME
				if(GHOST_ACCS_NONE)
					button_name = GHOST_ACCS_NONE_NAME

			dat += "<b>Ghost Accessories:</b> <a href='?_src_=prefs;task=input;preference=ghostaccs'>[button_name]</a><br>"

			switch(ghost_others)
				if(GHOST_OTHERS_THEIR_SETTING)
					button_name = GHOST_OTHERS_THEIR_SETTING_NAME
				if(GHOST_OTHERS_DEFAULT_SPRITE)
					button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
				if(GHOST_OTHERS_SIMPLE)
					button_name = GHOST_OTHERS_SIMPLE_NAME

			dat += "<b>Ghosts of Others:</b> <a href='?_src_=prefs;task=input;preference=ghostothers'>[button_name]</a><br>"
			dat += "<br>"

			dat += "<b>Income Updates:</b> <a href='?_src_=prefs;preference=income_pings'>[(chat_toggles & CHAT_BANKCARD) ? "Allowed" : "Muted"]</a><br>"
			dat += "<br>"
*/
			dat += "<b>帧率 (FPS):</b> <a href='?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"
/*
			dat += "<b>Parallax (Fancy Space):</b> <a href='?_src_=prefs;preference=parallaxdown' oncontextmenu='window.location.href=\"?_src_=prefs;preference=parallaxup\";return false;'>"
			switch (parallax)
				if (PARALLAX_LOW)
					dat += "Low"
				if (PARALLAX_MED)
					dat += "Medium"
				if (PARALLAX_INSANE)
					dat += "Insane"
				if (PARALLAX_DISABLE)
					dat += "Disabled"
				else
					dat += "High"
			dat += "</a><br>"
*/
//			dat += "<b>Fit Viewport:</b> <a href='?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
//			if (CONFIG_GET(string/default_view) != CONFIG_GET(string/default_view_square))
//				dat += "<b>Widescreen:</b> <a href='?_src_=prefs;preference=widescreenpref'>[widescreenpref ? "Enabled ([CONFIG_GET(string/default_view)])" : "Disabled ([CONFIG_GET(string/default_view_square)])"]</a><br>"

/*			if (CONFIG_GET(flag/maprotation))
				var/p_map = preferred_map
				if (!p_map)
					p_map = "Default"
					if (config.defaultmap)
						p_map += " ([config.defaultmap.map_name])"
				else
					if (p_map in config.maplist)
						var/datum/map_config/VM = config.maplist[p_map]
						if (!VM)
							p_map += " (No longer exists)"
						else
							p_map = VM.map_name
					else
						p_map += " (No longer exists)"
				if(CONFIG_GET(flag/preference_map_voting))
					dat += "<b>Preferred Map:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[p_map]</a><br>"
*/

//			dat += "<b>Play Lobby Music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Enabled":"Disabled"]</a><br>"

			dat += "<b>Preferred Map:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[preferred_map || "Default"]</a><br>"
			dat += "</td><td width='300px' height='300px' valign='top'>"

			dat += "<h2>特殊角色设置</h2>"

			if(is_banned_from(user.ckey, ROLE_SYNDICATE))
				dat += "<font color=red><b>我已被禁止担任反派角色。</b></font><br>"
				src.be_special = list()


			for (var/i in GLOB.special_roles_rogue)
				if(is_banned_from(user.ckey, i))
					dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;bancheck=[i]'>已被封禁</a><br>"
				else
					var/days_remaining = null
					if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
						days_remaining = get_remaining_days(user.client)

					if(days_remaining)
						dat += "<b>[capitalize(i)]:</b> <font color=red> \[[days_remaining] 天后解锁]</font><br>"
					else
						dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[(i in be_special) ? "开启" : "关闭"]</a><br>"
//			dat += "<br>"
//			dat += "<b>Midround Antagonist:</b> <a href='?_src_=prefs;preference=allow_midround_antag'>[(toggles & MIDROUND_ANTAG) ? "Enabled" : "Disabled"]</a><br>"
			dat += "</td></tr></table>"

		if(2) //OOC Preferences
			used_title = "ooc"
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>OOC 设置</h2>"
			dat += "<b>窗口闪烁提示:</b> <a href='?_src_=prefs;preference=winflash'>[(windowflashing) ? "开启":"关闭"]</a><br>"
			dat += "<br>"
			dat += "<b>播放管理员 MIDI 音乐:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "开启":"关闭"]</a><br>"
			dat += "<b>播放大厅音乐:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "开启":"关闭"]</a><br>"
			dat += "<b>接收 Pull Requests 提示:</b> <a href='?_src_=prefs;preference=pull_requests'>[(chat_toggles & CHAT_PULLR) ? "开启":"关闭"]</a><br>"
			dat += "<br>"


			if(user.client)
				if(unlock_content)
					dat += "<b>公开 BYOND 会员身份:</b> <a href='?_src_=prefs;preference=publicity'>[(toggles & MEMBER_PUBLIC) ? "公开" : "隐藏"]</a><br>"

				if(unlock_content || check_rights_for(user.client, R_ADMIN))
					dat += "<b>OOC 文本颜色:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : GLOB.normal_ooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ooccolor;task=input'>更改</a><br>"

			dat += "</td>"

			if(user.client.holder)
				dat +="<td width='300px' height='300px' valign='top'>"

				dat += "<h2>管理员设置</h2>"

				dat += "<b>管理求助提示音 (Adminhelp):</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"开启":"关闭"]</a><br>"
				dat += "<b>祈祷提示音 (Prayer):</b> <a href = '?_src_=prefs;preference=hear_prayers'>[(toggles & SOUND_PRAYERS)?"开启":"关闭"]</a><br>"
				dat += "<b>上线公告提示:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"开启":"关闭"]</a><br>"
				dat += "<br>"
				dat += "<b>全局组合 HUD 照明:</b> <a href = '?_src_=prefs;preference=combohud_lighting'>[(toggles & COMBOHUD_LIGHTING)?"全亮":"不改变"]</a><br>"
				dat += "<br>"
				dat += "<b>隐藏死者聊天栏 (Dead Chat):</b> <a href = '?_src_=prefs;preference=toggle_dead_chat'>[(chat_toggles & CHAT_DSAY)?"显示":"隐藏"]</a><br>"
				dat += "<b>隐藏无线电消息:</b> <a href = '?_src_=prefs;preference=toggle_radio_chatter'>[(chat_toggles & CHAT_RADIO)?"显示":"隐藏"]</a><br>"
				dat += "<b>隐藏祈祷消息:</b> <a href = '?_src_=prefs;preference=toggle_prayers'>[(chat_toggles & CHAT_PRAYER)?"显示":"隐藏"]</a><br>"
				if(CONFIG_GET(flag/allow_admin_asaycolor))
					dat += "<br>"
					dat += "<b>ASAY 颜色:</b> <span style='border: 1px solid #161616; background-color: [asaycolor ? asaycolor : "#FF4500"];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=asaycolor;task=input'>更改</a><br>"

				//deadmin
				dat += "<h2>游玩时卸任管理</h2>"
				if(CONFIG_GET(flag/auto_deadmin_players))
					dat += "<b>游玩时总是卸任:</b> 强制执行</a><br>"
				else
					dat += "<b>游玩时总是卸任:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_always'>[(toggles & DEADMIN_ALWAYS)?"开启":"关闭"]</a><br>"
					if(!(toggles & DEADMIN_ALWAYS))
						dat += "<br>"
						if(!CONFIG_GET(flag/auto_deadmin_antagonists))
							dat += "<b>作为反派时:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_antag'>[(toggles & DEADMIN_ANTAGONIST)?"卸任管理":"保留管理"]</a><br>"
						else
							dat += "<b>作为反派时:</b> 强制执行<br>"

						if(!CONFIG_GET(flag/auto_deadmin_heads))
							dat += "<b>作为指挥官时:</b> <a href = '?_src_=prefs;preference=toggle_deadmin_head'>[(toggles & DEADMIN_POSITION_HEAD)?"卸任管理":"保留管理"]</a><br>"
						else
							dat += "<b>作为指挥官时:</b> 强制执行<br>"

				dat += "</td>"
			dat += "</tr></table>"

		if(3) // Custom keybindings
			used_title = "键位绑定"
			// Create an inverted list of keybindings -> key
			var/list/user_binds = list()
			for (var/key in key_bindings)
				for(var/kb_name in key_bindings[key])
					user_binds[kb_name] += list(key)

			var/list/kb_categories = list()
			// Group keybinds by category
			for (var/name in GLOB.keybindings_by_name)
				var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
				kb_categories[kb.category] += list(kb)

			dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

			for (var/category in kb_categories)
				for (var/i in kb_categories[category])
					var/datum/keybinding/kb = i
					if(!length(user_binds[kb.name]))
						dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
//						var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
//						if(LAZYLEN(default_keys))
//							dat += "| Default: [default_keys.Join(", ")]"
						dat += "<br>"
					else
						var/bound_key = user_binds[kb.name][1]
						dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						for(var/bound_key_index in 2 to length(user_binds[kb.name]))
							bound_key = user_binds[kb.name][bound_key_index]
							dat += " | <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
							dat += "| <a href ='?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name]'>添加次要键位</a>"
						var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
						if(LAZYLEN(default_keys))
							dat += "| 默认: [default_keys.Join(", ")]"
						dat += "<br>"

			dat += "<br><br>"
			dat += "<a href ='?_src_=prefs;preference=keybinds;task=keybindings_set'>\[恢复默认值\]</a>"
			dat += "</body>"


	if(!IsGuestKey(user.key))
		dat += "<a href='?_src_=prefs;preference=save'>保存设置</a><br>"
		dat += "<a href='?_src_=prefs;preference=load'>撤销更改</a><br>"

	// well.... one empty slot here for something I suppose lol
	dat += "<table width='100%'>"
	dat += "<tr>"
	dat += "<td width='33%' align='left'>"
	dat += "<b>环境光遮蔽 (AO):</b> <a href='?_src_=prefs;preference=ambientocclusion'>[ambientocclusion ? "开启" : "关闭"]</a><br>"
	dat += "</td>"
	dat += "<td width='33%' align='center'>"
	var/mob/dead/new_player/N = user
	if(istype(N))
		//dat += "<a href='?_src_=prefs;preference=bespecial'><b>[next_special_trait ? "<font color='red'>SPECIAL</font>" : "Be Special"]</b></a><BR>"
		if(SSticker.current_state <= GAME_STATE_PREGAME)
			switch(N.ready)
				if(PLAYER_NOT_READY)
					dat += "<b>未就绪</b> <a href='byond://?src=[REF(N)];ready=[PLAYER_READY_TO_PLAY]'>准备就绪</a>"
				if(PLAYER_READY_TO_PLAY)
					dat += "<a href='byond://?src=[REF(N)];ready=[PLAYER_NOT_READY]'>取消准备</a> <b>已就绪</b>"
					log_game("([user || "NO KEY"]) readied as ([real_name])")
		else
			if(!is_active_migrant())
				dat += "<a href='byond://?src=[REF(N)];late_join=1'>局中加入</a>"
			else
				dat += "<a class='linkOff' href='byond://?src=[REF(N)];late_join=1'>局中加入</a>"
			dat += " - <a href='?_src_=prefs;preference=migrants'>移民设置</a>"
			dat += "<br><a href='?_src_=prefs;preference=manifest'>名单</a>"
			dat += " - <a href='?_src_=prefs;preference=observe'>旁观比赛</a>"
	else
		dat += "<a href='?_src_=prefs;preference=finished'>完成</a>"

	dat += "</td>"
	dat += "<td width='33%' align='right'>"
	dat += "<b>成为心之声:</b> <a href='?_src_=prefs;preference=schizo_voice'>[(toggles & SCHIZO_VOICE) ? "开启":"关闭"]</a>"
	dat += "<br><b>切换管理员声音:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "开启":"关闭"]</a>"
	dat += "</td>"
	dat += "</tr>"
	dat += "</table>"
//	dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"


	if(user.client?.is_new_player())
		dat = list("<center>请注册！</center>")

	winshow(user, "preferencess_window", TRUE)
	winset(user, "preferencess_window", "size=820x850")
	winset(user, "preferencess_window", "pos=280,80")
	var/datum/browser/noclose/popup = new(user, "preferences_browser", "<div align='center'>[used_title]</div>")
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)
	update_preview_icon()
//	onclose(user, "preferencess_window", src)

#undef APPEARANCE_CATEGORY_COLUMN
#undef MAX_MUTANT_ROWS

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>按键绑定: [kb.full_name]<br>[kb.description]<br><br><b>按下任意键进行更改<br>按下 ESC 键清除当前绑定</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var main_key = e.key;
		switch (main_key){
			case '#':main_key = '%23';
			break;
			case '&':main_key = '%26';
			break;
			case '=':main_key = '%3D';
			break;
		};
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybinds;task=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+main_key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/noclose/popup = new(user, "capturekeypress", "<div align='center'>按键绑定</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/SetChoices(mob/user, limit = 14, list/splitJobs = list("宫廷法师", "骑士团长", "主教", "商人", "档案保管员", "镇民", "格伦泽霍夫雇佣兵", "乞丐", "囚犯", "地精王"), widthPerColumn = 295, height = 620) //295 620
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
//		HTML += "The job SSticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>完成</a></center><br>" // Easier to press up here.

	else
//		HTML += "<b>Choose class preferences</b><br>"
//		HTML += "<div align='center'>Left-click to raise a class preference, right-click to lower it.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>完成</a></center>" // Easier to press up here.
		if(joblessrole != RETURNTOLOBBY && joblessrole != BERANDOMJOB) // this is to catch those that used the previous definition and reset.
			joblessrole = RETURNTOLOBBY
		HTML += "<i>点击已解锁的职业获取更多信息</i><br>"
		HTML += "<b>若该角色不可用:</b><font color='purple'><a href='?_src_=prefs;preference=job;task=nojob'>[joblessrole]</a></font><BR>"
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob
		for(var/datum/job/job in sortList(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))
			if(!job.spawn_positions)
				continue

			index += 1
//			if((index >= limit) || (job.title in splitJobs))
			if(index >= limit)
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='#000000'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			if(job.title in splitJobs)
				HTML += "<tr bgcolor='#000000'><td width='60%' align='right'><hr></td></tr>"

			HTML += "<tr bgcolor='#000000'><td width='60%' align='right'>"
			var/rank = job.title
			var/used_name = job.display_title || job.title
			if((pronouns == SHE_HER || pronouns == THEY_THEM_F) && job.f_title)
				used_name = "[job.f_title]"
			lastJob = job
			if(is_banned_from(user.ckey, rank))
				HTML += "[used_name]</td> <td><a href='?_src_=prefs;bancheck=[rank]'> 已被封禁</a></td></tr>"
				continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				HTML += "[used_name]</td> <td><font color=red> \[ 还需要作为 [job.get_exp_req_type()] 游玩 [get_exp_format(required_playtime_remaining)] \] </font></td></tr>"
				continue
			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "[used_name]</td> <td><font color=red> \[[available_in_days] 天后可用\]</font></td></tr>"
				continue
			#ifdef USES_PQ
			if(!job.required && !isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
				HTML += "<font color=#a59461>[used_name] (最低 PQ 限制: [job.min_pq])</font></td> <td> </td></tr>"
				continue
			#endif
			if(!job.required && !isnull(job.max_pq) && (get_playerquality(user.ckey) > job.max_pq))
				HTML += "<font color=#a59461>[used_name] (最高 PQ 限制: [job.max_pq])</font></td> <td> </td></tr>"
				continue
			if(length(job.virtue_restrictions) && length(job.vice_restrictions))
				var/name
				if(virtue.type in job.virtue_restrictions)
					name = virtue.name
				if(virtuetwo?.type in job.virtue_restrictions)
					if(name)
						name += ", "
						name += virtuetwo.name
					else
						name = virtuetwo.name
				// Check all vices
				for(var/datum/charflaw/vice in list(vice1, vice2, vice3, vice4, vice5, charflaw))
					if(vice?.type in job.vice_restrictions)
						if(name)
							name += ", "
							name += vice.name
						else
							name = vice.name
				if(!isnull(name))
					HTML += "<font color='#a561a5'>[used_name] (因美德/恶习冲突而被禁止: [name])</font></td> <td> </td></tr>"
			if(length(job.virtue_restrictions))
				var/name
				if(virtue.type in job.virtue_restrictions)
					name = virtue.name
				if(virtuetwo?.type in job.virtue_restrictions)
					if(name)
						name += ", "
						name += virtuetwo.name
					else
						name = virtuetwo.name
				if(!isnull(name))
					HTML += "<font color='#a59461'>[used_name] (因美德冲突而被禁止: [name])</font></td> <td> </td></tr>"
					continue
			if(length(job.vice_restrictions))
				var/list/restricted_vices = list()
				// Check all vices
				for(var/datum/charflaw/vice in list(vice1, vice2, vice3, vice4, vice5, charflaw))
					if(vice?.type in job.vice_restrictions)
						restricted_vices += vice.name
				if(length(restricted_vices))
					HTML += "<font color='#a56161'>[used_name] (因恶习冲突而被禁止: [restricted_vices.Join(", ")])</font></td> <td> </td></tr>"
					continue
			var/job_unavailable = JOB_AVAILABLE
			if(isnewplayer(parent?.mob))
				var/mob/dead/new_player/new_player = parent.mob
				job_unavailable = new_player.IsJobUnavailable(job.title, latejoin = FALSE)
			var/static/list/acceptable_unavailables = list(
				JOB_AVAILABLE,
				JOB_UNAVAILABLE_SLOTFULL,
			)
			if(!(job_unavailable in acceptable_unavailables))
				HTML += "<font color=#a36c63>[used_name]</font></td> <td> </td></tr>"
				continue

			var/job_display = used_name
			//job_display += " <a href='?src=[REF(job)];explainjob=1'>{?}</a></span>"
//			if((job_preferences[SSjob.overflow_role] == JP_LOW) && (rank != SSjob.overflow_role) && !is_banned_from(user.ckey, SSjob.overflow_role))
//				HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
//				continue
/*			if((rank in GLOB.command_positions) || (rank == "AI"))//Bold head jobs
				HTML += "<b><span class='dark'><a href='?_src_=prefs;preference=job;task=tutorial;tut='[job.tutorial]''>[used_name]</a></span></b>"
			else
				HTML += span_dark("<a href='?_src_=prefs;preference=job;task=tutorial;tut='[job.tutorial]''>[used_name]</a>")*/

			HTML += {"

<style>


.tutorialhover {
	position: relative;
	display: inline-block;
	border-bottom: 1px dotted black;
}

.tutorialhover .tutorial {

	visibility: hidden;
	width: 280px;
	background-color: black;
	color: #e3c06f;
	text-align: center;
	border-radius: 6px;
	padding: 5px 0;

	position: absolute;
	z-index: 1;
	top: 100%;
	left: 50%;
	margin-left: -140px;
}

.tutorialhover:hover .tutorial{
	visibility: visible;
}

</style>

<div class="tutorialhover"> [job.class_setup_examine ? "<a href='?src=[REF(job)];explainjob=1'><font>[job_display]</font></a>" : "<font>[job_display]</font>"]</span>
<span class="tutorial">[job.tutorial]<br>
Slots: [job.spawn_positions] [job.round_contrib_points ? "RCP: +[job.round_contrib_points]" : ""]</span>
</div>

			"}

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			switch(job_preferences[job.title])
				if(JP_HIGH)
					prefLevelLabel = "高"
					prefLevelColor = "slateblue"
					prefUpperLevel = 4
					prefLowerLevel = 2
					var/mob/dead/new_player/P = user
					if(istype(P))
						P.topjob = job.title
				if(JP_MEDIUM)
					prefLevelLabel = "中"
					prefLevelColor = "green"
					prefUpperLevel = 1
					prefLowerLevel = 3
				if(JP_LOW)
					prefLevelLabel = "低"
					prefLevelColor = "orange"
					prefUpperLevel = 2
					prefLowerLevel = 4
				else
					prefLevelLabel = "无"
					prefLevelColor = "red"
					prefUpperLevel = 3
					prefLowerLevel = 1

			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

//			if(rank == SSjob.overflow_role)//Overflow is special
//				if(job_preferences[SSjob.overflow_role] == JP_LOW)
//					HTML += "<font color=green>Yes</font>"
//				else
//					HTML += "<font color=red>No</font>"
//				HTML += "</a></td></tr>"
//				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='000000'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table><br>"

//		var/message = "Be an [SSjob.overflow_role] if preferences unavailable"
//		if(joblessrole == BERANDOMJOB)
//			message = "Get random job if preferences unavailable"
//		else if(joblessrole == RETURNTOLOBBY)
//			message = "Return to lobby if preferences unavailable"
//		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		if(user.client.prefs.lastclass)
			HTML += "<center><a href='?_src_=prefs;preference=job;task=triumphthing'>再次以 [user.client.prefs.lastclass] 游玩</a></center>"
		else
			HTML += "<br>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>重置</a></center>"

	var/datum/browser/noclose/popup = new(user, "mob_occupation", "<div align='center'>职业选择</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH) // to high
		//Set all other high to medium
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
				//technically break here

	job_preferences[job.title] = level
	return TRUE

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user,4)
		return

	if (!isnum(desiredLvl))
		to_chat(user, span_danger("UpdateJobPreference - desired level was not a number. Please notify coders!"))
		ShowChoices(user,4)
		return

	var/jpval = null
	switch(desiredLvl)
		if(3)
			jpval = JP_LOW
		if(2)
			jpval = JP_MEDIUM
		if(1)
			jpval = JP_HIGH

	#ifdef USES_PQ
	if(job.required && !isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
		if(job_preferences[job.title] == JP_LOW)
			jpval = null
		else
			var/used_name = job.display_title || job.title
			if((pronouns == SHE_HER || pronouns == THEY_THEM_F) && job.f_title)
				used_name = "[job.f_title]"
			to_chat(user, "<font color='red'>你的 PQ 对于 [used_name] 来说太低（最低 PQ：[job.min_pq]），你只能将其设为低。</font>")
			jpval = JP_LOW
	#endif

	SetJobPreferenceLevel(job, jpval)
	SetChoices(user)

	return 1


/datum/preferences/proc/ResetJobs()
	job_preferences = list()

/datum/preferences/proc/ResetLastClass(mob/user)
	if(user.client?.prefs)
		if(!user.client.prefs.lastclass)
			return
	var/choice = tgalert(user, "使用 2 胜利点再次以该职业游玩？", "重置上次职业", "确认", "取消")
	if(choice == "取消")
		return
	if(!choice)
		return
	if(user.client?.prefs)
		if(user.client.prefs.lastclass)
			if(user.get_triumphs() < 2)
				to_chat(user, span_warning("我的胜利点不足。"))
				return
			user.adjust_triumphs(-2)
			user.client.prefs.lastclass = null
			user.client.prefs.save_preferences()

/datum/preferences/proc/SetKeybinds(mob/user, return_to_prefs = null)
	if(!isnull(return_to_prefs))
		keybinds_return_to_prefs = !!return_to_prefs
	var/return_flag = keybinds_return_to_prefs ? 1 : 0
	var/list/dat = list()
	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)

	var/list/kb_categories = list()
	// Group keybinds by category
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		kb_categories[kb.category] += list(kb)

	dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

	dat += "<center><a href='?_src_=prefs;preference=keybinds;task=close;return_to_prefs=[return_flag]'>完成</a></center><br>"
	for (var/category in kb_categories)
		for (var/i in kb_categories[category])
			var/datum/keybinding/kb = i
			if(!length(user_binds[kb.name]))
				dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=["未绑定"]'>未绑定</a>"
//						var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
//						if(LAZYLEN(default_keys))
//							dat += "| Default: [default_keys.Join(", ")]"
				dat += "<br>"
			else
				var/bound_key = user_binds[kb.name][1]
				dat += "<label>[kb.full_name]</label> <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				for(var/bound_key_index in 2 to length(user_binds[kb.name]))
					bound_key = user_binds[kb.name][bound_key_index]
					dat += " | <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
					dat += "| <a href ='?_src_=prefs;preference=keybinds;task=keybindings_capture;keybinding=[kb.name]'>添加副键</a>"
				dat += "<br>"

	dat += "<br><br>"
	dat += "<a href ='?_src_=prefs;preference=keybinds;task=keybindings_reset'>\[重置为默认\]</a>"
	dat += "</body>"

	var/datum/browser/noclose/popup = new(user, "keybind_setup", "<div align='center'>按键绑定</div>", 600, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/SetAntag(mob/user)
	var/list/dat = list()

	dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

	dat += "<center><a href='?_src_=prefs;preference=antag;task=close'>完成</a></center><br>"


	if(is_banned_from(user.ckey, ROLE_SYNDICATE))
		dat += "<font color=red><b>我被禁止担任反派角色。</b></font><br>"
		src.be_special = list()


	for (var/i in GLOB.special_roles_rogue)
		if(is_banned_from(user.ckey, i))
			dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;bancheck=[i]'>已封禁</a><br>"
		else
			var/days_remaining = null
			if(ispath(GLOB.special_roles_rogue[i]) && CONFIG_GET(flag/use_age_restriction_for_jobs)) //If it's a game mode antag, check if the player meets the minimum age
				days_remaining = get_remaining_days(user.client)

			if(days_remaining)
				dat += "<b>[capitalize(i)]:</b> <font color=red> \[剩余 [days_remaining] 天]</font><br>"
			else
				dat += "<b>[capitalize(i)]:</b> <a href='?_src_=prefs;preference=antag;task=be_special;be_special_type=[i]'>[(i in be_special) ? "启用" : "禁用"]</a><br>"


	dat += "</body>"

	var/datum/browser/noclose/popup = new(user, "antag_setup", "<div align='center'>特殊角色</div>", 250, 300) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)


/datum/preferences/Topic(href, href_list, hsrc)			//yeah, gotta do this I guess..
	. = ..()
	if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()
	if(href_list["preference"] == "origin_select")
		var/mob/user = usr
		var/chosen_type = text2path(href_list["type"])
		if(chosen_type && (chosen_type in GLOB.origins))
			origin = GLOB.origins[chosen_type]
			save_character()
			user << browse(null, "window=origin_map")
			ShowChoices(user)
			return

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["bancheck"])
		var/list/ban_details = is_banned_from_with_details(user.ckey, user.client.address, user.client.computer_id, href_list["bancheck"])
		var/admin = FALSE
		if(GLOB.admin_datums[user.ckey] || GLOB.deadmins[user.ckey])
			admin = TRUE
		for(var/i in ban_details)
			if(admin && !text2num(i["applies_to_admins"]))
				continue
			ban_details = i
			break //we only want to get the most recent ban's details
		if(ban_details && ban_details.len)
			var/expires = "这是永久封禁。"
			if(ban_details["expiration_time"])
				expires = " 封禁时长为 [DisplayTimeText(text2num(ban_details["duration"]) MINUTES)]，过期时间为 [ban_details["expiration_time"]]（服务器时间）。"
			to_chat(user, span_danger("您或此电脑/连接的其他用户（[ban_details["key"]]）被禁止扮演 [href_list["bancheck"]]。<br>封禁原因：[ban_details["reason"]]<br>此封禁（封禁ID #[ban_details["id"]]）由 [ban_details["admin_key"]] 于 [ban_details["bantime"]] 在游戏轮次 ID [ban_details["round_id"]] 中执行。<br>[expires]"))
			return
	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user,4)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("triumphthing")
				ResetLastClass(user)
			if("nojob")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			if("tutorial")
				if(href_list["tut"])
					testing("[href_list["tut"]]")
					to_chat(user, span_info("* ----------------------- *"))
					to_chat(user, href_list["tut"])
					to_chat(user, span_info("* ----------------------- *"))
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(is_banned_from(user.ckey, SSjob.overflow_role))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BERANDOMJOB
					if(BEOVERFLOW)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = BERANDOMJOB
				SetChoices(user)
			if("setJobLevel")
				if(SSticker.job_change_locked)
					return 1
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			else
				SetChoices(user)
		return 1

	else if(href_list["preference"] == "antag")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=antag_setup")
				ShowChoices(user)
			if("be_special")
				var/be_special_type = href_list["be_special_type"]
				if(be_special_type in be_special)
					be_special -= be_special_type
				else
					be_special += be_special_type
				SetAntag(user)
			if("update")
				SetAntag(user)
			else
				SetAntag(user)
	else if(href_list["preference"] == "tgui_ui_prefs")
		tgui_pref = !tgui_pref
	else if(href_list["preference"] == "triumphs")
		user.show_triumphs_list()

	else if(href_list["preference"] == "playerquality")
		check_pq_menu(user.ckey)

	else if(href_list["preference"] == "agevet")
		if(!user.check_agevet())
			to_chat(usr, span_info("- 您是白名单玩家，可完全访问服务器的所有功能。如果您也想向他人展示您已通过<b>年龄验证</b>（使用经过遮挡的身份证明），可以在 Azure Peak 的 <b>#vet-here</b> 频道提交工单。请注意，这是一个完全可选的过程，除了为您的风味文本添加特殊标题外，不会以任何其他方式影响您。"))
		else
			to_chat(usr, span_love("- 您已成功<b>通过年龄验证！</b>"))

	else if(href_list["preference"] == "culinary")
		show_culinary_ui(user)
		return
	else if(href_list["preference"] == "markings")
		ShowMarkings(user)
		return
	else if(href_list["preference"] == "descriptors")
		show_descriptors_ui(user)
		return

	else if(href_list["preference"] == "customizers")
		ShowCustomizers(user)
		return
	else if(href_list["preference"] == "origin_select")
		var/chosen_type = text2path(href_list["type"])
		if(chosen_type && (chosen_type in GLOB.origins))
			origin = GLOB.origins[chosen_type]
			save_character()
			user << browse(null, "window=origin_map")
			ShowChoices(user)
			return
		return
	else if(href_list["preference"] == "triumph_buy_menu")
		SStriumphs.startup_triumphs_menu(user.client)

	else if(href_list["preference"] == "keybinds")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=keybind_setup")
				if(text2num(href_list["return_to_prefs"]) || keybinds_return_to_prefs)
					ShowChoices(user)
			if("menu")
				SetKeybinds(user, TRUE)
			if("update")
				SetKeybinds(user)
			if("keybindings_capture")
				var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
				var/old_key = href_list["old_key"]
				CaptureKeybinding(user, kb, old_key)
				return

			if("keybindings_set")
				var/kb_name = href_list["keybinding"]
				if(!kb_name)
					user << browse(null, "window=capturekeypress")
					SetKeybinds(user)
					return

				var/clear_key = text2num(href_list["clear_key"])
				var/old_key = href_list["old_key"]
				if(clear_key)
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					user << browse(null, "window=capturekeypress")
					save_preferences()
					SetKeybinds(user)
					return

				var/new_key = uppertext(href_list["key"])
				var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
				var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
				var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
				var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
				// var/key_code = text2num(href_list["key_code"])

				if(GLOB._kbMap[new_key])
					new_key = GLOB._kbMap[new_key]

				var/full_key
				switch(new_key)
					if("Alt")
						full_key = "[new_key][CtrlMod][ShiftMod]"
					if("Ctrl")
						full_key = "[AltMod][new_key][ShiftMod]"
					if("Shift")
						full_key = "[AltMod][CtrlMod][new_key]"
					else
						full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
				if(key_bindings[old_key])
					key_bindings[old_key] -= kb_name
					if(!length(key_bindings[old_key]))
						key_bindings -= old_key
				key_bindings[full_key] += list(kb_name)
				key_bindings[full_key] = sortList(key_bindings[full_key])

				user << browse(null, "window=capturekeypress")
				user.client.update_movement_keys()
				save_preferences()
				SetKeybinds(user)

			if("keybindings_reset")
				var/choice = tgalert(user, "您真的想要重置按键绑定吗？", "设置按键绑定", "确认", "取消")
				if(choice == "取消")
					SetKeybinds(user)
					return
				hotkeys = (choice == "确认")
				key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
				user.client.update_movement_keys()
				SetKeybinds(user)
			else
				SetKeybinds(user)
		return TRUE

	switch(href_list["task"])
		if("change_customizer")
			handle_customizer_topic(user, href_list)
			ShowChoices(user)
			ShowCustomizers(user)
			return
		if("change_marking")
			handle_body_markings_topic(user, href_list)
			ShowChoices(user)
			ShowMarkings(user)
			return
		if("change_descriptor")
			handle_descriptors_topic(user, href_list)
			show_descriptors_ui(user)
			return
		if("change_culinary_preferences")
			handle_culinary_topic(user, href_list)
			show_culinary_ui(user)
			return
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = pick(pref_species.possible_ages)
				if("eyes")
					eye_color = random_eye_color()
				if("s_tone")
					var/list/skins = pref_species.get_skin_list()
					skin_tone = skins[pick(skins)]
				if("species")
					random_species()
				if("bag")
					backpack = pick(GLOB.backpacklist)
				if("suit")
					jumpsuit_style = PREF_SUIT
				if("all")
					random_character(gender, FALSE, FALSE)

		if("input")

			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])

			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = input(user, "感谢支持 BYOND - 选择您的幽灵形态：","感谢支持 BYOND",null) as null|anything in GLOB.ghost_forms
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = input(user, "感谢支持 BYOND - 选择您的幽灵轨道：","感谢支持 BYOND", null) as null|anything in GLOB.ghost_orbits
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("您希望您的幽灵在可能的情况下显示完整饰品，隐藏饰品但仍使用方向精灵（如果可能），还是忽略方向并坚持使用默认精灵？",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("您希望其他人的幽灵按照他们自己的设置显示，作为他们的默认精灵，还是始终显示为默认的白色幽灵？",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = tgui_input_text(user, "此容器的名称？", "身份", real_name, encode = FALSE)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>无效名称。名称长度应为2到[MAX_NAME_LEN]个字符，只能包含 A-Z, a-z, -, ', . 和 ,。</font>")

				if("nickname")
					var/new_name = tgui_input_text(user, "选择您角色的昵称（用于高亮）：", "昵称", nickname, encode = FALSE)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							nickname = new_name
						else
							to_chat(user, "<font color='red'>无效名称。名称长度应为2到[MAX_NAME_LEN]个字符，只能包含 A-Z, a-z, -, ', . 和 ,。</font>")

				if("subclassoutfit")
					var/list/choices = list("无")
					var/datum/job/highest_pref
					for(var/job in job_preferences)
						if(job_preferences[job] > highest_pref)
							highest_pref = SSjob.GetJob(job)
					if(isnull(highest_pref))
						to_chat(user, "<b>我没有将任何职业设为高！</b>")
					if(length(highest_pref.job_subclasses))
						for(var/adv in highest_pref.job_subclasses)
							var/datum/advclass/advpath = adv
							var/datum/advclass/advref = SSrole_class_handler.get_advclass_by_name(initial(advpath.name))
							choices[advref.name] = advref
					if(length(choices))
						var/new_choice = input(user, "选择装备预览：", "装备预览")  as anything in choices|null
						if(new_choice && new_choice != "无")
							preview_subclass = choices[new_choice]
							update_preview_icon()
						else
							preview_subclass = null
							update_preview_icon(jobOnly = TRUE)

//				if("age")
//					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Years Dead") as num|null
//					if(new_age)
//						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("age")
					var/new_age = tgui_input_list(user, "选择您角色的年龄（18-[pref_species.max_age]）", "已活年数", pref_species.possible_ages)
					if(new_age)
						age = new_age
						var/list/hairs
						if((age == AGE_OLD) && (OLDGREY in pref_species.species_traits))
							hairs = pref_species.get_oldhc_list()
						else
							hairs = pref_species.get_hairc_list()
						hair_color = hairs[pick(hairs)]
						facial_hair_color = hair_color
						// LETHALSTONE EDIT: let players know what this shit does stats-wise
						switch (age)
							if (AGE_ADULT)
								to_chat(user, "您处于“壮年”时期，无论这意味着什么，您的存活时间既不会带来加成也不会带来惩罚。")
							if (AGE_MIDDLEAGED)
								to_chat(user, "肌肉酸痛，关节开始迟缓，永生的魔爪开始落在您的肩上。（-1 速度，+1 意志）")
							if (AGE_OLD)
								to_chat(user, "在像 PSYDONIA 这样致命的地方，老年人堪称奇迹……或者是惯常特权阶层的受益者。（-1 力量，-2 速度，-1 感知，-2 体质，+2 智力，+1 坚韧）")
						// LETHALSTONE EDIT END
						ResetJobs()
						family = FAMILY_NONE
						to_chat(user, "<font color='red'>职业已重置。</font>")

				if("map_preference")
					var/list/available_maps = list("Default")

					for(var/map_name in config.maplist)
						available_maps += map_name

					var/new_map = tgui_input_list(user, "Choose your preferred map.", "MAP PREFERENCE", available_maps)

					if(new_map)
						if(new_map == "Default")
							preferred_map = null
						else
							preferred_map = new_map

						to_chat(user, span_notice("Preferred map set to: [new_map]"))

					return
				// LETHALSTONE EDIT: add pronouns
				if ("pronouns")
					var pronouns_input = tgui_input_list(user, "选择您角色的人称代词", "人称代词", GLOB.pronouns_list)
					if(pronouns_input)
						pronouns = pronouns_input
						ResetJobs()
						to_chat(user, "<font color='red'>您角色的人称代词现在为 [pronouns]。</font>")
						to_chat(user, "<font color='red'><b>您的职业已重置。</b></font>")

				// LETHALSTONE EDIT: add voice type selection
				if ("voicetype")
					var voicetype_input = tgui_input_list(user, "选择您角色的语音类型", "语音类型", GLOB.voice_types_list)
					if(voicetype_input)
						voice_type = voicetype_input
						to_chat(user, "<font color='red'>您的角色现在将以 [LOWER_TEXT(voice_type)] 的效果发声。</font>")

				if ("voicepack")
					var/voicepack_input = tgui_input_list(user, "选择您角色的表情语音包", "语音包", GLOB.voice_packs_list)
					if(voicepack_input)
						voice_pack = voicepack_input
						if(voicepack_input != "Default")
							to_chat(user, span_red("<font color='red'>您的角色现在将以 [LOWER_TEXT(voicepack_input)] 的效果发出有声表情。") + span_notice("<br>这将覆盖您的语音身份和职业特定的语音包。</font>"))
						else
							to_chat(user, "<font color='red'>您的角色现在将根据其语音身份以及任何种族/职业特定的语音包发出有声表情。</font>")

				if("taur_type")
					var/list/species_taur_list = pref_species.get_taur_list()
					if(!LAZYLEN(species_taur_list))
						taur_type = null
						to_chat(user, span_bad("该物种没有可用的半人马躯体。"))
						return

					var/list/taur_selection
					if(pref_species.forced_taur)
						taur_selection = list()
					else
						taur_selection = list("无")

					for(var/obj/item/bodypart/taur/tt as anything in pref_species.get_taur_list())
						taur_selection[tt::name] = tt

					var/new_taur_type = tgui_input_list(user, "选择您角色的半人马躯体", "半人马躯体", taur_selection)
					if(!new_taur_type)
						return

					if(new_taur_type == "无")
						taur_type = null
					else
						taur_type = taur_selection[new_taur_type]

					var/obj/item/bodypart/taur/tt = taur_type
					to_chat(user, span_red("您的角色现在拥有 [tt ? tt::name : "没有半人马类型"]。"))

				if("origin")
					open_origin_map(user)
					return

				if("faith")
					var/list/faiths_named = list()
					for(var/path as anything in GLOB.preference_faiths)
						var/datum/faith/faith = GLOB.faithlist[path]
						if(!faith.name)
							continue
						faiths_named[faith.name] = faith
					var/faith_input = tgui_input_list(user, "世界正在腐烂。您信奉何种真理？", "信仰", faiths_named)
					if(faith_input)
						var/datum/faith/faith = faiths_named[faith_input]
						to_chat(user, "<font color='yellow'>信仰：[faith.name]</font>")
						to_chat(user, "背景：[faith.desc]")
						to_chat(user, "<font color='purple'>可能的信徒：[faith.worshippers]</font>")
						selected_patron = GLOB.patronlist[faith.godhead] || GLOB.patronlist[pick(GLOB.patrons_by_faith[faith_input])]

				if("patron")
					var/list/patrons_named = list()
					for(var/path as anything in GLOB.patrons_by_faith[selected_patron?.associated_faith || initial(default_patron.associated_faith)])
						var/datum/patron/patron = GLOB.patronlist[path]
						if(!patron.name)
							continue
						if(patron.disabled_patron)
							continue
						patrons_named[patron.name] = patron
					var/god_input = tgui_input_list(user, "众神之首。", "主神", patrons_named)
					if(god_input)
						selected_patron = patrons_named[god_input]
						to_chat(user, "<font color='yellow'>主神：[selected_patron]</font>")
						to_chat(user, "<font color='#FFA500'>领域：[selected_patron.domain]</font>")
						to_chat(user, "背景：[selected_patron.desc]")
						to_chat(user, "<font color='purple'>可能的信徒：[selected_patron.worshippers]</font>")
						to_chat(user, "<font color='white'>视为美德：[selected_patron.virtues]</font>")
						to_chat(user, "<font color='red'>视为罪恶：[selected_patron.sins]</font>")

				if("combat_music") // if u change shit here look at /client/verb/combat_music() too
					if(!combat_music_helptext_shown)
						to_chat(user, span_notice("<span class='bold'>战斗音乐覆盖</span>\n") + \
						"“默认”以外的选项将覆盖游戏动态为您设置的音乐， \
						该音乐受您的职业、反派状态或某些事件影响。\n\
						您可以稍后通过选项选项卡中的“战斗模式音乐”进行更改。\"</span>")
						combat_music_helptext_shown = TRUE
					var/client/C = user?.client
					if(!C)
						return
					var/datum/combat_music/selected_track = C.pick_combat_music_with_listen(
						"对您而言，信号听起来像：",
						"战斗音乐",
						combat_music?.name,
					)
					if(selected_track)
						combat_music = selected_track
						to_chat(user, span_notice("已选择曲目： <b>[selected_track.name]</b>."))
						if(combat_music.desc)
							to_chat(user, "<i>[combat_music.desc]</i>")
						if(combat_music.credits)
							to_chat(user, span_info("歌曲名称：<b>[combat_music.credits]</b>"))

				if("bdetail")
					var/list/loly = list("还没有。","施工中。","别点我。","别再点了。","不。","耐心点。","迟早的事。")
					to_chat(user, "<font color='red'>[pick(loly)]</font>")
					return

				if("voice")
					var/new_voice = input(user, "选择您角色的语音颜色：", "角色偏好","#"+voice_color) as color|null
					if(new_voice)
						if(color_hex2num(new_voice) < 230)
							to_chat(user, "<font color='red'>这种语音颜色对凡人来说太暗了。</font>")
							return
						voice_color = sanitize_hexcolor(new_voice)

				if("extra_language")
					var/static/list/selectable_languages = list(
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
						/datum/language/merar
					)
					var/list/choices = list("无")
					for(var/language in selectable_languages)
						if(language in pref_species.languages)
							continue
						var/datum/language/a_language = new language()
						choices[a_language.name] = language

					var/chosen_language = tgui_input_list(user, "选择您角色的额外语言：", "额外语言", choices)
					if(chosen_language)
						if(chosen_language == "无")
							extra_language = "None"
						else
							extra_language = choices[chosen_language]


				if("race_title")
					var/list/titles = pref_species.race_titles
					var/list/choices = list("无")
					for(var/A in titles)
						if(A == pref_species.languages)
							continue
						choices += list(A)
					if(user?.client)
						var/result = tgui_input_list(user, "您的同类如何称呼您？", "种族称号", choices)

						if(result)
							if(result == "无")
								selected_title = "None"
							else
								selected_title = result

				if("voice_pitch")
					var/new_voice_pitch = tgui_input_number(user, "选择您角色的语音音调（[MIN_VOICE_PITCH] 到 [MAX_VOICE_PITCH]，数值越低越深沉）：", "语音音调", 1, 1.35, 0.8, round_value = FALSE)
					if(new_voice_pitch)
						if(new_voice_pitch < MIN_VOICE_PITCH || new_voice_pitch > MAX_VOICE_PITCH)
							to_chat(user, "<font color='red'>数值必须在 [MIN_VOICE_PITCH] 和 [MAX_VOICE_PITCH] 之间。</font>")
							return
						voice_pitch = new_voice_pitch

				if("barksound")
					var/list/woof_woof = list()
					for(var/path in GLOB.bark_list)
						var/datum/bark/B = GLOB.bark_list[path]
						if(initial(B.ignore))
							continue
						if(initial(B.ckeys_allowed))
							var/list/allowed = initial(B.ckeys_allowed)
							if(!allowed.Find(user.client.ckey))
								continue
						woof_woof[initial(B.name)] = initial(B.id)
					var/new_bork = input(user, "选择您想要的发声吠叫", "角色偏好") as null|anything in woof_woof
					if(new_bork)
						bark_id = woof_woof[new_bork]
						var/datum/bark/B = GLOB.bark_list[bark_id] //Now we need sanitization to take into account bark-specific min/max values
						bark_speed = round(clamp(bark_speed, initial(B.minspeed), initial(B.maxspeed)), 1)
						bark_pitch = clamp(bark_pitch, initial(B.minpitch), initial(B.maxpitch))
						bark_variance = clamp(bark_variance, initial(B.minvariance), initial(B.maxvariance))

				if("barkspeed")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "选择您想要的吠叫速度（数值越高越慢，越低越快）。最小值：[initial(B.minspeed)]。最大值：[initial(B.maxspeed)]", "角色偏好") as null|num
					if(!isnull(borkset))
						bark_speed = round(clamp(borkset, initial(B.minspeed), initial(B.maxspeed)), 1)

				if("barkpitch")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "选择您想要的基准吠叫音高。最小值：[initial(B.minpitch)]。最大值：[initial(B.maxpitch)]", "角色偏好") as null|num
					if(!isnull(borkset))
						bark_pitch = clamp(borkset, initial(B.minpitch), initial(B.maxpitch))

				if("barkvary")
					var/datum/bark/B = GLOB.bark_list[bark_id]
					var/borkset = input(user, "选择您想要的基准吠叫音高变化。最小值：[initial(B.minvariance)]。最大值：[initial(B.maxvariance)]", "角色偏好") as null|num
					if(!isnull(borkset))
						bark_variance = clamp(borkset, initial(B.minvariance), initial(B.maxvariance))

				if("barkpreview")
					if(SSticker.current_state == GAME_STATE_STARTUP) //Timers don't tick at all during game startup, so let's just give an error message
						to_chat(user, "<span class='warning'>初始化期间无法播放吠叫预览！</span>")
						return
					if(!COOLDOWN_FINISHED(src, bark_previewing))
						return
					if(!parent || !parent.mob)
						return
					COOLDOWN_START(src, bark_previewing, (5 SECONDS))
					var/atom/movable/barkbox = new(get_turf(parent.mob))
					barkbox.set_bark(bark_id)
					var/total_delay = 0
					for(var/i in 1 to (round((32 / bark_speed)) + 1))
						addtimer(CALLBACK(barkbox, TYPE_PROC_REF(/atom/movable, bark), list(parent.mob), 7, 70, BARK_DO_VARY(bark_pitch, bark_variance)), total_delay)
						total_delay += rand(DS2TICKS(bark_speed/4), DS2TICKS(bark_speed/4) + DS2TICKS(bark_speed/4)) TICKS
					QDEL_IN(barkbox, total_delay)

				if("highlight_color")
					var/new_color = color_pick_sanitized(user, "选择您角色的昵称高亮颜色：", "角色偏好","#"+highlight_color)
					if(new_color)
						highlight_color = sanitize_hexcolor(new_color)

				if("headshot")
					to_chat(user, "<span class='notice'>请使用相对无不良内容的头部和肩部区域图像，以保持沉浸感。最后，["<span class='bold'>不要使用真实照片或任何不够严肃的图像。</span>"]</span>")
					to_chat(user, "<span class='notice'>如果照片在游戏内无法正常显示，请确保它是一个可以在浏览器中正常打开的直接图像链接。</span>")
					to_chat(user, "<span class='notice'>请注意，照片将被缩小到 325x325 像素，因此照片越方正，效果越好。</span>")
					var/new_headshot_link = tgui_input_text(user, "输入头像链接（https，支持的主机：gyazo, lensdump, imgbox, catbox）：", "头像", headshot_link,  encode = FALSE)
					if(new_headshot_link == null)
						return
					if(new_headshot_link == "")
						headshot_link = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_headshot_link))
						headshot_link = null
						ShowChoices(user)
						return
					headshot_link = new_headshot_link
					to_chat(user, "<span class='notice'>成功更新头像图片</span>")
					log_game("[user] 已将头像图片设置为 '[headshot_link]'.")
				if("legacyhelp")
					var/list/dat = list()
					dat += "此槽位在主要的风味文本 / OOC 更改之前就已存在。<br>"
					dat += "因此，它被保留旧版以保持其旧的个人资料布局和格式，包括 html。<br>"
					dat += "如果您希望保持原样，<b>您不能再编辑它。</b><br><br>"
					dat += "任何编辑（即使是在未更改的风味文本 / OOC 备注上点击“确定”）都将<font color ='red'><b>不可逆转地</b></font>覆盖所有 html，并移除该槽位的旧版状态。<br>"
					dat += "没有例外。玩得开心！"
					dat += "（您仍然可以添加 OOC 额外内容）"
					var/datum/browser/popup = new(user, "Legacy Help", nwidth = 450, nheight = 250)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("formathelp")
					var/list/dat = list()
					dat +="您可以使用反斜杠 (\\) 来转义特殊字符。<br>"
					dat += "<br>"
					dat += "# 文本 : 定义标题。<br>"
					dat += "|文本| : 居中显示文本。<br>"
					dat += "**文本** : 使文本<b>加粗</b>。<br>"
					dat += "*文本* : 使文本<i>斜体</i>。<br>"
					dat += "^文本^ : 增大文本的<font size = \"4\">尺寸</font>。<br>"
					dat += "((文本)) : 减小文本的<font size = \"1\">尺寸</font>。<br>"
					dat += "* 项目 : 无序列表项。<br>"
					dat += "--- : 添加水平分割线。<br>"
					dat += "-=FFFFFF文本=- : 为文本添加特定的<font color = '#FFFFFF'>颜色</font>。<br><br>"
					dat += "最小风味文本长度：<b>[MINIMUM_FLAVOR_TEXT]</b> 个字符。<br>"
					dat += "最小 OOC 备注长度：<b>[MINIMUM_OOC_NOTES]</b> 个字符。"
					var/datum/browser/popup = new(user, "Formatting Help", nwidth = 400, nheight = 350)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("skin_color_ref_list")
					var/list/dat = list()
					dat +="肤色代码参考列表<br>"
					dat += "<br>"
					for(var/tone in pref_species.get_skin_list_tooltip())
						dat += "[tone]<br>"
					var/datum/browser/popup = new(user, "Formatting Help", nwidth = 400, nheight = 450)
					popup.set_content(dat.Join())
					popup.open(FALSE)
				if("flavortext")
					to_chat(user, "<span class='notice'>["<span class='bold'>风味文本不应包含非物理、非感官的属性，例如背景故事或角色的内心想法。</span>"]</span>")
					var/new_flavortext = tgui_input_text(user, "输入您的角色描述：", "风味文本", flavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_flavortext == null)
						return
					if(new_flavortext == "")
						flavortext = null
						ShowChoices(user)
						return
					flavortext = new_flavortext
					to_chat(user, "<span class='notice'>成功更新风味文本</span>")
					log_game("[user] 已设置其风味文本。")
				if("ooc_notes")
					to_chat(user, "<span class='notice'>["<span class='bold'>OOC 备注应用于角色扮演钩子和关于您角色的一般信息。</span>"]</span>")
					var/new_ooc_notes = tgui_input_text(user, "输入您的 OOC 偏好：", "OOC 备注", ooc_notes, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_ooc_notes == null)
						return
					if(new_ooc_notes == "")
						ooc_notes = null
						ShowChoices(user)
						return
					ooc_notes = new_ooc_notes
					to_chat(user, "<span class='notice'>成功更新 OOC 备注。</span>")
					log_game("[user] 已设置其 OOC 备注。")

				if("rumour")
					to_chat(user, span_notice("谣言是其他人可能知道或自以为了解您的事情，它们不必精确，甚至不必真实。但请记住，它们可以为其他玩家提供如何与您的角色互动甚至思考的提示。\n<b>避免 explicit 的身体描述，但像“经常与人厮混”这样的谣言是可以的。</b>"))
					var/new_rumour = tgui_input_text(user, "输入关于您角色的谣言：（400 字符限制）", "谣言", rumour, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
					if(new_rumour == null)
						return
					if(new_rumour == "")
						rumour = null
						ShowChoices(user)
						return
					if(length(new_rumour) > 400)
						to_chat(user, span_warning("谣言不能超过 400 个字符。"))
						ShowChoices(user)
						return
					rumour = new_rumour
					to_chat(user, span_notice("成功更新谣言"))
					log_game("[user] 已设置其谣言。")

				if("gossip")
					to_chat(user, span_notice("八卦是四处传播的谣言，仅在贵族圈内知晓，只有其他出身高贵的人才知道。与普通谣言类似，八卦不需要精确或真实，但请记住，它可以为其他贵族提供与您角色互动和评判的提示和途径。\n<b>避免 explicit 的身体描述，但像“经常与人厮混”这样的谣言是可以的。</b>"))
					var/new_gossip = tgui_input_text(user, "输入关于您角色的贵族八卦：（400 字符限制）", "贵族八卦", noble_gossip, multiline = TRUE, encode = FALSE, bigmodal = TRUE)
					if(new_gossip == null)
						return
					if(new_gossip == "")
						noble_gossip = null
						ShowChoices(user)
						return
					if(length(new_gossip) > 400)
						to_chat(user, span_notice("贵族八卦不能超过 400 个字符。"))
						ShowChoices(user)
						return
					noble_gossip = new_gossip
					to_chat(user, span_notice("成功更新贵族八卦"))
					log_game("[user] 已设置其贵族八卦。")

				if("nsfwflavortext")
					to_chat(user, "<span class='notice'>["<span class='bold'>NSFW 风味文本可用于设置身体描述和其他可能被视为 explicit 的身体细节。</span>"]</span>")
					to_chat(user, "<font color = '#d6d6d6'>留空以清除。</font>")
					var/new_nsfwflavortext = tgui_input_text(user, "输入您的角色描述：", "NSFW 风味文本", nsfwflavortext, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_nsfwflavortext == null)
						return
					if(new_nsfwflavortext == "")
						new_nsfwflavortext = null
						nsfwflavortext = null
						to_chat(user, "<span class='notice'>成功删除 NSFW 风味文本。</span>")
						ShowChoices(user)
						return
					nsfwflavortext = new_nsfwflavortext
					to_chat(user, "<span class='notice'>成功更新 NSFW 风味文本</span>")
					log_game("[user] 已设置其 NSFW 风味文本。")
				if("erpprefs")
					to_chat(user, "<span class='notice'>["<span class='bold'>色情角色扮演偏好。如果您在这里填写“什么都可以”或“无限制”，如果别人当真了，请不要感到惊讶。</span>"]</span>")
					to_chat(user, "<font color = '#d6d6d6'>留空以清除。</font>")
					var/new_erpprefs = tgui_input_text(user, "输入您的偏好：", "ERP 偏好", erpprefs, multiline = TRUE,  encode = FALSE, bigmodal = TRUE)
					if(new_erpprefs == null)
						return
					if(new_erpprefs == "")
						new_erpprefs = null
						erpprefs = null
						to_chat(user, "<span class='notice'>成功删除 ERP 偏好。</span>")
						ShowChoices(user)
						return
					erpprefs = new_erpprefs
					to_chat(user, "<span class='notice'>成功更新 ERP 偏好。</span>")
					log_game("[user] 已设置其 ERP 偏好。")

				if("img_gallery")

					if(img_gallery.len >= 3)
						to_chat(user, "您的图库中已有三张图片！")
						return

					to_chat(user, "<span class='notice'>请使用["<span class='bold'>您角色的图片</span>"]以保持沉浸感。最后，["<span class='bold'>不要使用真实照片或任何不够严肃的图像。</span>"]</span>")
					to_chat(user, "<span class='notice'>如果照片在游戏内无法正常显示，请确保它是一个可以在浏览器中正常打开的直接图像链接。</span>")
					to_chat(user, "<span class='notice'>请注意，三张图片并排显示并自适应填充水平矩形。因此，垂直图像效果最佳。</span>")
					to_chat(user, "<span class='notice'>您的图库中一次最多只能有["<span class='bold'>三张图片</span>"]。</span>")

					var/new_galleryimg = tgui_input_text(user, "输入图像链接（https，支持的主机：gyazo, lensdump, imgbox, catbox）：", "图库图像",  encode = FALSE)

					if(new_galleryimg == null)
						return
					if(new_galleryimg == "")
						new_galleryimg = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_galleryimg))
						to_chat(user, "<span class='notice'>无效的图像链接。请确保它是来自有效主机（gyazo, lensdump, imgbox, catbox）的直接链接。</span>")
						new_galleryimg = null
						ShowChoices(user)
						return
					img_gallery += new_galleryimg
					to_chat(user, "<span class='notice'>成功将图像添加到图库。</span>")
					log_game("[user] 已向图库添加图像：'[new_galleryimg]'.")

				if("nsfw_img_gallery")

					if(nsfw_img_gallery.len >= 3)
						to_chat(user, "您的 NSFW 图库中已有三张图片！")
						return

					to_chat(user, "<span class='notice'>请使用["<span class='bold'>您角色的图片</span>"]以保持沉浸感。最后，["<span class='bold'>不要使用真实照片或任何不够严肃的图像。</span>"]</span>")
					to_chat(user, "<span class='notice'>如果照片在游戏内无法正常显示，请确保它是一个可以在浏览器中正常打开的直接图像链接。</span>")
					to_chat(user, "<span class='notice'>请注意，三张图片并排显示并自适应填充水平矩形。因此，垂直图像效果最佳。</span>")
					to_chat(user, "<span class='notice'>您的 NSFW 图库中一次最多只能有["<span class='bold'>三张图片</span>"]。</span>")

					var/new_galleryimg = tgui_input_text(user, "输入图像链接（https，支持的主机：gyazo, lensdump, imgbox, catbox）：", "图库图像",  encode = FALSE)

					if(new_galleryimg == null)
						return
					if(new_galleryimg == "")
						new_galleryimg = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_galleryimg))
						to_chat(user, "<span class='notice'>无效的图像链接。请确保它是来自有效主机（gyazo, lensdump, imgbox, catbox）的直接链接。</span>")
						new_galleryimg = null
						ShowChoices(user)
						return
					nsfw_img_gallery += new_galleryimg
					to_chat(user, "<span class='notice'>成功将图像添加到 NSFW 图库。</span>")
					log_game("[user] 已向 NSFW 图库添加图像：'[new_galleryimg]'.")

				if("clear_gallery")
					if(!img_gallery.len)
						to_chat(user, "您的图库中没有要清除的图像！")
						return
					var/dachoice = tgui_alert(user, "您真的要清除图像图库吗？", "清除图库", list("是", "否"))
					if(dachoice == "否")
						ShowChoices(user)
						return
					img_gallery = list()
					to_chat(user, "<span class='notice'>成功清除图像图库。</span>")
					log_game("[user] 已清除其图像图库。")

				if("clear_nsfw_gallery")
					if(!nsfw_img_gallery.len)
						to_chat(user, "您的 NSFW 图库中没有要清除的图像！")
						return
					var/dachoice = tgui_alert(user, "您真的要清除 NSFW 图像图库吗？", "清除 NSFW 图库", list("是", "否"))
					if(dachoice == "否")
						ShowChoices(user)
						return
					nsfw_img_gallery = list()
					to_chat(user, "<span class='notice'>成功清除 NSFW 图像图库。</span>")
					log_game("[user] 已清除其 NSFW 图像图库。")

				if("ooc_preview")
					var/datum/examine_panel/preview_examine_panel = new(user)
					preview_examine_panel.pref = src
					preview_examine_panel.holder = user
					preview_examine_panel.viewing = user
					preview_examine_panel.ui_interact(user)

				if("rumour_preview")
					var/msg = ""
					if(rumour && length(rumour))
						var/rumour_display = rumour
						rumour_display = html_encode(rumour_display)
						rumour_display = parsemarkdown_basic(rumour_display, hyperlink = TRUE)
						msg += "<b>您回想起在镇上听到的关于 [real_name] 的传言...</b><br>[rumour_display]"
					if(length(noble_gossip))
						if(msg)
							msg += "<br><br>"
						var/gossip_display = noble_gossip
						gossip_display = html_encode(gossip_display)
						gossip_display = parsemarkdown_basic(gossip_display, hyperlink = TRUE)
						msg += "<b>您回想起其他蓝血贵族私下议论的关于 [real_name] 的八卦...</b><br>[gossip_display]"
					if(msg)
						to_chat(user, "<span class='info'>[msg]</span>")

				if("ooc_extra")
					to_chat(user, "<span class='notice'>从合适的主机（catbox 等）添加一个 mp3 链接，嵌入到您的风味文本中。</span>")
					to_chat(user, "<span class='notice'>如果歌曲无法正常播放，请确保它是一个可以在浏览器中正常打开的直接链接。</span>")
					to_chat(user, "<font color = '#d6d6d6'>留空以清除您当前的歌曲。</font>")
					to_chat(user, "<font color ='red'>滥用此功能将导致您被禁止。</font>")
					var/new_extra_link = tgui_input_text(user, "输入附件链接（https，主机：catbox）：", "歌曲 URL", ooc_extra, encode = FALSE)
					if(new_extra_link == null)
						return
					if(new_extra_link == "")
						new_extra_link = null
						ooc_extra = null
						to_chat(user, "<span class='notice'>成功删除 OOC 额外内容。</span>")
						ShowChoices(user)
						return
					var/static/list/valid_extensions = list("mp3")
					if(!valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
						new_extra_link = null
						ShowChoices(user)
						return

					var/list/value_split = splittext(new_extra_link, ".")

					// extension will always be the last entry
					var/extension = value_split[length(value_split)]
					if((extension in valid_extensions))
						ooc_extra = new_extra_link
						to_chat(user, "<span class='notice'>成功更新歌曲 URL。</span>")
						log_game("[user] 已将其歌曲 URL 设置为 '[ooc_extra]'.")

				if("change_artist")
					var/new_artist = tgui_input_text(user, "输入您歌曲的艺术家：", "歌曲艺术家", song_artist,  encode = FALSE)
					if(new_artist == null)
						return
					if(new_artist == "")
						ShowChoices(user)
						return
					song_artist = new_artist
					to_chat(user, "<span class='notice'>成功更新歌曲艺术家。</span>")
					log_game("[user] 已设置其歌曲艺术家。")

				if("change_title")
					var/new_title = tgui_input_text(user, "输入您歌曲的标题：", "歌曲标题", song_title,  encode = FALSE)
					if(new_title== null)
						return
					if(new_title == "")
						ShowChoices(user)
						return
					song_title = new_title
					to_chat(user, "<span class='notice'>成功更新歌曲标题。</span>")
					log_game("[user] 已设置其歌曲标题。")

				if("ooc_extra_img")
					to_chat(user, "<span class='notice'>添加将显示在风味文本中的图像/视频链接（jpg, png, gif, mp4）。</span>")
					to_chat(user, "<span class='notice'>图像/视频的宽度受限但高度不限。合适的主机：catbox, discord, gyazo, lensdump, imgbox。</span>")
					to_chat(user, "<font color='#d6d6d6'>留一个空格以删除它。</font>")
					to_chat(user, "<font color='red'>滥用此功能将导致您被禁止。</font>")
					var/link = tgui_input_text(user, "输入图像/视频链接（https）：", "OOC 额外图像", ooc_extra_img_link, encode = FALSE)
					if(link == null)
						return
					if(link == "")
						link = null
						var/choice = tgui_alert(user, "您真的要清除您的 OOC 额外图像/视频/GIF 吗？", "清除 OOC 额外图像/视频/GIF", list("是", "否"))
						if(choice == "否")
							ShowChoices(user)
							return
						ooc_extra_img = null
						ooc_extra_img_link = null
						to_chat(user, "<span class='notice'>成功删除 OOC 额外图像。</span>")
						ShowChoices(user)
						return
					var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4")
					if(!valid_headshot_link(user, link, FALSE, valid_ext))
						link = null
						ShowChoices(user)
						return
					ooc_extra_img_link = link
					var/ext = LOWER_TEXT(splittext(link, ".")[length(splittext(link, "."))])
					var/info
					switch(ext)
						if("jpg", "jpeg", "png", "gif")
							ooc_extra_img = "<div align='center'><br><img src='[link]' style='max-width: 100%;'/></div>"
							info = "一张图像。"
						if("mp4")
							ooc_extra_img = "<div align='center'><br><video style='max-width: 100%;' controls><source src='[link]' type='video/mp4'></video></div>"
							info = "一个视频。"
					to_chat(user, "<span class='notice'>成功使用 [info] 更新 OOC 额外图像。</span>")
					log_game("[user] 已将其 OOC 额外图像设置为 '[link]'.")

				if("nsfw_ooc_extra_img")
					to_chat(user, "<span class='notice'>添加将显示在 NSFW 风味文本中的 NSFW 图像/视频链接（jpg, png, gif, mp4）。</span>")
					to_chat(user, "<span class='notice'>图像/视频的宽度受限但高度不限。合适的主机：catbox, discord, gyazo, lensdump, imgbox。</span>")
					to_chat(user, "<font color='#d6d6d6'>留一个空格以删除它。</font>")
					to_chat(user, "<font color='red'>滥用此功能将导致您被禁止。</font>")
					var/link = tgui_input_text(user, "输入图像/视频链接（https）：", "NSFW OOC 额外图像", nsfw_ooc_extra_img_link, encode = FALSE)
					if(link == null)
						return
					if(link == "")
						link = null
						var/choice = tgui_alert(user, "您真的要清除您的 NSFW OOC 额外图像/视频/GIF 吗？", "清除 NSFW OOC 额外图像/视频/GIF", list("是", "否"))
						if(choice == "否")
							ShowChoices(user)
							return
						nsfw_ooc_extra_img = null
						nsfw_ooc_extra_img_link = null
						to_chat(user, "<span class='notice'>成功删除 NSFW OOC 额外图像。</span>")
						ShowChoices(user)
						return
					var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4")
					if(!valid_headshot_link(user, link, FALSE, valid_ext))
						link = null
						ShowChoices(user)
						return
					nsfw_ooc_extra_img_link = link
					var/ext = LOWER_TEXT(splittext(link, ".")[length(splittext(link, "."))])
					var/info
					switch(ext)
						if("jpg", "jpeg", "png", "gif")
							nsfw_ooc_extra_img = "<div align='center'><br><img src='[link]' style='max-width: 100%;'/></div>"
							info = "一张图像。"
						if("mp4")
							nsfw_ooc_extra_img = "<div align='center'><br><video style='max-width: 100%;' controls><source src='[link]' type='video/mp4'></video></div>"
							info = "一个视频。"
					to_chat(user, "<span class='notice'>成功使用 [info] 更新 NSFW OOC 额外图像。</span>")
					log_game("[user] 已将其 NSFW OOC 额外图像设置为 '[link]'.")

				if("familiar_prefs")
					familiar_prefs.fam_show_ui()

				if("gnoll_prefs")
					gnoll_prefs.gnoll_show_ui(user)

				if("species")
					var/list/species = list()
					for(var/A in GLOB.roundstart_races)
						var/datum/species/race = GLOB.species_list[A]
						race = new race()
						if(user.client)
							if(race.patreon_req > user.client.patreonlevel())
								continue
						else
							continue
						species += race

					species = sortNames(species)

					var/result = tgui_input_list(user, "您被何种形态所束缚？", "种族", species)

					if(result)
						set_new_race(result, user)

				if("update_mutant_colors")
					update_mutant_colors = !update_mutant_colors

				if("dnr")
					dnr_pref = !dnr_pref

				if("charflaw")
					var/list/coom = GLOB.character_flaws.Copy()
					var/result = tgui_input_list(user, "您将承担何种重负？", "缺陷", coom)
					if(result)
						result = coom[result]
						var/datum/charflaw/C = new result()
						charflaw = C
						if(charflaw.desc)
							to_chat(user, "<span class='info'>[charflaw.desc]</span>")

				if("vices_menu")
					open_vices_menu(user)
					return

				if("race_bonus_select")
					if(length(pref_species.custom_selection))
						var/choice = tgui_input_list(user, "命运赐予您的种族何种祝福？", "加成", pref_species.custom_selection)
						if(choice)
							race_bonus = pref_species.custom_selection[choice]

				if("body_size")
					var/new_body_size = tgui_input_number(user, "选择您想要的精灵尺寸：\n([BODY_SIZE_MIN*100]%-[BODY_SIZE_MAX*100]%)，警告：可能使您的角色看起来变形", "角色偏好", features["body_size"]*100)
					if(new_body_size)
						new_body_size = clamp(new_body_size * 0.01, BODY_SIZE_MIN, BODY_SIZE_MAX)
						features["body_size"] = new_body_size

				if("taur_color")
					var/new_taur_color = color_pick_sanitized(user, "选择您角色的半人马颜色：", "角色偏好", "#"+taur_color)
					if(new_taur_color)
						taur_color = sanitize_hexcolor(new_taur_color)

				if("taur_markings")
					var/new_taur_markings = color_pick_sanitized(user, "选择您角色的半人马标记颜色：", "角色偏好", "#"+taur_markings)
					if(new_taur_markings)
						taur_markings = sanitize_hexcolor(new_taur_markings)

				if("taur_tertiary")
					var/new_taur_tertiary = color_pick_sanitized(user, "选择您角色的半人马第三级标记颜色：", "角色偏好", "#"+taur_tertiary)
					if(new_taur_tertiary)
						taur_tertiary = sanitize_hexcolor(new_taur_tertiary)

				if("mutant_color")
					var/new_mutantcolor = color_pick_sanitized(user, "选择您角色的突变色 #1：", "角色偏好","#"+features["mcolor"])
					if(new_mutantcolor)

						features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
						try_update_mutant_colors()

				if("mutant_color2")
					var/new_mutantcolor = color_pick_sanitized(user, "选择您角色的突变色 #2：", "角色偏好","#"+features["mcolor2"])
					if(new_mutantcolor)
						features["mcolor2"] = sanitize_hexcolor(new_mutantcolor)
						try_update_mutant_colors()

				if("mutant_color3")
					var/new_mutantcolor = color_pick_sanitized(user, "选择您角色的突变色 #3：", "角色偏好","#"+features["mcolor3"])
					if(new_mutantcolor)
						features["mcolor3"] = sanitize_hexcolor(new_mutantcolor)
						try_update_mutant_colors()

				if("skin_choice_pick")
					var/prompt = alert(user, "选择皮肤/鳞片颜色",, "自定义", "预设")
					if(prompt == "自定义")
						var/new_mutantcolor = color_pick_sanitized(user, "选择您角色的皮肤/鳞片颜色：", "角色偏好","#"+features["mcolor"])
						if(new_mutantcolor)
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
							try_update_mutant_colors()
					if(prompt == "预设")
						var/listy = pref_species.get_skin_list()
						var/new_mutantcolor = input(user, "选择您角色的肤色：", "肤色")  as null|anything in listy
						if(new_mutantcolor)
							features["mcolor"] = listy[new_mutantcolor]
							try_update_mutant_colors()

/*
				if("color_ethereal")
					var/new_etherealcolor = input(user, "Choose your ethereal color", "Character Preference") as null|anything in GLOB.color_list_ethereal
					if(new_etherealcolor)
						features["ethcolor"] = GLOB.color_list_ethereal[new_etherealcolor]

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in GLOB.legs_list
					if(new_legs)
						features["legs"] = new_legs
*/
				if("s_tone")
					var/listy = pref_species.get_skin_list()
					var/new_s_tone = tgui_input_list(user, "选择您角色的肤色：", "肤色", listy)
					if(new_s_tone)
						skin_tone = listy[new_s_tone]
						try_update_mutant_colors()

				if("charflaw")
					var/selectedflaw
					selectedflaw = tgui_input_list(user, "选择您角色的缺陷：", "缺陷", GLOB.character_flaws)
					if(selectedflaw)
						charflaw = GLOB.character_flaws[selectedflaw]
						charflaw = new charflaw()
						if(charflaw.desc)
							to_chat(user, span_info("[charflaw.desc]"))

				if("char_accent")
					var/selectedaccent = tgui_input_list(user, "选择您角色的口音：", "角色偏好", GLOB.character_accents)
					if(selectedaccent)
						char_accent = selectedaccent
						var/test_message = "你好朋友，是的这很好。我的领主带着仆人和士兵骑马经过；队长和中士守卫着教堂，而弓箭手和骑兵守住北方的道路。我的剑和盾很锋利，水流清爽，我们在告别前感谢公爵。"
						var/preview = apply_accent_preview(selectedaccent, test_message)
						var/preview_text
						if(preview)
							preview_text = "[preview]"
						else
							preview_text = "[test_message]（此口音不使用文本替换）"

						var/list/accent_preview_spans = GLOB.accent_spans?[selectedaccent]
						if(accent_preview_spans?.len)
							var/accent_preview_span = accent_preview_spans[1]
							if(accent_preview_span)
								preview_text = "<span class='[accent_preview_span]'>[preview_text]</span>"

						to_chat(user, span_info("<b>[selectedaccent] 预览：</b> [preview_text]"))

				if("ooccolor")
					var/new_ooccolor = color_pick_sanitized(user, "选择您的 OOC 颜色：", "游戏偏好", ooccolor)
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("asaycolor")
					var/new_asaycolor = color_pick_sanitized(user, "选择您的 ASAY 颜色：", "游戏偏好", asaycolor)
					if(new_asaycolor)
						asaycolor = new_asaycolor

				if("bag")
					var/new_backpack = input(user, "选择您角色的背包风格：", "角色偏好")  as null|anything in GLOB.backpacklist
					if(new_backpack)
						backpack = new_backpack

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SUIT
					else
						jumpsuit_style = PREF_SUIT

				if("uplink_loc")
					var/new_loc = input(user, "选择您角色的叛徒上行链路生成位置：", "角色偏好") as null|anything in GLOB.uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("ai_core_icon")
					var/ai_core_icon = input(user, "选择您偏好的 AI 核心显示屏幕：", "AI 核心显示屏幕选择") as null|anything in GLOB.ai_core_display_screens
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon

				if("sec_dept")
					var/department = input(user, "选择您偏好的安保部门：", "安保部门") as null|anything in GLOB.security_depts_prefs
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/no_preference = "无偏好"
					for(var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]

						if(!VM.votable)
							continue

						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += "（已禁用）"
						maplist[friendlyname] = VM.map_name
					maplist[no_preference] = null
					var/pickedmap = input(user, "选择您偏好的地图。这将用于帮助加权随机地图选择。", "角色偏好")  as null|anything in sortList(maplist)
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/desiredfps = input(user, "选择您想要的 FPS。（0 = 与服务器滴答率同步（当前：[world.fps]））", "角色偏好", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						parent.fps = desiredfps
				if("ui")
					var/pickedui = input(user, "选择您的 UI 样式。", "角色偏好", UI_style)  as null|anything in sortList(GLOB.available_ui_styles)
					if(pickedui)
						UI_style = "Rogue"
						if (parent && parent.mob && parent.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style, src))
				if("pda_style")
					var/pickedPDAStyle = input(user, "选择您的 PDA 样式。", "角色偏好", pda_style)  as null|anything in GLOB.pda_styles
					if(pickedPDAStyle)
						pda_style = pickedPDAStyle
				if("pda_color")
					var/pickedPDAColor = input(user, "选择您的 PDA 界面颜色。", "角色偏好", pda_color) as color|null
					if(pickedPDAColor)
						pda_color = pickedPDAColor

				if("phobia")
					var/phobiaType = input(user, "您害怕什么？", "角色偏好", phobia) as null|anything in SStraumas.phobia_types
					if(phobiaType)
						phobia = phobiaType

		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if ("max_chat_length")
					var/desiredlength = input(user, "选择显示的符文聊天消息的最大字符长度。有效范围是 1 到 [CHAT_MESSAGE_MAX_LENGTH]（默认值：[initial(max_chat_length)]）", "角色偏好", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)
				if("gender")
					var/pickedGender = "male"
					if(gender == "male")
						pickedGender = "female"
					if(pickedGender && pickedGender != gender)
						gender = pickedGender
						to_chat(user, "<font color='red'>您的角色现在将使用 [friendlyGenders[pickedGender]] 精灵。</font>")
						//random_character(gender)
					genderize_customizer_entries()
				if("domhand")
					if(domhand == 1)
						domhand = 2
					else
						domhand = 1
				if("family")
					var/list/famtree_options_list = list(FAMILY_NONE, FAMILY_PARTIAL, FAMILY_NEWLYWED, "向我解释这个")
					if(age != AGE_ADULT)
						famtree_options_list = list(FAMILY_NONE, FAMILY_PARTIAL, FAMILY_NEWLYWED, FAMILY_FULL, "向我解释这个")
					var/new_family = tgui_input_list(user, "选择您英雄的羁绊", "血浓于水", famtree_options_list, family)
					if(new_family == "向我解释这个")
						to_chat(user, span_purple("\
						--[FAMILY_NONE] 将禁用此功能。<br>\
						--[FAMILY_PARTIAL] 将根据您的物种将您分配为当地家族的后代。如果您年龄大于 ADULT，此功能将改为将您分配为当地家族的姑妈或叔父。<br>\
						--[FAMILY_NEWLYWED] 为您分配一个配偶，而不将您添加到家族中。设置配偶将优先将您与另一个具有相同设置配偶名称的新婚配对。<br>\
						--[FAMILY_FULL] 将尝试将您分配为王国/城镇中某个当地家族的女族长或族长。设置配偶将阻止 \
						设置配偶 = 无的玩家与您匹配，除非他们的名称等于您的设置配偶。"))

					else if(new_family)
						family = new_family
						setspouse = null
						gender_choice = ANY_GENDER
						xenophobe_pref = 0
				//Setspouse is part of the family subsystem. It will check existing families for this character and attempt to place you in this family.
				if("setspouse")
					var/newspouse = tgui_input_text(user, "输入另一位英雄的身份", "至死不渝")
					if(newspouse)
						setspouse = newspouse
					else
						setspouse = null
				//Gender_choice is part of the family subsytem. It will check existing families members with the same preference of this character and attempt to place you in this family.
				if("gender_choice")
					// If pronouns are neutral, lock to ANY_GENDER
					if(pronouns == THEY_THEM || pronouns == IT_ITS)
						to_chat(user, span_warning("使用中性代词时，您只能选择 [ANY_GENDER]。"))
						gender_choice = ANY_GENDER
					else
						var/list/gender_choice_option_list = list(ANY_GENDER, SAME_GENDER, DIFFERENT_GENDER)
						var/new_gender_choice  = tgui_input_list(user, "选择您英雄的偏好", "相爱相惜", gender_choice_option_list, gender_choice)
						if(new_gender_choice)
							gender_choice = new_gender_choice
				if("species_choice")
					var/list/restriction_options = list("无限制", "同一种族", "选择特定种族")
					var/choice = tgui_input_list(user, "选择配偶种族限制", "种族限制", restriction_options)
					if(choice == "无限制")
						xenophobe_pref = 0
						restricted_species_pref = null
						to_chat(user, "配偶种族无限制。")
					else if(choice == "同一种族")
						xenophobe_pref = 1
						restricted_species_pref = null
						to_chat(user, "配偶种族将限制为您的种族。")
					else if(choice == "选择特定种族")
						var/list/available_races = list()
						for(var/race_name in GLOB.roundstart_races)
							available_races += race_name
						var/selected_race = tgui_input_list(user, "选择允许的配偶种族", "物种选择", available_races)
						if(selected_race)
							xenophobe_pref = 2
							restricted_species_pref = selected_race
							to_chat(user, "配偶种族将限制为 [selected_race]。")
				if("hotkeys")
					hotkeys = !hotkeys
					if(hotkeys)
						winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_ENABLED]  input.text-color = #EEEEEE")
					else
						winset(user, null, "input.focus=true command=activeInput input.background-color=[COLOR_INPUT_DISABLED]  input.text-color = #ad9eb4")

				if("keybindings_capture")
					var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
					var/old_key = href_list["old_key"]
					CaptureKeybinding(user, kb, old_key)
					return

				if("keybindings_set")
					var/kb_name = href_list["keybinding"]
					if(!kb_name)
						user << browse(null, "window=capturekeypress")
						ShowChoices(user, 3)
						return

					var/clear_key = text2num(href_list["clear_key"])
					var/old_key = href_list["old_key"]
					if(clear_key)
						if(key_bindings[old_key])
							key_bindings[old_key] -= kb_name
							if(!length(key_bindings[old_key]))
								key_bindings -= old_key
						user << browse(null, "window=capturekeypress")
						save_preferences()
						ShowChoices(user, 3)
						return

					var/new_key = uppertext(href_list["key"])
					var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
					var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
					var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
					var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
					// var/key_code = text2num(href_list["key_code"])

					if(GLOB._kbMap[new_key])
						new_key = GLOB._kbMap[new_key]

					var/full_key
					switch(new_key)
						if("Alt")
							full_key = "[new_key][CtrlMod][ShiftMod]"
						if("Ctrl")
							full_key = "[AltMod][new_key][ShiftMod]"
						if("Shift")
							full_key = "[AltMod][CtrlMod][new_key]"
						else
							full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					key_bindings[full_key] += list(kb_name)
					key_bindings[full_key] = sortList(key_bindings[full_key])

					user << browse(null, "window=capturekeypress")
					user.client.update_movement_keys()
					save_preferences()

				if("keybindings_reset")
					var/choice = tgalert(user, "您更喜欢“热键”还是“经典”默认设置？", "设置按键绑定", "热键", "经典", "取消")
					if(choice == "取消")
						ShowChoices(user)
						return
					hotkeys = (choice == "热键")
					key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
					user.client.update_movement_keys()
				if("chat_on_map")
					chat_on_map = !chat_on_map
				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				if("action_buttons")
					buttons_locked = !buttons_locked
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("tgui_theme")
					setTguiStyle()
				if("winflash")
					windowflashing = !windowflashing

				//here lies the badmins
				if("hear_adminhelps")
					user.client.toggleadminhelpsound()
				if("hear_prayers")
					user.client.toggle_prayer_sound()
				if("announce_login")
					user.client.toggleannouncelogin()
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING
				if("toggle_radio_chatter")
					user.client.toggle_hear_radio()
				if("toggle_prayers")
					user.client.toggleprayers()
				if("toggle_deadmin_always")
					toggles ^= DEADMIN_ALWAYS
				if("toggle_deadmin_antag")
					toggles ^= DEADMIN_ANTAGONIST
				if("toggle_deadmin_head")
					toggles ^= DEADMIN_POSITION_HEAD


				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("toggle_random")
					var/random_type = href_list["random_type"]
					if(randomise[random_type])
						randomise -= random_type
					else
						randomise[random_type] = TRUE

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

/* 				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA */

				if("income_pings")
					chat_toggles ^= CHAT_BANKCARD

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = WRAP(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("parallaxdown")
					parallax = WRAP(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					if(parent && parent.screen && parent.screen.len)
						var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in parent.screen
						PM.backdrop(parent.mob)
						PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in parent.screen
						PM.backdrop(parent.mob)
						PM = locate(/atom/movable/screen/plane_master/game_world_above) in parent.screen
						PM.backdrop(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("widescreenpref")
					widescreenpref = !widescreenpref
					user.client.change_view(CONFIG_GET(string/default_view))

				if("schizo_voice")
					toggles ^= SCHIZO_VOICE
					if(toggles & SCHIZO_VOICE)
						to_chat(user, "<span class='warning'>您现在是一个“声音”。\n\
										作为声音，您将收到玩家关于游戏机制的冥想提问！\n\
										回答冥想的好声音将获得 PQ 奖励，而坏声音将由管理层酌情惩罚。</span>")
					else
						to_chat(user, span_warning("您不再是声音。"))

				if("migrants")
					migrant.show_ui()
					return

				if("manifest")
					parent.view_actors_manifest()
					return

				if("observe")
					if(is_banned_from(user.ckey, "Observer"))
						to_chat(user, span_danger("You are banned from observing."))
						return
					var/mob/dead/new_player/P = user
					P.make_me_an_observer()
					return

				if("finished")
					user << browse(null, "window=latechoices") //closes late choices window
					user << browse(null, "window=playersetup") //closes the player setup window
					user << browse(null, "window=preferences") //closes job selection
					user << browse(null, "window=mob_occupation")
					user << browse(null, "window=latechoices") //closes late job selection
					user << browse(null, "window=migration") // Closes migrant menu

					SStriumphs.remove_triumph_buy_menu(user.client)

					winshow(user, "preferencess_window", FALSE)
					user << browse(null, "window=preferences_browser")
					user << browse(null, "window=lobby_window")
					return

				if("save")
					save_preferences()
					save_character()
					to_chat(user, span_notice("角色已保存。"))

				if("load")
					load_preferences()
					load_character()

				if("changeslot")
					var/list/choices = list()
					if(path)
						var/savefile/S = new /savefile(path)
						if(S)
							for(var/i=1, i<=max_save_slots, i++)
								var/name
								S.cd = "/character[i]"
								S["real_name"] >> name
								if(!name)
									name = "槽位[i]"
								choices[name] = i
					var/choice = tgui_input_list(user, "选择一位英雄", "盗贼小镇", choices)
					if(choice)
						choice = choices[choice]
						if(!load_character(choice))
							random_character(null, FALSE, FALSE)
							save_character()

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])

	ShowChoices(user)
	return 1

/datum/preferences/proc/resolve_loadout_to_color(item_path)
	if (loadout && (item_path == loadout.path) && loadout_1_hex && length(loadout_1_hex))
		return loadout_1_hex
	if (loadout2 && (item_path == loadout2.path) && loadout_2_hex && length(loadout_2_hex))
		return loadout_2_hex
	if (loadout3 && (item_path == loadout3.path) && loadout_3_hex && length(loadout_3_hex))
		return loadout_3_hex
	if (loadout4 && (item_path == loadout4.path) && loadout_4_hex && length(loadout_4_hex))
		return loadout_4_hex
	if (loadout5 && (item_path == loadout5.path) && loadout_5_hex && length(loadout_5_hex))
		return loadout_5_hex
	if (loadout6 && (item_path == loadout6.path) && loadout_6_hex && length(loadout_6_hex))
		return loadout_6_hex
	if (loadout7 && (item_path == loadout7.path) && loadout_7_hex && length(loadout_7_hex))
		return loadout_7_hex
	if (loadout8 && (item_path == loadout8.path) && loadout_8_hex && length(loadout_8_hex))
		return loadout_8_hex
	if (loadout9 && (item_path == loadout9.path) && loadout_9_hex && length(loadout_9_hex))
		return loadout_9_hex
	if (loadout10 && (item_path == loadout10.path) && loadout_10_hex && length(loadout_10_hex))
		return loadout_10_hex

	return FALSE

/datum/preferences/proc/resolve_loadout_to_name(item_path)
	if (loadout && (item_path == loadout.path) && loadout_1_name)
		return loadout_1_name
	if (loadout2 && (item_path == loadout2.path) && loadout_2_name)
		return loadout_2_name
	if (loadout3 && (item_path == loadout3.path) && loadout_3_name)
		return loadout_3_name
	if (loadout4 && (item_path == loadout4.path) && loadout_4_name)
		return loadout_4_name
	if (loadout5 && (item_path == loadout5.path) && loadout_5_name)
		return loadout_5_name
	if (loadout6 && (item_path == loadout6.path) && loadout_6_name)
		return loadout_6_name
	if (loadout7 && (item_path == loadout7.path) && loadout_7_name)
		return loadout_7_name
	if (loadout8 && (item_path == loadout8.path) && loadout_8_name)
		return loadout_8_name
	if (loadout9 && (item_path == loadout9.path) && loadout_9_name)
		return loadout_9_name
	if (loadout10 && (item_path == loadout10.path) && loadout_10_name)
		return loadout_10_name

	return FALSE

/datum/preferences/proc/resolve_loadout_to_desc(item_path)
	if (loadout && (item_path == loadout.path) && loadout_1_desc)
		return loadout_1_desc
	if (loadout2 && (item_path == loadout2.path) && loadout_2_desc)
		return loadout_2_desc
	if (loadout3 && (item_path == loadout3.path) && loadout_3_desc)
		return loadout_3_desc
	if (loadout4 && (item_path == loadout4.path) && loadout_4_desc)
		return loadout_4_desc
	if (loadout5 && (item_path == loadout5.path) && loadout_5_desc)
		return loadout_5_desc
	if (loadout6 && (item_path == loadout6.path) && loadout_6_desc)
		return loadout_6_desc
	if (loadout7 && (item_path == loadout7.path) && loadout_7_desc)
		return loadout_7_desc
	if (loadout8 && (item_path == loadout8.path) && loadout_8_desc)
		return loadout_8_desc
	if (loadout9 && (item_path == loadout9.path) && loadout_9_desc)
		return loadout_9_desc
	if (loadout10 && (item_path == loadout10.path) && loadout_10_desc)
		return loadout_10_desc

	return FALSE


/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE, skip_normal_prefs = FALSE)
	if(skip_normal_prefs)
		_load_statpack() /// This should load statpack preferences, I'm at my limit here.
		character.statpack = statpack
		// For gnolls spawning from a non-gnoll base slot, we must not apply any base-slot state.
		// Set species to gnoll immediately so advclass check_requirements can read dna.species.type.
		character.set_species(/datum/species/gnoll, icon_update = FALSE)
		// Set gender to MALE as a neutral default; gnoll pronouns override the displayed pronoun.
		character.gender = MALE
		if(gnoll_prefs?.gnoll_pronouns)
			character.pronouns = gnoll_prefs.gnoll_pronouns
		var/gnoll_name = gnoll_prefs?.ensure_gnoll_name() || "Gnoll"
		character.real_name = gnoll_name
		character.name = gnoll_name
		character.dna.real_name = gnoll_name
		return

	if(randomise[RANDOM_SPECIES] && !character_setup)
		random_species()

	if((randomise[RANDOM_BODY] || randomise[RANDOM_BODY_ANTAG] && antagonist) && !character_setup)
		slot_randomized = TRUE
		random_character(gender, antagonist)

	// Bandaid to undo no arm flaw prosthesis
	if(charflaw)
		var/obj/item/bodypart/O = character.get_bodypart(BODY_ZONE_R_ARM)
		if(O)
			O.drop_limb(TRUE)
			qdel(O)
		O = character.get_bodypart(BODY_ZONE_L_ARM)
		if(O)
			O.drop_limb(TRUE)
			qdel(O)
		character.regenerate_limb(BODY_ZONE_R_ARM)
		character.regenerate_limb(BODY_ZONE_L_ARM)

	var/datum/species/chosen_species
	chosen_species = pref_species.type
	if(!(pref_species.name in GLOB.roundstart_races))
		set_new_race(new /datum/species/human/northern)

		random_character(gender, FALSE, FALSE)
	if(parent)
		if(pref_species.patreon_req > parent.patreonlevel())
			set_new_race(new /datum/species/human/northern)
			random_character(gender, FALSE, FALSE)

	character.age = age
	character.dna.features = features.Copy()
	character.gender = gender
	character.set_species(chosen_species, icon_update = FALSE, pref_load = src)
	character.dna.update_body_size()

	if((randomise[RANDOM_NAME] || randomise[RANDOM_NAME_ANTAG] && antagonist) && !character_setup)
		slot_randomized = TRUE
		real_name = pref_species.random_name(gender)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && ((pref_species.id == "human") || (pref_species.id == "humen")))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	if(real_name in GLOB.chosen_names)
		character.real_name = pref_species.random_name(gender)
	else
		character.real_name = real_name
	character.name = character.real_name

	if((selected_title != "None" && pref_species.use_titles) && selected_title != null)
		character.dna.species.name = selected_title

	character.domhand = domhand
	character.cmode_music_override = combat_music.musicpath
	character.cmode_music_override_name = combat_music.name
	character.highlight_color = highlight_color
	character.nickname = nickname

	character.eye_color = eye_color
	var/origin_lang = FALSE
	if(origin && origin.origin_language)
		origin_lang = TRUE
	if(!origin_lang && extra_language && extra_language != "None")
		character.grant_language(extra_language)
	if(extra_language_1 && extra_language_1 != "None")
		character.grant_language(extra_language_1)
	if(extra_language_2 && extra_language_2 != "None")
		character.grant_language(extra_language_2)
	character.voice_color = voice_color
	character.voice_pitch = voice_pitch
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.eye_color))
			organ_eyes.eye_color = eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.skin_tone = skin_tone
	character.hairstyle = hairstyle
	character.facial_hairstyle = facial_hairstyle
	character.detail = detail
	character.set_patron(selected_patron)
	character.backpack = backpack

	character.familytree_pref = family
	character.gender_choice_pref = gender_choice
	character.setspouse = setspouse
	character.xenophobe = xenophobe_pref
	character.restricted_species = restricted_species_pref

	character.jumpsuit_style = jumpsuit_style

	// Apply multiple vices system
	character.vices = list()
	for(var/i = 1 to 5)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice)
			var/datum/charflaw/new_vice = new vice.type()
			character.vices += new_vice
			new_vice.on_mob_creation(character)
			// Set first vice as the legacy charflaw for compatibility
			if(i == 1)
				character.charflaw = new_vice

	// Legacy single vice support (if new system not used)
	if(!length(character.vices) && charflaw)
		character.charflaw = new charflaw.type()
		character.charflaw.on_mob_creation(character)
		character.vices += character.charflaw

	character.dna.real_name = character.real_name

	character.headshot_link = headshot_link

	character.origin = origin ? origin.name : "Unknown"

	character.statpack = statpack

	character.flavortext = flavortext

	character.ooc_notes = ooc_notes

	// Rumours / Noble gossip
	character.rumour = rumour
	character.noble_gossip = noble_gossip

	character.nsfwflavortext = nsfwflavortext

	character.nsfw_ooc_extra_img = nsfw_ooc_extra_img

	character.nsfw_ooc_extra_img_link = nsfw_ooc_extra_img_link

	character.erpprefs = erpprefs

	character.img_gallery = img_gallery

	character.nsfw_img_gallery = nsfw_img_gallery

	character.ooc_extra = ooc_extra

	character.ooc_extra_img = ooc_extra_img

	character.ooc_extra_img_link = ooc_extra_img_link

	character.song_title = song_title

	character.song_artist = song_artist
	// LETHALSTONE ADDITION BEGIN: additional customizations

	character.pronouns = pronouns
	character.voice_type = voice_type

	// LETHALSTONE ADDITION END

	character.set_bark(bark_id)
	character.vocal_speed = bark_speed
	character.vocal_pitch = bark_pitch
	character.vocal_pitch_range = bark_variance

	//if(parent)
	//	var/list/L = get_player_curses(parent.ckey)
	//	if(L)
	//		for(var/X in L)
	//			ADD_TRAIT(character, curse2trait(X), TRAIT_GENERIC)

	if(taur_type)
		character.Taurize(taur_type, "#[taur_color]", "#[taur_markings]", "#[taur_tertiary]")
	else if(character_setup)
		// This should only ever ~do~ anything for previews
		character.ensure_not_taur()

	if(icon_updates)
		character.update_body()
		character.update_hair()
		character.update_body_parts(redraw = TRUE)

	if (character.char_accent in GLOB.character_accents)
		character.char_accent = char_accent
	else
		char_accent = "No accent"
		character.char_accent = char_accent

	if(culinary_preferences)
		apply_culinary_preferences(character)

/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
		if("religion")
			return DEFAULT_RELIGION
		if("deity")
			return DEFAULT_DEITY
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = input(user, "选择您角色的[namedata["qdesc"]]：","角色偏好") as text|null
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>无效名称。名称长度应为2到[MAX_NAME_LEN]个字符，只能包含 A-Z, a-z,[namedata["allow_numbers"] ? ",0-9," : ""] -, ' 和 .。</font>")
			return
		else
			custom_names[name_id] = sanitized_name

/// Resets the client's keybindings. Asks them for which
/datum/preferences/proc/force_reset_keybindings()
	var/choice = tgalert(parent.mob, "您的基本按键绑定需要重置，您设置的自定义按键绑定将保留。您更喜欢“热键”模式还是“经典 TG”模式？除非您确切知道自己在做什么，否则不要点击“经典”。", "重置按键绑定", "热键", "经典")
	hotkeys = (choice != "经典")
	force_reset_keybindings_direct(hotkeys)

/// Does the actual reset
/datum/preferences/proc/force_reset_keybindings_direct(hotkeys = TRUE)
	var/list/oldkeys = key_bindings
	key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)

	for(var/key in oldkeys)
		if(!key_bindings[key])
			key_bindings[key] = oldkeys[key]
	parent?.ensure_keys_set(src)

/datum/preferences/proc/try_update_mutant_colors()
	if(update_mutant_colors)
		reset_body_marking_colors()
		reset_all_customizer_accessory_colors()

/proc/valid_headshot_link(mob/user, value, silent = FALSE, list/valid_extensions = list("jpg", "png", "jpeg"))
	var/static/link_regex = regex(@"i\.gyazo.com|.\.l3n\.co|(images2|thumbs2)\.imgbox\.com|files\.catbox\.moe|file\.garden") //gyazo, lensdump, imgbox, catbox, filegarden

	if(!length(value))
		return FALSE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		if(!silent)
			to_chat(user, "<span class='warning'>您的链接必须是 https！</span>")
		return FALSE

	if(!findtext(value, ".") || findtext(value, "<") || findtext(value, ">") || findtext(value, "]") || findtext(value, "\["))	//there is no link in the world that would ever need < or >
		if(!silent)
			to_chat(user, "<span class='warning'>无效链接！</span>")
		return FALSE
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		if(!silent)
			to_chat(usr, "<span class='warning'>链接必须是以下扩展名之一：“[english_list(valid_extensions)]”</span>")
		return FALSE

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		if(!silent)
			to_chat(usr, "<span class='warning'>链接必须托管在以下站点之一：Gyazo、Lensdump、Imgbox、Catbox、Filegarden</span>")
		return FALSE
	return TRUE

/datum/preferences/proc/is_active_migrant()
	if(!migrant)
		return FALSE
	if(!migrant.active)
		return FALSE
	return TRUE

/datum/preferences/proc/process_virtue_text(datum/virtue/V)
	var/dat
	if(V.desc)
		dat += "<font size = 3>[span_purple(V.desc)]</font><br>"
	if(length(V.added_skills))
		dat += "<font color = '#a3e2ff'><font size = 3>此美德增加以下技能：<br>"
		for(var/list/L in V.added_skills)
			var/name
			if(ispath(L[1],/datum/skill))
				var/datum/skill/S = L[1]
				name = initial(S.name)
			dat += "["\Roman[L[2]]"] 级[L[2] > 1 ? "" : ""] of <b>[name]</b>[L[3] ? ", 最高达到 <b>[SSskills.level_names_plain[L[3]]]</b>" : ""] <br>"
		dat += "</font>"
	if(length(V.added_traits))
		dat += "<font color = '#a3ffe0'><font size = 3>此美德赋予以下特征：<br>"
		for(var/TR in V.added_traits)
			dat += "[TR] — <font size = 2>[GLOB.roguetraits[TR]]</font><br>"
		dat += "</font>"
	if(length(V.added_stashed_items))
		dat += "<font color = '#eeffa3'><font size = 3>此美德向您的储藏箱添加以下物品：<br>"
		for(var/I in V.added_stashed_items)
			dat += "<i>[I]</i> <br>"
		dat += "</font>"
	if(V.custom_text)
		dat += "<font color = '#ffffff'><font size = 3>此美德具有以下特殊行为：<br>"
		dat += "[V.custom_text]"
		dat += "</font>"
	return dat
