// The persistent player book and painting archives, owned by SSlibrarian and SSpaintings.

#define PLAYER_ARCHIVE_BOOKS "books"
#define PLAYER_ARCHIVE_PAINTINGS "paintings"
/// The category of player books filed under none of GLOB.player_book_categories, including those archived before categories existed.
#define PLAYER_BOOK_DEFAULT_CATEGORY "Misc"

/// Returns the archive filename for a title, or null if the title cannot be stored safely.
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

/proc/write_player_archive_file(path, list/contents)
	fdel(path)
	if(!text2file(json_encode(contents), path))
		message_admins("Unable to save archive file [path].")
		return FALSE
	return TRUE

/// Returns the archive of the given kind, either PLAYER_ARCHIVE_BOOKS or PLAYER_ARCHIVE_PAINTINGS.
/proc/get_player_archive(kind)
	switch(kind)
		if(PLAYER_ARCHIVE_BOOKS)
			return SSlibrarian.archive
		if(PLAYER_ARCHIVE_PAINTINGS)
			return SSpaintings.archive

/// A directory of archived player creations, one JSON file per entry, kept across rounds along with the players barred from adding to it.
/datum/player_archive
	/// PLAYER_ARCHIVE_BOOKS or PLAYER_ARCHIVE_PAINTINGS, used in admin links and messages.
	var/kind
	/// What one entry is called in messages.
	var/entry_noun
	var/directory
	/// The entry key holding the title.
	var/title_key
	/// Entries keyed by filename. Loaded once and kept in sync with the files on every change.
	var/list/entries = list()
	/// Entries already placed in the world by mapped spawners this round, so none is placed twice.
	var/list/placed = list()
	/// Ban details of players barred from adding to the archive, keyed by ckey: the key of the admin who applied the ban and the real date it was applied.
	var/list/upload_bans = list()

/datum/player_archive/New()
	load_entries()
	load_upload_bans()

/datum/player_archive/proc/get_bans_path()
	return "[directory]_upload_bans.json"

/datum/player_archive/proc/get_entry_path(file_name)
	return "[directory][file_name].json"

/datum/player_archive/proc/load_entries()
	// Only the archive's own bookkeeping files are skipped. Entries archived before titles were barred from starting with an underscore still load.
	// _book_titles.json is the title index of the old book archive, which no longer reads it.
	var/static/list/reserved_files = list("_upload_bans.json", "_book_titles.json")
	entries = list()
	for(var/file_name in flist(directory))
		if((file_name in reserved_files) || copytext(file_name, -5) != ".json")
			continue
		var/list/contents = safe_json_decode(file2text("[directory][file_name]"))
		if(!islist(contents))
			log_world("Player archive file [directory][file_name] contains invalid JSON and was skipped.")
			continue
		entries[copytext(file_name, 1, -5)] = contents

/datum/player_archive/proc/load_upload_bans()
	var/bans_path = get_bans_path()
	if(!fexists(bans_path))
		return
	var/list/loaded = safe_json_decode(file2text(bans_path))
	if(!islist(loaded))
		log_world("Player archive ban file [bans_path] contains invalid JSON and was skipped.")
		return
	upload_bans = loaded

/// Returns the entry stored under a filename, or an empty list if there is none.
/datum/player_archive/proc/get_entry(file_name)
	var/list/contents = entries[file_name]
	return contents ? contents : list()

/// Returns the escaped title of an entry, falling back to its filename.
/datum/player_archive/proc/get_display_title(file_name)
	var/list/contents = get_entry(file_name)
	return player_archive_display_text(contents[title_key], file_name)

/// Whether the entry stored under a filename is complete enough to place in the world or print.
/datum/player_archive/proc/is_usable(file_name)
	var/list/contents = entries[file_name]
	return contents && contents[title_key]

/// Returns the filenames of usable entries, leaving out those already placed this round unless include_placed is set.
/datum/player_archive/proc/get_usable_entries(include_placed = FALSE)
	. = list()
	for(var/file_name in entries)
		if(!include_placed && placed[file_name])
			continue
		if(is_usable(file_name))
			. += file_name

/// Whether an entry is already stored under a filename.
/datum/player_archive/proc/is_title_taken(file_name)
	// fexists also catches titles differing only in case on case-insensitive filesystems.
	return entries[file_name] || fexists(get_entry_path(file_name))

/datum/player_archive/proc/is_banned(key)
	var/banned_ckey = ckey(key)
	return banned_ckey && upload_bans[banned_ckey]

/datum/player_archive/proc/ban(key, admin_key)
	var/banned_ckey = ckey(key)
	if(!banned_ckey || upload_bans[banned_ckey])
		return FALSE
	var/list/new_bans = upload_bans.Copy()
	new_bans[banned_ckey] = list("admin" = "[admin_key]", "date" = time2text(world.realtime, "YYYY-MM-DD"))
	if(!write_player_archive_file(get_bans_path(), new_bans))
		return FALSE
	upload_bans = new_bans
	return TRUE

/datum/player_archive/proc/unban(key)
	var/banned_ckey = ckey(key)
	if(!banned_ckey || !upload_bans[banned_ckey])
		return FALSE
	var/list/new_bans = upload_bans.Copy()
	new_bans -= banned_ckey
	if(!write_player_archive_file(get_bans_path(), new_bans))
		return FALSE
	upload_bans = new_bans
	return TRUE

/// Checks whether user may add an entry with the given title, which everyone in contributor_ckeys worked on. Returns its filename, or null after telling the user why not.
/datum/player_archive/proc/check_upload(mob/user, title, list/contributor_ckeys)
	if(is_banned(user?.ckey))
		player_archive_feedback(user, "You have been barred from adding [kind] to the archive.")
		return
	for(var/contributor in contributor_ckeys)
		if(is_banned(contributor))
			player_archive_feedback(user, "Someone who worked on this [entry_noun] has been barred from adding [kind] to the archive.")
			return
	var/file_name = player_archive_filename(title)
	if(!file_name)
		player_archive_feedback(user, "That title cannot be archived. Use a shorter title that does not begin with an underscore.")
		return
	return file_name

/// Writes an entry under a filename, replacing any stored there. Returns TRUE on success.
/datum/player_archive/proc/save_entry(file_name, list/contents)
	if(!write_player_archive_file(get_entry_path(file_name), contents))
		return FALSE
	entries[file_name] = contents
	return TRUE

/// Saves an entry a player has uploaded, telling them and the admins how it went. Returns TRUE on success.
/datum/player_archive/proc/add_entry(file_name, list/contents, mob/user)
	if(!save_entry(file_name, contents))
		player_archive_feedback(user, "The archive could not store this [entry_noun].")
		return FALSE
	message_admins("[capitalize(entry_noun)] [get_display_title(file_name)] has been saved to the player [entry_noun] archive by [player_archive_display_text(contents["author_ckey"])]([player_archive_display_text(contents["author"])])")
	player_archive_feedback(user, "You have a feeling the [entry_noun] will remain in the archive for a very long time...", TRUE)
	return TRUE

/datum/player_archive/proc/delete_entry(file_name)
	if(!entries[file_name])
		return FALSE
	var/entry_path = get_entry_path(file_name)
	fdel(entry_path)
	if(fexists(entry_path))
		message_admins("Unable to delete archived [entry_noun] [entry_path].")
		return FALSE
	entries -= file_name
	return TRUE

/// Returns the usable entries as listed in the printing press archive UI.
/datum/player_archive/proc/get_ui_entries()
	. = list()
	for(var/file_name in get_usable_entries(include_placed = TRUE))
		UNTYPED_LIST_ADD(., get_ui_entry(file_name))

/datum/player_archive/proc/get_ui_entry(file_name)
	var/list/contents = entries[file_name]
	return list(
		"filename" = file_name,
		"title" = html_decode(contents[title_key]),
		"author" = html_decode(contents["author"] || "Unknown"),
		"date" = contents["ic_date"],
	)

/datum/player_archive/books
	kind = PLAYER_ARCHIVE_BOOKS
	entry_noun = "book"
	directory = "data/player_generated_books/"
	title_key = "book_title"

/datum/player_archive/books/load_entries()
	. = ..()
	// Books archived before categories existed, or under a category since removed, are filed under Misc.
	for(var/file_name in entries)
		var/list/book = entries[file_name]
		if(!(book["category"] in GLOB.player_book_categories))
			book["category"] = PLAYER_BOOK_DEFAULT_CATEGORY

/datum/player_archive/books/is_usable(file_name)
	return ..() && entries[file_name]["text"]

/datum/player_archive/books/get_ui_entry(file_name)
	. = ..()
	.["category"] = entries[file_name]["category"]

/datum/player_archive/paintings
	kind = PLAYER_ARCHIVE_PAINTINGS
	entry_noun = "painting"
	directory = "data/player_generated_paintings/"
	title_key = "painting_title"

/// Returns the path of the image for the painting stored under a filename.
/datum/player_archive/paintings/proc/get_image_path(file_name)
	return "[directory]paintings/[file_name].png"

/datum/player_archive/paintings/is_usable(file_name)
	return ..() && fexists(get_image_path(file_name))

/datum/player_archive/paintings/delete_entry(file_name)
	. = ..()
	if(.)
		fdel(get_image_path(file_name))
