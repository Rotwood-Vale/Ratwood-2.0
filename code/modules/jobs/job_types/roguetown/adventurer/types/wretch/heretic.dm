/datum/advclass/wretch/heretic
	name = "异端"
	tutorial = "你以最古老、也最经得起考验的方式来扶持自己亵渎的事业：双臂执重钢，周身披重甲。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/heretic
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_HEAVYARMOR)
	maximum_possible_slots = 2 //Ppl dont like heavy armor antags.
	// same stats as templar as you are essentially an antagonist aligned templar with miracles and armor
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 3
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "该子职业获得“疗伤圣迹”奇迹与“引渡失落之人”法术。"

/datum/outfit/job/roguetown/wretch/heretic
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/heretic/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你以最古老、也最经得起考验的方式来扶持自己亵渎的事业：双臂执重钢，周身披重甲。"))
	H.set_blindness(0)
	if(H.mind)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		var/weapons = list("长剑", "钉锤", "链枷", "战斧", "钩镰枪")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		switch(weapon_choice)
			if("长剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/sword/long/oldpsysword
				else
					r_hand = /obj/item/rogueweapon/sword/long
			if("钉锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/mace/goden/psy/old
				else
					r_hand = /obj/item/rogueweapon/mace/steel
			if("链枷")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/flail/sflail/psyflail/old
				else
					beltr = /obj/item/rogueweapon/flail/sflail
			if("战斧")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/stoneaxe/battle/psyaxe/old
				else
					beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
			if("钩镰枪")
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/spear/psyspear/old
				else
					r_hand = /obj/item/rogueweapon/spear/billhook
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)	//Minor regen, starts maxed out.
		wretch_select_bounty(H)

	// You can convert those the church has shunned.
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	backr = /obj/item/rogueweapon/shield/tower/metal
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife
	if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
		backl = /obj/item/storage/backpack/rogue/satchel/otavan
	else
		backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/ritechalk = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
/datum/outfit/job/roguetown/wretch/heretic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/bascinet/pigface, SLOT_HEAD, TRUE)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold, SLOT_HEAD, TRUE)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan, SLOT_HEAD, TRUE)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/guard, SLOT_HEAD, TRUE)
		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold, SLOT_HEAD, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		if(/datum/patron/divine/abyssor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy, SLOT_HEAD, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle, SLOT_HEAD, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		if(/datum/patron/divine/dendor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/volfplate, SLOT_HEAD, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		if(/datum/patron/divine/necra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/guard, SLOT_HEAD, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		if(/datum/patron/divine/pestra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/sallet/visored, SLOT_HEAD, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 3, TRUE)
		if(/datum/patron/divine/eora)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull, SLOT_HEAD, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/knight, SLOT_HEAD, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		if(/datum/patron/divine/ravox)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/bucket, SLOT_HEAD, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		if(/datum/patron/divine/malum)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/sheriff, SLOT_HEAD, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		if(/datum/patron/old_god)
			H.change_stat(STATKEY_WIL, 2) //ENDVRE. You give up useful miracles, rites and miracle-healing from other Heretics, so you'll need this.
			var/heavypsyfashion = list("传统派", "正统派", "改革派") //Only outfits differ.
			var/heavypsyfashion_choice = input(H, "你对祂的信仰为何种模样？", "祂长存，祂忍受，祂死去") as anything in heavypsyfashion
			switch(heavypsyfashion_choice)
				if("传统派") //You look like any other Heretic.
					to_chat(H, span_warning("普赛顿 长存，但祂为我们献出了自己。我们听不见祂，祂也听不见我们，可一切道路终将通向祂，也将由祂回到我们身边。终有一日，普赛顿 会归来，而创造万物也将再度安宁，化作真正的 极乐境。正统教会与圣座早已扭曲了经文与传说。十神只想把世界捏造成自己的模样，不愿帮助我们的主苏醒。与此同时，正统派还假借祂之名说谎，偏离和平之路，让整个世界充满痛苦，而祂借由万物共同感受着这一切，这也拖慢了祂的苏醒。"))
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/bucket, SLOT_HEAD, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/psydon, SLOT_CLOAK, TRUE)
				if("正统派") //You look like an Orthodoxist-Adjudicator. The best set mechanically, but a high risk of getting attacked by your fellow Wretches or Bandits.
					to_chat(H, span_warning("你曾是令人畏惧又遭人憎恨的 奥塔瓦 宗教裁判所一员，如今却躲避着他们，身上仍穿着他们的甲胄。怀旧？怨恨？绝望？……你就是放不下这身制服。"))
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, SLOT_ARMOR, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain/psydon, SLOT_GLOVES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/psydonboots, SLOT_SHOES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/cloak/psydontabard, SLOT_CLOAK, TRUE)
					var/helmets = list("巴布塔盔", "萨雷特盔", "阿米特盔", "桶盔")
					var/helmet_choice = input(H,"选择你的 普赛顿 头盔。", "披挂 普赛顿 之盔") as anything in helmets
					switch(helmet_choice)
						if("巴布塔盔")
							H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute, SLOT_HEAD, TRUE)
						if("萨雷特盔")
							H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet, SLOT_HEAD, TRUE)
						if("阿米特盔")
							H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm, SLOT_HEAD, TRUE)
						if("桶盔")
							H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket, SLOT_HEAD, TRUE)
				if("改革派") //You look like as if somebody dressed Freifechter into a lot of armour. Better chestpiece, but worse gloves and boots, and worse padded gambeson.
					to_chat(H, span_warning ("普赛顿 在与伟大邪恶的战斗后陨落了。但祂仍借由我们而长存，活在我们的记忆与流血的心中。只要我们还活着，祂也将借由我们而长存。万事都应如祂所定，如祂所行，皆以祂之名。"))
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/reform, SLOT_RING, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet, SLOT_HEAD, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/fluted, SLOT_ARMOR, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter, SLOT_SHIRT, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic, SLOT_PANTS, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/angle, SLOT_GLOVES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short, SLOT_SHOES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/cloak/reformtabard, SLOT_CLOAK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half, SLOT_ARMOR, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers, SLOT_WRISTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/armor, SLOT_SHOES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel, SLOT_WEAR_MASK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/gorget, SLOT_NECK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/chainlegs, SLOT_PANTS, TRUE)

/datum/advclass/wretch/heretic/spy
	name = "异端密探"
	tutorial = "无论匕首还是步伐，你都同样轻捷。你是密教组织潜伏于阴影中的使者，他们根本来不及看见你的到来。"
	outfit = /datum/outfit/job/roguetown/wretch/hereticspy
	class_select_category = CLASS_CAT_ROGUE
	maximum_possible_slots = 2 //Ppl dont like rogue antags.
	traits_applied = list(TRAIT_RITUALIST, TRAIT_DODGEEXPERT)
	//Slower than outlaw, but a bit more PER and INT
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)
	extra_context = "该子职业获得“疗伤圣迹”奇迹与“引渡失落之人”法术。"


/datum/outfit/job/roguetown/wretch/hereticspy
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/hereticspy/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
		backl = /obj/item/storage/backpack/rogue/satchel/otavan
	else
		backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	to_chat(H, span_warning("无论匕首还是步伐，你都同样轻捷。你是密教组织潜伏于阴影中的使者，他们根本来不及看见你的到来。"))
	H.cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	if(H.mind)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		var/weapons = list("细剑","匕首", "弓", "弩", "斯勒弩" , "鞭子")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("细剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/rapier
			if("匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special
			if("弓")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltl = /obj/item/quiver/arrows
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("弩")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE) //have to specifically go into bows/crossbows unlike outlaw
				beltr = /obj/item/quiver/bolts
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("斯勒弩") //If Knaves can have one, then so can you. Normal crossbow is a more optimal choice for Heretic Spy.
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/quiver/bolts
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			if("鞭子") //For baothans.
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/whip
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)	//Minor regen, starts maxed out.
		wretch_select_bounty(H)

	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			if(H.mind.current)
				H.mind.current.faction += "[H.name]_faction"
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)

/datum/outfit/job/roguetown/wretch/hereticspy/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		if(/datum/patron/divine/abyssor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		if(/datum/patron/divine/dendor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		if(/datum/patron/divine/necra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		if(/datum/patron/divine/pestra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 3, TRUE)
		if(/datum/patron/divine/eora)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		if(/datum/patron/divine/ravox)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		if(/datum/patron/divine/malum)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
		if(/datum/patron/old_god)
			H.change_stat(STATKEY_WIL, 2) //ENDVRE. You give up useful miracles, rites and miracle-healing from other Heretics, so you'll need this.
			var/lightpsyfashion = list("传统派", "正统派", "改革派")
			var/lightpsyfashion_choice = input(H, "你对祂的信仰为何种模样？", "祂长存，祂忍受，祂死去") as anything in lightpsyfashion
			switch(lightpsyfashion_choice)
				if("传统派") //You look like any other Heretic Spy.
					to_chat(H, span_warning("奥塔瓦 的正统教会已经把信仰扭曲到面目全非。他们崇拜的不是祂，而只是伪造出来的偶像与所谓真神的塑像。回归传统，回归本真。"))
					H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants, SLOT_PANTS, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat, SLOT_ARMOR, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson, SLOT_SHIRT, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/fingerless_leather, SLOT_GLOVES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, SLOT_SHOES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
				if("正统派") //You look like an Orthodoxist-Confessor. The best set mechanically, but a high risk of getting attacked by your fellow Wretches or Bandits.
					to_chat(H, span_warning("你曾是令人畏惧又遭人憎恨的 奥塔瓦 宗教裁判所一员，如今却躲避着他们，身上仍披着他们的长袍。怀旧？怨恨？绝望？……你就是放不下这身制服。"))
					H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/roguehood/psydon/confessor, SLOT_HEAD, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor, SLOT_ARMOR, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/otavan/psygloves, SLOT_GLOVES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/psydonboots, SLOT_SHOES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan, SLOT_PANTS, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed, SLOT_WEAR_MASK, TRUE) //Dark vision but bad. Still better than being entirely blind in the dark.
					//Perceptive players will see past your disguise: you lack the beltpack and the silver signet ring, and your gas mask is lensed from get-go.
				if("改革派") //You look like a Reformist Freifechter.
					to_chat(H, span_warning("神已死去，但祂留下的这个世界依然美丽，仍值得去热爱。别让那些来自 奥塔瓦 的屠夫告诉你不是这样。"))
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half/fencer, SLOT_ARMOR, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter, SLOT_SHIRT, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/fingerless_leather, SLOT_GLOVES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short, SLOT_SHOES, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic, SLOT_PANTS, TRUE)
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/reform, SLOT_RING, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/mortus, SLOT_CLOAK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/ragmask/black, SLOT_WEAR_MASK, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants, SLOT_PANTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants, SLOT_PANTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat, SLOT_ARMOR, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/fingerless_leather, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, SLOT_SHOES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/leather/heavy, SLOT_WRISTS, TRUE)

/obj/effect/proc_holder/spell/invoked/convert_heretic
	name = "引渡失落之人"
	desc = "将一名被逐出教门、遭受诅咒，或被迫背教的灵魂引入你的事业。需要对方自愿，并且施法耗时很长。"
	invocations = list("向这只迷途羔羊显明正道。")
	invocation_type = "whisper"
	sound = 'sound/magic/bless.ogg'
	devotion_cost = 100
	recharge_time = 20 MINUTES
	// Long to prevent combat casting and forcing popups.
	chargetime = 10 SECONDS
	associated_skill = /datum/skill/magic/holy
	overlay_state = "convert_heretic"

/obj/effect/proc_holder/spell/invoked/convert_heretic/cast(list/targets, mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_HERESIARCH))
		to_chat(user, span_warning("你缺乏完成这项仪式所需的知识。"))
		return FALSE

	var/mob/living/carbon/human/target = targets[1]

	if(!ishuman(target))
		revert_cast()
		return FALSE

	//This SHOULD stop most heretics from being convertible and self-curing should they somehow get cursed in the future.
	if(HAS_TRAIT(target, TRAIT_HERESIARCH))
		to_chat(user, span_warning("[target] 已经在为更伟大的事业效力。"))
		revert_cast()
		return FALSE

	if(alert(target, "[user.real_name] 试图将你引渡到其所侍奉的神祇 [user.patron.name] 之下。你接受吗？", "转化请求", "接受", "拒绝") != "接受")
		to_chat(user, span_warning("[target] 拒绝了你的转化提议。"))
		revert_cast()
		return FALSE

	var/absolvable = FALSE
	// Check if target qualifies for absolving
	if(HAS_TRAIT(target, TRAIT_EXCOMMUNICATED))
		absolvable = TRUE

	if(target.has_status_effect(/datum/status_effect/debuff/apostasy))
		target.remove_status_effect(/datum/status_effect/debuff/apostasy)
		absolvable = TRUE

	// Remove from global lists
	if(target.real_name in GLOB.apostasy_players)
		GLOB.apostasy_players -= target.real_name
		absolvable = TRUE
	if(target.real_name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= target.real_name
		absolvable = TRUE

	if(!absolvable)
		to_chat(user, span_warning("[target] 身上并没有教会施加的耻辱印记！"))
		return

	// Remove divine punishments
	target.remove_status_effect(/datum/status_effect/debuff/apostasy)
	target.remove_status_effect(/datum/status_effect/debuff/excomm)
	target.remove_stress(/datum/stressevent/apostasy)
	target.remove_stress(/datum/stressevent/excommunicated)

	// Remove divine curses
	for(var/datum/curse/C in target.curses)
		target.remove_curse(C)

	// Save devotion state if exists
	var/saved_level = CLERIC_T0
	var/saved_max_progression = CLERIC_T1
	var/saved_devotion_gain = CLERIC_REGEN_MINOR

	if(target.devotion)
		saved_level = target.devotion.level
		saved_devotion_gain = target.devotion.passive_devotion_gain
		saved_max_progression = target.devotion.max_progression

		// Remove all granted spells
		if(target.patron != user.patron)
			for(var/obj/effect/proc_holder/spell/S in target.devotion.granted_spells)
				target.mind.RemoveSpell(S)

		target.devotion.Destroy()

	// Change patron
	target.patron = new user.patron.type()
	to_chat(target, span_userdanger("你的灵魂如今属于 [user.patron.name]！"))

	// Grant new devotion
	var/datum/devotion/new_devotion = new /datum/devotion(target, target.patron)
	target.devotion = new_devotion
	new_devotion.grant_miracles(target, saved_level, saved_devotion_gain, saved_max_progression)

	// Final conversion
	ADD_TRAIT(target, TRAIT_HERESIARCH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_ZURCH, TRAIT_GENERIC)
	to_chat(user, span_danger("你已将 [target.name] 转化为 [user.patron.name] 的信徒！"))
	to_chat(target, span_danger("你感到古老的力量正在从你的灵魂上卸去神罚的重担……"))

	return TRUE
