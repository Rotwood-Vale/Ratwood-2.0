
//Not clay but part of pottery/glassblowing.
/obj/item/rogueweapon/blowrod
	force = 10
	possible_item_intents = list(/datum/intent/mace/strike)
	name = "blowing rod"
	desc = "A blowing rod for shaping glass."
	icon_state = "blowJobRod" // sorry not sorry
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_SHORT
	slot_flags = ITEM_SLOT_HIP
	associated_skill = null
	smeltresult = /obj/item/ingot/iron
	var/obj/item/natural/glass/heated/loaded_glass

/obj/item/rogueweapon/blowrod/update_icon()
	. = ..()
	icon_state = loaded_glass ? "blowJobRodFull" : initial(icon_state)

/obj/item/rogueweapon/blowrod/proc/attach_heated_glass(obj/item/natural/glass/heated/G, mob/living/user)
	if(!G)
		return FALSE
	if(loaded_glass)
		to_chat(user, span_warning("There is already heated glass on the blowing rod."))
		return FALSE
	if(!user.transferItemToLoc(G, src) && G.loc != src)
		G.forceMove(src)
	loaded_glass = G
	update_icon()
	to_chat(user, span_notice("I attach [G] to the blowing rod."))
	return TRUE

/obj/item/rogueweapon/blowrod/proc/detach_heated_glass(mob/living/user)
	if(!loaded_glass)
		return FALSE
	var/obj/item/natural/glass/heated/G = loaded_glass
	loaded_glass = null
	update_icon()
	G.forceMove(get_turf(user))
	if(user)
		user.put_in_hands(G)
		to_chat(user, span_notice("I remove [G] from the blowing rod."))
	return TRUE

/obj/item/rogueweapon/blowrod/attack_self(mob/living/user)
	// Using the rod in hand opens the crafting menu (if glass is attached)
	if(loaded_glass)
		attack_right(user)
		return
	return ..()

/obj/item/rogueweapon/blowrod/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = I
		// If tongs are holding heated glass, attach it to the rod
		if(istype(T.hingot, /obj/item/natural/glass/heated))
			var/obj/item/natural/glass/heated/G = T.hingot
			if(attach_heated_glass(G, user))
				T.hingot = null
				T.hott = FALSE
				T.update_icon()
			return TRUE
		// If tongs are empty and rod has glass, detach it
		else if(!T.hingot && loaded_glass)
			var/obj/item/natural/glass/heated/G_detach = loaded_glass
			loaded_glass = null
			update_icon()
			G_detach.forceMove(T)
			T.hingot = G_detach
			T.hott = world.time
			addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), T.hott), 10 SECONDS)
			T.update_icon()
			to_chat(user, span_notice("I remove [G_detach] from the blowing rod with the tongs."))
			return TRUE
		else
			to_chat(user, span_warning("The tongs are not holding heated glass or rod is empty."))
			return TRUE
	return ..()

/obj/item/rogueweapon/blowrod/proc/calculate_glass_quality(skill_level)
	var/roll = rand(1, 100)
	switch(skill_level)
		if(SKILL_LEVEL_NONE)
			return 0
		if(SKILL_LEVEL_NOVICE)
			return roll <= 25 ? 1 : 0
		if(SKILL_LEVEL_APPRENTICE)
			if(roll <= 20) return 2
			if(roll <= 65) return 1
			return 0
		if(SKILL_LEVEL_JOURNEYMAN)
			if(roll <= 15) return 3
			if(roll <= 55) return 2
			if(roll <= 80) return 1
			return 0
		if(SKILL_LEVEL_EXPERT)
			if(roll <= 15) return 4
			if(roll <= 50) return 3
			if(roll <= 80) return 2
			if(roll <= 95) return 1
			return 0
		if(SKILL_LEVEL_MASTER)
			if(roll <= 20) return 5
			if(roll <= 50) return 4
			if(roll <= 80) return 3
			if(roll <= 95) return 2
			return 1
	if(roll <= 40) return 5
	if(roll <= 70) return 4
	if(roll <= 90) return 3
	return 2

/obj/item/rogueweapon/blowrod/proc/apply_glass_quality(obj/item/result, quality_tier, creator_skill_level)
	if(!result)
		return

	var/quality_prefix = ""
	var/quality_multiplier = 1.0

	switch(quality_tier)
		if(0)
			quality_prefix = "crude "
			quality_multiplier = 0.4
		if(1)
			quality_prefix = "poor "
			quality_multiplier = 0.6
		if(2)
			quality_multiplier = 0.8
		if(3)
			quality_prefix = "fine "
			quality_multiplier = 1.1
		if(4)
			quality_prefix = "flawless "
			quality_multiplier = 1.2
		if(5)
			quality_prefix = "masterwork "
			quality_multiplier = 1.5

	if(quality_prefix)
		result.name = quality_prefix + initial(result.name)

	if(result.sellprice)
		result.sellprice = round(result.sellprice * quality_multiplier)

	if(quality_tier >= 4)
		result.polished = 4
		if(!result.GetComponent(/datum/component/metal_glint))
			result.AddComponent(/datum/component/metal_glint)

	result.pottery_quality = quality_tier
	result.creator_skill = creator_skill_level

/obj/item/rogueweapon/blowrod/attack_right(mob/living/user)
	if(!user)
		return ..()

	var/obj/item/natural/glass/heated/G = loaded_glass
	if(!G)
		to_chat(user, span_warning("I need to attach heated glass to the blowing rod first."))
		return

	if(!G.selected_recipe)
		var/list/recipe_map = list()
		var/list/generated_recipes = list()
		var/list/radial_choices = list()

		for(var/path in subtypesof(/datum/glass_blow_recipe))
			if(is_abstract(path))
				continue
			var/datum/glass_blow_recipe/R = new path
			generated_recipes += R
			var/choice_label = "[R.name] ([SSskills.level_names_plain[R.craftdiff]])"
			recipe_map[choice_label] = R
			radial_choices[choice_label] = image(icon = R.recipe_icon, icon_state = R.recipe_icon_state)

		if(!recipe_map.len)
			for(var/datum/glass_blow_recipe/R_cleanup0 in generated_recipes)
				qdel(R_cleanup0)
			to_chat(user, span_warning("I can't shape this into anything useful."))
			return

		var/choice = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
		if(!choice)
			for(var/datum/glass_blow_recipe/R_cleanup1 in generated_recipes)
				qdel(R_cleanup1)
			return

		G.selected_recipe = recipe_map[choice]
		if(!G.selected_recipe)
			for(var/datum/glass_blow_recipe/R_cleanup2 in generated_recipes)
				qdel(R_cleanup2)
			return

		for(var/datum/glass_blow_recipe/R_cleanup_keep in generated_recipes)
			if(R_cleanup_keep != G.selected_recipe)
				qdel(R_cleanup_keep)

	var/skill_level = user.get_skill_level(/datum/skill/craft/ceramics)
	if(skill_level < G.selected_recipe.craftdiff)
		to_chat(user, span_warning("I need [SSskills.level_names_plain[G.selected_recipe.craftdiff]] pottery skill for this glasswork."))
		QDEL_NULL(G.selected_recipe)
		G.blow_progress = 0
		return

	// Glassblowing is twice as slow as pottery wheel spinning - same skill scaling formula, but doubled
	var/base_per_blow = max(1, round(G.selected_recipe.base_time / G.blows_required))
	var/time_to_blow = max(12, 2 * (base_per_blow + (SKILL_LEVEL_JOURNEYMAN - skill_level) * 4))
	to_chat(user, span_notice("I blow and shape the heated glass ([G.blow_progress + 1]/[G.blows_required])..."))
	playsound(src, "bubbles", 65, FALSE)
	if(!do_after(user, time_to_blow, target = src))
		return

	if(loaded_glass != G)
		to_chat(user, span_warning("I lose control of the glasswork."))
		return

	// Glassblowing has twice the failure chance of pottery wheel
	if(skill_level <= SKILL_LEVEL_EXPERT)
		var/failure_chance = 0
		switch(skill_level)
			if(SKILL_LEVEL_NONE)
				failure_chance = 90
			if(SKILL_LEVEL_NOVICE)
				failure_chance = 50
			if(SKILL_LEVEL_APPRENTICE)
				failure_chance = 40
			if(SKILL_LEVEL_JOURNEYMAN)
				failure_chance = 30
			if(SKILL_LEVEL_EXPERT)
				failure_chance = 20
		if(prob(failure_chance))
			user.visible_message(span_warning("[user] loses control of the glass — it cracks and shatters!"), span_warning("I lose control of the molten glass — it cracks and shatters!"))
			playsound(src, 'sound/foley/glassbreak.ogg', 75, TRUE)
			loaded_glass = null
			update_icon()
			qdel(G)
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
			return

	G.blow_progress++
	if(G.blow_progress < G.blows_required)
		to_chat(user, span_notice("The glass form is taking shape."))
		return

	var/final_craftdiff = G.selected_recipe.craftdiff
	var/final_recipe_name = G.selected_recipe.name
	var/turf/drop_turf = get_turf(user)
	var/glass_quality_tier = calculate_glass_quality(skill_level)
	for(var/i in 1 to G.selected_recipe.result_count)
		var/obj/item/result = new G.selected_recipe.result_type(drop_turf)
		apply_glass_quality(result, glass_quality_tier, skill_level)
	user.visible_message(span_notice("[user] finishes shaping molten glass into [final_recipe_name]."), span_notice("I finish shaping the glass into [final_recipe_name]."))

	loaded_glass = null
	update_icon()
	QDEL_NULL(G.selected_recipe)
	qdel(G)

	if(user.mind)
		var/exp_gain = max(2, user.STAINT)
		if(final_craftdiff > 0)
			exp_gain += final_craftdiff * 4
		user.mind.add_sleep_experience(/datum/skill/craft/ceramics, exp_gain, FALSE)


/datum/glass_blow_recipe
	abstract_type = /datum/glass_blow_recipe
	var/name = "glass shape"
	var/craftdiff = SKILL_LEVEL_NONE
	var/base_time = 40
	var/result_type = /obj/item/natural/glass
	var/result_count = 1
	var/recipe_icon = 'icons/roguetown/items/cooking.dmi'
	var/recipe_icon_state = "glassBatch"

/datum/glass_blow_recipe/statue_1
	name = "glass statue (style I)"
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	base_time = 42
	result_type = /obj/item/roguestatue/glass/design1
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "statueglass1"

/datum/glass_blow_recipe/statue_2
	name = "glass statue (style II)"
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	base_time = 42
	result_type = /obj/item/roguestatue/glass/design2
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "statueglass2"

/datum/glass_blow_recipe/statue_3
	name = "glass statue (style III)"
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	base_time = 42
	result_type = /obj/item/roguestatue/glass/design3
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "statueglass3"

/datum/glass_blow_recipe/statue_4
	name = "glass statue (style IV)"
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	base_time = 42
	result_type = /obj/item/roguestatue/glass/design4
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "statueglass4"

/datum/glass_blow_recipe/statue_5
	name = "glass statue (style V)"
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	base_time = 42
	result_type = /obj/item/roguestatue/glass/design5
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "statueglass5"

/datum/glass_blow_recipe/pane
	name = "glass pane"
	craftdiff = SKILL_LEVEL_NOVICE
	base_time = 20
	result_type = /obj/item/natural/glass
	recipe_icon = 'icons/roguetown/items/crafting.dmi'
	recipe_icon_state = "glasspane"

/datum/glass_blow_recipe/bottle
	name = "glass bottle"
	craftdiff = SKILL_LEVEL_NOVICE
	base_time = 28
	result_type = /obj/item/reagent_containers/glass/bottle/blown
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "clear_bottle1"

/datum/glass_blow_recipe/alch_vial
	name = "alchemical vial"
	craftdiff = SKILL_LEVEL_NOVICE
	base_time = 24
	result_type = /obj/item/reagent_containers/glass/bottle/alchemical/blown
	result_count = 2
	recipe_icon = 'icons/roguetown/misc/alchemy.dmi'
	recipe_icon_state = "vial_bottle"

