/datum/advclass/artificer
	name = "Tinkerer"
	tutorial = "One of the brilliant minds that survived the disaster that befell Heartfelt. Perhaps you weren't able to prevent what happened in your homeland, but with your knowledge and skill, perhaps you can shape what happens from now on in your life as you venture towards a new beginning."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/artificer
	subclass_social_rank = SOCIAL_RANK_YEOMAN // differing from the original decision, I think that a highly experienced artisan should be slightly more respected even in foreign lands
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 4, "locked_aspects" = list(/datum/magic_aspect/artifice), "ward" = FALSE) // No battlewardry
	traits_applied = list(TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON, TRAIT_ENGINEER, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 1,
		STATKEY_STR = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, // Traveling Engineer
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, // They know how to swing a hammer a little bit better
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE, // Allows you to field repair items for people but not that well
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/ceramics = SKILL_LEVEL_EXPERT, // ceramics is a very unforgiving craft, expert is almost always required for even glass panes
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE, // No expert lockpicking
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/artificer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/articap
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	backl = /obj/item/storage/backpack/rogue/artibackpack/engineer // They can have a better backpack as a treat
	backr = /obj/item/rogueweapon/pick/woodcutter/dolabra/iron // You do not get a good one
	backpack_contents = list(
								/obj/item/rogueweapon/hammer/bronze = 1,
								/obj/item/rogueweapon/chisel/bronze = 1,
								/obj/item/rogueweapon/handsaw/bronze = 1,
								/obj/item/recipe_book/survival = 1,
								/obj/item/contraption/linker = 1,
								/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
								/obj/item/rogueweapon/huntingknife/bronze = 1,
								/obj/item/rogueweapon/shovel/bronze/spade = 1,
								/obj/item/flint = 1,
								/obj/item/dye_brush = 1,
								/obj/item/rogueweapon/scabbard/sheath = 1,
								/obj/item/clothing/mask/rogue/spectacles/golden = 1, // people with bad sight had their spectacles overwritten, should prevent this from happening
						)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/architect_plan)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/architect_conjure)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
