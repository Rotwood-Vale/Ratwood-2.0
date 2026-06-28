/datum/patron/inhumen
	name = null
	associated_faith = /datum/faith/inhumen
	undead_hater = FALSE
	var/crafting_recipes = list(/datum/crafting_recipe/roguetown/structure/zizo_shrine)			//Allows construction of unique bad shrine.
	profane_words = list("cock","dick","fuck","shit","pussy","cuck","cunt","asshole", "pintle")	//Same as master but 'Zizo' is allowed now.
	confess_lines = list(
		"普赛顿就是造物伪神！",
		"十神都是毫无价值的懦夫！",
		"十神都是骗子！",
	)

/datum/patron/inhumen/on_gain(mob/living/living)
	. = ..()

	if(ishuman(living) && living.mind)
		living.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/structure/zizo_shrine)
