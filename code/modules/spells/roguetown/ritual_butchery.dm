/obj/effect/proc_holder/spell/invoked/extract_heart
	name = "剜心献祭"
	desc = "一场为 Graggar 献上心脏祭品的亵渎仪式。仅对新鲜尸体生效。"
	overlay_state = "curse"
	chargedrain = 0
	chargetime = 0
	range = 1
	movement_interrupt = TRUE
	invocation_type = "none"
	associated_skill = /datum/skill/labor/butchering
	miracle = FALSE
	devotion_cost = 0
	sound = 'sound/surgery/organ1.ogg'
	/// Base time, reduced by butchery skill
	var/extraction_time = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/extract_heart/cast(list/targets, mob/living/user)
	var/mob/living/carbon/human/target = targets[1]

	if(!istype(target))
		to_chat(user, "<span class='warning'>唯有真正的血肉，才值得 Graggar 投来目光！</span>")
		return FALSE

	if(target.stat != DEAD)
		to_chat(user, "<span class='warning'>这懦夫体内仍有生命搏动！Graggar 要求你先把他彻底了结！</span>")
		return FALSE

	// Calculate actual time based on butchery skill
	var/skill_modifier = 1 - (user.get_skill_level(/datum/skill/labor/butchering) * 0.1) // 10% reduction per skill level
	var/actual_time = max(extraction_time * skill_modifier, 7.5 SECONDS) // Minimum 7.5 seconds

	user.visible_message("<span class='warning'>[user] 伸手探向了 [target] 的胸腔，口中含混地念诵着什么……</span>", \
						"<span class='notice'>我开始执行剜取 [target] 心脏的仪式。</span>")

	if(!do_after(user, actual_time, target = target))
		to_chat(user, "<span class='warning'>亵渎仪式被打断了！可耻！</span>")
		return FALSE

	if(target.stat != DEAD)
		to_chat(user, "<span class='warning'>这懦夫体内仍有生命搏动！Graggar 要求你先把他彻底了结！</span>")
		return FALSE

	var/obj/item/organ/heart/heart = target.getorganslot(ORGAN_SLOT_HEART)
	if(!heart)
		to_chat(user, "<span class='warning'>这里只剩下一具空荡荡的胸腔了！</span>")
		return FALSE

	heart.Remove(target)
	heart.forceMove(target.drop_location())
	user.put_in_hands(heart)

	target.add_splatter_floor()
	target.adjustBruteLoss(20)

	user.visible_message("<span class='warning'>[user] 咆哮着将 [target] 的心脏活生生扯了出来！</span>", \
						"<span class='red'>我将这颗心脏献给了 Graggar！这位神明对祭品发出了低笑。</span>")
	user.emote("rage", forced = TRUE)

	return TRUE
