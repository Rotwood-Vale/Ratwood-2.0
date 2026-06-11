/obj/effect/proc_holder/spell/invoked/psydonlux_tamper
	name = "泣血"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "WEEP"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	desc = "为目标流出自己的鲜血，承受他们的伤口，并为其补足血量。"
	movement_interrupt = FALSE
	sound = 'sound/magic/psydonbleeds.ogg'
	invocations = list("我以鲜血代偿，好让你得以撑下去！")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonlux_tamper/cast(list/targets, mob/living/user)
	if(!ishuman(targets[1]))
		to_chat(user, span_warning("对方的 Lux 无需净化。"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]

	if(H == user)
		to_chat(user, span_warning("我自身的 Lux 仍维持着纯净。"))
		revert_cast()
		return FALSE

	if(H.stat == DEAD)
		to_chat(user, span_warning("[H] 的 Lux 已经离去。我已无能为力。"))
		user.emote("cry")
		revert_cast()
		return FALSE

	// Transfer wounds.
	if(ishuman(H) && ishuman(user))
		var/mob/living/carbon/human/C_target = H
		var/mob/living/carbon/human/C_caster = user
		var/list/datum/wound/tw_List = C_target.get_wounds()

		if(!tw_List.len)
			revert_cast()
			return FALSE

		//Transfer wounds from each bodypart.
		for(var/datum/wound/targetwound in tw_List)
			if (istype(targetwound, /datum/wound/dismemberment))
				continue
			if (istype(targetwound, /datum/wound/facial))
				continue
			if (istype(targetwound, /datum/wound/fracture/head))
				continue
			if (istype(targetwound, /datum/wound/fracture/neck))
				continue
			if (istype(targetwound, /datum/wound/cbt/permanent))
				continue
			var/obj/item/bodypart/c_BP = C_caster.get_bodypart(targetwound.bodypart_owner.body_zone)
			c_BP.add_wound(targetwound.type)
			var/obj/item/bodypart/t_BP = C_target.get_bodypart(targetwound.bodypart_owner.body_zone)
			t_BP.remove_wound(targetwound.type)

	// Transfer blood
	var/blood_transfer = 0
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		blood_transfer = BLOOD_VOLUME_NORMAL - H.blood_volume
		H.blood_volume = BLOOD_VOLUME_NORMAL
		user.blood_volume -= blood_transfer
		to_chat(user, span_warning("我感到自己的鲜血正流入 [H] 体内！"))
		to_chat(H, span_notice("我感到自己的血量恢复了！"))

	// Visual effects
	user.visible_message(span_danger("[user] 净化了 [H] 的伤口！"))
	playsound(get_turf(user), 'sound/magic/psydonbleeds.ogg', 50, TRUE)

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")

	// Notify the user and target
	to_chat(user, span_notice("片刻之间，我以彼此相融的 Lux 净化了对方。"))
	to_chat(H, span_info("我感到一股奇异的悸动漫过自己的 Lux，将伤痛一并带走。"))
	return TRUE

/obj/effect/proc_holder/spell/self/psydonrespite
	name = "息憩"
	desc = "以少许维系生命的鲜血为代价，我可以静立原地，专心修补自身伤势。"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "RESPITE"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/psydonrespite/cast(mob/living/carbon/human/user) // It's a very tame self-heal. Nothing too special.
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	var/brute = H.getBruteLoss()
	var/burn = H.getFireLoss()
	var/conditional_buff = FALSE
	var/zcross_trigger = FALSE
	var/sit_bonus1 = 0
	var/sit_bonus2 = 0
	var/psicross_bonus = 0

	for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
		if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/decrepit, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/g))
			switch(current_item.type) // Worn Psicross Piety bonus. For fun.
				if(/obj/item/clothing/neck/roguetown/psicross/wood)
					psicross_bonus = -2
				if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
					psicross_bonus = -4
				if(/obj/item/clothing/neck/roguetown/psicross)
					psicross_bonus = -5
				if(/obj/item/clothing/neck/roguetown/psicross/silver)
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
					zcross_trigger = TRUE
	if(brute > 100)
		sit_bonus1 = -2
	if(brute > 150)
		sit_bonus1 = -4
	if(brute > 200)
		sit_bonus1 = -6
	if(brute > 300)
		sit_bonus1 = -8
	if(brute > 350)
		sit_bonus1 = -10
	if(brute > 400)
		sit_bonus1 = -14

	if(burn > 100)
		sit_bonus2 = -2
	if(burn > 150)
		sit_bonus2 = -4
	if(burn > 200)
		sit_bonus2 = -6
	if(burn > 300)
		sit_bonus2 = -8
	if(burn > 350)
		sit_bonus2 = -10
	if(burn > 400)
		sit_bonus2 = -14

	if(sit_bonus1 || sit_bonus2)
		conditional_buff = TRUE

	var/bruthealval = -7 + psicross_bonus + sit_bonus1
	var/burnhealval = -7 + psicross_bonus + sit_bonus2

	to_chat(H, span_info("我稍作停顿，收束心神……"))
	if(zcross_trigger)
		user.visible_message(span_warning("[user] 猛地一颤。情况很不对劲。"), span_userdanger("一股寒意窜上我的脊背。有什么东西在嘲笑我的尝试。"))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		H.blood_volume = max(H.blood_volume-6, 0)//Don't sit here and heal all day. Thanks.
		if (conditional_buff)
			to_chat(user, span_info("疼痛短暂退去，化作更清晰的意识，随后又钝钝地回到我身上。"))
		user.devotion?.update_devotion(-20)
		to_chat(user, "<font color='purple'>我失去了 20 点虔诚！</font>")
		cast(user)
		return TRUE
	else
		to_chat(H, span_warning("我的思绪与那份宁静从指缝间溜走了。"))
		return FALSE


/obj/effect/proc_holder/spell/self/psydonpersist
	name = "坚持"
	desc = "静立不动，专心修补你的伤势。你必须坚持下去。"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "PERSIST"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/psydonpersist/cast(mob/living/carbon/human/user) // It's a very tame self-heal. Nothing too special.
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	var/brute = H.getBruteLoss()
	var/burn = H.getFireLoss()
	var/conditional_buff = FALSE
	var/zcross_trigger = FALSE
	var/sit_bonus1 = 0
	var/sit_bonus2 = 0
	var/psicross_bonus = 0

	for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
		if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/decrepit, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/g))
			switch(current_item.type) // Worn Psicross Piety bonus. For fun.
				if(/obj/item/clothing/neck/roguetown/psicross/wood)
					psicross_bonus = -2
				if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
					psicross_bonus = -4
				if(/obj/item/clothing/neck/roguetown/psicross)
					psicross_bonus = -5
				if(/obj/item/clothing/neck/roguetown/psicross/silver)
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
					zcross_trigger = TRUE
	if(brute > 100)
		sit_bonus1 = -2
	if(brute > 150)
		sit_bonus1 = -4
	if(brute > 200)
		sit_bonus1 = -6
	if(brute > 300)
		sit_bonus1 = -8
	if(brute > 350)
		sit_bonus1 = -10
	if(brute > 400)
		sit_bonus1 = -14

	if(burn > 100)
		sit_bonus2 = -2
	if(burn > 150)
		sit_bonus2 = -4
	if(burn > 200)
		sit_bonus2 = -6
	if(burn > 300)
		sit_bonus2 = -8
	if(burn > 350)
		sit_bonus2 = -10
	if(burn > 400)
		sit_bonus2 = -14

	if(sit_bonus1 || sit_bonus2)
		conditional_buff = TRUE

	var/bruthealval = -14 + psicross_bonus + sit_bonus1
	var/burnhealval = -14 + psicross_bonus + sit_bonus2

	to_chat(H, span_info("I take a moment to collect myself..."))
	if(zcross_trigger)
		user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		if (conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))
		user.devotion?.update_devotion(-60)
		to_chat(user, "<font color='purple'>我失去了 60 点虔诚！</font>")
		cast(user)
		return TRUE
	else
		to_chat(H, span_warning("My thoughts and sense of quiet escape me."))
		return FALSE


/obj/effect/proc_holder/spell/invoked/psydonabsolve
	name = "赦免"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ABSOLVE"
	desc = "赦免目标，将其伤害转移到自己身上，甚至可能以你的性命为代价代其赴死。"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/psyabsolution.ogg'
	invocations = list("得蒙赦免吧！")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS // 60 seconds cooldown
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonabsolve/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("“赦免”只对行于祂之形象下的人有效！"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]

	if(H == user)
		to_chat(user, span_warning("我不能对自己施展“赦免”！"))
		revert_cast()
		return FALSE

	// Special case for dead targets
	if(H.stat >= DEAD)
		if(!H.check_revive(user))
			revert_cast()
			return FALSE
		if(alert(user, "要伸手将其拉回来吗？", "其中已无 Lux", "是", "否") != "是")
			revert_cast()
			return FALSE
		to_chat(user, span_warning("我试图以“赦免”将 [H] 拉回人世！"))
		// Dramatic effect
		user.visible_message(span_danger("[user] 一把抓住了 [H] 的手腕，试图将其赦免回生！"))
		if(alert(H, "对方想要赦免你，将你拉回人世。你愿意吗？", "ABSOLUTION", "我愿接受", "我拒绝") != "我愿接受")
			H.visible_message(span_notice("什么也没有发生。"))
			return FALSE
		// Create visual effects
		H.apply_status_effect(/datum/status_effect/buff/psyvived)
		// Kill the caster
		user.say("我以此命换彼命！活下去，如他一般！", forced = TRUE)
		user.death()
		// Revive the target
		H.revive(full_heal = TRUE, admin_revive = FALSE)
		H.adjustOxyLoss(-H.getOxyLoss())
		H.grab_ghost(force = TRUE) // even suicides
		H.emote("breathgasp")
		H.Jitter(100)
		H.update_body()
		record_round_statistic(STATS_LUX_REVIVALS)
		ADD_TRAIT(H, TRAIT_IWASREVIVED, "[type]")
		H.apply_status_effect(/datum/status_effect/buff/psyvived)
		user.apply_status_effect(/datum/status_effect/buff/psyvived)
		H.visible_message(span_notice("[H] 被赦免回生了！"), span_green("我自虚无中醒来。"))
		H.mind.remove_antag_datum(/datum/antagonist/zombie)
		H.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		H.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		return TRUE

	// Transfer afflictions from the target to the caster

	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)

	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Visual effects
	user.visible_message(span_danger("[user] 将 [H] 的苦痛揽到了自己身上！"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")

	// Notify the user and target
	to_chat(user, span_warning("我替 [H] 承下了他们的伤势！"))
	to_chat(H, span_notice("[user] 替你承下了伤势！"))

	return TRUE

// Weaker absolve for the Stigmata adventurer
/obj/effect/proc_holder/spell/invoked/psydonamend	
	name = "分担"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ABSOLVE"
	desc = "这是强大神艺“赦免”的弱化形式，不具备复活之能，只会将目标的伤势转移到你身上。务必谨慎使用。"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 5
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/psyabsolution.ogg'
	invocations = list("由我来分担！")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS // 60 seconds cooldown
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonamend/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("“分担”只对行于祂之形象下的人有效！"))
		revert_cast()
		return FALSE
	
	var/mob/living/carbon/human/H = targets[1]
	
	if(H == user)
		to_chat(user, span_warning("我不能对自己施展“分担”！"))
		revert_cast()
		return FALSE

	// THE LESSER ART OF AMENDMENT CANNOT RETURN THE DEAD.
	
	// Transfer afflictions from the target to the caster
	
	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	if (oxy_transfer >= 150)
		if (alert(user, "对方面如死灰、呼吸停滞。施展“分担”可能会立刻害死你，受印者。还要继续吗？", "自保", "YES", "NO") != "YES")
			revert_cast()
			return
	
	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)
	
	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Visual effects
	user.visible_message(span_danger("[user] 将 [H] 的痛苦强行揽到了自己身上！"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	
	// Notify the user and target
	to_chat(user, span_warning("我替 [H] 承下了这份折磨！"))
	to_chat(H, span_notice("[user] 替你分担了这份痛苦！"))
	
	return TRUE
