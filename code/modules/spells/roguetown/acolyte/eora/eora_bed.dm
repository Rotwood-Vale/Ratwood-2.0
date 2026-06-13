/obj/structure/bed/rogue/eora
	name = "花瓣床"
	desc = "一张由花瓣铺成的床，看起来柔软得足以安睡！据说能让濒死者免受内克拉领域侵扰。"
	sleepy = 4
	debris = null
	max_integrity = 50
	icon_state = "eora"
	var/list/occupants = list()
	var/next_heal_time = 0
	var/heal_cooldown = 10 SECONDS

/obj/structure/bed/rogue/eora/Initialize(mapload)
	. = ..()
	var/random_rotation = pick(0, 180)
	if(random_rotation != 0)
		var/matrix/M = matrix()
		M.Turn(random_rotation)
		transform = M

/obj/structure/bed/rogue/eora/Crossed(atom/movable/AM, atom/oldloc)
	. = ..()
	if(isliving(AM))
		RegisterSignal(AM, COMSIG_CARBON_HANDLE_SLEEP, PROC_REF(on_sleeper))

/obj/structure/bed/rogue/eora/Uncrossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		UnregisterSignal(AM, COMSIG_CARBON_HANDLE_SLEEP)

/obj/structure/bed/rogue/eora/proc/on_sleeper(datum/source)
	SIGNAL_HANDLER

	var/mob/living/L = source
	if(!istype(L))
		return

	for(var/datum/weakref/W in occupants)
		if(W.resolve() == L)
			return

	occupants += WEAKREF(L)
	START_PROCESSING(SSobj, src)

/obj/structure/bed/rogue/eora/process(seconds_per_tick)
	if(!occupants.len)
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/priority_target = null
	var/max_oxy = -1 // Start below 0 to catch people even with 0 oxy loss
	var/max_brute = -1 // Brute if oxy is 0.

	for(var/datum/weakref/W in occupants)
		var/mob/living/L = W.resolve()

		if(!L || L.loc != src.loc || (L.mobility_flags & MOBILITY_STAND))
			occupants -= W
			continue

		if(L.has_status_effect(/datum/status_effect/buff/healing/bed_rest))
			continue

		var/current_oxy = L.getOxyLoss()
		var/current_brute = L.getBruteLoss()
		if(current_oxy > max_oxy)
			max_oxy = current_oxy
			priority_target = L
			max_brute = current_brute 

		else if(current_oxy == max_oxy && !priority_target)
			if(current_brute > max_brute)
				max_brute = current_brute
				priority_target = L

	if(priority_target && world.time >= next_heal_time)
		priority_target.apply_status_effect(/datum/status_effect/buff/healing/bed_rest)
		next_heal_time = world.time + heal_cooldown

/obj/structure/bed/rogue/eora/Destroy()
	. = ..()
	for(var/mob/living/L in get_turf(src))
		UnregisterSignal(L, COMSIG_CARBON_HANDLE_SLEEP)

/datum/status_effect/buff/healing/bed_rest
	id = "eora_bed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/eora_bed
	// Smoother than 10 seconds with the bed CD
	duration = 11 SECONDS
	healing_on_tick = 0.5
	var/oxy_healing_on_tick = 5
	outline_colour = "#d04ae2"

/atom/movable/screen/alert/status_effect/buff/healing/eora_bed
	name = "伊欧拉的宽慰"
	desc = "花瓣的温暖安抚着我的呼吸，并治愈我的病痛。"
	icon_state = "eorabed"

/datum/status_effect/buff/healing/bed_rest/tick()
	if(!owner || owner.stat == DEAD)
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour

	owner.heal_wounds(healing_on_tick)
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)

	owner.adjustOxyLoss(-oxy_healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.5)
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)

/obj/effect/proc_holder/spell/invoked/summon_bed
	name = "伊欧拉的安憩"
	desc = "召唤一张神圣的伊欧拉床榻，为伤者提供庇护并稳定伤势。\
	你同时只能维持有限数量的床榻，数量取决于神迹技艺。召唤新床会使最早的一张消失。"
	invocations = list("伊欧拉啊，赐下安眠之美吧！")
	sound = 'sound/magic/holyshield.ogg'
	overlay_state = "eorabed"
	chargetime = 10
	recharge_time = 30 SECONDS
	devotion_cost = 40
	associated_skill = /datum/skill/magic/holy
	var/list/bed_refs = list()

/obj/effect/proc_holder/spell/invoked/summon_bed/cast(list/targets, mob/living/user)
	. = ..()
	var/turf/T = get_turf(targets[1]) || get_turf(user)

	if(!isopenturf(T) || T.density)
		to_chat(user, span_warning("这里的地面并不适合建起一处庇护所。"))
		revert_cast()
		return FALSE

	var/max_beds = 1
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)

	if(holy_skill >= 5)
		max_beds = 3
	else if(holy_skill >= 4)
		max_beds = 2

	for(var/datum/weakref/W in bed_refs)
		if(!W.resolve())
			bed_refs -= W

	if(bed_refs.len >= max_beds)
		var/datum/weakref/oldest_W = bed_refs[1]
		var/obj/structure/bed/rogue/eora/old_bed = oldest_W.resolve()
		if(old_bed && !QDELETED(old_bed))
			old_bed.visible_message(span_nicegreen("旧床在新床被召来时渐渐消散。"))
			qdel(old_bed)
		bed_refs.Cut(1, 2)

	var/obj/structure/bed/rogue/eora/new_bed = new(T)
	bed_refs += WEAKREF(new_bed)
	user.visible_message(span_notice("[user]召出了一张由伊欧拉花瓣构成的美丽床榻！"), \
		span_notice("我为疲惫者召来了一处庇护所。"))

	return TRUE

/obj/effect/proc_holder/spell/invoked/summon_bed/Destroy()
	for(var/datum/weakref/W in bed_refs)
		var/obj/structure/bed/rogue/eora/B = W.resolve()
		if(B)
			qdel(B)
	bed_refs.Cut()
	return ..()
