/datum/advclass/vagabond_excommunicated
	name = "Excommunicated"
	tutorial = "The Church has found you bereft of mercy, and you walk the lands of the vale with nothing but the tattered shreds of the faith you cling to."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/excommunicated
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_CON = -1,
		STATKEY_WIL = -1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vagabond/excommunicated/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind?.current)
		H.mind.current.faction += "[H.name]_faction"
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	r_hand = /obj/item/rogueweapon/woodstaff

	if (H.mind)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR)	//Minor regen, can level up to T4.
		GLOB.excommunicated_players += H.real_name // john roguetown, you are EXCOMMUNICADO.

/datum/outfit/job/roguetown/vagabond/excommunicated/choose_loadout(mob/living/carbon/human/H)
	if(H.patron?.type == /datum/patron/divine/noc) // Arcyne and Knowledge - Probably good at reading and the other arcyne adjacent stuff.
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE) // for their arcane spells, very little CDR and cast speed.
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
			H.mind.set_spell_mastery("arcane", 1)
			H.mind.set_spell_mastery("illusion", 1)
		ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC) // So that they can take arcyne potential and not break.
