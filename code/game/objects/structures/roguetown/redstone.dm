GLOBAL_LIST_EMPTY(redstone_objs)


/obj/structure
	var/redstone_structure = FALSE //If you want the structure to interact with player built redstone
	var/redstone_id
	var/list/redstone_attached = list()

/obj/structure/LateInitialize()
	. = ..()
	if(redstone_id)
		for(var/obj/structure/S in GLOB.redstone_objs)
			if(S.redstone_id == redstone_id)
				redstone_attached |= S
				S.redstone_attached |= src

/obj/structure/multitool_act(mob/living/user, obj/item/I)
	var/obj/item/contraption/linker/multitool = I
	var/guildmasteroverride = FALSE
	var/trigger_structure = FALSE //if the source is something like a lever or pressure plate or some other item
	var/trigger_buffer = FALSE //if the buffer is something like a lever or pressure plate or some other item
	var/reaction_structure = FALSE //if the source is something like a gate or a trapdoor
	var/reaction_buffer = FALSE //if the buffer is something like a gate or a trapdoor
	. = ..()
	if(!redstone_structure)
		return
	if(!istype(I, /obj/item/contraption/linker))
		return
	if(istype(I, /obj/item/contraption/linker/master))
		guildmasteroverride = TRUE //this is for the guildmaster's wrench
	if(!multitool.current_charge)
		return
	//check if the target is a trigger or a reaction
	if ((istype(src, /obj/structure/pressure_plate)) || (istype(src, /obj/structure/lever)))
		trigger_structure = TRUE
		reaction_structure = FALSE
	else
		reaction_structure = TRUE
		trigger_structure = FALSE
	//can't link a launcher while its locked
	if (istype(src, /obj/structure/englauncher))
		var obj/structure/englauncher/launchercheck = src
		if(launchercheck.locked)
			to_chat(user, span_warning("它锁住了！"))
			playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
	//check if the buffer is a trigger or reaction
	if ((istype(multitool.buffer, /obj/structure/pressure_plate)) || (istype(multitool.buffer, /obj/structure/lever)))
		trigger_buffer = TRUE
		reaction_buffer = FALSE
	else
		if (isnull(multitool.buffer)) //we need to check if the buffer is empty
			reaction_buffer = FALSE
			trigger_buffer = FALSE
		else
			reaction_buffer = TRUE
			trigger_buffer = FALSE

	// no linking two levers together
	if ((trigger_structure && trigger_buffer) && !(src == multitool.buffer))
		to_chat(user, "你不能把两个触发器直接连在一起")
		return

	//no linking two gates together
	if ((reaction_buffer && reaction_structure) && !(src == multitool.buffer))
		to_chat(user, "你不能把两个信号接收器直接连在一起")
		return

	//check the skill level, someone needs a bit of engineering skill at least
	if(user.get_skill_level(/datum/skill/craft/engineering) < 3)
		to_chat(user, span_warning("我完全不知道该怎么用[multitool]！"))
		return
	user.visible_message("[user]开始校准[src]。", "我开始校准[src]。")
	if(!do_after(user, 3 SECONDS, src))
		return

	if (reaction_structure && !guildmasteroverride && src.redstone_attached.len >= 1 ) //checks if our target is a gate or trap door with prior connections
		to_chat(user, "已经连接到另一套网络了") //prevents multiple linkings unless its the guildmaster's wrench
		return

	if(isstructure(multitool.buffer))
		var/obj/structure/buffer_structure = multitool.buffer
		if(src == buffer_structure)
			if (guildmasteroverride)
				for(var/obj/structure/O in redstone_attached) //the guild master wrench can clear all patterns
					O.redstone_attached -= src
					redstone_attached -= O
				GLOB.redstone_objs -= src
				to_chat(user, "我清除了[src]的全部连接")
			else
				to_chat(user, "[src]不能校准到自身。")
			return
		if (reaction_structure && !guildmasteroverride && src.redstone_attached.len >= 1) //checks if a structure is a gate or trap door with prior connections
			to_chat(user, "已经连接到另一套网络了") //prevent multiple linkings unless it's the guildmaster wrench
			return
		if (reaction_buffer && !guildmasteroverride && buffer_structure.redstone_attached.len >= 1) //checks if the buffer is a gate or trapdoor with prior connections
			to_chat(user, "已经连接到另一套网络了") //prevent multiple linkings unless it's the guildmaster wrench
			//we do this check incase someone linked something with another wrench
			return
		buffer_structure.redstone_attached |= src
		redstone_attached |= buffer_structure
		GLOB.redstone_objs |= src
		GLOB.redstone_objs |= buffer_structure
		to_chat(user, "我将[src]校准到[buffer_structure]的输出上。")
		if (reaction_buffer && !guildmasteroverride) //is the buffer a gate or a trap door that should only have one connection?
			multitool.remove_buffer(multitool.buffer) //clean up any structure from the buffer if its not a lever or plate, unless this is the guildmaster wrench
	else
		to_chat(user, "我把[src]的内部线路图存进了[multitool]。")
		multitool.set_buffer(src)
	multitool.charge_deduction(src, user, 1)

/obj/structure/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("redstone_id")
			update_redstone_id(var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

	return ..()

/obj/structure/proc/update_redstone_id(new_id)
	if(new_id)
		GLOB.redstone_objs |= src
		redstone_attached = list()
		redstone_id = new_id
		for(var/obj/structure/S in GLOB.redstone_objs)
			if(S.redstone_id == redstone_id)
				redstone_attached |= S
				S.redstone_attached |= src



/obj/structure/proc/redstone_triggered(mob/user)
	return

/obj/structure/lever
	name = "拉杆"
	desc = "我想拉下它。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "leverfloor0"
	density = FALSE
	anchored = TRUE
	max_integrity = 3000
	var/toggled = FALSE
	redstone_structure = TRUE

/obj/structure/lever/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_MELEE)
		var/used_time = 100 - (L.STASTR * 10)
		user.visible_message(span_warning("[user]拉下了拉杆。"))
		log_game("[key_name(user)] pulled the lever with redstone id \"[redstone_id]\"")
		if(do_after(user, used_time, target = user))
			for(var/obj/structure/O in redstone_attached)
				spawn(0) O.redstone_triggered()
			toggled = !toggled
			icon_state = "leverfloor[toggled]"
			playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

/obj/structure/lever/attackby(obj/item/I, mob/user, params)
	var/obj/item = user.get_active_held_item()
	if(user.used_intent.type == /datum/intent/chisel )
		if (user.get_skill_level(/datum/skill/craft/engineering) <= 3)
			to_chat(user, span_warning("我需要更高的技巧，才能在这个拉杆上刻名字。"))
			return
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message("<span class='info'>[user]开始在拉杆上刻名字。</span>")
		if(do_after(user, 10))
			var/levername
			levername = input("你想在这个拉杆上刻什么名字？")
			if (levername)
				name = levername + "（拉杆）"
				desc = "一个刻着名字的拉杆"
			else
				name = "拉杆"
				desc = "一个原有刻字被刮掉的拉杆"
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		return
	else if(istype(item, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须空出双手才能给门改名。"))

/obj/structure/lever/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_MELEE)
		if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
			user.visible_message("<span class='warning'>[user]用[user.p_their()]的尾巴拍打了拉杆！</span>")
		else
			user.visible_message("<span class='warning'>[user]踢了拉杆一脚！</span>")
		playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
		if(prob(L.STASTR * 4))
			for(var/obj/structure/O in redstone_attached)
				spawn(0) O.redstone_triggered()
			toggled = !toggled
			icon_state = "leverfloor[toggled]"
			playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

/obj/structure/lever/wall
	icon_state = "leverwall0"

/obj/structure/lever/wall/attack_hand(mob/user)
	. = ..()
	icon_state = "leverwall[toggled]"

/obj/structure/lever/wall/onkick(mob/user)
	. = ..()
	icon_state = "leverwall[toggled]"

/obj/structure/lever/hidden
	icon = null

/obj/structure/lever/pretoggled
	toggled = TRUE
	icon_state = "leverfloor1"

/obj/structure/lever/wall/pretoggled
	toggled = TRUE
	icon_state = "leverwall1"

/obj/structure/lever/hidden/proc/feel_button(mob/living/user)
	if(isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_MELEE)
		user.visible_message("<span class='warning'>[user]按下了一个隐藏按钮。</span>")
		user.log_message("pulled the lever with redstone id \"[redstone_id]\"", LOG_GAME)
		for(var/obj/structure/O in redstone_attached)
			spawn(0) O.redstone_triggered(user)
		toggled = !toggled
		playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

/obj/structure/lever/hidden/onkick(mob/user) // nice try
	return FALSE

/obj/structure/pressure_plate //vanderlin port
	name = "压力板"
	desc = "小心点。踩上去之后，要么是炸弹爆炸，要么是门在你脸上砸下来。"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "pressureplate"
	max_integrity = 45 // so it gets destroyed when used to explode a bomb
	density = FALSE
	anchored = TRUE
	redstone_structure = TRUE

/obj/structure/pressure_plate/Crossed(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		to_chat(L, "<span class='info'>我感觉脚下有什么咔哒响了一声。</span>")
		AM.log_message("has activated a pressure plate", LOG_GAME)
		playsound(src, 'sound/misc/pressurepad_down.ogg', 35, extrarange = 2)
		triggerplate()

/obj/structure/pressure_plate/proc/triggerplate()
	playsound(src, 'sound/misc/pressurepad_up.ogg', 35, extrarange = 2)
	for(var/obj/structure/O in redstone_attached)
		spawn(0) O.redstone_triggered()

/obj/structure/pressure_plate/attackby(obj/item/I, mob/user, params)
	. = ..()
	var/obj/item = user.get_active_held_item()
	if(istype(item,/obj/item/natural/cloth))
		if(alpha<36)
			to_chat(user, span_warning("我擦掉了遮住[name]的泥土"))
			if(do_after(user, 10))
				alpha = 255
			return
	if(istype(item,/obj/item/natural/dirtclod))
		if(alpha>= 36)
			to_chat(user, span_warning("我开始把[name]重新掩藏起来"))
			if(do_after(user, 10))
				alpha = 35
				qdel(item)
			return
		else
			to_chat(user, span_warning("[name]已经被掩藏好了"))
			return
	if(user.used_intent.type == /datum/intent/chisel )
		if (user.get_skill_level(/datum/skill/craft/engineering) <= 3)
			to_chat(user, span_warning("我需要更高的技巧，才能在这个压力板上刻名字。"))
			return
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message("<span class='info'>[user]在压力板上刻下了名字。</span>")
		if(do_after(user, 10))
			var/platename
			platename = input("你想在这个压力板上刻什么名字？")
			if (platename)
				name = platename + "（压力板）"
				desc = "一块刻着名字的板"
			else
				name = "板"
				desc = "一块原有刻字被刮掉的板"
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		return
	else if(istype(item, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须空出双手才能给压力板改名。"))


/*
/obj/structure/pressure_plate/attack_hand(mob/user) //commented out for now, they're stuposed to be anchored structures for dungeons. End of vanderlin traps port. Maybe an artificer subtype craft in the future.
	. = ..()
	if(user.used_intent.type == INTENT_HARM)
		playsound(loc, 'sound/combat/hits/punch/punch (1).ogg', 100, FALSE, -1)
		triggerplate()
		anchored = !anchored
*/

/obj/structure/englauncher
	name = "工程师发射器"
	desc = "一种工程机关，能把各种东西朝它所指的方向发射出去。"
	icon = 'icons/roguetown/misc/engineering_structure.dmi'
	icon_state = "activator"
	max_integrity = 45 // so it gets destroyed when used to explode a bomb
	//w_class = WEIGHT_CLASS_HUGE // mechanical stuff is usually pretty heavy.
	density = TRUE
	anchored = TRUE
	redstone_structure = TRUE
	var/obj/item/containment
	var/obj/item/quiver/ammo // used if the contained item is a bow or crossbow
	var/datum/intent/used_intent = null //fooling it to think we're a person
	var/mind = null //fooling it to think we're a person
	var/firedirection = NORTH //fire direction, we'll start north
	var/firedirectiontwo = NORTHEAST //bullet variation for spread mode
	var/firedirectionthree = NORTHWEST //bullet variation for spread mode
	var/spreadmode = FALSE //spread out your shots, waste your ammo
	locked = FALSE
	var/keylock = FALSE
	lockhash = 0
	lockid = null
	var/lockbroken = 0
	var/locksound = 'sound/foley/doors/woodlock.ogg'
	var/unlocksound = 'sound/foley/doors/woodlock.ogg'
	var/rattlesound = 'sound/foley/doors/lockrattle.ogg'
	var/masterkey = TRUE //if masterkey can open this regardless

/obj/structure/englauncher/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/englauncher/ComponentInitialize()
	. = ..()
	//AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED) //from vanderline, we don't have these flags here
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, PROC_REF(can_user_rotate)),CALLBACK(src, PROC_REF(can_be_rotated)),null)

/obj/structure/englauncher/proc/changeNext_move()
	return

/obj/structure/englauncher/proc/can_user_rotate(mob/user)
	var/mob/living/L = user
	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE))
			return FALSE
		else
			return TRUE
	else if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE

/obj/structure/englauncher/proc/can_be_rotated(mob/user)
	return TRUE

/obj/structure/englauncher/update_icon()
	. = ..()
	cut_overlays()
	if(!containment)
		add_overlay("activator-e")

/obj/structure/englauncher/attack_hand(mob/user)
	. = ..()
	if(locked)
		to_chat(user, span_warning("它锁住了！"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/obj/item = user.get_active_held_item()
	if(user.used_intent.type == /datum/intent/chisel )
		if (user.get_skill_level(/datum/skill/craft/engineering) <= 3)
			to_chat(user, span_warning("我需要更高的技巧，才能在这个发射器上刻名字。"))
			return
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message("<span class='info'>[user]在发射器上刻下了名字。</span>")
		if(do_after(user, 10))
			var/launchername
			launchername = input("你想在这个发射器上刻什么名字？")
			if (launchername)
				name = launchername + "（发射器）"
				desc = "一个刻着名字的发射器"
			else
				name = "工程师发射器"
				desc = "一个原有刻字被刮掉的发射器"
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		return
	else if(istype(item, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须空出双手才能给发射器改名。"))
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	sleep(7)
	if(containment)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		containment.forceMove(get_turf(src))
		containment = null
	if(ammo)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		ammo.forceMove(get_turf(src))
		ammo = null
	update_icon()
	return TRUE

/obj/structure/englauncher/attack_right(mob/user)
	var/obj/item = user.get_active_held_item()
	if(istype(item, /obj/item/roguekey) || istype(item, /obj/item/storage/keyring))
		if(locked)
			to_chat(user, span_warning("它没法往这边转。试着往左转。"))
			launcher_rattle()
			return
		trykeylock(item, user)
		return
	if(locked)
		to_chat(user, span_warning("它锁住了！"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if (user.rmb_intent)
		if (user.is_holding_item_of_type(/obj/item/contraption/linker))
			sleep(1)
			switch(firedirection)
				if(WEST)
					say("模式：北")
					playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					firedirection = NORTH
					firedirectiontwo = NORTHEAST
					firedirectionthree = NORTHWEST
				if(NORTH)
					say("模式：东")
					playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					firedirection = EAST
					firedirectiontwo = NORTHEAST
					firedirectionthree = SOUTHEAST
				if(EAST)
					say("模式：南")
					playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					firedirection = SOUTH
					firedirectiontwo = SOUTHEAST
					firedirectionthree = SOUTHWEST
				if(SOUTH)
					say("模式：西")
					playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					firedirection = WEST
					firedirectiontwo = NORTHWEST
					firedirectionthree = SOUTHWEST
		else if (user.is_holding_item_of_type(/obj/item/rogueweapon/hammer))
			sleep(1)
			switch(spreadmode)
				if(TRUE)
					say("射击：单发")
					playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					spreadmode = FALSE
				if(FALSE)
					say("射击：散射")
					playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					spreadmode = TRUE
		else
			say("需要扳手或锤子")
		return

/obj/structure/englauncher/attackby(obj/item/I, mob/user, params)
	user.changeNext_move(CLICK_CD_FAST)
	if(istype(I, /obj/item/roguekey) || istype(I, /obj/item/storage/keyring))
		if(!locked)
			to_chat(user, span_warning("这个装置已经没上锁了。"))
			playsound(src, rattlesound, 100)
			return
		else
			trykeylock(I, user)
			return
	if(locked)
		to_chat(user, span_warning("它被锁住了。"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!containment && (istype(I,/obj/item/reagent_containers) || istype(I, /obj/item/bomb) || istype(I, /obj/item/flint))) //loading in items
		if(!user.transferItemToLoc(I, src))
			return ..()
		containment = I
		playsound(src, 'sound/misc/chestclose.ogg', 25)
		update_icon()
		return TRUE
	if(!ammo && istype(I, /obj/item/quiver)) //loading in quivers of ammo to fire
		if (istype(I, /obj/item/quiver/javelin) || istype(I, /obj/item/quiver/sling)) //javelin don't work and sling seem too low cost to be balanced
			return
		if(!user.transferItemToLoc(I, src))
			return
		playsound(src, 'sound/misc/chestclose.ogg', 25)
		containment = I
		ammo = I
		update_icon()
		return TRUE
	return ..()

/obj/structure/englauncher/redstone_triggered(mob/user)
	if(!containment)
		return
	var/turf/front = get_step(src, firedirection)

	if(istype(containment, /obj/item/bomb))
		var/obj/item/bomb/bomba = containment
		bomba.light()
	if(istype(containment, /obj/item/reagent_containers))
		container_aerosolize(containment, firedirection)
	if(istype(containment, /obj/item/flint))
		var/datum/effect_system/spark_spread/S = new()
		S.set_up(1, 1, front)
		S.start()
	if(istype(containment, /obj/item/quiver))
		var/bodyzone =  BODY_ZONE_CHEST
		bodyzone =  pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
		quiver_fire(firedirection, bodyzone)
		if(spreadmode)
			bodyzone =  pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			quiver_fire(firedirectiontwo, bodyzone)
			bodyzone =  pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			quiver_fire(firedirectionthree, bodyzone)

/obj/structure/englauncher/proc/quiver_fire(launcher_direction, launcher_bodyzone)
	if(!ammo)
		return
	if(ammo.arrows.len)
		for(var/obj/item/ammo_casing/BT in ammo.arrows)
			//if(istype(BT, gun_ammo))
			ammo.arrows -= BT
			BT.fire_casing(get_step(src, launcher_direction), src, null, null, null, launcher_bodyzone, 0,  src)
			ammo.contents -= BT
			ammo.update_icon()
			break

/obj/structure/englauncher/proc/container_aerosolize(launcher_liquid, launcher_direction)
	var/turf/T = get_step(src, launcher_direction) //check for turf
	if(T)
		var/obj/item/reagent_containers/con = launcher_liquid //get the container
		if(con)
			if(con.spillable)
				if(con.reagents.total_volume > 0)
					var/datum/reagents/R = con.reagents
					var/datum/effect_system/smoke_spread/chem/smoke = new
					if(spreadmode)
						smoke.set_up(R, 3, T, FALSE)
					else
						smoke.set_up(R, 1, T, FALSE)
					smoke.start()

					//user.visible_message(span_warning("[user] sprays the contents of the [held_item], creating a cloud!"), span_warning("You spray the contents of the [held_item], creating a cloud!"))
					con.reagents.clear_reagents() //empty the container
					playsound(src, 'sound/magic/webspin.ogg', 100)

/obj/structure/englauncher/proc/trykeylock(obj/item/I, mob/user, autobump = FALSE)
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, span_warning("这个装置的锁已经坏了。"))
	if(lockhash == 0)
		to_chat(user, span_warning("这个装置根本没有装锁。"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(istype(I,/obj/item/storage/keyring))
		var/obj/item/storage/keyring/R = I
		if(!R.contents.len)
			return
		var/list/keysy = shuffle(R.contents.Copy())
		for(var/obj/item/roguekey/K in keysy)
			if(user.cmode)
				if(!do_after(user, 10, TRUE, src))
					break
			if(K.lockhash == lockhash)
				lock_toggle(user)
				return
			else
				if(user.cmode)
					launcher_rattle()
		to_chat(user, span_warning("我钥匙串上没有一把钥匙能开这个装置。"))
		launcher_rattle()
		return
	else
		var/obj/item/roguekey/K = I
		if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord)) //master key cares not for lockhashes
			lock_toggle(user)
			return
		else
			to_chat(user, span_warning("这不是能打开这个装置的正确钥匙。"))
			launcher_rattle()
		return

/obj/structure/englauncher/proc/lock_toggle(mob/user)
	if(locked)
		user.visible_message(span_warning("[user]打开了[src]的锁。"), \
			span_notice("我打开了[src]的锁。"))
		playsound(src, unlocksound, 100)
		locked = 0
	else
		user.visible_message(span_warning("[user]锁上了[src]。"), \
			span_notice("我锁上了[src]。"))
		playsound(src, locksound, 100)
		locked = 1

/obj/structure/englauncher/proc/launcher_rattle()
	playsound(src, rattlesound, 100)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/floordoor
	name = "地板活门"
	desc = "一个方便的地板活门，适合给楼上的人留点隐私。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "floorhatch1"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	var/togg = FALSE
	var/base_state = "floorhatch"
	max_integrity = 0
	redstone_structure = TRUE
/*
/obj/structure/floordoor/Initialize(mapload)
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/FTMET_A1.ogg','sound/foley/footsteps/FTMET_A2.ogg','sound/foley/footsteps/FTMET_A3.ogg','sound/foley/footsteps/FTMET_A4.ogg'), 100)
	return ..()
*/
/obj/structure/floordoor/obj_break(damage_flag)
	set_is_platform(FALSE)
	obj_flags &= ~BLOCK_Z_IN_UP
	..()

/obj/structure/floordoor/redstone_triggered(mob/user)
	if(obj_broken)
		return
	togg = !togg
	if(togg)
		icon_state = "[base_state]0"
		set_is_platform(FALSE)
		obj_flags &= ~BLOCK_Z_IN_UP
		var/turf/T = loc
		if(istype(T))
			for(var/atom/movable/M in loc)
				T.Entered(M)
	else
		icon_state = "[base_state]1"
		set_is_platform(TRUE)
		obj_flags |= BLOCK_Z_IN_UP

/obj/structure/floordoor/open
	icon_state = "floorhatch0"
	base_state = "floorhatch"
	togg = TRUE
	obj_flags = null

/obj/structure/floordoor/gatehatch
	name = ""
	desc = ""
	base_state = ""
	icon_state = ""
	var/changing_state = FALSE
	var/delay2open = 0
	var/delay2close = 0
	max_integrity = 0
	nomouseover = TRUE
	mouse_opacity = 0

/obj/structure/floordoor/gatehatch/Initialize(mapload)
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/FTMET_A1.ogg','sound/foley/footsteps/FTMET_A2.ogg','sound/foley/footsteps/FTMET_A3.ogg','sound/foley/footsteps/FTMET_A4.ogg'), 40)
	return ..()

/obj/structure/floordoor/gatehatch/redstone_triggered(mob/user)
	if(changing_state)
		return
	if(obj_broken)
		return
	changing_state = TRUE
	togg = !togg
	if(togg)
		sleep(delay2open)
		icon_state = "[base_state]0"
		set_is_platform(FALSE)
		obj_flags &= ~BLOCK_Z_IN_UP
		var/turf/T = loc
		if(istype(T))
			for(var/atom/movable/M in loc)
				T.Entered(M)
		sleep(40-delay2open)
		changing_state = FALSE
	else
		sleep(delay2close)
		icon_state = "[base_state]1"
		set_is_platform(TRUE)
		obj_flags |= BLOCK_Z_IN_UP
		sleep(40-delay2close)
		changing_state = FALSE

/obj/structure/floordoor/gatehatch/inner
	delay2open = 10
	delay2close = 30

/obj/structure/floordoor/gatehatch/outer
	delay2open = 30
	delay2close = 10

/obj/structure/floordoor/attackby(mob/user)
	. = ..()
	var/obj/item = user.get_active_held_item()
	if(user.used_intent.type == /datum/intent/chisel )
		if (user.get_skill_level(/datum/skill/craft/engineering) <= 3)
			to_chat(user, span_warning("我需要更高的技巧，才能在这个活门上刻名字。"))
			return
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message("<span class='info'>[user]在活门上刻下了名字。</span>")
		if(do_after(user, 10))
			var/hatchname
			hatchname = input("你想在这个活门上刻什么名字？")
			if (hatchname)
				name = hatchname + "（活门）"
				desc = "一个刻着名字的活门"
			else
				name = ""
				desc = "一个原有刻字被刮掉的活门"
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		return
	else if(istype(item, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须空出双手才能给这个活门改名。"))

/obj/structure/kybraxor
	name = "吞噬者凯布拉索"
	desc = "疯公爵最饥饿的宠物。"
	density = FALSE
	nomouseover = TRUE
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "kybraxor1"
	redstone_id = "gatelava"
	var/openn = FALSE
	var/changing_state = FALSE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0

/obj/structure/kybraxor/redstone_triggered(mob/user)
	if(changing_state)
		return
	if(obj_broken)
		return
	changing_state = TRUE
	openn = !openn
	if(openn)
		playsound(src, 'sound/misc/kybraxorop.ogg', 100, FALSE)
		flick("kybraxoropening",src)
		sleep(40)
		icon_state = "kybraxor0"
		changing_state = FALSE
	else
		playsound(src, 'sound/misc/kybraxor.ogg', 100, FALSE)
		flick("kybraxorclosing",src)
		sleep(40)
		icon_state = "kybraxor1"
		changing_state = FALSE

/obj/structure/kybraxor/psy
	name = "凯布拉索之门"
	redstone_id = "swamp_psy_dungeon"

/obj/structure/lever/cursed
	name = "诅咒拉杆"
	// color = "e8a3a0" //this breaks for some reason
	desc = "一根被黑暗力量缠绕的拉杆，不是谁都能碰。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "leverwall0"
	var/allowed_factions = null // List of factions allowed to use this lever, e.g. list("orcs", "tribe")

/obj/structure/lever/cursed/attack_hand(mob/user)
	if(!istype(user, /mob/living))
		return
	var/mob/living/L = user
	if(src.allowed_factions && (!L.faction || !length(src.allowed_factions & L.faction)))
		to_chat(user, "<span class='danger'>一股黑暗力量排斥了我！</span>")
		playsound(src, 'sound/magic/magic_nulled.ogg', 50)
		return
	. = ..()
	icon_state = "leverwall[toggled]"

/obj/structure/lever/cursed/onkick(mob/user)
	if(!istype(user, /mob/living))
		return
	var/mob/living/L = user
	if(src.allowed_factions && (!L.faction || !length(src.allowed_factions & L.faction)))
		to_chat(user, "<span class='danger'>一股黑暗力量弹开了我的踢击！</span>")
		playsound(src, 'sound/magic/magic_nulled.ogg', 50)
		return
	. = ..()
	icon_state = "leverwall[toggled]"
