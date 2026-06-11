/obj/structure/fluff/ceramicswheel
	name = "陶轮"
	desc = "一座供熟练工匠塑形与成型黏土用的旋转工作台。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "potwheel"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 150
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	var/obj/item/natural/clay/loaded_clay
	var/datum/pottery_wheel_recipe/selected_recipe
	var/spin_progress = 0
	var/spins_required = 3
	var/needs_rewet = FALSE

/obj/structure/fluff/ceramicswheel/proc/reset_shaping_progress()
	if(selected_recipe)
		qdel(selected_recipe)
	selected_recipe = null
	spin_progress = 0
	needs_rewet = FALSE

/obj/structure/fluff/ceramicswheel/proc/get_required_rewet_count()
	if(istype(loaded_clay, /obj/item/natural/clay/refined))
		return 2
	return 1

/obj/structure/fluff/ceramicswheel/update_overlays()
	. = ..()
	if(loaded_clay)
		var/mutable_appearance/clay_overlay = mutable_appearance(loaded_clay.icon, loaded_clay.icon_state)
		clay_overlay.transform *= 0.8
		clay_overlay.pixel_y = 2
		clay_overlay.layer = layer + 0.1
		. += clay_overlay

/obj/structure/fluff/ceramicswheel/attackby(obj/item/W, mob/living/user, params)
	if(loaded_clay && istype(W, /obj/item/reagent_containers))
		if(!selected_recipe || !needs_rewet)
			to_chat(user, span_warning("这团黏土暂时还不需要加更多水。"))
			return
		var/obj/item/reagent_containers/container = W
		if(loaded_clay.consume_wetting_water(container))
			to_chat(user, span_notice("我把轮上的黏土润湿了。"))
			playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 80, TRUE, -1)
			needs_rewet = FALSE
		else
			to_chat(user, span_warning("还需要更多水，才能继续塑形。"))
		return

	if(istype(W, /obj/item/natural/clay))
		if(loaded_clay)
			to_chat(user, span_warning("轮上已经有黏土了。"))
			return
		if(W.type == /obj/item/natural/clay)
			to_chat(user, span_warning("这东西太粗糙，不能直接上轮。我得先准备揉制黏土。"))
			return
		if(!istype(W, /obj/item/natural/clay/kneaded) && !istype(W, /obj/item/natural/clay/refined))
			to_chat(user, span_warning("只有揉制黏土或精炼黏土才能在轮上加工。"))
			return
		if(!user.transferItemToLoc(W, src))
			to_chat(user, span_warning("[W]粘在我手上了。"))
			return
		loaded_clay = W
		reset_shaping_progress()
		to_chat(user, span_notice("我把[W]放到了陶轮上。"))
		update_icon()
		return

/obj/structure/fluff/ceramicswheel/attack_hand(mob/living/user)
	if(loaded_clay)
		if(selected_recipe)
			to_chat(user, span_warning("我正在塑形，不能在这时候把黏土取下来！"))
			return
		var/obj/item/natural/clay/removed = loaded_clay
		loaded_clay = null
		reset_shaping_progress()
		removed.forceMove(get_turf(src))
		user.put_in_hands(removed)
		to_chat(user, span_notice("我把[removed]从陶轮上取了下来。"))
		update_icon()
		return

/obj/structure/fluff/ceramicswheel/proc/calculate_pottery_quality(skill_level)
	// Quality tiers: 0=Crude, 1=Rough, 2=Competent(regular), 3=Fine, 4=Flawless, 5=Masterwork
	// Gating: regular only from Apprentice, fine from Journeyman, masterwork from Master
	var/roll = rand(1, 100)
	switch(skill_level)
		if(SKILL_LEVEL_NONE)
			return 0
		if(SKILL_LEVEL_NOVICE)
			return roll <= 25 ? 1 : 0
		if(SKILL_LEVEL_APPRENTICE)
			// Below journeyman — skewed heavily towards poor quality
			if(roll <= 10) return 2
			if(roll <= 50) return 1
			return 0
		if(SKILL_LEVEL_JOURNEYMAN)
			// Still learning — higher chance of poor quality than expected
			if(roll <= 10) return 3
			if(roll <= 35) return 2
			if(roll <= 65) return 1
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
	// SKILL_LEVEL_LEGENDARY (and any above)
	if(roll <= 40) return 5
	if(roll <= 70) return 4
	if(roll <= 90) return 3
	return 2

/obj/structure/fluff/ceramicswheel/attack_right(mob/living/user)
	if(user.get_active_held_item())
		return ..()
	if(!loaded_clay)
		to_chat(user, span_warning("我得先把黏土放到陶轮上。"))
		return
	if(needs_rewet)
		to_chat(user, span_warning("黏土正在变干。我得先加点水，再继续转。"))
		return

	if(!selected_recipe)
		var/list/recipe_map = list()
		var/list/generated_recipes = list()
		var/list/radial_choices = list()
		for(var/path in subtypesof(/datum/pottery_wheel_recipe))
			if(is_abstract(path))
				continue
			var/datum/pottery_wheel_recipe/R = new path
			generated_recipes += R
			if(!R.valid_for_clay(loaded_clay))
				continue
			var/choice_label = "[R.name] ([SSskills.level_names_plain[R.craftdiff]])"
			recipe_map[choice_label] = R
			var/atom/result_preview = initial(R.result_type)
			var/preview_icon = R.recipe_icon || initial(result_preview.icon)
			var/preview_icon_state = R.recipe_icon_state || initial(result_preview.icon_state)
			radial_choices[choice_label] = image(icon = preview_icon, icon_state = preview_icon_state)

		if(!recipe_map.len)
			to_chat(user, span_warning("这团黏土没法塑造成什么有用的东西。"))
			for(var/datum/pottery_wheel_recipe/R_cleanup0 in generated_recipes)
				qdel(R_cleanup0)
			return

		var/choice = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
		if(!choice)
			for(var/datum/pottery_wheel_recipe/R_cleanup in generated_recipes)
				qdel(R_cleanup)
			return

		selected_recipe = recipe_map[choice]
		if(!selected_recipe)
			for(var/datum/pottery_wheel_recipe/R_cleanup2 in generated_recipes)
				qdel(R_cleanup2)
			return

		for(var/datum/pottery_wheel_recipe/R_cleanup_keep in generated_recipes)
			if(R_cleanup_keep != selected_recipe)
				qdel(R_cleanup_keep)

	if(!selected_recipe.valid_for_clay(loaded_clay))
		to_chat(user, span_warning("这团黏土已经不适合当前选择的造型了。"))
		reset_shaping_progress()
		return

	var/skill_level = user.get_skill_level(/datum/skill/craft/ceramics)
	if(skill_level < selected_recipe.craftdiff)
		to_chat(user, span_warning("这需要我具备 [SSskills.level_names_plain[selected_recipe.craftdiff]] 级陶艺技能。"))
		reset_shaping_progress()
		return

	// Use recipe's spins_required to determine total spins needed
	var/total_spins = selected_recipe.spins_required
	// Journeyman (skill 3) is the baseline speed; lower skills take longer, higher are faster
	var/base_per_spin = max(1, round(selected_recipe.base_time / total_spins))
	var/time_to_spin = max(6, base_per_spin + (SKILL_LEVEL_JOURNEYMAN - skill_level) * 4)
	to_chat(user, span_notice("我转动陶轮，塑造[loaded_clay]（[spin_progress + 1]/[total_spins]）……"))
	playsound(src, 'sound/foley/grindblade.ogg', 80, FALSE)
	if(!do_after(user, time_to_spin, target = src))
		return
	if(!loaded_clay || !selected_recipe || !selected_recipe.valid_for_clay(loaded_clay))
		to_chat(user, span_warning("这团黏土已经不再适合继续加工了。"))
		reset_shaping_progress()
		return

	// Up to expert, potters can still collapse the clay while spinning
	if(skill_level <= SKILL_LEVEL_EXPERT)
		var/ruin_chance = 0
		switch(skill_level)
			if(SKILL_LEVEL_NONE)
				ruin_chance = 50
			if(SKILL_LEVEL_NOVICE)
				ruin_chance = 30
			if(SKILL_LEVEL_APPRENTICE)
				ruin_chance = 20
			if(SKILL_LEVEL_JOURNEYMAN)
				ruin_chance = 10
			if(SKILL_LEVEL_EXPERT)
				ruin_chance = 5
		if(prob(ruin_chance))
			user.visible_message(span_warning("[user]失去了对轮上黏土的控制，它塌掉了！"), span_warning("我失去了对旋转中黏土的控制，它塌坏了！"))
			playsound(src, 'modular/Neu_Food/sound/kneading.ogg', 80, TRUE)
			qdel(loaded_clay)
			loaded_clay = null
			reset_shaping_progress()
			update_icon()
			if(user.mind)
				user.mind.add_sleep_experience(/datum/skill/craft/ceramics, 2, FALSE)
			return

	spin_progress++
	var/required_rewets = get_required_rewet_count()
	if(spin_progress <= required_rewets)
		needs_rewet = TRUE
		to_chat(user, span_notice("这团黏土还需要更多水，我才能继续（[spin_progress]/[selected_recipe.spins_required]）。"))
		return

	var/turf/drop_turf = get_turf(src)
	for(var/spawn_i in 1 to selected_recipe.result_count)
		var/obj/item/I = new selected_recipe.result_type(drop_turf)
		if(istype(I, /obj/item/natural/clay))
			var/obj/item/natural/clay/clay_item = I
			clay_item.creator_skill = skill_level
			clay_item.pottery_quality = calculate_pottery_quality(skill_level)
	user.visible_message(span_notice("[user]把[loaded_clay]塑形成了[selected_recipe.name]。"), span_notice("我把[loaded_clay]塑形成了[selected_recipe.name]。"))
	var/final_craftdiff = selected_recipe.craftdiff
	qdel(loaded_clay)
	loaded_clay = null
	reset_shaping_progress()
	update_icon()

	if(user.mind)
		var/exp_gain = max(2, user.STAINT)
		if(final_craftdiff > 0)
			exp_gain += final_craftdiff * 4
		user.mind.add_sleep_experience(/datum/skill/craft/ceramics, exp_gain, FALSE)


/datum/pottery_wheel_recipe
	abstract_type = /datum/pottery_wheel_recipe
	var/name = "轮制配方"
	var/craftdiff = SKILL_LEVEL_NOVICE
	var/base_time = 40
	var/result_type = /obj/item/natural/clay
	var/required_clay_type = /obj/item/natural/clay
	var/result_count = 1
	var/recipe_icon = null
	var/recipe_icon_state = null
	var/spins_required = 3  // Override for specific recipes if needed

/datum/pottery_wheel_recipe/proc/valid_for_clay(obj/item/natural/clay/C)
	return C && istype(C, required_clay_type)

/datum/pottery_wheel_recipe/basic
	abstract_type = /datum/pottery_wheel_recipe/basic
	required_clay_type = /obj/item/natural/clay/kneaded
	spins_required = 2  // Basic kneaded clay only needs 1 rewet, so 2 total spins

/datum/pottery_wheel_recipe/basic/brick
	name = "黏土砖 x2"
	craftdiff = 0
	base_time = 30
	result_type = /obj/item/natural/clay/claybrick
	result_count = 2
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/cup
	name = "陶罐"
	craftdiff = 0
	base_time = 30
	result_type = /obj/item/natural/clay/claycup
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/bottle
	name = "陶瓶"
	craftdiff = 0
	base_time = 35
	result_type = /obj/item/natural/clay/claybottle
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/vase
	name = "陶花瓶"
	craftdiff = 0
	base_time = 40
	result_type = /obj/item/natural/clay/clayvase
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/fancy_vase
	name = "华饰陶花瓶"
	craftdiff = 0
	base_time = 45
	result_type = /obj/item/natural/clay/clayfancyvase
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/teapot
	name = "茶壶"
	craftdiff = 0
	base_time = 45
	result_type = /obj/item/natural/clay/rawteapot
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/teacup
	name = "茶杯"
	craftdiff = 0
	base_time = 35
	result_type = /obj/item/natural/clay/rawteacup
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/statue_1
	name = "陶像（款式 I）"
	craftdiff = 0
	base_time = 55
	result_type = /obj/item/natural/clay/claystatue/design1
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "claystatueraw"
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/statue_2
	name = "陶像（款式 II）"
	craftdiff = 0
	base_time = 55
	result_type = /obj/item/natural/clay/claystatue/design2
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "claystatueraw2"
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/statue_3
	name = "陶像（款式 III）"
	craftdiff = 0
	base_time = 55
	result_type = /obj/item/natural/clay/claystatue/design3
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "claystatueraw3"
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/statue_4
	name = "陶像（款式 IV）"
	craftdiff = 0
	base_time = 55
	result_type = /obj/item/natural/clay/claystatue/design4
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "claystatueraw4"
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/basic/statue_5
	name = "陶像（款式 V）"
	craftdiff = 0
	base_time = 55
	result_type = /obj/item/natural/clay/claystatue/design5
	recipe_icon = 'icons/roguetown/items/cooking.dmi'
	recipe_icon_state = "claystatueraw5"
	required_clay_type = /obj/item/natural/clay/kneaded

/datum/pottery_wheel_recipe/porcelain
	abstract_type = /datum/pottery_wheel_recipe/porcelain
	required_clay_type = /obj/item/natural/clay/refined
	craftdiff = 0
	base_time = 50

/datum/pottery_wheel_recipe/porcelain/cameo
	name = "瓷浮雕"
	result_type = /obj/item/natural/clay/porcelain/cameo

/datum/pottery_wheel_recipe/porcelain/figurine
	name = "瓷雕小像"
	result_type = /obj/item/natural/clay/porcelain/figurine

/datum/pottery_wheel_recipe/porcelain/fish
	name = "瓷鱼摆件"
	result_type = /obj/item/natural/clay/porcelain/fish

/datum/pottery_wheel_recipe/porcelain/tablet
	name = "瓷板"
	result_type = /obj/item/natural/clay/porcelain/tablet

/datum/pottery_wheel_recipe/porcelain/vase
	name = "瓷花瓶"
	result_type = /obj/item/natural/clay/porcelain/vase

/datum/pottery_wheel_recipe/porcelain/fork
	name = "瓷叉"
	result_type = /obj/item/natural/clay/porcelain/fork

/datum/pottery_wheel_recipe/porcelain/spoon
	name = "瓷勺"
	result_type = /obj/item/natural/clay/porcelain/spoon

/datum/pottery_wheel_recipe/porcelain/bowl
	name = "瓷碗"
	result_type = /obj/item/natural/clay/porcelain/bowl

/datum/pottery_wheel_recipe/porcelain/cup
	name = "瓷茶杯"
	result_type = /obj/item/natural/clay/porcelain/cup

/datum/pottery_wheel_recipe/porcelain/platter
	name = "瓷盘"
	result_type = /obj/item/natural/clay/porcelain/platter

/datum/pottery_wheel_recipe/porcelain/teapot
	name = "瓷茶壶"
	result_type = /obj/item/natural/clay/porcelain/teapot

/datum/pottery_wheel_recipe/porcelain/fancy_teapot
	name = "华饰瓷茶壶"
	result_type = /obj/item/natural/clay/porcelain/fancyteapot

/datum/pottery_wheel_recipe/porcelain/advanced
	abstract_type = /datum/pottery_wheel_recipe/porcelain/advanced
	craftdiff = 0
	base_time = 60

/datum/pottery_wheel_recipe/porcelain/advanced/bust
	name = "瓷半身像"
	result_type = /obj/item/natural/clay/porcelain/bust

/datum/pottery_wheel_recipe/porcelain/advanced/fancy_vase
	name = "华饰瓷花瓶"
	result_type = /obj/item/natural/clay/porcelain/fancyvase

/datum/pottery_wheel_recipe/porcelain/advanced/comb
	name = "瓷梳"
	result_type = /obj/item/natural/clay/porcelain/comb

/datum/pottery_wheel_recipe/porcelain/advanced/duck
	name = "瓷鸭摆件"
	result_type = /obj/item/natural/clay/porcelain/duck

/datum/pottery_wheel_recipe/porcelain/advanced/fancy_cup
	name = "华饰瓷杯"
	result_type = /obj/item/natural/clay/porcelain/fancycup

/datum/pottery_wheel_recipe/porcelain/advanced/fancy_teacup
	name = "华饰瓷茶杯"
	result_type = /obj/item/natural/clay/porcelain/fancyteacup

/datum/pottery_wheel_recipe/porcelain/advanced/mask
	name = "瓷面具"
	result_type = /obj/item/natural/clay/porcelain/mask

/datum/pottery_wheel_recipe/porcelain/advanced/urn
	name = "瓷骨灰瓮"
	result_type = /obj/item/natural/clay/porcelain/urn

/datum/pottery_wheel_recipe/porcelain/advanced/statue
	name = "瓷雕像"
	result_type = /obj/item/natural/clay/porcelain/statue

/datum/pottery_wheel_recipe/porcelain/advanced/obelisk
	name = "瓷方尖碑"
	result_type = /obj/item/natural/clay/porcelain/obelisk

/datum/pottery_wheel_recipe/porcelain/advanced/turtle
	name = "瓷海龟雕饰"
	result_type = /obj/item/natural/clay/porcelain/turtle

/datum/pottery_wheel_recipe/porcelain/advanced/bauble
	name = "瓷饰球"
	result_type = /obj/item/natural/clay/porcelain/bauble

/datum/pottery_wheel_recipe/porcelain/advanced/rungu
	name = "瓷 rungu"
	result_type = /obj/item/natural/clay/porcelain/rungu
