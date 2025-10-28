#define CTAG_RUNAWAY_PRISONER "runaway_prisoner"

/datum/migrant_wave/runaway_prisoners
	name = "Runaway Prisoners"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_one
	weight = 50
	roles = list(
		/datum/migrant_role/runaway_prisoner = 4
	)
	greet_text = "You've been rotting for years in a cell. Though you escaped, you have nothing - your body atrophied, your mind dulled. But one thing you know clearly - you are not going back."

/datum/migrant_wave/runaway_prisoners_down_one
	name = "Runaway Prisoners"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_two
	roles = list(
		/datum/migrant_role/runaway_prisoner = 3
	)

/datum/migrant_wave/runaway_prisoners_down_two
	name = "Runaway Prisoners"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	downgrade_wave = /datum/migrant_wave/runaway_prisoners_down_three
	roles = list(
		/datum/migrant_role/runaway_prisoner = 3
	)

/datum/migrant_wave/runaway_prisoners_down_three
	name = "Runaway Prisoners"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/runaway_prisoners
	roles = list(
		/datum/migrant_role/runaway_prisoner = 2
	)

/datum/migrant_role/runaway_prisoner
	name = "Escaped Prisoner"
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_RUNAWAY_PRISONER = 20)

/datum/advclass/runaway_prisoner_commoner
	name = "Runaway Prisoner (commoner)"
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

/datum/advclass/runaway_prisoner_noble
	name = "Runaway Prisoner (Noble)"
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

/datum/advclass/runaway_prisoner_mage
	name = "Runaway Prisoner (Mage)"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/runaway_prisoner/mage
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_ARCYNE_T3)
	category_tags = list(CTAG_RUNAWAY_PRISONER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_CON = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_INT = 3,
	)

/datum/outfit/job/roguetown/adventurer/runaway_prisoner/noble/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "The Justiciary of Rotwood Vale")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)

/datum/outfit/job/roguetown/adventurer/runaway_prisoner/commoner/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "The Justiciary of Rotwood Vale")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)

/datum/outfit/job/roguetown/adventurer/runaway_prisoner/mage/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(100, 200), FALSE, my_crime, "The Justiciary of Rotwood Vale")
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.mind?.adjust_spellpoints(21)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)