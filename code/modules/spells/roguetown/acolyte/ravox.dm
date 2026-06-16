//These are all Vanderlin ports, simply redone values and additions to fit Azure. Credit for the code and idea goes to them!

//Divine Strike - Enhance your held weapon to have the next strike do extra damage and slow the target. Undead debuffed more.
/obj/effect/proc_holder/spell/self/divine_strike
	name = "神圣一击"
	desc = "赐福你的下一次攻击，使其造成额外伤害并拖慢目标。"
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "divine_strike"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("以 拉沃克斯 之名，起身而战！")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/divine_strike/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/divine_strike, user.get_active_held_item())
	return TRUE

/datum/status_effect/divine_strike
	id = "divine_strike"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_strike
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/divine_strike/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/divine_strike/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/divine_strike/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/debuff/ravox_burden)
	living_target.visible_message(span_warning("[user] 的武器重击让 [living_target] 的身躯骤然僵住！"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/divine_strike/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	H.apply_status_effect(/datum/status_effect/debuff/ravox_burden)
	H.visible_message(span_warning("[M] 的一记重拳让 [H] 的身躯骤然僵住！"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

//Call to Arms - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/call_to_arms
	name = "号召执兵"
	desc = "为你与附近所有盟友赋予力量、意志与体魄上的增益。"
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "call_to_arms"
	recharge_time = 5 MINUTES
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list("为了荣光与荣耀！")
	invocation_type = "shout"
	sound = 'sound/magic/timestop.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 40

/obj/effect/proc_holder/spell/self/call_to_arms/cast(list/targets,mob/living/user = usr)
	for(var/mob/living/carbon/target in view(3, get_turf(user)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/debuff/call_to_arms)	//Debuffs inhumen worshipers.
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("你只觉得一阵热浪掠过全身，却又转瞬即逝……"))	//No effect on Psydonians!
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/call_to_arms)
	return TRUE

//Persistence - Harms the shit out of an undead mob/player while causing bleeding/pain wounds to clot at higher rate for living ones. Basically a 'shittier' yet still good greater heal effect.
/obj/effect/proc_holder/spell/invoked/persistence
	name = "坚忍"
	desc = "伤害不死者，并促使活人的伤口更快闭合。"
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "persistence"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("拉沃克斯 认可你的坚忍！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/invoked/persistence/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD)
			if(ishuman(target)) //BLEED AND PAIN
				var/mob/living/carbon/human/human_target = target
				var/datum/physiology/phy = human_target.physiology
				phy.bleed_mod *= 1.5
				phy.pain_mod *= 1.5
				addtimer(VARSET_CALLBACK(phy, bleed_mod, phy.bleed_mod /= 1.5), 19 SECONDS)
				addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 1.5), 19 SECONDS)
				human_target.visible_message(span_danger("[target] 的伤口猛然发炎溃痛，生命力也被抽走了！"), span_userdanger("拉沃克斯 令我的伤口灼痛发炎，并削弱了我的身体！"))
				return ..()
			return FALSE

		target.visible_message(span_info("[target] 身上泛起暖意，伤口也随之缓缓闭合！"), span_notice("暖意自我的灵魂中流淌开来，伤口的疼痛也渐渐退去了！"))
		var/situational_bonus = 0.25
		for(var/obj/effect/decal/cleanable/blood/O in oview(5, target))
			situational_bonus = min(situational_bonus + 0.015, 1)
		if(situational_bonus > 0.25)
			to_chat(user, "在这种环境下，引导 拉沃克斯 的力量要容易得多！")

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in target.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		return TRUE
	return FALSE

/atom/movable/screen/alert/status_effect/buff/divine_strike
	name = "神圣一击"
	desc = "你的下一次攻击会造成额外伤害，并拖慢目标。"
	icon_state = "stressvg"

/obj/effect/proc_holder/spell/invoked/tug_of_war
	name = "角力之链"
	desc = "放出一条锁链，试图将目标拖拽到更近处。"
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "ravox_tug"
	recharge_time = 1 MINUTES
	movement_interrupt = TRUE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("以 拉沃克斯 之名，让你的罪孽引你走向审判！")
	invocation_type = "shout"
	antimagic_allowed = FALSE
	miracle = TRUE
	devotion_cost = 25
	var/pull_distance = 1
	var/slowdown = 1

/obj/effect/proc_holder/spell/invoked/tug_of_war/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/chance = 0
		if(target.mob_biotypes & MOB_UNDEAD)
			pull_distance++
			chance += 20
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/strdiff = user.STASTR - H.STASTR
			var/enddiff = user.STAWIL - H.STAWIL
			var/condiff = user.STACON - H.STACON
			var/spddiff = user.STASPD - H.STASPD
			var/fordiff = user.STALUC - H.STALUC

			var/list/statdiffs = list(strdiff, enddiff, condiff, spddiff, fordiff)
			var/count = 0
			for(var/diff in statdiffs)
				if(diff > 0)
					chance += 10
					count++
				else if(diff < 0)
					chance -= 10
			var/holymod = user.get_skill_level(/datum/skill/magic/holy) * 10
			pull_distance += floor((user.get_skill_level(/datum/skill/magic/holy) - 1) / 2)	//+1 pull dist at Jman and Master Holy skill
			chance += holymod
			user.visible_message(span_boldwarning("[user] 猛地一扯，从 [target] 身上延伸出的半透明锁链随之绷紧！"))
			if(count > 3)	//More than half of the stats are in our favor.
				pull_distance++
				slowdown++
			if(prob(chance))
				H.throw_at(user, pull_distance, 1, H, FALSE)
				H.visible_message(span_warning("[H] 的身体不受控制地被拖动了！"))
				user.Beam(target,icon_state="chain",time=5)
			else
				H.visible_message(span_warning("[H] 硬生生稳住了身形！"))
			H.Slowdown(slowdown)
			return TRUE
		revert_cast()
		return FALSE
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/challenge
	name = "裁决挑战"
	desc = "将一名对手一并带入 拉沃克斯 的审判试炼，进行三分钟决斗。"
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "ravoxchallenge"
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	recharge_time = 10 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	range = 5
	chargetime = 3 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("以 拉沃克斯 之名，我向你发起挑战！！")
	chargedloop = /datum/looping_sound/invokeholy
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 100

GLOBAL_LIST_EMPTY(arenafolks) // we're just going to use a list and add to it. Since /entered doesnt work on teleported mobs.

/obj/effect/proc_holder/spell/invoked/challenge/cast(list/targets, mob/living/user)
	var/area/rogue/indoors/ravoxarena/thearena = GLOB.areas_by_type[/area/rogue/indoors/ravoxarena]
	var/turf/challengerspawnpoint
	var/turf/challengedspawnpoint
	var/arenacount = GLOB.arenafolks.len
	if(arenacount >= 2)
		to_chat(user, span_italics("竞技场尚未准备好迎接下一场审判！耐心等候。"))
		revert_cast()
		return FALSE

	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/originalcmodeuser = user.cmode_music
		var/originalcmodetarget = target.cmode_music
		var/turf/storedchallengerturf = get_turf(user)
		var/turf/storedchallengedturf = get_turf(target)
		if(user.z != target.z)
			revert_cast()
			return FALSE
		if(target == user)
			revert_cast()
			return FALSE

		for(var/obj/structure/fluff/ravox/challenger/aflag in thearena)
			challengerspawnpoint = get_turf(aflag)
		for(var/obj/structure/fluff/ravox/challenged/bflag in thearena)
			challengedspawnpoint = get_turf(bflag)

		do_teleport(user, challengerspawnpoint)
		do_teleport(target, challengedspawnpoint)
		GLOB.arenafolks += user
		GLOB.arenafolks += target
		storedchallengerturf.visible_message((span_cult("[user] 呼唤了 拉沃克斯 的审判仪式！[target] 与 [user] 一同被带入了试炼！")))

		new /obj/structure/fluff/ravox/challenger/recall(storedchallengerturf)
		new /obj/structure/fluff/ravox/challenged/recall(storedchallengedturf)

		to_chat(user, span_userdanger("审判已经开始，取悦我们吧，原告！！"))
		to_chat(target, span_userdanger("拉沃克斯 的审判开始了。取悦我们吧，被告！！"))

		user.cmode_change('sound/music/ravoxarena.ogg')
		target.cmode_change('sound/music/ravoxarena.ogg')

		addtimer(CALLBACK(user, GLOBAL_PROC_REF(do_teleport), user, storedchallengerturf), 3 MINUTES)
		addtimer(CALLBACK(target, GLOBAL_PROC_REF(do_teleport), target, storedchallengedturf), 3 MINUTES)
		addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, cmode_change), originalcmodeuser), 3 MINUTES)
		addtimer(CALLBACK(target,TYPE_PROC_REF(/mob, cmode_change), originalcmodetarget), 3 MINUTES)
		addtimer(CALLBACK(thearena,TYPE_PROC_REF(/area/rogue/indoors/ravoxarena, cleanthearena), storedchallengedturf), 3 MINUTES) // shunt all items from the arena out onto the challenged spot.

		if(iscarbon(target))
			var/mob/living/carbon/human/spawnprotectiontarget = target
			addtimer(CALLBACK(spawnprotectiontarget,TYPE_PROC_REF(/mob/living/carbon/human, do_invisibility), 10 SECONDS), 3 MINUTES)


		return TRUE
	revert_cast()
	return FALSE


/obj/structure/fluff/ravox
	icon = 'icons/roguetown/rav/obj/flags.dmi'
	density = FALSE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	layer = BELOW_MOB_LAYER
	max_integrity = 0

/obj/structure/fluff/ravox/proc/spawnprotection()
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromflag
	var/maxthrow = 6
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 3

	playsound(src, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, src))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == src || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(AM, src)))
		distfromflag = get_dist(src, AM)
		if(distfromflag == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>你被 拉沃克斯 的力量狠狠砸向了地面！！</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(src, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(5)
				to_chat(M, "<span class='danger'>你被 拉沃克斯 的力量猛地掀飞了出去！！</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromflag - 2, 0, distfromflag))), 3, maxthrow))), 1,null, force = repulse_force)


/obj/structure/fluff/ravox/challenger
	name = "挑战者之旗"
	desc = "审判结束后，挑战者将回到这里。"
	icon_state = "ravoxchallenger"

/obj/structure/fluff/ravox/challenged
	name = "应战者之旗"
	desc = "审判结束后，应战者将回到这里。"
	icon_state = "ravoxchallenged"


/obj/structure/fluff/ravox/challenger/recall/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)

/obj/structure/fluff/ravox/challenged/recall/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)
