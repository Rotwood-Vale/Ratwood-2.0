#define CRIER_ANNOUNCEMENT_COOLDOWN (10 MINUTES)//He has access to free SCOM he should be using this

/datum/job/roguetown/crier
	title = "Town Crier"
	display_title = "镇报官"
	tutorial = "你是号角的执掌者、传声线的主人，也是自封的理性之声。坐在 SCOM传讯网 工坊的案前，你决定哪些话语会轰鸣着传遍全境，哪些则会因请愿人没交够鼠粮而烂死在喉咙里。楼上的播报间里，你主持辩论、传述流言、编织故事，让余波荡遍镇上每个角落。人人都把耳朵朝向你，所以，谨言吧。"
	flag = CRIER
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	allowed_races = ALL_RACES_TYPES
	allowed_ages = ALL_AGES_LIST
	social_rank = SOCIAL_RANK_YEOMAN
	outfit = /datum/outfit/job/roguetown/loudmouth
	display_order = JDO_CRIER
	give_bank_account = 15
	min_pq = 3 // Has actual responsibility and is a key figure in town.
	max_pq = null
	round_contrib_points = 3

	job_traits = list(TRAIT_INTELLECTUAL, TRAIT_ARCYNE_T1, TRAIT_MAGEARMOR, TRAIT_SEEPRICES_SHITTY, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_TOWNCRIER = 2)
	job_subclasses = list(
		/datum/advclass/towncrier
	)

/datum/advclass/towncrier
	name = "镇报官"
	tutorial = "你是号角的执掌者、传声线的主人，也是自封的理性之声。\
	坐在 SCOM传讯网 工坊的案前，你决定哪些话语会轰鸣着传遍全境，哪些则会因请愿人没交够鼠粮而烂死在喉咙里。\
	楼上的播报间里，你主持辩论、传述流言、编织故事，让余波荡遍镇上每个角落。人人都把耳朵朝向你，所以，谨言吧。"
	outfit = /datum/outfit/job/roguetown/loudmouth/basic
	subclass_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/orcish,
		/datum/language/grenzelhoftian,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/hammerholdian,
		/datum/language/kazengunese,
		/datum/language/draconic,
		/datum/language/aavnic, // All but beast, which is associated with werewolves.
	)
	category_tags = list(CTAG_TOWNCRIER)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_INT = 3,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/loudmouth/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(should_wear_femme_clothes(H))
		pants = /obj/item/legwears/black
	else
		pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	head = /obj/item/clothing/head/roguetown/veiled/loudmouth
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/roguekey/crier
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone
	backpack_contents = list(
		/obj/item/recipe_book/alchemy,
		/obj/item/barometer,
	)
	if (H && H.mind)
		H.mind.adjust_spellpoints(6)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)

/mob/living/carbon/human/proc/crier_announcement()
	set name = "公告播报"
	set category = "镇报官"
	if(stat)
		return
	var/announcementinput = input("向群峰高声宣告", "发布公告") as text|null
	if(announcementinput)
		if(!src.can_speak_vocal())
			to_chat(src,span_warning("我发不出声音！"))
			return FALSE
		if(!istype(get_area(src), /area/rogue/outdoors/town))//Go touch grass
			to_chat(src, span_warning("我只能在镇区范围内发言。"))
			return FALSE
		if(!COOLDOWN_FINISHED(src, crier_announcement))
			to_chat(src, span_warning("我得等一会儿才能再次发言。"))
			return FALSE
		visible_message(span_warning("[src] 深吸一口气，准备发布公告……"))
		if(do_after(src, 15 SECONDS, target = src)) // Reduced to 15 seconds from 30 on the original Herald PR. 15 is well enough time for sm1 to shove you.
			say(announcementinput)
			priority_announce("[announcementinput]", "镇报官宣告", 'sound/misc/bell.ogg', sender = src)
			COOLDOWN_START(src, crier_announcement, CRIER_ANNOUNCEMENT_COOLDOWN)
		else
			to_chat(src, span_warning("我的公告被打断了！"))
			return FALSE
