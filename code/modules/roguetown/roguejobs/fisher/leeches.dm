#define MAX_LEECH_EVILNESS 10

/obj/item/natural/worms/leech
	name = "水蛭"
	desc = "一种恶心的吸血寄生虫。"
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "leech"
	dropshrink = 0.8
	baitpenalty = 0
	fishingMods=list(
		"commonFishingMod" = 0.7,
		"rareFishingMod" = 1.3,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1.1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
	)

	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
	)
	/// Consistent AKA no lore
	var/consistent = FALSE
	/// Are we giving or receiving blood?
	var/giving = FALSE
	/// How much blood we waste away on process()
	var/drainage = 1
	/// How much blood we suck on on_embed_life()
	var/blood_sucking = 2
	/// How much toxin damage we heal on on_embed_life()
	var/toxin_healing = -2
	/// Amount of blood we have stored
	var/blood_storage = 0
	/// Maximum amount of blood we can store
	var/blood_maximum = BLOOD_VOLUME_SURVIVE
	// Who are we latching onto?
	var/mob/living/host
	/// Multiplier for extracted blood. Mainly used by Cheeles or equivalent.
	var/blood_multiplier = 1
	/// Whether we can be attached to mindless mobs.
	var/mindless_attach = TRUE

/obj/item/natural/worms/leech/Initialize(mapload)
	. = ..()
	//leech lore
	leech_lore()
	if(drainage)
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/update_icon()
	. = ..()
	icon_state = initial(icon_state)

/obj/item/natural/worms/leech/process()
	if(!drainage && !is_embedded)
		return PROCESS_KILL
	blood_storage = max(blood_storage - drainage, 0)
	if(!is_embedded)
		host = null
		return FALSE
	if(!host)
		return FALSE
	if(!giving && host.stat == DEAD)
		return FALSE
	host.adjustToxLoss(toxin_healing)
	var/obj/item/bodypart/bp = loc
	if(giving)
		var/blood_given = min(BLOOD_VOLUME_MAXIMUM - host.blood_volume, blood_storage, blood_sucking)
		host.blood_volume += blood_given
		blood_storage = max(blood_storage - blood_given, 0)
		if((blood_storage <= 0) || (host.blood_volume >= BLOOD_VOLUME_MAXIMUM))
			if(bp)
				bp.remove_embedded_object(src)
			else
				host.simple_remove_embedded_object(src)
			return TRUE
	else
		var/blood_extracted = min(blood_maximum - blood_storage, host.blood_volume, blood_sucking)
		host.blood_volume = max(host.blood_volume - blood_extracted, 0)
		blood_storage += blood_extracted
		if((blood_storage >= blood_maximum) || (host.blood_volume <= 0))
			if(bp)
				bp.remove_embedded_object(src)
			else
				host.simple_remove_embedded_object(src)
			return TRUE
	return FALSE

/obj/item/natural/worms/leech/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	if(!user)
		return
	user.adjustToxLoss(toxin_healing)
	if(giving)
		var/blood_given = min(BLOOD_VOLUME_MAXIMUM - user.blood_volume, blood_storage, blood_sucking)
		user.blood_volume += blood_given
		blood_storage = max(blood_storage - blood_given, 0)
		if((blood_storage <= 0) || (user.blood_volume >= BLOOD_VOLUME_MAXIMUM))
			if(bodypart)
				bodypart.remove_embedded_object(src)
			else
				user.simple_remove_embedded_object(src)
			return TRUE
	else
		var/blood_extracted = min(blood_maximum - blood_storage, user.blood_volume, blood_sucking)
		user.blood_volume = max(user.blood_volume - blood_extracted, 0)
		blood_storage += blood_extracted * blood_multiplier
		if((blood_storage >= blood_maximum) || (user.blood_volume <= 0))
			if(bodypart)
				bodypart.remove_embedded_object(src)
			else
				user.simple_remove_embedded_object(src)
			return TRUE
	return FALSE

/obj/item/natural/worms/leech/on_embed(obj/item/bodypart/bp)
	if(bp.owner)
		host = bp.owner
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/examine(mob/user)
	. = ..()
	switch(blood_storage/blood_maximum)
		if(0.8 to INFINITY)
			. += span_bloody("<B>[p_theyre(TRUE)]肥硕鼓胀，吸满了鲜血。</B>")
		if(0.5 to 0.8)
			. += span_bloody("[p_theyre(TRUE)]吃得很饱。")
		if(0.1 to 0.5)
			. += span_warning("[p_they(TRUE)]想进食了。")
		if(-INFINITY to 0.1)
			. += span_dead("[p_theyre(TRUE)]饿死了。")
	if(!giving)
		. += span_warning("[p_theyre(TRUE)] [pick("吮吸着", "抽吸着", "吞饮着")]。")
	else
		. += span_notice("[p_theyre(TRUE)] [pick("反呕着", "干呕着", "呼吐着")]。")
	if(drainage)
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/attack(mob/living/M, mob/user)
	if(ishuman(M))
		if(!giving && M.stat == DEAD)
			to_chat(user, span_warning("它们已经死了。只有流动的血液才能被抽取。"))
			return
		if(!giving && !M.mind && !mindless_attach)
			to_chat(user, span_warning("对方毫无意识，[src]不会附着上去。"))
			return
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			return
		if(!get_location_accessible(H, check_zone(user.zone_selected)))
			to_chat(user, span_warning("有东西挡着。"))
			return
		var/used_time = (70 - (user.get_skill_level(/datum/skill/misc/medicine) * 10))/2
		if(!do_mob(user, H, used_time))
			return
		if(!H)
			return
		user.dropItemToGround(src)
		src.forceMove(H)
		affecting.add_embedded_object(src, silent = TRUE, crit_message = FALSE)
		if(M == user)
			user.visible_message(span_notice("[user]把[src]放到了[user.p_their()]的[affecting]上。"), span_notice("我把一只水蛭放到了自己的[affecting]上。"))
		else
			user.visible_message(span_notice("[user]把[src]放到了[M]的[affecting]上。"), span_notice("我把一只水蛭放到了[M]的[affecting]上。"))
		return
	return ..()

/// LEECH LORE... Collect em all!
/obj/item/natural/worms/leech/proc/leech_lore()
	if(consistent)
		return FALSE
	var/static/list/all_colors = list(
		"#9860ff" = 8,
		"#bcff49" = 4,
		"#ffce49" = 2,
		"#79ddff" = 2,
		"#ff7878" = 1,
		"#ff31e4" = 1,
	)
	var/static/list/all_adjectives = list(
		"吸血的" = 20,
		"恶心的" = 10,
		"卑劣的" = 8,
		"令人作呕的" = 4,
		"骇人的" = 4,
		"怪诞的" = 4,
		"丑恶的" = 4,
		"愚蠢的" = 2,
		"呆笨的" = 2,
		"恶魔般的" = 1,
		"graggoid" = 1,
		"zizoid" = 1,
	)
	var/static/list/all_descs = list(
		"真是个恶心的东西。" = 10,
		"恶心得要命。" = 5,
		"滑溜溜的..." = 3,
		"看起来很美味，满是鲜血。" = 3,
		"我喜欢这只水蛭！" = 2,
		"它真漂亮。" = 2,
		"真希望我也是只水蛭。" = 1,
	)
	var/list/possible_adjectives = all_adjectives.Copy()
	var/list/possible_descs = all_descs.Copy()
	var/list/adjectives = list()
	var/list/descs = list()
	var/evilness_rating = rand(0, MAX_LEECH_EVILNESS)
	switch(evilness_rating)
		if(MAX_LEECH_EVILNESS to INFINITY) //maximized evilness holy shit
			color = "#ff0000"
			adjectives += pick("邪恶的", "恶毒的", "憎人的")
			descs += span_danger("这只充满了仇恨！")
		if(5) //this leech is painfully average, it gets no adjectives
			if(prob(3))
				adjectives += pick("平平无奇的", "普通的", "无聊的")
				descs += "这只看起来无聊透顶。"
		if(-INFINITY to 1) //this leech is pretty terrible at being a leech
			adjectives += pick("可怜的", "可悲的", "消沉的")
			descs += span_dead("这只一心求死。")
		else
			var/adjective_amount = 1
			if(prob(5))
				adjective_amount = 3
			else if(prob(30))
				adjective_amount = 2
			for(var/i in 1 to adjective_amount)
				var/picked_adjective = pickweight(possible_adjectives)
				possible_adjectives -= picked_adjective
				adjectives += pickweight(possible_adjectives)
				var/picked_desc = pickweight(possible_descs)
				possible_descs -= picked_desc
				descs += pickweight(possible_descs)
	toxin_healing = min(round((MAX_LEECH_EVILNESS - evilness_rating)/MAX_LEECH_EVILNESS * 2 * initial(toxin_healing), 0.1), -1)
	blood_sucking = max(round(evilness_rating/MAX_LEECH_EVILNESS * 2 * initial(blood_sucking), 0.1), 1)
	if(evilness_rating < 10)
		color = pickweight(all_colors)
	if(length(adjectives))
		name = "[jointext(adjectives, " ")] [name]"
	if(length(descs))
		desc = "[desc] [jointext(descs, " ")]"
	return TRUE

/obj/item/natural/worms/leech/cheele
	name = "奇勒"
	desc = "一只由佩丝特拉亲手造出的美丽生物，会无私地向宿主注入鲜血。"
	icon_state = "cheele"
	color = null
	consistent = TRUE
	drainage = 0
	blood_sucking = 5
	toxin_healing = -2
	blood_multiplier = 3
	blood_storage = BLOOD_VOLUME_BAD
	blood_maximum = BLOOD_VOLUME_NORMAL
	mindless_attach = FALSE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
		"embedded_unsafe_removal_pain_multiplier" = 0,
	) // the humble cheele is gentle. so gentle.

/obj/item/natural/worms/leech/cheele/attack_self(mob/user)
	. = ..()
	giving = !giving
	if(giving)
		user.visible_message(span_notice("[user]挤压了[src]。"),\
							span_notice("我挤压了[src]。它现在会注入血液。"))
	else
		user.visible_message(span_notice("[user]挤压了[src]。"),\
							span_notice("我挤压了[src]。它现在会抽取血液。"))

#undef MAX_LEECH_EVILNESS

/obj/item/natural/worms/leech/attack_right(mob/user)
	return

/obj/item/natural/worms/leech/abyssoid
	name = "深渊水蛭"
	desc = "由阿比索尔亲自降下的神圣水蛭。"
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

/obj/item/natural/worms/leech/abyssoid/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	. = ..()
	if(!user)
		return
	if(iscarbon(user))
		var/mob/living/carbon/V = user
		if(prob(3))
			V.say(pick("赞美 阿比索尔！", "铭记 阿比索尔！", "阿比索尔 长存！", "荣耀归于 阿比索尔！", "阿比索尔 即将降临！"))
