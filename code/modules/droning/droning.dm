//Used to manage sending droning sounds to various clients
SUBSYSTEM_DEF(droning)
	name = "Droning"
	flags = SS_NO_INIT|SS_NO_FIRE

/datum/controller/subsystem/droning/proc/get_channel_volume(client/listener, channel)
	if(!listener?.prefs)
		return 50
	if(channel == CHANNEL_BUZZ || channel == CHANNEL_CMUSIC1 || channel == CHANNEL_CMUSIC2 || channel == CHANNEL_CMUSIC3 || channel == CHANNEL_CMUSIC4)
		var/combat_volume = listener.prefs.combatmusicvol
		if(!isnum(combat_volume))
			combat_volume = listener.prefs.musicvol
		if(!isnum(combat_volume))
			combat_volume = initial(listener.prefs.combatmusicvol)
		return clamp(combat_volume, 0, 100)
	if(channel == CHANNEL_AMBIENCE || channel == CHANNEL_RAIN)
		return listener.prefs.ambiencevol
	if(channel == CHANNEL_MUSIC)
		return listener.prefs.musicvol
	if(channel == CHANNEL_LOBBYMUSIC)
		return listener.prefs.lobbymusicvol
	return listener.prefs.musicvol

/datum/controller/subsystem/droning/proc/area_entered(area/area_entered, client/entering)
	if(!area_entered || !entering)
		return
/*
	if(HAS_TRAIT(entering.mob, TRAIT_LEAN) && !area_entered.droning_sound)
		//just kill the previous droning sound
		kill_droning(entering)
		return
	if(HAS_TRAIT(entering.mob, TRAIT_BLOODARN) && !area_entered.droning_sound)
		//just kill the previous droning sound
		kill_droning(entering)
		return
*/
	var/list/last_droning = list()
	last_droning |= entering.last_droning_sound
	var/list/new_droning = list()
	new_droning |= area_entered.droning_sound_current

	if(HAS_TRAIT(entering.mob, TRAIT_PSYCHOSIS))
		new_droning = list('sound/music/dreamer_is_still_asleep.ogg')

	//Same ambience, don't bother
	if(last_droning ~= new_droning)
		return
	play_area_sound(area_entered, entering)

/datum/controller/subsystem/droning/proc/play_area_sound(area/area_player, client/listener)
	if(!area_player || !listener)
		return
	
	if(SSticker.current_state >= GAME_STATE_FINISHED) //stop drones in round end
		return

	if(area_player.we_droning_here)

		if(!area_player.droning_sound)
			return
		var/used_sound

		if(GLOB.tod == "dawn")
			if(area_player.droning_sound_dawn)
				used_sound = area_player.droning_sound_dawn
			else
				used_sound = area_player.droning_sound

		if(GLOB.tod == "day")
			if(area_player.droning_sound)
				used_sound = area_player.droning_sound
			else
				used_sound = null

		if(GLOB.tod == "dusk")
			if(area_player.droning_sound_dusk)
				used_sound = area_player.droning_sound_dusk
			else
				used_sound = area_player.droning_sound

		if(GLOB.tod == "night")
			if(area_player.droning_sound_night)
				used_sound = area_player.droning_sound_night
			else
				used_sound = area_player.droning_sound

		if(HAS_TRAIT(listener.mob, TRAIT_PSYCHOSIS))
			used_sound = list('sound/music/dreamer_is_still_asleep.ogg')
		else if(HAS_TRAIT(listener.mob, TRAIT_DRUQK))
			used_sound = list('sound/music/spice.ogg', 100)
		//our music for real
		area_player.droning_sound_current = used_sound
		//last phase!
		if(listener?.mob.cmode)
			last_phase(area_player, listener, shouldskip = TRUE)
		else
			last_phase(area_player, listener, shouldskip = FALSE)

/datum/controller/subsystem/droning/proc/play_combat_music(music = null, client/dreamer)
	if(!music || !dreamer)
		return

	var/frenq = 1

	if(HAS_TRAIT(dreamer.mob, TRAIT_DRUQK))
		frenq = -1

	if(ishuman(dreamer.mob))
		var/mob/living/carbon/human/H = dreamer.mob
		if(H.has_status_effect(/datum/status_effect/buff/moondust))
			frenq = 2
		if(H.has_status_effect(/datum/status_effect/buff/weed))
			frenq = 0.5

	//kill the previous droning sound
	kill_droning(dreamer)
	var/sound/combat_music = sound(pick(music), repeat = TRUE, wait = 0, channel = CHANNEL_BUZZ, volume = get_channel_volume(dreamer, CHANNEL_BUZZ) * 1.2)
	combat_music.frequency = frenq
	if(!HAS_TRAIT(dreamer.mob, TRAIT_DRUQK))
		combat_music.pitch = 1 / combat_music.frequency
	SEND_SOUND(dreamer, combat_music)
	dreamer.droning_sound = combat_music
	dreamer.last_droning_sound = combat_music.file

/datum/controller/subsystem/droning/proc/last_phase(area/area_player, client/listener, shouldskip = FALSE)
	if(!area_player || !listener)
		return
	if(!listener?.droning_sound)
		shouldskip = TRUE
	if(listener?.mob.cmode)
		shouldskip = TRUE
	if(shouldskip)
		var/sound/droning = sound(pick(area_player.droning_sound_current), area_player.droning_repeat, area_player.droning_wait, area_player.droning_channel, get_channel_volume(listener, area_player.droning_channel))


		if(HAS_TRAIT(listener.mob, TRAIT_PSYCHOSIS))
			droning.file = 'sound/music/dreamer_is_still_asleep.ogg'
		else if(HAS_TRAIT(listener.mob, TRAIT_DRUQK))
			droning.file = 'sound/music/spice.ogg'

		listener.droning_sound = droning
		listener.last_droning_sound = area_player.droning_sound
		SEND_SOUND(listener, droning)
	else
		var/sound/sound_killer = sound()
		sound_killer.channel = listener.droning_sound.channel
		sound_killer.volume = get_channel_volume(listener, sound_killer.channel)
		while(sound_killer.volume > 0)
			if(sound_killer.volume <= 0)
				break
			sound_killer.volume = max(sound_killer.volume - 5, 0)
			sound_killer.status = SOUND_UPDATE
			SEND_SOUND(listener, sound_killer)
			sleep(1)
		listener.droning_sound = null
		listener.last_droning_sound = null
		var/sound/droning = sound(pick(area_player.droning_sound_current), area_player.droning_repeat, area_player.droning_wait, area_player.droning_channel, get_channel_volume(listener, area_player.droning_channel))

		if(HAS_TRAIT(listener.mob, TRAIT_PSYCHOSIS))
			droning.file = 'sound/music/dreamer_is_still_asleep.ogg'
		else if(HAS_TRAIT(listener.mob, TRAIT_DRUQK))
			droning.file = 'sound/music/spice.ogg'

		listener.droning_sound = droning
		listener.last_droning_sound = area_player.droning_sound_current
		SEND_SOUND(listener, droning)

/datum/controller/subsystem/droning/proc/kill_droning(client/victim)
	if(!victim?.droning_sound)
		return
	var/sound/sound_killer = sound('sound/blank.ogg')
	sound_killer.channel = victim.droning_sound.channel
	SEND_SOUND(victim, sound_killer)
	victim.droning_sound = null
	victim.last_droning_sound = null

/datum/controller/subsystem/droning/proc/play_loop(area/area_entered, client/dreamer)
	if(!area_entered || !dreamer)
		return

	var/amb_sound_list = null
	if(area_entered.we_looping_here)
		if(GLOB.tod == "night")
			if(area_entered.ambientnight)
				amb_sound_list = area_entered.ambientnight
		else
			if(area_entered.ambientsounds)
				amb_sound_list = area_entered.ambientsounds

	if(dreamer.loop_sound_file && islist(amb_sound_list) && (dreamer.loop_sound_file in amb_sound_list))
		if(dreamer.loop_sound)
			return

	//kill the previous looping only when we need to change or clear it
	kill_loop(dreamer)

	if(!amb_sound_list)
		return
	var/loop_file = pick(amb_sound_list)
	var/sound/loop_sound = sound(loop_file, repeat = TRUE, wait = 0, channel = CHANNEL_AMBIENCE, volume = dreamer?.prefs.ambiencevol)
	SEND_SOUND(dreamer, loop_sound)
	dreamer.loop_sound = TRUE
	dreamer.loop_sound_file = loop_file

/datum/controller/subsystem/droning/proc/kill_loop(client/victim)
	SHOULD_NOT_SLEEP(TRUE)
	if(!victim?.loop_sound)
		return
	victim?.mob.stop_sound_channel(CHANNEL_AMBIENCE)
	victim?.loop_sound = FALSE
	victim.loop_sound_file = null

/datum/controller/subsystem/droning/proc/kill_rain(client/victim)
	if(!victim?.rain_sound)
		return
	victim?.mob.stop_sound_channel(CHANNEL_RAIN)
	victim?.rain_sound = FALSE

/datum/controller/subsystem/droning/proc/play_rain(area/area_entered, client/dreamer)
	if(!area_entered || !dreamer)
		return
	kill_rain(dreamer)

	var/amb_sound_list = null
	if(area_entered.ambientrain)
		amb_sound_list = area_entered.ambientrain

	if(!amb_sound_list)
		return
	var/sound/loop_sound = sound(pick(amb_sound_list), repeat = TRUE, wait = 0, channel = CHANNEL_RAIN, volume = dreamer?.prefs.ambiencevol)
	SEND_SOUND(dreamer, loop_sound)
	dreamer.rain_sound = TRUE
