/obj/item/leechtick
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "leechtick"
	name = "水蛭蜱"
	desc = "一种来自 阿比索尔 神圣之海、受 佩斯特拉 影响的入侵生物。众所周知，它们会附着在海中巨兽的尸骸上。它们不只是害虫，任何惊扰它们的人都会被吸走灵魂与灵辉。"
	// Don't lower the size, they'll make effective throwing weapons otherwise.
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/leechtick_bloated
	icon_state = "leechthick"
	icon = 'icons/obj/structures/heart_items.dmi'
	name = "胀满水蛭蜱"
	desc = "这只水蛭蜱饱食灵辉，并已将其消化。疯子也许会拿它去复生……"
	sellprice = 40
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.85

/obj/item/leechtick/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	if(isliving(target) && do_after(user, 2 SECONDS, FALSE, target))
		try_attach(target, user)

/obj/item/leechtick/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(isliving(hit_atom))
		try_attach(hit_atom)

/obj/item/leechtick/proc/try_attach(mob/living/target, mob/user)
	// Don't attach to dead things
	if(!SSchimeric_tech.get_node_status("CORPSE_TICKS") && target.stat == DEAD)
		return FALSE

	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		return FALSE

	var/datum/component/leechtick_attachment/existing = target.GetComponent(/datum/component/leechtick_attachment)
	if(existing)
		return FALSE

	if(target.cmode && prob(66))
		target.visible_message(
			span_warning("[src]从[target]身上弹开了！"),
			span_notice("[src]从你身上弹开了，你反抗得太凶，它根本咬不上来！")
		)
		return FALSE

	// Add the component to the target
	var/datum/component/leechtick_attachment/attachment = target.AddComponent(/datum/component/leechtick_attachment, type)
	if(!attachment)
		return FALSE

	if(user)
		user.visible_message(
			span_warning("[user]把[src]贴到了[target]身上！"),
			span_notice("你把[src]贴到了[target]身上。")
		)
	else
		target.visible_message(span_warning("[src]一下咬住了[target]！"))

	// Delete the item now that it's attached as a component
	qdel(src)
	return TRUE

/datum/component/leechtick_attachment
	var/leechtick_type
	var/full_leechtick_type = /obj/item/leechtick_bloated
	var/mutable_appearance/attachment_overlay
	var/detach_timer
	var/zone_switch_timer
	var/current_zone
	var/static/list/possible_zones = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/component/leechtick_attachment/Initialize(leechtick_type)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

	src.leechtick_type = leechtick_type

	attachment_overlay = mutable_appearance('icons/obj/structures/heart_items.dmi', "leechsuck")
	update_overlay()

	detach_timer = addtimer(CALLBACK(src, PROC_REF(on_full)), 1 MINUTES, TIMER_STOPPABLE)
	switch_zone()
	playsound(parent, 'sound/vo/mobs/spider/speak (1).ogg', 40)

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_LIVING_GRAB_SELF_ATTEMPT, PROC_REF(on_grab_self_attempt))

/datum/component/leechtick_attachment/Destroy()
	// Clean up timers
	if(detach_timer)
		deltimer(detach_timer)
	if(zone_switch_timer)
		deltimer(zone_switch_timer)

	var/mob/living/L = parent
	if(L && attachment_overlay)
		L.cut_overlay(attachment_overlay)

	return ..()

/datum/component/leechtick_attachment/proc/update_overlay()
	var/mob/living/L = parent
	if(!L || !attachment_overlay)
		return

	var/mutable_appearance/old_overlay_ref = attachment_overlay
	attachment_overlay = mutable_appearance('icons/obj/structures/heart_items.dmi', attachment_overlay.icon_state)
	attachment_overlay.icon_state = old_overlay_ref.icon_state
	L.cut_overlay(old_overlay_ref)

	switch(current_zone)
		if(BODY_ZONE_HEAD)
			attachment_overlay.pixel_x = -1
			attachment_overlay.pixel_y = 12
			attachment_overlay.icon_state = "leechsuck"
		if(BODY_ZONE_CHEST)
			attachment_overlay.pixel_x = -1
			attachment_overlay.pixel_y = 0
			attachment_overlay.icon_state = "leechsuck"
		if(BODY_ZONE_L_ARM)
			attachment_overlay.pixel_x = -8
			attachment_overlay.pixel_y = 0
			attachment_overlay.icon_state = "leechsuck_left"
		if(BODY_ZONE_R_ARM)
			attachment_overlay.pixel_x = 8
			attachment_overlay.pixel_y = 0
			attachment_overlay.icon_state = "leechsuck_right"
		if(BODY_ZONE_L_LEG)
			attachment_overlay.pixel_x = -4
			attachment_overlay.pixel_y = -8
			attachment_overlay.icon_state = "leechsuck_left"
		if(BODY_ZONE_R_LEG)
			attachment_overlay.pixel_x = 4
			attachment_overlay.pixel_y = -8
			attachment_overlay.icon_state = "leechsuck_right"

	L.add_overlay(attachment_overlay)
	L.update_icon()

/datum/component/leechtick_attachment/proc/switch_zone()
	if(!parent)
		return
	var/mob/living/L = parent
	if(prob(25))
		to_chat(L, span_notice("水蛭蜱在我身上飞快乱爬！"))
	L.adjustBruteLoss(1, 0)
	current_zone = pick(possible_zones)
	update_overlay()
	zone_switch_timer = addtimer(CALLBACK(src, PROC_REF(switch_zone)), rand(10, 40), TIMER_STOPPABLE)

/datum/component/leechtick_attachment/proc/on_full()
	if(!parent)
		return
	safe_detach()

/datum/component/leechtick_attachment/proc/safe_detach()
	if(!parent)
		return
	var/mob/living/L = parent
	if(!L.has_status_effect(/datum/status_effect/debuff/devitalised) && !L.has_status_effect(/datum/status_effect/debuff/revived) && !L.has_status_effect(/datum/status_effect/debuff/leech_schizophrenia))
		L.visible_message(span_notice("水蛭蜱从[L]身上脱落，看起来饱足而满足。"))
		new full_leechtick_type(get_turf(L))
		L.apply_status_effect(/datum/status_effect/debuff/devitalised)
	else
		L.visible_message(span_notice("水蛭蜱从[L]身上脱落，看起来和先前没什么两样。"))
		new leechtick_type(get_turf(L))

	playsound(parent, 'sound/vo/mobs/spider/pain.ogg', 40)
	L.cut_overlay(attachment_overlay)
	qdel(src)

/datum/component/leechtick_attachment/proc/on_examine(source, mob/living/examiner, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_warning("一只水蛭蜱正附着在[examiner == parent ? "你" : "对方"]身上！")

/datum/component/leechtick_attachment/proc/on_grab_self_attempt(mob/living/source, mob/living/target, zone, params)
	SIGNAL_HANDLER
	// Only handle self-grabs on the correct zone
	if(source != parent || target != parent || zone != current_zone)
		return

	var/mob/living/L = parent
	if(!L.used_intent || !istype(L.used_intent, /datum/intent/grab))
		return
	L.visible_message(
		span_warning("[L]开始试着扯下那只水蛭蜱！"),
		span_notice("你开始试着扯下那只水蛭蜱......")
	)

	// Use global do_after with callback instead of sleeping in signal handler
	INVOKE_ASYNC(src, PROC_REF(start_removal_async), L)
	return COMPONENT_CANCEL_GRAB_ATTACK

/datum/component/leechtick_attachment/proc/start_removal_async(mob/living/L)
	// This runs in its own thread, so do_after is safe here
	if(move_after(L, 1 SECONDS, target = L))
		// Call back to the component to complete the removal
		complete_removal()

/datum/component/leechtick_attachment/proc/complete_removal()
	var/mob/living/L = parent
	if(!L)
		return

	L.visible_message(
		span_warning("[L]成功扯下了那只水蛭蜱！"),
		span_notice("你成功扯下了那只水蛭蜱。")
	)

	if(leechtick_type)
		new leechtick_type(get_turf(L))
	L.cut_overlay(attachment_overlay)
	qdel(src)

/atom/movable/screen/alert/status_effect/debuff/leech_schizophrenia
	name = "耳畔回响"
	desc = "你听见了不属于自己的微弱低语。你的心神变得紊乱而不安。"

/datum/status_effect/debuff/leech_schizophrenia
	id = "leech_schizophrenia"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/leech_schizophrenia
	duration = 10 SECONDS

	var/message_cooldown = 4 MINUTES
	var/current_cooldown = 0
	var/list/creepy_msgs = list(
		span_italics("你感觉有什么存在正沉入你的脑海深处。'还......不够......'"),
		span_warning("你感觉自己的脑中仿佛灌满了沉重而黏滑的浆液......"),
		span_userdanger("寂静被一阵低沉而执拗的咔哒声打破，只有你能听见。"),
		span_italics("有那么一瞬间，你自己的影子似乎在脱离你独自移动。"),
		span_warning("你忽然怀疑起自己为何正拿着手里的东西，整个世界也在那一刻显得不太对劲。"),
		span_italics("一个像湿沙摩擦般的声音问道：'为什么？'")
	)
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -2, STATKEY_CON = -2, STATKEY_SPD = -1, STATKEY_INT = -1)

/datum/status_effect/debuff/leech_schizophrenia/on_creation(mob/living/new_owner, ...)
	. = ..()

	duration = rand(14 MINUTES, 28 MINUTES)
	current_cooldown = world.time + message_cooldown
	return .

/datum/status_effect/debuff/leech_schizophrenia/tick()
	. = ..()

	if(world.time >= current_cooldown)
		send_creepy_message()
		current_cooldown = world.time + message_cooldown

/datum/status_effect/debuff/leech_schizophrenia/proc/send_creepy_message()
	var/mob/living/L = owner
	if(!L)
		return
	to_chat(L, pick(creepy_msgs))
