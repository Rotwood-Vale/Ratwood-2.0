/obj/effect/proc_holder/spell/invoked/avatar_ultimate
	name = "Avatar"
	desc = "Channel the full power of the Khan for 99 seconds. After this time, your mortal body will be consumed."
	overlay_state = "raiseskele"
	antimagic_allowed = TRUE
	recharge_time = 0 // Can only be used once
	range = 0
	cast_without_targets = TRUE
	sound = null
	var/used = FALSE

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/cast(list/targets, mob/living/carbon/human/user)
	if(used)
		to_chat(user, span_warning("You have already used your Avatar power!"))
		return FALSE
	
	if(!istype(user))
		return FALSE
	
	// Check if they have the Avatar antagonist datum
	var/datum/antagonist/khan_sahnuzal/avatar/avatar_datum = user.mind?.has_antag_datum(/datum/antagonist/khan_sahnuzal/avatar)
	if(!avatar_datum)
		to_chat(user, span_warning("You are not an Avatar of the Khan!"))
		return FALSE
	
	// Start wind-up (cannot be interrupted)
	user.visible_message(
		span_danger("[user] begins channeling an immense power!"),
		span_userdanger("You channel the power of the Khan!")
	)
	
	// Play wind-up sound
	playsound(user, 'sound/shuz/avatar/oncast.ogg', 100, TRUE)
	
	// Make them immobile during wind-up
	user.Immobilize(3 SECONDS)
	
	// Wait for wind-up
	sleep(3 SECONDS)
	
	// Check if they're still valid
	if(!user || user.stat != CONSCIOUS)
		return FALSE
	
	used = TRUE
	
	// Play activation sound
	playsound(user, 'sound/shuz/avatar/activate.ogg', 100, TRUE)
	
	// Start the transformation sequence
	start_avatar_sequence(user, avatar_datum)
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/proc/start_avatar_sequence(mob/living/carbon/human/user, datum/antagonist/khan_sahnuzal/avatar/avatar_datum)
	// Apply orange particle effect
	var/particles/avatar_sparkles/P = new()
	user.particles = P
	
	// Get all mobs who can see the avatar
	var/list/viewers = list()
	for(var/mob/M in view(14, user))
		if(M.client)
			viewers += M
	
	// Play the transformation music and show lyrics to everyone
	play_avatar_karaoke(user, viewers)
	
	// Activate the avatar transformation after the full song completes (around 92 seconds)
	addtimer(CALLBACK(avatar_datum, TYPE_PROC_REF(/datum/antagonist/khan_sahnuzal/avatar, activate_avatar), user), 3 SECONDS)
	
	// The particle effect stays active until death

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/proc/play_avatar_karaoke(mob/living/carbon/human/user, list/viewers)
	// Stop all sounds for viewers first
	for(var/mob/M in viewers)
		if(M.client)
			M.playsound_local(M, null, 0, FALSE, channel = CHANNEL_NOTIFY, pressure_affected = FALSE)
	
	// Get a dedicated sound channel
	var/sound_channel = SSsounds.random_available_channel()
	
	// Play the song for all viewers
	for(var/mob/M in viewers)
		if(M.client)
			M.playsound_local(M, 'sound/shuz/realm/duelsong.ogg', 80, FALSE, channel = sound_channel)
	
	// Show transformation message
	user.visible_message(
		span_userdanger("[user] begins to glow with an otherworldly power!"),
		span_userdanger("You channel the full might of the Khan!")
	)
	
	// Schedule all lyrics with exact same timing as realm_of_death
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "He will return with honor."), 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "He also swims across the river of the dead.", FALSE, 4.5), 10 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "The Unconquered king, Sahn-Uzal!", FALSE, 4), 16 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "Now he has left the world of the living for the Hall of Bones.", FALSE, 5), 24.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "The gods are waiting there respectfully..", FALSE, 4.5), 30 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "As they drank cup after cup of mead and sang loudly", FALSE, 4.5), 36 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "Will he frown and be unhappy?"), 41.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "Remember his past achievements?"), 45.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "His name is Sahn-Uzal..", FALSE, 5.5), 52 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "His name is Sahn-Uzal!", FALSE, 4.5), 58.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "HIS NAME IS SAHN-UZAL!", TRUE, 6), 65 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "His name is Sahn-Uzal!", FALSE, 5), 71 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric_bg), viewers, "(SAHN-UZAL! SAHN-UZAL!)"), 73 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "He will return with honor."), 76 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric_bg), viewers, "(SAHN-UZAL! SAHN-UZAL!)"), 78.75 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "He also swims across the river of the dead.", FALSE, 4.5), 82 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric_bg), viewers, "(SAHN-UZAL! SAHN-UZAL!)"), 85 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(show_avatar_lyric), viewers, "The Unconquered king, Sahn-Uzal!", FALSE, 4.5), 88 SECONDS)

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/proc/show_avatar_lyric(list/viewers, lyric_text, big = FALSE, duration = 2.8)
	var/font_size = big ? "16px" : "12px"
	var/color = big ? "#FFD700" : "#FFFFFF"
	var/anim_time = duration * 10 // Convert to deciseconds for animation
	
	for(var/mob/M in viewers)
		if(!M?.client)
			continue
		
		var/obj/screen/lyric/L = new()
		L.maptext = "<span style='font-size:[font_size];text-align:center;color:[color];text-shadow: 2px 2px 4px #000000'>[lyric_text]</span>"
		L.screen_loc = "CENTER:-200,NORTH-1:0"
		L.maptext_width = 400
		L.layer = SPLASHSCREEN_LAYER
		M.client.screen += L
		
		// Animate downward and fade out
		animate(L, pixel_y = -48, alpha = 0, time = anim_time)
		
		// Remove after animation
		addtimer(CALLBACK(src, PROC_REF(remove_avatar_lyric), M, L), duration SECONDS)

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/proc/show_avatar_lyric_bg(list/viewers, lyric_text)
	// Background vocals - smaller, italicized, different color, fades faster
	for(var/mob/M in viewers)
		if(!M?.client)
			continue
		
		var/obj/screen/lyric/L = new()
		L.maptext = "<span style='font-size:10px;text-align:center;color:#AAAAAA;font-style:italic;text-shadow: 2px 2px 4px #000000'>[lyric_text]</span>"
		L.screen_loc = "CENTER:-200,NORTH-2:0"
		L.maptext_width = 400
		L.layer = SPLASHSCREEN_LAYER
		M.client.screen += L
		animate(L, pixel_y = -32, alpha = 0, time = 18)
		addtimer(CALLBACK(src, PROC_REF(remove_avatar_lyric), M, L), 2 SECONDS)

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/proc/remove_avatar_lyric(mob/M, obj/screen/lyric/L)
	if(M?.client && L)
		M.client.screen -= L
		qdel(L)

/obj/effect/proc_holder/spell/invoked/avatar_ultimate/proc/clear_all_avatar_lyrics(list/viewers)
	for(var/mob/M in viewers)
		if(!M?.client)
			continue
		for(var/obj/screen/lyric/L in M.client.screen)
			M.client.screen -= L
			qdel(L)

// Orange sparkle particle effect
/particles/avatar_sparkles
	name = "avatar_sparkles"
	width = 124
	height = 124
	count = 24
	spawning = 8
	lifespan = 1.5 SECONDS
	fade = 0.5 SECONDS
	position = generator("circle", -16, 16, NORMAL_RAND)
	gravity = list(0, 0.5)
	velocity = generator("box", list(-8, -8, 0), list(8, 12, 5), NORMAL_RAND)
	friction = 0.15
	gradient = list(0, "#FFA500", 0.5, "#FF8C00", 1, "#FF6347")
	color_change = 0.125
	color = 0
	transform = list(1,0,0,0, 0,1,0,0, 0,0,1,1/5, 0,0,0,1)

// Screen object for lyrics (reused from realm_of_death)
/obj/screen/lyric
	icon_state = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

