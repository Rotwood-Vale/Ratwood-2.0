/datum/job/roguetown/greater_skeleton/bog
	title = "Bog Skeleton"
	total_positions = 3
	spawn_positions = 0
	job_reopens_slots_on_death = TRUE
	allowed_races = RACES_ALL_KINDS
	min_pq = null
	max_pq = null
	can_random = FALSE
	antag_job = TRUE
	no_virtue = TRUE
	announce_latejoin = FALSE
	give_bank_account = FALSE
	show_in_credits = FALSE
	hidden_job = TRUE
	advclass_cat_rolls = null
	job_subclasses = null
	job_traits = list(TRAIT_OUTLANDER, TRAIT_MEDIUMARMOR)
	outfit = /datum/outfit/job/roguetown/greater_skeleton/bog
	tutorial = "You are a shambling skeleton risen in the Rockhill bog. You can hit hard, but you are slow and brittle."

/datum/job/roguetown/greater_skeleton/bog/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.advsetup = FALSE
	H.invisibility = 0
	H.cure_blind("advsetup")
	H.become_skeleton()
	H.job = title
	if(H.mind)
		H.mind.assigned_role = title
	H.STASTR = 13
	H.STASPD = 8
	H.STACON = 9
	H.STAWIL = 13
	H.STAPER = 10
	H.STAINT = 3
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
	setup_bog_throwaway(H, M)

/datum/outfit/job/roguetown/greater_skeleton/bog
	head = /obj/item/clothing/head/roguetown/helmet/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut
	r_hand = /obj/item/rogueweapon/spear
