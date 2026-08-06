/// Civic classification helpers. Maps a job title to a civic-class department used by the
/// Assembly for vote weighting and by other systems that care about class groupings. Kept as a
/// plain proc with no subsystem dependency so callers can use it without pulling the Assembly
/// or other modules into scope.
/// ES: the switch below is built from Emerald Summit's actual job roster (which has diverged
/// from Azure-Peak's) while keeping AP's department taxonomy. Titles listed here must match
/// mob.job strings exactly; anything unmatched falls through to "NONE" (no vote).

/proc/civic_department(job)
	if(!job)
		return "NONE"
	switch(job)
		// Nobility and the ducal household.
		if("Grand Duke", "Grand Duchess", "Duke Emeritus", "Consort", "Consort Dowager", "Prince", "Princess", "Hand", "Marshal", "Steward", "Knight", "Dame", "Suitor")
			return "KEEP"
		// Court staff and retainers.
		if("Councillor", "Seneschal", "Clerk", "Servant", "Court Physician")
			return "KEEP"
		// Garrison.
		if("Sergeant", "Man at Arms", "Woman at Arms", "Warden", "Watchman", "Watchwoman", "Veteran", "Squire", "Gatemaster", "Dungeoneer")
			return "KEEP"
		if("Inquisitor", "Absolver", "Orthodoxist")
			return "INQUISITION"
		// Antagonists, outcasts and captives - civically dead.
		if("Wretch", "Bandit", "Lunatic", "Thug", "Gnoll", "Prisoner (Town)", "Prisoner (Bog)", "Hostage (Bandit)")
			return "EXCLUDED"
		// Drifters and hired blades passing through.
		if("Adventurer", "Court Agent", "Mercenary", "Pilgrim", "Lord of Heartfelt", "Hand of Heartfelt", "Knight of Heartfelt", "Heartfeltian Retinue")
			return "TOWN_TRANSIENT"
		// Common laborers of the town.
		if("Towner", "Soilson", "Vagabond", "Beggar", "Cook", "Tapster", "Butcher", "Nightswain", "Shophand")
			return "TOWN_PEASANT"
		// Shopkeeps, artisans and lettered professionals.
		if("Innkeeper", "Guildsman", "Guild Clerk", "Archivist", "Apothecary", "Tailor", "Scribe", "Loudmouth", "Jester", "Magos Thrall")
			return "TOWN_BURGHER"
		// The Church.
		if("Vice Priest", "Vice Priestess", "Acolyte", "Druid", "Templar", "Martyr", "Churchling")
			return "TOWN_CLERGY"
		// Town elites. ES: the Priest is Emerald Summit's head-of-church (AP's "Bishop"
		// analogue), so they sit with the notables rather than the common clergy.
		if("Priest", "Priestess", "Court Magician", "Merchant", "Guildmaster", "Nightmaster", "Town Elder")
			return "TOWN_NOTABLE"
	return "NONE"
