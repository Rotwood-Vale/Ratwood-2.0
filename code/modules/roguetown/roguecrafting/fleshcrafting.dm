/datum/crafting_recipe/roguetown/fleshcrafting
	abstract_type = /datum/crafting_recipe/roguetown/fleshcrafting
	req_table = FALSE
	verbage_simple = "assembles"
	skillcraft = /datum/skill/labor/butchering
	subtype_reqs = TRUE
	structurecraft = /obj/structure/roguemachine/chimeric_heart_beast

/datum/crafting_recipe/roguetown/fleshcrafting/decoy
	name = "flesh decoy (2x fresh meat)"
	category = "Flesh"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "FLESH_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/decoy_alt
	name = "flesh decoy (2x viscera)"
	category = "Flesh"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/alch/viscera = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "VISCERA_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/flesh_node // flesh nodes need to be made with beast, organs dont, but need the nodes
	name = "flesh node (1x rotten meat)"
	category = "Flesh"
	result = list(/obj/item/flesh_node)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	craftdiff = 1
	required_tech_node = "FLESH_NODE"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/lungs
	name = "Lungs"
	category = "Flesh"
	result = list(/obj/item/organ/lungs,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	structurecraft = null
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/heart
	name = "Heart"
	category = "Flesh"
	result = list(/obj/item/organ/heart,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/liver
	name = "Liver"
	category = "Flesh"
	result = list(/obj/item/organ/liver,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	structurecraft = null
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/stomach
	name = "Stomach"
	category = "Flesh"
	result = list(/obj/item/organ/stomach,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/eyes
	name = "Eyes"
	category = "Flesh"
	result = list(/obj/item/organ/eyes,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	structurecraft = null	
	tech_unlocked = FALSE
	
/datum/crafting_recipe/roguetown/fleshcrafting/ear
	name = "Ears"
	category = "Flesh"
	result = list(/obj/item/organ/ears,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	structurecraft = null	
	tech_unlocked = FALSE


/datum/crafting_recipe/roguetown/fleshcrafting/tongue
	name = "Tongue"
	category = "Flesh"
	result = list(/obj/item/organ/tongue,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/r_arm
	name = "Right arm"
	category = "Flesh"
	result = list(/obj/item/bodypart/r_arm,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/l_arm
	name = "Left arm"
	category = "Flesh"
	result = list(/obj/item/bodypart/l_arm,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/r_leg
	name = "Right leg"
	category = "Flesh"
	result = list(/obj/item/bodypart/r_leg,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/l_leg
	name = "Left leg"
	category = "Flesh"
	result = list(/obj/item/bodypart/l_leg,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/head // build a abomination!
	name = "Head"
	category = "Flesh"
	result = list(/obj/item/bodypart/head/filled,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "ADVANCED_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/chest
	name = "Chest"
	category = "Flesh"
	result = list(/mob/living/carbon/human/species/human/northern/torso,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "ADVANCED_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/human // yea that one needs heart help. GO FORTH FRANKENSTAIN!!!
	name = "A new life"
	category = "Flesh"
	result = list(/mob/living/carbon/human/species/human/northern,)
	reqs = list(/obj/item/flesh_node = 7,
				/obj/item/heart_blood_vial/filled = 3,
				/obj/item/reagent_containers/lux = 1,)
	craftdiff = 5
	required_tech_node = "LIFE_CREATION"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/black_rose
	name = "Black Rose"
	category = "Flesh"
	result = list(/obj/item/black_rose)
	reqs = list(/obj/item/heart_blood_canister/filled = 5,
				/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 15)
	craftdiff = 5
	required_tech_node = "BLACK_ROSE"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait
	name = "leechbait"
	craftdiff = 1
	result = list(
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		)
	reqs = list(
		/obj/item/storage/roguebag = 3,
		/obj/item/reagent_containers/lux_impure = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/imperfect_gnoll
	name = "vilespawn flesh"
	craftdiff = 1
	result = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 1,
		/obj/item/roguegem/blood_diamond = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null
