//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "金属门"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = CLOSED_DOOR_LAYER

	icon = 'icons/roguetown/misc/doors.dmi'
	icon_state = "metal"
	max_integrity = 1000
	integrity_failure = 0.5
	CanAtmosPass = ATMOS_PASS_DENSITY

	var/ridethrough = FALSE

	var/door_opened = FALSE //if it's open or not.
	var/isSwitchingStates = FALSE //don't try to change stats if we're already opening

	var/close_delay = -1 //-1 if does not auto close.
	var/openSound = 'sound/blank.ogg'
	var/closeSound = 'sound/blank.ogg'

	var/sheetAmount = 7 //how much we drop when deconstructed

	var/windowed = FALSE
	var/base_state = null

	locked = FALSE
	var/lockdifficulty = 1
	var/last_bump = null
	var/brokenstate = 0
	var/keylock = FALSE
	lockhash = 0
	lockid = null
	var/lockbroken = 0
	var/locksound = 'sound/foley/doors/woodlock.ogg'
	var/unlocksound = 'sound/foley/doors/woodlock.ogg'
	var/rattlesound = 'sound/foley/doors/lockrattle.ogg'
	var/masterkey = TRUE //if masterkey can open this regardless
	var/kickthresh = 15
	var/swing_closed = TRUE
	var/lock_strength = 100
	var/repairable = FALSE
	var/repair_state = 0
	var/obj/item/repair_cost_first = null
	var/obj/item/repair_cost_second = null
	var/repair_skill = null
	damage_deflection = 10
	var/mob/last_bumper = null
	var/smashable = FALSE
	/// Whether to grant a resident_key
	var/grant_resident_key = FALSE
	var/resident_key_amount = 1
	/// The type of a key the resident will get
	var/resident_key_type
	/// The required role of the resident
	var/resident_role
	/// The requied advclass of the resident
	var/list/resident_advclass
	//a door name a skilled artisan can make 
	var/doorname = null

/obj/structure/mineral_door/onkick(mob/user)
	if(isSwitchingStates)
		return
	if(door_opened)
		playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
		if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
			user.visible_message(span_warning("[user]用[user.p_their()]尾巴猛地甩上了[src]！"), \
				span_notice("我用尾巴把[src]猛地甩上了。"))
		else
			user.visible_message(span_warning("[user]一脚踹上了[src]！"), \
				span_notice("我一脚把[src]踹上了。"))
		force_closed()
	else
		if(locked)
			if(isliving(user))
				var/mob/living/L = user
				if(L.STASTR >= initial(kickthresh))
					kickthresh--
				if((prob(L.STASTR * 0.5) || kickthresh == 0) && (L.STASTR >= initial(kickthresh)))
					playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
					if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
						user.visible_message(span_warning("[user]用[user.p_their()]尾巴猛地甩开了[src]！"), \
							span_notice("我用尾巴猛地把[src]甩开了。"))
					else
						user.visible_message(span_warning("[user]一脚踹开了[src]！"), \
							span_notice("我一脚踹开了[src]。"))
					locked = 0
					force_open()
				else
					playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
					if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
						user.visible_message(span_warning("[user]用尾巴狠狠撞上了[src]！"), \
							span_notice("我用尾巴狠狠撞上了[src]。"))
					else
						user.visible_message(span_warning("[user]猛踹了[src]一脚！"), \
							span_notice("我猛踹了[src]一脚。"))
			//try to kick open, destroy lock
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
				user.visible_message(span_warning("[user]用[user.p_their()]尾巴猛地甩开了[src]！"), \
					span_notice("我用尾巴猛地把[src]甩开了。"))
			else
				user.visible_message(span_warning("[user]一脚踹开了[src]！"), \
					span_notice("我一脚踹开了[src]。"))
			force_open()

/obj/structure/mineral_door/proc/force_open()
	isSwitchingStates = TRUE
	if(!windowed)
		set_opacity(FALSE)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/force_closed()
	isSwitchingStates = TRUE
	if(!windowed)
		set_opacity(TRUE)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/mineral_door/Initialize(mapload)
	. = ..()
	if(!base_state)
		base_state = icon_state
	air_update_turf(TRUE)
	if(grant_resident_key && !lockid)
		lockid = "random_lock_id_[rand(1,9999999)]" // I know, not foolproof
	if(lockhash)
		GLOB.lockhashes += lockhash
	else if(keylock)
		if(lockid)
			if(GLOB.lockids[lockid])
				lockhash = GLOB.lockids[lockid]
			else
				lockhash = rand(1000,9999)
				while(lockhash in GLOB.lockhashes)
					lockhash = rand(1000,9999)
				GLOB.lockhashes += lockhash
				GLOB.lockids[lockid] = lockhash
		else
			lockhash = rand(1000,9999)
			while(lockhash in GLOB.lockhashes)
				lockhash = rand(1000,9999)
			GLOB.lockhashes += lockhash

/obj/structure/mineral_door/proc/try_award_resident_key(mob/user)
	if(!grant_resident_key)
		return FALSE
	if(!lockid)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/human = user
	if(human.received_resident_key)
		return FALSE
	if(resident_role)
		var/datum/job/job = SSjob.name_occupations[human.job]
		if(job.type != resident_role)
			if(!HAS_TRAIT(human, TRAIT_RESIDENT))
				return FALSE
	if(resident_advclass)
		if(!human.advjob)
			return FALSE
		var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(human.advjob)
		if(!advclass)
			return FALSE
		if(!(advclass.type in resident_advclass))
			return FALSE
	var/alert = alert(user, "这是你的住处。要领取钥匙吗？", "领取钥匙", "要", "不要")
	if(alert != "要")
		return
	if(!grant_resident_key)
		return
	var/spare_key = alert(user, "要不要顺便领一把备用钥匙？", "领取钥匙", "要", "不要")
	if(!grant_resident_key)
		return
	if(spare_key == "要")
		resident_key_amount = 2
	else
		resident_key_amount = 1
	for(var/i in 1 to resident_key_amount)
		var/obj/item/roguekey/key
		if(resident_key_type)
			key = new resident_key_type(get_turf(human))
		else
			key = new /obj/item/roguekey(get_turf(human))
		key.lockid = lockid
		key.lockhash = lockhash
		human.put_in_hands(key)
	human.received_resident_key = TRUE
	grant_resident_key = FALSE
	if(resident_key_amount > 1)
		to_chat(human, span_notice("我领取了住处钥匙和一把备用钥匙。"))
	else
		to_chat(human, span_notice("我领取了住处钥匙。"))
	var/owner_title = human.job  // If you somehow have no job at all, it'll just be "Name's house"
	if(human.mind && human.mind.cosmetic_class_title)
		owner_title = human.mind.cosmetic_class_title
	else if(human.advjob)
		owner_title = human.advjob		
	name = "[user.real_name][owner_title ? "（[owner_title]）" : ""]的房子"
	return TRUE

/obj/structure/mineral_door/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	..()
	if(door_opened)
		return
	if(world.time < last_bump+20)
		return
	last_bump = world.time
	if(ismob(AM))
		var/mob/user = AM
		if(HAS_TRAIT(user, TRAIT_BASHDOORS))
			if(locked)
				user.visible_message(span_warning("[user]猛撞上了[src]！"))
				take_damage(200, "brute", "blunt", 1)
			else
				playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
				force_open()
				user.visible_message(span_warning("[user]猛地撞穿了[src]！"))
			return
		if(locked)
			if(istype(user.get_active_held_item(), /obj/item/roguekey) || istype(user.get_active_held_item(), /obj/item/storage/keyring))
				src.attackby(user.get_active_held_item(), user, TRUE)
				return
			door_rattle()
			return
		if(TryToSwitchState(user))
			if(swing_closed)
				if(user.m_intent == MOVE_INTENT_SNEAK)
					addtimer(CALLBACK(src, PROC_REF(Close), TRUE), 25)
				else
					addtimer(CALLBACK(src, PROC_REF(Close), FALSE), 25)


/obj/structure/mineral_door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(brokenstate)
		return
	if(isSwitchingStates)
		return
	if(try_award_resident_key(user))
		return
	if(locked)
		if(isliving(user))
			var/mob/living/L = user
			if(L.m_intent == MOVE_INTENT_SNEAK)
				to_chat(user, span_warning("这扇门锁着。"))
				return
		if(world.time >= last_bump+20)
			last_bump = world.time
			playsound(src, 'sound/foley/doors/knocking.ogg', 100)
			user.visible_message(span_warning("[user]敲了敲[src]。"), \
				span_notice("我敲了敲[src]。"))
		return
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/mineral_door/CanAStarPass(ID, to_dir, datum/caller)
	. = ..()
	if(.) // we can already go through it
		return TRUE
	if(!anchored)
		return FALSE
	if(HAS_TRAIT(caller, TRAIT_BASHDOORS))
		return TRUE // bash into it!
	// it's openable
	return ishuman(caller) && !locked // only humantype mobs can open doors, as funny as it'd be for a volf to walk in on you ERPing

/obj/structure/mineral_door/proc/TryToSwitchState(mob/living/user)
	if(!isliving(user) || isSwitchingStates || !anchored)
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		// must have a client or be trying to pass through the door
		if(!human_user.client && !length(human_user.myPath))
			return FALSE
		if(human_user.handcuffed)
			return FALSE
	else if(!user.client) // simplemobs aren't allowed to pathfind through doors, currently
		return FALSE
	SwitchState(user.m_intent == MOVE_INTENT_SNEAK) // silent when sneaking
	return TRUE

/obj/structure/mineral_door/proc/SwitchState(silent = FALSE)
	if(door_opened)
		Close(silent)
	else
		Open(silent)

/obj/structure/mineral_door/proc/Open(silent = FALSE, mob/user)
	isSwitchingStates = TRUE
	if(!silent)
		playsound(src, openSound, 100)
	if(!windowed)
		set_opacity(FALSE)
	flick("[base_state]opening",src)
	sleep(2)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/Close(silent = FALSE, autobump = FALSE, mob/user)
	if(isSwitchingStates || !door_opened)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	isSwitchingStates = TRUE
	if(!silent)
		playsound(src, closeSound, 100)
	flick("[base_state]closing",src)
	sleep(2)
	density = TRUE
	if(!windowed)
		set_opacity(TRUE)
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE
	if(autobump && src.Adjacent(last_bumper))
		if(istype(last_bumper.get_active_held_item(), /obj/item/roguekey) || istype(last_bumper.get_active_held_item(), /obj/item/storage/keyring))
			src.attack_right(last_bumper)
	last_bumper = null

/obj/structure/mineral_door/update_icon()
	icon_state = "[base_state][door_opened ? "open":""]"

/obj/structure/mineral_door/examine(mob/user)
	. = ..()
	if(repairable)
		var/obj/cast_repair_cost_first = repair_cost_first
		var/obj/cast_repair_cost_second = repair_cost_second
		if((repair_state == 0) && (obj_integrity < max_integrity))
			. += span_notice("它可以用[initial(cast_repair_cost_first.name)]修补。")
			if(brokenstate)
				. += span_notice("之后还需要[initial(cast_repair_cost_second.name)]才能彻底修好。")
		if(repair_state == 1)
			. += span_notice("还需要[initial(cast_repair_cost_second.name)]才能彻底修好。")



/obj/structure/mineral_door/proc/door_rattle()
	playsound(src, rattlesound, 100)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/mineral_door/attackby(obj/item/I, mob/user, autobump = FALSE)
	user.changeNext_move(CLICK_CD_FAST)
	if(istype(I, /obj/item/roguekey) || istype(I, /obj/item/storage/keyring))
		if(!locked)
			to_chat(user, span_warning("这扇门已经没上锁了。"))
			door_rattle()
			return
		if(autobump == TRUE) //Attackby passes UI coordinate onclick stuff, so forcing check to TRUE
			trykeylock(I, user, autobump)
			return
		else
			trykeylock(I, user)
			return
	if(istype(I, /obj/item/lockpick))
		trypicklock(I, user)
	if(istype(I, /obj/item/melee/touch_attack/lesserknock))
		trypicklock(I, user)
	if(istype(I,/obj/item/lockpickring))
		var/obj/item/lockpickring/pickring = I
		if(pickring.picks.len)
			pickring.removefromring(user)
			to_chat(user, span_warning("我从开锁环上取下了一枚锁针。"))
		return
	if(istype(I, /obj/item/skeleton_key))
		tryskeletonlock(user)
	else
		if(repairable && (user.get_skill_level(repair_skill) > 0) && ((istype(I, repair_cost_first)) || (istype(I, repair_cost_second)))) // At least 1 skill level needed
			repairdoor(I,user)
		else if(user.used_intent.type == /datum/intent/chisel )
			if (user.get_skill_level(repair_skill) <= 3)
				to_chat(user, span_warning("我的手艺还不够，没法给这扇门刻名。"))
				return
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			user.visible_message("<span class='info'>[user]开始在门上刻名字。</span>")
			if(do_after(user, 10))
				doorname = input("你想在门上刻什么名字？")
				if (doorname)
					name = doorname + "（门）"
					desc = "门上被人刻了名字。"
				else
					name = "门"
					desc = "一扇普通的门。"
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			return
		else if(istype(I, /obj/item/rogueweapon/chisel/assembly))
			to_chat(user, span_warning("这东西不能拿来给门刻名。"))
		else
			return ..()

/obj/structure/mineral_door/attacked_by(obj/item/I, mob/living/user)
	..()
	if(obj_broken || obj_destroyed)
		var/obj/effect/track/structure/new_track = SStracks.get_track(/obj/effect/track/structure, get_turf(src))
		new_track.handle_creation(user)

/obj/structure/mineral_door/proc/repairdoor(obj/item/I, mob/user)
	if(brokenstate)
		switch(repair_state)
			if(0)
				if(istype(I, repair_cost_first))
					user.visible_message(span_notice("[user]开始修理[src]。"), \
					span_notice("我开始修理[src]。"))
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
						qdel(I)
						playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
						repair_state = 1
						var/obj/cast_repair_cost_second = repair_cost_second
						to_chat(user, span_notice("还需要[initial(cast_repair_cost_second.name)]才能彻底修好它。"))
			if(1)
				if(istype(I, repair_cost_second))
					user.visible_message(span_notice("[user]开始修理[src]。"), \
					span_notice("我开始修理[src]。"))
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
						qdel(I)
						playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
						icon_state = "[base_state]"
						density = TRUE
						opacity = TRUE
						brokenstate = FALSE
						obj_broken = FALSE
						obj_integrity = max_integrity
						repair_state = 0
						user.visible_message(span_notice("[user]修好了[src]。"), \
						span_notice("我修好了[src]。"))
	else
		if(obj_integrity < max_integrity && istype(I, repair_cost_first))
			to_chat(user, span_warning("[obj_integrity]"))
			user.visible_message(span_notice("[user]开始修理[src]。"), \
			span_notice("我开始修理[src]。"))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				obj_integrity = obj_integrity + (max_integrity/2)
				if(obj_integrity > max_integrity)
					obj_integrity = max_integrity
				user.visible_message(span_notice("[user]修好了[src]。"), \
				span_notice("我修好了[src]。"))

/obj/structure/mineral_door/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)

	// Special handling for deadbolt and shutter doors - preserve their custom behavior
	if(istype(src, /obj/structure/mineral_door/wood/deadbolt) || istype(src, /obj/structure/mineral_door/wood/deadbolt/shutter))
		return ..()

	// Check if user has a key in hand or belt slots
	var/obj/item/key_item = find_key_for_door(user)
	if(key_item)
		trykeylock(key_item, user)
		return

	// If no key found, fall back to parent behavior
	return ..()

// Helper proc to find a matching key or keyring in hand or belt slots
/obj/structure/mineral_door/proc/find_key_for_door(mob/user)
	if(!user || !keylock)
		return null

	// Check hand first
	var/obj/item/W = user.get_active_held_item()
	if(W && (istype(W, /obj/item/roguekey) || istype(W, /obj/item/storage/keyring)))
		if(istype(W, /obj/item/roguekey))
			var/obj/item/roguekey/K = W
			if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
				return W
		if(istype(W, /obj/item/storage/keyring))
			if(keyring_has_matching_key(W))
				return W

	// Check belt slots if human
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/list/belt_slots = list(
			H.get_item_by_slot(SLOT_BELT),
			H.get_item_by_slot(SLOT_BELT_L),
			H.get_item_by_slot(SLOT_BELT_R)
		)

		for(var/obj/item/I in belt_slots)
			if(!I) continue

			// Check if the belt item itself is a key or keyring
			if(istype(I, /obj/item/roguekey))
				var/obj/item/roguekey/K = I
				if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
					return I
			if(istype(I, /obj/item/storage/keyring))
				if(keyring_has_matching_key(I))
					return I

			// Check inside the belt item if it has contents (storage belts, etc.)
			if(I.contents && I.contents.len)
				for(var/obj/item/contained_item in I.contents)
					if(istype(contained_item, /obj/item/roguekey))
						var/obj/item/roguekey/K = contained_item
						if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
							return I // Return the belt item that contains the key
					if(istype(contained_item, /obj/item/storage/keyring))
						if(keyring_has_matching_key(contained_item))
							return I // Return the belt item that contains the keyring

	return null

// Helper proc to check if a keyring contains a matching key
/obj/structure/mineral_door/proc/keyring_has_matching_key(obj/item/storage/keyring/keyring)
	if(!keyring || !istype(keyring, /obj/item/storage/keyring))
		return FALSE

	for(var/obj/item/I in keyring.contents)
		if(istype(I, /obj/item/roguekey))
			var/obj/item/roguekey/K = I
			if(K.lockhash == lockhash)
				return TRUE
		if(istype(I, /obj/item/storage/keyring))
			if(keyring_has_matching_key(I))
				return TRUE

	return FALSE

/obj/structure/mineral_door/proc/trykeylock(obj/item/I, mob/user, autobump = FALSE)
	if(door_opened || isSwitchingStates)
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, span_warning("这把锁已经坏了。"))
	user.changeNext_move(CLICK_CD_INTENTCAP)

	// Handle belt items that contain keys
	if(I.contents && I.contents.len && !istype(I, /obj/item/storage/keyring))
		var/obj/item/found_key = null
		for(var/obj/item/contained_item in I.contents)
			if(istype(contained_item, /obj/item/roguekey))
				var/obj/item/roguekey/K = contained_item
				if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
					found_key = contained_item
					break
			if(istype(contained_item, /obj/item/storage/keyring))
				if(keyring_has_matching_key(contained_item))
					found_key = contained_item
					break

		if(found_key)
			// Use the found key instead of the belt
			trykeylock(found_key, user, autobump)
			return
		else
			to_chat(user, span_warning("[I]里没有能开这扇门的钥匙。"))
			door_rattle()
			return

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
				if(autobump && !locked)
					src.Open()
					addtimer(CALLBACK(src, PROC_REF(Close), FALSE, TRUE), 25)
					src.last_bumper = user
				return
			else
				if(user.cmode)
					door_rattle()
		to_chat(user, span_warning("这串钥匙里没有能开这扇门的钥匙。"))
		door_rattle()
		return
	else
		var/obj/item/roguekey/K = I
		if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord)) //master key cares not for lockhashes
			lock_toggle(user)
			if(autobump)
				src.Open()
				addtimer(CALLBACK(src, PROC_REF(Close), FALSE, TRUE), 25)
				src.last_bumper = user
			return
		else
			to_chat(user, span_warning("这把钥匙打不开这扇门。"))
			door_rattle()
		return

/obj/structure/mineral_door/proc/trypicklock(obj/item/I, mob/user)
	if(door_opened || isSwitchingStates)
		to_chat(user, "<span class='warning'>门开着的时候没法撬锁。</span>")
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, "<span class='warning'>这扇门的锁已经坏了。</span>")
		user.changeNext_move(CLICK_CD_INTENTCAP)
	else
		var/lockprogress = 0
		var/locktreshold = lock_strength

		var/obj/item/lockpick/P = I
		var/mob/living/L = user

		var/pickskill = user.get_skill_level(/datum/skill/misc/lockpicking)
		var/perbonus = L.STAPER/5
		var/picktime = 70
		var/pickchance = 35
		var/moveup = 10

		picktime -= (pickskill * 10)
		picktime = clamp(picktime, 10, 70)

		moveup += (pickskill * 3)
		moveup = clamp(moveup, 10, 30)

		pickchance += pickskill * 10
		pickchance += perbonus
		pickchance *= P.picklvl
		pickchance = clamp(pickchance, 1, 95)
		
		if (lockdifficulty > 1) //each time the difficulty goes up, the harder the lock
			picktime = picktime+(10*lockdifficulty)//add a flat 10 per level
			pickchance = pickchance/(lockdifficulty*0.75)//reduce the chance by .75 per level

		if(lockdifficulty > 2 && P.picklvl < 1) //disallowing lesser knock and poor locks from being used
			to_chat(user, "<span class='warning'>我的锁针太差，没法对付这把锁。</span>")
			playsound(loc, 'sound/items/pickbad.ogg', 40, TRUE)
			I.take_damage(1, BRUTE, "blunt")
			to_chat(user, "<span class='warning'>咔嗒。</span>")
			return

		var/picked = FALSE
		user.log_message("尝试撬锁门\"[src.name]\"（当前[locked ? "已上锁" : "未上锁"]）。", LOG_ATTACK)

		while(!QDELETED(I) &&(lockprogress < locktreshold))
			if(!do_after(user, picktime, target = src))
				break
			if(prob(pickchance))
				lockprogress += moveup
				playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
				to_chat(user, "<span class='warning'>咔哒……</span>")
				if(L.mind)
					add_sleep_experience(L, /datum/skill/misc/lockpicking, L.STAINT/2)
				if(lockprogress >= locktreshold)
					picked = TRUE
					to_chat(user, "<span class='deadsay'>锁芯松开了。</span>")
					if(ishuman(user))
						var/mob/living/carbon/human/H = user
						message_admins("[H.real_name]([key_name(user)])成功撬开了[src.name]并将其[locked ? "解锁" : "锁上"]。[ADMIN_JMP(src)]")
						log_admin("[H.real_name]([key_name(user)]) successfully lockpicked [src.name].")
						record_featured_stat(FEATURED_STATS_CRIMINALS, user)
						record_round_statistic(STATS_LOCKS_PICKED)
						var/obj/effect/track/structure/new_track = SStracks.get_track(/obj/effect/track/structure, get_turf(src))
						new_track.handle_creation(user)
					lock_toggle(user)
					break
				else
					continue
			else
				playsound(loc, 'sound/items/pickbad.ogg', 40, TRUE)
				I.take_damage(1, BRUTE, "blunt")
				to_chat(user, "<span class='warning'>咔嗒。</span>")
				add_sleep_experience(L, /datum/skill/misc/lockpicking, L.STAINT/4)
				continue
		if(!picked)
			user.log_message("停止/失败于撬锁门\"[src.name]\"（仍为[locked ? "已上锁" : "未上锁"]）。", LOG_ATTACK)
		return

/obj/structure/mineral_door/proc/tryskeletonlock(mob/user)
	if(door_opened || isSwitchingStates)
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, span_warning("这把锁已经坏了。"))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		message_admins("[H.real_name]([key_name(user)])成功用骷髅钥匙操作了[src.name]并将其[locked ? "解锁" : "锁上"]。[ADMIN_JMP(src)]")
		log_admin("[H.real_name]([key_name(user)]) successfully used a skeleton key on [src.name].")
	do_sparks(3, FALSE, src)
	playsound(user, 'sound/items/skeleton_key.ogg', 100)
	lock_toggle(user) //All That It Does.
	user.changeNext_move(CLICK_CD_INTENTCAP)
	return

/obj/structure/mineral_door/proc/lock_toggle(mob/user)
	if(isSwitchingStates || door_opened)
		return
	if(locked)
		user?.visible_message(span_warning("[user]打开了[src]的锁。"), \
			span_notice("我打开了[src]的锁。"))
		playsound(src, unlocksound, 100)
		locked = 0
	else
		user?.visible_message(span_warning("[user]锁上了[src]。"), \
			span_notice("我锁上了[src]。"))
		playsound(src, locksound, 100)
		locked = 1

/obj/structure/mineral_door/setAnchored(anchorvalue) //called in default_unfasten_wrench() chain
	. = ..()
	set_opacity(anchored ? !door_opened : FALSE)
	air_update_turf(TRUE)

/obj/structure/mineral_door/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 40)
	return TRUE


/obj/structure/mineral_door/obj_break(damage_flag, mapload)
	if(!brokenstate)
		icon_state = "[base_state]br"
		density = FALSE
		opacity = FALSE
		brokenstate = TRUE
	..()

/obj/structure/mineral_door/OnCrafted(dirin, user)
	. = ..()
	keylock = FALSE
	GLOB.lockhashes.Remove(lockhash)
	lockhash = 0

/////////////////////// TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/proc/pickaxe_door(mob/living/user, obj/item/I) //override if the door isn't supposed to be a minable mineral.
	return/*
	if(!istype(user))
		return
	if(I.tool_behaviour != TOOL_MINING)
		return
	. = TRUE
	to_chat(user, span_notice("?????[src]??"))
	if(I.use_tool(src, user, 40, volume=50))
		to_chat(user, span_notice("?????"))
		deconstruct(TRUE)*/

/obj/structure/mineral_door/welder_act(mob/living/user, obj/item/I) //override if the door is supposed to be flammable.
	..()
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src]仍然牢牢固定在地上！"))
		return

	user.visible_message(span_notice("[user]开始拆解[src]。"), span_notice("我开始拆解[src]。"))
	if(!I.use_tool(src, user, 60, 5, 50))
		to_chat(user, span_warning("我没能拆掉[src]。"))
		return

	user.visible_message(span_notice("[user]拆掉了[src]。"), span_notice("我拆掉了[src]。"))
	deconstruct(TRUE)

/obj/structure/mineral_door/proc/crowbar_door(mob/living/user, obj/item/I) //if the door is flammable, call this in crowbar_act() so we can still decon it
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src]仍然牢牢固定在地上！"))
		return

	user.visible_message(span_notice("[user]开始拆解[src]。"), span_notice("我开始拆解[src]。"))
	if(!I.use_tool(src, user, 60, volume = 50))
		to_chat(user, span_warning("我没能拆掉[src]。"))
		return

	user.visible_message(span_notice("[user]拆掉了[src]。"), span_notice("我拆掉了[src]。"))
	deconstruct(TRUE)

//ROGUEDOOR

/obj/structure/mineral_door/wood
	name = "木门"
	desc = ""
	icon_state = "woodhandle"
	openSound = 'sound/foley/doors/creak.ogg'
	closeSound = 'sound/foley/doors/shut.ogg'
	resistance_flags = FLAMMABLE
	max_integrity = 1000
	damage_deflection = 12
	layer = ABOVE_MOB_LAYER
	keylock = TRUE
	icon = 'icons/roguetown/misc/doors.dmi'
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	var/over_state = "woodover"
	repairable = TRUE
	repair_cost_first = /obj/item/grown/log/tree/small
	repair_cost_second = /obj/item/grown/log/tree/small
	repair_skill = /datum/skill/craft/carpentry
	smashable = TRUE
	metalizer_result = /obj/structure/mineral_door/wood/donjon

/obj/structure/mineral_door/wood/Initialize(mapload)
	if(icon_state =="woodhandle")
		if(icon_state != "wcv")
			if(prob(10))
				icon_state = "wcg"
			else if(prob(10))
				icon_state = "wcr"
	if(over_state)
		add_overlay(mutable_appearance(icon, "[over_state]", ABOVE_MOB_LAYER))
	..()

/obj/structure/mineral_door/wood/blue
	icon_state = "wcb"
/obj/structure/mineral_door/wood/red
	icon_state = "wcr"
/obj/structure/mineral_door/wood/violet
	icon_state = "wcv"


/obj/structure/mineral_door/obj_break(damage_flag)
	loud_message("木门碎裂的巨响在四周回荡", hearing_distance = 14)
	. = ..()

/obj/structure/mineral_door/wood/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/wood/attackby(obj/item/I, mob/living/user)
	return ..()

/obj/structure/mineral_door/wood/fire_act(added, maxstacks)
	testing("added [added]")
	if(!added)
		return FALSE
	if(added < 10)
		return FALSE
	..()

/obj/structure/mineral_door/swing_door
	name = "摆门"
	desc = "一扇可以双向推动的门。"
	icon_state = "woodhandle"
	openSound = 'sound/foley/doors/creak.ogg'
	closeSound = 'sound/foley/doors/shut.ogg'
	resistance_flags = FLAMMABLE
	max_integrity = 500
	damage_deflection = 12
	layer = ABOVE_MOB_LAYER
	opacity = FALSE
	windowed = TRUE
	keylock = FALSE
	icon = 'icons/roguetown/misc/doors.dmi'
	icon_state = "swing"
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	repairable = TRUE
	repair_cost_first = /obj/item/grown/log/tree/small
	repair_cost_second = /obj/item/grown/log/tree/small
	repair_skill = /datum/skill/craft/carpentry
	ridethrough = TRUE
	smashable = TRUE
	metalizer_result = null

/obj/structure/mineral_door/wood/window
	opacity = FALSE
	icon_state = "woodwindow"
	windowed = TRUE
	desc = ""
	over_state = "woodwindowopen"
	smashable = TRUE
	metalizer_result = null

/obj/structure/mineral_door/wood/fancywood
	icon_state = "fancy_wood"
	desc = ""
	over_state = "fancy_woodopen"
	smashable = TRUE
	metalizer_result = null

/obj/structure/mineral_door/wood/deadbolt
	desc = "一扇带门闩的木门。"
	icon_state = "wooddir"
	base_state = "wood"
	var/lockdir
	keylock = FALSE
	max_integrity = 1000
	over_state = "woodopen"
	kickthresh = 10
	openSound = 'sound/foley/doors/shittyopen.ogg'
	closeSound = 'sound/foley/doors/shittyclose.ogg'
	smashable = TRUE

/obj/structure/mineral_door/wood/deadbolt/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/mineral_door/wood/deadbolt/Initialize(mapload)
	. = ..()
	lockdir = dir
	icon_state = base_state

/obj/structure/mineral_door/wood/deadbolt/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)

	// If keylock is disabled, implement manual locking behavior
	if(!keylock)
		if(get_dir(src,user) == lockdir)
			if(brokenstate)
				to_chat(user, span_warning("这扇门的门闩已经坏了。"))
				return
			lock_toggle(user)
		else
			to_chat(user, span_warning("只能从有门闩的那一侧操作。"))
		return

	var/obj/item = user.get_active_held_item()
	var/obj/item/roguekey/found_key = null
	var/obj/item/storage/keyring/found_keyring = null

	// Check held item first
	if(istype(item, /obj/item/roguekey))
		found_key = item
	else if(istype(item, /obj/item/storage/keyring))
		found_keyring = item

	// If no key in hand, check all storage items
	if(!found_key && !found_keyring)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/list/checked_items = list()
			var/list/to_check = H.get_all_slots()

			while(to_check.len)
				var/obj/item/I = to_check[1]
				to_check -= I
				if(I in checked_items)
					continue
				checked_items += I

				if(istype(I, /obj/item/roguekey))
					var/obj/item/roguekey/K = I
					if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
						found_key = K
						break
				if(istype(I, /obj/item/storage/keyring))
					var/obj/item/storage/keyring/R = I
					for(var/obj/item/roguekey/K in R.contents)
						if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
							found_keyring = R
							break
					if(found_keyring)
						break
				if(istype(I, /obj/item/storage))
					var/obj/item/storage/S = I
					to_check += S.contents

	if(found_key || found_keyring)
		if(door_opened || isSwitchingStates)
			return ..()
		if(lockbroken)
			to_chat(user, span_warning("这把锁已经坏了。"))
			return
		trykeylock(found_key || found_keyring, user)
	else
		to_chat(user, span_warning("我身上没有能开这扇门的钥匙。"))
		return

/obj/structure/mineral_door/wood/donjon
	desc = "一扇厚重而坚固的铁包木门。"
	icon_state = "donjondir"
	base_state = "donjon"
	keylock = TRUE
	max_integrity = 2000
	over_state = "dunjonopen"
	var/viewportdir
	var/window_closed = TRUE
	kickthresh = 15
	locksound = 'sound/foley/doors/lockmetal.ogg'
	unlocksound = 'sound/foley/doors/lockmetal.ogg'
	rattlesound = 'sound/foley/doors/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	lock_strength = 200
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/carpentry
	metalizer_result = null
	smeltresult = /obj/item/ingot/iron

/obj/structure/mineral_door/wood/donjon/stone
	desc = "一扇沉重的石门。"
	icon_state = "stone"
	base_state = "stone"
	keylock = TRUE
	max_integrity = 1500
	over_state = "stoneopen"
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	repair_cost_first = /obj/item/natural/stone
	repair_cost_second = /obj/item/natural/stone
	repair_skill = /datum/skill/craft/masonry
	smeltresult = null

/obj/structure/mineral_door/wood/donjon/stone/attack_right(mob/user)
	// Check for keys first (inherited from parent)
	var/obj/item/key_item = find_key_for_door(user)
	if(key_item)
		trykeylock(key_item, user)
		return

	// If no key, fall back to parent behavior
	if(user.get_active_held_item())
		return ..()

/obj/structure/mineral_door/wood/donjon/stone/view_toggle(mob/user)
	return

/obj/structure/mineral_door/wood/donjon/stone/MiddleClick(mob/user, params)
	if(user.get_active_held_item())
		return ..()
	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("这扇门上的观察窗已经坏了。"))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("我得站在观察窗那一侧才行。"))
		return

/obj/structure/mineral_door/wood/donjon/Initialize(mapload)
	viewportdir = dir
	icon_state = base_state
	..()

/obj/structure/mineral_door/wood/donjon/MiddleClick(mob/user, params)
	if(user.get_active_held_item())
		return ..()

	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("这扇门上的观察窗已经坏了。"))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("我得站在观察窗那一侧才行。"))
		return

/obj/structure/mineral_door/wood/donjon/proc/view_toggle(mob/user)
	if(door_opened)
		return
	window_closed = !window_closed //opacity == true, so inverting this sets it to false.
	to_chat(user, span_info("我把观察窗[window_closed ? "关上" : "打开"]了。"))
	set_opacity(window_closed)
	playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)

/obj/structure/mineral_door/wood/donjon/set_opacity(setter)
	..()
	if(!window_closed) //Keeps it non-opaque when the door shuts.
		opacity = FALSE
	else
		opacity = setter

/obj/structure/mineral_door/wood/donjon/stone/broken
	desc = "这扇石门已经被砸毁，彻底失去作用。"
	icon_state = "stonebr"
	base_state = "stone"
	density = 0
	opacity = 0
	obj_integrity = 150
	brokenstate = 1
	obj_broken = 1
	repairable = FALSE

/obj/structure/mineral_door/wood/donjon/stone/broken/Initialize(mapload)
	..()
	icon_state = "stonebr" // Weird override otherwise

/obj/structure/mineral_door/wood/donjon/stone/tough
	name = "加固石门"
	desc = "一扇格外结实的门。"
	locked = TRUE
	max_integrity = 2500
	lockdifficulty = 3

/obj/structure/mineral_door/wood/donjon/tough
	name = "加固牢门"
	desc = "一扇格外结实的门。"
	locked = TRUE
	max_integrity = 2500
	lockdifficulty = 3

/obj/structure/mineral_door/bars
	name = "铁栅门"
	desc = ""
	icon_state = "bars"
	openSound = 'sound/foley/doors/ironopen.ogg'
	closeSound = 'sound/foley/doors/ironclose.ogg'
	resistance_flags = null
	max_integrity = 2000
	damage_deflection = 15
	layer = ABOVE_MOB_LAYER
	keylock = TRUE
	icon = 'icons/roguetown/misc/doors.dmi'
	blade_dulling = DULLING_BASH
	opacity = FALSE
	windowed = TRUE
	locksound = 'sound/foley/doors/lock.ogg'
	unlocksound = 'sound/foley/doors/unlock.ogg'
	rattlesound = 'sound/foley/doors/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	ridethrough = TRUE
	swing_closed = FALSE
	lock_strength = 150
	repairable = TRUE
	repair_cost_first = /obj/item/ingot/iron
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/blacksmithing

/obj/structure/mineral_door/bars/tough
	name = "加固铁栅门"
	desc = "一扇格外结实的门。"
	locked = TRUE
	max_integrity = 2500
	lockdifficulty = 3

/obj/structure/mineral_door/barsold
	name = "旧铁栅门"
	desc = ""
	icon_state = "barsold"

/obj/structure/mineral_door/bars/Initialize(mapload)
	. = ..()
	add_overlay(mutable_appearance(icon, "barsopen", ABOVE_MOB_LAYER))


/obj/structure/mineral_door/bars/onkick(mob/user)
	if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
		user.visible_message(span_warning("[user]用尾巴猛撞了[src]！"))
	else
		user.visible_message(span_warning("[user]踢了[src]一脚！"))
	return


/obj/structure/mineral_door/wood/deadbolt/shutter
	name = "传菜窗"
	desc = "一扇可以上下开合的小窗。"
	icon_state = "serving"
	base_state = "serving"
	max_integrity = 250
	over_state = "servingopen"
	openSound = 'modular/Neu_Food/sound/blindsopen.ogg'
	closeSound = 'modular/Neu_Food/sound/blindsclose.ogg'
	dir = NORTH
	locked = TRUE

/obj/structure/mineral_door/wood/towner
	locked = TRUE
	keylock = TRUE
	grant_resident_key = TRUE
	resident_key_type = /obj/item/roguekey/townie
	resident_role = /datum/job/roguetown/villager
	lockid = null //Will be randomized

/obj/structure/mineral_door/wood/mercenary
	locked = TRUE
	keylock = TRUE
	grant_resident_key = TRUE
	resident_key_type = /obj/item/roguekey/townie
	resident_role = /datum/job/roguetown/mercenary
	lockid = null //Will be randomized

/obj/structure/mineral_door/wood/towner/generic

/obj/structure/mineral_door/wood/towner/generic/two_keys
	resident_key_amount = 2

/obj/structure/mineral_door/wood/towner/blacksmith
	resident_advclass = list(/datum/advclass/blacksmith, /datum/advclass/masterblacksmith)
	lockid = "towner_blacksmith"

/obj/structure/mineral_door/wood/towner/cheesemaker
	resident_advclass = list(/datum/advclass/cheesemaker)
	lockid = "towner_cheesemaker"

/obj/structure/mineral_door/wood/towner/miner
	resident_advclass = list(/datum/advclass/miner)
	lockid = "towner_miner"

/obj/structure/mineral_door/wood/towner/seamstress
	resident_advclass = list(/datum/advclass/seamstress)
	lockid = "towner_seamstress"

/obj/structure/mineral_door/wood/towner/woodworker
	resident_advclass = list(/datum/advclass/woodworker)
	lockid = "towner_woodworker"

/obj/structure/mineral_door/wood/towner/fisher
	resident_advclass = list(/datum/advclass/fisher)
	lockid = "towner_fisher"

/obj/structure/mineral_door/wood/towner/hunter
	resident_advclass = list(/datum/advclass/hunter)
	lockid = "towner_hunter"

/obj/structure/mineral_door/wood/towner/witch
	resident_advclass = list(/datum/advclass/witch)
	lockid = "towner_witch"

/obj/structure/mineral_door/wood/bath
	locked = TRUE
	keylock = TRUE
	grant_resident_key = TRUE
	resident_key_type = /obj/item/roguekey/bath
	resident_role = /datum/job/roguetown/nightmaiden
	lockid = null //Will be randomized

/obj/structure/mineral_door/wood/bath/bathmaid
	icon_state = "woodwindow"
	resident_advclass = list(/datum/advclass/nightmaiden)

/obj/structure/mineral_door/wood/bath/courtesan
	resident_advclass = list(/datum/advclass/nightmaiden/concubine, /datum/advclass/nightmaiden/courtesan, /datum/advclass/nightmaiden/dominatrix)

/obj/structure/mineral_door/wood/wretched
	locked = TRUE
	keylock = TRUE
	grant_resident_key = TRUE
	resident_key_type = /obj/item/roguekey/townie// should be every wretch class - ideally we can get resident_role to accept lists but until then this'll do
	resident_advclass = list(/datum/advclass/witch, /datum/advclass/wretch/licker, /datum/advclass/wretch/deserter, /datum/advclass/wretch/deserter/maa, /datum/advclass/wretch/berserker, /datum/advclass/wretch/hedgemage, /datum/advclass/wretch/necromancer, /datum/advclass/wretch/heretic, /datum/advclass/wretch/heretic/spy, /datum/advclass/wretch/outlaw, /datum/advclass/wretch/poacher, /datum/advclass/wretch/plaguebearer, /datum/advclass/wretch/pyromaniac, /datum/advclass/wretch/vigilante, /datum/advclass/wretch/blackoakwyrm, /datum/advclass/wretch/antipope, /datum/advclass/wretch/ancientchampion)
	lockid = null //Will be randomized
