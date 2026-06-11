//Non-map stactic version, can be destroyed. (Not craftable, for now.)
/obj/structure/noose
	name = "绞索"
	desc = "放弃一切希望吧。"
	icon = 'modular/icons/obj/gallows.dmi'
	pixel_y = 10
	icon_state = "noose"
	can_buckle = 1
	layer = 4.26
	max_integrity = 10
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	max_buckled_mobs = 1
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	static_debris = list(/obj/item/rope = 1)
	breakoutextra = 10 MINUTES
	buckleverb = "tie"
	var/offsetx = 0
	var/offsety = 10

//Map stactic version.
/obj/structure/noose/gallows
	name = "绞刑架"
	desc = "孤零零地悬在那里，瘫软而死寂。"
	icon_state = "gallows"
	pixel_y = 0
	max_integrity = 9999
	offsetx = 6
	offsety = 15

/obj/structure/noose/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.visible_message("<span class='danger'>[buckled_mob]摔倒在地，重重撞上了地面！</span>")
			to_chat(buckled_mob, "<span class='userdanger'>你摔倒在地，重重撞上了地面！</span>")
			buckled_mob.adjustBruteLoss(10)
			buckled_mob.Knockdown(60)
	return ..()

/obj/structure/noose/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(!in_range(user, src) || user.stat != CONSCIOUS || !iscarbon(M))
		return FALSE

	if(!M.get_bodypart("head"))
		to_chat(user, "<span class='warning'>[M]没有头！</span>")
		return FALSE

	M.visible_message("<span class='danger'>[user]试图把[src]套到[M]的脖子上！</span>")
	if(do_after(user, user == M ? 0:5 SECONDS, M))
		if(buckle_mob(M))
			user.visible_message("<span class='warning'>[user]把[src]套在了[M]的脖子上！</span>")
			if(user == M)
				to_chat(M, "<span class='userdanger'>你把[src]套在了自己的脖子上！</span>")
			else
				to_chat(M, "<span class='userdanger'>[user]把[src]套在了你的脖子上！</span>")
			playsound(user.loc, 'sound/foley/noosed.ogg', 50, 1, -1)
			return TRUE
	user.visible_message("<span class='warning'>[user]没能把[src]套到[M]的脖子上！</span>")
	to_chat(user, "<span class='warning'>你没能把[src]套到[M]的脖子上！</span>")
	return FALSE

/obj/structure/noose/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		START_PROCESSING(SSobj, src)
		M.set_mob_offsets("bed_buckle", _x = offsetx, _y = offsety)
		M.setDir(SOUTH)
		M.hanged = TRUE

/obj/structure/noose/post_unbuckle_mob(mob/living/M)
	STOP_PROCESSING(SSobj, src)
	M.reset_offsets("bed_buckle")
	if(M.hanged)
		M.hanged = FALSE

/obj/structure/noose/process()
	if(!has_buckled_mobs())
		STOP_PROCESSING(SSobj, src)
		return
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(buckled_mob.get_bodypart("head"))
			if(buckled_mob.stat != DEAD)
				if(locate(/obj/structure/chair) in get_turf(src)) // So you can kick down the chair and make them hang, and stuff.
					return
				if(!HAS_TRAIT(buckled_mob, TRAIT_NOBREATH))
					buckled_mob.adjustOxyLoss(10)
					if(prob(20))
						buckled_mob.emote("gasp")
				playsound(buckled_mob.loc, 'sound/foley/noose_idle.ogg', 30, 1, -3)
			else
				if(prob(1))
					var/obj/item/bodypart/head/head = buckled_mob.get_bodypart("head")
					if(head.brute_dam >= 50)
						if(head.dismemberable)
							head.dismember()
		else
			buckled_mob.visible_message("<span class='danger'>[buckled_mob]从绞索上掉了下来！</span>")
			buckled_mob.Knockdown(60)
			buckled_mob.pixel_y = initial(buckled_mob.pixel_y)
			buckled_mob.pixel_x = initial(buckled_mob.pixel_x)
			unbuckle_all_mobs(force=1)
