/datum/advclass/wretch/wretchedtoiler
	name = "Wretched Toiler"
	tutorial = "The wretched engine of evil churns ever onward - the gears pushed by wretched toilers such as yourself. And toil you shall - until the machinations of thine masters come to fruition."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/wretchedtoiler
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_JACKOFALLTRADES,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_SMITHING_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_RITUALIST, //This will be fine, probably. No plate armor training, so the rituals will be used to arm other people, which regular heretics could already do. 
		TRAIT_HOMESTEAD_EXPERT, 
		TRAIT_ARCYNE_T2, //no major offensive spells, but some utility.
	)
	cmode_music = 'sound/music/combat_cult.ogg'
	extra_context = "Mastermind, or Servant of the Masses? The choice is yours." //choose between master and servant
	maximum_possible_slots = 1 // do we need TWO antag weapon factories?
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,

		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,

		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE, //ritualist stuff
	)

//The stat spread of a survivor and a weasel. Balanced for both physical toil and magical aptitude.

/datum/outfit/job/roguetown/wretch/wretchedtoiler/pre_equip(mob/living/carbon/human/H)
	//shared loadout
	belt = /obj/item/storage/belt/rogue/leather/plaquegold //Bro it's aura 
	beltl = /obj/item/storage/magebag/starter
	backr = /obj/item/storage/backpack/rogue/satchel/short
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
	//you get miracles, but nothing actually useful.
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_4)
	//give minion orders if they're a zizite
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
	var/classes = list("MALICIOUS Mastermind","SNIVELLING servant", "MALUM'S MUNITIONEER")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes
	switch(classchoice)
		if("MALICIOUS Mastermind")
			//stats
			H.change_stat(STATKEY_WIL, 3) 
			H.change_stat(STATKEY_INT, 1) 
			H.change_stat(STATKEY_STR, -2)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE) //To give them good odds at the scrying orb. They dont actually GET a lot of spellpoints.
			//orders and stuff. you're the MASTERMIND!
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
			//MINIONS! ATTACK!
			//evil ass coordination stuff
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink)
			//Giving them proper villain clothes
			mask = /obj/item/clothing/mask/rogue/eyepatch // Chuunibyou up to 11.
			head = /obj/item/clothing/head/roguetown/roguehood/shroudscarlet
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
			pants = /obj/item/clothing/under/roguetown/splintlegs/iron
			wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/tabardscarlet //We're evil bitch
			gloves = /obj/item/clothing/gloves/roguetown/plate //Dr. Claw type beat
			cloak = /obj/item/clothing/cloak/cape/blkknight
			beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
			neck = /obj/item/clothing/neck/roguetown/gorget/copper
			backl = /obj/item/rogueweapon/woodstaff/ruby
			r_hand = /obj/item/scrying //expert should give you good odds with this? if it breaks in one use, blame xylix, not me
			switch(H.patron?.type) //MINIONS, ATTACK!!!
				if(/datum/patron/inhumen/zizo)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/eyebite)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill) //Because the Zizo T1 is utter dogshit
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, SLOT_RING, TRUE)
				if(/datum/patron/inhumen/matthios)
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)
				if(/datum/patron/inhumen/baotha)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/griefflower)
				if(/datum/patron/inhumen/graggar) //MINIONS, ATTACK!!!
					H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)
			H.mind.adjust_spellpoints(3) //just enough for maybe one or two offensive spells or extra utility

		if("SNIVELLING servant") //Extra homesteader support buffs. They can spawn with a surplus of healing or tools.
			//stats 
			H.change_stat(STATKEY_WIL, 1) 
			H.change_stat(STATKEY_CON, 1) 
			H.change_stat(STATKEY_INT, -2)
			//maximum TOIL!!!
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_EXPERT, TRUE)

			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			//buffs. you better be snarling "GET THEM, MASTER!" while you cast these
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortitude)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hawks_eyes)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/giants_strength)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/haste)
			//the fit. you ready to TOIL?
			backl = /obj/item/storage/backpack/rogue/backpack
			var/discipline = list("SERVANT! POTIONS!", "SERVANT! REPAIR!", "SERVANT! DEFENSES!", "SERVANT! KIIIIILL!")
			var/discipline_choice = input(H,"You still hear your old master's echoing commands...", "What did they yell out most?") as anything in discipline
			switch(discipline_choice)
				if("SERVANT! POTIONS!")
					backpack_contents += list(
						/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
						/obj/item/reagent_containers/glass/bottle/rogue/stampot = 2,
						/obj/item/reagent_containers/glass/bottle/rogue/manapot = 2,
						/obj/item/alch/calendula = 2,
						/obj/item/alch/hypericum = 2,
						/obj/item/alch/urtica = 2,
					)
				if("SERVANT! REPAIR!")
					ADD_TRAIT(H, TRAIT_SQUIRE_REPAIR, TRAIT_GENERIC)
					backpack_contents += list(
						/obj/item/rogueweapon/hammer/steel = 1,
						/obj/item/repair_kit/metal = 1,
						/obj/item/repair_kit = 1,
					)
				if("SERVANT! DEFENSES!")
					H.adjust_skillrank_up_to(/datum/skill/craft/traps, SKILL_LEVEL_EXPERT, TRUE)
					backpack_contents += list(
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/dye_brush = 1,
						/obj/item/recipe_book/engineering = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/recipe_book/survival = 1,
					)
				if("SERVANT! KIIIIILL!")
					backpack_contents += list(
						/obj/item/rogueweapon/stoneaxe/hurlbat = 2,
					)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick) //hilarious
					H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE) //for the brick
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)

			neck = /obj/item/clothing/neck/roguetown/gorget/cursed_collar //hey, relax. it's just an iron gorget that you can't take off and makes you look like someone's pet
			armor = /obj/item/clothing/suit/roguetown/shirt/rags //toilmaxxing
		
		if("MALUM'S MUNITIONEER")
			to_chat(H, span_warning("You are a passable warrior- though weak- but your true strength lies in your ability to bend the resources of Azuria to your will."))
			H.change_stat(STATKEY_WIL, -2) 
			H.change_stat(STATKEY_CON, 1) 
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_INT, -2)
			ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)

			H.equip_to_slot_or_del(new /obj/item/storage/backpack/rogue/satchel/beltpack, SLOT_RING, TRUE)

			head = /obj/item/clothing/head/roguetown/roguehood/warden/munitioneer
			mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy
			neck = /obj/item/clothing/neck/roguetown/gorget
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			cloak = /obj/item/clothing/cloak/templar/malumite
			armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			backl = /obj/item/storage/backpack/rogue/satchel
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
			belt = /obj/item/storage/backpack/rogue/satchel/beltpack
			gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/woodcut/pick) //I gave you the pickaxe with the devotion regen so I dont want to hear complaints about not being able to pick the crossbow
			if(H.mind)
				H.mind?.current.faction += "[H.name]_faction"
				H.set_patron(/datum/patron/divine/malum)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight)
			C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_4)	//Minor regen, can level up to T4.

	wretch_select_bounty(H)


