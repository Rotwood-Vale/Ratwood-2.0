// Fey Mushroom Circle
//
// GROWTH CHAIN (fey circles only — base mushroom_circle is a plain map decoration):
//   /obj/item/seeds/mushroom_fey  →  planted in blessed soil, watered once
//   /obj/structure/mushroom_sprout (5 min)
//   /obj/structure/mushroom_circle/fey (active portal, tinymushrooms sprite)
//      ↓ 20 min without scissors maintenance
//   mushroomcluster sprite (unusable)
//      ↓ 10 more min
//   /obj/structure/flora/rogueshroom  (random mush1-5, final dead state)
//
// Teleportation (fey only):
//   Hold Dendor amulet → click circle → choose destination → 3 sec cast
//   You must stand inside the circle, and every living being standing in it travels together.
//
// Renaming (fey only):
//   Click with /obj/item/natural/feather (name only, no description editing).

GLOBAL_LIST_EMPTY(mushroom_circles)

//==============================================================================
// Mushroom Fey Sprout
//==============================================================================

/obj/structure/mushroom_sprout
	name = "妖精蘑菇幼芽"
	desc = "一簇细小苍白的幼芽，隐隐流动着妖精能量。给它浇水，它应该就会绽放。"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	max_integrity = 5
	resistance_flags = FLAMMABLE
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "fyritius0"
	layer = OBJ_LAYER

	var/obj/structure/soil/linked_soil
	var/growth_progress = 0
	var/has_grown = FALSE   // prevents death before first watering
	var/soil_water_drain = 1.0 / (1 MINUTES)
	var/soil_nutrition_drain = 0.75 / (1 MINUTES)

/obj/structure/mushroom_sprout/Initialize(mapload)
	. = ..()
	linked_soil = locate(/obj/structure/soil) in get_turf(src)
	START_PROCESSING(SSprocessing, src)

/obj/structure/mushroom_sprout/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/mushroom_sprout/process(dt)
	if(!linked_soil || QDELETED(linked_soil))
		qdel(src)
		return
	if(linked_soil.blessed_time > 0 && linked_soil.water > 0 && linked_soil.nutrition > 0)
		linked_soil.adjust_water(-dt * soil_water_drain)
		linked_soil.adjust_nutrition(-dt * soil_nutrition_drain)
		growth_progress += dt * linked_soil.get_environmental_growth_multiplier()
		has_grown = TRUE
	else if(has_grown)
		growth_progress -= dt * 2
		if(growth_progress <= -60)
			visible_message(span_warning("[src]重新枯萎回了圣土中。"))
			qdel(src)
			return
	if(growth_progress >= 10 MINUTES)
		bloom()

/obj/structure/mushroom_sprout/examine(mob/user)
	. = ..()
	var/time_to_bloom = max((10 MINUTES) - growth_progress, 0)
	. += span_info("若悉心照料，它大约会在[DisplayTimeText(time_to_bloom)]后长成一圈妖精蘑菇。")
	if(linked_soil)
		if(linked_soil.blessed_time <= 0)
			. += span_warning("土壤中的祝福正在消退；若失去它，幼芽将难以存活。")
		if(linked_soil.water <= 45)
			. += span_warning("它下方的土壤很干渴。")
		else if(linked_soil.water <= 150)
			. += span_info("它下方的土壤很湿润。")
		else
			. += span_info("它下方的土壤很潮湿。")
		if(linked_soil.nutrition <= 45)
			. += span_warning("它下方的土壤很贫瘠。")
		else if(linked_soil.nutrition <= 150)
			. += span_info("它下方的土壤还算充足。")
		else
			. += span_info("它下方的土壤看起来很肥沃。")

/obj/structure/mushroom_sprout/attackby(obj/item/I, mob/living/user, params)
	if(linked_soil)
		if(linked_soil.try_handle_watering(I, user, params))
			return
		if(linked_soil.try_handle_fertilizing(I, user, params))
			return
	if(istype(I, /obj/item/rogueweapon/shovel))
		to_chat(user, span_notice("我开始铲除[src]……"))
		if(do_after(user, 2 SECONDS, target = src))
			qdel(src)
		return
	return ..()

/obj/structure/mushroom_sprout/proc/bloom()
	if(QDELETED(src))
		return
	if(linked_soil && !QDELETED(linked_soil))
		qdel(linked_soil)
	new /obj/structure/mushroom_circle/fey(get_turf(src))
	qdel(src)

/obj/structure/mushroom_circle
	name = "蘑菇环"
	desc = "一圈淡白与紫色的蘑菇，恰好长成完美圆环。"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	obj_flags = CAN_BE_HIT
	max_integrity = 50
	resistance_flags = FLAMMABLE
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "tinymushrooms"
	layer = OBJ_LAYER

//==============================================================================
// Fey Mushroom Circle — player-grown, teleport-capable subtype
//==============================================================================
/obj/structure/mushroom_circle/fey
	name = "妖精蘑菇环"
	desc = "一圈泛着微光的淡白与紫色魔法蘑菇。Dendor 的德鲁伊以它为路标，能瞬间跨越长途。"
	max_integrity = 200
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = "plantcross"

	/// Seconds since last scissors maintenance
	var/maintenance_elapsed = 0
	/// TRUE while usable as a portal; set to FALSE when decaying
	var/active = TRUE
	/// Timer ID for the final_decay timer so it can be cancelled on Destroy().
	var/decay_timerid = null
	/// world.time moment when final decay will occur after overgrowth starts.
	var/decay_finish_time = 0

/obj/structure/mushroom_circle/fey/Initialize(mapload)
	. = ..()
	GLOB.mushroom_circles |= src
	set_light(3, 3, 3, l_color = "#5D3FD3")
	START_PROCESSING(SSprocessing, src)

/obj/structure/mushroom_circle/fey/Destroy()
	GLOB.mushroom_circles -= src
	STOP_PROCESSING(SSprocessing, src)
	if(decay_timerid)
		deltimer(decay_timerid)
		decay_timerid = null
	return ..()

/obj/structure/mushroom_circle/fey/obj_destruction(damage_flag)
	for(var/i in 1 to rand(1, 2))
		new /obj/item/natural/fibers(get_turf(src))
	return ..()

/obj/structure/mushroom_circle/fey/process(dt)
	if(!active)
		return
	maintenance_elapsed += dt
	if(maintenance_elapsed >= 90 MINUTES)
		begin_decay()

/obj/structure/mushroom_circle/fey/proc/begin_decay()
	active = FALSE
	GLOB.mushroom_circles -= src
	set_light(0)
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "mushroomcluster"
	desc = "一圈枯萎的蘑菇，已失去与妖精界的联系。"
	visible_message(span_warning("[src]开始枯萎，神秘的光芒闪烁几下后熄灭。"))
	decay_finish_time = world.time + 5 MINUTES
	decay_timerid = addtimer(CALLBACK(src, PROC_REF(final_decay)), 5 MINUTES, flags = TIMER_STOPPABLE)

/obj/structure/mushroom_circle/fey/proc/final_decay()
	if(QDELETED(src))
		return
	new /obj/structure/flora/rogueshroom(get_turf(src))
	qdel(src)

/obj/structure/mushroom_circle/fey/examine(mob/user)
	. = ..()
	if(!active)
		var/time_to_final_decay = max(decay_finish_time - world.time, 0)
		. += span_warning("这个蘑菇环已失去力量并彻底疯长。它与妖精界的联系被切断了，还会在[DisplayTimeText(time_to_final_decay)]后崩塌。")
		return
	var/time_to_overgrowth = max((90 MINUTES) - maintenance_elapsed, 0)
	if(maintenance_elapsed > (75 MINUTES))
		. += span_warning("这些蘑菇看起来状态不佳。尽快用剪刀修剪，否则它会在[DisplayTimeText(time_to_overgrowth)]后疯长。")
	else
		. += span_info("这些蘑菇稳定地散发着妖精之力。若无人照料，它会在[DisplayTimeText(time_to_overgrowth)]后疯长。")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron && H.patron.type == /datum/patron/divine/dendor)
			if(H.get_skill_level(/datum/skill/magic/druidic) >= SKILL_LEVEL_EXPERT)
				. += span_notice("手持我的 Dendor 护符，将其按在这个蘑菇环上，就能前往另一处妖精蘑菇环。")
			else
				. += span_warning("妖精的奥秘超出我当前的理解，我需要更高深的德鲁伊修行，才能与这个蘑菇环共鸣。")

/obj/structure/mushroom_circle/fey/attackby(obj/item/I, mob/living/user, params)
	// Only block fey circle USE actions from low-skill users — attacking/chopping is always allowed.
	var/is_fey_use = istype(I, /obj/item/natural/feather) || istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor) || ((istype(I, /obj/item/rogueweapon/huntingknife/scissors) || istype(I, /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr)) && user.used_intent.type == /datum/intent/snip)
	if(is_fey_use && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_skill_level(/datum/skill/magic/druidic) < SKILL_LEVEL_EXPERT)
			to_chat(user, span_warning("这个蘑菇环中的妖精魔法超出了我的理解，我需要更高深的德鲁伊修行，才能与它共鸣。"))
			return

	// Feather rename support — name only, no description editing.
	if(istype(I, /obj/item/natural/feather))
		var/new_name = stripped_input(user, "你想给这个妖精蘑菇环起什么名字？", "重命名妖精蘑菇环", "", MAX_NAME_LEN)
		if(!new_name || QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
			return
		var/old_name = name
		if(old_name == new_name)
			to_chat(user, span_notice("妖精蘑菇环保留了原名。"))
		else
			name = "[new_name] ([initial(name)])"
			renamedByPlayer = TRUE
			to_chat(user, span_notice("我将[old_name]更名为[new_name]。"))
		return

	// Scissors/bauernwehr maintenance — requires snip intent so attacks don't accidentally maintain it
	if((istype(I, /obj/item/rogueweapon/huntingknife/scissors) || istype(I, /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr)) && user.used_intent.type == /datum/intent/snip)
		if(!active)
			to_chat(user, span_warning("这个蘑菇环已经凋零，现在无法恢复了。"))
			return
		to_chat(user, span_notice("我小心修整着[src]……"))
		if(do_after(user, 3 SECONDS, target = src))
			if(!active)
				return
			maintenance_elapsed = 0
			to_chat(user, span_notice("[src]看起来维护得很好，神秘的微光也更明亮了。"))
		return

	// Dendor amulet — opens fey teleport menu
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor))
		if(!user.patron || user.patron.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("唯有 Dendor 的信徒才能与这个蘑菇环沟通。"))
			return
		if(!active)
			to_chat(user, span_warning("这个蘑菇环的力量已经衰弱，无法再将我送往任何地方。"))
			return
		open_teleport_menu(user)
		return

	return ..()

/obj/structure/mushroom_circle/fey/proc/open_teleport_menu(mob/living/user)
	// 30-second per-user cooldown between fey circle uses.
	if(world.time < (user.mob_timers["feycircle_cooldown"] + 30 SECONDS))
		var/remaining = (user.mob_timers["feycircle_cooldown"] + 30 SECONDS) - world.time
		to_chat(user, span_warning("我必须等待[DisplayTimeText(remaining)]，让蘑菇环内的妖精能量重新充盈。"))
		return
	if(get_turf(user) != get_turf(src))
		to_chat(user, span_warning("我必须站在蘑菇环内，才能穿行妖精路径。"))
		return
	var/list/choices = list()
	for(var/obj/structure/mushroom_circle/fey/C in GLOB.mushroom_circles)
		if(C == src || !C.active)
			continue
		choices[C.name] = C

	if(!choices.len)
		to_chat(user, span_warning("这片网络中没有其他仍然活跃的妖精蘑菇环。"))
		return

	var/choice = input(user, "你想前往哪一个蘑菇环？", "妖精蘑菇环网络") as null|anything in choices
	if(isnull(choice) || QDELETED(src) || QDELETED(user))
		return

	var/obj/structure/mushroom_circle/fey/dest = choices[choice]
	if(QDELETED(dest) || !dest.active)
		to_chat(user, span_warning("在我作出选择后，那座蘑菇环已经消逝了。"))
		return

	to_chat(user, span_notice("我将意念聚焦在[dest.name]……"))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(dest) || !dest.active)
		to_chat(user, span_warning("目的地蘑菇环在旅途中消逝了。"))
		return

	var/turf/dest_turf = get_turf(dest)
	var/turf/source_turf = get_turf(src)
	var/list/travelers = list()
	for(var/mob/living/L in source_turf)
		if(!QDELETED(L))
			travelers += L

	playsound(source_turf, 'sound/misc/portalopen.ogg', 50, FALSE)
	for(var/mob/living/L in travelers)
		L.forceMove(dest_turf)
	playsound(dest_turf, 'sound/misc/portalopen.ogg', 50, FALSE)

	to_chat(user, span_notice("我迈入圆环，稳稳站定，随后便在[dest.name]现身。"))
	user.mob_timers["feycircle_cooldown"] = world.time
