/obj/item/flashlight/lantern/shrunken
	name = "shrunken lamp"
	desc = "A beacon."
	icon_state = "shrunkenlamp"
	item_state = "shrunkenlamp"
	lefthand_file = 'icons/roguetown/underworld/enigma_husks.dmi'
	righthand_file = 'icons/roguetown/underworld/enigma_husks.dmi'
	light_outer_range = 4
	light_power = 20
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	light_system = STATIC_LIGHT
/obj/item/flashlight/lantern/shrunken/update_brightness(mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)

/obj/structure/underworld/carriageman
	name = "The Carriageman"
	desc = "The dead pay tolls. The living may yet bargain. They will take the reigns and lead the way. But only if the price I can pay."
	icon = 'icons/roguetown/underworld/enigma_carriageman.dmi'
	icon_state = "carriageman"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE
	var/toll = FALSE
	var/list/pending_choice = list()
	var/list/pending_tokens = list()
	var/list/pending_has_shovel = list()
	var/list/pending_has_censer = list()
/obj/structure/underworld/carriageman/Initialize(mapload)
	. = ..()
	set_light(5, 4, 30, l_color = LIGHT_COLOR_BLUE)

/obj/structure/underworld/carriageman/examine(mob/user)
	. = ..()
	. += span_notice("The Carriageman accepts the Toll from the dead.")
	. += span_notice("Necrans who follow the Undermaiden may select and purchase boons with tokens of gratitude.")

/obj/structure/underworld/carriageman/proc/get_trade_key(mob/living/user)
	if(user?.ckey)
		return user.ckey
	return REF(user)

/obj/structure/underworld/carriageman/proc/follows_necra(mob/living/user)
	return user?.patron?.type == /datum/patron/divine/necra

/obj/structure/underworld/carriageman/proc/clear_trade_state(mob/living/user)
	var/key = get_trade_key(user)
	pending_choice -= key
	pending_tokens -= key
	pending_has_shovel -= key
	pending_has_censer -= key

/obj/structure/underworld/carriageman/proc/get_pending_tokens(mob/living/user)
	var/key = get_trade_key(user)
	return pending_tokens[key] || 0

/obj/structure/underworld/carriageman/proc/add_pending_tokens(mob/living/user, amt)
	if(amt <= 0)
		return
	var/key = get_trade_key(user)
	pending_tokens[key] = (pending_tokens[key] || 0) + amt

/obj/structure/underworld/carriageman/proc/get_required_tokens(choice)
	switch(choice)
		if("shovel")
			return 200
		if("censer")
			return 100
		if("cord")
			return 25
		if("scroll1")
			return 50
		if("scroll2")
			return 100
	return 0

/obj/structure/underworld/carriageman/proc/give_trade_reward(mob/living/user, obj/item/reward)
	if(!reward || !user)
		return
	if(!user.put_in_hands(reward, TRUE))
		reward.forceMove(get_turf(user))

/obj/structure/underworld/carriageman/proc/consume_token_payment(obj/item/roguecoin/necra_token/T, mob/living/user)
	var/key = get_trade_key(user)
	var/choice = pending_choice[key]
	if(!choice)
		return FALSE
	var/required = get_required_tokens(choice)
	var/current = get_pending_tokens(user)
	if(current >= required)
		to_chat(user, span_notice("I have already paid enough tokens for this request."))
		return TRUE
	var/need = required - current
	var/take = min(need, T.quantity)
	if(take <= 0)
		return TRUE
	add_pending_tokens(user, take)
	if(take >= T.quantity)
		qdel(T)
	else
		T.set_quantity(T.quantity - take)
	to_chat(user, span_notice("The Carriageman takes [take] token\s of gratitude."))
	return TRUE

/obj/structure/underworld/carriageman/proc/try_complete_trade(mob/living/user)
	var/key = get_trade_key(user)
	var/choice = pending_choice[key]
	if(!choice)
		return FALSE
	var/required = get_required_tokens(choice)
	if(get_pending_tokens(user) < required)
		return FALSE

	if(choice == "shovel")
		if(!pending_has_shovel[key])
			return FALSE
		new /obj/item/rogueweapon/shovel/mort_staff(get_turf(user))
		to_chat(user, span_notice("The Carriageman presents an unadorned mortician's staff."))

	if(choice == "censer")
		if(!pending_has_censer[key])
			return FALSE
		give_trade_reward(user, new /obj/item/necra_censer/upgraded(get_turf(user)))
		to_chat(user, span_notice("The Carriageman returns your censer, transformed by underworld ash."))

	if(choice == "cord")
		give_trade_reward(user, new /obj/item/rope/necran_cord(get_turf(user)))
		to_chat(user, span_notice("The Carriageman coils a pale burial-cord into your waiting hands."))

	if(choice == "scroll1")
		give_trade_reward(user, new /obj/item/underworld/carriageman_scroll/first(get_turf(user)))
		to_chat(user, span_notice("The Carriageman grants the first blessed scroll."))

	if(choice == "scroll2")
		give_trade_reward(user, new /obj/item/underworld/carriageman_scroll/second(get_turf(user)))
		to_chat(user, span_notice("The Carriageman grants the second blessed scroll."))

	playsound(user, pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 50, FALSE)
	clear_trade_state(user)
	return TRUE

/obj/structure/underworld/carriageman/attack_hand(mob/living/user)
	if(!istype(user, /mob/living/carbon/spirit))
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE) && follows_necra(user))
			var/key = get_trade_key(user)
			if(pending_choice[key])
				var/choice_action = alert(user, "The Carriageman already awaits the rest of your current offering. Must this bargain be canceled?", "Pending Trade", "Keep Current Trade", "Cancel Current Trade")
				if(choice_action == "Keep Current Trade" || !choice_action)
					to_chat(user, span_warning("This trade must be fulfilled before another may be chosen."))
					return
				clear_trade_state(user)
			var/list/options = list(
				"Burial Cord (25 tokens)",
				"Upgrade Necra censer (100 tokens + Necra's censer)",
				"Staff Blessing Scroll I (50 tokens)",
				"Staff Blessing Scroll II (100 tokens)",
				"Mortician's Staff (200 tokens + iron shovel)"
			)
			var/choice = input(user, "Choose a reward from the Carriageman", "Carriageman") as null|anything in options
			if(!choice)
				return
			clear_trade_state(user)
			switch(choice)
				if("Burial Cord (25 tokens)")
					pending_choice[key] = "cord"
				if("Upgrade Necra censer (100 tokens + Necra's censer)")
					pending_choice[key] = "censer"
				if("Staff Blessing Scroll I (50 tokens)")
					pending_choice[key] = "scroll1"
				if("Staff Blessing Scroll II (100 tokens)")
					pending_choice[key] = "scroll2"
				if("Mortician's Staff (200 tokens + iron shovel)")
					pending_choice[key] = "shovel"
			to_chat(user, span_notice("Your selection is made. Present the required offering now."))
			return
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE) && !follows_necra(user))
			to_chat(user, span_warning("You must be a follower of the Undermaiden to select boons."))
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)&& toll)
			to_chat(user, "<br><font color=purple><span class='bold'>HANDS EXCHANGE PAY AND OATHS GIVE WAY, BE ON YOUR WAY</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			toll = FALSE
			if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
				user.remove_status_effect(/datum/status_effect/debuff/ritesexpended)
			return
		if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE)&& !toll)
			to_chat(user, "<br><font color=purple><span class='bold'>RITES ARE A FICKLE THING, SWORN ONCE A DAY- <br> PAY THE TOLL, AND OATHS GIVE WAY</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			return
		to_chat(user, span_warning("The carriageman does not acknowledge the living."))
		return
	var/mob/living/carbon/spirit/ghost = user
	if(!ghost.paid)
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
		to_chat(user, "<br><font color=purple><span class='bold'>FETCH THE TOLL AND YOU MAY BOARD</span></font>")
	else
		to_chat(user, "<br><font color=purple><span class='bold'>HANDS EXCHANGE PAY, BE ON YOUR WAY</span></font>")
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)

/obj/structure/underworld/carriageman/attackby(obj/item/W, mob/living/user)
	if(!istype(user, /mob/living/carbon/spirit))
		// Bargain penance: let non-Necran revived players pay their toll to unlock the shrine exit
		if(HAS_TRAIT(user, TRAIT_BARGAIN_PENANCE_LOCKED) && istype(W, /obj/item/thetoll))
			qdel(W)
			REMOVE_TRAIT(user, TRAIT_BARGAIN_PENANCE_LOCKED, "bargain_penance")
			user.remove_status_effect(/datum/status_effect/debuff/necra_bargain_penance)
			to_chat(user, span_cultsmall("The Carriageman's bony hand accepts the toll. You feel the Undermaiden's hold on you loosen — the Way Out is yours to pass through once more."))
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0, 0, 50)
			return
		if(!HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
			to_chat(user, span_warning("The Carriageman does not acknowledge you."))
			return
		var/key = get_trade_key(user)
		var/choice = pending_choice[key]
		if(istype(W, /obj/item/thetoll) && !choice)
			if(toll)
				to_chat(user, "<br><font color=purple><span class='bold'>ONE TRANSACTION AT A TIME.</span></font>")
				return
			qdel(W)
			ensure_underworld_toll_present()
			to_chat(user, "<br><font color=purple><span class='bold'>THE TOLL IS PAID, A TRANSACTION MADE.</span></font>")
			toll = TRUE
			return
		if(!follows_necra(user))
			to_chat(user, span_warning("The Carriageman only bargains with followers of the Undermaiden."))
			return
		if(!choice)
			to_chat(user, span_warning("Choose a reward from the Carriageman first."))
			return
		if(istype(W, /obj/item/roguecoin/necra_token))
			var/obj/item/roguecoin/necra_token/T = W
			consume_token_payment(T, user)
			try_complete_trade(user)
			return
		if(choice == "shovel" && istype(W, /obj/item/rogueweapon/shovel) && !istype(W, /obj/item/rogueweapon/shovel/mort_staff))
			qdel(W)
			pending_has_shovel[key] = TRUE
			to_chat(user, span_notice("The Carriageman accepts the iron shovel."))
			try_complete_trade(user)
			return
		if(choice == "censer" && istype(W, /obj/item/necra_censer) && !istype(W, /obj/item/necra_censer/upgraded))
			qdel(W)
			pending_has_censer[key] = TRUE
			to_chat(user, span_notice("The Carriageman accepts your censer."))
			try_complete_trade(user)
			return
		to_chat(user, span_warning("This is not part of your selected offering."))
		return
	var/mob/living/carbon/spirit/ghost = user
	if(istype(W, /obj/item/underworld/coin))
		if(!ghost.paid)
			qdel(W)
			to_chat(ghost, "<br><font color=purple><span class='bold'>THE TOLL IS PAID, THROUGH THE CARRIAGE THE UNDERMAIDEN WAITS.</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
			ghost.paid = TRUE
			return
		if(ghost.paid)
			to_chat(ghost, "<br><font color=purple><span class='bold'>FURTHER PAYMENT WILL NOT CHANGE HER JUDGEMENT.</span></font>")
			user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)
	else
		to_chat(ghost, "<br><font color=purple><span class='bold'>ONLY THE TOLL WILL I ACCEPT</span></font>")
		user << sound(pick('sound/misc/carriage1.ogg', 'sound/misc/carriage2.ogg', 'sound/misc/carriage3.ogg', 'sound/misc/carriage4.ogg'), 0, 0 ,0, 50)

/obj/item/underworld/carriageman_scroll
	name = "blessing scroll"
	desc = "A pale vellum scroll etched with deathly sigils for a mortician's staff. Its rite is written plainly upon the parchment."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll"
	var/incantation = null
	var/power_scroll = FALSE

/obj/item/underworld/carriageman_scroll/first
	name = "blessing scroll I"
	desc = "The first of the Carriageman's blessings. It grants a mortician's staff a keen silver edge and must be used before the second blessed scroll."

/obj/item/underworld/carriageman_scroll/second
	name = "blessing scroll II"
	desc = "The second of the Carriageman's blessings. It deepens a previously blessed mortician's staff with greater strike power and durability. The first blessed scroll must be used before this one."
	power_scroll = TRUE
	incantation = "By the Undermaiden's power within this scroll, grant this holy staff endurance and strength!"

/// Debug: max-stack tokens of gratitude for testing
/obj/item/roguecoin/necra_token/debug_pile

/obj/item/roguecoin/necra_token/debug_pile/Initialize(mapload)
	. = ..()  
	set_quantity(200)

/obj/structure/underworld/barrier //Blocks sprite locations
	name = "DONT STAND HERE"
	desc = "The Undermaiden awaits."
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"
	density = TRUE
	anchored = TRUE

/obj/structure/underworld/carriage_normal
	name = "Carriage"
	desc = "The vale awaits."
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_normal"
	anchored = TRUE
	density = TRUE

/obj/structure/underworld/carriage_normal/Initialize(mapload)
	. = ..()
	set_light(5, 3, 30, l_color = LIGHT_COLOR_WHITE)

/obj/structure/underworld/carriage
	name = "Carriage"
	desc = "The Undermaiden awaits."
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_lit"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	density = TRUE


/obj/structure/underworld/carriage/Initialize(mapload)
	. = ..()
	set_light(5, 3, 30, l_color = LIGHT_COLOR_BLUE)

/obj/structure/underworld/carriage/attack_hand(mob/living/carbon/spirit/user)
	if(user.paid)
		switch(alert("Are you ready to be judged?",,"Yes","No"))
			if("Yes")
				playsound(user, 'sound/misc/deadbell.ogg', 50, TRUE, -2, ignore_walls = TRUE)
				user.returntolobby()
			if("No")
				usr << "You delay fate."
	else
		to_chat(user, "<B><font size=3 color=red>It's LOCKED.</font></B>")

GLOBAL_VAR_INIT(underworld_coins, 0)

/obj/item/underworld/coin
	name = "The Toll"
	desc = "This is more than just a coin."
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken_floor"
	var/should_track = TRUE

/obj/item/underworld/coin/Initialize(mapload)
	. = ..()
	if(should_track)
		GLOB.underworld_coins += 1

/obj/item/underworld/coin/Destroy()
	if(should_track)
		GLOB.underworld_coins -= 1
	coin_upkeep()
	return ..()

/obj/item/underworld/coin/pickup(mob/user)
	..()
	if(should_track)
		GLOB.underworld_coins -= 1
	coin_upkeep()
	icon_state = "soultoken"

/obj/item/underworld/coin/dropped(mob/user)
	..()
	if(should_track)
		GLOB.underworld_coins += 1
	icon_state = "soultoken_floor"

/obj/item/underworld/coin/notracking
	should_track = FALSE

/proc/ensure_underworld_toll_present()
	var/has_realm_toll = FALSE
	for(var/obj/item/thetoll/T in world)
		if(QDELETED(T))
			continue
		var/area/rogue/A = get_area(T)
		if(!isnull(A) && A.necra_area)
			has_realm_toll = TRUE
			break
	if(has_realm_toll)
		return

	var/list/valid_spawns = list()
	for(var/obj/effect/landmark/underworld_toll_spawn/L in GLOB.landmarks_list)
		valid_spawns += L
	if(!length(valid_spawns))
		for(var/obj/effect/landmark/underworldcoin/C in GLOB.landmarks_list)
			valid_spawns += C
	if(!length(valid_spawns))
		return

	var/obj/effect/landmark/chosen = pick(valid_spawns)
	var/turf/spawn_turf = get_turf(chosen)
	if(spawn_turf)
		new /obj/item/thetoll(spawn_turf)

/proc/coin_upkeep()
	if(GLOB.underworld_coins < 8)
		for(var/obj/effect/landmark/underworldcoin/B in GLOB.landmarks_list)
			new /obj/item/underworld/coin(B.loc)

/obj/item/detroyt_toll
	name = "Ticket"
	desc = "This is more than just compressed salt."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "ticket_detroyt"
