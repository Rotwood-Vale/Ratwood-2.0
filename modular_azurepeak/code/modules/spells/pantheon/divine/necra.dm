#define CHURN_FILTER "churn_glow"

// T1: Avert End (channel on an adjacent target to slowly spend devotion to grant them NODEATH and ticks of oxyloss healing)

/obj/effect/proc_holder/spell/invoked/avert
	name = "借来时光"
	desc = "为同伴挡住冥下少女的注视，只要你的信仰与体力尚能支撑，便可阻止他们滑入死亡。"
	overlay_state = "borrowtime"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 10
	var/list/near_death_lines = list(
		"一阵朦胧薄雾开始将我包裹，却又突然退去，仿佛被某道伟大的光辉驱散......",
		"一股可怖的重压落在我身上，仿佛整个世界都正以它的重量将我碾碎......",
		"平静河流的声音飘入耳中，随后便是摆渡人阴森的钟鸣......",
		"某个庞大到无法估量、远在感知之外的存在正耸立于彼端。我感受到它，甚于看见它。它在等待。它在注视。",
	)

/obj/effect/proc_holder/spell/invoked/avert/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	var/atom/target = targets[1]
	if (!isliving(target))
		revert_cast()
		return FALSE

	var/mob/living/living_target = target
	if (!user.Adjacent(target))
		to_chat(user, span_warning("我必须站在[living_target]身旁，才能替[living_target.p_them()]挡开她的注视！"))
		revert_cast()
		return FALSE

	// add the no-death trait to them....
	user.visible_message(span_notice("当[user]将手伸向[living_target]近旁时，低语般的光点自[user]指间缓缓凝出，冥下少女的经文也从[user.p_their()]唇边流泻而出......"), span_notice("我立于[living_target]身旁，低诵那永世代求的神圣词句，再多拖住她的手片刻......"))
	to_chat(user, span_small("我必须保持静止，守在[living_target]身边......"))
	to_chat(living_target, span_warning("一种奇异的感觉在我胸口绽开，寒冷而陌生......"))

	ADD_TRAIT(living_target, TRAIT_NODEATH, "avert_spell")

	var/our_holy_skill = user.get_skill_level(associated_skill)
	var/tickspeed = 30 + (5 * our_holy_skill)

	while (do_after(user, tickspeed, target = living_target))
		user.stamina_add(2.5)

		living_target.adjustOxyLoss(-10)
		living_target.blood_volume = max((BLOOD_VOLUME_SURVIVE * 1.5), living_target.blood_volume)

		if (living_target.health <= 5)
			if (prob(5))
				to_chat(living_target, span_small(pick(near_death_lines)))

		if (user.devotion?.check_devotion(src))
			user.devotion?.update_devotion(-10)
		else
			to_chat(span_warning("我的虔诚耗尽了，代求之词自我唇边消散！"))
			break

	REMOVE_TRAIT(living_target, TRAIT_NODEATH, "avert_spell")

	user.visible_message(span_danger("[user]的专注中断了，那些光点从[living_target]身边退回，再度归入[user.p_their()]掌中。"), span_danger("我的专注断裂了，代求也归于沉寂。"))

/obj/effect/proc_holder/spell/targeted/abrogation
	name = "斥绝"
	desc = "只要目标亡灵仍停留在你附近，便会持续遭受削弱，久留者还会慢慢被点燃。"
	range = 8
	overlay_state = "necra"
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 50
	chargedrain = 0.5
	recharge_time = 30 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("冥下少女厌弃你们！")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/targeted/abrogation/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/debuff_power = 1
	if (user && user.mind)
		debuff_power = clamp((user.get_skill_level(/datum/skill/magic/holy) / 2), 1, 3)

	var/too_powerful = FALSE
	var/list/things_to_churn = list()
	var/list/things_to_stun = list()
	for (var/mob/living/L in targets)
		var/is_vampire = FALSE
		var/is_zombie = FALSE
		if(L.stat == DEAD)
			continue
		if (L.mind)
			var/datum/antagonist/vampire/V = L.mind.has_antag_datum(/datum/antagonist/vampire)
			if(V && SEND_SIGNAL(L, COMSIG_DISGUISE_STATUS))
				is_vampire = TRUE
			if (L.mind.has_antag_datum(/datum/antagonist/zombie))
				is_zombie = TRUE
				things_to_stun += L
			if (L.mind.special_role == "Vampire Lord")
				too_powerful = L
				user.visible_message(span_warning("[user]面对某个不可见的存在突然面色惨白，猛地倒抽一口气！"), span_warning("奔涌的血流声灌满了我的耳朵与脑海，将我的斥绝祷词彻底淹没！"))
				break
		if (L.mob_biotypes & MOB_UNDEAD || is_vampire || is_zombie)
			things_to_churn += L

	if (!too_powerful)
		if (LAZYLEN(things_to_churn))
			user.visible_message(span_warning("[user]的双眼骤然爆出冰寒蓝芒，低声祈祷唤出了盘旋缠绕的幽灵迷雾！"), span_notice("我施行神圣的斥绝之仪，引来她的侍从骚扰并削弱那些不死之物！"))
			for(var/mob/living/thing in things_to_churn)
				thing.apply_status_effect(/datum/status_effect/churned, user, debuff_power)
		if(LAZYLEN(things_to_stun))
			for(var/mob/living/thing in things_to_churn)
				thing.Stun(100)
				thing.Knockdown(50)
				thing.emote("scream")
		if(!LAZYLEN(things_to_churn))
			to_chat(user, span_notice("斥绝之仪自我唇边悄然流过，却没找到任何可供驱逐之物。"))
			return
	else
		user.Stun(25)
		user.throw_at(get_ranged_target_turf(user, get_dir(user,too_powerful), 7), 7, 1, too_powerful, spin = FALSE)
		user.visible_message(span_warning("[user]的祈祷骤然中断，喉间猛地呛出一口鲜血！"), span_boldwarning("我的视野被一片猩红淹没！"))

/atom/movable/screen/alert/status_effect/churned
	name = "翻搅精魂"
	desc = "维系我存在的魔力正在被扰乱！我得尽快远离源头！"
	icon_state = "stressvb"

/datum/status_effect/churned
	id = "necra_churned"
	alert_type = /atom/movable/screen/alert/status_effect/churned
	duration = 30 SECONDS
	examine_text = "<b>SUBJECTPRONOUN周身缠绕着一阵狂乱翻腾的幽魂微光！</b>"
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -2, STATKEY_SPD = -2)
	status_type = STATUS_EFFECT_REFRESH
	var/datum/weakref/debuffer
	var/outline_colour = "#33cabc"
	var/base_tick = 0.2
	var/intensity = 1
	var/range = 10

/datum/status_effect/churned/on_creation(mob/living/new_owner, mob/living/caster, potency)
	intensity = potency
	if (caster)
		debuffer = WEAKREF(caster)
	return ..()

/datum/status_effect/churned/on_apply()
	var/filter = owner.get_filter(CHURN_FILTER)
	to_chat(owner, span_warning("微光从黏稠迷雾中跃出，将我团团围住；那股寒意正在扰乱我的身体！快逃！"))
	if (!filter)
		owner.add_filter(CHURN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	return TRUE

/datum/status_effect/churned/refresh()
	. = ..()
	intensity += 1
	to_chat(owner, span_boldwarning("迷雾变得更浓了，那些发亮的幽光正持续扰乱我的身体......"))

/datum/status_effect/churned/process()
	. = ..()
	if (!owner)
		return
	if (prob(33))
		owner.adjustFireLoss(base_tick * intensity)
	if (prob(10))
		to_chat(owner, span_warning("一阵狂乱的幽魂微光正在袭扰我的身躯！"))
		owner.emote("scream")

	var/mob/living/our_debuffer = debuffer.resolve()
	if (get_dist(our_debuffer, owner) > range)
		to_chat(owner, span_notice("我逃出那团黏稠迷雾了！"))
		qdel(src)

/datum/status_effect/churned/on_remove()
	owner.remove_filter(CHURN_FILTER)

#undef CHURN_FILTER


/obj/effect/proc_holder/spell/invoked/necra_vow
	name = "向内克拉立誓"
	desc = "向内克拉立下誓言。你被复活或恢复断肢的可能性将大幅降低，但你将伤害不死者，并缓慢治疗自己。"
	range = 1
	overlay_state = "necra"
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 50
	chargedrain = 0.5
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("冥下少女护佑。")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/necra_vow/cast(list/targets, mob/living/user = usr)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/H = targets[1]
		if(HAS_TRAIT(H, TRAIT_ROTMAN) || HAS_TRAIT(H, TRAIT_NOBREATH) || H.mob_biotypes & MOB_UNDEAD)	//No Undead, no Rotcured, no Deathless
			to_chat(user, span_warning("内克拉不在乎腐化者的誓言。"))
			revert_cast()
			return FALSE
		if(H.has_status_effect(/datum/status_effect/buff/necras_vow) || H.patron?.type != /datum/patron/divine/necra)
			to_chat(user, span_notice("他们已经立下誓言了。"))
			revert_cast()
			return FALSE
		var/choice = alert(H, "有人要求你立下誓言。你被复活或恢复断肢的可能性将大幅降低，但你将伤害不死者，并缓慢治疗自己。你同意吗？", "誓言", "同意", "拒绝")
		if(choice != "同意")
			to_chat(user, span_notice("他们拒绝了。"))
			return TRUE
		user.visible_message(span_warning("[user]将誓言的祝福赐予了[H]。"))
		to_chat(H, span_warning("我已经立誓。再无回头路。"))
		H.apply_status_effect(/datum/status_effect/buff/necras_vow)
		H.apply_status_effect(/datum/status_effect/buff/healing/necras_vow)

/atom/movable/screen/alert/status_effect/buff/necras_vow
	name = "向内克拉立誓"
	desc = "我已向内克拉立下誓言。不死者若敢伤我，便会受创或燃烧。腐朽不再能夺走我。失去的肢体也只能接回属于我自己的那部分。"
	icon_state = "necravow"

#define NECRAVOW_FILTER "necravow_glow"

/datum/status_effect/buff/necras_vow
	var/outline_colour ="#929186" // A dull grey.
	id = "necravow"
	alert_type = /atom/movable/screen/alert/status_effect/buff/necras_vow
	effectedstats = list(STATKEY_CON = 2)
	duration = -1

/datum/status_effect/buff/necras_vow/on_apply()
	. = ..()
	var/filter = owner.get_filter(NECRAVOW_FILTER)
	if (!filter)
		owner.add_filter(NECRAVOW_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	ADD_TRAIT(owner, TRAIT_NECRAS_VOW, TRAIT_MIRACLE)
	owner.rot_type = null
	to_chat(owner, span_warning("我的四肢比以往任何时候都更像活着一般......我感到自己完整无缺......"))

/datum/status_effect/buff/necras_vow/on_remove()
	. = ..()
	owner.remove_filter(NECRAVOW_FILTER)
	to_chat(owner, span_warning("我的身体感觉怪异......空洞......"))

#undef NECRAVOW_FILTER

/obj/effect/proc_holder/spell/invoked/necras_sight
	name = "内克拉之视"
	desc = "标记一座普赛圣十字或墓碑，并透过它们窥视。"
	releasedrain = 30
	chargetime = 0 SECONDS
	recharge_time = 10 SECONDS
	warnie = "spellwarning"
	invocation_type = "whisper"
	invocations = list("冥下少女，请引导我的目光......")
	associated_skill = /datum/skill/magic/holy
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "necraeye"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	action_icon_state = "necraeye"
	miracle = TRUE
	devotion_cost = 30
	range = 1
	var/static/list/whitelisted_objects = list(/obj/structure/gravemarker, /obj/structure/fluff/psycross, /obj/structure/fluff/psycross/copper, /obj/structure/fluff/psycross/crafted)
	var/list/marked_objects = list()
	var/outline_color = "#4ea1e6"
	var/last_index = 1

/obj/effect/proc_holder/spell/invoked/necras_sight/cast(list/targets, mob/user)
	var/success
	if(isobj(targets[1]))
		var/obj/O = targets[1]
		if((O.type in whitelisted_objects))
			add_to_scry(O, user)
			return TRUE
	if(isturf(targets[1]))
		var/turf/T = targets[1]
		for(var/obj/O in T)
			if((O.type in whitelisted_objects))
				add_to_scry(O, user)
				return TRUE
		if(length(marked_objects))
			success = try_scry(user)
	if(ismob(targets[1]))
		if(length(marked_objects))
			success = try_scry(user)
	if(success)
		return TRUE
	revert_cast()
	return FALSE

#define GRAVE_SPY "grave_spy"

/obj/effect/proc_holder/spell/invoked/necras_sight/proc/try_scry(mob/living/carbon/human/user)
	listclearnulls(marked_objects)

	if(!length(marked_objects))
		return FALSE

	// Build a display list: label -> obj
	var/list/choices = list()
	for(var/obj/O as anything in marked_objects)
		choices[marked_objects[O]] = O

	var/choice = input(user, "我们要透过哪座坟墓窥视？", "") as null|anything in choices
	if(!choice)
		return FALSE

	var/obj/structure/gravemarker/spygrave = choices[choice]
	if(!spygrave)
		return FALSE

	// Add outline filter if missing
	var/filter = spygrave.get_filter(GRAVE_SPY)
	if(!filter)
		spygrave.add_filter(
			GRAVE_SPY,
			2,
			list(
				"type" = "outline",
				"color" = outline_color,
				"alpha" = 200,
				"size" = 1
			)
		)

	// Create scry eye
	var/mob/dead/observer/screye/S = user.scry_ghost()
	if(!S)
		return FALSE

	spygrave.visible_message(span_warning("[spygrave]闪烁起诡异的幽光。"))
	S.ManualFollow(spygrave)

	user.visible_message(
		span_danger("[user]眨了眨眼，[user.p_their()]的眼珠猛地翻回了[user.p_their()]眼眶深处。")
	)

	user.playsound_local(get_turf(user), 'sound/magic/necra_sight.ogg', 80)

	// Cleanup after duration
	addtimer(
		CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)),
		(8 SECONDS)
	)

	addtimer(
		CALLBACK(spygrave, TYPE_PROC_REF(/atom/movable, remove_filter), GRAVE_SPY),
		(8 SECONDS)
	)

	return TRUE

#undef GRAVE_SPY

/obj/effect/proc_holder/spell/invoked/necras_sight/proc/add_to_scry(obj/O, mob/living/carbon/human/user)
	if(O in marked_objects)
		marked_objects.Remove(O)
		to_chat(user, span_info("你让那座坟墓从记忆中滑走了......"))
		return
	var/holyskill = user.get_skill_level(/datum/skill/magic/holy)
	var/label = input(user, "为你的视野给这座坟墓命名：", "标记神圣之物") as text|null
	if(!label || !length(label))
		label = "[O.name]"

// Replace logic when at cap
	if(length(marked_objects) >= holyskill)
		// Build a display list: label -> obj
		var/list/choices = list()
		for(var/obj/graves as anything in marked_objects)
			choices[marked_objects[graves]] = graves

		var/removing_object = tgui_input_list(user, "我已记住太多坟墓，是否让其中一座从记忆中滑落？", "遗忘", choices, marked_objects[1])

		if(!removing_object)
			to_chat(user, span_warning("我选择什么也不遗忘。"))
			revert_cast()
			return FALSE

		to_chat(user, span_warning("[removing_object]从我脑海中滑落了……")) // show the labled grave first
		removing_object = choices[removing_object] 	// then get the correct object from the label...
		marked_objects -= removing_object 			// ...to remove from the marked list.

	to_chat(user, span_info("我轻声低念一个名字，为这座坟墓留下日后可用的标记......"))
	marked_objects[O] = label

/* /obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance
	name = "Avenging Spirits"
	desc = "Summon rancorous spirits to tear at an opponent!"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeholy
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	hide_charge_effect = TRUE
	miracle = TRUE
	devotion_cost = 50
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "vengeful_spirit"
	action_icon_state = "vengeful_spirit"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	invocations = list("Awaken, rancor!!")
	invocation_type = "shout"

/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(user.dir == SOUTH || user.dir == NORTH)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_turf(user),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, EAST),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, WEST),user)
		else
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_turf(user),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, NORTH),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, SOUTH),user)
		for(var/mob/living/simple_animal/hostile/rogue/spirit_vengeance/swarm in view(2, user))
			swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		return TRUE
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/raise_spirit_respite
	name = "Aspect of Respite"
	desc = "Summon an aspect of respite to relentlessly pursue your foe."
	range = 7
	sound = list('sound/magic/necra_sight.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeholy
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 2 MINUTES
	hide_charge_effect = TRUE
	miracle = TRUE
	devotion_cost = 100
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "aspect"
	action_icon_state = "aspect"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	invocations = list("Awaken, aspect of respite!!")//Someone change this.
	invocation_type = "shout"

/obj/effect/proc_holder/spell/invoked/raise_spirit_respite/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(user.dir == SOUTH || user.dir == NORTH)
			new /mob/living/simple_animal/hostile/rogue/spirit_respite(get_turf(user),user)
		else
			new /mob/living/simple_animal/hostile/rogue/spirit_respite(get_turf(user),user)
		for(var/mob/living/simple_animal/hostile/rogue/spirit_respite/avatar in view(2, user))
			avatar.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		return TRUE
	revert_cast()
	return FALSE
*/

/obj/effect/proc_holder/spell/invoked/necra_crows
	name = "内克拉的乌鸦"
	desc = "召来充满怨念的乌鸦撕扯对手！"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeholy
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	hide_charge_effect = TRUE
	miracle = TRUE
	devotion_cost = 50
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "vengeful_spirit"
	action_icon_state = "vengeful_spirit"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	invocations = list("冥下少女啊，让您黑翼的侍从回应我的呼唤吧！！")
	invocation_type = "shout"

/obj/effect/proc_holder/spell/invoked/necra_crows/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(user.dir == SOUTH || user.dir == NORTH)
			new /mob/living/simple_animal/hostile/rogue/crow_vengeance(get_turf(user), user)
			new /mob/living/simple_animal/hostile/rogue/crow_vengeance(get_step(user, EAST), user)
			new /mob/living/simple_animal/hostile/rogue/crow_vengeance(get_step(user, WEST), user)
		else
			new /mob/living/simple_animal/hostile/rogue/crow_vengeance(get_turf(user), user)
			new /mob/living/simple_animal/hostile/rogue/crow_vengeance(get_step(user, NORTH), user)
			new /mob/living/simple_animal/hostile/rogue/crow_vengeance(get_step(user, SOUTH), user)
		for(var/mob/living/simple_animal/hostile/rogue/crow_vengeance/swarm in view(2, user))
			swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		return TRUE
	revert_cast()
	return FALSE
