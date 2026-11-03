/datum/job/roguetown/guildassociate
	title = "Guild Associate"
	flag = GUILDASSOCIATE
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	advclass_cat_rolls = list(CTAG_GUILDASSOCIATE = 20)
	social_rank = SOCIAL_RANK_YEOMAN
	allowed_races = ACCEPTED_RACES

	tutorial = "You are a member of the Duchy's Guild of Crafts, a massive guild formed to represent the interests of all craftsmen in the township.\
As a guild associate, you hail from a lesser guild or aid the guild in their work. The Guildsmaster has sway over you, but it is not absolute."

	outfit = /datum/outfit/job/roguetown/guildassociate
	selection_color = JCOLOR_YEOMAN
	display_order = JDO_GUILDASSOCIATE
	give_bank_account = 15
	min_pq = 0
	max_pq = null
	round_contrib_points = 3
	advjob_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	job_subclasses = list(
		/datum/advclass/guildassociate/architect,
		/datum/advclass/guildassociate/miner,
		/datum/advclass/guildassociate/journeymanengineer,
		/datum/advclass/guildassociate/journeymansmith,
	)
		

/datum/advclass/guildassociate/architect
	name = "Guild Architect"
	tutorial = "You are a Guild Architect, a master of the art of building and construction. You build castles, fortifications and entire cities with your own hands. And you know how to source those materials yourself too.\
When there is no construction work around, your fellow Guildsmen appreciate your help with gathering materials."
	outfit = /datum/outfit/job/roguetown/guildassociate/architect

	category_tags = list(CTAG_GUILDASSOCIATE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_LEGENDARY_MINER, TRAIT_MASTER_MASON, TRAIT_MASTER_CARPENTER)
	maximum_possible_slots = 20
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_LCK = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_MASTER,
		/datum/skill/craft/carpentry = SKILL_LEVEL_MASTER,
		/datum/skill/craft/masonry = SKILL_LEVEL_MASTER,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_EXPERT,
	)
/datum/outfit/job/roguetown/guildassociate/architect/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatblu
	cloak = /obj/item/clothing/cloak/apron/waist/bar
	id = /obj/item/scomstone/bad
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/rogueweapon/pick/woodcutter/dolabra/albranze // general engineer/architects multitool
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/rogueweapon/hammer/iron = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/flint = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/recipe_book/engineering = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/roguekey/crafterguild = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/clothing/mask/rogue/spectacles/golden = 1, //allows them to see integrity of structures
					)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/architect_plan)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/architect_conjure)

/datum/advclass/guildassociate/miner
	name = "Guild Laborer"
	tutorial = "You are a Guild Laborer, a master of the art of mining and resource extraction. You know how to find the best resource locations and how to gather them safely.\
Your fellow Guildsmen appreciate your help with gathering materials."
	outfit = /datum/outfit/job/roguetown/guildassociate/miner

	category_tags = list(CTAG_GUILDASSOCIATE)
	traits_applied = list(TRAIT_LEGENDARY_MINER, TRAIT_SMITHING_EXPERT, TRAIT_DARKVISION, TRAIT_MEDIUMARMOR)
	maximum_possible_slots = 20
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_LCK = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_MASTER,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE, // crafting carts
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE, // crafting bags
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, //you can swim in cave water slightly
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // climbing up and down mineshafts
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE, // reading maps and sign
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, // you're trained to treat your injuries slightly better
	)

/datum/outfit/job/roguetown/guildassociate/labourer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	cloak = /obj/item/clothing/cloak/apron/waist/bar
	id = /obj/item/scomstone/bad
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/detpack
	backr = /obj/item/rogueweapon/pick/woodcutter/dolabra/albranze // guild issued standard multitool for anyone
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/rogueweapon/huntingknife/bronze = 1,
						/obj/item/rogueweapon/shovel/bronze/spade = 1,
						/obj/item/rogueweapon/hammer/bronze = 1,
						/obj/item/rogueweapon/chisel/bronze = 1,
						/obj/item/rogueweapon/handsaw/bronze = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
						/obj/item/storage/hip/orestore/bronze = 1
						)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight)


/datum/advclass/guildassociate/journeymanengineer
	name = "Journeyman Engineer"
	tutorial = "You are a Journeyman Engineer. Once either an architect or an artificer, you are now training under a Guild Engineer to become a fully-fledged engineer.\
While not as trained as your brethren, you are more than capable of doing the worked asked of you."
	outfit = /datum/outfit/job/roguetown/guildassociate/journeymanengineer
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3, "locked_aspects" = list(/datum/magic_aspect/artifice))

	
	category_tags = list(CTAG_GUILDASSOCIATE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON, TRAIT_ENGINEER, TRAIT_ARCYNE)
	maximum_possible_slots = 20
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/guildassociate/journeymanengineer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/articap
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	id = /obj/item/scomstone/bad
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/roguekey/crafterguild
	beltl = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	backl = /obj/item/storage/backpack/rogue/artibackpack/engineer
	backr = /obj/item/rogueweapon/pick/woodcutter/dolabra/albranze
	backpack_contents = list(
							/obj/item/rogueweapon/hammer/bronze = 1,
							/obj/item/rogueweapon/chisel/bronze = 1,
							/obj/item/rogueweapon/handsaw/bronze = 1,
							/obj/item/contraption/linker = 1,
							/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
							/obj/item/rogueweapon/blowrod = 1,
							/obj/item/rogueweapon/huntingknife/bronze = 1,
							/obj/item/rogueweapon/shovel/bronze/spade = 1,
							/obj/item/flint = 1,
							/obj/item/dye_brush = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1,
							/obj/item/clothing/mask/rogue/spectacles/golden = 1,
							/obj/item/recipe_book/engineering = 1,
							/obj/item/recipe_book/builder = 1,
						)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/architect_plan)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/architect_conjure)

/datum/advclass/guildassociate/journeymansmith
	name = "Journeyman Smith"
	tutorial = "You are a Journeyman Smith. Once an ordinary person, you are now training under a Guild Smith to become a fully-fledged smith."
	outfit = /datum/outfit/job/roguetown/guildassociate/journeymansmith
	
	
	category_tags = list(CTAG_GUILDASSOCIATE)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT)
	maximum_possible_slots = 20
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)
/datum/outfit/job/roguetown/guildassociate/journeymansmith/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	id = /obj/item/scomstone/bad
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/roguekey/crafterguild
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
			/obj/item/rogueweapon/hammer/iron = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/recipe_book/blacksmithing = 1,
			/obj/item/mini_flagpole/blacksmith = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
