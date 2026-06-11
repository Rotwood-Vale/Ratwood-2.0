//A skill for bath attendants to help their clients relax
/obj/effect/proc_holder/spell/invoked/massage
	name = "按摩"
	desc = "为顾客按摩，舒缓他们肌肉中的酸痛"
	overlay_state = "massage"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/massage/cast(list/targets, mob/user = usr)
	var/mob/living/massagee = targets[1]
	var/mob/living/massager = user
	var/massagetime = 20 SECONDS
	var/agreementone = FALSE
	var/agreementtwo = FALSE
	var/chance = rand(0,100)
	var/chance_append = max((massager.get_stat(STATKEY_LCK) - 10) * 5, 0)
	chance = min(chance + chance_append, 100)

	if(!ishuman(massagee))
		to_chat(massager, span_warning("我觉得那东西没法按摩。"))
		revert_cast()
		return

	if(massager == massagee)
		to_chat(massager, span_warning("可惜，我没法给自己按摩。"))
		revert_cast()
		return

	if((massagee.mobility_flags & MOBILITY_STAND))
		// Check if they're in bathing water or at a hotspring
		var/turf/massage_spot = get_turf(massagee)
		var/in_valid_location = FALSE

		// Check for bath/water tile
		if(istype(massage_spot, /turf/open/water/bath))
			in_valid_location = TRUE

		// Check for hotspring structure
		if(locate(/obj/structure/hotspring) in massage_spot)
			in_valid_location = TRUE

		if(!in_valid_location)
			to_chat(massager, span_warning("我的顾客必须躺下，或者站在适合沐浴的水里。"))
			revert_cast()
			return

	if(isliving(massagee)) //target needs to be living
		if(massagee in range(1, massager))
			switch(alert(massager,"你确定要给[massagee.name]按摩吗？", "你要进行按摩吗？","是","否"))
				if("Yes")
					to_chat(massager, span_warning("我询问对方是否准备好了。")) //make sure this is who I want to massage
					agreementone = TRUE
				if("No")
					to_chat(massager, span_warning("我决定不这么做。"))
					return
				else
					to_chat(massager, span_warning("我决定不这么做。"))
					return

			switch(alert(massagee, "你愿意接受[massager.name]的按摩吗？", "你想接受按摩吗？", "否", "是"))
				if("否")
					to_chat(massager, span_warning("对方拒绝了。"))
					return
				if("是")
					to_chat(massager, span_warning("对方同意了。")) //make sure they consent to a massage
					agreementtwo = TRUE
				else
					to_chat(massager, span_warning("对方拒绝了。"))
					return

			if (agreementone && agreementtwo)
				//we can proceed, they weren't afk
			else
				to_chat(massager, span_warning("对方现在无法作出回应。")) //a final catch all
				return

			if(massagee.has_status_effect(/datum/status_effect/debuff/muscle_sore) || massagee.has_status_effect(/datum/status_effect/buff/massage) || massagee.has_status_effect(/datum/status_effect/buff/goodmassage) || massagee.has_status_effect(/datum/status_effect/buff/greatmassage))
				to_chat(massagee, span_warning("我的肌肉还在恢复中。"))
				to_chat(massager, span_warning("我的顾客肌肉劳损过度，还需要一些时间恢复。"))
				return // can not continually give massages, the buff needs to wear off and you need to sleep off any cramps
			else
				to_chat(massagee, span_notice("[massager]开始给我按摩了。"))
				to_chat(massager, span_notice("[massagee]开始接受按摩。"))
				playsound(massager, pick('modular/Neu_Food/sound/kneading.ogg','modular/Neu_Food/sound/kneading_alt.ogg'), 10, TRUE)
				massagetime = pick(20 SECONDS, 25 SECONDS, 30 SECONDS, 35 SECONDS, 40 SECONDS) //randomize times
				if(do_after(massager, massagetime, target = massagee))
					switch(chance)
						if(0 to 49)
							to_chat(massagee, span_notice("啊，这次按摩让我的身体放松了下来。"))
							massagee.apply_status_effect(/datum/status_effect/buff/massage)
							to_chat(massager, span_warning("我做出了一次还不错的按摩。"))
						if(50 to 95)
							to_chat(massagee, span_notice("这次按摩让我的身体感觉非常舒服。"))
							massagee.apply_status_effect(/datum/status_effect/buff/goodmassage)
							to_chat(massager, span_warning("我做出了一次很棒的按摩。"))
						if (96 to 100)
							to_chat(massagee, span_notice("哇！这次按摩让我感觉好极了！"))
							massagee.apply_status_effect(/datum/status_effect/buff/greatmassage)
							to_chat(massager, span_warning("我做出了一次绝佳的按摩！"))
		else
			to_chat(massager, span_warning("[massagee]在按摩过程中必须待在我附近！"))
			to_chat(massagee, span_warning("按摩时我得待在[massager]附近！"))
			if (prob(55))
				to_chat(massagee, span_warning("啊，刚才差一点就抽筋了，我得小心些。"))
			else
				to_chat(massagee, span_bad("糟了，我感觉到了，抽筋了！"))
				massagee.apply_status_effect(/datum/status_effect/debuff/muscle_sore)
