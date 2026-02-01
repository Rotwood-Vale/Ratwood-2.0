//Generic Grenzel mean-merc. But adventurer.
//Big sword. Lack of armour. Tear that guy in half and toss him across the room!!!!
//Before you complain, go look at Battlemaster.
/datum/advclass/foreigner/bluthund
	name = "Grenzelhoft Bluthund"
	tutorial = "Grenzelhoftian mercenaries are one of a kind. \
	In a world of cheats, blaggards and broken oaths? They stand firm. \
	A guild of individuals who, once under contract, will follow it to the letter. \
	For some reason, whether glory or madness, you'd gone against that. Branded an outcast - a 'bluthund'. \
	You yet retain your equipment, for they could not strip that of you. Unlike your titles."
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_STEELHEARTED)
	outfit = /datum/outfit/job/roguetown/adventurer/bluthund
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	subclass_languages = list(/datum/language/grenzelhoftian)
	subclass_stats = list(//7 points total.
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,//Light armour. Get them!!!
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/bluthund/pre_equip(mob/living/carbon/human/H)
	..()
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	r_hand = /obj/item/rogueweapon/greatsword/grenz
	wrists = wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
