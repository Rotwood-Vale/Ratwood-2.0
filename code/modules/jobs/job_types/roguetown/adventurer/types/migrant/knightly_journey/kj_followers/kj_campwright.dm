/datum/advclass/kj_follower/campwright
	name = "Campwright"
	tutorial = "You set up camp wherever your knight stops for the night. With enough logs or stone, you can put up proper walls if they stay a while."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/kj_follower/campwright
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_KJ_FOLLOWER)
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON, TRAIT_LEGENDARY_MINER, TRAIT_OUTLANDER)
	stat_budget = STAT_BUDGET_MID
	favored_stats = list(STATKEY_STR = STAT_VERY_FAVORED, STATKEY_WIL = STAT_VERY_FAVORED, STATKEY_SPD = STAT_DISFAVORED)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,//makin' sacks
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/kj_follower/campwright/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatblu
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	cloak = /obj/item/clothing/cloak/apron/waist/bar
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/pick
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/rogueweapon/hammer/steel = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/flint = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/dye_brush = 1,
						/obj/item/rogueweapon/blowrod = 1,
						/obj/item/bedroll = 3,
						)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 4, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 5, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/architect_plan)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/architect_conjure)

/datum/outfit/job/roguetown/kj_follower/campwright/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(istype(H.belt, /obj/item/storage/belt/rogue/leather))
		if(locate(/obj/item/rogueweapon/scabbard/sheath) in H.belt)
			return
		var/obj/item/rogueweapon/scabbard/sheath/sheath = new(H.belt.loc)
		if(!SEND_SIGNAL(H.belt, COMSIG_TRY_STORAGE_INSERT, sheath, null, TRUE, TRUE))
			sheath.forceMove(get_turf(H))
