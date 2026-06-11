GLOBAL_VAR(moneymaster)

/obj/structure/roguemachine/money
	name = "机器"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "money1"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/budget = 0
	var/izmaster = FALSE
	anchored = TRUE

/obj/structure/roguemachine/money/attackby(obj/item/P, mob/user, params)
	if(!user.cmode)
		if(istype(P, /obj/item/roguecoin))
			budget += P.get_real_price()
			qdel(P)
			update_icon()
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return
		else if(P.get_real_price())
			if(izmaster)
				return ..()
			if(!GLOB.moneymaster)
				say("主人们都不在了吗？")
				playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
				return
			if(P.get_real_price() > 100)
				say("这得交给一位公会长交易。")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return
			var/obj/structure/roguemachine/money/twins/T = GLOB.moneymaster
			var/amtofsale = round(P.get_real_price()/2)
			if(amtofsale >= 1)
				if(T.budget >= amtofsale)
					T.budget -= amtofsale
					budget += amtofsale
					update_icon()
				else
					say("主人们出不起这个价……")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
			P.forceMove(T.loc)
			playsound(T.loc, 'sound/misc/hiss.ogg', 100, TRUE, -1)
			say("物品已收下，价值 [amtofsale] 玛门。")
			playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
			playsound(T, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)

		return
	..()


/obj/structure/roguemachine/money/Initialize(mapload)
	. = ..()
	icon_state = "money[rand(1,2)]"
	update_icon()

/obj/structure/roguemachine/money/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/money/r/Initialize(mapload)
	. = ..()
	icon_state = "money1"
	update_icon()

/obj/structure/roguemachine/money/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/money/l/Initialize(mapload)
	. = ..()
	icon_state = "money2"
	update_icon()

/obj/structure/roguemachine/money/attack_hand(mob/living/user)
	. = ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)
	to_chat(user, span_info("我顺时针摩挲这台机器。"))
	if(budget > 0)
		say("[budget] 玛门归我所有……")
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	update_icon()

/obj/structure/roguemachine/money/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/inputt = alert(user,"金、银，还是铜？",,"BRONZE","SILVER","GOLD")
	if(inputt && Adjacent(user))
		to_chat(user, span_info("我拉动了[inputt]那根舌头。"))
		if(inputt == "BRONZE" && budget >= 50)
			budget2change(budget, user, inputt)
			budget = 0
			if(isliving(user))
				var/mob/living/L = user
				L.emote("scream")
				L.Paralyze(50)
				L.Stun(50)
				L.visible_message(span_danger("[user]被埋进了一座硬币山里！"))
		else
			budget2change(budget, user, inputt)
			switch(inputt)
				if("GOLD")
					var/zenars = budget/10
					if(zenars >= 1)
						for(var/i in 1 to zenars)
							budget -= 10
				if("SILVER")
					var/zenars = budget/5
					if(zenars >= 1)
						for(var/i in 1 to zenars)
							budget -= 5
				if("BRONZE")
					if(budget >= 1)
						for(var/i in 1 to budget)
							budget -= 1
		update_icon()

/obj/structure/roguemachine/proc/budget2change(budget, mob/user, specify)
	var/turf/T
	if(!user || (!ismob(user)))
		T = get_turf(src)
	else
		T = get_turf(user)
	if(!budget || budget <= 0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	if(specify)
		switch(specify)
			if("金币")
				zenars_to_put = budget/10
				type_to_put = /obj/item/roguecoin/gold
			if("银币")
				zenars_to_put = budget/5
				type_to_put = /obj/item/roguecoin/silver
			if("铜币")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/copper
			if("MARQUE")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/inqcoin
	else
		var/highest_found = FALSE
		var/zenars = floor(budget/10)
		if(zenars)
			budget -= zenars * 10
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/gold
			zenars_to_put = zenars
		zenars = floor(budget/5)
		if(zenars)
			budget -= zenars * 5
			if(!highest_found)
				highest_found = TRUE
				type_to_put = /obj/item/roguecoin/silver
				zenars_to_put = zenars
			else
				// Create multiple stacks if needed
				while(zenars > 0)
					var/stack_size = min(zenars, 20)
					var/obj/item/roguecoin/silver_stack = new /obj/item/roguecoin/silver(T, stack_size)
					if(user && zenars == stack_size) // Only put first stack in hands
						user.put_in_hands(silver_stack)
					zenars -= stack_size
		if(budget >= 1)
			if(!highest_found)
				type_to_put = /obj/item/roguecoin/copper
				zenars_to_put = budget
			else
				// Create multiple stacks if needed
				while(budget > 0)
					var/stack_size = min(budget, 20)
					var/obj/item/roguecoin/copper_stack = new /obj/item/roguecoin/copper(T, stack_size)
					if(user && budget == stack_size) // Only put first stack in hands
						user.put_in_hands(copper_stack)
					budget -= stack_size
	if(!type_to_put || zenars_to_put < 1)
		return
	// Create multiple stacks if needed for the main type
	while(zenars_to_put > 0)
		var/stack_size = min(zenars_to_put, 20)
		var/obj/item/roguecoin/G = new type_to_put(T, stack_size)
		if(user && zenars_to_put == stack_size) // Only put first stack in hands
			user.put_in_hands(G)
		zenars_to_put -= stack_size
	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
/*
/obj/structure/roguemachine/money/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	speaking = !speaking
	to_chat(user, span_info("我按下右眼。"))
	update_icon()
*/
/obj/structure/roguemachine/money/obj_break(damage_flag)
	..()
	budget2change(budget)
	budget = 0
	update_icon()

/obj/structure/roguemachine/money/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")

/obj/structure/roguemachine/money/Destroy()
	set_light(0)
	budget2change(budget)
	budget = 0
	return ..()

/obj/structure/roguemachine/money/twins
	name = "雅努斯双子"
	desc = "他们或许能替你保管钱财。"
	icon_state = "twins"
	icon = 'icons/roguetown/misc/64x64.dmi'
	budget = 0
	pixel_x = -16
	izmaster = TRUE

/obj/structure/roguemachine/money/twins/Initialize(mapload)
	. = ..()
	budget = rand(50,200)
	icon_state = "twins"
	update_icon()
	GLOB.moneymaster = src

/obj/structure/roguemachine/money/twins/obj_break(damage_flag)
	. = ..()
	GLOB.moneymaster = null

/obj/structure/roguemachine/money/twins/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	if(budget > 10)
		add_overlay(mutable_appearance(icon, "[icon_state]-e"))
	else
		add_overlay(mutable_appearance(icon, "[icon_state]-b"))
	set_light(1, 1, 1, l_color = "#1b7bf1")
