/datum/advclass/seamstress
	name = "裁缝"
	tutorial = "你熟知这门手艺，一针既能穿过布匹，也能穿透皮革。为镇民缝补、裁制衣裳吧，外套、裤子、帽子、兜帽，还有更多。收贵一点又怎样？反正大家能穿得体面，全靠你。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/seamstress
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	traits_applied = list(TRAIT_SEWING_EXPERT,TRAIT_DYES)
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/seamstress/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/suit/roguetown/armor/armordress
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/needle
	beltr = /obj/item/rogueweapon/huntingknife/scissors
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/natural/cloth = 2,
						/obj/item/natural/bundle/fibers/full = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/needle/thorn = 1,
						/obj/item/book/rogue/swatchbook = 1,
						)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fittedclothing)

	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 5, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 6, TRUE)
