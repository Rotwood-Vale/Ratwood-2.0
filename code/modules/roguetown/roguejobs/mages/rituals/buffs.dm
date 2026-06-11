/datum/runeritual/knowledge
	name = "知识增幅"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 1)

/datum/runeritual/knowledge/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

/datum/runeritual/buff
	blacklisted = TRUE
	tier = 1
	var/buff

/datum/runeritual/buff/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

/datum/runeritual/buff/strength
	name = "奥术力量增幅"
	buff = /datum/status_effect/buff/magicstrength
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 2,/obj/item/magic/elemental/shard = 2)

/datum/runeritual/buff/lesserstrength
	name = "次级奥术力量增幅"
	buff = /datum/status_effect/buff/magicstrength/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/elemental/mote = 2,/obj/item/magic/manacrystal = 1)

/datum/runeritual/buff/constitution
	name = "强化体质"
	buff = /datum/status_effect/buff/magicconstitution
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 2, /obj/item/magic/obsidian = 4)

/datum/runeritual/buff/lesserconstitution
	name = "次级强化体质"
	buff = /datum/status_effect/buff/magicconstitution/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 1, /obj/item/magic/obsidian = 2)

/datum/runeritual/buff/speed
	name = "急速"
	buff = /datum/status_effect/buff/magicspeed
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/artifact = 2, /obj/item/magic/leyline = 2)

/datum/runeritual/buff/lesserspeed
	name = "次级急速"
	buff = /datum/status_effect/buff/magicspeed/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/artifact = 1, /obj/item/magic/leyline = 1)

/datum/runeritual/buff/perception
	name = "奥术之眼"
	buff = /datum/status_effect/buff/magicperception
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 2, /obj/item/magic/infernal/fang = 1)

/datum/runeritual/buff/lesserperception
	name = "次级奥术之眼"
	buff = /datum/status_effect/buff/magicperception/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/magic/infernal/ash = 2)

/datum/runeritual/buff/willpower
	name = "振奋意志"
	buff = /datum/status_effect/buff/magicwillpower
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/obsidian = 2, /obj/item/magic/fae/scale = 1)

/datum/runeritual/buff/lesserwillpower
	name = "次级振奋意志"
	buff = /datum/status_effect/buff/magicwillpower/lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/obsidian = 2, /obj/item/magic/fae/dust = 2)

/datum/runeritual/buff/nightvision
	name = "暗视"
	buff = /datum/status_effect/buff/darkvision
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 2, /obj/item/magic/fae/scale = 1, /obj/item/magic/elemental/shard = 1)
