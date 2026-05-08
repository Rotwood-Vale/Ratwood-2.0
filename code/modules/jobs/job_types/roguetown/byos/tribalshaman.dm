/datum/job/roguetown/tribalshaman
	title = "Tribal Shaman"
	flag = TRIBALSHAMAN
	department_flag = TRIBAL
	selection_color = JCOLOR_TRIBAL
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = list(/datum/species/goblinp, /datum/species/anthromorphsmall, /datum/species/kobold)
	allowed_sexes = list(MALE, FEMALE)
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	display_order = JDO_TRIBALSHAMAN
	// tutorial = "Ooga chacka ZAP a chacka!"
	tutorial = "You've seen visions of fire and magma, gnashing claws and red scales. The Dragon's will burns behind your eyes, and Graggar's voice echoes in your dreams. \
	Your wild hallucinations and prophetic trances set you apart from the rest of your tribe—some fear you, others revere you, but all know you are touched by something greater. \
	You serve as the spiritual heart of the tribe, guiding the Chief and your kin with fervent, sometimes unsettling, devotion. \
	Let no one doubt your faith: you are the Dragon's chosen, and you will do anything, no matter how mad, to see Graggar's vision made real."
	outfit = /datum/outfit/job/roguetown/tribalshaman
	whitelist_req = TRUE
	min_pq = 8 //High potential for abuse, lovepotion/killersice/greater fireball is not for the faint of heart
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	advclass_cat_rolls = list(CTAG_TRIBALSHAMAN = 2)
	// social_rank = SOCIAL_RANK_NOBLE
	// Can't get very far as a magician if you can't chant spells now can you?
	vice_restrictions = list(/datum/charflaw/mute)

	job_traits = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T4, TRAIT_SEEPRICES, TRAIT_INTELLECTUAL, TRAIT_ALCHEMY_EXPERT, TRAIT_TRIBAL, TRAIT_DARKVISION)
	job_subclasses = list(
		/datum/advclass/courtmage
	)

/datum/advclass/tribalshaman
	name = "Tribe Shaman"
	tutorial = "Ooga chacka ZAP a chacka!"
	outfit = /datum/outfit/job/roguetown/tribalshaman/basic

	subclass_spellpoints = 33
	category_tags = list(CTAG_TRIBALSHAMAN)
	subclass_stats = list(
		STATKEY_INT = 5,// Automatic advanced magic for most spells. (I.E summon weapon being upgraded to steel from iron/etc)
		STATKEY_PER = 3,
		STATKEY_LCK = 1,// Leadership carrot, stats weight lower than usual leadership weight due to having T4 magic.
		STATKEY_STR = -1,
		STATKEY_CON = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE, // more stam for holding spells
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/tribalshaman
	has_loadout = TRUE

/datum/outfit/job/roguetown/tribalshaman/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 6, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(6)

/datum/outfit/job/roguetown/tribalshaman/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.faction += list("orcs", "tribe")
	if(!H.has_language(/datum/language/draconic))
		H.grant_language(/datum/language/draconic)
	neck = /obj/item/clothing/neck/roguetown/talkstone
	mask = /obj/item/clothing/mask/rogue/facemask/goldmask
	cloak = /obj/item/clothing/cloak/tribal
	shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/tribalchief
	beltl = /obj/item/storage/magebag/associate
	id = /obj/item/clothing/ring/gold
	r_hand = /obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/recipe_book/alchemy,
		/obj/item/recipe_book/magic,
		/obj/item/book/spellbook,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	)
