#define VAMPCOST_ONE 8000
#define VAMPCOST_TWO 10000
#define VAMPCOST_THREE 12000
#define VAMPCOST_FOUR 14000
#define ARMOR_COST 5000
#define SUN_STEAL_COST 10000
#define SERVANT_COST 800
#define SERVANT_T2_COST 2500
#define SERVANT_T3_COST 4000

#define INITIATE_LORDE 1
#define INITIATE_ANYONE 2

/obj/structure/vampire/bloodpool
	name = "Crimson Crucible"
	icon_state = "vat"
	var/current = 0
	var/datum/clan/owner_clan

	var/list/active_projects = list()
	var/list/available_project_types = list(
		/datum/vampire_project/power_growth,
		/datum/vampire_project/armor_crafting,
		/datum/vampire_project/servant/servant_t1,
		/datum/vampire_project/servant/servant_t2,
		/datum/vampire_project/servant/servant_t3,
		/datum/vampire_project/sunsteal,
	)
	var/sunstolen = FALSE

/obj/structure/vampire/bloodpool/Initialize(mapload)
	. = ..()
	set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)

/obj/structure/vampire/bloodpool/examine(mob/user)
	. = ..()
	to_chat(user, span_boldnotice("Blood level: [current]"))

	// Show active projects
	if(active_projects.len)
		to_chat(user, span_notice("Active Projects:"))
		for(var/project_key in active_projects)
			var/datum/vampire_project/project = active_projects[project_key]
			var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
			to_chat(user, span_notice("- [project.display_name]: [project.paid_amount]/[project.total_cost] ([progress_percent]%)"))

/obj/structure/vampire/bloodpool/attack_hand(mob/living/user)
	if(!user.mind?.has_antag_datum(/datum/antagonist/vampire))
		return
	ui_interact(user)

/obj/structure/vampire/bloodpool/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/vampire/bloodpool/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrimsonCrucible", name)
		ui.open()

/obj/structure/vampire/bloodpool/ui_static_data(mob/user)
	var/list/data = list()
	var/list/projects = list()
	for(var/project_type in subtypesof(/datum/vampire_project))
		var/datum/vampire_project/project = get_project_prototype(project_type)
		projects += list(list(
			"type" = "[project_type]",
			"name" = project.display_name,
			"description" = project.description,
			"cost" = project.total_cost,
			"lockedReason" = project.start_failure_message,
		))
	data["projects"] = projects
	return data

/obj/structure/vampire/bloodpool/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/living_user = user
	if(!istype(living_user))
		return data

	var/is_lord = is_crucible_lord(living_user)
	var/list/active_project_data = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/list/contributor_data = list()
		for(var/mob/living/contributor in project.contributors)
			contributor_data += list(list(
				"name" = contributor.real_name,
				"amount" = project.contributors[contributor],
			))
		active_project_data += list(list(
			"type" = "[project_type]",
			"paid" = project.paid_amount,
			"maxContribution" = max(project.get_max_contribution(living_user), 0),
			"contributors" = contributor_data,
		))

	var/list/available_project_data = list()
	if(is_lord)
		for(var/project_type in available_project_types)
			if(active_projects[project_type])
				continue
			var/datum/vampire_project/project = get_project_prototype(project_type)
			available_project_data += list(list(
				"type" = "[project_type]",
				"canStart" = project.can_start(living_user, src, TRUE),
			))

	data["isLord"] = is_lord
	data["vitae"] = living_user.get_bloodpool()
	data["maxVitae"] = living_user.get_maxbloodpool()
	data["activeProjects"] = active_project_data
	data["availableProjects"] = available_project_data
	return data

/obj/structure/vampire/bloodpool/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/user = ui.user
	if(!istype(user) || !user.mind?.has_antag_datum(/datum/antagonist/vampire))
		return

	switch(action)
		if("start_project")
			var/project_type = text2path(params["type"])
			if(!is_crucible_lord(user) || !(project_type in available_project_types) || active_projects[project_type])
				return
			return start_new_project(project_type, user)
		if("contribute")
			var/datum/vampire_project/project = get_active_project(params["type"])
			if(!project)
				return
			return project.handle_contribution(user)
		if("cancel_project")
			var/datum/vampire_project/project = get_active_project(params["type"])
			if(!project || !is_crucible_lord(user))
				return
			if(tgui_alert(user, "Cancel [project.display_name]? All invested vitae will be refunded.", "CANCELLATION", list("Yes", "No")) != "Yes")
				return
			if(QDELETED(src) || get_active_project(params["type"]) != project || !is_crucible_lord(user))
				return
			cancel_project(project.type)
			return TRUE

/obj/structure/vampire/bloodpool/proc/is_crucible_lord(mob/living/user)
	return !!user.clan && user.clan.clan_leader == user

/obj/structure/vampire/bloodpool/proc/get_active_project(project_type_text)
	var/project_type = text2path(project_type_text)
	if(!project_type)
		return null
	return active_projects[project_type]

/obj/structure/vampire/bloodpool/proc/get_project_prototype(project_type)
	var/static/list/prototypes = list()
	var/datum/vampire_project/prototype = prototypes[project_type]
	if(!prototype)
		prototype = new project_type()
		prototypes[project_type] = prototype
	return prototype

/obj/structure/vampire/bloodpool/proc/start_new_project(project_type, mob/living/user)
	var/datum/vampire_project/project = new project_type()

	if(!project.can_start(user, src))
		to_chat(user, span_warning(project.start_failure_message))
		qdel(project)
		return

	project.bloodpool = src
	project.initiator = user
	project.initiator_clan = user.clan
	project.on_start(user)

	active_projects[project_type] = project

	to_chat(user, span_greentext("Started project: [project.display_name]. Begin contributing vitae to progress."))
	return TRUE

/obj/structure/vampire/bloodpool/proc/complete_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	// Detach before running effects, so a second call can't run them (or a refund) again
	active_projects.Remove(project_type)

	// Notify all contributors
	for(var/mob/living/contributor in project.contributors)
		to_chat(contributor, span_boldannounce("[project.display_name] has been completed!"))
		contributor.playsound_local(get_turf(src), project.completion_sound, 100, FALSE, pressure_affected = FALSE)

	// Execute project completion
	project.on_complete(src)

	qdel(project)

/obj/structure/vampire/bloodpool/proc/cancel_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	active_projects.Remove(project_type)

	project.on_cancel()

	qdel(project)

/datum/vampire_project
	var/display_name = "Unknown Project"
	var/description = "A mysterious undertaking."
	var/total_cost = 1000
	var/paid_amount = 0
	/// Assoc list of contributor mob -> vitae they personally paid in, so refunds can't mint blood
	var/list/contributors = list()
	var/obj/structure/vampire/bloodpool/bloodpool
	var/mob/living/initiator
	var/datum/clan/initiator_clan
	var/start_failure_message = "This project cannot be started."
	var/completion_sound = 'sound/misc/batsound.ogg'
	var/can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/proc/can_start(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool, silent = FALSE)
	if(!istype(user) || !istype(pool))
		return FALSE

	if(can_be_initiated_by == INITIATE_ANYONE)
		return TRUE
	else if(can_be_initiated_by == INITIATE_LORDE)
		if(user.clan.clan_leader == user)
			return TRUE
		else
			if(!silent)
				to_chat(user, span_warning("This project can only be initiate by your Lorde."))
			return FALSE

	return TRUE

/datum/vampire_project/proc/on_start(mob/living/user)
	return

/datum/vampire_project/proc/get_max_contribution(mob/living/user)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	var/headroom = total_cost - paid_amount
	if(!lord && (display_name != "Wicked Plate") && (display_name != "World Anchor"))
		headroom -= 100
	return min(user.get_bloodpool(), headroom)

/datum/vampire_project/proc/handle_contribution(mob/living/user)
	var/max_contribution = get_max_contribution(user)
	if(max_contribution <= 0)
		to_chat(user, span_warning("I have nothing left to give to [display_name]."))
		return

	var/contribution = tgui_input_number(user, "How much vitae to contribute? (Max: [max_contribution])", "CONTRIBUTION", max_contribution, max_contribution, 0)

	if(!contribution || contribution <= 0)
		return

	// Revalidate after the blocking prompt - the project may have finished, been cancelled, or been paid down further
	if(QDELETED(src) || !bloodpool || !(bloodpool.active_projects[type] == src))
		to_chat(user, span_warning("[display_name] is no longer underway."))
		return

	if(get_dist(user, bloodpool) > 1)
		to_chat(user, span_warning("I need to be next to the crucible."))
		return

	if(user.get_bloodpool() < contribution)
		to_chat(user, span_warning("I do not have enough vitae."))
		return

	max_contribution = get_max_contribution(user)
	if(max_contribution <= 0)
		to_chat(user, span_warning("I have nothing left to give to [display_name]."))
		return

	contribution = clamp(round(contribution), 1, max_contribution)

	user.adjust_bloodpool(-contribution)
	paid_amount += contribution
	contributors[user] += contribution

	to_chat(user, span_greentext("Contributed [contribution] vitae to [display_name]. ([paid_amount]/[total_cost])"))

	if(paid_amount >= total_cost)
		bloodpool.complete_project(type)
	return TRUE

/datum/vampire_project/proc/on_complete()
	return

/datum/vampire_project/proc/on_cancel()
	// Refund each contributor exactly what they paid in, then zero the ledger so it can't be paid out twice
	for(var/mob/living/contributor in contributors)
		var/refund_amount = contributors[contributor]
		if(refund_amount <= 0)
			continue
		contributor.adjust_bloodpool(refund_amount)
		to_chat(contributor, span_notice("Received [refund_amount] vitae refund from cancelled project: [display_name]"))

	contributors.Cut()
	paid_amount = 0

// Specific project types
/datum/vampire_project/power_growth
	display_name = "Rite of Stirring"
	description = "The ancient blood stirs once more. Forgotten whispers echo through the marrow of the land."
	total_cost = VAMPCOST_ONE
	completion_sound = 'sound/misc/batsound.ogg'
	start_failure_message = "Only the Methuselah may perform this rite."

/datum/vampire_project/power_growth/can_start(mob/living/user, obj/structure/vampire/bloodpool/pool)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	return lord && !lord.ascended

/datum/vampire_project/power_growth/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			bloodpool.available_project_types -= /datum/vampire_project/power_growth
			bloodpool.available_project_types += /datum/vampire_project/power_growth_2
			break

/datum/vampire_project/power_growth_2
	display_name = "Rite of Reclamation"
	description = "Strength long sealed returns. The soil, the stone, and the shadows bend again to their rightful master."
	total_cost = VAMPCOST_TWO
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_2/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_2
			bloodpool.available_project_types += /datum/vampire_project/power_growth_3
			break

/datum/vampire_project/power_growth_3
	display_name = "Rite of Dominion"
	description = "The veil of time shreds. The Elder's will pours forth, binding trespassers within the grasp of the Land."
	total_cost = VAMPCOST_THREE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_3/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_3
			bloodpool.available_project_types += /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/power_growth_4
	display_name = "Rite of Sovereignty"
	description = "The Lord is whole. Ancient power saturates every stone and vein, for the Land and its master are one."
	total_cost = VAMPCOST_FOUR
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_4/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			to_chat(user, span_danger("I AM ANCIENT, I AM THE LAND. EVEN THE SUN BOWS TO ME."))
			lord.ascended = TRUE
			var/list/all_subordinates = user.clan_position.get_all_subordinates()
			for(var/mob/living/carbon/human/subordinate_body  in all_subordinates)
				subordinate_body.adjust_maxbloodpool(1000)
				for(var/S in MOBSTATS)
					subordinate_body.change_stat(S, 2)

			bloodpool.available_project_types -= /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/armor_crafting
	display_name = "Wicked Plate"
	description = "Craft a complete set of vampiric armor from crystallized blood."
	total_cost = 5000
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/armor_crafting/on_complete(atom/movable/creation_point)
	new /obj/item/clothing/under/roguetown/platelegs/vampire (bloodpool.loc)
	new /obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire (bloodpool.loc)
	new /obj/item/clothing/suit/roguetown/armor/plate/vampire (bloodpool.loc)
	new /obj/item/clothing/shoes/roguetown/boots/armor/vampire (bloodpool.loc)
	new /obj/item/clothing/head/roguetown/helmet/heavy/vampire (bloodpool.loc)
	new /obj/item/clothing/gloves/roguetown/chain/vampire (bloodpool.loc)
	creation_point.visible_message(span_notice("A complete set of armor materializes from the crimson crucible."))

/datum/vampire_project/sunsteal
	display_name = "Steal the Sun"
	description = "The scorching gaze of the Sun-Tyrant shall hamper our plans no more. This project can only be initiated by your lorde."
	total_cost = SUN_STEAL_COST
	completion_sound = 'sound/misc/vcraft.ogg'
	can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/sunsteal/on_complete(atom/movable/creation_point)
	var/obj/structure/vampire/bloodpool/bloodpool = creation_point
	if(!istype(bloodpool))
		return

	SSticker.sunsteal(initiator_clan?.clan_leader)

/datum/vampire_project/servant/proc/summon(type, atom/feedback_atom)
	feedback_atom.visible_message("The crucible stirs, summoning a servant from the realms beyond...")
	var/list/candidates = pollGhostCandidates("Do you want to play as a Vampire's [type]?", ROLE_VAMPIRE_SUMMON, null, null, 10 SECONDS, POLL_IGNORE_VL_SERVANT)
	if(!LAZYLEN(candidates))
		feedback_atom.visible_message("But alas, the depths are hollow...")
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		feedback_atom.visible_message("But alas, the depths are hollow...")
		return FALSE

	. = TRUE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/human/northern/target = new /mob/living/carbon/human/species/human/northern(get_turf(feedback_atom))
	target.key = C.key
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, load_char_or_namechoice)), 3 SECONDS)
	switch(type)
		if("Vampire Servant")
			SSjob.EquipRank(target, "Vampire Servant", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_THINBLOOD)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Guard")
			SSjob.EquipRank(target, "Vampire Guard", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_NEONATE)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Spawn")
			SSjob.EquipRank(target, "Vampire Spawn", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_ANCILLAE)
			target.mind.add_antag_datum(new_antag)
	ADD_TRAIT(target, TRAIT_BLOODPOOL_BORN, TRAIT_GENERIC)

/datum/vampire_project/servant/servant_t1
	display_name = "Summon Servant"
	description = "A loyal servant to do your bidding."
	total_cost = SERVANT_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t1/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Servant", creation_point))
		on_cancel()

/datum/vampire_project/servant/servant_t2
	display_name = "Summon Guard"
	description = "A loyal servant to do your bidding."
	total_cost = SERVANT_T2_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t2/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Guard", creation_point))
		on_cancel()

/datum/vampire_project/servant/servant_t3
	display_name = "Summon Knight Spawn"
	description = "A loyal servant to do your bidding."
	total_cost = SERVANT_T3_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t3/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Spawn", creation_point))
		on_cancel()

#undef VAMPCOST_ONE
#undef VAMPCOST_TWO
#undef VAMPCOST_THREE
#undef VAMPCOST_FOUR
#undef ARMOR_COST
#undef SUN_STEAL_COST
#undef SERVANT_COST
#undef SERVANT_T2_COST
#undef SERVANT_T3_COST
