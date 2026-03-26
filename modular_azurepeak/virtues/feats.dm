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

/datum/virtue/combat/trained_and_ready
	name = "Trained & Ready"
	desc = "I've trained with various weapons and kept them close at hand. I can select my proficiencies and stashed weapons."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick up to 3 weapon proficiencies for free. Additional selections cost Triumphs. Each grants Journeyman skill and a stashed weapon."
	
	// Virtue choice system configuration
	free_choices = 3
	max_choices = 6
	choice_triumph_cost = 1

/datum/virtue/combat/trained_and_ready/New()
	. = ..()
	virtue_choices = list(
		"Swords" = list(
			"skills" = list(list(/datum/skill/combat/swords, 2, 3)),
			"items" = list("Iron Messer" = /obj/item/rogueweapon/sword/short/messer/iron/virtue),
			"cost" = 0,
			"desc" = "Journeyman with swords + Iron Messer"
		),
		"Axes" = list(
			"skills" = list(list(/datum/skill/combat/axes, 2, 3)),
			"items" = list("Iron Axe" = /obj/item/rogueweapon/stoneaxe/woodcut),
			"cost" = 0,
			"desc" = "Journeyman with axes + Iron Axe"
		),
		"Maces" = list(
			"skills" = list(list(/datum/skill/combat/maces, 2, 3)),
			"items" = list("Iron Mace" = /obj/item/rogueweapon/mace),
			"cost" = 0,
			"desc" = "Journeyman with maces + Iron Mace"
		),
		"Polearms" = list(
			"skills" = list(list(/datum/skill/combat/polearms, 2, 3)),
			"items" = list("Wooden Spear" = /obj/item/rogueweapon/spear),
			"cost" = 0,
			"desc" = "Journeyman with polearms + Wooden Spear"
		),
		"Knives" = list(
			"skills" = list(list(/datum/skill/combat/knives, 2, 3)),
			"items" = list("Bronze Hunting Knife" = /obj/item/rogueweapon/huntingknife/bronze),
			"cost" = 0,
			"desc" = "Journeyman with knives + Bronze Hunting Knife"
		),
		"Bows" = list(
			"skills" = list(list(/datum/skill/combat/bows, 2, 3)),
			"items" = list("Recurve Bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve, "Quiver of Arrows" = /obj/item/quiver/arrows),
			"cost" = 0,
			"desc" = "Journeyman with bows + Recurve Bow & Quiver"
		),
		"Crossbows" = list(
			"skills" = list(list(/datum/skill/combat/crossbows, 2, 3)),
			"items" = list("Crossbow" = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, "Quiver of Bolts" = /obj/item/quiver/bolts),
			"cost" = 0,
			"desc" = "Journeyman with crossbows + Crossbow & Bolts"
		),
		"Wrestling" = list(
			"skills" = list(list(/datum/skill/combat/wrestling, 2, 3)),
			"cost" = 0,
			"desc" = "Journeyman with wrestling"
		),
		"Unarmed" = list(
			"skills" = list(list(/datum/skill/combat/unarmed, 2, 3)),
			"items" = list("Bronze Knuckles" = /obj/item/rogueweapon/knuckles/bronzeknuckles, "Bronze Knuckles #2" = /obj/item/rogueweapon/knuckles/bronzeknuckles),
			"cost" = 0,
			"desc" = "Journeyman unarmed + Pair of Bronze Knuckles"
		),
		"Whips & Flails" = list(
			"skills" = list(list(/datum/skill/combat/whipsflails, 2, 3)),
			"items" = list("Leather Whip" = /obj/item/rogueweapon/whip),
			"cost" = 0,
			"desc" = "Journeyman with whips/flails + Leather Whip"
		),
		"Shields" = list(
			"skills" = list(list(/datum/skill/combat/shields, 2, 3)),
			"items" = list("Wooden Shield" = /obj/item/rogueweapon/shield/wood),
			"cost" = 0,
			"desc" = "Journeyman with shields + Wooden Shield"
		)
	)
	
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

/datum/virtue/utility/deadened
	name = "Deadened"
	desc = "Some terrible incident colours my past, and now, I feel nothing."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_NOMOOD)

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
	custom_text = "Maximizes Assess benefits with a bonus of the target's Stats. Allows the choice of up to 6 languages to learn upon joining. First 3 languages are free, additional ones cost Triumphs. +1 INT."
	added_traits = list(TRAIT_INTELLECTUAL)
	added_skills = list(list(/datum/skill/misc/reading, 3, 6))
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit
	)
	
	// Virtue choice system configuration
	free_choices = 3
	max_choices = 6
	choice_triumph_cost = 1

/datum/virtue/utility/linguist/New()
	. = ..()
	// Build language choices dynamically
	var/static/list/selectable_languages = list(
		"Elvish" = /datum/language/elvish,
		"Dwarvish" = /datum/language/dwarvish,
		"Orcish" = /datum/language/orcish,
		"Hellspeak" = /datum/language/hellspeak,
		"Draconic" = /datum/language/draconic,
		"Celestial" = /datum/language/celestial,
		"Grenzelhoftian" = /datum/language/grenzelhoftian,
		"Canilunzt" = /datum/language/canilunzt,
		"Kazengunese" = /datum/language/kazengunese,
		"Otavan" = /datum/language/otavan,
		"Etruscan" = /datum/language/etruscan,
		"Gronnic" = /datum/language/gronnic,
		"Aavnic" = /datum/language/aavnic,
		"Abyssal" = /datum/language/abyssal,
		"Merar" = /datum/language/merar
	)
	
	virtue_choices = list()
	for(var/lang_name in selectable_languages)
		virtue_choices[lang_name] = list(
			"languages" = list(selectable_languages[lang_name]),
			"cost" = 0,
			"desc" = "Learn [lang_name]"
		)

/datum/virtue/utility/linguist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.change_stat(STATKEY_INT, 1)
	// Filter out languages the character already knows before showing choices
	if(LAZYLEN(virtue_choices))
		var/list/filtered_choices = list()
		for(var/choice_name in virtue_choices)
			var/list/choice_data = virtue_choices[choice_name]
			if(LAZYLEN(choice_data["languages"]))
				var/language_type = choice_data["languages"][1]
				if(!recipient.has_language(language_type))
					filtered_choices[choice_name] = choice_data
		
		// Temporarily swap in filtered choices
		var/list/original_choices = virtue_choices
		virtue_choices = filtered_choices
		// Call parent to handle choices (will be picked up by handle_virtue_choices)
		. = ..()
		virtue_choices = original_choices

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

// ============ COMBINED VIRTUES ============
// These virtues combine multiple individual virtues into one with selectable bonuses

/datum/virtue/utility/prowler
	name = "Prowler"
	desc = "I've spent years in the shadows - skulking, stealing, and surviving. I can pick locks, move silently, see in the dark, and even disguise my voice when needed."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick 2 prowler skills for free. Additional selections cost Triumphs. Choose from: Light Steps (quiet movement), Night Vision (see in dark), Second Voice (voice changing), or Lockpicking (open locks)."
	
	// Virtue choice system configuration
	free_choices = 2
	max_choices = 4
	choice_triumph_cost = 1

/datum/virtue/utility/prowler/New()
	. = ..()
	virtue_choices = list(
		"Light Steps" = list(
			"traits" = list(TRAIT_LIGHT_STEP),
			"skills" = list(list(/datum/skill/misc/sneaking, 3, 6)),
			"cost" = 0,
			"desc" = "Quiet steps and faster hunched movement"
		),
		"Night Vision" = list(
			"traits" = list(TRAIT_DARKVISION),
			"cost" = 0,
			"desc" = "See through darkness"
		),
		"Second Voice" = list(
			"cost" = 0,
			"desc" = "Change and swap your voice"
		),
		"Lockpicking" = list(
			"skills" = list(list(/datum/skill/misc/lockpicking, 3, 6)),
			"items" = list("Lockpick Ring" = /obj/item/lockpickring/mundane),
			"cost" = 0,
			"desc" = "Expert lockpicking + lockpick ring"
		)
	)

/datum/virtue/utility/prowler/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Add special abilities based on selections - must happen after handle_virtue_choices
	// This will be called after parent completes

/datum/virtue/utility/prowler/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	// After parent handles choices, add special abilities for Second Voice
	if("Second Voice" in selected_choice_names)
		recipient.verbs |= /mob/living/carbon/human/proc/changevoice
		recipient.verbs |= /mob/living/carbon/human/proc/swapvoice
		to_chat(recipient, span_notice("Gained voice-changing abilities."))

/datum/virtue/utility/well_off
	name = "Well Off"
	desc = "Through fortune, charm, or shrewd dealings, I've secured a comfortable position in society. I can choose to be beautiful, wealthy, or a resident of the vale."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick 2 benefits for free. Additional selections cost Triumphs. Choose from: Beautiful (attractive & good lover), Resident (vale citizenship), Wealthy (see prices, appraise spell, coin purse), or Empathic Reading."
	
	// Virtue choice system configuration
	free_choices = 2
	max_choices = 4
	choice_triumph_cost = 1

/datum/virtue/utility/well_off/New()
	. = ..()
	virtue_choices = list(
		"Beautiful" = list(
			"traits" = list(TRAIT_BEAUTIFUL, TRAIT_GOODLOVER),
			"items" = list("Hand Mirror" = /obj/item/handmirror),
			"cost" = 0,
			"desc" = "Attractive appearance and skilled lover"
		),
		"Resident" = list(
			"traits" = list(TRAIT_RESIDENT),
			"cost" = 0,
			"desc" = "Resident of the vale with treasury account"
		),
		"Wealthy" = list(
			"traits" = list(TRAIT_SEEPRICES),
			"skills" = list(list(/datum/skill/misc/reading, 1, 6)),
			"items" = list("Weighty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch),
			"cost" = 0,
			"desc" = "See prices, appraise wealth, large coinpurse"
		),
		"Empathic" = list(
			"traits" = list(TRAIT_EMPATH),
			"cost" = 0,
			"desc" = "Read emotions and social cues"
		)
	)

/datum/virtue/utility/well_off/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Special handling will occur in handle_virtue_choices

/datum/virtue/utility/well_off/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	// After parent handles choices, add special abilities
	if("Wealthy" in selected_choice_names)
		if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/appraise/secular))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
		to_chat(recipient, span_notice("Gained appraise spell."))
	// Resident trait is handled globally in apply_virtue proc

/datum/virtue/utility/skilled_apprentice
	name = "Skilled Apprentice"
	desc = "I've apprenticed under various master craftsmen, learning diverse trades. I can select which crafts I've studied."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick 2 trade skills for free. Additional selections cost Triumphs. Each grants Journeyman-level skills and relevant tools."
	
	// Virtue choice system configuration
	free_choices = 2
	max_choices = 5
	choice_triumph_cost = 1
	
/datum/virtue/utility/skilled_apprentice/New()
	. = ..()
	virtue_choices = list(
		"Blacksmithing" = list(
			"traits" = list(TRAIT_SMITHING_EXPERT),
			"skills" = list(
				list(/datum/skill/craft/crafting, 2, 2),
				list(/datum/skill/craft/weaponsmithing, 2, 2),
				list(/datum/skill/craft/armorsmithing, 2, 2),
				list(/datum/skill/craft/blacksmithing, 2, 2),
				list(/datum/skill/craft/smelting, 2, 2)
			),
			"cost" = 0,
			"desc" = "Smithing expertise + metalworking skills"
		),
		"Tailoring" = list(
			"traits" = list(TRAIT_SEWING_EXPERT),
			"skills" = list(
				list(/datum/skill/craft/crafting, 2, 2),
				list(/datum/skill/labor/butchering, 2, 2),
				list(/datum/skill/craft/sewing, 2, 2),
				list(/datum/skill/craft/tanning, 2, 2)
			),
			"items" = list("Needle" = /obj/item/needle, "Scissors" = /obj/item/rogueweapon/huntingknife/scissors),
			"cost" = 0,
			"desc" = "Sewing expertise + tailoring skills & tools"
		),
		"Medicine" = list(
			"traits" = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT),
			"skills" = list(
				list(/datum/skill/craft/crafting, 2, 2),
				list(/datum/skill/craft/alchemy, 2, 2),
				list(/datum/skill/misc/medicine, 2, 2)
			),
			"items" = list("Medicine Pouch" = /obj/item/storage/belt/rogue/pouch/medicine),
			"cost" = 0,
			"desc" = "Medicine & alchemy expertise + diagnose spell"
		),
		"Hunting" = list(
			"traits" = list(TRAIT_SURVIVAL_EXPERT),
			"skills" = list(
				list(/datum/skill/craft/crafting, 2, 2),
				list(/datum/skill/craft/traps, 2, 2),
				list(/datum/skill/labor/butchering, 2, 2),
				list(/datum/skill/craft/sewing, 2, 2),
				list(/datum/skill/craft/tanning, 2, 2),
				list(/datum/skill/misc/tracking, 2, 2)
			),
			"cost" = 0,
			"desc" = "Survival expertise + hunting & tracking skills"
		),
		"Engineering" = list(
			"traits" = list(TRAIT_SMITHING_EXPERT),
			"skills" = list(
				list(/datum/skill/craft/crafting, 2, 2),
				list(/datum/skill/craft/carpentry, 2, 2),
				list(/datum/skill/craft/masonry, 2, 2),
				list(/datum/skill/craft/engineering, 2, 2),
				list(/datum/skill/craft/smelting, 2, 2),
				list(/datum/skill/craft/ceramics, 2, 2)
			),
			"items" = list(
				"Hammer" = /obj/item/rogueweapon/hammer/wood,
				"Chisel" = /obj/item/rogueweapon/chisel,
				"Hand Saw" = /obj/item/rogueweapon/handsaw
			),
			"cost" = 0,
			"desc" = "Smithing expertise + construction & engineering skills"
		)
	)

/datum/virtue/utility/skilled_apprentice/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Special abilities handled in handle_virtue_choices

/datum/virtue/utility/skilled_apprentice/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	// After parent handles choices, add special abilities
	if("Medicine" in selected_choice_names)
		if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		to_chat(recipient, span_notice("Gained diagnose spell."))

/datum/virtue/utility/laborious_apprentice
	name = "Laborious Apprentice"
	desc = "I've worked hard labor in my youth - mining ores from deep shafts or felling trees in the forest. I've kept my tools close."
	category = "feats"
	virtue_cost = 3
	custom_text = "Pick 2 labor skills for free. Additional selections cost Triumphs. Choose from: Mining (pickaxe & lantern) or Lumberjacking (axe & wood skills)."
	
	// Virtue choice system configuration
	free_choices = 2
	max_choices = 2
	choice_triumph_cost = 0  // Can't pick more than 2 anyway

/datum/virtue/utility/laborious_apprentice/New()
	. = ..()
	virtue_choices = list(
		"Mining" = list(
			"traits" = list(TRAIT_SMITHING_EXPERT),
			"skills" = list(list(/datum/skill/labor/mining, 3, 6)),
			"items" = list(
				"Steel Pickaxe" = /obj/item/rogueweapon/pick/steel,
				"Lamptern" = /obj/item/flashlight/flare/torch/lantern
			),
			"cost" = 0,
			"desc" = "Expert mining + pickaxe & lantern"
		),
		"Lumberjacking" = list(
			"skills" = list(list(/datum/skill/labor/lumberjacking, 3, 6)),
			"items" = list("Iron Axe" = /obj/item/rogueweapon/stoneaxe/woodcut),
			"cost" = 0,
			"desc" = "Expert lumberjacking + iron axe"
		)
	)

// Crafter Feats - Apprenticeships removed and consolidated into Skilled Apprentice and Laborious Apprentice choice-based virtues
