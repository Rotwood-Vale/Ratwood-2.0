//The League, but in space. Or something.
//Whip-javelin saiga-archer maniacs!
/datum/advclass/foreigner/aavnik
	name = "Aavnik Nitkov"
	tutorial = "A niktov. The slang for one who's done much, against both common good and their fellow man. \
	You're a brigand, of some sort. Perhaps not known, or violent in the same nature as all the others. \
	Yet, all the same, you're outcast from the people you'd once called your own. \
	What could you have done for them to toss you aside? Where had you failed?"
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_STEELHEARTED)
	outfit = /datum/outfit/job/roguetown/adventurer/aavnik
	cmode_music = 'sound/music/combat_league.ogg'
	subclass_languages = list(/datum/language/aavnic)
	subclass_stats = list(//7 skill spread, since STR/SPD count for 2 each.
		STATKEY_PER = 3,
		STATKEY_STR = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
	//Universal skills
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This subclass provides the player with four loadouts. \
	Choosing the path of the saiga provides the Equestrian trait. \
	All others provide medium armour training."

/datum/outfit/job/roguetown/adventurer/aavnik/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	head = /obj/item/clothing/head/roguetown/papakha
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/quiver/javelin/iron
	neck = /obj/item/clothing/neck/roguetown/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/rogueweapon/whip/nagaika,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	if(H.mind)
		var/aavnik_purpose = list("Saiga Archer","Footman","Axeman","Pikeman")
		var/purpose_choice = input(H, "Choose your FALL", "WHY YOU LEFT") as anything in aavnik_purpose
		switch(purpose_choice)
			if("Saiga Archer")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE)
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
				beltl = /obj/item/quiver/arrows
				var/turf/TU = get_turf(H)
				if(TU)
					new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
			if("Footman")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				beltl = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/buckler
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("Axeman")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				backl = /obj/item/rogueweapon/shield/buckler
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("Pikeman")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				r_hand = /obj/item/rogueweapon/spear/boar/aav
				l_hand = /obj/item/rogueweapon/katar/punchdagger/aav
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/advclass/foreigner/shepherd
	name = "Szöréndnížine Shepherd"
	tutorial = "You're a simple shepherd hailing from Aavnr's Free City, taking a pilgrimage or having fled for one reason or another. You can easily fend for yourself in the wilderness, and with enough practice, fend for yourself in combat against even armoured opponents with your traditional axe."
	extra_context = "This class is for experienced adventurers with a solid grasp on footwork and stamina management. Your weapon has special intents you can juggle through to make fights easier... Sometimes."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_languages = list(/datum/language/aavnic)
	outfit = /datum/outfit/job/roguetown/adventurer/freishepherd
	traits_applied = list()
	cmode_music = 'sound/music/frei_shepherd.ogg'
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/freishepherd/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/head/roguetown/armingcap
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flashlight/flare/torch = 1,
						)

/datum/advclass/foreigner/fencerguy
	name = "Foreign Fencer"
	tutorial = "You're an itinerant weapons expert that was trained in a Grenzelhoftian fencing school, carrying with you your weapon, your skillset, your pride... And not much else, frankly."
	extra_context = "This is a freeform class that's meant to evoke a similar feeling to playing a Freifechter, your equipment and skillset is limited compared to other classes - this is by design - but you start with cool weapons."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/fencerguy
	subclass_languages = list(/datum/language/grenzelhoftian)
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_INTELLECTUAL, TRAIT_FENCERDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/adventurer/fencerguy/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You're an itinerant weapons expert that was trained in a Grenzelhoftian fencing school, carrying with you your weapon, your skillset, and your pride."))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Balanced Longsword","Spear & Punch Dagger","Sabre")
		var/weapon_choice = input(H, "Choose your expertise.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Balanced Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/fencerguy
				r_hand = /obj/item/rogueweapon/huntingknife/combat
				backr = /obj/item/rogueweapon/scabbard/sword
			if("Spear & Punch Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/spear/boar
				r_hand = /obj/item/rogueweapon/katar/punchdagger/frei
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre/freifechter
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
				beltr = /obj/item/rogueweapon/scabbard/sword
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	neck = /obj/item/clothing/neck/roguetown/fencerguard/generic
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		)
