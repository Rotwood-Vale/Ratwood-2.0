//t1, the bends
/obj/effect/proc_holder/spell/invoked/abyssor_bends
	name = "深渊压弯"
	desc = "抽空目标的体力，除非其同样信奉 Abyssor。还会令其头晕目眩、视野模糊。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "bends"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.75 SECONDS
	range = 15
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/foley/bubb (5).ogg'
	invocations = list("深渊之重，碾碎！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 15
	var/base_fatdrain = 10

/obj/effect/proc_holder/spell/invoked/abyssor_bends/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.visible_message("<font color='yellow'>[user] 朝着 [target] 猛然攥拳！</font>")
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon = target
			if(carbon.patron?.type != /datum/patron/divine/abyssor)
				var/fatdrain = user.get_skill_level(associated_skill) * base_fatdrain
				carbon.stamina_add(fatdrain)
		target.Dizzy(10)
		target.blur_eyes(20)
		target.emote("drown")
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/abyssor_undertow // t1 offbalance someone for 5 seconds if on land, on water, knock them down.
	name = "暗流拖曳"
	desc = "若目标站在水上则将其掀翻，否则会令其失去平衡。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "undertow"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.75 SECONDS
	range = 15
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/misc/undertow.ogg'
	invocations = list("绞杀之水，拖下去！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 15

/obj/effect/proc_holder/spell/invoked/abyssor_undertow/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.visible_message("<font color='yellow'>[user] 朝着 [target] 抬手一引！</font>")
		var/turf/targettile = get_turf(target)
		if(istype(targettile, /turf/open/water))
			target.Knockdown(10)
		else
			target.OffBalance(50)
		return TRUE
	revert_cast()
	return FALSE


//T0. Stands the character up, if they can stand.
/obj/effect/proc_holder/spell/self/abyssor_wind
	name = "再起之息"
	desc = "若你倒下便重新起身，并恢复部分体力。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "abyssor_wind"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	sound = 'sound/magic/abyssor_splash.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = list("凡被淹没者，皆将再起！")
	invocation_type = "shout"
	recharge_time = 120 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/stamregenmod = 5	//How many % of stamina we regain after cast, scales with holy skill.

/obj/effect/proc_holder/spell/self/abyssor_wind/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.IsStun() || H.IsImmobilized() || H.IsOffBalanced())
		to_chat(user, span_warning("我现在虚弱得动弹不得！"))
		revert_cast()
		return FALSE
	var/msg = span_warning("[user] ")
	if(H.resting)
		H.set_resting(FALSE, FALSE)
		msg += span_warning("重新起身，并且")
	var/regen = (stamregenmod / 100) * H.get_skill_level(associated_skill)
	H.stamina_add(-(regen * H.max_stamina))
	H.energy_add(regen * H.max_energy)
	msg += span_warning("精神一振！")
	H.visible_message(msg)
	return TRUE

//T0 The Fishing
/obj/effect/proc_holder/spell/invoked/aquatic_compulsion
	name = "驱水引鱼"
	desc = "强令鱼类从指定水域跃出，朝你飞来。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "aqua"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.5 SECONDS
	range = 3
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/foley/bubb (5).ogg'
	invocations = list("破水而出。")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 10
	//Horrendous carry-over from fishing code
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	var/list/fishingMods = list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0.1,
		"ceruleanFishingMod" = 0 // 1 on cerulean aril, 0 on everything else
	)

/obj/effect/proc_holder/spell/invoked/aquatic_compulsion/cast(list/targets, mob/user = usr)
	. = ..()
	if(isturf(targets[1]))
		var/turf/T = targets[1]
		var/A
		if(T.type in frwt)
			A = pickweightAllowZero(createFreshWaterFishWeightListModlist(fishingMods))
		else if(T.type in salwt_coast)
			A = pickweightAllowZero(createCoastalSeaFishWeightListModlist(fishingMods))
		else if(T.type in salwt_deep)
			A = pickweightAllowZero(createDeepSeaFishWeightListModlist(fishingMods))
		else if(T.type in mud)
			A = pickweightAllowZero(createMudFishWeightListModlist(fishingMods))
		if(A)
			var/atom/movable/AF = new A(T)
			if(istype(AF, /obj/item/reagent_containers/food/snacks/fish))
				var/obj/item/reagent_containers/food/snacks/fish/F = AF
				F.sinkable = FALSE
				F.throw_at(get_turf(user), 5, 1, null)
			else
				AF.throw_at(get_turf(user), 5, 1, null)
			record_featured_stat(FEATURED_STATS_FISHERS, user)
			record_round_statistic(STATS_FISH_CAUGHT)
			playsound(T, 'sound/foley/footsteps/FTWAT_1.ogg', 100)
			teleport_to_dream(user, 10000, 1)
			user.visible_message("<font color='yellow'>[user] 朝着 [T] 做出招引的手势！</font>")
			return TRUE
		else
			revert_cast()
			return FALSE
	revert_cast()
	return FALSE

//T2, Abyssal Healing. Totally stole most of this from lesser heal.
/obj/effect/proc_holder/spell/invoked/abyssheal
	name = "深渊疗愈"
	desc = "随时间治疗目标；你周围的水越多，治疗越强。若长时间远离水域，效果会逐渐衰弱。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "deepheal"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0.75 SECONDS
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/foley/waterenter.ogg'
	invocations = list("疗愈之水，奔涌而来！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 45
	var/slickness = 20
	var/max_slickness = 20
	var/max_slickness_greater_caster = 40
	var/base_healing = 6.5

/obj/effect/proc_holder/spell/invoked/abyssheal/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] 微微一颤，圣迹随之消散。"), span_notice("一股黯淡的暖意在我心中涌起，却又转瞬即逝。"))
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD))
			target.visible_message(span_danger("[target] 被神圣重压碾中！"), span_userdanger("我被神圣重压压住了！"))
			target.adjustBruteLoss(30)			
			return TRUE

		var/conditional_buff = FALSE
		var/situational_bonus = 0
		target.visible_message(span_info("一阵神圣能量如浪涛般拍向 [target]！"), span_notice("疗愈之力正如潮水般压过我的全身！"))

		var/list/water = list(/turf/open/water/bath, /turf/open/water/ocean, /turf/open/water/cleanshallow, /turf/open/water/swamp, /turf/open/water/swamp/deep, /turf/open/water/pond, /turf/open/water/river)

		// Calculate situational bonus based on water nearby
		for (var/turf/O in oview(3, user))
			if (is_type_in_list(O, water))
				situational_bonus = min(situational_bonus + 0.1, 2)
		for (var/turf/open/water/ocean/deep/O in oview(3, user))
			situational_bonus += 0.5

		var/holy_skill = user.get_skill_level(associated_skill)
		// It's annoying to have to do a check here -every- time for a one time change, but it's the only way I can think of without a refactor of job systems or spells...
		if(holy_skill > 3)
			max_slickness = max_slickness_greater_caster

		// Update slickness based on situational bonus
		if (situational_bonus > 0)
			slickness = max_slickness
			conditional_buff = TRUE
			to_chat(user, "在这种环境下，呼唤 Abyssor 的力量更加轻松！")

		// Warning messages
		if((slickness / max_slickness) <= 0.5)
			to_chat(user, span_warning("你与 Abyssor 的联系正在减弱。靠近水域施法即可恢复。"))

		// Calculate healing based on slickness and situational bonus
		var/healing = max(base_healing * (slickness / max_slickness) + situational_bonus, 3)
		if (situational_bonus == 0)
			slickness = max(0, slickness - 1)

		target.adjustFireLoss(-80)
		if (conditional_buff)
			target.adjustFireLoss(-40)

		target.apply_status_effect(/datum/status_effect/buff/healing, healing)
		return TRUE

	revert_cast()
	return FALSE
//t3 alt, land surf, i just removed it but if this idea is like better... we'll see

//t3, possible t4 if I put in land surf, summon mossback
/obj/effect/proc_holder/spell/invoked/call_mossback
	name = "召唤 Mossback"
	desc = "召来一只对你友善、并会听从你命令的 Mossback。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "crab"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	releasedrain = 20
	chargedrain = 0
	chargetime = 4 SECONDS
	chargedloop = null
	sound = 'sound/foley/bubb (1).ogg'
	invocations = list("自深渊升起！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 100
	var/townercrab = TRUE //I was looking at this for three days and i am utterly stupid for not fixing it
	var/mob/living/simple_animal/hostile/retaliate/rogue/mossback/summoned

/obj/effect/proc_holder/spell/invoked/call_mossback/cast(list/targets, mob/living/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	if(isopenturf(T))
		if(!user.mind.has_spell(/obj/effect/proc_holder/spell/invoked/minion_order))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
		QDEL_NULL(summoned)
		summoned = new /mob/living/simple_animal/hostile/retaliate/rogue/mossback(T, user, townercrab)
		return TRUE
	else
		to_chat(user, span_warning("目标位置被阻挡了，我的呼唤没能引来 Mossback。"))
		return FALSE

/obj/effect/proc_holder/spell/invoked/call_dreamfiend
	name = "召来 Dreamfiend"
	desc = "召唤一只 Dreamfiend 去纠缠你的目标。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "dreamfiend"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	chargetime = 1.25 SECONDS
	sound = 'sound/foley/bubb (1).ogg'
	invocations = list("自梦中现身，吞噬！")
	invocation_type = "shout"
	recharge_time = 300 SECONDS
	miracle = TRUE
	devotion_cost = 150

	// Teleport parameters
	var/inner_tele_radius = 1
	var/outer_tele_radius = 2
	var/include_dense = FALSE
	var/include_teleport_restricted = FALSE

/obj/effect/proc_holder/spell/invoked/call_dreamfiend/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/target = targets[1]
	
	if(!istype(target))
		to_chat(user, span_warning("这个法术只对会做梦的生物生效！"))
		revert_cast()
		return FALSE
	
	if(!summon_dreamfiend(
		target = target,
		user = user,
		F = /mob/living/simple_animal/hostile/rogue/dreamfiend,
		outer_tele_radius = outer_tele_radius,
		inner_tele_radius = inner_tele_radius,
		include_dense = FALSE,
		include_teleport_restricted = FALSE
	))
		to_chat(user, span_warning("附近没有合适的位置让 Dreamfiend 显现！"))
		revert_cast()
		return FALSE

	return TRUE

/proc/summon_dreamfiend(mob/living/target, mob/living/user, mob/F = /mob/living/simple_animal/hostile/rogue/dreamfiend, outer_tele_radius = 3, inner_tele_radius = 2, include_dense = FALSE, include_teleport_restricted = FALSE)
	var/turf/target_turf = get_turf(target)
	var/list/turfs = list()

	// Reused turf selection logic from blink_to_target
	for(var/turf/T in range(target_turf, outer_tele_radius))
		if(T in range(target_turf, inner_tele_radius))
			continue
		if(istransparentturf(T))
			continue
		if(T.density && !include_dense)
			continue
		if(T.teleport_restricted && !include_teleport_restricted)
			continue
		if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)
			continue
		if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)
			continue
		turfs += T

	if(!length(turfs))
		for(var/turf/T in orange(target_turf, outer_tele_radius))
			if(!(T in orange(target_turf, inner_tele_radius)))
				turfs += T

	if(!length(turfs))
		return FALSE

	var/turf/spawn_turf = pick(turfs)
	
	F = new F(spawn_turf)
	F.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	F.ai_controller.set_blackboard_key(BB_MAIN_TARGET, target)
	
	F.visible_message(span_notice("[F] 紧随着 [target] 显现而出……无数獠牙凶狠毕露！"))
	return TRUE

// No chargetime given this can be cast well in advance.
/obj/effect/proc_holder/spell/invoked/abyssal_infusion
	name = "深渊灌注"
	desc = "消耗一条鮟鱇鱼，为目标赐下呼唤“深渊之力”的能力。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "abyssal_infusion"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	sound = 'sound/foley/bubb (1).ogg'
	//Each dreamfiend has a different name to call!
	invocations = list("深渊，翻涌！")
	invocation_type = "shout"
	recharge_time = 600 SECONDS
	miracle = TRUE
	devotion_cost = 300

/obj/effect/proc_holder/spell/invoked/abyssal_infusion/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/human/target = targets[1]

	if(!istype(target, /mob/living/carbon/human) || target.mind == null)
		to_chat(user, span_warning("这个法术只对会做梦的生物生效！"))
		revert_cast()
		return FALSE

	if(target == user)
		to_chat(user, span_warning("你必须从安全的精神距离维系与 Dreamfiend 的联系，否则连你自己也会被反噬吞没！"))
		revert_cast()
		return FALSE

	if(target.mind.has_spell(/obj/effect/proc_holder/spell/invoked/abyssal_strength))
		to_chat(user, span_warning("[target] 已经受到了 Abyssor 之力的赐福。"))
		revert_cast()
		return FALSE

	var/anglerfish_found = FALSE
	var/list/held_items = list()

	for(var/obj/item/I in user.held_items)
		held_items += I

	for(var/obj/item/I in held_items)
		if(istype(I, /obj/item/reagent_containers/food/snacks/fish/angler))
			qdel(I)
			anglerfish_found = TRUE
			break

	if(!anglerfish_found)
		to_chat(user, span_warning("想要引导深渊能量，就必须消耗一条鮟鱇鱼！"))
		revert_cast()
		return FALSE

	target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/abyssal_strength)
	to_chat(target, span_warning("我的心智翻腾扭曲，一种新的能力显现了。"))

	return TRUE

/obj/effect/proc_holder/spell/invoked/abyssal_strength
	name = "深渊之力"
	desc = "提升除幸运外的全部属性，同时降低你的感知。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "abyssal_strength1"
	range = 7
	no_early_release = TRUE
	charging_slowdown = 1
	chargetime = 2 SECONDS
	sound = 'sound/foley/bubb (1).ogg'
	//Each dreamfiend has a different name to call!
	invocations = list("深渊，翻涌！")
	invocation_type = "shout"
	recharge_time = 750 SECONDS

	var/stage = 1
	var/casts_in_stage = 0
	var/current_stage3_chance = 50
	var/static/list/stage_mobs = list(
		/mob/living/simple_animal/hostile/rogue/dreamfiend,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/major,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient
	)

/obj/effect/proc_holder/spell/invoked/abyssal_strength/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/target = user

	var/list/stats = list(
		"str" = 3 + ((stage - 1) * 1),
		"con" = 1 + (stage * 2),
		"end" = 1 + (stage * 2),
		"fort" = 1 - (stage * 2),
		"speed" = 1 - (stage * 2),
		"per" = -1 * stage
	)

	var/summon_chance = 0
	var/spawn_type
	switch(stage)
		if(1)
			summon_chance = 5 + (casts_in_stage * 35)
			spawn_type = stage_mobs[1]
		if(2)
			summon_chance = 10 + (casts_in_stage * 40)
			spawn_type = stage_mobs[2]
		if(3)
			summon_chance = current_stage3_chance
			current_stage3_chance += rand(1,20)
			spawn_type = stage_mobs[3]

	if(prob(summon_chance))
		summon_dreamfiend(target = user, user = user, F = spawn_type)
		to_chat(user, span_userdanger("你感到梦境已在现实中凝成可怖的形体！"))
		user.mind.RemoveSpell(src)
		return

	if(stage < 3)
		casts_in_stage++
		if(casts_in_stage > 2)
			stage++
			casts_in_stage = 0
			if(stage == 3)
				to_chat(user, span_warning("我能感觉到无数滑腻渗液的利齿正啃咬我的皮肤！有什么可怖之物正在注视着我！"))
			else
				to_chat(user, span_warning("你脑海中的低语声越来越响了……"))
	else
		casts_in_stage = min(casts_in_stage + 1, 100)
	
	target.apply_status_effect(
		/datum/status_effect/buff/abyssal,
		stats["str"],
		stats["con"],
		stats["end"],
		stats["fort"],
		stats["speed"],
		stats["per"]
	)

	overlay_state = "abyssal_strength[stage]"

	return TRUE

/atom/movable/screen/alert/status_effect/buff/abyssal
	name = "Abyssal strength"
	desc = "我能感觉到一股不自然的力量盘踞在四肢之中。"
	icon_state = "abyssal"

#define ABYSSAL_FILTER "abyssal_glow"

/datum/status_effect/buff/abyssal
	var/dreamfiend_chance = 0
	var/stage = 1
	var/str_buff = 3
	var/con_buff = 3
	var/end_buff = 3
	var/speed_malus = 0
	var/fortune_malus = 0
	var/perception_malus = 0
	var/outline_colour ="#00051f"
	alert_type = /atom/movable/screen/alert/status_effect/buff/abyssal
	examine_text = "SUBJECTPRONOUN 的肌肉因一种苍白而诡异的力量而高高鼓胀。"
	id = "abyssal_strength"
	duration = 450 SECONDS

/datum/status_effect/buff/abyssal/on_creation(mob/living/new_owner, new_str, new_con, new_end, new_fort, new_speed, new_per)
	str_buff = new_str
	con_buff = new_con
	end_buff = new_end
	fortune_malus = new_fort
	speed_malus = new_speed
	perception_malus = new_per

	effectedstats = list(
		STATKEY_STR = str_buff,
		STATKEY_CON = con_buff,
		STATKEY_WIL = end_buff,
		STATKEY_LCK = fortune_malus,
		STATKEY_SPD = speed_malus,
		STATKEY_PER = perception_malus
	)
	
	return ..()

/datum/status_effect/buff/abyssal/on_apply()
	. = ..()
	var/filter = owner.get_filter(ABYSSAL_FILTER)
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	if (!filter)
		owner.add_filter(ABYSSAL_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 180, "size" = 1))
	to_chat(owner, span_warning("我的四肢正被异界之力灌得鼓胀起来！"))

/datum/status_effect/buff/abyssal/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	owner.remove_filter(ABYSSAL_FILTER)
	to_chat(owner, span_warning("那股诡异的力量消退了。"))

#undef ABYSSAL_FILTER
