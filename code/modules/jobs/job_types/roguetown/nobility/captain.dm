/datum/job/roguetown/captain
	title = "Knight Captain" //The Knight Captain is clearly not drawn from the ranks of guardsmen, or sergeants. They're drawn from the Knightly ranks and should be treated as such.
	display_title = "骑士队长"
	flag = GUARD_CAPTAIN
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "你的血脉出身高贵，世代都有强大而忠诚的骑士先于你而生。你曾优雅而尽责地侍奉王家为骑士，如今终于成长为无数人梦寐以求的地位。 \
	身为骑士中的老兵，你率领王权麾下的骑士出征，并负责整训侍从。服从执法官与王权。 \
	带领你的部下走向胜利，也让他们守住纪律，如此你便能见证这片王国在千轮骄阳下兴盛昌隆。"
	display_order = JDO_GUARD_CAPTAIN
	advclass_cat_rolls = list(CTAG_CAPTAIN = 20)

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/guard)
	outfit = /datum/outfit/job/roguetown/captain

	give_bank_account = 26
	noble_income = 16
	min_pq = 9
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_knight.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_NOBLE, TRAIT_GUARDSMAN)
	job_subclasses = list(
		/datum/advclass/captain/infantry
	)

	virtue_restrictions = list(
		/datum/virtue/utility/riding,
	)

/datum/outfit/job/roguetown/captain
	head = /obj/item/clothing/head/roguetown/helmet/heavy/captain
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/captain
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/captain
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs/captain
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON

/datum/job/roguetown/captain/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard)  || (istype(H.cloak, /obj/item/clothing/cloak/captain)))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "队长罩袍（[index]）" //This doesn't even actually work but you know.
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "爵士"
		if(should_wear_femme_clothes(H))
			honorary = "女爵"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/advclass/captain/infantry
	name = "骑士队长"
	tutorial = "你曾直接编入密集步兵军阵，与这片王国最杰出的骑士们并肩作战。 \
	无论作为武装战士还是战术指挥官，你都堪称无双，因此无论在哪片战场上，你的存在都足以令人畏惧。"
	outfit = /datum/outfit/job/roguetown/captain/infantry
	category_tags = list(CTAG_CAPTAIN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
	)

	extra_context = "该分支会在所选武器上获得大师级熟练。"

/datum/outfit/job/roguetown/captain/infantry/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/storage/keyring/kcaptain = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= list(
		/mob/living/carbon/human/proc/request_outlaw,
		/mob/proc/haltyell,
		/mob/living/carbon/human/mind/proc/setorders,
		/mob/living/carbon/human/proc/take_squire
	)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list(
			"马刀",
			"关刀",
			)
		var/weapon_choice = input(H, "选择你的武器。", "整备武装") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("马刀")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				r_hand = /obj/item/rogueweapon/sword/capsabre
				l_hand = /obj/item/rogueweapon/shield/capbuckler
				beltr = /obj/item/rogueweapon/scabbard/sword/royal
			if("关刀")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
				r_hand = /obj/item/rogueweapon/halberd/capglaive
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	if(H.mind && !H.mind.has_spell(/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount))
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/obj/effect/proc_holder/spell/self/convertrole
	name = "征募乞儿"
	desc = "征募某人为你效力。"
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Role given if recruitment is accepted
	var/new_role = "Beggar"
	/// Faction shown to the user in the recruitment prompt
	var/recruitment_faction = "乞儿"
	/// Message the recruiter gives
	var/recruitment_message = "为乞儿效力吧，%RECRUIT！"
	/// Range to search for potential recruits
	var/recruitment_range = 3
	/// Say message when the recruit accepts
	var/accept_message = "我愿效力！"
	/// Say message when the recruit refuses
	var/refuse_message = "我拒绝。"

/obj/effect/proc_holder/spell/self/convertrole/cast(list/targets,mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/recruit in (get_hearers_in_view(recruitment_range, user) - user))
		//not allowed
		if(!can_convert(recruit))
			continue
		recruitment[recruit.name] = recruit
	if(!length(recruitment))
		to_chat(user, span_warning("范围内没有可征募的对象。"))
		return
	var/inputty = input(user, "选择一名可征募的对象！", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(recruitment_range, user)))
			INVOKE_ASYNC(src, PROC_REF(convert), recruit, user)
		else
			to_chat(user, span_warning("征募失败！"))
	else
		to_chat(user, span_warning("已取消征募。"))

/obj/effect/proc_holder/spell/self/convertrole/proc/can_convert(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//only migrants and peasants
	if(!(recruit.job in GLOB.peasant_positions) && \
		!(recruit.job in GLOB.yeoman_positions) && \
		!(recruit.job in GLOB.wanderer_positions))
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/proc/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE
	recruiter.say(replacetext(recruitment_message, "%RECRUIT", "[recruit]"), forced = "[name]")
	var/prompt = alert(recruit, "你愿意加入[recruitment_faction]吗？", "[recruitment_faction]征募", "同意", "拒绝")
	if(QDELETED(recruit) || QDELETED(recruiter) || !(recruiter in get_hearers_in_view(recruitment_range, recruit)))
		return FALSE
	if(prompt != "同意")
		if(refuse_message)
			recruit.say(refuse_message, forced = "[name]")
		return FALSE
	if(accept_message)
		recruit.say(accept_message, forced = "[name]")
	if(new_role)
		recruit.job = new_role
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, recruiter, recruit, new_role)
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/guard
	name = "征募卫兵"
	new_role = "Watchman"
	overlay_state = "recruit_guard"
	recruitment_faction = "Watchman"
	recruitment_message = "为城卫效力，%RECRUIT！"
	accept_message = "为了王权！"
	refuse_message = "我拒绝。"

/obj/effect/proc_holder/spell/self/convertrole/guard/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	recruit.verbs |= /mob/proc/haltyell
