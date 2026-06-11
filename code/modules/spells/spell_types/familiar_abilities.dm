#define MIRACLE_HEALING_FILTER "miracle_heal_glow"
#define CORPSE_SCENT_RANGE 30
#define STARSEERS_CRY_RANGE 7
#define SOOTHING_BLOOM_RANGE 5

/obj/effect/proc_holder/spell/self/message_summoner
	name = "向召唤者传讯"
	recharge_time = 1 SECONDS

/obj/effect/proc_holder/spell/self/message_summoner/cast(list/targets, mob/living/simple_animal/pet/familiar/user)
	. = ..()

	var/mob/living/summoner = user.familiar_summoner

	if(!summoner || !isliving(summoner) || !summoner.mind)
		to_chat(user, span_warning("你无法感知到召唤者的心智。"))
		revert_cast()
		return FALSE

	var/message = input(user, "你建立起了联系。你想说什么？")
	if(!message)
		revert_cast()
		return FALSE
	to_chat_immediate(summoner, "奥术低语滑入我的脑海，最终化作[user.real_name]的声音：<font color=#7246ff>[message]</font>")
	user.visible_message("[user.name]低声念出咒语，嘴边短暂闪过一道白光。")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(summoner)] with contents [message]")
	return TRUE

/obj/effect/proc_holder/spell/self/stillness_of_stone
	name = "石之静寂"
	recharge_time = 1 SECONDS

/obj/effect/proc_holder/spell/self/stillness_of_stone/cast(list/targets, mob/living/simple_animal/pet/familiar/pondstone_toad/user)
	. = ..()
	if(!user)
		revert_cast()
		return FALSE
	if(user.stoneform)
		user.revert_from_stoneform()
	else
		// Save original state if not already saved
		if(!user.original_icon)
			user.original_icon = user.icon
			user.original_icon_state = user.icon_state
			user.original_icon_living = user.icon_living
			user.original_name = user.name

		user.visible_message(
			span_notice("[user.name]骤然静止，身体化作一块石头般的模样。"),
			span_notice("你变得一动不动，如石头般融入周遭环境。")
		)

		user.icon = 'icons/roguetown/items/natural.dmi'
		user.icon_state = "stone1"
		user.icon_living = "stone1"
		user.name = "石头"
		user.stoneform = TRUE
		user.regenerate_icons()
	return TRUE

/mob/living/simple_animal/pet/familiar/pondstone_toad/proc/revert_from_stoneform()
	if(!stoneform)
		return

	icon = original_icon
	icon_state = original_icon_state
	icon_living = original_icon_living
	name = original_name
	stoneform = FALSE

	visible_message(
		span_notice("[src]重新舒展，变回更有生气的蟾蜍模样。"),
		span_notice("你变回了自己的自然形态。")
	)
	regenerate_icons()

/mob/living/simple_animal/pet/familiar/pondstone_toad/Move()
	if(stoneform)
		return FALSE
	return ..()

/mob/living/simple_animal/pet/familiar/pondstone_toad/death()
	. = ..()
	if(stoneform)
		revert_from_stoneform()

/mob/living/simple_animal/pet/familiar/hollow_antlerling/Move()
	. = ..()
	if (prob(60) && isturf(src.loc))
		var/obj/item/glow_petal/petal = new /obj/item/glow_petal(src.loc)
		spawn(rand(50, 60))
			qdel(petal)

/obj/item/glow_petal
	name = "微光花瓣"
	icon = 'icons/roguetown/mob/familiars.dmi'
	icon_state = "leaf_trail"
	anchored = TRUE
	mouse_opacity = 0

	light_outer_range = 2
	light_power = 1
	light_color = rgb(255, 120, 255)
	light_on = TRUE

/obj/effect/proc_holder/spell/self/scent_of_the_grave
	name = "墓冢之息"
	recharge_time = 1 SECONDS

/obj/effect/proc_holder/spell/self/scent_of_the_grave/cast(list/targets, mob/living/simple_animal/pet/familiar/gravemoss_serpent/user)
	. = ..()

	user.visible_message(
		span_notice("[user.name]抬起头，舌头轻颤，细细分辨空气中的气味......"),
		span_notice("你抬起头，在空气中搜寻亡者的气味。")
	)

	var/list/trackable_corpses = list()
	for (var/mob/living/corpse in GLOB.dead_mob_list)
		if(corpse && get_dist(corpse, user) < CORPSE_SCENT_RANGE)
			trackable_corpses += corpse

	if(!trackable_corpses.len)
		to_chat(user,span_notice("你没有察觉到附近有尸体。"))
		return FALSE

	var/mob/living/selected_corpse = input(user, "选择一具要追踪的尸体", "附近的尸体") as null|anything in trackable_corpses
	if(!selected_corpse)
		return FALSE
	if(QDELETED(selected_corpse))
		to_chat(user, span_notice("那股气味已经散去了。"))
		return FALSE
	var/direction_text = dir2text(get_dir(user.loc, selected_corpse.loc))

	user.visible_message(
		span_warning("[user.name]眯起了眼睛。"),
		span_notice("墓冢之息正将你引向[direction_text]。")
	)
	return TRUE

/obj/effect/proc_holder/spell/invoked/blink/glimmer_hare
	invocations = list("") //"Natural" abilty, no incantation.
	chargetime = 0
	releasedrain = 0
	chargedrain = 0
	xp_gain = FALSE

/obj/effect/proc_holder/spell/self/inscription_cache
	name = "铭文藏匣"
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/self/inscription_cache/cast(mob/living/simple_animal/pet/familiar/rune_rat/user)
	. = ..()
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_notice("你必须手里拿着要储存的东西。"))
		revert_cast()
		return FALSE
	if(!(istype(held_item, /obj/item/book) || istype(held_item, /obj/item/paper)))
		to_chat(user, span_notice("只有书写材料才能被储存。"))
		revert_cast()
		return FALSE
	if(length(user.stored_books) >= user.storage_limit)
		to_chat(user, span_notice("你的藏匣已满。先取回一些东西吧。"))
		revert_cast()
		return FALSE

	user.stored_books += held_item
	held_item.forceMove(user) // remove it from the world
	user.visible_message(span_notice("[user.name]将[held_item.name]化作一阵符文微光收了起来。"),span_notice("你将[held_item.name]化作一阵符文微光收了起来。"))
	return TRUE

/obj/effect/proc_holder/spell/self/recall_cache
	name = "唤回藏匣"
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/self/recall_cache/cast(mob/living/simple_animal/pet/familiar/rune_rat/user)
	. = ..()
	if(!length(user.stored_books))
		to_chat(user, "<span class='notice'>你的藏匣是空的。</span>")
		revert_cast()
		return FALSE

	var/obj/item/selected_item = input(user, "选择要取回的物品：", "唤回藏匣") as null|anything in user.stored_books
	if(selected_item)
		if(QDELETED(selected_item))
			to_chat(user, span_warning("那件物品已不可用了。"))
			user.stored_books -= selected_item
			revert_cast()
			return FALSE
		selected_item.forceMove(user.loc)
		user.stored_books -= selected_item
		user.visible_message(span_notice("[selected_item.name]在[user.name]身旁微光一闪，显现出来。"),span_notice("[selected_item.name]在你身旁微光一闪，显现出来。"))
		return TRUE
	else
		revert_cast()
		return FALSE

/mob/living/simple_animal/pet/familiar/rune_rat/death()
	. = ..()
	for (var/obj/item/stored_item in src.stored_books)
		stored_item.forceMove(src.loc)

/obj/effect/proc_holder/spell/self/smolder_shroud
	name = "阴燃烟幕"
	recharge_time = 5 MINUTES
	chargetime = 0

/obj/effect/proc_holder/spell/self/smolder_shroud/cast(list/targets, mob/user)
	. = ..()
	user.visible_message(
		span_warning("[user.name]吐出一团浓厚翻涌的烟幕！"),
		span_warning("你吐出一团浓厚翻涌的烟幕！")
	)
	var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread
	smoke.set_up(2, user)
	smoke.start()
	return TRUE

/obj/effect/proc_holder/spell/self/soothing_bloom
	name = "抚慰花绽"
	recharge_time = 16 SECONDS

/obj/effect/proc_holder/spell/self/soothing_bloom/cast(list/targets, mob/living/simple_animal/pet/familiar/vaporroot_wisp/user)
	. = ..()

	user.visible_message(span_notice("[user.name]释放出一阵抚慰性的雾气。"),span_notice("你释放出一阵抚慰性的雾气。"))
	for (var/mob/living/nearby_mob in view(SOOTHING_BLOOM_RANGE, user))
		if(nearby_mob == user || isdead(nearby_mob))
			continue
		nearby_mob.apply_status_effect(/datum/status_effect/regen/soothing_bloom)
		to_chat(nearby_mob, span_notice("一层清凉薄雾落在你的肌肤上，你感觉伤口正缓缓愈合。"))
	return TRUE

/datum/status_effect/regen/soothing_bloom
	id = "soothing_bloom"
	tick_interval = 40 //This should give it two ticks of 1 healing per person in the radius.
	alert_type = /atom/movable/screen/alert/status_effect/regen/soothing_bloom
	duration = 8 SECONDS
	var/healing_on_tick = 1
	var/outline_colour = "#129160"

/atom/movable/screen/alert/status_effect/regen/soothing_bloom
	name = "抚慰花绽"
	desc = "你的生命值正在缓缓恢复。"

/datum/status_effect/regen/soothing_bloom/on_apply()
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/regen/soothing_bloom/on_remove()
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (filter)
		owner.remove_filter(MIRACLE_HEALING_FILTER)
	return TRUE

/datum/status_effect/regen/soothing_bloom/tick()
	var/obj/effect/temp_visual/heal/heal_effect = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	heal_effect.color = "#129160"
	var/list/wound_count = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+2, BLOOD_VOLUME_NORMAL) //Reduced blood replenishment compared to cleric miracle.
		if(wound_count.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

/obj/effect/proc_holder/spell/self/starseers_cry
	name = "观星者之啼"
	desc = "发出一声刺耳的天穹长鸣，扰乱视野内一切隐于阴影的伪装。"
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/self/starseers_cry/cast(list/targets, mob/living/simple_animal/pet/familiar/starfield_crow/user)
	. = ..()
	user.visible_message(span_danger("[user.name]发出一声刺魂长啼，眼中星辉闪烁！"))

	for (var/mob/living/living_mob in range(STARSEERS_CRY_RANGE, user))
		if (living_mob == user)
			continue

		var/invis_active = living_mob.mob_timers[MT_INVISIBILITY] > world.time
		var/sneaking = living_mob.m_intent == MOVE_INTENT_SNEAK

		if (invis_active || sneaking)
			living_mob.update_sneak_invis(reset = TRUE)
			living_mob.visible_message(span_danger("[living_mob.name]被宇宙脉冲显露了出来！"), span_notice("你感觉自己的隐匿被灼烧殆尽。"))
			found_ping(get_turf(living_mob), user.client, "hidden")

	return TRUE

/obj/effect/proc_holder/spell/invoked/pyroclastic_puff
	name = "火屑喷吐"
	recharge_time = 1 SECONDS
	sound = list('sound/magic/whiteflame.ogg')

/obj/effect/proc_holder/spell/invoked/pyroclastic_puff/cast(list/targets, mob/user)
	. = ..()
	if (!targets || !targets.len)
		to_chat(user, span_warning("未选定有效目标。"))
		revert_cast()
		return FALSE
	if (isturf(targets[1]))
		var/turf/front_turf = get_step(user, user.dir)
		var/datum/effect_system/spark_spread/spark_spread_effect = new()
		user.flash_fullscreen("whiteflash")
		flick("flintstrike", src)
		spark_spread_effect.set_up(1, 1, front_turf)
		spark_spread_effect.start()
		user.visible_message(span_notice("[user.name]吐出一阵发光火星！"), span_notice("你吐出一小团烬火微光。"))
		return TRUE
	else
		var/atom/target_atom = targets[1]
		if (user.Adjacent(target_atom))
			user.flash_fullscreen("whiteflash")
			flick("flintstrike", src)
			target_atom.spark_act()
			user.visible_message(span_notice("[user.name]朝[target_atom]吐出一道定向火星！"), span_notice("你朝[target_atom]放出一点炽烬。"))
			return TRUE
		else
			to_chat(user, span_warning("距离太远，你无法点燃那个目标。"))
			revert_cast()
			return FALSE

/obj/effect/proc_holder/spell/self/verdant_sprout
	name = "苍翠萌芽"
	recharge_time = 1 MINUTES

/obj/effect/proc_holder/spell/self/verdant_sprout/cast(list/targets, mob/user)
	. = ..()
	var/turf/target_turf = get_step(user, user.dir)

	if(!isturf(target_turf))
		to_chat(user, span_warning("你无法在这里催生植物。"))
		revert_cast()
		return FALSE

	// Turn dirt to grass
	if(istype(target_turf, /turf/open/floor/rogue/dirt))
		target_turf.ChangeTurf(/turf/open/floor/rogue/grass)
		user.visible_message(span_notice("藤蔓在[user.name]面前蜿蜒爬行，从泥土中催生出新草。"), span_notice("藤蔓在你面前蜿蜒爬行，从泥土中催生出新草。"))
		return TRUE

	// Add bush to existing grass tile if empty
	if(istype(target_turf, /turf/open/floor/rogue/grass))
		var/has_structures = FALSE
		for(var/obj/structure/structure_obj in target_turf)
			has_structures = TRUE
			break

		if(!has_structures)
			new /obj/structure/flora/roguegrass/bush(target_turf)
			to_chat(user, span_notice("一株小灌木从草地上缓缓长起。"))
			return TRUE
		else
			to_chat(user, span_warning("那个位置已经被占用了。"))
			return FALSE

	to_chat(user, span_warning("什么都没有发生。"))
	return FALSE

/obj/effect/proc_holder/spell/self/phantasm_fade
	name= "幻影消隐"
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/phantasm_fade/cast(list/targets, mob/living/simple_animal/pet/familiar/whisper_stoat/user)
	. = ..()
	user.visible_message(span_warning("[user.name]开始在空气中淡去！"), span_notice("你开始变得隐形！"))
	animate(user, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	user.mob_timers[MT_INVISIBILITY] = world.time + 15 SECONDS
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 15 SECONDS)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[user.name]重新显现出来。"), span_notice("你重新显形了。")), 15 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/phantom_flicker
	name= "幻影闪烁"
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/phantom_flicker/cast(list/targets, mob/living/simple_animal/pet/familiar/ripplefox/user)
	. = ..()

	var/mob/living/simple_animal/pet/familiar/ripplefox/illusory_familiar = new user.type(user.loc)
	user.visible_message(span_notice("[user.name]的身影一阵模糊，同时朝两个方向窜了出去！"))

	illusory_familiar.familiar_summoner = user
	illusory_familiar.fully_replace_character_name(null, user.name)

	// Schedule deletion safely with global context
	addtimer(CALLBACK(GLOBAL_PROC, /proc/delete_illusory_fam, illusory_familiar, user), 200)

	return TRUE

/proc/delete_illusory_fam(mob/living/simple_animal/pet/familiar/ripplefox/illusory_familiar, mob/user)
	if(illusory_familiar && !QDELETED(illusory_familiar))
		user.visible_message(span_notice("[illusory_familiar.name]一阵闪烁，随即化为虚无。"))
		qdel(illusory_familiar)

/obj/effect/proc_holder/spell/self/lurking_step
	name = "潜踪留痕"
	desc = "为此地留下一个名字，将其系于你的隐秘踪径。"
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/self/lurking_step/cast(list/targets, mob/living/simple_animal/pet/familiar/mist_lynx/user)
	. = ..()
	if (!user.saved_trails)
		user.saved_trails = list()
	var/spot_name = input(user, "为这个地点命名，方便日后返回：", "标记踪径") as text|null
	if (!spot_name)
		return FALSE
	// Prevent duplicate names
	for (var/trail_entry in user.saved_trails)
		if (trail_entry["name"] == spot_name)
			to_chat(user, span_warning("你已经有一条名为“[spot_name]”的踪径了。请换个名字。"))
			revert_cast()
			return FALSE
	// Prevent duplicate locations
	for (var/trail_entry in user.saved_trails)
		if (trail_entry["loc"] == user.loc)
			to_chat(user, span_warning("你已经在这个地点留下过踪径了。"))
			revert_cast()
			return FALSE
	// Limit to 3 entries
	if (user.saved_trails.len >= 3)
		user.saved_trails.Remove(user.saved_trails[1])
	user.saved_trails += list(list("name" = spot_name, "loc" = user.loc))
	to_chat(user, span_notice("你凝神静气，将此地刻入了自己的隐秘路径。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/veilbound_shift
	name = "帷径迁跃"
	desc = "消失无踪，并在你先前标记过的一条隐秘踪径处重现。"
	chargetime = 20
	recharge_time = 1 MINUTES

/obj/effect/proc_holder/spell/invoked/veilbound_shift/cast(list/targets, mob/living/simple_animal/pet/familiar/mist_lynx/user)
	. = ..()
	if (!user.saved_trails || !user.saved_trails.len)
		to_chat(user, span_warning("你没有任何可供返回的已标记路径。"))
		revert_cast()
		return FALSE

	var/list/trail_names = list()
	for (var/trail_entry in user.saved_trails)
		trail_names += trail_entry["name"]

	var/selected_trail_name = input(user, "选择一条要返回的隐秘踪径：", "帷径迁跃") as null|anything in trail_names
	if (!selected_trail_name)
		revert_cast()
		return FALSE

	var/target_location
	for (var/trail_entry in user.saved_trails)
		if (trail_entry["name"] == selected_trail_name)
			target_location = trail_entry["loc"]
			break

	if (!(isturf(target_location) || isopenturf(target_location)))
		to_chat(user, span_warning("那条路径已经消散了......"))
		// Remove the invalid entry by name
		for (var/i = 1, i <= user.saved_trails.len, i++)
			if (user.saved_trails[i]["name"] == selected_trail_name)
				user.saved_trails.Cut(i, i+1)
				break
		revert_cast()
		return FALSE

	user.visible_message(span_emote("[user.name]的轮廓逐渐模糊，如雾般消散。"))

	spawn(20)
		// Re-find the entry by name to ensure it's still valid
		var/current_index = 0
		for (var/i = 1, i <= user.saved_trails.len, i++)
			if (user.saved_trails[i]["name"] == selected_trail_name)
				current_index = i
				break
		if (!(isturf(target_location) || isopenturf(target_location)))
			to_chat(user, span_warning("那条路径已经消散了......"))
			if (current_index)
				user.saved_trails.Cut(current_index, current_index+1)
			return
		do_teleport(user, target_location, forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC)
		user.visible_message(span_emote("空气中一阵涟漪凝成了毛皮与爪影。[user.name]悄无声息地现身了。"))

	return TRUE

/obj/effect/proc_holder/spell/self/verdant_veil
	name = "苍翠帷幕"
	desc = "以幻象隐形笼罩附近盟友，但一旦移动或行动便会解除。"
	recharge_time = 30 SECONDS

//I wanted a long duration aoe invisibility that would be broken by movement. But I can't make it work so, short duration it is.
/obj/effect/proc_holder/spell/self/verdant_veil/cast(list/targets, mob/living/simple_animal/pet/familiar/hollow_antlerling/user)
	. = ..()
	to_chat(user, span_notice("你吐出一团闪烁着林野幻影的雾云......"))
	user.visible_message(span_warning("[user.name]释放出一阵发光的旋叶！"), span_notice("你感到森林的寂静笼罩了自己。"))

	for (var/mob/living/nearby_mob in range(1, user))
		if (nearby_mob == user || isobserver(nearby_mob))
			continue

		if (nearby_mob.anti_magic_check(TRUE, TRUE))
			continue

		nearby_mob.visible_message(span_warning("[nearby_mob]开始在空气中淡去！"), span_notice("你开始变得隐形！"))
		animate(nearby_mob, alpha = 0, time = 1 SECONDS, easing = EASE_IN)

		nearby_mob.mob_timers[MT_INVISIBILITY] = world.time + 5 SECONDS
		// Apply invis and visual feedback
		nearby_mob.update_sneak_invis()

		// Schedule end of duration
		addtimer(CALLBACK(nearby_mob, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), 5 SECONDS)

	return TRUE


#undef MIRACLE_HEALING_FILTER
#undef CORPSE_SCENT_RANGE
#undef STARSEERS_CRY_RANGE
#undef SOOTHING_BLOOM_RANGE
