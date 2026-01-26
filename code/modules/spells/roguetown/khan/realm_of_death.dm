/obj/effect/proc_holder/spell/invoked/realm_of_death
	name = "Realm of Death"
	desc = "Drag a victim into a shadowy realm where you will duel to the death."
	overlay_state = "raiseskele"
	antimagic_allowed = TRUE
	recharge_time = 3 MINUTES
	range = 7
	cast_without_targets = FALSE
	sound = null
	
	var/turf/khan_original_loc = null
	var/turf/victim_original_loc = null
	var/mob/living/carbon/human/current_victim = null
	var/active_duel = FALSE
	var/sound_channel = 0

/obj/effect/proc_holder/spell/invoked/realm_of_death/cast(list/targets, mob/living/carbon/human/user)
	if(active_duel)
		to_chat(user, span_warning("You are already in a Realm of Death!"))
		return FALSE
		
	var/mob/living/carbon/human/target = targets[1]
	
	if(!istype(target))
		to_chat(user, span_warning("You can only drag mortals into the Realm of Death!"))
		return FALSE
		
	if(target == user)
		to_chat(user, span_warning("You cannot duel yourself!"))
		return FALSE
		
	if(target.stat != CONSCIOUS)
		to_chat(user, span_warning("Your target must be conscious!"))
		return FALSE
		
	// Play wind-up sound
	playsound(get_turf(user), pick('sound/shuz/realm/oncast1.ogg', 'sound/shuz/realm/oncast2.ogg', 'sound/shuz/realm/oncast3.ogg'), 100, TRUE)
	
	// Wind-up visual
	user.visible_message(span_danger("[user] summons a shadowy hand that reaches for [target]!"))
	
	// Spawn the shadowy hand
	var/obj/effect/realm_hand/hand = new(get_turf(user))
	hand.realm_spell = src
	hand.target_mob = target
	hand.caster = user
	hand.start_pursuit()
	
	return TRUE

// Called by the shadowy hand when it hits
/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/teleport_to_realm(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(active_duel)
		return
	
	// Play onhit sound
	playsound(get_turf(target), 'sound/shuz/realm/onhit.ogg', 100, TRUE)
	
	// Store original locations
	khan_original_loc = get_turf(user)
	victim_original_loc = get_turf(target)
	current_victim = target
	active_duel = TRUE
	
	// Arena coordinates on CentCom (z=1)
	var/turf/khan_spawn = locate(48, 74, 1)
	var/turf/victim_spawn = locate(66, 74, 1)
	
	if(!khan_spawn || !victim_spawn)
		to_chat(user, span_warning("The Realm of Death cannot be accessed!"))
		active_duel = FALSE
		return
	
	// Teleport both to arena
	user.forceMove(khan_spawn)
	target.forceMove(victim_spawn)
	
	// Play welcome VO and show alert
	var/welcome_sound = pick('sound/shuz/realm/welcome1.ogg', 'sound/shuz/realm/welcome2.ogg', 'sound/shuz/realm/welcome3.ogg', 'sound/shuz/realm/welcome4.ogg')
	var/welcome_message
	switch(welcome_sound)
		if('sound/shuz/realm/welcome1.ogg')
			welcome_message = "You are in MY arena!"
		if('sound/shuz/realm/welcome2.ogg')
			welcome_message = "Hear them call!"
		if('sound/shuz/realm/welcome3.ogg')
			welcome_message = "A duel, then!"
		if('sound/shuz/realm/welcome4.ogg')
			welcome_message = "Your allies are GONE."
	
	playsound(get_turf(user), welcome_sound, 100, TRUE)
	to_chat(user, span_userdanger("[welcome_message]"))
	to_chat(target, span_userdanger("[welcome_message]"))
	
	// Start the karaoke song and lyrics
	start_karaoke(user, target)
	
	// Start monitoring the duel
	addtimer(CALLBACK(src, PROC_REF(monitor_duel), user, target), 2 SECONDS)
	
	// Auto-end after song finishes (99 seconds)
	addtimer(CALLBACK(src, PROC_REF(end_realm), user, target), 99 SECONDS)
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/monitor_duel(mob/living/carbon/human/khan, mob/living/carbon/human/victim)
	if(!active_duel)
		return
		
	// Check if duel should end
	if(!khan || !victim)
		end_realm(khan, victim)
		return
		
	// Instant death on unconsciousness in the death realm
	if(khan.stat >= SOFT_CRIT)
		to_chat(khan, span_userdanger("I fall in the Realm of Death... there is no mercy here."))
		khan.death()
		end_realm(khan, victim)
		return
		
	if(victim.stat >= SOFT_CRIT)
		to_chat(victim, span_userdanger("I fall in the Realm of Death... there is no mercy here."))
		victim.death()
		end_realm(khan, victim)
		return
		
	// Continue monitoring every 2 seconds
	addtimer(CALLBACK(src, PROC_REF(monitor_duel), khan, victim), 2 SECONDS)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/end_realm(mob/living/carbon/human/khan, mob/living/carbon/human/victim)
	if(!active_duel)
		return
		
	active_duel = FALSE
	
	// Check if victim survived (alive and conscious)
	var/victim_survived = (victim && victim.stat == CONSCIOUS && victim_original_loc)
	
	// Return to original locations
	if(khan && khan_original_loc)
		khan.forceMove(khan_original_loc)
		to_chat(khan, span_notice("You return from the Realm of Death."))
		
		// Khan voice lines if victim survived
		if(victim_survived)
			var/voice_choice = rand(1, 3)
			switch(voice_choice)
				if(1)
					playsound(get_turf(khan), 'sound/shuz/realm/vo1.ogg', 100, TRUE)
					khan.say("If you believe you are safe, you are a fool.", forced = "spell")
				if(2)
					playsound(get_turf(khan), 'sound/shuz/realm/vo2.ogg', 100, TRUE)
					khan.say("The gods spared you...for now.", forced = "spell")
				if(3)
					playsound(get_turf(khan), 'sound/shuz/realm/vo3.ogg', 100, TRUE)
					khan.say("You survived...hmm.", forced = "spell")
		
	if(victim && victim_original_loc)
		victim.forceMove(victim_original_loc)
		
		if(victim_survived)
			// Apply VICTOR stress relief and stat buffs
			to_chat(victim, span_greentext("I have survived the Khan's arena! I feel UNSTOPPABLE!"))
			victim.add_stress(/datum/stressevent/realm_victor)
			
			// Store original stats to restore later
			var/orig_str = victim.STASTR
			var/orig_spd = victim.STASPD
			var/orig_con = victim.STACON
			var/orig_wil = victim.STAWIL
			var/orig_per = victim.STAPER
			
			// Apply +3 to all stats
			victim.STASTR += 3
			victim.STASPD += 3
			victim.STACON += 3
			victim.STAWIL += 3
			victim.STAPER += 3
			
			// Remove buffs after 3 minutes
			addtimer(CALLBACK(src, PROC_REF(remove_victor_buffs), victim, orig_str, orig_spd, orig_con, orig_wil, orig_per), 3 MINUTES)
		else
			to_chat(victim, span_notice("You are released from the Realm of Death."))
	
	// Stop the song abruptly for both
	if(khan?.client)
		khan.stop_sound_channel(sound_channel)
	if(victim?.client)
		victim.stop_sound_channel(sound_channel)
	
	// Play deactivate sound
	playsound(get_turf(khan), 'sound/shuz/realm/deactivate.ogg', 100, TRUE)
	if(victim)
		playsound(get_turf(victim), 'sound/shuz/realm/deactivate.ogg', 100, TRUE)
	
	// Clear stored references
	khan_original_loc = null
	victim_original_loc = null
	current_victim = null
	
	// Clear any remaining lyrics from screens
	clear_all_lyrics(khan)
	clear_all_lyrics(victim)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/start_karaoke(mob/living/carbon/human/khan, mob/living/carbon/human/victim)
	// Get a dedicated sound channel
	sound_channel = SSsounds.random_available_channel()
	
	// Play the song for both
	if(khan?.client)
		khan.playsound_local(khan, 'sound/shuz/realm/duelsong.ogg', 80, FALSE, channel = sound_channel)
	if(victim?.client)
		victim.playsound_local(victim, 'sound/shuz/realm/duelsong.ogg', 80, FALSE, channel = sound_channel)
	
	// Schedule all lyrics
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "He will return with honor."), 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "He also swims across the river of the dead.", FALSE, 4.5), 10 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "The Unconquered king, Sahn-Uzal!", FALSE, 4), 16 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "Now he has left the world of the living for the Hall of Bones.", FALSE, 5), 24.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "The gods are waiting there respectfully..", FALSE, 4.5), 30 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "As they drank cup after cup of mead and sang loudly", FALSE, 4.5), 36 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "Will he frown and be unhappy?"), 41.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "Remember his past achievements?"), 45.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "His name is Sahn-Uzal..", FALSE, 5.5), 52 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "His name is Sahn-Uzal!", FALSE, 4.5), 58.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "HIS NAME IS SAHN-UZAL!", TRUE, 6), 65 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "His name is Sahn-Uzal!", FALSE, 5), 71 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric_bg), khan, victim, "(SAHN-UZAL! SAHN-UZAL!)"), 73 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "He will return with honor."), 76 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric_bg), khan, victim, "(SAHN-UZAL! SAHN-UZAL!)"), 78.75 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "He also swims across the river of the dead.", FALSE, 4.5), 82 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric_bg), khan, victim, "(SAHN-UZAL! SAHN-UZAL!)"), 85 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_lyric), khan, victim, "The Unconquered king, Sahn-Uzal!", FALSE, 4.5), 88 SECONDS)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/show_lyric(mob/living/carbon/human/khan, mob/living/carbon/human/victim, lyric_text, big = FALSE, duration = 2.8)
	if(!active_duel)
		return
		
	var/font_size = big ? "16px" : "12px"
	var/color = big ? "#FFD700" : "#FFFFFF"
	var/anim_time = duration * 10 // Convert to deciseconds for animation
	
	// Create screen object for Khan
	if(khan?.client)
		var/obj/screen/lyric/L = new()
		L.maptext = "<span style='font-size:[font_size];text-align:center;color:[color];text-shadow: 2px 2px 4px #000000'>[lyric_text]</span>"
		L.screen_loc = "CENTER:-200,NORTH-1:0"
		L.maptext_width = 400
		L.layer = SPLASHSCREEN_LAYER
		khan.client.screen += L
		
		// Animate downward and fade out
		animate(L, pixel_y = -48, alpha = 0, time = anim_time)
		
		// Remove after animation
		addtimer(CALLBACK(src, PROC_REF(remove_lyric), khan, L), duration SECONDS)
	
	// Same for victim
	if(victim?.client)
		var/obj/screen/lyric/L2 = new()
		L2.maptext = "<span style='font-size:[font_size];text-align:center;color:[color];text-shadow: 2px 2px 4px #000000'>[lyric_text]</span>"
		L2.screen_loc = "CENTER:-200,NORTH-1:0"
		L2.maptext_width = 400
		L2.layer = SPLASHSCREEN_LAYER
		victim.client.screen += L2
		animate(L2, pixel_y = -48, alpha = 0, time = anim_time)
		addtimer(CALLBACK(src, PROC_REF(remove_lyric), victim, L2), duration SECONDS)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/show_lyric_bg(mob/living/carbon/human/khan, mob/living/carbon/human/victim, lyric_text)
	if(!active_duel)
		return
		
	// Background vocals - smaller, italicized, different color, fades faster
	if(khan?.client)
		var/obj/screen/lyric/L = new()
		L.maptext = "<span style='font-size:10px;text-align:center;color:#AAAAAA;font-style:italic;text-shadow: 2px 2px 4px #000000'>[lyric_text]</span>"
		L.screen_loc = "CENTER:-200,NORTH-2:0"
		L.maptext_width = 400
		L.layer = SPLASHSCREEN_LAYER
		khan.client.screen += L
		animate(L, pixel_y = -32, alpha = 0, time = 18)
		addtimer(CALLBACK(src, PROC_REF(remove_lyric), khan, L), 2 SECONDS)
	
	if(victim?.client)
		var/obj/screen/lyric/L2 = new()
		L2.maptext = "<span style='font-size:10px;text-align:center;color:#AAAAAA;font-style:italic;text-shadow: 2px 2px 4px #000000'>[lyric_text]</span>"
		L2.screen_loc = "CENTER:-200,NORTH-2:0"
		L2.maptext_width = 400
		L2.layer = SPLASHSCREEN_LAYER
		victim.client.screen += L2
		animate(L2, pixel_y = -32, alpha = 0, time = 18)
		addtimer(CALLBACK(src, PROC_REF(remove_lyric), victim, L2), 2 SECONDS)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/remove_lyric(mob/M, obj/screen/lyric/L)
	if(M?.client && L)
		M.client.screen -= L
		qdel(L)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/clear_all_lyrics(mob/M)
	if(!M?.client)
		return
	for(var/obj/screen/lyric/L in M.client.screen)
		M.client.screen -= L
		qdel(L)

/obj/effect/proc_holder/spell/invoked/realm_of_death/proc/remove_victor_buffs(mob/living/carbon/human/victim, orig_str, orig_spd, orig_con, orig_wil, orig_per)
	if(!victim)
		return
	// Restore original stats
	victim.STASTR = orig_str
	victim.STASPD = orig_spd
	victim.STACON = orig_con
	victim.STAWIL = orig_wil
	victim.STAPER = orig_per
	to_chat(victim, span_warning("The power from surviving the Realm of Death fades..."))

// Screen object for lyrics
/obj/screen/lyric
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER,SOUTH"
	maptext_width = 400
	maptext_height = 32

// Stress event for surviving the Realm of Death
/datum/stressevent/realm_victor
	timer = 3 MINUTES
	stressadd = -15
	desc = span_greentext("I have survived the Khan's arena! I feel UNSTOPPABLE!")

// Shadowy hand effect that chases the target
/obj/effect/realm_hand
	name = "shadowy hand"
	desc = "A grasping hand of pure darkness."
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	layer = ABOVE_MOB_LAYER
	density = FALSE
	anchored = TRUE
	
	var/obj/effect/proc_holder/spell/invoked/realm_of_death/realm_spell
	var/mob/living/carbon/human/target_mob
	var/mob/living/carbon/human/caster
	
/obj/effect/realm_hand/Initialize(mapload)
	. = ..()
	// Auto-delete after 5 seconds
	addtimer(CALLBACK(src, PROC_REF(fade_away)), 5 SECONDS)
	
/obj/effect/realm_hand/proc/start_pursuit()
	if(!target_mob)
		qdel(src)
		return
	// Use walk_towards with delay of 3 (slow movement)
	walk_towards(src, target_mob, 0, 3)
	
/obj/effect/realm_hand/proc/fade_away()
	walk(src, 0) // Stop movement
	qdel(src)
	
/obj/effect/realm_hand/Bump(atom/A)
	. = ..()
	if(!realm_spell || !caster)
		qdel(src)
		return
		
	if(ishuman(A) && A == target_mob)
		// Play onhit sound
		playsound(get_turf(A), 'sound/shuz/realm/onhit.ogg', 100, TRUE)
		
		// Stop movement and delete
		walk(src, 0)
		
		// Trigger the realm teleport
		realm_spell.teleport_to_realm(target_mob, caster)
		
		qdel(src)
		
/obj/effect/realm_hand/Crossed(atom/movable/AM)
	. = ..()
	if(!realm_spell || !caster)
		qdel(src)
		return
		
	if(ishuman(AM) && AM == target_mob)
		// Play onhit sound
		playsound(get_turf(AM), 'sound/shuz/realm/onhit.ogg', 100, TRUE)
		
		// Stop movement and delete
		walk(src, 0)
		
		// Trigger the realm teleport
		realm_spell.teleport_to_realm(target_mob, caster)
		
		qdel(src)
