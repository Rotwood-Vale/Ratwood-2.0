GLOBAL_VAR(lordsurname)
GLOBAL_LIST_EMPTY(lord_titles)

/datum/job/roguetown/lord
	title = "Grand Duke"
	display_title = "大公"
	f_title = "Grand Duchess"
	flag = LORD
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_NOBLE
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	advclass_cat_rolls = list(CTAG_LORD = 20)

	spells = list(
		/obj/effect/proc_holder/spell/self/grant_title,
		/obj/effect/proc_holder/spell/self/convertrole/servant,
		/obj/effect/proc_holder/spell/self/convertrole/guard,
		/obj/effect/proc_holder/spell/self/grant_nobility,
		/obj/effect/proc_holder/spell/self/convertrole/bog
	)
	outfit = /datum/outfit/job/roguetown/lord
	visuals_only_outfit = /datum/outfit/job/roguetown/lord/visuals

	display_order = JDO_LORD
	tutorial = "你凭借阴谋与政局动荡织成的罗网登上王座，成为此地无可置疑的最高权威，也成了这片土地上一切谋划的中心。男人、女人与孩童都觊觎你的位置，恨不得立刻将你取而代之：让他们明白自己错得有多离谱。"
	whitelist_req = FALSE
	min_pq = 10
	max_pq = null
	round_contrib_points = 4
	give_bank_account = 1000
	required = TRUE
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_ROYAL
	// Can't use the Throat when you can't talk properly or.. at all for that matter.
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

	job_subclasses = list(
		/datum/advclass/lord/warrior,
		/datum/advclass/lord/merchant,
		/datum/advclass/lord/wizard,
		/datum/advclass/lord/inbred
	)

/datum/outfit/job/roguetown/lord
	job_bitflag = BITFLAG_ROYALTY

/datum/job/roguetown/lord/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(L)
		var/list/chopped_name = splittext(L.real_name, " ")
		if(length(chopped_name) > 1)
			chopped_name -= chopped_name[1]
			GLOB.lordsurname = jointext(chopped_name, " ")
		else
			GLOB.lordsurname = "of [L.real_name]"
		SSticker.set_ruler_mob(L)
		to_chat(world, "<b><span class='notice'><span class='big'>[L.real_name]现为谷地的[SSticker.rulertype]。</span></span></b>")
		if(istype(SSticker.regentmob, /mob/living/carbon/human))
			var/mob/living/carbon/human/regentbuddy = SSticker.regentmob
			to_chat(L, span_notice("我在归途中便已得知，[regentbuddy.real_name]，那位[regentbuddy.job]，曾在我离席时代理摄政。"))
		SSticker.regentmob = null //Time for regent to give up the position.

		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_marriage_choice)), 50)
		// if(STATION_TIME_PASSED() <= 10 MINUTES) //Late to the party? Stuck with default colors, sorry!
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_color_choice)), 50)

/datum/outfit/job/roguetown/lord
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	cloak = /obj/item/clothing/cloak/lordcloak
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/storage/keyring/lord
	id = /obj/item/scomstone/garrison

/datum/outfit/job/roguetown/lord/pre_equip(mob/living/carbon/human/H)
	..()
	if(SSroguemachine.crown == null || (QDELETED(SSroguemachine.crown)))
		SSroguemachine.crown = null
		head = /obj/item/clothing/head/roguetown/crown/serpcrown
	else
		to_chat(H, span_warning("我的王冠想必仍在这片领地之中。我会将它寻回。"))
	if(should_wear_femme_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		wrists = /obj/item/clothing/wrists/roguetown/royalsleeves
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		if(SSmapping.current_map.map_name == "Rockhill")
			armor = null
			wrists = null
			mask = /obj/item/clothing/head/roguetown/duchess_hood
			cloak = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/duchess
			gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
		if(SSmapping.current_map.map_name == "Desert Town")
			head = /obj/item/clothing/head/roguetown/sultana
			mask = /obj/item/clothing/head/roguetown/crown/serpcrown
			// l_hand = /obj/item/rogueweapon/lordscepter //currently aren't working on sultans
			belt = /obj/item/storage/belt/rogue/leather/cloth/lady
			gloves = /obj/item/clothing/gloves/roguetown/leather/black
			armor = /obj/item/clothing/suit/roguetown/shirt/sultana
			shoes = /obj/item/clothing/shoes/roguetown/gladiator
			wrists = null
			cloak = null
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		shoes = /obj/item/clothing/shoes/roguetown/boots
		if(SSmapping.current_map.map_name == "Rockhill")
			armor = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/duke
			cloak = null
		if(SSmapping.current_map.map_name == "Desert Town")
			head = /obj/item/clothing/head/roguetown/sultan
			mask = /obj/item/clothing/head/roguetown/crown/serpcrown
			// l_hand = /obj/item/rogueweapon/lordscepter
			belt = /obj/item/storage/belt/rogue/leather/sultbelt
			armor = /obj/item/clothing/suit/roguetown/shirt/sultan
			shoes = /obj/item/clothing/shoes/roguetown/shalal
			cloak = null
	if(H.wear_mask)
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask/l
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

//	SSticker.rulermob = H
/**
	Warrior Lord subclass. An evolution from the Daring Twit. This is the original Lord Class.
*/
/datum/advclass/lord/warrior
	name = "英武领主"
	tutorial = "你是一名高贵的战士。无论是率领部下，还是与他们并肩搏杀，你都是凭借自身的力量与技艺攀上如今的位置。又或者，你并非如此传奇，只是一个训练有素、最终被扶上领主之位的继承人。你受过重甲训练，也深谙剑术之道。"
	outfit = /datum/outfit/job/roguetown/lord/warrior
	category_tags = list(CTAG_LORD)
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/lord/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/seal/crown = 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)

/**
	Merchant Lord subclass. Consider this an evolution from Sheltered Aristocrat.
	Gets the same weighted 12 statspread + 5 fortune, but no strength. +2 Int, trade 2 End for 2 Perception. Keep speed. Deals gotta be quick.
	Get nice traits for seeing price, secular appraise and keen ears for spying.
	Weapon skills are worse across the board compared to the warrior lord, apprentice only.
	Has a high noble income plus a starting pouch with insane amount of money.
*/
/datum/advclass/lord/merchant
	name = "商贾领主"
	tutorial = "你自来就擅长金钱与交易，而正是这些本事把你送上了领地之主的位置。你也许是靠财富买来贵胄与权势的商人，也许只是天生善于理财的贵族。正面厮杀并非你的长项\
	但你坐拥丰厚财富、敏锐耳目，也分得清什么买卖值得，什么买卖只会赔个精光。"
	outfit = /datum/outfit/job/roguetown/lord/merchant
	category_tags = list(CTAG_LORD)
	noble_income = 400 // Let's go crazy. This is +400 per day for a total of 2400 per round at the end of a day. This is probably equal to doubling passive incomes of the keep.
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 5,
		STATKEY_PER = 4,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT, // Weapons suitable for defending yourself as a merchant.
		/datum/skill/combat/firearms = SKILL_LEVEL_EXPERT, // Weapons suitable for defending yourself as a merchant.
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/lord/merchant/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter
	beltr = /obj/item/gun/ballistic/firearm/arquebus_pistol
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/quiver/bullet/lead,
		/obj/item/powderflask,)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/**
	Wizard duke! We still want the court mage to be the most powerful wizard,
	but if a warrior duke can be about as strong as a Knight, then a wizard duke could probably afford to be as strong as a mage's associate. They'll get T3, no armor prof.
*/
/datum/advclass/lord/wizard
	name = "法术领主"
	tutorial = "一位优秀的统治者背后总该有力量作支撑。而你恰恰掌握着世间最强大的那一种力量：魔法。当然，治理领地意味着你没法像王国中最伟大的巫师那样钻研得无比深透，但正是你精明而狡黠的法术，才让你稳坐于王座之上。"
	outfit = /datum/outfit/job/roguetown/lord/wizard
	category_tags = list(CTAG_LORD)
	traits_applied = list(TRAIT_NOBLE, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_INTELLECTUAL)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 5,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_spellpoints = 27
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/lord/wizard/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/storage/backpack/rogue/satchel
	l_hand = /obj/item/rogueweapon/lordscepter
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/roguegem/amethyst = 1, /obj/item/spellbook_unfinished/pre_arcyne = 1)

/**
	Inbred Lord subclass. A joke class, evolution of the Inbred Wastrel.
	Literally the same stat line and skills line, but with one exception - 10 Fortune.
	Why? Because it is funny, that's why. They also have heavy armor training.
	The fact that the inbred wastrel with 20 fortune and critical weakness
	can get into heavy armor and try to fight is hilarious.
*/
/datum/advclass/lord/inbred
	name = "近亲领主"
	tutorial = "普赛顿 与 阿斯特拉塔 似乎仍对你露出了微笑。尽管你身躯孱弱、血统畸败，家族中也从未停止过想把你排除出继承序列的阴谋，你却还是莫名其妙地坐上了谷地领主之位。愿你的统治长存百年。"
	outfit = /datum/outfit/job/roguetown/lord/inbred
	category_tags = list(CTAG_LORD)
	traits_applied = list(TRAIT_NOBLE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NORUN, TRAIT_HEAVYARMOR, TRAIT_GOODLOVER)
	subclass_stats = list(
		STATKEY_LCK = 10,
		STATKEY_INT = -2,
		STATKEY_PER = -2,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_STR = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/lord/inbred/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/gun/ballistic/firearm/arquebus_pistol
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/quiver/bullet/lead,
		/obj/item/powderflask,)
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/combat/firearms, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(0,0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)

/datum/outfit/job/roguetown/lord/visuals/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/crown/fakecrown //Prevents the crown of woe from happening again.

/proc/give_lord_surname(mob/living/carbon/human/family_guy, preserve_original = FALSE)
	if(!GLOB.lordsurname)
		return
	if(preserve_original)
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
		return family_guy.real_name
	var/list/chopped_name = splittext(family_guy.real_name, " ")
	if(length(chopped_name) > 1)
		family_guy.fully_replace_character_name(family_guy.real_name, chopped_name[1] + " " + GLOB.lordsurname)
	else
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
	return family_guy.real_name

/obj/effect/proc_holder/spell/self/grant_title
	name = "册封头衔"
	desc = "赐予某人一个荣誉……或羞辱的称号。"
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Maximum range for title granting
	var/title_range = 3
	/// Maximum length for the title
	var/title_length = 42

/obj/effect/proc_holder/spell/self/grant_title/cast(list/targets, mob/user = usr)
	. = ..()
	var/granted_title = input(user, "你想赐予什么样的头衔？", "[name]") as null|text
	granted_title = reject_bad_text(granted_title, title_length)
	if(!granted_title)
		return
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/village_idiot in (get_hearers_in_view(title_range, user) - user))
		//not allowed
		if(!can_title(village_idiot))
			continue
		recruitment[village_idiot.name] = village_idiot
	if(!length(recruitment))
		to_chat(user, span_warning("范围内没有可受封之人。"))
		return
	var/inputty = input(user, "选择受封对象！", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(title_range, user)))
			INVOKE_ASYNC(src, PROC_REF(village_idiotify), recruit, user, granted_title)
		else
			to_chat(user, span_warning("授称失败！"))
	else
		to_chat(user, span_warning("已取消授称。"))

/obj/effect/proc_holder/spell/self/grant_title/proc/can_title(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/grant_title/proc/village_idiotify(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter, granted_title)
	if(QDELETED(recruit) || QDELETED(recruiter) || !granted_title)
		return FALSE
	if(GLOB.lord_titles[recruit.real_name])
		recruiter.say("我在此剥夺你，[uppertext(recruit.name)]，[uppertext(GLOB.lord_titles[recruit.real_name])]之称号！")
		GLOB.lord_titles -= recruit.real_name
		return FALSE
	recruiter.say("我在此授予你，[uppertext(recruit.name)]，[uppertext(granted_title)]之称号！")
	REMOVE_TRAIT(recruit, TRAIT_OUTLANDER, ADVENTURER_TRAIT)
	REMOVE_TRAIT(recruit, TRAIT_OUTLANDER, TRAIT_GENERIC)
	GLOB.lord_titles[recruit.real_name] = granted_title
	return TRUE

/obj/effect/proc_holder/spell/self/grant_nobility
	name = "授予贵胄"
	desc = "册封某人为贵族，或剥夺其贵族身份。"
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Maximum range for nobility granting
	var/nobility_range = 3

/obj/effect/proc_holder/spell/self/grant_nobility/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/village_idiot in (get_hearers_in_view(nobility_range, user) - user))
		//not allowed
		if(!can_nobility(village_idiot))
			continue
		recruitment[village_idiot.name] = village_idiot
	if(!length(recruitment))
		to_chat(user, span_warning("范围内没有可册封之人。"))
		return
	var/inputty = input(user, "选择册封对象！", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(nobility_range, user)))
			INVOKE_ASYNC(src, PROC_REF(grant_nobility), recruit, user)
		else
			to_chat(user, span_warning("册封失败！"))
	else
		to_chat(user, span_warning("已取消册封。"))

/obj/effect/proc_holder/spell/self/grant_nobility/proc/can_nobility(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_DEFILED_NOBLE)) // Their lux was tainted by evil matthios rite. They are utterly fucked.
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/grant_nobility/proc/grant_nobility(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_NOBLE))
		if(!(recruit.job in GLOB.foreign_positions))
			recruiter.say("我在此剥夺你，[uppertext(recruit.name)]，的贵族身份！")
			REMOVE_TRAIT(recruit, TRAIT_NOBLE, TRAIT_GENERIC)
			REMOVE_TRAIT(recruit, TRAIT_NOBLE, TRAIT_VIRTUE)
			return FALSE
		else
			to_chat(recruiter, span_warning("此人的贵族身份并不归我剥夺！"))
			return FALSE
	recruiter.say("我在此授予你，[uppertext(recruit.name)]，贵族身份！")
	ADD_TRAIT(recruit, TRAIT_NOBLE, TRAIT_GENERIC)
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "征募仆役"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "仆役"
	recruitment_message = "为王权效力，%RECRUIT！"
	accept_message = "为了王权！"
	refuse_message = "我拒绝。"
	recharge_time = 100

/obj/effect/proc_holder/spell/self/convertrole/bog
	name = "征募守林人"
	new_role = "Warden"
	recruitment_faction = "沼泽守卫"
	recruitment_message = "为守林人效力，%RECRUIT！"
	accept_message = "为了林苑！"
	refuse_message = "我拒绝。"
