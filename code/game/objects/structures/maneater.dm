
/obj/structure/flora/roguegrass/maneater
	name = "草"
	desc = "青翠鲜活。刚才那是一根藤蔓吗？"
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	max_integrity = 5

/obj/structure/flora/roguegrass/maneater/update_icon()
	return

/obj/structure/flora/roguegrass/maneater/real
	var/aggroed = 0
	max_integrity = 100
	integrity_failure = 0.15
	attacked_sound = list('sound/vo/mobs/plant/pain (1).ogg','sound/vo/mobs/plant/pain (2).ogg','sound/vo/mobs/plant/pain (3).ogg','sound/vo/mobs/plant/pain (4).ogg')
	var/list/eatablez = list(/obj/item/bodypart, /obj/item/organ, /obj/item/reagent_containers/food/snacks/rogue/meat)
	var/last_eat
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	var/seednutrition = 0
	var/max_seednutrition = 100
	var/mob/planter = null

/obj/structure/flora/roguegrass/maneater/real/process()
	if(seednutrition >= max_seednutrition)
		produce_seed()
		seednutrition = 0
	if(world.time > aggroed + 30 SECONDS && !has_buckled_mobs())
		aggroed = 0
		update_icon()
		STOP_PROCESSING(SSobj, src)
		return TRUE

/obj/structure/flora/roguegrass/maneater/real/obj_break(damage_flag)
	..()
	unbuckle_all_mobs()
	if(contents.len)
		for(var/obj/item/eaten in contents)
			var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), 1)
			playsound(src,'sound/misc/maneaterspit.ogg', 100)
			eaten.forceMove(target)
			contents.Remove(eaten)
	STOP_PROCESSING(SSobj, src)

/obj/structure/flora/roguegrass/maneater/real/Destroy()
	unbuckle_all_mobs()
	if(contents.len)
		for(var/obj/item/eaten in contents)
			var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), 1)
			playsound(src,'sound/misc/maneaterspit.ogg', 100)
			eaten.forceMove(target)
			contents.Remove(eaten)
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/flora/roguegrass/maneater/real/Crossed(atom/movable/AM)
	..()
	if(obj_broken)
		return
	if(world.time <= last_eat + 8 SECONDS)
		return
	if(has_buckled_mobs())
		return

	if(!aggroed)
		START_PROCESSING(SSobj, src)
	aggroed = world.time
	update_icon()

	if(!isliving(AM))
		if(is_type_in_list(AM, eatablez))
			last_eat = world.time
			playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
			AM.forceMove(src)
			seednutrition += 10
		return

	var/mob/living/victim = AM
	if(victim == planter)
		return
	if(!victim.ambushable())
		return
	if(victim.m_intent == MOVE_INTENT_SNEAK)
		return

	buckle_mob(victim, TRUE, check_loc = FALSE)
	visible_message(span_warningbig("[src]开始啃咬[victim]！"))
	addtimer(CALLBACK(src, PROC_REF(begin_eat), victim), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/structure/flora/roguegrass/maneater/real/proc/begin_eat(mob/living/victim, chew_factor = 1)
	if(victim.loc != loc)
		return
	if(!(has_buckled_mobs() && victim.buckled))
		return

	visible_message(span_warning("[src]咀嚼着[victim]！"))

	playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
	if(!iscarbon(victim))
		victim.adjustBruteLoss(20)
	else
		var/zone = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/limb = victim.get_bodypart(zone)
		if(!limb)
			begin_eat(victim)
		victim.flash_fullscreen("redflash3")
		playsound(loc, list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
		if(prob(chew_factor * 15))
			if(limb.dismember(damage = 20))
				limb.forceMove(src)
				seednutrition += 25
				if(!victim.mind)
					victim.gib()
					seednutrition += 25
					return
				maneater_spit_out(victim)
		else
			victim.run_armor_check(zone, BCLASS_CUT, damage = 20)

	if(victim.stat == DEAD || victim.stat == UNCONSCIOUS)
		if(!victim.mind)
			victim.gib()
			seednutrition += 50
			return
		maneater_spit_out(victim)

	last_eat = world.time
	addtimer(CALLBACK(src, PROC_REF(begin_eat), victim, chew_factor * 2), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/structure/flora/roguegrass/maneater/real/proc/maneater_spit_out(mob/living/C)
	if(!C)
		return
	if(!isliving(C))
		return
	visible_message(span_danger("[src]把[C]吐了出来！"))
	unbuckle_mob(C)
	playsound(src,'sound/misc/maneaterspit.ogg', 100)
	return TRUE

/obj/structure/flora/roguegrass/maneater/real/update_icon()
	if(obj_broken)
		name = "食人草"
		desc = "幸好，这只狡猾的生物已经被击败了。"
		icon_state = "maneater-dead"
		return
	if(aggroed)
		name = "食人草"
		icon_state = "maneater"
	else
		name = "草"
		icon_state = "maneater-hidden"

/obj/structure/flora/roguegrass/maneater/real/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user, break_factor = 1)
	if(!isliving(user))
		return
	if(obj_broken)
		return ..()

	if(user != buckled_mob)
		user.visible_message(span_warning("[user]试图把[buckled_mob]从[src]里拽出来！"))
	else
		user.visible_message(span_warning("[user]试图挣脱[src]！"))

	var/time2mount = CLAMP((user.STASTR * 2 * break_factor), 1, 99)
	if(istype(src, /obj/structure/flora/roguegrass/maneater/real/juvenile))
		time2mount *= 2
	if(!do_after(user, 1.5 SECONDS, FALSE, src, TRUE, null, FALSE, TRUE))
		user.visible_message(span_warning("[buckled_mob]停止了挣扎！"))
		return
	if(prob(time2mount))
		return ..()
	user_unbuckle_mob(buckled_mob, user, break_factor * 1.5) // Recursive loop that gives you better breakout chance every time

/obj/structure/flora/roguegrass/maneater/real/user_buckle_mob(mob/living/buckled_mob, mob/living/user) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/flora/roguegrass/maneater/real/attackby(obj/item/W, mob/user, params)
	..()
	aggroed = world.time
	update_icon()


//JUVENILE MANEATER

/obj/structure/flora/roguegrass/maneater/real/juvenile
	name = "幼年食人草"
	desc = "青翠鲜活。这株看起来比寻常的要小一些。"
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	max_integrity = 50
	seednutrition = 0
	max_seednutrition = 50
	var/growth_stage = 1
	var/max_growth_stage = 3
	var/growth_time = 20 MINUTES


/obj/structure/flora/roguegrass/maneater/real/juvenile/Initialize(mapload)
	..()
	transform = transform.Scale(0.75, 0.75)  // Start larger than an kobold.
	addtimer(CALLBACK(src, PROC_REF(try_grow)), growth_time)

/obj/structure/flora/roguegrass/maneater/real/juvenile/Crossed(atom/movable/AM)
	..()
	if(world.time <= last_eat + 5 SECONDS)
		return
	if(has_buckled_mobs())
		return
	if(isliving(AM))
		return

	if(is_type_in_list(AM, eatablez))
		last_eat = world.time
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		AM.forceMove(src)
		seednutrition += 10

	return

/obj/structure/flora/roguegrass/maneater/real/juvenile/proc/try_grow()
	if(growth_stage < max_growth_stage)
		growth_stage++
		// Largest juvenile stage stays under the adult's 1.0 size
		transform = transform.Scale(1.1, 1.1)
		visible_message(span_warning("[src] 长得更大了！"))
		playsound(loc, list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
		addtimer(CALLBACK(src, PROC_REF(try_grow)), growth_time)
		return

	// Replace with adult form
	visible_message(span_danger("[src]彻底长成了！"))
	var/turf/T = get_turf(src)
	var/obj/structure/flora/roguegrass/maneater/real/myboy = new(T)
	myboy.planter = planter
	qdel(src)

/obj/structure/flora/roguegrass/maneater/real/juvenile/update_icon()
	..()
	name = "幼年" + name


//MANEATER SEEDS

/obj/item/maneaterseed
	name = "食人草种子"
	desc = "一颗食人草的种子。若种在青草地或泥地里，它看起来会长成某种危险的东西。"
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-seed"
	max_integrity = 5
	sellprice = 30
	dropshrink = 0.7

/obj/item/maneaterseed/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/turf/T = get_turf(target)
	if(istype(T, /turf/open/floor/rogue/dirt) || istype(T, /turf/open/floor/rogue/grass))
		if(!proximity_flag)
			return
		for(var/obj/structure/flora/roguegrass/maneater/M in T)
			to_chat(user, span_warning("食人草之间需要留出更多空间才能生长。"))
			return
		for(var/turf/adjacent in orange(2, T))
			for(var/obj/structure/flora/roguegrass/maneater/M in adjacent)
				to_chat(user, span_warning("食人草之间需要留出更多空间才能生长。"))
				return
		for(var/obj/effect/decal/D in T) //To stop planting on mapped cobble decals etc
			to_chat(user, span_warning("这片地面太不平整，没法在这里种下食人草种子。"))
			return
		user.visible_message(span_notice("[user]开始种植一颗食人草种子。"), \
				span_notice("我开始种植这颗食人草种子。"))
		if(do_after(user, 10 SECONDS))
			var/obj/structure/flora/roguegrass/maneater/real/juvenile/myboy = new(T)
			myboy.planter = user
			user.visible_message(span_notice("[user]种下了一颗食人草种子。"), \
				span_notice("我种下了这颗食人草种子。"))
			qdel(src)
			message_admins("[user]/([user.ckey]) plants a maneater seed at [ADMIN_VERBOSEJMP(T)]")
			return
	..()

/obj/structure/flora/roguegrass/maneater/real/proc/produce_seed()
	visible_message(span_warning("[src]吐出了一颗种子！"))
	var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), rand(1,3))
	var/obj/item/maneaterseed/S = new(get_turf(src))
	S.throw_at(target,3,2)
	playsound(src,'sound/misc/maneaterspit.ogg', 100)
