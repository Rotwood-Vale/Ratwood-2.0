/datum/job/roguetown/baron
	title = "Baron"
	flag = BARON
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	always_show_on_latechoices = TRUE

	outfit = /datum/outfit/job/roguetown/baron
	display_order = JDO_BARON
	tutorial = "Through birthright, favors or intrigue you have landed yourself in the position of being the baron of the outer reaches of the duchy. You answer to the duke but are given significant independence to run lowtown as you see fit, you hold sway in its dealings and in absence of higher authority the local garrison will answer to you. If the Marshall and Knight Captain are absent, the responsibility of managing the lowtown garrison falls to you."
	whitelist_req = FALSE
	give_bank_account = 40
	min_pq = 40
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_noble.ogg'
	advclass_cat_rolls = list(CTAG_BARON = 20)
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/baron/shrewd_nobleman,
		/datum/advclass/baron/landed_knight
	)

/datum/job/roguetown/baron/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(!ishuman(H))
		return
	var/mob/living/carbon/human/human_target = H
	human_target.apply_ownership_mark(null, "")

/datum/outfit/job/roguetown/baron
	neck = /obj/item/roguekey/manor
	id = /obj/item/scomstone/bad/garrison
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	pants = /obj/item/clothing/under/roguetown/trou/formal
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	head = /obj/item/clothing/head/roguetown/chaperon/noble
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/roguekey/baron = 1)

// Baron subclasses

/datum/advclass/baron/shrewd_nobleman
	parent_type = /datum/advclass
	name = "Shrewd Nobleman"
	tutorial = "A noble in the most traditional sense, you use your wit and status to achieve your goals."
	outfit = /datum/outfit/job/roguetown/baron/shrewd_nobleman
	category_tags = list(CTAG_BARON)
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/baron/shrewd_nobleman/pre_equip(mob/living/carbon/human/H)
	..()
	beltr = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/datum/advclass/baron/landed_knight
	parent_type = /datum/advclass
	name = "Landed Knight"
	tutorial = "Rewarded with land for your noble service you have changed from wielding the sword to wielding the pen."
	outfit = /datum/outfit/job/roguetown/baron/landed_knight
	category_tags = list(CTAG_BARON)
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/baron/landed_knight/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	backl = /obj/item/rogueweapon/shield/iron
