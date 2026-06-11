/*
Grappling hook! Comes in 3 strict steps w/ unique intents: Grab -> Attach -> Reel.
Grab grabs onto a floor turf in range, only works for floors ABOVE the user.
Attach clasps a hook onto the chosen atom (obj / mob, has to be unanchored and not a structure or machinery)
Reel teleports the attached atom to the grabbed turf.
*/
#define GRAPPLER_ZUP 1
#define GRAPPLER_ZDOWN 2 
#define GRAPPLER_NOZ 3

/obj/item/grapplinghook
	name = "青铜抓钩发射器"
	desc = "矮人工业工程学最杰出的创新之一。用于在矿车难以通行的陡峭坑道中拖运木箱与桶子，也可对体型不算太大的人使用。\n在同一平面上的射程为 VI 格，跨平面的射程为 III 格。\n同一平面内的抓取会被任何致密物体阻挡。"
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "grappler_used"
	item_state = "grappler"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	possible_item_intents = list(/datum/intent/grapple, /datum/intent/attach, /datum/intent/reel)
	experimental_inhand = FALSE
	var/is_loaded = FALSE
	var/isloading = FALSE
	var/in_use = FALSE
	var/turf/grappled_turf
	var/atom/attached
	var/mutable_appearance/tile_effect
	var/mutable_appearance/target_effect
	var/max_range_z = 3
	var/max_range_noz = 6
	var/leash_range = 7
	var/list/obj_to_destroy = list()
	grid_height = 32
	grid_width = 64

/obj/item/grapplinghook/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)	//For preventing hooking / attaching something and walking away.


/obj/item/grapplinghook/Destroy()
	STOP_PROCESSING(SSobj, src)
	reset_tile()
	reset_target()
	return ..()

//Range check for both the tool itself and anything it has attached to the turf it's hooked to.
/obj/item/grapplinghook/process()
	if(in_use && grappled_turf)
		if(get_dist(grappled_turf, src) > leash_range)
			reset_tile()
			reset_target()
	if(grappled_turf && attached)
		if(get_dist(grappled_turf, attached) > leash_range)
			reset_tile()
			reset_target()

//Grappler intents. Not meant to be functional outside of the tool.
/datum/intent/grapple
	name = "抓取"
	icon_state = "ingrab"
	desc = "用于将钩爪射向一块开阔且无阻挡的地块。"
	no_attack = TRUE

/datum/intent/attach
	name = "附着"
	icon_state = "inattach"
	desc = "用于把目标挂到钩爪上以便卷回。目标不能太重、太大，也不能被固定。"
	no_attack = TRUE

/datum/intent/reel
	name = "卷回"
	icon_state = "inreel"
	desc = "用于将已挂上的目标卷回到抓住的地块处。"
	no_attack = TRUE

/obj/item/grapplinghook/examine()
	. = ..()
	if(is_loaded && !in_use)
		. += span_warning("它已准备就绪。对你上方的地块执行<b>抓取</b>即可。")
	else if(!is_loaded && !in_use)
		. += span_warning("它已经耗尽，必须重新装填。")
	else if(!is_loaded && grappled_turf && in_use)
		. += span_warning("它已部署。你现在可以把钩子<b>附着</b>到某个目标上。")
		. += span_info("我可以在手中启动它来重置。")
	if(attached && grappled_turf && in_use && !is_loaded)
		. += span_warning("它已准备就绪。你现在可以把[attached]<b>卷回</b>。")

/obj/item/grapplinghook/obj_break(damage_flag)
	reset_tile()
	reset_target()
	..()

/obj/item/grapplinghook/obj_destruction(damage_flag)
	reset_tile()
	reset_target()
	..()
	

/obj/item/grapplinghook/attack_self(mob/living/user)
	if(!is_loaded && !in_use && user.used_intent != /datum/intent/reel)
		var/stat = max(user.STASPD, user.STAPER)	//We check the PER / SPD stats first
		stat = stat - 10
		if(stat > 0)
			stat = stat * 3
			if(user.STASTR > 11)	//Then we add their strength if they had any of the previous
				stat += (user.STASTR - 10) * 2
		else
			stat = 0
		stat += (user.get_skill_level(/datum/skill/craft/engineering)) * 5	//And finally their Engineering level.
		stat = clamp(stat, 10, 70)	//Clamp to a very loud second just in case you're a superhuman engineer
		if(!isloading)
			user.visible_message(span_info("[user]开始转动[src]的摇柄……"))
			isloading = TRUE
			playsound(user, 'sound/misc/grapple_crank.ogg', 100, FALSE, 3)
			if(move_after(user, (70 - stat), FALSE, user))
				playsound(src, 'sound/foley/trap_arm.ogg', 100, FALSE , 5)
				to_chat(user, span_info("已经装填好了！"))
				isloading = FALSE
				is_loaded = TRUE
				update_icon()
			else
				isloading = FALSE
				user.visible_message(span_info("[user]被打断了！"))
	else if(istype(user.used_intent, /datum/intent/reel))	//Alternative to clicking on an empty tile. You can self-use it to reel instead.
		if(attached && in_use)
			if(get_dist(attached, grappled_turf) <= (user.z != grappled_turf.z ? max_range_z : max_range_noz))
				user.visible_message("[user]把[src]卷了回来！")
				if(do_after(user, 10))
					reel()
			else
				to_chat(user, span_info("[attached]太远了！"))
	else if(!is_loaded && in_use && grappled_turf && tile_effect)	//Reset option.
		user.visible_message("[user]把钩爪从地块上解开了。")
		reset_tile()
		reset_target()

//Resets the tile effect and the grappled turf. Generally called with reset_target()
/obj/item/grapplinghook/proc/reset_tile(silent = FALSE)
	if(tile_effect && grappled_turf)
		grappled_turf.cut_overlay(tile_effect)
		qdel(tile_effect)
		grappled_turf = null
	if(!silent)	//Silent is used during a successful reel because it has its own distinct sounds
		playsound(src, 'sound/foley/trap.ogg', 100, FALSE , 5)
	is_loaded = FALSE
	update_icon()

//Resets the target effect overlay and the attached atom. Generally called with reset_tile()
/obj/item/grapplinghook/proc/reset_target()
	if(attached && target_effect)
		attached.cut_overlay(target_effect)
		qdel(target_effect)
		attached = null
	in_use = FALSE
	update_icon()

/obj/item/grapplinghook/proc/check_path(turf/Tu, turf/Tt, state)
	var/dist = get_dist(Tt, Tu)
	var/last_dir
	var/turf/last_step
	switch(state)
		if(GRAPPLER_ZUP)
			last_step = get_step_multiz(Tu, UP)
		if(GRAPPLER_ZDOWN)
			last_step = get_step_multiz(Tu, DOWN)
		if(GRAPPLER_NOZ)
			last_step = Tu
	var/success = FALSE
	if(state == GRAPPLER_ZDOWN || state == GRAPPLER_ZUP)
		for(var/i = 0, i <= dist, i++)
			last_dir = get_dir(last_step, Tt)
			var/turf/Tstep = get_step(last_step, last_dir)
			if(!Tstep.density)
				success = TRUE
				var/list/cont = Tstep.GetAllContents()
				for(var/obj/structure/roguewindow/W in cont)
					if(W.climbable && !W.opacity)	//It's climable and can be seen through
						success = TRUE
						LAZYADD(obj_to_destroy, W)
						continue
					else if(!W.climbable)
						success = FALSE
						return success
				for(var/obj/structure/fluff/railing/fence/F in cont)
					if(F)
						success = FALSE
						return success
			else
				success = FALSE
				return success
			last_step = Tstep
	if(state == GRAPPLER_NOZ)
		success = TRUE
		var/list/visible = getline(Tu, Tt)
		for(var/turf/T in visible)
			if(T.opacity || T.density && T != Tu)	//Any dense or opaque turfs
				success = FALSE
				return success
			for(var/obj/O in (T.contents + Tt.contents))
				if(O)
					if(O.density || O.opacity)	//ANY dense or opaque objects. It's strict, but it's also a teleport, so. 
						success = FALSE
						return success
	return success

	

//Successful reel, complete reset.
/obj/item/grapplinghook/proc/reel()
	if(attached && in_use && grappled_turf)
		var/mob/living/grabber
		var/mob/living/grabby
		var/grapple_buckled
		if(isliving(attached))
			grabber = attached
			if(grabber && isliving(grabber.pulling))
				grabby = grabber.pulling
				if(grabby in grabber.buckled_mobs)
					grapple_buckled = TRUE
		if(do_teleport(attached, grappled_turf))
			if(grabby)
				do_teleport(grabby, grappled_turf)
				grabber.start_pulling(grabby, supress_message = TRUE)
				if(grapple_buckled) 
					if(grabby.mobility_flags & MOBILITY_STAND)	// piggyback carry
						grabber.buckle_mob(grabby, TRUE, TRUE, FALSE, 0, 0)
					else				// fireman carry
						grabber.buckle_mob(grabby, TRUE, TRUE, 90, 0, 0)
			playsound(attached, 'sound/misc/grapple_reel.ogg', 100, FALSE)
			playsound(grappled_turf, 'sound/misc/grapple_reel.ogg', 100, FALSE)
			destroy_eligible_objects()
			reset_tile(silent = TRUE)
			reset_target()
			unload(failure = TRUE)

/obj/item/grapplinghook/proc/destroy_eligible_objects()
	if(length(obj_to_destroy))
		for(var/obj/O in obj_to_destroy)
			if(istype(O,/obj/structure/roguewindow))
				var/obj/structure/roguewindow/W = O
				if(!W.climbable)
					O.obj_integrity = 1	//Keeps it from being destroyed
					O.obj_break()
		LAZYCLEARLIST(obj_to_destroy)

/obj/item/grapplinghook/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(user.used_intent, /datum/intent/grapple))	//First step, grappling onto a tile. Spawns an indicator on it.
		if(is_loaded && istype(target, /turf/))
			var/turf/T = target
			if(!istransparentturf(T) && !islava(T))
				if(T.z != user.z) //We are shooting at a floor turf above or below
					var/reason
					if(max_range_z >= get_dist(user, T) && !T.density)
						if(check_path(get_turf(user), T, T.z > user.z ? GRAPPLER_ZUP : GRAPPLER_ZDOWN))	//We check for opaque turfs or non-climbable windows in the way via a simple pathfind.
							to_chat(user, span_info("抓钩落在了那块地面上！"))
							grapple_to(T)
							attached = user
							return
						else
							to_chat(user, span_info("路径被挡住了！"))
							return
					else if(get_dist(user, T) > max_range_z)
						reason = "It's too far."
					else if (T.density)
						reason = "It's a wall!"
					to_chat(user, span_info("The hook fails! "+"[reason]"))
					playsound(user, 'sound/foley/trap.ogg', 100, FALSE , 5)
					unload(failure = TRUE)
				else if(T.z == user.z)
					if(max_range_noz >= get_dist(user, T) && !T.density)
						if(check_path(get_turf(user), T, GRAPPLER_NOZ))	//We check for opaque turfs and ANY dense objects in the way
							to_chat(user, span_info("抓钩落在了那块地面上！"))
							grapple_to(T)
							attached = user
							return
						else
							to_chat(user, span_info("路径被挡住了！"))
							return
			else
				to_chat(user, span_info("目标不正确！它需要一块空旷的地面来抓住。"))
		else if(!is_loaded)
			to_chat(user, span_info("它已经用过了。"))
	if(istype(user.used_intent, /datum/intent/attach))	//Second step. Once we have a turf we've grappled onto, we can use this to attach to an entity.
		if(in_use && !istype(target, /turf/))	//Can't use the feature unless it's grappled already
			var/safe_to_teleport = TRUE
			if(isobj(target))
				var/obj/O = target
				if(!istype(target, /obj/structure/closet/crate) && !istype(target, /obj/structure/fermentation_keg) && !istype(target, /obj/structure/handcart))	//We DO want to move crates, barrels & carts
					if(O.density || istype(target, /obj/structure) || O.anchored || istype(target, /obj/machinery)) //This should cover most (fingers crossed) objects that shouldn't be moved around like this.
						safe_to_teleport = FALSE
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(HAS_TRAIT(H, TRAIT_BIGGUY))	//Too fat.
					safe_to_teleport = FALSE
			if(safe_to_teleport)
				to_chat(user, span_info("我开始把钩子挂上去……"))
				if(do_after(user, 30))
					if(target != user)
						user.visible_message(span_warning("[user]把钩子挂到了[target]上。"))
					if(target == user)
						user.visible_message(span_warning("[user]把钩子挂到了自己身上！"))
					attach(target)
			else
				to_chat(user, span_warning("[target]太大或太难摆弄，没法挂上去！"))
		else
			to_chat(user, span_info("我得先把它钩到一块地面上。"))
	if(istype(user.used_intent, /datum/intent/reel))	//Last step, we reel in the attached entity to the grappled turf.
		if(attached && in_use)
			if(get_dist(attached, grappled_turf) <= (user.z != grappled_turf.z ? max_range_z : max_range_noz))
				user.visible_message("[user]卷回了[src]！")
				if(do_after(user, 10))
					reel()
			else
				to_chat(user, span_info("[target]太远了！"))
		else
			to_chat(user, span_info("我得先挂上某个目标。"))
	. = ..()

//Attaches a hook to an atom. Used with the "ATTACH" intent.
/obj/item/grapplinghook/proc/attach(atom/A)
	if(A && !isturf(A))
		if(target_effect && attached)
			attached.cut_overlay(target_effect)
			qdel(target_effect)
		playsound(A,'sound/misc/grapple_attach.ogg', 100, FALSE, 5)
		attached = A
		target_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "aimwarn", layer = 20)
		attached.add_overlay(target_effect)

//Hooks onto a turf. Used with the "GRAB" intent.
/obj/item/grapplinghook/proc/grapple_to(turf/T)
	unload()
	playsound(T, 'sound/misc/grapple_land.ogg', 100, FALSE, 5)
	tile_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "hooked_tile", layer = 18)
	grappled_turf = T
	grappled_turf.add_overlay(tile_effect)

//Reloads the grappler.
/obj/item/grapplinghook/proc/load()
	is_loaded = TRUE
	in_use = FALSE
	update_icon()

//Unloads the grappler after a successful, or not, attempt to use on a turf.
/obj/item/grapplinghook/proc/unload(failure)
	if(!failure)
		is_loaded = FALSE
		in_use = TRUE
	else
		is_loaded = FALSE
		in_use = FALSE
	update_icon()

/obj/item/grapplinghook/update_icon()
	. = ..()
	if(is_loaded && !in_use)
		icon_state = "grappler"
	else if(!is_loaded && !in_use)
		icon_state = "grappler_used"
	else if(!is_loaded && in_use)
		icon_state = "grappler_inuse"
