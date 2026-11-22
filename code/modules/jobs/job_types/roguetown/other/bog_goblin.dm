/datum/job/roguetown/goblin/bog
	title = "Bog Goblin"
	total_positions = 4
	spawn_positions = 0
	job_reopens_slots_on_death = TRUE
	allowed_races = RACES_ALL_KINDS
	min_pq = null
	max_pq = null
	can_random = FALSE
	no_virtue = TRUE
	antag_job = TRUE
	announce_latejoin = FALSE
	give_bank_account = FALSE
	show_in_credits = FALSE
	hidden_job = TRUE
	job_traits = list(TRAIT_OUTLANDER)
	outfit = /datum/outfit/job/roguetown/bog_goblin
	tutorial = "You are a small, nimble goblin of the Rockhill bog. Your life is brief and you are dangerously fragile."

/datum/job/roguetown/goblin/bog/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.job = title
	if(H.mind)
		H.mind.assigned_role = title
	else if(M?.mind)
		M.mind.assigned_role = title
	H.name = "Bog Goblin"
	H.real_name = "Bog Goblin"
	H.STASTR = 8
	H.STASPD = 14
	H.STACON = 7
	H.STAWIL = 13
	H.STAPER = 10
	H.STAINT = 5
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
	setup_bog_throwaway(H, M)

/datum/outfit/job/roguetown/bog_goblin
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
	r_hand = /obj/item/rogueweapon/spear/stone
	beltl = /obj/item/rogueweapon/huntingknife/stoneknife
