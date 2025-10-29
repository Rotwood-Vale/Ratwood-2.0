/datum/antagonist/crimson
	name = "Crimson Agent"
	roundend_category = "crimson agents"
	antagpanel_category = "Crimson Agent"
	job_rank = ROLE_CRIMSON_AGENT
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "crimson agent"
	show_in_roundend = FALSE
	confess_lines = list(
		"THE GOLDEN ROSA DOES NOT EXIST!",
		"BLOOD IS MY ART FORM!",
		"I KNOW TRUE ART!",
)
	can_coexist_with_others = TRUE
	rogue_enabled = TRUE

/datum/antagonist/crimson/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/crimson))
		return span_boldnotice("Another agent of the Golden Rosa.")

/datum/antagonist/crimson/on_gain()
	. = ..()
	owner.special_role = ROLE_CRIMSON_AGENT
	var/mob/living/carbon/human/H = owner.current
	if(owner?.current)
		owner.current.playsound_local(get_turf(owner.current), 'sound/villain/crimson_intro.ogg', 60, FALSE, pressure_affected = FALSE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, "[type]")
		ADD_TRAIT(H, TRAIT_SHARPER_BLADES, "[type]")
	to_chat(H, span_bigbold(span_red("I am a member of the GOLDEN ROSA!")))
	to_chat(H, span_boldwarning("I have been tasked by the Queen of Ferentia Herself, Queen Alexia the Righteous, with this extremely ambitious task. I must work together with my peers to harness Runes and Vitae from people to finally awaken PSYDON from his slumber!"))
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



/datum/antagonist/crimson/greet()
	if(owner?.current)
		owner.announce_objectives()
	..()

/datum/antagonist/crimson/proc/forge_crimson_objectives()
	// Replace any and all default objectives with a single Golden Rosa objective
	objectives = list()
	var/datum/objective/golden_psydon/O = new
	O.owner = owner
	O.update_explanation_text()
	objectives += O
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
	// No longer assign additional objectives on Challenge; the Golden Rosa has but one purpose
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



// A subtle signet ring used by Rosa agents; it conceals a clandestine uplink
/obj/item/clothing/ring/signet/crimson
	name = "golden signet"
	desc = "A heavy signet ring engraved with a thorny rose. Its weight hints at hidden purpose."
	icon_state = "ring_g"


// Singular Golden Rosa objective: an oath rather than a checklist
/datum/objective/golden_psydon
	name = "Awaken PSYDON"
	explanation_text = "I must awaken PSYDON, and usher in a new Golden Era for Humenity!"

/datum/objective/golden_psydon/check_completion()
	// This is a narrative objective; it is not auto-completable by the game logic
	return FALSE


