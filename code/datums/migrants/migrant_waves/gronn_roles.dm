/datum/migrant_role/gronn/chieftain
	name = "Gronn酋长"
	greet_text = "你是部族的领袖。带领他们走向荣耀，或至少设法活下去。"
	outfit = /datum/outfit/job/roguetown/gronn/chieftain
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi) //we'll see how this goes. Carl/Chocobo can shoot this shit down.
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/gronn
	allowed_patrons = list(/datum/patron/inhumen/graggar)

/datum/outfit/job/roguetown/gronn/chieftain/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/gorget		//You're the big honcho, may as well
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/kurche
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/scabbard/sheath/royal
	beltr = /obj/item/rogueweapon/stoneaxe/battle
	r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	l_hand = /obj/item/quiver/arrows
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1
		)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)  // only affects drawtime. They get no PER buff, come on.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_INT, -1)
	H.change_stat(STATKEY_LCK, 1)  //Graggar favors your little buttcheeks.

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("我可以在发言前加上 ,n 来说 Gronnic 语。"))

//Shaman
/datum/migrant_role/gronn/shaman
	name = "Gronn萨满"
	greet_text = "你是部族中最睿智、很可能也是最年长的人。你与 Graggah 沟通，释放神圣之力，也照料部族中的伤者。"
	outfit = /datum/outfit/job/roguetown/gronn/shaman
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/gronn/shaman/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	neck = /obj/item/clothing/neck/roguetown/leather	//leather gorget just in case. Ur Da Second Big Honcho.
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron	//U Gon Punch Good.
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron	//for parrying while unarmed
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full/improv
	backpack_contents = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle, /obj/item/rogueweapon/handclaw/gronn, /obj/item/rogueweapon/scabbard/sheath)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)  //May be too much, may not be too much. Can be nerfed. Arcyne is gone in favor of something close to the shaman merc
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_INT, 2)

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)	//this guy can SNAP HIS FINGERS and LIGHT A FIRE???
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/lesser_heal)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)	//Minor regen, can level up to T3.

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("我可以在发言前加上 ,n 来说 Gronnic 语。"))

//Warrior
/datum/migrant_role/gronn/warrior
	name = "Gronn战士"
	greet_text = "你是精锐中的精锐，是部族最优秀的战士。你与酋长并肩作战，并确保他能活下来。"
	outfit = /datum/outfit/job/roguetown/gronn/warrior
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/gronn/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/rogueweapon/stoneaxe/handaxe
	backpack_contents = list(/obj/item/rogueweapon/scabbard/sheath/noble)
	var/weaponroll = rand(1, 80)  //did I tell you guys I like gambling?
	switch(weaponroll)
		if(1 to 20)
			r_hand = /obj/item/rogueweapon/halberd/bardiche
		if(21 to 40)
			r_hand = /obj/item/rogueweapon/greataxe
		if(41 to 60)
			r_hand = /obj/item/rogueweapon/halberd/bardiche/ancient  // Literally just a cooler bardiche.
		if(61 to 80)
			r_hand = /obj/item/rogueweapon/greataxe  //50/50 between greataxe or a bardiche.
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_INT, -2)

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("我可以在发言前加上 ,n 来说 Gronnic 语。"))

//Tribal
/datum/migrant_role/gronn/tribal
	name = "Gronn部族民"
	greet_text = "你是部族中的大多数。你擅长弓与斧，或长矛，也非常适应靠这片土地生存。"
	outfit = /datum/outfit/job/roguetown/gronn/tribal
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/goblinp, /datum/species/tieberian, /datum/species/lizardfolk, /datum/species/lupian, /datum/species/anthromorph, /datum/species/demihuman, /datum/species/dwarf/mountain, /datum/species/dracon, /datum/species/tabaxi)
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/gronn/tribal/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/hatfur
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	armor = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(/obj/item/rogueweapon/scabbard/sheath)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_INT, -2)
	H.change_stat(STATKEY_SPD, 1)
	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("我可以在发言前加上 ,n 来说 Gronnic 语。"))

	H.adjust_blindness(-3)
	if(H.mind)
		var/classes = list("部族民", "猎手")
		var/classchoice = input(H, "选择你的原型", "可选原型") as anything in classes
		
		switch(classchoice)
			if("部族民")
				H.set_blindness(0)
				to_chat(H, span_warning("你是一名部族民，骑着 Saiga 与大部队同行，手持长矛与斧头。虽然你不像猎手那样外出搜集与追猎猎物，但你知道如何建造并协助搭建营地。"))
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut
				l_hand = /obj/item/rogueweapon/spear/bonespear
				H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("猎手")
				H.set_blindness(0)
				to_chat(H, span_warning("你是一名猎手，无论是骑着 Saiga 随大部队冲锋作战，向眼前可怜的敌人射出箭矢，还是在行军途中狩猎以养活整个部族，这些都是你的职责。"))
				beltr = /obj/item/rogueweapon/stoneaxe/boneaxe
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				l_hand = /obj/item/quiver/arrows
				H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
//Slave
/datum/migrant_role/gronn/slave
	name = "Gronn奴隶"
	greet_text = "你是个倒霉的家伙，也许在一场劫掠中被抓，也许独自在荒野中落单。你已被这个部族奴役，努力劳作去取悦你的新主人吧。"
	outfit = /datum/outfit/job/roguetown/gronn/slave
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	show_wanderer_examine = FALSE

/datum/outfit/job/roguetown/gronn/slave/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/cursed_collar
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/flint
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE) // can mend the wounded a bit.
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 2)

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'


	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("我可以在发言前加上 ,n 来说 Gronnic 语。"))

	H.adjust_blindness(-3)
	if(H.mind)
		var/classes = list("被俘工人", "被俘匠人","被俘贵族","被俘吟游诗人")
		var/classchoice = input(H, "选择你的原型", "可选原型") as anything in classes
		
		switch(classchoice)
			if("被俘工人")
				H.set_blindness(0)
				to_chat(H, span_warning(""))
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
				r_hand = /obj/item/rogueweapon/pitchfork
				l_hand = /obj/item/rogueweapon/pick

				H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
				H.adjust_skillrank(/datum/skill/labor/mining, 2, TRUE)
				H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)

			if("被俘匠人")
				H.set_blindness(0)
				to_chat(H, span_warning(""))

				beltr = /obj/item/rogueweapon/hammer/iron
				beltl = /obj/item/rogueweapon/tongs
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
				cloak = /obj/item/clothing/cloak/apron/blacksmith
				pants = /obj/item/clothing/under/roguetown/trou
				backl = /obj/item/storage/backpack/rogue/backpack
				backr = /obj/item/rogueweapon/scabbard/sheath

				backpack_contents = list(
					/obj/item/flint = 1,
					/obj/item/rogueore/coal = 4,
					/obj/item/rogueore/iron = 5,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/recipe_book/blacksmithing = 1,
					/obj/item/recipe_book/survival = 1,
					/obj/item/armor_brush = 1,
					/obj/item/polishing_cream = 1
					)

				H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/armorsmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/engineering, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/ceramics, 2, TRUE)

			if("被俘贵族")
				H.set_blindness(0)
				to_chat(H, span_warning(""))
				id = /obj/item/clothing/ring/silver
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/red
					shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
					pants = /obj/item/clothing/under/roguetown/tights/black
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
					cloak = /obj/item/clothing/cloak/raincloak/purple
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
				H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)

				H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)							
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)

			if("被俘吟游诗人")
				H.set_blindness(0)
				to_chat(H, span_warning(""))
				cloak = /obj/item/clothing/cloak/half
				pants = /obj/item/clothing/under/roguetown/tights/random
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/rogue/instrument/lute = 1,
					/obj/item/rogue/instrument/flute = 1,
					/obj/item/rogue/instrument/drum = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
				H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)

				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
				var/datum/inspiration/I = new /datum/inspiration(H)
				I.grant_inspiration(H, bard_tier = BARD_T3)
