/obj/structure/fluff/walldeco/mageguild
	name = "法师公会旗帜"
	desc = "炽白的法师之光映在法师蓝的底色上，这些旗帜标志着法师公会的各大学院与实验室。"
	icon_state = "mageguild"

/obj/structure/fluff/walldeco/mageguild2
	name = "法师公会旗帜"
	desc = "炽白的法师之光映在黑色底色上，这些旗帜标志着法师公会的各大学院与实验室。"
	icon_state = "mageguild2"

/obj/effect/turf_decal/magedecal
	icon = 'icons/effects/96x96.dmi'
	icon_state = "imbuement2"

//adapted from forcefields.dm, this needs to be destructible
/obj/structure/arcyne_wall
	desc = "一道由纯粹奥术力量构成的墙。"
	name = "奥术之墙"
	icon = 'icons/effects/effects.dmi'
	icon_state = "arcynewall"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	opacity = 0
	density = TRUE
	max_integrity = 200
	CanAtmosPass = ATMOS_PASS_DENSITY
	climbable = FALSE
	climb_time = 0

/obj/structure/arcyne_wall/Initialize(mapload)
	. = ..()

/obj/structure/arcyne_wall/caster
	var/mob/caster

/obj/structure/arcyne_wall/caster/Initialize(mapload, mob/summoner)
	. = ..()
	caster = summoner

/obj/structure/arcyne_wall/caster/CanPass(atom/movable/mover, turf/target)	//only the caster can move through this freely
	if(mover == caster)
		return TRUE
	if(ismob(mover))
		var/mob/M = mover
		if(M.anti_magic_check(chargecost = 0) || structureclimber == M)
			return TRUE
	return FALSE

/obj/structure/arcyne_wall/greater
	desc = "一道由纯粹奥术力量构成、异常坚固的高墙。"
	name = "高阶奥术之墙"
	icon = 'icons/effects/effects.dmi'
	icon_state = "arcynewall"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	max_integrity = 1100
	CanAtmosPass = ATMOS_PASS_DENSITY
	climb_time = 0

/obj/structure/arcyne_wall/greater/caster
	var/mob/caster

/obj/structure/arcyne_wall/greater/caster/Initialize(mapload, mob/summoner)
	. = ..()
	caster = summoner

/obj/structure/arcyne_wall/greater/caster/CanPass(atom/movable/mover, turf/target)	//only the caster can move through this freely
	if(mover == caster)
		return TRUE
	if(ismob(mover))
		var/mob/M = mover
		if(M.anti_magic_check(chargecost = 0) || structureclimber == M)
			return TRUE
	return FALSE

//A non-deadbolt version. Wowsers!!!
/obj/structure/mineral_door/wood/arcyne
	desc = "奥术之门"
	icon_state = "arcyne"
	base_state = "arcyne"
	max_integrity = 2000
	over_state = "arcyneopen"
	openSound = 'sound/magic/cosmic_expansion.ogg'
	closeSound = 'sound/magic/cosmic_expansion.ogg'
	destroy_sound = 'sound/magic/antimagic.ogg'
	break_sound = 'sound/magic/antimagic.ogg'
	locksound = 'sound/magic/teleport_diss.ogg'
	unlocksound = 'sound/magic/repulse.ogg'
	rattlesound = 'sound/magic/magic_nulled.ogg'


/obj/structure/mineral_door/wood/deadbolt/arcyne
	desc = "奥术之门"
	icon_state = "arcyne"
	base_state = "arcyne"
	keylock = FALSE
	max_integrity = 2000
	over_state = "arcyneopen"

/obj/structure/mineral_door/wood/deadbolt/arcyne/caster
	var/mob/caster

/obj/structure/mineral_door/wood/deadbolt/arcyne/caster/Initialize(mapload, mob/summoner)
//	icon_state = base_state
	. = ..()
	caster = summoner

/obj/structure/mineral_door/wood/deadbolt/arcyne/caster/attack_right(mob/user)
	..()
	if(door_opened || isSwitchingStates)
		return
	if(user == caster)
		lock_toggle(user)
		to_chat(user, span_warning("这扇门的锁坏掉了。"))
		return
	if(brokenstate)
		to_chat(user, span_warning("这扇门已经没剩下多少了。"))
		return
	if(get_dir(src,user) == lockdir)
		lock_toggle(user)
	else
		to_chat(user, span_warning("这扇门不能从这一侧上锁。"))


/obj/structure/well/fountain/mana
	name = "法力喷泉"
	desc = "这座喷泉会产出一种奇异的蓝色液体，隐约透着魔力。试图把它装瓶时，它似乎会莫名其妙地变成普通清水。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "manafountain"
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	max_integrity = 0	// Things with 0 max_integrity cannot be destroyed.
	pixel_x = -16
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF // Just to make doubly sure it can't be destroyed or damaged.

/obj/structure/well/fountain/mana/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user]开始饮用[src]中的液体。"))
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		for(var/drink in 1 to 25)
			if(drink_mana(user, L))
				return
		to_chat(user, span_warning("I've had enough."))
		return
	..()

/obj/structure/well/fountain/mana/proc/drink_mana(mob/user, mob/living/L)
	if(L.stat != CONSCIOUS)
		return TRUE
	if(do_after(L, 2.5 SECONDS, target = src))
		var/list/waterl = list(/datum/reagent/medicine/manapot = 2)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		return FALSE
	return TRUE

/obj/machinery/light/rogue/forge/arcane
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "炼狱熔炉"
	desc = "这座熔炉依靠内部核心循环涌动的岩浆来加热物品。"
	icon_state = "infernal0"
	base_state = "infernal"
	heat_time = 30 SECONDS

/obj/machinery/light/rogue/forge/arcane/process()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()
	if(on)
		if(initial(fueluse) > 0)
			if(fueluse > 0)
				fueluse = max(fueluse - 10, 0)
			if(fueluse == 0)//It's litterally powered by arcane lava. It's not gonna run out of fuel.
				fueluse = 4000
		update_icon()

/obj/structure/leyline
	name = "失活地脉"
	desc = "一组奇特排列的石头。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "inactiveleyline"
	var/active = FALSE
	var/mob/living/guardian = null
	anchored = TRUE
	density = FALSE
	var/time_between_uses = 12000
	var/last_process = 0

/obj/structure/leyline/Initialize(mapload)
	.=..()
	last_process = world.time

/obj/structure/leyline/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("这条地脉似乎已经被抽干了能量。"))
		return
	if(!isarcyne(user))
		if(!active)
			to_chat(user, span_notice("我把手挥过石环，什么都没有发生。"))
			return
		else
			if(prob(60) && (!guardian))
				if(do_after(user, 60))
					to_chat(user, span_notice("我朝活化地脉伸出手，向内窥探——而某种东西也在回望我！"))
					sleep(2 SECONDS)
					guardian = new /mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan(src.loc, src)
					src.visible_message(span_danger("[src]从地脉裂口中现身了！"))
			else
				if(do_after(user, 60))
					to_chat(user, span_notice("我伸手触碰活化地脉，它随即碎裂！一大块可用碎片落在了你的脚边。"))
					new /obj/item/magic/leyline(user.loc)
					active = FALSE
					icon_state = "inactiveleyline"
					name = "失活地脉"
					desc = "一组奇特排列的石头。"
					update_icon()
					last_process = world.time

	else
		if(!active)
			to_chat(user, span_notice("我将手挥过石环，并把奥术魔力注入其中。地脉被激活了！"))
			icon_state = "leylinerupture"
			name = "活化地脉"
			desc = "一道活化的地脉裂口，正源源不断地散发出能量。"
			active = TRUE
			update_icon()
		else
			if(guardian)
				if(do_after(user, 60))
					to_chat(user, span_danger("地脉因[guardian]的反馈而嗡鸣震荡，它朝我反噬而来！"))
					user.electrocute_act(10)

			if(prob(60) && (!guardian))
				if(do_after(user, 60))
					to_chat(user, span_notice("我朝活化地脉伸出手，向内窥探——而某种东西也在回望我！"))
					sleep(2 SECONDS)
					guardian = new /mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan(src.loc, src)
					src.visible_message(span_danger("[guardian]从地脉裂口中现身了！"))

			else
				if(do_after(user, 60))
					to_chat(user, span_notice("我伸手触碰活化地脉，它随即碎裂！一大块可用碎片落在了你的脚边。"))
					new /obj/item/magic/leyline(user.loc)
					active = FALSE
					icon_state = "inactiveleyline"
					name = "失活地脉"
					desc = "一组奇特排列的石头。"
					update_icon()
					last_process = world.time

/obj/structure/manaflower
	name = "法力花"
	desc = ""
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "manabloom2"
	color = null
	layer = BELOW_MOB_LAYER
	max_integrity = 60
	density = FALSE
	debris = list(/obj/item/natural/fibers = 1, /obj/item/reagent_containers/food/snacks/grown/manabloom = 1)

/obj/structure/manaflower/attack_hand(mob/living/carbon/human/user)
	playsound(src.loc, "plantcross", 80, FALSE, -1)
	user.visible_message(span_warning("[user]采下了[src]。"))
	if(do_after(user, 3 SECONDS, target = src))
		new /obj/item/reagent_containers/food/snacks/grown/manabloom (get_turf(src))
		qdel(src)
/obj/structure/manaflower/Crossed(mob/living/carbon/human/H)
	playsound(src.loc, "plantcross", 80, FALSE, -1)


/obj/structure/voidstoneobelisk
	name = "虚空石方尖碑"
	desc = "一座光滑而不自然的方尖碑，仅仅注视它就会令人不安。"
	icon = 'icons/mob/summonable/32x32.dmi'
	icon_state = "dormantobelisk"
	anchored = TRUE
	density = TRUE

/obj/structure/voidstoneobelisk/attacked_by(obj/item/I, mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	var/newforce = get_complex_damage(I, user, blade_dulling)
	if(!newforce)
		return 0
	if(newforce < damage_deflection)
		return 0
	if(user.used_intent.no_attack)
		return 0
	log_combat(user, src, "attacked", I)
	var/verbu = "击打"
	verbu = pick(user.used_intent.attack_verb)
	if(newforce > 1)
		if(user.stamina_add(5))
			user.visible_message(span_danger("[user]用[I][verbu][src]！"))
	user.visible_message(span_danger("[src]活了过来，古老石体开始错动重组！"))
	sleep(2)
	new /mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk(src.loc)
	qdel(src)

/obj/structure/voidstoneobelisk/attack_hand(mob/living/carbon/human/user)
	to_chat(user, span_notice("你伸手触碰那座畸异的方尖碑……"))
	if(do_after(user, 3 SECONDS, target = src))
		user.visible_message(span_danger("[src]活了过来，古老石体开始错动重组！"))
		sleep(2)
		new /mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk(src.loc)
		qdel(src)
