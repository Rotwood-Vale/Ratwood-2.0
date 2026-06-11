// Lesser miracle
/obj/effect/proc_holder/spell/invoked/lesser_heal
	name = "奇迹"
	desc = "随时间治疗目标，若目标体内有异物嵌入则会造成伤害。若你信仰十神，则可灼烧亡灵而非治疗。<br>对信仰已死之神的对象无效。"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "lesserheal"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/lesser_heal/cast(list/targets, mob/living/user)
	. = ..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]

	if(HAS_TRAIT(user, TRAIT_RESONANCE))//If the caster has the special funny Astratan trait...
		for(var/mob/living/carbon/fortified in view(2, get_turf(user)))
			if(user.patron?.undead_hater && (fortified.mob_biotypes & MOB_UNDEAD))//Resonance allows one to bypass the check above via an AoE. Slight damage to undead as a result.
				fortified.adjustFireLoss(5)
			else if(iscarbon(fortified))
				var/mob/living/carbon/C = fortified
				C.apply_status_effect(/datum/status_effect/buff/fortify)

	if(HAS_TRAIT(target, TRAIT_PSYDONITE))
		target.visible_message(span_info("[target]动了动，奇迹消散了。"), span_notice("一阵迟钝的暖意在你心中膨胀，却又转瞬即逝。"))
		user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return FALSE

	if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD))
		target.visible_message(span_danger("[target]被圣光灼伤！"), span_userdanger("我被圣光灼伤了！"))
		target.adjustFireLoss(10)
		target.fire_act(1, 10)
		return TRUE

	if(target.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("目标已受到治疗光环的影响！"))
		revert_cast()
		return FALSE

	var/conditional_buff = FALSE
	var/situational_bonus = 1
	var/is_inhumen = FALSE

	var/message_out = span_info("上方传来圣咏之声，[target] 的伤势开始愈合！")
	var/message_self = span_notice("我沐浴在疗愈的圣咏之中！")

	user.patron.on_lesser_heal(user, target, &message_out, &message_self, &conditional_buff, &situational_bonus, &is_inhumen)

	var/healing = 2.5

	if(conditional_buff)
		if(situational_bonus > 0)
			to_chat(user, "在这种环境下，引导我主的力量更加轻松！")
		healing += situational_bonus

	if(!ishuman(target))
		target.apply_status_effect(/datum/status_effect/buff/healing, healing, is_inhumen)
		return TRUE

	var/mob/living/carbon/human/human = target
	var/no_embeds = TRUE
	var/list/embeds = human.get_embedded_objects()

	for(var/object in embeds)
		if(istype(object, /obj/item/natural/worms/leech)) // Leeches and surgical cheeles are made an exception.
			continue

		no_embeds = FALSE
		break

	if(!no_embeds)
		target.visible_message("嵌入的物体周围的伤口撕裂开来！", "当魔法试图绕过嵌入的物体缝合时，剧痛贯穿你的身体！")
		human.adjustBruteLoss(20)
		playsound(target, 'sound/combat/dismemberment/dismem (2).ogg', 100)
		human.emote("agony")
		return FALSE

	target.apply_status_effect(/datum/status_effect/buff/healing, healing)
	target.visible_message(message_out, message_self)

	return TRUE

// Miracle
/obj/effect/proc_holder/spell/invoked/heal
	name = "疗愈加护"
	desc = "提升目标承受治疗的能力，使其受到的全部治疗效果提高 50%<br>若你信奉十神，它会灼烧亡灵而非治疗他们。"
	overlay_icon = 'icons/mob/actions/astratamiracles.dmi'
	action_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_state = "fortify"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
//	chargedloop = /datum/looping_sound/invokeholy
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/invoked/heal/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] 微微一颤，圣迹随之消散。"), span_notice("一股黯淡的暖意在我心中涌起，却又转瞬即逝。"))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD)) //positive energy harms the undead
			target.visible_message(span_danger("[target] 被圣光灼烧！"), span_userdanger("我被圣光灼烧了！"))
			target.adjustFireLoss(25)
			target.fire_act(1,10)
			return TRUE
		target.visible_message(span_info("一圈柔和的光辉拂过 [target]！"), span_notice("我沐浴在圣光之中！"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			C.apply_status_effect(/datum/status_effect/buff/fortify)
		else
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/regression
	name = "回溯"
	desc = "令目标的伤势倒回，随时间逐步愈合。"
	overlay_state = "regression"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = list('sound/magic/regression1.ogg','sound/magic/regression2.ogg','sound/magic/regression3.ogg','sound/magic/regression4.ogg')
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/regression/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message(span_info("秩序充盈的魔力回溯了 [target] 的伤势！"), span_notice("我的伤势正在倒退！"))
		var/healing = 2.5
		target.apply_status_effect(/datum/status_effect/buff/healing, healing)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/convergence
	name = "汇流"
	desc = "让目标的过去与现在汇于一体，使其受到的治疗效果提高 50%。"
	overlay_state = "convergence"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
//	chargedloop = /datum/looping_sound/invokeholy
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = list('sound/magic/convergence1.ogg','sound/magic/convergence2.ogg','sound/magic/convergence3.ogg','sound/magic/convergence4.ogg')
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/invoked/convergence/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message(span_info("命运的汇流环绕着 [target]！"), span_notice("我的过去与现在合而为一！"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			C.apply_status_effect(/datum/status_effect/buff/convergence)
			C.apply_status_effect(/datum/status_effect/buff/fortify)
		else
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
		return TRUE
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/stasis
	name = "停时"
	desc = "你将目标当前的状态封存于时间之中，数秒后令其回归那一刻。若效果结束时目标仍处于“汇流”之下，他们会保留期间获得的治疗。"
	releasedrain = 35
	chargedrain = 1
	chargetime = 30
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	sound = 'sound/magic/timeforward.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	overlay_state = "sands_of_time"
	var/brute = 0
	var/burn = 0
	var/oxy = 0
	var/toxin = 0
	var/turf/origin
	var/firestacks = 0
	var/divinefirestacks = 0
	var/sunderfirestacks = 0
	var/blood = 0
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/stasis/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		var/mob/living/carbon/C = target
		C.apply_status_effect(/datum/status_effect/buff/stasis)
		brute = target.getBruteLoss()
		burn = target.getFireLoss()
		oxy = target.getOxyLoss()
		toxin = target.getToxLoss()
		origin = get_turf(target)
		blood = target.blood_volume
		var/datum/status_effect/fire_handler/fire_stacks/fire_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
		firestacks = fire_status?.stacks
		var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
		sunderfirestacks = sunder_status?.stacks
		var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
		divinefirestacks = divine_status?.stacks
		to_chat(target, span_warning("我感觉自己仿佛有一部分被留在了原地……"))
		play_indicator(target,'icons/mob/overhead_effects.dmi', "timestop", 100, OBJ_LAYER)
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 10 SECONDS)
		return TRUE


/obj/effect/proc_holder/spell/invoked/stasis/proc/remove_buff(mob/living/carbon/target)
	do_teleport(target, origin, no_effects=TRUE)
	var/brutenew = target.getBruteLoss()
	var/burnnew = target.getFireLoss()
	var/oxynew = target.getOxyLoss()
	var/toxinnew = target.getToxLoss()
	target.adjust_fire_stacks(firestacks)
	target.adjust_fire_stacks(sunderfirestacks, /datum/status_effect/fire_handler/fire_stacks/sunder)
	target.adjust_fire_stacks(divinefirestacks, /datum/status_effect/fire_handler/fire_stacks/divine)
	if(target.has_status_effect(/datum/status_effect/buff/convergence))
		if(brutenew>brute)
			target.adjustBruteLoss(brutenew*-1 + brute)
		if(burnnew>burn)
			target.adjustFireLoss(burnnew*-1 + burn)
		if(oxynew>oxy)
			target.adjustOxyLoss(oxynew*-1 + oxy)
		if(toxinnew>toxin)
			target.adjustToxLoss(target.getToxLoss()*-1 + toxin)
		if(target.blood_volume<blood)
			target.blood_volume = blood
	else
		target.adjustBruteLoss(brutenew*-1 + brute)
		target.adjustFireLoss(burnnew*-1 + burn)
		target.adjustOxyLoss(oxynew*-1 + oxy)
		target.adjustToxLoss(target.getToxLoss()*-1 + toxin)
		target.blood_volume = blood
	playsound(target.loc, 'sound/magic/timereverse.ogg', 100, FALSE)

/obj/effect/proc_holder/spell/invoked/stasis/proc/play_indicator(mob/living/carbon/target, icon_path, overlay_name, clear_time, overlay_layer)
	if(!ishuman(target))
		return
	if(target.stat != DEAD)
		var/mob/living/carbon/humie = target
		var/datum/species/species =	humie.dna.species
		var/list/offset_list
		if(humie.gender == FEMALE)
			offset_list = species.offset_features[OFFSET_HEAD_F]
		else
			offset_list = species.offset_features[OFFSET_HEAD]
			var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
			if(offset_list)
				appearance.pixel_x += (offset_list[1])
				appearance.pixel_y += (offset_list[2]+12)
			appearance.appearance_flags = RESET_COLOR
			target.overlays_standing[OBJ_LAYER] = appearance
			target.apply_overlay(OBJ_LAYER)
			update_icon()
			addtimer(CALLBACK(humie, PROC_REF(clear_overhead_indicator), appearance, target), clear_time)

/obj/effect/proc_holder/spell/invoked/stasis/proc/clear_overhead_indicator(appearance,mob/living/carbon/target)
	target.remove_overlay(OBJ_LAYER)
	cut_overlay(appearance, TRUE)
	qdel(appearance)
	update_icon()
	return

// Bishop only miracle - This used to be T3 only but is too powerful and ate into apothecary's niche.
// Instantly heals all wounds & damage on a selected limb.
// Long CD (so a Medical class would still outpace this if there's more than one patient to heal)
/obj/effect/proc_holder/spell/invoked/wound_heal
	name = "疗伤圣迹"
	desc = "治疗目标肢体上的全部伤口。"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "woundheal"
	action_icon_state = "woundheal"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 15
	chargedrain = 0
	chargetime = 3
	range = 1
	ignore_los = FALSE
	warnie = "sydwarning"
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/woundheal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 2 MINUTES
	miracle = TRUE
	is_cdr_exempt = TRUE
	var/delay = 4.5 SECONDS	//Reduced to 1.5 seconds with Legendary
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/wound_heal/cast(list/targets, mob/user = usr)
	if(ishuman(targets[1]))

		var/mob/living/carbon/human/target = targets[1]
		var/mob/living/carbon/human/HU = user
		var/def_zone = check_zone(user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(def_zone)

		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE

		if(!affecting)
			revert_cast()
			return FALSE
		if(length(affecting.embedded_objects))
			var/no_embeds = TRUE
			for(var/object in affecting.embedded_objects)
				if(!istype(object, /obj/item/natural/worms/leech))	//Leeches and surgical cheeles are made an exception.
					no_embeds = FALSE
			if(!no_embeds)
				to_chat(user, span_warning("这条肢体里还有异物，我们无法封合伤口！"))
				revert_cast()
				return FALSE
		if(!do_after(user, (delay - (0.5 SECONDS * HU.get_skill_level(associated_skill)))))
			revert_cast()
			to_chat(user, span_warning("我们被打断了！"))
			return FALSE
		var/foundwound = FALSE
		if(length(affecting.wounds))
			for(var/datum/wound/wound in affecting.wounds)
				if(!isnull(wound) && wound.healable_by_miracles)
					wound.heal_wound(wound.whp)
					foundwound = TRUE
					user.visible_message(("<font color = '#488f33'>[capitalize(wound.name)] 渗出澄澈液体，缓缓闭合，最终只留下酸痛的瘀痕！</font>"))
					affecting.add_wound(/datum/wound/bruise/woundheal)
			if(foundwound)
				playsound(target, 'sound/magic/woundheal_crunch.ogg', 100, TRUE)
			affecting.change_bodypart_status(BODYPART_ORGANIC, heal_limb = TRUE)
			affecting.update_disabled()
			return TRUE
		else
			to_chat(user, span_warning("这条肢体没有伤口。"))
			revert_cast()
			return FALSE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/blood_heal
	name = "鲜血转移奇迹"
	desc = "以神圣魔法将我的血液转移给目标。转移比例随神圣技能等级提升。"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "bloodheal"
	action_icon_state = "bloodheal"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	ignore_los = FALSE
	warnie = "sydwarning"
	movement_interrupt = TRUE
	sound = 'sound/magic/bloodheal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 45 SECONDS
	miracle = TRUE
	devotion_cost = 50
	var/blood_price = 5
	var/blood_vol_restore = 7.5 //30 every 2 seconds.
	var/vol_per_skill = 1	//54 with legendary
	var/delay = 0.5 SECONDS

/obj/effect/proc_holder/spell/invoked/blood_heal/cast(list/targets, mob/user = usr)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]
		var/mob/living/carbon/human/UH = user

		if(target == UH)
			to_chat(UH, span_warning("I cannot transfer my own blood to myself."))
			revert_cast()
			return FALSE

		if(UH.doing)
			to_chat(UH, span_warning("I can't cast this while doing something else."))
			revert_cast()
			return FALSE

		if(NOBLOOD in UH.dna?.species?.species_traits)
			to_chat(UH, span_warning("I have no blood to provide."))
			revert_cast()
			return FALSE

		if(target.blood_volume >= BLOOD_VOLUME_NORMAL)
			to_chat(UH, span_warning("他们的生命之血已经充足，不需要转移。"))
			revert_cast()
			return FALSE

		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target]动了动，奇迹消散了。"), span_notice("一阵迟钝的暖意在你心中膨胀，却又转瞬即逝。"))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE

		UH.visible_message(span_warning("微小的红色丝线将[UH]与[target]相连，血液正在转移！"))
		playsound(UH, 'sound/magic/bloodheal_start.ogg', 100, TRUE)
		var/user_skill = UH.get_skill_level(associated_skill)
		var/user_informed = FALSE
		switch(user_skill)	//Bleeding happens every life(), which is every 2 seconds. Multiply these numbers by 4 to get the "bleedrate" equivalent values.
			if(SKILL_LEVEL_APPRENTICE)
				blood_price = 3.75
			if(SKILL_LEVEL_JOURNEYMAN)
				blood_price = 2.5
			if(SKILL_LEVEL_EXPERT)
				blood_price = 2
			if(SKILL_LEVEL_MASTER)
				blood_price = 1.625
			if(SKILL_LEVEL_LEGENDARY)
				blood_price = 1.25
		if(user_skill > SKILL_LEVEL_NOVICE)
			blood_vol_restore += vol_per_skill * user_skill
		var/max_loops = round(UH.blood_volume / blood_price, 1) * 2	// x2 just in case the user is trying to fill themselves up while using it.
		var/datum/beam/bloodbeam = user.Beam(target,icon_state="blood",time=(max_loops * 5))
		for(var/i in 1 to max_loops)
			if(UH.blood_volume > (BLOOD_VOLUME_SURVIVE / 2))
				if(do_after(UH, delay))
					target.blood_volume = min((target.blood_volume + blood_vol_restore), BLOOD_VOLUME_NORMAL)
					UH.blood_volume = max((UH.blood_volume - blood_price), 0)
					if(target.blood_volume >= BLOOD_VOLUME_NORMAL && !user_informed)
						to_chat(UH, span_info("对方的血量已恢复健康水平，但我还能继续输送。"))
						user_informed = TRUE
				else
					UH.visible_message(span_warning("与 [target] 相连的血链断开了！"))
					bloodbeam.End()
					return TRUE
			else
				UH.visible_message(span_warning("Severs the bloodlink from [target]!"))
				bloodbeam.End()
				return TRUE
		bloodbeam.End()
		return TRUE
	revert_cast()
	return FALSE
