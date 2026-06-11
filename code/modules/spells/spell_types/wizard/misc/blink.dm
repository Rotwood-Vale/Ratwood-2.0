/obj/effect/proc_holder/spell/invoked/blink
	name = "闪现"
	desc = "瞬移至你视野内的目标地点。最远 5 格。只能在与施术者相同的平面上生效。"
	school = "conjuration"
	cost = 3
	releasedrain = 30
	chargedrain = 1
	chargetime = 3
	recharge_time = 13 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE // Mobility spell
	spell_tier = 2
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "rune6"
	xp_gain = TRUE
	invocations = list("闪烁吧，传跃于此！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	var/max_range = 5
	var/phase = /obj/effect/temp_visual/blink

/obj/effect/temp_visual/blink
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	name = "传送魔法"
	desc = "快闪开！"
	randomdir = FALSE
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY

/obj/effect/temp_visual/blink/Initialize(mapload, new_caster)
	. = ..()
	var/turf/src_turf = get_turf(src)
	playsound(src_turf,'sound/magic/blink.ogg', 65, TRUE, -5)

/obj/effect/proc_holder/spell/invoked/blink/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	var/turf/start = get_turf(user)
	
	if(!T)
		to_chat(user, span_warning("目标地点无效！"))
		revert_cast()
		return

	if(T.teleport_restricted == TRUE)
		to_chat(user, span_warning("我无法传送到这里！"))

	if(T.z != start.z)
		to_chat(user, span_warning("我只能在同一平面上传送！"))

		revert_cast()
		return
	
	if(istransparentturf(T))
		to_chat(user, span_warning("我不能传送到露天处！"))
		revert_cast()
		return

	if(T.density)
		to_chat(user, span_warning("我不能传送进墙里！"))
		revert_cast()
		return

	// Check range limit
	var/distance = get_dist(start, T)
	if(distance > max_range)
		to_chat(user, span_warning("那个地点太远了！我最多只能闪现 [max_range] 格。"))
		revert_cast()
		return
	
	// Display a more obvious preparation message
	user.visible_message(span_warning("<b>[user]的身体开始因奥术能量而闪烁，[user.p_they()]正准备进行闪现！</b>"), 
						span_notice("<b>我凝聚奥术能量，准备穿越空间闪现！</b>"))
		
	// Check if there's a wall in the way, but exclude the target turf
	var/list/turf_list = getline(start, T)
	// Remove the last turf (target location) from the check
	if(length(turf_list) > 0)
		turf_list.len--
	
	for(var/turf/turf in turf_list)
		var/area/turf_area = get_area(turf)
		if(turf_area?.noteleport)
			to_chat(user, span_warning("这片区域不允许我传送！"))
			return
		if(turf.density)
			to_chat(user, span_warning("我无法穿墙闪现！"))
			revert_cast()
			return
			
	// Check for doors and bars in the path
	for(var/turf/traversal_turf in turf_list)
		// Check for mineral doors
		for(var/obj/structure/mineral_door/door in (traversal_turf.contents + T.contents))
			if(door.density)
				to_chat(user, span_warning("我无法穿门闪现！"))
				revert_cast()
				return
				
		// Check for windows
		for(var/obj/structure/roguewindow/window in (traversal_turf.contents + T.contents))
			if(window.density && !window.climbable)
				to_chat(user, span_warning("我无法穿窗闪现！"))
				revert_cast()
				return
				
		// Check for bars
		for(var/obj/structure/bars/bars in (traversal_turf.contents + T.contents))
			if(bars.density)
				to_chat(user, span_warning("我无法穿过栅栏闪现！"))
				revert_cast()
				return

		// Check for gates
		for (var/obj/structure/gate/gate in (traversal_turf.contents + T.contents))
			if(gate.density)
				to_chat(user, span_warning("我无法穿过闸门闪现！"))
				revert_cast()
				return

	var/obj/spot_one = new phase(start, user.dir)
	var/obj/spot_two = new phase(T, user.dir)

	spot_one.Beam(spot_two, "purple_lightning", time = 1.5 SECONDS)
	playsound(T, 'sound/magic/blink.ogg', 25, TRUE)

	if(user.buckled) // don't stay remote-buckled to the guillotine/pillory
		user.buckled.unbuckle_mob(user, TRUE)
	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)
	
	user.visible_message(span_danger("<b>[user]在一阵神秘的紫光中消失了！</b>"), span_notice("<b>我于刹那间穿梭空间完成闪现！</b>"))
	return TRUE
