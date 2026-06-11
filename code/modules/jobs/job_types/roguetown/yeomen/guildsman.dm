// Guildsman. Replacement class for the Blacksmith, Artificer, and Smithy Apprentice.
// But also includes a Mason-Architect.
/datum/job/roguetown/guildsman
	title = "Guildsman"
	display_title = "行会工匠"
	flag = GUILDSMAN
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	advclass_cat_rolls = list(CTAG_GUILDSMEN = 20)
	social_rank = SOCIAL_RANK_YEOMAN
	allowed_races = ACCEPTED_RACES

	tutorial = "你是谷地工匠行会的一员，这是个为代表全镇工匠利益而建立的庞大行会。\
	身为行会工匠，你出身于其中最重要的三大分支：铁匠行会、巧匠行会与建筑师行会。行会长对你有影响力，但并非绝对。"
	job_traits = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)

	outfit = /datum/outfit/job/roguetown/guildsman
	selection_color = JCOLOR_YEOMAN
	display_order = JDO_GUILDSMAN
	give_bank_account = 15
	min_pq = 0
	max_pq = null
	round_contrib_points = 3
	advjob_examine = TRUE // So that everyone know which subjob they have picked
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	job_subclasses = list(
		/datum/advclass/guildsman/artificer,
		/datum/advclass/guildsman/blacksmith,
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/guildsman/blacksmith
	name = "行会铁匠"
	tutorial = "你曾在许多名匠门下苦学多年。无论是锅碗器皿还是战争兵器，在将金属锻造成心中所想这门技艺上，鲜有人能与你比肩。"
	outfit = /datum/outfit/job/roguetown/guildsman/blacksmith

	category_tags = list(CTAG_GUILDSMEN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/smelting = SKILL_LEVEL_MASTER, // Goofy to insist you're worse at smelting than smithing
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE, // 1 Engineering to allow them to sub for Artificer role occaisonally
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/guildsman/blacksmith/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/hatblu
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
	if(should_wear_femme_clothes(H))
		pants = /obj/item/clothing/under/roguetown/trou
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		backr = /obj/item/storage/backpack/rogue/satchel
		backpack_contents = list(
			/obj/item/rogueweapon/hammer/iron = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/recipe_book/blacksmithing = 1,
			)
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		cloak = /obj/item/clothing/cloak/apron/blacksmith
		beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
		beltr = /obj/item/roguekey/crafterguild
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/trou
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
		backr = /obj/item/storage/backpack/rogue/satchel
		backpack_contents = list(
			/obj/item/rogueweapon/hammer/iron = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/recipe_book/blacksmithing = 1,
			/obj/item/mini_flagpole/blacksmith = 1
			)
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
		beltr = /obj/item/roguekey/crafterguild
		cloak = /obj/item/clothing/cloak/apron/blacksmith
	if(SSmapping.current_map.map_name == "Desert Town")
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		head = /obj/item/clothing/head/roguetown/turban/random
		shoes = /obj/item/clothing/shoes/roguetown/sandals

/datum/advclass/guildsman/artificer
	name = "巧匠"
	tutorial = "你是一名巧匠，也常被唤作机关巧匠。你受过基础的锻造训练，必要时足以顶替铁匠的活计。\
	但你真正的使命，是打造奥术机械，同时精通工程、建造与创造的技艺，以缔造机械与魔法交融的奇妙造物——这门手艺的传承，来自某位精灵巧匠……"
	outfit = /datum/outfit/job/roguetown/guildsman/artificer

	category_tags = list(CTAG_GUILDSMEN)
	traits_applied = list(TRAIT_ARCYNE_T1, TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON, TRAIT_HOMESTEAD_EXPERT, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list( // alchemy expert upon request
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_LCK = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, // woodcutting, don't want a wild venard attacking you
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_MASTER, 
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE, // can fill in for a blacksmith 
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_EXPERT, // glass making
	)

/datum/outfit/job/roguetown/guildsman/artificer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/articap
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/pick/steel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	backpack_contents = list(
								/obj/item/rogueweapon/hammer/steel = 1,
								/obj/item/rogueweapon/chisel = 1,
								/obj/item/rogueweapon/handsaw = 1,
								/obj/item/lockpickring/mundane = 1,
								/obj/item/recipe_book/blacksmithing = 1,
								/obj/item/recipe_book/engineering = 1,
								/obj/item/recipe_book/ceramics = 1,
								/obj/item/recipe_book/builder = 1,
								/obj/item/recipe_book/survival = 1,
								/obj/item/contraption/linker = 1,
								/obj/item/mini_flagpole/artificer = 1,
								/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
								/obj/item/mini_flagpole/blacksmith = 1,
								/obj/item/rogueweapon/blowrod = 1,
								/obj/item/dye_brush = 1,
								/obj/item/roguekey/crafterguild = 1,
								/obj/item/rogueweapon/huntingknife = 1,
								/obj/item/flint = 1,
						)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals
	// Not a real mage, no free spell point. Take Arcyne Potential if you want it.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
