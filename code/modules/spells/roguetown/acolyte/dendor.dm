// Druid
/obj/effect/proc_holder/spell/targeted/blesscrop
	name = "祝福庄稼"
	desc = "为目标土壤、树木赐福。德鲁伊技艺会提高储存充能。可复苏枯死植物，在缺乏时补充养分与水分，并加速其生长。持有祝福种粉时，还可一次耗尽全部充能，最多同时祝福附近五块已种植的土壤。"
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "blesscrop"
	range = 5
	selection_type = "range"
	releasedrain = 15
	charge_type = "charges"
	recharge_time = 1
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 1
	cast_without_targets = FALSE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	invocations = list("树父命你丰饶结果！")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/max_bless_charges = 1
	var/charge_regen_elapsed = 0
	var/empty_refill_elapsed = 0
	var/empty_refill_active = FALSE
	var/active_sound = null
	/// Set TRUE after the first sync with a real user, so charges are topped up correctly at spawn.
	var/charges_initialized = FALSE

/obj/effect/proc_holder/spell/targeted/blesscrop/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/blesscrop/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		if(active_sound)
			user.playsound_local(user, active_sound, 100, vary = FALSE)
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/blesscrop/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/blesscrop/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(.)
		return TRUE
	// Special case: targeting a lesser dryad triggers Dendor's Blessed Frenzy.
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser))
		if(!can_cast(caller))
			deactivate(caller)
			return TRUE
		var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad = target
		if(dryad.frenzy_timer)
			to_chat(caller, span_warning("树妖的狂乱祝福尚未平息！"))
			return TRUE
		if(!charge_check(caller))
			return TRUE
		// Check whether the player is holding a bloomstone for a stronger frenzy.
		var/obj/item/act_item = caller.get_active_held_item()
		var/obj/item/inact_item = caller.get_inactive_held_item()
		var/bloomstone_boost = istype(act_item, /obj/item/alch/bloomstone) || istype(inact_item, /obj/item/alch/bloomstone)
		if(bloomstone_boost)
			var/obj/item/alch/bloomstone/bs = istype(act_item, /obj/item/alch/bloomstone) ? act_item : inact_item
			qdel(bs) // Consumes one charge (Destroy() decrements; stone survives until charges reach 0).
		dryad.apply_blessed_frenzy(bloomstone_boost)
		playsound(caller, sound, 100, TRUE)
		charge_counter--
		after_cast(list(target), caller)
		deactivate(caller)
		return TRUE
	if(ismob(target))
		to_chat(caller, span_warning("“祝福庄稼”必须对准树木、长原木或土壤。"))
		return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return TRUE
	if(perform(list(target), TRUE, user = ranged_ability_user))
		return TRUE
	return TRUE

/obj/effect/proc_holder/spell/targeted/blesscrop/Initialize(mapload)
	. = ..()
	charge_counter = 1
	max_bless_charges = 1

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/get_max_bless_charges(mob/user)
	if(!user)
		return max(1, max_bless_charges)
	return max(1, 1 + user.get_skill_level(associated_skill))

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/sync_bless_charges(mob/user)
	var/old_max = max_bless_charges
	max_bless_charges = get_max_bless_charges(user)
	if(!charges_initialized && user)
		// First sync with a real user — set charges to the skill-based maximum immediately.
		charges_initialized = TRUE
		charge_counter = max_bless_charges
	else if(!empty_refill_active)
		if(max_bless_charges > old_max)
			// Skill level increased — award the extra charges proportionally.
			charge_counter = min(charge_counter + (max_bless_charges - old_max), max_bless_charges)
		else
			charge_counter = clamp(charge_counter, 0, max_bless_charges)

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/start_empty_refill()
	if(empty_refill_active)
		return
	empty_refill_active = TRUE
	empty_refill_elapsed = 0
	charge_regen_elapsed = 0
	charge_counter = 0
	START_PROCESSING(SSfastprocess, src)
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/spend_all_bless_charges()
	charge_counter = 0
	start_empty_refill()

/obj/effect/proc_holder/spell/targeted/blesscrop/charge_check(mob/user, silent = FALSE)
	if(!silent || charges_initialized)
		sync_bless_charges(user)
	if(empty_refill_active || charge_counter <= 0)
		if(!empty_refill_active)
			start_empty_refill()
		if(!silent)
			to_chat(user, span_warning("[name] 已耗尽，必须恢复后才能再次使用。"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/blesscrop/start_recharge()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/process()
	if(empty_refill_active)
		empty_refill_elapsed += 2
		if(empty_refill_elapsed >= 30 SECONDS)
			empty_refill_active = FALSE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			charge_counter = max_bless_charges
			if(action)
				action.UpdateButtonIcon()
			STOP_PROCESSING(SSfastprocess, src)
		return
	if(charge_counter < max_bless_charges)
		charge_regen_elapsed += 2
		while(charge_regen_elapsed >= 10 SECONDS && charge_counter < max_bless_charges)
			charge_regen_elapsed -= 10 SECONDS
			charge_counter++
		if(action)
			action.UpdateButtonIcon()
		if(charge_counter >= max_bless_charges)
			charge_counter = max_bless_charges
			STOP_PROCESSING(SSfastprocess, src)
		return
	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/after_cast(list/targets, mob/user = usr)
	. = ..()
	sync_bless_charges(user)
	if(active)
		add_ranged_ability(user, null, TRUE)
	if(charge_counter <= 0)
		start_empty_refill()
	else
		empty_refill_active = FALSE
		empty_refill_elapsed = 0
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/revert_cast(mob/user = usr)
	. = ..()
	sync_bless_charges(user)
	if(active)
		add_ranged_ability(user, null, TRUE)
	empty_refill_active = FALSE
	empty_refill_elapsed = 0
	if(charge_counter < max_bless_charges)
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/cast(list/targets,mob/user = usr)
	. = ..()
	var/atom/target_atom = targets?.len ? targets[1] : null
	var/turf/target_turf = get_turf(target_atom)
	sync_bless_charges(user)
	if(!target_turf)
		target_turf = get_turf(user)
	var/list/target_long_logs = list()
	for(var/obj/item/grown/log/tree/log in target_turf)
		if(log.type == /obj/item/grown/log/tree)
			target_long_logs += log
	var/obj/item/alch/blessedseedpowder/blessed_seed_powder = user.get_active_held_item()
	if(!istype(blessed_seed_powder))
		blessed_seed_powder = user.get_inactive_held_item()
	if(!istype(blessed_seed_powder))
		blessed_seed_powder = null
	// Also accept a Harvest Bloomstone as a one-charge powder substitute.
	var/obj/item/alch/bloomstone/held_bloomstone = null
	if(!blessed_seed_powder)
		var/obj/item/act_item = user.get_active_held_item()
		var/obj/item/inact_item = user.get_inactive_held_item()
		if(istype(act_item, /obj/item/alch/bloomstone))
			held_bloomstone = act_item
		else if(istype(inact_item, /obj/item/alch/bloomstone))
			held_bloomstone = inact_item
	// seed_source is either a blessed seed powder or a bloomstone acting as one.
	var/obj/item/seed_source = blessed_seed_powder || held_bloomstone
	// Detect a held bucket or mortar containing holy water for log blessing.
	var/obj/item/reagent_containers/water_container = null
	for(var/obj/item/held in list(user.get_active_held_item(), user.get_inactive_held_item()))
		if(held?.reagents && (istype(held, /obj/item/reagent_containers/glass/bucket) || istype(held, /obj/item/reagent_containers/glass/mortar)))
			if(held.reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 2)
				water_container = held
				break

	// Targeted long-log blessing: consume blessed seed powder + all holy water in held mortar/bucket,
	// and bless up to 6 long logs on the targeted tile.
	if(target_long_logs.len || istype(target_atom, /obj/item/grown/log/tree))
		if(istype(target_atom, /obj/item/grown/log/tree) && target_atom.type != /obj/item/grown/log/tree)
			to_chat(user, span_warning("只有长原木能接受这道仪式的祝福。"))
			return FALSE
		if(!target_long_logs.len)
			to_chat(user, span_warning("那个位置没有可供圣化的大原木。"))
			return FALSE
		if(!seed_source)
			to_chat(user, span_warning("我必须手持祝福种粉或丰收绽石，才能圣化原木。"))
			return FALSE
		if(!water_container)
			to_chat(user, span_warning("我必须手持装有圣水的石钵或水桶，才能圣化原木。"))
			return FALSE
		var/blessed_amt = water_container.reagents.get_reagent_amount(/datum/reagent/water/blessed)
		if(blessed_amt < 1)
			to_chat(user, span_warning("我的容器里没有足够的圣水来支撑这道祝福。"))
			return FALSE
		var/blessed_logs = 0
		for(var/obj/item/grown/log/tree/log in target_long_logs)
			if(!log.bless_log())
				continue
			blessed_logs++
			if(blessed_logs >= 6)
				break
		if(blessed_logs <= 0)
			to_chat(user, span_warning("这里没有尚未受祝福的长原木可供圣化。"))
			return FALSE
		water_container.reagents.remove_reagent(/datum/reagent/water/blessed, blessed_amt)
		qdel(seed_source)
		visible_message(span_green("[usr] 以 登多尔 的恩泽圣化了这些长原木！"))
		return TRUE

	// Soil plots are now blessed one-by-one unless blessed seed powder is used to bypass it.
	var/obj/structure/soil/target_soil = null
	if(istype(target_atom, /obj/structure/soil))
		target_soil = target_atom
	else
		target_soil = locate(/obj/structure/soil) in target_turf
	if(target_soil)
		if(target_soil.blessed_time > 0 && !seed_source)
			to_chat(user, span_warning("这片土壤已经受过祝福了。要等到 [DisplayTimeText(target_soil.blessed_time)] 后才能再次施祝。"))
			revert_cast(user)
			return FALSE
		if(seed_source)
			var/amount_blessed = 0
			for(var/obj/structure/soil/soil in range(4, user))
				if(!soil.plant)
					continue
				soil.bless_soil()
				amount_blessed++
				if(amount_blessed >= 5)
					break
			if(amount_blessed <= 0)
				to_chat(user, span_warning("附近没有已经种下作物的土壤可供种粉施祝。"))
				return FALSE
			qdel(seed_source)
			spend_all_bless_charges()
			visible_message(span_green("[usr] 撒下祝福种粉，登多尔 的恩泽随之拂过附近的作物！"))
			return TRUE
		target_soil.bless_soil()
		visible_message(span_green("[usr] 以 登多尔 的恩泽祝福了 [target_soil]！"))
		return TRUE

	// Non-soil target mode: bless exactly what was targeted.
	// Evil trees are dense+opaque, so the click may land on the turf — check both.
	var/obj/structure/flora/roguetree/target_tree = null
	if(istype(target_atom, /obj/structure/flora/roguetree))
		target_tree = target_atom
	else
		target_tree = locate(/obj/structure/flora/roguetree) in target_turf
	if(target_tree)
		if(seed_source && get_dist(user, target_tree) > 1)
			to_chat(user, span_warning("我必须紧贴树木，才能以 登多尔 的祝福转化它。"))
			return FALSE
		if(seed_source && target_tree.reinvigorate_tree(user))
			if(seed_source == user.get_active_held_item() || seed_source == user.get_inactive_held_item())
				qdel(seed_source)
			visible_message(span_green("[usr] 向 [target_tree] 唤来了 登多尔 的恩泽。"))
			return TRUE
		if(target_tree.bless_tree(user))
			visible_message(span_green("[usr] 向 [target_tree] 唤来了 登多尔 的恩泽。"))
			return TRUE
	if(istype(target_atom, /obj/structure/flora/newtree))
		var/obj/structure/flora/newtree/tree = target_atom
		if(tree.bless_tree(user))
			visible_message(span_green("[usr] 向 [tree] 唤来了 登多尔 的恩泽。"))
			return TRUE

	to_chat(user, span_warning("这个目标无法承受这道祝福。"))
	return FALSE

//At some point, this spell should Awaken beasts, allowing a ghost to possess them. Not for this PR though.
/obj/effect/proc_holder/spell/targeted/beasttame
	name = "驯服野兽"
	desc = "以登多尔的祝福安抚目标中可驯养的野兽，永久平息其怒意。共有 2 层充能；每层 10 秒恢复，若两层全空则需 1 分钟回满。"
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "tamebeast"
	range = 5
	selection_type = "range"
	releasedrain = 30
	charge_type = "charges"
	recharge_time = 1
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 1
	cast_without_targets = FALSE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("安静下来吧，兽之兄弟。")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/beast_tameable_factions = list("saiga", "chickens", "cows", "goats", "wolfs", "spiders")
	var/charge_regen_elapsed = 0
	var/empty_refill_elapsed = 0
	var/empty_refill_active = FALSE

/obj/effect/proc_holder/spell/targeted/beasttame/Initialize(mapload)
	. = ..()
	charge_counter = 2

/obj/effect/proc_holder/spell/targeted/beasttame/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/beasttame/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/beasttame/charge_check(mob/user, silent = FALSE)
	if(empty_refill_active || charge_counter <= 0)
		if(!empty_refill_active)
			empty_refill_active = TRUE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			START_PROCESSING(SSfastprocess, src)
		if(!silent)
			to_chat(user, span_warning("[name] 已耗尽，必须恢复后才能再次使用。"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/beasttame/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(.)
		return TRUE
	if(!isliving(target))
		to_chat(caller, span_warning("“驯服野兽”必须对准活着的野兽。"))
		return TRUE
	if(!istype(target, /mob/living/simple_animal))
		to_chat(caller, span_warning("这个生物无法被驯服。"))
		return TRUE
	var/mob/living/simple_animal/animal = target
	if((animal.mob_biotypes & MOB_UNDEAD) || !faction_check(animal.faction, beast_tameable_factions))
		to_chat(caller, span_warning("这头野兽不属于可驯养的种类。"))
		return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return TRUE
	perform(list(target), TRUE, user = ranged_ability_user)
	return TRUE

/obj/effect/proc_holder/spell/targeted/beasttame/cast(list/targets, mob/user = usr)
	. = ..()
	var/mob/living/simple_animal/animal = targets?.len ? targets[1] : null
	if(!animal || QDELETED(animal))
		return FALSE
	visible_message(span_green("[user] 以 登多尔 的低语抚平了兽血中的躁动。"))
	animal.tamed(TRUE)
	if(istype(animal, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/simple_animal/hostile/retaliate/retaliate_animal = animal
		retaliate_animal.aggressive = FALSE
	if(animal.ai_controller)
		animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
		animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_TAMED, TRUE)
	to_chat(user, span_green("在 登多尔 的祝福下，你平息了 [animal] 的怒火。"))
	return TRUE

/obj/effect/proc_holder/spell/targeted/beasttame/after_cast(list/targets, mob/user = usr)
	. = ..()
	if(charge_counter <= 0)
		empty_refill_active = TRUE
		empty_refill_elapsed = 0
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)
		deactivate(user)
	else
		empty_refill_active = FALSE
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)
		if(active)
			add_ranged_ability(user, null, TRUE)
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/beasttame/process()
	if(empty_refill_active)
		empty_refill_elapsed += 2
		if(empty_refill_elapsed >= 60 SECONDS)
			empty_refill_active = FALSE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			charge_counter = 2
			if(action)
				action.UpdateButtonIcon()
			STOP_PROCESSING(SSfastprocess, src)
		return
	if(charge_counter < 2)
		charge_regen_elapsed += 2
		while(charge_regen_elapsed >= 10 SECONDS && charge_counter < 2)
			charge_regen_elapsed -= 10 SECONDS
			charge_counter++
		if(action)
			action.UpdateButtonIcon()
		if(charge_counter >= 2)
			STOP_PROCESSING(SSfastprocess, src)
		return
	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/conjure_glowshroom
	name = "菌辉照明"
	desc = "召唤会发光的蘑菇；任何试图闯入其中的人都会被电击。登多尔的信徒免疫此效果。"
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "glowshroom"
	range = 1
	releasedrain = 30
	recharge_time = 30 SECONDS
	chargetime = 1 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/items/dig_shovel.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("树父，照亮前路。")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	devotion_cost = 30

/obj/effect/proc_holder/spell/targeted/conjure_glowshroom/cast(list/targets, mob/user = usr)
	. = ..()

	to_chat(user, span_notice("我开始滋养周围的土壤！"))
	if(!do_after(user, 0.5 SECONDS, progress = TRUE))
		revert_cast()
		return FALSE

	// Spawn a 3x1 line across the tile in front of the caster.
	var/turf/center_turf = get_step(user, user.dir)
	var/list/spawn_turfs = list(get_step(center_turf, turn(user.dir, 90)), center_turf, get_step(center_turf, turn(user.dir, -90)))
	for(var/turf/spawn_turf as anything in spawn_turfs)
		if(!istype(spawn_turf))
			continue
		if(!isclosedturf(spawn_turf) && !locate(/obj/structure/glowshroom) in spawn_turf)
			new /obj/structure/glowshroom(spawn_turf)
	return TRUE

/obj/effect/proc_holder/spell/targeted/conjure_vines
	name = "藤蔓萌发"
	desc = "在附近召出藤蔓。"
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "vine"
	releasedrain = 90
	invocations = list("树父，令藤蔓破土而出。")
	invocation_type = "shout"
	devotion_cost = 30
	range = 1
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/items/dig_shovel.ogg'
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE

/obj/effect/proc_holder/spell/targeted/conjure_vines/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/target_turf = get_step(user, user.dir)
	var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
	var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
	if(!locate(/obj/structure/vine/dendor) in target_turf)
		new /obj/structure/vine/dendor(target_turf)
	if(!locate(/obj/structure/vine/dendor) in target_turf_two)
		new /obj/structure/vine/dendor(target_turf_two)
	if(!locate(/obj/structure/vine/dendor) in target_turf_three)
		new /obj/structure/vine/dendor(target_turf_three)

	return TRUE

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon
	name = "呼唤明月"
	desc = "汲取隐秘天穹中的秘密，与受月诅咒者交谈。"
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "howl"
	antimagic_allowed = FALSE
	recharge_time = 600
	ignore_cockblock = TRUE
	use_language = TRUE
	var/first_cast = FALSE

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon/cast(mob/living/carbon/human/user)
	// only usable at night
	if (!GLOB.tod == "night")
		to_chat(user, span_warning("我必须等到隐月升起后，才能呼唤它。"))
		revert_cast()
		return
	// if they don't have beast language somehow, give it to them
	if (!user.has_language(/datum/language/beast))
		user.grant_language(/datum/language/beast)
		to_chat(user, span_boldnotice("高悬天际的隐月残辉向我揭示了祂的真理：原来兽语的知识一直都沉睡在我体内。"))

	if (!first_cast)
		to_chat(user, span_boldwarning("大地与空气如此低语：呼唤明月乃是神圣之事，将由此得来的知识分享给不属祂者，便是罪。"))
		to_chat(user, span_boldwarning("谨记于心吧，登多尔 的孩子。"))
		first_cast = TRUE
	. = ..()

/obj/effect/proc_holder/spell/invoked/spiderspeak
	name = "蜘蛛之语"
	desc = "让蜘蛛不再主动攻击目标。"
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "spider"
	releasedrain = 15
	chargedrain = 0
	chargetime = 1 SECONDS
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	invocations = list("Psydonia 的蛛群啊，让我平安通过！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	recharge_time = 4 SECONDS
	miracle = TRUE
	devotion_cost = 25

/obj/effect/proc_holder/spell/invoked/spiderspeak/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.visible_message("<font color='yellow'>[user] 将盘旋缠绕的幽灵蛛丝注入 [target] 体内！</font>")
		target.visible_message("<font color='yellow'>你感到自己的舌头诡异地扭动起来，发出古怪的咔哒声。</font>")
		target.apply_status_effect(/datum/status_effect/buff/spider_speak)
		return TRUE
	revert_cast()
	return FALSE

// --- T4 Miracle: Sanctify Tree -----------------------------------------------
/obj/effect/proc_holder/spell/invoked/sanctify_tree
	name = "圣化古树"
	desc = "引导 登多尔 最神圣的祝福，将一棵活着且未被烧毁的树木祝圣为树父的圣树，化作德鲁伊之力的枢纽。"
	invocation_type = "shout"
	overlay_state = "blesscrop"
	range = 1
	recharge_time = 60 SECONDS
	associated_skill = /datum/skill/magic/holy
	sound = 'sound/ambience/noises/mystical (4).ogg'
	invocations = list("树父，请将这棵活树迎入你永恒的怀抱！")
	miracle = TRUE
	devotion_cost = 250

/obj/effect/proc_holder/spell/invoked/sanctify_tree/cast(list/targets, mob/living/user)
	. = ..()

	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return FALSE

	var/atom/target_atom = targets[1]
	var/obj/structure/flora/newtree/target = null

	// Use for-in-list idiom: the loop var gets the correct static type regardless of source type.
	for(var/obj/structure/flora/newtree/NT_target in list(target_atom))
		if(!NT_target.burnt)
			target = NT_target
		break  // only check the first (and only) element
	if(!target && target_atom.loc && (get_dist(user, target_atom.loc) <= 1))
		for(var/obj/structure/flora/newtree/NT in target_atom.loc)
			if(!NT.burnt)
				target = NT
				break

	// If no living newtree found, search for an unsanctified wise tree to bless instead.
	var/obj/structure/flora/roguetree/wise/wise_target = null
	if(!target)
		for(var/obj/structure/flora/roguetree/wise/WT in list(target_atom))
			if(!istype(WT, /obj/structure/flora/roguetree/wise/sanctified))
				wise_target = WT
				break
		if(!wise_target && target_atom.loc && (get_dist(user, target_atom.loc) <= 1))
			for(var/obj/structure/flora/roguetree/wise/WT in target_atom.loc)
				if(!istype(WT, /obj/structure/flora/roguetree/wise/sanctified))
					wise_target = WT
					break

	if(!target && !wise_target)
		to_chat(H, span_warning("我必须对准紧贴在身旁的活树。老树、烧毁的树，以及已经圣化过的树都无法再次祝圣。"))
		return FALSE

	// For newtree consecration, block if a full sanctified tree (not sanctified_wise) is within 10 tiles.
	if(target)
		for(var/obj/structure/flora/roguetree/wise/sanctified/ST in range(10, target))
			if(istype(ST, /obj/structure/flora/roguetree/wise/sanctified/wise))
				continue  // sanctified wise trees do not block grove anchor placement
			to_chat(H, span_warning("附近已经有一棵圣树矗立。树父不会允许另一处林苑锚点离得如此之近。"))
			return FALSE

	var/atom/cast_target = target || wise_target
	H.visible_message(
		span_notice("[H] 将双手按在 [cast_target] 的树皮上，开始了一段漫长而虔敬的祷诵。"),
		span_notice("我将双手按在树皮上，把树父的祝福灌注进这棵树中……")
	)

	if(!do_after(H, 10 SECONDS, target = cast_target))
		to_chat(H, span_warning("祝圣仪式被打断了，祝福随之消散，只能重新开始。"))
		return FALSE

	// ---- Newtree → full sanctified tree ----
	if(target)
		if(QDELETED(target) || target.burnt)
			to_chat(H, span_warning("这棵树已经不再是有效的圣化目标了。"))
			return FALSE

		var/turf/T = get_turf(target)

		// Clean up branches and leaves from the old newtree.
		// Mirrors the wise tree conversion in create_wise_tree.dm.
		for(var/turf/adjacent in range(1, T))
			for(var/obj/structure/flora/newbranch/B in adjacent)
				qdel(B)
			for(var/obj/structure/flora/newleaf/L in adjacent)
				qdel(L)
		var/turf/above = get_step_multiz(T, UP)
		if(istype(above, /turf/open/transparent/openspace))
			for(var/obj/structure/flora/newtree/upper_tree in above)
				qdel(upper_tree)

		qdel(target)

		var/obj/structure/flora/roguetree/wise/sanctified/new_tree = new(T)
		playsound(T, 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
		H.visible_message(
			span_green("[H] 的双手燃起金色辉光，[new_tree] 完成圣化，蜕变为一棵属于 登多尔 的圣树！"),
			span_notice("当 [new_tree] 完成圣化时，我感到树父的力量流过了我的全身。")
		)
		SEND_SIGNAL(H, COMSIG_TREE_TRANSFORMED)
		if(H.mind)
			H.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
		return TRUE

	// ---- Wise tree → sanctified wise tree ----
	if(wise_target)
		if(QDELETED(wise_target) || istype(wise_target, /obj/structure/flora/roguetree/wise/sanctified))
			to_chat(H, span_warning("这棵神圣古树已经不再是有效的施祝目标了。"))
			return FALSE

		var/turf/T = get_turf(wise_target)
		qdel(wise_target)

		var/obj/structure/flora/roguetree/wise/sanctified/wise/new_tree = new(T)
		playsound(T, 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
		H.visible_message(
			span_green("[H] 的双手燃起金色辉光，[new_tree] 就此完成圣化，这棵古树也将永远承受树父的抚触！"),
			span_notice("当这棵古树完成圣化时，我感到树父的力量流过了我的全身。")
		)
		SEND_SIGNAL(H, COMSIG_TREE_TRANSFORMED)
		if(H.mind)
			H.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
		return TRUE

	return FALSE

//==============================================================================
// Soulbind & dryad control spells (granted by Cat 7 soulbind ritual)
//==============================================================================

/// Summon (or unsummon) a lesser dryad bound to this player.
/// First cast: spawns the lesser dryad adjacent to the caster and tags it.
/// Second cast (if already summoned): qdels the dryad, returning it to the grove.
/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad
	name = "召唤小树妖"
	desc = "自林苑中唤出一只小树妖作为你的守护者。再次施放可将其送回。"
	overlay_state = "blesscrop"
	action_icon_state = "blessing"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 60
	recharge_time = 60 SECONDS
	chargetime = 1 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	associated_skill = /datum/skill/magic/holy
	invocations = list("树父，请借我你的守护者。")
	invocation_type = "whisper"
	/// Reference to the currently summoned lesser dryad.
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/conjured_dryad = null
	/// TRUE while the player is intentionally unsummoning the dryad.
	var/manual_unsummon = FALSE
	/// Absolute world.time when summon is allowed again after dryad death.
	var/death_cooldown_until = 0

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/Destroy()
	if(conjured_dryad && !QDELETED(conjured_dryad))
		UnregisterSignal(conjured_dryad, COMSIG_QDELETING)
	conjured_dryad = null
	return ..()

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/cast(list/targets, mob/user = usr)
	// Swap invocation text so the caster says the right chant for summon vs unsummon.
	invocations = (conjured_dryad && !QDELETED(conjured_dryad)) \
		? list("我的守护者啊，回到林苑中去吧！") \
		: list("树父，请借我你的守护者。")
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(world.time < death_cooldown_until)
		to_chat(H, span_warning("我与灵魂绑定之树的联系还不稳定。必须再等 [DisplayTimeText(death_cooldown_until - world.time)]，我才能召出下一只树妖。"))
		revert_cast()
		return FALSE

	// If already summoned, unsummon
	if(conjured_dryad && !QDELETED(conjured_dryad))
		manual_unsummon = TRUE
		conjured_dryad.visible_message(span_boldwarning("[conjured_dryad] dissolves back into the grove."))
		qdel(conjured_dryad)
		manual_unsummon = FALSE
		conjured_dryad = null
		to_chat(H, span_notice("我的树妖回到了林苑。"))
		return TRUE

	// Summon the lesser dryad
	var/turf/spawn_turf = null
	for(var/D in GLOB.alldirs)
		var/turf/adj = get_step(get_turf(H), D)
		if(adj && !isclosedturf(adj))
			spawn_turf = adj
			break
	if(!spawn_turf)
		to_chat(H, span_warning("这里没有足够的空间召唤树妖。"))
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = new(spawn_turf, H)
	conjured_dryad = D
	D.summoner_spell = src
	// Immediately follow the summoner on spawn.
	D.follow_target = H
	// Register cleanup if the dryad dies on its own
	RegisterSignal(D, COMSIG_QDELETING, PROC_REF(on_dryad_deleted))
	to_chat(H, span_green("一只小树妖自根须间现身，回应了我的呼唤。"))
	D.visible_message(span_notice("[D] takes form beside [H]."))
	return TRUE

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/proc/on_dryad_deleted(datum/source)
	if(!manual_unsummon)
		death_cooldown_until = max(death_cooldown_until, world.time + 2 MINUTES)
	conjured_dryad = null
	UnregisterSignal(source, COMSIG_QDELETING)

/// Triggers the lesser dryad's surge by activating a targeting cursor and clicking a location.
/obj/effect/proc_holder/spell/targeted/lesser_dryad_special
	name = "树妖突袭"
	desc = "激活后，用中键点击地面或生物，命令你的小树妖裹挟荆棘与藤蔓扑向那里。"
	overlay_state = "blesscrop"
	action_icon_state = "blessing"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 50
	recharge_time = 1 MINUTES
	chargetime = 0 SECONDS
	max_targets = 1
	cast_without_targets = FALSE
	associated_skill = /datum/skill/magic/holy
	invocations = list("缠住我的敌人，刺穿他们的脚底吧。林苑，苏醒！")
	invocation_type = "shout"
	range = 10

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/InterceptClickOn(mob/living/caller, params, atom/target)
	// Turfs are not intercepted by the parent targeted-spell logic; handle them directly.
	if(!isturf(target))
		. = ..()
		if(.)
			return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		deactivate(caller)
		return TRUE
	// Always normalise to the turf so surging onto an empty tile works.
	perform(list(get_turf(target) || target), TRUE, user = ranged_ability_user)
	deactivate(caller)
	return TRUE

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/cast(list/targets, mob/user = usr)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/atom/target = targets?.len ? targets[1] : null
	if(!target)
		return FALSE
	var/mob/living/carbon/human/H = user

	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = null
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad in view(14, H))
		if(dryad.conjurer_ckey == H.ckey)
			D = dryad
			break
	if(!D)
		to_chat(H, span_warning("我的树妖不在附近。"))
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf || isclosedturf(target_turf))
		to_chat(H, span_warning("树妖无法抵达那个位置。"))
		return FALSE

	if(D.ai_controller)
		D.ai_controller.CancelActions()
		D.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		D.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
	// For old-style AI mobs, clear the enemies list, lose current target, and set
	// non-aggressive so the dryad doesn't re-acquire an enemy mid-transit.
	D.enemies = list()
	D.target = null
	D.LoseTarget()
	D.aggressive = FALSE
	D.Goto(target_turf, D.move_to_delay, 1)
	addtimer(CALLBACK(src, PROC_REF(try_execute_surge), D, target_turf, H, 12), 0.5 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/proc/try_execute_surge(mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D, turf/target_turf, mob/living/carbon/human/user, attempts_left)
	if(QDELETED(D) || QDELETED(user) || !target_turf)
		return
	if(get_dist(D, target_turf) > 1)
		if(attempts_left <= 0)
			to_chat(user, span_warning("我的树妖无法抵达被命令前往的目标。"))
			return
		D.Goto(target_turf, D.move_to_delay, 1)
		addtimer(CALLBACK(src, PROC_REF(try_execute_surge), D, target_turf, user, attempts_left - 1), 0.5 SECONDS)
		return
	if(!D.dryad_surge(target_turf))
		to_chat(user, span_warning("我的树妖之力尚未恢复。"))

/mob/living/proc/try_handle_middle_targeted_spell(atom/target)
	return FALSE

/mob/living/carbon/human/try_handle_middle_targeted_spell(atom/target)
	return FALSE

/// Minion order subtype for controlling the lesser dryad companion.
/// Uses the standard minion_order cast+click targeting (same as primordials):
/// cast and click yourself to follow, a tile to guard there, or an enemy to attack.
/// Overrides process_minions() to drive the dryad's old-style simple_animal AI vars
/// (follow_target / guard_turf / enemies / target) instead of ai_controller blackboard keys.
/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad
	name = "命令树妖"
	desc = "命令你的小树妖。施法后点击自己可令其跟随，点击地面可令其守卫，点击敌人则会发动攻击。"
	faction_ordering = FALSE

/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad/process_minions(order_type, turf/target_location, mob/living/target, faction_tag)
	var/mob/living/carbon/human/caster = usr
	if(!caster?.mind)
		return
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = null
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad in oview(order_range, caster))
		if(faction_tag in dryad.faction)
			D = dryad
			break
	if(!D)
		to_chat(caster, span_warning("附近没有树妖可供指挥。"))
		return
	switch(order_type)
		if("goto")
			D.follow_target = null
			D.enemies = list()
			D.target = null
			D.LoseTarget()
			D.guard_turf = target_location
			walk(D, 0)
			D.aggressive = FALSE
			if("neutral" in D.faction)
				D.faction -= "neutral"
			to_chat(caster, span_notice("[D.name] 前去守住那个位置。"))
		if("follow")
			D.enemies = list()
			D.target = null
			D.LoseTarget()
			D.lastattacker_weakref = null
			D.ignore_owner_defense_until = world.time + 2 SECONDS
			D.follow_target = caster
			D.guard_turf = null
			D.aggressive = FALSE
			D.toggle_ai(AI_IDLE)
			walk_towards(D, caster, D.move_to_delay)
			if(!("neutral" in D.faction))
				D.faction += "neutral"
			to_chat(caster, span_notice("[D.name] 将会跟随我。"))
		if("attack")
			D.follow_target = null
			D.guard_turf = null
			walk(D, 0)
			D.enemies = list(target)
			D.target = target
			D.aggressive = FALSE
			if("neutral" in D.faction)
				D.faction -= "neutral"
			D.toggle_ai(AI_ON)
			D.Goto(get_turf(target), D.move_to_delay, 0)
			to_chat(caster, span_notice("[D.name] 朝着 [target.name] 猛冲而去！"))
		if("toggle_stance")
			// Clicking the dryad itself — toggle between follow and stand-ground.
			if("neutral" in D.faction)
				D.follow_target = null
				D.guard_turf = get_turf(D)
				D.faction -= "neutral"
				to_chat(caster, span_notice("[D.name] 原地据守。"))
			else
				D.follow_target = caster
				D.guard_turf = null
				D.enemies = list()
				D.target = null
				D.LoseTarget()
				D.lastattacker_weakref = null
				D.ignore_owner_defense_until = world.time + 2 SECONDS
				D.toggle_ai(AI_IDLE)
				D.faction += "neutral"
				walk_towards(D, caster, D.move_to_delay)
				to_chat(caster, span_notice("[D.name] 将会跟随我。"))
		if("aggressive")
			// Clicking an ally — send dryad to their tile as a guard position.
			D.follow_target = null
			D.enemies = list()
			D.target = null
			D.LoseTarget()
			D.guard_turf = get_turf(target)
			walk(D, 0)
			D.aggressive = FALSE
			if("neutral" in D.faction)
				D.faction -= "neutral"
			to_chat(caster, span_notice("[D.name] 朝着 [target.name] 所在的位置移动。"))

//==============================================================================
// Conjure Floral Seed — granted by Cat 10 Floral Conjuration ritual.
// Instant-cast self spell. Prompts the caster to choose a bush or flower seed,
// then places a conjured copy in their hand. Conjured seeds vanish if dropped.
//==============================================================================
/obj/effect/proc_holder/spell/self/conjure_floral_seed
	name = "造化花种"
	desc = "借助 登多尔 的力量在手中造出花种或灌木种。种子一旦掉落便会溶解；花种可在手中切换为不同子类型。冷却 30 秒。"
	overlay_state = "blesscrop"
	action_icon_state = "blessing"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	chargetime = 0 SECONDS
	recharge_time = 20 SECONDS
	associated_skill = /datum/skill/magic/druidic
	invocations = list("自深土之中，脆弱生命破土而生！树父，请赐我种子。")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/self/conjure_floral_seed/cast(mob/user = usr)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	var/list/options = list("花种", "灌木种")
	var/choice = input(H, "你要造出哪一种种子？", "造化花种") as null|anything in options
	if(isnull(choice) || QDELETED(H))
		return
	var/obj/item/seed
	if(choice == "灌木种")
		seed = new /obj/item/seeds/bush/conjured(get_turf(H))
	else
		seed = new /obj/item/seeds/flower/conjured(get_turf(H))
	if(!H.put_in_hands(seed))
		// put_in_hands returns null/FALSE when both hands are full — seed lands at feet.
		to_chat(H, span_warning("我的双手都满了，造出的种子掉落到脚边，随后溶解消散！"))
		// The conjured seed would qdel on Dropped, but it already spawned on floor:
		// force it away since Dropped() only fires on hand-drop, not on initial spawn.
		qdel(seed)
		return
	to_chat(H, span_notice("[seed.name] 在我手中凝现成形，轻轻搏动着树父的生命气息。"))

