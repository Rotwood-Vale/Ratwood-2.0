/datum/advclass/artificer
	name = "Tinkerer"
	tutorial = "One of the brilliant minds that survived the disaster that befell Heartfelt. Perhaps you weren't able to prevent what happened in your homeland, but with your knowledge and skill, perhaps you can shape what happens from now on in your life as you venture towards a new beginning."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/artificer
	subclass_social_rank = SOCIAL_RANK_PEASANT // a migrant is but a peasant in foreign lands, so no yeoman like the normal one
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/towner/combat_towner3.ogg'
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT, TRAIT_ARCYNE_T1) // same as the guildsman variant
	maximum_possible_slots = 5 // We don't need a bunch of nerds running around, five will do, perhaps less, not everyone should be an artificer after all
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	) // removed both the str and per bonus, so it is not the same as the guildsman artificer, being a bit 'nerfed'
	
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, // Different from the guildsman, this one has been travelling.. They need to know how to defend themselves, a bit if only.
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN, // They won't be the best from the start. Got practice for that, buddies.
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE, // Can repair stuff, but it is not a blacksmith. Same as the guildsman variant.
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, // Keeping this as it is, they got climb stuff to build. And fall eventually as they get a moment of 'fog'. Hah.
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN, // Once more, if they wish to be as good as the ones we have, got practice.
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN, // Same as above. Do I need to repeat it? Eh.
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_JOURNEYMAN,	// I.. really won't even touch this, change it at all. Rarely anyone does pottery. Even normal artificers.
	)

/datum/outfit/job/roguetown/adventurer/artificer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/articap
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/steel = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/recipe_book/engineering = 1,
		/obj/item/recipe_book/ceramics = 1,
		/obj/item/recipe_book/builder = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/clothing/mask/rogue/spectacles/golden = 1,
		/obj/item/contraption/linker = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/rogueweapon/handsaw = 1,
	)
	// Always hated the fact that they began using magic for their stuff. Yet it is needed, same as the normal one. Perhaps one day we will change it, and move towards a more steampunk vibe. I pray.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
