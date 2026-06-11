/obj/machinery/light/rogue
	icon = 'icons/roguetown/misc/lighting.dmi'
	brightness = 8
	nightshift_allowed = FALSE
	fueluse = 60 MINUTES
	bulb_colour = "#f9ad80"
	bulb_power = 1
	var/datum/looping_sound/soundloop = null // = /datum/looping_sound/fireloop
	pass_flags = LETPASSTHROW
	flags_1 = NODECONSTRUCT_1
	var/no_refuel = FALSE // For special holder that don't actually refuel
	var/cookonme = FALSE
	var/crossfire = TRUE
	var/can_damage = FALSE
	var/heat_level = 0

/obj/machinery/light/rogue/proc/update_turf_heat()
	if(!heat_level)
		return
	var/turf/open/floor/T = loc
	if(!isfloorturf(T))
		return
	if(on)
		T.add_heat_source(src, heat_level)
	else
		T.remove_heat_source(src)

/obj/machinery/light/rogue/Moved(atom/OldLoc, Dir)
	. = ..()
	if(!heat_level)
		return
	if(isfloorturf(OldLoc))
		var/turf/open/floor/T = OldLoc
		T.remove_heat_source(src)
	update_turf_heat()

/obj/machinery/light/rogue/Initialize(mapload)
	if(soundloop)
		soundloop = new soundloop(src, FALSE)
		soundloop.start()
	GLOB.fires_list += src
	if(fueluse > 0)
		fueluse = fueluse - (rand(fueluse*0.1,fueluse*0.3))
	update_icon()
	seton(TRUE)
	update_turf_heat()
	. = ..()

/obj/machinery/light/rogue/weather_trigger(W)
	if(W==/datum/weather/rain)
		START_PROCESSING(SSweather,src)

/obj/machinery/light/rogue/OnCrafted(dirin, user)
	. = ..()
	can_damage = TRUE
	burn_out()

/obj/machinery/light/rogue/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(fueluse > 0)
			var/minsleft = fueluse / 600
			minsleft = round(minsleft)
			if(minsleft <= 1)
				minsleft = "不到一分钟"
			else
				minsleft = "[round(minsleft)]分钟"
			. += span_info("火焰还能持续[minsleft]。")
		else
			if(initial(fueluse) > 0)
				. += span_warning("火焰已经燃尽，正渴望燃料...")


/obj/machinery/light/rogue/extinguish()
	if(on)
		burn_out()
		new /obj/effect/temp_visual/small_smoke(src.loc)
	..()

/obj/machinery/light/rogue/burn_out()
	if(soundloop)
		soundloop.stop()
	if(on)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
	..()
	update_icon()

/obj/machinery/light/rogue/update_icon()
	if(on)
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]0"

/obj/machinery/light/rogue/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src
	update_turf_heat()

/obj/machinery/light/rogue/Destroy()
	QDEL_NULL(soundloop)
	GLOB.fires_list -= src
	if(heat_level && isfloorturf(loc))
		var/turf/open/floor/T = loc
		T.remove_heat_source(src)
	. = ..()

/obj/machinery/light/rogue/fire_act(added, maxstacks)
	if(!on && ((fueluse > 0) || (initial(fueluse) == 0)))
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		on = TRUE
		update()
		update_icon()
		if(soundloop)
			soundloop.start()
		addtimer(CALLBACK(src, PROC_REF(trigger_weather)), rand(5,20))
		return TRUE

/obj/proc/trigger_weather()
	if(!QDELETED(src))
		if(isturf(loc))
			var/turf/T = loc
			T.trigger_weather(src)

/obj/machinery/light/rogue/Crossed(atom/movable/AM, oldLoc)
	..()
	if(crossfire)
		if(on)
			AM.fire_act(1,5)

/obj/machinery/light/rogue/spark_act()
	fire_act()

/obj/machinery/light/rogue/attackby(obj/item/W, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	if(cookonme && on)
		if(istype(W, /obj/item/reagent_containers/food/snacks))
			if(istype(W, /obj/item/reagent_containers/food/snacks/egg))
				to_chat(user, "<span class='warning'>这个没法放在火上烤……</span>")
				return FALSE
			var/obj/item/A = user.get_inactive_held_item()
			if(A)
				var/foundstab = FALSE
				for(var/X in A.possible_item_intents)
					var/datum/intent/D = new X
					if(D.blade_class == BCLASS_STAB)
						foundstab = TRUE
						break
				if(foundstab)
					var/prob2spoil = 33
					if(user.get_skill_level(/datum/skill/craft/cooking))
						prob2spoil = 1
					var/already_rolled = FALSE
					user.visible_message("<span class='notice'>[user]开始在[src]上烹调[W]。</span>")
					for(var/i in 1 to 6)
						if(do_after(user, 30 / cooktime_divisor, target = src))
							var/obj/item/reagent_containers/food/snacks/S = W
							var/obj/item/C
							if(prob(prob2spoil) && !already_rolled)
								user.visible_message("<span class='warning'>[user]把[S]烤糊了。</span>")
								if(user.client?.prefs.showrolls)
									to_chat(user, "<span class='warning'>大失败……[prob2spoil]%。</span>")
								C = S.cooking(1000, 1000, null)
							else
								already_rolled = TRUE
								C = S.cooking(S.cooktime/4, S.cooktime/4, src)
							if(C)
								user.dropItemToGround(S, TRUE)
								qdel(S)
								C.forceMove(get_turf(user))
								user.put_in_hands(C)
								break
						else
							break
					return
	if(W.firefuel && !no_refuel)
		if(W.smeltresult) // For things with actual smelt results - functionally no differences
			if(alert(usr, "要用[W]给[src]添燃料吗？", "燃料操作", "添燃料", "冶炼") != "添燃料")
				return TRUE
		if(alert(usr, "要用[W]给[src]添燃料吗？", "燃料操作", "是", "否") != "是")
			return TRUE
		if(!W)
			return
		if(user.get_active_held_item() != W)
			to_chat(user, span_warning("那件物品已经不在我手里了……"))
			return

		user.dropItemToGround(W)

		if(initial(fueluse))
			if(fueluse > initial(fueluse) - 5 SECONDS)
				to_chat(user, "<span class='warning'>[src]的燃料已经满了。</span>")
				return
		else
			if(!on)
				return
		qdel(W)
		user.visible_message("<span class='warning'>[user]把[W]添进了[src]。</span>")
		if(initial(fueluse))
			fueluse = fueluse + W.firefuel
			if(fueluse > initial(fueluse)) //keep it at the max
				fueluse = initial(fueluse)
		return
	else
		if(on)
			if(istype(W, /obj/item/natural/dirtclod))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				on = FALSE
				set_light(0)
				update_icon()
				update_turf_heat()
				qdel(W)
				src.visible_message("<span class='warning'>[user]熄灭了火焰。</span>")
				return
			if(user.used_intent?.type != INTENT_SPLASH)
				W.spark_act()
	. = ..()

/obj/machinery/light/rogue/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	if(!can_damage)
		return
	. = ..()
