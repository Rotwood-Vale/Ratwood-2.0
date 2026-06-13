/datum/objective/ravox_duel
	name = "荣誉决斗"
	triumph_count = 0
	var/duels_won = 0
	var/duels_required = 2

/datum/objective/ravox_duel/on_creation()
	. = ..()
	if(owner?.current)
		owner.current.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/ravox_challenge)
	update_explanation_text()

/datum/objective/ravox_duel/proc/on_duel_won()
	duels_won++
	if(duels_won >= duels_required && !completed)
		to_chat(owner.current, span_greentext("你已在战斗中证明了自己的价值！拉沃克斯十分满意！"))
		owner.current.adjust_triumphs(2)
		completed = TRUE
		adjust_storyteller_influence("Ravox", 25)
		escalate_objective()

/datum/objective/ravox_duel/update_explanation_text()
	explanation_text = "赢下 [duels_required] 场对其他战士的荣誉决斗，以证明你的武勇！"

/obj/effect/proc_holder/spell/targeted/ravox_challenge
	name = "发起决斗"
	overlay_state = "call_to_arms"
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	range = 7
	selection_type = "view"
	include_user = FALSE

/obj/effect/proc_holder/spell/targeted/ravox_challenge/cast(list/targets, mob/living/carbon/human/user)
	var/mob/living/carbon/human/target = targets[1]

	if(!istype(target))
		to_chat(user, span_warning("你只能挑战人类战士！"))
		return FALSE

	if(target == user)
		to_chat(user, span_warning("挑战自己毫无意义！"))
		return FALSE

	if(target.stat != CONSCIOUS)
		to_chat(user, span_warning("你的目标必须保持清醒，才能接受决斗！"))
		return FALSE

	if(user.stat != CONSCIOUS)
		to_chat(user, span_warning("你必须保持清醒，才能发起挑战！"))
		return FALSE

	var/challenge_message = "[user] 向你发起了一场荣誉决斗！你接受吗？"
	user.visible_message(span_notice("[user] 向 [target] 发起了一场荣誉决斗！"), span_notice("你向 [target] 发起了决斗！"))
	if(alert(target, challenge_message, "决斗挑战", "接受", "拒绝") != "接受")
		to_chat(user, span_warning("[target] 拒绝了你的挑战！"))
		to_chat(target, span_warning("你拒绝了 [user] 的挑战。"))
		user.visible_message(span_warning("[target] 拒绝了 [user] 的决斗挑战。"))
		return FALSE

	user.visible_message(span_notice("[user] 与 [target] 准备进行一场荣誉决斗！"), span_notice("决斗开始！"))
	to_chat(user, span_notice("决斗开始！战斗将在一方失去意识，或有决斗者认输时结束（对战斗模式按钮点右键）。"))
	user.playsound_local(user, 'sound/magic/inspire_02.ogg', 100)

	to_chat(target, span_notice("决斗开始！战斗将在一方失去意识，或有决斗者认输时结束（对战斗模式按钮点右键）。"))
	target.playsound_local(target, 'sound/magic/inspire_02.ogg', 100)

	var/datum/duel/current_duel = new(user, target)
	var/start_time = world.time
	var/max_duel_duration = 8 MINUTES

	while(current_duel && current_duel.ongoing)
		CHECK_TICK

		if(world.time > start_time + max_duel_duration)
			to_chat(user, span_notice("这场决斗持续得太久，被判定为平局！"))
			to_chat(target, span_notice("这场决斗持续得太久，被判定为平局！"))
			qdel(current_duel)
			break

		if(user.stat >= SOFT_CRIT || user.surrendering)
			target.visible_message(span_notice("[target] 在荣誉决斗中击败了 [user]！"))
			current_duel.end_duel(target)
			break
		if(target.stat >= SOFT_CRIT || target.surrendering)
			user.visible_message(span_notice("[user] 在荣誉决斗中击败了 [target]！"))
			current_duel.end_duel(user)
			break
		sleep(2 SECONDS)

	return TRUE

/datum/duel
	var/mob/living/carbon/human/challenger
	var/mob/living/carbon/human/challenged
	var/ongoing = TRUE

/datum/duel/New(mob/living/carbon/human/challenger, mob/living/carbon/human/challenged)
	src.challenger = challenger
	src.challenged = challenged

/datum/duel/proc/end_duel(mob/living/winner)
	if(!ongoing)
		return

	ongoing = FALSE
	to_chat(winner, span_green("你赢得了这场荣誉决斗！"))
	to_chat(winner == challenger ? challenged : challenger, span_red("你输掉了这场荣誉决斗！"))

	if(winner.mind)
		var/datum/objective/ravox_duel/objective = locate() in winner.mind.get_all_objectives()
		if(objective)
			objective.on_duel_won()

	qdel(src)
