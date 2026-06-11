// Diagnose
/obj/effect/proc_holder/spell/invoked/diagnose
	name = "诊察"
	desc = "检查他人的生命体征。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "diagnose"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS //very stupidly simple spell
	miracle = TRUE
	devotion_cost = 0 //come on, this is very basic

/obj/effect/proc_holder/spell/invoked/diagnose/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/human_target = targets[1]
		human_target.check_for_injuries(user)

		if (human_target.reagents.has_reagent(/datum/reagent/infection/major))
			to_chat(user, span_boldwarning("黑黄相间的条纹无疑表明忧郁液过盛。"))
		else if (human_target.reagents.has_reagent(/datum/reagent/infection))
			to_chat(user, span_warning("皮肉发红发炎，额头汗斑点点。或许是黄胆液过盛？"))
		else if (human_target.reagents.has_reagent(/datum/reagent/infection/minor))
			to_chat(user, span_warning("轻微泛黄表明胆液失衡才刚刚显露端倪。"))

		//To tell thresholds of toxins in the system, here so people don't have info of their own toxins outside of diagnosis method
		switch(human_target.toxloss)
			if(0 to 1)
				to_chat(user, span_notice("体内没有中毒迹象。"))
			if(1 to 50)
				to_chat(user, span_notice("仔细查看后能发现些许中毒痕迹。"))
			if(50 to 100)
				to_chat(user, span_notice("已经能看到明显的中毒症状。"))
			if(100 to 150)
				to_chat(user, span_warning("这具身体正被毒素折磨。"))
			if(150 to INFINITY)
				to_chat(user, span_necrosis("这具身体已被毒素彻底摧残。"))
		
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/diagnose/secular
	name = "世俗诊察"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "diagnose"
	range = 1
	associated_skill = /datum/skill/misc/medicine
	miracle = FALSE
	devotion_cost = 0 //Doctors are not clerics

/obj/effect/proc_holder/spell/invoked/attach_bodypart
	name = "肢体奇迹"
	desc = "将你或目标手中、以及目标附近的全部肢体与器官接回目标身上。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "flextape"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/gore/flesh_eat_03.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/invoked/attach_bodypart/cast(list/targets, mob/living/user)
	if(!targets || !targets.len)
		to_chat(user, span_warning("没有找到目标！"))
		revert_cast()
		return FALSE
	var/mob/living/target = targets[1]
	if(!ishuman(target))
		to_chat(user, span_warning("该法术只能对人类施展！"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/human_target = target
	var/same_owner = FALSE
	var/attached_count = 0
	if(human_target.has_status_effect(/datum/status_effect/buff/necras_vow))
		same_owner = TRUE
		to_chat(user, span_warning("此人已向 Necra 立下誓约。唯有他们自己的肢体会被接纳。"))

	// Get missing limbs first
	var/list/missing_limbs = human_target.get_missing_limbs()
	// Search for limbs in three locations: user's hands, target's hands, and nearby
	var/list/limb_locations = list()
	if(user)
		limb_locations += user.held_items
	limb_locations += human_target.held_items
	limb_locations += range(1, human_target)

	// Try to attach limbs
	for(var/location in limb_locations)
		for(var/obj/item/bodypart/limb in location)
			if(!istype(limb) || !(limb.body_zone in missing_limbs))
				continue

			// Skip if limb is already attached to someone
			if(limb.owner && limb.owner != human_target)
				continue

			// Necra vow check
			if(same_owner && limb.original_owner && limb.original_owner != human_target)
				to_chat(user, span_warning("由于 Necra 誓约的限制，肢体 [limb] 不属于目标！"))
				continue

			// Check if target already has this limb
			if(human_target.get_bodypart(limb.body_zone))
				continue

			// Try to attach the limb
			if(limb.attach_limb(human_target))
				human_target.visible_message(
					span_info("[limb] 自行接回到了 [human_target] 身上！"), 
					span_notice("[limb] 自行接回到了我身上！")
				)
				attached_count++
				to_chat(user, span_green("成功接上了 [limb]。"))
				// Remove from missing limbs so we don't try to attach another to the same slot
				missing_limbs -= limb.body_zone
			else
				to_chat(user, span_warning("未能接上 [limb]。"))

	// Now handle organs
	var/list/missing_organs = list(
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_TONGUE,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_APPENDIX,
	)

	// Remove organs that are already present
	for(var/organ_slot in missing_organs)
		if(human_target.getorganslot(organ_slot))
			missing_organs -= organ_slot

	// Search for organs in the same locations
	var/list/organ_locations = list()
	if(user)
		organ_locations += user.held_items
	organ_locations += human_target.held_items
	organ_locations += range(1, human_target)

	// Try to attach organs
	for(var/location in organ_locations)
		for(var/obj/item/organ/organ in location)
			if(!istype(organ) || !(organ.slot in missing_organs))
				continue

			// Skip if organ is already in someone
			if(organ.owner && organ.owner != human_target)
				continue

			// Necra vow check for organs
			if(same_owner && organ.owner && organ.owner != human_target)
				continue

			// Check if target already has this organ
			if(human_target.getorganslot(organ.slot))
				continue

			// Try to insert the organ
			if(organ.Insert(human_target))
				human_target.visible_message(
					span_info("[organ] 自行接回到了 [human_target] 身上！"), 
					span_notice("[organ] 自行接回到了我身上！")
				)
				attached_count++
				to_chat(user, span_green("成功接上了 [organ]。"))
				// Remove from missing organs
				missing_organs -= organ.slot
			else
				to_chat(user, span_warning("未能接上 [organ]。"))

	if(attached_count > 0)
		if(!(human_target.mob_biotypes & MOB_UNDEAD))
			for(var/obj/item/bodypart/limb in human_target.bodyparts)
				limb.rotted = FALSE
				limb.skeletonized = FALSE
		human_target.update_body()
	else
		to_chat(user, span_warning("没有任何肢体被接回。"))

	return TRUE

/obj/effect/proc_holder/spell/invoked/infestation
	name = "虫灾"
	desc = "召来虫群包围目标，啃咬并致病。感染目标会为你提供施放其他法术所需的充能。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "infestation0"
	releasedrain = 50
	chargetime = 10
	recharge_time = 20 SECONDS
	range = 8
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	devotion_cost = 50 // attack miracle
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/fliesloop
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	miracle = TRUE

	invocations = list("腐败啊，去吞噬他们！")
	invocation_type = "shout" //can be none, whisper, emote and shout
	var/datum/component/infestation_charges/charge_component


/obj/effect/proc_holder/spell/invoked/infestation/proc/ensure_charge_component(mob/living/user)
	if(!user)
		return FALSE
	var/datum/component/infestation_charges/existing_component = user.GetComponent(/datum/component/infestation_charges)
	if(existing_component)
		charge_component = existing_component
		charge_component.parent_spell = src
	else
		charge_component = user.AddComponent(/datum/component/infestation_charges, src)

	return TRUE

/obj/effect/proc_holder/spell/invoked/infestation/on_gain(mob/living/user)
	// Note: there is no logic to remove the component yet, this should be fine
	. = ..()
	if(overlay_state && !hide_charge_effect)
		var/obj/effect/R = new /obj/effect/spell_rune
		R.icon = action_icon
		R.icon_state = "infestation10"
		action.overlay_alpha = overlay_alpha
		mob_charge_effect = R
	if(user && !charge_component)
		// Sanity check
		var/datum/component/existing_component = user.GetComponent(/datum/component/infestation_charges)
		if(existing_component)
			charge_component = existing_component
			charge_component.parent_spell = src
		else
			charge_component = user.AddComponent(/datum/component/infestation_charges, src)

/obj/effect/proc_holder/spell/invoked/infestation/proc/update_charge_overlay(charge_count)
	overlay_state = "infestation[charge_count]"
	update_icon()
	action.UpdateButtonIcon(FALSE, TRUE)
	action.desc = "[desc]\n<span class='notice'>充能 = [charge_count]</span>"

/obj/effect/proc_holder/spell/invoked/infestation/cast(list/targets, mob/living/user)
	ensure_charge_component(user)
	var/atom/target = targets[1]
	if(isliving(target))
		var/mob/living/carbon/M = target
		M.visible_message(span_warning("[M] 被一团瘟疫害虫包围了！"), span_notice("你让一团瘟疫害虫笼罩了 [M]！"))
		M.apply_status_effect(/datum/status_effect/buff/infestation/) //apply debuff
		SEND_SIGNAL(src, COMSIG_INFESTATION_CHARGE_ADD, 10)
		return TRUE
	if(SSchimeric_tech.get_node_status("INFESTATION_ROT_SNACKS") && istype(target, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/snack = target
		if(snack.eat_effect == /datum/status_effect/debuff/rotfood)
			revert_cast()
			return FALSE

		var/total_charge = 5
		var/rotted_count = 1
		var/search_count = SSchimeric_tech.get_infestation_food_rot_count()
		snack.become_rotten()

		var/list/potential_snacks = range(1, snack.loc)
		var/list/valid_snacks = list()
		for(var/atom/A in potential_snacks)
			if(!istype(A, /obj/item/reagent_containers/food/snacks))
				continue
			var/obj/item/reagent_containers/food/snacks/S = A
			if(S == snack)
				continue
			if(S.eat_effect == /datum/status_effect/debuff/rotfood)
				continue
			valid_snacks += S
		for(var/obj/item/reagent_containers/food/snacks/extra_snack in valid_snacks)
			if(rotted_count >= search_count)
				break
			extra_snack.become_rotten()
			total_charge += 5
			rotted_count++
		if(rotted_count <= 1)
			snack.visible_message(span_warning("[snack] 被害虫吞没，迅速腐坏了！"))
		else
			snack.visible_message(span_warning("有些食物被害虫吞没，迅速腐坏了！"))
		SEND_SIGNAL(src, COMSIG_INFESTATION_CHARGE_ADD, total_charge)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/infestation
	id = "infestation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/infestation
	duration = 10 SECONDS
	effectedstats = list(STATKEY_CON = -2)
	var/static/mutable_appearance/rotten = mutable_appearance('icons/roguetown/mob/rotten.dmi', "rotten")

/datum/status_effect/buff/infestation/on_apply()
	. = ..()
	var/mob/living/target = owner
	to_chat(owner, span_danger("我突然被一团虫群包围了！"))
	target.Jitter(20)
	target.add_overlay(rotten)
	target.update_vision_cone()

/datum/status_effect/buff/infestation/on_remove()
	var/mob/living/target = owner
	target.cut_overlay(rotten)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/buff/infestation/tick()
	var/mob/living/target = owner
	var/mob/living/carbon/M = target
	target.adjustToxLoss(2)
	target.adjustBruteLoss(1)
	var/prompt = pick(1,2,3)
	var/message = pick(
		"皮肤上的蜱虫开始吸饱鲜血，鼓胀起来了！",
		"苍蝇正在我敞开的伤口里产卵！",
		"有什么东西钻进了我的耳朵！",
		"虫子多得根本数不过来！",
		"它们正拼命往我的皮肤底下钻！",
		"快让这一切停下！",
		"蜈蚣的足肢正搔着我的耳后！",
		"火蚁正狠狠啃咬着我的双脚！",
		"鼻头挨了一记黄蜂蜇刺！",
		"蟑螂正从我的脖颈上窸窣爬过！",
		"蛆虫正黏腻地在我身上蠕动！",
		"甲虫正从我的嘴边爬过！",
		"跳蚤正在咬我的脚踝！",
		"小蚋在我脸边嗡嗡乱飞！",
		"虱子正在吸我的血！",
		"蟋蟀在我耳边唧唧作响！",
		"蠼螋正往我的耳道里钻！")
	if(prompt == 1 && iscarbon(M))
		M.add_nausea(pick(10,20))
		to_chat(target, span_warning(message))

/atom/movable/screen/alert/status_effect/buff/infestation
	name = "虫灾"
	desc = "有毒的害虫正啃咬撕扯我的皮肤。"
	icon_state = "debuff"

// Cure rot
/obj/effect/proc_holder/spell/invoked/cure_rot
	name = "祛腐"
	desc = "借助 Psycross 呼唤 Pestra 的意志，驱逐他人身上的腐坏，或令其血肉重生。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "rot"
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
	recharge_time = 3 MINUTES
	miracle = TRUE
	devotion_cost = 200
	/// Amount of PQ gained for curing zombos
	var/unzombification_pq = PQ_GAIN_UNZOMBIFY
	var/is_lethal = FALSE

/obj/effect/proc_holder/spell/invoked/cure_rot/priest
	desc = "借 Astrata 之意焚尽腐坏。"
	is_lethal = FALSE
	recharge_time = 2 MINUTES
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/cure_rot/cast(list/targets, mob/living/user)
	var/stinky = FALSE
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]

		var/obj/item/black_rose/rose = user.get_active_held_item()
		// Check if the user is holding a black rose and the target follows Pestra.
		if(istype(rose) && target.patron?.type == /datum/patron/divine/pestra)
			// If the target is a Pestran and we are holding the rose, implant the component.
			if(!target.GetComponent(/datum/component/infestation_black_rot))
				target.AddComponent(/datum/component/infestation_black_rot)
				ADD_TRAIT(target, TRAIT_PESTRAS_BLESSING, TRAIT_MIRACLE)
				target.visible_message(span_notice("[user] 轻轻将 [rose] 按在 [target] 的血肉上。玫瑰随即溶解，只留下一道黑印。"), \
										span_userdanger("玫瑰与我的血肉融为一体，赋予了我受 Pestra 庇护的印记。"))
				qdel(rose)
				return TRUE
			else
				to_chat(user, span_warning("[target] 早已受过 Pestra 的黑色祝福。"))
				revert_cast()
				return FALSE

		if(GLOB.tod == "night")
			to_chat(user, span_warning("让此地见光。"))
		for(var/obj/structure/fluff/psycross/S in oview(5, user))
			S.AOE_flash(user, range = 8)

		var/datum/antagonist/zombie/was_zombie = target.mind?.has_antag_datum(/datum/antagonist/zombie)
		if(target.stat == DEAD || was_zombie)	//Checks if the target is a dead rotted corpse.
			var/datum/component/rot/rot = target.GetComponent(/datum/component/rot)
			if(rot && rot.amount && rot.amount >= 5 MINUTES)	//Fail-safe to make sure the dead person has at least rotted for ~5 min.
				stinky = TRUE

		if(remove_rot(target = target, user = user, method = "prayer",
			success_message = "腐坏离开了 [target] 的身体！",
			fail_message = "什么也没有发生。", lethal = is_lethal))
			target.visible_message(span_notice("腐坏离开了 [target] 的身体！"), span_green("我感到腐坏正离开我的身体！"))
			target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it.
			if(stinky)
				target.apply_status_effect(/datum/status_effect/debuff/rotted)	//Perma debuff, needs cure
			return TRUE
		else //Attempt failed, no rot
			target.visible_message(span_warning("腐坏未能离开 [target] 的身体！"), span_warning("我没有感觉到任何变化……"))
			return FALSE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/cure_rot/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("我需要一枚圣十字。"))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/pestra_leech
	name = "水蛭净除"
	desc = "在目标体内催生水蛭，让其呕出，以恢复部分血量并解除轻度中毒。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "leech"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/gore/flesh_eat_03.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/pestra_leech/cast(list/targets, mob/living/user)
	if(iscarbon(targets[1]))
		var/mob/living/carbon/C = targets[1]
		if(C.cmode)
			to_chat(user, span_warning("他们绷得太紧，不适合这等细致手段！"))
			revert_cast()
			return FALSE
		C.vomit()
		C.adjustToxLoss(-30)
		if(C.blood_volume < BLOOD_VOLUME_NORMAL)
			C.blood_volume = min(C.blood_volume+30, BLOOD_VOLUME_NORMAL)
		C.visible_message(span_warning("[C] 呕出了几条水蛭！"), span_warning("我体内有什么东西在翻腾！"))
		new /obj/item/natural/worms/leech(get_turf(C))
		if(prob( (user.get_skill_level(/datum/skill/magic/holy) * 10) ))
			new /obj/item/natural/worms/leech(get_turf(C))
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/pestra_heal
	name = "重育"
	desc = "强力治疗，对受重度腐坏影响者更有效。施放需要虫灾充能。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "heal"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0.6 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocations = list("Pestra，让他们重获新生！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	// Greater heal, but requires a resource to cast.
	devotion_cost = 45
	var/datum/component/infestation_charges/charge_component

/obj/effect/proc_holder/spell/invoked/pestra_heal/cast_check(skipcharge = 0, mob/user = usr)
	if(!..())
		return FALSE
	if(!charge_component)
		charge_component = user.GetComponent(/datum/component/infestation_charges)
	// Check again just in case the component got deleted somehow!
	if(!charge_component || charge_component.get_charges() < 1)
		to_chat(user, span_warning("我至少需要一层虫灾充能才能施放这个法术！"))
		update_charges(0)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/pestra_heal/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/charge_count
		if(!charge_component)
			to_chat(user, span_warning("糟了，虫灾组件似乎不知怎么丢了……请提交错误反馈！"))
			revert_cast()
			return FALSE
		charge_count = charge_component.get_charges()
		if(charge_count < 1)
			to_chat(user, span_warning("我至少需要一层虫灾充能才能施放这个法术！"))
			update_charges(charge_count)
			revert_cast()
			return FALSE
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] 微微动了一下，但奇迹随即消散。"), span_notice("一股迟钝的暖意在你心口升起，却又如来时般迅速消退。"))
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		// Keep in mind this is 7.5 per tick with fortify!
		// Double the power of miracle
		var/healing = 5
		target.visible_message(span_info("窸窣作响的幽灵虫群包裹了 [target]！"), span_notice("缥缈的虫群正用口器将我的血肉重新缝合！"))
		target.apply_status_effect(/datum/status_effect/buff/healing, healing)
		// 225 healing but slowly released across 10 minutes, can't be refreshed.
		target.apply_status_effect(/datum/status_effect/buff/pestra_care)
		remove_infestation_charges(user, 10)
		// We just reduced it by 1 so we can assume that we might not have enough charges to cast again.
		update_charges(charge_count - 1)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/pestra_heal/proc/update_charges(charge_count)
	if(charge_count > 0)
		overlay_state = "heal"
	else
		overlay_state = "heal_disabled"
	update_icon()
	if(action)
		action.UpdateButtonIcon(FALSE, TRUE)

/obj/effect/proc_holder/spell/invoked/divine_rebirth
	name = "神圣重育"
	desc = "奇迹般的治疗，甚至能恢复最严重的伤势与缺失肢体。但必须在虫灾充能达到上限时才能施放。没有任何力量能抗拒这道奇迹。"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "heal_ascended"
	releasedrain = 50
	chargedrain = 0
	chargetime = 2 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/ahh2.ogg'
	invocations = list("虫群之母啊，吞噬并涤净一切吧！！！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	// Doesn't matter in the slightest, as the cooldown of this is handled by the component, not the spell.
	recharge_time = 999 MINUTES
	miracle = TRUE
	devotion_cost = 250
	chargedloop = /datum/looping_sound/invokeholy

// Given this is Pestra's true T4 spell, and it is limited in availability and gated heavily behind tech, this heal does affect Psydonites.
// You can't resist Pestra's most divine gift.
/obj/effect/proc_holder/spell/invoked/divine_rebirth/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message(span_info("一只缠满菌菇的虚幻手臂轻抚着 [target]！"), span_notice("我感到一阵关怀的抚触！"))
		target.apply_status_effect(/datum/status_effect/buff/divine_rebirth_healing)
		SEND_SIGNAL(user, COMSIG_DIVINE_REBIRTH_CAST, target)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/pestilent_blade
	name = "疫刃附魔"
	desc = "以 Pestra 的力量附魔你的刀刃，消耗一层虫灾充能，使你对已感染目标的下一击更具威力。若目标未感染，效果微乎其微……"
	overlay_icon = 'icons/mob/actions/pestramiracles.dmi'
	action_icon = 'icons/mob/actions/pestramiracles.dmi'
	overlay_state = "blade"
	releasedrain = 20
	chargedrain = 0
	chargetime = 1 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	range = 1 // Self-target
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/slimesquish.ogg'
	invocations = list("Pestra，赐福此刃！")
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 25
	var/datum/component/infestation_charges/charge_component

/obj/effect/proc_holder/spell/invoked/pestilent_blade/cast_check(skipcharge = 0, mob/user = usr)
	if(!..())
		return FALSE

	if(!charge_component)
		charge_component = user.GetComponent(/datum/component/infestation_charges)

	if(!charge_component || charge_component.get_charges() < 1)
		to_chat(user, span_warning("我至少需要一层虫灾充能才能为刀刃附魔！"))
		return FALSE

	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item || !isitem(held_item))
		to_chat(user, span_warning("我得手持武器才能进行附魔！"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/pestilent_blade/cast(list/targets, mob/living/user)
	var/obj/item/weapon = user.get_active_held_item()
	if(!weapon || !isitem(weapon))
		to_chat(user, span_warning("我必须手持武器才能为其附魔！"))
		revert_cast()
		return FALSE

	if(!charge_component || charge_component.get_charges() < 1)
		to_chat(user, span_warning("虫灾充能已经耗尽！"))
		revert_cast()
		return FALSE

	if(weapon.AddComponent(/datum/component/pestilent_blade_enchant))
		remove_infestation_charges(user, 10)
		to_chat(user, span_infection("我感到瘟疫之力流入了我的 [weapon.name]！"))
		weapon.visible_message(span_infection("[weapon] 泛起病态的绿光！"))
		return TRUE

	revert_cast()
	return FALSE
