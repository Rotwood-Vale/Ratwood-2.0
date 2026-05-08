/datum/skill/magic
	abstract_type = /datum/skill/magic
	name = "Magic"
	desc = ""
	randomable_dream_xp = FALSE
	color = "#9f74d6"
	max_skillbook_level = 3

/datum/skill/magic/holy
	name = "Miracles"
	desc = "Gives you access to higher tier of miracles from your patrons."
	expert_name = "Devotee"

/datum/skill/magic/blood
	name = "Blood Sorcery"
	desc = "Currently does not affect anything."
	expert_name = "Sorcerer"

/datum/skill/magic/arcane
	name = "Arcane Magic"
	desc = "Decreases casting time by 5% per level."
	expert_name = "Arcanist"

/datum/skill/magic/druidic
	name = "Druidic Trickery"
	desc = "Governs mastery over Dendor's nature rites. Unlocks higher tiers of animal transformation. Permits use of fey circles at Expert rank. Gates access to the Sanctified Tree's rituals by rank — from Novice through Master. Gained by completing tree bounties, sanctifying trees, and harvesting crops as a Dendor patron."
	expert_name = "Druid"
	max_skillbook_level = 3
