// Feats - extraordinary abilities and characteristics
// Max selection: 3 (or more based on number of vices)

/datum/virtue/size/giant
	name = "Giant"
	desc = "I've always been larger, stronger and hardier than the average person. I tend to lumber around a lot, and my immense size can break down frail, wooden doors."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_BIGGUY, TRAIT_DEATHBYSNUSNU)
	custom_text = "Increases your sprite size."

/datum/virtue/size/giant/apply_to_human(mob/living/carbon/human/recipient)
	// Don't apply transform to preview dummies
	if(istype(recipient, /mob/living/carbon/human/dummy))
		return
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()
	recipient.change_stat("constitution", 1)


// Arcyne Potential now gives 3 Spellpoints instead of 6 spellpoints so it is less of a "must take" for caster.
/datum/virtue/combat/magical_potential
	name = "Arcyne Potential"
	desc = "I am talented in the Arcyne arts, expanding my capacity for magic. I have become more intelligent from its studies. Other effects depends on what training I chose to focus on at a later age."
	category = "feats"
	virtue_cost = 10
	custom_text = "Classes that has a combat trait (Medium / Heavy Armor Training, Dodge Expert or Critical Resistance) get only prestidigitation. Everyone else get +3 spellpoints and T1 Arcyne Potential if they don't have any Arcyne."
	added_skills = list(list(/datum/skill/magic/arcane, 1, 6))

/datum/virtue/combat/magical_potential/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.get_skill_level(/datum/skill/magic/arcane)) // we can do this because apply_to is always called first
		if (!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			ADD_TRAIT(recipient, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			recipient.mind?.adjust_spellpoints(3)
	else
		recipient.mind?.adjust_spellpoints(3) // 3 extra spellpoints since you don't get any spell point from the skill anymore
	
/datum/virtue/combat/devotee
	name = "Devotee"
	desc = "Though not officially of the Church, my relationship with my chosen Patron is strong enough to grant me the most minor of their blessings. I've also kept a psycross of my deity."
	category = "feats"
	virtue_cost = 10
	custom_text = "You gain access to T0 miracles of your patron. As a non-combat role you also receive a minor passive devotion gain. If you already have access to Miracles, you get slightly increased passive devotion gain."

	added_skills = list(list(/datum/skill/magic/holy, 1, 6))

/datum/virtue/combat/devotee/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.mind)
		return
	if (!recipient.devotion)
		// Only give non-devotionists orison... and T0 for some reason (Bad ideas are fun!)
		var/datum/devotion/new_faith = new /datum/devotion(recipient, recipient.patron)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = (CLERIC_REQ_1 - 10)) // Passive devotion regen only for non-combat classes
		else
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = FALSE, devotion_limit = (CLERIC_REQ_1 - 20))	//Capped to T0 miracles.
	else
		// for devotionists, give them an amount of passive devo gain.
		var/datum/devotion/our_faith = recipient.devotion
		our_faith.passive_devotion_gain += CLERIC_REGEN_DEVOTEE
		START_PROCESSING(SSobj, our_faith)
	switch(recipient.patron?.type)
		if(/datum/patron/divine/astrata)
			recipient.mind?.special_items["Astrata Psycross"] = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/abyssor)
			recipient.mind?.special_items["Abyssor Psycross"] = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			recipient.mind?.special_items["Dendor Psycross"] = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			recipient.mind?.special_items["Necra Psycross"] = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			recipient.mind?.special_items["Pestra Psycross"] = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/eora) 
			recipient.mind?.special_items["Eora Psycross"] = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/xylix) 
			recipient.mind?.special_items["Xylix Psycross"] = /obj/item/clothing/neck/roguetown/psicross/xylix
		if(/datum/patron/divine/noc)
			recipient.mind?.special_items["Noc Psycross"] = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/ravox)
			recipient.mind?.special_items["Ravox Psycross"] =/obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			recipient.mind?.special_items["Malum Psycross"] = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/old_god)
			ADD_TRAIT(recipient, TRAIT_PSYDONITE, TRAIT_GENERIC)
			recipient.mind?.special_items["Psycross"] = /obj/item/clothing/neck/roguetown/psicross


/datum/virtue/movement/acrobatic
	name = "Acrobatic"
	desc = "I have powerful legs, allowing me to land precisely where I want to, even with a running start."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_LEAPER)

/datum/virtue/movement/equestrian
	name = "Equestrian"
	desc = "My mount understands me. We've worked together as one on our difficult journey. I can navigate through doors and other small gaps without getting thrown off my saddle."
	category = "feats"
	virtue_cost = 5
	added_skills = list(list(/datum/skill/misc/riding, 1, 6))
	added_traits = list(TRAIT_EQUESTRIAN)
	added_stashed_items = list("Saddle" = /obj/item/natural/saddle)

/datum/virtue/movement/equestrian/apply_to_human(mob/living/carbon/human/recipient)
	new /mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame(get_turf(recipient))


/datum/virtue/utility/noble
	name = "Nobility"
	desc = "By birth, blade or brain, I am noble known to the royalty of these lands, and have all the benefits associated with it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	category = "feats"
	virtue_cost = 10
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list("Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
								"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15

/datum/virtue/utility/socialite
	name = "Socialite"
	desc = "I thrive in social settings, easily reading the emotions of others and charming those around me. My presence is always felt at any gathering."
	category = "feats"
	virtue_cost = 5
	custom_text = "Incompatible with Ugly virtue. Grants empathic insight."
	added_traits = list(TRAIT_BEAUTIFUL, TRAIT_GOODLOVER, TRAIT_EMPATH)
	added_stashed_items = list(
		"Hand Mirror" = /obj/item/handmirror)

/datum/virtue/utility/socialite/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(isdullahan(recipient))
		REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_BEAUTIFUL_UNCANNY, TRAIT_VIRTUE)
	if(HAS_TRAIT(recipient, TRAIT_UNSEEMLY))
		to_chat(recipient, "Your attractiveness is cancelled out! You become normal.")
		if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
			REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/deadened
	name = "Deadened"
	desc = "Some terrible incident colours my past, and now, I feel nothing."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_NOMOOD)

/datum/virtue/utility/light_steps
	name = "Light Steps"
	desc = "Years of skulking about have left my steps quiet, and my hunched gait quicker."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_LIGHT_STEP)
	added_skills = list(list(/datum/skill/misc/sneaking, 3, 6))

/datum/virtue/utility/resident
	name = "Resident"
	desc = "I'm a resident of the vale. I have an account in the city's treasury and a home in the city."
	category = "feats"
	virtue_cost = 2
	added_traits = list(TRAIT_RESIDENT)

/datum/virtue/utility/resident/apply_to_human(mob/living/carbon/human/recipient)
	var/mapswitch = 0
	if(SSmapping.config.map_name == "Dun Manor")
		mapswitch = 1
	else if(SSmapping.config.map_name == "Dun World")
		mapswitch = 2

	if(mapswitch == 0)
		return
	if(recipient.mind?.assigned_role == "Adventurer" || recipient.mind?.assigned_role == "Mercenary" || recipient.mind?.assigned_role == "Court Agent")
		// Find tavern area for spawning
		var/area/spawn_area
		for(var/area/A in world)
			if(istype(A, /area/rogue/indoors/town/tavern))
				spawn_area = A
				break

		if(spawn_area)
			var/target_z = 3 //ground floor of tavern for dun manor / world
			var/target_y = 70 //dun manor
			var/list/possible_chairs = list()

			if(mapswitch == 2)
				target_y = 234 //dun world huge

			for(var/obj/structure/chair/C in spawn_area)
				//z-level 3, wooden chair, and Y > north of tavern backrooms
				var/turf/T = get_turf(C)
				if(T && T.z == target_z && T.y > target_y && istype(C, /obj/structure/chair/wood/rogue) && !T.density && !T.is_blocked_turf(FALSE))
					possible_chairs += C

			if(length(possible_chairs))
				var/obj/structure/chair/chosen_chair = pick(possible_chairs)
				recipient.forceMove(get_turf(chosen_chair))
				chosen_chair.buckle_mob(recipient)
				to_chat(recipient, span_notice("As a resident of the vale, you find yourself seated at a chair in the local tavern."))
			else
				var/list/possible_spawns = list()
				for(var/turf/T in spawn_area)
					if(T.z == target_z && T.y > (target_y + 4) && !T.density && !T.is_blocked_turf(FALSE))
						possible_spawns += T

				if(length(possible_spawns))
					var/turf/spawn_loc = pick(possible_spawns)
					recipient.forceMove(spawn_loc)
					to_chat(recipient, span_notice("As a resident of the vale, you find yourself in the local tavern."))

/datum/virtue/utility/failed_squire
	name = "Failed Squire"
	desc = "I was once a squire in training, but failed to achieve knighthood. Though my dreams of glory were dashed, I retained my knowledge of equipment maintenance and repair, including how to polish arms and armor."
	category = "feats"
	virtue_cost = 10
	added_traits = list(TRAIT_SQUIRE_REPAIR)
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Polishing Cream" = /obj/item/polishing_cream,
		"Fine Brush" = /obj/item/armor_brush
	)

/datum/virtue/utility/failed_squire/apply_to_human(mob/living/carbon/human/recipient)
	to_chat(recipient, span_notice("Though you failed to become a knight, your training in equipment maintenance and repair remains useful."))
	to_chat(recipient, span_notice("You can retrieve your hammer and polishing tools from a tree, statue, or clock."))

/datum/virtue/utility/linguist
	name = "Intellectual"
	desc = "I've spent my life surrounded by various books or sophisticated foreigners, be it through travel or other fortunes beset on my life. I've picked up several tongues and wits, and keep a journal closeby. I can tell people's exact prowess."
	category = "feats"
	virtue_cost = 10
	custom_text = "Maximizes Assess benefits with a bonus of the target's Stats. Allows the choice of 3 languages to learn upon joining. +1 INT."
	added_traits = list(TRAIT_INTELLECTUAL)
	added_skills = list(list(/datum/skill/misc/reading, 3, 6))
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit
	)

/datum/virtue/utility/linguist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.change_stat(STATKEY_INT, 1)
	addtimer(CALLBACK(src, .proc/linguist_apply, recipient), 50)

/datum/virtue/utility/linguist/proc/linguist_apply(mob/living/carbon/human/recipient)
	var/static/list/selectable_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/orcish,
		/datum/language/hellspeak,
		/datum/language/draconic,
		/datum/language/celestial,
		/datum/language/grenzelhoftian,
		/datum/language/canilunzt,
		/datum/language/kazengunese,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/aavnic,
		/datum/language/abyssal,
		/datum/language/merar
	)

	var/list/choices = list()
	for(var/language_type in selectable_languages)
		if(recipient.has_language(language_type))
			continue
		var/datum/language/a_language = new language_type()
		choices[a_language.name] = language_type

	if(length(choices))	//If this isn't true then we have no new languages learn -- we probably picked archivist
		var/lang_count = 3
		var/count = lang_count
		for(var/i in 1 to lang_count)
			var/chosen_language = input(recipient, "Choose your extra spoken language.", "VIRTUE: [count] LEFT") as null|anything in choices
			if(chosen_language)
				var/language_type = choices[chosen_language]
				recipient.grant_language(language_type)
				choices -= chosen_language
				to_chat(recipient, span_info("I recall my knowledge of [chosen_language]..."))
				count--

/datum/virtue/utility/deathless
	name = "Deathless"
	desc = "Some fell magick has rendered me inwardly unliving - I do not hunger, and I do not breathe."
	category = "feats"
	virtue_cost = 10
	added_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH)

/datum/virtue/utility/deathless/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
		to_chat(recipient, "My reliance on lyfeblood cannot be severed!")
		REMOVE_TRAIT(recipient, TRAIT_NOHUNGER, TRAIT_VIRTUE)

/datum/virtue/utility/feral_appetite
	name = "Feral Appetite"
	desc = "Raw, toxic or spoiled food doesn't bother my superior digestive system."
	category = "feats"
	virtue_cost = 2
	added_traits = list(TRAIT_NASTY_EATER)

/datum/virtue/utility/feral_appetite/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
		to_chat(recipient, "My reliance on lyfeblood cannot be severed!")
		REMOVE_TRAIT(recipient, TRAIT_NASTY_EATER, TRAIT_VIRTUE)

/datum/virtue/utility/night_vision
	name = "Night-eyed"
	desc = "I have eyes able to see through cloying darkness. Incompatible with the vice Colorblind."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_DARKVISION)
	custom_text = "Adds a button to toggle colorblindness to aid seeing in the dark. Taking this with the Colorblind vice will permanently colorblind you."

/datum/virtue/utility/night_vision/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/colorblind)
			to_chat(recipient, "Your eyes have become permanently colorblind.")
		else
			recipient.verbs += /mob/living/carbon/human/proc/toggleblindness

/datum/virtue/utility/performer
	name = "Performer"
	desc = "Music, artistry and the act of showmanship carried me through life. I've hidden a favorite instrument of mine, know how to please anyone I touch, and how to crack the eggs of hecklers."
	category = "feats"
	virtue_cost = 2
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_traits = list(TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	added_skills = list(list(/datum/skill/misc/music, 4, 6)) //Allows them uplaod custom music

/datum/virtue/utility/performer/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, .proc/performer_apply, recipient), 50)

/datum/virtue/utility/performer/proc/performer_apply(mob/living/carbon/human/recipient)
	var/list/instruments = list()
	for(var/instrument_type in subtypesof(/obj/item/rogue/instrument))
		if(instrument_type == /obj/item/rogue/instrument/harp/handcarved)
			continue //Skip the donator personal item harp.
		var/obj/item/rogue/instrument/instr = new instrument_type()
		instruments[instr.name] = instrument_type
		qdel(instr)  // Clean up the temporary instance

	var/chosen_name = input(recipient, "What instrument did I stash?", "STASH") as null|anything in instruments
	if(chosen_name)
		var/instrument_type = instruments[chosen_name]
		recipient.mind?.special_items[chosen_name] = instrument_type

/datum/virtue/utility/ugly
	name = "Ugly"
	desc = "Be it your family's habits in and out of womb, your own choices or Xylix's cruel roll of fate, you have been left unbearable to look at. Stuck to the unseen pits and crevices of the town, you've grown used to the foul odours of lyfe that often follow you. Corpses do not stink for you, and that is all the company you might find."
	category = "feats"
	virtue_cost = 0
	custom_text = "Incompatible with Beautiful virtue."
	added_traits = list(TRAIT_UNSEEMLY, TRAIT_NOSTINK)

/datum/virtue/utility/ugly/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
		to_chat(recipient, "Your repulsiveness is cancelled out! You become normal.")
		REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/secondvoice
	name = "Second Voice"
	desc = "From performance, deception, or by a need to change yourself in uncanny ways, you've acquired a second, perfect voice. You may switch between them at any point."
	category = "feats"
	virtue_cost = 2
	custom_text = "Grants access to a new 'Memory' tab. It will have the options for setting and changing your voice."

/datum/virtue/utility/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/datum/virtue/utility/keenears
	name = "Keen Ears"
	desc = "Cowering from authorities, loved ones or by a generous gift of the gods, you've adapted a keen sense of hearing, and can identify the speakers even when they are out of sight, their whispers ringing louder."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_KEENEARS)
	custom_text = "You can identify known people who speak even when they are out of sight. You can hear people speaking normally above and below you, regardless of obstacles in the way. You can hear whispers from one tile further."

/datum/virtue/utility/tracker
	name = "Sleuth"
	desc = "You realised long ago that the ability to find a man is as helpful to aid the law as it is to evade it."
	category = "feats"
	virtue_cost = 5
	added_skills = list(list(/datum/skill/misc/tracking, 3, 6))
	added_traits = list(TRAIT_SLEUTH)
	custom_text = "- Upon right clicking a track, you will Mark the person who made them <i>(Expert skill required, not exclusive to this Virtue)</i>.\n- Further tracks found will be automatically highlighted as theirs, along with the person themselves, if they are not sneaking or invisible at the time.\n- Reduces the cooldown for tracking, allows track examining right away, and movement no longer cancels tracking."

// NOTE: Bronze Arm/Leg virtues have been moved to modular_azurepeak/virtues/prosthetics/
// They are now part of the modular Prosthetic Limbs virtue system

/datum/virtue/utility/woodwalker
	name = "Woodwalker"
	desc = "After years of training in the wilds, I've learned to traverse the woods confidently, without breaking any twigs. I can even step lightly on leaves without falling, and I can gather twice as many things from bushes. (Also affects Nude Sleeper vice.)"
	category = "feats"
	virtue_cost = 10
	added_traits = list(TRAIT_WOODWALKER, TRAIT_OUTDOORSMAN)

/datum/virtue/heretic/zchurch_keyholder
	name = "Defiled Keyholder"
	desc = "The 'Holy' See has their blood-stained grounds, and so do we. Underneath their noses, we pray to the true gods - I know the location of the local heretic conclave. Secrecy is paramount. If found out, I will surely be killed."
	category = "feats"
	virtue_cost = 3
	added_traits = list(TRAIT_ZURCH)

/datum/virtue/utility/mountable
	name = "Mountable"
	desc = "You have trained or been trained into a suitable mount. People may ride you as they would a saiga."
	category = "feats"
	virtue_cost = 2
	added_traits = list(TRAIT_PONYGIRL_RIDEABLE)

/datum/virtue/utility/tolerant
	name = "Tolerant"
	desc = "Whether fostered through travel or care, you just don't see an issue with certain folks."
	category = "feats"
	virtue_cost = 0
	custom_text = "Prevents you from experiencing negative stress events when looking at select species."
	added_traits = list(TRAIT_TOLERANT)


/datum/virtue/thief/drug_runner
	name = "Dust Runner"
	desc = "I run dust for the Thieves' Guild, and an associate has left a delivery in my stash nearby for me to pick up."
	category = "feats"
	virtue_cost = 5
	added_stashed_items = list("Satchel #1" = /obj/item/storage/backpack/rogue/satchel/mule,
							"Satchel #2" = /obj/item/storage/backpack/rogue/satchel/mule,
							"Dagger" = /obj/item/rogueweapon/huntingknife/idagger
	)

// Additional feats - these combine skills, traits, and items
/datum/virtue/utility/larcenous
	name = "Larcenous"
	desc = "Whether it was asked of you, or by a calling for the rush deep within your hollow heart, you seek things that don't belong you. You know how to work a lock, and have stashed a ring of them, for just the occasion."
	category = "feats"
	virtue_cost = 5
	added_stashed_items = list("Lockpick Ring" = /obj/item/lockpickring/mundane)
	added_skills = list(list(/datum/skill/misc/lockpicking, 3, 6))

/datum/virtue/utility/granary
	name = "Cunning Provisioner"
	desc = "You've worked in or around the docks enough to steal away a sack of supplies that no one would surely miss, just in case. You've picked up on some cooking and fishing tips in your spare time, as well."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	added_stashed_items = list("Bag of Food" = /obj/item/storage/roguebag/food)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 6),
						list(/datum/skill/labor/fishing, 2, 6))

/datum/virtue/utility/forester
	name = "Forester"
	desc = "The forest is your home, or at least, it used to be. You always long to return and roam free once again, and you have not forgotten your knowledge on how to be self sufficient."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	added_stashed_items = list("Trusty hoe" = /obj/item/rogueweapon/hoe)
	added_skills = list(list(/datum/skill/craft/cooking, 2, 2),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 2, 2),
						list(/datum/skill/labor/fishing, 2, 2),
						list(/datum/skill/labor/lumberjacking, 2, 2)
	)

/datum/virtue/utility/homesteader
	name = "Pilgrim"
	desc= "As they say, 'hearth is where the heart is'. You are intimately familiar with the labors of lyfe, and have stowed away everything necessary to start anew: a hunting dagger, your trusty hoe, and a sack of assorted supplies."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	added_stashed_items = list(
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Bag of Food" = /obj/item/storage/roguebag/food,
		"Hunting Knife" = /obj/item/rogueweapon/huntingknife
	)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 3),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 3, 3),
						list(/datum/skill/labor/fishing, 3, 3),
						list(/datum/skill/labor/lumberjacking, 2, 2),
						list(/datum/skill/combat/knives, 2, 2)
	)

/datum/virtue/items/rich
	name = "Rich and Shrewd"
	desc = "Through a stroke of luck or shrewd planning, I've come into a considerable amount of mammon. I can tell the value of those I speak to, and what they offer. I've also stowed away some coinage for a rainy dae."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_SEEPRICES)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))	//So the spell would work
	custom_text = "Grants Secular Appraise -- a spell that allows you to tell how much wealth someone has on them, and in their Nervelock."
	added_stashed_items = list("Weighty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)

/datum/virtue/items/rich/apply_to_human(mob/living/carbon/human/recipient)
	recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/datum/virtue/items/arsonist
	name = "Arsonist"
	desc = "I like to watch the world burn, and I've stowed away two powerful firebombs to help me achieve that fact."
	category = "feats"
	virtue_cost = 6
	added_skills = list(list(/datum/skill/craft/alchemy, 1, 6))
	added_traits = list(TRAIT_ALCHEMY_EXPERT) // Kaboom
	added_stashed_items = list("Firebomb #1" = /obj/item/bomb,
								"Firebomb #2" = /obj/item/bomb
	)
/*
// ============ NOC-SCORCHED ============
// Lycanthropic curse that was "cured" but left its mark

/datum/virtue/noc_scorched
	name = "Noc-Scorched"
	desc = "I was exposed to lycanthropy and bear its scar. I can digest raw meat and organs naturally. Under the open night sky without headgear: I gain night vision and silver weakness, become bewitched (cannot cast spells), suffer from insomnia, suffer periodic oxygen damage, and involuntarily growl/howl/drool. I must eat raw meat regularly to satisfy my bestial hunger - if I don't feed, I'll enter a feral frenzy. Raw meat heals me. Silver cannot cure me again."
	category = "" //None for now.
	triumph_cost = 0
	custom_text = "A powerful lycanthropic transformation that provides both benefits and drawbacks. Cannot be combined with Astrata-Scorched."
	added_traits = list(TRAIT_SILVER_CURED, TRAIT_NOC_SCORCHED, TRAIT_ORGAN_EATER)
	
	var/in_moonlight = FALSE
	var/next_emote = 0
	var/next_burn = 0
	var/meat_hunger = 500 // Hunger meter: 500 = fed, 250 = hungry, 100 = starving
	var/next_hunger_check = 0
	var/mob/living/carbon/human/tracked_human

/datum/virtue/noc_scorched/apply_to_human(mob/living/carbon/human/recipient)
	// Check for incompatibility
	if(HAS_TRAIT(recipient, TRAIT_ASTRATA_SCORCHED))
		to_chat(recipient, span_boldwarning("The curse of the moon and the scorching of the sun are incompatible. You cannot bear both."))
		return FALSE
	
	..()
	tracked_human = recipient
	meat_hunger = 500
	next_hunger_check = world.time + 5 MINUTES
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/virtue/noc_scorched/Destroy()
	if(tracked_human)
		// Clean up all effects
		REMOVE_TRAIT(tracked_human, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
		REMOVE_TRAIT(tracked_human, TRAIT_NOSLEEP, TRAIT_GENERIC)
		tracked_human.remove_status_effect(/datum/status_effect/moon_touched)
		tracked_human.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t1)
		tracked_human.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t2)
		tracked_human.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t3)
		tracked_human = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/virtue/noc_scorched/process()
	if(!tracked_human || tracked_human.stat == DEAD)
		return
	
	var/mob/living/carbon/human/H = tracked_human
	
	if(H.stat != CONSCIOUS)
		return

	// Decay meat hunger over time
	if(world.time >= next_hunger_check)
		meat_hunger = max(0, meat_hunger - 25) // Lose 25 hunger every 5 minutes
		next_hunger_check = world.time + 5 MINUTES
		
		// Apply hunger debuffs based on hunger level
		switch(meat_hunger)
			if(250 to 500)
				H.apply_status_effect(/datum/status_effect/debuff/meat_hunger_t1)
				H.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t2)
				H.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t3)
				if(meat_hunger == 250)
					to_chat(H, span_warning("My bestial hunger grows... I need raw meat."))
			if(100 to 250)
				H.apply_status_effect(/datum/status_effect/debuff/meat_hunger_t2)
				H.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t1)
				H.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t3)
				if(meat_hunger == 100)
					to_chat(H, span_danger("The beast within DEMANDS flesh! I'm losing control!"))
			if(0 to 100)
				H.apply_status_effect(/datum/status_effect/debuff/meat_hunger_t3)
				H.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t1)
				H.remove_status_effect(/datum/status_effect/debuff/meat_hunger_t2)
		
		// Frenzy chance when starving
		if(meat_hunger < 100 && prob(9))
			if(H.last_frenzy_check + 5 MINUTES < world.time)
				to_chat(H, span_userdanger("The beast takes over! I cannot control myself!"))
				H.rollfrenzy()

	// Check moonlight exposure conditions: night, outdoors, and no headgear
	var/turf/T = get_turf(H)
	var/exposed = (GLOB.tod == "night") && isturf(T) && T.can_see_sky() && !H.head

	if(exposed)
		if(!in_moonlight)
			// First tick of moonlight exposure
			in_moonlight = TRUE
			next_emote = world.time + rand(60 SECONDS, 120 SECONDS)
			next_burn = world.time + rand(120 SECONDS, 180 SECONDS)
		// Continuously refresh the moon_touched status effect while exposed
		H.apply_status_effect(/datum/status_effect/moon_touched)
		// Apply bewitched (cannot cast spells) and insomnia while under moonlight
		ADD_TRAIT(H, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSLEEP, TRAIT_GENERIC)
		
		// Periodic emotes
		if(world.time >= next_emote)
			var/moon_emote = pick("growls softly.", "lets out a low howl.", "drools, teeth bared.", "snarls involuntarily.")
			H.visible_message(span_warning("[H] [moon_emote]"), span_warning("I [moon_emote]"))
			next_emote = world.time + rand(60 SECONDS, 120 SECONDS)

		// Periodic burning (oxygen damage) from moonlight
		if(world.time >= next_burn)
			var/moon_msg = pick(
				"The moonlight sears through you!",
				"Your flesh burns under Noc's gaze!",
				"The moon's touch ignites your cursed blood!")
			to_chat(H, span_danger(moon_msg))
			H.adjustOxyLoss(rand(5, 15))
			next_burn = world.time + rand(120 SECONDS, 180 SECONDS)
	else
		if(in_moonlight)
			// Left moonlight
			in_moonlight = FALSE
			H.remove_status_effect(/datum/status_effect/moon_touched)
			REMOVE_TRAIT(H, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
			REMOVE_TRAIT(H, TRAIT_NOSLEEP, TRAIT_GENERIC)

// ============ ASTRATA-SCORCHED ============
// Vampirism that was "cured" but left its mark

/datum/virtue/astrata_scorched
	name = "Astrata-Scorched"
	desc = "You once bore the dark hunger of the sanguine, but were cured. Astrata's light now scorches your once-shadowed flesh. Silver burns you deeply, the sun's gaze strips away your resilience, you cast no reflection, and the old hunger lingers — blood is your only sustenance. If starved, you'll lose control. You heal in coffins. Stakes can end you."
	category = "" // None for now.
	triumph_cost = 0
	custom_text = "A powerful vampiric transformation that provides both benefits and severe drawbacks. Cannot be combined with Noc-Scorched."
	added_traits = list(TRAIT_ASTRATA_SCORCHED, TRAIT_SILVER_WEAK, TRAIT_HEMOPHAGE, TRAIT_VAMPBITE, TRAIT_SILVER_CURED, TRAIT_DARKVISION, TRAIT_VAMP_DREAMS, TRAIT_NIGHT_OWL, TRAIT_NO_REFLECTION, TRAIT_STAKE_VULNERABLE)
	
	var/in_sunlight = FALSE
	var/next_burn = 0
	var/blood_hunger = 500 // Hunger meter: 500 = fed, 250 = hungry, 100 = starving
	var/next_hunger_check = 0
	var/mob/living/carbon/human/tracked_human

/datum/virtue/astrata_scorched/apply_to_human(mob/living/carbon/human/recipient)
	// Check for incompatibility
	if(HAS_TRAIT(recipient, TRAIT_NOC_SCORCHED))
		to_chat(recipient, span_boldwarning("The curse of the moon and the scorching of the sun are incompatible. You cannot bear both."))
		return FALSE
	
	..()
	to_chat(recipient, span_warning("Astrata's light finds me... and it burns. Silver scalds my flesh, the sun strips me bare, and the old hunger has never truly left me."))
	tracked_human = recipient
	blood_hunger = 500
	next_hunger_check = world.time + 5 MINUTES
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/virtue/astrata_scorched/Destroy()
	if(tracked_human)
		// Clean up all effects
		REMOVE_TRAIT(tracked_human, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
		tracked_human.remove_status_effect(/datum/status_effect/sun_scorched)
		tracked_human.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t1)
		tracked_human.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t2)
		tracked_human.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t3)
		tracked_human = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/virtue/astrata_scorched/process()
	if(!tracked_human || tracked_human.stat == DEAD)
		return
	
	var/mob/living/carbon/human/H = tracked_human
	
	// Coffin healing (even when not conscious, check separately)
	var/obj/structure/closet/crate/coffin/coffin = H.loc
	if(istype(coffin) && (H in coffin.contents))
		// Heal in coffin during night
		if(GLOB.tod == "night" || GLOB.tod == "dusk")
			if(H.getBruteLoss() > 0 || H.getFireLoss() > 0)
				H.heal_overall_damage(3, 3) // Slower than vampire torpor
				if(prob(10))
					to_chat(H, span_notice("The darkness of the coffin soothes your cursed flesh..."))
			// Also restore some blood hunger while resting in coffin
			if(blood_hunger < 500)
				blood_hunger = min(500, blood_hunger + 10)
	
	if(H.stat != CONSCIOUS)
		return

	// Decay blood hunger over time
	if(world.time >= next_hunger_check)
		blood_hunger = max(0, blood_hunger - 25)
		next_hunger_check = world.time + 5 MINUTES
		
		// Apply hunger debuffs based on hunger level
		switch(blood_hunger)
			if(250 to 500)
				H.apply_status_effect(/datum/status_effect/debuff/blood_hunger_t1)
				H.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t2)
				H.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t3)
				if(blood_hunger == 250)
					to_chat(H, span_warning("The thirst returns... I need blood."))
			if(100 to 250)
				H.apply_status_effect(/datum/status_effect/debuff/blood_hunger_t2)
				H.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t1)
				H.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t3)
				if(blood_hunger == 100)
					to_chat(H, span_danger("The old hunger BURNS! I must feed!"))
			if(0 to 100)
				H.apply_status_effect(/datum/status_effect/debuff/blood_hunger_t3)
				H.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t1)
				H.remove_status_effect(/datum/status_effect/debuff/blood_hunger_t2)
		
		// Frenzy chance when starving
		if(blood_hunger < 100 && prob(9))
			if(H.last_frenzy_check + 5 MINUTES < world.time)
				to_chat(H, span_userdanger("The blood-thirst overwhelms me! I cannot resist!"))
				H.rollfrenzy()

	// Check sunlight exposure: outdoors during day or dawn, no headgear
	var/turf/T = get_turf(H)
	var/exposed = (GLOB.tod == "day" || GLOB.tod == "dawn") && isturf(T) && T.can_see_sky() && !H.head

	if(exposed)
		if(!in_sunlight)
			in_sunlight = TRUE
			next_burn = world.time + rand(120 SECONDS, 180 SECONDS)
		// Continuously refresh the sun_scorched status effect (grants critical weakness) while exposed
		H.apply_status_effect(/datum/status_effect/sun_scorched)
		H.add_stress(/datum/stressevent/vice/astrata_scorched)

		// Periodic burning from the sun
		if(world.time >= next_burn)
			var/sun_msg = pick(
				"Astrata's light sears through you like a brand!",
				"The sun's gaze strips away all strength and resilience!",
				"Your flesh prickles and burns beneath the sun's relentless gaze!",
				"The light scalds you from the inside out...")
			to_chat(H, span_danger(sun_msg))
			H.adjustFireLoss(rand(1, 70))
			next_burn = world.time + rand(120 SECONDS, 240 SECONDS)
	else
		if(in_sunlight)
			in_sunlight = FALSE
			H.remove_status_effect(/datum/status_effect/sun_scorched)
			H.remove_stress(/datum/stressevent/vice/astrata_scorched)
*/

/datum/virtue/unique/venomous_nature
	name = "Venomous Nature"
	desc = "My body produces a natural venom. When I bite and chew on someone, I inject them with poison. I am partially resistant to toxins myself."
	virtue_cost = 5
	added_traits = list(TRAIT_VENOMOUS, TRAIT_TOXRESIST)

/datum/virtue/unique/waterborn
	name = "Waterborn"
	desc = "I was born of the deeps. I can breathe underwater and swim with far less fatigue than others."
	virtue_cost = 5
	added_traits = list(TRAIT_WATERBREATHING, TRAIT_ABYSSOR_SWIM)

/datum/virtue/unique/feral_instincts
	name = "Feral Instincts"
	desc = "I was born with bestial traits - sharp claws and fangs. I can extend and retract my claws at will, and my bite is more effective than most. My effectiveness depends on my unarmed combat skill."
	virtue_cost = 5
	added_traits = list(TRAIT_FERAL_BITE)

/datum/virtue/unique/feral_instincts/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Grant the claw spell ability
	var/obj/effect/proc_holder/spell/self/feral_claws/claw_ability = new(recipient)
	recipient.mind.AddSpell(claw_ability)

// Crafter Feats - Apprenticeships that grant crafting expertise

/datum/virtue/utility/blacksmith/trait
	name = "Blacksmith's Apprentice"
	desc = "In my youth, I worked under a skilled blacksmith, honing my skills with an anvil."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/weaponsmithing, 2, 2),
						list(/datum/skill/craft/armorsmithing, 2, 2),
						list(/datum/skill/craft/blacksmithing, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2))

/datum/virtue/utility/tailor/trait
	name = "Tailor's Apprentice"
	desc = "In my youth, I worked under a skilled tailor, studying fabric and design."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_SEWING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2))
	added_stashed_items = list(
		"Needle" = /obj/item/needle,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors)

/datum/virtue/utility/physician/trait
	name = "Physician's Apprentice"
	desc = "In my youth, I worked under a skilled physician, studying medicine and alchemy."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	added_stashed_items = list("Medicine Pouch" = /obj/item/storage/belt/rogue/pouch/medicine)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/alchemy, 2, 2),
						list(/datum/skill/misc/medicine, 2, 2))

/datum/virtue/utility/physician/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

/datum/virtue/utility/hunter/trait
	name = "Hunter's Apprentice"
	desc = "In my youth, I trained under a skilled hunter, learning how to butcher animals and work with leather/hide."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_SURVIVAL_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/traps, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
						list(/datum/skill/misc/tracking, 2, 2))

/datum/virtue/utility/artificer/trait
	name = "Artificer's Apprentice"
	desc = "In my youth, I worked under a skilled artificer, studying construction and engineering."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/carpentry, 2, 2),
						list(/datum/skill/craft/masonry, 2, 2),
						list(/datum/skill/craft/engineering, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2),
						list(/datum/skill/craft/ceramics, 2, 2))
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/wood,
		"Chisel" = /obj/item/rogueweapon/chisel,
		"Hand Saw" = /obj/item/rogueweapon/handsaw)

/datum/virtue/utility/mining/trait
	name = "Miner's Apprentice"
	desc = "The dark shafts, the damp smells of ichor and the laboring hours are no stranger to me. I keep my pickaxe and lamptern close, and have been taught how to mine well."
	category = "feats"
	virtue_cost = 6
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_stashed_items = list(
		"Steel Pickaxe" = /obj/item/rogueweapon/pick/steel,
		"Lamptern" = /obj/item/flashlight/flare/torch/lantern)
	added_skills = list(list(/datum/skill/labor/mining, 3, 6))
