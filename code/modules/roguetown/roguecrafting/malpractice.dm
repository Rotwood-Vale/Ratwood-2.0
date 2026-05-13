/datum/crafting_recipe/roguetown/malpractice
	abstract_type = /datum/crafting_recipe/roguetown/malpractice
	req_table = FALSE
	verbage_simple = "fabricate"
	verbage = "fabricates"
	craftsound = 'sound/foley/butcher.ogg'
	skillcraft = /datum/skill/misc/medicine
	subtype_reqs = TRUE
	hides_from_books = TRUE
	always_availible = FALSE //So it's available only to select classes.

/datum/crafting_recipe/roguetown/malpractice/lungs
	name = "basic lungs"
	result = list(/obj/item/organ/lungs)
	reqs = list(/obj/item/alch/viscera = 1,
				/obj/item/reagent_containers/lux_impure = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/malpractice/heart
	name = "basic heart"
	result = list(/obj/item/organ/heart)
	reqs = list(/obj/item/alch/viscera = 1,
				/obj/item/reagent_containers/lux_impure = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/malpractice/liver
	name = "basic liver"
	result = list(/obj/item/organ/liver)
	reqs = list(/obj/item/alch/viscera = 1,
				/obj/item/reagent_containers/lux_impure = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/malpractice/stomach
	name = "basic stomach"
	result = list(/obj/item/organ/stomach)
	reqs = list(/obj/item/alch/viscera = 1,
				/obj/item/reagent_containers/lux_impure = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/malpractice/eyes
	name = "basic eyes"
	result = list(/obj/item/organ/eyes)
	reqs = list(/obj/item/alch/viscera = 1,
				/obj/item/reagent_containers/lux_impure = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/malpractice/tongue
	name = "basic tongue"
	result = list(/obj/item/organ/tongue)
	reqs = list(/obj/item/alch/viscera = 1,
				/obj/item/reagent_containers/lux_impure = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/malpractice/lungs_t1
	name = "completed lungs"
	result = list(/obj/item/organ/lungs/t1)
	reqs = list(/obj/item/organ/lungs = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/natural/bone = 1,
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/malpractice/heart_t1
	name = "completed heart"
	result = list(/obj/item/organ/heart/t1)
	reqs = list(/obj/item/organ/heart = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat = 1,
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/malpractice/liver_t1
	name = "completed liver"
	result = list(/obj/item/organ/liver/t1)
	reqs = list(/obj/item/organ/liver = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/reagent_containers/powder/salt = 1,
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/malpractice/stomach_t1
	name = "completed stomach"
	result = list(/obj/item/organ/stomach/t1)
	reqs = list(/obj/item/organ/stomach = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/rogueore/coal = 1,
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/malpractice/eyes_t1
	name = "Eyes of the Scholar of Noс"
	result = list(/obj/item/organ/eyes/t1)
	reqs = list(/obj/item/organ/eyes = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/reagent_containers/food/snacks/grown/carrot = 1,
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/malpractice/lungs_t2
	name = "blessed lungs"
	result = list(/obj/item/organ/lungs/t2)
	reqs = list(/obj/item/organ/lungs/t1 = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/alch/airdust = 2,
	)
	craftdiff = 6

/datum/crafting_recipe/roguetown/malpractice/heart_t2
	name = "blessed heart"
	result = list(/obj/item/organ/heart/t2)
	reqs = list(/obj/item/organ/heart/t1 = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/alch/firedust = 2,
	)
	craftdiff = 6

/datum/crafting_recipe/roguetown/malpractice/liver_t2
	name = "blessed liver"
	result = list(/obj/item/organ/liver/t2)
	reqs = list(/obj/item/organ/liver/t1 = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/alch/waterdust = 2,
	)
	craftdiff = 6

/datum/crafting_recipe/roguetown/malpractice/stomach_t2
	name = "blessed stomach"
	result = list(/obj/item/organ/stomach/t2)
	reqs = list(/obj/item/organ/stomach/t1 = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/alch/waterdust = 1,
				/obj/item/alch/airdust = 1,
	)
	craftdiff = 6

/datum/crafting_recipe/roguetown/malpractice/eyes_t2
	name = "blessed dendorite eyes"
	result = list(/obj/item/organ/eyes/t2)
	reqs = list(/obj/item/organ/eyes/t1 = 1,
				/obj/item/reagent_containers/lux = 1,
				/obj/item/alch/firedust = 1,
				/obj/item/alch/waterdust = 1,
	)
	craftdiff = 6
