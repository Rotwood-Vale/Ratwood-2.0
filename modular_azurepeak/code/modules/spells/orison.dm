/obj/effect/proc_holder/spell/targeted/touch/orison
	name = "祈祷"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "orison"
	desc = "神圣魔法的基本法则围绕着祈祷的力量，向一位神祇祈求祂的一丝威能。"
	clothes_req = FALSE
	drawmessage = "我平复心神，准备施展一个祈祷。"
	dropmessage = "我将心神收回当下。"
	school = "transmutation"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 5
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/orison

/obj/item/melee/touch_attack/orison
	name = "\improper 次级祈祷"
	desc = "神学的基本教义涌回你的脑海：\n \
		<b>Fill</b>: 向你的神祇恳求，在你触碰的容器中创造少量水，消耗一定的信仰值。\n \
		<b>Touch</b>: 将一丝神圣奇术引入自身，使你下次开口时声音变得洪亮。据说有时能吓到 SCOM 管线里的老鼠。可以远程用于光源，使其闪烁。\n \
		<b>Use</b>: 发出祈求光明的祷告，使你或另一个活物开始发光，持续五分钟——此效果可叠加，无上限。对某人使用次级祈祷的 Touch 意图会移除其身上的此祝福，用中键点击祈祷之手则会移除你自身所有的光明祝福。\n \
		<b>Shove</b>: 将手按在相邻的生物身上，通过你的触碰引导神圣的恢复之力。你和你的目标都必须保持静止，引导才能继续。"
	catchphrase = null
	possible_item_intents = list(/datum/intent/fill, INTENT_HELP, /datum/intent/use, INTENT_DISARM)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	associated_skill = /datum/skill/magic/holy
	var/right_click = FALSE
	var/thaumaturgy_devotion = 10
	/// The amount of devotion used to apply/add light to a mob
	var/light_devotion = 5
	var/water_moisten = 2
	var/lay_hands_devotion = 10

/obj/item/melee/touch_attack/orison/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/orison/MiddleClick(mob/living/user, params)
	. = ..()
	if (user.has_status_effect(/datum/status_effect/light_buff))
		user.remove_status_effect(/datum/status_effect/light_buff)
		user.visible_message(span_notice("[user]闭上了[user.p_their()]的眼睛，环绕其周身的圣光缩回胸口，消失不见。"), span_notice("我放弃了 [user.patron.name] 赐予的光明恩赐。"))
		return

/obj/item/melee/touch_attack/orison/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	var/fatigue_used
	switch (user.used_intent.type)
		if (/datum/intent/fill)
			fatigue_used = create_water(target, user)
			if (fatigue_used)
				qdel(src)
		if (INTENT_HELP)
			fatigue_used = thaumaturgy(target, user)
			if (fatigue_used)
				user.devotion?.update_devotion(-fatigue_used)
				qdel(src)
		if (/datum/intent/use)
			fatigue_used = cast_light(target, user)
			if (fatigue_used)
				user.devotion?.update_devotion(-fatigue_used)
				qdel(src)
		if (INTENT_DISARM)
			fatigue_used = lay_hands(target, user)
			if (fatigue_used)
				user.devotion?.update_devotion(-fatigue_used)
				qdel(src)

#define BLESSINGOFLIGHT_FILTER "bol_glow"

/atom/movable/screen/alert/status_effect/light_buff
	name = "奇迹之光"
	desc = "光明的祝福驱散了我周围的黑暗。"
	icon_state = "stressvg"

/datum/status_effect/light_buff
	id = "orison_light_buff"
	alert_type = /atom/movable/screen/alert/status_effect/light_buff
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	examine_text = "SUBJECTPRONOUN周身环绕着柔和的光晕。"
	var/outline_colour = "#ffffff"
	/// The object attached to the mob that emits light
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj
	/// Amount of light our buff emits, can be buffed by someone with higher miracles skill
	var/holy_light_power = 1

/datum/status_effect/light_buff/on_creation(mob/living/new_owner, light_power)
	if(light_power > holy_light_power)
		holy_light_power = light_power
	return ..()

/datum/status_effect/light_buff/refresh(mob/living/owner, light_power)
	duration += initial(duration) // stack this up as much as we can be bothered to cast it
	if(holy_light_power > mob_light_obj.light_power)
		mob_light_obj.light_power = holy_light_power

/datum/status_effect/light_buff/on_apply()
	. = ..()
	if (!.)
		return
	playsound(owner, 'sound/magic/whiteflame.ogg', 75, FALSE)
	to_chat(owner, span_notice("光芒在我周围绽放！"))
	var/filter = owner.get_filter(BLESSINGOFLIGHT_FILTER)
	if (!filter)
		owner.add_filter(BLESSINGOFLIGHT_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	mob_light_obj = owner.mob_light(7, 7, _color ="#f5edda")
	mob_light_obj.light_power = holy_light_power
	return TRUE

/datum/status_effect/light_buff/on_remove()
	playsound(owner, 'sound/items/firesnuff.ogg', 75, FALSE)
	to_chat(owner, span_notice("环绕我的奇迹之光消散了..."))
	owner.remove_filter(BLESSINGOFLIGHT_FILTER)
	QDEL_NULL(mob_light_obj)

/obj/item/melee/touch_attack/orison/proc/cast_light(atom/thing, mob/living/carbon/human/user)
	var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
	var/cast_time = 35 - (holy_skill * 3)
	if (!thing.Adjacent(user))
		to_chat(user, span_info("我需要靠近[thing]才能引导光明祝福！"))
		return

	if(!isliving(thing))
		to_chat(user, span_notice("只有活物才能承受 [user.patron.name] 之光的祝福。"))
		return

	if(thing != user)
		user.visible_message(span_notice("[user]轻轻地朝[thing]伸出手，指尖闪烁着光点……"), span_notice("神圣的 [user.patron.name]，我只求一束光明指引前路..."))
	else
		user.visible_message(span_notice("[user]闭上眼睛，将发光的手按在胸口..."), span_notice("神圣的 [user.patron.name]，我只求一束光明指引前路..."))

	if(!do_after(user, cast_time, target = thing))
		return
	var/mob/living/living_thing = thing
	if (living_thing.has_status_effect(/datum/status_effect/light_buff))
		user.visible_message(span_notice("从[living_thing]身上散发出的圣光变得更加明亮！"), span_notice("我向[living_thing]的光明祝福注入了更多的虔诚。"))
	else
		user.visible_message(span_notice("一片柔和的光辉突然在[living_thing]周身绽放！"), span_notice("我给予[living_thing]一份光明的祝福。"))

	var/light_power = clamp(4 + (holy_skill - 3), 4, 7)
	living_thing.apply_status_effect(/datum/status_effect/light_buff, light_power)

	return light_devotion

#undef BLESSINGOFLIGHT_FILTER
/atom/movable/screen/alert/status_effect/thaumaturgy
	name = "奇术之声"
	desc = "吾神之力将使我接下来所说的话传得更远！"
	icon_state = "stressvg"

/datum/status_effect/thaumaturgy
	id = "thaumaturgy"
	alert_type = /atom/movable/screen/alert/status_effect/thaumaturgy
	duration = 30 SECONDS
	var/potency = 1

/datum/status_effect/thaumaturgy/on_creation(mob/living/new_owner, skill_power)
	potency = skill_power
	return ..()

/obj/item/melee/touch_attack/orison/proc/thaumaturgy(thing, mob/living/carbon/human/user)
	var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
	if (thing == user)
		// give us a buff that makes our next spoken thing really loud and also cause any linked, un-muted scom to shriek out the phrase at a 15% chance
		var/cast_time = 50 - (holy_skill * 5)
		user.visible_message(span_notice("[user]庄严地低下头，低声的祈祷从唇间流淌而出..."), span_notice("噢，神圣的 [user.patron.name]，请分与我一丝你的力量..."))
		
		if (!user.has_status_effect(/datum/status_effect/thaumaturgy))
			if (do_after(user, cast_time, target = user))
				user.apply_status_effect(/datum/status_effect/thaumaturgy, holy_skill)
				user.visible_message(span_notice("[user]猛地睁开双眼，顿时勇气倍增！"), span_notice("一股力量感涌上我的喉咙：开口吧，众人必将听见！"))
				return thaumaturgy_devotion
		else
			to_chat(user, span_notice("我已经被神圣奇术所增强！"))
			return
	else
		// make a light source flicker, and others around it within a radius	
		if (istype(thing, /obj/machinery/light) || istype(thing, /obj/item/flashlight))
			for (var/obj/maybe_light in view(3 + holy_skill, thing))
				if (istype(maybe_light, /obj/machinery/light))
					var/obj/machinery/light/other_light = maybe_light
					other_light.flicker(holy_skill * 5)
					user.devotion?.update_devotion(-1)
				else if (istype(maybe_light, /obj/item/flashlight/flare))
					var/obj/item/flashlight/flare/mobile_light = maybe_light
					if (mobile_light.on)
						mobile_light.turn_off()
						user.devotion?.update_devotion(-1)

			to_chat(user, span_notice("我将信仰的力量导向周围的火焰，令它们摇曳！"))
			
			return thaumaturgy_devotion
		else if (isturf(thing))

			var/did_flicker = FALSE
			for (var/obj/machinery/light/other_lights in view(3 + holy_skill, thing))
				other_lights.flicker(holy_skill * 5)
				user.devotion?.update_devotion(-1)
				did_flicker = TRUE

			if (did_flicker)
				to_chat(user, span_notice("我将信仰的力量导向周围的火焰，令它们摇曳！"))

				return thaumaturgy_devotion
			else
				to_chat(user, span_notice("我的信仰找不到火焰来证明其存在..."))
				qdel(src)
		else if (isliving(thing))

			var/mob/living/living_thing = thing
			if (living_thing.has_status_effect(/datum/status_effect/light_buff))
				living_thing.remove_status_effect(/datum/status_effect/light_buff)
				user.visible_message(span_notice("[user]向[living_thing]做了一个克制的手势，圣光便离开了[living_thing.p_them()]。"), span_notice("我向[living_thing]示意，[living_thing.p_their()]身上的光明祝福便消退了。"))
				return
			else
				to_chat(user, span_notice("我的神圣奇术只能增强自己的声音，或驱散他人身上的光明祝福。"))
				return
		else
			to_chat(user, span_warning("我只能将奇术祈祷导向自己、地面和周围的光源。"))
			return

/datum/reagent/water/blessed
	name = "圣水"
	description = "虔信的赐礼。可自内而外调理身躯，但无法愈合外在创伤。"

/datum/reagent/water/blessed/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_UNDEAD)
		M.adjustFireLoss(1.5*REM)
	else
		// Heals internal damage very well like potions
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
		M.adjustToxLoss(-3*REM, 0)
		M.adjustOxyLoss(-3*REM, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3*REM)
		M.adjustCloneLoss(-3*REM, 0)
		// Does NOT heal brute or fire damage

/datum/reagent/water/blessed/on_mob_metabolize(mob/living/L)
	..()
	if(L.mob_biotypes & MOB_UNDEAD)
		L.adjust_fire_stacks(2)
		L.ignite_mob()
		L.emote("scream")
		L.visible_message(span_warning("[L] erupts into angry fizzling and hissing!"), span_warning("BLESSED WATER!!! IT BURNS!!!"))

/datum/reagent/water/blessed/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if (!istype(M))
		return ..()
	
	if (method == TOUCH)
		if (M.mob_biotypes & MOB_UNDEAD)
			M.adjustFireLoss(2*reac_volume, 0)
			M.visible_message(span_warning("[M] erupts into angry fizzling and hissing!"), span_warning("BLESSED WATER!!! IT BURNS!!!"))
			M.emote("scream")
	
	return ..()

/datum/reagent/water/cursed
	name = "诅咒之水"
	description = "虔信的赐礼。可自内而外调理身躯，但无法愈合外在创伤。"

/datum/reagent/water/cursed/on_mob_life(mob/living/carbon/M)
	. = ..()
	var/mob/living/carbon/human/M_hum
	if(istype(M,/mob/living/carbon/human/))
		M_hum = M
	if((M.mob_biotypes & MOB_UNDEAD) || (M_hum.patron.undead_hater == FALSE))
		// Heals internal damage very well like potions for undead/dark patrons
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
		M.adjustToxLoss(-3*REM, 0)
		M.adjustOxyLoss(-3*REM, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3*REM)
		M.adjustCloneLoss(-3*REM, 0)
		// Does NOT heal brute or fire damage
	else
		// Heals less for divine worshippers, but still internal damage only
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_NORMAL)
		M.adjustToxLoss(-1.5*REM, 0)
		M.adjustOxyLoss(-1.5*REM, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1.5*REM)
		M.adjustCloneLoss(-1.5*REM, 0)
		// Does NOT heal brute or fire damage
		M.stamina_add(1*REM)

/obj/item/melee/touch_attack/orison/proc/lay_hands(atom/thing, mob/living/carbon/human/user)
	var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
	var/cast_time = 40 - (holy_skill * 4)
	
	if (!thing.Adjacent(user))
		to_chat(user, span_info(to_chat(user, span_info("我需要靠近[thing]才能按住[user.p_their()]的手！"))))
		return
	
	if (!isliving(thing))
		to_chat(user, span_notice("我只能通过活物传导治愈之力。"))
		return
	
	var/mob/living/target = thing
	
	if (target.stat == DEAD)
		to_chat(user, span_warning("死者非我所能触及..."))
		return
	
	if (target.has_status_effect(/datum/status_effect/buff/lay_hands))
		to_chat(user, span_notice("[target]已经在接受治疗了。"))
		return
	
	user.visible_message(span_notice("[user]将[user.p_their()]的双手按在[target]身上，神圣之力开始汇聚..."), span_notice("我将双手按在[target]身上，引导 [user.patron.name] 的治愈之力..."))
	
	// Initial channel to establish the connection
	if (do_after(user, cast_time, target = target))
		// Healing power scales better with holy skill: 0.3 to 0.8
		var/healing_power = clamp(0.3 + (holy_skill * 0.1), 0.3, 0.8)
		// Devotion cost per tick scales down with skill: 3 to 1
		var/devotion_per_tick = clamp(4 - holy_skill, 1, 20)
		
		user.visible_message(span_notice("神圣能量弥漫在[target]周身，[user]的引导开始生效！"), span_notice("连接已建立——[user.patron.name] 的力量通过我流向[target]。"))
		
		// Continuous healing loop - keeps going as long as both stay still and adjacent
		var/first_application = TRUE
		var/tick_time = 50 - (holy_skill * 3) // Faster ticks for more skilled clerics
		
		while(do_after(user, tick_time, target = target))
			// Check if we have enough devotion to continue
			if (user.devotion?.devotion < devotion_per_tick)
				to_chat(user, span_warning("我的虔诚已经耗尽——我无法继续维持引导！"))
				break
			
			// Break if target dies
			if (target.stat == DEAD)
				to_chat(user, span_warning("[target]已经超出了我治愈之触的范围..."))
				break
			
			// Break if no longer adjacent
			if (!target.Adjacent(user))
				to_chat(user, span_warning("我离[target]太远了——祝福消退了！"))
				break
			
			// Apply or refresh the healing effect
			target.apply_status_effect(/datum/status_effect/buff/lay_hands, healing_power)
			
			// Consume devotion for this healing cycle
			user.devotion?.update_devotion(-devotion_per_tick)
			
			if (first_application)
				to_chat(user, span_notice("我保持着专注，通过双手引导 [user.patron.name] 的治愈之力..."))
				first_application = FALSE
		
		// When the loop ends (player moved or stopped)
		user.visible_message(span_notice("[user]将手从[target]身上收回，神圣能量随之消散。"), span_notice("我松开专注，引导结束。"))
		
		return lay_hands_devotion
	
	return

/obj/item/melee/touch_attack/orison/proc/create_water(atom/thing, mob/living/carbon/human/user)
	// normally we wouldn't use fatigue here to keep in line w/ other holy magic, but we have to since water is a persistent resource
	if (!thing.Adjacent(user))
		to_chat(user, span_info("我需要更靠近[thing]才能试着往里面注水。"))
		return

	if (thing.is_refillable())
		if (thing.reagents.holder_full())
			to_chat(user, span_warning("[thing]已经满了。"))
			return
		
		user.visible_message(span_info("[user]闭上双眼祈祷，将手伸向[thing]，水从[user.p_their()]的指尖涌出..."), span_notice("我向 [user.patron.name] 发出祈求，将手伸向[thing]上方..."))

		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
		var/drip_speed = 56 - (holy_skill * 8)
		var/fatigue_spent = 0
		var/fatigue_used = max(3, holy_skill)
		while (do_after(user, drip_speed, target = thing))
			if (thing.reagents.holder_full() || (user.devotion.devotion - fatigue_used <= 0))
				break

			var/water_qty = max(1, holy_skill) + 1
			var/list/water_contents = list(/datum/reagent/water/cursed = water_qty)
			if(user.patron.undead_hater == TRUE)
				water_contents = list(/datum/reagent/water/blessed = water_qty)

			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(thing, reagents_to_add.total_volume, transfered_by = user, method = INGEST)

			fatigue_spent += fatigue_used
			user.stamina_add(fatigue_used)
			user.devotion?.update_devotion(-1.0)

			if (prob(80))
				playsound(user, 'sound/items/fillcup.ogg', 55, TRUE)
		
		return min(50, fatigue_spent)
	else if (istype(thing, /obj/item/natural/cloth))
		// stupid little easter egg here: you can dampen a cloth to clean with it, because prestidigitation also lets you clean things. also a lot cheaper devotion-wise than filling a bucket
		var/obj/item/natural/cloth/the_cloth = thing
		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
		if(the_cloth.wet >= holy_skill * 5) // Don't reduce the wetness if someone better than you already blessed it
			to_chat(user, span_warning("我无法再把这布弄得更湿了"))
			return
		the_cloth.wet = holy_skill * 5
		user.visible_message(span_info("[user]闭上双眼祈祷，水珠在手中凝聚，打湿了[the_cloth]。"), span_notice("我向 [user.patron.name] 发出祈求，将水分注入[the_cloth]。现在我应该能用它好好清洁了。"))
		return water_moisten
	else
		to_chat(user, span_info("我得找个能盛水的容器。"))
