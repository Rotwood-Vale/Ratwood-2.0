
/obj/item/bomb
	name = "瓶装炸弹"
	desc = "一场炽烈爆炸，正等待着从它的玻璃牢笼中被引发。"
	icon_state = "bbomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	var/fuze = null
	var/lit = FALSE
	var/prob2fail = 5
	grid_width = 32
	grid_height = 64
	dropshrink = 0.7

/obj/item/bomb/Initialize(mapload)
	..()
	fuze = rand(40,60)

/obj/item/bomb/spark_act()
	light()

/obj/item/bomb/fire_act()
	light()

/obj/item/bomb/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/bomb/proc/light()
	if(lit)
		return
	START_PROCESSING(SSfastprocess, src)
	icon_state += "-lit"
	lit = TRUE
	playsound(loc, 'sound/items/firelight.ogg', 100)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/bomb/extinguish()
	snuff()

/obj/item/bomb/proc/snuff()
	if(!lit)
		return
	lit = FALSE
	STOP_PROCESSING(SSfastprocess, src)
	playsound(loc, 'sound/items/firesnuff.ogg', 100)
	icon_state = "bbomb"
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(!skipprob && prob(prob2fail))
		snuff()
		return FALSE
	qdel(src)
	playsound(T, 'sound/items/firesnuff.ogg', 100)
	new /obj/item/natural/glass_shard(T)
	explosion(T, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	return TRUE

/obj/item/bomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	sleep(1)
	explode()

/obj/item/bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/bomb/attackby(obj/item/I, mob/user, params)
	..()

	if(!istype(I, /obj/item/natural/fibers))
		return
	
	I.visible_message(
		span_warning("[user]开始布置[src]……"),
		span_notice("我开始用[I]布置[src]。")
	)

	qdel(I)

	if(!do_after(user, 7 SECONDS - user.get_skill_level(/datum/skill/craft/crafting), TRUE, src))
		to_chat(user, span_warning("我停止布置[src]了。"))
		new /obj/item/natural/fibers(user.loc)
		if(prob(10))
			to_chat(user, span_warningbig("糟了。"))
			light()
		return
	
	var/obj/item/bomb/tripbomb/trip = new /obj/item/bomb/tripbomb(get_turf(src))
	trip.b_type = type
	trip.icon_state = icon_state
	trip.add_overlay("tripbomb")
	trip.update_icon()
	trip.prob2fail = prob2fail

	var/obj/item/tripwire/wire = new /obj/item/tripwire(get_turf(user))
	wire.dir = get_dir(loc, user)
	to_chat(user, get_dir(loc, user))
	wire.payload = trip

	trip.wire_trigger.Add(wire)

	qdel(src)

	I.visible_message(
		span_warning("[user]完成了[trip]的布置。"),
		span_notice("我完成了[trip]的布置。还能再把它延长一格。")
	)
	return

/obj/item/bomb/tripbomb
	name = "绊线炸弹"
	desc = "一场爆炸正等待着从它的玻璃牢笼中被引发。而这一个正潜伏着。"
	icon_state = "bbomb"
	w_class = WEIGHT_CLASS_NORMAL
	anchored = TRUE
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	fuze = 2 SECONDS
	grid_width = 32
	grid_height = 64
	var/obj/item/bomb/b_type = /obj/item/bomb
	var/list/obj/item/tripwire/wire_trigger = list()

/obj/item/bomb/tripbomb/Initialize(mapload)
	..()
	icon_state = b_type.icon_state

/obj/item/bomb/tripbomb/attackby(obj/item/I, mob/user, params)
	if(user.used_intent.blade_class == BCLASS_CUT && I.wlength == WLENGTH_SHORT)
		if(!do_after(user, 7 SECONDS - user.get_skill_level(/datum/skill/craft/crafting), TRUE, src))
			to_chat(user, span_warning("我停止拆解[src]了。"))
			if(!prob(user.get_skill_level(/datum/skill/craft/crafting) * 10))
				to_chat(user, span_warningbig("糟了。"))
				light()
		for(var/list/obj/item/tripwire/t_wire in wire_trigger)
			QDEL_NULL(t_wire)
		new b_type(loc)
		QDEL_NULL(src)
		return ..()
	if(istype(I, /obj/item/natural/dirtclod))
		var/skill = user.get_skill_level(/datum/skill/craft/crafting)
		alpha = (90 - skill * 5)
		qdel(I)
	..()

/obj/item/bomb/tripbomb/Destroy()
	..()

	if(wire_trigger.len)
		for(var/list/obj/item/tripwire/wire in wire_trigger)
			QDEL_NULL(wire)

/obj/item/bomb/tripbomb/light()
	var/obj/item/bomb/bomb = new b_type (loc)
	bomb.fuze = 1 SECONDS
	QDEL_NULL(src)
	bomb.light()

/obj/item/tripwire
	name = "纤维绊线"
	desc = "你差点就没发现它了，呼。最好用刀刃割断来解除它。"
	icon = 'icons/roguetown/items/misc.dmi'	
	icon_state = "wire"
	anchored = TRUE
	var/obj/item/bomb/tripbomb/payload

/obj/item/tripwire/Destroy()
	..()
	new /obj/item/natural/fibers(loc)

/obj/item/tripwire/attackby(obj/item/I, mob/user, params)
	if(user.used_intent.blade_class == BCLASS_CUT && I.wlength == WLENGTH_SHORT)
		if(!do_after(user, 7 SECONDS - user.get_skill_level(/datum/skill/craft/crafting), TRUE, src))
			to_chat(user, span_warning("我停止拆解[src]了。"))
			if(!prob(user.get_skill_level(/datum/skill/craft/crafting) * 10))
				to_chat(user, span_warningbig("糟了。"))
				payload.light()

		for(var/list/obj/item/tripwire/t_wire in payload.wire_trigger)
			QDEL_NULL(t_wire)
		new payload.b_type(payload.loc)
		QDEL_NULL(payload)
		return ..()
	
	if(istype(I, /obj/item/natural/dirtclod))
		var/skill = user.get_skill_level(/datum/skill/craft/crafting)
		alpha = (90 - skill * 5)
		qdel(I)

	if(istype(I, /obj/item/natural/fibers))
		if(payload.wire_trigger.len == 2)
			to_chat(user, span_warning("[src]已经不能再延长了。"))
			return ..()
		if(!do_after(user, 7 SECONDS - user.get_skill_level(/datum/skill/craft/crafting), TRUE, src))
			to_chat(user, span_warning("我停止延长[src]了。"))
			return ..()

		var/obj/item/tripwire/wire = new /obj/item/tripwire(get_ranged_target_turf(src, dir, 1))
		wire.dir = dir
		wire.payload = payload

		payload.wire_trigger.Add(wire)
		qdel(I)

	..()

/obj/item/tripwire/Crossed(atom/movable/O)
	..()

	if(!isliving(O))
		return
	var/mob/living/carbon/human/victim = O
	if(victim.STALUC >= 10)
		if(prob((victim.STALUC - 10) * 10))
			to_chat(victim, span_warning("你的脚险些碰到[src]。小心点！"))
			return
	playsound(victim, 'sound/items/knife_open.ogg', 100, TRUE)
	victim.visible_message(
		span_warningbig("[victim]踩中了[src]！"),
		span_warningbig("我感觉到靴底下的细绳绷断了！")
	)
	payload.light()
	for(var/list/obj/item/tripwire/t_wire in payload.wire_trigger)
		QDEL_NULL(t_wire)

/obj/item/bomb/smoke
	name = "烟雾弹"
	desc = "一个柔软球体，内部藏有炼金混合物与散布机构。任何压力都会引爆它。"
	icon_state = "smokebomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	grid_width = 32
	grid_height = 64
	fuze = 0 SECONDS
	var/radius = 3

/obj/item/bomb/smoke/attack_self(mob/user)
	..()
	light()

/obj/item/bomb/smoke/ex_act()
	if(!QDELETED(src))
		..()
	light()

/obj/item/bomb/smoke/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	light()

/obj/item/bomb/smoke/spark_act()
	return

/obj/item/bomb/smoke/fire_act()
	return

/obj/item/bomb/smoke/light()
	explode()

/obj/item/bomb/smoke/explode()
	var/turf/T = get_turf(src)
	if(!T) 
		return FALSE
	playsound(loc, 'sound/items/smokebomb.ogg', 50)
	var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread
	smoke.set_up(radius, T)
	smoke.start()
	new /obj/item/ash(T)
	qdel(src)

/obj/item/grenade/smokebomb
	parent_type = /obj/item/bomb/smoke


/obj/item/tntstick
	name = "爆粉棒"
	desc = "包在纸壳里的少量爆粉……"
	icon_state = "tnt_stick"
	var/lit_state = "tnt_stick-lit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	throw_range = 6
	var/fuze = 5.5 SECONDS
	var/lit = FALSE
	var/prob2fail = 1

/obj/item/tntstick/spark_act()
	light()

/obj/item/tntstick/fire_act()
	light()

/obj/item/tntstick/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/tntstick/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()
/obj/item/tntstick/attack_self(mob/user)
	..()
	extinguish()

/obj/item/tntstick/extinguish()
	snuff()

/obj/item/tntstick/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/tntstick/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, devastation_range = 2, heavy_impact_range = 4, light_impact_range = 6, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
				loud_message("一声沉闷的爆炸在听见者耳中回响", hearing_distance = 14)
				qdel(src) //IMPORTANT!! go into walls /turf/closed/wall/ and see /turf/closed/wall/ex_act. Its bounded with /proc/explosion. Same for /obj/structure and /obj/structure/ex_act because if you going to fuck intergity or whatever this shit called players will skin you alive for breaking their equipment and keys
		else //also /turf/open/floor/ex_act for comment above
			if(prob(prob2fail))
				snuff()

/obj/item/tntstick/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/satchel_bomb
	name = "爆粉挎包"
	desc = "一个装满爆粉的挎包……"
	icon_state = "satchel_bomb"
	var/lit_state = "satchel_bomb-lit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	throw_range = 2
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.3
	dropshrink = 0.8
	var/fuze = 15 SECONDS
	var/lit = FALSE
	var/prob2fail = 1

/obj/item/satchel_bomb/spark_act()
	light()

/obj/item/satchel_bomb/fire_act()
	light()

/obj/item/satchel_bomb/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/satchel_bomb/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/satchel_bomb/attack_self(mob/user)
	..()
	extinguish()

/obj/item/satchel_bomb/extinguish()
	snuff()

/obj/item/satchel_bomb/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/satchel_bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, devastation_range = 5, heavy_impact_range = 6, light_impact_range = 10, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
				loud_message("一声巨响在所有听见者耳中炸开", hearing_distance = 28)
				qdel(src)

		else
			if(prob(prob2fail))
				snuff()

/obj/item/satchel_bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/impact_grenade
	name = "碰炸手雷"
	desc = "某种物质，被包藏在纸张之下。"
	dropshrink = 0.6
	icon_state = "impact_grenade"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1
	grid_width = 32
	grid_height = 32
	dropshrink = 0.75

/obj/item/impact_grenade/Initialize(mapload)
	. = ..()

// Define a base explodes() proc that subtypes can override because its now explodes proc
/obj/item/impact_grenade/proc/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	qdel(src) // Delete the grenade after use boy (ALWAYS USE IT)

/obj/item/impact_grenade/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	sleep(1)
	explodes()

/obj/item/impact_grenade/attack_self(mob/user)
	..()
	explodes() 

/obj/item/impact_grenade/explosion
	name = "碰炸手雷"
	desc = "某种物质，被包藏在纸张与外皮之下。这个正在冒火花……"

/obj/item/impact_grenade/explosion/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		explosion(T, heavy_impact_range = 1, light_impact_range = 2, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
		qdel(src)

/obj/item/smokeshell
	name = "喷气壳"
	desc = "一个用来喷出气体的金属弹壳。"
	dropshrink = 0.6
	icon_state = "smokeshell_blank"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1
	grid_width = 32
	grid_height = 32

/obj/item/impact_grenade/smoke
	name = "喷气器"
	desc = "一个喷气器。这个会喷出无害烟雾……"
	dropshrink = 0.6
	icon_state = "smokeshell_blue"
	var/datum/effect_system/smoke_spread/smoke_type = /datum/effect_system/smoke_spread
	grid_width = 32
	grid_height = 32


/obj/item/impact_grenade/smoke/explodes()
	var/turf/T = get_turf(src)
	playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
	var/datum/effect_system/smoke_spread/smoke = new smoke_type
	new /obj/item/smokeshell (get_turf(src.loc)) //leaving the empty case behind
	smoke.set_up(2, T) // radius of 2 around T
	smoke.start()
	..() // stop processing and delete self

/obj/item/impact_grenade/smoke/poison_gas
	name = "毒气喷气器"
	desc = "一个喷气器。这个的气味会让你喘不过气……"
	icon_state = "smokeshell_green"
	smoke_type = /datum/effect_system/smoke_spread/poison_gas

/obj/item/impact_grenade/smoke/healing_gas
	name = "疗愈喷气器"
	desc = "一个喷气器。这个的气味让你想起红色的味道……"
	icon_state = "smokeshell_red"
	smoke_type = /datum/effect_system/smoke_spread/healing_gas


/obj/item/impact_grenade/smoke/fire_gas
	name = "燃烧喷气器"
	desc = "一个喷气器。它闻起来像鸡肉，还会灼伤你的手……"
	icon_state = "smokeshell_orange"
	smoke_type = /datum/effect_system/smoke_spread/fire_gas

/obj/item/impact_grenade/smoke/blind_gas
	name = "致盲喷气器"
	desc = "一个喷气器。这东西的气味会让你眼泪直流。"
	icon_state = "smokeshell_blue"
	smoke_type = /datum/effect_system/smoke_spread/blind_gas

/obj/item/impact_grenade/smoke/mute_gas
	name = "静默喷气器"
	desc = "一个喷气器。这东西的气味会让你脑中一片空白，舌头也动弹不得。"
	icon_state = "smokeshell_purple"
	smoke_type = /datum/effect_system/smoke_spread/mute_gas	
