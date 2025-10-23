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
	forge_crimson_objectives()

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

/datum/antagonist/crimson/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || (owner ? owner.current : null)
	if(M)
		add_antag_hud(antag_hud_type, antag_hud_name, M)
	return ..()

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


