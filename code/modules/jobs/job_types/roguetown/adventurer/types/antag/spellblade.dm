/datum/advclass/spellblade //mage class - like the adventurer SpellBlade, but more evil.
	name = "SpellBlade"
	tutorial = "As a mage, you learned spells can not cover all area's of your trade."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/spellblade
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	subclass_spellpoints = 18
	category_tags = list(CTAG_BANDIT)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ARCYNE_T3, TRAIT_MAGEARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2, // Adv mage get 2 perception so whatever. It is useful for aiming body parts but have no direct synergy with spells.
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, //needs climbing to get into hideout
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE, // Standards for athletics is 3, give them 2
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/bandit/spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/sword/long
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/book/spellbook = 1, // Spell resetting is a key identity of good mage
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel //idk if this makes it so they cant cast but i want all of the bandits to have the same mask
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	id = /obj/item/mattcoin
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)

/datum/outfit/job/roguetown/bandit/spellblade/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_SPD, 1)
