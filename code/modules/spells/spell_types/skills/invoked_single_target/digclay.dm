//a skill to help potters get clay
/obj/effect/proc_holder/spell/invoked/digclay
	name = "掘泥取陶"
	desc = "在泥地或湿土上挖掘陶土。"
	overlay_state = "dig"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 3 MINUTES
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/digclay/cast(list/targets, mob/user = usr)
	var/digtime = 50 SECONDS
	var/digamount = 5
	var/turf/T = get_turf(user)
	if(istype(T, /turf/open/floor/rogue/dirt) || istype(T, /turf/open/floor/rogue/dirt/road) || istype(T, /turf/open/floor/rogue/dirt/ambush))
		digtime = pick(10 SECONDS, 15 SECONDS, 20 SECONDS, 25 SECONDS, 30 SECONDS) //randomize times
		digamount = pick(5, 10, 15, 20, 25) //randomized amounts
		playsound(user, 'sound/items/dig_shovel.ogg', 25, TRUE)
		to_chat(user, span_warning("我开始向地里挖掘。"))
		if(do_after(user, digtime, target = user))			
			for(var/i=1, i<digamount,++i)
				var/obj/item/natural/clay/R = new /obj/item/natural/clay(user.drop_location())
				user.dropItemToGround(R)
			to_chat(user, span_warning("我挖出了一些可用的陶土！"))
			return TRUE
		else
			to_chat(user, span_warning("想挖陶土，我就得老老实实待在原地！"))
			return FALSE
	else
		to_chat(user, span_warning("我得在泥土上才能这么做。"))
		return FALSE
