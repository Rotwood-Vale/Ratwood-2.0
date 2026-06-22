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
	var/hag_tier = 1
	var/datum/component/hag_curio_tracker/curio_component
	var/static/list/curse_registry = list(
		/datum/hag_curse/scar = list("cost" = 0, "min_tier" = 1),
		/datum/hag_curse/no_run = list("cost" = 60, "min_tier" = 1),
		/datum/hag_curse/unseemly = list("cost" = 10, "min_tier" = 1),
		/datum/hag_curse/silver_weak = list("cost" = 50, "min_tier" = 2),
		/datum/hag_curse/no_def = list("cost" = 100, "min_tier" = 3),
		/datum/hag_curse/mute = list("cost" = 100, "min_tier" = 3),
		/datum/hag_curse/critical_weak = list("cost" = 75, "min_tier" = 2),
	)

/datum/antagonist/hag/get_antag_cap_weight()
	return 2

/datum/antagonist/hag/on_gain()
	. = ..()
	if(!owner || !owner.current)
		return

	owner.special_role = name
	if(!objectives.len)
		var/datum/objective/hag/revenge_objective = new /datum/objective/hag(owner = owner)
		objectives += revenge_objective
		owner.store_memory("Objective: [revenge_objective.explanation_text]")

	if(length(GLOB.hag_starts))
		owner.current.forceMove(pick(GLOB.hag_starts))

	bind_to_heart()

	greet()

/datum/antagonist/hag/greet()
	to_chat(owner.current, span_userdanger("The bog answers my spite. Bind mortals to my will and prepare my revenge."))
	owner.announce_objectives()
	..()

/datum/antagonist/hag/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!istype(hag_body) || !hag_body.mind)
		return
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hag_pact)
	hag_body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hag_transmute)
	// Attach the curio tracker component for death/revive handling
	curio_component = hag_body.AddComponent(/datum/component/hag_curio_tracker, src)

/datum/antagonist/hag/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/hag_body = mob_override || owner?.current
	if(!istype(hag_body) || !hag_body.mind)
		return
	if(curio_component)
		hag_body.RemoveComponent(curio_component)
		curio_component = null
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/hag_pact)
	hag_body.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/hag_transmute)

/datum/antagonist/hag/on_removal()
	if(owner?.current && curio_component)
		owner.current.RemoveComponent(curio_component)
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
	to_chat(owner.current, span_notice("[follower.name] has been cursed with [curse.name]."))
	return TRUE

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
	var/mob/user = usr
	var/datum/antagonist/hag/hag_datum = user?.mind?.has_antag_datum(/datum/antagonist/hag)
	if(!hag_datum)
		return ..()

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
	return ..()


/// HAG CURSE DATUMS

/datum/hag_curse
	var/name = "Generic Curse"
	var/desc = "A curse from the hag."
	var/datum/mind/victim
	var/points = 1

/datum/hag_curse/New(datum/mind/target, set_points = 1)
	victim = target
	points = set_points
	apply()

/datum/hag_curse/proc/apply()
	// Override in subtypes to apply specific effects
	return

/datum/hag_curse/scar
	name = "Curse Scar"
	desc = "A lingering mark of corruption, claimed by the Mossmother."

/datum/hag_curse/scar/apply()
	// Scar is a marker, not an active curse - no mechanical effects
	return

/datum/hag_curse/no_run
	name = "Curse of Sluggish Limbs"
	desc = "The bearer cannot run."

/datum/hag_curse/no_run/apply()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_NORUN, "hag_curse")

/datum/hag_curse/unseemly
	name = "Curse of Unseemly Form"
	desc = "Renders the bearer grotesque to behold."

/datum/hag_curse/unseemly/apply()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_curse/no_def
	name = "Curse of Defenselessness"
	desc = "The bearer cannot parry or dodge."

/datum/hag_curse/no_def/apply()
	if(victim?.current)
		ADD_TRAIT(victim.current, "No Defense", "hag_curse")

/datum/hag_curse/silver_weak
	name = "Curse of Silver Weakness"
	desc = "Silver becomes like acid to the bearer's flesh."

/datum/hag_curse/silver_weak/apply()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_curse/mute
	name = "Curse of Silenced Tongue"
	desc = "The bearer's voice is stolen by the hag."

/datum/hag_curse/mute/apply()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_curse/critical_weak
	name = "Curse of Fragile Form"
	desc = "The bearer's body grows frail and vulnerable."

/datum/hag_curse/critical_weak/apply()
	if(victim?.current)
		ADD_TRAIT(victim.current, TRAIT_CRITICAL_WEAKNESS, "hag_curse")
