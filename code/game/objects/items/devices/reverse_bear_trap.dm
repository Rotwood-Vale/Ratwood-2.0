/obj/item/reverse_bear_trap
	name = "反向捕熊夹"
	desc = ""
	icon = 'icons/obj/device.dmi'
	icon_state = "reverse_bear_trap"
	slot_flags = ITEM_SLOT_HEAD
	flags_1 = CONDUCT_1
	resistance_flags = FIRE_PROOF | UNACIDABLE
	w_class = WEIGHT_CLASS_NORMAL
	obj_integrity = 300
	max_integrity = 300
	item_state = "rack_parts"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	var/ticking = FALSE
	var/time_left = 60 //seconds remaining until pop
	var/escape_chance = 0 //chance per "fiddle" to get the trap off your head
	var/struggling = FALSE

	var/time_since_last_beep = 0
	var/datum/looping_sound/reverse_bear_trap/soundloop
	var/datum/looping_sound/reverse_bear_trap_beep/soundloop2

/obj/item/reverse_bear_trap/Initialize(mapload)
	. = ..()
	soundloop = new(src)
	soundloop2 = new(src)

/obj/item/reverse_bear_trap/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(soundloop2)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/reverse_bear_trap/process()
	if(!ticking)
		return
	time_left--
	soundloop2.mid_length = max(0.5, time_left - 5) //beepbeepbeepbeepbeep
	if(!time_left || !isliving(loc))
		playsound(src, 'sound/blank.ogg', 100, FALSE)
		soundloop.stop()
		soundloop2.stop()
		to_chat(loc, span_danger("*ding*"))
		addtimer(CALLBACK(src, PROC_REF(snap)), 2)

/obj/item/reverse_bear_trap/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(SLOT_HEAD) == src)
			if(HAS_TRAIT_FROM(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT) && !struggling)
				struggling = TRUE
				var/fear_string
				switch(time_left)
					if(0 to 5)
						fear_string = "痛苦万分地"
					if(5 to 20)
						fear_string = "绝望地"
					if(20 to 40)
						fear_string = "惊慌失措地"
					if(40 to 50)
						fear_string = "颤抖着"
					if(50 to 60)
						fear_string = ""
				C.visible_message(span_danger("[C]慌忙摆弄并拉扯着[src]……"), \
				span_danger("我[fear_string]试着把[src]扯下来……"), "<i>我听见了咔哒声和滴答声。</i>")
				if(!do_after(user, 20, target = src))
					struggling = FALSE
					return
				if(!prob(escape_chance))
					to_chat(user, span_warning("它纹丝不动！"))
					escape_chance++
				else
					user.visible_message(span_warning("[user]头上[name]的锁猛地弹开了！"), \
					span_danger("我硬生生撬开了挂锁！"), "<i>我听见一声清脆而响亮的咔哒声！</i>")
					REMOVE_TRAIT(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT)
				struggling = FALSE
			else
				..()
			return
	..()

/obj/item/reverse_bear_trap/attack(mob/living/target, mob/living/user)
	if(target.get_item_by_slot(SLOT_HEAD))
		to_chat(user, span_warning("先把[target.p_their()]的头部装备摘掉！"))
		return
	target.visible_message(span_warning("[user]开始把[src]强行往[target]头上套！"), \
	span_danger("[target]开始把[src]强行套到你头上！"), "<i>我听见金属碰撞声。</i>")
	to_chat(user, span_danger("我开始把[src]强行往[target]头上套……"))
	if(!do_after(user, 30, target = target) || target.get_item_by_slot(SLOT_HEAD))
		return
	target.visible_message(span_warning("[user]把[src]强行套到[target]头上并锁死了！"), \
	span_danger("[target]把[src]锁死在了你头上！"), "<i>我听见一声咔哒，接着是倒计时的滴答声。</i>")
	to_chat(user, span_danger("我把[src]强行套到[target]头上，并咔哒一声扣死了挂锁。"))
	user.dropItemToGround(src)
	target.equip_to_slot_if_possible(src, SLOT_HEAD)
	arm()
	notify_ghosts("[user]给[target]套上了一个反向捕熊夹！", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, ghost_sound = 'sound/blank.ogg', notify_volume = 75, header = "反向捕熊夹已启动")

/obj/item/reverse_bear_trap/proc/snap()
	reset()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.get_item_by_slot(SLOT_HEAD) != src)
		visible_message(span_warning("[src]的夹口伴着刺耳爆响猛然弹开！"))
		playsound(src, 'sound/blank.ogg', 75, TRUE)
	else
		var/mob/living/carbon/human/jill = loc
		jill.visible_message(span_boldwarning("[src]在[jill]口中猛然爆开，硬生生把[jill.p_their()]的脑袋撕碎了！"), span_danger("[src]爆开了！"))
		jill.emote("scream")
		playsound(src, 'sound/blank.ogg', 75, TRUE, frequency = 0.5)
		playsound(src, 'sound/blank.ogg', 50, TRUE, frequency = 0.5)
		jill.apply_damage(9999, BRUTE, BODY_ZONE_HEAD)
		jill.death() //just in case, for some reason, they're still alive
		flash_color(jill, flash_color = "#FF0000", flash_time = 100)

/obj/item/reverse_bear_trap/proc/reset()
	ticking = FALSE
	REMOVE_TRAIT(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT)
	soundloop.stop()
	soundloop2.stop()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/reverse_bear_trap/proc/arm() //hulen
	ticking = TRUE
	escape_chance = initial(escape_chance) //we keep these vars until re-arm, for tracking purposes
	time_left = initial(time_left)
	ADD_TRAIT(src, TRAIT_NODROP, REVERSE_BEAR_TRAP_TRAIT)
	soundloop.start()
	soundloop2.mid_length = initial(soundloop2.mid_length)
	soundloop2.start()
	START_PROCESSING(SSprocessing, src)
