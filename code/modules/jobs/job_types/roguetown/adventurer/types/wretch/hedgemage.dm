// Hedge Mage, a pure mage adventurer sidegrade to Necromancer without the Necromancer free spells and forced patron. More spellpoints, otherwise mostly the same.
/datum/advclass/wretch/hedgemage
	name = "野法师"
	tutorial = "他们否定你的天才，他们将你逐出，他们指责你不讲伦理。他们根本不懂你必须付出怎样的牺牲。可这已经无所谓了，除了那些宫廷大法师之外，你的力量早已凌驾于那群蠢货之上。让他们见识真正的魔法吧。至于我为什么戴着眼罩？"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/hedgemage
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	// Same stat spread as necromancer, same reasoning
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_spellpoints = 27 // Unlike Rogue Mage, who gets 6 but DExpert, this one don't have DExpert but have more spell points than anyone but the CM.
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
	)

// Hedge Mage on purpose has nearly the same fit as a Adv Mage / Mage Associate who cast conjure armor roundstart. Call it meta disguise.
/datum/outfit/job/roguetown/wretch/hedgemage/pre_equip(mob/living/carbon/human/H)
	mask = /obj/item/clothing/mask/rogue/eyepatch // Chuunibyou up to 11.
	head = /obj/item/clothing/head/roguetown/roguehood/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	gloves = /obj/item/clothing/gloves/roguetown/angle
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/clothing/neck/roguetown/leather // No iron gorget vs necro. They will have to acquire one in round.
	beltl = /obj/item/storage/magebag
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/chalk = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_MASTER, TRUE)
		H.mind?.adjust_spellpoints(6)
	if(H.mind)
		wretch_select_bounty(H)

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
