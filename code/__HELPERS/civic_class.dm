/// Civic classification helpers. Maps a job title to a civic-class department used by the
/// Assembly for vote weighting and by other systems that care about class groupings. Kept as a
/// plain proc with no subsystem dependency so callers can use it without pulling the Assembly
/// or other modules into scope.
/// The switch below is built from this tree's actual job roster (titles and, defensively, the
/// f_titles it defines) while keeping AP's department taxonomy. Titles listed here must match
/// mob.job strings exactly; anything unmatched falls through to "NONE" (no vote).

/proc/civic_department(job)
	if(!job)
		return "NONE"
	switch(job)
		// Nobility and the ducal household.
		if("Grand Duke", "Grand Duchess", "Consort", "Consort Dowager", "Prince", "Princess", "Hand", "Marshal", "Steward", "Knight", "Knight Captain", "Suitor")
			return "KEEP"
		// Court staff and retainers.
		if("Councillor", "Seneschal", "Clerk", "Servant", "Head Physician", "Court Chaplain", "Magicians Associate")
			return "KEEP"
		// Garrison.
		if("Sergeant", "Man at Arms", "Warden", "Master Warden", "Watchman", "Watch Captain", "City Guard", "Rookie", "Vanguard", "Veteran", "Squire", "Dungeoneer")
			return "KEEP"
		if("Inquisitor", "Absolver", "Orthodoxist")
			return "INQUISITION"
		// Antagonists, outcasts, captives and non-town roles - civically dead.
		if("Wretch", "Bandit", "Lunatic", "Assassin", "Gnoll", "Goblin", "Prisoner (Town)", "Tester")
			return "EXCLUDED"
		if("Chieftain", "Tribe Chieftess", "Tribal Guard", "Tribal Rabble", "Tribal Shaman", "Tribal Villager")
			return "EXCLUDED"
		if("Fortified Skeleton", "Greater Skeleton", "Vampire Guard", "Vampire Servant", "Vampire Spawn")
			return "EXCLUDED"
		// Drifters and hired blades passing through.
		if("Adventurer", "Court Agent", "Mercenary", "Refugee", "Trader", "Lord of Heartfelt", "Hand of Heartfelt", "Knight of Heartfelt", "Heartfeltian Retinue")
			return "TOWN_TRANSIENT"
		// Common laborers of the town.
		if("Towner", "Soilson", "Soilbride", "Vagabond", "Beggar", "Cook", "Tapster", "Bathhouse Attendant", "Bathmatron", "Shophand")
			return "TOWN_PEASANT"
		// Shopkeeps, artisans and lettered professionals.
		if("Innkeeper", "Guildsman", "Archivist", "Apothecary", "Tailor", "Jester", "Town Crier")
			return "TOWN_BURGHER"
		// The Church.
		if("Vice Priest", "Vice Priestess", "Acolyte", "Druid", "Druidess", "Templar", "Martyr", "Churchling", "Keeper")
			return "TOWN_CLERGY"
		// Town elites. The Bishop heads this tree's church and sits with the notables rather
		// than the common clergy, matching AP's placement of their head-of-church.
		if("Bishop", "Court Magician", "Merchant", "Guildmaster", "Bathmaster")
			return "TOWN_NOTABLE"
	return "NONE"
