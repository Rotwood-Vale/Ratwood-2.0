//Gronnic Itinerant is a combination subclass.
//A choice between polearms, ranged, or miracles.
/datum/advclass/foreigner/gronn
	name = "格隆恩 流徙者"
	tutorial = "不论你是与族群失散，还是被故土抛弃，你终究还是来到了 费伦提亚。\
	血誓、暴力，以及你族裔一并携来的疯狂仍缠着你不放；你究竟要怎样适应这里？\
	也许，只要还有另一位酋长愿意接纳你……"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/gronnic
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_gronn.ogg'
	traits_applied = list(TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "仅限 异民。\
	打手提供：+3 力量 / -2 智力，中甲训练，熟练长柄与骑术，并附带暴击抗性。\
	射手提供：+3 感知 / +2 力量，中甲训练，大师弓术，熟练追踪。\
	狂信者提供：+2 速度 / +2 力量，闪避专精，T2 神迹。"

/datum/outfit/job/roguetown/adventurer/gronnic
	allowed_patrons = ALL_INHUMEN_PATRONS

/datum/outfit/job/roguetown/adventurer/gronnic/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/handaxe
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rogueweapon/scabbard/sheath)

	if(H.mind)
		var/gronnish_lot = list("打手","射手", "狂信者")
		var/lot_choice = input(H, "选择你曾经的身份。", "你曾是什么人") as anything in gronnish_lot
		switch(lot_choice)
			if("打手")
				//Equipment
				head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				//Skills & Stats.
				H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
				H.change_stat(STATKEY_STR, 3)
				H.change_stat(STATKEY_INT, -2)
				//The rest.
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("射手")
				//Equipment
				head = /obj/item/clothing/head/roguetown/hatfur
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				l_hand = /obj/item/quiver/arrows
				//Skills & Stats.
				H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.change_stat(STATKEY_PER, 3)
				H.change_stat(STATKEY_STR, 2)
				//The rest.
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("狂信者")
				//Equipment
				head = /obj/item/clothing/head/roguetown/hatfur
				armor = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
				r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
				//Skills & Stats.
				H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_SPD, 2)
				//The rest.
				var/datum/devotion/C = new /datum/devotion(H, H.patron)
				C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2) //Capped to T2 miracles. Devotion at T2.
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
