GLOBAL_LIST_EMPTY(vampire_objects)
#define INITIAL_BLOODPOOL_PERCENTAGE 40
/datum/antagonist/vampire
	name = "Vampire"
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "vamp_spawn_hud"
	confess_lines = list(
		"I WANT YOUR BLOOD!",
		"DRINK THE BLOOD!",
		"CHILD OF KAIN!",
	)
	rogue_enabled = TRUE
	typecache_datum_blacklist = list(/datum/antagonist/zombie) //the rot cannot claim what the Curse already holds
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
	var/research_spent = 0
	var/list/pre_embrace_state

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
		if(GENERATION_THINBLOOD)
			return 0.25 // You are not even an antagonist
		else
			return 1 // Default weight if generation not set

/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("Kaine's firstborn!")
	if(istype(examined_datum, /datum/antagonist/vampire))
		return span_boldnotice("A child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite.")

/datum/antagonist/vampire/on_gain()
	// the Curse takes precedence over the rot - covers dying to it partway through being sired
	owner?.remove_antag_datum(/datum/antagonist/zombie)
	owner?.current?.remove_status_effect(/datum/status_effect/zombie_infection)
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
	if(vampdude.job == "Wretch")
		create_custom_clan(vampdude)
		return

	var/fallback_clan = /datum/clan/nosferatu
	var/choice
	var/custom_name
	if(vampdude.client)
		var/datum/vampire_clan_selection_menu/menu = new(vampdude, fallback_clan)
		menu.ui_interact(vampdude)
		if(SStgui.get_open_ui(vampdude, menu))
			menu.wait()
		if(!QDELETED(menu))
			choice = menu.choice
			custom_name = menu.custom_name
			qdel(menu)

	if(choice == "custom")
		create_custom_clan(vampdude, custom_name)
		return

	default_clan = choice || fallback_clan
	vampdude.set_clan(default_clan)
	clan_selected = TRUE

/datum/antagonist/vampire/proc/create_custom_clan(mob/living/carbon/human/vampdude, custom_name)
	// Get custom clan name
	if(isnull(custom_name))
		custom_name = tgui_input_text(vampdude, "Enter your custom clan name:", "Custom Clan", "Custom Clan", MAX_NAME_LEN, encode = FALSE)
	custom_clan_name = sanitize(custom_name)
	if(!custom_clan_name)
		custom_clan_name = "Custom Clan"

	var/datum/clan/custom/new_clan = new /datum/clan/custom()
	new_clan.name = custom_clan_name
	new_clan.set_covens_for_generation(vampdude.get_vampire_generation())

	// Apply the custom clan
	vampdude.set_clan_direct(new_clan)
	clan_selected = TRUE

	to_chat(vampdude, span_notice("You are now a member of the [custom_clan_name] clan with [length(selected_covens)] coven(s)."))

/datum/antagonist/vampire/proc/after_gain()
	owner.current.set_bloodpool(owner.current.get_maxbloodpool() / 100 * INITIAL_BLOODPOOL_PERCENTAGE)
	antag_hud_name = get_hud_icon()
	add_antag_hud(antag_hud_type, antag_hud_name, owner.current)

/// The HUD icon for this vampire's rank
/datum/antagonist/vampire/proc/get_hud_icon()
	if(owner?.current && HAS_TRAIT(owner.current, TRAIT_CLAN_LEADER))
		return "vamp_lord_hud"
	return "vamp_spawn_hud"

/// Re-picks the HUD icon after a rank change, such as gaining or losing clan leadership
/datum/antagonist/vampire/proc/update_hud_icon()
	antag_hud_name = get_hud_icon()
	if(owner?.current && owner.antag_hud == GLOB.huds[antag_hud_type])
		set_antag_hud(owner.current, antag_hud_name)

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
	tagline = "Forge your own cursed bloodline"
	selectable_by_vampires = FALSE

/datum/clan/custom/proc/set_covens_for_generation(generation)
	switch(generation)
		if(GENERATION_NEONATE, GENERATION_THINBLOOD)
			covens_to_select = COVENS_PER_WRETCH_CLAN

/obj/structure/vampire
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	density = TRUE

/obj/structure/vampire/Initialize(mapload)
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

/obj/effect/landmark/start/vampirelord/Initialize(mapload)
	. = ..()
	GLOB.vlord_starts += loc

/obj/effect/landmark/start/vampirespawn
	name = "Vampire Spawn"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirespawn/Initialize(mapload)
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


