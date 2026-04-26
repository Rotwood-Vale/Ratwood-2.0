/*
	UNDERBELLY JOBS
	Criminal faction lurking beneath Rotwood's legitimate society.
	All five jobs share TRAIT_UNDERBELLY_SCUM and the Thieves' Cant language.
	Scum, Flesh Trader, Flinger, and Ripper can opt into the excidium for a stat buff.
	Gutter King is the faction head — max 1, 80 PQ floor, bypasses all shop role restrictions.
*/

// =====================================================
// BASE OUTFIT — grants faction membership to all jobs
// =====================================================
/datum/outfit/job/roguetown/underbelly

/datum/outfit/job/roguetown/underbelly/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		ADD_TRAIT(H, TRAIT_UNDERBELLY_SCUM, "underbelly_job")
		H.grant_language(/datum/language/thievescant)

// =====================================================
// GUTTER KING
// 80 PQ, max 1. Faction head. Medium armour trained.
// Starts with a Gut Spiller. Bypasses all shop role locks.
// =====================================================
/datum/job/roguetown/gutterking
	title = "Gutter King"
	f_title = "Gutter Queen"
	flag = GUTTER_KING
	department_flag = UNDERBELLY
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_UNDERBELLY

	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You built something down here. Not a kingdom - nobody'd call it that. \
	But it runs, it pays, and when you say 'do it', people do it. The Keep above \
	think they own this town. You own what's underneath it. \
	Keep the Scum in line, keep the Flipside from burning you down, and don't get careless."

	outfit = /datum/outfit/job/roguetown/underbelly/gutterking
	obsfuscated_job = TRUE
	antag_job = FALSE
	display_order = JDO_GUTTER_KING
	min_pq = 80
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	advclass_cat_rolls = list(CTAG_UNDERBELLY = 3)
	job_traits = list(TRAIT_MEDIUMARMOR, TRAIT_SEEPRICES)
	job_subclasses = list(
		/datum/advclass/gutterking/kingpin,
		/datum/advclass/gutterking/fixer,
	)
	wanderer_examine = TRUE
	advjob_examine = TRUE
	announce_latejoin = FALSE
	same_job_respawn_delay = 3 MINUTES

/datum/outfit/job/roguetown/underbelly/gutterking

/datum/outfit/job/roguetown/underbelly/gutterking/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		scum_select_criminal_record(H)

// Kingpin - the brawler. Leads by force, not words.
/datum/advclass/gutterking/kingpin
	name = "Kingpin"
	tutorial = "You run the Underbelly the old-fashioned way - you're the biggest, meanest thing in it. \
	Your word is law because your fist is the law. Nobody questions you twice."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/gutterking/kingpin
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/underbelly/gutterking/kingpin/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/powderflask = 1,
		/obj/item/quiver/bullet/lead = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// Fixer - the social predator. Leads by leverage, not force.
/datum/advclass/gutterking/fixer
	name = "Fixer"
	tutorial = "You run the Underbelly through compromise, blackmail, and charm in equal measure. \
	The Keep drinks your wine. The merchants owe you favours. \
	Nobody needs to know you own them until you need them to know."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/gutterking/fixer
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_noble.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/gutterking/fixer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/chaperon/brown
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/clothing/neck/roguetown/horus
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/powderflask = 1,
		/obj/item/quiver/bullet/lead = 1,
		/obj/item/lockpickring/mundane = 1,
	)

// =====================================================
// SCUM
// 55 PQ, max 5. Enforcers, kidnappers, smugglers.
// Medium armour trained. Can opt into criminal record.
// Scrap guns available in the shop, not at spawn.
// =====================================================
/datum/job/roguetown/scum
	title = "Scum"
	flag = UB_SCUM
	department_flag = UNDERBELLY
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = JCOLOR_UNDERBELLY

	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Work for the Underbelly. Break legs, move cargo, disappear people, or keep the locals in line. \
	It doesn't pay well but it pays, and it beats starving above ground. The Gutter King expects results. \
	The kind that don't require explaining."

	outfit = /datum/outfit/job/roguetown/underbelly/scum
	obsfuscated_job = TRUE
	antag_job = FALSE
	display_order = JDO_UB_SCUM
	min_pq = 55
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	advclass_cat_rolls = list(CTAG_UNDERBELLY = 3)
	job_traits = list(TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/scum/enforcer,
		/datum/advclass/scum/kidnapper,
		/datum/advclass/scum/guttersnipe,
	)
	wanderer_examine = TRUE
	advjob_examine = TRUE
	announce_latejoin = FALSE
	same_job_respawn_delay = 2 MINUTES

/datum/outfit/job/roguetown/underbelly/scum

/datum/outfit/job/roguetown/underbelly/scum/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H << sound('modular_underbelly/sound/scummy.ogg')
		scum_select_criminal_record(H)

// Enforcer — the brawler. Hits things until they stop moving.
/datum/advclass/scum/enforcer
	name = "Enforcer"
	tutorial = "Debt collectors don't need to be subtle. They need to be persuasive. You are very persuasive."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/scum/enforcer
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/underbelly/scum/enforcer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/flashlight/flare/torch = 1,
	)

// Kidnapper - fast, quiet, rope in hand.
/datum/advclass/scum/kidnapper
	name = "Kidnapper"
	tutorial = "You don't fight people. You take them somewhere quiet and let the problem sort itself out. \
	Always works."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/scum/kidnapper
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/underbelly/scum/kidnapper/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rope/chain = 2,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// Guttersnipe - knife fighter, opportunist, nasty in a corner.
/datum/advclass/scum/guttersnipe
	name = "Guttersnipe"
	tutorial = "No armour, no plan, no problem. You're fast, you hit once and you disappear. \
	Born in the gutter. Comfortable there."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/scum/guttersnipe
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/underbelly/scum/guttersnipe/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/bomb/smoke = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// =====================================================
// FLESH TRADER
// 65 PQ, max 3. Organ harvesters. Wanted by default.
// Sleep mask and surgery bag. Stub - full mechanic TBD.
// =====================================================
/datum/job/roguetown/fleshtrader
	title = "Flesh Trader"
	flag = UB_FLESH_TRADER
	department_flag = UNDERBELLY
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = JCOLOR_UNDERBELLY

	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Organs fetch a good price if you know who to sell to. Kidneys, spleens, an appendix - nobody misses \
	the small things. Arms and legs pay better, but the paperwork gets complicated. \
	The Trader takes what you bring. The Excidium already wants you. Try not to make it worse."

	outfit = /datum/outfit/job/roguetown/underbelly/fleshtrader
	obsfuscated_job = TRUE
	antag_job = FALSE
	display_order = JDO_FLESH_TRADER_JOB
	min_pq = 65
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_physician.ogg'
	advclass_cat_rolls = list(CTAG_UNDERBELLY = 3)
	job_traits = list(TRAIT_KNOWNCRIMINAL)
	job_subclasses = list(
		/datum/advclass/fleshtrader/harvester,
		/datum/advclass/fleshtrader/corruptor,
	)
	wanderer_examine = TRUE
	advjob_examine = TRUE
	announce_latejoin = FALSE
	same_job_respawn_delay = 2 MINUTES

/datum/outfit/job/roguetown/underbelly/fleshtrader

// Harvester - the hunter. High medicine, predatory approach.
/datum/advclass/fleshtrader/harvester
	name = "Harvester"
	tutorial = "You hunt efficiently. You know exactly which organs to take and how quickly. \
	The mark is down before they know it happened, and you're gone before anyone asks questions."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/fleshtrader/harvester
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_physician.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/fleshtrader/harvester/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/physician
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/flashlight/flare/torch = 1,
	)

// Corruptor — the alchemist. Higher alchemy than medicine.
/datum/advclass/fleshtrader/corruptor
	name = "Corruptor"
	tutorial = "You found that Zizo's Bane makes the harvest considerably easier, and that alchemy \
	opens doors medicine doesn't. Not a surgeon — more of an extractor."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/fleshtrader/corruptor
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_physician.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/fleshtrader/corruptor/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/physician
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// =====================================================
// FLINGER
// 55 PQ, max 2. Businessmen. Special shop access.
// Fence starts richer. Dealer starts with more goods.
// =====================================================
/datum/job/roguetown/flinger
	title = "Flinger"
	flag = UB_FLINGER
	department_flag = UNDERBELLY
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = JCOLOR_UNDERBELLY

	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Coin is the only God worth worshipping, and you've devoted your life to it. \
	You have access to goods nobody Flipside can acquire legally, or easily - and a list of clients who will pay \
	anything not to have their name associated with acquiring them. Keep it quiet. Keep it profitable."

	outfit = /datum/outfit/job/roguetown/underbelly/flinger
	obsfuscated_job = TRUE
	antag_job = FALSE
	display_order = JDO_FLINGER_JOB
	min_pq = 55
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_noble.ogg'
	advclass_cat_rolls = list(CTAG_UNDERBELLY = 3)
	job_traits = list(TRAIT_SEEPRICES)
	job_subclasses = list(
		/datum/advclass/flinger/fence,
		/datum/advclass/flinger/dealer,
	)
	wanderer_examine = TRUE
	advjob_examine = TRUE
	announce_latejoin = FALSE

/datum/outfit/job/roguetown/underbelly/flinger

/datum/outfit/job/roguetown/underbelly/flinger/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		scum_select_criminal_record(H)

// Fence - moves stolen goods. Starts rich, keeps the margin.
/datum/advclass/flinger/fence
	name = "Fence"
	tutorial = "You buy low, sell high, and never ask where it came from. \
	Half the peasantry in this town have bought something from you. That makes them your clients. \
	Careful with the Watch, however. They might want a piece of you."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/flinger/fence
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_noble.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_CICERONE)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/flinger/fence/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/chaperon/brown
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/clothing/neck/roguetown/horus
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich //fence starts rich
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// Dealer - pushes contraband. More goods, less coin.
/datum/advclass/flinger/dealer
	name = "Dealer"
	tutorial = "You move the things polite society pretends don't exist - \
	poisons, powders, and things with no safe use. \
	The coin is good. The risk is also good. You've made peace with that."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/flinger/dealer
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_noble.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_SEEPRICES)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_LCK = 2,
	)
	subclass_skills = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/flinger/dealer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/chaperon/brown
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid //less coin than fence
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list( //more merchandise to start moving
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept = 2,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// =====================================================
// RIPPER
// 70 PQ, max 2. Criminal healers.
// =====================================================
/datum/job/roguetown/ripper
	title = "Ripper"
	flag = UB_RIPPER
	department_flag = UNDERBELLY
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = JCOLOR_UNDERBELLY

	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Medicine for coin. Surgery for more coin. You'll do what the clinic won't - \
	pull a crossbow bolt without asking how it got there, stitch a face closed that shouldn't be \
	walking around, and charge accordingly. \
	The Pestran relics you carry are not strictly legal. That suits everyone just fine."

	outfit = /datum/outfit/job/roguetown/underbelly/ripper
	obsfuscated_job = TRUE
	antag_job = FALSE
	display_order = JDO_RIPPER_JOB
	min_pq = 70
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_physician.ogg'
	advclass_cat_rolls = list(CTAG_UNDERBELLY = 3)
	job_traits = list(TRAIT_MEDICINE_EXPERT)
	job_subclasses = list(
		/datum/advclass/ripper/sawbones,
		/datum/advclass/ripper/chirurgeon,
	)
	wanderer_examine = TRUE
	advjob_examine = TRUE
	announce_latejoin = FALSE

/datum/outfit/job/roguetown/underbelly/ripper

/datum/outfit/job/roguetown/underbelly/ripper/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		scum_select_criminal_record(H)

// Sawbones — rough, fast, pragmatic.
/datum/advclass/ripper/sawbones
	name = "Sawbones"
	tutorial = "You operate quickly, in poor light, with whatever's available. \
	You keep people alive because dead patients don't tip. Usually."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/ripper/sawbones
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_physician.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/ripper/sawbones/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/physician
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/natural/bundle/cloth/bandage/full = 3,
		/obj/item/flashlight/flare/torch = 1,
	)

// Chirurgeon - the precise one. Master medicine, expert knives.
/datum/advclass/ripper/chirurgeon
	name = "Chirurgeon"
	tutorial = "Other Rippers cut fast. You cut right. \
	The Pestran relics that end up in your patients' bodies were placed there on purpose, \
	and to exactly the right depth. Your fee reflects the precision."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/underbelly/ripper/chirurgeon
	category_tags = list(CTAG_UNDERBELLY)
	cmode_music = 'sound/music/combat_physician.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/underbelly/ripper/chirurgeon/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/physician
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich //precision costs more
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

// =====================================================
// EXCIDIUM OPT-IN
// All non-Flesh-Trader underbelly jobs can choose to be
// known criminals for a stat buff, like bandits.
// =====================================================
/proc/scum_select_criminal_record(mob/living/carbon/human/H)
	if(!H.mind)
		return
	var/wanted = input(H, "Are you known to the law?", "EXCIDIUM") as anything in list("Yes, I have a record", "No, I stay in the shadows")
	if(wanted == "No, I stay in the shadows")
		to_chat(H, span_notice("My work has gone unnoticed. I intend to keep it that way."))
		return
	ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, "underbelly_criminal_record")
	var/skillbuff = input(H, "Your experience has sharpened you.", "Choose An Attribute") as anything in list("Strength", "Perception", "Intelligence", "Constitution", "Willpower", "Speed")
	switch(skillbuff)
		if("Strength")
			H.change_stat(STATKEY_STR, 1)
		if("Perception")
			H.change_stat(STATKEY_PER, 1)
		if("Intelligence")
			H.change_stat(STATKEY_INT, 1)
		if("Constitution")
			H.change_stat(STATKEY_CON, 1)
		if("Willpower")
			H.change_stat(STATKEY_WIL, 1)
		if("Speed")
			H.change_stat(STATKEY_SPD, 1)
	to_chat(H, span_bloody("I am known. The law has my name. I've survived it this far."))
