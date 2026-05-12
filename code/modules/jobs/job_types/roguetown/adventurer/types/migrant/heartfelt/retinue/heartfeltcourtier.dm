
/datum/advclass/heartfelt/retinue/courtier
	name = "Heartfeltian Courtier"
	tutorial = "You are a Courtier of Heartfelt, once a respected noblewoman now struggling to survive in a desolate landscape. \
	With your home in ruins, you look to the Vale, hoping to find new purpose or refuge amidst the chaos."
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/courtier
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	subclass_social_rank = SOCIAL_RANK_NOBLE
	class_select_category = CLASS_CAT_HFT_COURT
	
// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

	traits_applied = list(TRAIT_SEEPRICES, TRAIT_NOBLE, TRAIT_NUTCRACKER, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
	/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/heartfelt/retinue/courtier/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	cloak = /obj/item/clothing/cloak/heartfelt
	shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
	if(isdwarf(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress
	else
		if(prob(66))
			armor = /obj/item/clothing/suit/roguetown/armor/armordress/alt
		else
			armor = /obj/item/clothing/suit/roguetown/armor/armordress
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	id = /obj/item/clothing/ring/silver
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
	/obj/item/lockpickring/mundane = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/elfred = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake = 1,
	)
