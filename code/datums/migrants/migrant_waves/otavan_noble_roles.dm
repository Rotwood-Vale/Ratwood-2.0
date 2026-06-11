#define CTAG_OTAVAN_ENVOY "otavan_envoy"
#define CTAG_OTAVAN_KNIGHT "otavan_knight"
#define CTAG_OTAVAN_GUARD "otavan_guard"
#define CTAG_OTAVAN_PREACHER "otavan_preacher"
#define CTAG_OTAVAN_SCRIBE "otavan_scribe"

/datum/migrant_role/otavan/envoy
	name = "使节"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	greet_text = "你是来自 Otava 的使节，带着一小队随员与一位 Psydonite 传教士出行，代表自己的祖国。\
	你究竟被派来此地商谈什么，只有你自己知道。"
	advclass_cat_rolls = list(CTAG_OTAVAN_ENVOY = 20)

/datum/advclass/otavan_envoy
	name = "使节"
	outfit = /datum/outfit/job/roguetown/otavan/envoy
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

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_languages = list(
		/datum/language/otavan,
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
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/paper/scroll/writ_of_esteem/otavan = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 2,
		)
	H.cmode_music = 'sound/music/combat_routier.ogg'

/datum/migrant_role/otavan/knight
	name = "骑士"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	advclass_cat_rolls = list(CTAG_OTAVAN_KNIGHT = 20)

/datum/advclass/otavan_knight
	name = "骑士"
	tutorial = "无论是凭借功绩、血统还是名望，你都成为了效力于 Otava 宫廷的骑士。如今你奉命护送使节，不惜一切代价保护其安全，正策马进入谷地。"
	outfit = /datum/outfit/job/roguetown/otavan/knight
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

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_languages = list(
		/datum/language/otavan,
	)

/datum/outfit/job/roguetown/otavan/knight/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
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
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		)
	H.cmode_music = 'sound/music/combat_routier.ogg'

/datum/migrant_role/otavan/guard
	name = "Otava重弩手"
	greet_text = "你目光锐利、身强体壮，是 Otava 亲王国赫赫有名的重弩手之一。用你的剑与弩矢保护使节的安全。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	advclass_cat_rolls = list(CTAG_OTAVAN_GUARD = 20)

/datum/advclass/otavan_guard
	name = "Otava重弩手"		//Modified skirmisher, main focus is crossbow and swords.
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
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

	subclass_languages = list(
		/datum/language/otavan,
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
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

/datum/migrant_role/otavan/preacher
	name = "Psydonite传教士"
	greet_text = "你是 Psydonite 宗教裁判所的一名忠诚成员，长期周旋于政治之中，如今主动协助外交使命，并将祂的圣训带到使节所到之处。帮助他，并确保他不会忽视祂的福音。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_OTAVAN_PREACHER = 20)

/datum/advclass/otavan_preacher
	name = "Psydonite传教士"		//Basically a middle ground between a disciple and an adventurer monk. Staves and preaching!
	outfit = /datum/outfit/job/roguetown/otavan/preacher
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_STEELHEARTED, TRAIT_SILVER_BLESSED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_OTAVAN_PREACHER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
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

	subclass_languages = list(
		/datum/language/otavan,
	)

/datum/outfit/job/roguetown/otavan/preacher/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/old_god)))		//PSYDON ENDURE PURITY AFLOAT PSYDON PSYDON ENDURE PSYDON OTAVA PSYDON WAH WAH WAH
		to_chat(H, span_warning("PSYDON 教会了我不惜一切代价去忍耐，而祂将指引我的双手与言辞。"))
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
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/redwine = 1,	//share some of psydon's body and psydon's blood with your crew. Ask for a knife though.
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WEAK, start_maxed = TRUE) 
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

/datum/migrant_role/otavan/scribe
	name = "Otava书记官"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	greet_text = "钱币、羽笔与文字，自你年幼时起便定义了你的人生。如今？你已是这支外交使团中使节麾下声名在外的书记官。做记录、提问题，并在被要求时拨付资金。"
	advclass_cat_rolls = list(CTAG_OTAVAN_SCRIBE = 20)

/datum/advclass/otavan_scribe
	name = "Otava书记官"
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
		/datum/skill/misc/riding= SKILL_LEVEL_EXPERT,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding,
	)

	subclass_languages = list(
		/datum/language/otavan,
	)

/datum/outfit/job/roguetown/otavan/scribe/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/spectacles
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/half
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	id = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
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
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,		//you are the piggybank and the dude taking notes.
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		)
	H.cmode_music = 'sound/music/combat_routier.ogg'
	H.grant_language(/datum/language/otavan)

#undef CTAG_OTAVAN_ENVOY
#undef CTAG_OTAVAN_KNIGHT
#undef CTAG_OTAVAN_GUARD
#undef CTAG_OTAVAN_PREACHER
#undef CTAG_OTAVAN_SCRIBE
