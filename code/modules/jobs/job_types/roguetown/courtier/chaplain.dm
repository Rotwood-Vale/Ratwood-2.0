#define COURTCHAPLAIN_PATRONS list(/datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/malum, /datum/patron/divine/eora)

/obj/item/storage/keyring/chaplain
	keys = list(/obj/item/roguekey/church, /obj/item/roguekey/graveyard,  /obj/item/roguekey/manor)

/datum/job/roguetown/chaplain
	title = "Court Chaplain"
	flag = CHAPLAIN
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_patrons = COURTCHAPLAIN_PATRONS
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/chaplain
	tutorial = "The time most acolytes put towards the ways of magic and miracle, you spent studying history and building connections. Liasing between church and court, you are an advisor and diplomat on spiritual matters. Your task is to negotiate, mediate and advise the court against unpious decisions. \
	Some call you a scheming manipulator, a spy on the other church's behalf. Others suspect the Duke may come to prefer your sweet whispers to the Bishop's. Perhaps you are simply drawn to the safety and luxury of court-living."
	display_order = JDO_CHAPLAIN
	give_bank_account = TRUE
	min_pq = 5
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	virtue_restrictions = list(/datum/virtue/utility/noble)//Hmm. I duno, they're PRETTY noble-like.
	job_traits = list(TRAIT_EMPATH)//no homestead expert because we want them doing intrigue intead of gardening?
	advclass_cat_rolls = list(CTAG_CHAPLAIN = 2)
	job_subclasses = list(
		/datum/advclass/chaplain
	)

/datum/advclass/chaplain
	name = "Court Chaplain"
	tutorial = "The time most acolytes put towards the ways of magic and miracle, you spent studying history and building connections. Liasing between church and court, you are an advisor and diplomat on spiritual matters. Your task is to negotiate, mediate and advise the court against unpious decisions. \
	Some call you a scheming manipulator, a spy on the other church's behalf. Others suspect the Duke may come to prefer your sweet whispers to the Bishop's. Perhaps you are simply drawn to the safety and luxury of court-living."
	outfit = /datum/outfit/job/roguetown/chaplain
	subclass_languages = list(/datum/language/grenzelhoftian)
	category_tags = list(CTAG_CHAPLAIN)
	subclass_stats = list(
		STATKEY_INT = 2,//court knowledge
		STATKEY_WIL = 2,
		STATKEY_PER = 2,//eye for intrigue
		STATKEY_CON = -1,//scrawny pencil-pusher
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,//fancy lad school
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)

/datum/outfit/job/roguetown/chaplain
	name = "Court Chaplain"
	jobtype = /datum/job/roguetown/chaplain
	has_loadout = TRUE
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/chaplain/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid//court money
	beltl = /obj/item/storage/keyring/chaplain
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff
	// backpack_contents = list(/obj/item/ritechalk)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	H.cmode_music = 'sound/music/cmode/church/combat_acolyte.ogg' // has to be defined here for the selection below to work. sm1 please rewrite cmusic to apply pre-equip.
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			mask = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			mask = /obj/item/clothing/head/roguetown/nochood
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
			wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		if(/datum/patron/divine/abyssor) // the deep calls!
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			pants = /obj/item/clothing/under/roguetown/tights
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
			mask = /obj/item/clothing/head/roguetown/roguehood/abyssor
		if(/datum/patron/divine/dendor) //Garden Hermit
			mask = /obj/item/clothing/head/roguetown/dendormask
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			mask = /obj/item/clothing/head/roguetown/necrahood
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			shoes = /obj/item/clothing/shoes/roguetown/boots
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/necra
			shirt = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
			backr = /obj/item/rogueweapon/shovel//Meant for morticians, but since we don't have those...
			backpack_contents = list(/obj/item/flashlight/flare/torch/lantern = 1, /obj/item/natural/bundle/stick = 1, /obj/item/necra_censer = 1)
		// if(/datum/patron/divine/pestra)
		// 	neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		// 	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
		// 	head = /obj/item/clothing/head/roguetown/roguehood/phys
		// 	shoes = /obj/item/clothing/shoes/roguetown/boots
		// 	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
		// 	cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora)
			mask = /obj/item/clothing/head/roguetown/eoramask
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			cloak = /obj/item/clothing/cloak/templar/eoran
		if(/datum/patron/divine/malum)
			mask = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
			shoes = /obj/item/clothing/shoes/roguetown/boots
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			pants = /obj/item/clothing/under/roguetown/trou
			cloak = /obj/item/clothing/cloak/templar/malumite
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		if(/datum/patron/divine/ravox)
			mask = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/boots
			armor = /obj/item/clothing/suit/roguetown/shirt/robe
			backpack_contents = list(/obj/item/book/rogue/law)
		// if(/datum/patron/divine/xylix)
		// 	head = /obj/item/clothing/head/roguetown/roguehood
		// 	neck = /obj/item/clothing/neck/roguetown/psicross/xylix // no more good luck charm,  you wanna cheat gambling? Xylix weeps
		// 	cloak = /obj/item/clothing/cloak/templar/xylixian
		// 	wrists = /obj/item/clothing/wrists/roguetown/wrappings
		// 	shoes = /obj/item/clothing/shoes/roguetown/sandals
		// 	armor = /obj/item/clothing/suit/roguetown/shirt/robe
		// 	H.cmode_music = 'sound/music/combat_jester.ogg'
		// 	var/datum/inspiration/I = new /datum/inspiration(H)
		// 	I.grant_inspiration(H, bard_tier = BARD_T2)
		else
			mask = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)

/datum/outfit/job/roguetown/chaplain/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/astrata) // Light and Guidance - Like ravox, they probably can endure seeing some shit.
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		r_hand = /obj/item/storage/belt/rogue/pouch/coins/mid//Astrata blesses you with lots of funding
	if(H.patron?.type == /datum/patron/divine/noc) // Arcyne and Knowledge - Probably good at reading and the other arcyne adjacent stuff. - Might step on the toes of the Court Magician?
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE) // for their arcane spells, very little CDR and cast speed.
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC) // So that they can take arcyne potential and not break.
	if(H.patron?.type == /datum/patron/divine/abyssor) // The Sea and Weather - probably would be good at fishing - I'm not... REALLY sure what they'd be whispering into the duke's ear about. Other than some cthuluisms
		H.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/dendor) // Beauty and Love - beautiful and can read people pretty well.
		ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_WOODWALKER, TRAIT_GENERIC)
		H.adjust_skillrank_up_to(/datum/skill/labor/farming, 3, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, 2, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/necra) // Death and Moving on - grave diggers.
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)//For the stave. Beat back the dead. +1 from base, like Ravox.
		H.adjust_skillrank_up_to(/datum/skill/combat/maces, 2, TRUE)//Or the shovel, I guess... loser...
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	// if(H.patron?.type == /datum/patron/divine/pestra) //that's what the court physician is for!
	// 	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE)
	// 	H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		// ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora) // Beauty and Love - beautiful and can read people pretty well.
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/malum) // Craft and Creativity - they can make stuff. - I guess they can... advise public works?
		ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox) // Justice and Honor - athletics and probably a bit better at handling the horrors of war
		H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE) //Who even plays Ravoxian acolyte? Whatever, this isn't a huge buff.
		H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE) //Who even plays Ravoxian acolyte? Whatever, this isn't a huge buff.
		H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 3, TRUE) //Who even plays Ravoxian acolyte? Whatever, this isn't a huge buff.
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE) //On par with an Adventuring Monk. Seems quite fitting.
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	// if(H.patron?.type == /datum/patron/divine/xylix)  // Maybe that's what the Jester is for!
	// 	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	// 	H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
	// 	H.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
