// Virtue Packs - Triumph-cost combinations of virtues that make thematic sense together

/datum/virtue/pack
	category = "packs"
	/// List of virtue types that this pack grants
	var/list/granted_virtues = list()

/datum/virtue/pack/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Apply all virtues in the pack
	for(var/virtue_path in granted_virtues)
		var/datum/virtue/V = GLOB.virtues[virtue_path]
		if(V)
			// Apply the virtue's effects without checking triumphs (pack already cost triumphs)
			V.apply_to_human(recipient)
			V.handle_traits(recipient)
			V.handle_skills(recipient)
			V.handle_stashed_items(recipient)
			V.handle_added_languages(recipient)
			V.handle_stats(recipient)

// NOTE: Bronze Golem pack has been removed
// Use the new Prosthetic Limbs virtue system instead, which allows selecting all 4 limbs
// in bronze, iron, or steel appearance with the same functionality

// Enchanting Performer Pack: Socialite + Performer + Second Voice
// For entertainers, bards, and charismatic performers
/datum/virtue/pack/enchanter
	name = "Enchanting Performer"
	desc = "I am a master of the stage and salon alike - beautiful, talented, and able to become anyone through voice and charm. My performances captivate audiences, and my social graces open every door."
	virtue_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/socialite,
		/datum/virtue/utility/performer,
		/datum/virtue/utility/secondvoice
	)
	custom_text = "Grants three virtues for the perfect entertainer:\n\
	- Socialite: Beautiful, empathic, good lover traits + hand mirror stashed\n\
	- Performer: Choose stashed instrument, +4 Music skill, nutcracker.\n\
	- Second Voice: Ability to perfectly mimic a second voice and switch between them"

// Traveling Scholar Pack: Linguist + Rich and Shrewd + Equestrian
// For worldly scholars who have traveled extensively and accumulated wealth and knowledge
/datum/virtue/pack/travelingscholar
	name = "Traveling Scholar"
	desc = "My travels across distant lands have made me wealthy in both coin and wisdom. I speak many tongues, understand the value of all things, and ride with practiced ease. The world is my library, and every road teaches me something new."
	virtue_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/linguist,
		/datum/virtue/items/rich,
		/datum/virtue/movement/equestrian
	)
	custom_text = "Grants three virtues for the worldly traveler:\n\
	- Intellectual: +1 INT, +3 Reading, choose 3 languages, assess with stats, book crafting kit stashed (INTELLECTUAL)\n\
	- Rich and Shrewd: Appraise spell, see prices, coinpurse stashed (SEEPRICES)\n\
	- Equestrian: Tame goat mount, +1 Riding, saddle stashed, navigate doors while mounted (EQUESTRIAN)"

// Feral Survivor Pack: Natural Armour + Pilgrim + Feral Appetite
/datum/virtue/pack/scrappysurvivor
	name = "Feral Survivor"
	desc = "I've lived through hard times in the wilds - poverty, famine, or exile taught me to survive like an animal. My skin has grown thick from exposure to the elements, I know the basics of homesteading, and most importantly, I can stomach anything. Spoiled rations? Raw meat? Doesn't matter - I'll eat it and keep going."
	virtue_cost = 10
	granted_virtues = list(
		/datum/virtue/combat/tough_hide,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/feral_appetite
	)
	custom_text = "Grants three virtues for the feral survivor:\n\
	- Natural Armour: Tough hide that regenerates over time (skin armor slot with regeneration)\n\
	- Pilgrim: Cooking, Athletics, Farming, Fishing, Lumberjacking, Knife skills, hoe/knife/food bag stashed (HOMESTEAD_EXPERT trait)\n\
	- Feral Appetite: Can safely eat raw, toxic or spoiled food (NASTY_EATER trait)"

	// Sturdy Giant Pack: Natural Armor + Giant
/datum/virtue/pack/sturdygiant
	name = "Sturdy Giant"
	desc = "I am both large and hardy — my size and thick skin make me difficult to wound."
	virtue_cost = 5
	granted_virtues = list(
		/datum/virtue/combat/tough_hide,
		/datum/virtue/size/giant
	)
	custom_text = "Grants two virtues for the hulking creature.:\n\
	- Natural Armour: Tough hide that replaces your shirt slot with a regenerating skin armor.\n\
	- Giant: Increased sprite size and +1 Constitution."

// High Society Pack: Nobility + Socialite
/datum/virtue/pack/highsociety
	name = "High Society"
	desc = "I was born into privilege and raised in the finest circles. Noble blood runs through my veins, I read the emotions of others with ease, and my charm opens every door. Wealth, beauty, and status are my birthright."
	virtue_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/noble,
		/datum/virtue/utility/socialite
	)
	custom_text = "Grants two virtues for the aristocrat:\n\
	- Nobility: Noble status, Reading skill, +15 noble income, Heirloom Amulet & Hefty Coinpurse stashed\n\
	- Socialite: Beautiful, empathic, good lover traits + hand mirror stashed"

// Trusted Housekeeper Pack: Resident + Cunning Provisioner
/datum/virtue/pack/housekeeper
	name = "Trusted Housekeeper"
	desc = "I've served the households of this city for years - cooking, cleaning, and managing provisions. I know every street, have a home here, and my skills in the kitchen are unmatched. The city trusts me, and I know how to make do."
	virtue_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/granary,
		/datum/virtue/utility/homesteader
	)
	custom_text = "Grants two virtues for the city servant:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Cunning Provisioner: Cooking & Fishing skills, food bag stashed (HOMESTEAD_EXPERT)\n\
	- Pilgrim: Cooking, Athletics, Farming, Fishing, Lumberjacking, Knife skills, hoe/knife/food bag stashed."

// Broken Soul Pack: Ugly + Tolerant + Deadened
/datum/virtue/pack/brokensoul
	name = "Broken Soul"
	desc = "Life has been cruel to me. My appearance drives others away, I've learned to endure what most cannot, and I've felt nothing for so long I can barely remember what emotions were like. I am a walking testament to survival through suffering."
	virtue_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/ugly,
		/datum/virtue/utility/tolerant,
		/datum/virtue/utility/deadened
	)
	custom_text = "Grants three virtues for the outcast:\n\
	- Ugly: Unseemly appearance, immune to corpse stink (UNSEEMLY + NOSTINK traits)\n\
	- Tolerant: No stress from certain species, broad acceptance\n\
	- Deadened: Completely emotionless (NOMOOD trait)"
