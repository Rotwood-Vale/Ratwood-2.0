/datum/quest_faction/mirespider
	id = QUEST_FACTION_MIRESPIDER
	name_singular = "mirespider"
	name_plural = "mirespiders"
	group_word = "nest"
	faction_tag = FACTION_SPIDERS
	category = FACTION_CAT_BEAST
	// ES deviation: AP's drider (its own type) has no ES beast equivalent and was substituted to
	// spider/mutated - which already had a weight, so the two are merged (20+10) rather than left
	// as a dropped duplicate key.
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/spider = 70,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 30,
	)
