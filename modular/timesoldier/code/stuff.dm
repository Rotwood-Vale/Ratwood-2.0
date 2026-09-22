#define FUTURE_VOICE_MALE_GENERIC "Male Generic" // regular guy.
#define FUTURE_VOICE_FEMALE "Female" // girlboss.
#define FUTURE_VOICE_MALE "Male" // the guy that likes yelling.

#define FUTURE_LANGUAGE_IMPERIAL "Imperial"
#define FUTURE_LANGUAGE_NEW_IMPERIAL "New Imperial"


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

	if(W.wlength == WLENGTH_SHORT && (user.used_intent?.blade_class in list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB)))
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
	var/voice_template = FUTURE_VOICE_MALE_GENERIC
	var/broadcast_language = FUTURE_LANGUAGE_NEW_IMPERIAL
	var/radio_noise_timer
	verb_say = "coldly states"
	verb_ask = "coldly states"
	verb_exclaim = "coldly states"
	verb_yell = "coldly states"
	grid_width = 32
	grid_height = 32 // smol
	voicecolor_override = "97cefd"
	var/tmp/language_icon_html = ""


/obj/item/timesoldier/radio/say_quote(input, list/spans = list(speech_span), message_mode)
	var/rendered = ..()
	return "<span style='color:#97cefd;'>[rendered]</span>"


/obj/item/timesoldier/radio/GetVoice()
	return "[language_icon_html]<span style='font-size: 115%;'><b>UNKNOWN</b></span>"

/obj/item/timesoldier/radio/proc/get_language_icon_for(atom/movable/hearer, datum/language/language) // blatantly stolen from our language stuff.
	if(!language)
		return ""

	if(!ismob(hearer))
		return ""

	var/mob/M = hearer

	if(!M.client)
		return ""

	if(!M.show_language_icon())
		return ""

	if(!language.display_icon(M))
		return ""

	var/language_name = url_encode(language.name)
	var/language_desc = url_encode(language.desc)

	return "<a href='byond://?src=\ref[M.client];lang_name=[language_name];lang_desc=[language_desc]'><span style=\"position: relative; bottom: 4px;\">[language.get_icon()]</span></a>"

/datum/looping_sound/timesoldier_radio
	mid_sounds = 'modular/timesoldier/sounds/comms/lsloop.ogg'
	mid_length = 10
	volume = 100
	extra_range = 9
	persistent_loop = TRUE

/obj/item/timesoldier/radio/Destroy() // so if we qdel it - which we will, we don't accidentally leave the looping sound hanging in the air.
	if(radio_noise_timer)
		deltimer(radio_noise_timer)
		radio_noise_timer = null


	QDEL_NULL(radio_loop)
	return ..()


/obj/item/timesoldier/radio/proc/start_broadcast(selected_voice, selected_language)
	if(broadcasting)
		return

	broadcasting = TRUE
	icon_state = "radio_on"
	voice_template = selected_voice
	broadcast_language = selected_language

	visible_message(
	span_notice("[src]'s Naledi time-crystal gently clinks against the COMET shard, its strange internals sending it to lyfe with a low, steady hum.")
	)

	playsound(src, pick('modular/timesoldier/sounds/comms/broadcast_start1.ogg', 'modular/timesoldier/sounds/comms/broadcast_start2.ogg'), 45, FALSE)

	QDEL_NULL(radio_loop) // just in case we somehow have it already from before.
	radio_loop = new(src, TRUE)

	schedule_radio_noise()

/obj/item/timesoldier/radio/proc/message_is_yelling(message)
	if(!message)
		return FALSE

	for(var/i = length(message), i >= 1, i--)
		var/character = copytext(message, i, i + 1)

		if(character == "!")
			return TRUE

		if(character in list (" ", "\t", ".", "?", "\"", "'", ")", "]"))
			continue
		return FALSE
	return FALSE


/obj/item/timesoldier/radio/proc/receive_broadcast(message)
	if(!broadcasting)
		return

	playsound(src, 'modular/timesoldier/sounds/comms/startspeak.ogg', 55, FALSE)
	addtimer(CALLBACK(src, PROC_REF(deliver_broadcast), message), 4)

/obj/item/timesoldier/radio/proc/deliver_broadcast(message)
	if(!broadcasting)
		return

	var/sound_to_play

	switch(voice_template)
		if(FUTURE_VOICE_MALE_GENERIC)
			sound_to_play = pick('modular/timesoldier/sounds/comms/male_generic/generic1.ogg', 'modular/timesoldier/sounds/comms/male_generic/generic2.ogg', 'modular/timesoldier/sounds/comms/male_generic/generic3.ogg', 'modular/timesoldier/sounds/comms/male_generic/generic4.ogg', 'modular/timesoldier/sounds/comms/male_generic/generic5.ogg')

		if(FUTURE_VOICE_FEMALE)
			sound_to_play = pick('modular/timesoldier/sounds/comms/female/female1.ogg', 'modular/timesoldier/sounds/comms/female/female2.ogg', 'modular/timesoldier/sounds/comms/female/female3.ogg', 'modular/timesoldier/sounds/comms/female/female4.ogg', 'modular/timesoldier/sounds/comms/female/female5.ogg')

		if(FUTURE_VOICE_MALE)
			if(message_is_yelling(message))
				sound_to_play = pick('modular/timesoldier/sounds/comms/male_important/maley1.ogg', 'modular/timesoldier/sounds/comms/male_important/maley2.ogg', 'modular/timesoldier/sounds/comms/male_important/maley3.ogg')
			else
				sound_to_play = pick('modular/timesoldier/sounds/comms/male_important/male1.ogg', 'modular/timesoldier/sounds/comms/male_important/male2.ogg', 'modular/timesoldier/sounds/comms/male_important/male3.ogg')
		
	if(sound_to_play)
		playsound(src, sound_to_play, 55, FALSE)

	switch(broadcast_language)
		if(FUTURE_LANGUAGE_IMPERIAL)
			say_imperial(message)
		if(FUTURE_LANGUAGE_NEW_IMPERIAL)
			say_new_imperial(message)

/obj/item/timesoldier/radio/proc/schedule_radio_noise()
	if(!broadcasting)
		return

	if(radio_noise_timer)
		deltimer(radio_noise_timer)

	var/noise_delay = rand(15 SECONDS, 40 SECONDS) // i cant believe the compiler choked on this.
	var/datum/callback/noise_callback = CALLBACK(src, PROC_REF(play_radio_noise))
	radio_noise_timer = addtimer(noise_callback, noise_delay, TIMER_STOPPABLE) // this should hopefully properly fix it.

/obj/item/timesoldier/radio/proc/play_radio_noise()
	radio_noise_timer = null

	if(!broadcasting)
		return

	playsound(src, 'modular/timesoldier/sounds/comms/lsnoise.ogg', 50, FALSE)
	schedule_radio_noise()

/obj/item/timesoldier/radio/proc/end_broadcast()
	if(!broadcasting)
		return

	broadcasting = FALSE
	QDEL_NULL(radio_loop)
	playsound(src, 'modular/timesoldier/sounds/comms/broadcast_end1.ogg', 45, FALSE)

	visible_message(
	span_notice("[src]'s internal hum winds down before falling completely silent, the Naledi time-crystal pushing away from the COMET shard.")
	)
	icon_state = "radio_off"

	if(radio_noise_timer)
		deltimer(radio_noise_timer)
		radio_noise_timer = null


// RADIO TRANSLATION STUFF.

/obj/item/timesoldier/radio/proc/say_imperial(message)
	var/list/hearers = get_hearers_in_view(7, src)
	var/list/spans = list()
	spans |= speech_span

	var/rendered_message = compose_message(
		src,
		/datum/language/common,
		message,
		null,
		spans,
		null
	)

	for(var/atom/movable/hearer as anything in hearers)
		if(!hearer)
			continue

		hearer.Hear(
			rendered_message,
			src,
			/datum/language/common,
			message,
			null,
			spans,
			null
		)


/obj/item/timesoldier/radio/proc/say_new_imperial(message)
	var/datum/language/new_imperial/new_imperial = GLOB.language_datum_instances[/datum/language/new_imperial]
	if(!new_imperial)
		return

	var/list/hearers = get_hearers_in_view(7, src)
	var/list/spans = list()
	spans |= speech_span

	for(var/atom/movable/hearer as anything in hearers)
		if(!hearer)
			continue

		var/heard_message = "\[The speech is completely unintelligible..\]"
		var/datum/language/delivery_language = /datum/language/common
		if(isobserver(hearer))
			heard_message = message
		else if(isliving(hearer))
			var/mob/living/living_hearer = hearer
			heard_message = new_imperial.translate_for(living_hearer, message)

			// native New Imperial speakers should receive ACTUAL New Imperial. because this is literally a hack and its actually old imperial.
			if(living_hearer.has_language(/datum/language/new_imperial))
				delivery_language = /datum/language/new_imperial

		// if we're delivering actual New Imperial, Ratwood will render
		// the language icon natively.
		//
		// Otherwise we're using old imperial internally only as a carrier for
		// our manually translated partial-comprehension text, so manually
		// show the New Imperial icon.
		if(delivery_language == /datum/language/new_imperial)
			language_icon_html = ""
		else
			language_icon_html = get_language_icon_for(hearer, new_imperial)

		var/rendered_message = compose_message(
			src,
			delivery_language,
			heard_message,
			null,
			spans,
			null
		)

		hearer.Hear(
			rendered_message,
			src,
			delivery_language,
			heard_message,
			null,
			spans,
			null
		)

		language_icon_html = "" // gotta be after hear otherwise hear recomposes the message so only clear this after we...uh...hear.
