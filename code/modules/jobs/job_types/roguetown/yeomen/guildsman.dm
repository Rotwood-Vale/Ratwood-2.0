// Guildsman. Replacement class for the Blacksmith, Artificer.
// But also includes a Mason-Architect.
/datum/job/roguetown/guildsman
	title = "Guildsman"
	flag = GUILDSMAN
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	advclass_cat_rolls = list(CTAG_GUILDSMEN = 20)
	social_rank = SOCIAL_RANK_YEOMAN
	allowed_races = ACCEPTED_RACES

	tutorial = "You are a member of the Duchy's Guild of Crafts, a massive guild formed to represent the interests of all craftsmen in the township.\
	As a Guildsman, you hail from the three most important constituent guilds: The Smith's Guild, the Artificer's Guild, and the Architect's Guild. The Guildsmaster has sway over you, but it is not absolute."
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
	name = "Guild Blacksmith"
	tutorial = "You've studied for many yils under quite a number of master smiths. Whether it's cookware or tools of war, you're unmatched at the art of bending metal to your will."
	outfit = /datum/outfit/job/roguetown/guildsman/blacksmith

	category_tags = list(CTAG_GUILDSMEN)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 2,
		STATKEY_LCK = 1 // general skillbuff to bring them in line with the architech
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
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE, // 2 engineering as most engineering crafts were increased in skill
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
	name = "Guild Engineer"
	tutorial = "You are an engineer, Once trained under architects and artificers you now have the experience to surpass them both. \
	Your calling is the works of artificing and architecture, be it smithing, constructing or the arcane machinery you do it all, your experience demands respect."
	outfit = /datum/outfit/job/roguetown/guildsman/artificer

	category_tags = list(CTAG_GUILDSMEN)
	traits_applied = list(TRAIT_ARCYNE_T1, TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON, TRAIT_HOMESTEAD_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_FUSILIER)
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
		/datum/skill/combat/firearms = SKILL_LEVEL_JOURNEYMAN, // this will allow an architech to use a portable bombard
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_MASTER,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN, // can fill in for a blacksmith but can now actually repair equipment if needed
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, // AP gave them apprentice to allow for grinding since bombs need alchemy skill to get the ingredients
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
