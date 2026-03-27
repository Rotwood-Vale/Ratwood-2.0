//Psydonic-exclusive 1-slot gunslinger. Gets a gun of choice, a special item to summon disposable one-use pistols, and can choose two relics.
//Mediocre statblock and poor skills, so reliant on their weapon and relics to get anything done.
/datum/advclass/wretch/renegade
	name = "Renegade Inquisitor"
	tutorial = "Once a respected puritan of the Otavan Orthodoxy, disappointed in the Inquisition or having found your own way to serve HIM, you have left your sect behind. \
	But it's not for desertion alone those who you once served seek to put you to death. Before you left, you took a rare firearm and several valuable relics as parting gifts. \
	Now, driven by newfound zealotry, greed, vengeance or desire for justice, you right wrongs, one bullet at a time."
	allowed_races = RACES_NO_CONSTRUCT //Same as Inquisitor's.
	outfit = /datum/outfit/job/roguetown/wretch/renegade
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/inquisitorcombat.ogg'
	class_select_category = CLASS_CAT_RANGER
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_BLACKBAGGER, TRAIT_FUSILIER, TRAIT_ZOMBIE_IMMUNE, TRAIT_DODGEEXPERT)
	maximum_possible_slots = 1 //Snowflake class with guns and some unusual items.
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 2
	) //+9 weighted stat total.
	subclass_skills = list(
		/datum/skill/combat/firearms = SKILL_LEVEL_EXPERT, //I wanted to give this class LEGENDARY in firearms, but it made them aim near instantly.
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN, // Back-up if you lose your primary gun.
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, // You can fight upclose, but your stats aren't well-suited for it.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wretch/renegade
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/renegade/pre_equip(mob/living/carbon/human/H)
	H.set_patron(/datum/patron/old_god)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Piss-weak Devotion, just for ENDURE miracle and TRAIT_PSYDONITE.
	head = /obj/item/clothing/head/roguetown/helmet/leather/advanced/renegadetricorn // Hardened leather helmet reskin.
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/renegade
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/renegade
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/powderflask
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1, // Can't heal using Miracles, so you get a vial of STRONG health potion instead.
	)
	if(H.mind)
		var/guns = list("Pistol", "Arquebus", "Blunderbuss", "Handgonne")
		var/guns_choice = input(H, "Choose your firearm.", "THE SMELL OF SULFUR") as anything in guns
		switch(guns_choice)
			if("Pistol")
				l_hand = /obj/item/gun/ballistic/firearm/arquebus_pistol
				beltl = /obj/item/quiver/bullet/lead
			if("Arquebus")
				l_hand = /obj/item/gun/ballistic/firearm/arquebus
				beltl = /obj/item/quiver/bullet/lead
			if("Blunderbuss")
				l_hand = /obj/item/gun/ballistic/firearm/blunderbuss
				beltl = /obj/item/quiver/bullet/grapeshot
			if("Handgonne")
				l_hand = /obj/item/gun/ballistic/firearm/handgonne
				beltl = /obj/item/quiver/bullet/lead
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/wretch/renegade/choose_loadout(mob/living/carbon/human/H)
	if(H.mind)
		var/turf/TU = get_turf(H) // We'll spawning the chosen relics on the character's tile. Let them figure out inventory management on their own.
		var/relic_count = 2
		var/relics = list("Matrimony (Rapier)", "Skeleton Key", "Cerulean Tear (Player Minion)", "Ring of Chameleon", "Vial of Eoran Balm (x3)", "Bombdolier & Grenades", "Drow Screaming Bell", "PSYDON's Music Box (Replica)")
		if(TU) // Safety.
			for(var/i in 1 to relic_count) //This is really messy and unoptimised. Please, somebody come up with a better solution.
				var/relic_choice = input(H, "Choose your relic.", "[relic_count] CHOICES REMAIN") as anything in relics
				switch(relic_choice)
					if("Matrimony (Rapier)")
						new /obj/item/rogueweapon/sword/rapier/evil(TU)
						new /obj/item/rogueweapon/scabbard/sword(TU)
						relics -= "Matrimony (Rapier)"
						relic_count--
					if("Skeleton Key")
						new /obj/item/skeleton_key(TU)
						relics -= "Skeleton Key"
						relic_count--
					if("Cerulean Tear (Player Minion)")
						new /obj/item/renegade_relics/life_crystal(TU)
						relics -= "Cerulean Tear (Player Minion)"
						relic_count--
					if("Ring of Chameleon")
						new /obj/item/clothing/ring/chameleon_ring(TU)
						relics -= "Ring of Chameleon"
						relic_count--
					if("Vial of Eoran Balm (x3)")
						new /obj/item/reagent_containers/glass/bottle/revival(TU)
						relics -= "Vial of Eoran Balm (x3)"
						relic_count--
					if("Bombdolier & Grenades")
						new /obj/item/bmbstrap(TU)
						new /obj/item/impact_grenade/smoke/blind_gas(TU)
						new /obj/item/impact_grenade/smoke/fire_gas(TU)
						new /obj/item/impact_grenade/smoke/poison_gas(TU)
						new /obj/item/impact_grenade/explosion(TU)
						new /obj/item/impact_grenade/explosion(TU)
						relics -= "Bombdolier & Grenades"
						relic_count--
					if("Drow Screaming Bell")
						new /obj/item/renegade_relics/screaming_bell(TU)
						relics -= "Drow Screaming Bell"
						relic_count--
					if("PSYDON's Music Box (Replica)") // Highly valuable relic for TRUE WARRIORS OF PSYDON.
						new /obj/item/dmusicbox(TU)
						relics -= "PSYDON's Music Box (Replica)"
						relic_count--