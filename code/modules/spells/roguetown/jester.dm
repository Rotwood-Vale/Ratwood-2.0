/obj/effect/proc_holder/spell/self/telljoke
	name = "喜剧"
	desc = "对情绪高涨的人说些滑稽话，好让他们更加开怀。"
	overlay_state = "comedy"
	antimagic_allowed = TRUE
	invocation_type = "shout"
	recharge_time = 600

/obj/effect/proc_holder/spell/self/telljoke/cast(list/targets,mob/user = usr)
	. = ..()
	var/joker = input(user, "说点好笑的吧！", "Comedia")
	if(!joker)
		return FALSE
	user.say(joker, forced = "spell")
	sleep(20)
	playsound(get_turf(user), 'sound/magic/comedy.ogg', 100)
	for(var/mob/living/carbon/CA in view(7, get_turf(user)))
		if(CA == user)
			continue
		if(CA.cmode)
			continue
		if(CA.get_stress_amount() <= 0)
			CA.add_stress(/datum/stressevent/joke)
			CA.emote(pick("laugh","chuckle","giggle"), forced = TRUE)
			
			// Apply Xylix buff to those with the trait who hear the laughter
			// Only apply if the hearer is not the one laughing and not the spell caster
			for(var/mob/living/carbon/human/H in hearers(7, CA))
				if(H == CA || H == user || !H.client)
					continue
				if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
					H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
					to_chat(H, span_info("笑声让我面露笑意，也让幸运落在了我的脚步上！"))
		sleep(rand(1,5))

/obj/effect/proc_holder/spell/self/telltragedy
	name = "悲剧"
	desc = "提醒那些情绪低落的人，事情本还可以更糟。"
	overlay_state = "tragedy"
	antimagic_allowed = TRUE
	invocation_type = "shout"
	recharge_time = 600

/obj/effect/proc_holder/spell/self/telltragedy/cast(list/targets,mob/user = usr)
	. = ..()
	var/joker = input(user, "说点悲伤的吧！", "Tragedia")
	if(!joker)
		return FALSE
	user.say(joker, forced = "spell")
	sleep(20)
	playsound(get_turf(user), 'sound/magic/tragedy.ogg', 100)
	for(var/mob/living/carbon/CA in view(7, get_turf(user)))
		if(CA == user)
			continue
		if(CA.cmode)
			continue
		if(CA.get_stress_amount() > 0)
			CA.add_stress(/datum/stressevent/tragedy)
			CA.emote(pick("sigh","hmm"), forced = TRUE)
		sleep(rand(1,5))
