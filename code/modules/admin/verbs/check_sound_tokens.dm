/**
 * Live view of the sound token system and the channel pool it draws from.
 *
 * Shows how many tokens are live, what holds channels, and how close the pool is to running dry.
 * Tokens are enumerated from SSsounds.using_channels_by_datum rather than a global list, since
 * every token reserves its channel through reserve_sound_channel_for_datum() and is listed there
 * for exactly as long as it is alive.
 */
/client/proc/check_sound_tokens()
	set category = "Debug"
	set name = "Check Sound Tokens"
	if(!check_rights(R_DEBUG))
		return

	if(!SSsounds)
		to_chat(usr, span_warning("SSsounds does not exist."))
		return

	var/list/output = list()

	var/pool_total = SSsounds.using_channels_max - SSsounds.random_channels_min
	var/reserved_now = SSsounds.using_channels_max - SSsounds.channel_reserve_high
	var/reservable_left = SSsounds.channel_reserve_high - SSsounds.random_channels_min
	var/pct = pool_total ? round((reserved_now / pool_total) * 100, 0.1) : 0

	output += "<h2>Channel pool</h2>"
	output += "<table border='1' cellpadding='3'>"
	output += "<tr><td>reservable pool</td><td><b>[pool_total]</b> (channels [SSsounds.random_channels_min + 1]-[SSsounds.using_channels_max])</td></tr>"
	output += "<tr><td>reserved right now</td><td><b>[reserved_now]</b> ([pct]%)</td></tr>"
	output += "<tr><td>still reservable</td><td><b>[reservable_left]</b></td></tr>"
	output += "<tr><td>channel_reserve_high</td><td>[SSsounds.channel_reserve_high]</td></tr>"
	output += "<tr><td>channel_random_low</td><td>[SSsounds.channel_random_low] <i>(one-shot playsound cycle position; reserves nothing)</i></td></tr>"
	output += "</table>"
	if(reservable_left < 100)
		output += "<p><b style='color:red'>Fewer than 100 channels left. Token creation refuses when the pool is dry - instruments and music boxes would start failing.</b></p>"

	var/list/tokens = list()
	var/list/other_holders = list()
	for(var/holder in SSsounds.using_channels_by_datum)
		if(istype(holder, /datum/sound_token))
			tokens += holder
		else
			other_holders += holder

	var/list/by_type = list()
	var/total_listeners = 0
	for(var/datum/sound_token/token as anything in tokens)
		var/type_key = "[token.source ? token.source.type : "(source gone)"]"
		by_type[type_key] = (by_type[type_key] || 0) + 1
		total_listeners += length(token.listeners)

	output += "<h2>Live tokens: [length(tokens)]</h2>"
	output += "<p>listener slots in use across all of them: <b>[total_listeners]</b>"
	output += " &mdash; averaging [length(tokens) ? round(total_listeners / length(tokens), 0.01) : 0] listeners per token.<br>"
	output += "<i>A token with 0 listeners is holding a channel and its grid signals for nobody. Many of those at once is the case lazy creation exists to fix.</i></p>"

	output += "<h3>By source type</h3><table border='1' cellpadding='3'><tr><th>source type</th><th>tokens</th></tr>"
	for(var/type_key in by_type)
		output += "<tr><td>[type_key]</td><td align='right'><b>[by_type[type_key]]</b></td></tr>"
	output += "</table>"

	output += "<h3>Individual tokens</h3>"
	output += "<table border='1' cellpadding='3'><tr>"
	output += "<th>source</th><th>where</th><th>chan</th><th>range</th><th>vol</th><th>listeners</th><th>repeat</th><th>pref-gated</th><th>cells</th><th>age (s)</th><th>sound</th></tr>"
	for(var/datum/sound_token/token as anything in tokens)
		var/turf/token_turf = get_turf(token.source)
		var/where = token_turf ? "[get_area_name(token_turf)] ([token_turf.x],[token_turf.y],[token_turf.z])" : "<i>nullspace</i>"
		var/listener_count = length(token.listeners)
		var/age = token.start_time ? round((REALTIMEOFDAY - token.start_time) / 10, 0.1) : "?"
		var/soundfile = token.sound ? "[token.sound.file]" : "<i>none</i>"
		var/row_style = listener_count ? "" : " style='color:#888'"
		output += "<tr[row_style]>"
		output += "<td>[token.source ? "[token.source]" : "<i>gone</i>"]</td>"
		output += "<td>[where]</td>"
		output += "<td align='right'>[token.sound_channel]</td>"
		output += "<td align='right'>[token.range]</td>"
		output += "<td align='right'>[token.volume]</td>"
		output += "<td align='right'><b>[listener_count]</b></td>"
		output += "<td>[token.repeating ? "yes" : "no"]</td>"
		output += "<td>[token.respect_instrument_pref ? "yes" : "no"]</td>"
		output += "<td align='right'>[length(token.cell_trackers)]</td>"
		output += "<td align='right'>[age]</td>"
		output += "<td>[soundfile]</td>"
		output += "</tr>"
	output += "</table>"

	output += "<h2>Other channel holders: [length(other_holders)]</h2>"
	if(length(other_holders))
		output += "<table border='1' cellpadding='3'><tr><th>holder</th><th>type</th><th>channels</th></tr>"
		for(var/holder in other_holders)
			var/list/held = SSsounds.using_channels_by_datum[holder]
			output += "<tr><td>[holder]</td><td>[istype(holder, /datum) ? "[holder:type]" : "(not a datum)"]</td><td>[length(held)] : [held ? jointext(held, ", ") : ""]</td></tr>"
		output += "</table>"
	else
		output += "<p><i>none</i></p>"

	output += "<h2>SSsound_tokens</h2>"
	if(SSsound_tokens)
		output += "<table border='1' cellpadding='3'>"
		output += "<tr><td>clients queued for a positional refresh</td><td><b>[length(SSsound_tokens.clients_needing_update)]</b></td></tr>"
		output += "<tr><td>mid-run backlog</td><td>[length(SSsound_tokens.currentrun)]</td></tr>"
		output += "</table>"
		output += "<p><i>The queue is an idempotent mark drained once per fire, so a client cannot be refreshed more than once a tick however fast it moves. A persistently large backlog means listener updates are outrunning the subsystem.</i></p>"
	else
		output += "<p><i>SSsound_tokens does not exist.</i></p>"

	var/datum/browser/browser = new(usr, "check_sound_tokens", "Sound Tokens & Channels", 900, 700)
	browser.set_content(jointext(output, ""))
	browser.open()
