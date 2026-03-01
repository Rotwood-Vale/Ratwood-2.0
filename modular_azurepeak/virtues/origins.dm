
/datum/virtue/utility/blacksmith
	name = "Forged in Fire"
	desc = "In my youth, I worked under a skilled blacksmith, learning the ways of the forge and anvil."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(list(/datum/skill/craft/crafting, 1, 1),
						list(/datum/skill/craft/weaponsmithing, 1, 1),
						list(/datum/skill/craft/armorsmithing, 1, 1),
						list(/datum/skill/craft/blacksmithing, 1, 1),
						list(/datum/skill/craft/smelting, 1, 1)
	)

/datum/virtue/utility/tailor
	name = "Needlework and Thread"
	desc = "In my youth, I worked under a skilled tailor, learning to work with fabric and leather."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(list(/datum/skill/craft/crafting, 1, 1),
						list(/datum/skill/labor/butchering, 1, 1),
						list(/datum/skill/craft/sewing, 1, 1),
						list(/datum/skill/craft/tanning, 1, 1)
	)

/datum/virtue/utility/physician
	name = "Healer's Education"
	desc = "In my youth, I studied under a skilled physician, learning the arts of medicine and alchemy."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(list(/datum/skill/craft/crafting, 1, 1),
						list(/datum/skill/craft/alchemy, 1, 1),
						list(/datum/skill/misc/medicine, 1, 1)
	)

/datum/virtue/utility/physician/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)


/datum/virtue/utility/hunter
	name = "Tracker's Tutelage"
	desc = "In my youth, I trained under a skilled hunter, learning to track game and work with hides."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(list(/datum/skill/craft/crafting, 1, 1),
						list(/datum/skill/craft/traps, 1, 1),
						list(/datum/skill/labor/butchering, 1, 1),
						list(/datum/skill/craft/sewing, 1, 1),
						list(/datum/skill/craft/tanning, 1, 1),
						list(/datum/skill/misc/tracking, 1, 1)
	)

/datum/virtue/utility/artificer
	name = "Builder's Foundation"
	desc = "In my youth, I worked under a skilled artificer, learning construction and engineering."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(list(/datum/skill/craft/crafting, 1, 1),
						list(/datum/skill/craft/carpentry, 1, 1),
						list(/datum/skill/craft/masonry, 1, 1),
						list(/datum/skill/craft/engineering, 1, 1),
						list(/datum/skill/craft/smelting, 1, 1),
						list(/datum/skill/craft/ceramics, 1, 1)
	)

/datum/virtue/utility/mining
	name = "Deep Delver"
	desc = "In my youth, I worked the dark shafts and learned the miner's craft in the depths."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(list(/datum/skill/labor/mining, 1, 1),
						list(/datum/skill/craft/smelting, 1, 1),
						list(/datum/skill/craft/crafting, 1, 1)
	)

/datum/virtue/utility/homesteader_novice
	name = "Farmstead Youth"
	desc = "I grew up on a homestead, learning farming, cooking, woodcutting, and the daily labors of self-sufficiency."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(
		list(/datum/skill/labor/farming, 1, 1),
		list(/datum/skill/craft/cooking, 1, 1),
		list(/datum/skill/labor/fishing, 1, 1),
		list(/datum/skill/craft/crafting, 1, 1)
	)

/datum/virtue/utility/artisan_novice
	name = "Workshop Upbringing"
	desc = "I grew up in a workshop, learning the fundamentals of working with metal, fabric, and clay."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(
		list(/datum/skill/craft/crafting, 1, 1),
		list(/datum/skill/craft/blacksmithing, 1, 1),
		list(/datum/skill/craft/sewing, 1, 1),
		list(/datum/skill/craft/ceramics, 1, 1),
		list(/datum/skill/craft/engineering, 1, 1)
	)

/datum/virtue/utility/healer_novice
	name = "Infirmary Raised"
	desc = "I grew up around healers, learning the basics of medicine, and tending to the sick."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(
		list(/datum/skill/misc/medicine, 1, 1),
		list(/datum/skill/craft/crafting, 1, 1),
		list(/datum/skill/craft/sewing, 1, 1),
		list(/datum/skill/craft/cooking, 1, 1),
	)

/datum/virtue/utility/vagabond_novice
	name = "Back-Alley Vagabond"
	desc = "I grew up on gutters and back roads, surviving by quick hands, quicker feet, and knowing when to vanish from sight."
	category = "origin"
	virtue_cost = 2
	blocked_feats = list(/datum/virtue/utility/artificer/trait,
		/datum/virtue/utility/blacksmith/trait,
		/datum/virtue/utility/tailor/trait,
		/datum/virtue/utility/physician/trait,
		/datum/virtue/utility/hunter/trait,
		/datum/virtue/utility/mining/trait,
		/datum/virtue/utility/homesteader,
		/datum/virtue/utility/forester,
		/datum/virtue/utility/granary
	)
	added_skills = list(
		list(/datum/skill/misc/stealing, 1, 1),
		list(/datum/skill/misc/lockpicking, 1, 1),
		list(/datum/skill/misc/sneaking, 1, 1),
		list(/datum/skill/misc/climbing, 1, 1)
	)



