/*	..................   FLOORS   ................... */

/turf/open/water/bath/pool
	desc = "水质清澈，温度宜人，令人放松。"
	icon_state = "bathtile_pool"
/turf/open/water/bath/pool/Initialize(mapload)
	.  = ..()
	icon_state = "bathtile_pool"

/turf/open/water/bath/pool/mid
	icon_state = "bathtile_pool_mid"
/turf/open/water/bath/pool/mid/Initialize(mapload)
	.  = ..()
	icon_state = "bathtile_pool_mid"

/*	..................   SPIDER   ................... */

/obj/structure/spider/stickyweb
	name = "蛛网"
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "stickyweb1"
	resistance_flags = FLAMMABLE
	alpha = 109
	max_integrity = 30
	opacity = TRUE
	debris = list(/obj/item/natural/silk = 1)

/obj/structure/spider/stickyweb/attacked_by(obj/item/I, mob/living/user) //Snipping action for webs, scissors turning webs into silk fast!
	var/snip_time = 50
	var/sewing_skill = user.get_skill_level(/datum/skill/craft/sewing)
	var/amount = rand(1, 2)
	if(user.used_intent.type == /datum/intent/snip)
		snip_time = (50 - (sewing_skill * 10))
		if(!do_after(user, snip_time, target = user))
			return TRUE
		for(var/i = 1; i <= amount; i++)
			new /obj/item/natural/silk (get_turf(src))
		user.visible_message(span_notice("[user]将[src]剪成了丝线。"))
		user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT / 2)) //We're getting experience for harvesting silk!
		playsound(src, 'sound/items/flint.ogg', 100, TRUE)
		qdel(src)
		return TRUE
	..()

/obj/structure/spider/stickyweb/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		if(prob(50) && !HAS_TRAIT(mover, TRAIT_WEBWALK))
			to_chat(mover, "<span class='danger'>我被[src]绊住了一小会儿。</span>")
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)
	return TRUE

/obj/structure/spider/stickyweb/fire_act(added, maxstacks)
	visible_message(span_warning("[src]着火了！"))
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/effect/hotspot(T)

/obj/structure/spider/stickyweb/solo
	icon_state = "stickyweb3"

/obj/structure/spider/stickyweb/Initialize(mapload)
	if(icon_state == "stickyweb1")
		if(prob(50))
			icon_state = "stickyweb2"
	dir = pick(GLOB.cardinals)
	alpha = rand(80,109)
	switch(pick(1,2))
		if (1)
			static_debris = FALSE
		if (2)
			static_debris = list(/obj/item/natural/silk = 1)
	. = ..()

/obj/structure/spider/cocoon
	name = "茧"
	desc = ""
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "cocoon_person"
	max_integrity = 40
	static_debris = list(/obj/item/natural/silk = 5)

/obj/structure/spider/cocoon/container_resist(mob/living/user)
	var/breakout_time = 600
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, "<span class='notice'>我奋力挣扎，试图摆脱这层紧缚......（大约需要 [DisplayTimeText(breakout_time)]。）</span>")
	visible_message("<span class='notice'>我看见有什么东西正在[src]里挣扎扭动！</span>")
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src)
			to_chat(user, "<span class='notice'>啊！太痛了！我暂时挣脱不出来。</span>")
			return
		user.remove_status_effect(/datum/status_effect/buff/healing/spider_cocoon)
		qdel(src)

/obj/structure/spider/cocoon/Destroy()
	var/turf/T = get_turf(src)
	src.visible_message("<span class='warning'>[src]裂开了。</span>")
	for(var/atom/movable/A in contents)
		if(istype(A, /mob/living))
			var/mob/living/L = A
			L.remove_status_effect(/datum/status_effect/buff/healing/spider_cocoon)
		A.forceMove(T)
	return ..()
