/datum/antagonist/hag
	name = "Hag"
	roundend_category = "Hags"
	antagpanel_category = "Roguetown"
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
	var/list/cursed_followers = list()
	var/list/active_curses = list()
	var/hag_baseline_applied = FALSE
	var/hag_tier = 1
	var/datum/component/hag_curio_tracker/curio_component
	var/static/list/hag_baseline_traits = list(
		TRAIT_RITUALIST,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_ANCIENT_HAG,
		TRAIT_HOMESTEAD_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_NOMOOD,
		TRAIT_UNLYCKERABLE,
		TRAIT_DARKVISION,
		TRAIT_NOHUNGER,
		TRAIT_SELF_SUSTENANCE
		//To add: bogwalker - investigate edit_descriptors, technophobe and no pve as well as ring still not working
	)
	var/static/list/hag_baseline_stats = list(
		STATKEY_STR = -7,
		STATKEY_WIL = 8,
		STATKEY_SPD = -2,
		STATKEY_CON = 1,
		STATKEY_INT = 9,
	)
	var/static/list/hag_baseline_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/sewing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER,
	)
	var/static/list/curse_registry = list(
		/datum/hag_curse/no_run = list("cost" = 60, "min_tier" = 2),
		/datum/hag_curse/unseemly = list("cost" = 10, "min_tier" = 1),
		/datum/hag_curse/silver_weak = list("cost" = 50, "min_tier" = 2),
		/datum/hag_curse/no_def = list("cost" = 100, "min_tier" = 3),
		/datum/hag_curse/mute = list("cost" = 100, "min_tier" = 3),
		/datum/hag_curse/critical_weak = list("cost" = 75, "min_tier" = 2),
	)

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

	if(istype(hag_body))
		if(admin_granted)
			// Admin/manual grants often happen mid-round with occupied slots.
			// Clear equipment first so the hag loadout applies deterministically.
			hag_body.unequip_everything()
		hag_body.equipOutfit(/datum/outfit/job/roguetown/hag)
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
		/obj/item/handmirror = 1
	)
	if(H.mind)
		H.verbs += /mob/living/carbon/human/proc/commune_with_roots

/datum/antagonist/hag/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!istype(hag_body) || !hag_body.mind)
		return
	ADD_TRAIT(hag_body, TRAIT_ANCIENT_HAG, "[type]")
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hag_pact)
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/transmutation_rite)
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spiritual_siphon)
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/grant_boon)
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/resurrect/hag)
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink/hag)
	teach_hag_recipes(hag_body.mind)
	// Attach the curio tracker component for death/revive handling
	curio_component = hag_body.AddComponent(/datum/component/hag_curio_tracker, src)

/datum/antagonist/hag/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!istype(hag_body) || !hag_body.mind)
		return
	for(var/trait in hag_baseline_traits)
		REMOVE_TRAIT(hag_body, trait, "[type]")
	hag_baseline_applied = FALSE
	qdel(hag_body.GetComponent(/datum/component/hag_curio_tracker))
	curio_component = null
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/hag_pact)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/transmutation_rite)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/spiritual_siphon)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/grant_boon)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/resurrect/hag)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/mindlink/hag)
	hag_body.verbs -= /mob/living/carbon/human/proc/commune_with_roots

/datum/antagonist/hag/proc/apply_hag_baseline(mob/living/carbon/human/hag_body)
	if(!istype(hag_body) || !hag_body.mind || hag_baseline_applied)
		return

	for(var/trait in hag_baseline_traits)
		if(trait in hag_body.dna?.species?.banned_traits)
			continue
		ADD_TRAIT(hag_body, trait, "[type]")

	for(var/stat in hag_baseline_stats)
		hag_body.change_stat(stat, hag_baseline_stats[stat])

	for(var/skill in hag_baseline_skills)
		hag_body.adjust_skillrank_up_to(skill, hag_baseline_skills[skill], TRUE)

	hag_baseline_applied = TRUE

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
	cleanup_bound_followers()
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
	if(target.mind in cursed_followers)
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
	if(length(bound_followers))
		report += span_notice("Bound followers gathered: [length(bound_followers)]")
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
	if(target.mind in hag_datum.cursed_followers)
		to_chat(user, span_warning("[target] already bears my curse and cannot be bound again."))
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
	to_chat(target, span_userdanger("The pact settles into my flesh. Bog leeches will shun me, and I can speak to the hag with ,m."))
	to_chat(user, span_notice("[target] is now bound to my pact. I can speak to them with ,m."))
	return TRUE

/datum/antagonist/hag/proc/transmute_to_curse(datum/mind/follower, curse_path, points)
	if(!follower || !curse_path)
		return FALSE
	if(!(follower in bound_followers))
		return FALSE

	// Remove from normal binding
	cursed_followers |= follower
	bound_followers -= follower

	// Add curse scar if missing
	var/mob/living/victim = follower.current
	if(victim)
		if(!HAS_TRAIT(victim, TRAIT_CURSE_SCAR))
			ADD_TRAIT(victim, TRAIT_CURSE_SCAR, "hag_curse")
			to_chat(victim, span_userdanger("A dark scar etches itself into your soul. You have been cursed."))

	// Create and apply the curse
	var/datum/hag_curse/curse = new curse_path(follower, points)
	if(!active_curses[follower])
		active_curses[follower] = list()
	active_curses[follower] += curse
	to_chat(owner.current, span_notice("[follower.name] has been cursed with [curse.name]."))
	check_tier_upgrade()
	return TRUE

/// Checks accumulated curse-point totals across all victims and advances hag_tier if thresholds are met.
/// Mirrors Azure Peak's check_tier_upgrade(): tier 2 at first victim with >= 20pts, tier 3 at two victims with >= 60pts.
/datum/antagonist/hag/proc/check_tier_upgrade()
	var/scar_60_count = 0
	var/has_scar_20 = FALSE

	for(var/datum/mind/follower in cursed_followers)
		var/total_points = 0
		if(active_curses[follower])
			for(var/datum/hag_curse/C in active_curses[follower])
				total_points += C.points
		if(total_points >= 60)
			scar_60_count++
		if(total_points >= 20)
			has_scar_20 = TRUE

	if(hag_tier == 1 && has_scar_20)
		hag_tier = 2
		if(owner?.current)
			to_chat(owner.current, span_boldnotice("Your connection to the Mossmother's roots deepens. You have reached Tier 2."))

	if(hag_tier == 2 && scar_60_count >= 2)
		hag_tier = 3
		if(owner?.current)
			to_chat(owner.current, span_boldnotice("The Mossmother sees you. You have reached Tier 3."))

/// Called on the hag's permanent death. Lifts curses from scarred followers and applies final spite to unblemished pact-bearers.
/datum/antagonist/hag/proc/execute_final_spite()
	// Cursed followers have already paid the price — lift their curses as the hag's power fades.
	for(var/datum/mind/follower in cursed_followers)
		var/mob/living/victim = follower.current
		if(victim)
			to_chat(victim, span_notice("The heavy weight of your curse lifts as a distant, pained shriek echoes in your mind."))
			REMOVE_TRAIT(victim, TRAIT_CURSE_SCAR, "hag_curse")
		if(active_curses[follower])
			for(var/datum/hag_curse/C in active_curses[follower])
				C.remove_curse()
				qdel(C)
		active_curses -= follower

	// Bound followers enjoyed boons but were never truly claimed. The hag's dying breath claims them now.
	var/list/valid_curses = list()
	for(var/path in curse_registry)
		var/list/details = curse_registry[path]
		if(details["cost"] > 10)
			valid_curses += path

	for(var/datum/mind/follower in bound_followers)
		var/mob/living/victim = follower.current
		if(!victim)
			continue
		to_chat(victim, span_userdanger("With her dying breath, the Hag weaves a final, spiteful knot into your soul!"))
		if(!length(valid_curses))
			continue
		// Apply 2 random curses — matching Azure Peak's final spite behaviour
		for(var/i in 1 to 2)
			var/curse_path = pick(valid_curses)
			var/datum/hag_curse/curse = new curse_path(follower, 100)
			if(!active_curses[follower])
				active_curses[follower] = list()
			active_curses[follower] += curse

/datum/antagonist/hag/proc/get_available_curses()
	var/list/data = list()
	for(var/path in curse_registry)
		var/list/details = curse_registry[path]
		if(details["min_tier"] > hag_tier)
			continue
		data[path] = details
	return data

/obj/effect/proc_holder/spell/invoked/hag_transmute
	name = "Transmutation Rite"
	desc = "Transmute a bound pact-bearer into a cursed servant."
	overlay_state = "mindlink"
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 2 MINUTES
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
	spell_tier = 3
	invocations = list("Betray and bind")
	invocation_type = "whisper"
	var/selected_follower = null
	var/selected_curse = null

/obj/effect/proc_holder/spell/invoked/hag_transmute/cast(list/targets, mob/living/user)
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	if(!hag_datum || !length(hag_datum.bound_followers))
		to_chat(user, span_warning("I have no pacts to corrupt."))
		revert_cast()
		return FALSE

	ui_interact(user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/hag_transmute/ui_state(mob/user)
	return GLOB.always_state

/obj/effect/proc_holder/spell/invoked/hag_transmute/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HagTransmutation", "Rite of Transmutation")
		ui.open()

/obj/effect/proc_holder/spell/invoked/hag_transmute/ui_data(mob/user)
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	if(!hag_datum)
		return FALSE

	var/list/followers_data = list()
	for(var/datum/mind/follower in hag_datum.bound_followers)
		followers_data += list(list(
			"name" = follower.name,
			"key" = REF(follower)
		))

	var/list/curses_data = list()
	for(var/path in hag_datum.get_available_curses())
		var/list/details = hag_datum.curse_registry[path]
		curses_data += list(list(
			"name" = initial(path:name),
			"path" = "[path]",
			"cost" = details["cost"],
			"min_tier" = details["min_tier"]
		))

	return list(
		"followers" = followers_data,
		"curses" = curses_data,
		"hag_tier" = hag_datum.hag_tier,
		"selected_follower" = selected_follower,
		"selected_curse" = selected_curse
	)

/obj/effect/proc_holder/spell/invoked/hag_transmute/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	if(!hag_datum)
		return .

	switch(action)
		if("select_follower")
			selected_follower = params["key"]
			return TRUE

		if("select_curse")
			selected_curse = params["path"]
			return TRUE

		if("commit_transmute")
			if(!selected_follower || !selected_curse)
				to_chat(user, span_warning("You must select both a follower and a curse."))
				return TRUE

			var/datum/mind/follower = locate(selected_follower)
			if(!follower || !(follower in hag_datum.bound_followers))
				to_chat(user, span_warning("That follower is no longer bound."))
				return TRUE

			var/curse_cost = 0
			for(var/path in hag_datum.curse_registry)
				if("[path]" == selected_curse)
					curse_cost = hag_datum.curse_registry[path]["cost"]
					break

			if(!hag_datum.transmute_to_curse(follower, text2path(selected_curse), curse_cost))
				to_chat(user, span_warning("The transmutation fails."))
				return TRUE

			selected_follower = null
			selected_curse = null
			to_chat(user, span_notice("The rite completes. [follower.name] is now cursed."))
			return TRUE
	return .


/// HAG CURSE DATUMS

/datum/hag_curse
	var/name = "Generic Curse"
	var/desc = "A curse from the hag."
	var/datum/mind/victim
	var/points = 1

/datum/hag_curse/New(datum/mind/target, set_points = 1)
	victim = target
	points = set_points
	apply_curse()

/datum/hag_curse/proc/apply_curse()
	// Override in subtypes to apply specific effects
	return

/// Reverses the effects of apply_curse(). Called on hag's permanent death to clean up living curses.
/datum/hag_curse/proc/remove_curse()
	return

/datum/hag_curse/scar
	name = "Curse Scar"
	desc = "A lingering mark of corruption, claimed by the Mossmother."

/datum/hag_curse/scar/apply_curse()
	// Scar is a marker, not an active curse - no mechanical effects
	return

/datum/hag_curse/no_run
	name = "Curse of Sluggish Limbs"
	desc = "The bearer cannot run."

/datum/hag_curse/no_run/apply_curse()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_NORUN, "hag_curse")

/datum/hag_curse/no_run/remove_curse()
	if(victim?.current)
		REMOVE_TRAIT(victim.current, TRAIT_NORUN, "hag_curse")

/datum/hag_curse/unseemly
	name = "Curse of Unseemly Form"
	desc = "Renders the bearer grotesque to behold."

/datum/hag_curse/unseemly/apply_curse()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_curse/unseemly/remove_curse()
	if(victim?.current)
		REMOVE_TRAIT(victim.current, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_curse/no_def
	name = "Curse of Defenselessness"
	desc = "The bearer cannot parry or dodge."

/datum/hag_curse/no_def/apply_curse()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_NODEF, "hag_curse")

/datum/hag_curse/no_def/remove_curse()
	if(victim?.current)
		REMOVE_TRAIT(victim.current, TRAIT_NODEF, "hag_curse")

/datum/hag_curse/silver_weak
	name = "Curse of Silver Weakness"
	desc = "Silver becomes like acid to the bearer's flesh."

/datum/hag_curse/silver_weak/apply_curse()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_curse/silver_weak/remove_curse()
	if(victim?.current)
		REMOVE_TRAIT(victim.current, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_curse/mute
	name = "Curse of Silenced Tongue"
	desc = "The bearer's voice is stolen by the hag."

/datum/hag_curse/mute/apply_curse()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_curse/mute/remove_curse()
	if(victim?.current)
		REMOVE_TRAIT(victim.current, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_curse/critical_weak
	name = "Curse of Fragile Form"
	desc = "The bearer's body grows frail and vulnerable."

/datum/hag_curse/critical_weak/apply_curse()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_CRITICAL_WEAKNESS, "hag_curse")

/datum/hag_curse/critical_weak/remove_curse()
	if(victim?.current)
		REMOVE_TRAIT(victim.current, TRAIT_CRITICAL_WEAKNESS, "hag_curse")


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

	var/choice = input(user, "Which blessing do you wish to manifest?", "Manifestation") as null|anything in options
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

			var/points_gathered = calculate_current_points()
			var/curse_cost = 999
			var/list/curses = H.get_available_curses_data()
			for(var/list/C in curses)
				if(C["path"] == selected_curse_path)
					curse_cost = C["cost"]
					break

			if(points_gathered < curse_cost)
				to_chat(user, span_warning("The soul-tithe is insufficient. You require [curse_cost] points, but have only gathered [points_gathered]."))
				return TRUE

			H.transmute_boons_to_curse(active_victim_name, selected_boons, text2path(selected_curse_path), points_gathered)
			selected_boons.Cut()
			selected_curse_path = null
			active_victim_name = null
			return TRUE
	return .

/obj/effect/proc_holder/spell/invoked/transmutation_rite/proc/calculate_current_points()
	var/points = 0
	for(var/datum/hag_boon/B in selected_boons)
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


/obj/effect/proc_holder/spell/invoked/mindlink/hag
	name = "Coven Link"
	desc = "Weave selected minds into your web. Linked minds communicate via ,m."
	recharge_time = 4 MINUTES
	cost = 12
	var/link_duration = 20 MINUTES

/obj/effect/proc_holder/spell/invoked/mindlink/hag/cast(list/targets, mob/living/user)
	var/list/possible = user.mind.known_people.Copy()
	if(!possible.len)
		to_chat(user, span_warning("I have no puppets to bind to my web."))
		revert_cast()
		return FALSE

	var/list/mob/living/carbon/human/selected = list()
	for(var/i in 1 to 5)
		var/prompt = "Choose member #[i] to bind (Cancel to finalize)"
		var/target_name = tgui_input_list(user, prompt, "Coven Link", sort_list(possible))
		if(!target_name)
			break

		var/mob/living/carbon/human/found_mob
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.real_name == target_name)
				found_mob = HL
				break
		if(found_mob)
			selected += found_mob
			possible -= target_name
		if(!possible.len)
			break

	if(!selected.len)
		to_chat(user, span_warning("A coven of one is just a lonely old woman. I need at least one other."))
		revert_cast()
		return FALSE

	var/list/active_links = list()
	for(var/mob/living/carbon/human/M in selected)
		var/datum/mindlink/link = new(user, M)
		GLOB.mindlinks += link
		active_links += link

	var/list/names = list(user.real_name)
	for(var/mob/living/M in selected)
		names += M.real_name
	var/roster = names.Join(", ")
	to_chat(user, span_boldnotice("The Coven is formed! Linked minds: [roster]. Use ,m to speak."))
	for(var/mob/living/M in selected)
		to_chat(M, span_boldnotice("The Coven is formed! Linked minds: [roster]. Use ,m to speak."))

	addtimer(CALLBACK(src, PROC_REF(break_coven), active_links), link_duration)
	return TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/hag/proc/break_coven(list/links)
	for(var/datum/mindlink/L in links)
		if(!L)
			continue
		if(L.owner)
			to_chat(L.owner, span_warning("The coven web snaps and withers..."))
		if(L.target)
			to_chat(L.target, span_warning("The coven web snaps and withers..."))
		GLOB.mindlinks -= L
		qdel(L)


/mob/living/carbon/human/proc/commune_with_roots()
	set name = "Commune with Roots"
	set category = "RoleUnique.Hag"
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
