//seperated into two classes so they can change names into more map-friendly names via maphandlers depending on the map.
/datum/job/roguetown/thugb
	title = "Blortz Volves Thug"
	flag = BTHUG
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	allowed_races = ACCEPTED_RACES
	tutorial = "Maybe you've never been the smartest person in town, but you've gotten this far - whether by finding odd-jobs around town carting shit for the soilers,\
			being the meathead that somebody needs to stand behind them and look scary, or simply shaking down the weak with the veiled-or-otherwise threat of a clobbering.\
			You might've had some run-ins with the law for petty crimes here and there, but you're still a resident; and your heart beats in these lands.\
			\
			You're a member of street gang Blortz Volves, a lot of time has passed and now you have to build up your power again, \
			those bastards from Rontz Ratz will answer for this. \
			Blortz Wolves howl - enemies cower!"
	advclass_cat_rolls = list(CTAG_THUGB = 20)
	outfit = /datum/outfit/job/roguetown/adventurer/thugb
	outfit_female = /datum/outfit/job/roguetown/adventurer/thugb
	bypass_lastclass = TRUE
	bypass_jobban = FALSE
	display_order = JDO_THUGB
	give_bank_account = TRUE
	min_pq = 1 //Someones first round should preferably NOT be a thug round.
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	same_job_respawn_delay = 0
	class_setup_examine = TRUE
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_GANG_B, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEEPRICES_SHITTY, TRAIT_DRUNK_HEALING)
	job_subclasses = list(
		/datum/advclass/goon,
		/datum/advclass/miscreant,
		/datum/advclass/muscle,
		/datum/advclass/longshoreman,
	)

/datum/outfit/job/roguetown/adventurer/thugb/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	mask = /obj/item/clothing/mask/rogue/ragmask/azure
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/beer = 1)
