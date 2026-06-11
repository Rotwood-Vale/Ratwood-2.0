/obj/effect/proc_holder/spell/invoked/enlarge
	name = "巨化术"
	desc = "暂时将目标放大成高大魁梧的巨型姿态，足以撞开门扉。对本就体型巨大的人无效。"
	cost = 2
	overlay_state = "enlarge"
	releasedrain = 35
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 2
	invocations = list("膨胀壮大吧！")
	invocation_type = "shout"
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	overlay_state = "rune1"
	range = 7

/obj/effect/proc_holder/spell/invoked/enlarge/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target,TRAIT_BIGGUY))
			to_chat(user, "<span class='warning'>对方已经大到无法再被放大了！</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
		ADD_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
		target.transform = target.transform.Scale(1.25, 1.25)
		target.transform = target.transform.Translate(0, (0.25 * 16))
		target.update_transform()
		to_chat(target, span_warning("我感觉自己比平时高大得多，简直能直接撞穿一扇门！"))
		target.visible_message("[target]的身体膨胀变大了！")
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 60 SECONDS)
		return TRUE


/obj/effect/proc_holder/spell/invoked/enlarge/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	REMOVE_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
	target.transform = target.transform.Translate(0, -(0.25 * 16))
	target.transform = target.transform.Scale(1/1.25, 1/1.25)
	target.update_transform()
	to_chat(target, span_warning("我突然感觉自己缩小了。"))
	target.visible_message("[target]的身体迅速缩小了！")
