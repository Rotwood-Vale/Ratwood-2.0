/datum/job/roguetown/knavewench // The most aggressively rude name yet.
	title = "Tapster"
	display_title = "酒馆伙计"
	f_title = "Tapster"
	flag = KNAVEWENCH
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_races = RACES_ALL_KINDS
	tutorial = "你在谷地酒馆的职责其实很简单，真的。你得端盘跑堂、招呼客人、打扫房间、种些酿酒作物、继续酿出更多酒水，还要在厨房忙不过来时搭把手。多对众人露点笑脸吧，那些抠门的镇民与冒险客说不定会多赏你一枚铜子……前提是他们还没在醉倒后，被你先一步摸走了钱袋。"

	outfit = /datum/outfit/job/roguetown/knavewench
	display_order = JDO_KNAVEWENCH
	give_bank_account = 10
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_TAPSTER = 2)
	job_subclasses = list(
		/datum/advclass/tapster
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/tapster
	name = "酒馆伙计"
	tutorial = "你在谷地酒馆的职责其实很简单，真的。你得端盘跑堂、招呼客人、打扫房间、种些酿酒作物、继续酿出更多酒水，还要在厨房忙不过来时搭把手。多对众人露点笑脸吧，那些抠门的镇民与冒险客说不定会多赏你一枚铜子……前提是他们还没在醉倒后，被你先一步摸走了钱袋。"
	outfit = /datum/outfit/job/roguetown/knavewench/basic
	category_tags = list(CTAG_TAPSTER)
	// 5 points weighted
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/knavewench
	has_loadout = TRUE

/datum/outfit/job/roguetown/knavewench/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/roguekey/tavern
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/apron/waist
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
		pants = /obj/item/clothing/under/roguetown/tights/black
	else if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	backpack_contents = list(
		/obj/item/bottle_kit,
		/obj/item/mini_flagpole/innkeeper,
	)

/datum/outfit/job/roguetown/knavewench/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
