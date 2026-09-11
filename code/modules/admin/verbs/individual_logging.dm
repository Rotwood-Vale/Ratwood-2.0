/*
	Log values are dicts, not strings: "msg" plus metadata, so nothing here parses prose.
	"msg" is stored PLAIN with any colour riding as "color": log_entry_text() normalizes then wraps at render,
	so markup written into a stored value shows as literal text. Keep it that way, storage stays plain.
	log_combat() mints one "event" id shared by its three writes (attacker line, seen entry, target receipt).
	Forward lines and seen entries carry the target's ckey as "target"; receipts are flagged "receipt" and carry
	the attacker's ckey as "attacker", absent when that attacker is keyless. log_seen() stores "witnesses" as
	ckey to list(name, tiles away, perception tag), the tag ^ v ~ or a direction digit. Speech seen copies hold
	the TREATED message, exactly what listeners read. Disk logs carry none of it. Every key named here is a
	LOG_META_* define, written and read through the same one so a misspelling cannot pass silently.

	Invariants:
	1. The witnessed pass must finish before the offscreen pass. It marks event ids and clear sightings; the pull trusts both.
	2. The subject's receipts never mark. Their thread and the attacker's block both showing the hit is intended.
	3. Only receipts pull, and only when their victim was clearly in the subject's view around that moment.
	   Fights the subject never saw stay out entirely.
	4. Reads go through the accessors below, so a stray string degrades to text instead of erroring.
	5. The subject's own seen entries are never rows. They are read for what their written lines lack, and for
	   presence. Rendering them as well doubles every line the subject ever spoke.
*/
#define POV_LOG_PAGE_LEN 2000
#define POV_FOCUS_PAGE_LEN 10
#define POV_FOCUS_LINK_EVERY 5
#define POV_LOG_COOLDOWN (5 SECONDS)
#define SEEN_LOG_WITNESS_COLOR "#8fbf8f"
/// sortTim cannot yield mid-call, so this is the one uninterruptible stretch. Keep it small
#define POV_SORT_BLOCK 256
/// Also enforced in the page's javascript, keep them in step
#define POV_HIGHLIGHT_MAX 10
/// Silence long enough to call it a new scene. world.time units, like the rows' "time"
#define POV_SCENE_GAP (60 SECONDS)
#define POV_CACHE_MAX 3
/// Timelines that keep their highlights and filters. Above POV_CACHE_MAX so selections outlive a rebuild
#define POV_PREFS_MAX 10

/client/var/last_pov_log_generation = 0

/// ckey to BYOND key for everyone who ever entered a log, so hide ckeys can find names in prose after they disconnect
GLOBAL_LIST_EMPTY(pov_player_keys)

/proc/pov_remember_key(reg_ckey, reg_key)
	if(reg_ckey && reg_key && !GLOB.pov_player_keys[reg_ckey])
		GLOB.pov_player_keys[reg_ckey] = reg_key

/// Stored text is mixed: player text arrives html_encoded at input, system text (names, places) arrives raw.
/// Decode then encode lands both at exactly one encoding, so text shows as typed instead of as markup.
/proc/log_normalize_html(text)
	return html_encode(html_decode(text))

/// Accessors, not direct indexing: a value written before the dict format degrades to plain text instead of erroring.
/// An override replaces the stored colour rather than wrapping outside it, where the inner tag would win
/proc/log_entry_text(value, color_override)
	return log_entry_colored(log_entry_raw_text(value), color_override || log_entry_field(value, "color"))

/// The stored message with nothing round it, for callers that add their own text before the colour goes on
/proc/log_entry_raw_text(value)
	return log_normalize_html(islist(value) ? value["msg"] : value)

/proc/log_entry_colored(text, color)
	if(!color)
		return text
	// unquoted hex, quoted named colour: the IE control wants both forms
	return (color[1] == "#") ? "<font color=[color]>[text]</font>" : "<font color='[color]'>[text]</font>"

/proc/log_entry_field(value, field)
	return islist(value) ? value[field] : null

/proc/witness_display_name(witness_entry)
	return islist(witness_entry) ? witness_entry[WITNESS_NAME] : witness_entry

/// Null when unknown or across a z level
/proc/witness_distance(witness_entry)
	return islist(witness_entry) ? witness_entry[WITNESS_DIST] : null

/// The perception tag, ^ v ~ or a direction digit. Null when they saw it plainly
/proc/witness_tag(witness_entry)
	return (islist(witness_entry) && length(witness_entry) >= WITNESS_TAG) ? witness_entry[WITNESS_TAG] : null

//pov_mode null shows the generate buttons. pov_paging is navigation inside a built POV, neither logged nor limited.
//pov_tail counts back from the end, so a focus link still lands on its entry after more has been logged
/proc/show_individual_logging_panel(mob/M, source = LOGSRC_CLIENT, type = INDIVIDUAL_ATTACK_LOG, page = 1, pov_mode = null, pov_paging = FALSE, page_len = 0, pov_tail = null, pov_focus = FALSE, pov_fresh = FALSE, pov_at = null)
	if(!M || !ismob(M))
		return

	var/ntype = text2num(type)
	var/client/admin = usr.client

	//Add client links
	var/list/dat = list()
	if(M.client)
		dat += "<center><p>Client</p></center>"
		dat += individual_logging_panel_row(M, LOGSRC_CLIENT, source, ntype, TRUE)
	else
		dat += "<p> No client attached to mob </p>"

	dat += "<hr style='background:#000000; border:0; height:1px'>"
	dat += "<center><p>Mob</p></center>"
	//Add the links for the mob specific log
	dat += individual_logging_panel_row(M, LOGSRC_MOB, source, ntype, FALSE)

	dat += "<hr style='background:#000000; border:0; height:1px'>"

	var/log_source = M.logging
	if(source == LOGSRC_CLIENT && M.client)
		log_source = M.client.player_details.logging //should exist, if it doesn't that's a bug, don't check for it not existing
		var/datum/player_details/details = GLOB.player_details[M.client]
		if(details) //we dont want to runtime if an admin aghosted
			log_source = details.logging
	var/list/concatenated_logs = list()
	var/list/pov_actor_labels = list()
	// the render's one bag: this request's parameters, grown with derived state on the way down
	var/list/pov_ctx
	if(ntype & INDIVIDUAL_POV_LOG)
		// href input: anything but the two real modes is dropped rather than reaching the cache key or the page's javascript
		if(pov_mode && pov_mode != "players" && pov_mode != "all")
			pov_mode = null
		var/cache_key = pov_cache_key(M, source, pov_mode)
		var/would_build = pov_mode && (!LAZYACCESS(admin?.pov_log_cache, cache_key) || (pov_fresh && !pov_paging))
		var/cooldown_left = admin ? max(0, admin.last_pov_log_generation + POV_LOG_COOLDOWN - world.time) : 0
		if(would_build && cooldown_left)
			to_chat(usr, span_warning("You generated a POV log moments ago. Try again in [DisplayTimeText(cooldown_left)]."))
			// keep showing what is already built; the generate buttons would only serve the same cache back
			pov_fresh = FALSE
			if(!LAZYACCESS(admin?.pov_log_cache, cache_key))
				pov_mode = null
		if(pov_mode)
			concatenated_logs = get_pov_timeline(admin, M, log_source, source, pov_mode, pov_paging, pov_actor_labels, pov_fresh)
			pov_ctx = list(
				"subject" = M, "ntype" = ntype, "source" = source, "mode" = pov_mode, "labels" = pov_actor_labels,
				"page" = page, "page_len" = page_len, "tail" = pov_tail, "at" = pov_at, "focused" = pov_focus,
				"highlights" = LAZYACCESS(admin?.pov_log_highlights, cache_key),
				"filters" = LAZYACCESS(admin?.pov_log_filters, cache_key),
			)
			// re-read: a fresh build just replaced the entry
			var/list/cache_entry = LAZYACCESS(admin?.pov_log_cache, cache_key)
			var/built = LAZYACCESS(cache_entry, "built")
			if(built && !pov_paging)
				dat += "<center><font size='1'>Timeline generated [DisplayTimeText(world.time - built)] ago. \
					<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_type=[ntype];log_src=[source];pov_mode=[pov_mode];pov_fresh=1'>Rebuild fresh</a></font></center>"
		else
			dat += pov_generate_prompt(M, ntype, source, cooldown_left, pov_tail, pov_focus, page_len)
	else
		concatenated_logs = collect_individual_log_entries(log_source, ntype)
		if(length(concatenated_logs))
			sortTim(concatenated_logs, cmp = GLOBAL_PROC_REF(cmp_text_dsc)) //Sort by timestamp.

	if(length(concatenated_logs))
		if(ntype & INDIVIDUAL_POV_LOG)
			dat += render_pov_log(concatenated_logs, pov_ctx)
		else
			dat += "<font size=2px>"
			dat += concatenated_logs.Join("<br>")
			dat += "</font>"

	var/datum/browser/popup = new(usr, "window=invidual_logging_[key_name(M)]", "Individual Logs", 600, 600)
	popup.set_content(dat.Join())
	popup.open()


/proc/collect_individual_log_entries(list/log_source, ntype)
	. = list()
	var/seen_entry_number = 0
	for(var/log_type in log_source)
		var/nlog_type = text2num(log_type)
		if(!(nlog_type & ntype))
			continue
		var/list/all_the_entrys = log_source[log_type]
		for(var/entry in all_the_entrys)
			// a seen row costs a roster's worth of html, so a long round's worth of them overruns the tick
			CHECK_TICK
			var/value = all_the_entrys[entry]
			seen_entry_number++
			var/line = log_entry_text(value)
			var/list/witnesses = log_entry_field(value, LOG_META_WITNESSES)
			if(!isnull(witnesses))
				line += pov_witness_html(witnesses, "seen[seen_entry_number]", plain = TRUE)
			. += "<b>[log_normalize_html(entry)]</b><br>[line]"

// Serving a POV timeline: the generate prompt, the cache, the cooldown and the yielding sort

/// cooldown_left says why the buttons will not work yet, since a blocked pivot lands here with no other explanation
/proc/pov_generate_prompt(mob/M, ntype, source, cooldown_left = 0, pov_tail = null, pov_focus = FALSE, page_len = 0)
	var/generate_href = "?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_type=[ntype];log_src=[source]"
	// carries where they were reading, so a build blocked mid navigation comes back to the same place
	if(!isnull(pov_tail))
		generate_href += ";pov_tail=[pov_tail]"
	if(pov_focus)
		generate_href += ";pov_focus=1"
	if(page_len)
		generate_href += ";page_len=[page_len]"
	. = list(
		"<center><i>The POV log is assembled on demand and this action is logged.</i><br>",
		"<a href='[generate_href];pov_mode=players'>Generate (Players Only)</a>",
		" | <a href='[generate_href];pov_mode=all'>Generate (All Mobs)</a></center>",
		"<center><i>All Mobs adds what nearby NPCs did, but a mob's log dies with it, so gibbed or deleted NPCs are missing.</i></center>"
	)
	if(cooldown_left)
		. += "<center><font color='#ff6b6b'>Another POV log was built moments ago. Generating works again in [DisplayTimeText(cooldown_left)].</font></center>"

/// One timeline's identity. The entries cache, the highlights and the filters all key off this.
/proc/pov_cache_key(mob/M, source, pov_mode)
	return "[REF(M)]_[source]_[pov_mode]"

/// Newest first, filling actor_labels. Only a real build is logged and rate limited; a cached one is free.
/proc/get_pov_timeline(client/admin, mob/M, list/log_source, source, pov_mode, pov_paging, list/actor_labels, force_fresh = FALSE)
	var/cache_key = pov_cache_key(M, source, pov_mode)
	var/list/cached = (pov_paging || !force_fresh) ? LAZYACCESS(admin?.pov_log_cache, cache_key) : null
	if(cached)
		actor_labels += cached["labels"]
		return cached["entries"]

	var/all_mobs = (pov_mode == "all")
	if(admin)
		admin.last_pov_log_generation = world.time
		log_admin("[key_name(admin)] generated the [all_mobs ? "all mobs" : "players only"] POV log of [key_name(M)]")
		message_admins("[key_name_admin(admin)] generated the [all_mobs ? "all mobs" : "players only"] POV log of [key_name_admin(M)]")
	. = build_pov_entries(M, log_source, all_mobs, actor_labels)
	if(!length(.))
		return
	. = sort_pov_entries(.)
	// cached whole and sorted, before paging slices it, so later pages cost nothing
	cache_pov_timeline(admin, cache_key, ., actor_labels)

/// Keeps the last POV_CACHE_MAX an admin generated.
/proc/cache_pov_timeline(client/admin, cache_key, list/entries, list/actor_labels)
	if(!admin)
		return
	LAZYINITLIST(admin.pov_log_cache)
	admin.pov_log_cache -= cache_key // re-adding puts it back at the end, keeping the list ordered oldest first
	admin.pov_log_cache[cache_key] = list("entries" = entries, "labels" = actor_labels, "built" = world.time)
	while(length(admin.pov_log_cache) > POV_CACHE_MAX)
		admin.pov_log_cache.Cut(1, 2)

/// Newest first on the row's precomputed time
/proc/cmp_pov_time_dsc(list/a, list/b)
	return b["time"] - a["time"]

/// Bottom up merge sort, yielding throughout so a big timeline never blocks a tick. Returns a new list.
/proc/sort_pov_entries(list/timeline)
	if(length(timeline) < 2)
		return timeline
	var/list/sorted_blocks = list()
	for(var/start = 1, start <= timeline.len, start += POV_SORT_BLOCK)
		var/list/block = timeline.Copy(start, min(start + POV_SORT_BLOCK, timeline.len + 1))
		sortTim(block, GLOBAL_PROC_REF(cmp_pov_time_dsc))
		sorted_blocks += list(block)
		CHECK_TICK
	while(sorted_blocks.len > 1)
		var/list/next_round = list()
		for(var/i = 1, i <= sorted_blocks.len, i += 2)
			if(i == sorted_blocks.len) // odd block with no partner this round, carries over as is
				next_round += list(sorted_blocks[i])
			else
				next_round += list(merge_pov_blocks(sorted_blocks[i], sorted_blocks[i + 1]))
		sorted_blocks = next_round
	return sorted_blocks[1]

/// Merges two sorted blocks of rows, newest first. Ties prefer left, keeping the merge stable
/proc/merge_pov_blocks(list/left, list/right)
	var/list/out = list()
	var/left_index = 1
	var/right_index = 1
	while(left_index <= left.len && right_index <= right.len)
		CHECK_TICK
		var/list/left_row = left[left_index]
		var/list/right_row = right[right_index]
		if(left_row["time"] >= right_row["time"])
			out += list(left_row)
			left_index++
		else
			out += list(right_row)
			right_index++
	// the remaining side is already sorted
	if(left_index <= left.len)
		out += left.Copy(left_index)
	else if(right_index <= right.len)
		out += right.Copy(right_index)
	return out

// Building a POV timeline: the subject's own rows, everything they witnessed, then the offscreen pulls

/// The subject's own rows, everything they witnessed, and what they missed. all_mobs also sweeps clientless mobs.
/// Flat list of pov_timeline_row()s. "actor" is absent on the subject's own rows
/proc/build_pov_entries(mob/M, list/log_source, all_mobs = FALSE, list/actor_labels = list())
	. = list()
	// marked event ids, so a watched hit is not pulled again as its receipt
	var/list/included_events = list()
	var/list/subject_receipts = list()
	// "[actor]@[bucket]" keys, when each person was in view
	var/list/presence = list()
	// fills presence as it goes, so this must run before anything reads it
	var/list/own_seen = pov_read_own_seen(log_source, presence)
	add_pov_own_entries(., log_source, own_seen, included_events, subject_receipts)

	if(!M.key)
		return

	var/list/roster_labels = list()
	var/list/actor_logs = pov_actor_roster(M, all_mobs, roster_labels)
	var/seen_key = num2text(LOG_SEEN)
	var/attack_key = num2text(LOG_ATTACK)
	var/list/already_added = list()

	// must complete first: it marks the ids and sightings the pull trusts
	for(var/actor_id in actor_logs)
		var/list/seen_entries = actor_logs[actor_id][seen_key]
		if(!length(seen_entries))
			continue
		actor_labels[pov_row_class(actor_id)] = roster_labels[actor_id]
		add_pov_witnessed_entries(., seen_entries, already_added, M.ckey, actor_id, included_events, subject_receipts, presence)

	for(var/actor_id in actor_logs)
		// never seen, so nothing of theirs can pull
		if(!presence["[actor_id]"])
			continue
		var/list/attack_entries = actor_logs[actor_id][attack_key]
		if(!length(attack_entries))
			continue
		var/row_class = pov_row_class(actor_id)
		if(!actor_labels[row_class]) // stood in the subject's rosters without ever acting, so the pass above never named them
			actor_labels[row_class] = roster_labels[actor_id]
		add_pov_offscreen_hits(., attack_entries, already_added, actor_id, included_events, presence)

#define POV_PRESENCE_BUCKET(time) round((time) / POV_SCENE_GAP)

/// Records that an actor was in view, bucketed and bare
/proc/pov_mark_presence(list/presence, actor_id, time)
	if(isnull(time))
		return
	presence["[actor_id]"] = TRUE
	presence["[actor_id]@[POV_PRESENCE_BUCKET(time)]"] = TRUE

/proc/pov_actor_present(list/presence, actor_id, time)
	if(isnull(time))
		return FALSE
	var/bucket = POV_PRESENCE_BUCKET(time)
	return presence["[actor_id]@[bucket]"] || presence["[actor_id]@[bucket - 1]"] || presence["[actor_id]@[bucket + 1]"]

/// "time" is precomputed so the sort never digs into the stored value or throws on a malformed one
/proc/pov_timeline_row(entry_key, value, actor_id = null)
	. = list("key" = entry_key, "entry" = value, "time" = log_entry_field(value, "time") || 0)
	if(actor_id)
		.["actor"] = actor_id

/// Pairs a row with the seen copy written beside it. Combat shares an event id, which is exact. Speech mints none,
/// so the pairing falls back to the tick both were written in, narrowed by log_seen's colour: a say and an emote
/// logged in the same tick cannot take each other's roster
/proc/pov_seen_pair_key(event_id, color, time)
	return event_id || "[color]@[time]"

/// One walk of the subject's seen log: entries out keyed for the pairing above, presence marked in place.
/// An empty roster is kept, nobody saw it being an answer worth printing
/proc/pov_read_own_seen(list/log_source, list/presence)
	. = list()
	var/list/seen_entries = log_source[num2text(LOG_SEEN)]
	for(var/entry in seen_entries)
		CHECK_TICK
		var/value = seen_entries[entry]
		var/list/witnesses = log_entry_field(value, LOG_META_WITNESSES)
		if(isnull(witnesses))
			continue
		var/entry_time = log_entry_field(value, "time")
		for(var/witness_ckey in witnesses)
			// eavesdropped, another floor, or past the screen edge, none of which is "in view"
			if(!witness_tag(witnesses[witness_ckey]))
				pov_mark_presence(presence, witness_ckey, entry_time)
		// nothing to pair on, and a malformed row defaults to time 0: indexing this would hand it a roster
		var/event_id = log_entry_field(value, LOG_META_EVENT)
		if(!event_id && isnull(entry_time))
			continue
		.[pov_seen_pair_key(event_id, log_entry_field(value, "color"), entry_time)] = value

/// The subject's own rows. Their forward attacks mark included_events; their receipts do NOT, because a hit on them is
/// meant to show in both their thread and the attacker's block. Receipts are indexed instead, for the distance handoff.
/proc/add_pov_own_entries(list/output, list/log_source, list/own_seen, list/included_events, list/subject_receipts)
	var/static/list/own_types = list(LOG_ATTACK, LOG_SAY, LOG_WHISPER, LOG_EMOTE)
	// log_talk writes no colour, so own rows would render plain against everyone else's log_seen scheme.
	// These are log_seen's own colours, which is also what pairs a speech row with its seen copy
	var/static/list/own_colors = list("[LOG_SAY]" = SEEN_COLOR_SAY, "[LOG_WHISPER]" = SEEN_COLOR_SAY, "[LOG_EMOTE]" = SEEN_COLOR_EMOTE)
	for(var/type in own_types)
		var/list/entries = log_source[num2text(type)]
		for(var/entry in entries)
			CHECK_TICK
			var/value = entries[entry]
			var/is_receipt = log_entry_field(value, LOG_META_RECEIPT)
			var/event_id = log_entry_field(value, LOG_META_EVENT)
			var/list/wrapper = pov_timeline_row(entry, value)
			wrapper["kind"] = type
			wrapper["tint"] = own_colors["[type]"]
			// log_combat stores a receipt orange, the say colour. Severe keeps its own
			if(is_receipt && log_entry_field(value, "color") != LOG_COLOR_SEVERE)
				wrapper["tint"] = "#ffcccc"
			// a receipt's witnesses belong to whoever landed the hit and arrive via the handoff in the witnessed
			// pass. A row with no stored time has no moment to pair on either, the wrapper's being a sort default
			var/pair_time = log_entry_field(value, "time")
			if(!is_receipt && (event_id || !isnull(pair_time)))
				var/list/seen_copy = own_seen[pov_seen_pair_key(event_id, own_colors["[type]"], pair_time)]
				if(seen_copy)
					wrapper[LOG_META_WITNESSES] = log_entry_field(seen_copy, LOG_META_WITNESSES)
			output += list(wrapper)
			if(type != LOG_ATTACK || !event_id)
				continue
			if(is_receipt)
				subject_receipts[event_id] = wrapper
			else
				included_events[event_id] = TRUE

/// Everyone but the subject who logged anything, mapped to their logging lists, labels filled into labels_out.
/// Players keyed by ckey so the record outlives the mob; clientless mobs by ref, keeping same-named ones apart
/proc/pov_actor_roster(mob/M, all_mobs, list/labels_out)
	. = list()
	for(var/pkey in GLOB.player_details)
		if(pkey == M.ckey)
			continue
		var/datum/player_details/details = GLOB.player_details[pkey]
		if(!length(details?.logging))
			continue
		.[pkey] = details.logging
		var/client/actor_client = GLOB.directory[pkey]
		labels_out[pkey] = pov_actor_label(actor_client?.mob, key_name(pkey))
	if(!all_mobs)
		return
	for(var/mob/other as anything in GLOB.mob_list)
		if(other.ckey || !length(other.logging)) // a played mob's entries are already covered by the player pass
			continue
		var/actor_id = REF(other)
		.[actor_id] = other.logging
		labels_out[actor_id] = pov_actor_label(other, other.real_name || other.name)

/// One person's seen log, keeping what the subject witnessed. already_added dedupes mob and player-record copies.
/proc/add_pov_witnessed_entries(list/output, list/entries, list/already_added, subject_ckey, actor_id, list/included_events, list/subject_receipts, list/presence)
	for(var/entry in entries)
		CHECK_TICK
		if(already_added[entry])
			continue
		var/value = entries[entry]
		var/list/witnesses = log_entry_field(value, LOG_META_WITNESSES)
		if(!witnesses)
			continue
		// a hit on the subject: hand their range to the receipt, then let the row render. Do not skip it, this is the
		// only copy carrying the witness roster
		if(log_entry_field(value, LOG_META_TARGET) == subject_ckey)
			var/hit_id = log_entry_field(value, LOG_META_EVENT)
			var/list/receipt_wrapper = hit_id ? LAZYACCESS(subject_receipts, hit_id) : null
			if(receipt_wrapper)
				receipt_wrapper["dist"] = witness_distance(witnesses[subject_ckey])
				// the attacker's roster, subject included. Shared not copied, so one hit cannot show two counts
				receipt_wrapper[LOG_META_WITNESSES] = witnesses
		if(!witnesses[subject_ckey])
			continue
		if(!witness_tag(witnesses[subject_ckey]))
			pov_mark_presence(presence, actor_id, log_entry_field(value, "time"))
		already_added[entry] = TRUE
		var/event_id = log_entry_field(value, LOG_META_EVENT)
		if(event_id)
			included_events[event_id] = TRUE
		output += list(pov_timeline_row(entry, value, actor_id))

/// Hits taken by someone the subject could see, from something they could not
/proc/add_pov_offscreen_hits(list/output, list/attack_entries, list/already_added, actor_id, list/included_events, list/presence)
	for(var/entry in attack_entries)
		CHECK_TICK
		if(already_added[entry])
			continue
		var/value = attack_entries[entry]
		if(!log_entry_field(value, LOG_META_RECEIPT))
			continue
		var/event_id = log_entry_field(value, LOG_META_EVENT)
		if(event_id && included_events[event_id]) // the subject watched this hit land, that copy carries the roster
			continue
		if(!pov_actor_present(presence, actor_id, log_entry_field(value, "time")))
			continue
		if(event_id)
			included_events[event_id] = TRUE
		already_added[entry] = TRUE
		output += list(pov_timeline_row(entry, value, actor_id))

// Rendering a POV timeline: the page frame, then each row styled into its actor's block

/// One page of the timeline. Paged because the renderer chokes on multi-thousand-line pages.
/// Works out where the page starts and writes that back into ctx, which is what everything below reads
/proc/render_pov_log(list/entries, list/ctx)
	. = list()
	var/mob/M = ctx["subject"]
	var/ntype = ctx["ntype"]
	var/source = ctx["source"]
	var/pov_mode = ctx["mode"]
	var/focused = ctx["focused"]
	var/page = ctx["page"]
	var/pov_tail = ctx["tail"]
	// href input: unclamped, a huge value renders the whole timeline at once and a negative one inverts the maths below
	var/entries_per_page = clamp(ctx["page_len"] || POV_LOG_PAGE_LEN, POV_FOCUS_PAGE_LEN, POV_LOG_PAGE_LEN)
	var/total = length(entries)
	var/pages = ROUND_UP(total / entries_per_page)
	// a pivot carries the moment it was clicked from, not a position, this timeline being someone else's
	if(isnull(pov_tail) && !isnull(ctx["at"]))
		pov_tail = total - pov_entry_index_at(entries, ctx["at"])
	if(!isnull(pov_tail)) // counting back from the end survives anything logged since the link was made
		page = ROUND_UP((total - pov_tail) / entries_per_page)
	page = clamp(page, 1, pages)
	var/first = (page - 1) * entries_per_page + 1
	var/last = min(page * entries_per_page, total)

	// a copy: the cached timeline has to stay whole for the next page
	var/list/page_entries = (pages > 1) ? entries.Copy(first, last + 1) : entries
	var/base_href = "?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_type=[ntype];log_src=[source];pov_mode=[pov_mode];pov_paging=1"
	var/page_href = focused ? "[base_href];pov_focus=1" : base_href
	var/subject_class = "a[M.ckey || "subject"]"

	ctx["subject_ckey"] = M.ckey
	ctx["subject_class"] = subject_class
	ctx["subject_label"] = pov_actor_label(M, key_name(M))
	ctx["start"] = first
	ctx["total"] = total

	// null in the focused view, no point linking to where you already are.
	// It's fucking annoying when you accidentally scroll away
	ctx["focus_href"] = focused ? null : base_href

	if(pages > 1)
		. += pov_page_nav(page, pages, first, last, total, page_href, entries_per_page)
	if(focused)
		. += "<center><a href='[base_href]'>Back to the full timeline</a></center>"
	. += pov_legend(M, focused, pov_mode)
	. += pov_highlight_controls(subject_class, base_href)

	// explicit size: the panel's <font size=2px> is not a valid attribute and gets coerced
	. += "<div style='font-size:14px;'>"
	. += style_pov_entries(page_entries, ctx)
	. += "</div>"
	// must come after the rows, it paints divs that have to exist first
	. += pov_restore_script(ctx)

/// Puts back highlights and filters after a page turn, from the server's copy the page cannot keep itself.
/proc/pov_restore_script(list/ctx)
	var/list/saved_highlights = ctx["highlights"]
	var/saved_filters = ctx["filters"]
	if(!length(saved_highlights) && !saved_filters)
		return ""
	var/subject_class = ctx["subject_class"]
	var/list/actor_labels = ctx["labels"]
	var/list/restore = list("<script type='text/javascript'>")
	for(var/hl in saved_highlights)
		// a ckey typed into the box may never have acted, so fall back to the ckey inside the class
		var/label = (hl == subject_class) ? ctx["subject_label"] : (actor_labels[hl] || copytext(hl, 2))
		restore += "povSet('[hl]', '[pov_safe_label(label)]');"
	if(saved_filters)
		restore += "povRestoreFilters('[saved_filters]');"
	restore += "povApply();povChips();</script>"
	return restore.Join()

/// Only shown once the timeline runs past a single page.
/proc/pov_page_nav(page, pages, first, last, total, page_href, entries_per_page)
	. = list("<center>Entries [first] to [last] of [total]")
	if(page > 1)
		. += " | <a href='[page_href];page_len=[entries_per_page];log_page=[page - 1]'>Previous</a>"
	if(page < pages)
		. += " | <a href='[page_href];page_len=[entries_per_page];log_page=[page + 1]'>Next</a>"
	. += "</center>"

/// How to read the page, and what not to conclude from it.
/proc/pov_legend(mob/M, focused, pov_mode)
	var/focus_hint = focused ? " This is the focused view, [POV_FOCUS_PAGE_LEN] entries around one moment with their full log keys." : " <b>&raquo;</b> reads around an entry."
	var/colour_key = "<b>Colours.</b> [M] gold on black, everyone else blue on grey. In someone else's block, a bright attack row landed on [M] and a faded one landed on somebody else.\
		<br><b>Grey marks</b> sit before the message and describe how [M] perceived it. &#8648; &#8650; a floor above or below. An arrow points off screen toward it, so a grey &#8592; means it happened to the west. ~ edge of earshot. (N) tiles away. After a witness name, those same marks place that witness instead.\
		<br><b>Red arrows</b> sit after the grey ones and mark a hit landing. &#8592; is a hit [M] took. &#8606; is a hit somebody else took from off screen: [M] could see them, but not what struck them.\
		<br><b>Rows.</b> Grey lines show where the action moved. Hover any row for its full entry. &#8644; beside a name opens their own POV at this moment.[focus_hint]\
		<br><b>Witnesses.</b> The count on a row opens the list of who was close enough to perceive it, which is not proof that they did.\
		<br><b>Names.</b> Click a name to follow them like a second subject, up to [POV_HIGHLIGHT_MAX], and again to clear. <b>Their own blocks box bright, and every hit they took stripes dull inside the block of whoever landed it.</b> [M] is the exception: hits taken are full rows in their own thread instead.\
		<br><b>Filters.</b> Each box hides one thing: attacks, speech and emotes, everyone not highlighted, faded rows, or ckeys. Hiding ckeys leaves a * so players still read apart from mobs, handy before a screenshot. Headers always stay, so you can still see who else was there."
	var/all_mobs_caveat = "All Mobs: a mob's log dies with it, so gibbed or deleted NPCs are missing here, which can shift where a \" &raquo; \" link lands."

	// bruh, ya'll better read this
	var/caution ="<b>Absence is not evidence.</b> A great deal of harm records nothing at all, including spells and miracles, traps, explosions, falls, strangling, drowning, fire and poison. A missing line does not mean it did not happen.\
		<br><b>Witness lists</b> are who stood close enough to perceive something, not who did. Blindness, facing away and language are not accounted for.\
		<br><b>Off-screen hits</b> show only when their victim had been clearly in [M]'s view around that moment. A victim who never acted nearby leaves no proof they were visible, so their hit stays out.\
		<br><b>Speech</b> reads as it came out: accents, slurring and all, which also means what a garbled speaker actually typed is not recorded. Distance stars are not reproduced.\
		<br><b>Typing</b> appears only in [M]'s own rows. It records no witnesses, so nobody else's bubble reaches this page even though it was visible in game.\
		<br><b>This timeline is a snapshot</b> taken when it was generated, and a clientless mob's log dies with the mob."

	// both are read once then in the way, so they sit behind toggles. The All Mobs caveat stays visible
	. = list("<center><span style='color:#7fb2d9; text-decoration:underline;' onclick=\"var e=document.getElementById('povlegend');e.style.display=(e.style.display=='none')?'block':'none';\">Legend</span>\
		&nbsp; <span style='color:#ff6b6b; text-decoration:underline;' onclick=\"var e=document.getElementById('povcaution');e.style.display=(e.style.display=='none')?'block':'none';\">Caution</span>\
		<div id='povlegend' style='display:none; text-align:left; padding:2px 8px;'>[colour_key]</div>\
		<div id='povcaution' style='display:none; text-align:left; padding:2px 8px; color:#ffc957;'>[caution]</div></center>")
	if(pov_mode == "all")
		. += "<center><font color='#ffc957'><i>[all_mobs_caveat]</i></font></center>"

/// Wraps entries in blocks headed by whoever acted. Subject on black under gold, everyone else grey under blue.
/proc/style_pov_entries(list/entries, list/ctx)
	. = list()
	// deliberately smaller than the rows: the rows are what gets read
	var/header_style = "font-size:13px; padding:2px 5px 1px 5px;"
	var/subject_header_style = "font-size:14px; padding:2px 5px 1px 5px;"
	var/list/actor_labels = ctx["labels"]
	var/subject_class = ctx["subject_class"]
	var/subject_ckey = ctx["subject_ckey"]
	var/subject_label = ctx["subject_label"]
	var/pov_mode = ctx["mode"]
	var/focus_href = ctx["focus_href"]
	var/total_entries = ctx["total"]
	var/focused = isnull(focus_href)
	var/last_actor
	var/last_place
	var/have_block = FALSE
	var/index = ctx["start"]
	var/prev_time
	for(var/list/wrapper as anything in entries)
		CHECK_TICK
		var/actor = wrapper["actor"] // the subject's own rows carry none
		var/stored = wrapper["entry"]
		var/raw_key = wrapper["key"]

		var/cur_time = wrapper["time"]
		if(prev_time && prev_time - cur_time > POV_SCENE_GAP)
			if(have_block)
				. += "</div>"
			. += "<div style='text-align:center; color:#8a8a8a; font-size:11px; padding:3px;'>&#8212;&#8212; [DisplayTimeText(prev_time - cur_time, 1)] apart &#8212;&#8212;</div>"
			have_block = FALSE
			last_place = null // time passed, so the scene after the break restates where it happens
		prev_time = cur_time
		var/block_class = actor ? pov_row_class(actor) : subject_class
		var/label = actor ? (actor_labels[block_class] || actor) : subject_label
		var/row_style = actor ? "background:#1e1e1e; border-left:4px solid #5a5a5a;" : "background:#000000; border-left:4px solid #eac0b9;"
		var/header_colour = actor ? "#7fb2d9" : "#ffc957"

		var/list/witnesses = pov_row_borrowed(wrapper, stored, LOG_META_WITNESSES)
		var/subject_witness = subject_ckey ? LAZYACCESS(witnesses, subject_ckey) : null
		var/glyph = pov_perception_glyph(subject_witness)
		var/subject_dist = witness_distance(subject_witness)
		if(isnull(subject_dist)) // a hit they took: their range came from the attacker's roster at build time
			subject_dist = wrapper["dist"]
		var/is_receipt = log_entry_field(stored, LOG_META_RECEIPT)
		// an id or a receipt flag is what separates a hit from speech, a death or a typing line
		var/is_attack = log_entry_field(stored, LOG_META_EVENT) || is_receipt
		var/row_target = log_entry_field(stored, LOG_META_TARGET)
		// the other party: whose ckey sits in the prose, and whose highlight should stripe this row
		var/row_other = row_target || log_entry_field(stored, LOG_META_ATTACKER)

		var/row_marks = pov_perception_marks(glyph, subject_dist)
		// after the marks, not before the time, so the time column stays straight
		if(is_receipt)
			row_marks += actor ? "<font color='#ff8f6b'>&#8606;</font> " : "<font color='#ff8f6b'>&#8592;</font> "

		// raw key shape: "\[YYYY-MM-DD hh:mm:ss\] who where (LOG #n)", built in log_message()
		var/full_key = log_normalize_html(raw_key)
		var/message = pov_row_message(wrapper, is_receipt, row_other)
		var/line
		var/place_line = ""
		if(focused)
			line = "<b>[pov_key_with_ckey_spans(raw_key)]</b><br>[row_marks][message]"
		else
			var/place = pov_entry_place(raw_key)
			if(place != last_place)
				last_place = place
				place_line = "<div class='[block_class] row plc' style='[row_style] color:#8a8a8a; font-size:12px; padding:1px 5px;'>[place]</div>"
			line = "<font color='#8a8a8a'>[copytext(raw_key, 13, 21)]</font> [row_marks][message]"
		if(!isnull(witnesses))
			line += pov_witness_html(witnesses, "pov[index]")

		var/kind_token = pov_row_kind_token(wrapper, is_attack)
		var/row_dim = pov_row_fade(glyph, actor, is_attack, subject_ckey, row_target)
		var/recipient = (row_other && row_other != subject_ckey && "a[row_other]" != block_class) ? " t[row_other]" : ""
		var/focus = (focus_href && !((index - 1) % POV_FOCUS_LINK_EVERY)) ? " <a href='[focus_href];pov_focus=1;page_len=[POV_FOCUS_PAGE_LEN];pov_tail=[total_entries - index]'>&raquo;</a>" : ""
		index++

		if(!have_block || actor != last_actor)
			if(have_block)
				. += "</div>"
			have_block = TRUE
			last_actor = actor
			// the container the highlight paints as one box. Border is pre-emitted transparent so lighting it shifts no layout
			. += "<div class='blk [block_class]' style='border:2px solid transparent; margin-top:3px;'>"
			. += "<div class='[block_class] hdr' style='[row_style] [actor ? header_style : subject_header_style]'>[pov_highlight_link(block_class, label, header_colour)][actor ? pov_pivot_link(actor, cur_time, pov_mode) : ""]</div>"
		if(place_line)
			. += place_line
		// class tokens drive the browser side, see the contract in pov_highlight_script
		. += "<div class='[block_class] row[recipient][row_dim ? " dim" : ""][kind_token]' style='[row_style] [row_dim][actor ? "" : "font-size:15px; "]padding:1px 5px;' title='[pov_safe_label(full_key)]'>[line][focus]</div>"
	if(have_block)
		. += "</div>"

/// A field the subject's own rows borrow from the seen copy beside them, falling back to the entry itself
/// for everyone else's. isnull, not a truth test: an empty roster is a real answer, nobody saw it, and
/// must not fall through to a field that is missing for a different reason
/// Null wrapper is fine: the plain log tabs read entries directly, with nothing to borrow from
/proc/pov_row_borrowed(list/wrapper, stored, field)
	var/borrowed = wrapper ? wrapper[field] : null
	if(isnull(borrowed))
		borrowed = log_entry_field(stored, field)
	return borrowed

/// Grey, and all of it subject-relative: how they perceived it and how far off it was
/proc/pov_perception_marks(glyph, subject_dist)
	var/marks = glyph
	if(!isnull(subject_dist))
		marks = marks ? "[marks] ([subject_dist])" : "([subject_dist])"
	return marks ? "<font color='#8a8a8a'>[marks]</font> " : ""

/// A row's text: kind prefix, then tint, then receipt italics, then the ckey mask over the lot.
/// A seen copy is already treated, so only log_talk's quotes go on here
/proc/pov_row_message(list/wrapper, is_receipt, prose_ckey)
	var/static/list/kind_prefixes = list("[LOG_WHISPER]" = "(whisper) ", "[LOG_EMOTE]" = "(emote) ")
	var/stored = wrapper["entry"]
	// one colour over the lot, prefix included. A tint outranks the stored colour
	var/color = wrapper["tint"] || log_entry_field(stored, "color")
	var/prefix = kind_prefixes["[wrapper["kind"]]"] || ""
	var/text = log_entry_raw_text(stored)
	if(pov_row_is_seen_speech(wrapper, stored))
		text = "\"[text]\""
	var/message = log_entry_colored("[prefix][text]", color)
	if(is_receipt)
		message = "<i>[message]</i>"
	return pov_mask_prose_ckey(message, prose_ckey)

/// Witnessed rows carry no kind of their own, so the colour is what names them. Harm is excluded first:
/// log_combat stamps a receipt the same orange, and the colour alone would put a hit taken off screen in
/// quotation marks
/proc/pov_row_is_seen_speech(list/wrapper, stored)
	if(!isnull(wrapper["kind"]))
		return FALSE
	if(log_entry_field(stored, LOG_META_RECEIPT) || log_entry_field(stored, LOG_META_EVENT))
		return FALSE
	return log_entry_field(stored, "color") == SEEN_COLOR_SAY

/// Which kind filter may hide a row. Harm is claimed first, so hiding chatter can never hide a hit.
/// Deaths, typing and steal lines answer neither and are hidden by no kind filter at all
/proc/pov_row_kind_token(list/wrapper, is_attack)
	if(is_attack)
		return " atk"
	var/kind = wrapper["kind"]
	if(kind == LOG_SAY || kind == LOG_WHISPER || kind == LOG_EMOTE)
		return " cht"
	if(kind)
		return ""
	// witnessed rows carry no kind of their own, so log_seen's colours are what tell speech from harm
	var/stored_color = log_entry_field(wrapper["entry"], "color")
	return (stored_color == SEEN_COLOR_SAY || stored_color == SEEN_COLOR_EMOTE) ? " cht" : ""

/// Two fade tiers: barely perceived, and someone else's fight.
/// row_target, not the attacker: a receipt has no target, and a hit taken off screen is exactly the faded case
/proc/pov_row_fade(glyph, actor, is_attack, subject_ckey, row_target)
	if(glyph)
		return "opacity:0.5;filter:alpha(opacity=50); "
	if(actor && is_attack && subject_ckey && row_target != subject_ckey)
		return "opacity:0.6;filter:alpha(opacity=60); "
	return ""

/// Combat prose embeds one key_name, and the row already stores whose ckey it is. Exact match, no guessing
/proc/pov_mask_prose_ckey(message, prose_ckey)
	var/prose_key = prose_ckey ? GLOB.pov_player_keys[prose_ckey] : null
	if(!prose_key)
		return message
	// a DC suffix can sit between the key and the slash
	var/key_pos = findtextEx(message, "[prose_key]/(") || findtextEx(message, "[prose_key]\[DC\]/(")
	if(!key_pos)
		return message
	var/slash_pos = findtext(message, "/(", key_pos)
	return copytext(message, 1, key_pos) + pov_ckey_spans(copytext(message, key_pos, slash_pos + 1)) + copytext(message, slash_pos + 1)

/// The two halves of the hide ckeys toggle: the "key/" shown normally, a * player marker in its place when hidden
/proc/pov_ckey_spans(key_part)
	return "<span class='ck'>[log_normalize_html(key_part)]</span><span class='ckh' style='display:none'>*</span>"

/// Splits key_name output at the first "/(", which is exact because a BYOND key cannot contain a slash.
/// The * marker means player, so key_name's keyless placeholders must never earn one
/proc/pov_name_with_ckey_spans(name_text)
	var/split = findtext(name_text, "/(")
	if(!split || copytext(name_text, 1, split) == "*no key*" || copytext(name_text, 1, split) == "*null*")
		return log_normalize_html(name_text)
	return "[pov_ckey_spans(copytext(name_text, 1, split + 1))][log_normalize_html(copytext(name_text, split + 1))]"

/// Entry keys carry "\[stamp\] key/(Name) place". Spans the key only, the stamp is not a name
/proc/pov_key_with_ckey_spans(raw_key)
	var/split = findtext(raw_key, "/(")
	if(!split || split < 23)
		return log_normalize_html(raw_key)
	var/key_part = copytext(raw_key, 23, split)
	if(key_part == "*no key*" || key_part == "*null*")
		return log_normalize_html(raw_key)
	return "[log_normalize_html(copytext(raw_key, 1, 23))][pov_ckey_spans(copytext(raw_key, 23, split + 1))][log_normalize_html(copytext(raw_key, split + 1))]"

/// Z arrows are flipped, a witness above means it happened below them. Direction digits already point at the event
/proc/pov_perception_glyph(witness_entry)
	var/tag = witness_tag(witness_entry)
	if(!tag)
		return ""
	var/static/list/glyphs = list("^" = "&#8650;", "v" = "&#8648;", "~" = "~")
	return glyphs[tag] || pov_numpad_arrow(tag) || ""

/// Everything in the key but the time and log number. Cut at fixed text log_message writes, no guessing.
/// key_name's "(Character Name)" closes before loc_name opens and names cannot hold parens, so the
/// first ") " is where the who ends and the where begins. The header already names them
/proc/pov_entry_place(raw_key)
	var/log_pos = findlasttext(raw_key, " (LOG #")
	var/name_end = findtext(raw_key, ") ", 23)
	return copytext(raw_key, name_end ? name_end + 2 : 23, log_pos || 0)

/// "a" plus a ckey-flattened id. Rows, highlights, label lookups and the page's javascript all key off this.
/proc/pov_row_class(actor_id)
	return "a[ckey("[actor_id]")]"

/// The newest entry at or before a moment, entries running newest first
/proc/pov_entry_index_at(list/entries, at_time)
	var/index = 0
	for(var/list/wrapper as anything in entries)
		index++
		var/entry_time = wrapper["time"]
		if(entry_time && entry_time <= at_time)
			return index
	return index || 1

/// Opens that person's POV in the same mode, landing on the moment pivoted from rather than the top of their timeline
/proc/pov_pivot_link(actor_id, at_time, pov_mode)
	var/id_text = "[actor_id]"
	// players are keyed by ckey, mobs by ref string, which always carries a bracket
	var/mob/target = findtext(id_text, "\[") ? locate(id_text) : get_mob_by_key(id_text)
	if(!istype(target))
		return ""
	return " <a href='?_src_=holder;[HrefToken()];individuallog=[REF(target)];log_type=[INDIVIDUAL_POV_LOG];log_src=[target.client ? LOGSRC_CLIENT : LOGSRC_MOB];pov_mode=[pov_mode];pov_at=[at_time];pov_focus=1;page_len=[POV_FOCUS_PAGE_LEN]'>&#8644;</a>"

/// A POV block header's text: who they are, plus the role they were holding if they have one
/proc/pov_actor_label(mob/actor, name_text)
	var/title = actor?.get_role_title()
	// get_role_title() says "unknown" for anything without a job, which is every NPC. Nothing worth printing
	return (title && title != "unknown") ? "[name_text] - [title]" : name_text

// Highlights: painted in the browser, remembered on the server so they survive page turns

/// The ckey box, the filter checkboxes and the chip row. Script first: every handler below is defined in it.
/proc/pov_highlight_controls(subject_class, base_href)
	. = pov_highlight_script(subject_class, base_href)
	. += "<center>Highlight a CKEY: <input type='text' id='povkey' style='width:130px;'> <span style='color:#7fb2d9; text-decoration:underline;' onclick='povHLKey()'>Highlight</span></center>"
	. += "<center>Hide: <label><input type='checkbox' id='povhatk' onclick='povFilterSet()'> attacks</label> \
		&nbsp; <label><input type='checkbox' id='povhcht' onclick='povFilterSet()'> say/emote</label> \
		&nbsp; <label><input type='checkbox' id='povhlit' onclick='povFilterSet()'> non-highlighted</label> \
		&nbsp; <label><input type='checkbox' id='povhdim' onclick='povFilterSet()'> faded</label> \
		&nbsp; <label><input type='checkbox' id='povhck' onclick='povFilterSet()'> ckeys</label><span id='povmsg' style='color:#ff6b6b;'></span></center>"
	. += "<div id='povchips' style='text-align:center;'></div>"

/// Highlighting and filtering, done in the browser so nothing rebuilds. Hooray for technology.
/// Toggles ping the server so they survive page turns.
/proc/pov_highlight_script(subject_class, base_href)
	return {"<script type='text/javascript'>
	// class contract, emitted by style_pov_entries: "blk" on block containers, "row" on rows, "plc" on place lines,
	// "a"+ckey for who acted, "t"+ckey for who it was done to, dim/atk/cht for the filters, ck/ckh for the two ckey
	// halves. povLit maps a class to its label; being in it means lit
	var povLit = {};
	var povMax = [POV_HIGHLIGHT_MAX];
	var povSubject = '[subject_class]';
	var povHref = '[base_href];povhl=';
	var povFilterHref = '[base_href];povfilter=';
	// falls back to the class: a blank label must not read as unlit
	function povSet(row_class, label){ povLit\[row_class\] = label || row_class; }
	function povCount(){ var count = 0; for(var row_class in povLit){ count++; } return count; }
	function povColor(row_class, is_actor){
		// the subject never carries recipient tokens, so they only ever get the one colour
		if(row_class == povSubject) return '#ff6d00';
		return is_actor ? '#ffc957' : '#8a7434';
	}
	// fill, not an outline: per row outlines double up between neighbours and read as stacked boxes
	function povBg(row_class, is_actor){
		if(row_class == povSubject) return '#3d2a12';
		return is_actor ? '#3a3116' : '#282316';
	}
	// one pass for both jobs: colouring and filtering need the same class read and the same match. Writes are value
	// guarded, and nothing here inserts or removes nodes, which is what keeps the browser control happy
	function povApply(){
		var patterns = \[\];
		for(var row_class in povLit){
			patterns.push({acting: ' ' + row_class + ' ', receiving: ' t' + row_class.substring(1) + ' ', row_class: row_class});
		}
		var hide_atk = document.getElementById('povhatk').checked;
		var hide_cht = document.getElementById('povhcht').checked;
		var hide_dim = document.getElementById('povhdim').checked;
		// nothing lit would blank the page, so the box does nothing instead
		var lit_only = document.getElementById('povhlit').checked && patterns.length > 0;
		var hide_ck = document.getElementById('povhck').checked;
		var visible_rows = 0;
		// live collection, so cache the length rather than re-reading it every iteration
		var cells = document.getElementsByTagName('div');
		var cell_count = cells.length;
		for(var cell_index = 0; cell_index < cell_count; cell_index++){
			var cell = cells\[cell_index\];
			var classes = ' ' + cell.className + ' ';
			var is_block = classes.indexOf(' blk ') >= 0;
			var is_row = !is_block && classes.indexOf(' row ') >= 0;
			var is_header = !is_block && !is_row && classes.indexOf(' hdr ') >= 0;
			// the page holds divs we do not own: legend, caution, chips, wrapper
			if(!is_block && !is_row && !is_header) continue;
			// acting wins over receiving and ends the search
			var match = null;
			var acting = false;
			for(var pattern_index = 0; pattern_index < patterns.length && !acting; pattern_index++){
				var pattern = patterns\[pattern_index\];
				if(classes.indexOf(pattern.acting) >= 0){ match = pattern.row_class; acting = true; }
				else if(!match && classes.indexOf(pattern.receiving) >= 0){ match = pattern.row_class; }
			}
			if(is_block){
				// one box per block, not a mark per line
				var want_box = acting ? povColor(match, true) : 'transparent';
				if(cell.style.borderColor != want_box){ cell.style.borderColor = want_box; }
				continue;
			}
			var is_subject_row = classes.indexOf(' ' + povSubject + ' ') >= 0;
			var want_stripe = match ? povColor(match, acting) : (is_subject_row ? '#eac0b9' : '#5a5a5a');
			if(cell.style.borderLeftColor != want_stripe){ cell.style.borderLeftColor = want_stripe; }
			var want_bg = match ? povBg(match, acting) : (is_subject_row ? '#000000' : '#1e1e1e');
			if(cell.style.backgroundColor != want_bg){ cell.style.backgroundColor = want_bg; }
			if(!is_row) continue;
			// headers are never hidden: they stay as proof of who else was there, with their name and pivot still live
			var hide = (hide_dim && classes.indexOf(' dim ') >= 0)
				|| (hide_atk && classes.indexOf(' atk ') >= 0)
				|| (hide_cht && classes.indexOf(' cht ') >= 0)
				|| (lit_only && !match && classes.indexOf(' ' + povSubject + ' ') < 0);
			// place lines are scenery, not content: counting them would stop the guard firing on an emptied page
			if(!hide && classes.indexOf(' plc ') < 0){ visible_rows++; }
			var want_display = hide ? 'none' : '';
			if(cell.style.display != want_display){ cell.style.display = want_display; }
		}
		// the two ckey halves, class-tagged spans of our own making. One shows while the other hides
		var spans = document.getElementsByTagName('span');
		var span_count = spans.length;
		for(var span_index = 0; span_index < span_count; span_index++){
			var span = spans\[span_index\];
			var span_class = span.className;
			var span_display = null;
			if(span_class == 'ck'){ span_display = hide_ck ? 'none' : ''; }
			else if(span_class == 'ckh'){ span_display = hide_ck ? '' : 'none'; }
			if(span_display != null && span.style.display != span_display){ span.style.display = span_display; }
		}
		var msg = document.getElementById('povmsg');
		if(msg){
			var warn = visible_rows == 0 ? ' every row on this page is filtered out' : '';
			if(msg.innerHTML != warn){ msg.innerHTML = warn; }
		}
	}
	function povChips(){
		var chip_box = document.getElementById('povchips');
		if(!chip_box) return;
		var html = '';
		for(var row_class in povLit){
			// the class rides in the id, so the handler reads it back rather than nesting another layer of quotes
			html += '<span id="chip_' + row_class + '" onclick="povHL(this.id.substring(5))" style="color:#7fb2d9; text-decoration:underline; margin-right:6px;">' + povLit\[row_class\] + ' &times;</span>';
		}
		chip_box.innerHTML = html ? 'Highlighted: ' + html : '';
	}
	function povHL(row_class, label){
		var warning = document.getElementById('povmsg');
		if(povLit\[row_class\]){
			delete povLit\[row_class\];
		} else {
			if(povCount() >= povMax){
				if(warning) warning.innerHTML = ' Limit of ' + povMax + ' reached.';
				return;
			}
			povSet(row_class, label);
		}
		if(warning) warning.innerHTML = '';
		povApply(); // colours and the highlighted-only filter both follow the set as it changes
		povChips();
		// a ping, not a navigation: the server keeps its own copy so a page turn can restore it
		window.location.href = povHref + row_class;
	}
	function povHLKey(){
		var key_box = document.getElementById('povkey');
		var typed = key_box.value.toLowerCase().replace(/\[^a-z0-9\]/g, '');
		key_box.value = '';
		if(typed){ povHL('a' + typed, typed); }
	}
	// fixed order, so the state string and the restore cannot disagree about which box is which
	function povBoxes(){
		return \[document.getElementById('povhatk'), document.getElementById('povhcht'), document.getElementById('povhlit'),
			document.getElementById('povhdim'), document.getElementById('povhck')\];
	}
	// only a click pings. The restore pass and highlight changes call povApply directly, or they would ping back on load
	function povFilterSet(){
		povApply();
		var boxes = povBoxes();
		var state = '';
		for(var box_index = 0; box_index < boxes.length; box_index++){ state += boxes\[box_index\].checked ? '1' : '0'; }
		window.location.href = povFilterHref + state;
	}
	function povRestoreFilters(state){
		var boxes = povBoxes();
		for(var box_index = 0; box_index < boxes.length; box_index++){ boxes\[box_index\].checked = state.charAt(box_index) == '1'; }
	}
	</script>"}


/// Toggles one name in the admin's remembered set. The page paints instantly and pings this alongside.
/proc/pov_touch_prefs(list/prefs, cache_key)
	var/entry = prefs[cache_key]
	prefs -= cache_key
	prefs[cache_key] = entry
	while(length(prefs) > POV_PREFS_MAX)
		prefs.Cut(1, 2)

/client/proc/toggle_pov_highlight(mob/M, source, pov_mode, hl_class)
	if(!M || !pov_mode)
		return
	// href input: row classes are "a" plus a ckey, so anything ckey() alters was not one we emitted
	hl_class = ckey(hl_class)
	if(!length(hl_class))
		return
	var/cache_key = pov_cache_key(M, source, pov_mode)
	LAZYINITLIST(pov_log_highlights)
	LAZYINITLIST(pov_log_highlights[cache_key])
	var/list/highlights = pov_log_highlights[cache_key]
	if(hl_class in highlights)
		highlights -= hl_class
		if(length(highlights))
			pov_touch_prefs(pov_log_highlights, cache_key)
		else
			pov_log_highlights -= cache_key
		return
	if(length(highlights) >= POV_HIGHLIGHT_MAX)
		to_chat(src, span_warning("POV highlight limit of [POV_HIGHLIGHT_MAX] reached. Remove one first."))
		return
	highlights += hl_class
	pov_touch_prefs(pov_log_highlights, cache_key)

/// Remembers which filter boxes were ticked, pinged the same way highlights are
/client/proc/set_pov_filters(mob/M, source, pov_mode, state)
	if(!M || !pov_mode)
		return
	// href input: the page only ever sends five characters, each 0 or 1
	if(length(state) != 5)
		return
	for(var/position in 1 to 5)
		var/digit = copytext(state, position, position + 1)
		if(digit != "0" && digit != "1")
			return
	var/cache_key = pov_cache_key(M, source, pov_mode)
	LAZYINITLIST(pov_log_filters)
	pov_log_filters[cache_key] = state
	pov_touch_prefs(pov_log_filters, cache_key)

/// A header's name doubles as the highlight control, so there is no second widget for it
/proc/pov_highlight_link(actor_class, label, colour)
	return "<b><font color='[colour]'><span style='text-decoration:underline;' onclick=\"povHL('[actor_class]', '[pov_safe_label(label)]')\">[pov_name_with_ckey_spans(label)]</span></font></b>"

/// Labels end up inside the page's javascript, so quotes, tags and backslashes cannot survive the trip
/proc/pov_safe_label(text)
	if(!text)
		return ""
	text = replacetext(text, "\\", "")
	text = replacetext(text, "'", "")
	text = replacetext(text, "\"", "")
	text = replacetext(text, "<", "")
	text = replacetext(text, ">", "")
	return text

// The Seen By log's collapsible witness lists, used by both the Seen By tab and every POV row

/// The arrow for a numpad direction code, null for anything that is not one
/proc/pov_numpad_arrow(code)
	var/static/list/arrows = list(
		"8" = "&#8593;", "9" = "&#8599;", "6" = "&#8594;", "3" = "&#8600;",
		"2" = "&#8595;", "1" = "&#8601;", "4" = "&#8592;", "7" = "&#8598;",
	)
	return arrows[code]

/// The witness list for a seen row, count up front and names behind a click. element_id must be unique on
/// the page. plain skips the ckey spans: only the POV page emits the script that toggles them, so on the
/// plain tabs they are dead markup bought at two extra encode passes per name. If those tabs ever gain the
/// ckey filter, their caller must stop passing plain or the filter will silently skip witness names
/proc/pov_witness_html(list/witnesses, element_id, plain = FALSE)
	if(!length(witnesses)) // nobody to expand, so it says its piece here or nowhere
		return " (<font color='[SEEN_LOG_WITNESS_COLOR]'>Witnesses: nobody</font>)"
	var/static/list/marks = list("^" = "&#8648;", "v" = "&#8650;", "~" = "~")
	var/list/shown = list()
	for(var/witness_key in witnesses)
		var/witness_entry = witnesses[witness_key]
		var/shown_name = plain ? log_normalize_html(witness_display_name(witness_entry)) : pov_name_with_ckey_spans(witness_display_name(witness_entry))
		var/tag = witness_tag(witness_entry)
		var/code = text2num(tag)
		var/mark = tag ? (marks[tag] || (code ? pov_numpad_arrow(num2text(10 - code)) : null)) : null
		if(mark)
			shown_name += " <font color='#8a8a8a'>[mark]</font>"
		shown += shown_name
	var/toggle = "<span style='color:#7fb2d9; text-decoration:underline;' onclick=\"var e=document.getElementById('[element_id]');e.style.display=(e.style.display=='none')?'inline':'none';\">(+[length(shown)])</span>"
	return " (<font color='[SEEN_LOG_WITNESS_COLOR]'>Witnesses: [toggle]<span id='[element_id]' style='display:none'> [shown.Join(", ")]</span></font>)"

/// One row of log tabs. The mob row omits OOC, which only ever exists on a client record
/proc/individual_logging_panel_row(mob/M, log_src, source, ntype, include_ooc)
	var/static/list/tabs = list(
		"[INDIVIDUAL_ATTACK_LOG]" = "Attack Log",
		"[INDIVIDUAL_SAY_LOG]" = "Say Log",
		"[INDIVIDUAL_EMOTE_LOG]" = "Emote Log",
		"[INDIVIDUAL_COMMS_LOG]" = "Comms Log",
		"[INDIVIDUAL_OOC_LOG]" = "OOC Log",
		"[INDIVIDUAL_LOOC_LOG]" = "LOOC Log",
		"[INDIVIDUAL_SEEN_LOG]" = "Seen By Log",
		"[INDIVIDUAL_POV_LOG]" = "POV Log",
		"[INDIVIDUAL_SHOW_ALL_LOG]" = "Show All",
	)
	var/list/links = list()
	for(var/log_type in tabs)
		var/ntab = text2num(log_type)
		if(ntab == INDIVIDUAL_OOC_LOG && !include_ooc)
			continue
		links += individual_logging_panel_link(M, ntab, log_src, tabs[log_type], source, ntype)
	return "<center>[links.Join(" | ")]</center>"

/proc/individual_logging_panel_link(mob/M, log_type, log_src, label, selected_src, selected_type)
	var/slabel = label
	if(selected_type == log_type && selected_src == log_src)
		slabel = "<b>\[[label]\]</b>"
	return "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_type=[log_type];log_src=[log_src]'>[slabel]</a>"

#undef POV_LOG_PAGE_LEN
#undef POV_LOG_COOLDOWN
#undef POV_SORT_BLOCK
#undef POV_HIGHLIGHT_MAX
#undef POV_SCENE_GAP
#undef POV_PRESENCE_BUCKET
#undef POV_FOCUS_PAGE_LEN
#undef POV_FOCUS_LINK_EVERY
#undef SEEN_LOG_WITNESS_COLOR
#undef POV_CACHE_MAX
