// Arcyne Potential now gives 3 Spellpoints instead of 6 spellpoints so it is less of a "must take" for caster.
/datum/virtue/combat/magical_potential
	name = "Arcyne Potential"
	desc = "I am talented in the Arcyne arts, expanding my capacity for magic. I have become more intelligent from its studies. Other effects depends on what training I chose to focus on at a later age."
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

/datum/virtue/combat/duelist
	name = "Duelist's Apprentice"
	desc = "I have trained under a duelist of considerable skill. I have a pair of dueling weapons - both a hunting sword and dagger - stowed away."
	custom_text = "Guaranteed Journeyman for Swords & Knives."
	added_stashed_items = list("Duelist's Messer" = /obj/item/rogueweapon/sword/short/messer/iron/virtue,
								"Duelist's Parrying Dagger" = /obj/item/rogueweapon/huntingknife/idagger/virtue)

/datum/virtue/combat/duelist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/combat/executioner
	name = "Dungeoneer's Apprentice"
	desc = "I was set to be a dungeoneer some time ago, and I was taught by one. I have an axe and whip stashed away, should the need arise."
	custom_text = "Guaranteed Journeyman for Axes & Whips/Flails."
	added_stashed_items = list("Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
								"Whip" = /obj/item/rogueweapon/whip)

/datum/virtue/combat/executioner/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/combat/militia
	name = "Militiaman"
	desc = "I have trained with the local garrison in case I'm ever to be levied to fight for my lord. I have a spear and mace stashed away in the event I'm called to arms."
	custom_text = "Guaranteed Journeyman for Polearms & Maces."
	added_stashed_items = list("Spear" = /obj/item/rogueweapon/spear,
								"Mace" = /obj/item/rogueweapon/mace)

/datum/virtue/combat/militia/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/combat/brawler
	name = "Brawler's Apprentice"
	desc = "I have trained under a skilled brawler, and have some experience fighting with my fists. I have a katar and some knuckledusters stashed away, too."
	custom_text = "Guaranteed Journeyman for Unarmed & Wrestling."
	added_stashed_items = list("Knuckles" = /obj/item/rogueweapon/knuckles/bronzeknuckles,
								"More Knuckles" = /obj/item/rogueweapon/knuckles/bronzeknuckles)

/datum/virtue/combat/brawler/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)


/datum/virtue/combat/bowman
	name = "Toxophilite"
	desc = "I've had an interest in archery from a young age, and I always keep a spare bow and quiver around."
	custom_text = "+1 to Bows, Up to Legendary, Minimum Apprentice"
	added_stashed_items = list("Recurve Bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
								"Quiver (Arrows)" = /obj/item/quiver/arrows
	)

/datum/virtue/combat/bowman/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/bows) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/bows, 1, 6))

/datum/virtue/combat/crossbowman
	name = "Crossbow Levy"
	desc = "A crossbow is a simple weapon to use, but that's what makes it so effective. I've always kept a crossbow and some bolts around, just in case."
	custom_text = "+1 to Crossbows, Up to Legendary, Minimum Apprentice"
	added_stashed_items = list("Crossbow" = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
								"Quiver (Bolts)" = /obj/item/quiver/bolts
	)

/datum/virtue/combat/crossbowman/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/crossbows) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/crossbows, 1, 6))

/datum/virtue/combat/shepherd
	name = "Capable Shepherd"
	desc = "Years of protecting my herd from brigands and thieves have taught me how to use the simplest of weapons in self-defense."
	custom_text = "Guaranteed Journeyman for Staffs & Slings."
	added_stashed_items = list("Iron Quarterstaff" = /obj/item/rogueweapon/woodstaff/quarterstaff/iron,
								"Sling" = /obj/item/gun/ballistic/revolver/grenadelauncher/sling,
								"Pouch of Iron Sling Bullets" = /obj/item/quiver/sling/iron)

/datum/virtue/combat/shepherd/apply_to_human(mob/living/carbon/human/recipient)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	recipient.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/*/datum/virtue/combat/tavern_brawler
	name = "Tavern Brawler"
	desc = "I've never met a problem my fists couldn't solve."
	added_traits = list(TRAIT_CIVILIZEDBARBARIAN)*/

/datum/virtue/combat/guarded
	name = "Guarded"
	desc = "I have long kept my true capabilities and vices a secret. Sometimes being deceptively weak can save one's lyfe."
	custom_text = "Obfuscates information about you from all sorts of effects, including patron abilities & passives, Assess and other virtues."
	added_traits = list(TRAIT_DECEIVING_MEEKNESS)

/*/datum/virtue/combat/impervious
	name = "Impervious"
	desc = "I've spent years shoring up my weakspots, and have become difficult to wound with critical blows."
	added_traits = list(TRAIT_CRITICAL_RESISTANCE)*/

#define SC_ROTCURED "Rotcured"
#define SC_PALLID "Pallid"
#define SC_BLACKBLOOD "Blackblood"

/// The traits each Second Chance option grants, under SECOND_CHANCE_TRAIT so they can be stripped again without touching other virtues' traits.
GLOBAL_LIST_INIT(second_chance_traits, list(
	SC_ROTCURED = list(TRAIT_ROTMAN, TRAIT_EASYDISMEMBER, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_NOBREATH, TRAIT_NOHUNGER, TRAIT_TOXIMMUNE, TRAIT_ZOMBIE_IMMUNE, TRAIT_SILVER_WEAK),
	SC_PALLID = list(TRAIT_PALLID, TRAIT_DARKVISION, TRAIT_NOBREATH, TRAIT_ZOMBIE_IMMUNE, TRAIT_SILVER_WEAK),
	SC_BLACKBLOOD = list(TRAIT_BLACKBLOOD, TRAIT_HALFHEAL, TRAIT_STRONGBITE, TRAIT_NASTY_EATER, TRAIT_DARKVISION, TRAIT_SILVER_WEAK),
))

/datum/virtue/combat/second_chance
	name = "Second Chance"
	desc = "Not many are given second chances. Somehow, you're among the lucky bastards who were. What foul, cruel fate did you narrowly escape, changed yet still living?"
	max_choices = 1
	// Not hungering would make Blackblood regeneration free and endless
	incompatible_virtues = list(/datum/virtue/utility/deathless)

	extra_choices = list(
		SC_ROTCURED,
		SC_PALLID,
		SC_BLACKBLOOD,
	)
	choice_tooltips = list(
		SC_ROTCURED = "<font color='#4a8d48'>I was once afflicted with the accursed rot, and was cured. It has left me changed: my limbs are weaker, but I feel no pain and have no need to breathe or eat.</font><br><br><font color=red>(Grants Easy Dismemberment, Painless, Enduring, Breathless, Foodless, Poison Immune, Deadite Immunity and Silver Weakness.)</font><br><br>(Additionally, you can eat brains and you don't suffer nausea. Food's lingering effects, good or bad, never take hold on you, and you feel nothing for your favourite or hated foods. Your heart does not beat, so anyone who checks your heartbeat or diagnoses you will find you dead. You cannot give mouth-to-mouth, and Necra refuses your vows. Hemophages still hunger, as their thirst cannot be cured away. Any silver on your person when you arrive is dropped.)",
		SC_PALLID = "<font color='#8d4848'>I was once a nite-creacher, be it lycanthrope or vampyre, but was cured by something close to divine intervention. It has left me changed: silver burns my flesh, and the open sky fills me with unease. Yet I draw no breath, and my eyes pierce the darkness. Lingering traces of the curse that once claimed me. Traces I hope will fade in time.</font><br><br><font color=red>(Grants Darksight, Breathless, Deadite Immunity and Silver Weakness.)</font><br><br>(Additionally, being outdoors, by day or by night, causes stress. Vampyres sicken on your blood. You cannot give mouth-to-mouth, and Necra refuses your vows. Any silver on your person when you arrive is dropped.)",
		SC_BLACKBLOOD = "<font color='#8b488d'>I was once a nite-creacher, be it lycanthrope or vampyre, before the Otavan Inquisition subdued and exported me as a test subject of an experimental \"cure\" for my Quicksilver-resistant taint. This intense therapy had me warped, inside, outside, body and mind, into something 'idealistically' humen-like for Otavan standards, even if I am now no different than a sentient, hollowed ghoul.</font><br><br><font color=red>(Grants Darksight, Laden Lux, Strong Bite, Inhumen Digestion and Silver Weakness.)</font><br><br>(Additionally, your blood runs black, and consuming any food will grant a minor healing buff. While not starving or dehydrated, you slowly mend your wounds and your bleeding clots faster, at the cost of hunger, though a severed artery will never close until it is stitched, even if it bleeds only half as fast. Silver fire halts both. This mending replaces Psydonite endurance rather than stacking with it, and anything that takes away your hunger for good, such as the Rituos, ends it. Lifeblood does nothing for you, but zarum does, and healing miracles pain you while only working half as well. You will feel stressed when exposed to Sunlight, and panic while being around or interacting with members of the Inquisition. Vampyres sicken on your blood. You will usually resist the Deadite plague and sometimes resist Lycanthropy, but you are not immune. Any silver on your person when you arrive is dropped.)",
	)

/datum/virtue/combat/second_chance/apply_to_human(mob/living/carbon/human/recipient)
	// Delayed because virtues are applied before quirks and the loadout hand out their items, so drop_worn_silver()
	// has to wait for those. Antags gained in the meantime are caught either way: before the grant by
	// second_chance_blocked(), after it by /datum/antagonist/on_gain(). Choices are snapshotted because src is
	// the player's prefs virtue, which they can still edit during the delay.
	addtimer(CALLBACK(src, PROC_REF(apply_second_chance), recipient, picked_choices.Copy()), 8 SECONDS)

/datum/virtue/combat/second_chance/proc/apply_second_chance(mob/living/carbon/human/recipient, list/chosen)
	if(QDELETED(recipient) || !recipient.mind || !length(chosen))
		return
	recipient.mind.second_chance_choices = chosen.Copy()
	if(recipient.mind.second_chance_blocked())
		to_chat(recipient, span_warning("My second chance lies dormant while I am what I am. Should that ever change, it will return."))
		return
	recipient.grant_second_chance(chosen, announce = TRUE)

/// Whether an antagonist this mind currently is stops their Second Chance applying.
/datum/mind/proc/second_chance_blocked()
	for(var/datum/antagonist/antag as anything in antag_datums)
		if(antag.blocks_second_chance())
			return TRUE
	return FALSE

/// Gives this body the traits and effects of the given Second Chance options.
/mob/living/carbon/human/proc/grant_second_chance(list/choices, announce = FALSE)
	for(var/choice in choices)
		for(var/trait in GLOB.second_chance_traits[choice])
			ADD_TRAIT(src, trait, SECOND_CHANCE_TRAIT)
		switch(choice)
			if(SC_ROTCURED)
				if(HAS_TRAIT(src, TRAIT_HEMOPHAGE)) // same as Deathless, the vice's thirst can't be cured away
					REMOVE_TRAIT(src, TRAIT_NOHUNGER, SECOND_CHANCE_TRAIT)
					if(announce)
						to_chat(src, "My reliance on lyfeblood cannot be severed!")
				if(announce)
					to_chat(src, span_notice("You are no longer a rotting corpse, at least not a dying one."))

			if(SC_PALLID)
				if(announce)
					to_chat(src, span_notice("You are no longer one scorned by Astrata, by the mercy of the gods."))

			if(SC_BLACKBLOOD)
				set_blood_color(BLOOD_COLOR_BLACKBLOOD)
				if(!announce)
					continue
				to_chat(src, span_notice("You are no longer one among the nite creechers, by the ingenuity of HIS followers."))
				// AP grants an "averse to Inquisition" flaw here; we have no averse flaw system, so this is just done through stress events and minor flavour
				if(patron?.type == /datum/patron/old_god)
					to_chat(src, span_blue("<i>You recall your horrid experiences with the Inquisition... But through your newfound faith in HIM, you ENDURE. You were but one wrong righted, after all.</i>"))
				else
					to_chat(src, span_blue("<i>You recall your horrid experiences with the Inquisition... It is rather traumatic. Best to avoid them.</i>"))
				to_chat(src, span_danger("DISCLAIMER: This Second Chance option exists to support roleplay and backstory continuity, not to diminish the threat or narrative weight of vampires, werewolves, or similar antagonistic entities. You are a tortured survivor of the Otavan Inquisition, and your very LUX fears them. Failure to roleplay this appropriately may result in this option's removal. Have fun and don't be cringe."))

	update_sight() // sight was already set when we spawned, so darkvision needs a refresh
	if(HAS_TRAIT(src, TRAIT_SILVER_WEAK))
		drop_worn_silver()

/// Drops any silver worn or held. Silver weakness only bites when silver is picked up or equipped, so anything already on us when we gain it has to go.
/mob/living/carbon/human/proc/drop_worn_silver()
	var/dropped_any = FALSE
	for(var/obj/item/worn as anything in get_equipped_items(include_pockets = TRUE) + held_items)
		if(!worn || !(worn.is_silver || worn.smeltresult == /obj/item/ingot/silver))
			continue
		if(dropItemToGround(worn))
			dropped_any = TRUE
	if(dropped_any)
		to_chat(src, span_warning("I cannot bear Silver on my person!"))

/// Lifts Second Chance's traits while an antagonist blocks it, such as being turned into a vampire or rising as a deadite. The choice stays on the mind, so it can be restored.
/mob/living/carbon/human/proc/suspend_second_chance(silent = FALSE)
	var/had_second_chance = FALSE
	for(var/choice in GLOB.second_chance_traits)
		for(var/trait in GLOB.second_chance_traits[choice])
			if(!HAS_TRAIT_FROM(src, trait, SECOND_CHANCE_TRAIT))
				continue
			had_second_chance = TRUE
			REMOVE_TRAIT(src, trait, SECOND_CHANCE_TRAIT)
	if(!had_second_chance)
		return
	set_blood_color(null)
	update_sight()
	if(!silent)
		to_chat(src, span_danger("Whatever second chance I was given, it slips away from me."))

/// For a body remade for the soul now in it, such as a foreign brain's forced revival.
/// Swaps the old owner's Second Chance, which lives on the flesh, for the new soul's own.
/mob/living/carbon/human/proc/rebind_second_chance()
	suspend_second_chance(silent = TRUE)
	set_blood_color(null) // the remade dna brought the soul's old blood colour, so let their own choice decide it
	if(!length(mind?.second_chance_choices) || mind.second_chance_blocked())
		return
	grant_second_chance(mind.second_chance_choices)

/// Brings back a suspended Second Chance on this body, once nothing blocks it any more. The choices are read from source_mind, which may not be in the body right now.
/mob/living/carbon/human/proc/restore_second_chance(datum/mind/source_mind = mind)
	if(!length(source_mind?.second_chance_choices) || source_mind.second_chance_blocked())
		return
	grant_second_chance(source_mind.second_chance_choices)
	to_chat(src, span_notice("My second chance returns to me, as it always has."))

/// Legacy virtue, replaced by Second Chance's Rotcured option. Kept nameless (so it never shows in the picker) only so old saves can be migrated.
/datum/virtue/combat/rotcured

/// Swaps a legacy virtue loaded from an old save for its current equivalent.
/proc/migrate_legacy_virtue(datum/virtue/loaded)
	if(!istype(loaded, /datum/virtue/combat/rotcured))
		return loaded
	var/datum/virtue/combat/second_chance/migrated = new()
	migrated.picked_choices = list(SC_ROTCURED)
	return migrated

#undef SC_ROTCURED
#undef SC_BLACKBLOOD
#undef SC_PALLID

/datum/virtue/combat/dualwielder
	name = "Dual Wielder"
	desc = "Whether it was by the Naledi scholars, Etruscan privateers or even the Kazengan senseis. I've been graced with the knowledge of how to wield two weapons at once."
	added_traits = list(TRAIT_DUALWIELDER)

/datum/virtue/combat/sharp
	name = "Sentinel of Wits"
	desc = "Whether it's by having an annoying sibling that kept prodding me with a stick, or years of study and observation, I've become adept at both parrying and dodging stronger opponents, by learning their moves and studying them."
	added_traits = list(TRAIT_SENTINELOFWITS)

/datum/virtue/combat/combat_aware
	name = "Combat Aware"
	desc = "The opponent's flick of their wrist. The sound of maille snapping. The desperate breath as the opponent's stamina wanes. All of this is made more clear to you through intuition or experience."
	custom_text = "Shows a lot more combat information via floating text. Has a toggle."
	added_traits = list(TRAIT_COMBAT_AWARE)

/datum/virtue/combat/combat_aware/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/togglecombatawareness

/datum/virtue/combat/tough_hide
	name = "Natural Armor"
	desc = "Whether by natural means or other means, my skin is strong enough to resist being pierced and cut."
	custom_text = "This will replace your SHIRT slot with a regenerating, unremoveable armor."
	added_traits = list(TRAIT_NATURALARMOR)

/datum/virtue/combat/tough_hide/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!recipient)
		return

	// Remove whatever shirt they spawned with
	var/obj/item/clothing/shirt = recipient.wear_shirt
	if(shirt)
		qdel(shirt)

	// Equip the skin armor
	recipient.equip_to_slot_or_del(
		new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/weak(recipient),
		SLOT_SHIRT,
		TRUE
	)
	
	if(alert(recipient, "Would you like to change the name or description of your skin?", "TOUGH HIDE", "MAKE IT SO", "I RESCIND") == "MAKE IT SO") // Query user
		addtimer(CALLBACK(src, PROC_REF(customize_skin), recipient), 1 SECONDS)

/datum/virtue/combat/tough_hide/proc/customize_skin(mob/living/carbon/human/recipient)
	var/obj/item/clothing/hide = recipient.wear_shirt
	var/vanished_hide = FALSE
	if(!QDELETED(hide))
		var/inputty = stripped_input(recipient, "What would you like to name your hide?", "TOUGH HIDE", null, 200)
		if(!QDELETED(hide))
			if(inputty)
				hide.name = inputty
		else
			vanished_hide = TRUE
		inputty = stripped_input(recipient, "How would you describe your hide?", "TOUGH HIDE", null, 200)
		if(!QDELETED(hide))
			if(inputty)
				hide.desc = inputty
		else
			vanished_hide = TRUE
	else
		vanished_hide = TRUE

	if(vanished_hide) //failsafe
		to_chat(recipient, span_warning("My natural armor vanished! Perhaps some divine intervention might sort things out..."))

