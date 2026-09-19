#define FUTURE_VOICE_MALE_GENERIC "Male Generic"
#define FUTURE_VOICE_FEMALE "Female"
#define FUTURE_VOICE_MALE "Male"


/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow
	name = "Ferentian Ration Can"
	desc = "<span class='yellow'><i>Made in bulk in Kingsfield, filling, and allegedly edible. I've eaten so many of these to know better than to ask what the slop inside is made of.</i></span>"
	icon = 'modular/timesoldier/sprites/stuff.dmi'
	icon_state = "bluechow" // temporary sprite as i work on actual sprites. shoutout to you matt, i love you forever.
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("salt" = 2, "processed meat" = 2, "something unidentifiable" = 1)
	foodtype = MEAT | GRAIN
	faretype = FARE_POOR
	bitesize = 4
	trash = /obj/item/trash/timesoldier/ferenchow
	drop_sound = 'modular/timesoldier/sounds/candrop.ogg'
	var/opened = FALSE


/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow/attack(mob/living/M, mob/living/user, def_zone)
	if(user.used_intent.type == INTENT_HARM || user.cmode)
		return ..()

	if(!opened)
		to_chat(user, span_warning("I need to open [src] first."))
		return

	return ..()


/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow/attackby(obj/item/W, mob/living/user, params)
	if(opened)
		return ..()

	if(W.wlength == WLENGTH_SHORT && user.used_intent?.blade_class in list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB))
		user.visible_message(
			span_notice("[user] pries open [src] with [W]."),
			span_notice("I pry open [src] with [W].")
		)
		playsound(src, 'modular/timesoldier/sounds/canopen.ogg', 60, TRUE)
		opened = TRUE
		icon_state = "bluechow_open"
		return

	to_chat(user, span_warning("I need something short and sharp to pry [src] open."))
	return


/obj/item/trash/timesoldier/ferenchow
	name = "empty Ferentian Ration Can"
	desc = "An empty military ration can. There's still some unpleasant bits stuck around inside. It looks like something out of Kingsfield!"
	icon = 'modular/timesoldier/sprites/stuff.dmi'
	icon_state = "bluechow_empty"
	experimental_inhand = TRUE


/obj/item/timesoldier/radio
	name = "field transceiver"
	desc = "<span class='yellow'><i>I still remember when we replaced these over the old SCOMRING. We'd be able to receive orders from so far away. They're powered by arcyne magick, and this one in particular has a piece of the comet in it. They told me it's so they can communicate across 'time'.</span><br><br>You can sense the power of the Comet SYON within this...It must have a very small fragment of it."
	icon = 'modular/timesoldier/sprites/stuff.dmi'
	icon_state = "radio_off"
	var/broadcasting = FALSE
	var/datum/looping_sound/timesoldier_radio/radio_loop

/datum/looping_sound/timesoldier_radio
	mid_sounds = 'modular/timesoldier/sounds/comms/lsloop.ogg'
	mid_length = 10
	volume = 35
	extra_range = 9
	persistent_loop = TRUE

/obj/item/timesoldier/radio/Destroy() // so if we qdel it - which we will, we don't accidentally leave the looping sound hanging in the air.
	QDEL_NULL(radio_loop)
	return ..()


/obj/item/timesoldier/radio/proc/start_broadcast()
	if(broadcasting)
		return
	
	broadcasting = TRUE
	icon_state = "radio_on"

	playsound(src, pick(
		'modular/timesoldier/sounds/comms/broadcast_start1.ogg',
		'modular/timesoldier/sounds/comms/broadcast_start2.ogg'
	), 45, TRUE)

	radio_loop = new(src, TRUE)

/obj/item/timesoldier/radio/proc/receive_broadcast(message)
	if(!broadcasting)
		return
	
	say(message)

/obj/item/timesoldier/radio/proc/end_broadcast()
	if(!broadcasting)
		return
	
	broadcasting = FALSE
	QDEL_NULL(radio_loop)
	playsound(src, 'modular/timesoldier/sounds/comms/broadcast_end1.ogg', 45, TRUE)
	icon_state = "radio_off"
