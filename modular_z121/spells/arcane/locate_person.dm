// modular_z121 自定义奥术法术：寻人术
// 只允许追踪施法者 mind.known_people 中已经认识的人，避免越界获取陌生人的位置信息。

/obj/effect/proc_holder/spell/self/locate_person
	name = "寻人术"
	desc = "每个人的魔力都是独一无二的，通过对熟识之人魔力踪迹的追索，我能判断对方所在方向、距离、区域、层级与当前状态。"
	cost = 2
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 0
	recharge_time = 15 SECONDS
	cooldown_min = 15 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "locate_person"
	invocations = list("循迹寻人。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/self/locate_person/cast(list/targets, mob/living/user = usr)
	if(!ishuman(user) || !user.mind)
		revert_cast()
		return FALSE

	var/list/known_targets = get_available_known_targets(user)
	if(!length(known_targets))
		to_chat(user, span_warning("我当前感应不到任何熟识之人的清晰魔力踪迹。"))
		revert_cast()
		return FALSE

	var/chosen_name = input(user, "选择一位你想追踪的熟识之人。", "寻人术") as null|anything in known_targets
	if(QDELETED(src) || QDELETED(user))
		revert_cast()
		return FALSE
	if(!chosen_name)
		to_chat(user, span_notice("我暂时没有沿着任何熟识之人的魔力踪迹继续追索。"))
		revert_cast()
		return FALSE

	// 寻人术需要短暂持续引导，期间若移动或被打断，则不会得到结果。
	user.visible_message(
		span_notice("[user] 闭目凝神，以指尖拂过空气中残留的细微魔力波纹。"),
		span_notice("我开始顺着 [chosen_name] 残留在记忆中的独特魔力轨迹进行追索。")
	)
	if(!do_after(user, 5 SECONDS, target = user, progress = TRUE))
		to_chat(user, span_warning("我的引导被打断了，熟悉的魔力踪迹也随之散开。"))
		revert_cast()
		return FALSE

	if(QDELETED(src) || QDELETED(user) || !user.mind)
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/found_person = find_known_human(chosen_name)
	if(!found_person)
		to_chat(user, span_warning("[chosen_name] 的魔力踪迹此刻太过飘忽，我没能锁定对方的位置。"))
		revert_cast()
		return FALSE

	var/report_text = build_location_report(user, found_person)
	playsound(get_turf(user), 'sound/magic/whiteflame.ogg', 70, TRUE, soundping = TRUE)
	to_chat(user, span_notice("我循着 [found_person.real_name] 的魔力踪迹得出了感应：[report_text]"))
	return TRUE

/obj/effect/proc_holder/spell/self/locate_person/proc/get_available_known_targets(mob/living/carbon/human/user)
	var/list/known_targets = list()
	if(!user?.mind?.known_people)
		return known_targets

	// 只展示当前仍存在于场上的熟识之人，避免选中后必然落空。
	for(var/person_name in user.mind.known_people)
		if(find_known_human(person_name))
			known_targets += person_name
	return sortList(known_targets)

/obj/effect/proc_holder/spell/self/locate_person/proc/find_known_human(person_name)
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == person_name)
			return HL
	return null

/obj/effect/proc_holder/spell/self/locate_person/proc/build_location_report(mob/living/carbon/human/user, mob/living/carbon/human/found_person)
	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(found_person)
	if(!user_turf || !target_turf)
		return "那道踪迹忽明忽暗，我暂时无法判断更具体的位置。"

	var/list/report_parts = list()
	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/horizontal_distance = max(abs(dx), abs(dy))
	var/z_difference = abs(target_turf.z - user_turf.z)
	var/direction = get_dir(user_turf, target_turf)

	// 先给出罗盘式方向反馈，再补充距离、区域与状态，方便玩家一眼读懂。
	if(horizontal_distance <= 0)
		report_parts += "方位：◎ 就在我所在的位置"
	else
		report_parts += "方位：[get_direction_arrow(direction)] [get_direction_text(direction)]"

	report_parts += "距离：约 [horizontal_distance] 格"
	report_parts += "区域：[get_target_area_text(found_person)]"

	if(target_turf.z == user_turf.z)
		report_parts += "层级：与我处于同一层级"
	else if(target_turf.z > user_turf.z)
		report_parts += "层级：不在同一层级，对方位于更高处（相差 [z_difference] 层）"
	else
		report_parts += "层级：不在同一层级，对方位于更低处（相差 [z_difference] 层）"

	report_parts += "状态：[get_target_condition_text(found_person)]"

	return " [report_parts.Join("；")]。"

/obj/effect/proc_holder/spell/self/locate_person/proc/get_direction_text(direction)
	switch(direction)
		if(NORTH)
			return "北方"
		if(SOUTH)
			return "南方"
		if(EAST)
			return "东方"
		if(WEST)
			return "西方"
		if(NORTHEAST)
			return "东北方"
		if(NORTHWEST)
			return "西北方"
		if(SOUTHEAST)
			return "东南方"
		if(SOUTHWEST)
			return "西南方"
	return "难以辨明的方向"

/obj/effect/proc_holder/spell/self/locate_person/proc/get_direction_arrow(direction)
	switch(direction)
		if(NORTH)
			return "↑"
		if(SOUTH)
			return "↓"
		if(EAST)
			return "→"
		if(WEST)
			return "←"
		if(NORTHEAST)
			return "↗"
		if(NORTHWEST)
			return "↖"
		if(SOUTHEAST)
			return "↘"
		if(SOUTHWEST)
			return "↙"
	return "?"

/obj/effect/proc_holder/spell/self/locate_person/proc/get_target_condition_text(mob/living/carbon/human/found_person)
	if(found_person.stat == DEAD)
		return "已死亡"
	// 本项目只有 SOFT_CRIT / UNCONSCIOUS / DEAD 三档 stat，濒死用 InFullCritical() 区分。
	if(found_person.InFullCritical())
		return "濒临死亡"
	if(found_person.stat == UNCONSCIOUS)
		return "失去意识"
	if(found_person.stat == SOFT_CRIT)
		return "重伤挣扎"
	if(found_person.stat == CONSCIOUS)
		return "神志清醒"
	return "状态难明"

/obj/effect/proc_holder/spell/self/locate_person/proc/get_target_area_text(mob/living/carbon/human/found_person)
	var/area/target_area = get_area(found_person)
	if(!target_area)
		return "未知区域"

	// 优先使用地图作者提供的 location_name；若没有，则只在区名本身不是英文时才回显它。
	var/location_name = target_area.vars["location_name"]
	if(istext(location_name) && length(location_name))
		return location_name

	var/formatted_area_name = get_area_name(found_person, TRUE)
	if(!length(formatted_area_name))
		return "未知区域"
	if(has_latin_letters(formatted_area_name))
		return "未知区域"
	return formatted_area_name

/obj/effect/proc_holder/spell/self/locate_person/proc/has_latin_letters(text_to_check)
	var/upper_text = uppertext("[text_to_check]")
	for(var/i in 1 to length(upper_text))
		var/current_char = copytext(upper_text, i, i + 1)
		if(current_char >= "A" && current_char <= "Z")
			return TRUE
	return FALSE
