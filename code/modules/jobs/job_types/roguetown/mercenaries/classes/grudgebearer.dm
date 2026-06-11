//Dwarf-exclusive mercenary class with unique armor setups.
/datum/advclass/mercenary/grudgebearer
	name = "负怨铸匠"
	tutorial = "背负着万古未消的宿怨，负怨者被迫流落地表，因为几乎每一个氏族都与你们结怨，而你们也同样痛恨他们。这片腐臭如沼泽的大公国也曾伤害过你和你的族人，你根本不在乎它。金钱不过是达成目的的手段，矿石与钢铁你自己就能开采锻造。真正能为你在族中赢得尊重的，是出自名匠之手的器物。只是，这些杰作未必能换来食物或栖身之所。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain
	)
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_dwarf.ogg'
	extra_context = "该分支仅限矮人选择。"
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_TRAINED_SMITH, TRAIT_STEELHEARTED, TRAIT_SMITHING_EXPERT) // Another one off exception for a combat role
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 3,//Anvil"Strikes deftly" is based on PER
		STATKEY_STR = 1,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,	//Shouldn't be better than the smith (though the stats are already)
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

//Because the armor is race-exclusive for repairs, these guys *should* be able to repair their own guys armor layers. A Dwarf smith isn't guaranteed, after all.
/datum/outfit/job/roguetown/mercenary/grudgebearer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
		belt = /obj/item/storage/belt/rogue/leather/black
		beltr = /obj/item/rogueweapon/mace
		beltl = /obj/item/flashlight/flare/torch
		backl = /obj/item/storage/backpack/rogue/backpack
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		gloves = /obj/item/clothing/gloves/roguetown/plate/dwarven
		pants = /obj/item/clothing/under/roguetown/trou/leather
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
		backpack_contents = list(
			/obj/item/roguekey/mercenary,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/hammer/iron,
			/obj/item/paper/scroll/grudge,
			/obj/item/natural/feather,
			/obj/item/rogueweapon/tongs = 1,
			)
		var/weapons = list("巨型权杖", "尖刺重槌")
		var/wepchoice = input("选择你的武器。", "可选武器") as anything in weapons
		switch(wepchoice)
			if("巨型权杖")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("尖刺重槌")
				r_hand = /obj/item/rogueweapon/mace/maul/spiked
				backr = /obj/item/rogueweapon/scabbard/gwstrap
		H.merctype = 8

/datum/advclass/mercenary/grudgebearer/soldier
	name = "负怨战士"
	tutorial = "背负着万古未消的宿怨，负怨者被迫流落地表，因为几乎每一个氏族都与你们结怨，而你们也同样痛恨他们。这片腐臭如沼泽的大公国也曾伤害过你和你的族人，你根本不在乎它。金钱不过是达成目的的手段，矿石与钢铁你自己就能开采锻造。真正能为你在族中赢得尊重的，是出自名匠之手的器物。只是，这些杰作未必能换来食物或栖身之所。"
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer_soldier
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 4,
		STATKEY_STR = 2,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,	//Only here so they'd be able to repair their own armor integrity
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/mercenary/grudgebearer_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
		belt = /obj/item/storage/belt/rogue/leather/black
		beltl = /obj/item/flashlight/flare/torch
		backl = /obj/item/storage/backpack/rogue/satchel
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		gloves = /obj/item/clothing/gloves/roguetown/plate/dwarven
		pants = /obj/item/clothing/under/roguetown/trou/leather
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven
		backpack_contents = list(
			/obj/item/roguekey/mercenary,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/hammer/iron,
			/obj/item/paper/scroll/grudge,
			/obj/item/natural/feather,
			)
		if(H.mind)
			var/weapons = list("战斧", "巨型权杖", "重槌")
			var/wepchoice = input(H, "选择你的武器。", "可选武器") as anything in weapons
			switch(wepchoice)
				if("战斧")
					backr = /obj/item/rogueweapon/stoneaxe/battle
				if("巨型权杖")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("重槌")
					r_hand = /obj/item/rogueweapon/mace/maul/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
		H.merctype = 8


/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
	name = "负怨者矮人板甲"
	desc = "一套许多矮人战士都会穿戴的标准层叠板甲。若没有与生俱来的矮人工艺知识，便无法对它动工修整。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfchest"
	item_state = "dwarfchest"
	armor = ARMOR_GRUDGEBEARER
	prevent_crits = list(BCLASS_TWIST)
	body_parts_covered = CHEST|GROIN|VITALS|ARMS|LEGS
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	equip_delay_other = 4 SECONDS
	strip_delay = 12 SECONDS
	smelt_bar_num = 4
	max_integrity = 1000	//They have their own unique integrity

/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer)

/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
	name = "负怨者板条铁围"
	desc = "一件由板甲与锁甲层叠构成的标准护具，许多矮人工匠都会穿戴。 \
	若没有与生俱来的矮人工艺知识，便无法对它动工修整。"
	icon_state = "dsmithchest"
	item_state = "dsmithchest"
	armor_class = ARMOR_CLASS_MEDIUM
	body_parts_covered = CHEST|GROIN|VITALS|LEGS
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven
	name = "负怨者矮人头盔"
	desc = "一顶结实耐用的层叠头盔，还特意给矮人的胡须留出了探出来的位置。"
	body_parts_covered = (HEAD | MOUTH | NOSE | EYES | EARS | NECK)	//This specifically omits hair so you could hang your beard out of the helm
	armor = ARMOR_GRUDGEBEARER
	prevent_crits = list(BCLASS_TWIST)
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "dwarfhead"
	item_state = "dwarfhead"
	block2add = FOV_BEHIND
	bloody_icon = 'icons/effects/blood64.dmi'
	smeltresult = /obj/item/ingot/steel
	max_integrity = 1000
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer/helmet)

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
	name = "负怨者匠师头盔"
	desc = "一顶结实耐用的层叠头盔，还特意给矮人的胡须留出了探出来的位置。 \
	这一顶是为氏族铁匠打造的，防护丝毫不差，样式却更体面。"
	icon_state = "dsmithhead"
	item_state = "dsmithhead"

/obj/item/clothing/gloves/roguetown/plate/dwarven
	name = "负怨者矮人臂铠"
	desc = "专为最粗短的手指锻造，外覆多层防护。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	prevent_crits = list(BCLASS_TWIST)
	icon_state = "dwarfhand"
	item_state = "dwarfhand"
	armor = ARMOR_GRUDGEBEARER
	max_integrity = 1000

/obj/item/clothing/gloves/roguetown/plate/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer/limbs)

/obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	name = "负怨者矮人战靴"
	desc = "迈步时铿锵作响，外覆多层防护。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	prevent_crits = list(BCLASS_TWIST)
	icon_state = "dwarfshoe"
	item_state = "dwarfshoe"
	armor = ARMOR_GRUDGEBEARER
	max_integrity = 1000

/obj/item/clothing/shoes/roguetown/boots/armor/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer/limbs)

/datum/component/layeredarmor/grudgebearer
	layer_repair = 2

	layer_max = list(
		"blunt" = 40,
		"slash" = 200,
		"stab" = 200,
		"piercing" = 100,
	)

	hits_to_shred = list(
		"blunt" = 3,
		"slash" = 3,
		"stab" = 3,
		"piercing" = 5,
	)

	damtype_shred_ratio = list(
		"blunt" = 1,
		"slash" = 1,
		"stab" = 1,
		"piercing" = 5,
	)

	hits_per_layer = list(
		"200"	= 3,
		"100" 	= 3,
		"90" 	= 3,
		"80" 	= 5,
		"70" 	= 5,
		"60" 	= 5,
		"50"	= 10,
		"40"	= 10,
		"30"	= 20,
		"20"	= 30,
		"10"	= 50,
	)

	repair_items = list(/obj/machinery/anvil)

	repair_skills = list(
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
	)

	race_repair = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain,
	)

/datum/component/layeredarmor/grudgebearer/helmet

/datum/component/layeredarmor/grudgebearer/limbs
	hits_to_shred = list(
		"blunt" = 2,
		"slash" = 2,
		"stab" = 2,
		"piercing" = 2,
	)

	layer_max = list(
		"blunt" = 40,
		"slash" = 200,
		"stab" = 200,
		"piercing" = 90,
	)

	hits_per_layer = list(
		"200"	= 2,
		"100" 	= 2,
		"90" 	= 2,
		"80" 	= 2,
		"70" 	= 2,
		"60" 	= 2,
		"50"	= 2,
		"40"	= 2,
		"30"	= 4,
		"20"	= 20,
		"10"	= 30,
	)

	shred_amt = 20	//Limbs lose 2 grades per layer shred, but also repair 4.
	layer_repair = 2
