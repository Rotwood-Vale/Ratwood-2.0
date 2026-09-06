//Parent of the foreign classes. This is gross, but some genius pathed it all to the ruma slop.
//I'm another genius and too lazy to work around it.
/datum/advclass/foreigner
	name = "Eastern Warrior"
	tutorial = "A warrior hailing from the distant land of Kazengun, far across the eastern sea."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES // Clothing has no dwarf sprites.
	outfit = /datum/outfit/job/roguetown/adventurer/kazengun
	class_select_category = CLASS_CAT_NOMAD
	traits_applied = list(TRAIT_STEELHEARTED)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_languages = list(/datum/language/kazengunese)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/kazengun/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("A warrior hailing from the distant land of Kazengun, far across the eastern sea."))
	head = /obj/item/clothing/head/roguetown/mentorhat
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern,
		)
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Naginata","Quarterstaff","Hwando")
		var/weapon_choice = input(H, "Choose your weapon", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Naginata")
				r_hand = /obj/item/rogueweapon/spear/naginata
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
			if("Quarterstaff")
				backr = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
			if("Hwando")
				beltl = /obj/item/rogueweapon/sword/sabre/mulyeog
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)

/datum/advclass/foreigner/yoruku
	name = "Eastern Assassin"
	tutorial = "The Yoruku are Kazengun agents trained in assassination, sabotage, and irregular combat. You are armed with daggers or a short sword, perfect \
	for combat in the tight confines of castles and back alleys."
	allowed_races = NON_DWARVEN_RACE_TYPES //Clothing has no dwarf sprites.
	outfit = /datum/outfit/job/roguetown/adventurer/yoruku
	subclass_languages = list(/datum/language/kazengunese)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/yoruku/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("The Yoruku are Kazengun agents trained in assassination, sabotage, and irregular combat. You are armed with daggers or a short sword, perfect \
	for combat in the tight confines of castles and back alleys."))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/bomb/smoke = 3,
		)
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	cloak = /obj/item/clothing/cloak/thief_cloak/yoruku
	shoes = /obj/item/clothing/shoes/roguetown/boots
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Tanto","Kodachi")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Tanto")
				beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
				beltl = /obj/item/rogueweapon/scabbard/sheath/kazengun
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			if("Kodachi")
				beltr = /obj/item/rogueweapon/sword/short/kazengun
				beltl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		var/masks = list("Oni","Kitsune")
		var/mask_choice = input(H, "Choose your mask.", "HIDE YOURSELF") as anything in masks
		switch(mask_choice)
			if("Oni")
				mask = /obj/item/clothing/mask/rogue/facemask/yoruku_oni
			if("Kitsune")
				mask = /obj/item/clothing/mask/rogue/facemask/yoruku_kitsune
