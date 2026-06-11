/datum/job/roguetown/marshal // A somewhat ham-fisted merge between bailiff and the old town sheriff role. The latter was built like a modern day officer, but we medieval in this bitch!
	title = "Marshal"
	display_title = "执法官"
	flag = MARSHAL
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_TOLERATED_UP
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	display_order = JDO_MARSHAL
	tutorial = "你是王权在法律与军务上的代理人，负责确保法令得以制定、核准，并由侍从与卫队贯彻到这片土地的臣民身上。 \
				尽管你统辖骑士与披甲兵，但你大量的工作都在案牍之后进行，并交由军士长或骑士队长在前线替你贯彻意志。"
	whitelist_req = FALSE

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/guard) // /obj/effect/proc_holder/spell/self/convertrole/bog
	outfit = /datum/outfit/job/roguetown/marshal

	give_bank_account = 40
	noble_income = 20
	min_pq = 8
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_knight.ogg'
	advclass_cat_rolls = list (CTAG_MARSHAL = 20)
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_PERFECT_TRACKER)
	job_subclasses = list(
		/datum/advclass/marshal/classic,
		/datum/advclass/marshal/kcommander
	)

/datum/outfit/job/roguetown/marshal
	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON	//Same as Captain, you get decent combat stats so might as well be garrison.

/datum/outfit/job/roguetown/marshal/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	backl = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	id = /obj/item/scomstone/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/living/carbon/human/proc/request_law, /mob/living/carbon/human/proc/request_law_removal, /mob/living/carbon/human/proc/request_purge)

/datum/advclass/marshal/classic
	name = "执法官"	//One focused on crossbows and maces. And knives. Just in case.
	tutorial = "你多年周旋于城中的法庭与驻军之间，将法典从头到尾翻得滚瓜烂熟，并以正义的铁腕和手中的铁锤贯彻自己的裁断。蹲过地牢的人远比那位骑士统领亲手押进去的还多，而王国上下每个人都敬畏你在法纪与秩序上的权威。"
	outfit = /datum/outfit/job/roguetown/marshal/classic

	category_tags = list(CTAG_MARSHAL)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_LCK = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/marshal/classic/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/retinue
	cloak = /obj/item/clothing/cloak/stabard/surcoat/bailiff
	backr = /obj/item/rogueweapon/mace/cudgel/justice
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/sheriff
	head = /obj/item/clothing/head/roguetown/chaperon/noble/bailiff

/datum/advclass/marshal/kcommander
	name = "骑士统领"	//One focused on swords and better riding. You get SOME knives skill too but swords are better in general.
	tutorial = "你曾是忠心侍奉王权的骑士，以军略与战功赢得声望，在沙场上赫赫有名。如今自前线退下后，你把昔日战场上的铁律搬回故土，以军纪般的严苛统辖驻军、骑士与城中法令，谁也别想说你在打击罪行上会输给那些软弱的执法官。"
	outfit = /datum/outfit/job/roguetown/marshal/kcommander

	category_tags = list(CTAG_MARSHAL)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_LCK = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/marshal/kcommander/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/retinue/coat
	backr = /obj/item/rogueweapon/sword/long/oathkeeper
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/sheriff

/mob/living/carbon/human/proc/request_law()
	set name = "请求立法"
	set category = "号令"
	if(stat)
		return
	var/inputty = input("拟定一条新法。", "执法官") as text|null
	if(inputty)
		if(hasomen(OMEN_NOLORD))
			make_law(inputty)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_law_requested), src, lord, inputty)
			else
				make_law(inputty)

/mob/living/carbon/human/proc/request_law_removal()
	set name = "请求废法"
	set category = "号令"
	if(stat)
		return
	var/inputty = input("移除一条现行法令。", "执法官") as text|null
	var/law_index = text2num(inputty) || 0
	if(law_index && GLOB.laws_of_the_land[law_index])
		if(hasomen(OMEN_NOLORD))
			remove_law(law_index)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_law_removal_requested), src, lord, law_index)
			else
				remove_law(law_index)

/mob/living/carbon/human/proc/request_purge()
	set name = "请求清法"
	set category = "号令"
	if(stat)
		return
	if(hasomen(OMEN_NOLORD))
		purge_laws()
	else
		var/lord = find_lord()
		if(lord)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_purge_requested), src, lord)
		else
			purge_laws()

/mob/living/carbon/human/proc/request_outlaw()
	set name = "请求宣告亡命"
	set category = "号令"
	if(stat)
		return
	var/inputty = input("宣告某人为亡命徒。", "执法官") as text|null
	if(inputty)
		if(hasomen(OMEN_NOLORD))
			make_outlaw(inputty)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_outlaw_requested), src, lord, inputty)
			else
				make_outlaw(inputty)

/proc/find_lord(required_stat = CONSCIOUS)
	var/mob/living/lord
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.mind || H.job != "Grand Duke" || (H.stat > required_stat))
			continue
		lord = H
		break
	return lord

/proc/lord_law_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_law)
	var/choice = alert(lord, "执法官请求颁布一条新法！\n[requested_law]", "立法请求", "是", "否")
	if(choice != "是" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("领主驳回了这条新法请求！"))
		return
	make_law(requested_law)

/proc/lord_law_removal_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_law)
	if(!requested_law || !GLOB.laws_of_the_land[requested_law])
		return
	var/choice = alert(lord, "执法官请求废除一条法令！\n[GLOB.laws_of_the_land[requested_law]]", "废法请求", "是", "否")
	if(choice != "是" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("领主驳回了这条废法请求！"))
		return
	remove_law(requested_law)

/proc/lord_purge_requested(mob/living/bailiff, mob/living/carbon/human/lord)
	var/choice = alert(lord, "执法官请求清除全部法令！", "清法请求", "是", "否")
	if(choice != "是" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("领主驳回了清除全部法令的请求！"))
		return
	purge_laws()

/proc/lord_outlaw_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_outlaw)
	var/choice = alert(lord, "执法官请求宣告某人为亡命徒！\n[requested_outlaw]", "亡命宣告请求", "是", "否")
	if(choice != "是" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("领主驳回了亡命宣告请求！"))
		return
	make_outlaw(requested_outlaw)

/mob/proc/haltyell()
	set name = "止步！"
	set category = "呼喝"
	emote("haltyell")

/mob/proc/haltyell_exhausting()
	set name = "止步！"
	set category = "呼喝"

	emote("haltyell")
	stamina_add(rand(5,15))
