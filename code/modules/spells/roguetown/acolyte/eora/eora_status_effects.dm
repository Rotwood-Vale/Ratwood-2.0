#define ASHEN_FILTER
/atom/movable/screen/alert/status_effect/buff/ashen_aril
	name = "阿瑞里安神化"
	desc = "神圣之力在你体内奔涌，强化着你的一切能力。"
	icon_state = "buff"

/datum/status_effect/buff/ashen_aril
	id = "ashen"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ashen_aril
	duration = 6 MINUTES
	var/prevent_reapply = FALSE
	var/current_boost = 5
	var/next_wound_time = 0
	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/status_effect/buff/ashen_aril/on_creation(mob/living/new_owner, boost_level = 5, new_duration = 6 MINUTES)
	current_boost = boost_level
	duration = new_duration
	next_wound_time = world.time - 1

	. = ..()

	switch(current_boost)
		if(3 to 5)
			linked_alert.name = "阿瑞里安神化"
			linked_alert.desc = "神圣之力在你体内奔涌，强化着你的一切能力。"
			linked_alert.icon_state = "pom_god"
		if(1 to 2)
			linked_alert.name = "衰退中的阿瑞里安神化"
			linked_alert.desc = "你体内的神圣之力正在消退。"
			linked_alert.icon_state = "pom_god"
		if(0)
			linked_alert.name = "阿瑞里安平宁"
			linked_alert.desc = "暴风雨来临前的平静。"
			linked_alert.icon_state = "pom_anxiety"
		if(-4 to -1)
			linked_alert.name = "灰烬灾厄"
			linked_alert.desc = "你的身体正在化为灰烬！"
			linked_alert.icon_state = "pom_regret"
		if(-5)
			linked_alert.name = "阿瑞里安空壳"
			linked_alert.desc = "你身体的大部分都已朽坏成灰。若你居然还活着，那也绝非 Eora 的怜悯。"
			linked_alert.icon_state = "pom_regret"

/datum/status_effect/buff/ashen_aril/on_apply()
	// Apply stat boosts to all attributes
	effectedstats = list(
		STATKEY_STR = current_boost,
		STATKEY_WIL = current_boost,
		STATKEY_CON = current_boost,
		STATKEY_INT = current_boost,
		STATKEY_PER = current_boost,
		STATKEY_LCK = current_boost,
		STATKEY_SPD = current_boost
	)
	//Apply Uncapped STR as long as it's still positive.
	if(current_boost > 0)
		ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)

	// Apply Beautiful trait for positive boosts
	if(current_boost == 5)
		ADD_TRAIT(owner, TRAIT_BEAUTIFUL, TRAIT_MIRACLE)
		to_chat(owner, span_notice("你感到自己被神力充盈，光彩焕发！"))
	else if(current_boost == 0)
		REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, TRAIT_MIRACLE)
		to_chat(owner, span_warning("你那神赐的美丽正在消退……"))
	else if (current_boost == -5)
		ADD_TRAIT(owner, TRAIT_UNSEEMLY, TRAIT_MIRACLE)
		to_chat(owner, span_notice("你的血肉正变得干裂剥落，令人作呕。"))

	// Set visual appearance based on boost level
	switch(current_boost)
		if(3 to 5)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#e78e08", "alpha" = 225, "size" = 2))
		if(1 to 2)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#c0c0c0", "alpha" = 180, "size" = 1))
		if(-4 to -1)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#a9a9a9", "alpha" = 160, "size" = 1))
		if(-5)
			owner.add_filter(ASHEN_FILTER, 2, list("type" = "outline", "color" = "#696969", "alpha" = 140, "size" = 1))

	return ..()

/datum/status_effect/buff/ashen_aril/tick()
	// Apply wounds at negative boost levels except -5
	if(current_boost < 0 && current_boost > -5 && world.time > next_wound_time)
		next_wound_time = world.time + rand(30 SECONDS, 60 SECONDS)
		if(prob(25))
			if(iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/list/valid_parts = list()

				for(var/obj/item/bodypart/BP in C.bodyparts)
					var/BP_name = BP.name
					if(!BP_name) BP_name = "无名肢体" // Fallback

					var/bool_can_bloody_wound = BP.can_bloody_wound()
					var/bool_in_zone = (BP.body_zone in valid_body_zones)
					var/bool_combined_condition = (bool_in_zone && bool_can_bloody_wound)

					if(bool_combined_condition) //Idk but it works like this.
						valid_parts += BP

				if(length(valid_parts))
					var/obj/item/bodypart/BP = pick(valid_parts)
					BP.add_wound(/datum/wound/slash, FALSE, "looks sickly and ashen.")
					new /obj/item/ash(owner.loc)
					to_chat(owner, span_warning("你的身体皲裂开来，一道新的伤口张开，灰烬从中簌簌落下。"))

/datum/status_effect/buff/ashen_aril/on_remove()
	. = ..()
	owner.remove_filter(ASHEN_FILTER)
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	if(!prevent_reapply)
	// Handle effect progression
		if(current_boost > -4)
			owner.apply_status_effect(/datum/status_effect/buff/ashen_aril, current_boost - 1)
		else
			// Permanent at -5 with wilting effect
			owner.apply_status_effect(/datum/status_effect/buff/ashen_aril, -5, -1)
			owner.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)

#undef ASHEN_FILTER

/datum/status_effect/buff/eoran_balm_effect
	id = "eoran_balm"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = -1
	var/healing_power = 1.5
	var/waiting_for_prompt = FALSE

/datum/status_effect/buff/eoran_balm_effect/on_apply()
	to_chat(owner, span_notice("一股奇异药膏般的力量在我血管中流淌，不自然的暖意正扩散到我这具死寂的身体……"))
	. = ..()

/datum/status_effect/buff/eoran_balm_effect/tick()
	. = ..()
	var/mob/living/carbon/M = owner
	new /obj/effect/temp_visual/heal(get_turf(owner), "#cd2be2")

	if(M.stat != DEAD)
		M.remove_status_effect(src)
		return

	if(waiting_for_prompt)
		return

	M.adjustBruteLoss(-healing_power)
	M.adjustFireLoss(-healing_power)
	M.adjustToxLoss(-healing_power)
	M.adjustOxyLoss(-healing_power)
	M.adjustCloneLoss(-healing_power)

	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume + healing_power * 2, BLOOD_VOLUME_NORMAL)

	var/list/wounds = M.get_wounds()
	if(length(wounds))
		M.heal_wounds(healing_power)
		M.update_damage_overlays()

	if(M.getBruteLoss() < 50 && M.getFireLoss() < 50 && M.getToxLoss() < 50 && M.getOxyLoss() < 50 && M.blood_volume >= BLOOD_VOLUME_SAFE)

		new /obj/effect/temp_visual/heal(get_turf(M), "#8A2BE2")

		var/mob/dead/observer/spirit = M.get_spirit()
		//GET OVER HERE!
		if(spirit)
			var/mob/dead/observer/ghost = spirit.ghostize()
			qdel(spirit)
			ghost.mind.transfer_to(M, TRUE)
		M.grab_ghost(force = FALSE)

		M.adjustOxyLoss(-M.getOxyLoss()) // Full oxygen healing
		if(!M.revive(full_heal = FALSE))
			M.visible_message(span_warning("[M] 的身体猛然一颤，却仍未能复生！"))
			M.remove_status_effect(src)
			return

		M.emote("breathgasp")
		M.Jitter(100)
		record_round_statistic(STATS_LUX_REVIVALS)
		M.update_body()
		M.visible_message(span_notice("[M] 被强行从 Necra 的掌握中拽了回来！"), span_green("我自虚无之中醒来。"))

		M.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
		M.apply_status_effect(/datum/status_effect/debuff/revived)
		M.remove_status_effect(src)

#define POM_FILTER "pom_aura"

/datum/status_effect/debuff/pomegranate_aura
	id = "pomegranate_aura"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/pomegranate_aura
	var/outline_colour ="#42001f"
	var/datum/weakref/source_ref

/datum/status_effect/debuff/pomegranate_aura/on_creation(mob/living/carbon/owner, tree)
	if(!owner)
		return ..()

	source_ref = WEAKREF(tree)
	var/str_change = -8
	var/perc_change = -8

	if(owner?.head?.type == /obj/item/clothing/head/peaceflower)
		str_change += 1
		perc_change += 1

	if(owner.patron.type == /datum/patron/divine/eora)
		str_change += 2
		perc_change += 2
		if(owner.get_skill_level(/datum/skill/magic/holy) >= 1)
			str_change += 2
			perc_change += 4

	effectedstats = list(
		STATKEY_STR = str_change,
		STATKEY_PER = perc_change
	)

	return ..()

/datum/status_effect/debuff/pomegranate_aura/on_apply()
	. = ..()
	var/filter = owner.get_filter(POM_FILTER)
	if (!filter)
		owner.add_filter(POM_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 180, "size" = 1))
	to_chat(owner, span_warning("我的战斗能力正被这棵树抽走！"))

/datum/status_effect/debuff/pomegranate_aura/on_remove()
	. = ..()
	owner.remove_filter(POM_FILTER)
	to_chat(owner, span_warning("当我离开这棵树的影响范围后，力量又回来了。"))

/datum/status_effect/debuff/pomegranate_aura/tick()
	if(HAS_TRAIT(owner, TRAIT_EORAN_CALM))
		owner.remove_status_effect(src)
		return

	// Check if source tree still exists
	var/obj/structure/eoran_pomegranate_tree/tree = source_ref?.resolve()
	if(QDELETED(tree) || !istype(tree))
		owner.remove_status_effect(src)
		return

	// Check distance to tree. This is a sanity check given the aura SHOULD remove already, but you can never be too safe :)
	if(get_dist(owner, tree) > tree.aura_range)
		owner.remove_status_effect(src)
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		// Ugly people might get hurt
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY) && prob(2))
			to_chat(H, span_warning("这棵树的美丽灼痛了你的双眼！"))
			H.Dizzy(5)
			H.blur_eyes(5)
			H.adjustBruteLoss(10, 0)

		// Beautiful people might get healed
		else if(HAS_TRAIT(H, TRAIT_BEAUTIFUL) && prob(10))
			to_chat(H, span_good("这棵树的美丽令你重新焕发生机！"))
			H.apply_status_effect(/datum/status_effect/buff/healing, 1)

	// There is no beauty in death. Feed my tree.
	if(owner.stat == DEAD)
		owner.blood_volume = max(10, owner.blood_volume - 10)

/atom/movable/screen/alert/status_effect/pomegranate_aura
	name = "Eora 的祝福"
	desc = "你在这棵圣树附近感到一阵安宁。"
	icon_state = "pom_peace"

#undef POM_FILTER

#define WILTING_FILTER "wilting_death"

/atom/movable/screen/alert/status_effect/eoran_wilting
	name = "枯萎"
	desc = "我的四肢正在脱落！"
	icon_state = "pom_death"

/datum/status_effect/debuff/eoran_wilting
	id = "wilting"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/eoran_wilting
	var/outline_colour ="#2c2828"
	var/datum/weakref/source_ref

/datum/status_effect/debuff/eoran_wilting/on_apply()
	if(isliving(owner))
		owner.add_filter(WILTING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 210, "size" = 2))
		to_chat(owner, span_userdanger("你感觉自己的四肢正可怖地开始脱落，死亡已近在眼前！"))
	return TRUE

/datum/status_effect/debuff/eoran_wilting/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(WILTING_FILTER)
	
	dismember_owner()

/datum/status_effect/debuff/eoran_wilting/tick()
	if(isliving(owner))
		var/mob/living/L = owner
		L.flash_fullscreen("redflash3", 1)
		
		// Small damage to limbs as warning
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			for(var/obj/item/bodypart/BP in C.bodyparts)
				if(BP.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					BP.receive_damage(1)

/datum/status_effect/debuff/eoran_wilting/proc/dismember_owner()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	playsound(C, 'sound/misc/eat.ogg', 100, TRUE)

	// Dismember limbs in sequence
	var/static/list/dismember_order = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD
	)

	C.visible_message(span_userdanger("[C] 的四肢在可怖景象中枯萎断落！"))

	for(var/zone in dismember_order)
		var/obj/item/bodypart/BP = C.get_bodypart(zone)
		if(BP)
			C.adjustBruteLoss(50)
			BP.dismember()
			sleep(0.5 SECONDS)

#undef WILTING_FILTER

/datum/status_effect/pearlescent_aril
	id = "pearlescent_aril"
	duration = 10 MINUTES
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/pearlescent_aril

/atom/movable/screen/alert/status_effect/pearlescent_aril
	name = "珠辉净化"
	desc = "毒素正在治愈你！"
	icon_state = "pearlescent"

/datum/status_effect/pearlescent_aril/on_apply()
	to_chat(owner, span_notice("当这枚果粒生效时，一股净化的暖流扩散进了你的血脉。"))
	return ..()

/datum/status_effect/pearlescent_aril/tick()
	if(!owner.reagents || !iscarbon(owner))
		return
	
	var/mob/living/carbon/C = owner
	var/datum/reagents/R = C.reagents
	var/conversion_occurred = FALSE
	
	for(var/datum/reagent/RG in R.reagent_list)
		if(RG.harmful || istype(RG, /datum/reagent/medicine/stronghealth) && RG.volume > 0.1)
			R.remove_reagent(RG.type, 1)
			R.add_reagent(/datum/reagent/medicine/healthpot, 1)
			conversion_occurred = TRUE
	
	// Visual feedback if conversion occurred
	if(conversion_occurred)
		new /obj/effect/temp_visual/heal(get_turf(C), "#d8d8d8")

/datum/status_effect/pearlescent_aril/on_remove()
	to_chat(owner, span_warning("那股净化的暖意正从你的血脉中褪去。"))
	..()
