/obj/structure/trap
	name = "这是个陷阱"
	desc = ""
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "trap"
	density = FALSE
	anchored = TRUE
	alpha = 60 //initially quite hidden when not "recharging"
	var/flare_message = span_warning("陷阱骤然亮起！")
	var/last_trigger = 0
	var/time_between_triggers = 600 //takes a minute to recharge
	var/charges = INFINITY
	var/checks_antimagic = TRUE
	var/armed = TRUE // used for onlook detection and disabling
	var/trap_damage = 50 // baseline trap damage, reduced by armor checks. Wear your PPE in dungeons
	var/def_zone = BODY_ZONE_CHEST //
	var/used_time = 14 // interaction time for disabling traps, scales down with trap skill


	var/static/list/ignore_typecache
	var/list/mob/immune_minds = list() //unused and a bit weird, helpful for making mobs immune to the traps without TRAIT_LIGHT_STEP

	var/sparks = TRUE
	var/datum/effect_system/spark_spread/spark_system

/obj/structure/trap/Initialize(mapload)
	. = ..()
	flare_message = span_warning("[src]骤然亮起！")
	spark_system = new
	spark_system.set_up(4,1,src)
	spark_system.attach(src)

	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/obj/projectile,
			/mob/dead))

/obj/structure/trap/Destroy()
	qdel(spark_system)
	spark_system = null
	. = ..()

/obj/structure/trap/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	if(!armed)
		return
	var/mob/living/luser = user
	if(user.mind && (user.mind in immune_minds))
		return
	if(get_dist(user, src) <= FLOOR((luser.STAPER-4)/4,1))
		to_chat(user,span_notice("我发现并暂时解除了[src]。"))
		flare()

/obj/structure/trap/attack_hand(mob/user)
	var/mob/living/carbon/C = user
	var/def_zone = "[(C.active_hand_index == 2) ? "r" : "l" ]_arm"
	var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
	if(iscarbon(user) && armed && isturf(loc))
		if(!BP)
			return FALSE
		if(C.get_skill_level(/datum/skill/craft/crafting) < 1)
			C.visible_message(span_notice("我不知道该怎么解除[src]。"))
			return FALSE
		else
			used_time = 14 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/crafting) * 2 SECONDS), 2 SECONDS)
				C.visible_message(span_notice("[C]开始解除[src]。"), \
						span_notice("我开始解除[src]。"))
			if(do_after(user, used_time, target = src))
				armed = FALSE
				update_icon()
				alpha = 255
				C.visible_message(span_notice("[C]解除了[src]。"), \
						span_notice("我解除了[src]。"))
				return FALSE
	if(iscarbon(user) && !armed && isturf(loc))
		if(!BP)
			return FALSE
		if(C.get_skill_level(/datum/skill/craft/crafting) < 1)
			C.visible_message(span_notice("我不知道该怎么布设[src]。"))
			return FALSE
		else
			used_time = 8 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/crafting) * 2 SECONDS), 2 SECONDS)
			if(do_after(user, used_time, target = src))
				armed = TRUE
				update_icon()
				alpha = 35
				C.visible_message(span_notice("[C]布设了[src]。"), \
						span_notice("我布设了[src]。"))
				return FALSE
	..()

/obj/structure/trap/proc/flare()
	// Makes the trap visible, and starts the cooldown until it's
	// able to be triggered again.
	alpha = 200
	last_trigger = world.time
	charges--
	if(charges <= 0)
		animate(src, alpha = 0, time = 10)
		QDEL_IN(src, 10)
	else
		animate(src, alpha = initial(alpha), time = time_between_triggers)

/obj/structure/trap/Crossed(atom/movable/AM)
	if(last_trigger + time_between_triggers > world.time)
		return
	// Don't want the traps triggered by sparks, ghosts or projectiles.
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	if(!armed)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(M.mind in immune_minds)
			return
		if(checks_antimagic && M.anti_magic_check())
			flare()
			return
		if(HAS_TRAIT(AM, TRAIT_LIGHT_STEP))
			return
	if(charges <= 0)
		return
	flare()
	if(isliving(AM))
		trap_effect(AM)

/obj/structure/trap/proc/trap_effect(mob/living/L)
	return

/obj/structure/trap/stun
	name = "电击陷阱"
	desc = ""
	icon_state = "trap-shock"
	var/stun_time = 100

/obj/structure/trap/stun/trap_effect(mob/living/L)
	L.electrocute_act(30, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	L.Paralyze(stun_time)

/obj/structure/trap/stun/hunter
	name = "赏金陷阱"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "bounty_trap_on"
	stun_time = 200
	sparks = FALSE //the item version gives them off to prevent runtimes (see Destroy())
	checks_antimagic  = FALSE
	var/obj/item/bountytrap/stored_item
	var/caught = FALSE

/obj/structure/trap/stun/hunter/Initialize(mapload)
	. = ..()
	time_between_triggers = 10
	flare_message = span_warning("[src]猛地夹合！")

/obj/structure/trap/stun/hunter/Crossed(atom/movable/AM)
	caught = TRUE
	. = ..()

/obj/structure/trap/stun/hunter/flare()
	..()
	stored_item.forceMove(get_turf(src))
	forceMove(stored_item)
	if(caught)
		stored_item.announce_fugitive()
		caught = FALSE

/obj/item/bountytrap
	name = "赏金陷阱"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "bounty_trap_off"
	var/obj/structure/trap/stun/hunter/stored_trap
	var/datum/effect_system/spark_spread/spark_system

/obj/item/bountytrap/Initialize(mapload)
	. = ..()
	spark_system = new
	spark_system.set_up(4,1,src)
	spark_system.attach(src)
	name = "[name] #[rand(1, 999)]"
	stored_trap = new(src)
	stored_trap.name = name
	stored_trap.stored_item = src

/obj/item/bountytrap/proc/announce_fugitive()
	spark_system.start()
	playsound(src, 'sound/blank.ogg', 50, TRUE)

/obj/item/bountytrap/attack_self(mob/living/user)
	var/turf/T = get_turf(src)
	if(!user || !user.transferItemToLoc(src, T))//visibly unequips
		return
	to_chat(user, "<span class=notice>我布设好了[src]。靠近检视即可解除它。</span>")
	stored_trap.forceMove(T)//moves trap to ground
	forceMove(stored_trap)//moves item into trap

/obj/item/bountytrap/Destroy()
	qdel(stored_trap)
	QDEL_NULL(spark_system)
	. = ..()

/obj/structure/trap/fire
	name = "火焰陷阱"
	desc = ""
	icon_state = "trap-fire"

/obj/structure/trap/fire/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>自燃了！</B>"))
	L.Paralyze(20)
	new /obj/effect/hotspot(get_turf(src))

/obj/structure/trap/chill
	name = "霜冻陷阱"
	desc = ""
	icon_state = "trap-frost"

/obj/structure/trap/chill/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>我被彻底冻僵了！</B>"))
	L.Paralyze(20)
	L.adjust_bodytemperature(-100)
	L.apply_status_effect(/datum/status_effect/freon)

/obj/structure/trap/damage
	name = "震地陷阱"
	desc = ""
	icon_state = "trap-earth"

/obj/structure/trap/damage/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>脚下的大地猛然震动！</B>"))
	L.Paralyze(100)
	L.adjustBruteLoss(35)
	var/obj/structure/flora/rock/giant_rock = new(get_turf(src))
	QDEL_IN(giant_rock, 200)

/obj/structure/trap/ward
	name = "神圣结界"
	desc = ""
	icon_state = "ward"
	density = TRUE
	time_between_triggers = 1200 //Exists for 2 minutes

/obj/structure/trap/ward/Initialize(mapload)
	. = ..()
	QDEL_IN(src, time_between_triggers)

/obj/structure/trap/saw_blades // vanderlin traps and AP traps below
	name = "锯盘压板陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "saw_trap_plate"
	time_between_triggers = 100
	max_integrity = 500

/obj/structure/trap/saw_blades/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>一片旋转利刃猛地从我脚下窜出！</B>"))
	def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	L.apply_damage(trap_damage, BRUTE, def_zone, L.run_armor_check(def_zone, "stab", damage = trap_damage))
	playsound(src, 'sound/gore/flesh_eat_01.ogg', 70, TRUE)
	var/obj/structure/sawblade_trap/saw = new(get_turf(src))
	last_trigger = 0 // override to keep slicing you every time you step onto the trap
	QDEL_IN(saw, 100)

/obj/structure/sawblade_trap
	name = "锯刃"
	desc = "一片高速旋转的锯刃，由某种未知机关驱动。"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "trap_saw"
	density = FALSE
	anchored = TRUE

/obj/structure/trap/bomb // fire can RR easily, dangerous
	name = "爆炸压板陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "bomb_trap_plate"
	time_between_triggers = 100
	max_integrity = 500

/obj/structure/trap/bomb/trap_effect(mob/living/L)
	..()
	explosion(src, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

/obj/structure/trap/flame // fire can RR easily, dangerous
	name = "喷焰压板陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "trap_plate"
	time_between_triggers = 100
	max_integrity = 500

/obj/structure/trap/flame/trap_effect(mob/living/L)
	..()
	to_chat(L,span_danger("地面突然喷涌出烈焰！"))
	new /obj/effect/hotspot(get_turf(src))

/obj/structure/trap/shock
	name = "雷击压板陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "shock_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	var/stun_time = 5 SECONDS

/obj/structure/trap/shock/trap_effect(mob/living/L)
	..()
	L.electrocute_act(30, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	L.Paralyze(stun_time)

/obj/structure/trap/wall_projectile
	name = "箭矢压板陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "arrow_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	var/turf/closed/home_wall
	///How far we look for a 'home' wall
	var/wall_range = 7
	///What're we shooting at the victim? Should be an /obj/projectile/
	var/fired = /obj/projectile/bullet/reusable/arrow/stone/wall_projectile

/obj/projectile/bullet/reusable/arrow/stone/wall_projectile
	speed = 6

/obj/structure/trap/wall_projectile/Initialize(mapload)
	. = ..()
	for(var/step in 1 to wall_range)
		var/location = get_ranged_target_turf(src,dir,step)
		if(isclosedturf(location))
			home_wall = location
			break
	if(!home_wall)
		return INITIALIZE_HINT_QDEL

/obj/structure/trap/wall_projectile/trap_effect(mob/living/L)
	..()
	if(!home_wall || !ispath(fired,/obj/projectile))
		return
	var/obj/projectile/suprise = new fired(get_step_towards2(home_wall,src))
	suprise.preparePixelProjectile(L,home_wall)
	suprise.fire()
	to_chat(L, span_danger("[suprise]从[home_wall]上的暗槽里猛地射了出来！"))

/obj/structure/trap/wall_projectile/Destroy()
	home_wall = null
	. = ..()

/obj/structure/trap/wall_projectile/frostbolt
	name = "霜箭压板陷阱"
	fired = /obj/projectile/magic/frostbolt/wall_projectile

/obj/projectile/magic/frostbolt/wall_projectile
	speed = 6
	damage = 20
	armor_penetration = 5

/obj/structure/trap/wall_projectile/acidsplash
	name = "酸液压板陷阱"
	fired = /obj/projectile/magic/acidsplash/wall_projectile

/obj/projectile/magic/acidsplash/wall_projectile
	speed = 6

/obj/structure/trap/rock_fall
	name = "落石陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "rockfall_trap_plate"
	time_between_triggers = 100
	max_integrity = 500

/obj/structure/trap/rock_fall/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>头顶的地面剧烈震动起来！</B>"))
	def_zone = BODY_ZONE_HEAD
	L.apply_damage(trap_damage, BRUTE, def_zone, L.run_armor_check(def_zone, "stab", damage = trap_damage))
	playsound(src, 'sound/foley/smash_rock.ogg', 70, TRUE)
	L.set_blurriness(10)
	var/obj/structure/flora/rock/giant_rock = new(get_turf(src))
	QDEL_IN(giant_rock, 100)

/obj/structure/trap/water
	name = "水流陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "water_trap_plate"
	time_between_triggers = 100
	max_integrity = 500

/obj/structure/trap/water/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>激流把我浇得透湿，还把我冲翻在地！</B>"))
	for(var/obj/O in L.contents) //Checks for light sources in the mob's inventory. Tyvm to LynxSolstice for the extinguish code
		O.extinguish() //Extinguishes light sources on the mob hit by the trap.
	playsound(src, 'sound/foley/water_land2.ogg', 70, TRUE)
	L.Paralyze(10)
	var/obj/effect/particle_effect/water/spray = new(get_turf(src))
	QDEL_IN(spray, 100)

/obj/structure/trap/curse
	name = "失效陷阱" //Im not activated guys I swear Im a broken trap I dont work
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "base_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	alpha = 255

/obj/structure/trap/curse/hidden
	name = "诅咒陷阱"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "base_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	alpha = 35

/obj/structure/trap/curse/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>我被狠狠戏弄了一番！</B>"))
	L.add_stress(/datum/stressevent/thefool)
	playsound(src, 'sound/magic/mockery.ogg', 60, TRUE)
	L.apply_status_effect(/datum/status_effect/debuff/viciousmockery)

/datum/stressevent/thefool
	timer = 10 MINUTES
	stressadd = 2
	desc = span_boldgreen("我被耍得团团转。")

// BANDIT THING STARTS HERE //
/obj/structure/trap/bogtrap
	name = "陷足夹"
	desc = "一种隐藏巧妙、内藏恶意惊喜的机关。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "beartrap"
	name = "捕人夹"
	time_between_triggers = 100 //feel free to add more than 1 use
	max_integrity = 100
	trap_damage = 60
	alpha = 60
	charges = 2 //feel free to add more than 1 use
	checks_antimagic = FALSE

	var/tmp/list/personal_reveal_images = list()
	var/bandit_reveal_alpha = 140
	var/others_reveal_alpha = 35
	var/retinue_planted = FALSE//Is this a retinue trap? Inverses the checks for who triggers.

/obj/structure/trap/bogtrap/flare()
	alpha = 200
	last_trigger = world.time
	charges--
	animate(src, alpha = 0, time = 2)
	QDEL_IN(src, 2)

/obj/structure/trap/bogtrap/Destroy()
	if(personal_reveal_images)
		for(var/client/C in personal_reveal_images)
			var/image/I = personal_reveal_images[C]
			if(C && I)
				C.images -= I
	personal_reveal_images = null
	. = ..()

/obj/structure/trap/bogtrap/proc/has_exempt_role(mob/living/H)
	if(!H || !H.mind)
		return FALSE

	var/assigned = LOWER_TEXT("[H.mind.assigned_role]")
	var/special  = LOWER_TEXT("[H.mind.special_role]")

//We don't care about anyone but the MAAs/Wardens.
	if(retinue_planted)
		if(assigned == "man at arms")
			return TRUE

		if(assigned == "bogguard")
			return TRUE

		if(assigned == "warden")
			return TRUE
//Otherwise...
	else
		if(assigned == "bandit" || special == "bandit")
			return TRUE

		if(assigned == "wretch")
			return TRUE

		if(special == "lich" || special == "vampire lord")
			return TRUE

		if(assigned == "bogguard")
			return TRUE

	return FALSE

/obj/structure/trap/bogtrap/proc/has_required_trigger_trait(mob/living/H)
	if(!H) return FALSE
	if(HAS_TRAIT(H, TRAIT_MEDIUMARMOR)) return TRUE
	if(HAS_TRAIT(H, TRAIT_HEAVYARMOR))  return TRUE
	if(HAS_TRAIT(H, TRAIT_DODGEEXPERT)) return TRUE
	if(HAS_TRAIT(H, TRAIT_CRITICAL_RESISTANCE)) return TRUE
	return FALSE

/obj/structure/trap/bogtrap/proc/is_trap_exception(mob/living/H)
	if(!H) return FALSE
	if(has_exempt_role(H))
		return TRUE
	if(!has_required_trigger_trait(H))
		return TRUE
	return FALSE

/obj/structure/trap/bogtrap/proc/is_exempt_viewer(mob/living/H)
	if(!H || !H.mind)
		return FALSE
	var/assigned = LOWER_TEXT("[H.mind.assigned_role]")
	var/special  = LOWER_TEXT("[H.mind.special_role]")

//Is this hacky? Yeah. Does it work? I guess.
	if(retinue_planted)
		return (assigned == "man at arms" \
			|| assigned == "bogguard" \
			|| assigned == "warden" || special == "warden")
	else
		return (assigned == "bandit" || special == "bandit" \
			|| assigned == "bogguard" \
			|| assigned == "warden" || special == "warden")

/obj/structure/trap/bogtrap/proc/show_personal_reveal(mob/user)
	if(!user || !user.client)
		return
	var/image/I = image(icon = src.icon, loc = src, icon_state = src.icon_state)
	I.layer = src.layer
	I.plane = src.plane
	I.appearance_flags = src.appearance_flags
	I.color = src.color
	I.transform = src.transform
	I.alpha = is_exempt_viewer(user) ? bandit_reveal_alpha : others_reveal_alpha
	user.client.images += I
	if(!personal_reveal_images)
		personal_reveal_images = list()
	personal_reveal_images[user.client] = I
	addtimer(CALLBACK(src, PROC_REF(hide_personal_reveal), user), 3 SECONDS)

/obj/structure/trap/bogtrap/proc/hide_personal_reveal(mob/user)
	if(user && user.client && personal_reveal_images && personal_reveal_images[user.client])
		var/image/I = personal_reveal_images[user.client]
		user.client.images -= I
		personal_reveal_images[user.client] = null

/obj/structure/trap/bogtrap/examine(mob/user)
	if(!isliving(user) || !armed)
		return
	var/mob/living/L = user
	if(user.mind && (user.mind in immune_minds))
		return
	if(get_dist(user, src) <= FLOOR((L.STAPER-4)/4,1))
		to_chat(user, span_notice("我发现了[src]。"))
		show_personal_reveal(user)


/obj/structure/trap/bogtrap/Crossed(atom/movable/AM)
	if(ismob(AM))
		var/mob/living/H = AM
		if(is_trap_exception(H))
			return
	. = ..()

/obj/structure/trap/bogtrap/freeze
	name = "捕人夹（霜冻）"

/obj/structure/trap/bogtrap/freeze/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>我被彻底冻僵了！</B>"))
	L.Paralyze(50)
	L.adjust_bodytemperature(-100)
	playsound(src, 'sound/misc/explode/bottlebomb (1).ogg', 60, TRUE)


/obj/structure/trap/bogtrap/bomb
	name = "捕人夹（爆裂）"

/obj/structure/trap/bogtrap/bomb/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>地下炸药轰然引爆！</B>"))
	explosion(src, light_impact_range = 1, flame_range = 3, smoke = TRUE)
	playsound(src, 'sound/misc/explode/bottlebomb (1).ogg', 200, TRUE)

//kneestingers

/obj/structure/trap/bogtrap/kneestingers
	name = "捕人夹（刺膝草）"
	desc = "一种隐藏机关，会炸出一片刺膝草。"
	charges = 1

/obj/structure/trap/bogtrap/kneestingers/trap_effect(mob/living/L)
	var/turf/center = get_turf(src)
	to_chat(L, span_danger("<B>有什么东西从地里窜了出来！</B>"))
	playsound(src, 'sound/items/beartrap.ogg', 200, TRUE)

	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			var/turf/T = locate(center.x + dx, center.y + dy, center.z)
			if(!T || isclosedturf(T))
				continue
			new /obj/structure/glowshroom(T)

//Poison tr*p

/obj/structure/trap/bogtrap/poison
	name = "捕人夹（毒雾）"
	charges = 1

/obj/structure/trap/bogtrap/poison/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>一团毒雾将我吞没！</B>"))
	L.Paralyze(30)
	new /obj/effect/particle_effect/smoke/poison_gas(get_turf(src))
	playsound(src, 'sound/items/beartrap.ogg', 200, TRUE)

//Rous nest. Spawns a rather large rous.

/obj/structure/trap/bogtrap/rous
	name = "捕人夹（鼠巢）"
	charges = 1
	retinue_planted = TRUE

/obj/structure/trap/bogtrap/rous/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>我踩上了一个隐藏的笼子！</B>"))
	playsound(src, 'sound/items/beartrap.ogg', 200, TRUE)

	L.AdjustKnockdown(5)
	new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat(get_turf(src))

//Flare. Flashbangs viewiers. Alerts folks. Alarm trap, basically.
//A better, RP friendly blind gas.

/obj/structure/trap/bogtrap/flare_trap
	name = "捕人夹（信号弹）"
	charges = 1
	retinue_planted = TRUE

/obj/structure/trap/bogtrap/flare_trap/trap_effect(mob/living/L)
	playsound(src, 'sound/effects/hood_ignite.ogg', 200, TRUE)

//The poor fools in view.
	if(L in oviewers(7, src))
		L.adjust_blurriness(12)
		L.adjust_blindness(3)
		L.emote("scream")
//Church bell range. A bit far? Sure. Don't step on it.
	loud_message("一道信号弹冲天而起，紧接着传来一声锐响", hearing_distance = 150)
//The entire town knows you're here, now, buddy.
