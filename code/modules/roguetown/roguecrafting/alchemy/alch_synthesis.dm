GLOBAL_LIST_INIT(alch_synthesis_recipes, init_subtypes(/datum/alch_synthesis_recipe))

/datum/alch_synthesis_recipe
	var/name = "Alchemy Synthesis"
	var/desc = ""
	var/req_item = null
	var/list/req_reagents_1 = list()
	var/list/req_reagents_2 = list()
	var/result_item = null
	var/list/result_reagents = list()
	var/skill_required = SKILL_LEVEL_JOURNEYMAN


/datum/alch_synthesis_recipe/mirror_clay
	name = "Mirror Clay"
	desc = "Infuses malleable raw earth with pure lifeblood and intellect, creating living homunculus clay."
	req_item = /obj/item/natural/stone
	req_reagents_1 = list(/datum/reagent/medicine/stronghealth = 30)
	req_reagents_2 = list(/datum/reagent/buff/intelligence = 30)
	result_item = /obj/item/alch/mirror_clay
	skill_required = SKILL_LEVEL_EXPERT
