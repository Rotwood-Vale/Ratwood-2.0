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

/datum/virtue/combat/second_chance
	name = "Second Chance"
	desc = "Not many are given second chances. Somehow, you're among the lucky bastards who were. What foul, cruel fate did you narrowly escape, changed yet still living?"
	max_choices = 1
	restricted = TRUE
	races = list(/datum/species/construct/metal, /datum/species/gnoll)

	extra_choices = list(
		SC_ROTCURED,
		SC_PALLID,
		SC_BLACKBLOOD,
	)
	choice_tooltips = list(
		SC_ROTCURED = "<font color='#4a8d48'>I was once afflicted with the accursed rot, and was cured. It has left me changed: my limbs are weaker, but I feel no pain and have no need to breathe.<br><br><font color=red>(Grants Easy Dismember, Painless, Breathless, Deathless, Poison Immune, Deadite Immune, Silver Weakness.)<font color=white><br><br>(Additionally, you can eat brains, you don't suffer nausea, and your heart does not beat.)</font>",
		SC_PALLID = "<font color='#8d4848'>I was once afflicted with vampirism, but was cured by something close to divine intervention. It has left me changed: silver burns my flesh, and the open sky fills me with unease. Yet I draw no breath, and my eyes pierce the darkness. Lingering traces of the curse that once claimed me. Traces I hope will fade in time.<br><br><font color=red>(Grants Darkvision, Breathless, Deadite Immunity and Silver Weakness.)<br><br><font color=white>(Additionally, being outdoors causes stress.)</font>",
		SC_BLACKBLOOD = "<font color='#8b488d'>I was once a nite-creacher, be it lycanthrope or vampyre, before the Otavan Inquisition subdued and exported me as a test subject of an experimental \"cure\" for my Quicksilver-resistant taint. This intense therapy had me warped, inside, outside, body and mind, into something 'idealistically' humen-like for Otavan standards, even if I am now no different than a sentient, hollowed ghoul.<br><br><font color=red>(Grants Darkvision, Leaden Lux, Strong Bite, Inhumen Digestion, and Silver Weakness.)<br><br><font color=white>(Additionally, consuming any food will grant a minor healing buff. You bleed slower and passively recover from wounds (while not hungry). You will feel stressed when exposed to Sunlight, and panic while being around or interacting with members of the Inquisition. You are somewhat resistant to Lycanthropy, but not immune.)",
	)

/datum/virtue/combat/second_chance/apply_to_human(mob/living/carbon/human/recipient)
	// Delayed so antag datums have been handed out by the time we check them. Choices are snapshotted
	// because src is the player's prefs virtue, which they can still edit during the delay.
	addtimer(CALLBACK(src, .proc/apply_second_chance, recipient, picked_choices.Copy()), 8 SECONDS)

/datum/virtue/combat/second_chance/proc/apply_second_chance(mob/living/carbon/human/recipient, list/chosen)
	if(QDELETED(recipient) || !recipient.mind || !length(chosen))
		return

	if(recipient.mind.has_antag_datum(/datum/antagonist/skeleton) || recipient.mind.has_antag_datum(/datum/antagonist/lich) || recipient.mind.has_antag_datum(/datum/antagonist/vampire) || recipient.mind.has_antag_datum(/datum/antagonist/vampire/lord) || recipient.mind.has_antag_datum(/datum/antagonist/werewolf) || recipient.mind.has_antag_datum(/datum/antagonist/zombie))
		to_chat(recipient, span_warning("Second Chance cannot be applied to your role, so it has not been applied."))
		return

	for(var/choice in chosen)
		switch(choice)
			if(SC_ROTCURED)
				ADD_TRAIT(recipient, TRAIT_ROTMAN, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_EASYDISMEMBER, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_NOPAIN, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_NOBREATH, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_NOHUNGER, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_TOXIMMUNE, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_ZOMBIE_IMMUNE, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
				to_chat(recipient, span_notice("You are no longer a rotting corpse, at least not a dying one."))

			if(SC_PALLID)
				ADD_TRAIT(recipient, TRAIT_PALLID, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_DARKVISION, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_NOBREATH, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_ZOMBIE_IMMUNE, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
				to_chat(recipient, span_notice("You are no longer one scorned by Astrata, by the mercy of the gods."))

			if(SC_BLACKBLOOD)
				ADD_TRAIT(recipient, TRAIT_BLACKBLOOD, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_HALFHEAL, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_STRONGBITE, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_NASTY_EATER, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_DARKVISION, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
				to_chat(recipient, span_notice("You are no longer one among the nite creechers, by the ingenuinity of HIS followers."))

				// Want to use this in future, but out of scope of this port
				//recipient.dna.species.blood_color = "#530000"

				// AP grants an "averse to Inquisition" flaw here; we have no averse flaw system, so this is just done through stress events and minor flavour
				if(recipient.patron?.type == /datum/patron/old_god)
					to_chat(recipient, span_blue("<i>You recall your horrid experiences with the Inquisition... But through your newfound faith in HIM, you ENDURE. You were but one wrong righted, after all.</i>"))
				else
					to_chat(recipient, span_blue("<i>You recall your horrid experiences with the Inquisition... It is rather traumatic. Best to avoid them.</i>"))
				to_chat(recipient, span_danger("DISCLAIMER: This Second Chance option exists to support roleplay and backstory continuity, not to diminish the threat or narrative weight of vampires, werewolves, or similar antagonistic entities. You are a tortured survivor of the Otavan Inquisition, and your very LUX fears them. Failure to roleplay this appropriately may result in this option's removal. Have fun and don't be cringe."))

	recipient.update_sight() // sight was already set when we spawned, so darkvision needs a refresh

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
		addtimer(CALLBACK(src, .proc/customize_skin, recipient), 1 SECONDS)

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

