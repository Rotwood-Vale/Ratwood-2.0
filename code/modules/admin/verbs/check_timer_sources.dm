/**
 * Tallies live timers by their source, with the most prolific first.
 *
 * The source is the file and line recorded by the addtimer macro. Use this to find which
 * call sites are responsible when the live timer count keeps climbing.
 */
/client/proc/check_timer_sources()
	set category = "Debug"
	set name = "Check Timer Sources"
	if(!check_rights(R_DEBUG))
		return

	var/output = {"
		<h2>SStimer</h2>
		<h3>bucket_list</h3>
		[generate_timer_source_output(SStimer.bucket_list)]
		<h3>second_queue</h3>
		[generate_timer_source_output(SStimer.second_queue)]
		<h3>clienttime_timers</h3>
		[generate_timer_source_output(SStimer.clienttime_timers)]
		<h2>SSsound_loops</h2>
		<h3>bucket_list</h3>
		[generate_timer_source_output(SSsound_loops.bucket_list)]
		<h3>second_queue</h3>
		[generate_timer_source_output(SSsound_loops.second_queue)]
		<h3>clienttime_timers</h3>
		[generate_timer_source_output(SSsound_loops.clienttime_timers)]
	"}

	var/datum/browser/browser = new(usr, "check_timer_sources", "Timer Sources", 700, 700)
	browser.set_content(output)
	browser.open()

/proc/generate_timer_source_output(list/datum/timedevent/events)
	var/list/per_source = list()

	for (var/_event in events)
		if (!_event)
			continue
		var/datum/timedevent/event = _event

		// Capped like dump_timer_buckets(): the head check only catches a chain that loops back
		// to where it started, and this verb is run when timers are already misbehaving.
		var/anti_loop_check = 1000
		do
			var/source_key = event.source || "(no source recorded)"
			if (per_source[source_key] == null)
				per_source[source_key] = 1
			else
				per_source[source_key] += 1
			event = event.next
			anti_loop_check--
		while (event && event != _event && anti_loop_check)

	var/list/sorted = list()
	for (var/source in per_source)
		sorted += list(list("source" = source, "count" = per_source[source]))
	sortTim(sorted, GLOBAL_PROC_REF(cmp_timer_data))

	var/output = "<table border='1'>"

	for (var/_timer_data in sorted)
		var/list/timer_data = _timer_data
		output += {"<tr>
			<td><b>[timer_data["source"]]</b></td>
			<td>[timer_data["count"]]</td>
		</tr>"}

	output += "</table>"

	return output

/proc/cmp_timer_data(list/a, list/b)
	return b["count"] - a["count"]
