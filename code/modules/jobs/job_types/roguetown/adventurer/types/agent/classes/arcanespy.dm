/datum/advclass/agent/arcane
	name = "Arcane Spy"
	tutorial = "You were a past student of the magic guild, studying the arcane arts underneath a watchful eye.. But soon you realised how tedious and boring the lyfe of a guild associate is.. The tedious scroll making, creature summoning and constant scribing of enchantments were enough to drive you away from the guild.. Now picking up a more thrilling job underneath the hand, using what you've learnt to your advantage to fulfill the will of the court underneath the shadow of the night.."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/agent/arcane
	class_select_category = CLASS_CAT_FERENTIA
	category_tags = list(CTAG_COURTAGENT)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_ARCYNE, TRAIT_LIGHT_STEP, TRAIT_MAGEDEXTERITY)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_languages = list(/datum/language/thievescant)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_STR = -1,
		STAT_CONSTITUTION = -2,
		STATKEY_WIL = 1
	)

	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_EXP_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_EXP_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	
/datum/outfit/job/roguetown/agent/arcane/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/white
	neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/white
	backr = /obj/item/storage/backpack/rogue/satchel/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/white
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/spellbook = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/speaker/agent = 1,
					/obj/item/listeningdevice/agent = 2,
					/obj/item/roguekey/courtagent = 1,
				)

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/aetherknife)
		H.mind.AddSpell(new /datum/action/cooldown/spell/lesser_knock)
		H.mind.AddSpell(new /datum/action/cooldown/spell/phantom_ear)

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood/white
	color = CLOTHING_WHITE
/obj/item/storage/belt/rogue/leather/battleskirt/faulds/white
	color = CLOTHING_WHITE
/obj/item/clothing/suit/roguetown/armor/longcoat/white
	color = CLOTHING_WHITE
