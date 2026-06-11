/datum/job/roguetown/suitor
	title = "Suitor"
	display_title = "求婚贵胄"
	flag = SUITOR
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_CONSORT = 20)
	tutorial = "你是一名来自异国宫廷的贵族，远赴谷地，只为赢得谷地中最炙手可热之人的婚约，并为你的家族争取一位政治盟友。竞争激烈，而看起来，盯上公爵青睐的人显然不止你一个……"

	outfit = /datum/outfit/job/roguetown/suitor

	display_order = JDO_SUITOR
	give_bank_account = 40
	noble_income = 20
	min_pq = 3
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	job_traits = list(TRAIT_NOBLE)

/datum/outfit/job/roguetown/suitor
	job_bitflag = BITFLAG_ROYALTY

/datum/advclass/suitor/envoy
	name = "使节"
	tutorial = "你是一位举止优雅的使节，精于谄辞、礼法，以及恰到好处的真诚表演。你会用温柔、机智与恰如其分的微笑打动公爵，慢慢赢得他的欢心。"
	outfit = /datum/outfit/job/roguetown/suitor/envoy
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/suitor/envoy/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		neck = /obj/item/roguekey/manor
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
		backl = /obj/item/rogue/instrument/harp
		beltl = /obj/item/flashlight/flare/torch/lantern
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/signet
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle/consortcrown
		pants = /obj/item/clothing/under/roguetown/tights
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		backl = /obj/item/rogue/instrument/lute
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
		belt = /obj/item/storage/belt/rogue/leather
		neck = /obj/item/roguekey/manor
		beltl = /obj/item/flashlight/flare/torch/lantern
		beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/signet
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/suitor()
		H.mind.add_antag_datum(new_antag)

/datum/advclass/suitor/schemer
	name = "谋士"
	tutorial = "你是条巧舌如簧的毒蛇，擅长耳语、毒药与拿捏得分毫不差的“意外”。既然能操纵人心，何必费力去赢得它？等到对手被一一清除，秘密又尽为你所用，公爵将别无选择，只能选中你。"
	outfit = /datum/outfit/job/roguetown/suitor/schemer
	traits_applied = list(TRAIT_ALCHEMY_EXPERT)
	category_tags = list(CTAG_CONSORT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/suitor/schemer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/tights/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/black
	neck = /obj/item/roguekey/manor
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/ring/silver
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress
	if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/longcoat
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/lockpick = 1,
		)
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/suitor()
		H.mind.add_antag_datum(new_antag)

/datum/advclass/suitor/gallant
	name = "英杰"
	tutorial = "你以荣誉与寒铁的光芒正面迎战每一位对手。你赢得公爵青睐的方式，不靠耳语，也不靠柔情，而是靠满堂喝彩。"
	outfit = /datum/outfit/job/roguetown/suitor/gallant
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/suitor/gallant/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/gallant
	pants = /obj/item/clothing/under/roguetown/tights/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/roguekey/manor
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/sabre/dec
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/ring/silver
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/mid = 1)
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/suitor()
		H.mind.add_antag_datum(new_antag)


/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/gallant
	color = "#384d8a"
