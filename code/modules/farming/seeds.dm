/obj/item/seeds
	name = "seeds"
	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	possible_item_intents = list(/datum/intent/use)
	var/plant_def_type
	var/seed_identity = "some seed"

	var/cooking = 0
	var/cooktime = 20 SECONDS
	var/burning = 0
	var/burntime = 3 MINUTES

	var/burned_color = "#302d2d"
	var/cooked_smell = /datum/pollutant/food/roasted_seeds
	var/cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds

/obj/item/seeds/Initialize(mapload)
	. = ..()
	if(plant_def_type)
		var/datum/plant_def/def = GLOB.plant_defs[plant_def_type]
		color = def.seed_color

/obj/item/seeds/examine(mob/user)
	. = ..()
	var/show_real_identity = FALSE
	if(isliving(user))
		var/mob/living/living = user
		// Seed knowers, know the seeds (druids and such)
		if(HAS_TRAIT(living, TRAIT_SEEDKNOW))
			show_real_identity = TRUE
		// Journeyman farmers know them too
		else if(living.get_skill_level(/datum/skill/labor/farming) >= 2)
			show_real_identity = TRUE
	else
		show_real_identity = TRUE
	if(show_real_identity)
		. += span_info("I can tell these are [seed_identity]")

/obj/item/seeds/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = get_soil_on_turf(T)
	if(soil)
		try_plant_seed(user, soil)
		return
	else if(istype(T, /turf/open/floor/rogue/dirt))
		if(!(user.get_skill_level(/datum/skill/labor/farming) >= SKILL_LEVEL_JOURNEYMAN))
			to_chat(user, span_notice("I don't know enough to work without a tool."))
			return
		to_chat(user, span_notice("I begin making a mound for the seeds..."))
		if(do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
			apply_farming_fatigue(user, 30)
			soil = get_soil_on_turf(T)
			if(!soil)
				soil = new /obj/structure/soil(T)
		return
	. = ..()

/obj/item/seeds/proc/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant)
		to_chat(user, span_warning("There is already something planted in \the [soil]!"))
		return
	if(!plant_def_type)
		return
	to_chat(user, span_notice("I plant \the [src] in \the [soil]."))
	soil.insert_plant(GLOB.plant_defs[plant_def_type])
	qdel(src)

// Cook a seed, burninput is separate so that burning doesn't scale up with skills. Based on 'snacks.dm'
/obj/item/seeds/cooking(input as num, burninput, atom/A)
	if(!input)
		return
	if(cooktime)
		var/added_input = input
		if(cooking < cooktime)
			cooking = cooking + added_input
			if(cooking >= cooktime)
				return heating_act(A)
			return
	burning(burninput)

/obj/item/seeds/heating_act(atom/A)
	if(istype(A,/obj/machinery/light/rogue/oven))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_seed(result, 1)
		return result
	if(istype(A,/obj/machinery/light/rogue/hearth) || istype(A,/obj/machinery/light/rogue/firebowl) || istype(A,/obj/machinery/light/rogue/campfire) || istype(A,/obj/machinery/light/rogue/hearth/mobilestove))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_seed(result, 1)
		return result
	var/obj/item/result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
	initialize_cooked_seed(result, 1)
	return result

/obj/item/seeds/burning(input as num)
	if(!input)
		return
	if(burntime)
		burning = burning + input
		if(burning >= burntime)
			name = "burned [name]"
			color = burned_color
		if(burning > (burntime * 2))
			burn()

/obj/item/seeds/proc/initialize_cooked_seed(obj/item/seeds/S, cooking_efficiency = 1)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)

/obj/item/seeds/random
	name = "random seed"
	desc = "Haha, im in danger."

/obj/item/seeds/random/Initialize(mapload)
	var/type = pick(list(
	/obj/item/seeds/wheat,
	/obj/item/seeds/wheat/oat,
	/obj/item/seeds/rice,
	/obj/item/seeds/apple,
	/obj/item/seeds/pear,
	/obj/item/seeds/lemon,
	/obj/item/seeds/lime,
	/obj/item/seeds/tangerine,
	/obj/item/seeds/plum,
	/obj/item/seeds/strawberry,
	/obj/item/seeds/blackberry,
	/obj/item/seeds/raspberry,
	/obj/item/seeds/tomato,
	/obj/item/seeds/nut,
	/obj/item/seeds/sugarcane,
	/obj/item/seeds/pipeweed,
	/obj/item/seeds/swampweed,
	/obj/item/seeds/berryrogue,
	/obj/item/seeds/turnip,
	/obj/item/seeds/sunflower,
	/obj/item/seeds/onion,
	/obj/item/seeds/cabbage,
	/obj/item/seeds/potato,
	/obj/item/seeds/fyritius,
	/obj/item/seeds/poppy,
	/obj/item/seeds/garlick,
	/obj/item/seeds/coffee,
	/obj/item/seeds/tea,
	/obj/item/seeds/pumpkin,
	/obj/item/seeds/carrot,
	/obj/item/seeds/cucumber,
	/obj/item/seeds/eggplant,))

	var/obj/item/seeds/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL

/obj/item/seeds/wheat
	seed_identity = "wheat seeds"
	plant_def_type = /datum/plant_def/wheat

/obj/item/seeds/wheat/oat
	seed_identity = "oat seeds"
	plant_def_type = /datum/plant_def/oat

/obj/item/seeds/rice
	seed_identity = "rice seeds"
	plant_def_type = /datum/plant_def/rice

/obj/item/seeds/apple
	seed_identity = "apple seeds"
	plant_def_type = /datum/plant_def/tree/apple

/obj/item/seeds/pear
	seed_identity = "pear seeds"
	plant_def_type = /datum/plant_def/tree/pear

/obj/item/seeds/lemon
	seed_identity = "lemon seeds"
	plant_def_type = /datum/plant_def/tree/lemon

/obj/item/seeds/lime
	seed_identity = "lime seeds"
	plant_def_type = /datum/plant_def/tree/lime

/obj/item/seeds/tangerine
	seed_identity = "tangerine seeds"
	plant_def_type = /datum/plant_def/tree/tangerine

/obj/item/seeds/plum
	seed_identity = "plum seeds"
	plant_def_type = /datum/plant_def/tree/plum

/obj/item/seeds/strawberry
	seed_identity = "strawberry seeds"
	plant_def_type = /datum/plant_def/bush/strawberry

/obj/item/seeds/blackberry
	seed_identity = "blackberry seeds"
	plant_def_type = /datum/plant_def/bush/blackberry

/obj/item/seeds/raspberry
	seed_identity = "raspberry seeds"
	plant_def_type = /datum/plant_def/bush/raspberry

/obj/item/seeds/tomato
	seed_identity = "tomato seeds"
	plant_def_type = /datum/plant_def/bush/tomato

/obj/item/seeds/nut
	seed_identity = "rocknut seeds"
	plant_def_type = /datum/plant_def/nut

/obj/item/seeds/sugarcane
	seed_identity = "sugarcane seeds"
	plant_def_type = /datum/plant_def/sugarcane

/obj/item/seeds/pipeweed
	seed_identity = "westleach leaf seeds"
	plant_def_type = /datum/plant_def/pipeweed

/obj/item/seeds/swampweed
	seed_identity = "swampweed seeds"
	plant_def_type = /datum/plant_def/swampweed

/obj/item/seeds/berryrogue
	seed_identity = "berry seeds"
	plant_def_type = /datum/plant_def/bush/berry

/obj/item/seeds/berryrogue/poison
	seed_identity = "berry seeds"
	plant_def_type = /datum/plant_def/bush/berry_poison

/obj/item/seeds/turnip
	seed_identity = "turnip seeds"
	plant_def_type = /datum/plant_def/turnip

/obj/item/seeds/sunflower
	seed_identity = "sunflower seeds"
	plant_def_type = /datum/plant_def/sunflower
	cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds/sunflower

/obj/item/seeds/onion
	seed_identity = "onion seeds"
	plant_def_type = /datum/plant_def/onion

/obj/item/seeds/cabbage
	seed_identity = "cabbage seeds"
	plant_def_type = /datum/plant_def/cabbage

/obj/item/seeds/potato
	seed_identity = "potato seeds"
	plant_def_type = /datum/plant_def/potato

/obj/item/seeds/fyritius
	seed_identity = "fyritius seeds"
	plant_def_type = /datum/plant_def/fyritiusflower

/obj/item/seeds/poppy
	seed_identity = "poppy seeds"
	plant_def_type = /datum/plant_def/poppy

/obj/item/seeds/garlick
	seed_identity = "garlick seeds"
	plant_def_type = /datum/plant_def/garlick

/obj/item/seeds/coffee
	seed_identity = "coffee seeds"
	plant_def_type = /datum/plant_def/coffee

/obj/item/seeds/tea
	seed_identity = "tea seeds"
	plant_def_type = /datum/plant_def/tea

/obj/item/seeds/pumpkin
	seed_identity = "pumpkin seeds"
	plant_def_type = /datum/plant_def/pumpkin
	cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds/pumpkin

/obj/item/seeds/carrot
	seed_identity = "carrot seeds"
	plant_def_type = /datum/plant_def/carrot

/obj/item/seeds/cucumber
	seed_identity = "cucumber seeds"
	plant_def_type = /datum/plant_def/cucumber

/obj/item/seeds/eggplant
	seed_identity = "eggplant seeds"
	plant_def_type = /datum/plant_def/eggplant

// -- Tree sapling seeds (Dendor druid content) ----------------------------
// These bypass the soil plant_def system and directly grow /obj/structure/tree_sapling.
// Require journeyman farming skill to use.

/obj/item/seeds/treesap
	name = "tree sapling"
	desc = "A small, young tree. Plant it in prepared soil and keep it watered; a great tree may follow."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "palebush_2"
	seed_identity = "tree seeds"

/obj/item/seeds/treesap/attack_turf(turf/T, mob/living/user)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a tree sapling."))
		return
	if(locate(/obj/structure/tree_sapling) in T)
		to_chat(user, span_warning("There's already a sapling growing here."))
		return
	var/obj/structure/soil/existing_soil = locate(/obj/structure/soil) in T
	if(!existing_soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I need to plant this in soil, on dirt, or on grass."))
		return
	to_chat(user, span_notice("I begin preparing the ground for the tree sapling..."))
	if(!do_after(user, get_farming_do_time(user, 15 SECONDS), target = src))
		return
	apply_farming_fatigue(user, 40)
	// Re-check after delay
	if(locate(/obj/structure/tree_sapling) in T)
		return
	if(!locate(/obj/structure/soil) in T)
		if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
			return
		new /obj/structure/soil(T)
	plant_tree_sapling(T, user)

/obj/item/seeds/treesap/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a tree sapling."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	if(locate(/obj/structure/tree_sapling) in get_turf(soil))
		to_chat(user, span_warning("There's already a sapling growing here."))
		return
	plant_tree_sapling(get_turf(soil), user)

/obj/item/seeds/treesap/proc/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling(T)
	to_chat(user, span_notice("I carefully plant the tree sapling and pat the soil down."))
	qdel(src)

/obj/item/seeds/treesap/pine
	name = "pine sapling"
	desc = "A small, resinous sapling. Plant it in prepared soil and it may grow into a tall pine tree."
	icon_state = "palebush_3"
	seed_identity = "pine seeds"

/obj/item/seeds/treesap/pine/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling/pine(T)
	to_chat(user, span_notice("I carefully plant the pine sapling and pat the soil down."))
	qdel(src)

/obj/item/seeds/treesap/sakura
	name = "sakura sapling"
	desc = "A small, pink-tinged sapling. Incredibly rare, and originally from distant lands Tend it faithfully and a blooming cherry tree will reward your patience."
	icon_state = "palebush_1"
	seed_identity = "sakura seeds"

/obj/item/seeds/treesap/sakura/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling/sakura(T)
	to_chat(user, span_notice("I carefully plant the sakura sapling and pat the soil down."))
	qdel(src)

// -- Bush seeds (Dendor druid content) ------------------------------------
// Grows into a staged bush sapling that eventually becomes a harvestable bush,
// then a tall hedge if left unpruned. Requires journeyman farming to plant.

/obj/item/seeds/bush
	name = "bush seed"
	desc = "A hard, thorny seed. Plant in prepared soil and keep it watered to grow a wild bush."
	icon_state = "seed"
	seed_identity = "bush seeds"

/obj/item/seeds/bush/attack_turf(turf/T, mob/living/user)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a bush sapling."))
		return
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(locate(/obj/structure/bush_sapling) in T)
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	if(!soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I need to plant this in soil, on dirt, or on grass."))
		return
	to_chat(user, span_notice("I begin mounding up earth for the bush seed..."))
	if(!do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
		return
	apply_farming_fatigue(user, 25)
	// Re-check after delay
	if(locate(/obj/structure/bush_sapling) in T)
		return
	if(!soil)
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
				return
			soil = new /obj/structure/soil(T)
	new /obj/structure/bush_sapling(T)
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

/obj/item/seeds/bush/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I don't have the farming knowledge to tend a bush sapling."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	if(locate(/obj/structure/bush_sapling) in get_turf(soil))
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	new /obj/structure/bush_sapling(get_turf(soil))
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

// -- Flower seeds (Dendor druid content) ----------------------------------
// Select a flower type in-hand, then plant in dirt/grass/soil.
// Waters once → blooms into the chosen decorative flower bush after 5 minutes.
// No skill gate — purely decorative.

/obj/item/seeds/flower
	name = "flower seeds"
	desc = "A small packet of mixed flower seeds. Click in-hand to choose which flower to grow, then plant them in the earth and water."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	seed_identity = "flower seeds"
	var/flower_sprout_type = null
	var/flower_name = null

/obj/item/seeds/flower/attack_self(mob/living/user)
	var/list/options = list(
		"Yellow flowers"        = /obj/structure/flora/ausbushes/ywflowers,
		"Blue & red flowers"    = /obj/structure/flora/ausbushes/brflowers,
		"Purple & pink flowers" = /obj/structure/flora/ausbushes/ppflowers,
		"Lavender"              = /obj/structure/flora/ausbushes/lavendergrass
	)
	var/choice = input(user, "Which flower would you like to cultivate from these seeds?", "Choose Flower") as null|anything in options
	if(isnull(choice))
		return
	flower_sprout_type = options[choice]
	flower_name = choice
	name = "[LOWER_TEXT(choice)] seeds"
	to_chat(user, span_notice("I sort the seeds to cultivate [flower_name]."))

/obj/item/seeds/flower/attack_turf(turf/T, mob/living/user)
	if(!flower_sprout_type)
		to_chat(user, span_warning("I haven't chosen what to grow yet. Use them in your hand to choose first."))
		return
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(soil)
		try_plant_seed(user, soil)
		return
	if(!isopenturf(T))
		to_chat(user, span_warning("The ground here is not suitable for planting."))
		return
	if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I should plant these in dirt or grass."))
		return
	to_chat(user, span_notice("I scatter the seeds into the ground..."))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	soil = locate(/obj/structure/soil) in T
	if(!soil)
		soil = new /obj/structure/soil(T)
	try_plant_seed(user, soil)

/obj/item/seeds/flower/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(!flower_sprout_type)
		to_chat(user, span_warning("I haven't chosen what to grow yet. Use them in your hand to choose first."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("Something is already sprouting here."))
		return
	to_chat(user, span_notice("I plant the flower seeds in \the [soil]."))
	var/obj/structure/soil_seedling/flower/seedling = new(get_turf(soil))
	seedling.configure_seedling(soil, icon, icon_state, flower_sprout_type, 5 MINUTES)
	qdel(src)

// -- Conjured seed variants (granted by Conjure Floral Seed spell) ----------
// These subtypes vanish the moment they leave the caster's inventory.

/obj/item/seeds/bush/conjured
	name = "conjured bush seed"
	desc = "A bush seed called forth by the Treefather's will. It will vanish if dropped."

/obj/item/seeds/bush/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)

// Conjured bush seeds bypass the farming skill gate — the druid's blessing provides the knowledge.
/obj/item/seeds/bush/conjured/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(locate(/obj/structure/bush_sapling) in T)
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	if(!soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("I need to plant this in soil, on dirt, or on grass."))
		return
	to_chat(user, span_notice("I begin mounding up earth for the bush seed..."))
	if(!do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
		return
	// Re-check after delay
	if(locate(/obj/structure/bush_sapling) in T)
		return
	if(!soil)
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
				return
			soil = new /obj/structure/soil(T)
	new /obj/structure/bush_sapling(T)
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

/obj/item/seeds/bush/conjured/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	if(locate(/obj/structure/bush_sapling) in get_turf(soil))
		to_chat(user, span_warning("There's already a bush sapling growing here."))
		return
	new /obj/structure/bush_sapling(get_turf(soil))
	to_chat(user, span_notice("I plant the bush seed and pat down the earth."))
	qdel(src)

/obj/item/seeds/flower/conjured
	name = "conjured flower seeds"
	desc = "Flower seeds called forth by the Treefather's will. They will vanish if dropped. Use in-hand to choose which flower to cultivate."

/obj/item/seeds/flower/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)

// -- Mushroom Fey Circle Spores ---------------------------
// Can only be planted in BLESSED soil. Seeds a mushroom sprout that blooms
// into a full fey teleport circle after 5 minutes of growing.
// Obtained as a reward from Sanctified Tree category 3 ritual.

/obj/item/seeds/mushroom_fey
	name = "fey mushroom spore"
	desc = "A cluster of tiny pale spores that hum with strange, wild energy. They can only take root in blessed soil."
	icon_state = "seed"
	color = "#FFFFFF"
	seed_identity = "mushroom fey spores"

/obj/item/seeds/mushroom_fey/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(!soil)
		if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
			to_chat(user, span_warning("I need to plant these in a prepared soil plot."))
			return
		to_chat(user, span_notice("I begin loosening the earth for the spores..."))
		if(!do_after(user, 5 SECONDS, target = src))
			return
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			soil = new /obj/structure/soil(T)
	if(soil.blessed_time <= 0)
		to_chat(user, span_warning("The soil must be blessed for these spores to take root."))
		return
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		to_chat(user, span_warning("Something is already growing here."))
		return
	to_chat(user, span_notice("I carefully press the spores into the blessed soil..."))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(QDELETED(soil) || soil.blessed_time <= 0)
		to_chat(user, span_warning("The soil's blessing faded before I could finish planting."))
		return
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		return
	new /obj/structure/mushroom_sprout(T)
	to_chat(user, span_notice("I plant the fey mushroom spores."))
	qdel(src)

/obj/item/seeds/mushroom_fey/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.blessed_time <= 0)
		to_chat(user, span_warning("The soil must be blessed for these spores to take root."))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("There is already something growing in \the [soil]!"))
		return
	var/turf/T = get_turf(soil)
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		to_chat(user, span_warning("Something is already growing here."))
		return
	to_chat(user, span_notice("I carefully press the spores into the blessed soil..."))
	new /obj/structure/mushroom_sprout(T)
	qdel(src)
