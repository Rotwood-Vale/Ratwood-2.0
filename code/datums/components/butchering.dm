/datum/component/butchering
	var/speed = 80 //time in deciseconds taken to butcher something
	var/effectiveness = 100 //percentage effectiveness; numbers above 100 yield extra drops
	var/bonus_modifier = 0 //percentage increase to bonus item chance
	var/butcher_sound = 'sound/blank.ogg' //sound played when butchering
	var/butchering_enabled = TRUE
	var/can_be_blunt = FALSE

/datum/component/butchering/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(_speed)
		speed = _speed
	if(_effectiveness)
		effectiveness = _effectiveness
	if(_bonus_modifier)
		bonus_modifier = _bonus_modifier
	if(_butcher_sound)
		butcher_sound = _butcher_sound
	if(disabled)
		butchering_enabled = FALSE
	if(_can_be_blunt)
		can_be_blunt = _can_be_blunt

/datum/component/butchering/proc/startButcher(obj/item/source, mob/living/M, mob/living/user)
	to_chat(user, span_notice("我开始肢解[M]……"))
	playsound(M.loc, butcher_sound, 50, TRUE, -1)
	if(do_mob(user, M, speed) && M.Adjacent(source))
		Butcher(user, M)

/datum/component/butchering/proc/startNeckSlice(obj/item/source, mob/living/carbon/human/H, mob/living/user)
	user.visible_message(span_danger("[user] 正在割开[H]的喉咙！"), \
					span_danger("我开始割开[H]的喉咙！"), \
					span_hear("我听见了切割声！"), ignored_mobs = H)
	H.show_message(span_danger("[user] 正在割开我的喉咙！"), MSG_VISUAL, \
					"<span class = 'danger'>有什么东西正在切入我的脖颈！</span>", NONE)
	log_combat(user, H, "starts slicing the throat of")

	playsound(H.loc, butcher_sound, 50, TRUE, -1)
	if(do_mob(user, H, CLAMP(500 / source.force, 30, 100)) && H.Adjacent(source))
		if(H.has_status_effect(/datum/status_effect/neck_slice))
			user.show_message(span_warning("[H]的脖颈早已被割开了，你没法让出血更严重了！"), MSG_VISUAL, \
							span_warning("对方的脖颈早已被割开了，你没法让出血更严重了！"))
			return

		H.visible_message(span_danger("[user] 割开了[H]的喉咙！"), \
					span_danger("[user] 割开了我的喉咙……"))
		log_combat(user, H, "finishes slicing the throat of")
		H.apply_damage(source.force, BRUTE, BODY_ZONE_HEAD)
		H.bleed_rate = CLAMP(H.bleed_rate + 20, 0, 30)
		H.apply_status_effect(/datum/status_effect/neck_slice)

/datum/component/butchering/proc/Butcher(mob/living/butcher, mob/living/meat)
	var/turf/T = meat.drop_location()
	var/final_effectiveness = effectiveness - meat.butcher_difficulty
	var/bonus_chance = max(0, (final_effectiveness - 100) + bonus_modifier) //so 125 total effectiveness = 25% extra chance
	for(var/V in meat.butcher_results)
		var/obj/bones = V
		var/amount = meat.butcher_results[bones]
		for(var/_i in 1 to amount)
			if(!prob(final_effectiveness))
				if(butcher)
					to_chat(butcher, span_warning("我没能从[meat]身上取下部分[initial(bones.name)]。"))
			else if(prob(bonus_chance))
				if(butcher)
					to_chat(butcher, span_info("我从[meat]身上额外取下了一些[initial(bones.name)]！"))
				for(var/i in 1 to 2)
					new bones (T)
			else
				new bones (T)
		meat.butcher_results.Remove(bones) //in case you want to, say, have it drop its results on gib
	for(var/V in meat.guaranteed_butcher_results)
		var/obj/sinew = V
		var/amount = meat.guaranteed_butcher_results[sinew]
		for(var/i in 1 to amount)
			new sinew (T)
		meat.guaranteed_butcher_results.Remove(sinew)
	if(butcher)
		butcher.visible_message(span_notice("[butcher] 肢解了[meat]。"), \
								span_notice("我肢解了[meat]。"))
	ButcherEffects(meat)
	meat.harvest(butcher)
	meat.gib(FALSE, FALSE, TRUE)

/datum/component/butchering/proc/ButcherEffects(mob/living/meat) //extra effects called on butchering, override this via subtypes
	return
