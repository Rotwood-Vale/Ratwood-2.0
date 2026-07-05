/datum/job/roguetown/hag
	title = "Hag"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "You are ancient, malevolent evil. None of the known gods claim to have brought you into this world. All you know is hatred, how to sift through the grains of this land with your calloused hands, picking those who prove themselves useful."

	outfit = /datum/outfit/job/roguetown/hag
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE

	obsfuscated_job = TRUE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES

	job_traits = list(
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
		TRAIT_SELF_SUSTENANCE,
		TRAIT_LEECHIMMUNE,
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_WILDERNESSGUIDE,
		TRAIT_EXTREME_TEMPERATURE_IMMUNE,
		TRAIT_ANTISCRYING,
		TRAIT_LONGSTRIDER,
	)

	job_stats = list(
		STATKEY_STR = -7,
		STATKEY_WIL = 8,
		STATKEY_SPD = -2,
		STATKEY_CON = 1,
		STATKEY_INT = 9,
	)

	skills = list(
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
