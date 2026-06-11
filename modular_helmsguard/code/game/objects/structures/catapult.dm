/obj/structure/catapult
	name = "攻城投石机"
	desc = "一台古老的攻城器械，可将投射物抛向远方。"
	icon = 'modular_helmsguard/icons/obj/structure/catapult.dmi'
	icon_state = "catapult_ready"
	anchored = 1
	density = 1
	drag_slowdown = 7
	var/fire_distance = 0
	var/min_distance = 20
	var/max_distance = 65
	var/xoffset = 0
	var/yoffset = 0
	var/travel_time = 50
	//var/obj/item/boulder/current_projectile = null
	var/packed = 0
	var/busy = 0
	var/ready = 1
	var/loaded = 0
	var/list/choices = list("发射！", "设置朝向", "设置目标距离", "收拢")

/*/obj/structure/catapult/examine(mob/user)
	. = ..()
	. += "It is set to [angle] degrees facing [dir2text(dir)]"*/

/obj/structure/catapult/update_icon()
	cut_overlays()
	if(ready)
		icon_state = "catapult_ready"
	else
		icon_state = "catapult_launch"
/*	if(loaded && ready)
		add_overlay("boulder", HIGH_OBJ_LAYER)
	else
		cut_overlays()
		update_overlays()
*/

/obj/structure/catapult/proc/check_obstruction(mob/living/carbon/user)
	var/turf/T = get_turf(src)
	if(istype(T, /turf/open/floor) && T.z > src.z)
		to_chat(user, "<span class='warning'>投石机正上方有东西挡住了它。</span>")
		return 1
	return 0

/obj/structure/catapult/attack_hand(mob/living/carbon/user)
	// Check if the catapult is loaded
	if (packed) // Check if the catapult is packed
		// Provide a message indicating it cannot be used
		user.visible_message("<span class='notice'>投石机当前处于收拢状态，无法使用。</span>")
		return // Exit the proc early since no further action can be taken

	if(busy)
		to_chat(user, "<span class='warning'>现在有别人在使用这台器械。</span>")
		return
	// Provide choices to the user
	if(!ready)
		user.visible_message("<span class='notice'>[user] 将投石机的抛臂重新摇回原位。</span>")
		playsound(src, "modular_helmsguard/sound/catapult/adjusting.ogg", 100)
		if(do_after(user, 30, src))
			ready = 1
			update_icon()
			user.visible_message("<span class='notice'>投石机已准备好再次发射。</span>")
			to_chat(user, "<span class='warning'>投石机里已经装有投射物了。</span>")
		return

	if(ready && !packed)
		var/choice_unpacked = input("你想对投石机做什么？", "投石机操作") in choices
		switch(choice_unpacked)
			if ("发射！")
				if (check_obstruction(src))  // Check for obstruction
					return // Don't proceed if obstructed
				if (!loaded)
					to_chat(user, "<span class='warning'>投石机还没有装填。</span>")
					return
				if(fire_distance == 0)
					to_chat(user, "<span class='warning'>[src] 需要先完成瞄准。</span>")
					return
				else
					fire_catapult(user) // Pass the distance to fire_catapult
			if ("设置朝向")
				var/current_direction = dir
				var/list/directionlist = list("北" = "NORTH", "南" = "SOUTH", "东" = "EAST", "西" = "WEST")
				var/direction_choice = input("方向", "选择一个方向") as anything in directionlist
				var/direction = directionlist[direction_choice]
				var/texttodirection = text2dir(direction)
				if(busy)
					to_chat(user, "<span class='warning'>现在有别人在使用这台投石机。</span>")
					return
				playsound(src, pick("modular_helmsguard/sound/catapult/aim.ogg", "modular_helmsguard/sound/catapult/aim2.ogg"),  100)
				user.visible_message("<span class='notice'>[user] 试着将 [src] 转向 [direction]。</span>")
				if(texttodirection != current_direction)
					busy = 1
					if(do_after(user, 30, src))
						dir = texttodirection
						user.visible_message("<span class='notice'>[user] 将 [src] 的发射方向设为 [direction]。</span>",
						"<span class='notice'>你完成了 [src] 的发射方向调整。</span>")
						busy = 0
					else
						user.visible_message("<span class='notice'>[src] 本来就朝向 [direction]。</span>")
						busy = 0
						return
				else
					busy = 0
			if ("设置目标距离")
				var/distance_input = input("设置轰击目标距离。", "格") as num
				if(distance_input>max_distance)
					to_chat(user, "<span class='warning'>投石机最远只能发射到 [max_distance] 格。</span>")
					return
				if(distance_input<min_distance)
					to_chat(user, "<span class='warning'>射程最少也要有 [min_distance] 格。</span>")
					return
				else
					busy = 1
					playsound(src, pick("modular_helmsguard/sound/catapult/aim.ogg", "modular_helmsguard/sound/catapult/aim2.ogg"),  100)
					user.visible_message("<span class='notice'>[user] 开始设置 [src] 的发射距离。</span>")
					if(do_after(user, 30, src))
						fire_distance = distance_input
						user.visible_message("<span class='notice'>[user] 将 [src] 的发射距离设为 [fire_distance] 格。</span>")
						busy = 0
					else
						busy = 0
						return
			if ("收拢")
				user.visible_message("<span class='notice'>[user] 开始收拢投石机。</span>")
				busy = 1
				playsound(src, "modular_helmsguard/sound/catapult/adjusting.ogg", 100)
				if(do_after(user, 10 SECONDS, target = src))
					user.visible_message("<span class='notice'>[user] 已将投石机收拢好，便于移动。</span>")
					anchored = 0
					packed = 1
					fire_distance = 0
					busy = 0
				else
					busy = 0
					return
	else
		return

/obj/structure/catapult/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) && (packed) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		visible_message(span_notice("[usr] 架设好了 [src]。"))
		playsound(src, "modular_helmsguard/sound/catapult/adjusting.ogg",  100)
		if(do_after(usr, 10 SECONDS, target = src))
			anchored = 1
			packed = 0

/obj/structure/catapult/attackby(obj/item/boulder/O, mob/living/carbon/user)

	if(istype(O, /obj/item/boulder))
		if(!ready)
			to_chat(user, "<span class='warning'>投石机的抛臂需要重新拉回。</span>")
			return
		if(loaded)
			to_chat(user, "<span class='warning'>投石机里已经装有投射物了。</span>")
			return

		user.dropItemToGround(O, src)
		O.forceMove(src)
		loaded = 1
		user.visible_message("<span class='notice'>[user] 将 [O.name] 装入投石机。</span>")
		playsound(src, 'sound/foley/hit_rock.ogg', 100)
		// Optional: Remove the projectile from the world to show it's loaded
		O.loc = src // Keeps it "inside" the catapult
		update_icon()
		return


/obj/structure/catapult/proc/fire_catapult(mob/living/carbon/user)
	var/launchsound = list("modular_helmsguard/sound/catapult/launch.ogg", "modular_helmsguard/sound/catapult/launch2.ogg", "modular_helmsguard/sound/catapult/launch3.ogg")
	xoffset = rand(-8, 8)
	yoffset = rand(-8, 8)
	var/turf/targetx = get_ranged_target_turf(src, dir, fire_distance).x
	var/turf/targety = get_ranged_target_turf(src, dir, fire_distance).y
	var/turf/T = locate(targetx + xoffset, targety + yoffset, src.z)

	if(!isturf(T))
		for(var/turf/O in range(2,T))
			T = O
			continue
/*
		to_chat(user, "<span class='warning'>You cannot fire [src] to this target.</span>")
		return*/
	if (ready)
		playsound(src, pick(launchsound), 100)
		spawn(10)
			var/obj/item/boulder/P = /obj/item/boulder
//			var/atom/target = get_edge_target_turf(src, dir)
			user.visible_message("<span class='notice'>你发射了投石机！</span>")
			loaded = 0
			ready = 0
		// Adjust `distance_input` with a random variation
		//	var/random_distance = distance_input + rand(-5, 5)
			var/z_position = src.z + 1 // Start one level above the catapult
			// Apply random offsets to target position for x and y directions

/*			if (!isturf(locate(src.x, src.y, z_position)))
			z_position = src.z // If no z-level above, stay on the current z-level
			if (!target) // Confirm target validity
			to_chat(user, "<span class='warning'>No valid target found!</span>")
			return*/
			for(var/atom/movable/AM in src)
				qdel(AM)
			new P(locate(src.x, src.y, z_position))

			for(P in (locate(src.x, src.y, z_position)))
				P.launched = TRUE
				P.throw_at(get_turf(T), get_dist(src, T), 3)
				P.travel_time = get_dist(P, src)

			cut_overlays()
			update_icon()
			update_overlays()

/obj/structure/catapult/attack_right(mob/user)
	. = ..()
	if(loaded)
		unload_projectile()
		playsound(loc, 'sound/foley/cartdump.ogg', 100, FALSE, -1)
		user.visible_message("<span class='notice'>[user] 卸下了投石机中的弹药。</span>")
		src.loaded = 0
		update_icon()

/obj/structure/catapult/proc/unload_projectile(mob/living/carbon/user)
	// Code to handle unloading logic

	var/atom/L = drop_location()
	var/atom/movable/AM
	for(AM in src)
		AM.forceMove(L)
	playsound(src, 'sound/foley/hit_rock.ogg', 100)
	src.loaded = 0
	// Additional unloading logic...

/obj/item/boulder
	name = "巨石"
	icon = 'modular_helmsguard/icons/obj/structure/cata_ammo.dmi'
	icon_state = "b-1"
	w_class = 5
	var/launched = FALSE
	var/travel_time = 0
	var/incoming = list('modular_helmsguard/sound/catapult/incoming.ogg', 'modular_helmsguard/sound/catapult/incoming2.ogg', 'modular_helmsguard/sound/catapult/incoming3.ogg')


/obj/item/boulder/Initialize(mapload)
	. = ..()
	icon_state = "b-[rand(1,3)]"



/*/obj/item/boulder/flying
	icon = 'modular_helmsguard/icons/obj/structure/cata_ammo.dmi'
	icon_state = "boulder"*/


/obj/item/boulder/Bump(atom/A)
	if(launched)
		playsound(get_turf(src), pick(incoming), 100, FALSE)
		spawn(travel_time * 6)
			explosion(get_turf(src), 1, -1, 2, 0)
			do_shrapnel_effect(get_turf(src))
			qdel(src)

/obj/item/boulder/onZImpact(turf/T, levels)
	if(launched)
		playsound(get_turf(src), pick(incoming), 100, FALSE)
		spawn(travel_time * 6)
			explosion(get_turf(src), 1, -1, 2, 0)
			do_shrapnel_effect(get_turf(src))

			qdel(src)

/obj/item/boulder/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(launched)
		if(!istype(hit_atom, /turf/open/space))
			playsound(get_turf(src), pick(incoming), 100, FALSE)
			spawn(travel_time * 6)
				explosion(get_turf(src), 1, -1, 2, 0)
				do_shrapnel_effect(get_turf(src))
				qdel(src)

/obj/item/boulder/proc/do_shrapnel_effect(atom/target)
	// Create a shrapnel component for this instance of the boulder
	var/datum/component/shrapnel/shrapnel_effect = new /datum/component/shrapnel()
	var/turf/origin_turf = get_turf(src)
	var/boomchannel = SSsounds.random_available_channel()
	var/sound/far_explosion_sound = sound(pick('modular_helmsguard/sound/catapult/explosion_distant.ogg',
	'modular_helmsguard/sound/catapult/explosion_distant2.ogg','modular_helmsguard/sound/catapult/explosion_distant3.ogg', 'modular_helmsguard/sound/catapult/explosion_distant4.ogg'))
	shrapnel_effect.projectile_type = /obj/projectile/rock_shard // Define the type of shrapnel
	shrapnel_effect.radius = 3 // Define the explosion radius
	shrapnel_effect.override_projectile_range = 5 // Optional: specify the max range of each projectile
	shrapnel_effect.do_shrapnel(src, target) // Activate shrapnel
	for(var/mob/M in urange(20, src))
		if(!M.stat)
			shake_camera(M, 3, 1)
	for(var/mob/living/L in range(6, src))
		if(!L.stat)
			L.Knockdown(1)
			L.Jitter(30)
	for(var/mob/living/player in GLOB.player_list)
		var/distance = get_dist(player, origin_turf)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue
		if(distance > 20)
			player.playsound_local(get_turf(player), far_explosion_sound, 100, FALSE, pressure_affected = FALSE, channel = boomchannel)

/obj/projectile/rock_shard
	name = "石片"
	icon_state = "bullet"
	damage = 15
	range = 8
	pass_flags = PASSTABLE | PASSGRILLE
	armor_penetration = 15
	damage_type = BRUTE
	nodamage = FALSE
	embedchance = 20
	woundclass = BCLASS_BLUNT
	flag = "bullet"
	hitsound_wall = "ricochet"
	speed = 2
	impact_effect_type = /obj/effect/temp_visual/impact_effect
