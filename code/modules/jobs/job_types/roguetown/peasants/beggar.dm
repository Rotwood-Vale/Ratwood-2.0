/datum/job/roguetown/beggar
	title = "Beggar"
	display_title = "乞丐"
	flag = BEGGAR
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST
	outfit = /datum/outfit/job/roguetown/vagrant
	job_traits = list(TRAIT_HOMESTEAD_EXPERT)
	bypass_lastclass = TRUE
	bypass_jobban = FALSE
	min_pq = -30
	max_pq = null

	tutorial = "你那身浸透尿骚味的破衣早已熏不着自己了，旁人投来的厌恶与嫌憎目光，如今在你眼里都像是一种亲切问候！你之所以还没被人顺手宰掉，不过是因为据说 沃尔夫 会厌恶腐肉的臭气。你会成为一个活生生的沉痛提醒，告诉世人：这世上若有不该降生之物落地，会变成什么模样。"
	display_order = JDO_VAGRANT
	show_in_credits = FALSE
	can_random = FALSE

	cmode_music = 'sound/music/combat_bum.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	/// Chance to become a wise beggar, if we still have space for more wise beggars
	var/wise_chance = 10
	/// Amount of wise beggars spawned as of now
	var/wise_amount = 0
	/// Maximum amount of wise beggars that can be spawned
	var/wise_max = 3
	/// Outfit to use when wise beggar triggers
	var/wise_outfit = /datum/outfit/job/roguetown/vagrant/wise

/datum/job/roguetown/beggar/New()
	. = ..()
	peopleknowme = list()

/datum/job/roguetown/beggar/get_outfit(mob/living/carbon/human/wearer, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, preference_source = null)
	if((wise_amount < wise_max) && prob(wise_chance))
		wise_amount++
		return wise_outfit
	return ..()

/datum/outfit/job/roguetown/vagrant/pre_equip(mob/living/carbon/human/H)
	..()
	// wise beggar!!!
	// guaranteed full beggar gear + random stats
	if(is_wise)
		head = /obj/item/clothing/head/roguetown/wizhat/gen/wise //wise hat
		beltr = /obj/item/reagent_containers/powder/moondust
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		shoes = /obj/item/clothing/shoes/roguetown/shalal // wise boots
		r_hand = /obj/item/rogueweapon/woodstaff/wise // dog beating staff
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special // dog butchering knife
		H.adjust_skillrank(/datum/skill/misc/sneaking, rand(2,5), TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, rand(2,5), TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE) //very good reading he is wise
		H.adjust_skillrank(/datum/skill/combat/polearms, rand(2,5), TRUE) // dog beating staff
		H.STASTR = rand(1, 20)
		H.STAINT = rand(5, 20)
		H.STALUC = rand(1, 20)
		H.change_stat(STATKEY_CON, -rand(0, 2))
		H.change_stat(STATKEY_WIL, -rand(0, 2))
		H.real_name = "[H.real_name] 贤者"
		H.name = "[H.name] 贤者"
		H.facial_hairstyle = "Knowledge"
		H.update_hair()
		H.age = AGE_OLD
		return
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap
	else
		head = null
	if(prob(5))
		beltr = /obj/item/reagent_containers/powder/moondust
	else
		beltr = null
	if(prob(10))
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis
	else
		beltl = null
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	else
		cloak = null
	if(prob(10))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	else
		gloves = null
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		armor = null
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/sneaking, rand(1,5), TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, rand(1,5), TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, pick (1,2,3,4,5), TRUE) // thug lyfe
		H.STALUC = rand(1, 20)
	if(prob(5))
		r_hand = /obj/item/rogueweapon/mace/woodclub
	else
		r_hand = null
	if(prob(5))
		l_hand = /obj/item/rogueweapon/mace/woodclub
	else
		l_hand = null
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, -4)
	H.change_stat(STATKEY_CON, -3)
	H.change_stat(STATKEY_WIL, -3)
	H.grant_language(/datum/language/thievescant)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NASTY_EATER, TRAIT_GENERIC)

/datum/outfit/job/roguetown/vagrant
	name = "乞丐"
	/// Whether or not we get wise gear and stats
	var/is_wise = FALSE

/datum/outfit/job/roguetown/vagrant/wise
	name = "贤者乞丐"
	is_wise = TRUE
