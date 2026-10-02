/datum/virtue/nobility
	name = "Nobility"
	desc = "By birth, blade or brain, I carry noble blood, if only a minor and untitled line of it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	custom_text = "This virtue grants you MINOR nobility, meaning you are still subjected to the Great Writ and poll tax. Unlocks noble items in the loadout. Limited to 2."
	point_cost = 3
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list(
	"Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
	"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
	)
	incompatible_vices = list(/datum/charflaw/lawless)
	incompatible_virtues = list(/datum/virtue/defilednobility)
	incompatible_quirks = list(/datum/quirk/gossiper)
	incompatible_traits = list(TRAIT_NOBLE)
	loadout_grants = list(LOADOUT_NOBLE = 2)

/datum/virtue/nobility/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15
	recipient.social_rank = max(recipient.social_rank, SOCIAL_RANK_MINOR_NOBLE)

// disgraced nobles get shittier stuff from da loadout.
/datum/virtue/defilednobility
	name = "Disgraced Nobility"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	custom_text = "Unlocks noble items in the loadout. Limited to 2. They aren't as good!"
	point_cost = 1
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_virtues = list(/datum/virtue/nobility)
	incompatible_traits = list(TRAIT_NOBLE)
	loadout_grants = list(LOADOUT_NOBLE = 2)
	loadout_shabby = list(LOADOUT_NOBLE)
