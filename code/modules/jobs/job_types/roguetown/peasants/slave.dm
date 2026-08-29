/datum/job/roguetown/rockhillslave
	title = "Slave"
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allowed_races = ACCEPTED_RACES
	tutorial = "Traded around like common goods you are deprived of your freedom and been trained into an obedient implement of your masters. Whether it be making them rich or making them comfortable you serve at their leisure with your continued well being entirely dependent on your owner's good will."
	outfit = /datum/outfit/job/roguetown/slave
	display_order = JDO_SLAVE
	give_bank_account = 0
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_bum.ogg'
	advclass_cat_rolls = list(CTAG_SLAVE = 20)
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_OWNED_SLAVE)
	job_subclasses = list(
		/datum/advclass/slave/house_slave,
		/datum/advclass/slave/labor_slave,
		/datum/advclass/slave/slave_sentry
	)

/datum/job/roguetown/rockhillslave/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(!ishuman(H))
		return
	var/mob/living/carbon/human/human_target = H
	human_target.apply_ownership_mark(null, "")

/datum/outfit/job/roguetown/rockhillslave
	neck = /obj/item/clothing/neck/roguetown/collar/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	pants = /obj/item/clothing/under/roguetown/tights/random
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	beltl = /obj/item/storage/keyring/rockhillslaves

// Slave Subclasses

/datum/advclass/slave
	subclass_languages = list(/datum/language/celestial)

/datum/advclass/slave/house_slave
	parent_type = /datum/advclass/slave
	name = "House Slave"
	tutorial = "You are trained as a servant, \
	Keep the Master's abode clean, prepare meals, serve them."
	outfit = /datum/outfit/job/roguetown/rockhillslave/house_slave
	category_tags = list(CTAG_SLAVE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/craft/ceramics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/music = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/rockhillslave/house_slave/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/apron
	head = /obj/item/clothing/head/roguetown/maidband
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/soap/bath
	)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
	H.set_blindness(0)

/datum/advclass/slave/labor_slave
	parent_type = /datum/advclass/slave
	name = "Labor Slave"
	tutorial = "You are trained as a laborer, \
	Toil for the Master's needs, serve them."
	outfit = /datum/outfit/job/roguetown/rockhillslave/labor_slave
	category_tags = list(CTAG_SLAVE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_SMITHING_EXPERT)
	subclass_skills = list(
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/rockhillslave/labor_slave/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/allwrappings
	head = /obj/item/clothing/head/roguetown/headband
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/pick
	backr = /obj/item/storage/hip/orestore/bronze
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/stoneaxe/handaxe = 1,
	)
	H.set_blindness(0)

/datum/advclass/slave/slave_sentry
	parent_type = /datum/advclass/slave
	name = "Slave Sentry"
	maximum_possible_slots = 2
	tutorial = "You are trained as a fighter, \
	Protect your Master's interests, serve them."
	outfit = /datum/outfit/job/roguetown/rockhillslave/slave_sentry
	category_tags = list(CTAG_SLAVE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/rockhillslave/slave_sentry/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	neck = /obj/item/clothing/neck/roguetown/gorget
	head = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/spear
	H.set_blindness(0)
