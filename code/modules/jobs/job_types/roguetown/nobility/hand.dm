/datum/job/roguetown/hand
	title = "Hand"
	display_title = "执政之手"
	flag = HAND
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_NO_CONSTRUCT	//No noble constructs.
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/hand
	advclass_cat_rolls = list(CTAG_HAND = 20)
	display_order = JDO_HAND
	tutorial = "无论是凭借卓绝功绩，还是出于私心偏爱，你都成了大公最信任的代理人与顾问。你的权威仅次于大公本人。你的话语足以左右政令、挑起纷争，亦或压下异议。务必让所有人记住你究竟代表着谁的意志，也切莫辜负提拔你的人。"
	whitelist_req = TRUE
	give_bank_account = 44
	noble_income = 22
	min_pq = 9 //The second most powerful person in the realm...
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/nobility/combat_spymaster.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/hand/blademaster,
		/datum/advclass/hand/spymaster,
		/datum/advclass/hand/advisor
	)
	spells = list(/obj/effect/proc_holder/spell/self/convertrole/agent)//Hiring court agents

/datum/outfit/job/roguetown/hand
	backr = /obj/item/storage/backpack/rogue/satchel/short
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/steel
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/hand/pre_equip(mob/living/carbon/human/H)
	H.verbs |= /datum/job/roguetown/hand/proc/remember_agents

/datum/job/roguetown/hand/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(know_agents), L), 5 SECONDS)

///////////
//CLASSES//
///////////

//Blademaster Hand start
/datum/advclass/hand/blademaster
	name = "剑术宗师"
	tutorial = "你为主家兼任剑术宗师与军略家已有多年，早已成长为老辣的战术大师，并以此施展自己的强势意志。别让任何人忘记，你究竟是在谁的耳边低语。你亲手用剑杀过的人，比任何谍务总管能吹嘘的都要多。"
	outfit = /datum/outfit/job/roguetown/hand/blademaster

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_STR = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/hand/blademaster/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/long/dec //Gets STR so longsword instead of a rapier
	beltr = /obj/item/rogueweapon/scabbard/sword/royal
	head = /obj/item/clothing/head/roguetown/chaperon/noble/hand
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		r_hand = /obj/item/rogueweapon/sword/sabre/dec
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,//You don't get killer's ice for this because you're the gross swordsmaster and I HATE YOU!!!!
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/hand = 1,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		H.change_stat(STATKEY_LCK, 2)


//Spymaster start
/datum/advclass/hand/spymaster
	name = "谍务总管"
	tutorial = "你长期担任主家的谍务总管与亲信知己，已成了一座装满阴谋诡计的宝库，并以此贯彻自己的强硬意志。别让任何人忘记，你究竟是在谁的耳边低语。死在你这张嘴下的人，比任何剑术宗师能声称斩杀的都更多。"
	extra_context = "该分支会免费获得“完美追踪者”与“敏锐听觉”。"
	outfit = /datum/outfit/job/roguetown/hand/spymaster

	category_tags = list(CTAG_HAND)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_KEENEARS, TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER)//Spy not a royal champion
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,//Huntmaster, but this was apprentice. You can powerlevel this easy, but that's a waste of sleeping.
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER, // not like they're gonna break into the vault.
	)

//Spymaster start. More similar to the rogue adventurer - loses heavy armor and sword skills for more sneaky stuff.
/datum/outfit/job/roguetown/hand/spymaster/pre_equip(mob/living/carbon/human/H)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,//Just like the wizard, since he can dip the blade.
	)
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
		cloak = /obj/item/clothing/cloak/shadowcloak
		gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
		mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask
		pants = /obj/item/clothing/under/roguetown/trou/shadowpants
	else
		cloak = /obj/item/clothing/cloak/raincloak/mortus //cool spymaster cloak
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		backr = /obj/item/storage/backpack/rogue/satchel/black
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
		pants = /obj/item/clothing/under/roguetown/tights/black
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/stealing, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 6, TRUE)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant

//Advisor Start
/datum/advclass/hand/advisor
	name = "谋士顾问"
	tutorial = "你既是主家的学者，也是其顾问，能娴熟运用知识与奥术之力。别让任何人忘记，你究竟是在谁的耳边低语；你那些睿智的谏言所救下的人命，比任何军略家的命令或谍务总管的算计都要更多。"
	outfit = /datum/outfit/job/roguetown/hand/advisor

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_LCK = 2,
	)
	subclass_spellpoints = 15
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
	)

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/job/roguetown/hand/advisor/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/rapier/hand
	beltr = /obj/item/rogueweapon/scabbard/sheath/courtphysician/hand
	head = /obj/item/clothing/head/roguetown/chaperon/noble/hand
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,//starts with a vial of poison, like all wizened evil advisors do!
	)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(3)
	//He gets far less spellpoints than any other equivalent caster. Give him a T4.
	//Message, too. You'll be taking it anyways.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/recall)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)


////////////////////
///SPELLS & VERBS///
////////////////////

/datum/job/roguetown/hand/proc/know_agents(mob/living/carbon/human/H)
	if(!GLOB.court_agents.len)
		to_chat(H, span_boldnotice("本周伊始，我麾下没有任何密探。"))
	else
		to_chat(H, span_boldnotice("本周伊始，我麾下有这些密探："))
		for(var/name in GLOB.court_agents)
			to_chat(H, span_greentext(name))

/datum/job/roguetown/hand/proc/remember_agents()
	set name = "回想密探"
	set category = "号令之声"

	to_chat(usr, span_boldnotice("我手下现有这些密探："))
	for(var/name in GLOB.court_agents)
		to_chat(usr, span_greentext(name))
	return

/obj/effect/proc_holder/spell/self/convertrole/agent
	name = "征募密探"
	new_role = "Court Agent"//They get shown as adventurers either way.
	overlay_state = "recruit_servant"
	recruitment_faction = "Agents"
	recruitment_message = "为王冠效命吧，%RECRUIT！"
	accept_message = "为了王冠！"
	refuse_message = "我拒绝。"
	recharge_time = 100

/obj/effect/proc_holder/spell/self/convertrole/agent/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	GLOB.court_agents += recruit.real_name
