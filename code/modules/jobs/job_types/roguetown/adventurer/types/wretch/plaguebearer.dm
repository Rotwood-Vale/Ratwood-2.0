/datum/advclass/wretch/plaguebearer
	name = "Malpractitioner"
	tutorial = "A disgraced physician forced into exile and years of hardship, you have turned to a private practice. Operating beyond the bounds of the law, you work with traitors, heretics, and common criminals as easily as your peers would treat a peasant or craftsman."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/plaguebearer
	cmode_music = 'sound/music/combat_physician.ogg'
	class_select_category = CLASS_CAT_TRADER
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_CICERONE, TRAIT_NOSTINK, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	maximum_possible_slots = 1 //They spawn with killer's ice lol I'm limiting this shit 
	extra_context = "This subclass has a choice of starting with a poisonable dagger and a bow with poison arrows, a poisonable dagger and magic, or a rapier and the ability to dodge well."
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_CON = 2
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, // To escape grapplers, fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN, //Build your gooncave 
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY, //Disgraced medicine man. 
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY, // This is literally their whole thing
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN, // Farm ingredients so you have something to do that isn't grinding skills
	)

/datum/outfit/job/roguetown/wretch/plaguebearer/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/physician
	mask = /obj/item/clothing/mask/rogue/physician
	neck = /obj/item/clothing/neck/roguetown/chaincoif 
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	r_hand = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	belt = /obj/item/storage/belt/rogue/leather/black
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1, // You get one epic poison. As a treat because you're valid. Don't waste it. 
		/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/natural/worms/leech/cheele = 1,
		)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.mind)
		var/primary_weapons = list("A Poison Dagger", "A Rapier and Agility")
		var/primary_weapon_choice = input(H, "Choose your signature weapon.", "TOOLS OF YOUR TRADE") as anything in primary_weapons
		H.set_blindness(0)
		switch(primary_weapon_choice)
			if("A Poison Dagger")
				backpack_contents += /obj/item/rogueweapon/huntingknife/idagger/steel/corroded
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				var/additional_weapons = list("Archery", "Magic")
				var/additional_weapon_choice = input(H, "Effective, but risky. What gives you range?", "TOOLS OF YOUR TRADE") as anything in additional_weapons
				switch(additional_weapon_choice)
					if("Archery")
						H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
						backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
						beltl = /obj/item/quiver/poisonarrows
					if("Magic")
						H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
						backr = /obj/item/rogueweapon/woodstaff/toper
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/acidsplash)
			if("A Rapier and Agility")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/rapier
		wretch_select_bounty(H)
