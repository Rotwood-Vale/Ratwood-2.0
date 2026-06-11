/datum/advclass/mercenary/steppesman
	name = "阿夫尼克 联盟军"
	tutorial = "作为对你所属 哥萨克 赫特曼履行的强制服役之一环，你在这一年的轮调中离开故土先锋军， \
	转而加入北方草原的统一佣兵军 阿夫尼克 联盟，并投身 费伦提亚的 战线。 \
	为祖国带回黄金与荣耀。Chest' cherez pobedu."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/steppesman
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_league.ogg'
	subclass_languages = list(/datum/language/aavnic)
	extra_context = "该分支拥有 5 种不同的配装路线，属性、技能与装备各不相同。"
	subclass_skills = list(
	//Universal skills
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/mercenary/steppesman/pre_equip(mob/living/carbon/human/H)
	..()

	//Universal gear
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/whip/nagaika,
		/obj/item/rogueweapon/scabbard/sheath
		)

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	var/classchoice
	if(H.mind)
		var/classes = list("Starshina - 军士长", "Obyvatel' - 精锐工兵", "Gromoverzhets - 爆雷工兵", "Zastrel'shchik - 轻装弓手", "Plastunsky - 潜踪步兵")
		classchoice = input(H, "选择你的战斗流派。", "可选流派") as anything in classes
	
	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

		switch(classchoice)
			if("Starshina - 军士长")	//Tl;dr - medium armor class for Mount and Blade larpers who still get a saiga. Akin to Vaquero with specific drip.
				H.set_blindness(0)
				to_chat(H, span_warning("军士长 是北方草原 哥萨克 中的初级军官阶层，历经 Grimoria 各地战火的老兵。 \
				漫长的服役岁月为你赢来了你的尖顶盔、盾牌与甲胄，但别搞错了。 \
				你可不是什么坐着喝苦酒的 Grenzel 贵族。带头冲锋吧，Zoloto i slava。"))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe	//Scale armor w/ better durability & unique sprite
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman
				beltl= /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_SPD, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil() 	//Fits in my head all too well.
				var/masks = list(
				"人形" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"兽形"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"无"
		)
				var/maskchoice = input("哪种更适合你的脸型？", "面具选择") as anything in masks
				if(maskchoice != "无")
					mask = masks[maskchoice]

			if("Obyvatel' - 精锐工兵")	//Tl;dr - medium armor sappers with less mobility in exchange for their different statblock and equipment.
				H.set_blindness(0)
				to_chat(H, span_warning("精锐工兵 是一支训练方式独特的 哥萨克 步兵部队，精于破坏与筑垒之术。 \
				他们往往最先跟随 Starshina 投入战斗，也往往最先倒下。 \
				你是盾，而你的弟兄们是剑。Dvigaytes' ni dlya kogo." ))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman // rucksack aka /bagpack eats whatever goes to backpack_contents so replaced with shield
				l_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				backpack_contents = list(
					/obj/item/roguekey/mercenary,
					/obj/item/storage/belt/rogue/pouch/coins/poor,
					/obj/item/rogueweapon/handsaw,
					/obj/item/rogueweapon/chisel,
					/obj/item/rogueweapon/huntingknife/combat,
					/obj/item/rogueweapon/scabbard/sheath
				)
				H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)		//To avoid virtue cheese
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, 3, TRUE)		//Ditto
				H.change_stat(STATKEY_STR, 2)		//Statblock prone to revision. Probably will be revised. Currently weighted for 7 points and not 9.
				H.change_stat(STATKEY_WIL, 3)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, -2)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
				var/masks = list(
				"人形" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"兽形"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"无"
		)
				var/maskchoice = input("哪种更适合你的脸型？", "面具选择") as anything in masks
				if(maskchoice != "无")
					mask = masks[maskchoice]

			if("Gromoverzhets - 爆雷工兵")	//Tl;dr - these guys fucking EXPLODE. No whip. No dagger. Less skills. Three TNT sticks. Impact of choice. Godspeed.
				H.set_blindness(0)
				to_chat(H, span_warning("爆雷工兵 是 精锐工兵 中规模较小的一支， \
				专门负责连队爆炸物的保管与频繁使用。 \
				让常识指引你，也让你的投掷手臂足够有力。Ne ubivay sebya, pozhaluysta."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				head = /obj/item/clothing/head/roguetown/papakha
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				if(should_wear_femme_clothes(H))
					armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
				else
					armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				backl = /obj/item/rogueweapon/shield/iron/steppesman
				beltl = /obj/item/tntstick
				beltr = /obj/item/tntstick
				l_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				//No whip, dagger, etc. Only the explosives and some basic stuff.
				backpack_contents = list(
					/obj/item/roguekey/mercenary,
					/obj/item/storage/belt/rogue/pouch/coins/poor,
					/obj/item/tntstick
					)
				H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)//One less axe skill.
				H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)//One less shield skill.
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)		//To avoid virtue cheese
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)		//Ditto
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, 3, TRUE)		//Ditto
				H.change_stat(STATKEY_WIL, 3)		//Two less speed, no con, compared to 'elite' sappers. 7 spread.
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, -4)
				ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)//No armour skill. They get BOMBS.
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
				var/masks = list(
				"人形" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
				"兽形"		= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
				"无"
		)
				var/maskchoice = input("哪种更适合你的脸型？", "面具选择") as anything in masks
				if(maskchoice != "无")
					mask = masks[maskchoice]

				var/special_grenade = list(
				"爆裂"			= /obj/item/impact_grenade/explosion,
				"烟尘"				= /obj/item/impact_grenade/smoke,
				"毒雾"			= /obj/item/impact_grenade/smoke/poison_gas,
				"烈焰"		= /obj/item/impact_grenade/smoke/fire_gas,
				"致盲"			= /obj/item/impact_grenade/smoke/blind_gas,
				"无"
		)
				var/grenade_choice = input("你要携带哪种触发手雷？", "手雷选择") as anything in special_grenade
				if(grenade_choice != "无")
					r_hand = special_grenade[grenade_choice]
				else//Do they not take a grenade? Engineering skill and alchemy. They're a bomb factory.
					H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 2, TRUE)	//Eeyup.
					H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)	//This ain't a pie factory.


			if("Zastrel'shchik - 轻装弓手")	//Tl;dr - light armor class for Tatar-style archery.
				H.set_blindness(0)
				to_chat(H, span_warning("轻装弓手 是北方草原上精于游骑与射术的轻装弓手。 \
				他们依赖速度、视野与精准，在战场边缘不断消磨敌人。 \
				保持机动，别让任何人追上你。"))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				beltr = /obj/item/quiver/javelin/iron
				beltl = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
				neck = /obj/item/clothing/neck/roguetown/leather
				H.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				H.change_stat(STATKEY_PER, 3)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

			if("Plastunsky - 潜踪步兵")		//Tl;dr - Old Steppesman whip build, light armor, be the glass canon you always wanted to be. Live your life, king.
				H.set_blindness(0)
				to_chat(H, span_warning("成为 阿夫尼克的、成为 哥萨克，并非一种头衔，也非单靠出身就能拥有，而是一种活法。 \
				这些离经叛道的边地人看待贵族与农夫时，目光里并无差别。 \
				新近征召而来的他们以 Plastunsky 之名上阵，带着自己能拿得出的全部家当投入战斗。 \
				他们看似不过是农兵杂牌，却正是文明战士最厌恶的克星。Pust' chetyre zverya vedut tebya." ))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				head = /obj/item/clothing/head/roguetown/papakha	//No helm
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
				cloak = /obj/item/clothing/cloak/volfmantle			//Crazed man, gives the look.
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				neck = /obj/item/clothing/neck/roguetown/chaincoif	//Better neckpiece for slightly less skill variety. Based it off a cool piece of art...				H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)		//Bit high but he doesn't get huge strength boons so makes up for it. Same as a guard.
				H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()		//Semi-crazed warrior vibe.
				var/weapons = list("Lándzsa 长枪", "链枷")
				var/weapon_choice = input("选择你的武器。", "整备武装") as anything in weapons
				switch(weapon_choice)
					if("Lándzsa 长枪")//Funny banner weapon & punchdagger, with whip I suppose.
						r_hand = /obj/item/rogueweapon/spear/boar/aav
						l_hand = /obj/item/rogueweapon/katar/punchdagger/aav
						backl = /obj/item/rogueweapon/scabbard/gwstrap
						H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)		//Use of the weapon.
					if("链枷")//Or boring flail and buckler, whip.
						beltl = /obj/item/rogueweapon/flail
						beltr = /obj/item/rogueweapon/shield/buckler //Doesn't get good shield skill + no armor, so they get this to compensate for no parry on whip.
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)	//Old whip skill.

	H.merctype = 11
