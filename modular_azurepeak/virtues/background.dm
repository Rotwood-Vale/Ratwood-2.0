// Backgrounds: virtue-like picks focused on a character's previous life - skills and starting
// equipment, kept in their own free slot alongside (not instead of) the two normal virtue picks.
//
// Ported from Valmorian-Isle PR #76 (github.com/atomicplan666/Valmorian-Isle/pull/76), which itself
// ported Emerald Summit PR #240 onto the Azure Peak rebase; the virtue-quirk refactor it builds on
// is Ratwood-2.0 PR #2650 (github.com/Rotwood-Vale/Ratwood-2.0/pull/2650). Most of these already
// existed here as ordinary virtues (crafter.dm's blacksmith/tailor/physician/hunter/artificer/mining,
// combat.dm's duelist/executioner/militia/brawler/bowman/crossbowman, utility.dm's light_steps/
// performer/granary/forester/tracker/linguist, items.dm's arsonist) - those are retired in
// modular_azurepeak/virtues/retired.dm in favour of this dedicated per-archetype system so that
// spending a virtue on "some skills and a kit" is no longer necessary.
//
// Deliberate additions on top of the VI port (paid addenda, 2026-09-22):
//   * Tailor's Apprentice and Enchanter's Apprentice got proper equipment-choice packs (VI shipped
//     them with only the tools inherited from the retired Skilled Apprentice virtue).
//   * The fighting backgrounds (Brawler/Duelist/Dungeoneer/Militiaman/Toxophilite) grant guaranteed
//     Journeyman in the skills their retired virtues granted guaranteed Journeyman in.
//   * /datum/virtue/utility/second_background lets a virtue slot buy a second background pick.
//   * Every "bunch of apprentice skills" background prompts for two of those skills to be raised to
//     Journeyman, mirroring the old Skilled Apprentice's journeyman-grade highlights.
//
// Not ported: Emerald Summit's "Portable Smelter" contraption (Blacksmith/Scrapper) and "Scroll of
// Find Familiar" (Rogue Alchemist) - neither the portable-smelter item nor the findfamiliar spell
// exist here. Item paths that had no direct equivalent were substituted for the closest one this
// codebase has (surgery/scalpel/improv -> surgery/scalpel, alchemical/endpot -> alchemical/healthpot,
// cooking/pan/aalloy -> cooking/pan, the bare armor/leather/jacket -> its /artijacket subtype).

/// Backgrounds are a separate free pick from the virtue and virtue_two slots. They share virtue
/// machinery (skills, traits, stash) but are picked, saved and displayed as their own slot.
/// (background_desc, used for the equipment blurb, lives on /datum/virtue itself so the virtue text
/// renderer can read it off any pick.)
/datum/virtue/background

/// Shared helper for backgrounds built around "a bunch of apprentice skills": lets the player pick
/// two of the skills the background grants and raises those to Journeyman. Reads the skills straight
/// off added_skills so every background's list stays the single source of truth.
/datum/virtue/background/proc/prompt_journeyman_skills(mob/living/carbon/human/recipient)
	if(!recipient?.mind || !LAZYLEN(added_skills))
		return
	var/list/choices = list()
	for(var/list/L in added_skills)
		if(!islist(L) || !ispath(L[1], /datum/skill))
			continue
		var/datum/skill/S = L[1]
		choices[initial(S.name)] = L[1]
	var/picks_left = 2
	for(var/i in 1 to 2)
		if(!length(choices))
			break
		var/picked = tgui_input_list(recipient, "Which of my trades did I hone to journeyman's quality?", "BACKGROUND: [picks_left] JOURNEYMAN PICKS LEFT", choices)
		if(!picked)
			break
		recipient.adjust_skillrank_up_to(choices[picked], SKILL_LEVEL_JOURNEYMAN, silent = FALSE)
		choices -= picked
		picks_left--

/// Adds a pack to the stash without wiping what other virtues, traits or a second background put
/// there. Clashing names get a numbered suffix.
/datum/virtue/background/proc/stash_items(mob/living/carbon/human/recipient, list/items)
	if(!recipient?.mind)
		return
	if(!recipient.mind.special_items)
		recipient.mind.special_items = list()
	for(var/item_name in items)
		var/key = item_name
		var/suffix = 2
		while(recipient.mind.special_items[key])
			key = "[item_name] ([suffix++])"
		recipient.mind.special_items[key] = items[item_name]

/// The pack prompts in apply_to_human() block on player input, so they run off the spawn chain.
/// Otherwise spawning stalls until the player answers or the prompt times out.
/datum/virtue/background/apply_generic_effects(mob/living/carbon/human/recipient)
	if(blocked_by_incompatible_traits(recipient))
		return FALSE
	handle_traits(recipient)
	handle_skills(recipient)
	handle_stashed_items(recipient)
	handle_added_languages(recipient)
	handle_stats(recipient)
	if(!istype(src, /datum/virtue/background/none))
		record_background_pick(recipient, src)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/customization_trait, apply_to_human), recipient)
	return TRUE

/datum/virtue/background/none //for having no background
	name = "None"
	desc = "You have aspired to (or been given) little in the way of trade or upbringing."

/datum/virtue/background/militia
	name = "Militiaman"
	desc = "I have trained with the local garrison in case I'm ever to be levied to fight for my lord. My gear is stashed away, in case I am ever levied."
	background_desc = "Guaranteed Journeyman for Maces, Polearms and Slings, depending on equipment choice (Cudgel & Buckler, Quarterstaff, or Spear & Sling)."

/datum/virtue/background/militia/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my precious things.", list("Guard (Cudgel, Buckler)", "Watchman (Quarterstaff)", "Conscript (Spear, Sling)"))
	switch(equip_choice)
		if("Guard (Cudgel, Buckler)")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/militiaguard,
					"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
					"Buckler" = /obj/item/rogueweapon/shield/buckler
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Watchman (Quarterstaff)")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/militiawatch,
					"Quarterstaff" = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Conscript (Spear, Sling)")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/militiaconscript,
					"Militia Spear" = /obj/item/rogueweapon/spear
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

// Merges the old separate combat/bowman + combat/crossbowman virtues into one equipment-choice
// background, matching the port's Toxophilite.
/datum/virtue/background/bowman
	name = "Toxophilite"
	desc = "I've had an interest in archery from a young age, and I always keep a spare bow and quiver around."
	background_desc = "Guaranteed Journeyman for Bows or Crossbows, depending on equipment choice (Recurve Bow or Crossbow)."

/datum/virtue/background/bowman/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Archer", "Crossbowman"))
	switch(equip_choice)
		if("Archer")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/toxarcher,
					"Recurve Bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
					"Quiver" = /obj/item/quiver/arrows
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Crossbowman")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/toxcross,
					"Crossbow" = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow,
					"Quiver" = /obj/item/quiver/bolts
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/background/performer
	name = "Performer"
	desc = "Music, artistry and the act of showmanship carried me through life. I've hidden a favorite instrument of mine, know how to please anyone I touch, and how to crack the eggs of hecklers."
	background_desc = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_traits = list(TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	added_skills = list(list(/datum/skill/misc/music, 4, 6)) //Allows them to upload custom music

/datum/virtue/background/performer/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, PROC_REF(performer_apply), recipient), 5 SECONDS)

/datum/virtue/background/performer/proc/performer_apply(mob/living/carbon/human/recipient)
	pick_stashed_instrument(recipient)

// Kept this codebase's version of the old Intellectual virtue (3 languages, +1 INT), rebuilt onto the
// port's spawn-time prompt: the max_choices/extra_choices machinery only has picker UI and savefile
// persistence for the virtue/virtuetwo slots, so a background built on it could never have its picks
// made - it would grant zero languages.
/datum/virtue/background/linguist
	name = "Intellectual"
	desc = "I've spent my life surrounded by various books or sophisticated foreigners, be it through travel or other fortunes beset on my life. I've picked up several tongues and wits, and keep a journal closeby. I can tell people's exact prowess."
	background_desc = "Maximizes Assess benefits with a bonus of the target's Stats. Allows the choice of 3 languages to learn upon joining. +1 INT."
	added_traits = list(TRAIT_INTELLECTUAL)
	added_skills = list(list(/datum/skill/misc/reading, 3, 6))
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit,
		"Unfinished Skillbook" = /obj/item/skillbook/unfinished
	)

/datum/virtue/background/linguist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.change_stat(STATKEY_INT, 1)
	addtimer(CALLBACK(src, PROC_REF(linguist_apply), recipient), 5 SECONDS)

/datum/virtue/background/linguist/proc/linguist_apply(mob/living/carbon/human/recipient)
	var/static/list/selectable_languages = list(
		"Elvish" = /datum/language/elvish,
		"Dwarvish" = /datum/language/dwarvish,
		"Orcish" = /datum/language/orcish,
		"Infernal" = /datum/language/hellspeak,
		"Draconic" = /datum/language/draconic,
		"Celestial" = /datum/language/celestial,
		"Grenzelhoftian" = /datum/language/grenzelhoftian,
		"Canilunzt" = /datum/language/canilunzt,
		"Kazengunese" = /datum/language/kazengunese,
		"Otavan" = /datum/language/otavan,
		"Etruscan" = /datum/language/etruscan,
		"Gronnic" = /datum/language/gronnic,
		"Hammerholdian" = /datum/language/hammerholdian,
		"Aavnic" = /datum/language/aavnic,
		"Abyssal" = /datum/language/abyssal,
		"Merar" = /datum/language/merar
	)
	var/list/choices = list()
	for(var/language_name in selectable_languages)
		if(recipient.has_language(selectable_languages[language_name]))
			continue
		choices[language_name] = selectable_languages[language_name]
	var/count = 3
	for(var/i in 1 to 3)
		if(!length(choices))
			break
		var/chosen_language = tgui_input_list(recipient, "Choose your extra spoken language.", "BACKGROUND: [count] LEFT", choices)
		if(!chosen_language)
			break
		recipient.grant_language(choices[chosen_language])
		choices -= chosen_language
		to_chat(recipient, span_info("I recall my knowledge of [chosen_language]..."))
		count--

// ========================
// CRAFTER BACKGROUNDS
// ========================

/datum/virtue/background/artificer
	name = "Artificer's Apprentice"
	desc = "In my youth, I worked under a skilled artificer, studying construction and engineering."
	background_desc = "Tinkerer comes with cogs and bronze ingots. Mason comes with a blowrod, a chisel, and bricks."
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/carpentry, 2, 2),
						list(/datum/skill/craft/masonry, 2, 2),
						list(/datum/skill/craft/engineering, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2),
						list(/datum/skill/craft/ceramics, 2, 2)
	)

/datum/virtue/background/artificer/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Tinkerer", "Mason"))
	switch(equip_choice)
		if("Tinkerer")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/artificertinker))
		if("Mason")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/artificermason))
	prompt_journeyman_skills(H)

/datum/virtue/background/blacksmith
	name = "Blacksmith's Apprentice"
	desc = "In my youth, I worked under a skilled blacksmith, honing my skills with an anvil."
	background_desc = "Smith loadout comes with ingots and equipment to start smithing. Scrapper is focused on finding refuse to recycle - has smithing tools and knows the Scrapper's Smelt, which melts a metal item down into an ingot."
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/weaponsmithing, 2, 2),
						list(/datum/skill/craft/armorsmithing, 2, 2),
						list(/datum/skill/craft/blacksmithing, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2))

/datum/virtue/background/blacksmith/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Smith", "Scrapper"))
	switch(equip_choice)
		if("Smith")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/smithapp))
		if("Scrapper")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/smithscrap))
				if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/heatmetal/secular))
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/heatmetal/secular)
	prompt_journeyman_skills(H)

// Stand-in for Emerald Summit's Portable Smelter (not ported): a secular, smelt-only Heat Metal.
// No psicross or devotion, touch range, and it never targets people.
/obj/effect/proc_holder/spell/invoked/heatmetal/secular
	name = "Scrapper's Smelt"
	desc = "Melts a single metal item down into an ingot."
	req_items = list()
	invocations = list()
	invocation_type = "none"
	range = 1
	associated_skill = /datum/skill/craft/smelting
	miracle = FALSE
	devotion_cost = 0 //Scrappers are not clerics

/obj/effect/proc_holder/spell/invoked/heatmetal/secular/cast(list/targets, mob/user = usr)
	for(var/obj/item/target in targets)
		if(istype(target, /obj/item/rogueore/coal) || !target.smeltresult || target.smeltresult == /obj/item/ash)
			to_chat(user, span_warning("[target] won't smelt down into anything useful."))
			return FALSE
		var/datum/effect_system/spark_spread/sparks = new()
		handle_item_smelting(target, user, sparks, list(/obj/item/rogueore/coal))
		return TRUE
	return FALSE

/datum/virtue/background/tailor
	name = "Tailor's Apprentice"
	desc = "In my youth, I worked under a skilled tailor, learning to cut, stitch and mend."
	background_desc = "Seamster comes with cloth, fibres and a spare needle. Skinner comes with hides, furs and fat for tanning. Both keep my needle and scissors stashed away."
	added_traits = list(TRAIT_SEWING_EXPERT)
	added_skills = list(list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 3, 3),
						list(/datum/skill/craft/tanning, 2, 2))
	added_stashed_items = list(
		"Needle" = /obj/item/needle,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors
	)

/datum/virtue/background/tailor/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Seamster", "Skinner"))
	switch(equip_choice)
		if("Seamster")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/tailorseam))
		if("Skinner")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/tailorskin))
	prompt_journeyman_skills(H)

// Adapted to this codebase's traits: TRAIT_RITUALIST (ritual chalk) + TRAIT_ARCYNE_T2 stand in for
// the port's TRAIT_ENCHANTING_EXPERT / TRAIT_ARCYNE / TRAIT_LEYLINE_ATTUNEMENT, none of which exist
// here (the closest leyline trait here is TRAIT_LEYLINE_HASTE, which is a spell-casting buff, not a
// ritual gate).
/datum/virtue/background/enchanter
	name = "Enchanter's Apprentice"
	desc = "In my youth, I worked under a skilled enchanter, learning to bind lux to matter."
	background_desc = "Ritualist comes with chalk, mortar, pestle and writing supplies. Brewster comes with alchemical vials and reagents."
	added_traits = list(TRAIT_ALCHEMY_EXPERT, TRAIT_ARCYNE_T2)
	added_skills = list(list(/datum/skill/craft/alchemy, 2, 2),
						list(/datum/skill/craft/blacksmithing, 2, 2),
						list(/datum/skill/craft/engineering, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2),
						list(/datum/skill/magic/arcane, 2, 2))
	added_stashed_items = list(
		"Pestle" = /obj/item/pestle,
		"Mortar" = /obj/item/reagent_containers/glass/mortar,
		"Chalk" = /obj/item/chalk
	)

/datum/virtue/background/enchanter/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Ritualist", "Brewster"))
	switch(equip_choice)
		if("Ritualist")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/enchritual))
		if("Brewster")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/enchbrew))
	prompt_journeyman_skills(H)

// Kept this codebase's extra grants from the old Physician's Apprentice virtue (expert traits +
// the secular diagnose spell) on top of the port's equipment-choice structure.
/datum/virtue/background/physician
	name = "Physician's Apprentice"
	desc = "In my youth, I worked under a skilled physician, studying medicine and alchemy."
	background_desc = "Alchemist comes with a bedroll, healing vials, and basic medical supplies. Surgeon is equipped with improvised surgical tools, a bedroll, and a needle."
	added_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/alchemy, 2, 2),
						list(/datum/skill/misc/medicine, 2, 2))

/datum/virtue/background/physician/apply_to_human(mob/living/carbon/human/H)
	if(!H.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Alchemist", "Surgeon"))
	switch(equip_choice)
		if("Alchemist")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/physalc))
		if("Surgeon")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/physurg))
	prompt_journeyman_skills(H)

// Adapted to this codebase: no TRAIT_MASTERFUL_HUNTER and no trapping/hunting skills exist here
// (this codebase's survival skills are tracking + butchering + tanning + sewing), so the background
// grants TRAIT_SURVIVAL_EXPERT over the skills that do exist.
/datum/virtue/background/hunter
	name = "Hunter's Apprentice"
	desc = "In my youth, I trained under a skilled hunter, learning how to butcher animals and work with leather and hide."
	background_desc = "Trapper comes with bait and ingredients for a mantrap. Tanner comes with bait, fat and a pan."
	added_traits = list(TRAIT_SURVIVAL_EXPERT, TRAIT_MASTERFUL_HUNTER)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
						list(/datum/skill/misc/tracking, 2, 2),
						list(/datum/skill/misc/hunting, 2, 2)
	)

/datum/virtue/background/hunter/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Trapper", "Tanner"))
	switch(equip_choice)
		if("Trapper")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/huntertrap))
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Tanner")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/huntertan))
	prompt_journeyman_skills(H)

/datum/virtue/background/mining
	name = "Miner's Apprentice"
	desc = "The dark shafts, the damp smells of ichor and the laboring hours are no stranger to me. I keep my pickaxe and lamptern close, and have been taught how to mine well."
	background_desc = "Comes with a mining backpack, a steel pickaxe and a lamptern."
	added_traits = list(TRAIT_SMITHING_EXPERT) // Not sure whether smithing or homestead, but mining goods go into smithing, so this fits better.
	added_skills = list(list(/datum/skill/labor/mining, 3, 6))

/datum/virtue/background/mining/apply_to_human(mob/living/carbon/human/H)
	if(H.mind)
		stash_items(H, list("Mining Backpack" = /obj/item/storage/backpack/rogue/backpack/minerbag))

// ========================
// COMBAT BACKGROUNDS
// ========================
// These replace the retired per-archetype fighting virtues (combat.dm's duelist/executioner/
// militia/brawler/bowman/crossbowman). Where those granted guaranteed Journeyman, so do these -
// the equipment choice just decides which weapon those Journeyman ranks land on.

/datum/virtue/background/brawler
	name = "Brawler's Apprentice"
	desc = "I have trained under a skilled brawler, and have some experience fighting with my fists."
	background_desc = "Guaranteed Journeyman for Unarmed and Wrestling, with a choice of Katar or Knuckles."

/datum/virtue/background/brawler/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Katar", "Knuckles"))
	switch(equip_choice)
		if("Katar")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/brawlkatar))
		if("Knuckles")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/brawlknuck))
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/background/duelist
	name = "Duelist's Apprentice"
	desc = "I have trained under a duelist of considerable skill, and have taken up their arms of choice."
	background_desc = "Guaranteed Journeyman for Swords or Knives, depending on equipment choice (Rapier, Arming Sword, or Twin Daggers)."

/datum/virtue/background/duelist/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Dueler (Rapier)", "Swordsman (Arming)", "Scoundrel (Twin Daggers)"))
	switch(equip_choice)
		if("Dueler (Rapier)")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/duelistnoble,
					"Rapier" = /obj/item/rogueweapon/sword/rapier
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Swordsman (Arming)")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/duelistsword))
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Scoundrel (Twin Daggers)")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/duelistscoundrel))
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

/datum/virtue/background/executioner
	name = "Dungeoneer's Apprentice"
	desc = "I was set to be a dungeoneer some time ago, and I was taught by one. I managed to bring my gear with me."
	background_desc = "Guaranteed Journeyman for Axes or Whips/Flails, depending on equipment choice (Dungeon Guard or Executioner)."

/datum/virtue/background/executioner/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Dungeon Guard", "Executioner"))
	switch(equip_choice)
		if("Dungeon Guard")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/dungeonguard))
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if("Executioner")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/dungeonexecute,
					"Greataxe" = /obj/item/rogueweapon/greataxe
				))
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)

// Kept this codebase's version of the old Sleuth virtue (tracking, TRAIT_SLEUTH), plus the port's
// net + rope stash.
/datum/virtue/background/tracker
	name = "Sleuth"
	desc = "You realised long ago that the ability to find a man is as helpful to aid the law as it is to evade it."
	background_desc = "- Upon right clicking a track, you will Mark the person who made them <i>(Expert skill required, not exclusive to this Background)</i>.\n- Further tracks found will be automatically highlighted as theirs, along with the person themselves, if they are not sneaking or invisible at the time.\n- Reduces the cooldown for tracking, allows track examining right away, and movement no longer cancels tracking.\n- As a bonus, you'll be able to read people's noble gossip regardless of <i>your</i> noble status.\n- Comes with a net and rope."
	added_skills = list(list(/datum/skill/misc/tracking, 3, 6))
	added_traits = list(TRAIT_SLEUTH)
	added_stashed_items = list("Equipment Bag" = /obj/item/storage/roguebag/sleuth)

// Kept this codebase's richer version of the old items/arsonist virtue (explosive supply trait,
// flint) instead of building the port's roguealchemist fresh. This codebase has no trapping skill,
// so the port's Trapmaking journeyman is dropped.
/datum/virtue/background/roguealchemist
	name = "Rogue Alchemist"
	desc = "I like to watch the world burn, and I've stowed away bombs and materials to help me achieve that fact. Every day I can take one bomb from any HERMES."
	background_desc = "Firebombs and bomb materials, plus Expert Alchemist."
	added_skills = list(list(/datum/skill/craft/alchemy, 2, 4))
	added_traits = list(TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY)

/datum/virtue/background/roguealchemist/apply_to_human(mob/living/carbon/human/H)
	if(H.mind)
		stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/arsonbomb))

/datum/virtue/background/sailor
	name = "Sailor"
	desc = "You spent your daes on the sea, learning to brace ships against storms and swim against Abyssor's tides."
	background_desc = "Comes with carpentry tools, fishing rod + bait, and an axe."
	added_skills = list(list(/datum/skill/misc/swimming, 2, 3),
						list(/datum/skill/misc/athletics, 2, 3),
						list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/carpentry, 2, 2),
						list(/datum/skill/labor/fishing, 2, 6))

/datum/virtue/background/sailor/apply_to_human(mob/living/carbon/human/H)
	if(H.mind)
		stash_items(H, list(
			"Equipment Bag" = /obj/item/storage/roguebag/sailfix,
			"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut
		))
	prompt_journeyman_skills(H)

// ========================
// SUPPORTING VIRTUE
// ========================

// Paid addendum (2026-09-22): lets a virtue slot buy a second background pick instead of the usual
// virtue package. The pick is made after spawning - same spawn-time prompt pattern as the equipment
// choices above - and the chosen background applies its full package (skills, traits, stash, and its
// own equipment prompt) to the character.
/datum/virtue/utility/second_background
	name = "Second Background"
	desc = "My lyfe before was a busy one - I learned two trades, not just one."
	custom_text = "Pick a second Background after spawning in. Grants nothing on its own."

/datum/virtue/utility/second_background/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, PROC_REF(pick_second_background), recipient), 5 SECONDS)

/datum/virtue/utility/second_background/proc/pick_second_background(mob/living/carbon/human/recipient)
	if(!recipient?.mind)
		return
	var/list/choices = list()
	for(var/path as anything in GLOB.virtues)
		var/datum/virtue/V = GLOB.virtues[path]
		if(!istype(V, /datum/virtue/background) || istype(V, /datum/virtue/background/none))
			continue
		if(!V.name || V.unlisted || V.retired)
			continue
		if(recipient.client?.prefs?.virtue_background?.type == V.type)
			continue //Already the character's main background.
		choices[V.name] = V
	var/chosen = tgui_input_list(recipient, "What else did I learn, before all this?", "BACKGROUND: SECOND PICK", choices)
	var/datum/virtue/background/chosen_background = choices[chosen]
	if(!chosen_background)
		to_chat(recipient, span_warning("I never settled on a second trade - my virtue slot is spent regardless."))
		return
	to_chat(recipient, span_notice("My second trade, then: [chosen_background.name]."))
	chosen_background.apply_generic_effects(recipient)

// ========================
// UTILITY BACKGROUNDS
// ========================

/datum/virtue/background/granary
	name = "Cunning Provisioner"
	desc = "You've worked in or around the docks enough to steal away a sack of supplies that no one would surely miss, just in case. You've picked up on some cooking and fishing tips in your spare time, as well."
	background_desc = "Both come with a cooling backpack. Chef is equipped with a variety of foods + pan for cooking (and a chef's knife). Fisher has a fishing rod, bait, and supplies for making fishing traps."
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 6),
						list(/datum/skill/labor/fishing, 2, 6))

/datum/virtue/background/granary/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Chef", "Fisher"))
	switch(equip_choice)
		if("Chef")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/backpack/rogue/artibackpack/cunningchef))
		if("Fisher")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/backpack/rogue/artibackpack/cunningfish))

/datum/virtue/background/forester
	name = "Forester"
	desc = "The forest is your home, or at least, it used to be. You always long to return and roam free once again, and you have not forgotten your knowledge on how to be self sufficient."
	background_desc = "Lumberer comes with an axe, fishing rod, and whetstone. Farmer has an assortment of seeds, crops, and a hoe."
	added_skills = list(list(/datum/skill/craft/cooking, 2, 2),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 2, 2),
						list(/datum/skill/labor/fishing, 2, 2),
						list(/datum/skill/labor/lumberjacking, 2, 2)
	)

/datum/virtue/background/forester/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Lumberer", "Farmer"))
	switch(equip_choice)
		if("Lumberer")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/forestlumber,
					"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut
				))
		if("Farmer")
			if(H.mind)
				stash_items(H, list(
					"Equipment Bag" = /obj/item/storage/roguebag/forestfarm,
					"Hoe" = /obj/item/rogueweapon/hoe
				))
	prompt_journeyman_skills(H)

/datum/virtue/background/light_steps
	name = "Light Steps"
	desc = "Years of skulking about have left my steps quiet, and my hunched gait quicker."
	background_desc = "Skulker comes with lockpicks and smoke bombs. Larcenous comes with a lockpick ring and a dagger."
	added_traits = list(TRAIT_LIGHT_STEP)

/datum/virtue/background/light_steps/apply_to_human(mob/living/carbon/human/H)
	var/equip_choice = tgui_input_list(H, "My lyfe before, STASHed away ...", "TREES and STATUES hold my things.", list("Skulker", "Larcenous"))
	switch(equip_choice)
		if("Skulker")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/lightstep))
			add_skill_capped(H, /datum/skill/misc/sneaking, 3, SKILL_LEVEL_EXPERT)
			add_skill_capped(H, /datum/skill/misc/lockpicking, 1, SKILL_LEVEL_EXPERT)
			add_skill_capped(H, /datum/skill/misc/stealing, 1, SKILL_LEVEL_EXPERT)
		if("Larcenous")
			if(H.mind)
				stash_items(H, list("Equipment Bag" = /obj/item/storage/roguebag/larcscoundrel))
			add_skill_capped(H, /datum/skill/misc/sneaking, 1, SKILL_LEVEL_EXPERT)
			add_skill_capped(H, /datum/skill/misc/lockpicking, 3, SKILL_LEVEL_EXPERT)
			add_skill_capped(H, /datum/skill/misc/stealing, 3, SKILL_LEVEL_EXPERT)

// Adds onto whatever the character already has, stopping at the cap (never lowers an existing skill).
/datum/virtue/background/light_steps/proc/add_skill_capped(mob/living/carbon/human/H, skill, amount, cap)
	var/current = H.get_skill_level(skill)
	var/target = min(current + amount, cap)
	if(target > current)
		H.adjust_skillrank(skill, target - current, TRUE)

// ========================
// EQUIPMENT BAGS
// ========================
// Every background equipment choice stashes one of these into the player's special items; the
// contents are spawned when the bag is retrieved from a tree, statue or clock.

//Rogue Alchemist
/obj/item/storage/roguebag/arsonbomb
	populate_contents = list(
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/ash,
		/obj/item/rogueore/coal,
		/obj/item/rogueore/coal,
		/obj/item/natural/cloth,
		/obj/item/natural/cloth,
		/obj/item/flint
	)

//Artificer
/obj/item/storage/roguebag/artificertinker
	populate_contents = list(
		/obj/item/contraption,
		/obj/item/contraption,
		/obj/item/contraption,
		/obj/item/ingot/bronze,
		/obj/item/ingot/bronze,
		/obj/item/ingot/bronze,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick
	)

/obj/item/storage/roguebag/artificermason
	populate_contents = list(
		/obj/item/rogueweapon/blowrod,
		/obj/item/rogueweapon/chisel,
		/obj/item/natural/bundle/brick,
		/obj/item/natural/bundle/brick,
		/obj/item/natural/bundle/brick,
		/obj/item/natural/bundle/brick,
		/obj/item/natural/bundle/brick,
		/obj/item/natural/bundle/brick,
		/obj/item/natural/bundle/brick
	)

//Blacksmith
/obj/item/storage/roguebag/smithapp
	populate_contents = list(
		/obj/item/rogueweapon/tongs,
		/obj/item/rogueweapon/hammer/iron,
		/obj/item/ingot/iron,
		/obj/item/ingot/iron,
		/obj/item/ingot/iron,
		/obj/item/ingot/steel,
		/obj/item/ingot/steel,
		/obj/item/rogueore/coal,
		/obj/item/rogueore/coal,
		/obj/item/rogueore/coal,
		/obj/item/rogueore/coal
	)

/obj/item/storage/roguebag/smithscrap
	populate_contents = list(
		/obj/item/rogueweapon/tongs,
		/obj/item/rogueweapon/hammer/iron
	)

//Tailor (new pack, paid addendum 2026-09-22 - the port shipped this background with only the tools
//inherited from the retired Skilled Apprentice virtue)
/obj/item/storage/roguebag/tailorseam
	populate_contents = list(
		/obj/item/natural/bundle/cloth,
		/obj/item/natural/bundle/cloth,
		/obj/item/natural/cloth,
		/obj/item/natural/cloth,
		/obj/item/natural/bundle/fibers,
		/obj/item/natural/bundle/fibers,
		/obj/item/needle
	)

/obj/item/storage/roguebag/tailorskin
	populate_contents = list(
		/obj/item/natural/hide,
		/obj/item/natural/hide,
		/obj/item/natural/fur,
		/obj/item/natural/fur,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/needle/thorn
	)

//Enchanter (new pack, paid addendum 2026-09-22 - as Tailor above)
/obj/item/storage/roguebag/enchritual
	populate_contents = list(
		/obj/item/chalk,
		/obj/item/chalk,
		/obj/item/chalk,
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		/obj/item/natural/feather,
		/obj/item/natural/cloth
	)

/obj/item/storage/roguebag/enchbrew
	populate_contents = list(
		/obj/item/reagent_containers/glass/bottle/alchemical,
		/obj/item/reagent_containers/glass/bottle/alchemical,
		/obj/item/alch/urtica,
		/obj/item/alch/urtica,
		/obj/item/alch/valeriana,
		/obj/item/alch/valeriana,
		/obj/item/natural/cloth
	)

//Forester
/obj/item/storage/roguebag/forestlumber
	populate_contents = list(
		/obj/item/natural/whetstone,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/fishingrod
	)

/obj/item/storage/roguebag/forestfarm
	populate_contents = list(
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/seeds/wheat,
		/obj/item/seeds/wheat,
		/obj/item/seeds/onion,
		/obj/item/seeds/onion,
		/obj/item/seeds/apple,
		/obj/item/seeds/apple,
		/obj/item/millstone
	)

//Hunter
/obj/item/storage/roguebag/huntertrap
	populate_contents = list(
		/obj/item/rogueweapon/huntingknife,
		/obj/item/bait,
		/obj/item/bait/sweet,
		/obj/item/bait/sweet,
		/obj/item/grown/log/tree/small,
		/obj/item/natural/bundle/fibers,
		/obj/item/natural/bundle/fibers,
		/obj/item/ingot/iron
	)

/obj/item/storage/roguebag/huntertan
	populate_contents = list(
		/obj/item/rogueweapon/huntingknife,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/needle/thorn,
		/obj/item/bait,
		/obj/item/bait/sweet,
		/obj/item/bait/sweet,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/cooking/pan
	)

//Light Steps
/obj/item/storage/roguebag/lightstep
	populate_contents = list(
		/obj/item/lockpick,
		/obj/item/lockpick,
		/obj/item/lockpick,
		/obj/item/bomb/smoke,
		/obj/item/bomb/smoke,
		/obj/item/bomb/smoke
	)

/obj/item/storage/roguebag/larcscoundrel
	populate_contents = list(
		/obj/item/lockpickring/mundane,
		/obj/item/lockpick,
		/obj/item/lockpick,
		/obj/item/lockpick,
		/obj/item/rogueweapon/huntingknife/idagger
	)

//Militia
/obj/item/storage/roguebag/militiaguard
	populate_contents = list(
		/obj/item/clothing/head/roguetown/helmet/kettle,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
		/obj/item/rope/chain,
		/obj/item/needle/thorn
	)

/obj/item/storage/roguebag/militiawatch
	populate_contents = list(
		/obj/item/clothing/head/roguetown/helmet/kettle,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	)

/obj/item/storage/roguebag/militiaconscript
	populate_contents = list(
		/obj/item/clothing/head/roguetown/helmet/kettle,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
		/obj/item/gun/ballistic/revolver/grenadelauncher/sling,
		/obj/item/quiver/sling
	)

//Brawler
/obj/item/storage/roguebag/brawlkatar
	populate_contents = list(
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/rogueweapon/katar,
		/obj/item/needle/thorn
	)

/obj/item/storage/roguebag/brawlknuck
	populate_contents = list(
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/rogueweapon/knuckles,
		/obj/item/needle/thorn
	)

//Cunning Provisioner
/obj/item/storage/backpack/rogue/artibackpack/cunningchef
	populate_contents = list(
		/obj/item/reagent_containers/food/snacks/rogue/dough,
		/obj/item/reagent_containers/food/snacks/rogue/dough,
		/obj/item/reagent_containers/food/snacks/rogue/dough,
		/obj/item/reagent_containers/food/snacks/butter,
		/obj/item/rogueweapon/huntingknife/chefknife,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/cooking/pan,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)

/obj/item/storage/backpack/rogue/artibackpack/cunningfish
	populate_contents = list(
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/natural/worms,
		/obj/item/grown/log/tree/small,
		/obj/item/grown/log/tree/small,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/fishingrod
	)

//Duelist
/obj/item/storage/roguebag/duelistnoble
	populate_contents = list(
		/obj/item/clothing/ring/duelist,
		/obj/item/clothing/ring/duelist,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying,
		/obj/item/clothing/head/roguetown/duelhat,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light
	)

/obj/item/storage/roguebag/duelistsword
	populate_contents = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/lord,
		/obj/item/rogueweapon/sword/iron,
		/obj/item/clothing/head/roguetown/helmet/skullcap
	)

/obj/item/storage/roguebag/duelistscoundrel
	populate_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	)

//Dungeoneer
/obj/item/storage/roguebag/dungeonguard
	populate_contents = list(
		/obj/item/clothing/suit/roguetown/armor/leather,
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/head/roguetown/helmet/leather,
		/obj/item/rogueweapon/whip,
		/obj/item/rope/chain,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
		/obj/item/rope/chain,
		/obj/item/needle/thorn
	)

/obj/item/storage/roguebag/dungeonexecute
	populate_contents = list(
		/obj/item/clothing/suit/roguetown/armor/leather,
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/head/roguetown/helmet/leather,
		/obj/item/natural/whetstone,
		/obj/item/needle/thorn
	)

//Miner
/obj/item/storage/backpack/rogue/backpack/minerbag
	populate_contents = list(
		/obj/item/rogueweapon/pick/steel,
		/obj/item/flashlight/flare/torch/lantern
	)

//Physician
/obj/item/storage/roguebag/physurg
	populate_contents = list(
		/obj/item/rogueweapon/surgery/saw/improv,
		/obj/item/rogueweapon/surgery/hemostat/improv,
		/obj/item/rogueweapon/surgery/hemostat/improv,
		/obj/item/rogueweapon/surgery/retractor/improv,
		/obj/item/rogueweapon/surgery/scalpel,
		/obj/item/rogueweapon/surgery/hammer,
		/obj/item/needle,
		/obj/item/bedroll
	)

/obj/item/storage/roguebag/physalc
	populate_contents = list(
		/obj/item/needle,
		/obj/item/natural/bundle/cloth,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot,
		/obj/item/alch/urtica,
		/obj/item/alch/valeriana,
		/obj/item/bedroll
	)

//Sailor
/obj/item/storage/roguebag/sailfix
	populate_contents = list(
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/grown/log/tree/small,
		/obj/item/rogueweapon/handsaw,
		/obj/item/rogueweapon/hammer/wood,
		/obj/item/fishingrod
	)

//Sleuth
/obj/item/storage/roguebag/sleuth
	populate_contents = list(
		/obj/item/net,
		/obj/item/rope,
		/obj/item/rope
	)

//Toxophilite
/obj/item/storage/roguebag/toxarcher
	populate_contents = list(
		/obj/item/clothing/head/roguetown/helmet/leather,
		/obj/item/clothing/gloves/roguetown/fingerless_leather,
		/obj/item/clothing/under/roguetown/trou/leather
	)

/obj/item/storage/roguebag/toxcross
	populate_contents = list(
		/obj/item/clothing/head/roguetown/helmet/kettle,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light
	)
