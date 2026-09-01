/// Tallies every live timer by the file:line that created it (recorded by the addtimer
/// macro), most prolific first. The tool for "the timer count is climbing, who is doing it".
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

	// Collate all events and figure out what sources are creating the most
	for (var/_event in events)
		if (!_event)
			continue
		var/datum/timedevent/event = _event

		do
			var/source_key = event.source || "(no source recorded)"
			if (per_source[source_key] == null)
				per_source[source_key] = 1
			else
				per_source[source_key] += 1
			event = event.next
		while (event && event != _event)

	// Now, sort them in order
	var/list/sorted = list()
	for (var/source in per_source)
		sorted += list(list("source" = source, "count" = per_source[source]))
	sortTim(sorted, GLOBAL_PROC_REF(cmp_timer_data))

	// Now that everything is sorted, compile them into an HTML output
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
