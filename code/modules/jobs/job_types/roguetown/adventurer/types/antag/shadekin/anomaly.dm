/datum/job/roguetown/anomaly
	title = "Anomaly"
	flag = ANOMALY
	antag_job = TRUE
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_races = list(/datum/species/shadekin)
	tutorial = "You are a Shadekin Anomaly - a being of shadow that exists between worlds. \
	You observe the mortal realm with curiosity, occasionally manifesting to explore, \
	sneak food, or simply watch. You are NOT a combatant. You are rarely seen, \
	and you must not interfere with kingdom business. Use your void walk to remain hidden, \
	and be careful not to exhaust your shadow energy or you will collapse asleep wherever you stand."
	outfit = /datum/outfit/job/roguetown/anomaly
	outfit_female = /datum/outfit/job/roguetown/anomaly
	display_order = JDO_ANOMALY
	show_in_credits = FALSE
	min_pq = 20
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_ANOMALY = 20)
	round_contrib_points = 1

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 3 MINUTES

	job_subclasses = list(
		/datum/advclass/anomaly/watcher,
	)

/datum/job/roguetown/anomaly/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/shadekin_anomaly))
			var/datum/antagonist/new_antag = new /datum/antagonist/shadekin_anomaly()
			H.mind.add_antag_datum(new_antag)

/// Anomaly Watcher subclass(es?)
/datum/advclass/anomaly/watcher
	name = "Watcher"
	tutorial = "You are a Watcher - a Shadekin Anomaly that observes the mortal world from the shadows. \
	Your curiosity drives you to explore, but your nature demands discretion. You cannot be involved in \
	kingdom politics or combat. You are a passive presence, a shadow in the corner, a curious being \
	that occasionally reveals itself for interesting interactions."
	allowed_races = list(/datum/species/shadekin)
	category_tags = list(CTAG_ANOMALY)
	outfit = /datum/outfit/job/roguetown/anomaly

	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/// Anomaly outfit
/datum/outfit/job/roguetown/anomaly

/datum/outfit/job/roguetown/anomaly/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
