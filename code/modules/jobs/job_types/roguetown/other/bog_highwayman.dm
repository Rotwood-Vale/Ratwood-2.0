/datum/job/roguetown/throwaway_highwayman
	title = "Bog Highwayman"
	flag = NONE
	department_flag = SLOP
	faction = "Station"
	total_positions = 4
	spawn_positions = 0
	job_reopens_slots_on_death = TRUE
	allowed_races = list(/datum/species/human/northern)
	min_pq = null
	max_pq = null
	can_random = FALSE
	no_virtue = TRUE
	antag_job = TRUE
	announce_latejoin = FALSE
	give_bank_account = FALSE
	show_in_credits = FALSE
	hidden_job = TRUE
	job_traits = list(TRAIT_OUTLANDER, TRAIT_OUTLAW)
	outfit = /datum/outfit/job/roguetown/bog_highwayman
	tutorial = "You are a highway robber lurking in the Rockhill marsh. You have one life. Choose your targets carefully."

/datum/job/roguetown/throwaway_highwayman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		setup_bog_throwaway(H, M)

/datum/outfit/job/roguetown/bog_highwayman
	mask = /obj/item/clothing/mask/rogue/ragmask/red
	head = /obj/item/clothing/head/roguetown/helmet/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife/idagger
	r_hand = /obj/item/rogueweapon/sword/short/iron
	l_hand = /obj/item/rogueweapon/shield/wood

/datum/outfit/job/roguetown/bog_highwayman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.STASTR = 12
	H.STASPD = 12
	H.STACON = 10
	H.STAWIL = 11
	H.STAPER = 11
	H.STAINT = 10
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
