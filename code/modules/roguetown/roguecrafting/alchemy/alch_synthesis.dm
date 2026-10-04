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

/datum/alch_synthesis_recipe/lux_life_infusion
	name = "Radiant Life Sphere"
	desc = "Infuses a pure Lux container with the vital essence of a Strong Health Elixir."
	req_item = /obj/item/reagent_containers/lux
	req_reagents_1 = list(/datum/reagent/medicine/stronghealth = 30)
	result_item = /obj/item/reagent_containers/food/snacks/grown/manabloom
	skill_required = SKILL_LEVEL_EXPERT

/datum/alch_synthesis_recipe/rejuvenation
	name = "Elixir of Rejuvenation"
	desc = "A harmonious synthesis of raw vitality and arcane mana."
	req_item = null
	req_reagents_1 = list(/datum/reagent/medicine/healthpot = 30)
	req_reagents_2 = list(/datum/reagent/medicine/manapot = 30)
	result_reagents = list(/datum/reagent/buff/temperature_normalize = 60)
	skill_required = SKILL_LEVEL_JOURNEYMAN

/datum/alch_synthesis_recipe/mirror_clay
	name = "Mirror Clay"
	desc = "Infuses malleable raw earth with pure lifeblood and intellect, creating living homunculus clay."
	req_item = /obj/item/natural/stone
	req_reagents_1 = list(/datum/reagent/medicine/stronghealth = 30)
	req_reagents_2 = list(/datum/reagent/buff/intelligence = 30)
	result_item = /obj/item/alch/mirror_clay
	skill_required = SKILL_LEVEL_EXPERT
