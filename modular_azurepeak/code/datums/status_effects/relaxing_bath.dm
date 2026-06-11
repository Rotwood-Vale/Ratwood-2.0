/*
Code for relaxing bath, which is a soft, "active roleplay" alternative to sleeping. 
Removes the tired moodlet, gives a triumph, gives dream points without opportunity of
dreaming. Still have to go to sleep to learn skills. Also gives healing tickrate + energy regen. 
*/

/mob/living/carbon/human/proc/relaxing_bath(source_type)
	var/bathing_spot = src.loc
	var/pool

	var/list/wash = list('sound/foley/watermove (1).ogg','sound/foley/watermove (2).ogg', 'sound/foley/waterwash (1).ogg', 'sound/foley/waterwash (2).ogg')
	playsound(src, pick(wash), 100, FALSE)

	if(source_type == 1)
		pool = get_turf(src)
	else if (source_type == 2)
		pool = locate(/obj/structure/hotspring) in get_turf(src)

	src.visible_message(span_info("[src]开始在[pool]中浸泡。"), span_info("我在水中缓缓坐下，开始泡澡。"), span_info("有人正在水中懒洋洋地晃动。"))
	
	if(src.has_status_effect(/datum/status_effect/debuff/sleepytime))
		to_chat(src, span_green("我正在享受一场放松的沐浴。这会消除我现在承受的疲惫感。"))
	else
		to_chat(src, span_green("我正在享受一场放松的沐浴。"))

	var/soak_count = 0
	var/soak_threshold = 12 // 2 minutes
	var/ticks = 105 // 10.5 seconds per loop, like campfire
	var/first_clean = TRUE
	var/buff_strength = 1
	var/ultimate_soak = FALSE
	var/soapy = FALSE

	if(src.patron?.type == /datum/patron/divine/eora || src.patron?.type == /datum/patron/inhumen/baotha) //BAoTHa
		buff_strength = 2

	while(do_after(src, ticks, target = pool))
		if(src.loc != bathing_spot)
			to_chat(src, span_warning("我离开了水边，结束了这场沐浴。"))
			break

		if(first_clean) //Cleaning them on first loop through
			wash_atom(src, CLEAN_STRONG)
			src.remove_stress(/datum/stressevent/sewertouched)
			src.visible_message(span_info("[src]洗去了身上的污垢。"), span_info("温暖的水流洗净了我。"))
			first_clean = FALSE

		if(bodytemperature < BODYTEMP_NORMAL_MIN)	//washing yourself helps to warm you up.
			adjust_bodytemperature(75)
		if(bodytemperature > BODYTEMP_NORMAL_MAX)	//washing yourself helps to cool you off.
			adjust_bodytemperature(-75)

		soak_count++

		// Soap buff makes you bathe faster
		if(src.has_stress_event(/datum/stressevent/bathcleaned))
			soak_count += 2
			soapy = TRUE
		else if(src.has_stress_event(/datum/stressevent/bath))
			soak_count += 1
			soapy = TRUE
		else
			soapy = FALSE

		if(src.wear_armor || src.head && src.head.armor?.stab > 70)
			soak_count--
			if(prob(10))
				to_chat(src, span_warning("穿着外层衣物，我没法充分享受这场沐浴。"))
			if(!soapy)
				to_chat(src, span_warning("我这样根本泡不出什么效果。我至少该脱掉盔甲和头盔，或者用些肥皂。"))
				break //No healing for you


		// Play occasional water sounds
		if(prob(30))
			playsound(src, pick(wash), 50, FALSE)

		// Gradual healing and fatigue regen every tick
		src.apply_status_effect(/datum/status_effect/buff/healing, buff_strength)
		if(src.energy < src.max_energy)
			src.energy_add(100) // Refilling our blue bar

		if(soak_count >= soak_threshold && !ultimate_soak && src.has_status_effect(/datum/status_effect/debuff/sleepytime))
			to_chat(src, span_green("这一泡让我彻底恢复了精神！"))
			src.visible_message(span_info("[src]看起来神清气爽，疲惫正从[src.p_them()]身上消退。"))
			src.remove_status_effect(/datum/status_effect/debuff/sleepytime)
			src.remove_stress(/datum/stressevent/sleepytime)
			src.adjust_triumphs(1)
			if(src.mind?.sleep_adv)
				src.mind.sleep_adv.sleep_adv_points += 3
			ultimate_soak = TRUE
