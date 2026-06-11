//Vaquero, but not merc. So, y'know, cool.
//Sailors, given the choice of two classes.
//Navigator, focused on survival skills.
//Castaway, focused on fancy footwork.
/datum/advclass/foreigner/nostromo
	name = "伊特鲁斯卡 失途水手"
	tutorial = "Nostromo，这个词从通俗 伊特鲁斯卡 语中被硬生生扯了出来，又被帝国语言嚼得面目全非。\
	它原本的含义，平民们早已无人知晓。你既不是什么海上浪客，也不是什么浪漫人物，因为你根本不是英雄。\
	被贴上“Nostromo”这个名号，便意味着你已经失了自己的位置，成了个只会夸夸其谈、却不肯拔剑的人。\
	也许你曾是伟大的船长？也许你在更好的年岁里，是个快活水手？\
	如今这些都不重要了。给自己重新挣一个名字吧。"
	allowed_races = RACES_ALL_KINDS
	subclass_languages = list(/datum/language/etruscan)
	outfit = /datum/outfit/job/roguetown/adventurer/nostromo
	cmode_music = 'sound/music/combat_vaquero.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_GOODLOVER, TRAIT_INTELLECTUAL)//No dodge / crit resist slop. Zzz...
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_INT = 3
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,//Not much of a wrestler.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,//SWIM, MORON.
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,//WORK THOSE LINES!!!!
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

	extra_context = "该子职业为玩家提供两种配置。\
	领航员：+2 感知，熟练级剑术。\
	落难者：+1 感知/意志，熟练级开锁，1 级吟游激励。"

/datum/outfit/job/roguetown/adventurer/nostromo/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bardhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/half/rider/red
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/scabbard/sheath
	if(H.mind)
		var/nostromo_purpose = list("领航员","落难者")
		var/purpose_choice = input(H, "选择你的失途。", "你为何被逼上跳板") as anything in nostromo_purpose
		switch(purpose_choice)
			if("领航员")
				H.change_stat(STATKEY_PER, 2)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)//No shield skill, since you're buckler reliant.
				r_hand = /obj/item/rogueweapon/sword/long/etruscan//You'd stolen this, probably. It's just a longsword reskin.
				beltl = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/buckler
				backpack_contents = list(
								/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
								/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
								/obj/item/flashlight/flare/torch = 1,
								)
			if("落难者")
				var/datum/inspiration/I = new /datum/inspiration(H)
				I.grant_inspiration(H, bard_tier = BARD_T1)
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 3, TRUE)
				//You already know why...
				backr = /obj/item/rogue/instrument/flute
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
				backpack_contents = list(
								/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
								/obj/item/lockpick = 1,
								/obj/item/flashlight/flare/torch = 1,
								/obj/item/rogueweapon/scabbard/sheath = 1
								)
