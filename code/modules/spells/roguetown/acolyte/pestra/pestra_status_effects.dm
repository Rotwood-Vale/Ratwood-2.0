/datum/status_effect/divine_exhaustion
	id = "divine_exhaustion"
	duration = 20 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/divine_exhaustion
	var/cooldown_end

/datum/status_effect/divine_exhaustion/on_creation(mob/living/new_owner, duration)
	src.duration = duration
	cooldown_end = world.time + duration
	return ..()

/datum/status_effect/divine_exhaustion/on_remove()
	to_chat(owner, span_notice("我感到自己与 Pestra 神力之间的联系正缓缓恢复。"))
	return ..()

/atom/movable/screen/alert/status_effect/divine_exhaustion
	name = "神力耗竭"
	desc = "我方才引导了过多 Pestra 的力量，如今已无法再承载太多她的神圣虫灾。"
	icon_state = "divine_exhaustion"

// The ultimate healing miracle
/datum/status_effect/buff/divine_rebirth_healing
	id = "divine_rebirth_healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_rebirth_healing
	duration = 30 SECONDS // Gradual healing
	tick_interval = 3 SECONDS
	var/time_left
	var/healing_strength = 45
	var/limbs_regenerated = 0
	var/max_limbs_to_regenerate = 3
	var/outline_colour = "#FFD700"
	var/static/list/regenerable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)

#define MIRACLE_HEALING_FILTER "pestra_heal_glow"

/datum/status_effect/buff/divine_rebirth_healing/on_apply()
	. = ..()
	time_left = duration
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_strength, src)
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 100, "size" = 2))
	return TRUE

/datum/status_effect/buff/divine_rebirth_healing/on_remove()
	owner.remove_filter(MIRACLE_HEALING_FILTER)
	return ..()

/datum/status_effect/buff/divine_rebirth_healing/tick()
	var/time_progress = (duration - time_left) / duration
	time_left -= tick_interval
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour
	do_sprite_shake(owner, 3, 3, 15, 1)

	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + healing_strength, BLOOD_VOLUME_NORMAL)

		var/list/wounds = owner.get_wounds()
		if(length(wounds) > 0)
			owner.heal_wounds(healing_strength)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_strength, 0)
		owner.adjustFireLoss(-healing_strength, 0)
		owner.adjustOxyLoss(-healing_strength, 0)
		owner.adjustToxLoss(-healing_strength, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_strength)
		owner.adjustCloneLoss(-healing_strength, 0)

	if(ishuman(owner) && limbs_regenerated < max_limbs_to_regenerate)
		var/mob/living/carbon/human/human_owner = owner
		var/missing_limbs = human_owner.get_missing_limbs()
		var/list/regenerable_missing_limbs = list()
		for(var/limb_zone in missing_limbs)
			if(limb_zone in regenerable_zones)
				regenerable_missing_limbs += limb_zone
		if(length(regenerable_missing_limbs) > 0 && prob(25 + (time_progress * 30)))
			var/limb_to_regrow = pick(regenerable_missing_limbs)
			if(human_owner.regenerate_limb(limb_to_regrow))
				limbs_regenerated++
				human_owner.visible_message(span_info("[human_owner] 的 [limb_to_regrow] 开始重新生长！"), span_info("当我的 [limb_to_regrow] 开始再生时，我感到一阵奇迹般的触感！"))

/datum/status_effect/buff/divine_rebirth_healing/proc/do_sprite_shake(mob/living/target, cycles = 3, intensity = 3, rotation_max = 15, speed = 1)
	if(!target)
		return

	spawn(0)
		for(var/i in 1 to cycles)
			// Randomly offsets
			var/rand_x = rand(-intensity, intensity)
			var/rand_y = rand(-intensity, intensity)

			// Rotation & movement
			animate(target, \
				pixel_y = rand_y, \
				pixel_x = rand_x, \
				time = speed, \
				easing = LINEAR_EASING)
			sleep(speed)

		animate(target, \
			pixel_y = 0, \
			pixel_x = 0, \
			time = speed, \
			easing = LINEAR_EASING)

#undef MIRACLE_HEALING_FILTER

/atom/movable/screen/alert/status_effect/buff/divine_rebirth_healing
	name = "神圣重生"
	desc = "奇迹般的神圣能量正在治愈我的伤势，并让我的肢体重新生长。"
	icon_state = "divine_heal"

/datum/status_effect/buff/pestra_care
	id = "pestra_care"
	alert_type = /atom/movable/screen/alert/status_effect/buff/pestra_care
	duration = 10 MINUTES
	tick_interval = 20 SECONDS
	var/healing_strength = 7.5
	var/effect_colour = "#005532"

/datum/status_effect/buff/pestra_care/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_strength, src)

/datum/status_effect/buff/pestra_care/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = effect_colour

	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + healing_strength, BLOOD_VOLUME_NORMAL)

		var/list/wounds = owner.get_wounds()
		if(length(wounds) > 0)
			owner.heal_wounds(healing_strength)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_strength, 0)
		owner.adjustFireLoss(-healing_strength, 0)
		owner.adjustOxyLoss(-healing_strength, 0)
		owner.adjustToxLoss(-healing_strength, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_strength)
		owner.adjustCloneLoss(-healing_strength, 0)

/atom/movable/screen/alert/status_effect/buff/pestra_care
	name = "Pestra 的拥抱"
	desc = "我体内仿佛有什么在蠕动，可那感觉却让我逐渐好转……"
	icon_state = "divine_heal"

#define PLAGUE_GLOW_FILTER "plague_glow_filter"

/datum/status_effect/debuff/pestilent_plague
	id = "pestilent_plague"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/pestilent_plague
	duration = 60 SECONDS
	tick_interval = 3 SECONDS
	effectedstats = list(
		STATKEY_CON = -1,
		STATKEY_STR = -3,
	)
	var/outline_colour = "#095000"

/datum/status_effect/debuff/pestilent_plague/on_apply()
	. = ..()
	owner.adjustBruteLoss(30)
	to_chat(owner, span_danger("我的身体正被剧烈病痛折磨！"))
	var/filter = owner.get_filter(PLAGUE_GLOW_FILTER)
	if (!filter)
		owner.add_filter(PLAGUE_GLOW_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 90, "size" = 2))

/datum/status_effect/debuff/pestilent_plague/on_remove()
	owner.remove_filter(PLAGUE_GLOW_FILTER)
	. = ..()

/datum/status_effect/debuff/pestilent_plague/tick()
	var/mob/living/target = owner
	target.adjustBruteLoss(2)

	if(prob(10))
		var/message = pick(
			"我的血肉仿佛正从骨头上爬开！",
			"有蠕虫正在我皮肤下翻动！",
			"每一次呼吸都把更多疫病送进了肺里！",
			"我的血液像是被病邪淤堵了一般！",
			"虫群正在啃食我活着的血肉！",
			"我不过是虫子的饵食而已！",
			"疫病正从我体内将我一点点吞噬！")
		to_chat(target, span_danger(message))

/atom/movable/screen/alert/status_effect/debuff/pestilent_plague
	name = "瘟疫缠身"
	desc = "一场凶恶的疫病正在摧残我的身体，带来剧痛与腐朽。"
	icon_state = "debuff_severe"

#undef PLAGUE_GLOW_FILTER

/datum/status_effect/black_rot
	id = "black_rot"
	alert_type = /atom/movable/screen/alert/status_effect/black_rot
	duration = -1 // Permanent until cured
	tick_interval = 1 SECONDS
	var/stacks = 1
	var/tier = 1
	var/progression_timer = 0
	var/base_progression_time = 25 MINUTES // Base time to next tier at 1 stack
	var/next_damage_tick = 0
	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
	)

/datum/status_effect/black_rot/on_creation(mob/living/new_owner, initial_stacks = 4)
	stacks = clamp(initial_stacks, 1, 4)
	progression_timer = world.time + (base_progression_time / stacks)
	. = ..()
	update_alert()

/datum/status_effect/black_rot/on_apply()
	to_chat(owner, span_userdanger("一股深沉而冰冷的腐坏开始在我体内蔓延！"))
	update_effects()
	return TRUE

/datum/status_effect/black_rot/proc/update_alert()
	if(!linked_alert)
		return
	switch(tier)
		if(1)
			linked_alert.name = "黑腐病（潜行）"
			linked_alert.desc = "一层淡淡的黑暗正在我皮肤下扩散。"
			linked_alert.icon_state = "blackrot1"
		if(2)
			linked_alert.name = "黑腐病（溃烂）"
			linked_alert.desc = "腐败已使我的血脉化作漆黑。若再持续下去，我必死无疑。"
			linked_alert.icon_state = "blackrot2"
		if(3)
			linked_alert.name = "黑腐病（沸腾）"
			linked_alert.desc = "我的血肉正在腐烂，骨头也隐隐作痛。皮肤仿佛正在沸腾。"
			linked_alert.icon_state = "blackrot3"
		if(4)
			linked_alert.name = "黑腐病（坏死）"
			linked_alert.desc = "虚无正在吞噬我。我能感觉到骨头正发出呻吟。"
			linked_alert.icon_state = "blackrot4"

/datum/status_effect/black_rot/proc/update_effects()
	var/list/old_stats = effectedstats.Copy()
	effectedstats = list()
	// Apply effects based on tier and stack multiplier
	var/stack_multiplier = stacks * 0.25 // 25% per stack

	switch(tier)
		if(1)
			// Mild effects
			effectedstats = list(
				STATKEY_CON = round(-1 * stack_multiplier),
				STATKEY_SPD = round(-1 * stack_multiplier)
			)
		if(2)
			// Moderate effects
			effectedstats = list(
				STATKEY_CON = round(-2 * stack_multiplier),
				STATKEY_SPD = round(-1 * stack_multiplier),
				STATKEY_STR = round(-1 * stack_multiplier)
			)
		if(3)
			// Severe effects
			effectedstats = list(
				STATKEY_CON = round(-4 * stack_multiplier),
				STATKEY_SPD = round(-2 * stack_multiplier),
				STATKEY_STR = round(-2 * stack_multiplier),
				STATKEY_WIL = round(-1 * stack_multiplier)
			)
		if(4)
			// Critical effects
			effectedstats = list(
				STATKEY_CON = round(-6 * stack_multiplier),
				STATKEY_SPD = round(-3 * stack_multiplier),
				STATKEY_STR = round(-3 * stack_multiplier),
				STATKEY_WIL = round(-2 * stack_multiplier),
				STATKEY_PER = round(-1 * stack_multiplier)
			)
	reapply_effect(old_stats)

/datum/status_effect/black_rot/proc/reapply_effect(list/old_stats)
	for(var/S in old_stats)
		owner.change_stat(S, -(old_stats[S]))

	for(var/S in effectedstats)
		if(effectedstats[S] < 0)
			if((owner.get_stat(S) + effectedstats[S]) < 1)
				for(var/i in 1 to abs(effectedstats[S]))
					if((owner.get_stat(S) + (effectedstats[S] + i)) == 1)
						effectedstats[S] = (effectedstats[S] + i)
						break
		else
			if((owner.get_stat(S) + effectedstats[S]) > 20)
				effectedstats[S] = 20 - owner.get_stat(S)
		owner.change_stat(S, effectedstats[S])

/datum/status_effect/black_rot/tick()
	if(world.time >= progression_timer && tier < 4)
		// Tier 3 and 4 require at least 2 stacks
		if(tier >= 2 && stacks < 2)
			progression_timer = world.time + (base_progression_time / stacks) // Reset timer but don't progress
		else
			tier++
			progression_timer = world.time + (base_progression_time / stacks)
			// Generally an indicator that you're advancing a tier
			trigger_vomit_fit()
			update_alert()
			update_effects()

	// Apply damage and effects based on tier
	if(world.time >= next_damage_tick)
		next_damage_tick = world.time + (8 SECONDS / stacks)
		apply_damage_effects()

/datum/status_effect/black_rot/proc/apply_damage_effects()
	var/damage_multiplier = stacks * 0.25

	if(prob(25))
		owner.Jitter(20)

	switch(tier)
		if(1)
			if(prob(25))
				owner.adjustBruteLoss(2 * damage_multiplier)
				if(prob(25))
					to_chat(owner, span_warning("我感到骨头里泛起一阵古怪的寒意。"))

		if(2)
			owner.adjustToxLoss(2 * damage_multiplier)
			if(prob(25))
				owner.adjustBruteLoss(4 * damage_multiplier)
			if(prob(10))
				var/message = pick(
					"我的皮肤冰冷而湿腻。",
					"一阵深沉的疼痛正沿着四肢蔓延。",
					"黑斑正在我的视野里乱舞。")
				to_chat(owner, span_warning(message))
		if(3)
			owner.adjustToxLoss(2 * damage_multiplier)
			owner.adjustBruteLoss(2 * damage_multiplier)
			if(prob(25))
				owner.adjustOxyLoss(min(60 - owner.getOxyLoss(), 50 * damage_multiplier))
			if(prob(1))
				trigger_vomit_fit()
			if(prob(10))
				var/message = pick(
					"我的血肉像是在一点点烂掉！",
					"每一次呼吸都带来痛楚！",
					"黑暗正从我体内将我吞噬！")
				to_chat(owner, span_userdanger(message))
		if(4)
			// Severe damage and limb effects
			owner.adjustToxLoss(20 * damage_multiplier)
			owner.adjustBruteLoss(10 * damage_multiplier)
			owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * damage_multiplier)
			// Chance to break limbs
			if(prob(10 * damage_multiplier) && iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/list/breakable_limbs = list()
				for(var/obj/item/bodypart/BP in C.bodyparts)
					if(BP.body_zone in valid_body_zones)
						breakable_limbs += BP
				if(length(breakable_limbs))
					var/obj/item/bodypart/BP = pick(breakable_limbs)
					BP.receive_damage(brute = 25 * damage_multiplier)
					to_chat(owner, span_userdanger("我的 [BP.name] 以不自然的角度扭曲起来，皮肤下鼓起的肿瘤正将它顶得变形！"))
			if(prob(5))
				trigger_vomit_fit()
			if(prob(10))
				var/message = pick(
					"我的身体正在化作尘埃！",
					"虚无在呼唤我！",
					"我能感觉到灵魂正被吞吃！",
					"万物都在褪入黑暗……")
				to_chat(owner, span_userdanger(message))

/datum/status_effect/black_rot/proc/add_stack(amount = 1)
	var/old_stacks = stacks
	stacks = clamp(stacks + amount, 1, 4)

	if(stacks != old_stacks)
		var/time_remaining = progression_timer - world.time
		var/new_time_remaining = time_remaining * (old_stacks / stacks)
		progression_timer = world.time + new_time_remaining
		update_effects()
		update_alert()
		to_chat(owner, span_warning("黑腐病正在我体内溃烂翻腾！"))

/datum/status_effect/black_rot/proc/remove_stack(amount = 1)
	var/old_stacks = stacks
	stacks = clamp(stacks - amount, 1, 4)
	if(stacks != old_stacks)
		var/time_remaining = progression_timer - world.time
		var/new_time_remaining = time_remaining * (old_stacks / stacks)
		progression_timer = world.time + new_time_remaining
		update_effects()
		update_alert()
		to_chat(owner, span_good("黑腐病稍稍退去了一些。"))

/datum/status_effect/black_rot/proc/set_tier(new_tier)
	if(new_tier < 1 || new_tier > 4)
		return

	if(new_tier >= 3 && stacks < 2)
		return

	tier = new_tier
	progression_timer = world.time + (base_progression_time / stacks)
	update_effects()
	update_alert()
	to_chat(owner, span_userdanger("黑腐病的形态改变了！"))

/datum/status_effect/black_rot/on_remove()
	to_chat(owner, span_good("黑腐病已经彻底从我体内清除了！"))
	return ..()

/atom/movable/screen/alert/status_effect/black_rot
	name = "黑腐病"
	desc = "一股腐化的黑暗正在我体内蔓延。"
	icon_state = "black_rot1"

// Puke when advancing stages, woo
/datum/status_effect/black_rot/proc/trigger_vomit_fit()
	to_chat(owner, span_userdanger("一阵恶心猛地将我吞没！而且还在越来越严重。"))
	for(var/i in 1 to 5)
		spawn(rand(1 SECONDS, 20 SECONDS))
			if(owner && !QDELETED(owner) && owner.stat != DEAD)
				vomit_black_rot()

/datum/status_effect/black_rot/proc/vomit_black_rot()
	if(!owner || QDELETED(owner) || owner.stat == DEAD)
		return

	var/turf/vomit_turf = find_vomit_turf()
	if(vomit_turf)
		new /obj/effect/decal/cleanable/black_rot_vomit(vomit_turf)
	playsound(owner, 'sound/misc/machinevomit.ogg', 50, TRUE)
	if(prob(10))
		owner.visible_message(span_warning("[owner] 呕出了一团漆黑如沥青般的污秽物！"), span_userdanger("我呕出了一团漆黑如沥青般的污秽物！"))

/obj/effect/decal/cleanable/black_rot_vomit
	name = "黑腐呕吐物"
	desc = "一团恶臭、漆黑如沥青的污秽物。它仿佛还在诡异地蠕动。"
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "smashed_plant"
	color = "#000000"

/obj/effect/decal/cleanable/black_rot_vomit/Initialize(mapload)
	. = ..()
	alpha = rand(180, 255)
	transform = transform.Scale(rand(8, 12) * 0.1, rand(8, 12) * 0.1)

/datum/status_effect/black_rot/proc/find_vomit_turf()
	var/turf/owner_turf = get_turf(owner)
	if(!owner_turf)
		return null

	// First try the turf in the direction the owner is facing
	var/turf/front_turf = get_step(owner_turf, owner.dir)
	if(front_turf && !front_turf.density)
		return front_turf

	// If front turf is blocked, try adjacent turfs
	var/list/possible_turfs = list()
	for(var/turf/adjacent_turf in RANGE_TURFS(1, owner_turf))
		if(adjacent_turf != owner_turf && !adjacent_turf.density)
			possible_turfs += adjacent_turf
	if(possible_turfs.len)
		return pick(possible_turfs)
	return owner_turf

/datum/status_effect/buff/black_rot_carrier
	id = "black_rot_carrier"
	alert_type = /atom/movable/screen/alert/status_effect/black_rot_carrier
	duration = -1
	examine_text = "SUBJECTPRONOUN 周身萦绕着一股不祥的病疫气息。"

/atom/movable/screen/alert/status_effect/black_rot_carrier
	name = "Pestra 的赐福"
	desc = "Pestra 的赐福正寄宿于我体内，旁人最好避开我的碰触。"
