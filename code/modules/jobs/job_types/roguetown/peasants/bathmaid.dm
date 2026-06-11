/datum/job/roguetown/nightmaiden
	title = "Bathhouse Attendant"
	display_title = "浴场侍者"
	f_title = "Bathhouse Attendant"
	flag = WENCH
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 5
	spawn_positions = 5

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)


	tutorial = "舞蹈、乐曲，或是侍奉肉身的技艺。你已靠这些本事积攒出了一点取悦他人的名声，也正因如此，在某个人生节点上，浴场主人看中了你，招你来施展其中一门长处。在浴场里，你在阶序中的位置，取决于你混迹这行有多久，以及你到底值多少马蒙。"

	outfit = /datum/outfit/job/roguetown/nightmaiden
	advclass_cat_rolls = list(CTAG_NIGHTMAIDEN = 20)
	display_order = JDO_WENCH
	give_bank_account = TRUE
	can_random = FALSE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_EMPATH, TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT)
	job_subclasses = list(
		/datum/advclass/nightmaiden,
		/datum/advclass/nightmaiden/concubine,
		/datum/advclass/nightmaiden/courtesan
	)

/datum/outfit/job/roguetown/nightmaiden
	name = "浴场侍者"
	// This is just a base outfit, the actual outfits are defined in the advclasses

/datum/advclass/nightmaiden
	name = "浴场侍者"
	tutorial = "你还是个新入行的学徒。大多数人会把卑微的浴场女侍骂成那种为钱引人上床的可怜蠢货，不过你会辩解说，那也只是偶尔！你在公共浴场里侍奉地位高于你的人，按客人的心意把场子与来客都收拾得妥妥帖帖。洗衣、处理些轻伤，再熟练地用香皂为客人擦洗身子，这便是你的手艺。"
	outfit = /datum/outfit/job/roguetown/nightmaiden/attendant
	category_tags = list(CTAG_NIGHTMAIDEN)
	traits_applied = list(TRAIT_NUTCRACKER, TRAIT_CICERONE)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/nightmaiden/attendant/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/armingcap
	neck = /obj/item/clothing/neck/roguetown/collar/leather
	beltl = /obj/item/roguekey/nightmaiden
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backpack_contents = list(
		/obj/item/soap/bath = 1,
		/obj/item/mini_flagpole/bathhouse,
	)
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random
		pants = /obj/item/clothing/under/roguetown/skirt/brown
		belt =	/obj/item/storage/belt/rogue/leather/cloth/lady
	else
		belt = /obj/item/storage/belt/rogue/leather
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)

/datum/advclass/nightmaiden/concubine
	name = "侍妾"
	tutorial = "与你那些还维持着体面门面的浴场同伴不同，你已把所有伪装都抛开了。你是贵族们珍爱的私产，披戴着异域丝绸与黄金饰物。你的职责就是提供陪伴、取乐与欢愉。在那些精致名妓手下做事时，你的行当地位也确实比普通浴场侍者高上一层。"
	outfit = /datum/outfit/job/roguetown/nightmaiden/concubine
	category_tags = list(CTAG_NIGHTMAIDEN)
	traits_applied = list(TRAIT_LIGHT_STEP, TRAIT_BEAUTIFUL)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 1
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/nightmaiden/concubine/pre_equip(mob/living/carbon/human/H)
	..()
	beltl = /obj/item/roguekey/nightmaiden
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rope = 1,
		/obj/item/candle/eora = 1,
		/obj/item/rogueweapon/whip = 1,
		/obj/item/clothing/mask/rogue/blindfold = 1,
		/obj/item/mini_flagpole/bathhouse,
	)
	if(should_wear_femme_clothes(H))
		mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		neck = /obj/item/clothing/neck/roguetown/collar/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
		shoes = /obj/item/clothing/shoes/roguetown/anklets
		belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		neck = /obj/item/clothing/neck/roguetown/collar/catbell
		pants = /obj/item/clothing/under/roguetown/trou/leathertights
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/sandals

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
		var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇琴","口簧琴","鲁特琴","圣咏琴","三味线","小号","中提琴","咏声护符")
		var/weapon_choice = input(H, "选择你的乐器。", "拿起家伙") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("班卓琴")
				backr = /obj/item/rogue/instrument/banjo
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("口琴")
				backr = /obj/item/rogue/instrument/harmonica
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("手摇琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口簧琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("圣咏琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("咏声护符")
				backr = /obj/item/rogue/instrument/vocals

/datum/advclass/nightmaiden/dominatrix
	name = "调教师"
	tutorial = "痛楚与欢愉相接之处，有一道纤细而模糊的界线。你服侍的，正是那类喜欢踩在线上的客人。你将疼痛与支配的技艺练成了自己的本事。可说到底，你始终还是妓子，而他们仍旧是客人。你真正握有的权力，又有多少呢？"
	outfit = /datum/outfit/job/roguetown/nightmaiden/dominatrix
	//maximum_possible_slots = 1 //It could be funny to have a gang of them, probably fine
	category_tags = list(CTAG_NIGHTMAIDEN)
	traits_applied = list(TRAIT_NUTCRACKER, TRAIT_NOPAINSTUN) //might be a bit much but given their profession I imagine they'd be able to handle a bit of pain.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_CON = 1
	)

/datum/outfit/job/roguetown/nightmaiden/dominatrix/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/whip
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/menacing
	neck = /obj/item/roguekey/nightmaiden
	backpack_contents = list(
		/obj/item/rope = 1,
		/obj/item/clothing/mask/rogue/blindfold = 1,
		/obj/item/clothing/neck/roguetown/collar/catbell,
		/obj/item/leash/leather,
		/obj/item/mini_flagpole/bathhouse,
	)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/bikini
		belt = /obj/item/storage/belt/rogue/leather/black
	else
		pants =	/obj/item/clothing/under/roguetown/trou/beltpants
		belt = /obj/item/storage/belt/rogue/leather/black
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE) //3 in their preferred combat skills seems to be in line for towner-y roles
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE) //can't be an amateur at this sort of thing
	H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE) //for caning purposes
	H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)//worse than the other whores but still a bit tricksy
	H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE) //tempted to make it 3. Need to provide aftercare yknow

/datum/advclass/nightmaiden/courtesan
	name = "名妓"
	tutorial = "你熬过了心机、欺骗与竞争，终于成长为浴场里最值钱、也最擅交际的摇钱树之一。你穿戴着恩客们遗留下来的华美赠礼，不是谁都能轻易碰得到你。在鸨母手下，你承担了大半对外应酬的重担，也提供形形色色的娱乐，只不过一切都标着高昂的价码。 "
	outfit = /datum/outfit/job/roguetown/nightmaiden/courtesan
	category_tags = list(CTAG_NIGHTMAIDEN)
	traits_applied = list(TRAIT_KEENEARS, TRAIT_BEAUTIFUL)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/nightmaiden/courtesan/pre_equip(mob/living/carbon/human/H)
	..()
	var/pinroll = rand(1, 20)
	switch(pinroll)
		if(1 to 19)
			head = /obj/item/lockpick/goldpin
		if(20)
			head = /obj/item/lockpick/goldpin/silver
	var/ringroll = rand(1, 100)
	switch(ringroll)
		if(1 to 25)
			id = /obj/item/clothing/ring/gold
		if(26 to 50)
			id = /obj/item/clothing/ring/emerald
		if(51 to 80)
			id = /obj/item/clothing/ring/topaz
		if(81 to 95)
			id = /obj/item/clothing/ring/silver
		if(96 to 100)
			id = /obj/item/clothing/ring/diamond
	beltl = /obj/item/roguekey/nightmaiden
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/powder/moondust = 2,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/toy/cards/deck = 1,
		/obj/item/mini_flagpole/bathhouse,
	)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
		shirt = /obj/item/clothing/suit/roguetown/armor/corset
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		shoes = /obj/item/clothing/shoes/roguetown/anklets
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short

	if(H.mind)
		var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇琴","口簧琴","鲁特琴","圣咏琴","三味线","小号","中提琴","咏声护符")
		var/weapon_choice = input(H, "选择你的乐器。", "拿起家伙") as anything in weapons
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
		H.set_blindness(0)
		switch(weapon_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("班卓琴")
				backr = /obj/item/rogue/instrument/banjo
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("口琴")
				backr = /obj/item/rogue/instrument/harmonica
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("手摇琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口簧琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("圣咏琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("咏声护符")
				backr = /obj/item/rogue/instrument/vocals

/obj/item/soap/bath
	name = "草本香皂"
	desc = "由多种草药制成的香皂。"
