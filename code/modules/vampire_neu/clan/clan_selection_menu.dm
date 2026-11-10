/datum/vampire_clan_selection_menu
	var/mob/living/carbon/human/vampdude
	var/default_clan
	var/choice
	var/custom_name
	var/closed = FALSE

/datum/vampire_clan_selection_menu/New(mob/living/carbon/human/vampdude, default_clan)
	. = ..()
	src.vampdude = vampdude
	src.default_clan = default_clan

/datum/vampire_clan_selection_menu/Destroy(force)
	SStgui.close_uis(src)
	vampdude = null
	return ..()

/datum/vampire_clan_selection_menu/proc/wait()
	while(!choice && !closed && !QDELETED(src))
		stoplag(1)

/datum/vampire_clan_selection_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/vampire_clan_selection_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VampireClanSelection")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/vampire_clan_selection_menu/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/vampire_clan_selection_menu/ui_static_data(mob/user)
	var/list/data = list()
	var/list/clans = list()
	var/list/covens_by_id = list()
	for(var/clan_type in subtypesof(/datum/clan))
		var/datum/clan/clan = new clan_type
		if(clan.selectable_by_vampires)
			clans += list(clan_to_ui("[clan_type]", clan, covens_by_id))
		qdel(clan)

	var/datum/clan/custom/custom_clan = new
	custom_clan.set_covens_for_generation(vampdude?.get_vampire_generation())
	var/list/custom_entry = clan_to_ui("custom", custom_clan, covens_by_id)
	custom_entry["isCustom"] = TRUE
	clans += list(custom_entry)
	qdel(custom_clan)

	var/list/covens = list()
	for(var/coven_id in covens_by_id)
		covens += list(covens_by_id[coven_id])

	var/datum/clan/fallback = default_clan
	data["clans"] = clans
	data["covens"] = covens
	data["defaultClanId"] = "[default_clan]"
	data["defaultClanName"] = fallback ? initial(fallback.name) : ""
	data["maxNameLength"] = MAX_NAME_LEN
	return data

/datum/vampire_clan_selection_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("accept_clan")
			var/clan_id = params["clan_id"]
			if(clan_id == "custom")
				var/raw_name = params["custom_name"]
				custom_name = istext(raw_name) ? copytext_char(trim(raw_name), 1, MAX_NAME_LEN + 1) : ""
				choice = "custom"
			else
				var/clan_type = text2path(clan_id)
				if(!is_selectable_clan(clan_type))
					return
				choice = clan_type
			SStgui.close_uis(src)
			return TRUE
		if("close")
			SStgui.close_uis(src)
			return TRUE

/datum/vampire_clan_selection_menu/proc/is_selectable_clan(clan_type)
	if(!ispath(clan_type, /datum/clan))
		return FALSE
	var/datum/clan/clan = clan_type
	return initial(clan.selectable_by_vampires)

/datum/vampire_clan_selection_menu/proc/clan_to_ui(clan_id, datum/clan/clan, list/covens_by_id)
	var/list/coven_ids = list()
	for(var/coven_type in clan.clane_covens)
		var/coven_id = "[coven_type]"
		coven_ids += coven_id
		if(!covens_by_id[coven_id])
			covens_by_id[coven_id] = coven_to_ui(coven_type)

	var/list/lord_forms = list()
	var/list/lord_traits = list()
	var/vitae_bonus = 0
	var/leader_type = clan.leader
	var/datum/clan_leader/leader = ispath(leader_type) ? new leader_type() : leader_type
	if(istype(leader))
		for(var/spell_type in leader.lord_spells)
			lord_forms += list(lord_form_to_ui(spell_type))
		lord_traits = traits_to_ui(leader.lord_traits)
		vitae_bonus = leader.vitae_bonus
		if(ispath(leader_type))
			qdel(leader)

	return list(
		"id" = clan_id,
		"name" = clan.name,
		"desc" = clan.desc,
		"curse" = clan.curse,
		"downside" = clan.get_downside_string(),
		"bloodPreference" = clan.get_blood_preference_string(),
		"tagline" = clan.tagline,
		"isCustom" = FALSE,
		"covensToSelect" = clan.covens_to_select,
		"covenIds" = coven_ids,
		"clanTraits" = traits_to_ui(clan.extra_clan_traits),
		"lordTitle" = clan.leader_title,
		"lordForms" = lord_forms,
		"lordTraits" = lord_traits,
		"vitaeBonus" = vitae_bonus,
	)

/datum/vampire_clan_selection_menu/proc/coven_to_ui(coven_type)
	var/datum/coven/coven = coven_type
	var/list/powers = list()
	for(var/power_type in sortTim(subtypesof(initial(coven.power_type)), GLOBAL_PROC_REF(cmp_coven_power_level_asc)))
		var/datum/coven_power/power = power_type
		powers += list(list(
			"name" = initial(power.name),
			"level" = initial(power.level),
			"desc" = initial(power.desc),
			"vitaeCost" = initial(power.vitae_cost),
		))
	return list(
		"id" = "[coven_type]",
		"name" = initial(coven.name),
		"desc" = initial(coven.desc),
		"powers" = powers,
	)

/datum/vampire_clan_selection_menu/proc/lord_form_to_ui(spell_type)
	var/obj/effect/proc_holder/spell/spell = spell_type
	return list(
		"name" = initial(spell.name),
		"desc" = get_lord_form_flavor(spell_type) || initial(spell.desc),
	)

/datum/vampire_clan_selection_menu/proc/get_lord_form_flavor(spell_type)
	switch(spell_type)
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/rat)
			return "Shed your kindred shape for that of a sewer rat — slip through cracks no man could pass."
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat)
			return "Take wing as a winged shadow — quick, elusive, hard to strike."
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform)
			return "Dissolve into mist — untouchable, but thinly bound to this world."
		if(/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit)
			return "A graceful, deceptively meek shape — beauty as camouflage, fang behind a smile."

/datum/vampire_clan_selection_menu/proc/traits_to_ui(list/traits)
	var/list/result = list()
	for(var/trait in traits)
		var/description = GLOB.roguetraits[trait]
		result += list(list(
			"name" = trait,
			"desc" = istext(description) ? GLOB.html_tags.Replace(description, "") : "",
		))
	return result
