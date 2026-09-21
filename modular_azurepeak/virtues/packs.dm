// Virtue Packs - Triumph-cost combinations of virtues that make thematic sense together

/datum/virtue/pack
	/// List of virtue types that this pack grants
	var/list/granted_virtues = list()

/datum/virtue/pack/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Apply all virtues in the pack without checking triumphs (pack already cost triumphs)
	for(var/virtue_path in granted_virtues)
		var/datum/virtue/V = GLOB.virtues[virtue_path]
		if(V)
			V.apply_generic_effects(recipient)

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
	name = "Enchanting Performer (-6 TRI)"
	desc = "I am a master of the stage and salon alike - beautiful, talented, and charming. My performances captivate audiences, and my social graces open every door."
	triumph_cost = 6
	granted_virtues = list(
		/datum/virtue/utility/socialite,
		/datum/virtue/utility/performer
	)
	custom_text = "Grants two virtues for the perfect entertainer:\n\
	- Socialite: Beautiful, empathic, good lover traits + hand mirror stashed\n\
	- Performer: Choose stashed instrument, +4 Music skill, nutcracker."

// Traveling Scholar Pack: Linguist + Rich and Shrewd + Equestrian
// For worldly scholars who have traveled extensively and accumulated wealth and knowledge
/datum/virtue/pack/travelingscholar
	name = "Traveling Scholar (-15 TRI)"
	desc = "My travels across distant lands have made me wealthy in both coin and wisdom. I speak many tongues, understand the value of all things, and ride with practiced ease. The world is my library, and every road teaches me something new."
	triumph_cost = 15
	granted_virtues = list(
		/datum/virtue/utility/linguist,
		/datum/virtue/items/rich,
		/datum/virtue/utility/riding
	)
	custom_text = "Grants three virtues for the worldly traveler:\n\
	- Intellectual: +1 INT, +3 Reading, choose 3 languages, assess with stats, book crafting kit stashed (INTELLECTUAL)\n\
	- Rich and Shrewd: Appraise spell, see prices, coinpurse stashed (SEEPRICES)\n\
	- Equestrian: Call and bond with a treasured mount, Apprentice Riding, saddle stashed, navigate doors while mounted (EQUESTRIAN)"

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

// Trusted Housekeeper Pack: Resident + Cunning Provisioner
/datum/virtue/pack/housekeeper
	name = "Trusted Housekeeper (-5 TRI)" //BD Dropped price by 4 to make it round stable, so long as you're playing you should be able to keep using it
	desc = "I've served the households of this city for years - cooking, cleaning, and managing provisions. I know every street, have a home here, and my skills in the kitchen are unmatched. The city trusts me, and I know how to make do."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/granary
	)
	custom_text = "Grants two virtues for the city servant:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Cunning Provisioner: Cooking & Fishing skills, food bag stashed (HOMESTEAD_EXPERT)"

// Man in The Pub Pack: Resident + Pilgrim
/datum/virtue/pack/pubman
	name = "Man in The Pub (-8 TRI)"
	desc = "You've been around for a while, and seem to know a little bit about everything about living in these lands. You know how to farm the land, hunt for meat, fish and cook, and you've had your fair share of knife fights in the Tavern. The city knows you me, and you know it."
	triumph_cost = 8
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/homesteader
	)
	custom_text = "Grants two virtues for the city servant:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Pilgrim: Cooking, Fishing, Lumberjacking, Athletics, Farming, and Knife skills, food bag, hunting knife, and hoe stashed (HOMESTEAD_EXPERT)"

// Broken Soul Pack: Tolerant + Deadened
/datum/virtue/pack/brokensoul
	name = "Broken Soul (-2 TRI)"
	desc = "Life has been cruel to me. I've learned to endure what most cannot, and I've felt nothing for so long I can barely remember what emotions were like. I am a walking testament to survival through suffering."
	triumph_cost = 2
	granted_virtues = list(
		/datum/virtue/utility/tolerant,
		/datum/virtue/utility/deadened
	)
	custom_text = "Grants two virtues for the outcast:\n\
	- Tolerant: No stress from certain species, broad acceptance\n\
	- Deadened: Completely emotionless (NOMOOD trait)"

// Arcyne Worshiper Pack: Arcyne Potential + Devotee
/datum/virtue/pack/arcyneworkship
	name = "Arcyne Worshiper (-6 TRI)"
	desc = "I have found that not all things can be answered with magic, and that sometimes the unseen hands of the gods are needed. In devoting myself to both paths, i am great for the journey ahead."
	triumph_cost = 6
	granted_virtues = list(
		/datum/virtue/combat/magical_potential,
		/datum/virtue/combat/devotee
	)
	custom_text = "Grants two virtues for the Arcyne Worshiper:\n\
	- Magical Potential: Innate ability to wield magic\n\
	- Devotee: Deep devotion to Arcyne, with a strong connection to the divine"

// Hobbyist Tinkerer Pack: Resident + Artificer
/datum/virtue/pack/hobbyist
	name = "Hobbyist Tinkerer (-5 TRI)"
	desc = "In between your daily activities, you find time to tinker and toy with gears and cogs, marvelling at what could be made with a little bit of time and effort."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/artificer
	)
	custom_text = "Grants two virtues for the Hobbyist Tinkerer:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Artificer's Apprentice: Skilled in crafting and tinkering with mechanical devices"

// DIY Patchjob Pack: Resident + Blacksmith
/datum/virtue/pack/patchjob
	name = "Patchjob (-5 TRI)"
	desc = "For the true connoisseur of the patchjob. There's nothing some spit and polish can't fix."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/blacksmith
	)
	custom_text = "Grants two virtues for the Patchjob:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Blacksmith's Apprentice: Skilled in crafting and repairing metallic devices"

// Pit Fighter Pack: Resident + Brawler
/datum/virtue/pack/pitfighter
	name = "Pit Fighter (-5 TRI)"
	desc = "Not all work is glamourous, but when there's blood on your knuckles and a crowd cheering your name, you could swear you're on top of the world."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/combat/brawler
	)
	custom_text = "Grants two virtues for the Pit Fighter:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Brawler's Apprentice: Skilled in hand-to-hand combat"

// Volf In Sheep's Clothing Pack: Resident + Defiled Keyholder
/datum/virtue/pack/volfsheep
	name = "Volf In Sheep's Clothing (-5 TRI)"
	desc = "They let me into their businesses, their taverns, their homes, never knowing what lies behind this fake smile. But when the others come to bring down the 10, they will have friends inside the walls."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/heretic/zchurch_keyholder
	)
	custom_text = "Grants two virtues for the Volf In Sheep's Clothing:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Defiled Keyholder: Know the location of the local heretic conclave"

// Street Fencer Pack: Resident + Duelist
/datum/virtue/pack/streetfencer
	name = "Street Fencer (-5 TRI)"
	desc = "Whether schooled by tutor or hard knocks, I have learned how to wield a blade with skill, and now these streets have become my battleground, when my honour is questioned, the glint of my blade is not to far off."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/combat/duelist
	)
	custom_text = "Grants two virtues for the Street Fencer:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Duelist's Apprentice: Skilled in dueling and swordplay"

// Collector Pack: Resident + Executioner
/datum/virtue/pack/collector
	name = "Collector (-5 TRI)"
	desc = "What is the point of digging my way into an ancient tomb or forgotten dwarven stronghold, if I can't bring my discoveries back and show them off."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/combat/executioner
	)
	custom_text = "Grants two virtues for the Collector:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Dungoneer's Apprentice: Skilled in Axes and Whips"

// One In The Drawstring Pack: Resident + Crossbowman
/datum/virtue/pack/oneinthedrawstring
	name = "One In The Drawstring (-5 TRI)"
	desc = "You know what keeps petty thieves and would be heretics up at night? The thought of me coming down the stairs with a loaded crossbow aimed right at their head."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/combat/crossbowman
	)
	custom_text = "Grants two virtues for this combo virtue:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Crossbow Levy: Skilled in using crossbows"

// Dreaming of a Knight's Tale Pack: Resident + Failed Squire
/datum/virtue/pack/knightstale
	name = "Dreaming of a Knight's Tale (-5 TRI)"
	desc = "I coulda been a Knight you know, was a squire and everything, but they said I couldn't hack it. What do they know anyways huh? Wouldn't know a real squire if it kicked em in the teeth."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/failed_squire
	)
	custom_text = "Grants two virtues for this combo virtue:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Failed Squire: Squire Knowledge and the tools to use it"

// Logger Pack: Resident + Forester
/datum/virtue/pack/logger
	name = "Logger (-5 TRI)"
	desc = "Someone's gotta keep the hearths lit mate, and it sure ain't gonna be the Duke, sitting on his rear like that. Nah, is folks like me that get out there are pull in the firewood before winter."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/forester
	)
	custom_text = "Grants two virtues for the Logger:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Forester: Skilled in woodgathering and survival"

// Butcher Pack: Resident + Hunter's Apprentice
/datum/virtue/pack/butcher
	name = "Butcher (-5 TRI)"
	desc = "Why they gotta keep asking me what kinda meat, meat is meat alright friend. Don't like it, go somewhere else, ain't no skin off my teeth. 'sides, it's not like anyone's gonna be complaining about a few less Rous in the sewers eh?"
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/hunter
	)
	custom_text = "Grants two virtues for the Butcher:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Hunter's Apprentice: Skilled in butchering, tanning, and tracking"

// Locksmith Pack: Resident + Larcenous
/datum/virtue/pack/locksmith
	name = "Locksmith (-5 TRI)"
	desc = "Some people say I'm no better than a petty thief, and that simply ain't true. I provide a valuable service. I let you back in to your lovely home, when you've been stupid enough to lock yourself out somehow. And most of the time I only take your payment and nothing else."
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/larcenous
	)
	custom_text = "Grants two virtues for the Locksmith:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Larcenous: Skilled in lockpicking"

// Citizen's Militia Pack: Resident + Militiaman
/datum/virtue/pack/citizen_militia
	name = "Citizen's Militia (-5 TRI)"
	desc = "You know, I don't get the respect I deserve. Just cause I ain't a guard, don't mean I'm not vital to the cities defence. I mean, what would happen if me and my mate's weren't here. That's right, this place would be overrun with deadites in no time at all. So uh... my drinks are free right?"
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/combat/militia
	)
	custom_text = "Grants two virtues for the Citizen's Militia:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Militiaman: Skilled in spears and maces"

// Coal Runner Pack: Resident + Miner's Apprentice
/datum/virtue/pack/coal_runner
	name = "Coal Runner (-5 TRI)"
	desc = "The forges don't feed themselves friend, oh no. That would be me and the lads. We head out with our picks on our shoulders and a song in our hearts, and by the end of the day we'll be back with more than enough fuel for the fires. "
	triumph_cost = 5
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/mining
	)
	custom_text = "Grants two virtues for the Coal Runner:\n\
	- Resident: City residency, treasury account, home in the city\n\
	- Miner's Apprentice: Skilled in spears and maces"
