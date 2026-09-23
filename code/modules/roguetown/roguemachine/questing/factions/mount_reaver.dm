/datum/quest_faction/mount_reaver
	id = QUEST_FACTION_MOUNT_REAVER
	name_singular = "mount reaver"
	name_plural = "mount reavers"
	group_word = "gang"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_HUMANOID
	// Ratwood deviation: AP's /highwayman/mount_reaver (mounted elite) has no ES equivalent; the raiding
	// core is stood in by searaiders so the warband keeps two distinct types instead of collapsing.
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 70,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 100,
	)
	boss_title_templates = list(
		"%N the Ironclad",
		"%N Stonebreaker",
		"%N the Bear",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
