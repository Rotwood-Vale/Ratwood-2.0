/datum/job/roguetown/exiled
	title = "Exiled Towner"
	flag = EXILED
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	allowed_races = ACCEPTED_RACES
	tutorial = "For one reason or another the duchy has sentenced you to be exiled to the Island of Sauro for your crimes, work your way back into society or be damned to stay on this forsaken island or travel the seas in search of a better life where Abyssor may take you."
	outfit = null
	outfit_female = null
	bypass_lastclass = TRUE
	bypass_jobban = FALSE


	advclass_cat_rolls = list(CTAG_VILLAGER = 20)
	give_bank_account = TRUE
	min_pq = -15
	max_pq = null
	round_contrib_points = 3
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	class_setup_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_subclasses = list(
		/datum/advclass/barbersurgeon,
		/datum/advclass/blacksmith,
		/datum/advclass/cheesemaker,
		/datum/advclass/drunkard,
		/datum/advclass/fisher,
		/datum/advclass/hunter,
		/datum/advclass/hunter/spear,
		/datum/advclass/miner,
		/datum/advclass/minstrel,
		/datum/advclass/peasant,
		/datum/advclass/potter,
		/datum/advclass/seamstress,
		/datum/advclass/thug,
		/datum/advclass/witch,
		/datum/advclass/woodworker
	)

/datum/job/roguetown/exiled/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		SSjob.sync_resident_wanderer_knowledge(H)
