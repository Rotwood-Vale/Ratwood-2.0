/obj/effect/proc_holder/spell/invoked/resurrect
	name = "复苏"
	overlay_state = "revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 250
	var/revive_pq = PQ_GAIN_REVIVE
	var/required_structure = /obj/structure/fluff/psycross
	var/required_items = list(/obj/item/clothing/neck/roguetown/psicross = 1)
	var/alt_required_items = list(/obj/item/clothing/neck/roguetown/psicross = 1)
	var/item_radius = 1
	var/debuff_type = /datum/status_effect/debuff/revived
	var/structure_range = 1
	var/harms_undead = TRUE
	priest_excluded = TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/start_recharge()
	recharge_time = initial(recharge_time) * SSchimeric_tech.get_resurrection_multiplier()
	. = ..()

/obj/effect/proc_holder/spell/invoked/resurrect/proc/get_current_required_items()
	if(SSchimeric_tech.has_revival_cost_reduction() && length(alt_required_items))
		return alt_required_items
	return required_items

/obj/effect/proc_holder/spell/invoked/resurrect/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]

		var/validation_result = validate_items(target)
		if(validation_result != "")
			to_chat(user, span_warning("[validation_result]，物品必须放在 [target] 身旁或其所在位置。"))
			revert_cast()
			return FALSE

		var/found_structure = FALSE
		var/list/search_area = oview(structure_range, target)

		for(var/atom/A in search_area)
			// Check if the atom itself is the required structure type
			if(istype(A, required_structure))
				found_structure = TRUE
				break

			if(istype(A, /turf))
				var/turf/T = A
				for(var/obj/O in T.contents)
					if(istype(O, required_structure))
						found_structure = TRUE
						break // Found it in the turf, no need to check further
			if(found_structure)
				break

		if(!found_structure)
			var/atom/temp_structure = required_structure
			to_chat(user, span_warning("我需要在 [target] 附近放置一座圣洁的 [initial(temp_structure.name)]。"))
			revert_cast()
			return FALSE
			//OV edit
		if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering))
			target.revive()
			return TRUE
		//OV edit
		var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
		if(underworld_spirit)
			var/mob/dead/observer/ghost = underworld_spirit.ghostize()
			qdel(underworld_spirit)
			ghost.mind.transfer_to(target, TRUE)
		target.grab_ghost(force = TRUE)
		if(!target.check_revive(user))
			revert_cast()
			return FALSE
		if(target.mob_biotypes & MOB_UNDEAD && harms_undead) //positive energy harms the undead
			target.visible_message(
				span_danger("[target] 被神圣魔法彻底抹消了！"),
				span_userdanger("我被神圣魔法抹消了！")
			)
			target.gib()
			return TRUE
		target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
		if(!target.revive(full_heal = FALSE))
			to_chat(user, span_warning("什么也没有发生。"))
			revert_cast()
			return FALSE
		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] 被神圣魔法复活了！"), span_green("我自虚无中醒来。"))
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		target.apply_status_effect(debuff_type)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		//Due to an increased cost and cooldown, these revival types heal quite a bit.
		target.apply_status_effect(/datum/status_effect/buff/healing, 14)
		consume_items(target)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/resurrect/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		to_chat(user, span_warning("神迹熄散了。"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/proc/validate_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	var/list/available_items = list()
	var/list/missing_items = list()

	// Scan for items in radius
	for(var/obj/item/I in range(item_radius, center))
		if(I.type in current_required_items)
			available_items[I.type] += 1

	// Check quantities and compile missing list
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]
		var/have = available_items[item_type] || 0

		if(have < needed) {
			var/obj/item/I = item_type
			var/amount_needed = needed - have
			missing_items += "[amount_needed] 个[initial(I.name)] "
		}

	if(length(missing_items))
		var/string = ""
		for(var/item in missing_items)
			string += item
		return "缺少材料：[string]。"
	return ""

/obj/effect/proc_holder/spell/invoked/resurrect/proc/consume_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]

		for(var/obj/item/I in range(item_radius, center))
			if(needed <= 0)
				break
			if(I.type == item_type)
				needed--
				qdel(I)

/obj/effect/proc_holder/spell/invoked/resurrect/abyssor
	name = "深渊复苏"
	desc = "付出代价复活目标，对自己施放可查看条件。<br>一头梦魇恶物会持续追猎目标并削弱其属性，直到其亲自面对它。"
	overlay_icon = 'icons/mob/actions/abyssormiracles.dmi'
	action_icon = 'icons/mob/actions/abyssormiracles.dmi'
	overlay_state = "resurrect"
	sound = 'sound/magic/whale.ogg'
	//A medley of common ocean fish, totalling 10
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fish/sole = 3,
		/obj/item/reagent_containers/food/snacks/fish/cod = 3,
		/obj/item/reagent_containers/food/snacks/fish/bass = 2,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 1,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 1,
	)
	alt_required_items = list(
		/obj/item/reagent_containers/food/snacks/fish/plaice = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1
	)
	debuff_type = /datum/status_effect/debuff/dreamfiend_curse
	//This will be Abyssor's statue soon.
	required_structure = /turf/open/water/ocean

/datum/status_effect/debuff/dreamfiend_curse
	id = "dreamfiend_curse"
	alert_type = /atom/movable/screen/alert/status_effect/dreamfiend_curse
	/// Type of dreamfiend to summon
	var/dreamfiend_type
	var/obj/effect/proc_holder/spell/invoked/summon_dreamfiend_curse/curse_spell

/datum/status_effect/debuff/dreamfiend_curse/on_creation(mob/living/new_owner)
	// Choose dreamfiend type from weighted list
	var/list/dreamfiend_types = list(
		/mob/living/simple_animal/hostile/rogue/dreamfiend = 50,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/major = 49,
		/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient = 1
	)
	dreamfiend_type = pickweight(dreamfiend_types)

	effectedstats = list(
		STATKEY_STR = 1,
		STATKEY_INT = -5,
		STATKEY_LCK = -5,
		STATKEY_SPD = -2,
		STATKEY_PER = -5
	)

	// Add summoning spell to the victim
	if(!new_owner.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/abyssal_strength))
		curse_spell = new(new_owner)
		new_owner.mind?.AddSpell(curse_spell)
		curse_spell.dreamfiend_type = dreamfiend_type
		curse_spell.timed_cooldown = world.time + 5 MINUTES

	. = ..()

	switch(dreamfiend_type)
		if(/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient)
			linked_alert.icon_state = "dreamfiend_ancient"
			linked_alert.name = "宏深渊诅咒"
			linked_alert.desc = "一股骇人的存在正在撕扯我心智的边缘。这种威胁绝非我一人能够面对。"
		if(/mob/living/simple_animal/hostile/rogue/dreamfiend/major)
			linked_alert.icon_state = "dreamfiend_major"
			linked_alert.name = "重深渊诅咒"
			linked_alert.desc = "一头可怖的大魔正在蚕食我的心智。我必须将其召来并直面，才能找回自己的神智。"
		if(/mob/living/simple_animal/hostile/rogue/dreamfiend)
			linked_alert.icon_state = "dreamfiend"

/atom/movable/screen/alert/status_effect/dreamfiend_curse
	name = "深渊诅咒"
	desc = "一头梦魇实体令你复生，如今却正不断抽取你的生机。把它召来，亲自面对它。"

/obj/effect/proc_holder/spell/invoked/summon_dreamfiend_curse
	name = "直面梦魇"
	desc = "召出纠缠着你的梦魇恶物，与其正面对抗。"
	overlay_state = "terrors"
	chargetime = 0
	invocations = list(span_danger("身上渐渐泛起海盐气息。你能听见浪涛正在附近拍岸……"))
	invocation_type = "emote"
	sound = 'modular_azurepeak/sound/mobs/abyssal/abyssal_teleport.ogg'
	/// Type of dreamfiend to summon
	var/dreamfiend_type
	recharge_time = 600 SECONDS
	var/timed_cooldown

/obj/effect/proc_holder/spell/invoked/summon_dreamfiend_curse/cast(list/targets, mob/living/user)
	if (world.time < timed_cooldown)
		to_chat(user, span_warning("你必须先重新积蓄力量，才能准备好直面自己的梦魇！"))
		to_chat(user, span_warning("剩余时间：[max(0, timed_cooldown - world.time)/10] 秒。"))
		revert_cast()
		return FALSE
	// Summon the dreamfiend
	if(summon_dreamfiend(
		target = user,
		user = user,
		F = dreamfiend_type,
		outer_tele_radius = 6,
		inner_tele_radius = 5
	))
		// Remove the curse after summoning
		user.remove_status_effect(/datum/status_effect/debuff/dreamfiend_curse)
		user.mind.RemoveSpell(src)
		return TRUE

	to_chat(user, span_warning("附近没有可供梦魇显形的有效空间！"))
	return FALSE

/obj/effect/proc_holder/spell/invoked/resurrect/pestra
	name = "腐败复苏"
	desc = "消耗心血以复活目标。对自己施放可查看更多信息。"
	sound = 'sound/magic/slimesquish.ogg'
	required_items = list(
		/obj/item/heart_blood_canister/filled = 1,
		/obj/item/heart_blood_vial/filled = 2
	)
	alt_required_items = list(
		/obj/item/heart_blood_vial/filled = 2
	)
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "resurrect"

/obj/effect/proc_holder/spell/invoked/resurrect/eora
	//Does heartfelt even exist?
	name = "暖心复苏"
	desc = "付出代价复活目标，对自己施放可查看条件。<br>目标会在一段时间内更容易感到饥饿。"
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast = 5
	)
	alt_required_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1
	)
	debuff_type = /datum/status_effect/debuff/metabolic_acceleration
	sound = 'sound/magic/heartbeat.ogg'
	overlay_state = "eora_revive"

/atom/movable/screen/alert/status_effect/nutrition_drain
	name = "代谢加速"
	desc = "你的身体正以加快的速度燃烧能量！"
	icon_state = "nutrition_drain"

/datum/status_effect/debuff/metabolic_acceleration
	id = "metabolic_accel"
	alert_type = /atom/movable/screen/alert/status_effect/nutrition_drain
	tick_interval = 1 MINUTES
	duration = 15 MINUTES

/datum/status_effect/debuff/metabolic_acceleration/tick()
	if(!owner || owner.stat == DEAD)
		qdel(src)
		return

	if(HAS_TRAIT(owner, TRAIT_NOHUNGER))
		// For those without hunger, drain blood instead. CONSEQUENCES FOR MY TRAIT CHOICES?!
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			H.blood_volume = max(H.blood_volume - 100, BLOOD_VOLUME_SURVIVE)
	else
		// For normal humans, drain nutrition
		owner.adjust_nutrition(-100)

/datum/status_effect/debuff/metabolic_acceleration/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_CON = -5
	)

	return ..()

/obj/effect/proc_holder/spell/invoked/resurrect/xylix
	//Cheap, but wildly unpretictable with possibly far worse effects than other methods.
	name = "复苏？"
	desc = "也许能复活目标？会随机赋予其其他复苏方式的负面效果，并有小概率变得更糟或稍好。"
	debuff_type = /datum/status_effect/debuff/random_revival
	alt_required_items = list(
		/obj/item/clothing/neck/roguetown/psicross/wood = 1
	)

/datum/status_effect/debuff/random_revival
	id = "random_revival_debuff"
	duration = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/random_revival

/datum/status_effect/debuff/random_revival/on_apply()
	. = ..()
	// 10% chance for special teleport effect
	if(prob(10))
		apply_teleport_effect()
	else
		// 90% chance for normal debuff
		apply_random_debuff()
		if(prob(33))
			apply_random_debuff()
		if(prob(20))
			apply_random_debuff()

	return TRUE

/datum/status_effect/debuff/random_revival/proc/apply_random_debuff()
	var/static/list/possible_debuffs = list(
		/datum/status_effect/debuff/revived,
		/datum/status_effect/debuff/dreamfiend_curse,
		/datum/status_effect/debuff/metabolic_acceleration,
		/datum/status_effect/debuff/malum_revival,
		/datum/status_effect/debuff/ravox_revival,
		/datum/status_effect/debuff/dendor_revival,
		/datum/status_effect/debuff/noc_revival,
	)
	var/debuff_type = pick(possible_debuffs)
	owner.apply_status_effect(debuff_type)

/datum/status_effect/debuff/random_revival/proc/apply_teleport_effect()
	var/area/target_area = locate(/area/rogue/indoors/town/manor) in GLOB.sortedAreas
	if(!target_area)
		apply_random_debuff() // Fallback if manor doesn't exist
		return

	// Find valid turf in manor
	var/turf/target_turf
	var/attempts = 0
	var/max_attempts = 5

	while(attempts < max_attempts && !target_turf)
		attempts++

		// Get all turfs in manor area
		var/list/area_turfs = get_area_turfs(target_area.type)
		if(!length(area_turfs))
			break

		var/list/valid_turfs = list()
		for(var/turf/T in area_turfs)
			if(T.density)
				continue
			if(istransparentturf(T))
				continue
			if(T.teleport_restricted)
				continue
			valid_turfs += T

		if(length(valid_turfs))
			target_turf = pick(valid_turfs)

	if(target_turf)
		// Unequip everything before teleporting
		owner.unequip_everything()

		// Teleport to manor
		owner.forceMove(target_turf)
		to_chat(owner, span_userdanger("你在一处陌生之地醒来，身上所有物品都已被剥空！"))
		owner.Jitter(30)
	else
		// Fallback to random debuff if no valid turf found
		apply_random_debuff()

/atom/movable/screen/alert/status_effect/random_revival
	name = "诡异后遗症"
	desc = "这次复苏给你留下了意想不到的后果……"

//Dendor, Malum, Ravox, Noc
//Fairly generic for now, I might give these more unique effects later!
/datum/status_effect/debuff/malum_revival
	id = "malum_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/malum_revival

/datum/status_effect/debuff/malum_revival/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_WIL = -5,
		STATKEY_STR = -2
	)
	return ..()

/atom/movable/screen/alert/status_effect/malum_revival
	name = "Malum 之担"
	desc = "你的身体沉重无比，恢复起来也格外缓慢。"
	icon_state = "malum_burden"

/datum/status_effect/debuff/ravox_revival
	id = "ravox_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/ravox_revival

/datum/status_effect/debuff/ravox_revival/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_STR = -5,
		STATKEY_SPD = -2
	)
	return ..()

/atom/movable/screen/alert/status_effect/ravox_revival
	name = "Ravox 之衰"
	desc = "你的肌肉绵软无力，动作也变得迟缓。"
	icon_state = "ravox_weakness"

/datum/status_effect/debuff/dendor_revival
	id = "dendor_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/dendor_revival

/datum/status_effect/debuff/dendor_revival/on_creation(mob/living/new_owner)
	effectedstats = list(
		STATKEY_SPD = -5,
		STATKEY_CON = -2
	)
	return ..()

/atom/movable/screen/alert/status_effect/dendor_revival
	name = "Dendor 之缓"
	desc = "你的动作仿佛被无形根须缠住，身体也变得脆弱不堪。"
	icon_state = "dendor_sluggish"

/datum/status_effect/debuff/noc_revival
	id = "noc_revival"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/noc_revival
	tick_interval = 10 SECONDS
	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/status_effect/debuff/noc_revival/on_creation(mob/living/new_owner)
	effectedstats = list(STATKEY_INT = -5)
	return ..()

/datum/status_effect/debuff/noc_revival/tick()
	// Check if outside at night
	if(istype(get_area(owner), /area/rogue/outdoors) && (GLOB.tod == "night"))
		if(prob(15))
			to_chat(owner, span_danger("月光正在灼烧你的血肉！"))
			owner.adjustFireLoss(15)
			if(iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/list/valid_parts = list()

				for(var/obj/item/bodypart/BP in C.bodyparts)
					var/BP_name = BP.name
					if(!BP_name) BP_name = "未命名部位" // Fallback

					var/bool_can_bloody_wound = BP.can_bloody_wound()
					var/bool_in_zone = (BP.body_zone in valid_body_zones)
					var/bool_combined_condition = (bool_in_zone && bool_can_bloody_wound)

					if(bool_combined_condition) //Idk but it works like this.
						valid_parts += BP

				if(length(valid_parts))
					var/obj/item/bodypart/BP = pick(valid_parts)
					BP.add_wound(/datum/wound/nocburn, FALSE, "看起来像被灼伤了。")

/datum/wound/nocburn
	name = "灼烧伤"
	whp = 15
	sewn_whp = 5
	bleed_rate = 0
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.05
	sew_threshold = 25
	mob_overlay = "cut"
	can_sew = TRUE
	//It's.. a burn..
	can_cauterize = FALSE

/atom/movable/screen/alert/status_effect/noc_revival
	name = "Noc 的月照诅咒"
	desc = "你的思绪一片昏沉，而月光会灼伤你的皮肤。"
	icon_state = "noc_curse"

/obj/effect/proc_holder/spell/invoked/resurrect/malum
	name = "勤勉复苏"
	desc = "付出代价复活目标，对自己施放可查看条件。<br>目标的意志与力量会在一段时间内被削弱。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "resurrect"
	required_items = list(
		/obj/item/ingot/iron = 3
	)
	alt_required_items = list(
		/obj/item/ingot/copper = 1
	)
	debuff_type = /datum/status_effect/debuff/malum_revival
	sound = 'sound/magic/clang.ogg'

/obj/effect/proc_holder/spell/invoked/resurrect/ravox
	name = "公正复苏"
	desc = "付出代价复活目标，对自己施放可查看条件。<br>目标的力量与速度会在一段时间内被削弱。"
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "resurrect"
	// The items here are somewhat hard to pick as it still has to be something a ravox acolyte would reasonably obtain.
	// Bones insinuate that mayhaps, they went out there to delete some skeletons for justice?
	required_items = list(
		/obj/item/natural/bone = 10
	)
	alt_required_items = list(
		/obj/item/natural/bone = 7
	)
	debuff_type = /datum/status_effect/debuff/ravox_revival

/obj/effect/proc_holder/spell/invoked/resurrect/dendor
	name = "荒野复苏"
	desc = "付出代价复活目标，对自己施放可查看条件。<br>需要附近有一棵智者之树或受圣化的树木。目标的速度与体魄会在一段时间内被削弱。"
	//Herbs that have to do with intelligence mostly. Easier to remember.
	required_items = list(
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 3,
		/obj/item/alch/mentha = 3,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 3
	)
	alt_required_items = list(
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 3,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1
	)
	debuff_type = /datum/status_effect/debuff/dendor_revival
	required_structure = /obj/structure/flora/roguetree/wise
	sound = 'sound/magic/birdsong.ogg'

// Wild Revival can also revive simple animal mobs (no debuff applied, full heal).
/obj/effect/proc_holder/spell/invoked/resurrect/dendor/cast(list/targets, mob/living/user)
	if(!isanimal(targets[1]))
		return ..()
	var/mob/living/simple_animal/target = targets[1]
	if(target.stat != DEAD)
		to_chat(user, span_warning("[target] 还没有死。"))
		revert_cast()
		return FALSE
	var/validation_result = validate_items(target)
	if(validation_result != "")
		to_chat(user, span_warning("[validation_result]，物品必须放在 [target] 身旁或其所在位置。"))
		revert_cast()
		return FALSE
	var/found_structure = FALSE
	for(var/atom/A in oview(structure_range, target))
		if(istype(A, required_structure))
			found_structure = TRUE
			break
		if(istype(A, /turf))
			var/turf/T = A
			for(var/obj/O in T.contents)
				if(istype(O, required_structure))
					found_structure = TRUE
					break
		if(found_structure)
			break
	if(!found_structure)
		var/atom/temp_structure = required_structure
		to_chat(user, span_warning("我需要在 [target] 附近放置一座 [initial(temp_structure.name)]。"))
		revert_cast()
		return FALSE
	if(!target.revive(full_heal = TRUE))
		to_chat(user, span_warning("什么也没有发生。"))
		revert_cast()
		return FALSE
	target.visible_message(span_notice("[target] 被荒野魔力重新唤醒了！"))
	consume_items(target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/noc
	name = "月照复苏"
	desc = "付出代价复活目标，对自己施放可查看条件。<br>目标的智力会在一段时间内被削弱，此外还会被月光灼伤。"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "resurrect"
	required_items = list(
		/obj/item/paper/scroll = 6
	)
	alt_required_items = list(
		/obj/item/paper = 10
	)
	debuff_type = /datum/status_effect/debuff/noc_revival
	sound = 'sound/magic/owlhoot.ogg'
