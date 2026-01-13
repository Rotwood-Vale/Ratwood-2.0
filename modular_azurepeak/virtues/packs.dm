// Virtue Packs - Triumph-cost combinations of virtues that make thematic sense together

/datum/virtue/pack
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

// Bronze Golem Pack: Both Bronze Arms
// For those who have replaced both arms with mechanical prosthetics
/datum/virtue/pack/bronzegolem
	name = "Bronze Golem (-3 TRI)"
	desc = "Through wealth, misfortune, or perhaps experimentation, both of my arms have been replaced with bronze prosthetics. I am part man, part machine - a walking testament to artifice."
	triumph_cost = 3
	granted_virtues = list(
		/datum/virtue/utility/bronzearm_r,
		/datum/virtue/utility/bronzearm_l
	)
	custom_text = "Grants both Bronze Arm virtues:\n\
	- Bronze Arm (R): Right arm replaced with bronze prosthetic\n\
	- Bronze Arm (L): Left arm replaced with bronze prosthetic\n\
	- +1 Engineering skill from studying the mechanisms"

// Enchanting Performer Pack: Socialite + Performer + Second Voice
// For entertainers, bards, and charismatic performers
/datum/virtue/pack/enchanter
	name = "Enchanting Performer (-12 TRI)"
	desc = "I am a master of the stage and salon alike - beautiful, talented, and able to become anyone through voice and charm. My performances captivate audiences, and my social graces open every door."
	triumph_cost = 12
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
	name = "Traveling Scholar (-15 TRI)"
	desc = "My travels across distant lands have made me wealthy in both coin and wisdom. I speak many tongues, understand the value of all things, and ride with practiced ease. The world is my library, and every road teaches me something new."
	triumph_cost = 15
	granted_virtues = list(
		/datum/virtue/utility/linguist,
		/datum/virtue/items/rich,
		/datum/virtue/movement/equestrian
	)
	custom_text = "Grants three virtues for the worldly traveler:\n\
	- Intellectual: +1 INT, +3 Reading, choose 3 languages, assess with stats, book crafting kit stashed (INTELLECTUAL)\n\
	- Rich and Shrewd: Appraise spell, see prices, coinpurse stashed (SEEPRICES)\n\
	- Equestrian: Tame goat mount, +1 Riding, saddle stashed, navigate doors while mounted (EQUESTRIAN)"

// Scrappy Survivor Pack: Cunning Provisioner + Forester + Feral Appetite
/datum/virtue/pack/scrappysurvivor
	name = "Scrappy Survivor (-10 TRI)"
	desc = "I've lived through hard times - poverty, famine, or exile taught me to make do with what I have. I can fish, farm, forage, and most importantly, I can stomach anything. Spoiled rations? Raw meat? Doesn't matter - I'll eat it and keep going."
	triumph_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/forester,
		/datum/virtue/utility/feral_appetite
	)
	custom_text = "Grants two virtues for the hardened survivor:\n\
	- Forester: Cooking, Athletics, Farming, Fishing, Lumberjacking skills, Trusty Hoe (HOMESTEAD_EXPERT trait)\n\
	- Feral Appetite: Can safely eat raw, toxic or spoiled food (NASTY_EATER trait)"

// High Society Pack: Nobility + Socialite
/datum/virtue/pack/highsociety
	name = "High Society (-12 TRI)"
	desc = "I was born into privilege and raised in the finest circles. Noble blood runs through my veins, I read the emotions of others with ease, and my charm opens every door. Wealth, beauty, and status are my birthright."
	triumph_cost = 12
	granted_virtues = list(
		/datum/virtue/utility/noble,
		/datum/virtue/utility/socialite
	)
	custom_text = "Grants two virtues for the aristocrat:\n\
	- Nobility: Noble status, Reading skill, +15 noble income, Heirloom Amulet & Hefty Coinpurse stashed\n\
	- Socialite: Beautiful, empathic, good lover traits + hand mirror stashed"

// Trusted Housekeeper Pack: Resident + Cunning Provisioner
/datum/virtue/pack/housekeeper
	name = "Trusted Housekeeper (-9 TRI)"
	desc = "I've served the households of this city for years - cooking, cleaning, and managing provisions. I know every street, have a home here, and my skills in the kitchen are unmatched. The city trusts me, and I know how to make do."
	triumph_cost = 9
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/granary
	)
	custom_text = "Grants two virtues for the city servant:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Cunning Provisioner: Cooking & Fishing skills, food bag stashed (HOMESTEAD_EXPERT)"

// Broken Soul Pack: Ugly + Tolerant + Deadened
/datum/virtue/pack/brokensoul
	name = "Broken Soul (-3 TRI)"
	desc = "Life has been cruel to me. My appearance drives others away, I've learned to endure what most cannot, and I've felt nothing for so long I can barely remember what emotions were like. I am a walking testament to survival through suffering."
	triumph_cost = 3
	granted_virtues = list(
		/datum/virtue/utility/ugly,
		/datum/virtue/utility/tolerant,
		/datum/virtue/utility/deadened
	)
	custom_text = "Grants three virtues for the outcast:\n\
	- Ugly: Unseemly appearance, immune to corpse stink (UNSEEMLY + NOSTINK traits)\n\
	- Tolerant: No stress from certain species, broad acceptance\n\
	- Deadened: Completely emotionless (NOMOOD trait)"
