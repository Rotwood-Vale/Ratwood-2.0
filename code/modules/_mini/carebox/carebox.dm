GLOBAL_DATUM_INIT(carebox, /datum/carebox, new())

/datum/carebox
	var/list/carebox_table
	var/list/carebox_loot

/datum/carebox/New()
	. = ..()
	carebox_table = build_singleton_list(/datum/carebox_table)
	carebox_loot = build_singleton_list(/datum/carebox_loot)

/datum/carebox/proc/human_cycle_progress(mob/living/carbon/human/human)
	var/carebox_table_type = get_human_carebox_table(human)
	if(!carebox_table_type)
		return
	if(has_carebox(human))
		return
	var/datum/carebox_table/table = carebox_table[carebox_table_type]
	if(!(human.survived_cycles % table.cycles == 0))
		return
	give_carebox(human, table)

/datum/carebox/proc/get_human_carebox_table(mob/living/carbon/human/human)
	var/datum/job/job = SSjob.GetJob(human.job)
	if(!job)
		return null
	return job.carebox_table

/datum/carebox/proc/give_carebox(mob/living/carbon/human/human, datum/carebox_table/table)
	ADD_TRAIT(human, TRAIT_CAREBOX, TRAIT_GENERIC)
	human.apply_status_effect(/datum/status_effect/carebox)
	to_chat(human, span_notice("收到一封来自 <b>[table.sender]</b> 的新信件。"))
	human.playsound_local(human, 'sound/misc/mail.ogg', 100, FALSE, -1)

/datum/carebox/proc/has_carebox(mob/living/carbon/human/human)
	return HAS_TRAIT(human, TRAIT_CAREBOX)

/datum/carebox/proc/try_retrieve_carebox(mob/living/carbon/human/human, atom/source)
	if(!has_carebox(human))
		return FALSE
	if(alert(human, "你要领取你的特别补给包吗？", "", "是", "否") == "否")
		return FALSE
	var/carebox_table_type = get_human_carebox_table(human)
	if(!carebox_table_type)
		return
	var/datum/carebox_table/table = carebox_table[carebox_table_type]

	var/list/result_table = list()
	for(var/carebox_loot_type in table.loot)
		var/datum/carebox_loot/loot = carebox_loot[carebox_loot_type]
		result_table[loot.name] = carebox_loot_type

	var/remaining_choices = table.loot_choice
	var/list/loots = list()

	while(remaining_choices > 0)
		if(!length(result_table))
			break
		var/result = input(human, "我要领取什么？（可选：[remaining_choices]）[table.addendum]", "邮件") as null|anything in result_table
		if(!result)
			break
		var/result_loot = result_table[result]
		loots += result_loot
		result_table -= result

		remaining_choices--

	// User didn't select all choices
	if(remaining_choices > 0)
		return

	if(length(table.extra_loot))
		loots += table.extra_loot

	var/random_loot_choices = table.random_loot
	while(random_loot_choices > 0)
		if(!length(result_table))
			break
		var/picked_name = pick(result_table)
		var/result_loot = result_table[picked_name]
		result_table -= picked_name
		loots += result_loot

		random_loot_choices--

	if(!has_carebox(human))
		return
	// Success
	REMOVE_TRAIT(human, TRAIT_CAREBOX, TRAIT_GENERIC)
	human.remove_status_effect(/datum/status_effect/carebox)
	to_chat(human, span_notice("我领取了我的包裹。"))

	var/turf/spawn_loc = get_turf(human)
	playsound(spawn_loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

	var/list/items_to_spawn = list()

	for(var/loot_type in loots)
		var/datum/carebox_loot/loot = carebox_loot[loot_type]
		if(length(loot.loot))
			items_to_spawn += loot.loot
		if(length(loot.random_loot))
			var/list/random_copy = loot.random_loot.Copy()
			for(var/i in 1 to loot.random_loot_amt)
				if(!length(random_copy))
					break
				var/picked_item = pick_n_take(random_copy)
				items_to_spawn += picked_item

	for(var/item_path in items_to_spawn)
		var/obj/item/spawned = new item_path(spawn_loc)
		human.put_in_hands(spawned)
	return TRUE
