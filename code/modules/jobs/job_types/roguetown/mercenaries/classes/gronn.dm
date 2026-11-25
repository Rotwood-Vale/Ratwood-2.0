/datum/advclass/mercenary/gronn/warrior
	name = "Gronnic Nöküd"
	tutorial = "A former raider of the Gronnic steppes, you have decided to leave your past behind, whether to escape your former life, or seek new opportunities; \
	To your employers, you merely call yourself Nöküd - a warrior - nothing more, nothing less. \
	You only hope that your looted equipment and crudely-assembled armor will be enough to keep you alive in the battles to come."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/demihuman) //It is imperative you do not change this.
	outfit = /datum/outfit/job/roguetown/mercenary/gronn/warrior
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_IGNOREDAMAGESLOWDOWN)
	cmode_music = 'sound/music/combat_gronn.ogg'
	subclass_languages = list(/datum/language/gronnic)
	extra_context = "This subclass has 2 loadouts with various stats, skills & equipment."
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

/datum/outfit/job/roguetown/mercenary/gronn/warrior
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/gronn/warrior/pre_equip(mob/living/carbon/human/H)
	..()

	//Universal gear
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/combat = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/pagan
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/pagan
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/pagan
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/pagan
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/pagan
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/pagan
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/pagan/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	if(H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

		var/classes = list("Gronn Kheshig - 'Elite Cavalry'", "Aavar - 'Authentic Steppesman'", "Hammerhold - 'Drakkynborne'")
		var/classchoice = input(H, "Choose your disguise", "WHO DID YOU LOOT FROM LAST?") as anything in classes

		switch(classchoice)
			if("Gronn Kheshig - 'Elite Cavalry'")	//Medium armor, fire poison arrows on horseback or fight them hand-to-hand with your battleaxe.
				H.set_blindness(0)
				to_chat(H, span_warning("You and your warband took the soldiers by surprise, striking them from behind with a flurry of poison-laced arrows - they never saw it coming. You ride their steed and you wear their lamellar scalemail."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
				mask = /obj/item/clothing/mask/rogue/facemask/leather
				gloves = /obj/item/clothing/gloves/roguetown/angle
				armor = /obj/item/clothing/suit/roguetown/armor/kurche
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
				wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				backr = /obj/item/rogueweapon/stoneaxe/battle
				beltr = /obj/item/quiver/poisonarrows
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				neck = /obj/item/clothing/neck/roguetown/leather
				H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
				H.change_stat(STATKEY_PER, 3)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_SPD, 2)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_INT, -1) //Raiders aren't known for their intellect.
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior
			if("Aavar - 'Authentic Steppesman'")	//Light armor, Nagaika whip or a sabre.
				H.set_blindness(0)
				to_chat(H, span_warning("Easy pickings - the raiders of Gronn are infamous for the pillaging of Aavar for a reason; following the onslaught, you took a few spoils from a saiga-rider for yourself before splitting off."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
				neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
				backr = /obj/item/rogueweapon/shield/iron
				mask = /obj/item/clothing/mask/rogue/spectacles/duelist/steel
				H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)		//Bit high but he doesn't get huge strength boons so makes up for it. Same as a guard.
				H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil //Dodge builds are evil
				var/weapons = list("Nagaika Whip", "Sabre")
				var/weapon_choice = input("Choose your weapon.", "WHAT DID YOU STEAL?") as anything in weapons
				switch(weapon_choice)
					if("Nagaika Whip")//Funny banner weapon & punchdagger, with whip I suppose.
						r_hand = /obj/item/rogueweapon/whip/nagaika
						l_hand = /obj/item/rogueweapon/katar/punchdagger/aav
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)		//Use of the weapon.
					if("Sabre")//Or boring flail and buckler, whip.
						beltl= /obj/item/rogueweapon/scabbard/sword
						beltr = /obj/item/rogueweapon/shield/iron/steppesman
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)	//Old whip skill.
			if("Hammerhold - 'Drakkynborne'")	//Plate armor and a banded iron sword. NEVER SHOULD'VE COME HERE!!
				H.set_blindness(0)
				to_chat(H, span_warning("'Never should have come here!', was the last thing they heard before you gruesomely spilt their entrails; you'd make better use of their possessions than they did, anyway."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
				head = /obj/item/clothing/head/roguetown/helmet/sallet/iron/banded
				gloves = /obj/item/clothing/gloves/roguetown/plate/iron/banded
				armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/stolen
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				pants = /obj/item/clothing/under/roguetown/splintlegs/iron
				neck = /obj/item/clothing/neck/roguetown/bevor/iron
				mask = /obj/item/clothing/mask/rogue/facemask/maille
				beltr = /obj/item/rogueweapon/sword/short/iron/banded
				backr = /obj/item/rogueweapon/shield/iron
				beltl= /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 2, TRUE)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_WIL, 3)
				H.change_stat(STATKEY_STR, 2)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil //Dodge builds are evil
	H.merctype = 19

/datum/advclass/mercenary/gronn/heavy
	name = "Kheshig Bahadur"
	tutorial = "You are a member of the Kheshig: An order of proven warriors trained and sent out from Gronn to bring glory to the realm - at least, you are in name; \
	in truth, you were merely a Gronnic raider, now taking the guise of a sellsword to avoid your past misdeeds. \
	The cobbled-together and stolen armaments you bear may arouse suspicion from educated observers, but your employers seem conveniently oblivious - perhaps they prefer not to know the truth."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/human/northern, /datum/species/halforc, /datum/species/demihuman)
	maximum_possible_slots = 1 //The weapons and armor given to this subclass warrant it being limited to one slot.
	outfit = /datum/outfit/job/roguetown/mercenary/gronn/heavy
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_OUTDOORSMAN, TRAIT_NOPAINSTUN, TRAIT_BARBARICFIGHTER, TRAIT_IGNOREDAMAGESLOWDOWN)
	cmode_music = 'sound/music/combat_gronn.ogg'
	subclass_languages = list(/datum/language/gronnic)
	extra_context = "This subclass includes a unique weapon and specialized combat techniques."
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2, 
		STATKEY_PER = 1,
		STATKEY_CON = 3,
		STATKEY_SPD = -1 //SLOW AND UNWIELDY
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/gronn/heavy
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/gronn/heavy/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aventail/gronn
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/banded
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/banded
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron //Weakspot.
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	mask = /obj/item/clothing/mask/rogue/sack
	r_hand = /obj/item/rogueweapon/greataxe/poleaxe/saigasplitter
	cloak = /obj/item/clothing/cloak/volfmantle/shoulderpad/leather
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	beltr = /obj/item/quiver/bodkin

	if(H.mind)
		var/weapons = list("SAIGASPLITTER", "SAWTOOTH SLABSWORD")
		var/weapon_choice = input(H, "MY INSEPARABLE ARMAMENT.", "WHAT HAVE YOU COBBLED TOGETHER?") as anything in weapons
		switch(weapon_choice)
			if("SAIGASPLITTER")
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				r_hand = /obj/item/rogueweapon/greataxe/poleaxe/saigasplitter
			if("SAWTOOTH SLABSWORD")
				r_hand = /obj/item/rogueweapon/sword/long/exe/sawtooth

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/pagan
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/pagan
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/pagan
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/pagan
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/pagan
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/pagan
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/pagan/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/combat = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)

	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

	H.merctype = 19
