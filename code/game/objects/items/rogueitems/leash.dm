#define STATUS_EFFECT_LEASH_PET /datum/status_effect/leash_pet
#define STATUS_EFFECT_LEASH_OWNER /datum/status_effect/leash_owner
#define STATUS_EFFECT_LEASH_FREEPET /datum/status_effect/leash_freepet
#define MOVESPEED_ID_LEASH      "LEASH"

/////STATUS EFFECTS/////
//These are mostly used as flags for the states each member can be in

/datum/status_effect/leash_owner
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/leash_owner

/atom/movable/screen/alert/status_effect/leash_owner
	name = "牵绳主人"
	desc = "你手里握着牵绳，另一端还有只可爱的小宠物！"
	icon_state = "leash_master" //These call icons that don't exist, so no icon comes up. Which is good.
		//As a result, the descriptions also don't proc, which is fine.

/datum/status_effect/leash_freepet
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/leash_freepet

/atom/movable/screen/alert/status_effect/leash_freepet
	name = "逃脱的宠物"
	desc = "你还拴在牵绳上，但已经没有主人了。谁抓住牵绳，谁就能控制你！"
	icon_state = "leash_freepet"


/datum/status_effect/leash_pet
	id = "leashed"
	status_type = STATUS_EFFECT_UNIQUE
	var/mob/redirect_component
	alert_type = /atom/movable/screen/alert/status_effect/leash_pet

/atom/movable/screen/alert/status_effect/leash_pet
	name = "被牵住的宠物"
	desc = "你现在被牵住了！可要乖乖听主人的话……"
	icon_state = "leash_pet"


/datum/status_effect/leash_pet/on_apply()
	redirect_component = owner
	if(!owner.stat)
		to_chat(owner, span_userdanger("你被拴上牵绳了！"))
	return ..()

///// OBJECT /////
//The leash object itself
//The component variables are used for hooks, used later.

/obj/item/leash
	name = "绳制牵绳"
	desc = "一条简单的绳索，末端打了个结，便于系在束缚物上。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	icon_state = "leash"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	equip_sound = 'sound/foley/equip/rummaging-01.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	throw_range = 4
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_POCKET //Stop adding item_slot_belt, item_slot_belt is only compatable with inventory storage items and runtimes and breaks when used with anything else.
	force = 1
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 32
	grid_width = 64
	dropshrink = 0.9
	var/mob/living/leash_pet = null //Variable to store our pet later
	var/mob/living/leash_master = null //And our master too
	var/mob/living/leash_freepet = null
	var/var/last_yank = null

/obj/item/leash/leather
	name = "皮制牵绳"
	desc = "一条经过处理的皮带，末端带有金属扣，便于夹在束缚物上。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	icon_state = "leatherleash"
	item_state = "leatherleash"

/obj/item/leash/chain
	name = "链式牵绳"
	desc = "一条结实的金属链，末端带有金属扣，便于夹在束缚物上。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	icon_state = "chainleash"
	item_state = "chainleash"
	resistance_flags = FIRE_PROOF
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'

/obj/item/leash/process(delta_time)
	if(!leash_pet) //No pet, break loop
		w_class = WEIGHT_CLASS_SMALL
		return PROCESS_KILL
	if(!leash_pet.get_item_by_slot(SLOT_NECK)) //The pet has slipped their collar and is not the pet anymore.
		for(var/mob/viewing in viewers(leash_pet, null))
			if(viewing == leash_master)
				to_chat(leash_master, "<span class='notice'>[leash_pet]挣脱项圈了！！</span>", 1)
			else if(viewing == leash_pet)
				to_chat(leash_pet, "<span class='notice'>你从项圈里滑脱了！</span>")
			else
				viewing.show_message("<span class='notice'>[leash_pet]从项圈里挣脱了！</span>")
		leash_pet.remove_status_effect(/datum/status_effect/leash_pet)
		w_class = WEIGHT_CLASS_SMALL

	if(!leash_pet.has_status_effect(/datum/status_effect/leash_pet)) //If there is no pet, there is no dom. Loop breaks.
		if(leash_master) UnregisterSignal(leash_master, COMSIG_MOVABLE_MOVED)
		if(leash_pet) UnregisterSignal(leash_pet, COMSIG_MOVABLE_MOVED)
		if(leash_freepet) UnregisterSignal(leash_freepet, COMSIG_MOVABLE_MOVED)
		leash_pet?.remove_status_effect(/datum/status_effect/leash_freepet)
//		leash_pet.remove_movespeed_modifier(/datum/movespeed_modifier/leash)
		leash_master?.remove_status_effect(/datum/status_effect/leash_owner)
		leash_freepet = null
		leash_master = null
		leash_pet = null
		w_class = WEIGHT_CLASS_SMALL
		return PROCESS_KILL

//Called when someone is clicked with the leash
/obj/item/leash/attack(mob/living/carbon/C, mob/living/user)
	var/obj/item/collar = C.get_item_by_slot(SLOT_NECK)
	if(C.has_status_effect(/datum/status_effect/leash_pet))
		to_chat(user, span_notice("[C]已经被拴住了。"))
		return

	if(C.cmode && C.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_warning("我没法给他们套牵绳，他们太紧张了！"))
		return

	if(src.leash_pet != null)
		to_chat(user, span_warning("这条牵绳已经拴在[leash_pet]身上了！"))
		return

	if((collar && collar:leashable == TRUE) || istype(C.get_item_by_slot(SLOT_HANDCUFFED), /obj/item/rope/chain))
		var/leash_attempt_message = "[user]把[src]抬向了[C]的脖子！"
		for(var/mob/viewing in viewers(C, null))
			if(viewing == C)
				to_chat(C, "<span class='warning'>[user]开始把[src]套向我的脖子！</span>")
			else if(viewing == user)
				to_chat(user, "<span class='warning'>我开始把[src]套向[C]的脖子！</span>")
			else
				viewing.show_message("<span class='warning'>[leash_attempt_message]</span>", 1)

		var/leashtime = 50
		if(C.handcuffed)
			leashtime = 5
		if(do_mob(user, C, leashtime)) //do_mob adds a progress bar, but then we also check to see if they have a collar
			log_combat(user, C, "拴上牵绳", addition="嬉闹地")
			C.apply_status_effect(/datum/status_effect/leash_pet)//Has now been leashed
			leash_pet = C //Save pet reference for later
			w_class = WEIGHT_CLASS_BULKY //This plus ITEM_SLOT_POCKET prevents putting into backpacks and other storage while still fitting on belt. When process kills, weightclass is returned to smol and backpackable.
			if(!(user == leash_pet)) //Pet leashed themself. They are not the dom
				leash_master = user //Save dom reference for later
				user.apply_status_effect(/datum/status_effect/leash_owner) //Is the leasher
				RegisterSignal(leash_master, COMSIG_MOVABLE_MOVED, PROC_REF(on_master_move))
				RegisterSignal(leash_pet, COMSIG_MOVABLE_MOVED, PROC_REF(on_pet_move))
//			if(!leash_pet.has_status_effect(/datum/status_effect/leash_owner)) //Add slowdown if the pet didn't leash themselves
//				leash_pet.add_movespeed_modifier(/datum/movespeed_modifier/leash)
			for(var/mob/viewing in viewers(user, null))
				if(viewing == user)
					to_chat(user, span_warning("你把牵绳扣在了[leash_pet]身上！"))
				else
					viewing.show_message(span_warning("[leash_pet]被[user]拴上了牵绳！"), 1)
			START_PROCESSING(SSfastprocess, src) // The original while loop here ran every 2 deciseconds, and so does SSfastprocess.
	else //No collar, no fun
		var/leash_message = pick("[C]得先戴上项圈，你才能把牵绳拴上去。")
		to_chat(user, span_notice("[leash_message]"))

//Called when the leash is used in hand
//Tugs the pet closer
/obj/item/leash/attack_self(mob/living/user)
	if(!leash_pet) //No pet, no tug.
		return
	if(!leash_master) //No pets yanking their own leash.
		return
	if(world.time < last_yank + 15)
		return
	//Yank the pet. Yank em in close.
	apply_tug_mob_to_mob(leash_pet, leash_master, 1)
	log_combat(leash_master, leash_pet, "猛拽牵绳")
	leash_pet.visible_message(span_warning("[leash_master]用[src.name]把[leash_pet]猛地拽近了。"))

//Figure this out in leashs part 2
/*
	if(istype(src, obj/item/leash/chain))
		playsound(src, pick(list('sound/foley/equip/equip_armor_chain.ogg',\
													'sound/foley/dropsound/chain_drop.ogg'), 50, 100))
*/
	last_yank = world.time

/obj/item/leash/proc/on_master_move()
	SIGNAL_HANDLER
	//Make sure the dom still has a pet
	if(!leash_master) //There must be a master
		return
	if(!leash_pet) //There must be a pet
		return
	if(leash_pet == leash_master) //Pet is the master
		return
	if(!leash_pet.has_status_effect(/datum/status_effect/leash_pet))
		return
	addtimer(CALLBACK(src, PROC_REF(after_master_move)), 0.1 SECONDS)

/obj/item/leash/proc/after_master_move()
	//If the master moves, pull the pet in behind
	//Also, the timer means that the distance check for master happens before the pet, to prevent both from proccing.

	if(leash_master == null) //Just to stop error messages
		return
	if(leash_pet == null)
		return
	apply_tug_mob_to_mob(leash_pet, leash_master, 1)
	if(leash_pet.cmode && leash_master.m_intent == MOVE_INTENT_RUN) //stamina infliction Calls if pet has combatmode enabled while master has run intent active.
		leash_master.stamina_add(1)
		
	//Knock the pet over if they get further behind. Shouldn't happen too often.
	sleep(3) //This way running normally won't just yank the pet to the ground.
	if(!leash_master) //Just to stop error messages. Break the loop early if something removed the master
		return
	if(!leash_pet)
		return
	if(get_dist(leash_pet, leash_master) > 3)
		leash_pet.visible_message(
			span_warning("[leash_pet]被牵绳拽倒在地！"),
			span_warning("你被牵绳拽倒在地！")
		)
		leash_pet.apply_effect(20, EFFECT_KNOCKDOWN, 0)

	//This code is to check if the pet has gotten too far away, and then break the leash.
	sleep(3) //Wait to snap the leash
	if(!leash_master) //Just to stop error messages
		return
	if(!leash_pet)
		return
	if(get_dist(leash_pet, leash_master) > 5)
		var/leash_break_message = "牵绳从[leash_pet]身上崩开了！"
		for(var/mob/viewing in viewers(leash_pet, null))
			if(viewing == leash_master)
				to_chat(leash_master, "<span class='warning'>牵绳从你的宠物身上崩开了！</span>")
			if(viewing == leash_pet)
				to_chat(leash_pet, "<span class='warning'>你的牵绳从项圈上弹开了！</span>")
			else
				viewing.show_message("<span class='warning'>[leash_break_message]</span>", 1)
		leash_pet.apply_effect(20, EFFECT_KNOCKDOWN, 0)
		leash_pet.adjustOxyLoss(5)
		leash_pet.remove_status_effect(/datum/status_effect/leash_pet)
//		leash_pet.remove_movespeed_modifier(/datum/movespeed_modifier/leash)

/obj/item/leash/proc/on_pet_move()
	SIGNAL_HANDLER
	//This should only work if there is a pet and a master.
	//This is here pretty much just to stop the console from flooding with errors
	if(!leash_master)
		return
	if(!leash_pet)
		return
	//Make sure the pet is still a pet
	if(!leash_pet.has_status_effect(/datum/status_effect/leash_pet))
		UnregisterSignal(leash_pet, COMSIG_MOVABLE_MOVED)
		return

	//The pet has escaped. There is no DOM. GO PET RUN.
	if(leash_pet.has_status_effect(/datum/status_effect/leash_freepet))//If the pet is free, break
		return
	//If the pet gets too far away, they get tugged back
	addtimer(CALLBACK(src, PROC_REF(after_pet_move)), 0.2 SECONDS) //A short timer so the pet kind of bounces back after they make the step

/obj/item/leash/proc/after_pet_move()
	if(!leash_master)
		return
	if(!leash_pet)
		return
	for(var/i in 2 to get_dist(leash_pet, leash_master)) // Move the pet to a minimum of 1 tiles away from the master, so the pet trails behind them.
		step_towards(leash_pet, leash_master)

/obj/item/leash/proc/on_freepet_move()
	SIGNAL_HANDLER
	//Pet is on the run. Let's drag the leash behind them.
	if(leash_master) //If there is a master, don't do this
		return
	if(!leash_pet) //If there is no pet, don't do this
		return
	if(leash_pet.is_holding(src) || leash_pet.get_item_by_slot(ITEM_SLOT_HIP) == src) //If the pet is holding the leash, don't do this
		return

	//If the pet gets too far away, we get tugged to them.
	addtimer(CALLBACK(src, PROC_REF(after_freepet_move)), 0.1 SECONDS, TIMER_UNIQUE) //A short timer so the leash trails behind us.

/obj/item/leash/proc/after_freepet_move()
	if(!leash_pet)
		return

	for(var/i in 2 to get_dist(src, leash_pet)) // Move us to a minimum of 1 tiles away from the pet, so we trail behind them.
		step_towards(src, leash_pet)

	sleep(1)
	//Just to prevent error messages
	if(!leash_pet)
		return
	if(get_dist(src, leash_pet) > 5)
		var/leash_break_message = "拴绳从[leash_pet]身上崩开了！"
		for(var/mob/viewing in viewers(leash_pet, null))
			if(viewing == leash_master)
				to_chat(leash_master, "<span class='warning'>拴绳从我的宠物身上崩开了！</span>")
			if(viewing == leash_pet)
				to_chat(leash_pet, "<span class='warning'>我的拴绳从项圈上脱开了！</span>")
			else
				viewing.show_message("<span class='warning'>[leash_break_message]</span>", 1)

		leash_pet.apply_effect(20, EFFECT_KNOCKDOWN, 0)
		leash_pet.adjustOxyLoss(5)
		leash_pet.remove_status_effect(/datum/status_effect/leash_pet)

//The proc below in question is the one causing all the errors apparently

/obj/item/leash/dropped(mob/user, silent)
	//Drop the leash, and the leash effects stop
	. = ..()
	if(!leash_pet) //There is no pet. Stop this silliness
		return
	//Dropping procs any time the leash changes slots. So, we will wait a tick and see if the leash was actually dropped
	addtimer(CALLBACK(src, PROC_REF(drop_effects), user, silent), 1)

/obj/item/leash/proc/drop_effects(mob/user, silent)
	SIGNAL_HANDLER
	if(leash_master == user)
		if(leash_master.is_holding(src) || leash_master.get_item_by_slot(ITEM_SLOT_HIP) == src)
			return  //Dom still has the leash as it turns out. Cancel the proc.
	if(!leash_pet)
		return
	user.visible_message(span_notice("[user]丢下了[src]。"), span_notice("我丢下了[src]。"))
	//DOM HAS DROPPED LEASH. PET IS FREE. SCP HAS BREACHED CONTAINMENT.
//	leash_pet.remove_movespeed_modifier(/datum/movespeed_modifier/leash)
	if(leash_pet)
		leash_freepet = leash_pet
		UnregisterSignal(leash_pet, COMSIG_MOVABLE_MOVED)
		leash_pet.apply_status_effect(/datum/status_effect/leash_freepet)
		RegisterSignal(leash_freepet, COMSIG_MOVABLE_MOVED, PROC_REF(on_freepet_move))
		leash_master?.remove_status_effect(/datum/status_effect/leash_owner) //No dom with no leash. We will get a new dom if the leash is picked back up.
		UnregisterSignal(leash_master, COMSIG_MOVABLE_MOVED)
		leash_master = null

/obj/item/leash/equipped(mob/user, slot, initial = FALSE, silent = FALSE)
	. = ..()
	if(!leash_pet) //Don't apply statuses with a petless leash.
		return
	addtimer(CALLBACK(src, PROC_REF(equip_effects), user), 2)

/obj/item/leash/proc/equip_effects(mob/user)
	if(!leash_pet)
		return
	if(leash_master == user)
		return // Don't double-register.
	if(leash_pet == user) //Pet picked up their own leash.
		UnregisterSignal(leash_freepet, COMSIG_MOVABLE_MOVED)
		leash_pet.remove_status_effect(/datum/status_effect/leash_freepet)
		leash_freepet = null
		return
	leash_master = user
	leash_master.apply_status_effect(/datum/status_effect/leash_owner)
	UnregisterSignal(leash_freepet, COMSIG_MOVABLE_MOVED)
	RegisterSignal(leash_master, COMSIG_MOVABLE_MOVED, PROC_REF(on_master_move))
	RegisterSignal(leash_pet, COMSIG_MOVABLE_MOVED, PROC_REF(on_pet_move))
	leash_pet.remove_status_effect(/datum/status_effect/leash_freepet)
	leash_freepet = null
//	leash_pet.add_movespeed_modifier(/datum/movespeed_modifier/leash)

// These procs were made for travel tiles and are called in traveltile.dm. But they might have uses elsewhere.

/proc/leashed_by_other(mob/living/L)
	if(L.has_status_effect(/datum/status_effect/leash_pet))
		for(var/obj/item/leash/held_leash in L.contents)
			if(held_leash.leash_pet == L)
				return FALSE
		for(var/obj/item/leash/dropped_freepet_leash in view(5, L))
			if(dropped_freepet_leash.leash_pet == L)
				return FALSE
		return TRUE
	return FALSE

/proc/get_master_leashed_mobs(mob/living/L, do_not_remove = TRUE)
	var/list/master_leashed_mobs = list()
	if(L.has_status_effect(/datum/status_effect/leash_owner))
		for(var/obj/item/leash/leash in L.contents)
			var/mob/living/nearby_pet
			for(var/mob/living/target in view(5, L) - L)
				if((L == leash.leash_master) && (target == leash.leash_pet))  // As of writing, you are not considered a master for leashing yourself, or for holding your own leash.
					nearby_pet = target
					break
			if(!nearby_pet)
				if(leash.leash_pet && !do_not_remove) // leash will unregister them next process(), to not spontaneously throw pet up a z-level
					leash.leash_pet.remove_status_effect(/datum/status_effect/leash_pet)
				continue
			else
				master_leashed_mobs += nearby_pet
	return master_leashed_mobs

/proc/get_freepet_leash(atom/movable/subject)
	if(!isliving(subject))
		return
	var/mob/living/L = subject
	if(L.has_status_effect(/datum/status_effect/leash_freepet))
		for(var/obj/item/leash/leash in view(5, L))
			if(leash.leash_freepet == L)
				return leash
	return null

/*/datum/movespeed_modifier/leash
	id = MOVESPEED_ID_LEASH
	multiplicative_slowdown = 5 */

/obj/item/catbell
	name = "猫铃"
	desc = "一只叮当作响的小猫铃。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	icon_state = "catbell"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	throw_range = 4
	force = 1
	throwforce = 1
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.8
	var/last_ring
	/// Sounds that this bell can make when it jingles
	var/list/jingle_sounds = SFX_COLLARJINGLE

/obj/item/catbell/cow
	name = "牛铃"
	desc = "一只叮当作响的小牛铃。"
	icon_state = "cowbell"
	jingle_sounds = SFX_CBJINGLE

/obj/item/catbell/attack_self(mob/living/user)
	if(world.time < last_ring + 15)
		return
	user.visible_message(span_info("[user]开始摇响[src]。"))
	playsound(src, 'sound/items/jinglebell1.ogg', 100, extrarange = 8, ignore_walls = TRUE)
	flick("bell_commonpressed", src)
	last_ring = world.time


//Bell attachment onto collars
/obj/item/catbell/attack(mob/living/carbon/target, mob/living/user)
	var/obj/item/clothing/neck/roguetown/collar/leather/collar = target.get_item_by_slot(SLOT_NECK)
	if(!istype(collar))
		to_chat(user, "[target]得先戴着项圈，才能挂上铃铛！")
		return
	if(collar.bell)
		to_chat(user, "[target]的项圈上已经有铃铛了！")
		return
	target.visible_message(span_warning("[user]开始把[src]抬向[target]的脖子！"), span_warning("[user]开始把[src]抬向我的脖子！"), span_hear("我听见[src]叮当作响。"), ignored_mobs = user)
	to_chat(user, span_warning("我开始把[src]抬向[target]的脖子！"))
	if(!do_mob(user, target, target.handcuffed ? 0.5 SECONDS : 5 SECONDS))
		return
	log_combat(user, target, "put a bell on")
	user.visible_message(span_warning("[user]把[src]扣在了[target]的[collar.name]上！"), span_warning("我把[src]扣在了[target]的[collar.name]上！"))
	collar.bell = TRUE
	collar.bellsound = TRUE
	collar.AddComponent(/datum/component/squeak, jingle_sounds, 50, 100, 1)
	if(istype(src, /obj/item/catbell/cow))
		collar.icon_state = /obj/item/clothing/neck/roguetown/collar/cowbell::icon_state
		collar.desc = "一条挂着叮当作响牛铃的皮项圈。"
		collar.name = "牛铃项圈"
	else
		collar.icon_state = /obj/item/clothing/neck/roguetown/collar/catbell::icon_state
		collar.desc = "一条挂着叮当作响猫铃的皮项圈。"
		collar.name = "猫铃项圈"
	target.update_inv_neck()
	forceMove(collar) // move us inside the collar so that if we salvage it, we get the bell back


/datum/crafting_recipe/roguetown/smithing/catbell
	name = "猫铃"
	result = /obj/item/catbell
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Smithing"
	req_table = TRUE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/smithing/cowbell
	name = "牛铃"
	result = /obj/item/catbell/cow
	reqs = list(/obj/item/ingot/iron = 1)
	category = "Smithing"
	req_table = TRUE
	always_availible = TRUE
