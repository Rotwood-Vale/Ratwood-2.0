/// Token duration and seeks must follow the file's actual playback rate without changing its pitch
/datum/unit_test/sound_token_timing/Run()
	var/obj/emitter = allocate(/obj)
	var/sound/played = sound('sound/misc/DrillDone.ogg')
	played.frequency = 44100
	var/datum/sound_token/token = new(emitter, played, _sound_duration_override = 100, _delete_on_end = TRUE, _sample_rate = 48000)
	allocated += token
	TEST_ASSERT(!QDELETED(token), "The timing fixture must reserve a channel")
	TEST_ASSERT_EQUAL(token.sound.frequency, 44100, "Timing correction must leave the transmitted pitch unchanged")
	TEST_ASSERT(abs(token.playback_speed - 0.91875) < 0.0001, "A 48 kHz file at 44.1 kHz plays at 91.875% speed")
	TEST_ASSERT_EQUAL(length(token.active_timers), 1, "A one-shot must have one cleanup timer")
	var/datum/timedevent/ending = token.active_timers[1]
	TEST_ASSERT(ending.wait >= 100 / 0.91875 && ending.wait < 100 / 0.91875 + world.tick_lag + 0.001, "Cleanup must include the slower playback, rounded up to the tick")
	token.start_time = REALTIMEOFDAY - 50
	var/elapsed_before = REALTIMEOFDAY - token.start_time
	var/offset = token.calculate_offset(100)
	var/elapsed_after = REALTIMEOFDAY - token.start_time
	TEST_ASSERT(offset >= elapsed_before * 0.91875 / 10 - 0.001 && offset <= elapsed_after * 0.91875 / 10 + 0.001, "Late listeners must seek at the same speed as the cleanup timer")
	token.start_time = REALTIMEOFDAY - 105
	TEST_ASSERT_NOTNULL(token.calculate_offset(100), "The slowed clip must still be playing after its unscaled duration")
	token.start_time = REALTIMEOFDAY - 110
	TEST_ASSERT_NULL(token.calculate_offset(100), "A finished one-shot must not restart for a late arrival")
	TEST_ASSERT_EQUAL(token.calculate_offset(0), 0, "Unknown duration must not seek beyond the file")

	var/datum/sound_token/normal = new(emitter, 'sound/misc/TheDrill.ogg', _sound_duration_override = 100)
	allocated += normal
	TEST_ASSERT(!QDELETED(normal), "The normal-speed fixture must reserve a channel")
	TEST_ASSERT_EQUAL(normal.playback_speed, 1, "An unvaried recording keeps its natural speed")
	played = sound('sound/misc/TheDrill.ogg')
	played.frequency = 43100
	normal.update_sound(played)
	TEST_ASSERT(abs(normal.playback_speed - 43100 / 44100) < 0.0001, "The existing 44.1 kHz variation must retain its timing")
	played.frequency = 2
	normal.update_sound(played)
	TEST_ASSERT_EQUAL(normal.playback_speed, 2, "A relative frequency is already a speed multiplier")
	played.frequency = 0
	normal.update_sound(played)
	TEST_ASSERT_EQUAL(normal.playback_speed, 1, "Replacing a varied file must clear its old speed")

/// Exercise direct-loop packet state without a client. Hearing and slider scaling still need a client test
/datum/unit_test/direct_loop_volume/Run()
	var/mob/listener = allocate(/mob)
	var/datum/looping_sound/loop = new(listener, _direct = TRUE, _channel = CHANNEL_WEATHER)
	allocated += loop
	var/sound/playing = sound('sound/weather/rain/weather_rain.ogg', channel = CHANNEL_WEATHER, volume = 80)
	playing.frequency = 43000
	playing.environment = SOUND_DEFAULT_ENVIRONMENT
	var/list/echo = new /list(18)
	playing.echo = echo
	loop.direct_sound = playing
	loop.set_volume(0)
	TEST_ASSERT_EQUAL(playing.volume, 0, "Zero volume must silence the active sound")
	TEST_ASSERT(playing.status & SOUND_MUTE, "Zero must mute without stopping playback")
	TEST_ASSERT(playing.status & SOUND_UPDATE, "Volume updates must not restart the file")
	loop.set_volume(30)
	TEST_ASSERT_EQUAL(playing.volume, 30, "Unmuting must use the latest volume")
	TEST_ASSERT(!(playing.status & SOUND_MUTE), "Unmuting must clear the old mute bit")
	TEST_ASSERT_EQUAL(playing.frequency, 43000, "A volume change must preserve frequency")
	TEST_ASSERT_EQUAL(playing.environment, SOUND_DEFAULT_ENVIRONMENT, "A volume change must preserve the room")
	TEST_ASSERT_EQUAL(playing.echo, echo, "A volume change must reuse the existing echo settings")
	TEST_ASSERT_EQUAL(playing.file, 'sound/weather/rain/weather_rain.ogg', "A volume change must preserve the loaded file")
	loop.set_volume(500)
	TEST_ASSERT_EQUAL(playing.volume, 100, "Direct updates must retain the playback volume cap")

	// No client can accept this replay, so the last successful send must remain available
	loop.play('sound/weather/rain/weather_storm.ogg')
	TEST_ASSERT_EQUAL(loop.direct_sound, playing, "A refused replay must not replace the last sound sent")
	var/sound/replacement = sound('sound/weather/rain/weather_storm.ogg', channel = CHANNEL_WEATHER)
	loop.direct_sound = replacement
	loop.set_volume(20)
	TEST_ASSERT_EQUAL(replacement.volume, 20, "A new playback must receive subsequent updates")
	TEST_ASSERT_EQUAL(playing.volume, 100, "A replaced sound must no longer be modified")
	loop.stop_current()
	loop.set_volume(40)
	TEST_ASSERT_NULL(loop.direct_sound, "A stopped channel must not be repriced")
	loop.direct_sound = replacement
	loop.stop()
	TEST_ASSERT_NULL(loop.direct_sound, "Stopping an inactive loop must also clear its sound")
	loop.direct_sound = replacement
	loop.set_parent(listener)
	TEST_ASSERT_EQUAL(loop.direct_sound, replacement, "Keeping the same parent must preserve playback state")
	var/mob/other_listener = allocate(/mob)
	loop.set_parent(other_listener)
	TEST_ASSERT_NULL(loop.direct_sound, "A new parent must not inherit another listener's sound")
