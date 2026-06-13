#define ENDLESS_MAGIC_ARROW_CAP 10

/obj/effect/proc_holder/spell/self/endless_magic_arrows
	name = "无尽魔矢"
	desc = "极快地在手中凝聚一支限时存在的魔矢。最多同时维持十支魔矢，每支魔矢会在一分钟后自行溃散。"
	action_icon = 'icons/roguetown/weapons/ammo.dmi'
	action_icon_state = "arrow"
	overlay_state = "arrow"
	sound = list('sound/magic/whiteflame.ogg')
	releasedrain = 2
	chargedrain = 0
	chargetime = 0
	recharge_time = 0.6 SECONDS
	cooldown_min = 0.2 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 0
	chargedloop = null
	invocations = list("魔矢，凝形！")
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/arcane
	cost = 1
	spell_tier = 1
	miracle = FALSE

	var/list/active_arrow_refs = list()
	var/arrow_cap = ENDLESS_MAGIC_ARROW_CAP
	var/arrow_type = /obj/item/ammo_casing/caseless/rogue/arrow/magic
	var/arrow_group_id

/obj/effect/proc_holder/spell/self/endless_magic_arrows/cast(list/targets, mob/living/user = usr)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	if(user.get_num_arms() <= 0)
		to_chat(user, span_warning("我没有能接住魔矢的手。"))
		revert_cast()
		return FALSE

	cleanup_active_arrows()
	if(length(active_arrow_refs) >= arrow_cap)
		to_chat(user, span_warning("我维持的魔矢已到上限，得先让旧的魔矢消散。"))
		revert_cast()
		return FALSE

	var/obj/item/ammo_casing/caseless/rogue/arrow/magic/new_arrow = new arrow_type(user.drop_location())
	if(!user.put_in_hands(new_arrow))
		to_chat(user, span_warning("我的手必须空出来，才能接住新凝聚的魔矢。"))
		qdel(new_arrow)
		revert_cast()
		return FALSE

	if(!arrow_group_id)
		arrow_group_id = "\ref[src]"
	new_arrow.bind_magic_group(arrow_group_id)

	// 用弱引用追踪限时魔矢，只统计当前仍存在的箭矢，确保上限稳定。
	active_arrow_refs += WEAKREF(new_arrow)
	user.visible_message(span_notice("[user]的掌中凝出一支泛着淡蓝辉光的魔矢。"), span_notice("一支魔矢在我的手中凝聚成形。"))
	return TRUE

/obj/effect/proc_holder/spell/self/endless_magic_arrows/proc/cleanup_active_arrows()
	if(!arrow_group_id)
		active_arrow_refs.Cut()
		return

	var/list/valid_refs = list()
	// 通过法术实例分组标记重新搜集所有魔矢，确保射出后落地的魔矢也会继续计入上限与回收。
	for(var/obj/item/ammo_casing/caseless/rogue/arrow/magic/magic_arrow in world)
		if(magic_arrow.magic_arrow_group_id != arrow_group_id)
			continue
		if(QDELETED(magic_arrow) || !magic_arrow)
			continue
		valid_refs += WEAKREF(magic_arrow)

	active_arrow_refs = valid_refs

/obj/effect/proc_holder/spell/self/endless_magic_arrows/proc/recycle_active_arrows(mob/living/user)
	cleanup_active_arrows()
	if(!length(active_arrow_refs))
		if(user)
			to_chat(user, span_warning("我现在没有可回收的魔矢。"))
		return FALSE

	var/recycled_count = 0
	// 逐个删除仍存在的魔矢，并清空追踪列表，确保计数和上限立即同步。
	for(var/datum/weakref/arrow_ref as anything in active_arrow_refs)
		var/obj/item/ammo_casing/caseless/rogue/arrow/magic/magic_arrow = arrow_ref?.resolve()
		if(QDELETED(magic_arrow) || !magic_arrow)
			continue
		recycled_count++
		qdel(magic_arrow)

	active_arrow_refs.Cut()
	if(user)
		user.visible_message(span_notice("[user]轻轻一引，四散的魔矢便化作淡蓝色流光归于虚无。"), span_notice("我将维持中的魔矢尽数回收，令它们重新散作奥术流光。"))
	return recycled_count > 0

/obj/effect/proc_holder/spell/self/endless_magic_arrows/Destroy()
	// 授予法术被移除时，同步清掉仍由该法术维持的魔矢，避免重新装备后重置上限统计。
	cleanup_active_arrows()
	for(var/datum/weakref/arrow_ref as anything in active_arrow_refs)
		var/obj/item/ammo_casing/caseless/rogue/arrow/magic/magic_arrow = arrow_ref?.resolve()
		if(QDELETED(magic_arrow) || !magic_arrow)
			continue
		qdel(magic_arrow)
	active_arrow_refs = null
	arrow_group_id = null
	return ..()

/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted
	var/datum/weakref/source_quiver_ref

/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted/proc/bind_source_quiver(obj/item/quiver/magic/source_quiver)
	source_quiver_ref = WEAKREF(source_quiver)

/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted/proc/get_source_quiver()
	return source_quiver_ref?.resolve()

/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted/Destroy()
	source_quiver_ref = null
	return ..()

/obj/effect/proc_holder/spell/self/recycle_magic_arrows
	name = "回收魔矢"
	desc = "将目前维持着的所有魔矢回收为散逸的奥术流光。"
	action_icon = 'icons/roguetown/weapons/ammo.dmi'
	action_icon_state = "quiver0"
	overlay_state = "quiver0"
	sound = list('sound/magic/whiteflame.ogg')
	releasedrain = 1
	chargedrain = 0
	chargetime = 0
	recharge_time = 0.6 SECONDS
	cooldown_min = 0.2 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 0
	chargedloop = null
	invocations = list("流矢，回环。")
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/arcane
	cost = 1
	spell_tier = 1
	miracle = FALSE

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/cast(list/targets, mob/living/user = usr)
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/obj/effect/proc_holder/spell/self/endless_magic_arrows/endless_spell = find_linked_endless_spell(user)
	if(!endless_spell)
		to_chat(user, span_warning("我感应不到与这道术式相连的魔矢。"))
		revert_cast()
		return FALSE
	// 回收改为需要短暂持续引导，期间若移动或被打断则不会生效。
	user.visible_message(span_notice("[user]抬手引动周围残留的奥术轨迹，开始回收散落的魔矢。"), span_notice("我开始牵引四周魔矢留下的奥术痕迹，准备将它们尽数回收。"))
	if(!do_after(user, 3 SECONDS, target = user))
		to_chat(user, span_warning("我的引导被打断了，未能成功回收魔矢。"))
		revert_cast()
		return FALSE
	if(!endless_spell.recycle_active_arrows(user))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/proc/find_linked_endless_spell(mob/living/carbon/human/user)
	if(!user?.mind)
		return null

	var/obj/item/quiver/magic/source_quiver = get_source_quiver()
	for(var/obj/effect/proc_holder/spell/self/endless_magic_arrows/endless_spell as anything in user.mind.spell_list)
		if(source_quiver && istype(endless_spell, /obj/effect/proc_holder/spell/self/endless_magic_arrows/granted))
			var/obj/effect/proc_holder/spell/self/endless_magic_arrows/granted/granted_endless = endless_spell
			if(granted_endless.get_source_quiver() != source_quiver)
				continue
		return endless_spell
	return null

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/proc/get_source_quiver()
	return null

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted
	var/datum/weakref/source_quiver_ref

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted/proc/bind_source_quiver(obj/item/quiver/magic/source_quiver)
	source_quiver_ref = WEAKREF(source_quiver)

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted/get_source_quiver()
	return source_quiver_ref?.resolve()

/obj/effect/proc_holder/spell/self/recycle_magic_arrows/granted/Destroy()
	source_quiver_ref = null
	return ..()

#undef ENDLESS_MAGIC_ARROW_CAP
