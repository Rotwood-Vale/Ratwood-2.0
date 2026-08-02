/datum/advclass/foreigner/refugee
	name = "Naledi Refugee"
	tutorial = "An asylum-seeker or descendant thereof from the war-torn ruins of Naledi. The Fall of Naledi robbed you of your future, though fragments  of Naledi remain in what little training you carry."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/refugee
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_NALEDI)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/refugee/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/paths = list("Refugee (Default)", "Conclave Dropout (Hierophant)", "Desert Ascetic (Pontifex)", "Abandoned  Diviner (Vizier)")
	var/list/hmm = list("I left for a reason... (Default)", "The Djinn could be anywhere! (Naledi Complex)")
	var/path = input(H, "Choose your past.", "WHAT DID WAR TAKE FROM YOU?") as anything in paths
	var/complex = input(H, "How tightly bound to traditions you are?", "I HATE DJINNS!") as anything in hmm

	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/neck/roguetown/psicross/naledi
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
	pants = /obj/item/clothing/under/roguetown/skirt/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	beltr = /obj/item/flashlight/flare/torch/lantern

	switch(complex)
		if("The Djinn could be anywhere! (Naledi Complex)")
			ADD_TRAIT(H, TRAIT_NALEDI, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/lordmask/naledi
		else
			mask = /obj/item/clothing/mask/rogue/lordmask/tarnished

	switch(path)

		if("Refugee (Default)")
			to_chat(H, span_warning("An asylum-seeker from the war-torn deserts of Naledi, \
			the ruins of your great city are as unsafe as the deserts being ravaged by the Djinn."))
			r_hand = /obj/item/rogueweapon/spear/assegai
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

		if("Seminary Dropout (Hierophant)")
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("A would be promising Magos in the Hierophant halls, during a better era. The Fall of Naledi a hundred yils ago leaves whatever arcyne teachings of the hireophants you have managed to gather incomplete."))
			r_hand = /obj/item/rogueweapon/woodstaff
			head = /obj/item/clothing/head/roguetown/roguehood/hierophant
			cloak = /obj/item/clothing/cloak/hierophant
			backpack_contents += list(/obj/item/book/spellbook = 1)
			backpack_contents += list(/obj/item/chalk = 1)

			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearm, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)

			H.change_stat(STATKEY_INT, 3)
			H.change_stat(STATKEY_PER, -1)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_CON, -1)

			ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)

			if(H.mind)
				H.mind?.adjust_spellpoints(10)
				H.mind.AddSpell(new /datum/action/cooldown/spell/ley_lines)

		if("Desert Ascetic (Pontifex)")
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("You were being being taught the ways of a Pontifex, training in body and will. The Fall of Naledi a hundred yils ago left whatever your training incomplete, whatever it's source. Shunned for your survival and left without a master, you wandered the deserts with unfinished discipline."))
			r_hand = /obj/item/rogueweapon/katar
			armor = //obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/monke
			backpack_contents += list(/obj/item/chalk = 1)
			backpack_contents += list(/obj/item/book/spellbook = 1)

			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)

			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_PER, -1)
			H.change_stat(STATKEY_WIL, -1)
			H.change_stat(STATKEY_SPD, -1)

			ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

			if(H.mind)
				var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves for non-magic guys.
				var/technique_choice = input(H,"Choose your TECHNIQUE.", "DECIMATE AND DOMINATE WITH FLAIR.") as anything in techniques
				switch(technique_choice)
					if("Dropkick - Pushback + Extra Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
					if("Chokeslam - Stamina Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
					if("Stunner - Dazed Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
					if("Headbutt - Vulnerable Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
				H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
				H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blink/shadowstep)
				H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 5, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation)))

		if("Wandering Yogi (Vizier)")
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("A Vizier healer in training, your studies revolved around the esoteric Origin Magyck - The drawing of Psydon power as the origin of creation. The Fall of Naledi a hundred yils ago ensures that you are wandering in exile with only fragments of the art."))
			r_hand = /obj/item/rogueweapon/woodstaff
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
			cloak = /obj/item/clothing/cloak/raincloak/white
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/white

			backpack_contents += list(/obj/item/chalk = 1)

			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE, TRUE)

			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_LCK, 1)
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_WIL, -1)

			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)

			if(H.mind)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blink/shadowstep)
				H.mind.AddSpell(new /datum/action/cooldown/spell/vizier/restoration)
				H.mind.AddSpell(new /datum/action/cooldown/spell/vizier/divergence)
				H.mind.AddSpell(new /datum/action/cooldown/spell/vizier/acceleration)
				H.mind.AddSpell(new /datum/action/cooldown/spell/bestow_ward)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
				H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide)