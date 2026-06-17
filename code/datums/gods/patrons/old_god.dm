/datum/patron/old_god
	name = "普赛顿"
	domain = "生命、创造、慈悲与坚忍"
	desc = "独一者抵达了普赛顿彗星所载的普赛多尼亚，将那片荒芜世界重塑为祂的模样。祂被死灵魔女齐佐击倒；有人相信祂已经死去，也有人相信祂只是沉眠。愿我们以祂之名坚忍。"
	worshippers = "古代矮人与精灵、兹班图人、奥塔万人、和平之梦者"
	virtues = "和平、坚韧、顽强"
	sins = "巫术、施虐、纵欲无度"
	associated_faith = /datum/faith/old_god
	mob_traits = list(TRAIT_PSYDONIAN_GRIT)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/check_boot				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/psydonendure			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/psydonrespite			= CLERIC_T2,
	)
	traits_tier = list(TRAIT_PSYDONITE = CLERIC_T1)
	confess_lines = list(
		"唯有一位真神！",
		"普赛顿仍然活着！普赛顿依然长存！",
		"斥退异教徒，粉碎怪物！",
		"骨断筋折之时，我仍发誓自己活着！",
		"宽恕他们吧，全父，因为他们不知道自己在做什么！",
		"见证吧，我的神；这份牺牲已然显现！",
	)


/obj/effect/proc_holder/spell/self/check_boot
	name = "靴中寻物"
	desc = "检查我的靴子里有没有各种东西。"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "BOOTCHECK"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = null
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 30
	range = 1
	var/static/list/lootpool = list(/obj/item/flowercrown/rosa,
	/obj/item/bouquet/rosa,
	/obj/item/jingle_bells,
	/obj/item/bouquet/salvia,
	/obj/item/bouquet/calendula,
	/obj/item/roguecoin/gold,
	/obj/item/roguecoin/silver,
	/obj/item/roguecoin/copper,
	/obj/item/alch/atropa,
	/obj/item/alch/salvia,
	/obj/item/alch/artemisia,
	/obj/item/alch/rosa,
	/obj/item/rogueweapon/huntingknife/idagger/navaja,
	/obj/item/lockpick,
	/obj/item/reagent_containers/glass/bottle/alchemical/strpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/endpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/conpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/lucpot,
	/obj/item/reagent_containers/glass/bottle/rogue/poison,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
	/obj/item/needle,
	/obj/item/natural/rock,
	/obj/item/natural/bundle/cloth,
	/obj/item/natural/bundle/fibers,
	/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini,
	/obj/item/reagent_containers/glass/bottle/waterskin/milk,
	/obj/item/reagent_containers/food/snacks/rogue/bread,
	/obj/item/reagent_containers/food/snacks/grown/apple,
	/obj/item/natural/worms,
	/obj/item/natural/worms/leech,
	/obj/item/reagent_containers/food/snacks/rogue/psycrossbun,
	/obj/item/clothing/neck/roguetown/psicross,
	/obj/item/clothing/neck/roguetown/psicross/wood,
	/obj/item/rope/chain,
	/obj/item/rope,
	/obj/item/clothing/neck/roguetown/collar/leather,
	/obj/item/natural/dirtclod,
	/obj/item/reagent_containers/glass/cup/wooden,
	/obj/item/natural/glass,
	/obj/item/clothing/shoes/roguetown/sandals,
	/obj/item/alch/transisdust)

/obj/effect/proc_holder/spell/self/check_boot/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/obj/item/found_thing
	if(H.get_stress_amount() < 0 && H.STALUC > 10)
		found_thing = new /obj/item/roguecoin/gold
	else if(H.STALUC == 10)
		found_thing = new /obj/item/roguecoin/silver
	else
		found_thing = new /obj/item/roguecoin/copper
	to_chat(H, span_info("我的靴子里有枚硬币？普赛顿正对我微笑！"))
	H.put_in_hands(found_thing, FALSE)
	if(prob(H.STALUC + H.get_skill_level(associated_skill)))
		var/obj/item/extra_thing = pick(lootpool)
		new extra_thing(get_turf(user))
		to_chat(H, span_info("啊，当然！我差点忘了自己还藏着这个，正适合此刻派上用场。"))
		H.put_in_hands(extra_thing, FALSE)
	return TRUE



/////////////////////////////////
// Does God Hear Your Prayer ? //
/////////////////////////////////
// no he's dead - ok maybe he does

/datum/patron/old_god/can_pray(mob/living/follower)
	. = ..()
	. = TRUE
	// Allows prayer near psycross.
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的普赛圣十字打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer if raining and outside. Psydon weeps.
	if(GLOB.forecast == "rain")
		if(istype(get_area(follower), /area/rogue/outdoors))
			return TRUE
	// Allows prayer if bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer if holding silver psycross.
	if(istype(follower.get_active_held_item(), /obj/item/clothing/neck/roguetown/psicross/silver))
		return TRUE
	to_chat(follower, span_danger("若想让普赛顿听见我的祈祷，我必须在万神殿十字架附近、以自己的鲜血忏悔、手持祂的银制圣徽之一，或沐浴在祂的雨中；因为普赛顿正为祂的子民哭泣……"))
	return FALSE

//////////////////////////////////
// 	    ENDVRE. AS DOES HE.    //
////////////////////////////////

/obj/effect/proc_holder/spell/invoked/psydonendure
	name = "坚忍"
	desc = "以一些维系生命的鲜血为代价，我能够治愈目标的伤势。"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ENDURE"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/ENDVRE.ogg'
	invocations = list("活着，坚持！") // holy larp yelling for healing is silly
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 40

/obj/effect/proc_holder/spell/invoked/psydonendure/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/brute = target.getBruteLoss()
		var/burn = target.getFireLoss()
		var/list/wAmount = target.get_wounds()
		var/conditional_buff = FALSE
		var/situational_bonus = 0
		var/psicross_bonus = 0
		var/pp = 0
		var/damtotal = brute + burn
		var/zcross_trigger = FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD)) // YOU ARE NO LONGER MORTAL. NO LONGER OF HIM. PSYDON WEEPS.
			target.visible_message(span_danger("[target] 因一股奇异悸动而颤抖！"), span_userdanger("好痛。你感觉自己想哭。"))
			target.adjustBruteLoss(40)
			return TRUE

		// Bonuses! Flavour! SOVL!
		for(var/obj/item/clothing/neck/current_item in target.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/decrepit, /obj/item/clothing/neck/roguetown/psicross/silver,	/obj/item/clothing/neck/roguetown/psicross/g))
				pp += 1
				if(pp >= 12 & target == user) // A harmless easter-egg. Only applies on self-cast. You'd have to be pretty deliberate to wear 12 of them.
					target.visible_message(span_danger("[target] 身上的众多普赛圣十字共鸣出一种奇异而短暂的声响……"), span_userdanger("祂一定要苏醒了！我听见了！我竟如此坚忍！"))
					playsound(user, 'sound/magic/PSYDONE.ogg', 100, FALSE)
					sleep(60)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(20)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(15)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(10)
					user.gib()
					return FALSE

				switch(current_item.type) // Target-based worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/roguetown/psicross/wood)
						psicross_bonus = 0.1
					if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
						psicross_bonus = 0.2
					if(/obj/item/clothing/neck/roguetown/psicross)
						psicross_bonus = 0.3
					if(/obj/item/clothing/neck/roguetown/psicross/silver)
						psicross_bonus = 0.4
					if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
						psicross_bonus = 0.4
					if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
						zcross_trigger = TRUE

		if(damtotal >= 300) // ARE THEY ENDURING MUCH, IN ONE WAY OR ANOTHER?
			situational_bonus += 0.3

		if(wAmount.len > 5)
			situational_bonus += 0.3

		if (situational_bonus > 0)
			conditional_buff = TRUE

		target.visible_message(span_info("一股奇异的悸动自 [target] 体内涌出！"), span_info("感伤的思绪驱散了我的痛楚……"))
		var/psyhealing = 3
		psyhealing += psicross_bonus
		if (conditional_buff & !zcross_trigger)
			to_chat(user, "正因如此 <b>坚忍不屈</b>，我变得 <b>无比振奋</b>！")
			psyhealing += situational_bonus

		if (zcross_trigger)
			user.visible_message(span_warning("[user] 颤抖了一下。情况很不对劲。"), span_userdanger("一阵寒意窜上我的脊背。有某种东西在嘲笑我的尝试。"))
			user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
			user.adjustBruteLoss(25)
			return FALSE

		target.apply_status_effect(/datum/status_effect/buff/psyhealing, psyhealing)
		user.blood_volume = max(user.blood_volume-30, 0)//We don't care about scaling, for this one.
		return TRUE

	revert_cast()
	return FALSE
