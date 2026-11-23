/datum/advclass/mercenary/rumaclan
	name = "Ruma Clan Gun-in"
	tutorial = "A swordfighter from a band of Kazengite foreigners. The Ruma Clan were outcasts from the Xinyi Dynasty, believed to be associated with the rebels at the time. The clan departed to avoid repercussion. It is no organized group of soldiers, but rather a loose collection of experienced fighters."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_BUT_BLOODLESS_DWARF //no dwarf sprites
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_HARDDISMEMBER, TRAIT_NOPAINSTUN)
	cmode_music = 'sound/music/combat_Kazengun_Runaway_Chariot.ogg'
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "This subclass is race-limited from: Dwarves."

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a swordfighter of the Clan, peerless with a blade. So long as the coin is good, you have no problem taking up most jobs on behalf of either yourself, your leading Seonjang, or the Clan as a whole."))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/steel
	beltl = /obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
	cloak = /obj/item/clothing/cloak/eastcloak1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1, 

		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/tattoos = list("Defiant (Blacksteel, fragile)","Harmonious (Plate, balanced)","Enduring (Padded, durable)")
		var/tattoo_choice = input(H, "Choose your tattoos", "WHAT MARKS DO YOU CARRY?") as anything in tattoos
		switch(tattoo_choice)
			if("Defiant (Blacksteel, fragile)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/blacksteel //200 blacksteel
			if("Harmonious (Plate, balanced)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma //250 plate
			if("Enduring (Padded, durable)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/padded //300 padded
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE) //you're going to need it.
		var/clothing = list("White Shirt","Dark Shirt", "Bare-Chested")
		var/clothing_choice = input(H, "Choose your attire.", "WHAT SILK SWATHES YOU?") as anything in clothing
		switch(clothing_choice)
			if("White Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
			if("Dark Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
			if("Bare-Chested")
				shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/easttats/ruma //light brigadine.

/datum/advclass/mercenary/rumaclan/sasu
	name = "Ruma Clan Sasu"
	tutorial = "An archer from a band of Kazengite foreigners. The Ruma Clan were outcasts from the Xinyi Dynasty, believed to be associated with the rebels at the time. The clan departed to avoid repercussion. It is no organized group of soldiers, but rather a loose collection of experienced fighters."
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan_sasu
	subclass_stats = list(
		STATKEY_SPD = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are an archer of the Clan, matchless with a bow. So long as the coin is good, you have no problem taking up most jobs on behalf of either yourself, your leading Seonjang, or the Clan as a whole."))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/arrows
	beltl = /obj/item/flashlight/flare/torch/lantern
	cloak = /obj/item/clothing/cloak/eastcloak1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
		/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/tattoos = list("Defiant (Blacksteel, fragile)","Harmonious (Plate, balanced)","Enduring (Padded, durable)")
		var/tattoo_choice = input(H, "Choose your tattoos", "WHAT MARKS DO YOU CARRY?") as anything in tattoos
		switch(tattoo_choice)
			if("Defiant (Blacksteel, fragile)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/blacksteel //200 blacksteel
			if("Harmonious (Plate, balanced)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma //250 plate
			if("Enduring (Padded, durable)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/padded //300 padded
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE) //you're going to need it.
		var/clothing = list("White Shirt","Dark Shirt", "Bare-Chested")
		var/clothing_choice = input(H, "Choose your attire.", "WHAT SILK SWATHES YOU?") as anything in clothing
		switch(clothing_choice)
			if("White Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
			if("Dark Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
			if("Bare-Chested")
				shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/easttats/ruma //light brigadine.
