/obj/effect/proc_holder/spell/targeted/realm_of_death
	name = "Realm of Death"
	desc = "Drag a victim into a shadowy realm where you will duel to the death."
	overlay_state = "raiseskele"
	antimagic_allowed = TRUE
	recharge_time = 3 MINUTES
	range = 7
	selection_type = "view"
	include_user = FALSE
	
	var/turf/khan_original_loc = null
	var/turf/victim_original_loc = null
	var/mob/living/carbon/human/current_victim = null
	var/active_duel = FALSE

/obj/effect/proc_holder/spell/targeted/realm_of_death/cast(list/targets, mob/living/carbon/human/user)
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
		
	// Wind-up visual
	user.visible_message(span_danger("[user] summons a shadowy hand that reaches for [target]!"))
	
	// Brief delay for wind-up
	sleep(1.5 SECONDS)
	
	// Store original locations
	khan_original_loc = get_turf(user)
	victim_original_loc = get_turf(target)
	current_victim = target
	active_duel = TRUE
	
	// Arena coordinates on CentCom (z=1)
	var/turf/khan_spawn = locate(48, 74, 1)
	var/turf/victim_spawn = locate(66, 74, 1)
	
	// Teleport both to arena
	user.forceMove(khan_spawn)
	target.forceMove(victim_spawn)
	
	// Messages
	to_chat(user, span_userdanger("You drag [target] into your Realm of Death!"))
	to_chat(target, span_userdanger("You are pulled into a shadowy realm of eternal combat!"))
	
	// Start the karaoke song and lyrics
	start_karaoke(user, target)
	
	// Start monitoring the duel
	addtimer(CALLBACK(src, PROC_REF(monitor_duel), user, target), 2 SECONDS)
	
	// Auto-end after song finishes (99 seconds)
	addtimer(CALLBACK(src, PROC_REF(end_realm), user, target), 99 SECONDS)
	
	return TRUE

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/monitor_duel(mob/living/carbon/human/khan, mob/living/carbon/human/victim)
	if(!active_duel)
		return
		
	// Check if duel should end
	if(!khan || !victim)
		end_realm(khan, victim)
		return
		
	if(khan.stat >= SOFT_CRIT || victim.stat >= SOFT_CRIT)
		end_realm(khan, victim)
		return
		
	// Continue monitoring every 2 seconds
	addtimer(CALLBACK(src, PROC_REF(monitor_duel), khan, victim), 2 SECONDS)

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/end_realm(mob/living/carbon/human/khan, mob/living/carbon/human/victim)
	if(!active_duel)
		return
		
	active_duel = FALSE
	
	// Return to original locations
	if(khan && khan_original_loc)
		khan.forceMove(khan_original_loc)
		to_chat(khan, span_notice("You return from the Realm of Death."))
		
	if(victim && victim_original_loc)
		victim.forceMove(victim_original_loc)
		to_chat(victim, span_notice("You are released from the Realm of Death."))
	
	// Clear stored references
	khan_original_loc = null
	victim_original_loc = null
	current_victim = null
	
	// Clear any remaining lyrics from screens
	clear_all_lyrics(khan)
	clear_all_lyrics(victim)

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/start_karaoke(mob/living/carbon/human/khan, mob/living/carbon/human/victim)
	// Play the song for both
	if(khan?.client)
		khan.playsound_local(khan, 'sound/shuz/realm/duelsong.ogg', 80, FALSE)
	if(victim?.client)
		victim.playsound_local(victim, 'sound/shuz/realm/duelsong.ogg', 80, FALSE)
	
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

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/show_lyric(mob/living/carbon/human/khan, mob/living/carbon/human/victim, lyric_text, big = FALSE, duration = 2.8)
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

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/show_lyric_bg(mob/living/carbon/human/khan, mob/living/carbon/human/victim, lyric_text)
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

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/remove_lyric(mob/M, obj/screen/lyric/L)
	if(M?.client && L)
		M.client.screen -= L
		qdel(L)

/obj/effect/proc_holder/spell/targeted/realm_of_death/proc/clear_all_lyrics(mob/M)
	if(!M?.client)
		return
	for(var/obj/screen/lyric/L in M.client.screen)
		M.client.screen -= L
		qdel(L)

// Screen object for lyrics
/obj/screen/lyric
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER,SOUTH"
	maptext_width = 400
	maptext_height = 32
