/*
	Log values are dicts, not strings: "msg" plus metadata, so nothing here parses prose.
	"msg" is stored PLAIN with any colour riding as "color": log_entry_text() normalizes then wraps at render,
	so markup written into a stored value shows as literal text. Keep it that way, storage stays plain.
	log_combat() mints one "event" id shared by its three writes (attacker line, seen entry, target receipt).
	Forward lines and seen entries carry the target's ckey as "target"; receipts are flagged "receipt" and carry
	the attacker's ckey as "attacker", absent when that attacker is keyless. log_seen() stores "witnesses" as
	ckey to list(name, tiles away, perception tag), the tag ^ v ~ or a direction digit. Disk logs carry none of it.

	Invariants:
	1. The witnessed pass must finish before the offscreen pass. It marks event ids and clear sightings; the pull trusts both.
	2. The subject's receipts never mark. Their thread and the attacker's block both showing the hit is intended.
	3. Only receipts pull, and only when their victim was clearly in the subject's view around that moment.
	   Fights the subject never saw stay out entirely.
	4. Reads go through the accessors below, so a stray string degrades to text instead of erroring.
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

/// Stored text is mixed: player text arrives html_encoded at input, system text (names, places) arrives raw.
/// Decode then encode lands both at exactly one encoding, so text shows as typed instead of as markup.
/proc/log_normalize_html(text)
	return html_encode(html_decode(text))

/// Accessors, not direct indexing: a value written before the dict format degrades to plain text instead of erroring
/proc/log_entry_text(value)
	if(!islist(value))
		return log_normalize_html(value)
	var/list/entry = value
	var/text = log_normalize_html(entry["msg"])
	var/color = entry["color"]
	if(!color)
		return text
	// unquoted hex, quoted named colour: the IE control wants both forms
	if(color[1] == "#")
		return "<font color=[color]>[text]</font>"
	return "<font color='[color]'>[text]</font>"

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
	var/list/saved_highlights
	var/saved_filters
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
			saved_highlights = LAZYACCESS(admin?.pov_log_highlights, cache_key)
			saved_filters = LAZYACCESS(admin?.pov_log_filters, cache_key)
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
			dat += render_pov_log(M, concatenated_logs, pov_actor_labels, ntype, source, pov_mode, page, page_len, pov_tail, pov_focus, saved_highlights, pov_at, saved_filters)
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
			var/value = all_the_entrys[entry]
			var/line = log_entry_text(value)
			var/list/witnesses = log_entry_field(value, "witnesses")
			if(!isnull(witnesses))
				seen_entry_number++
				line += pov_witness_html(witnesses, "seen[seen_entry_number]")
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
	add_pov_own_entries(., log_source, included_events, subject_receipts)

	if(!M.key)
		return

	var/list/roster_labels = list()
	var/list/actor_logs = pov_actor_roster(M, all_mobs, roster_labels)
	var/seen_key = num2text(LOG_SEEN)
	var/attack_key = num2text(LOG_ATTACK)
	var/list/already_added = list()
	// "[actor]@[bucket]" keys, when each person was in view
	var/list/presence = list()
	pov_harvest_own_rosters(log_source, presence)

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

/// Marks presence for everyone who witnessed the subject's own actions
/proc/pov_harvest_own_rosters(list/log_source, list/presence)
	var/list/seen_entries = log_source[num2text(LOG_SEEN)]
	for(var/entry in seen_entries)
		CHECK_TICK
		var/value = seen_entries[entry]
		var/list/witnesses = log_entry_field(value, "witnesses")
		if(!witnesses)
			continue
		var/entry_time = log_entry_field(value, "time")
		for(var/witness_ckey in witnesses)
			// eavesdropped, another floor, or past the screen edge, none of which is "in view"
			if(!witness_tag(witnesses[witness_ckey]))
				pov_mark_presence(presence, witness_ckey, entry_time)

/// "time" is precomputed so the sort never digs into the stored value or throws on a malformed one
/proc/pov_timeline_row(entry_key, value, actor_id = null)
	. = list("key" = entry_key, "entry" = value, "time" = log_entry_field(value, "time") || 0)
	if(actor_id)
		.["actor"] = actor_id

/// The subject's own rows. Their forward attacks mark included_events; their receipts do NOT, because a hit on them is
/// meant to show in both their thread and the attacker's block. Receipts are indexed instead, for the distance handoff.
/proc/add_pov_own_entries(list/output, list/log_source, list/included_events, list/subject_receipts)
	var/static/list/own_types = list(LOG_ATTACK, LOG_SAY, LOG_WHISPER, LOG_EMOTE)
	// log_talk writes no colour, so own rows would render plain against everyone else's log_seen scheme
	var/static/list/own_colors = list("[LOG_SAY]" = "orange", "[LOG_WHISPER]" = "orange", "[LOG_EMOTE]" = "grey")
	for(var/type in own_types)
		var/list/entries = log_source[num2text(type)]
		for(var/entry in entries)
			CHECK_TICK
			var/value = entries[entry]
			var/list/wrapper = pov_timeline_row(entry, value)
			wrapper["kind"] = type
			wrapper["tint"] = own_colors["[type]"]
			output += list(wrapper)
			if(type != LOG_ATTACK)
				continue
			var/event_id = log_entry_field(value, "event")
			if(!event_id)
				continue
			if(log_entry_field(value, "receipt"))
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
		var/list/witnesses = log_entry_field(value, "witnesses")
		if(!witnesses)
			continue
		// a hit on the subject: hand their range to the receipt, then let the row render. Do not skip it, this is the
		// only copy carrying the witness roster
		if(log_entry_field(value, "target") == subject_ckey)
			var/hit_id = log_entry_field(value, "event")
			var/list/receipt_wrapper = hit_id ? LAZYACCESS(subject_receipts, hit_id) : null
			if(receipt_wrapper)
				receipt_wrapper["dist"] = witness_distance(witnesses[subject_ckey])
		if(!witnesses[subject_ckey])
			continue
		if(!witness_tag(witnesses[subject_ckey]))
			pov_mark_presence(presence, actor_id, log_entry_field(value, "time"))
		already_added[entry] = TRUE
		var/event_id = log_entry_field(value, "event")
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
		if(!log_entry_field(value, "receipt"))
			continue
		var/event_id = log_entry_field(value, "event")
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
/proc/render_pov_log(mob/M, list/entries, list/actor_labels, ntype, source, pov_mode, page, page_len, pov_tail, focused = FALSE, list/saved_highlights, pov_at = null, saved_filters = null)
	. = list()
	// href input: unclamped, a huge value renders the whole timeline at once and a negative one inverts the maths below
	var/entries_per_page = clamp(page_len || POV_LOG_PAGE_LEN, POV_FOCUS_PAGE_LEN, POV_LOG_PAGE_LEN)
	var/total = length(entries)
	var/pages = ROUND_UP(total / entries_per_page)
	// a pivot carries the moment it was clicked from, not a position, this timeline being someone else's
	if(isnull(pov_tail) && !isnull(pov_at))
		pov_tail = total - pov_entry_index_at(entries, pov_at)
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
	var/subject_label = pov_actor_label(M, key_name(M))

	if(pages > 1)
		. += pov_page_nav(page, pages, first, last, total, page_href, entries_per_page)
	if(focused)
		. += "<center><a href='[base_href]'>Back to the full timeline</a></center>"
	. += pov_legend(M, focused, pov_mode)
	. += pov_highlight_controls(subject_class, base_href)

	// explicit size: the panel's <font size=2px> is not a valid attribute and gets coerced
	. += "<div style='font-size:14px;'>"
	// null focus_href in the focused view, no point linking to where you already are.
	// It's fucking annoying when you accidentally scroll away
	. += style_pov_entries(page_entries, actor_labels, subject_label, focused ? null : base_href, first, total, subject_class, M.ckey, pov_mode)
	. += "</div>"
	// must come after the rows, it paints divs that have to exist first
	. += pov_restore_script(saved_highlights, saved_filters, subject_class, subject_label, actor_labels)

/// Puts back highlights and filters after a page turn, from the server's copy the page cannot keep itself.
/proc/pov_restore_script(list/saved_highlights, saved_filters, subject_class, subject_label, list/actor_labels)
	if(!length(saved_highlights) && !saved_filters)
		return ""
	var/list/restore = list("<script type='text/javascript'>")
	for(var/hl in saved_highlights)
		// a ckey typed into the box may never have acted, so fall back to the ckey inside the class
		var/label = (hl == subject_class) ? subject_label : (actor_labels[hl] || copytext(hl, 2))
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
		<br><b>Filters.</b> The boxes above hide chatter, faded rows, or anyone not highlighted. Headers always stay, so you can still see who else was there."
	var/all_mobs_caveat = "All Mobs: a mob's log dies with it, so gibbed or deleted NPCs are missing here, which can shift where a \" &raquo; \" link lands."

	// bruh, ya'll better read this
	var/caution ="<b>Absence is not evidence.</b> A great deal of harm records nothing at all, including spells and miracles, traps, explosions, falls, strangling, drowning, fire and poison. A missing line does not mean it did not happen.\
		<br><b>Witness lists</b> are who stood close enough to perceive something, not who did. Blindness, facing away, and language are not accounted for.\
		<br><b>Off-screen hits</b> show only when their victim had been clearly in [M]'s view around that moment. A victim who never acted nearby leaves no proof they were visible, so their hit stays out.\
		<br><b>Speech</b> is stored as typed, not as perceived. Listeners may have heard it slurred by injury, starred at a distance, or in a language they do not know.\
		<br><b>Typing</b> appears only in [M]'s own rows. It records no witnesses, so nobody else's bubble reaches this page even though it was visible in game.\
		<br><b>Headless dullahan speech</b> is recorded nowhere at all.\
		<br><b>This timeline is a snapshot</b> taken when it was generated, and a clientless mob's log dies with the mob."

	// both are read once then in the way, so they sit behind toggles. The All Mobs caveat stays visible
	. = list("<center><span style='color:#7fb2d9; text-decoration:underline;' onclick=\"var e=document.getElementById('povlegend');e.style.display=(e.style.display=='none')?'block':'none';\">Legend</span>\
		&nbsp; <span style='color:#ff6b6b; text-decoration:underline;' onclick=\"var e=document.getElementById('povcaution');e.style.display=(e.style.display=='none')?'block':'none';\">Caution</span>\
		<div id='povlegend' style='display:none; text-align:left; padding:2px 8px;'>[colour_key]</div>\
		<div id='povcaution' style='display:none; text-align:left; padding:2px 8px; color:#ffc957;'>[caution]</div></center>")
	if(pov_mode == "all")
		. += "<center><font color='#ffc957'><i>[all_mobs_caveat]</i></font></center>"

/// Wraps entries in blocks headed by whoever acted. Subject on black under gold, everyone else grey under blue.
/proc/style_pov_entries(list/entries, list/actor_labels, subject_label, focus_href, start_index = 1, total_entries = 0, subject_class = "asubject", subject_ckey = null, pov_mode = null)
	. = list()
	// deliberately smaller than the rows: the rows are what gets read
	var/header_style = "font-size:12px; padding:2px 5px 1px 5px;"
	var/subject_header_style = "font-size:14px; padding:2px 5px 1px 5px;"
	var/static/list/kind_prefixes = list("[LOG_WHISPER]" = "(whisper) ", "[LOG_EMOTE]" = "(emote) ")
	var/focused = isnull(focus_href)
	var/last_actor
	var/last_place
	var/have_block = FALSE
	var/index = start_index
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

		var/list/witnesses = log_entry_field(stored, "witnesses")
		var/subject_witness = subject_ckey ? LAZYACCESS(witnesses, subject_ckey) : null
		var/glyph = pov_perception_glyph(subject_witness)
		var/subject_dist = witness_distance(subject_witness)
		if(isnull(subject_dist)) // a hit they took: their range came from the attacker's roster at build time
			subject_dist = wrapper["dist"]
		var/is_receipt = log_entry_field(stored, "receipt")
		var/event_id = log_entry_field(stored, "event")

		var/row_marks = glyph
		if(!isnull(subject_dist))
			row_marks = row_marks ? "[row_marks] ([subject_dist])" : "([subject_dist])"
		if(row_marks)
			row_marks = "<font color='#8a8a8a'>[row_marks]</font> "
		// after the marks, not before the time, so the time column stays straight
		if(is_receipt)
			row_marks += actor ? "<font color='#ff8f6b'>&#8606;</font> " : "<font color='#ff8f6b'>&#8592;</font> "

		// raw key shape: "\[YYYY-MM-DD hh:mm:ss\] who where (LOG #n)", built in log_message()
		var/full_key = log_normalize_html(raw_key)
		var/message = log_entry_text(stored)
		var/kind_prefix = kind_prefixes["[wrapper["kind"]]"]
		if(kind_prefix)
			message = "[kind_prefix][message]"
		var/tint = wrapper["tint"]
		if(tint)
			message = "<font color='[tint]'>[message]</font>"
		if(is_receipt)
			message = "<i>[message]</i>"
		var/line
		var/place_line = ""
		if(focused)
			line = "<b>[full_key]</b><br>[row_marks][message]"
		else
			var/place = pov_entry_place(raw_key)
			if(place != last_place)
				last_place = place
				place_line = "<div class='[block_class] row' style='[row_style] color:#8a8a8a; font-size:12px; padding:1px 5px;'>[place]</div>"
			line = "<font color='#8a8a8a'>[copytext(raw_key, 13, 21)]</font> [row_marks][message]"
		if(!isnull(witnesses))
			line += pov_witness_html(witnesses, "pov[index]")

		// an id or a receipt flag is what separates a hit from speech, a death or a typing line
		var/is_attack = event_id || is_receipt
		// two fade tiers: barely perceived, and someone else's fight
		var/row_dim = glyph ? "opacity:0.5;filter:alpha(opacity=50); " : ""
		if(!row_dim && actor && subject_ckey && is_attack && log_entry_field(stored, "target") != subject_ckey)
			row_dim = "opacity:0.6;filter:alpha(opacity=60); "
		// the other party, so highlighting a name stripes rows they were in
		var/recipient = ""
		var/row_other = log_entry_field(stored, "target") || log_entry_field(stored, "attacker")
		if(row_other && row_other != subject_ckey && "a[row_other]" != block_class)
			recipient = " t[row_other]"
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
		// class tokens drive the browser side: blk/row/hdr for what to touch, a/t for who, dim/atk for the filters
		. += "<div class='[block_class] row[recipient][row_dim ? " dim" : ""][is_attack ? " atk" : ""]' style='[row_style] [row_dim][actor ? "" : "font-size:15px; "]padding:1px 5px;' title='[pov_safe_label(full_key)]'>[line][focus]</div>"
	if(have_block)
		. += "</div>"

/// Z arrows are flipped, a witness above means it happened below them. Direction digits already point at the event
/proc/pov_perception_glyph(witness_entry)
	var/tag = witness_tag(witness_entry)
	if(!tag)
		return ""
	var/static/list/glyphs = list("^" = "&#8650;", "v" = "&#8648;", "~" = "~")
	return glyphs[tag] || pov_numpad_arrow(tag) || ""

/// Everything in the key but the time and log number. Cut at fixed text log_message writes, no guessing.
/proc/pov_entry_place(raw_key)
	var/log_pos = findlasttext(raw_key, " (LOG #")
	return copytext(raw_key, 23, log_pos || 0)

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
	. += "<center>Highlight a CKEY: <input type='text' id='povkey' style='width:130px;'> <span style='color:#7fb2d9; text-decoration:underline;' onclick='povHLKey()'>Highlight</span> \
		&nbsp; <label><input type='checkbox' id='povatk' onclick='povFilterSet()'> attacks only</label> \
		&nbsp; <label><input type='checkbox' id='povlit' onclick='povFilterSet()'> highlighted only</label> \
		&nbsp; <label><input type='checkbox' id='povdim' onclick='povFilterSet()'> hide faded rows</label><span id='povmsg' style='color:#ff6b6b;'></span></center>"
	. += "<div id='povchips' style='text-align:center;'></div>"

/// Highlighting and filtering, done in the browser so nothing rebuilds. Hooray for technology.
/// Toggles ping the server so they survive page turns.
/proc/pov_highlight_script(subject_class, base_href)
	return {"<script type='text/javascript'>
	// class contract, emitted by style_pov_entries: "blk" on block containers, "row" on rows, "a"+ckey for who acted,
	// "t"+ckey for who it was done to, dim/atk for the filters. povLit maps a class to its label; being in it means lit
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
		var attacks_only = document.getElementById('povatk').checked;
		var hide_dim = document.getElementById('povdim').checked;
		// nothing lit would blank the page, so the box does nothing instead
		var lit_only = document.getElementById('povlit').checked && patterns.length > 0;
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
			// headers are never hidden: they stay as proof of who else was there, with their name and pivot still live.
			// Nor is the subject, whatever is filtered
			var hide = (hide_dim && classes.indexOf(' dim ') >= 0)
				|| (attacks_only && classes.indexOf(' atk ') < 0)
				|| (lit_only && !match && classes.indexOf(' ' + povSubject + ' ') < 0);
			var want_display = hide ? 'none' : '';
			if(cell.style.display != want_display){ cell.style.display = want_display; }
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
		return \[document.getElementById('povatk'), document.getElementById('povlit'), document.getElementById('povdim')\];
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
	// href input: the page only ever sends three characters, each 0 or 1
	if(length(state) != 3)
		return
	for(var/position in 1 to 3)
		var/digit = copytext(state, position, position + 1)
		if(digit != "0" && digit != "1")
			return
	var/cache_key = pov_cache_key(M, source, pov_mode)
	LAZYINITLIST(pov_log_filters)
	pov_log_filters[cache_key] = state
	pov_touch_prefs(pov_log_filters, cache_key)

/// A header's name doubles as the highlight control, so there is no second widget for it
/proc/pov_highlight_link(actor_class, label, colour)
	return "<b><font color='[colour]'><span style='text-decoration:underline;' onclick=\"povHL('[actor_class]', '[pov_safe_label(label)]')\">[log_normalize_html(label)]</span></font></b>"

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

/// The witness list for a seen row, count up front and names behind a click. element_id must be unique on the page.
/proc/pov_witness_html(list/witnesses, element_id)
	if(!length(witnesses))
		return " (<font color='[SEEN_LOG_WITNESS_COLOR]'>Witnesses: nobody</font>)"
	var/static/list/marks = list("^" = "&#8648;", "v" = "&#8650;", "~" = "~")
	var/list/shown = list()
	for(var/witness_key in witnesses)
		var/witness_entry = witnesses[witness_key]
		var/shown_name = log_normalize_html(witness_display_name(witness_entry))
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
