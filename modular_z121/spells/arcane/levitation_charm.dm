// modular_z121 自定义奥术法术：漂浮咒
// 仅在 modular_z121 内实现，不改动主线投射法术或飞行系统。

/proc/z121_get_levitation_duration(mob/living/user)
	var/arcane_level = max(user?.get_skill_level(/datum/skill/magic/arcane), 0)
	switch(arcane_level)
		if(0 to 1)
			return 30 SECONDS
		if(2)
			return 60 SECONDS
		if(3)
			return 120 SECONDS
		if(4)
			return 240 SECONDS
		if(5)
			return 480 SECONDS
	return 960 SECONDS

/atom/movable/screen/alert/status_effect/buff/levitation
	name = "漂浮咒"
	desc = "轻盈魔力正托举着我的身躯，让我只能在当前层级悬浮移动。"
	icon_state = "buff"

/datum/status_effect/buff/levitation
	id = "z121_levitation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/levitation
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	var/apply_message = "轻柔的漂浮魔力托住了我的身躯，我不由自主地离开了地面。"
	var/remove_message = "托举着我的漂浮魔力渐渐散去，我也重新落回地面。"
	var/ending_warning_message = "托举着我的漂浮魔力只剩不到 10 秒了。"
	var/mob/living/flier
	var/was_floating = FALSE
	var/ending_warning_sent = FALSE

/datum/status_effect/buff/levitation/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	return ..()

/datum/status_effect/buff/levitation/refresh(mob/living/new_owner, new_duration = null)
	ending_warning_sent = FALSE
	if(isnull(new_duration))
		return ..()
	duration = world.time + new_duration

/datum/status_effect/buff/levitation/on_apply()
	. = ..()
	flier = owner
	if(!flier)
		return FALSE

	was_floating = !!(flier.movement_type & FLOATING)
	// 漂浮只给予 FLOATING，不授予 FLYING，因此无法进行上下层 zMove。
	flier.float(TRUE)
	ADD_TRAIT(flier, TRAIT_INFINITE_STAMINA, MAGIC_TRAIT)
	to_chat(flier, span_notice(apply_message))
	return TRUE

/datum/status_effect/buff/levitation/on_remove()
	. = ..()
	if(!flier)
		return

	if(!was_floating)
		flier.float(FALSE)
	REMOVE_TRAIT(flier, TRAIT_INFINITE_STAMINA, MAGIC_TRAIT)
	to_chat(flier, span_warning(remove_message))
	flier = null

/datum/status_effect/buff/levitation/tick()
	if(!flier || duration == -1 || ending_warning_sent)
		return
	if(duration - world.time > 10 SECONDS)
		return

	ending_warning_sent = TRUE
	to_chat(flier, span_warning(ending_warning_message))

/obj/effect/proc_holder/spell/invoked/levitation_charm
	name = "漂浮咒"
	desc = "直接以轻盈魔力托起 7 格内的活物，让其只能在当前层级漂浮移动；持续时间随施法者的奥术造诣提升。"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "levitation_charm"
	range = 7
	sound = list('sound/magic/vlightning.ogg')
	releasedrain = 1
	chargedrain = 0
	chargetime = 0
	recharge_time = 3 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocations = list("羽加迪姆勒维奥萨！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 0
	chargedloop = null
	associated_skill = /datum/skill/magic/arcane
	cost = 2
	miracle = FALSE
	xp_gain = TRUE

/obj/effect/proc_holder/spell/invoked/levitation_charm/cast(list/targets, mob/living/user = usr)
	if(user?.curplaying)
		user.curplaying.on_mouse_up()

	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("漂浮咒只能对活物施放。"))
		revert_cast()
		return FALSE

	var/mob/living/living_target = target_atom
	if(!apply_levitation_to_target(living_target, user))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/levitation_charm/proc/apply_levitation_to_target(mob/living/living_target, mob/living/user)
	var/levitation_duration = z121_get_levitation_duration(user)
	if(living_target.anti_magic_check())
		living_target.visible_message(span_warning("[living_target] 周身泛起一圈反魔法涟漪，将浅蓝色的漂浮魔力尽数震散！"))
		to_chat(user, span_warning("[living_target] 身上的反魔法抵消了漂浮咒。"))
		playsound(get_turf(living_target), 'sound/magic/magic_nulled.ogg', 100)
		return FALSE

	var/datum/status_effect/buff/magic_flight/existing_flight = living_target.has_status_effect(/datum/status_effect/buff/magic_flight)
	var/datum/status_effect/buff/levitation/existing_levitation = living_target.has_status_effect(/datum/status_effect/buff/levitation)
	var/already_levitating = !!existing_levitation
	var/has_other_flight = (living_target.movement_type & FLYING) && !existing_flight
	var/remaining_flight_time = 0
	if(existing_flight?.duration == -1)
		remaining_flight_time = INFINITY
	else if(existing_flight)
		remaining_flight_time = max(existing_flight.duration - world.time, 0)
	var/remaining_levitation_time = 0
	if(existing_levitation?.duration == -1)
		remaining_levitation_time = INFINITY
	else if(existing_levitation)
		remaining_levitation_time = max(existing_levitation.duration - world.time, 0)

	if(existing_flight)
		playsound(get_turf(living_target), 'sound/magic/whiteflame.ogg', 80, TRUE)
		if(remaining_flight_time == INFINITY)
			living_target.visible_message(span_notice("[user] 轻轻一指，[living_target] 周身的浮空魔力微微一颤，但原本的永久飞行魔法仍稳稳托着 [living_target.p_them()]。"))
			to_chat(living_target, span_notice("浅蓝色魔力短暂缠上了我的身体，但我身上原有的永久飞行魔法并未被更换。"))
		else
			living_target.visible_message(span_notice("[user] 轻轻一指，[living_target] 周身的浮空魔力微微一颤，但原本的飞行魔法仍稳稳托着 [living_target.p_them()]。"))
			to_chat(living_target, span_notice("浅蓝色魔力短暂缠上了我的身体，但我身上原有的飞行魔法并未被更换。"))
		to_chat(user, span_notice("我试图以漂浮咒托起 [living_target]，但 [living_target.p_their()] 身上原有的飞行魔法更强。"))
		return TRUE
	if(existing_levitation && remaining_levitation_time >= levitation_duration)
		playsound(get_turf(living_target), 'sound/magic/whiteflame.ogg', 80, TRUE)
		living_target.visible_message(span_notice("[user] 再度引动浅蓝魔光，但 [living_target] 身上的漂浮咒原本就还能持续更久。"))
		to_chat(living_target, span_notice("新的漂浮咒短暂触及了我，但我身上的漂浮魔力本就还能维持更久。"))
		to_chat(user, span_notice("[living_target] 身上的漂浮魔力原本就还能维持更久，无需覆盖。"))
		return TRUE
	if(has_other_flight)
		playsound(get_turf(living_target), 'sound/magic/whiteflame.ogg', 80, TRUE)
		living_target.visible_message(span_notice("[user] 指尖的浅蓝魔力一触即散，因为 [living_target] 原本就靠其他飞行力量停留在空中。"))
		to_chat(living_target, span_notice("浅蓝色魔力短暂缠上了我的身体，但我原本就靠其他飞行力量停留在空中。"))
		to_chat(user, span_notice("[living_target] 原本就靠其他飞行力量停留在空中，漂浮咒没有覆盖它。"))
		return TRUE

	// 漂浮咒与飞行术分离：若目标已有飞行术，则保持飞行术优先，漂浮咒只在没有完整飞行时生效。
	living_target.apply_status_effect(/datum/status_effect/buff/levitation, levitation_duration)
	playsound(get_turf(living_target), 'sound/magic/whiteflame.ogg', 80, TRUE)
	if(already_levitating)
		living_target.visible_message(span_notice("[user] 再度引动浅蓝魔光，[living_target] 身上的漂浮咒托举之力被重新续上了。"))
		to_chat(living_target, span_notice("环绕着我的漂浮魔力再次充盈起来。"))
		to_chat(user, span_notice("我重新续上了 [living_target] 身上的漂浮咒。"))
	else if(living_target == user)
		user.visible_message(span_notice("[user] 周身泛起一圈浅蓝魔光，整个人顿时轻飘飘地离开了地面。"))
		to_chat(user, span_notice("一股轻盈的魔力托住了我的身体，让我漂浮起来。"))
	else
		user.visible_message(span_notice("[user] 指尖一点，[living_target] 周身顿时缠上浅蓝魔光，整个人轻飘飘地离开了地面。"))
		to_chat(user, span_notice("我将一股轻盈魔力系在 [living_target] 身上，让 [living_target.p_them()] 漂浮起来。"))
		to_chat(living_target, span_notice("一股轻盈的魔力忽然托住了我的身体，让我漂浮起来。"))
	return TRUE
