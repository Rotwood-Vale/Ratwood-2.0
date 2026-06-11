//////Kitchen Spike
#define VIABLE_MOB_CHECK(X) (isliving(X))

/obj/structure/kitchenspike_frame
	name = "肉钩架"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spikeframe"
	desc = ""
	density = TRUE
	anchored = FALSE
	max_integrity = 200

/obj/structure/kitchenspike
	name = "肉钩"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "一只细长弯曲的钩子，专为悬挂尸体而设计。厨房、屠宰场和地牢里都能见到。"
	density = TRUE
	anchored = TRUE
	buckle_lying = 0
	can_buckle = 1
	max_integrity = 250

/obj/structure/kitchenspike/crowbar_act(mob/living/user, obj/item/I)
	if(has_buckled_mobs())
		to_chat(user, span_warning("钩子上挂着东西时我没法这么做！"))
		return TRUE

	if(I.use_tool(src, user, 20, volume=100))
		to_chat(user, span_notice("我把肉钩从架子上撬了下来。"))
		deconstruct(TRUE)
	return TRUE

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/structure/kitchenspike/attack_hand(mob/user)
	if(VIABLE_MOB_CHECK(user.pulling) && user.used_intent.type == INTENT_GRAB && !has_buckled_mobs())
		var/mob/living/L = user.pulling
		if(do_mob(user, src, 120))
			if(has_buckled_mobs()) //to prevent spam/queing up attacks
				return
			if(L.buckled)
				return
			if(user.pulling != L)
				return
			playsound(src.loc, 'sound/blank.ogg', 25, TRUE)
			L.visible_message(span_danger("[user]把[L]猛地砸上了肉钩！"), span_danger("[user]把你猛地砸上了肉钩！"), span_hear("我听见一阵湿黏的噗嗤声。"))
			L.forceMove(drop_location())
			L.emote("scream")
			L.add_splatter_floor()
			L.adjustBruteLoss(30)
			L.setDir(2)
			buckle_mob(L, force=1)
			var/matrix/m180 = matrix(L.transform)
			m180.Turn(180)
			animate(L, transform = m180, time = 3)
			L.pixel_y = L.get_standard_pixel_y_offset(180)
	else if (has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			user_unbuckle_mob(L, user)
	else
		..()



/obj/structure/kitchenspike/user_buckle_mob(mob/living/M, mob/living/user) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/kitchenspike/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message(span_notice("[user]试图把[M]从[src]上扯下来！"),\
				span_notice("[user]正试图把你从[src]上扯下来，这会重新撕开伤口！"),\
				span_hear("我听见一阵湿黏的噗嗤声。"))
			if(!do_after(user, 300, target = src))
				if(M && M.buckled)
					M.visible_message(span_notice("[user]没能把[M]救下来！"),\
					span_notice("[user]没能把你从[src]上扯下来。"))
				return

		else
			M.visible_message(span_warning("[M]拼命想从[src]上挣脱！"),\
			span_notice("我拼命想从[src]上挣脱，只会让伤口更严重！(保持不动两分钟。)"),\
			span_hear("我听见一阵湿漉漉的挤压声……"))
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M && M.buckled)
					to_chat(M, span_warning("我没能挣脱出来！"))
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/kitchenspike/proc/release_mob(mob/living/M)
	var/matrix/m180 = matrix(M.transform)
	m180.Turn(180)
	animate(M, transform = m180, time = 3)
	M.pixel_y = M.get_standard_pixel_y_offset(180)
	M.adjustBruteLoss(30)
	src.visible_message(span_danger("[M]从[src]上摔了下来！"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)

/obj/structure/kitchenspike/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			INVOKE_ASYNC(src, PROC_REF(release_mob), L)
	return ..()

#undef VIABLE_MOB_CHECK
