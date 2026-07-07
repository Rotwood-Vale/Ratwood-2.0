//this works as is to create a single checked item, but has no back end code for toggleing the check yet
#define TOGGLE_CHECKBOX(PARENT, CHILD) PARENT/CHILD/abstract = TRUE;PARENT/CHILD/checkbox = CHECKBOX_TOGGLE;PARENT/CHILD/verb/CHILD

//Example usage TOGGLE_CHECKBOX(datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
#ifdef TESTING
//override because we don't want to save preferences twice.
/datum/verbs/menu/Settings/Set_checked(client/C, verbpath)
	if (checkbox == CHECKBOX_GROUP)
		C.prefs.menuoptions[type] = verbpath
	else if (checkbox == CHECKBOX_TOGGLE)
		var/checked = Get_checked(C)
		C.prefs.menuoptions[type] = !checked
		winset(C, "[verbpath]", "is-checked = [!checked]")

/datum/verbs/menu/Settings/verb/setup_character()
	set name = "Character Preferences"
	set category = "Options"
	set desc = ""
	set hidden = 1
	usr.client.prefs.current_tab = 1
	usr.client.prefs.ShowChoices(usr)
#endif

/client/verb/setup_character()
	set name = "Character Preferences"
	set category = "Options"
	set desc = ""
	if(prefs)
		usr.client.prefs.current_tab = 1
		usr.client.prefs.ShowChoices(usr, 4)

/client/verb/toggle_options_menu()
	set name = "Toggles"
	set category = "Options"
	set desc = ""

	if(!prefs)
		return

	if(!toggles_menu)
		toggles_menu = new(src)

	toggles_menu.ui_interact(mob)

/client/verb/keybindings_menu()
	set name = "Keybindings"
	set category = "Options"
	set desc = ""

	if(!prefs)
		return

	prefs.SetKeybinds(mob, FALSE)

/datum/toggle_options_menu
	var/client/owner

/datum/toggle_options_menu/New(client/C)
	. = ..()
	owner = C

/datum/toggle_options_menu/Destroy(force)
	if(owner?.toggles_menu == src)
		owner.toggles_menu = null
	owner = null
	return ..()

/datum/toggle_options_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ToggleOptionsMenu", "Toggles")
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/toggle_options_menu/ui_data(mob/user)
	var/list/data = list()
	if(!owner?.prefs)
		data["categories"] = list()
		return data

	var/list/graphics_entries = list(
		list("id" = "fullscreen", "label" = "Fullscreen", "enabled" = !!(owner.prefs.toggles & TOGGLE_FULLSCREEN), "desc" = "Use fullscreen mode for the game window."),
		list("id" = "crt", "label" = "CRT Effect", "enabled" = !!owner.prefs.crt, "desc" = "Apply CRT-style blur/scanline look to the map."),
		list("id" = "grain", "label" = "Grain Effect", "enabled" = !!owner.prefs.grain, "desc" = "Overlay a subtle film grain effect."),
		list("id" = "tgui_multiline", "label" = "TGUI Multiline", "enabled" = !!owner.mob?.tgui_multiline, "desc" = "Use multiline TGUI input where supported."),
	)
	var/list/graphics_selects = list(
		list(
			"id" = "hud_colorblind_palette",
			"label" = "HUD Colorblind Palette",
			"value" = owner.prefs.hud_colorblind_palette,
			"desc" = "Swap the Rogue HUD and heat HUD icons to a higher-contrast colorblind palette.",
			"options" = hud_colorblind_palette_options(),
		),
	)

	var/list/character_entries = list(
		list("id" = "masked_examine", "label" = "Masked Examine", "enabled" = !!owner.prefs.masked_examine, "desc" = "Allow your character info to be seen while masked."),
		list("id" = "wildshape_name", "label" = "Show Wildshape Name", "enabled" = !!owner.prefs.wildshape_name, "desc" = "Show your character name while in wildshape."),
		list("id" = "nsfw_examine", "label" = "Always Show NSFW Examine", "enabled" = !!owner.prefs.nsfw_examine_always, "desc" = "Always display NSFW examine info, even when clothed."),
	)

	var/list/visual_entries = list(
		list("id" = "screen_shake", "label" = "Screen Shake", "enabled" = !!owner.prefs.shake, "desc" = "Enable camera shake during impactful events."),
		list("id" = "chat_headshot", "label" = "Headshot in Chat", "enabled" = !!owner.prefs.chatheadshot, "desc" = "Show character headshot images next to chat when available."),
		list("id" = "examine_blocks", "label" = "Hide Examine Blocks", "enabled" = !!owner.prefs.no_examine_blocks, "desc" = "Hide inspect details for items inside containers."),
		list("id" = "language_fonts", "label" = "Disable Language Fonts", "enabled" = !!owner.prefs.no_language_fonts, "desc" = "Use normal fonts instead of stylized language fonts."),
		list("id" = "language_icon", "label" = "Disable Language Icon", "enabled" = !!owner.prefs.no_language_icon, "desc" = "Hide language icon prefixes in chat."),
		list("id" = "floating_text", "label" = "Show Floating Text", "enabled" = !!(owner.prefs.floating_text_toggles & FLOATING_TEXT), "desc" = "Show floating combat/feedback text popups."),
		list("id" = "xp_text", "label" = "Show XP Text", "enabled" = !!(owner.prefs.floating_text_toggles & XP_TEXT), "desc" = "Show floating XP gain popups."),
	)

	var/list/gameplay_entries = list(
		list("id" = "autoconsume", "label" = "AutoConsume", "enabled" = !!owner.prefs.autoconsume, "desc" = "Repeat consume/feed interactions automatically."),
		list("id" = "show_rolls", "label" = "Show Rolls", "enabled" = !!owner.prefs.showrolls, "desc" = "Show combat and check roll details in chat."),
		list("id" = "combat_strip", "label" = "Combat Mode Stripping", "enabled" = !!(owner.prefs.toggles & CMODE_STRIPPING), "desc" = "Allow opening strip menu while in combat mode."),
		list("id" = "hide_unavailable_emotes", "label" = "Hide Unavailable Noises", "enabled" = !!owner.prefs.hide_unavailable_emotes, "desc" = "Hide anatomy-specific noise verbs your current body cannot use."),
		list("id" = "vocal_barks", "label" = "Hear Vocal Barks", "enabled" = !!owner.prefs.hear_barks, "desc" = "Enable hearing vocal bark sounds."),
		list("id" = "compliance_notifs", "label" = "Compliance Notifications", "enabled" = !!owner.prefs.compliance_notifs, "desc" = "Show chat notices when compliance mode changes."),
		list("id" = "skillcap_notifs", "label" = "Skillcap Notifications", "enabled" = !!owner.prefs.skillcap_notifs, "desc" = "Notify when a skill reaches its XP cap."),
		list("id" = "autopunctuation", "label" = "Disable Autopunctuation", "enabled" = !!owner.prefs.no_autopunctuate, "desc" = "Prevent automatic punctuation in your chat messages."),
		list("id" = "deadchat", "label" = "Show Deadchat", "enabled" = !!(owner.prefs.chat_toggles & CHAT_DSAY), "desc" = "Receive deadchat messages."),
		list("id" = "legacy_craft", "label" = "Enable Legacy Craft", "enabled" = !!owner.legacycraft, "desc" = "Use legacy crafting UI/behavior."),
		list("id" = "roleplay_ads", "label" = "Receive Roleplay Ads", "enabled" = !!(owner.prefs.toggles & ROLEPLAY_ADS), "desc" = "Receive notifications for new roleplay ads."),
	)

	var/list/audio_entries = list(
		list("id" = "lobby_music", "label" = "Lobby Music", "enabled" = !!(owner.prefs.toggles & SOUND_LOBBY), "desc" = "Play music while in the lobby."),
		list("id" = "hear_instruments", "label" = "Hear Instruments", "enabled" = !!(owner.prefs.toggles & SOUND_INSTRUMENTS), "desc" = "Hear bard instruments, jukeboxes, and boomboxes."),
	)

	var/list/content_entries = list(
		list("id" = "animal_emotes", "label" = "Animal Noise Emotes", "enabled" = !!(!owner.prefs.mute_animal_emotes), "desc" = "Play animal emote sound effects."),
		list("id" = "erp_panel", "label" = "Enable ERP Panel Interactions", "enabled" = !!owner.prefs.sexable, "desc" = "Allow others to use ERP panel interactions on you."),
		list("id" = "chastity", "label" = "Enable Chastity Content", "enabled" = !!owner.prefs.chastenable, "desc" = "Show and allow chastity-related content."),
		list("id" = "permanent_binding", "label" = "Enable Permanent Binding", "enabled" = (owner.prefs.chastity_hardmode == CHASTITY_HARDMODE_ENABLED), "desc" = "Enable irreversible key-only chastity lock behavior."),
		list("id" = "extreme_erp", "label" = "Enable Extreme ERP Content", "enabled" = !!owner.prefs.extreme_erp, "desc" = "Allow extreme ERP content categories."),
		list("id" = "edging", "label" = "Enable Edging Content", "enabled" = !!owner.prefs.edging, "desc" = "Allow edging-related ERP content."),
	)

	data["categories"] = list(
		list("name" = "Character", "entries" = character_entries),
		list("name" = "Graphics", "entries" = graphics_entries, "selects" = graphics_selects),
		list("name" = "Visuals", "entries" = visual_entries),
		list("name" = "Gameplay", "entries" = gameplay_entries),
		list("name" = "Audio", "entries" = audio_entries),
		list("name" = "Content", "entries" = content_entries),
	)
	return data

/datum/toggle_options_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!owner?.prefs)
		return FALSE

	if(action == "toggle")
		var/id = params["id"]
		switch(id)
			if("fullscreen")
				owner.toggle_fullscreen()
			if("crt")
				owner.crtmode()
			if("grain")
				owner.grainfilter()
			if("tgui_multiline")
				owner.mob?.toggle_tgui_multiline()
			if("screen_shake")
				owner.toggle_screenshake()
			if("chat_headshot")
				owner.set_picinchat()
			if("masked_examine")
				owner.masked_examine()
			if("nsfw_examine")
				owner.nsfw_examine_always()
			if("examine_blocks")
				owner.toggle_examine_blocks()
			if("wildshape_name")
				owner.toggle_wildshape_name()
			if("language_fonts")
				owner.toggle_language_fonts()
			if("language_icon")
				owner.toggle_language_icon()
			if("floating_text")
				owner.toggle_floatingtext()
			if("xp_text")
				owner.toggle_xptext()
			if("autoconsume")
				owner.autoconsume()
			if("show_rolls")
				owner.show_rolls()
			if("combat_strip")
				owner.cmode_strip()
			if("hide_unavailable_emotes")
				owner.toggle_hide_unavailable_emotes()
			if("vocal_barks")
				owner.vocal_barks()
			if("compliance_notifs")
				owner.toggle_compliance_notifs()
			if("skillcap_notifs")
				owner.toggle_skillcap_notifs()
			if("autopunctuation")
				owner.toggle_autopunctuation()
			if("deadchat")
				owner.toggle_deadchat()
			if("legacy_craft")
				owner.toggle_legacycraft()
			if("roleplay_ads")
				owner.toggle_roleplay_ads()
			if("lobby_music")
				owner.toggle_lobby_music()
			if("hear_instruments")
				owner.prefs.toggles ^= SOUND_INSTRUMENTS
				owner.prefs.save_preferences()
				for(var/datum/looping_sound/persistent_loop in GLOB.persistent_sound_loops)
					owner.update_persistent_sound_loop(persistent_loop)
				owner.update_sounds()
				owner.sync_instrument_audio_toggle()
			if("animal_emotes")
				owner.mute_animal_emotes()
			if("erp_panel")
				owner.toggle_ERP()
			if("chastity")
				owner.toggle_Chastity()
			if("permanent_binding")
				owner.toggle_Chastity_Hardmode()
			if("extreme_erp")
				owner.toggle_extreme_ERP()
			if("edging")
				owner.toggle_edging()
		SStgui.update_uis(src)
		return TRUE

	if(action == "select")
		var/select_id = params["id"]
		switch(select_id)
			if("hud_colorblind_palette")
				if(!owner.prefs.set_hud_colorblind_palette(params["value"]))
					return FALSE
				owner.prefs.save_preferences()
				owner.refresh_colorblind_hud_palette()
		SStgui.update_uis(src)
		return TRUE

	return FALSE

/client/verb/toggle_fullscreen()
	set name = "ToggleFullscreen"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= TOGGLE_FULLSCREEN
		prefs.save_preferences()
		toggle_fullscreeny(prefs.toggles & TOGGLE_FULLSCREEN)

/client/verb/toggle_screenshake()
	set category = "Options"
	set name = "Toggle Screen Shake"
	set hidden = 1
	if(prefs)
		prefs.shake = !prefs.shake
		prefs.save_preferences()
		if(prefs.shake)
			to_chat(src, "Screen shake enabled.")
		else
			to_chat(src, "Screen shake disabled.")

/client/verb/masked_examine()
	set category = "Options"
	set name = "Toggle Masked Examine"
	set hidden = 1
	if(prefs)
		prefs.masked_examine = !prefs.masked_examine
		prefs.save_preferences()
		if(prefs.masked_examine)
			to_chat(src, "Your character information will be viewable when masked.")
		else
			to_chat(src, "Your character information will no longer be viewable when masked.")

/client/verb/nsfw_examine_always()
	set category = "Options"
	set name = "Toggle NSFW Examine"
	set hidden = 1
	if(prefs)
		prefs.nsfw_examine_always = !prefs.nsfw_examine_always
		prefs.save_preferences()
		if(prefs.nsfw_examine_always)
			to_chat(src, "Your character NSFW information will always be visible.")
		else
			to_chat(src, "Your character NSFW information will only be visible when nude.")

/client/verb/mute_animal_emotes()
	set category = "Options"
	set name = "Toggle Animal Noise Emotes"
	set hidden = 1
	if(prefs)
		prefs.mute_animal_emotes = !prefs.mute_animal_emotes
		prefs.save_preferences()
		if(prefs.mute_animal_emotes)
			to_chat(src, "You can no longer hear animal sound emotes.")
		else
			to_chat(src, "You will now hear animal sound emotes.")

/client/verb/autoconsume()
	set category = "Options"
	set name = "Toggle AutoConsume"
	set hidden = 1
	if(prefs)
		prefs.autoconsume = !prefs.autoconsume
		prefs.save_preferences()
		if(prefs.autoconsume)
			to_chat(src, "You will now try to repeatedly consume/feed food/drinks")
		else
			to_chat(src, "You will no longer try to repeatedly consume/feed food/drinks")

/client/verb/toggle_hide_unavailable_emotes()
	set category = "Options"
	set name = "Toggle Hide Unavailable Noises"
	set hidden = 1
	if(prefs)
		prefs.hide_unavailable_emotes = !prefs.hide_unavailable_emotes
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.update_tongue_noise_verbs()
		if(prefs.hide_unavailable_emotes)
			to_chat(src, "Unavailable noise verbs are now hidden.")
		else
			to_chat(src, "Unavailable noise verbs are now visible.")

/client/verb/toggle_ERP() // Alters if other people can use the ERP panel ON you.
	set category = "Options"
	set name = "Toggle ERP Panel"
	set hidden = 1
	if(prefs)
		prefs.sexable = !prefs.sexable
		prefs.save_preferences()
		if(prefs.sexable)
			to_chat(src, "Others can play with you.")
		else
			to_chat(src, "Others can't touch you.")

/client/verb/toggle_Chastity() // Alters whether the user can see or interact with any content related to chastity devices, including the devices themselves, actions that target them, and messages related to them. This is intended for users who want to avoid accidentally encountering this content, but still want to be able to use the game without missing out on unrelated features.
	set category = "Options"
	set name = "Toggle Chastity Content"
	set hidden = 1
	if(prefs)
		prefs.chastenable = !prefs.chastenable
		prefs.save_preferences()
		if(prefs.chastenable)
			to_chat(src, "Chastity content enabled.")
		else
			if(hascall(src, "modular_handle_chastity_toggle_disable"))
				call(src, "modular_handle_chastity_toggle_disable")()
			to_chat(src, "Chastity content disabled.")

/client/verb/toggle_Chastity_Hardmode()
	set category = "Options"
	set name = "Toggle Permanent Binding"
	set hidden = 1
	
	if(!prefs)
		return
	
	// Enabling hard mode requires confirmation
	if(prefs.chastity_hardmode == CHASTITY_HARDMODE_DISABLED)
		var/confirm = alert(src, 
			"PERMANENT CHASTITY BINDING:\n\n\
			• Only the device's unique key can unlock it\n\
			• Keys can be lost, stolen, or destroyed forever\n\
			• Divine intervention will not free you\n\
			• Lockpicks and tools will fail\n\
			• Even the Duke's master key holds no power\n\
			• Physical removal is impossible\n\
			• You will remain bound until the key releases you\n\n\
			Do you accept these terms of permanent binding?",
			"Permanent Chastity Binding",
			"I accept the binding",
			"I refuse")
		
		if(confirm != "I accept the binding")
			to_chat(src, span_notice("You decline the permanent binding."))
			return
		
		prefs.chastity_hardmode = CHASTITY_HARDMODE_ENABLED
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.chastity_device?.sync_generated_key_metadata(H, mob)
		to_chat(src, span_boldwarning("You have accepted the terms of PERMANENT BINDING. Only keys shall grant freedom."))
		log_game("[key_name(src)] enabled permanent chastity binding.")
		message_admins("[key_name_admin(src)] enabled permanent chastity binding.")
	else
		// Disabling requires the humiliation prayer
		to_chat(src, span_notice("To disable permanent binding, you must recite the Prayer of Foolish Repentance to Eora."))
		var/sacred_prayer = "Dear Eora, I embraced this binding in foolish haste because I'm a dullard and I'm sorry, so so so sorry for being such a stupid stupid stupid person and I'm begging you please please please free my loins."
		var/encoded_sacred_prayer = html_encode(sacred_prayer)
		var/prayer_prompt = "Recite the Prayer of Foolish Repentance EXACTLY as written:\n\n\"[sacred_prayer]\"\n\n(You must type this yourself - copying is forbidden by divine law)"
		// multiline=TRUE so the wrapping textarea is readable; bigmodal=TRUE for a large window that shows the full prompt.
		// disable_paste=TRUE enforces hand-typing; max_length locks out anything longer than the prayer itself.
		var/prayer_attempt = tgui_input_text(src, prayer_prompt, "Prayer of Foolish Repentance", default = "", max_length = length(encoded_sacred_prayer), multiline = TRUE, encode = TRUE, ui_state = GLOB.tgui_always_state, bigmodal = TRUE, disable_paste = TRUE)

		if(!prayer_attempt)
			to_chat(src, span_warning("Eora does not hear your silence."))
			return

		// tgui_input_text() html-encodes player input, so compare against the prayer normalized the same way.
		if(prayer_attempt != encoded_sacred_prayer)
			to_chat(src, span_warning("Eora rejects your imperfect prayer. You must recite it EXACTLY as written."))
			to_chat(src, span_notice("You wrote: \"[prayer_attempt]\""))
			to_chat(src, span_notice("Required: \"[sacred_prayer]\""))
			log_game("[key_name(src)] failed the humiliation prayer (incorrect text).")
			return

		// They did it! The humiliation is complete
		prefs.chastity_hardmode = CHASTITY_HARDMODE_DISABLED
		prefs.save_preferences()
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			H.chastity_device?.sync_generated_key_metadata(H)
		to_chat(src, span_boldnotice("Eora hears your pathetic plea and takes pity upon you. The permanent binding is lifted."))
		to_chat(src, span_notice("You have revoked the permanent binding. Mortal means may now test the lock once more."))
		log_game("[key_name(src)] disabled permanent chastity binding via humiliation prayer.")
		message_admins("[key_name_admin(src)] disabled permanent chastity binding by reciting the humiliation prayer.")

/client/verb/toggle_extreme_ERP()// toggles gore, ryona, and other extreme content in the ERP panel. This is separate from the regular ERP toggle for users who want to avoid just the extreme content but are okay with milder stuff.
	set category = "Options"
	set name = "Toggle Extreme ERP Content"
	set hidden = 1
	if(prefs)
		prefs.extreme_erp = !prefs.extreme_erp
		prefs.save_preferences()
		if(prefs.extreme_erp)
			to_chat(src, "Extreme ERP content enabled in the ERP panel.")
		else
			if(hascall(src, "modular_handle_extreme_erp_toggle_disable"))
				call(src, "modular_handle_extreme_erp_toggle_disable")()
			to_chat(src, "Extreme ERP content disabled in the ERP panel.")

/client/verb/toggle_edging() // Toggles edging content in the ERP panel, for psydonites who clearly can't ENDURE.
	set category = "Options"
	set name = "Toggle Edging Content"
	set hidden = 1
	if(prefs)
		prefs.edging = !prefs.edging
		prefs.save_preferences()
		if(prefs.edging)
			to_chat(src, "You ENDVRE through orgasms.")
		else
			to_chat(src, "You will no longer ENDVRE through orgasms.")

/client/verb/toggle_compliance_notifs() // The messages need to be on-by-default while this is in its early stages.
	set category = "Options"
	set name = "Toggle Compliance Notifs"
	set hidden = 1
	if(prefs)
		prefs.compliance_notifs = !prefs.compliance_notifs
		prefs.save_preferences()
		if(prefs.compliance_notifs)
			to_chat(src, "You will receive chat notifications when enabling or disabling Compliance Mode.")
		else
			to_chat(src, "You will no longer be notified in chat when toggling Compliance Mode.")

/client/verb/toggle_skillcap_notifs()
	set category = "Options"
	set name = "Toggle Skillcap Notifs"
	set hidden = 1
	if(prefs)
		prefs.skillcap_notifs = !prefs.skillcap_notifs
		prefs.save_preferences()
		if(prefs.skillcap_notifs)
			to_chat(src, "You will receive notifications when hitting your character's experience cap in a skill.")
		else
			to_chat(src, "You will no longer be notified in chat when hitting your character's experience cap in a skill.")

/client/verb/toggle_examine_blocks()
	set category = "Options"
	set name = "Toggle Examine Blocks"
	set hidden = 1
	if(prefs)
		prefs.no_examine_blocks = !prefs.no_examine_blocks
		prefs.save_preferences()
		if(prefs.no_examine_blocks)
			to_chat(src, "You will no longer see examined items in boxes.")
		else
			to_chat(src, "You will now see examined items in boxes.")

/client/verb/toggle_wildshape_name()
	set category = "Options"
	set name = "Toggle Wildshape Name"
	set hidden = 1
	if(prefs)
		prefs.wildshape_name = !prefs.wildshape_name
		prefs.save_preferences()
		if(prefs.wildshape_name)
			to_chat(src, "You will show your character's name when wildshaping as a Druid.")
		else
			to_chat(src, "You will hide your character's name when wildshaping as a Druid and appear solely as your animal form.")

/client/verb/toggle_autopunctuation()
	set category = "Options"
	set name = "Toggle Autopunctuation"
	set hidden = 1
	if(prefs)
		prefs.no_autopunctuate = !prefs.no_autopunctuate
		prefs.save_preferences()
		if(prefs.no_autopunctuate)
			to_chat(src, "Your messages will no longer be automatically punctuated.")
		else
			to_chat(src, "Your messages will now be automatically punctuated.")

/client/verb/toggle_language_fonts()
	set category = "Options"
	set name = "Toggle Language Fonts"
	set hidden = 1
	if(prefs)
		prefs.no_language_fonts = !prefs.no_language_fonts
		prefs.save_preferences()
		if(prefs.no_language_fonts)
			to_chat(src, "You will no longer see languages in their stylized fonts.")
		else
			to_chat(src, "You will now see languages in their stylized fonts.")

/client/verb/toggle_language_icon()
	set category = "Options"
	set name = "Toggle Language Icon"
	set hidden = 1
	if(prefs)
		prefs.no_language_icon = !prefs.no_language_icon
		prefs.save_preferences()
		if(prefs.no_language_icon)
			to_chat(src, "You will no longer see the language icon in front of a language.")
		else
			to_chat(src, "You will now see the language icon in front of a language.")

/client/verb/toggle_lobby_music()
	set name = "Toggle Lobby Music"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= SOUND_LOBBY
		prefs.save_preferences()
	if(prefs.toggles & SOUND_LOBBY)
		to_chat(src, "You will now hear music in the lobby.")
		if(isnewplayer(usr))
			playtitlemusic()
	else
		to_chat(src, "You will no longer hear music in the lobby.")
		mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)

/client/verb/toggle_roleplay_ads()
	set name = "Roleplay Ads (Toggle)"
	set category = "OOC"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= ROLEPLAY_ADS
		prefs.save_preferences()
	if(prefs.toggles & ROLEPLAY_ADS)
		to_chat(src, "You will now be notified of new roleplay ads.")
	else
		to_chat(src, "You will no longer be notified of new roleplay ads.")

/client/verb/stop_sounds_rogue()
	set name = "StopSounds"
	set category = "Options"
	set desc = ""
	if(mob)
		SEND_SOUND(mob, sound(null))

/client/verb/cmode_strip()
	set name = "Combat Mode Stripping"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.toggles ^= CMODE_STRIPPING
		prefs.save_preferences()
	to_chat(src, "You will [prefs.toggles & CMODE_STRIPPING ? "" : "not"] be able to open the strip menu in combat mode.")

/client/verb/vocal_barks()
	set name = "Hear Vocal Barks"
	set category = "Options"
	set desc = ""
	set hidden = 1
	if(prefs)
		prefs.hear_barks = !prefs.hear_barks
		prefs.save_preferences()
	to_chat(src, "You will [prefs.hear_barks ? "" : "not "]hear vocal barks.")

/client/verb/toggle_xptext() // Whether the user can see the balloon XP pop ups.
	set category = "Options"
	set name = "Toggle XP Text"
	set hidden = 1
	if(prefs)
		prefs.floating_text_toggles ^= XP_TEXT
		prefs.save_preferences()
	to_chat(src, "You will[prefs.floating_text_toggles & XP_TEXT ? "" : " not"] see XP pop ups.")

/client/verb/toggle_floatingtext() // Whether the user can see the balloon pop ups at all.
	set category = "Options"
	set name = "Toggle Floating Text"
	set hidden = 1
	if(prefs)
		prefs.floating_text_toggles ^= FLOATING_TEXT
		prefs.save_preferences()
	to_chat(src, "You will [prefs.floating_text_toggles & FLOATING_TEXT ? "see" : "not see any"] floating text.")

/client/verb/toggle_deadchat() // Whether the user can see DSAY or not.
	set name = "Show/Hide Deadchat"
	set category = "Options"
	set desc ="Toggles seeing deadchat"
	set hidden = 1

	if(prefs)
		prefs.chat_toggles ^= CHAT_DSAY
		prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_DSAY) ? "now" : "no longer"] see deadchat.")
	if(holder)
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Deadchat Visibility", "[prefs.chat_toggles & CHAT_DSAY ? "Enabled" : "Disabled"]"))

/*
//toggles
/datum/verbs/menu/Settings/Ghost/chatterbox
	name = "Chat Box Spam"

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTEARS
	to_chat(usr, "As a ghost, you will now [(usr.client.prefs.chat_toggles & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Ears", "[usr.client.prefs.chat_toggles & CHAT_GHOSTEARS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_ears/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTEARS

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_sight)()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	to_chat(usr, "As a ghost, you will now [(usr.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Sight", "[usr.client.prefs.chat_toggles & CHAT_GHOSTSIGHT ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_sight/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTSIGHT

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_whispers)()
	set name = "Show/Hide GhostWhispers"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	to_chat(usr, "As a ghost, you will now [(usr.client.prefs.chat_toggles & CHAT_GHOSTWHISPER) ? "see all whispers in the world" : "only see whispers from nearby mobs"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Whispers", "[usr.client.prefs.chat_toggles & CHAT_GHOSTWHISPER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_whispers/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTWHISPER

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_radio)()
	set name = "Show/Hide GhostRadio"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTRADIO
	to_chat(usr, "As a ghost, you will now [(usr.client.prefs.chat_toggles & CHAT_GHOSTRADIO) ? "see radio chatter" : "not see radio chatter"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Radio", "[usr.client.prefs.chat_toggles & CHAT_GHOSTRADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc! //social experiment, increase the generation whenever you copypaste this shamelessly GENERATION 1
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_radio/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTRADIO

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_pda)()
	set name = "Show/Hide GhostPDA"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTPDA
	to_chat(usr, "As a ghost, you will now [(usr.client.prefs.chat_toggles & CHAT_GHOSTPDA) ? "see all pda messages in the world" : "only see pda messages from nearby mobs"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost PDA", "[usr.client.prefs.chat_toggles & CHAT_GHOSTPDA ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_pda/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTPDA

/datum/verbs/menu/Settings/Ghost/chatterbox/Events
	name = "Events"

//please be aware that the following two verbs have inverted stat output, so that "Toggle Deathrattle|1" still means you activated it
TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox/Events, toggle_deathrattle)()
	set name = "Toggle Deathrattle"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= DISABLE_DEATHRATTLE
	usr.client.prefs.save_preferences()
	to_chat(usr, "You will [(usr.client.prefs.toggles & DISABLE_DEATHRATTLE) ? "no longer" : "now"] get messages when a sentient mob dies.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Deathrattle", "[!(usr.client.prefs.toggles & DISABLE_DEATHRATTLE) ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, maybe you should spend some time reading the comments.
/datum/verbs/menu/Settings/Ghost/chatterbox/Events/toggle_deathrattle/Get_checked(client/C)
	return !(C.prefs.toggles & DISABLE_DEATHRATTLE)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox/Events, toggle_arrivalrattle)()
	set name = "Toggle Arrivalrattle"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= DISABLE_ARRIVALRATTLE
	to_chat(usr, "You will [(usr.client.prefs.toggles & DISABLE_ARRIVALRATTLE) ? "no longer" : "now"] get messages when someone joins the station.")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Arrivalrattle", "[!(usr.client.prefs.toggles & DISABLE_ARRIVALRATTLE) ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, maybe you should rethink where your life went so wrong.
/datum/verbs/menu/Settings/Ghost/chatterbox/Events/toggle_arrivalrattle/Get_checked(client/C)
	return !(C.prefs.toggles & DISABLE_ARRIVALRATTLE)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost, togglemidroundantag)()
	set name = "Toggle Midround Antagonist"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= MIDROUND_ANTAG
	usr.client.prefs.save_preferences()
	to_chat(usr, "You will [(usr.client.prefs.toggles & MIDROUND_ANTAG) ? "now" : "no longer"] be considered for midround antagonist positions.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Midround Antag", "[usr.client.prefs.toggles & MIDROUND_ANTAG ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/togglemidroundantag/Get_checked(client/C)
	return C.prefs.toggles & MIDROUND_ANTAG*/
/*
TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggletitlemusic)()
	set name = "LobbyMusic"
	set category = "Options"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_LOBBY
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_LOBBY)
		to_chat(usr, "You will now hear music in the lobby.")
		if(isnewplayer(usr))
			usr.client.playtitlemusic()
	else
		to_chat(usr, "You will no longer hear music in the lobby.")
		usr.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Lobby Music", "[usr.client.prefs.toggles & SOUND_LOBBY ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggletitlemusic/Get_checked(client/C)
	return C.prefs.toggles & SOUND_LOBBY


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, togglemidis)()
	set name = "Hear/Silence Midis"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_MIDI
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_MIDI)
		to_chat(usr, "You will now hear any sounds uploaded by admins.")
	else
		to_chat(usr, "You will no longer hear sounds uploaded by admins")
		usr.stop_sound_channel(CHANNEL_ADMIN)
		var/client/C = usr.client
		if(C && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
			C.chatOutput.stopMusic()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Hearing Midis", "[usr.client.prefs.toggles & SOUND_MIDI ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/togglemidis/Get_checked(client/C)
	return C.prefs.toggles & SOUND_MIDI


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_instruments)()
	set name = "Hear/Silence Instruments"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_INSTRUMENTS
	usr.client.prefs.save_preferences()
	usr.client.update_sounds()
	usr.client.sync_instrument_audio_toggle()
	if(usr.client.prefs.toggles & SOUND_INSTRUMENTS)
		to_chat(usr, "You will now hear people playing musical instruments.")
	else
		to_chat(usr, "You will no longer hear musical instruments.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Instruments", "[usr.client.prefs.toggles & SOUND_INSTRUMENTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_instruments/Get_checked(client/C)
	return C.prefs.toggles & SOUND_INSTRUMENTS


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, Toggle_Soundscape)()
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_AMBIENCE
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_AMBIENCE)
		to_chat(usr, "You will now hear ambient sounds.")
	else
		to_chat(usr, "You will no longer hear ambient sounds.")
		usr.stop_sound_channel(CHANNEL_AMBIENCE)
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ambience", "[usr.client.prefs.toggles & SOUND_AMBIENCE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/Toggle_Soundscape/Get_checked(client/C)
	return C.prefs.toggles & SOUND_AMBIENCE


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_ship_ambience)()
	set name = "Hear/Silence Ship Ambience"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_SHIP_AMBIENCE
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		to_chat(usr, "You will now hear ship ambience.")
	else
		to_chat(usr, "You will no longer hear ship ambience.")
		usr.client.ambience_playing = 0
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ship Ambience", "[usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, I bet you read this comment expecting to see the same thing :^)
/datum/verbs/menu/Settings/Sound/toggle_ship_ambience/Get_checked(client/C)
	return C.prefs.toggles & SOUND_SHIP_AMBIENCE


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_announcement_sound)()
	set name = "Hear/Silence Announcements"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.toggles ^= SOUND_ANNOUNCEMENTS
	to_chat(usr, "You will now [(usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS) ? "hear announcement sounds" : "no longer hear announcements"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Announcement Sound", "[usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_announcement_sound/Get_checked(client/C)
	return C.prefs.toggles & SOUND_ANNOUNCEMENTS


/datum/verbs/menu/Settings/Sound/verb/stop_client_sounds()
	set name = "Stop Sounds"
	set category = "Options"
	set desc = ""
	SEND_SOUND(usr, sound(null))
	var/client/C = usr.client
	if(C && C.chatOutput && !C.chatOutput.broken && C.chatOutput.loaded)
		C.chatOutput.stopMusic()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Stop Self Sounds")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_ooc)()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_OOC
	usr.client.prefs.save_preferences()
	to_chat(usr, "You will [(usr.client.prefs.chat_toggles & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Seeing OOC", "[usr.client.prefs.chat_toggles & CHAT_OOC ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/listen_ooc/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_OOC

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_bank_card)()
	set name = "Show/Hide Income Updates"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	usr.client.prefs.chat_toggles ^= CHAT_BANKCARD
	usr.client.prefs.save_preferences()
	to_chat(usr, "You will [(usr.client.prefs.chat_toggles & CHAT_BANKCARD) ? "now" : "no longer"] be notified when you get paid.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Income Notifications", "[(usr.client.prefs.chat_toggles & CHAT_BANKCARD) ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/listen_bank_card/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_BANKCARD*/


GLOBAL_LIST_INIT(ghost_forms, sortList(list("ghost","ghostking","ghostian2","skeleghost","ghost_red","ghost_black", \
							"ghost_blue","ghost_yellow","ghost_green","ghost_pink", \
							"ghost_cyan","ghost_dblue","ghost_dred","ghost_dgreen", \
							"ghost_dcyan","ghost_grey","ghost_dyellow","ghost_dpink", "ghost_purpleswirl","ghost_funkypurp","ghost_pinksherbert","ghost_blazeit",\
							"ghost_mellow","ghost_rainbow","ghost_camo","ghost_fire", "catghost")))
/client/proc/pick_form()
	if(!is_content_unlocked())
		alert("This setting is for accounts with BYOND premium only.")
		return
	var/new_form = input(src, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_forms
	if(new_form)
		prefs.ghost_form = new_form
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_icon(new_form)

GLOBAL_LIST_INIT(ghost_orbits, list(GHOST_ORBIT_CIRCLE,GHOST_ORBIT_TRIANGLE,GHOST_ORBIT_SQUARE,GHOST_ORBIT_HEXAGON,GHOST_ORBIT_PENTAGON))

/client/proc/pick_ghost_orbit()
	if(!is_content_unlocked())
		alert("This setting is for accounts with BYOND premium only.")
		return
	var/new_orbit = input(src, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND",null) as null|anything in GLOB.ghost_orbits
	if(new_orbit)
		prefs.ghost_orbit = new_orbit
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.ghost_orbit = new_orbit

/client/proc/pick_ghost_accs()
	var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,"full accessories", "only directional sprites", "default sprites")
	if(new_ghost_accs)
		switch(new_ghost_accs)
			if("full accessories")
				prefs.ghost_accs = GHOST_ACCS_FULL
			if("only directional sprites")
				prefs.ghost_accs = GHOST_ACCS_DIR
			if("default sprites")
				prefs.ghost_accs = GHOST_ACCS_NONE
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_icon()

/client/verb/pick_ghost_customization()
	set name = "Ghost Customization"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	if(is_content_unlocked())
		switch(alert("Which setting do you want to change?",,"Ghost Form","Ghost Orbit","Ghost Accessories"))
			if("Ghost Form")
				pick_form()
			if("Ghost Orbit")
				pick_ghost_orbit()
			if("Ghost Accessories")
				pick_ghost_accs()
	else
		pick_ghost_accs()

/client/verb/pick_ghost_others()
	set name = "Ghosts of Others"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,"Their Setting", "Default Sprites", "White Ghost")
	if(new_ghost_others)
		switch(new_ghost_others)
			if("Their Setting")
				prefs.ghost_others = GHOST_OTHERS_THEIR_SETTING
			if("Default Sprites")
				prefs.ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
			if("White Ghost")
				prefs.ghost_others = GHOST_OTHERS_SIMPLE
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_sight()

/client/verb/toggle_intent_style()
	set name = "Toggle Intent Selection Style"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.toggles ^= INTENT_STYLE
	to_chat(src, "[(prefs.toggles & INTENT_STYLE) ? "Clicking directly on intents selects them." : "Clicking on intents rotates selection clockwise."]")
	prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Intent Selection", "[prefs.toggles & INTENT_STYLE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_hud_pref()
	set name = "Toggle Ghost HUD"
	set category = "Preferences"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.ghost_hud = !prefs.ghost_hud
	to_chat(src, "Ghost HUD will now be [prefs.ghost_hud ? "visible" : "hidden"].")
	prefs.save_preferences()
	if(isobserver(mob))
		mob.hud_used.show_hud()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost HUD", "[prefs.ghost_hud ? "Enabled" : "Disabled"]"))

/client/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = ""
	set category = "Preferences"
	set hidden = 1
	if(!holder)
		return
	prefs.inquisitive_ghost = !prefs.inquisitive_ghost
	prefs.save_preferences()
	if(prefs.inquisitive_ghost)
		to_chat(src, span_notice("I will now examine everything you click on."))
	else
		to_chat(src, span_notice("I will no longer examine things you click on."))
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Inquisitiveness", "[prefs.inquisitive_ghost ? "Enabled" : "Disabled"]"))

//Admin Preferences
/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Prefs - Admin"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Adminhelp Sound", "[prefs.toggles & SOUND_ADMINHELP ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleannouncelogin()
	set name = "Do/Don't Announce Login"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= ANNOUNCE_LOGIN
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & ANNOUNCE_LOGIN) ? "now" : "no longer"] have an announcement to other admins when you login.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Login Announcement", "[prefs.toggles & ANNOUNCE_LOGIN ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Prefs - Admin"
	set desc = ""
	set hidden = 1
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.chat_toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from nearby radios or speakers")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Radio Chatter", "[prefs.chat_toggles & CHAT_RADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Visibility", "[prefs.chat_toggles & CHAT_PRAYER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_prayer_sound()
	set name = "Toggle Prayer Sounds"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	prefs.toggles ^= SOUND_PRAYERS
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_PRAYERS) ? "now" : "no longer"] hear a sound when prayers arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Sounds", "[usr.client.prefs.toggles & SOUND_PRAYERS ? "Enabled" : "Disabled"]"))

/client/proc/colorasay()
	set name = "Set Asay Color"
	set category = "Prefs - Admin"
	set desc = ""
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	var/new_asaycolor = input(src, "Please select your ASAY color.", "ASAY color", prefs.asaycolor) as color|null
	if(new_asaycolor)
		prefs.asaycolor = sanitize_ooccolor(new_asaycolor)
		prefs.save_preferences()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set ASAY Color")
	return

/client/proc/resetasaycolor()
	set name = "Reset your Admin Say Color"
	set desc = ""
	set category = "Prefs - Admin"
	if(!holder)
		return
	if(!CONFIG_GET(flag/allow_admin_asaycolor))
		to_chat(src, "Custom Asay color is currently disabled by the server.")
		return
	prefs.asaycolor = initial(prefs.asaycolor)
	prefs.save_preferences()

/client/proc/hearallasghost()
	set category = "Prefs - Admin"
	set name = "HearAllAsAdmin"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.chat_toggles ^= CHAT_GHOSTEARS
//	prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	prefs.save_preferences()
	if(prefs.chat_toggles & CHAT_GHOSTEARS)
		to_chat(src, span_notice("I will hear all now."))
	else
		to_chat(src, span_info("I will hear like a mortal."))

/client/proc/hearglobalLOOC()
	set category = "Prefs - Admin"
	set name = "Show/Hide Global LOOC"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMINLOOC
	prefs.save_preferences()
	if(prefs.admin_chat_toggles & CHAT_ADMINLOOC)
		to_chat(src, span_notice("I will now hear all LOOC chatter."))
	else
		to_chat(src, span_info("I will now only hear LOOC chatter around me."))

/client/proc/togglespawnmessages()
	set category = "Prefs - Admin"
	set name = "Show/Hide Spawn Logs"
	if(!holder)
		return
	if(!prefs)
		return
	prefs.admin_chat_toggles ^= CHAT_ADMINSPAWN
	prefs.save_preferences()
	to_chat(src, "You will [prefs.admin_chat_toggles & CHAT_ADMINSPAWN ? "see" : "not see any"] spawn logs.")
