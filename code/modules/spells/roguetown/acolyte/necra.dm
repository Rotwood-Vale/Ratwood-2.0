// Necrite
/obj/effect/proc_holder/spell/targeted/burialrite
	name = "葬仪"
	desc = "祝圣一具棺木或一座墓穴，将其中停留的灵魂送往 Necra 的国度。"
	range = 5
	overlay_state = "consecrateburial"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("冥下侍女，赐其归途，免受遗忘者诸般试炼。")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 5 //very weak spell, you can just make a grave marker with a literal stick

/obj/effect/proc_holder/spell/targeted/burialrite/cast(list/targets, mob/user = usr)
	. = ..()
	var/success = FALSE
	for(var/obj/structure/closet/crate/coffin/coffin in view(1))
		success = pacify_coffin(coffin, user)
		if(success)
			user.visible_message("[user] 祝圣了 [coffin]！", "我已对 [coffin] 行完葬仪！")
			return
	for(var/obj/structure/closet/dirthole/hole in view(1))
		success = pacify_coffin(hole, user)
		if(success)
			user.visible_message("[user] 祝圣了 [hole]！", "我已对 [hole] 行完葬仪！")
			record_round_statistic(STATS_GRAVES_CONSECRATED)
			return
	to_chat(user, span_red("我未能完成葬仪。"))

/obj/effect/proc_holder/spell/targeted/churn
	name = "翻搅亡骸"
	desc = "震慑并炸裂不死者。"
	range = 8//We return it, up from 4...
	overlay_state = "necra_ult"//Temp.
	releasedrain = 30
	chargetime = 6 SECONDS//Up from 2.
	recharge_time = 2 MINUTES//Up from 60.
	max_targets = 2//... in exchange for max targets...
	cast_without_targets = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("冥下侍女斥退汝等！！")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 150//... with a higher devotion cost, at +100, from 50.

/obj/effect/proc_holder/spell/targeted/churn/cast(list/targets,mob/living/user = usr)
	var/prob2explode = 100
	if(user && user.mind)
		prob2explode = 0
		for(var/i in 1 to user.get_skill_level(/datum/skill/magic/holy))
			prob2explode += 30
	for(var/mob/living/L in targets)
		var/isvampire = FALSE
		var/iszombie = FALSE
		if(L.stat == DEAD)
			continue
		if(L.mind)
			var/datum/antagonist/vampire/V = L.mind.has_antag_datum(/datum/antagonist/vampire)
			if(V && !SEND_SIGNAL(L, COMSIG_DISGUISE_STATUS))
				isvampire = TRUE
			if(L.mind.has_antag_datum(/datum/antagonist/zombie))
				iszombie = TRUE
			if(L.mind.special_role == "Vampire Lord" || L.mind.special_role == "Lich")	//Won't detonate Lich's or VLs but will fling them away.
				user.visible_message(span_warning("[L] 压倒了翻搅之力！"), span_userdanger("[L] 太过强大，反倒是我被翻搅了！"))
				user.Stun(50)
				user.throw_at(get_ranged_target_turf(user, get_dir(user,L), 7), 7, 1, L, spin = FALSE)
				return
		if((L.mob_biotypes & MOB_UNDEAD) || isvampire || iszombie)
			var/vamp_prob = prob2explode
			if(isvampire)
				vamp_prob -= 59
			if(prob(vamp_prob))
				L.visible_message("<span class='warning'>[L] 被 Necra 之握翻搅撕裂！", "<span class='danger'>我被 Necra 之握翻搅撕裂了！")
				explosion(get_turf(L), light_impact_range = 1, flame_range = 1, smoke = FALSE)
				L.Stun(50)
			else
				L.visible_message(span_warning("[L] 抵住了翻搅之力！"), span_userdanger("我抵住了翻搅之力！"))
	..()
	return TRUE


/*
	DEATH'S DOOR
*/
/obj/effect/proc_holder/spell/invoked/deaths_door
	name = "死门"
	desc = "开启一道通往濒死边缘之境的单向门户，可将他人拖入其中以阻止尸身腐坏。不死者会在其中燃烧。踏入此域的人会感到求生意志大幅衰弱。<br>离开 Necra 领域的方法，是通过其中通往神龛的出口，或通往被 Necra 之视标记的墓穴/灵十字的出口。"
	range = 6
	no_early_release = TRUE
	chargedrain = 0
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "necraportal"
	action_icon_state = "necraportal"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	charging_slowdown = 1
	chargetime = 2 SECONDS
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	sound = 'sound/misc/deadbell.ogg'
	invocations = list("Necra，向我显出归途！")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/deaths_door/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		return FALSE

	if(locate(/obj/structure/deaths_door_portal) in T)
		to_chat(user, span_warning("这里已经立着一道门扉。"))
		return FALSE

	new /obj/structure/deaths_door_portal(T, user)
	return TRUE


//Choosing between skulls/respite
/* /obj/effect/proc_holder/spell/self/necra_spirits
	name = "Necra 的群灵"
	overlay_state = "consecrateburial"
	desc = "冥下侍女将复仇群灵握于掌中，让你从 <b>她</b> 的助力中择其一而用。"
	miracle = TRUE
	devotion_cost = 100
	recharge_time = 10 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/necra_spirits/cast(list/targets, mob/user)
	. = ..()
	var/choice = alert(user, "是谁回应了这钟声？", "唤来群灵", "颅灵", "慰灵")
	switch(choice)
		if("Skulls")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance))//No stacking.
				revert_cast()
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirit_respite))//No, thanks.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/raise_spirit_respite)
		if("Respite")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirit_respite))//No stacking. Again. As funny as a dozen of these were.
				revert_cast()
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_spirit_respite)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance))//Nope.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance)
		else
			revert_cast() */

// Speak with dead

/obj/effect/proc_holder/spell/invoked/speakwithdead
	name = "与死者交谈"
	desc = "呼请冥下侍女，让你的话语抵达已逝之魂，并听见他们回返的低语。"
	range = 5
	overlay_state = "speakwithdead"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("逝者余音已起，开口吧，已陨之人。")
	invocation_type = "whisper"
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/speakwithdead/cast(list/targets, mob/user = usr)
	if(!targets || !length(targets))
		to_chat(user, "<font color='red'>施行此神迹时，你必须站在死者遗体旁。若躯壳中已无灵魂，便不会有任何回应。</font>")
		return FALSE

	var/mob/living/target = targets[1]

	if(isliving(target) && target.stat == DEAD)
		return speakwithdead(user, target)
	else
		to_chat(user, "<font color='red'>他们还没死。至少现在还没有。</font>")
		return FALSE

/proc/speakwithdead(mob/user, mob/living/target)
	if(target.stat == DEAD && target.mind)
		var/message = input(user, "你正与 [target.real_name] 的灵魂交谈。你要说什么？", "与死者交谈") as text|null

		if(message)
			if(target.mind.current)
				to_chat(target.mind.current, "<span style='color:gold'><b>[user.real_name]</b> 说道：\"[message]\"</span>")

			var/mob/dead/observer/ghost = null

			for (var/mob/dead/observer/G in world)
				if (G.mind == target.mind)
					ghost = G
					break

			if (!ghost && target.mind && target.mind.key)
				var/expected_ckey = ckey(target.mind.key)
				for (var/mob/dead/observer/G2 in world)
					if (G2.client && ckey(G2.key) == expected_ckey)
						ghost = G2
						break

			if (ghost && ghost != target.mind.current)
				to_chat(ghost, "<span style='color:gold'><b>[user.real_name]</b> 说道：\"[message]\"</span>")

			to_chat(user, "<span style='color:gold'>你向灵魂说道：\"[message]\"</span>")

			var/mob/replier = null
			if (ghost && ghost.client)
				replier = ghost
			else if (target.mind.current && target.mind.current.client)
				replier = target.mind.current

			if(replier)
				var/spirit_message = input(replier, "一名叫做 [user.real_name] 的 Necra 侍僧正在呼唤你。你要如何回应？", "灵魂的回应") as text|null
				if(spirit_message)
					to_chat(user, "<span style='color:silver'><i>灵魂低语道：</i> \"[spirit_message]\"</span>")
				else
					to_chat(user, "<span style='color:#aaaaaa'><i>那道灵魂选择保持沉默……</i></span>")
			else
				to_chat(user, "<span style='color:#aaaaaa'><i>那道灵魂此刻无法作答……</i></span>")
		else
			to_chat(user, "<span style='color:#aaaaaa'><i>你选择了沉默。</i></span>")
	else
		to_chat(user, "<span style='color:#aaaaaa'><i>没有灵魂回应你的呼唤。</i></span>")

// BODY INTO COIN

/obj/effect/proc_holder/spell/invoked/fieldburials
	name = "收取丧资"
	overlay_state = "consecrateburial"
	antimagic_allowed = TRUE
	devotion_cost = 10
	miracle = TRUE
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/fieldburials/cast(list/targets, mob/living/user)
	. = ..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat < DEAD)
		to_chat(user, span_warning("他们还活着！"))
		revert_cast()
		return FALSE

	if(world.time <= target.mob_timers["lastdied"] + 15 MINUTES)
		to_chat(user, span_warning("这具尸体对这项仪式来说还太新鲜。"))
		revert_cast()
		return FALSE

	var/obj/item/roguecoin/silver/C = new(get_turf(target))
	C.pixel_x = rand(-6, 6)
	C.pixel_y = rand(-6, 6)

	to_chat(user, span_notice("你从 [target.real_name] 的遗骸上收取了丧资。"))
	to_chat(target, span_danger("你尘世的财富正随着仪式一并流逝……"))

	qdel(target)

	return TRUE

/*
	SOUL SPEAK OLD LEGACY
	Not used anymore, but kept for reference.
*/

/*
/obj/effect/proc_holder/spell/targeted/soulspeak
	name = "与灵交谈"
	range = 5
	overlay_state = "speakwithdead"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("冥下之主许你片刻歇息，迷途者啊，说出你的声音。")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/targeted/soulspeak/cast(list/targets,mob/user = usr)
	var/mob/living/carbon/spirit/capturedsoul = null
	var/list/souloptions = list()
	var/list/itemstore = list()
	for(var/mob/living/carbon/spirit/S in GLOB.mob_list)
		if(S.summoned)
			continue
		if(!S.client)
			continue
		souloptions += S.livingname
	var/pickedsoul = input(user, "我要与哪一道游魂沟通？", "可选灵魂") as null|anything in souloptions
	if(!pickedsoul)
		to_chat(user, span_warning("我未能与任何灵魂建立沟通。"))
		return
	for(var/mob/living/carbon/spirit/P in GLOB.mob_list)
		if(P.livingname == pickedsoul)
			to_chat(P, "<font color='blue'>我感觉自己正被拉离冥界。</font>")
			sleep(2 SECONDS)
			if(QDELETED(P) || P.summoned)
				to_chat(user, "<font color='blue'>我与那道灵魂的联系突然断开了！</font>")
				return
			capturedsoul = P
			break
	if(capturedsoul)
		for(var/obj/item/I in capturedsoul.held_items) // this is still ass
			capturedsoul.temporarilyRemoveItemFromInventory(I, force = TRUE)
			itemstore += I.type
			qdel(I)
		capturedsoul.loc = user.loc
		capturedsoul.summoned = TRUE
		capturedsoul.beingmoved = TRUE
		capturedsoul.invisibility = INVISIBILITY_OBSERVER
		capturedsoul.status_flags |= GODMODE
		capturedsoul.Stun(61 SECONDS)
		capturedsoul.density = FALSE
		addtimer(CALLBACK(src, PROC_REF(return_soul), user, capturedsoul, itemstore), 60 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(return_soul_warning), user, capturedsoul), 50 SECONDS)
		to_chat(user, "<font color='blue'>一股寒意顺着我的脊背爬下，有某种可怖之物已经到来。</font>")
		return ..()

/obj/effect/proc_holder/spell/targeted/soulspeak/proc/return_soul_warning(mob/user, mob/living/carbon/spirit/soul)
	if(!QDELETED(user))
		to_chat(user, span_warning("那道灵魂正被拉扯离去……"))
	if(!QDELETED(soul))
		to_chat(soul, span_warning("我开始被拖离此地了……"))

/obj/effect/proc_holder/spell/targeted/soulspeak/proc/return_soul(mob/user, mob/living/carbon/spirit/soul, list/itemstore)
	to_chat(user, "<font color='blue'>那道灵魂回归了冥界。</font>")
	if(QDELETED(soul))
		return
	to_chat(soul, "<font color='blue'>我感觉自己正被送回冥界。</font>")
	soul.drop_all_held_items()
	for(var/obj/effect/landmark/underworld/A in shuffle(GLOB.landmarks_list))
		soul.loc = A.loc
		for(var/I in itemstore)
			soul.put_in_hands(new I())
		break
	soul.beingmoved = FALSE
	soul.fully_heal(FALSE)
	soul.invisibility = initial(soul.invisibility)
	soul.status_flags &= ~GODMODE
	soul.density = initial(soul.density) */

/proc/necra_dir_arrow(dir)
	switch(dir)
		if(NORTH)      return "↑"
		if(SOUTH)      return "↓"
		if(EAST)       return "→"
		if(WEST)       return "←"
		if(NORTHEAST)  return "↗"
		if(NORTHWEST)  return "↖"
		if(SOUTHEAST)  return "↘"
		if(SOUTHWEST)  return "↙"
	return "•"

/proc/necra_repeat_arrow(arrow, count)
	var/result = ""
	for(var/i in 1 to count)
		result += arrow
	return result

/obj/effect/proc_holder/spell/targeted/locate_dead
	name = "寻尸"
	desc = "呼请冥下侍女，为你指引一具迷失灵魂的遗体所在。"
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "locatecorpse"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon_state = "locatecorpse"
	sound = 'sound/magic/whiteflame.ogg'
	releasedrain = 30
	chargedrain = 0.5
	max_targets = 0
	cast_without_targets = TRUE
	miracle = TRUE
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list("冥下侍女，引我去往那些迷失归途者身边。")
	invocation_type = "whisper"
	recharge_time = 15 SECONDS
	devotion_cost = 35

/obj/effect/proc_holder/spell/targeted/locate_dead/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/list/mob/corpses = list()

	for(var/mob/living/C in GLOB.dead_mob_list)
		if(!C.mind)
			continue

		if(istype(C, /mob/living/carbon/human))
			var/mob/living/carbon/human/B = C
			if(B.buried)
				continue

		var/time_dead = 0
		if(C.timeofdeath)
			time_dead = world.time - C.timeofdeath

		var/corpse_name

		if(time_dead < 5 MINUTES)
			corpse_name = "新鲜尸体 "
		else if(time_dead < 10 MINUTES)
			corpse_name = "新近亡者 "
		else if(time_dead < 30 MINUTES)
			corpse_name = "久死之躯 "
		else
			corpse_name = "被遗忘的遗骸，属于 "

		var/list/d_list = C.get_mob_descriptors()
		var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
		var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
		var/descriptor_name = "[trait_desc] [stature_desc]"

		if(descriptor_name == " ")
			descriptor_name = "未知之人"

		corpse_name += "\a [descriptor_name]……"
		corpses[corpse_name] = C

	if(!length(corpses))
		to_chat(user, span_warning("冥下侍女的指引自你手中滑脱了。"))
		revert_cast()
		return .

	var/selected = tgui_input_list(user, "你要寻找哪一具遗体？", "可选遗体", corpses)

	if(!selected || QDELETED(src) || QDELETED(user) || QDELETED(corpses[selected]))
		to_chat(user, span_warning("冥下侍女的牵引忽然脱手了。"))
		return .

	var/mob/living/corpse = corpses[selected]

	var/turf/turf_user = get_turf(user)
	var/turf/turf_corpse = get_turf(corpse)

	if(!turf_user || !turf_corpse)
		to_chat(user, span_warning("冥下侍女的指引自你手中滑脱了。"))
		return .

	var/vertical_text = null
	var/vertical_arrow = null
	var/horizontal_text = null
	var/horizontal_arrow = null

	if(turf_user.z != turf_corpse.z)
		var/z_difference = abs(turf_corpse.z - turf_user.z)

		if(turf_corpse.z > turf_user.z)
			vertical_text = "向上"
			vertical_arrow = necra_repeat_arrow("⇧", z_difference)
		else
			vertical_text = "向下"
			vertical_arrow = necra_repeat_arrow("⇩", z_difference)

	if(turf_user.x != turf_corpse.x || turf_user.y != turf_corpse.y)
		var/direction = get_dir(turf_user, turf_corpse)
		horizontal_arrow = necra_dir_arrow(direction)

		switch(direction)
			if(NORTH)      horizontal_text = "北方"
			if(SOUTH)      horizontal_text = "南方"
			if(EAST)       horizontal_text = "东方"
			if(WEST)       horizontal_text = "西方"
			if(NORTHEAST)  horizontal_text = "东北方"
			if(NORTHWEST)  horizontal_text = "西北方"
			if(SOUTHEAST)  horizontal_text = "东南方"
			if(SOUTHWEST)  horizontal_text = "西南方"

	var/dist = get_dist(turf_user, turf_corpse)
	var/distance_text

	if(dist > 100)
		distance_text = "它的气息显得十分遥远。"
	else if(dist > 50)
		distance_text = "那股牵引正在增强，但仍远在他处。"
	else if(dist > 20)
		distance_text = "你感觉那具尸体已经不算太远。"
	else if(dist > 0)
		distance_text = "那具尸体已经近在咫尺。"
	else
		distance_text = "它就在这里。"

	var/direction_text = ""

	if(vertical_text)
		direction_text += "<br>垂直方向：<b>[vertical_arrow]</b> [vertical_text]"

	if(horizontal_text)
		direction_text += "<br>水平方向：<b>[horizontal_arrow]</b> [horizontal_text]"

	if(!length(direction_text))
		direction_text = "<br><b>•</b> 无法辨明方向"

	var/area/corpse_area = get_area(turf_corpse)
	var/area_text = corpse_area ? corpse_area.name : "某个未知之地"

	to_chat(user, span_notice("冥下侍女正牵引着你的手。[direction_text]<br>[distance_text] 它安息于 <b>[area_text]</b> 之中。"))
