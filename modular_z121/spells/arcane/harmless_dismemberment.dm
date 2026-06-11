/atom/movable/screen/alert/status_effect/buff/harmless_dismemberment
	name = "无害肢解"
	desc = "我的肉身像一件被温柔拆开的旧衣。断口不流血，不呼痛，只在等待被放回原处。"
	icon_state = "buff"

/mob/living/carbon/human
	var/obj/item/bodypart/head/harmless_live_head_source
	var/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/harmless_dismemberment_selector_spell

/mob/living/carbon/human/proc/get_harmless_live_head_source()
	if(QDELETED(harmless_live_head_source))
		harmless_live_head_source = null
		return null
	if(!harmless_live_head_source?.harmless_live_head)
		harmless_live_head_source = null
		return null
	if(harmless_live_head_source.harmless_live_owner != src)
		harmless_live_head_source = null
		return null
	return harmless_live_head_source

/mob/living/carbon/human/GetSource()
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	if(live_head)
		return live_head
	return ..()

/mob/living/carbon/human/GetVoice()
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	if(live_head)
		return "[real_name]的头颅"
	return ..()

/mob/living/carbon/human/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language = null, message_mode, original_message)
	var/obj/item/bodypart/head/live_head = get_harmless_live_head_source()
	if(live_head)
		source = live_head
	return ..()

/obj/item/bodypart/head
	var/harmless_live_head = FALSE
	var/mob/living/carbon/human/harmless_live_owner

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	if(harmless_live_head && harmless_live_owner)
		. += span_notice("这颗头还活着。它的眼神并未熄灭，仿佛正隔着自己的眼窝向外张望。")
		if(harmless_live_owner.client?.eye == src)
			. += span_notice("你有一种怪异的感觉: 它此刻正借由这颗头注视着你。")

/obj/item/bodypart/head/Destroy()
	disable_harmless_live_head()
	return ..()

/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
	// Preserve the base head-specific reattachment behavior, then clear our temporary live-head state.
	if(brain)
		if(brainmob)
			brainmob.forceMove(brain)
			brain.brainmob = brainmob
			brainmob = null
		brain.Insert(C)
		brain = null

	if(tongue)
		tongue = null
	if(ears)
		ears = null
	if(eyes)
		eyes = null

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.hair_color = hair_color
		H.hairstyle = hairstyle
		H.facial_hair_color = facial_hair_color
		H.facial_hairstyle = facial_hairstyle
		H.lip_style = lip_style
		H.lip_color = lip_color
	if(real_name)
		C.real_name = real_name
	real_name = ""
	name = initial(name)

	var/success = ..()
	if(success)
		disable_harmless_live_head()
	return success

/obj/item/bodypart/head/attackby(obj/item/I, mob/user, params)
	if(harmless_live_head && harmless_live_owner && istype(I, /obj/item/reagent_containers/food/) && ishuman(user))
		I.attack(harmless_live_owner, user)
		return
	return ..()

/obj/item/bodypart/head/say_mod(input, message_mode)
	if(harmless_live_head)
		if(message_mode == MODE_WHISPER || message_mode == MODE_WHISPER_CRIT)
			return "低低呢喃"
		if(copytext(input, length(input) - 1) == "!!")
			return "猛然尖啸"
		var/ending = copytext(input, length(input))
		if(ending == "?")
			return "幽幽发问"
		if(ending == "!")
			return "突兀惊呼"
		return "轻声开口"
	return ..()

/obj/item/bodypart/head/proc/enable_harmless_live_head(mob/living/carbon/human/head_owner)
	if(!istype(head_owner))
		return
	harmless_live_head = TRUE
	harmless_live_owner = head_owner
	head_owner.harmless_live_head_source = src
	desc = "这颗头被一层不肯散去的古怪魔力维系着。它仍在呼吸，仍在倾听，也仍在看。"
	head_owner.reset_perspective(src)
	to_chat(head_owner, span_notice("我的视野猛然一沉，随后竟从自己被捧起的头颅里重新睁开了眼。"))

/obj/item/bodypart/head/proc/disable_harmless_live_head()
	if(!harmless_live_head)
		return
	if(harmless_live_owner?.client?.eye == src)
		harmless_live_owner.reset_perspective()
	if(harmless_live_owner?.harmless_live_head_source == src)
		harmless_live_owner.harmless_live_head_source = null
	harmless_live_head = FALSE
	harmless_live_owner = null
	desc = initial(desc)

/datum/status_effect/buff/harmless_dismemberment
	id = "harmless_dismemberment"
	alert_type = /atom/movable/screen/alert/status_effect/buff/harmless_dismemberment
	duration = 1 MINUTES
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	var/list/monitored_bodyparts = list()
	var/list/reattach_candidate_since = list()
	var/list/reattach_glow_announced = list()
	var/mob/living/carbon/human/controller
	var/datum/mind/controller_mind
	var/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/selector_spell

/datum/status_effect/buff/harmless_dismemberment/on_creation(mob/living/new_owner, new_duration = null, mob/living/new_controller = null)
	if(new_duration)
		duration = new_duration
	if(ishuman(new_controller))
		controller = new_controller
		controller_mind = new_controller.mind
	return ..()

/datum/status_effect/buff/harmless_dismemberment/on_apply()
	. = ..()
	if(!. || !iscarbon(owner))
		return FALSE

	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, id)
	ADD_TRAIT(owner, TRAIT_NOBREATH, id)
	refresh_monitored_bodyparts()
	ensure_selector_spell()
	to_chat(owner, span_notice("一道潮湿而温柔得令人不安的魔力覆上了我的身体。现在，只要切口平整迅速，我的血肉便会像本就该分开那样安静裂离。"))
	return TRUE

/datum/status_effect/buff/harmless_dismemberment/on_remove()
	var/mob/living/carbon/carbon_owner = owner
	unregister_monitored_bodyparts()
	reattach_candidate_since = list()
	reattach_glow_announced = list()
	remove_selector_spell()
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, id)
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, id)
	. = ..()

	if(!istype(carbon_owner))
		return

	if(!carbon_owner.get_bodypart(BODY_ZONE_HEAD))
		if(ishuman(carbon_owner))
			var/mob/living/carbon/human/human_owner = carbon_owner
			var/obj/item/bodypart/head/live_head = human_owner.get_harmless_live_head_source()
			live_head?.disable_harmless_live_head()
		carbon_owner.visible_message(
			span_danger("[carbon_owner] 身上的诡异缝合魔法忽然褪去，失去归处的性命也随之倏然断绝！"),
			span_userdanger("维系我头身分离的那层温柔恶意终于散了。没能归位的头颅，也把我的命一起带走了。")
		)
		carbon_owner.death()
		return

	var/list/missing_limbs = carbon_owner.get_missing_limbs()
	if(length(missing_limbs))
		to_chat(carbon_owner, span_warning("断口上的柔和魔力已经消失。那些还未来得及归位的部件，从此便不再属于我。"))
	else
		to_chat(carbon_owner, span_notice("覆在断口上的古怪柔光渐渐退去，我的身体终于又像一个完整的人了。"))

/datum/status_effect/buff/harmless_dismemberment/tick()
	refresh_monitored_bodyparts()
	try_reattach_nearby_bodyparts()

/datum/status_effect/buff/harmless_dismemberment/refresh(mob/living/new_owner, new_duration = null, mob/living/new_controller = null)
	if(new_duration)
		duration = world.time + new_duration
	else
		..()
	if(ishuman(new_controller))
		set_controller(new_controller)
	else if(controller)
		ensure_selector_spell()

/datum/status_effect/buff/harmless_dismemberment/proc/set_controller(mob/living/carbon/human/new_controller)
	if(controller == new_controller && controller_mind == new_controller?.mind)
		ensure_selector_spell()
		return
	remove_selector_spell()
	controller = new_controller
	controller_mind = new_controller?.mind
	ensure_selector_spell()

/datum/status_effect/buff/harmless_dismemberment/proc/can_be_manipulated_by(mob/living/user)
	if(!istype(user) || !istype(controller))
		return FALSE
	if(user != controller)
		return FALSE
	if(user.mind != controller_mind)
		return FALSE
	return TRUE

/datum/status_effect/buff/harmless_dismemberment/proc/ensure_selector_spell()
	if(!controller_mind || !controller)
		return
	if(QDELETED(selector_spell))
		selector_spell = null
	if(!selector_spell)
		selector_spell = new /obj/effect/proc_holder/spell/self/harmless_dismemberment_select
		controller_mind.AddSpell(selector_spell, controller)
	controller.harmless_dismemberment_selector_spell = selector_spell
	selector_spell.linked_target = owner
	selector_spell.linked_effect = src

/datum/status_effect/buff/harmless_dismemberment/proc/remove_selector_spell()
	if(controller?.harmless_dismemberment_selector_spell == selector_spell)
		controller.harmless_dismemberment_selector_spell = null
	if(selector_spell)
		if(controller_mind)
			controller_mind.RemoveSpell(selector_spell)
		else
			qdel(selector_spell)
	selector_spell = null
	controller = null
	controller_mind = null

/datum/status_effect/buff/harmless_dismemberment/proc/refresh_monitored_bodyparts()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/carbon_owner = owner
	var/list/current_bodyparts = list()
	for(var/obj/item/bodypart/bodypart as anything in carbon_owner.bodyparts)
		if(bodypart.body_zone == BODY_ZONE_CHEST)
			continue
		current_bodyparts += bodypart
		if(!(bodypart in monitored_bodyparts))
			RegisterSignal(bodypart, COMSIG_MOB_DISMEMBER, PROC_REF(handle_harmless_dismember))

	for(var/obj/item/bodypart/bodypart as anything in monitored_bodyparts)
		if(QDELETED(bodypart) || !(bodypart in current_bodyparts))
			UnregisterSignal(bodypart, COMSIG_MOB_DISMEMBER)

	monitored_bodyparts = current_bodyparts

/datum/status_effect/buff/harmless_dismemberment/proc/unregister_monitored_bodyparts()
	for(var/obj/item/bodypart/bodypart as anything in monitored_bodyparts)
		if(QDELETED(bodypart))
			continue
		UnregisterSignal(bodypart, COMSIG_MOB_DISMEMBER)
	monitored_bodyparts = list()

/datum/status_effect/buff/harmless_dismemberment/proc/handle_harmless_dismember(obj/item/bodypart/source, obj/item/bodypart/bodypart)
	SIGNAL_HANDLER

	var/obj/item/bodypart/target_bodypart = bodypart
	if(!istype(target_bodypart))
		target_bodypart = source
	if(!istype(target_bodypart) || target_bodypart.owner != owner)
		return NONE
	if(!separate_bodypart(target_bodypart))
		return NONE
	return COMPONENT_CANCEL_DISMEMBER

/datum/status_effect/buff/harmless_dismemberment/proc/separate_bodypart(obj/item/bodypart/bodypart)
	if(!istype(bodypart) || !iscarbon(owner) || bodypart.owner != owner)
		return FALSE
	if(bodypart.body_zone == BODY_ZONE_CHEST)
		return FALSE

	var/mob/living/carbon/carbon_owner = owner
	var/is_head = bodypart.body_zone == BODY_ZONE_HEAD
	var/atom/drop_spot = carbon_owner.drop_location()

	if(!bodypart.drop_limb(TRUE))
		return FALSE
	if(QDELETED(bodypart))
		return TRUE

	if(drop_spot)
		bodypart.forceMove(drop_spot)
	reattach_candidate_since -= bodypart
	reattach_glow_announced -= bodypart
	if(get_dist(bodypart, carbon_owner) <= 1)
		reattach_candidate_since[bodypart] = world.time

	if(is_head)
		if(ishuman(carbon_owner))
			var/mob/living/carbon/human/human_owner = carbon_owner
			var/obj/item/bodypart/head/head = bodypart
			head.enable_harmless_live_head(human_owner)
		carbon_owner.visible_message(
			span_notice("[carbon_owner] 的头颅在一层近乎慈悲的魔力包裹下平整地离开了身体，却连一滴血也没有舍得流出来。"),
			span_notice("我的头颅在法术托举下与身体平整分离，可我的意识仍牢牢系在这颗被捧起的头里。")
		)
	else
		carbon_owner.visible_message(
			span_notice("[carbon_owner] 的[bodypart.name]在柔和得令人发寒的魔力中平整地与身体分离开来，像只是被轻轻拆下。"),
			span_notice("我的[bodypart.name]在法术的托扶下平整地离开了身体，却没有带来半点痛楚，只有一种古怪的空落感。")
		)

	return TRUE

/datum/status_effect/buff/harmless_dismemberment/proc/try_reattach_nearby_bodyparts()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/list/current_candidates = list()
	for(var/obj/item/bodypart/limb in range(1, human_owner))
		if(!can_reattach_bodypart(human_owner, limb))
			continue
		if(!isturf(limb.loc))
			continue
		current_candidates += limb
		var/started_waiting = reattach_candidate_since[limb]
		if(!isnum(started_waiting))
			reattach_candidate_since[limb] = world.time
			continue
		if(world.time - started_waiting >= 3 SECONDS && !(limb in reattach_glow_announced))
			reattach_glow_announced += limb
			limb.visible_message(
				span_info("[limb] 静静落在地上，断口边缘渐渐浮现出一缕微弱而温柔的牵引光。"),
				null
			)
		if(world.time - started_waiting < 5 SECONDS)
			continue
		if(!limb.attach_limb(human_owner, TRUE))
			continue
		reattach_candidate_since -= limb
		reattach_glow_announced -= limb

		human_owner.visible_message(
			span_notice("[limb] 被无形的牵引轻轻拽回了 [human_owner] 的断口，像一块终于寻回原位的骨肉。"),
			span_notice("[limb] 在我的断口附近落地停留片刻后，终于在那股古怪而温柔的牵引下愈合接回。")
		)

	for(var/obj/item/bodypart/limb as anything in reattach_candidate_since)
		if(QDELETED(limb) || !(limb in current_candidates))
			reattach_candidate_since -= limb
			reattach_glow_announced -= limb

/datum/status_effect/buff/harmless_dismemberment/proc/can_reattach_bodypart(mob/living/carbon/human/human_owner, obj/item/bodypart/limb)
	if(!istype(human_owner) || !istype(limb))
		return FALSE
	if(limb.owner)
		return FALSE
	if(limb.original_owner && limb.original_owner != human_owner)
		return FALSE
	if(human_owner.get_bodypart(limb.body_zone))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select
	name = "指定脱落"
	desc = "在无害肢解持续期间，再次指定目标身上要无伤脱落的部位。"
	action_icon_state = "abduct"
	overlay_state = "blink"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 1 SECONDS
	cooldown_min = 1 SECONDS
	range = 1
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = FALSE
	var/mob/living/carbon/human/linked_target
	var/datum/status_effect/buff/harmless_dismemberment/linked_effect

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/Destroy()
	if(linked_effect?.selector_spell == src)
		linked_effect.selector_spell = null
	if(linked_effect?.controller?.harmless_dismemberment_selector_spell == src)
		linked_effect.controller.harmless_dismemberment_selector_spell = null
	linked_target = null
	linked_effect = null
	return ..()

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/proc/remove_from_holder(mob/living/user)
	var/datum/mind/M = user?.mind
	if(M)
		M.RemoveSpell(src)
	else
		qdel(src)

/obj/effect/proc_holder/spell/self/harmless_dismemberment_select/cast(list/targets, mob/living/user = usr)
	if(!ishuman(user))
		revert_cast(user)
		return FALSE
	if(QDELETED(linked_target) || QDELETED(linked_effect) || linked_effect.owner != linked_target)
		to_chat(user, span_warning("那层牵引血肉的法术已经散了。"))
		remove_from_holder(user)
		revert_cast(user)
		return FALSE
	if(!linked_effect.can_be_manipulated_by(user))
		to_chat(user, span_warning("这道断离牵引如今已不再回应我的手。"))
		remove_from_holder(user)
		revert_cast(user)
		return FALSE
	if(get_dist(user, linked_target) > range)
		to_chat(user, span_warning("[linked_target] 离得太远，我暂时没法继续指定新的脱落部位。"))
		revert_cast(user)
		return FALSE

	var/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/main_spell = user.mind?.get_spell(/obj/effect/proc_holder/spell/invoked/harmless_dismemberment, TRUE)
	if(!main_spell)
		to_chat(user, span_warning("我一时无法重新牵动这道法术。"))
		remove_from_holder(user)
		revert_cast(user)
		return FALSE

	main_spell.prompt_initial_separation(user, linked_target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/get_detachable_bodypart_choices(mob/living/carbon/human/target)
	var/list/detachable = list()
	if(!istype(target))
		return detachable

	if(target.get_bodypart(BODY_ZONE_HEAD))
		detachable += "头颅"
	if(target.get_bodypart(BODY_ZONE_L_ARM))
		detachable += "左臂"
	if(target.get_bodypart(BODY_ZONE_R_ARM))
		detachable += "右臂"
	if(target.get_bodypart(BODY_ZONE_L_LEG))
		detachable += "左腿"
	if(target.get_bodypart(BODY_ZONE_R_LEG))
		detachable += "右腿"
	if(target.get_bodypart(BODY_ZONE_TAUR))
		detachable += "尾巴"
	return detachable

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/get_choice_bodypart(mob/living/carbon/human/target, choice)
	if(!istype(target) || !choice)
		return null

	switch(choice)
		if("头颅")
			return target.get_bodypart(BODY_ZONE_HEAD)
		if("左臂")
			return target.get_bodypart(BODY_ZONE_L_ARM)
		if("右臂")
			return target.get_bodypart(BODY_ZONE_R_ARM)
		if("左腿")
			return target.get_bodypart(BODY_ZONE_L_LEG)
		if("右腿")
			return target.get_bodypart(BODY_ZONE_R_LEG)
		if("尾巴")
			return target.get_bodypart(BODY_ZONE_TAUR)

	return null

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/proc/prompt_initial_separation(mob/living/user, mob/living/carbon/human/target)
	if(!istype(user) || !istype(target))
		return

	var/datum/status_effect/buff/harmless_dismemberment/effect = target.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	if(!effect)
		return
	if(!effect.can_be_manipulated_by(user))
		to_chat(user, span_warning("这道无害肢解当前并不受我支配。"))
		return

	var/list/detachable = get_detachable_bodypart_choices(target)
	if(!length(detachable))
		to_chat(user, span_warning("[target] 身上已经没有可供无害分离的部位了。"))
		return

	var/choice = input(user, "选择要从 [target] 身上无害分离的部位。", "无害肢解") as null|anything in detachable
	if(QDELETED(src) || QDELETED(user) || QDELETED(target) || QDELETED(effect))
		return
	if(!effect.can_be_manipulated_by(user))
		to_chat(user, span_warning("那股牵引血肉的柔力已不再听从我的指定。"))
		return
	if(get_dist(user, target) > range)
		to_chat(user, span_warning("[target] 已经离得太远，我没法继续指定断离的部位。"))
		return
	if(!choice)
		to_chat(user, span_notice("我暂时没有让任何部位脱落。"))
		return

	var/obj/item/bodypart/chosen = get_choice_bodypart(target, choice)
	if(!istype(chosen) || chosen.owner != target)
		to_chat(user, span_warning("[target] 的[choice]已经不在原位了。"))
		return
	if(!effect.separate_bodypart(chosen))
		to_chat(user, span_warning("[target] 的[chosen.name]没能顺利分离。"))
		return

	to_chat(user, span_notice("我指定了 [target] 的[chosen.name] 脱落。"))

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment
	name = "无害肢解"
	desc = "让一名自愿目标在一分钟内变成一具可被平整拆开的活体圣匣。肢体与头颅会在无痛、无血、无死的温柔里分离，并在靠近断口时自行归位；待时限耗尽，仍未归位之物便不再回来。"
	action_icon_state = "bloodcrawl"
	cost = 8
	xp_gain = TRUE
	releasedrain = 40
	chargedrain = 1
	chargetime = 1 MINUTES
	recharge_time = 10 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "mimicry"
	spell_tier = 3
	invocations = list("肉可离，命暂留，归处莫迟。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 4
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 1
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/invoked/harmless_dismemberment/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!ishuman(target_atom))
		to_chat(user, span_warning("无害肢解只能对近在咫尺的人施展。"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/spelltarget = target_atom
	if(spelltarget.anti_magic_check())
		spelltarget.visible_message(span_warning("[spelltarget] 周身泛起一阵反魔法涟漪，将那道缝在血肉间的怪异温柔尽数震散！"))
		to_chat(user, span_warning("[spelltarget] 身上的反魔法抵消了无害肢解。"))
		playsound(get_turf(spelltarget), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	if(spelltarget != user)
		if(spelltarget.stat != CONSCIOUS || !spelltarget.client)
			to_chat(user, span_warning("只有清醒且能够亲自同意的人，才能接受这道法术。"))
			revert_cast()
			return FALSE

		var/consent = alert(spelltarget, "[user] 想对你施放“无害肢解”。接下来的一分钟里，你的肢体与头颅会在不流血、不呼痛、不立刻死去的情况下被平整分离，并在靠近断口时自行归位。若时限结束仍未归位，分离便会成为永久。要接受吗？", "无害肢解", "同意", "拒绝")
		if(QDELETED(src) || QDELETED(user) || QDELETED(spelltarget) || get_dist(user, spelltarget) > range)
			revert_cast()
			return FALSE
		if(consent != "同意")
			to_chat(user, span_warning("[spelltarget] 拒绝接受无害肢解。"))
			to_chat(spelltarget, span_notice("我拒绝了 [user] 的无害肢解。"))
			revert_cast()
			return FALSE

	var/already_enchanted = spelltarget.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	spelltarget.apply_status_effect(/datum/status_effect/buff/harmless_dismemberment, 1 MINUTES, user)
	var/datum/status_effect/buff/harmless_dismemberment/effect = spelltarget.has_status_effect(/datum/status_effect/buff/harmless_dismemberment)
	effect?.set_controller(user)
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 70, TRUE, soundping = TRUE)

	if(spelltarget == user)
		if(already_enchanted)
			user.visible_message(span_notice("[user] 再度抚过自己的四肢与颈项，让那道缝在血肉里的古怪魔法重新流转起来。"))
			to_chat(user, span_notice("我重新续上了自己身上的无害肢解。"))
		else
			user.visible_message(span_notice("[user] 以魔力轻抚自己的四肢与颈项，肉身随之浮现出一层柔和却令人不安的缝合辉光。"))
			to_chat(user, span_notice("我的血肉被这道法术轻轻托住了。接下来的一分钟里，即便分离，它们也不会立刻把我弃下。"))
	else
		if(already_enchanted)
			user.visible_message(span_notice("[user] 重新续接了 [spelltarget] 身上的无害肢解。"))
			to_chat(user, span_notice("我重新续上了 [spelltarget] 身上的无害肢解。"))
			to_chat(spelltarget, span_notice("那道维系我断口的古怪柔力重新充盈了起来。"))
		else
			user.visible_message(span_notice("[user] 贴近 [spelltarget]，以低缓咒语将一层柔和而诡异的魔力缝进了 [spelltarget.p_their()] 血肉。"))
			to_chat(user, span_notice("我把无害肢解缝进了 [spelltarget] 的血肉里。接下来的一分钟里，[spelltarget.p_their()] 的身体会像一件还能活着的器皿那样被拆开。"))
			to_chat(spelltarget, span_notice("[user] 的魔法轻柔地覆上了我的身体。接下来的一分钟里，只要切口平整迅速，我的肢体与头颅就能在不死不伤的古怪温柔中分离，并在归位时重新接回。"))
			to_chat(user, span_notice("在法术维持期间，我还可以继续点按“指定脱落”来反复选择新的部位。"))

	prompt_initial_separation(user, spelltarget)

	return TRUE
