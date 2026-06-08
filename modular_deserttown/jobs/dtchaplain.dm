/datum/job/roguetown/dtchaplain
	title = "Palace Chaplain"
	flag = DTCHAPLAIN
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_patrons = list(/datum/patron/old_god)
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/dtchaplain
	tutorial = "SOMETHING SOMETHING PSYDON, something something REFUGEE TENNITES in your BIG TEMPLE... UNEASY ALLIANCE? Brokering PEACE  with the tennites? Idunno!"
	display_order = JDO_CHAPLAIN
	give_bank_account = TRUE
	min_pq = 5
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	virtue_restrictions = list(/datum/virtue/utility/noble)//Hmm. I duno, they're PRETTY noble-like.
	job_traits = list(TRAIT_EMPATH, TRAIT_STEELHEARTED, TRAIT_SOUL_EXAMINE)
	cmode_music = 'sound/music/combat_desert2.ogg'
	advclass_cat_rolls = list(CTAG_DTCHAPLAIN = 2)
	job_subclasses = list(
		/datum/advclass/dtchaplain
	)

/datum/advclass/dtchaplain
	name = "Palace Chaplain"
	tutorial = "SOMETHING SOMETHING PSYDON, something something REFUGEE TENNITES in your BIG TEMPLE... UNEASY ALLIANCE? Brokering PEACE  with the tennites? Idunno!"
	outfit = /datum/outfit/job/roguetown/dtchaplain
	subclass_languages = list(/datum/language/otavan, /datum/language/celestial)
	category_tags = list(CTAG_DTCHAPLAIN)
	subclass_stats = list(
		STATKEY_INT = 2,//court knowledge
		STATKEY_WIL = 2,
		STATKEY_PER = 2,//eye for intrigue
		STATKEY_CON = -1,//scrawny pencil-pusher
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,//fancy lad school
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/dtchaplain
	name = "Palace Chaplain"
	jobtype = /datum/job/roguetown/dtchaplain
	has_loadout = TRUE
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/dtchaplain/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	wrists = /obj/item/clothing/wrists/roguetown/wrappings
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	cloak = /obj/item/clothing/cloak/psydontabard/alt

	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid//court money
	beltl = /obj/item/storage/keyring/chaplain
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff
	// backpack_contents = list(/obj/item/ritechalk)
	id = /obj/item/clothing/ring/signet/silver
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.

/datum/outfit/job/roguetown/dtchaplain/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

