/mob/proc/collar_master_listen()
	set name = "监听宠物"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]  // Use first selected pet
	if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
		to_chat(src, span_warning("所选宠物无效！"))
		return

	if(pet.stat >= UNCONSCIOUS)
		to_chat(src, span_warning("[pet]必须保持清醒，才能建立监听链接！"))
		return

	to_chat(src, span_notice("你通过[pet]的项圈建立起了一道监听链接……"))
	to_chat(pet, span_warning("当主人借由你的耳朵监听时，你的项圈微微发麻了！"))

	CM.toggle_listening(pet)
	CM.last_command_time = world.time

/mob/proc/collar_master_shock()
	set name = "电击宠物"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈的能量单元仍在充能中！"))
		return

	var/intensity = 15  // Fixed intensity like the scepter
	CM.last_command_time = world.time
	var/shocked_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(pet.stat >= UNCONSCIOUS)
			to_chat(src, span_warning("[pet]必须保持清醒，才能接受惩戒！"))
			continue

		if(CM.shock_pet(pet, intensity))
			shocked_count++

	if(shocked_count > 0)
		to_chat(src, span_notice("你以电击惩戒了[shocked_count > 1 ? "[shocked_count]只宠物" : "你的宠物"]。"))
	else
		to_chat(src, span_warning("未能成功惩戒任何宠物！"))

/mob/proc/collar_master_send_message()
	set name = "发送讯息"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈的神经链接仍在充能中！"))
		return

	var/message = input(src, "你想让什么讯息在宠物脑海中回响？", "心灵命令") as text|null
	if(!message)
		return

	CM.last_command_time = world.time
	var/message_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		to_chat(pet, span_userdanger("<i>你的项圈回响起主人的声音：</i> [message]"))
		playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
		if(!pet.is_shifted)
			pet.do_jitter_animation(15)
		message_count++

	if(message_count > 0)
		to_chat(src, span_notice("你将自己的意志投射进了[message_count > 1 ? "[message_count]只宠物" : "宠物"]的脑海。"))
	else
		to_chat(src, span_warning("没能联系上任何宠物！"))

/mob/proc/collar_master_force_surrender()
	set name = "强制投降"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/surrendered_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(pet.stat >= UNCONSCIOUS)
			to_chat(src, span_warning("[pet]必须保持清醒，才能被强制投降！"))
			continue

		if(CM.force_surrender(pet))
			surrendered_count++

	to_chat(src, span_notice("已强制 [surrendered_count] 只宠物投降。"))

/mob/proc/collar_master_force_strip()
	set name = "强制脱衣"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈的指令回路仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/stripped_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(CM.force_strip(pet))
			stripped_count++

	if(stripped_count > 0)
		to_chat(src, span_notice("你命令了[stripped_count > 1 ? "[stripped_count]只宠物" : "你的宠物"]脱衣。"))
	else
		to_chat(src, span_warning("没能让任何宠物脱衣！"))

/mob/proc/collar_master_clothing()
	set name = "穿衣许可"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈的行为回路需要时间重新校准！"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		var/permitted = HAS_TRAIT_FROM(pet, TRAIT_NUDIST, COLLAR_TRAIT)
		if(CM.permit_clothing(pet, permitted))
			if(permitted)
				to_chat(src, span_notice("你准许[pet.real_name]穿衣。"))
			else
				to_chat(src, span_notice("你禁止[pet.real_name]穿衣。"))

/mob/proc/collar_master_toggle_speech()
	set name = "切换发声"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈的发声抑制器还需要时间轮转！"))
		return

	CM.last_command_time = world.time
	var/toggled_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(CM.toggle_speech(pet))
			toggled_count++

	to_chat(src, span_notice("已为 [toggled_count] 只宠物切换发声状态。"))

/mob/proc/collar_master_force_action()
	set name = "强制行动"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	var/message = input(src, "你想让宠物执行什么动作？", "命令执行") as text|null
	if(!message || !CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈的控制矩阵仍在充能中！"))
		return

	CM.last_command_time = world.time
	var/action_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		to_chat(pet, span_userdanger("你的项圈强迫你执行一项动作！"))
		pet.visible_message(span_warning("[pet]的项圈开始搏动，逼迫其付诸行动！"))
		pet.say(message) // The game will automatically handle * for emotes
		if(!pet.is_shifted)
			pet.do_jitter_animation(15)
		playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
		action_count++

	if(action_count > 0)
		to_chat(src, span_notice("你强迫[action_count > 1 ? "[action_count]只宠物" : "你的宠物"]执行了你的命令动作。"))
	else
		to_chat(src, span_warning("没能让任何宠物执行该动作！"))

/mob/proc/collar_master_force_love()
	set name = "强制爱恋"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		// Toggle love status
		var/love_enabled
		if(pet.has_status_effect(/datum/status_effect/in_love))
			pet.remove_status_effect(/datum/status_effect/in_love)
			REMOVE_TRAIT(pet, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
			to_chat(pet, span_notice("那股压倒性的吸引感逐渐褪去了……"))
			love_enabled = FALSE
		else
			pet.apply_status_effect(/datum/status_effect/in_love, src)
			ADD_TRAIT(pet, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
			to_chat(pet, span_love("你感到自己对[src]产生了压倒性的爱慕！"))
			love_enabled = TRUE
		playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
		log_collar_command(pet, COLLAR_LOG_LOVE, "enabled=[love_enabled]")

	to_chat(src, span_notice("已为 [length(CM.temp_selected_pets)] 只宠物切换爱恋状态。"))

/mob/proc/collar_master_force_arousal()
	set name = "切换情欲"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/affected_pets = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(CM.toggle_arousal(pet))
			affected_pets++

	to_chat(src, span_notice("已为 [affected_pets] 只宠物切换情欲状态。"))

/mob/proc/collar_master_toggle_denial()
	set name = "切换高潮禁止"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/toggle_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(CM.toggle_denial(pet))
			toggle_count++

	to_chat(src, span_notice("已为 [toggle_count] 只宠物切换高潮限制。"))

/mob/proc/collar_master_toggle_chastity_lock()
	set name = "切换贞操锁定"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/affected = 0
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue
		if(CM.toggle_pet_chastity_lock(pet))
			affected++

	to_chat(src, affected ? span_notice("已为 [affected] 只宠物切换贞操锁定。") : span_warning("所选宠物中没有佩戴诅咒贞操装置者。"))

/mob/proc/collar_master_cycle_chastity_front()
	set name = "轮换贞操前端开放"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/affected = 0
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue
		if(CM.cycle_pet_chastity_front(pet))
			affected++

	to_chat(src, affected ? span_notice("已为 [affected] 只宠物轮换贞操前端开放状态。") : span_warning("所选宠物中没有佩戴诅咒贞操装置者。"))

/mob/proc/collar_master_toggle_chastity_anal()
	set name = "切换贞操肛门开放"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/affected = 0
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue
		if(CM.toggle_pet_chastity_anal(pet))
			affected++

	to_chat(src, affected ? span_notice("已为 [affected] 只宠物切换贞操肛门开放状态。") : span_warning("所选宠物中没有佩戴诅咒贞操装置者。"))

/mob/proc/collar_master_toggle_chastity_spikes()
	set name = "切换贞操尖刺"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/affected = 0
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue
		if(CM.toggle_pet_chastity_spikes(pet))
			affected++

	to_chat(src, affected ? span_notice("已为 [affected] 只宠物切换贞操尖刺状态。") : span_warning("所选宠物中没有佩戴诅咒贞操装置者。"))

/mob/proc/collar_master_toggle_hallucinate()
	set name = "切换宠物幻觉"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time
	var/toggled_count = 0

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		if(CM.toggle_hallucinations(pet))
			toggled_count++

	if(toggled_count > 0)
		to_chat(src, span_notice("已为 [toggled_count] 只宠物切换幻觉状态。"))
	else
		to_chat(src, span_warning("未能为任何宠物切换幻觉状态！"))

/mob/proc/collar_master_illusion()
	set name = "制造幻象"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	var/message = input(src, "你想让宠物看见、感受到什么？", "施加意志") as message|null
	if(!message || !CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !pet.mind || !pet.client || !(pet in CM.my_pets))
			continue

		// Send message directly to pet's chat
		to_chat(pet, message)
		playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

	to_chat(src, span_notice("你为 [length(CM.temp_selected_pets)] 只宠物施加了幻象。"))

/mob/proc/collar_master_select_pets()
	set name = "选择宠物"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	if(!length(CM.my_pets))
		to_chat(src, span_warning("你没有可供选择的宠物！"))
		return

	var/list/pet_options = list()
	for(var/mob/living/carbon/human/pet in CM.my_pets)
		if(!pet || pet.stat == DEAD)
			continue
		pet_options[pet.name] = pet

	if(!length(pet_options))
		to_chat(src, span_warning("没有可用的有效宠物！"))
		return

	var/list/selected = input(src, "选择要下令的宠物：", "宠物选择") as null|anything in pet_options
	if(!selected)
		return

	CM.temp_selected_pets.Cut()
	if(islist(selected))
		for(var/name in selected)
			CM.temp_selected_pets += pet_options[name]
	else
		CM.temp_selected_pets += pet_options[selected]

	to_chat(src, span_notice("已选中 [length(CM.temp_selected_pets)] 只宠物。"))

/mob/proc/collar_master_release_pet()
	set name = "释放宠物"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("项圈仍在冷却中！"))
		return

	var/confirm = alert("你确定要释放所选宠物吗？", "释放确认", "是", "否")
	if(confirm != "是")
		return

	CM.last_command_time = world.time
	var/released_count = 0

	var/list/release_targets = CM.temp_selected_pets.Copy()
	for(var/mob/living/carbon/human/pet in release_targets)
		if(!pet || !pet.mind || !(pet in CM.my_pets))
			continue

		if(CM.remove_pet(pet))
			CM.temp_selected_pets -= pet
			released_count++

	if(released_count > 0)
		to_chat(src, span_notice("已将 [released_count] 只宠物从你的控制下释放。"))
	else
		to_chat(src, span_warning("未能释放任何宠物！"))

/mob/proc/collar_master_help()
	set name = "项圈帮助"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	var/help_text = {"<span class='notice'><b>项圈主控命令：</b>
	- 选择宠物：选择哪些宠物会受到命令影响
	- 打开图形控制面板：打开新的常驻项圈控制界面
	- 发送讯息：通过项圈发送一段信息
	- 强制投降：强迫宠物屈服
	- 电击宠物：以不同强度惩戒宠物
	- 释放宠物：将宠物从你的控制中解放
	- 监听宠物：听见你的宠物所听见的内容
	- 强制脱衣：让你的宠物脱光并禁止其穿衣
	- 禁止/允许穿衣：令你的宠物无法自行穿衣，或恢复许可
	- 切换宠物发声：让宠物闭嘴，只能发出动物般的叫声
	- 强制行动：强迫其说出或做出你输入的内容
	- 强制爱恋：强迫其爱上你
	- 切换情欲：切换其情欲状态
	- 切换高潮禁止：禁止其达到高潮
	- 切换贞操锁定：锁定/解锁诅咒贞操装置
	- 轮换贞操前端开放：在 全封闭 / 阴茎开放 / 阴部开放 / 全开放 之间轮换
	- 切换贞操肛门开放：打开或封闭诅咒贞操的肛门通路
	- 切换贞操尖刺：切换诅咒贞操带来的生殖器尖刺特性
	- 切换宠物幻觉：让宠物听见或看见并不存在的事物
	- 施加意志：向宠物发送未经处理的信息，可表现为所见、所感等
	- 释放宠物：项圈会掉落到地上

	注意：大多数命令有 [CM.command_cooldown/10] 秒冷却。
	当前控制 [length(CM.my_pets)] 只宠物，其中 [length(CM.temp_selected_pets)] 只已被选中。</span>"}

	to_chat(src, help_text)


/mob/proc/collar_master_releaseall()
	set name = "释放全部宠物"
	set category = "项圈标签"

	var/datum/component/collar_master/CM = mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		return
	qdel(CM)
