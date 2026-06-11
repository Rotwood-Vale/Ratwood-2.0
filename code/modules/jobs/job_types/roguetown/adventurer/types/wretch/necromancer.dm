/datum/advclass/wretch/necromancer
	name = "死灵法师"
	tutorial = "你因施展黑暗魔法、亵渎生命而遭到社会排斥与追猎。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/necromancer
	cmode_music = 'sound/music/combat_heretic.ogg'
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_ZOMBIE_IMMUNE, TRAIT_MAGEARMOR, TRAIT_GRAVEROBBER, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT, TRAIT_MEDICINE_EXPERT,TRAIT_RITUALIST,TRAIT_OUTLANDER,)
	maximum_possible_slots = 2 // Going from 1 to 2, because skeleton that are summoned count AGAINST antagonist cap and they don't always shows up
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_spellpoints = 16
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //For lux extractions.
	)

/datum/outfit/job/roguetown/wretch/necromancer/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/necromhood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/necromancer
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/clothing/neck/roguetown/gorget
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/necro_relics/necro_crystal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/ritechalk = 1
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_MASTER, TRUE)
		H.mind?.adjust_spellpoints(6)
	if(H.mind)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		H.set_patron(/datum/patron/inhumen/zizo)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/eyebite)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tame_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_guard)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/lacrima/free)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
		wretch_select_bounty(H)
	H.grant_language(/datum/language/undead)

	var/staffs = list(
		"ronts 系法杖",
		"blortz 系法杖",
		"saffira 系法杖",
		"gemerald 系法杖",
		"amethyst 系法杖",
		"toper 系法杖",
	)
	var/staffchoice = input(H, H, "选择你的法杖", "可选法杖") as anything in staffs
	switch(staffchoice)
		if("ronts 系法杖")
			backr = /obj/item/rogueweapon/woodstaff/ruby
		if("blortz 系法杖")
			backr = /obj/item/rogueweapon/woodstaff/quartz
		if("saffira 系法杖")
			backr = /obj/item/rogueweapon/woodstaff/sapphire
		if("gemerald 系法杖")
			backr = /obj/item/rogueweapon/woodstaff/emerald
		if("amethyst 系法杖")
			backr = /obj/item/rogueweapon/woodstaff/amethyst
		if("toper 系法杖")
			backr = /obj/item/rogueweapon/woodstaff/toper
