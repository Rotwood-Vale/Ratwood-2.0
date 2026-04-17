/datum/virtue/size/giant
	name = "Giant"
	desc = "I've always been larger, stronger and hardier than the average person. I tend to lumber around a lot, and my immense size can break down frail, wooden doors."
	category = "feats"
	virtue_cost = 5
	added_traits = list(TRAIT_BIGGUY, TRAIT_DEATHBYSNUSNU)
	custom_text = "Increases your sprite size."

/datum/virtue/size/giant/apply_to_human(mob/living/carbon/human/recipient)
	if(istype(recipient, /mob/living/carbon/human/dummy))
		return
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()
	recipient.change_stat("constitution", 1)

/datum/virtue/combat/magical_potential
	name = "Arcyne Potential"
	desc = "I am talented in the Arcyne arts, expanding my capacity for magic. I have become more intelligent from its studies. Other effects depends on what training I chose to focus on at a later age."
	category = "feats"
	virtue_cost = 5
	custom_text = "Classes that has a combat trait (Medium / Heavy Armor Training, Dodge Expert or Critical Resistance) get only prestidigitation. Everyone else get +3 spellpoints and T1 Arcyne Potential if they don't have any Arcyne."
	added_skills = list(list(/datum/skill/magic/arcane, 1, 6))

/datum/virtue/combat/magical_potential/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.get_skill_level(/datum/skill/magic/arcane))
		if (!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			ADD_TRAIT(recipient, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			recipient.mind?.adjust_spellpoints(3)
	else
		recipient.mind?.adjust_spellpoints(3)

/datum/virtue/combat/devotee
	name = "Devotee"
	desc = "Though not officially of the Church, my relationship with my chosen Patron is strong enough to grant me the most minor of their blessings. I've also kept a psycross of my deity."
	category = "feats"
	virtue_cost = 5
	custom_text = "You gain access to T0 miracles of your patron. As a non-combat role you also receive a minor passive devotion gain. If you already have access to Miracles, you get slightly increased passive devotion gain."

	added_skills = list(list(/datum/skill/magic/holy, 1, 6))

/datum/virtue/combat/devotee/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.mind)
		return
	if (!recipient.devotion)
		var/datum/devotion/new_faith = new /datum/devotion(recipient, recipient.patron)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = (CLERIC_REQ_1 - 10))
		else
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = FALSE, devotion_limit = (CLERIC_REQ_1 - 20))
	else

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
	desc = "By birth, blade or brain, I am noble known to the royalty of these lands. I can select which privileges of nobility I possess."
	category = "feats"
	virtue_cost = 5
	custom_text = "All noble privileges cost Virtue Points. Choose from: Heirloom Amulet, Hefty Coinpurse, Noble Income, or Full Noble Rank."
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	
	free_choices = 0
	max_choices = 4
	choice_virtue_point_cost = 2

/datum/virtue/utility/noble/New()
	. = ..()
	virtue_choices = list(
		"Heirloom Amulet" = list(
			"items" = list("Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble),
			"cost" = 0,
			"desc" = "A family heirloom amulet"
		),
		"Hefty Coinpurse" = list(
			"items" = list("Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch),
			"cost" = 0,
			"desc" = "A large purse filled with coins"
		),
		"Noble Income" = list(
			"cost" = 0,
			"desc" = "Regular income from noble holdings"
		),
		"Full Noble Rank" = list(
			"cost" = 0,
			"desc" = "Full noble social rank instead of minor noble"
		)
	)

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()

/datum/virtue/utility/noble/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	if("Noble Income" in selected_choice_names)
		SStreasury.noble_incomes[recipient] += 15
		to_chat(recipient, span_notice("Gained noble income from holdings."))
	
	if("Full Noble Rank" in selected_choice_names)
		recipient.social_rank = SOCIAL_RANK_NOBLE
		to_chat(recipient, span_notice("Your social rank is that of a full noble."))

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
	
	free_choices = 3
	max_choices = 6
	choice_virtue_point_cost = 1

/datum/virtue/utility/linguist/New()
	. = ..()
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
	if(LAZYLEN(virtue_choices))
		var/list/filtered_choices = list()
		for(var/choice_name in virtue_choices)
			var/list/choice_data = virtue_choices[choice_name]
			if(LAZYLEN(choice_data["languages"]))
				var/language_type = choice_data["languages"][1]
				if(!recipient.has_language(language_type))
					filtered_choices[choice_name] = choice_data
		
		var/list/original_choices = virtue_choices
		virtue_choices = filtered_choices
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

/datum/virtue/utility/performer
	name = "Performer"
	desc = "Music, artistry and the act of showmanship carried me through life. I've hidden a favorite instrument of mine, know how to please anyone I touch, and how to crack the eggs of hecklers."
	category = "feats"
	virtue_cost = 4
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
	virtue_cost = 5
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
	virtue_cost = 2
	custom_text = "Prevents you from experiencing negative stress events when looking at select species."
	added_traits = list(TRAIT_TOLERANT)


/datum/virtue/thief/drug_runner
	name = "Dust Runner"
	desc = "I run dust for the Thieves' Guild, and an associate has left a delivery in my stash nearby for me to pick up."
	category = "feats"
	virtue_cost = 4
	added_stashed_items = list("Satchel #1" = /obj/item/storage/backpack/rogue/satchel/mule,
							"Satchel #2" = /obj/item/storage/backpack/rogue/satchel/mule,
							"Dagger" = /obj/item/rogueweapon/huntingknife/idagger
	)

/datum/virtue/utility/granary
	name = "Cunning Provisioner"
	desc = "You've worked in or around the docks enough to steal away a sack of supplies that no one would surely miss, just in case. You've picked up on some cooking and fishing tips in your spare time, as well."
	category = "feats"
	virtue_cost = 4
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	added_stashed_items = list("Bag of Food" = /obj/item/storage/roguebag/food)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 6),
						list(/datum/skill/labor/fishing, 2, 6))

/datum/virtue/utility/forester
	name = "Forester"
	desc = "The forest is your home, or at least, it used to be. You always long to return and roam free once again, and you have not forgotten your knowledge on how to be self sufficient."
	category = "feats"
	virtue_cost = 4
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
	virtue_cost = 4
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
	virtue_cost = 4
	added_skills = list(list(/datum/skill/craft/alchemy, 1, 6))
	added_traits = list(TRAIT_ALCHEMY_EXPERT) // Kaboom
	added_stashed_items = list("Firebomb #1" = /obj/item/bomb,
								"Firebomb #2" = /obj/item/bomb
	)

/datum/virtue/utility/prowler
	name = "Prowler"
	desc = "I've spent years in the shadows - skulking, stealing, and surviving. I can pick locks, move silently, see in the dark, and even disguise my voice when needed."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick 2 prowler skills for free. Additional selections cost Virtue Points. Choose from: Light Steps, Night Vision, Second Voice, Lockpicking, Acrobatic, Sleuth, or Keen Ears."
	
	free_choices = 2
	max_choices = 7
	choice_virtue_point_cost = 3

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
		),
		"Acrobatic" = list(
			"traits" = list(TRAIT_LEAPER),
			"cost" = 0,
			"desc" = "Powerful legs for precise leaping"
		),
		"Sleuth" = list(
			"traits" = list(TRAIT_SLEUTH),
			"skills" = list(list(/datum/skill/misc/tracking, 3, 6)),
			"cost" = 0,
			"desc" = "Expert tracking with enhanced abilities"
		),
		"Keen Ears" = list(
			"traits" = list(TRAIT_KEENEARS),
			"cost" = 0,
			"desc" = "Hear speakers through walls and whispers further"
		)
	)

/datum/virtue/utility/prowler/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()

/datum/virtue/utility/prowler/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	if("Second Voice" in selected_choice_names)
		recipient.verbs |= /mob/living/carbon/human/proc/changevoice
		recipient.verbs |= /mob/living/carbon/human/proc/swapvoice
		to_chat(recipient, span_notice("Gained voice-changing abilities."))

/datum/virtue/utility/well_off
	name = "Well Off"
	desc = "Through fortune, charm, or shrewd dealings, I've secured a comfortable position in society. I can choose to be beautiful, wealthy, or a resident of the vale."
	category = "feats"
	virtue_cost = 2
	custom_text = "Pick 1 benefit for free. Additional selections cost Virtue Points. Choose from: Beautiful (attractive & good lover), Resident (vale citizenship), Wealthy (see prices, appraise spell, coin purse), or Empathic Reading."
	
	free_choices = 1
	max_choices = 4
	choice_virtue_point_cost = 2

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

/datum/virtue/utility/well_off/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	if("Wealthy" in selected_choice_names)
		if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/appraise/secular))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
		to_chat(recipient, span_notice("Gained appraise spell."))

/datum/virtue/utility/skilled_apprentice
	name = "Skilled Apprentice"
	desc = "I've apprenticed under various master craftsmen, learning diverse trades. I can select which crafts I've studied."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick 2 trade skills for free. Additional selections cost Virtue Points. Each grants Journeyman-level skills and relevant tools."
	
	free_choices = 2
	max_choices = 5
	choice_virtue_point_cost = 1
	
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

/datum/virtue/utility/skilled_apprentice/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	if("Medicine" in selected_choice_names)
		if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		to_chat(recipient, span_notice("Gained diagnose spell."))

/datum/virtue/utility/laborious_apprentice
	name = "Laborious Apprentice"
	desc = "I've worked hard labor in my youth - mining ores from deep shafts or felling trees in the forest. I've kept my tools close."
	category = "feats"
	virtue_cost = 3
	custom_text = "Pick 2 labor skills for free. Additional selections cost Virtue Points. Choose from: Mining (pickaxe & lantern) or Lumberjacking (axe & wood skills)."
	
	free_choices = 2
	max_choices = 2
	choice_virtue_point_cost = 0

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

/datum/virtue/utility/wild_born
	name = "Wild Born"
	desc = "Born of the wilds, I possess primal traits that set me apart. My body adapted to survive in harsh, untamed environments."
	category = "feats"
	virtue_cost = 5
	custom_text = "Pick 2 primal traits for free. Additional selections cost Virtue Points. Choose from: Venomous Nature, Waterborn, Feral Instincts, or Feral Appetite."
	

	free_choices = 1
	max_choices = 4
	choice_virtue_point_cost = 2

/datum/virtue/utility/wild_born/New()
	. = ..()
	virtue_choices = list(
		"Venomous Nature" = list(
			"traits" = list(TRAIT_VENOMOUS, TRAIT_TOXRESIST),
			"cost" = 0,
			"desc" = "Produce natural venom when biting + toxin resistance"
		),
		"Waterborn" = list(
			"traits" = list(TRAIT_WATERBREATHING, TRAIT_ABYSSOR_SWIM),
			"cost" = 0,
			"desc" = "Breathe underwater and swim with less fatigue"
		),
		"Feral Instincts" = list(
			"traits" = list(TRAIT_FERAL_BITE),
			"cost" = 0,
			"desc" = "Retractable claws and stronger bite attacks"
		),
		"Feral Appetite" = list(
			"traits" = list(TRAIT_NASTY_EATER),
			"cost" = 0,
			"desc" = "Eat raw, toxic, or spoiled food without issue"
		)
	)

/datum/virtue/utility/wild_born/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()

/datum/virtue/utility/wild_born/handle_virtue_choices(mob/living/carbon/human/recipient, list/selected_choice_names)
	. = ..()
	if("Feral Instincts" in selected_choice_names)
		var/obj/effect/proc_holder/spell/self/feral_claws/claw_ability = new(recipient)
		recipient.mind.AddSpell(claw_ability)
		to_chat(recipient, span_notice("Gained retractable claws ability."))
	
	if("Feral Appetite" in selected_choice_names)
		if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
			to_chat(recipient, "My reliance on lyfeblood cannot be severed!")
			REMOVE_TRAIT(recipient, TRAIT_NASTY_EATER, TRAIT_VIRTUE)
