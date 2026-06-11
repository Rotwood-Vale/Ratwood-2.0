/datum/job/roguetown/wardenmaster
	title = "Master Warden"
	display_title = "守林总长"
	flag = BOGMASTER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)//I like the idea of making it set you to middle aged, but having the requirement removes it from the latejoin menu which I think is bad for visibility
	tutorial = "你是守林人中资历最深的一位。这些精锐巡林者巡逻、侦察，并凶狠守卫着下城区与周边荒野，处理那些尚不值得惊动城市高层的威胁与罪案。\
				你的职责是率领这群冷淡的守林人，管束桀骜不驯的先锋守卒，在城墙南方的混乱中劈出秩序。\
				服从元帅与王权的命令，在墙外充当文明边境之外第一道防线。\
				守住道路，守住先锋堡垒。王权正指望着你。"
	display_order = JDO_BOGMASTER
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/wardenmaster
	advclass_cat_rolls = list(CTAG_BOGMASTER = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_FUSILIER)
	job_subclasses = list(
		/datum/advclass/wardenmaster/wardenmaster
	)

/datum/outfit/job/roguetown/wardenmaster
	job_bitflag = BITFLAG_GARRISON

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/wardenmaster
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/antler
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/darkcloak/bear/wardenmaster
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	id = /obj/item/scomstone/garrison

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/wardenmaster/wardenmaster
	name = "守林总长"
	tutorial = "你可不是什么无名之辈，而是下城区堡垒的守林总长。也许你最初只是个农夫，或是一介佣兵，但你一路从底层爬到了如今这等既能赢得敬重、也能发号施令的位置。执起兵刃吧，守林总长！"
	outfit = /datum/outfit/job/roguetown/wardenmaster/wardenmaster

	category_tags = list(CTAG_BOGMASTER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 1, 
		STATKEY_CON = 1, 
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/wardenmaster/wardenmaster/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/vanguard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/wardenmaster = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/signal_horn = 1
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("双手巨斧","标枪与盾","黑角长弓","手炮")	//competent at both sides of wardenry so it's more a matter of what weapon you start with
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		var/armor_options = list("轻甲", "中甲")
		var/armor_choice = input(H, "选择你的护甲。", "穿上护甲") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)//feel it'd be nice to have a sword version for a real Jeor Mormont?
			if("双手巨斧")			
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/rogueweapon/stoneaxe/oath
			if("标枪与盾")
				beltr = /obj/item/quiver/javelin/steel
				backl = /obj/item/rogueweapon/shield/tower/
			if("黑角长弓")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
			if("手炮")//okay I can remove this later but I think it would be... just... so based
				r_hand = /obj/item/gun/ballistic/firearm/handgonne
				l_hand = /obj/item/powderflask
				beltr = /obj/item/quiver/bullet/lead
		switch(armor_choice)
			if("轻甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			if("中甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				pants = /obj/item/clothing/under/roguetown/chainlegs

/obj/effect/proc_holder/spell/self/convertrole/vanguard
	name = "征募先锋"
	new_role = "Vanguard"
	overlay_state = "recruit_guard"
	recruitment_faction = "Vanguard"
	recruitment_message = "为先锋而战，%RECRUIT！"
	accept_message = "为了王权！"
	refuse_message = "我拒绝。"
