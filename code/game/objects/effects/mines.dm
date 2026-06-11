/obj/effect/mine
	name = "假地雷"
	desc = ""
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine"
	var/triggered = 0

/obj/effect/mine/proc/mineEffect(mob/victim)
	to_chat(victim, span_danger("*咔哒*"))

/obj/effect/mine/Crossed(AM as mob|obj)
	if(isturf(loc))
		if(ismob(AM))
			var/mob/MM = AM
			if(!(MM.movement_type & FLYING))
				triggermine(AM)
		else
			triggermine(AM)

/obj/effect/mine/proc/triggermine(mob/victim)
	if(triggered)
		return
	visible_message(span_danger("[victim]触发了[icon2html(src, viewers(src))] [src]！"))
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	mineEffect(victim)
	triggered = 1
	qdel(src)


/obj/effect/mine/explosive
	name = "爆炸地雷"
	var/range_devastation = 0
	var/range_heavy = 1
	var/range_light = 2
	var/range_flash = 3

/obj/effect/mine/explosive/mineEffect(mob/victim)
	explosion(loc, range_devastation, range_heavy, range_light, range_flash)


/obj/effect/mine/stun
	name = "眩晕地雷"
	var/stun_time = 80

/obj/effect/mine/stun/mineEffect(mob/living/victim)
	if(isliving(victim))
		victim.Paralyze(stun_time)

/obj/effect/mine/kickmine
	name = "踢人地雷"

/obj/effect/mine/kickmine/mineEffect(mob/victim)
	if(isliving(victim) && victim.client)
		to_chat(victim, span_danger("我平白无故就挨了一脚！"))
		qdel(victim.client)


/obj/effect/mine/gas
	name = "氧气地雷"
	var/gas_amount = 360
	var/gas_type = "o2"

/obj/effect/mine/gas/plasma
	name = "等离子地雷"
	gas_type = "plasma"


/obj/effect/mine/gas/n2o
	name = "\improper 笑气地雷"
	gas_type = "n2o"


/obj/effect/mine/sound
	name = "鸣笛爆响 1000"
	var/sound = 'sound/blank.ogg'

/obj/effect/mine/sound/mineEffect(mob/victim)
	playsound(loc, sound, 100, TRUE)


/obj/effect/mine/sound/bwoink
	name = "哔嗡地雷"
	sound = 'sound/blank.ogg'

/obj/effect/mine/pickup
	name = "拾取物"
	desc = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity2"
	density = FALSE
	var/duration = 0

/obj/effect/mine/pickup/Initialize(mapload)
	. = ..()
	animate(src, pixel_y = 4, time = 20, loop = -1)

/obj/effect/mine/pickup/triggermine(mob/victim)
	if(triggered)
		return
	triggered = 1
	invisibility = INVISIBILITY_ABSTRACT
	mineEffect(victim)
	qdel(src)

/obj/effect/mine/pickup/healing
	name = "蓝色宝珠"
	desc = ""
	color = "#0000FF"

/obj/effect/mine/pickup/healing/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, span_notice("我感觉棒极了！"))
	victim.revive(full_heal = TRUE, admin_revive = TRUE)

/obj/effect/mine/pickup/speed
	name = "黄色宝珠"
	desc = ""
	color = "#FFFF00"
	duration = 300

/obj/effect/mine/pickup/speed/mineEffect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, span_notice("我感觉自己快了起来！"))
	victim.add_movespeed_modifier(MOVESPEED_ID_YELLOW_ORB, update=TRUE, priority=100, multiplicative_slowdown=-2, blacklisted_movetypes=(FLYING|FLOATING))
	sleep(duration)
	victim.remove_movespeed_modifier(MOVESPEED_ID_YELLOW_ORB)
	to_chat(victim, span_notice("我慢下来了。"))
