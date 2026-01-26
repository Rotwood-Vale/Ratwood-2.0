#define CTAG_OTAVAN_ENVOY "otavan_envoy"
#define CTAG_OTAVAN_KNIGHT "otavan_knight"
#define CTAG_OTAVAN_GUARD "otavan_guard"
#define CTAG_OTAVAN_PREACHER "otavan_preacher"
#define CTAG_OTAVAN_SCRIBE "otavan_scribe"

/datum/migrant_role/otavan/envoy
	name = "Émissaire"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	greet_text = "You are an Otavan Emissary, traveling with a small retinue and a Psydonite preacher to represent your homeland.\
	 What exactly you have been sent here to speak about- only you know."
	advclass_cat_rolls = list(CTAG_OTAVAN_ENVOY = 20)

/datum/advclass/otavan_envoy
	name = "Émissaire"
	outfit = /datum/outfit/job/roguetown/otavan/envoy
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled		//look at my horse, my horse is amazing
	traits_applied = list(TRAIT_NOBLE, TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_OTAVAN_ENVOY)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1,		//You're not really fight-y. Get behind your knight, punk. Expert swords bc you probably danced a lot with it but otherwise you suck.
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords= SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding= SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/otavan/envoy/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/stabard/surcoat/bailiff
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	id = /obj/item/clothing/ring/silver
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	l_hand = /obj/item/rogueweapon/sword/sabre
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/paper/scroll/writ_of_esteem/otavan = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 2,
		)
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

/datum/migrant_role/otavan/knight
	name = "Gendarme"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	advclass_cat_rolls = list(CTAG_OTAVAN_KNIGHT = 20)

/datum/advclass/otavan_knight
	name = "Gendarme"
	tutorial = "Whether through merit, blood or renown, you became a knight in service of the Otavan court. Now, tasked with escorting the Émissaire and protecting them at all cost, you ride into the Vale."
	outfit = /datum/outfit/job/roguetown/otavan/knight
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled		//look at my horse, my horse is amazing
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_NOBLE, TRAIT_OUTLANDER)
	category_tags = list(CTAG_OTAVAN_KNIGHT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms= SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics= SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding= SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/otavan/knight/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/scabbard/sword
	neck = /obj/item/clothing/neck/roguetown/fencerguard
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	head = /obj/item/clothing/head/roguetown/helmet/otavan
	armor = /obj/item/clothing/suit/roguetown/armor/plate/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	r_hand = /obj/item/rogueweapon/spear/otava
	l_hand = /obj/item/rogueweapon/sword/short/falchion
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

/datum/migrant_role/otavan/guard
	name = "Otavan Arbalétrier"
	greet_text = "With sharp eyes and a strong body, you are one of the many famous Heavy Crossbowmen that fill the ranks of the Otavan Principality. Keep the Emmisary safe, with sword and bolts."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	advclass_cat_rolls = list(CTAG_OTAVAN_GUARD = 20)

/datum/advclass/otavan_guard
	name = "Otavan Arbalétrier"		//Modified skirmisher, main focus is crossbow and swords.
	outfit = /datum/outfit/job/roguetown/otavan/guard
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_OTAVAN_GUARD)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/otavan/guard/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	cloak = /obj/item/clothing/cloak/stabard/surcoat
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/bolts
	beltl = /obj/item/rogueweapon/scabbard/sword
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	l_hand = /obj/item/rogueweapon/sword
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

/datum/migrant_role/otavan/preacher
	name = "Psydonite Preacher"
	greet_text = "A loyal member of the Psydonite Inquisition, you have mingled with politics long enough to become an active volunteer in assisting diplomatic missions and providing His sermon to wherever the Émissaire goes. Aid him, and make sure that he does not ignore His gospel."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_OTAVAN_PREACHER = 20)

/datum/advclass/otavan_preacher
	name = "Psydonite Preacher"		//Basically a middle ground between a disciple and an adventurer monk. Staves and preaching!
	outfit = /datum/outfit/job/roguetown/otavan/preacher
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_STEELHEARTED, TRAIT_SILVER_BLESSED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_OTAVAN_PREACHER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,		//everybody was kung-fu fighting. Jman bc you're defending yourself, punk. Roleplay.
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,		//no powergaming. Staves or bust.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/otavan/preacher/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/old_god)))		//PSYDON ENDURE PURITY AFLOAT PSYDON PSYDON ENDURE PSYDON OTAVA PSYDON WAH WAH WAH
		to_chat(H, span_warning("PSYDON has taught me to ENDURE whatever it takes - and HE guides my hand and words."))
		H.set_patron(/datum/patron/old_god)
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	mask = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	beltl = /obj/item/book/rogue/bibble/psy
	beltr = /obj/item/flashlight/flare/torch/lantern
	cloak = /obj/item/clothing/cloak/psydontabard/alt
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/redwine = 1,	//share some of psydon's body and psydon's blood with your crew. Ask for a knife though.
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WEAK, start_maxed = TRUE) 
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

/datum/migrant_role/otavan/scribe
	name = "Otavan Scribe"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	greet_text = "Coin, quill, and words, these have defined your life since you were a mere youngling. Now? You are the renowned Scribe to this diplomatic mission's Emissary. Take notes, ask questions, and give funds when asked."
	advclass_cat_rolls = list(CTAG_OTAVAN_SCRIBE = 20)

/datum/advclass/otavan_scribe
	name = "Otavan Scribe"
	outfit = /datum/outfit/job/roguetown/otavan/scribe
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_CICERONE, TRAIT_INTELLECTUAL, TRAIT_OUTLANDER)	//booksmart, moneysmart, winesmart
	category_tags = list(CTAG_OTAVAN_SCRIBE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_CON = -1,		//You are DEFINITELY not a fighting role.
		STATKEY_STR = -2,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed= SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding= SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/otavan/scribe/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/spectacles
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/half
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	id = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	r_hand = /obj/item/rogueweapon/huntingknife/idagger
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 4,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,		//you are the piggybank and the dude taking notes.
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		)
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

#undef CTAG_OTAVAN_ENVOY
#undef CTAG_OTAVAN_KNIGHT
#undef CTAG_OTAVAN_GUARD
#undef CTAG_OTAVAN_PREACHER
#undef CTAG_OTAVAN_SCRIBE
