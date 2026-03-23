//Psydonic-exclusive 1-slot gunslinger. Gets to a gun of choice, a special item to summon disposable one-use pistols, and can choose two relics.
//Mediocre statblock and poor skills, so reliant on their weapon and relics to get anything done.
/datum/advclass/wretch/renegade
	name = "Renegade Inquisitor"
	tutorial = "Once a respected puritan of the Otavan Orthodoxy, lacking in faith or having found your own way to serve HIM, you have left your sect behind. \
	But it's not for desertion alone those who you once served seek to put you to death. Before you left, you took a rare firearm and several valuable relics as parting gifts. \
	Now, driven by newfound zealotry, greed, vengeance or desire for justice, you right wrongs, one bullet at a time."
	allowed_races = RACES_NO_CONSTRUCT //Same as Inquisitor's.
	outfit = /datum/outfit/job/roguetown/wretch/renegade
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/inquisitorcombat.ogg'
	class_select_category = CLASS_CAT_RANGER
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_BLACKBAGGER, TRAIT_FUSILIER, TRAIT_ZOMBIE_IMMUNE, TRAIT_DODGEEXPERT)
	maximum_possible_slots = 1 //Snowflake class with guns and some unusual items.
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 2
	) //+9 weighted stat total.
	subclass_skills = list(
		/datum/skill/combat/firearms = SKILL_LEVEL_LEGENDARY, // The real difference between MASTER and LEGENDARY in Firearms is negligible, but it's flavourful.
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN, // Back-up if you lose your primary gun.
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, // You can fight upclose, but your stats aren't well-suited for it.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wretch/renegade/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/inqhat
//	mask = /obj/item/clothing/mask/rogue/rorschach
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/renegade
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
