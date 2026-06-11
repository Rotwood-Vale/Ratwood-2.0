/datum/crafting_recipe/roguetown/fleshcrafting
	abstract_type = /datum/crafting_recipe/roguetown/fleshcrafting
	req_table = FALSE
	verbage_simple = "组装"
	skillcraft = /datum/skill/labor/butchering
	subtype_reqs = TRUE
	structurecraft = /obj/structure/roguemachine/chimeric_heart_beast

/datum/crafting_recipe/roguetown/fleshcrafting/decoy
	name = "血肉诱饵（2 份鲜肉）"
	category = "血肉"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "FLESH_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/decoy_alt
	name = "血肉诱饵（2 份内脏）"
	category = "血肉"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/alch/viscera = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "VISCERA_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/flesh_node
	name = "血肉节点（1 份腐肉）"
	category = "血肉"
	result = list(/obj/item/flesh_node)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/fleshcrafting/lungs
	name = "肺"
	category = "血肉"
	result = list(/obj/item/organ/lungs)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/heart
	name = "心脏"
	category = "血肉"
	result = list(/obj/item/organ/heart)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/liver
	name = "肝脏"
	category = "血肉"
	result = list(/obj/item/organ/liver)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE


/datum/crafting_recipe/roguetown/fleshcrafting/eyes
	name = "眼球"
	category = "血肉"
	result = list(/obj/item/organ/eyes)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/tongue
	name = "舌头"
	category = "血肉"
	result = list(/obj/item/organ/tongue)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/black_rose
	name = "黑玫瑰"
	category = "血肉"
	result = list(/obj/item/black_rose)
	reqs = list(/obj/item/heart_blood_canister/filled = 5,
				/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 15)
	craftdiff = 5
	required_tech_node = "BLACK_ROSE"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait
	name = "水蛭饵"
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
	name = "邪孽血肉"
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
