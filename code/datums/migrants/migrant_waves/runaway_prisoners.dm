#define CTAG_RUNAWAY_PRISONER "runaway_prisoner"

/datum/migrant_wave/runaway_prisoners
	name = "逃亡囚犯"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_one
	weight = 50
	roles = list(
		/datum/migrant_role/runaway_prisoner = 4
	)
	greet_text = "你已在牢房中腐烂了多年。虽然你成功逃脱，却早已一无所有，身体萎缩，心神迟钝。但有一件事你无比清楚，你绝不会再回去。"

/datum/migrant_wave/runaway_prisoners_down_one
	name = "逃亡囚犯"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_two
	roles = list(
		/datum/migrant_role/runaway_prisoner = 3
	)

/datum/migrant_wave/runaway_prisoners_down_two
	name = "逃亡囚犯"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_three
	roles = list(
		/datum/migrant_role/runaway_prisoner = 2
	)

/datum/migrant_wave/runaway_prisoners_down_three
	name = "逃亡囚犯"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	roles = list(
		/datum/migrant_role/runaway_prisoner = 1
	)

/datum/migrant_role/runaway_prisoner
	name = "越狱囚犯"
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_RUNAWAY_PRISONER = 20)

/datum/advclass/runaway_prisoner_commoner
	name = "逃亡囚犯（平民）"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner/commoner
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/runaway_prisoner_noble
	name = "逃亡囚犯（贵族）"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner/noble
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_NOBLE, TRAIT_SEEPRICES)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/runaway_prisoner_mage
	name = "逃亡囚犯（法师）"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner/mage
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_spellpoints = 18
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/runaway_prisoner/noble/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "你的罪名是什么？", "罪名") as text|null
	if (!my_crime)
		my_crime = "冒犯王冠之罪"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "谷地司法庭")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar


/datum/outfit/job/roguetown/adventurer/runaway_prisoner/commoner/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "你的罪名是什么？", "罪名") as text|null
	if (!my_crime)
		my_crime = "冒犯王冠之罪"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "谷地司法庭")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar


/datum/outfit/job/roguetown/adventurer/runaway_prisoner/mage/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "你的罪名是什么？", "罪名") as text|null
	if (!my_crime)
		my_crime = "冒犯王冠之罪"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "谷地司法庭")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
