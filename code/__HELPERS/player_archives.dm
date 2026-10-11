// Shared helpers for the persistent player book and painting archives (SSlibrarian and SSpaintings).

/// Returns the URL-encoded archive filename for a title, or null if the title cannot be stored safely.
/proc/player_archive_filename(title)
	if(!istext(title) || !length(trim(title)) || length(title) > MAX_NAME_LEN)
		return
	if(copytext(title, 1, 2) == "_")
		return
	var/file_name = url_encode(title)
	var/static/regex/unsafe_filename = regex(@{"[\\/:*?"<>|]"})
	if(length(file_name) > 150 || unsafe_filename.Find(file_name))
		return
	return file_name

/proc/player_archive_feedback(mob/user, message, success = FALSE)
	if(!user)
		return
	to_chat(user, success ? span_notice(message) : span_warning(message))

/// Escapes player-supplied archive text for HTML output, without double-encoding text that was already encoded on input.
/proc/player_archive_display_text(text, fallback = "Unknown")
	if(isnull(text) || text == "")
		return html_encode(fallback)
	return html_encode(html_decode("[text]"))

/// Archived books and paintings are always signed with the creator's true name.
/proc/player_archive_author_name(mob/user)
	return player_archive_display_text(user?.real_name)

/// Loads every archive entry in a directory, keyed by filename without the .json extension.
/proc/load_player_archive(directory)
	. = list()
	for(var/file_name in flist(directory))
		if(copytext(file_name, 1, 2) == "_" || copytext(file_name, -5) != ".json")
			continue
		var/list/contents = safe_json_decode(file2text("[directory][file_name]"))
		if(!islist(contents))
			log_world("Player archive file [directory][file_name] contains invalid JSON and was skipped.")
			continue
		.[copytext(file_name, 1, -5)] = contents

/proc/write_player_archive_file(path, list/contents)
	fdel(path)
	if(!text2file(json_encode(contents), path))
		message_admins("Unable to save archive file [path].")
		return FALSE
	return TRUE

/// Returns the upload bans for an archive, either "books" or "paintings".
/proc/get_player_archive_bans(archive)
	switch(archive)
		if("books")
			return SSlibrarian.upload_bans
		if("paintings")
			return SSpaintings.upload_bans

/// Players barred by admins from adding to one of the player archives, kept across rounds.
/datum/player_archive_bans
	/// The archive these bans apply to, either "books" or "paintings".
	var/archive
	var/file_path
	/// Ban details keyed by ckey: the key of the admin who applied the ban and the real date it was applied.
	var/list/bans = list()

/datum/player_archive_bans/New(archive, file_path)
	src.archive = archive
	src.file_path = file_path
	if(!fexists(file_path))
		return
	var/list/loaded = safe_json_decode(file2text(file_path))
	if(!islist(loaded))
		log_world("Player archive ban file [file_path] contains invalid JSON and was skipped.")
		return
	bans = loaded

/datum/player_archive_bans/proc/is_banned(key)
	var/banned_ckey = ckey(key)
	return banned_ckey && bans[banned_ckey]

/datum/player_archive_bans/proc/ban(key, admin_key)
	var/banned_ckey = ckey(key)
	if(!banned_ckey || bans[banned_ckey])
		return FALSE
	var/list/new_bans = bans.Copy()
	new_bans[banned_ckey] = list("admin" = "[admin_key]", "date" = time2text(world.realtime, "YYYY-MM-DD"))
	if(!write_player_archive_file(file_path, new_bans))
		return FALSE
	bans = new_bans
	return TRUE

/datum/player_archive_bans/proc/unban(key)
	var/banned_ckey = ckey(key)
	if(!banned_ckey || !bans[banned_ckey])
		return FALSE
	var/list/new_bans = bans.Copy()
	new_bans -= banned_ckey
	if(!write_player_archive_file(file_path, new_bans))
		return FALSE
	bans = new_bans
	return TRUE
