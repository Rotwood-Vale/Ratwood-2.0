SUBSYSTEM_DEF(librarian)
	name = "Librarian"
	init_order = INIT_ORDER_PLAYER_ARCHIVES
	flags = SS_NO_FIRE
	var/list/books = list()
	/// Archived player books, keyed by filename. Loaded once at init and kept in sync with the files on every change.
	var/list/player_books = list()
	/// Archived books already placed by random book spawners this round, so none is placed twice.
	var/list/placed_player_books = list()
	/// Stocking callbacks of mapped random book spawners, run in a random order once every one in their map load has initialized.
	var/list/pending_random_books = list()
	/// Players barred from adding books to the archive.
	var/datum/player_archive_bans/upload_bans

/datum/controller/subsystem/librarian/proc/get_book(input)
	if(!input)
		return list()
	if(books.Find(input))
		return books[input]
	books[input] = file2book(input)
	return books[input]

/proc/file2book(filename)
	if(!filename)
		return list()
	var/json_file = file("strings/books/[filename]")
	testing("filebegin")
	if(fexists(json_file))
		testing("file1")
		var/list/configuration = json_decode(file2text(json_file))
		var/list/contents = configuration["Contents"]
		if(isnull(contents))
			testing("file2")
			return list()
		return contents
	testing("file4")
	return list()

#define PLAYER_BOOK_DIRECTORY "data/player_generated_books/"

/datum/controller/subsystem/librarian/Initialize(start_timeofday)
	player_books = load_player_archive(PLAYER_BOOK_DIRECTORY)
	upload_bans = new("books", "[PLAYER_BOOK_DIRECTORY]_upload_bans.json")
	return ..()

/datum/controller/subsystem/librarian/proc/playerbook2file(input, book_title = "Unknown", author = "Unknown", author_ckey = "Unknown", icon = "basic_book", mob/user, ic_date, category = "Unknown")
	if(!input)
		player_archive_feedback(user, "There is no text in the book!")
		return FALSE
	if(!ic_date)
		ic_date = get_ic_date_short_as_string()
	if(!(istext(input) && istext(book_title) && istext(author) && istext(author_ckey) && istext(icon) && istext(ic_date)))
		player_archive_feedback(user, "This book is incorrectly formatted!")
		return FALSE
	if(upload_bans.is_banned(user?.ckey))
		player_archive_feedback(user, "You have been barred from adding books to the archive.")
		return FALSE
	if(upload_bans.is_banned(author_ckey))
		player_archive_feedback(user, "The author of this book has been barred from adding books to the archive.")
		return FALSE
	if(!(category in GLOB.player_book_categories))
		category = "Unknown"
	var/file_name = player_archive_filename(book_title)
	if(!file_name)
		player_archive_feedback(user, "That title cannot be archived. Use a shorter title that does not begin with an underscore.")
		return FALSE
	// fexists also catches titles differing only in case on case-insensitive filesystems.
	if(player_books[file_name] || fexists("[PLAYER_BOOK_DIRECTORY][file_name].json"))
		player_archive_feedback(user, "There is already a book by this title!")
		return FALSE

	var/list/contents = list("book_title" = "[book_title]", "author" = "[author]", "author_ckey" = "[author_ckey]", "icon" = "[icon]", "category" = "[category]", "text" = "[input]", "ic_date" = "[ic_date]")
	if(!write_player_archive_file("[PLAYER_BOOK_DIRECTORY][file_name].json", contents))
		player_archive_feedback(user, "The archive could not store this book.")
		return FALSE
	player_books[file_name] = contents
	message_admins("Book [player_archive_display_text(book_title)] has been saved to the player book database by [player_archive_display_text(author_ckey)]([player_archive_display_text(author)])")
	player_archive_feedback(user, "You have a feeling the newly written book will remain in the archive for a very long time...", TRUE)
	return TRUE

/// Returns the archived book stored under a filename, or an empty list if there is none.
/datum/controller/subsystem/librarian/proc/file2playerbook(filename)
	var/list/contents = player_books[filename]
	return contents ? contents : list()

/datum/controller/subsystem/librarian/proc/del_player_book(filename)
	if(!player_books[filename])
		return FALSE
	var/json_file = "[PLAYER_BOOK_DIRECTORY][filename].json"
	fdel(json_file)
	if(fexists(json_file))
		message_admins("Unable to delete archived book [json_file].")
		return FALSE
	player_books -= filename
	return TRUE

/// Returns the filenames of readable archived books, limited to one category if given. Books already placed by a random book spawner this round are left out unless include_placed is set.
/datum/controller/subsystem/librarian/proc/pull_player_book_titles(category, include_placed = FALSE)
	. = list()
	for(var/file_name in player_books)
		if(!include_placed && placed_player_books[file_name])
			continue
		var/list/book = player_books[file_name]
		if(!book["book_title"] || !book["text"])
			continue
		if(!category || book["category"] == category)
			. += file_name

/// Stocks the pending random book spawners in a random order, so which shelves get the archived books differs each round.
/datum/controller/subsystem/librarian/proc/stock_random_books()
	var/list/stock_callbacks = shuffle(pending_random_books)
	pending_random_books = list()
	for(var/datum/callback/stock as anything in stock_callbacks)
		stock.Invoke()

/datum/controller/subsystem/librarian/proc/amend_player_book(filename, amend_type, amend_text)
	if(!istext(amend_text) || !length(trim(amend_text)) || !(amend_type in list("book_title", "author", "icon", "category")))
		return FALSE
	if(amend_type == "category" && !(amend_text in GLOB.player_book_categories))
		return FALSE
	var/list/contents = player_books[filename]
	if(!contents)
		return FALSE
	contents = contents.Copy()
	contents[amend_type] = amend_text
	var/new_file_name = filename
	if(amend_type == "book_title")
		new_file_name = player_archive_filename(amend_text)
		if(!new_file_name)
			return FALSE
		if(new_file_name != filename && (player_books[new_file_name] || fexists("[PLAYER_BOOK_DIRECTORY][new_file_name].json")))
			return FALSE
	// Write the amended copy before removing the original so a failed save cannot lose the book.
	if(!write_player_archive_file("[PLAYER_BOOK_DIRECTORY][new_file_name].json", contents))
		return FALSE
	player_books[new_file_name] = contents
	if(new_file_name != filename)
		return del_player_book(filename)
	return TRUE

#undef PLAYER_BOOK_DIRECTORY
