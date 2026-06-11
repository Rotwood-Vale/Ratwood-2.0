/datum/job/roguetown/lady
	title = "Consort"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "你之所以被选中，多半是出于政治价值，而非什么爱情。经由这场婚姻，你成了大公最信任的知己，也许甚至是朋友。今日，你的忠诚，乃至你的爱意，都将遭受考验……因为那些指向你所爱之人的匕首，同样也正抵在你的喉头。"

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/servant,
	/obj/effect/proc_holder/spell/self/grant_nobility)
	outfit = /datum/outfit/job/roguetown/lady

	display_order = JDO_LADY
	give_bank_account = 50
	noble_income = 22
	min_pq = 5
	max_pq = null
	round_contrib_points = 3

/datum/job/roguetown/exlady
	title = "Consort Dowager"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE

/datum/outfit/job/roguetown/lady
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/lady/pre_equip(mob/living/carbon/human/H)
	. = ..()
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
//		SSticker.rulermob = H
	if(should_wear_femme_clothes(H))
		beltl = /obj/item/storage/keyring/royal
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		id = /obj/item/scomstone/garrison
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/storage/keyring/royal
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/silver
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_LCK, 5)

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "征募仆役"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "为王冠效命吧，%RECRUIT！"
	accept_message = "为了王冠！"
	refuse_message = "我拒绝。"
	recharge_time = 100
