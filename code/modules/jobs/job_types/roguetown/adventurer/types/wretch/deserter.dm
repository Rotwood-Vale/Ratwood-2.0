/datum/advclass/wretch/deserter
	name = "失节骑士"
	tutorial = "你曾是受人尊崇与敬畏的骑士，如今却成了背弃君主的叛徒。你过着亡命之徒的日子，被世人唾弃，也被整个社会轻蔑地看待。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/wretch/deserter
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_EQUESTRIAN, TRAIT_DISGRACED_NOBLE)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it.

	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg' // same as new hedgeknight music
	class_select_category = CLASS_CAT_WARRIOR
	// Deserter are the knight-equivalence. They get a balanced, straightforward 2 2 3 statspread to endure and overcome.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_STR = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

	extra_context = "This class is restricted from using the Equestrian virtue."

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/wretch/deserter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你曾是受人尊崇与敬畏的骑士，如今却成了背弃君主的叛徒。你过着亡命之徒的日子，被世人唾弃，也被整个社会轻蔑地看待。"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		var/weapons = list(
			"刺剑",
			"钉锤加盾",
			"链枷加盾",
			"长剑加盾",
			"卢塞恩锤",
			"战斧",
			"骑枪加风筝盾",
			"弯刀",		//WHO MISPELLED IT BRO
		)
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("刺剑")
				r_hand = /obj/item/rogueweapon/estoc
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("长剑加盾")
				beltr = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/long
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("钉锤加盾")
				beltr = /obj/item/rogueweapon/mace/steel
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("链枷加盾")
				beltr = /obj/item/rogueweapon/flail/sflail
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			if("卢塞恩锤")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("战斧")
				backr = /obj/item/rogueweapon/stoneaxe/battle
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("骑枪加风筝盾")
				r_hand = /obj/item/rogueweapon/spear/lance
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("弯刀")
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		var/helmets = list(
			"猪面盆盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"卫兵头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"栅栏盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"骑士盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"带面罩萨雷特盔"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"阿米特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"犬首盆盔" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"伊特鲁斯卡盆盔" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"开缝锅盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"库拉胡德盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/zyb,
			"Otava 头盔" = /obj/item/clothing/head/roguetown/helmet/otavan,
			"具装骑兵盔" = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "披挂头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/armors = list(
			"锁子布面甲"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"板片罩衣"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
			"纵槽胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
			"鳞甲"		= /obj/item/clothing/suit/roguetown/armor/plate/scale,
			"具装骑兵甲"	= /obj/item/clothing/suit/roguetown/armor/plate/cataphract,
		)
		var/armorchoice = input(H, "选择你的护甲。", "披挂甲胄") as anything in armors
		armor = armors[armorchoice]
		wretch_select_bounty(H)
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel //gwstraps landing on backr asyncs with backpack_contents
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/datum/advclass/wretch/deserter/maa
	name = "战士"
	tutorial = "无论你为哪一方挥舞武器，到头来你战斗的方式都与你的祖先，以及他们的祖先别无二致：披挂金属，与鲜血和死亡紧紧纠缠。"
	outfit = /datum/outfit/job/roguetown/wretch/desertermaa
	cmode_music = 'sound/music/combat_vigilante.ogg' //Unused by any other class, so may as very well...
	class_select_category = CLASS_CAT_WARRIOR
	// Slightly more rounded. These can be nudged as needed.
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, // Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN, // That saiga was stolen. Probably.
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/wretch/desertermaa/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("战锤与盾","军刀与盾","战斧与盾","钩镰枪","巨斧","戟斧","弩",)
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("战锤与盾")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("军刀与盾")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood
			if("战斧与盾")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("钩镰枪")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("戟斧")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("弩")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("巨斧")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
		var/helmets = list(
		"简易头盔" 		 = /obj/item/clothing/head/roguetown/helmet,
		"锅盔" 		 = /obj/item/clothing/head/roguetown/helmet/kettle,
		"盆盔" 		 = /obj/item/clothing/head/roguetown/helmet/bascinet,
		"萨雷特盔" 		 = /obj/item/clothing/head/roguetown/helmet/sallet,
		"翼盔" 		 = /obj/item/clothing/head/roguetown/helmet/winged,
		"护顶盔"				 = /obj/item/clothing/head/roguetown/helmet/skullcap,
		"Gronn Ownel 头盔" 	 = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
		"钢制希沙克盔" 		 = /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
		"游牧头盔" 			 = /obj/item/clothing/head/roguetown/helmet/nomadhelmet,
		"Grenzelhoft 羽饰帽"  = /obj/item/clothing/head/roguetown/grenzelhofthat,
		"近卫军盔"  = /obj/item/clothing/head/roguetown/helmet/janissaryhelm,
		"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "披挂头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/masks = list(
		"钢面甲" 			= /obj/item/clothing/mask/rogue/facemask/steel,
		"钢制猎犬面甲" 		= /obj/item/clothing/mask/rogue/facemask/steel/hound,
		"荒卫面具" 			= /obj/item/clothing/mask/rogue/wildguard,
		"草原战面" 	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman,
		"草原兽面"	= /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro,
		"无"
		)
		var/maskchoice = input(H, "选择你的面具。", "面具！面具！面具！") as anything in masks // Run from it. MASK. MASK. MASK.
		if(maskchoice != "无")
			mask = masks[maskchoice]

		var/armor_options = list("锁子布面甲套装", "锁子甲套装", "胸甲套装", "Hammerhold 套装", "草原套装", "Gronn 套装", "Grenzelhoft 套装", "Otava 套装")
		var/armor_choice = input(H, "选择你的护甲。", "时髦赴死") as anything in armor_options
		switch(armor_choice)
			if("锁子布面甲套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine
				pants = /obj/item/clothing/under/roguetown/splintlegs
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				gloves = /obj/item/clothing/gloves/roguetown/plate/iron
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("锁子甲套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/chainlegs
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("胸甲套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
				pants = /obj/item/clothing/under/roguetown/chainlegs
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Hammerhold 套装") //It is actually called Gronn in-game, but it's from AP's lore where Gronns are Totally-Not-Vikings, whereas on RW Gronns are Mongols and Hammerholdians are Vikings.
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
				pants = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("草原套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
			if("Gronn 套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/angle
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Grenzelhoft 套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate //Better chest protection but worse limb protection, a fair trade-off.
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				neck = /obj/item/clothing/neck/roguetown/gorget
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
			if("Otava 套装")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan //Better gambeson but your dedicated leg protection is worse.
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted //Actual Otavan plate's AC is heavy.
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				neck = /obj/item/clothing/neck/roguetown/fencerguard
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				gloves = /obj/item/clothing/gloves/roguetown/otavan
			if("Janissary Set")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
				pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
				gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/storage/backpack/rogue/satchel
	if(H.mind)
		var/archetype = list("重装步兵", "轻装步兵", "沼卫/骑兵", "军医", "战法师", "老兵")
		var/archetype_choice = input (H, "选择你的主要训练方向。", "你如何杀人？") as anything in archetype
		switch(archetype_choice)
			if("重装步兵") //Classic Deserter. Master Athletics, Expert Swimming and Expert Shields. Otherwise nothing special.
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				cloak = /obj/item/clothing/cloak/stabard/surcoat
				to_chat(H, span_warning("你受训于密集盾阵之中作战。这让你体格强健，但也没机会学会其他本事。"))
			if("轻装步兵") //Throwing weapons guy. Starts with steel javelins; +1 SPD and -1 STR; Journeyman in Sneaking.
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_STR, -1)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				cloak = /obj/item/clothing/cloak/poachercloak //Maybe you are a former Warden-Forester?
				beltl = /obj/item/quiver/javelin/steel
				l_hand = /obj/item/clothing/head/roguetown/roguehood/poacher
				to_chat(H, span_warning("你受训于松散阵形中作战，以投掷武器和迅疾突袭从远处骚扰敌人。"))
			if("沼卫/骑兵") //TRAIT_EQUESTRIAN, Expert Riding, Leech & Kneestinger Immunity. BOGGUARD LIVES!
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_EXPERT, TRUE)
				if (istype (H.patron, /datum/patron/divine/dendor)) //Dendorites get Expert Swimming instead of redundant immunities.
					H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				else
					ADD_TRAIT(H, TRAIT_LEECHIMMUNE, TRAIT_GENERIC)
					ADD_TRAIT(H, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
				cloak = /obj/item/clothing/cloak/stabard/bog
				to_chat(H, span_warning("你受训于骑术与险地穿行。当地沼泽对你来说与第二故乡无异。"))
			if("军医") //Expert Medicine and a surgery bag. No TRAIT_MEDICINE_EXPERT, so you can't progress past Expert without somebody taking you on as their medicine apprentice.
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)
				cloak = /obj/item/clothing/suit/roguetown/shirt/robe/feld
				beltl = /obj/item/storage/belt/rogue/surgery_bag
				to_chat(H, span_warning("你曾是战地外科医师，是救人者，而非杀人者。可久而久之，你学会了如何夺命，于是两者皆成。"))
			if("战法师") //Wretch Spellblade that's not exclusive to racist elfs! T2 Arcyne, Magearmor, Apprentice Arcyne, 12 spell points, but worse stats -- weighted stat total of +5.
				ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_PER, -1)
				H.mind?.adjust_spellpoints(12)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
				cloak = /obj/item/clothing/cloak/tabard
				to_chat(H, span_warning("你受训于身披沉重甲胄时施展法术的艰难技艺。训练确实见效了，但也几乎没有时间与精力去锻炼体能。"))
			if("老兵") //Master in primary weapon skills and Expert in all other weapon skills except Unarmed, but worse stats -- weighted stat total of +5.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_WIL, -1)
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_PER, -1)
				cloak = /obj/item/clothing/cloak/stabard/surcoat
				to_chat(H, span_warning("你已征战太久，肉体与精神都濒临崩溃，可你的肌肉仍记得每一次挥砍与突刺。最后再战一场……"))
	wretch_select_bounty(H)

	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch/lantern/prelit = 1, /obj/item/rogueweapon/scabbard/sheath = 1)

/obj/effect/proc_holder/spell/invoked/order
	name = ""
	range = 5
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 0
	chargetime = 0
	releasedrain = 80
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'


/obj/effect/proc_holder/spell/invoked/order/retreat
	name = "战术后撤！"
	chargedrain = 0
	chargetime = 0
	desc = "让你的弟兄们获得 3 点速度！"
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/order/retreat/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.retreattext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/retreat)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/retreat/nextmove_modifier()
	return 0.85

/datum/status_effect/buff/order/retreat
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 0.5 / 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/retreat
	name = "战术后撤！！"
	desc = "我的指挥官命令我后撤！"
	icon_state = "buff"

/datum/status_effect/buff/order/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我后撤！"))

/obj/effect/proc_holder/spell/invoked/order/bolster
	name = "稳住战线！"
	desc = "让你的弟兄们获得 2 点体质和 3 点意志！"
	overlay_state = "takeaim"
	chargedrain = 0
	chargetime = 0

/datum/status_effect/buff/order/bolster
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/bolster
	effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 3)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/bolster
	name = "稳住战线！"
	desc = "我的指挥官鼓舞我坚持下去，再多撑一会儿！"
	icon_state = "buff"

/datum/status_effect/buff/order/bolster/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我稳住战线！"))

/obj/effect/proc_holder/spell/invoked/order/bolster/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.bolstertext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/bolster)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/brotherhood
	name = "为了兄弟会！"
	desc = "你的弟兄们暂时感受不到痛苦，也更容易重新站起来！"
	overlay_state = "onfeet"
	chargedrain = 0
	chargetime = 0
/obj/effect/proc_holder/spell/invoked/order/brotherhood/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.brotherhoodtext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/brotherhood)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/brotherhood
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/brotherhood
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/brotherhood
	name = "坚守阵地！"
	desc = "我的指挥官命令我为兄弟会骄傲地站稳脚跟！"
	icon_state = "buff"

/datum/status_effect/buff/order/brotherhood/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我为兄弟会骄傲地站稳脚跟！"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/brotherhood/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
	. = ..()


/obj/effect/proc_holder/spell/invoked/order/charge
	name = "冲锋！"
	desc = "让你的弟兄们获得 2 点力量和 2 点感知！"
	overlay_state = "hold"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/invoked/order/charge/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.holdtext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/charge)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/order/charge
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/charge
	name = "冲锋！"
	desc = "我的指挥官意志已下，现在正是冲锋之时！"
	icon_state = "buff"

/datum/status_effect/buff/order/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我冲锋！为了兄弟会！"))



/mob/living/carbon/human/mind/proc/setorderswretch()
	set name = "预设军令"
	set category = "统御之声"
	mind.retreattext = input("输入一段话。", "战术后撤！！") as text|null
	if(!mind.retreattext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return
	mind.chargetext = input("输入一段话。", "冲啊啊啊啊！！") as text|null
	if(!mind.chargetext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return
	mind.bolstertext = input("输入一段话。", "稳住战线！！") as text|null
	if(!mind.bolstertext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return
	mind.brotherhoodtext = input("输入一段话。", "为了兄弟会，昂首站稳！！") as text|null
	if(!mind.brotherhoodtext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return



/obj/effect/proc_holder/spell/self/convertrole/brotherhood
	name = "招募兄弟会民兵"
	new_role = "Brother"
	overlay_state = "recruit_brotherhood"
	recruitment_faction = "Brother"
	recruitment_message = "从现在起，我们同进共退，%RECRUIT！"
	accept_message = "为了兄弟会！"
	refuse_message = "我拒绝。"

