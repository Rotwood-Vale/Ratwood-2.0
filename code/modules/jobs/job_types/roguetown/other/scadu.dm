GLOBAL_VAR(scadu_persistent_datum)
GLOBAL_VAR_INIT(scadu_slot_closed, FALSE)

/datum/job/roguetown/scadu
	title = "Scadu"
	display_title = "Scadu"
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	antag_job = TRUE
	always_show_on_latechoices = TRUE
	min_pq = null
	max_pq = null
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE
	can_random = FALSE
	hidden_job = FALSE
	wanderer_examine = FALSE
	selection_color = JCOLOR_WANDERER
	outfit = null
	advclass_cat_rolls = list("CTAG_SCADU" = 1)
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	tutorial = "You are the Scadu. Move through the bog as an invisible presence. Use the 'Select Ability' verb and click targets to spend lux on abilities. Place monuments to grow your power."
	job_greet_text = TRUE
	social_rank = SOCIAL_RANK_DIRT

/datum/job/roguetown/scadu/equip(mob/living/carbon/human/H, visualsOnly, announce, latejoin, datum/outfit/outfit_override, client/preference_source)
	return TRUE

/datum/job/roguetown/scadu/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	..()
	var/mob/living/carbon/human/body = H
	var/datum/mind/player_mind = M.mind
	spawn(2)
		do_scadu_transform(body, player_mind)

/datum/job/roguetown/scadu/proc/do_scadu_transform(mob/living/carbon/human/H, datum/mind/player_mind)
	if(!player_mind || QDELETED(H) || GLOB.scadu_slot_closed)
		return

	var/turf/spawn_turf = null
	if(length(GLOB.jobspawn_overrides["Scadu"]))
		spawn_turf = get_turf(pick(GLOB.jobspawn_overrides["Scadu"]))
	if(!spawn_turf)
		for(var/turf/T in get_area_turfs(/area/rogue/outdoors/bograt))
			if(isopenturf(T))
				spawn_turf = T
				break
	if(!spawn_turf)
		spawn_turf = get_turf(H)

	var/saved_key = H.key
	H.forceMove(spawn_turf)
	H.ghostize(can_reenter_corpse = FALSE)
	qdel(H)

	var/mob/dead/observer/rogue/scadu/SM = new(spawn_turf)
	SM.name = "The Scadu"
	SM.real_name = "The Scadu"

	var/datum/antagonist/scadu/antag = GLOB.scadu_persistent_datum
	if(!antag || QDELETED(antag))
		antag = new /datum/antagonist/scadu()
	GLOB.scadu_persistent_datum = antag

	antag.scadu_mob = SM
	SM.antag_datum = antag

	for(var/obj/structure/scadu_monument/M in antag.monuments)
		if(!QDELETED(M) && M.standing)
			M.owner_datum = antag
			M.start_lux_loop()

	SM.key = saved_key

	if(SM.mind)
		SM.mind.add_antag_datum(antag)
		SM.mind.special_role = "Scadu"
		SM.mind.assigned_role = "Scadu"

/datum/job/roguetown/scadu/greet(mob/player)
	if(player?.mind?.assigned_role != title)
		return
	to_chat(player, span_userdanger("You are the <b>Scadu</b>, a spirit of the bog without form or mercy."))
	to_chat(player, span_notice(tutorial))

/datum/job/roguetown/scadu/override_latejoin_spawn(mob/living/carbon/human/H)
	return TRUE

/datum/advclass/scadu_void
	name = "Scadu"
	tutorial = "The Scadu."
	maximum_possible_slots = -1
	category_tags = list("CTAG_SCADU")

/datum/advclass/scadu_void/equipme(mob/living/carbon/human/H, dummy)
	return

/obj/effect/landmark/start/scadu
	name = "Scadu"
	icon_state = "arrow"
	jobspawn_override = list("Scadu")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/goblin_portal_spawn
	name = "Goblin Portal"
	icon_state = "arrow"
	jobspawn_override = list("Goblin")
	delete_after_roundstart = FALSE

/datum/job/roguetown/goblin/override_latejoin_spawn(mob/living/carbon/human/H)
	var/list/landmarks = GLOB.jobspawn_overrides["Goblin"]
	if(!length(landmarks))
		return FALSE
	var/turf/dest = get_turf(pick(landmarks))
	if(!dest)
		return FALSE
	H.forceMove(dest)
	return TRUE
