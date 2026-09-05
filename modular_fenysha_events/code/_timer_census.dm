/**
 * Tallies what is actually sitting in SStimer, grouped by callback.
 *
 * SStimer's own dump only runs once the subsystem has already stalled, and it
 * prints one line per timer - useless at the twenty thousand that a flood puts
 * there. This counts instead, so whatever is creating them lands at the top.
 */

/client/proc/fenysha_timer_census()
	set category = "Debug"
	set name = "Timer Census"
	set desc = "Tally pending timers by callback, worst first."

	if(!check_rights(R_DEBUG))
		return

	var/list/tally = list()
	var/total = 0

	for(var/datum/timedevent/head as anything in SStimer.bucket_list)
		if(!head)
			continue
		/*
		 * Buckets are circular doubly linked lists. The guard mirrors the one
		 * in the subsystem's own dump - a corrupted bucket is exactly the sort
		 * of thing this gets run to find, so it must not be able to hang.
		 */
		var/datum/timedevent/node = head
		var/guard = 100000
		do
			total += timer_census_add(tally, node)
			node = node.next
			guard--
		while(node && node != head && guard)

	for(var/datum/timedevent/event as anything in SStimer.second_queue)
		total += timer_census_add(tally, event)

	for(var/datum/timedevent/event as anything in SStimer.clienttime_timers)
		total += timer_census_add(tally, event)

	var/list/lines = list(
		"<b>[total] pending timers</b> across [length(tally)] distinct callbacks",
		"B:[SStimer.bucket_count] P:[length(SStimer.second_queue)] H:[length(SStimer.hashes)] C:[length(SStimer.clienttime_timers)] S:[length(SStimer.timer_id_dict)]",
		"---",
	)

	// Repeated max rather than a sort: the tally is short, and this keeps the
	// verb from depending on a sorting helper being present and behaving.
	for(var/i in 1 to 40)
		var/best
		var/best_count = 0
		for(var/key in tally)
			if(tally[key] > best_count)
				best_count = tally[key]
				best = key
		if(!best)
			break
		lines += "[best_count] - [best]"
		tally -= best

	to_chat(src, span_notice(jointext(lines, "<br>")))

/// One timer into the tally. Returns 1 so the caller can total as it walks.
/proc/timer_census_add(list/tally, datum/timedevent/event)
	if(!event)
		return 0

	var/key
	var/datum/callback/call_back = event.callBack
	if(!call_back)
		key = "(no callback)"
	else
		// object defaults to GLOBAL_PROC, which is not a datum - so anything
		// that fails istype is a global proc rather than a method on something.
		var/datum/target = call_back.object
		key = "[istype(target) ? "[target.type]" : "global"] -> [call_back.delegate]"

	tally[key] += 1
	return 1
