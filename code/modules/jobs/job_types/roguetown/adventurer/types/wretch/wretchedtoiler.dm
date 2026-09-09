/datum/advclass/wretch/wretchedtoiler
	name = "Wretched Toiler"
	tutorial = "The wretched engine of evil churns ever onward - the gears pushed by wretched toilers such as yourself. And toil you shall - until the machinations of thine masters come to fruition."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/wretch/wretchedtoiler
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ARCYNE_T2, TRAIT_ALCHEMY_EXPERT, TRAIT_MEDICINE_EXPERT, TRAIT_SMITHING_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_HOMESTEAD_EXPERT) //This can always be nerfed or changed to a specialization choice.
	cmode_music = 'sound/music/cmode/antag/combat_thrall.ogg' //We don't have the original .ogg and I'm lazy. You get thrall music now. Change it if you want.
	class_select_category = CLASS_CAT_TRADER
	extra_context = "Choose between 2 options: being an EVIL mastermind or a WRETCHED servant" //choose between master and servant
	maximum_possible_slots = 1 

	// balance isn't real i picked these bc they're funny
	subclass_stats = list(
		STATKEY_STR = -1, //YOU ARE WRETCHED!!!
		STATKEY_CON = -2, //AND YOU WILL +TOIL+!!!!!!!!!!!
		STATKEY_INT = 2, //4 int so you can be a feintbeast with the master swordskill I'm giving yo-HAHAHAHAHA JUST KIDDING! GRIND EXPERT ALCHEMY, WORMS!!!
		STATKEY_PER = 1, //i like looking into the distance
		STATKEY_WIL = 1, //i want this to be lower because i like hearing the stamout sfx but i will allow you ONE point of END
	)
	subclass_stashed_items = list(
		"Sewing Kit" = /obj/item/repair_kit,
	)
	subclass_skills = list(
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT, //You shall TOIL. You can TOIL most skills quite well.
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //So you can manhandle the princess for your dark master
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT, //summon monsters? I think?
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT, //miracle regen? I think?
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // brotherhood order spells most importantly. But this fellas gonna run a lot to.
		)

// Hedge Mage on purpose has nearly the same fit as a Adv Mage / Mage Associate who cast conjure armor roundstart. Call it meta disguise.
/datum/outfit/job/wretch/wretchedtoiler/pre_equip(mob/living/carbon/human/H)
	//shared loadout
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/magebag/associate
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/recipe_book/magic,
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()	
	//evil laughter/making fun of good guys (essential)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
	//you get miracles, yay! not as peak as a dedicated miracle class, though
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_2)
	//give minion orders if they're a zizite
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
	var/classes = list("MALICIOUS Mastermind","SNIVELLING servant")
	var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes
	switch(classchoice)
		if("MALICIOUS Mastermind")
			//stats
			H.STAINT += 2
			H.STAPER += 1
			//orders and stuff. you're the MASTERMIND!
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
			//MINIONS! ATTACK!
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/call_to_slaughter)
			//evil ass spells
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/eyebite)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
			//evil ass coordination stuff
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink)
			//they get uhhh i think this is the hedgemage fit
			mask = /obj/item/clothing/mask/rogue/eyepatch // Chuunibyou up to 11.
			head = /obj/item/clothing/head/roguetown/roguehood/black
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			if(should_wear_femme_clothes(H))
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
			else
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
			gloves = /obj/item/clothing/gloves/roguetown/angle
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
			beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
			neck = /obj/item/clothing/neck/roguetown/leather // No iron gorget vs necro. They will have to acquire one in round.
			r_hand = /obj/item/scrying //expert should give you good odds with this? if it breaks in one use, blame xylix, not me
			//you get some spellpoints. if you really wanna take combat spells you can ig
			H?.mind.adjust_spellpoints(12)
			var/staffs = list(
				"ronts-focused staff",
				"blortz-focused staff",
				"saffira-focused staff",
				"gemerald-focused staff",
				"amethyst-focused staff",
				"toper-focused staff",
			)
			var/staffchoice = input(H, H, "Choose your staff", "Available staffs") as anything in staffs
			switch(staffchoice)
				if("ronts-focused staff")
					backr = /obj/item/rogueweapon/woodstaff/ruby
				if("blortz-focused staff")
					backr = /obj/item/rogueweapon/woodstaff/quartz
				if("saffira-focused staff")
					backr = /obj/item/rogueweapon/woodstaff/sapphire
				if("gemerald-focused staff")
					backr = /obj/item/rogueweapon/woodstaff/emerald
				if("amethyst-focused staff")
					backr = /obj/item/rogueweapon/woodstaff/amethyst
				if("toper-focused staff")
					backr = /obj/item/rogueweapon/woodstaff/toper

		if("SNIVELLING servant")
			//stats
			H.STACON += 2
			H.STAWIL += 1
			//maximum TOIL!!!
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming , SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_EXPERT, TRUE)
			//buffs. you better be snarling "GET THEM, MASTER!" while you cast these
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortitude)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hawks_eyes)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/giants_strength)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/haste)
			//the fit. you ready to TOIL?
			neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar //hey, relax. it's just an iron gorget that you can't take off and makes you look like someone's pet
			armor = /obj/item/clothing/suit/roguetown/shirt/rags //toilmaxxing
			//you get less spellpoints. enough for like slip or message or smth
			H?.mind.adjust_spellpoints(6) 
	wretch_select_bounty(H)

/obj/effect/proc_holder/spell/invoked/order //i think this has to be here
	name = ""
	range = 5
