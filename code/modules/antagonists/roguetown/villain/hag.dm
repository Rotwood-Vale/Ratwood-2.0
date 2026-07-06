/datum/antagonist/hag
	name = "Hag"
	roundend_category = "Hags"
	antagpanel_category = "Hag"
	show_name_in_check_antagonists = TRUE
	job_rank = ROLE_HAG
	rogue_enabled = TRUE
	can_coexist_with_others = FALSE
	confess_lines = list(
		"I HEAR THE MOSSMOTHER'S WHISPERS!",
		"THE BOG HAS CLAIMED ME!",
		"MY GIFTS ALWAYS COME DUE!",
	)

	var/list/datum/mind/bound_followers = list()
	var/list/follower_links = list()
	var/datum/mindlink_coven/coven_link
	var/hag_baseline_applied = FALSE
	var/hag_tier = 1
	var/datum/component/hag_curio_tracker/curio_component
	var/list/saved_hag_stats = null
	var/list/saved_hag_skill_levels = null
	var/list/saved_hag_skill_experience = null

/datum/antagonist/hag/get_antag_cap_weight()
	return 2

/datum/antagonist/hag/on_gain(admin_granted = FALSE)
	. = ..()
	if(!owner || !owner.current)
		return
	var/mob/living/carbon/human/hag_body = owner.current

	owner.special_role = name
	if(!objectives.len)
		var/datum/objective/hag/revenge_objective = new /datum/objective/hag(owner = owner)
		objectives += revenge_objective
		owner.store_memory("Objective: [revenge_objective.explanation_text]")

	if(hag_body)
		if(admin_granted)
			// Admin/manual grants often happen mid-round with occupied slots.
			// Clear equipment first so the hag loadout applies deterministically.
			hag_body.unequip_everything()
		var/datum/job/roguetown/hag/hag_job = get_hag_job_datum()
		capture_hag_baseline_state(hag_body, hag_job)
		hag_body.equipOutfit(hag_job.outfit)
		apply_hag_baseline(hag_body)

	if(length(GLOB.hag_starts))
		owner.current.forceMove(pick(GLOB.hag_starts))

	bind_to_heart()

	greet()

/datum/antagonist/hag/greet()
	to_chat(owner.current, span_userdanger("The bog answers my spite. Bind mortals to my will and prepare my revenge."))
	owner.announce_objectives()
	..()

/datum/outfit/job/roguetown/hag/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/hag
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	beltl = /obj/item/storage/belt/rogue/pouch/coins/aalloy
	beltr = /obj/item/roguekey/hag
	backpack_contents = list(
		/obj/item/handmirror/hag = 1
	)
	if(H.mind)
		H.verbs += /mob/living/carbon/human/proc/commune_with_roots

/datum/antagonist/hag/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!hag_body || !hag_body.mind)
		return
	ADD_TRAIT(hag_body, TRAIT_ANCIENT_HAG, "[type]")
	ensure_single_spell(hag_body.mind, /obj/effect/proc_holder/spell/invoked/hag_pact)
	ensure_single_spell(hag_body.mind, /obj/effect/proc_holder/spell/invoked/transmutation_rite)
	ensure_single_spell(hag_body.mind, /obj/effect/proc_holder/spell/invoked/spiritual_siphon)
	ensure_single_spell(hag_body.mind, /obj/effect/proc_holder/spell/invoked/grant_boon)
	ensure_single_spell(hag_body.mind, /obj/effect/proc_holder/spell/self/wildshape/hag_true_form)
	ensure_single_spell(hag_body.mind, /obj/effect/proc_holder/spell/invoked/resurrect/hag)
	teach_hag_recipes(hag_body.mind)
	// Attach the curio tracker component for death/revive handling
	curio_component = hag_body.AddComponent(/datum/component/hag_curio_tracker, src)

/datum/antagonist/hag/proc/ensure_single_spell(datum/mind/hag_mind, spell_type)
	if(!hag_mind || !spell_type)
		return
	var/seen = FALSE
	for(var/obj/effect/proc_holder/spell/S in hag_mind.spell_list.Copy())
		if(S.type != spell_type)
			continue
		if(!seen)
			seen = TRUE
			continue
		hag_mind.RemoveSpell(S)
	if(!seen)
		hag_mind.AddSpell(new spell_type)

/datum/antagonist/hag/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!hag_body || !hag_body.mind)
		return
	var/datum/job/roguetown/hag/hag_job = get_hag_job_datum()
	if(hag_job)
		for(var/trait in hag_job.job_traits)
			REMOVE_TRAIT(hag_body, trait, "[type]")
	else
		REMOVE_TRAIT(hag_body, TRAIT_ANCIENT_HAG, "[type]")
	hag_baseline_applied = FALSE
	qdel(hag_body.GetComponent(/datum/component/hag_curio_tracker))
	curio_component = null
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/hag_pact)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/transmutation_rite)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/spiritual_siphon)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/grant_boon)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/wildshape/hag_true_form)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/resurrect/hag)
	hag_body.verbs -= /mob/living/carbon/human/proc/commune_with_roots
	restore_hag_baseline_state(hag_body)

/datum/antagonist/hag/proc/apply_hag_baseline(mob/living/carbon/human/hag_body)
	if(!hag_body || !hag_body.mind || hag_baseline_applied)
		return

	var/datum/job/roguetown/hag/hag_job = get_hag_job_datum()
	if(!hag_job)
		return

	for(var/trait in hag_job.job_traits)
		if(trait in hag_body.dna?.species?.banned_traits)
			continue
		ADD_TRAIT(hag_body, trait, "[type]")

	for(var/stat in hag_job.job_stats)
		hag_body.change_stat(stat, hag_job.job_stats[stat])

	for(var/skill in hag_job.skills)
		hag_body.adjust_skillrank_up_to(skill, hag_job.skills[skill], TRUE)

	hag_baseline_applied = TRUE

/datum/antagonist/hag/proc/get_hag_job_datum()
	var/static/datum/job/roguetown/hag/hag_job
	if(!hag_job)
		hag_job = new /datum/job/roguetown/hag()
	return hag_job

/datum/antagonist/hag/proc/capture_hag_baseline_state(mob/living/carbon/human/hag_body, datum/job/roguetown/hag/hag_job)
	if(!hag_body)
		return

	if(!hag_job)
		return
	saved_hag_stats = list()
	for(var/stat in hag_job.job_stats)
		saved_hag_stats[stat] = hag_body.get_stat(stat)

	var/datum/skill_holder/skill_holder = hag_body.ensure_skills()
	if(!skill_holder)
		return
	saved_hag_skill_levels = list()
	saved_hag_skill_experience = list()
	for(var/skill in hag_job.skills)
		var/datum/skill/skill_ref = GetSkillRef(skill)
		saved_hag_skill_levels[skill_ref] = skill_holder.known_skills[skill_ref] || SKILL_LEVEL_NONE
		saved_hag_skill_experience[skill_ref] = skill_holder.skill_experience[skill_ref] || 0

/datum/antagonist/hag/proc/restore_hag_baseline_state(mob/living/carbon/human/hag_body)
	if(!hag_body)
		return

	if(islist(saved_hag_stats))
		for(var/stat in saved_hag_stats)
			var/current_value = hag_body.get_stat(stat)
			hag_body.change_stat(stat, saved_hag_stats[stat] - current_value)

	var/datum/skill_holder/skill_holder = hag_body.skills
	if(!skill_holder)
		return

	if(islist(saved_hag_skill_levels))
		for(var/skill_ref in saved_hag_skill_levels)
			skill_holder.known_skills[skill_ref] = saved_hag_skill_levels[skill_ref]

	if(islist(saved_hag_skill_experience))
		for(var/skill_ref in saved_hag_skill_experience)
			skill_holder.skill_experience[skill_ref] = saved_hag_skill_experience[skill_ref]

	saved_hag_stats = null
	saved_hag_skill_levels = null
	saved_hag_skill_experience = null

/datum/antagonist/hag/proc/teach_hag_recipes(datum/mind/hag_mind)
	if(!hag_mind)
		return
	// Core catalysts
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/varnish)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/synth_shiny)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/synth_base)
	// Low rarity mosses
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/faded_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/crawling_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/stormy_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/corrosive_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/sprouting_moss)
	// Mid rarity mosses
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/lustrous_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/caring_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/rooted_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/creeping_moss)
	// High rarity mosses
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/prismatic_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/gilded_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/drowned_moss)
	// Wyrd items
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_cross)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_axe)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_sword)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_spear)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/lux_moss)
	hag_mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_mirror)

/datum/antagonist/hag/on_removal()
	if(owner?.current)
		qdel(owner.current.GetComponent(/datum/component/hag_curio_tracker))
	curio_component = null
	if(coven_link)
		GLOB.mindlinks -= coven_link
		qdel(coven_link)
		coven_link = null
	cleanup_bound_followers()
	if(owner)
		owner.special_role = null
	return ..()

/datum/antagonist/hag/proc/get_active_heart()
	for(var/obj/structure/roguemachine/hag_heart/heart as anything in GLOB.hag_hearts)
		if(QDELETED(heart) || heart.destroyed)
			continue
		return heart

	// Fallback for cases where the global list is stale or mixed with non-heart entries.
	for(var/obj/structure/roguemachine/hag_heart/heart in world)
		if(QDELETED(heart) || heart.destroyed)
			continue
		if(!(heart in GLOB.hag_hearts))
			GLOB.hag_hearts += heart
		return heart

/datum/antagonist/hag/proc/get_heart_turf()
	var/obj/structure/roguemachine/hag_heart/heart = get_active_heart()
	if(heart)
		return get_turf(heart)
	return null

/datum/antagonist/hag/proc/bind_to_heart()
	var/obj/structure/roguemachine/hag_heart/heart = get_active_heart()
	if(!heart)
		return FALSE
	heart.link_hag(src)
	return TRUE

/datum/antagonist/hag/proc/can_heart_revive()
	return !!get_active_heart()

/datum/antagonist/hag/proc/get_boon_source()
	return "hag_boon_[REF(src)]"

/datum/antagonist/hag/proc/get_or_create_coven(create_if_missing = FALSE)
	if(coven_link && QDELETED(coven_link))
		coven_link = null

	if(!coven_link && create_if_missing && owner?.current)
		coven_link = new(list(owner.current), owner)
		GLOB.mindlinks += coven_link

	if(coven_link && owner?.current && !(owner.current in coven_link.members))
		coven_link.add_member(owner.current)

	return coven_link

/datum/antagonist/hag/proc/add_coven_member(mob/living/member, announcement)
	if(!member || !owner?.current)
		return FALSE

	var/datum/mindlink_coven/C = get_or_create_coven(TRUE)
	if(!C)
		return FALSE

	if(!C.add_member(member))
		return FALSE

	if(announcement)
		C.broadcast_notice(announcement)
	return TRUE

/datum/antagonist/hag/proc/cast_out_from_coven(mob/living/member)
	if(!member)
		return FALSE

	var/datum/mindlink_coven/C = get_or_create_coven(FALSE)
	if(!C)
		return FALSE

	if(!C.remove_member(member))
		return FALSE

	if(owner?.current)
		to_chat(owner.current, span_warning("[member.real_name] was cursed and has been cast out of the coven."))
	to_chat(member, span_userdanger("I FEEL THE MOSSMOTHER TURN HER BOON AGAINST ME! I HAVE BEEN CURSED!"))
	return TRUE

/datum/antagonist/hag/proc/add_bound_follower(datum/mind/follower)
	if(!follower)
		return
	bound_followers |= follower

/datum/antagonist/hag/proc/remove_bound_follower(datum/mind/follower)
	if(!follower)
		return
	bound_followers -= follower

/datum/antagonist/hag/proc/bind_follower(mob/living/carbon/human/target)
	if(!target?.mind || !owner?.current)
		return FALSE
	if(target.mind in bound_followers)
		return FALSE

	add_bound_follower(target.mind)
	ADD_TRAIT(target, TRAIT_LEECHIMMUNE, get_boon_source())

	var/datum/mindlink/link = new(owner.current, target)
	GLOB.mindlinks += link
	follower_links[target.mind] = link
	return TRUE

/datum/antagonist/hag/proc/unbind_follower(datum/mind/follower)
	if(!follower)
		return

	var/datum/mindlink/link = follower_links[follower]
	if(link)
		GLOB.mindlinks -= link
		qdel(link)
	follower_links -= follower

	if(follower.current)
		REMOVE_TRAIT(follower.current, TRAIT_LEECHIMMUNE, get_boon_source())

	remove_bound_follower(follower)

/datum/antagonist/hag/proc/cleanup_bound_followers()
	for(var/datum/mind/follower as anything in bound_followers.Copy())
		unbind_follower(follower)

/datum/antagonist/hag/roundend_report()
	var/list/report = list()
	report += span_header("The Hag")
	if(considered_alive(owner))
		report += span_greentext("The hag still lurked within the bog by round end.")
	else
		report += span_redtext("The hag's revenge was cut short.")
	var/datum/mindlink_coven/C = get_or_create_coven(FALSE)
	if(C)
		report += span_notice("Coven souls gathered: [max(length(C.members) - 1, 0)]")
	return report.Join("<br>")

/obj/effect/proc_holder/spell/invoked/hag_pact
	name = "Seal Pact"
	desc = "Offer a minor boon to a nearby mortal, binding them to your service if they accept."
	overlay_state = "mindlink"
	releasedrain = 30
	chargedrain = 0
	chargetime = 10
	recharge_time = 1 MINUTES
	range = 1
	ignore_los = FALSE
	warnie = "spellwarning"
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokegen
	sound = 'sound/magic/whiteflame.ogg'
	clothes_req = FALSE
	human_req = TRUE
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Weave and wither")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/hag_pact/cast(list/targets, mob/living/user)
	if(!ishuman(targets[1]))
		to_chat(user, span_warning("Only mortals can be bound into a hag's pact."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	if(!hag_datum)
		revert_cast()
		return FALSE
	if(target == user)
		to_chat(user, span_warning("I cannot bargain with myself."))
		revert_cast()
		return FALSE
	if(!target.client || !target.mind)
		to_chat(user, span_warning("There is no willing mortal mind here to bind."))
		revert_cast()
		return FALSE
	if(target.mind.has_antag_datum(/datum/antagonist))
		to_chat(user, span_warning("Their nature is already claimed by another dark calling."))
		revert_cast()
		return FALSE
	if(target.mind in hag_datum.bound_followers)
		to_chat(user, span_warning("[target] is already bound to my pact."))
		revert_cast()
		return FALSE

	var/consent = alert(target, "[user.real_name] offers a hag's pact. Accept a minor bog-blessing and a telepathic bond?", "Hag Pact", "Accept", "Refuse")
	if(consent != "Accept")
		to_chat(user, span_warning("[target] refuses my bargain."))
		to_chat(target, span_notice("I refuse the hag's bargain."))
		revert_cast()
		return FALSE

	if(!hag_datum.bind_follower(target))
		to_chat(user, span_warning("The pact slips away before it can take hold."))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user] seals a sinister pact with [target]."), span_notice("I bind [target] to my pact with a sliver of bog-magic."))
	to_chat(target, span_userdanger("The pact settles into my flesh. Bog leeches will shun me. We may now speak along the coven thread with ,y (and sever with ,mst)."))
	to_chat(user, span_notice("[target] is now bound to my pact. We may now speak along the coven thread with ,y."))
	return TRUE

/// Called on the hag's permanent death. Lifts curses from scarred followers and applies final spite to unblemished pact-bearers.
/datum/antagonist/hag/proc/execute_final_spite()
	if(owner?.current)
		var/datum/component/hag_curio_tracker/H = owner.current.GetComponent(/datum/component/hag_curio_tracker)
		if(H)
			H.execute_final_spite()
			return


/obj/effect/proc_holder/spell/invoked/spiritual_siphon
	name = "Spiritual Siphon"
	desc = "Absorbs mosses and select components into your spirit, or manifests stored items onto the ground."
	invocation_type = "whisper"
	invocations = list("Bloom inside.")
	recharge_time = 5 SECONDS
	range = 1

/obj/effect/proc_holder/spell/invoked/spiritual_siphon/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		to_chat(user, span_warning("Your soul lacks the hollow spaces required to store these blossoms."))
		return FALSE

	var/atom/target = targets[1]
	var/turf/T = get_turf(target)

	var/absorbed_any = FALSE
	for(var/obj/item/I in T)
		if(istype(I, /obj/item/alch/hag_moss/enchanted))
			if(H.absorb_enchanted_moss(I))
				absorbed_any = TRUE
		else if(H.absorb_item(I))
			absorbed_any = TRUE

	if(absorbed_any)
		to_chat(user, span_notice("The mosses dissolve into your spirit."))
		playsound(T, 'sound/magic/magnet.ogg', 50, TRUE)
		return TRUE

	if(H.dump_materials(T))
		to_chat(user, span_notice("You manifest a handful of stored components."))
		playsound(T, 'sound/magic/slimesquish.ogg', 50, TRUE)
		return TRUE

	to_chat(user, span_warning("You have nothing stored to manifest."))
	return FALSE

/obj/effect/proc_holder/spell/invoked/grant_boon
	name = "Manifest Boon"

/obj/effect/proc_holder/spell/invoked/grant_boon/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H || !length(H.prepared_boons))
		to_chat(user, span_warning("You have no prepared blessings to manifest."))
		return FALSE

	var/list/options = list()
	for(var/path in H.prepared_boons)
		if(H.prepared_boons[path] > 0)
			options[initial(path:name)] = path

	if(!length(options))
		to_chat(user, span_warning("You have no prepared blessings with enough essence to manifest."))
		return FALSE

	var/choice = tgui_input_list(user, "Which blessing do you wish to manifest?", "Manifestation", sort_list(options))
	if(!choice)
		return FALSE

	var/path = options[choice]
	var/default_points = initial(path:points)

	var/obj/item/hag_blessing_item/B = new(user.loc)
	B.name = "[choice] blessing"
	B.AddComponent(/datum/component/hag_boon_manifestation, path, default_points)

	user.put_in_hands(B)
	to_chat(user, span_notice("You pull a sliver of [choice] from your spirit."))
	return TRUE


/obj/effect/proc_holder/spell/invoked/transmutation_rite
	name = "Transmutation"
	var/list/selected_boons = list()
	var/selected_curse_path = null
	var/active_victim_name = null

/obj/effect/proc_holder/spell/invoked/transmutation_rite/cast(list/targets, mob/living/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H || !length(H.boon_registry))
		to_chat(user, span_warning("You have no souls bound to your spirit."))
		return FALSE
	ui_interact(user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_state(mob/user)
	return GLOB.always_state

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HagTransmutation", "Rite of Transmutation")
		ui.open()

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_data(mob/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		return FALSE

	var/list/victims_data = list()
	for(var/t_name in H.boon_registry)
		var/list/boons = list()
		for(var/datum/hag_boon/B in H.boon_registry[t_name])
			boons += list(list(
				"id" = "[B.type]",
				"victim_name" = t_name,
				"name" = B.name,
				"points" = B.points,
				"selected" = (B in selected_boons),
				"transmutable" = B.transmutable
			))
		victims_data += list(list(
			"name" = t_name,
			"boons" = boons
		))

	return list(
		"victims" = victims_data,
		"curse_options" = H.get_available_curses_data(),
		"total_points" = calculate_current_points(),
		"hag_tier" = H.hag_tier,
		"selected_curse_path" = selected_curse_path
	)

/obj/effect/proc_holder/spell/invoked/transmutation_rite/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/living/user = ui.user
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		return .

	switch(action)
		if("toggle_boon")
			var/boon_id = params["id"]
			var/v_name = params["victim_name"]
			if(active_victim_name != v_name)
				selected_boons.Cut()
				active_victim_name = v_name
			var/list/registry = H.boon_registry[v_name]
			for(var/datum/hag_boon/B in registry)
				if("[B.type]" == boon_id)
					if(B in selected_boons)
						selected_boons -= B
						if(!selected_boons.len)
							active_victim_name = null
					else
						selected_boons += B
					return TRUE

		if("select_curse")
			selected_curse_path = params["path"]
			return TRUE

		if("commit_transmutation")
			if(!active_victim_name || !selected_curse_path || !selected_boons.len)
				return TRUE

			var/list/consumable_boons = list()
			for(var/datum/hag_boon/B in selected_boons)
				if(B && B.true_name == active_victim_name && B.transmutable && !B.hag_curse)
					consumable_boons += B
			if(!length(consumable_boons))
				to_chat(user, span_warning("Only transmutable blessings from this soul can be bound into a blight."))
				return TRUE

			var/curse_path = text2path(selected_curse_path)
			var/datum/hag_boon/selected_curse = curse_path
			if(!ispath(curse_path, /datum/hag_boon) || !initial(selected_curse.hag_curse))
				to_chat(user, span_warning("That curse choice is invalid. Choose a curse from the rite list."))
				return TRUE
			if(H.find_boon_by_type(active_victim_name, curse_path))
				to_chat(user, span_warning("That blight already festers in this soul. Choose a different curse."))
				return TRUE

			var/summary_power = calculate_current_points(consumable_boons)
			var/curse_cost = 999
			var/curse_available = FALSE
			var/list/curses = H.get_available_curses_data()
			for(var/list/C in curses)
				if(C["path"] == selected_curse_path)
					curse_available = TRUE
					curse_cost = C["cost"]
					break
			if(!curse_available)
				to_chat(user, span_warning("That blight is not available to your current circle."))
				return TRUE

			if(summary_power < curse_cost)
				to_chat(user, span_warning("The soul-tithe is insufficient. You require [curse_cost] points, but have only gathered [summary_power]."))
				return TRUE

			if(!H.transmute_boons_to_curse(active_victim_name, consumable_boons, curse_path, summary_power))
				to_chat(user, span_warning("The rite sputters and fails. The chosen blight cannot be bound this way."))
				return TRUE
			selected_boons.Cut()
			selected_curse_path = null
			active_victim_name = null
			return TRUE
	return .

/obj/effect/proc_holder/spell/invoked/transmutation_rite/proc/calculate_current_points(list/boons = selected_boons)
	var/points = 0
	for(var/datum/hag_boon/B in boons)
		points += B.points
	return points


/obj/effect/proc_holder/spell/invoked/resurrect/hag
	name = "Thorny Regrowth"
	desc = "Knit a fallen soul back into a body using parasitic vines. The target is revived, but incurs a 50-point debt to your Curio."
	recharge_time = 10 MINUTES
	sound = 'sound/magic/slimesquish.ogg'
	required_structure = /obj/structure/roguemachine/mossmother
	required_items = list()
	req_items = list()
	alt_required_items = list()
	miracle = FALSE
	harms_undead = FALSE
	devotion_cost = 0
	var/boon_path = /datum/hag_boon/revival_debt

/obj/effect/proc_holder/spell/invoked/resurrect/hag/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(!istype(target))
		return FALSE

	var/datum/component/hag_curio_tracker/HCT = user.GetComponent(/datum/component/hag_curio_tracker)
	if(HCT)
		HCT.grant_boon(target.real_name, boon_path, 50)
		to_chat(user, span_notice("You've tethered [target.real_name] to your garden. Their life is now your currency."))
	return TRUE


/mob/living/carbon/human/proc/commune_with_roots()
	set name = "Commune with Roots"
	set category = "IC"
	set desc = "Press your feet to the soil to hear the Mossmother's heartbeat."

	if(stat || !HAS_TRAIT(src, TRAIT_ANCIENT_HAG))
		return

	to_chat(src, span_notice("You press your feet to the earth, seeking the Mother's pulse..."))
	if(!do_after(src, 1 SECONDS, target = src))
		return

	var/obj/structure/roguemachine/mossmother/closest_tree
	var/min_dist = INFINITY
	var/turf/my_turf = get_turf(src)

	for(var/obj/structure/roguemachine/mossmother/tree in GLOB.hag_trees)
		var/turf/tree_turf = get_turf(tree)
		if(!tree_turf)
			continue
		var/dist = get_dist_euclidean(my_turf, tree_turf)
		if(dist < min_dist)
			min_dist = dist
			closest_tree = tree

	if(!closest_tree)
		to_chat(src, span_warning("The earth is hollow and silent. You are beyond the reach of the Mossmother."))
		return

	var/turf/tree_turf = get_turf(closest_tree)
	var/area/tree_area = get_area(closest_tree)
	if(tree_turf.z != my_turf.z)
		var/z_dir = (tree_turf.z > my_turf.z) ? "above" : "deep below"
		to_chat(src, span_notice("The pulse of a Heartroot tree thrums from [z_dir] you, somewhere in [tree_area.name]."))
	else
		var/dir_text = dir2text(get_dir(src, closest_tree))
		var/dist_tiles = get_dist(my_turf, tree_turf)
		if(dist_tiles <= 2)
			to_chat(src, span_boldnotice("The Heartroot is right here!"))
		else if(dist_tiles < 15)
			to_chat(src, span_notice("A strong, wet thrumming comes from the [dir_text]. A tree grows nearby in [tree_area.name]."))
		else
			to_chat(src, span_notice("You feel a faint, ancient vibration to the [dir_text]... somewhere far off in [tree_area.name]."))

	src.playsound_local(src.loc, 'sound/magic/heartbeat.ogg', 75, TRUE)
