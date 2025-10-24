/datum/antagonist/crimson
	name = "Crimson Agent"
	roundend_category = "crimson agents"
	antagpanel_category = "Crimson Agent"
	job_rank = ROLE_CRIMSON_AGENT
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "crimson agent"
	confess_lines = list(
		"THE CRIMSON ORDER DOES NOT EXIST!",
		"BLOOD IS MY ART FORM!",
		"I KNOW TRUE ART!",
)
	can_coexist_with_others = TRUE
	rogue_enabled = TRUE

/datum/antagonist/crimson/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/crimson))
		return span_boldnotice("Another agent of the Crimson Order.")

/datum/antagonist/crimson/on_gain()
	. = ..()
	owner.special_role = ROLE_CRIMSON_AGENT
	var/mob/living/carbon/human/H = owner.current
	if(owner?.current)
		owner.current.playsound_local(get_turf(owner.current), 'sound/villain/crimson_intro.ogg', 60, FALSE, pressure_affected = FALSE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, "[type]")
		ADD_TRAIT(H, TRAIT_SHARPER_BLADES, "[type]")
	to_chat(H, span_bigbold(span_red("I am an agent of the CRIMSON ORDER!")))
	to_chat(H, span_boldwarning("I have passed my initiation and I am now needed to carry out the will of the Order. Shadows are my friends - I must not be caught, I must blend in with the populace, and I must complete my objective at all costs, otherwise, I might meet my doom."))
	// Provide a clandestine signet that serves as an uplink trigger
	var/obj/item/clothing/ring/signet/crimson/signet = new(get_turf(H))
	if(H && !QDELETED(signet))
		// Try to place into hands; otherwise it will appear at feet
		if(ishuman(H))
			var/mob/living/carbon/human/HH = H
			HH.put_in_hands(signet)
		// Attach an unlocked uplink component to the signet (999 TC for testing)
		var/datum/component/uplink/U = signet.AddComponent(/datum/component/uplink, H?.key, FALSE, TRUE, null, 25)
		if(U)
			U.setup_unlock_code()
			if(U.unlock_note)
				antag_memory += U.unlock_note + "<br>"
		to_chat(H, span_notice("My signet bears a hidden mechanism. Use it in-hand to access clandestine supplies."))
	// Always include the baseline escape/survive objective
	forge_crimson_objectives()

	// Prompt the agent to choose a primary objective set
	if(H && H.client)
		var/list/options = list(
			"Assassination (Random)",
			"Assassination (High Value)",
			"Theft (High Value)",
			"Theft (Low Value)"
		)
		var/choice = input(H, "Select your contract from the Crimson Order:", "Crimson Objective") as null|anything in options
		// If the user closes the prompt, pick a random option (equal weight) and note it
		if(!choice)
			choice = pick(options)
			to_chat(H, span_boldnotice("The Order decides for me... [choice]."))
		var/datum/objective/picked_obj
		switch(choice)
			if("Assassination (Random)")
				selected_primary_choice = CRIMSON_PRIMARY_ASSASSINATE_RANDOM
				picked_obj = assign_crimson_assassination(random_target = TRUE)
				if(owner?.current)
					message_admins("[ADMIN_LOOKUPFLW(owner.current)] selected 'Assassination (Random)' as Crimson objective.")
					log_game("[key_name(owner.current)] selected 'Assassination (Random)' as Crimson objective.")
			if("Assassination (High Value)")
				selected_primary_choice = CRIMSON_PRIMARY_ASSASSINATE_HV
				picked_obj = assign_crimson_assassination(random_target = FALSE)
				if(owner?.current)
					message_admins("[ADMIN_LOOKUPFLW(owner.current)] selected 'Assassination (High Value)' as Crimson objective.")
					log_game("[key_name(owner.current)] selected 'Assassination (High Value)' as Crimson objective.")
			if("Theft (High Value)")
				selected_primary_choice = CRIMSON_PRIMARY_THEFT_HV
				picked_obj = assign_crimson_theft_high_value()
				if(owner?.current)
					message_admins("[ADMIN_LOOKUPFLW(owner.current)] selected 'Theft (High Value)' as Crimson objective.")
					log_game("[key_name(owner.current)] selected 'Theft (High Value)' as Crimson objective.")
			if("Theft (Low Value)")
				selected_primary_choice = CRIMSON_PRIMARY_THEFT_LV
				picked_obj = assign_crimson_theft_low_value()
				if(owner?.current)
					message_admins("[ADMIN_LOOKUPFLW(owner.current)] selected 'Theft (Low Value)' as Crimson objective.")
					log_game("[key_name(owner.current)] selected 'Theft (Low Value)' as Crimson objective.")

		// Announce the chosen objective in bold red; provide a robust fallback if selection failed somehow
		if(!picked_obj)
			// Universal fallback: assign a random assassination objective
			picked_obj = assign_crimson_assassination(TRUE)
			selected_primary_choice = CRIMSON_PRIMARY_ASSASSINATE_RANDOM

		if(picked_obj && owner?.current)
			picked_obj.update_explanation_text()
			to_chat(owner.current, span_bigbold(span_red("Objective: [picked_obj.explanation_text]")))


/datum/antagonist/crimson/greet()
	if(owner?.current)
		owner.announce_objectives()
	..()

/datum/antagonist/crimson/proc/forge_crimson_objectives()
	if(!(locate(/datum/objective/escape) in objectives))
		var/datum/objective/escape/escape_objective = new
		escape_objective.owner = owner
		objectives += escape_objective
		return

// Assign an assassination objective. If random_target is FALSE, prefer high-value roles; otherwise pick any valid target.
/datum/antagonist/crimson/proc/assign_crimson_assassination(random_target = TRUE)
	var/datum/objective/assassinate/crimson/A = new
	A.owner = owner
	if(random_target)
		A.find_target()
	else
		// Build a list of high-value role targets currently in the round
		var/list/high_value_roles = list(
			"Grand Duke",
			"Grand Duchess",
			"Prince",
			"Suitor",
			"Knight",
			"Knight Captain",
			"Merchant",
			"Bishop",
			"Inquisitor"
		)
		var/list/candidates = list()
		for(var/datum/mind/M in A.get_crewmember_minds())
			if(M == owner)
				continue
			if(!ishuman(M.current) || M.current.stat == DEAD)
				continue
			if(M.assigned_role && (M.assigned_role in high_value_roles))
				candidates += M
		if(length(candidates))
			A.target = pick(candidates)
			A.update_explanation_text()
		else
			// Fallback to any valid target if no high-value roles are present
			A.find_target()
	objectives += A
	return A

// Assign a high-value theft objective (e.g., crown, master key, merchant ledger). Falls back to random steal if none available.
/datum/antagonist/crimson/proc/assign_crimson_theft_high_value()
	var/datum/objective/steal/crimson/S = new
	S.owner = owner
	// Ensure possible items are populated (steal.New handles this)
	var/list/high_value_item_types = list(
		/datum/objective_item/steal/rogue/mkey,
		/datum/objective_item/steal/rogue/priestmask,
		/datum/objective_item/steal/rogue/unforgotten,
		/datum/objective_item/steal/rogue/golden_psydon,
		/datum/objective_item/steal/rogue/martyr_sword,
		/datum/objective_item/steal/rogue/exe_cloth
	)
	var/list/candidates = list()
	for(var/datum/objective_item/oi in GLOB.possible_items)
		var/match = FALSE
		for(var/T in high_value_item_types)
			if(istype(oi, T))
				match = TRUE
				break
		if(match)
			// Respect excludefromjob so we don't assign impossible/abusive objectives
			if(owner?.assigned_role && (owner.assigned_role in oi.excludefromjob))
				continue
			candidates += oi
	if(length(candidates))
		S.set_target(pick(candidates))
	else
		// Fallback to the standard random steal selection
		S.find_target()
	objectives += S
	return S


/datum/antagonist/crimson/proc/assign_crimson_theft_low_value()
	var/datum/objective/steal/crimson/S = new
	S.owner = owner
	var/list/low_value_item_types = list(
		/datum/objective_item/steal/rogue/heirloom_sword,
		/datum/objective_item/steal/rogue/idagger_silver,
		/datum/objective_item/steal/rogue/tallow_red,
		/datum/objective_item/steal/rogue/quicksilver
	)
	var/list/candidates = list()
	for(var/datum/objective_item/oi in GLOB.possible_items)
		var/match = FALSE
		for(var/T in low_value_item_types)
			if(istype(oi, T))
				match = TRUE
				break
		if(match)
			// Respect excludefromjob if ever defined
			if(owner?.assigned_role && (owner.assigned_role in oi.excludefromjob))
				continue
			candidates += oi
	if(length(candidates))
		S.set_target(pick(candidates))
	else
		S.find_target()
	objectives += S
	return S


/datum/antagonist/crimson/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || (owner ? owner.current : null)
	if(M)
		add_antag_hud(antag_hud_type, antag_hud_name, M)
	return ..()

// Track the player's primary choice so Challenge can assign the rest later
var/const/CRIMSON_PRIMARY_ASSASSINATE_RANDOM = "Assassination (Random)"
var/const/CRIMSON_PRIMARY_ASSASSINATE_HV = "Assassination (High Value)"
var/const/CRIMSON_PRIMARY_THEFT_HV = "Theft (High Value)"
var/const/CRIMSON_PRIMARY_THEFT_LV = "Theft (Low Value)"

/datum/antagonist/crimson
	var/selected_primary_choice = null
	var/challenge_accepted = FALSE
	var/challenge_objectives_assigned = FALSE

// Called by the uplink when the player accepts the Challenge
/datum/antagonist/crimson/proc/on_challenge_accepted()
	challenge_accepted = TRUE
	if(!challenge_objectives_assigned)
		// Assign every other primary objective except the one the player picked
		var/list/all_choices = list(
			CRIMSON_PRIMARY_ASSASSINATE_RANDOM,
			CRIMSON_PRIMARY_ASSASSINATE_HV,
			CRIMSON_PRIMARY_THEFT_HV,
			CRIMSON_PRIMARY_THEFT_LV
		)
		for(var/choice in all_choices)
			if(choice == selected_primary_choice)
				continue
			if(choice == CRIMSON_PRIMARY_ASSASSINATE_RANDOM)
				assign_crimson_assassination(TRUE)
			else if(choice == CRIMSON_PRIMARY_ASSASSINATE_HV)
				assign_crimson_assassination(FALSE)
			else if(choice == CRIMSON_PRIMARY_THEFT_HV)
				assign_crimson_theft_high_value()
			else if(choice == CRIMSON_PRIMARY_THEFT_LV)
				assign_crimson_theft_low_value()
		challenge_objectives_assigned = TRUE
	return

// Helper: Are all non-escape antag objectives complete?
/datum/antagonist/crimson/proc/all_non_escape_objectives_completed()
	if(!objectives?.len)
		return FALSE
	for(var/datum/objective/O in objectives)
		if(istype(O, /datum/objective/escape))
			continue
		if(!O.check_completion())
			return FALSE
	return TRUE

/datum/antagonist/crimson/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || (owner ? owner.current : null)
	if(M)
		remove_antag_hud(antag_hud_type, M)
	return ..()

/datum/antagonist/crimson/on_removal()
	if(!silent && owner?.current)
		to_chat(owner.current, span_danger("I am no longer a [job_rank]!"))
	if(owner?.current)
		var/mob/living/carbon/human/H = owner.current
		REMOVE_TRAIT(H, TRAIT_STEELHEARTED, "[type]")
		REMOVE_TRAIT(H, TRAIT_SHARPER_BLADES, "[type]")
	owner.special_role = null
	return ..()



// A subtle signet ring used by Crimson agents; it conceals a clandestine uplink
/obj/item/clothing/ring/signet/crimson
	name = "crimson signet"
	desc = "A heavy signet ring engraved with a thorny rose. Its weight hints at hidden purpose."
	icon_state = "ring_g"


