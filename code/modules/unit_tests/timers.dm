/**
 * Exercises the timer core end to end.
 *
 * Covers bucket and client-time firing, both timer subsystems, timer cancellation,
 * TIMER_UNIQUE deduplication, per-subsystem ID isolation, and TIMER_LOOP.
 */
/datum/unit_test/timers
	var/list/fired = list()

/datum/unit_test/timers/proc/mark(key)
	fired[key] = (fired[key] || 0) + 1

/datum/unit_test/timers/Run()
	// timer_sanity only catches bucket_count going negative. A missed decrement leaks the
	// count upward instead and is invisible to it, so assert here that a full
	// schedule/fire/cancel cycle returns the count to where it started. Measured on
	// SSsound_loops because nothing else in the game schedules on it yet. Taking this
	// baseline from SStimer would be flaky, since the rest of the game keeps using it.
	var/sound_loops_baseline = SSsound_loops.bucket_count

	addtimer(CALLBACK(src, PROC_REF(mark), "bucket"), 1)

	// Check the list length rather than just that it fired: if TIMER_CLIENT_TIME were
	// ignored the timer would land in an ordinary bucket and fire anyway, so "it fired"
	// alone proves nothing about the flag. Other systems hold clienttime timers too,
	// hence the before/after delta rather than a non-empty check.
	var/clienttime_before = length(SStimer.clienttime_timers)
	addtimer(CALLBACK(src, PROC_REF(mark), "clienttime"), 1, TIMER_CLIENT_TIME)
	if(length(SStimer.clienttime_timers) != clienttime_before + 1)
		Fail("a TIMER_CLIENT_TIME timer did not land in clienttime_timers")

	addtimer(CALLBACK(src, PROC_REF(mark), "sound_loops"), 1, 0, SSsound_loops)

	var/kill_id = addtimer(CALLBACK(src, PROC_REF(mark), "deltimer_victim"), 1, TIMER_STOPPABLE)
	if(!deltimer(kill_id))
		Fail("deltimer returned FALSE for a live stoppable timer")

	addtimer(CALLBACK(src, PROC_REF(mark), "unique"), 1, TIMER_UNIQUE)
	addtimer(CALLBACK(src, PROC_REF(mark), "unique"), 1, TIMER_UNIQUE)

	var/loop_id = addtimer(CALLBACK(src, PROC_REF(mark), "loop"), 1, TIMER_LOOP | TIMER_STOPPABLE)

	// updatetimedelay stretches a loop before it ever fires: 1ds widened to 5s, so it lands
	// exactly once inside the 1 second window below
	var/stretch_id = addtimer(CALLBACK(src, PROC_REF(mark), "stretch"), 1, TIMER_LOOP | TIMER_STOPPABLE)
	updatetimedelay(stretch_id, 5 SECONDS)

	// Per-subsystem id isolation: an SSsound_loops timer id must not resolve in SStimer's dict.
	// The delay must stay inside the sleep window below, or the "fired anyway" check at the
	// end can never catch a failed deltimer. It silently passes no matter what.
	var/iso_id = addtimer(CALLBACK(src, PROC_REF(mark), "isolation_probe"), 1, TIMER_STOPPABLE, SSsound_loops)
	if(!isnull(timeleft(iso_id)))
		Fail("an SSsound_loops timer id resolved in SStimer's dict")
	if(isnull(timeleft(iso_id, SSsound_loops)))
		Fail("an SSsound_loops timer id did not resolve in its own subsystem's dict")
	if(!deltimer(iso_id, SSsound_loops))
		Fail("deltimer with an explicit subsystem returned FALSE for a live timer")

	sleep(1 SECONDS)

	// Exact counts, not "did it fire at all". A one-shot that fires twice is as broken as one
	// that never fires, and a nonzero check passes either way.
	if(fired["bucket"] != 1)
		Fail("a basic bucket timer fired [fired["bucket"] || 0] times, expected 1")
	if(fired["clienttime"] != 1)
		Fail("a TIMER_CLIENT_TIME timer fired [fired["clienttime"] || 0] times, expected 1")
	if(fired["sound_loops"] != 1)
		Fail("a timer scheduled on SSsound_loops fired [fired["sound_loops"] || 0] times, expected 1")
	if(fired["deltimer_victim"])
		Fail("a deltimer'd timer fired anyway")
	if(fired["unique"] != 1)
		Fail("TIMER_UNIQUE dedupe failed: [fired["unique"] || 0] fires from two identical schedules")
	if(!fired["loop"] || fired["loop"] < 5)
		Fail("a 1ds TIMER_LOOP fired [fired["loop"] || 0] times in a second")

	// Exactly one, not "at most one". updatetimedelay only rewrites wait, it does not reschedule
	// the pending first firing, so the 1ds fire still lands and the 5s repeat does not. Accepting
	// zero would let a version that discarded the timer entirely pass.
	if((fired["stretch"] || 0) != 1)
		Fail("updatetimedelay: [fired["stretch"] || 0] fires in a second, expected exactly 1")
	deltimer(stretch_id)
	deltimer(loop_id)
	var/loop_count = fired["loop"]
	sleep(0.5 SECONDS)
	if(fired["loop"] != loop_count)
		Fail("a TIMER_LOOP kept firing after deltimer")
	if(fired["isolation_probe"])
		Fail("the deltimer'd isolation probe fired anyway")

	// One timer fired and was reaped, one was deltimer'd before firing. Both must have
	// given their bucket slot back
	if(SSsound_loops.bucket_count != sound_loops_baseline)
		Fail("SSsound_loops bucket_count leaked: [sound_loops_baseline] before, [SSsound_loops.bucket_count] after a full schedule/fire/cancel cycle")
