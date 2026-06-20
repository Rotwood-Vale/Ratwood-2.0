/mob/living/simple_animal/examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_is = p_are()

	. = list("<span class='info'>✠ ------------ ✠\n这是\a <EM>[src]</EM>。")
	if(desc)
		. += desc

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	if(user == src)
		m1 = "我"
		m2 = "我的"

	for(var/obj/item/held_item in held_items)
		if(held_item.item_flags & ABSTRACT)
			continue
		. += "[m1] [m2]的[get_held_index_name(get_held_index_of_item(held_item))]握着[held_item.get_examine_string(user)]。"

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/temp = getBruteLoss() + getFireLoss()
	// Damage
	switch(temp)
		if(5 to 25)
			msg += "[m1]受了轻伤。"
		if(25 to 50)
			msg += "[m1]受伤了。"
		if(50 to 100)
			msg += "<B>[m1]受了重伤。</B>"
		if(100 to INFINITY)
			msg += span_danger("[m1]身受重创。")

	var/has_simple_wounds = HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS)
	if(has_simple_wounds)
		// Blood volume
		if(blood_volume <= BLOOD_VOLUME_SURVIVE)
			msg += span_artery("<B>[m1]极度苍白且病态。</B>")
		else if(blood_volume <= BLOOD_VOLUME_BAD)
			msg += span_artery("<B>[m1]非常苍白。</B>")
		else if(blood_volume <= BLOOD_VOLUME_OKAY)
			msg += span_artery("[m1]面色苍白。")
		else if(blood_volume <= BLOOD_VOLUME_SAFE)
			msg += span_artery("[m1]略显苍白。")

		bleed_rate = get_bleed_rate()
		// Bleeding
		if(bleed_rate)
			var/bleed_wording = "正在流血"
			switch(bleed_rate)
				if(0 to 1)
					bleed_wording = "轻微流血"
				if(1 to 5)
					bleed_wording = "正在流血"
				if(5 to 10)
					bleed_wording = "流血不止"
				if(10 to INFINITY)
					bleed_wording = "大量失血"
			if(bleed_rate >= 5)
				msg += span_bloody("<B>[m1] [bleed_wording]</B>！")
			else
				msg += span_bloody("[m1] [bleed_wording]！")

	//Fire/water stacks
	if(has_status_effect(/datum/status_effect/fire_handler))
		msg += "[m1]披着易燃物。"
	else if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[m1]浑身湿透。"

	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1]正被[pulledby]抓住。"
	
	if(stat >= UNCONSCIOUS)
		msg += "[m1]不省人事。"

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = 10
		var/strength_diff = final_str - L.STASTR
		switch(strength_diff)
			if(5 to INFINITY)
				. += span_warning("<B>[t_He]看[p_s()]起来比我强壮得多。</B>")
			if(1 to 5)
				. += span_warning("[t_He]看[p_s()]起来比我强壮。")
			if(0)
				. += "[t_He]看[p_s()]起来和我差不多强壮。"
			if(-5 to -1)
				. += span_warning("[t_He]看[p_s()]起来比我弱小。")
			if(-INFINITY to -5)
				. += span_warning("<B>[t_He]看[p_s()]起来比我弱小得多。</B>")

	if(Adjacent(user))
		if(has_simple_wounds)
			. += "<a href='?src=[REF(src)];inspect_animal=1'>检查伤势</a>"
		if(user != src)
			. += "<a href='?src=[REF(src)];check_hb=1'>检查心跳</a>"

	. += "✠ ------------ ✠</span>"
