GLOBAL_LIST_EMPTY(vampire_objects)
#define INITIAL_BLOODPOOL_PERCENTAGE 40
/datum/antagonist/vampire
	name = "Vampire"
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "Vspawn"
	confess_lines = list(
		"I WANT YOUR BLOOD!",
		"DRINK THE BLOOD!",
		"BEARER OF THE SANGUINE NOCTIS!",
	)
	rogue_enabled = TRUE
	show_in_roundend = FALSE
	show_in_antagpanel = FALSE // Base vampire shouldn't be directly selectable - use Vampire Lord or specific subtypes
	var/datum/clan/default_clan = /datum/clan/nosferatu
	// New variables for clan selection
	var/clan_selected = FALSE
	var/custom_clan_name = ""
	var/list/selected_covens = list()
	var/forced = FALSE
	var/datum/clan/forcing_clan
	var/generation
	var/research_points = 10

/datum/antagonist/vampire/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation)
	. = ..()
	if(forced_clan)
		forced = forced_clan
		forcing_clan = incoming_clan
	else
		default_clan = incoming_clan
	if(generation)
		src.generation = generation
	switch(src.generation)
		if(GENERATION_METHUSELAH)
			research_points = 50
		if(GENERATION_ANCILLAE)
			research_points = 17
		if(GENERATION_NEONATE)
			research_points = 9
		if(GENERATION_CRIMSONBLOOD)
			research_points = 11 // This might be idiotic, but considering they only have one coven to choose from, they should get a bit more
		if(GENERATION_THINBLOOD)
			research_points = 0

/datum/antagonist/vampire/get_antag_cap_weight()
	switch(generation)
		if(GENERATION_METHUSELAH)
			return 3
		if(GENERATION_ANCILLAE)
			return 2
		if(GENERATION_NEONATE)
			return 0.75 // Licker Wretch
		if(GENERATION_CRIMSONBLOOD)
			return 0.5 // Crimson blood - between thinblood and neonate
		if(GENERATION_THINBLOOD)
			return 0.25 // You are not even an antagonist
		else
			return 1 // Default weight if generation not set

/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("One of the First Sires!")
	if(istype(examined_datum, /datum/antagonist/vampire))
		return span_boldnotice("A bearer of the Sanguine Noctis.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite.")

/datum/antagonist/vampire/on_gain()
	SSmapping.retainer.vampires |= owner
	//move_to_spawnpoint()
	owner.special_role = name
	owner.current.adjust_bloodpool()
	if(ishuman(owner.current))
		var/mob/living/carbon/human/vampdude = owner.current
		vampdude.hud_used?.shutdown_bloodpool()
		vampdude.hud_used?.initialize_bloodpool()
		vampdude.hud_used?.bloodpool.set_fill_color("#510000")

		if(!forced)
			// Show clan selection interface
			if(!clan_selected)
				show_clan_selection(vampdude)
			else
				// Apply the selected clan
				vampdude.set_clan(default_clan)
		else
			vampdude.set_clan_direct(forcing_clan)
			forcing_clan = null

	// The clan system now handles most of the setup, but we can still do antagonist-specific things
	after_gain()
	. = ..()
	equip()

/datum/antagonist/vampire/proc/show_clan_selection(mob/living/carbon/human/vampdude)
	var/list/clan_options = list()
	var/list/available_clans = list()

	if(vampdude.job == "Wretch")
		create_custom_clan(vampdude)
		return

	for(var/clan_type in subtypesof(/datum/clan))
		var/datum/clan/temp_clan = new clan_type
		if(temp_clan.selectable_by_vampires)
			available_clans += clan_type
			clan_options[temp_clan.name] = clan_type
		qdel(temp_clan)

	clan_options["Create Custom Clan"] = "custom"

	var/choice = input(vampdude, "Choose your vampire clan:", "Clan Selection") as null|anything in clan_options

	if(!choice)
		// Default to nosferatu if no choice made
		default_clan = /datum/clan/nosferatu
		vampdude.set_clan(default_clan)
		clan_selected = TRUE
		return

	if(clan_options[choice] == "custom")
		create_custom_clan(vampdude)
	else
		default_clan = clan_options[choice]
		vampdude.set_clan(default_clan)
		clan_selected = TRUE

/datum/antagonist/vampire/proc/create_custom_clan(mob/living/carbon/human/vampdude)
	// Get custom clan name; TGUI works better during the preferences UI
	var/list/custom_details = get_custom_clan_details(vampdude, "Custom Clan", "A custom vampire clan.")
	var/custom_clan_name = custom_details[1]
	var/custom_clan_desc = custom_details[2]

	var/datum/clan/custom/new_clan = new /datum/clan/custom()
	new_clan.name = custom_clan_name
	new_clan.desc = custom_clan_desc
	switch(vampdude.get_vampire_generation())
		if(GENERATION_NEONATE, GENERATION_CRIMSONBLOOD, GENERATION_THINBLOOD)
			new_clan.covens_to_select = COVENS_PER_WRETCH_CLAN

	// Apply the custom clan
	vampdude.set_clan_direct(new_clan)
	clan_selected = TRUE

	to_chat(vampdude, span_notice("You are now a member of the [custom_clan_name] clan ([custom_clan_desc]) with [length(selected_covens)] coven(s)."))


/datum/antagonist/vampire/proc/get_custom_clan_details(mob/living/carbon/human/vampdude, default_name, default_desc)
	var/custom_clan_name = tgui_input_text(vampdude, "Enter your custom clan name:", "Custom Clan", default_name, encode = FALSE)
	if(!custom_clan_name)
		custom_clan_name = default_name
	var/custom_clan_desc = tgui_input_text(vampdude, "Describe your clan:", "Clan Description", default_desc, encode = FALSE)
	if(!custom_clan_desc)
		custom_clan_desc = default_desc
	return list(custom_clan_name, custom_clan_desc)

/datum/antagonist/vampire/proc/after_gain()
	owner.current.set_bloodpool(owner.current.maxbloodpool / 100 * INITIAL_BLOODPOOL_PERCENTAGE)
	add_antag_hud(antag_hud_type, antag_hud_name, owner.current)

/datum/antagonist/vampire/on_removal()
	remove_antag_hud(antag_hud_type, owner.current)
	if(ishuman(owner.current))
		var/mob/living/carbon/human/vampdude = owner.current
		// Remove the clan when losing antagonist status
		vampdude.set_clan(null)
	owner.current?.hud_used?.shutdown_bloodpool()
	if(!silent && owner.current)
		to_chat(owner.current, span_danger("I am no longer a [job_rank]!"))
	owner.special_role = null
	return ..()

/datum/antagonist/vampire/proc/equip()
	return

// Custom clan datum for player-created clans
/datum/clan/custom
	name = "Custom Clan"
	selectable_by_vampires = FALSE

/obj/structure/vampire
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	density = TRUE

/obj/structure/vampire/Initialize()
	GLOB.vampire_objects |= src
	. = ..()

/obj/structure/vampire/Destroy()
	GLOB.vampire_objects -= src
	return ..()

// LANDMARKS
/obj/effect/landmark/start/vampirelord
	name = "Vampire Lord"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirelord/Initialize()
	. = ..()
	GLOB.vlord_starts += loc

/obj/effect/landmark/start/vampirespawn
	name = "Vampire Spawn"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirespawn/Initialize()
	. = ..()
	GLOB.vspawn_starts += loc

/obj/effect/landmark/start/vampireknight
	name = "Death Knight"
	icon_state = "arrow"
	jobspawn_override = list("Death Knight")
	delete_after_roundstart = FALSE

/obj/effect/landmark/vteleport
	name = "Teleport Destination"
	icon_state = "x2"

/obj/effect/landmark/vteleportsending
	name = "Teleport Sending"
	icon_state = "x2"

/obj/effect/landmark/vteleportdestination
	name = "Return Destination"
	icon_state = "x2"
	var/amuletname

/obj/effect/landmark/vteleportsenddest
	name = "Sending Destination"
	icon_state = "x2"

// Prefabs for admin
/datum/antagonist/vampire/thinblood
	name = "Thinblood"
	show_in_antagpanel = TRUE

/datum/antagonist/vampire/thinblood/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation = GENERATION_THINBLOOD)
	. = ..(incoming_clan, forced_clan, generation)

/datum/antagonist/vampire/crimson
	name = "Crimson Blood"
	show_in_antagpanel = TRUE
	show_in_roundend = FALSE
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "Vspawn"

/datum/antagonist/vampire/crimson/New(incoming_clan = /datum/clan/crimson_blood, forced_clan = FALSE, generation = GENERATION_CRIMSONBLOOD)
	. = ..(incoming_clan, forced_clan, generation)

/datum/antagonist/vampire/crimson/on_gain()
	SSmapping.retainer.vampires |= owner
	owner.special_role = name
	owner.current.adjust_bloodpool()
	if(ishuman(owner.current))
		var/mob/living/carbon/human/vampdude = owner.current
		vampdude.hud_used?.shutdown_bloodpool()
		vampdude.hud_used?.initialize_bloodpool()
		vampdude.hud_used?.bloodpool.set_fill_color("#510000")

		// Crimson-blooded always create custom clans like Wretches
		create_custom_clan(vampdude)

	after_gain()
	equip()


/datum/antagonist/vampire/crimson/create_custom_clan(mob/living/carbon/human/vampdude)
	// Get custom clan name via input with fallback
	to_chat(vampdude, span_notice("<b>Customize your Crimson Blood clan...</b>"))
	
	var/custom_clan_name = tgui_input_text(vampdude, "Enter your custom clan name:", "Custom Clan", "Custom Crimson Clan", encode = FALSE, timeout = 60 SECONDS)
	if(!custom_clan_name)
		custom_clan_name = input(vampdude, "Enter your custom clan name:", "Custom Clan", "Custom Crimson Clan") as text|null
	if(!custom_clan_name)
		custom_clan_name = "Custom Crimson Clan"
	
	var/custom_clan_desc = tgui_input_text(vampdude, "Describe your clan:", "Clan Description", "A custom vampire clan with crimson blood traits.", encode = FALSE, timeout = 60 SECONDS)
	if(!custom_clan_desc)
		custom_clan_desc = input(vampdude, "Describe your clan:", "Clan Description", "A custom vampire clan with crimson blood traits.") as text|null
	if(!custom_clan_desc)
		custom_clan_desc = "A custom vampire clan with crimson blood traits."

	var/datum/clan/crimson_blood/new_clan = new /datum/clan/crimson_blood()
	new_clan.name = custom_clan_name
	new_clan.desc = custom_clan_desc
	new_clan.covens_to_select = 1

	// Apply the custom clan
	vampdude.set_clan_direct(new_clan)
	clan_selected = TRUE

	// Add verb to re-customize if they're the leader
	if(new_clan.clan_leader == vampdude)
		vampdude.verbs += /mob/living/carbon/human/proc/recustomize_crimson_clan

	to_chat(vampdude, span_notice("You are now a member of the [custom_clan_name] clan. [new_clan.clan_leader == vampdude ? "Use the 'Recustomize Clan' verb in the VAMPIRE tab if you want to change the name/description." : ""]"))

/mob/living/carbon/human/proc/recustomize_crimson_clan()
	set name = "Recustomize Clan"
	set category = "VAMPIRE"
	
	if(!clan || !istype(clan, /datum/clan/crimson_blood))
		to_chat(src, span_warning("You don't have a crimson blood clan to customize!"))
		verbs -= /mob/living/carbon/human/proc/recustomize_crimson_clan
		return
	
	if(clan.clan_leader != src)
		to_chat(src, span_warning("Only the clan leader can recustomize the clan!"))
		verbs -= /mob/living/carbon/human/proc/recustomize_crimson_clan
		return
	
	var/new_name = tgui_input_text(src, "Enter your custom clan name:", "Custom Clan", clan.name, encode = FALSE, timeout = 240 SECONDS)
	if(!new_name)
		new_name = input(src, "Enter your custom clan name:", "Custom Clan", clan.name) as text|null
	if(!new_name)
		return
	
	var/new_desc = tgui_input_text(src, "Describe your clan:", "Clan Description", clan.desc, encode = FALSE, timeout = 240 SECONDS)
	if(!new_desc)
		new_desc = input(src, "Describe your clan:", "Clan Description", clan.desc) as text|null
	if(!new_desc)
		return
	
	clan.name = new_name
	clan.desc = new_desc
	to_chat(src, span_notice("Clan updated to: [new_name] - [new_desc]"))
	
	// Remove the verb after use
	verbs -= /mob/living/carbon/human/proc/recustomize_crimson_clan

/// Similarly as before, just a prefab for admins to give them via Traitor Panel
/datum/antagonist/vampire/licker
	name = "Licker - Neonate"
	show_in_antagpanel = TRUE

/datum/antagonist/vampire/licker/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation = GENERATION_NEONATE)
	. = ..(incoming_clan, forced_clan, generation)

/// Just a prefab for admins to give them via Traitor Panel, otherwise unused because vars can be normally passed in parent's New()
/datum/antagonist/vampire/ancillae
	name = "Ancillae"
	show_in_antagpanel = TRUE

/datum/antagonist/vampire/ancillae/New(incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE, generation = GENERATION_ANCILLAE)
	. = ..()


