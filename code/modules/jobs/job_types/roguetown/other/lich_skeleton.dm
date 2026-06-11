/*
LICH SKELETONS
*/

/datum/job/roguetown/greater_skeleton/lich
	title = "Fortified Skeleton"
	advclass_cat_rolls = list(CTAG_LSKELETON = 20)
	tutorial = "你早已死去。你的意志属于主人。去完成命令，去屠戮。"

	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich

/datum/outfit/job/roguetown/greater_skeleton/lich
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient
	backr = /obj/item/storage/backpack/rogue/satchel

/datum/outfit/job/roguetown/greater_skeleton/lich/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LICHLAIR, TRAIT_GENERIC) //Ability to leave/enter the lich's lair without being softlocked inside.

// Melee goon w/ throwables. All-rounder.
/datum/advclass/greater_skeleton/lich/legionnaire
	name = "古代军团兵"
	tutorial = "你曾是久经沙场的老兵。如今却沦落至此。"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/legionnaire

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/legionnaire/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 9
	H.STACON = 8
	H.STAWIL = 12
	H.STAINT = 3
	H.STAPER = 11

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient

	r_hand = /obj/item/rogueweapon/shield/gilbranze

	backpack_contents = list(
		/obj/item/natural/feather = 1,
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("短剑","Khopesh 弯刃剑","短剑式直剑","战斧", "链枷")
	var/weapons_choice = input(H, "选择你的武器。", "向生者发怒。") as anything in weapons
	switch(weapons_choice)
		if("短剑")
			l_hand = /obj/item/rogueweapon/sword/short/gladius/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Khopesh 弯刃剑")
			l_hand = /obj/item/rogueweapon/sword/sabre/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("短剑式直剑")
			l_hand = /obj/item/rogueweapon/sword/short/ancient
			beltl = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("战斧")
			l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("链枷")
			l_hand = /obj/item/rogueweapon/flail/sflail/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
	var/sidearms = list("标枪", "投网", "匕首")
	var/sidearms_choice = input(H, "选择你的副武器。", "向生者发怒。") as anything in sidearms
	switch(sidearms_choice)
		if("标枪")
			beltr = /obj/item/quiver/javelin/ancient
		if("投网")
			beltr = /obj/item/net
		if("匕首")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	var/neckwear = list("锁子头巾", "护喉")
	var/neckwear_choice = input(H, "选择你的护颈。", "守护神圣地脉。") as anything in neckwear
	switch(neckwear_choice)
		if("锁子头巾")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("护喉")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("罩袍", "纹章罩衣", "披风", "肩巾")
	var/cloaks_choice = input(H, "选择你的披挂。", "彰显你主人的纹章。") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("罩袍")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("纹章罩衣")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("披风")
			cloak = /obj/item/clothing/cloak/half/lich
		if("肩巾")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

// Ranged goon w/ a dumb bow. Ranger, what else is there to say.
/datum/advclass/greater_skeleton/lich/ballistiares
	name = "古代弩炮兵"
	tutorial = "你的血肉早已从骨架上流尽，指节只剩尖峭白骨，可你的准头依旧分毫不差。"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/ballistiares

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/ballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 6
	H.STAWIL = 12
	H.STAINT = 5
	H.STAPER = 15

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/bows , 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient

	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("反曲弓","紫杉长弓", "十字弩", "投石索")
	var/weapons_choice = input(H, "选择你的武器。", "向生者发怒。") as anything in weapons
	switch(weapons_choice)
		if("反曲弓")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltr = /obj/item/quiver/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
		if("紫杉长弓")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltr = /obj/item/quiver/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
		if("十字弩")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltr = /obj/item/quiver/boltsancient
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
		if("投石索")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltr = /obj/item/quiver/sling/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_MASTER, TRUE)
	var/neckwear = list("锁子头巾", "护喉")
	var/neckwear_choice = input(H, "选择你的护颈。", "守护神圣地脉。") as anything in neckwear
	switch(neckwear_choice)
		if("锁子头巾")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("护喉")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("罩袍", "纹章罩衣", "披风", "肩巾")
	var/cloaks_choice = input(H, "选择你的披挂。", "彰显你主人的纹章。") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("罩袍")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("纹章罩衣")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("披风")
			cloak = /obj/item/clothing/cloak/half/lich
		if("肩巾")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

// Heavy/Tanky goon. Can spec into disciples to be either a slow frontline combatant or a heavy armor wearing line holder.
/datum/advclass/greater_skeleton/lich/bulwark
	name = "古代死之壁垒"
	tutorial = "自始至终，你都在承受最沉重的冲击。即便死后，你也仍将如此。"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/bulwark

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/bulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 11
	H.STASPD = 5
	H.STACON = 11
	H.STAWIL = 11
	H.STAINT = 3
	H.STAPER = 10

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient
	gloves = /obj/item/clothing/gloves/roguetown/plate/ancient

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("巨剑 - +2 力量 / +1 速度 / -3 体质", "巨型权杖 - +2 力量 / +1 速度 / -3 体质", "长矛与盾 - +2 感知 / +1 力量 / -1 体质", "长柄战斧 - +2 感知 / +1 力量 / -1 体质","钉锤与盾 - +3 意志 / 重甲", "战锤与盾 - +3 意志 / 重甲")
	var/weapons_choice = input(H, "选择你的战斗戒律。", "向生者发怒。") as anything in weapons
	switch(weapons_choice)
		if("巨剑 - +2 力量 / +1 速度 / -3 体质")
			l_hand = /obj/item/rogueweapon/greatsword/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, -3)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("巨型权杖 - +2 力量 / +1 速度 / -3 体质")
			l_hand = /obj/item/rogueweapon/mace/goden/steel/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, -3)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("长矛与盾 - +2 感知 / +1 力量 / -1 体质")
			l_hand = /obj/item/rogueweapon/spear/ancient
			r_hand = /obj/item/rogueweapon/shield/gilbranze
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE) // spear and shield is kind of a meme but if you wanna you can go crazy
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, -1)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("长柄战斧 - +2 感知 / +1 力量 / -1 体质")
			l_hand = /obj/item/rogueweapon/halberd/bardiche/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half/ancient
			pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, -1)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("钉锤与盾 - +3 意志 / 重甲")
			l_hand = /obj/item/rogueweapon/mace/steel/ancient
			r_hand = /obj/item/rogueweapon/shield/tower/metal/ancient
			armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
			pants = /obj/item/clothing/under/roguetown/platelegs/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_WIL, 3)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		if("战锤与盾 - +3 意志 / 重甲")
			l_hand = /obj/item/rogueweapon/mace/warhammer/steel/ancient
			r_hand = /obj/item/rogueweapon/shield/tower/metal/ancient
			armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
			pants = /obj/item/clothing/under/roguetown/platelegs/ancient
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_WIL, 3)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	var/neckwear = list("锁子头巾", "护喉")
	var/neckwear_choice = input(H, "选择你的护颈。", "守护神圣地脉。") as anything in neckwear
	switch(neckwear_choice)
		if("锁子头巾")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("护喉")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("罩袍", "纹章罩衣", "披风", "肩巾")
	var/cloaks_choice = input(H, "选择你的披挂。", "彰显你主人的纹章。") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("罩袍")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("纹章罩衣")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("披风")
			cloak = /obj/item/clothing/cloak/half/lich
		if("肩巾")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

// non-Combat crafter goon. Worse weapons + armor but does base-building. Fortnite.
/datum/advclass/greater_skeleton/lich/sapper
	name = "断骨工兵"
	tutorial = "简单。顺从。像蚁群里的一只工蚁。"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/sapper

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 9
	H.STACON = 5
	H.STAWIL = 12 // AND YOU WILL TOIL
	H.STAINT = 6
	H.STAPER = 10

	ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 6, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	pants = /obj/item/clothing/under/roguetown/trou/artipants/lich
	shoes = /obj/item/clothing/shoes/roguetown/sandals/ancient
	gloves = /obj/item/clothing/gloves/roguetown/angle

	backl = /obj/item/storage/backpack/rogue/backpack

	backpack_contents = list(
		/obj/item/rogueweapon/hammer/ancient = 1,
		/obj/item/rogueweapon/tongs/ancient = 1,
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/rogueweapon/handsaw = 1,
		/obj/item/dye_brush = 1
	)

	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	beltl = /obj/item/rogueweapon/pick
	H.adjust_blindness(-3)
	var/neckwear = list("锁子头巾", "护喉")
	var/neckwear_choice = input(H, "选择你的护颈。", "守护神圣地脉。") as anything in neckwear
	switch(neckwear_choice)
		if("锁子头巾")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("护喉")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("罩袍", "纹章罩衣", "披风", "肩巾")
	var/cloaks_choice = input(H, "选择你的披挂。", "彰显你主人的纹章。") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("罩袍")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("纹章罩衣")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("披风")
			cloak = /obj/item/clothing/cloak/half/lich
		if("肩巾")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

	H.energy = H.max_energy

///////////////////////
// SPECIAL SKELETONS //
///////////////////////

// Stronger sidegrade of the Bulwark. Fully armored juggernaut with high Intelligence and Perception for baiting and riposting, but extremely low Speed and complete inability to sprint at all. Crack open the armor, overwhelm and they're dead meat.
// They lack the easily ability to escape fights including no climbing skill, they're tough and will tire you very fast. They have good armor off-the-bat. They're sturdy and difficult to tire but archers/mages/swarms of people will hardcounter them in open ground.
/datum/advclass/greater_skeleton/lich/deathknight
	name = "受崇死骑士"
	tutorial = "闪身，格挡，回击。你致命伤口上的血迹早在数百年前便已干涸，可你的战斗机锋仍未曾有半分蒙尘。披甲执刃，将你主人的骑士道带上战场。"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/deathknight
	maximum_possible_slots = 1 //Limited, but powerful. Could serve as either champions or commanders for their necromancer's army.

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/deathknight/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 16 // ZIZO's strongest skeleton
	H.STASPD = 5 // Slow and can't sprint, if you get surrounded you're cooked
	H.STACON = 9 // A little bit tankier than the average boner
	H.STAWIL = 12 // Hold the line
	H.STAINT = 14
	H.STAPER = 14

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC) // You can't sprint at all
	ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE) // Your flaw is inability to escape, no climbing here

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs/ancient
	gloves = /obj/item/clothing/gloves/roguetown/plate/ancient
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/ancient

	backpack_contents = list(
		/obj/item/natural/feather = 1,
		/obj/item/storage/belt/rogue/pouch/coins/gilbranze = 1
	)

	H.adjust_blindness(-3)
	var/weapons = list("巨剑", "链枷与巨盾")
	var/weapon_choice = input(H, "选择你的武器。", "向生者发怒。") as anything in weapons
	switch(weapon_choice)
		if("巨剑")
			l_hand = /obj/item/rogueweapon/greatsword/ancient
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("链枷与巨盾")
			l_hand = /obj/item/rogueweapon/flail/sflail/ancient
			r_hand = /obj/item/rogueweapon/shield/gilbranze/great
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	var/neckwear = list("锁子头巾", "护喉")
	var/neckwear_choice = input(H, "选择你的护颈。", "守护神圣地脉。") as anything in neckwear
	switch(neckwear_choice)
		if("锁子头巾")
			neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient
		if("护喉")
			neck = /obj/item/clothing/neck/roguetown/gorget/steel/ancient
	var/cloaks = list("罩袍", "纹章罩衣", "披风", "肩巾")
	var/cloaks_choice = input(H, "选择你的披挂。", "彰显你主人的纹章。") as anything in cloaks
	H.set_blindness(0)
	switch(cloaks_choice)
		if("罩袍")
			cloak = /obj/item/clothing/cloak/stabard/surcoat/lich
		if("纹章罩衣")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("披风")
			cloak = /obj/item/clothing/cloak/half/lich
		if("肩巾")
			cloak = /obj/item/clothing/cloak/thief_cloak/lich

//////////////////
// UNIQUE ITEMS //
//////////////////

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	name = "工兵衬衣"
	desc = "一件以粗纺布料与古旧皮革制成的衬衣，穿在那些被判处永世劳作之人的身上。"
	color = "#d6bbbb"

/obj/item/clothing/under/roguetown/trou/artipants/lich
	name = "工兵长裤"
	desc = "一条以古旧皮革与粗纺布料制成的长裤，穿在那些被判处永世劳作之人的身上。"
	color = "#d6bbbb"

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	name = "工兵短衣"
	desc = "一件以坚韧皮革、粗纺布料与毛皮拼成的短衣，穿在那些被判处永世劳作之人的身上。"
	color = "#d6bbbb"

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	name = "古旧兜帽"
	desc = "来自你生前时代之外的粗纺布料，被用来阻隔 阿斯特拉塔 的光辉，不让它照到那些遭她嫌弃之人。"
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/stabard/surcoat/lich
	name = "古旧罩袍"
	desc = "来自你生前时代之外的粗纺布料，披在那些被判处永世行军之人的身上。"
	color = CLOTHING_BLACK
	detail_tag = "_quad"
	detail_color = CLOTHING_BURLAP

/obj/item/clothing/cloak/tabard/lich
	name = "古旧纹章罩衣"
	desc = "来自你生前时代之外的粗纺布料，披在那些曾知晓骑士荣光诱惑之人的身上。"
	color = CLOTHING_BLACK
	detail_tag = "_quad"
	detail_color = CLOTHING_BURLAP

/obj/item/clothing/cloak/half/lich
	name = "古旧披风"
	desc = "来自你生前时代之外的粗纺布料，披在那些畏惧自己真正化为何物之人的身上。"
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/thief_cloak/lich
	name = "古旧肩巾"
	desc = "来自你生前时代之外的粗纺布料，披在那些已接受自己真正枷锁之人的身上。"
	color = CLOTHING_BLACK

// SHIELDS

/obj/item/rogueweapon/shield/gilbranze
	name = "古旧圆盾"
	desc = "标枪与短剑最完美的搭档，一面以吉尔青铜制成、看似轻薄却异常坚固的圆盾。这种合金即便薄如斯时，也曾在耐久上胜过钢铁，可纵使岁月桎梏已解，它也再不会如往昔般闪耀。"
	icon_state = "ancientshlegion"
	dropshrink = 0.8
	force = 15
	throwforce = 25 // DO NOT GIVE ANYTHING; BUT TAKE FROM THEM... EVERYTHING!
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	resistance_flags = null
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 220
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/gilbranze/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = -3,"ey" = 3,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/gilbranze/decrepit
	name = "朽败圆盾"
	desc = "一面近乎违背常理、薄得过分却仍勉强完整的残旧青铜圆盾。可即便如此，只消拇指轻轻一压，也会在其表面留下再难恢复的凹痕。"
	force = 10
	throwforce = 8
	max_integrity = 60
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null

/obj/item/rogueweapon/shield/gilbranze/great
	name = "古旧巨圆盾"
	desc = "一面厚重而庄严的古盾，比同代多数盾牌都更高、更厚，也更为精工。它本可一并挡下箭矢与弩矢 \
	可如今却扭曲地背离了昔日守护生命的职责，成了她麾下军团兵屠戮生命时的壁垒。"
	icon_state = "ancientshgreat"
	force = 30
	throwforce = 10
	throw_speed = 1
	throw_range = 2
	wlength = WLENGTH_NORMAL
	wdefense = 10
	coverage = 75
	minstr = 13
	max_integrity = 400

/obj/item/rogueweapon/shield/gilbranze/great/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = -3,"ey" = 3,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/gilbranze/great/decrepit
	name = "朽败巨圆盾"
	desc = "一面失去光泽、锈蚀斑斑的厚重古盾。它曾熬过不可言说的灾厄与漫长岁月，也曾挡下无数箭矢与弩矢；可如今它不过只是 \
	一块满布凹痕、随时会被撕裂的破烂铁板。它曾辜负旧主，而它自己脆弱的残躯也很快将归于虚无。"
	force = 18
	throwforce = 6
	max_integrity = 180
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
