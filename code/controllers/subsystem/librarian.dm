SUBSYSTEM_DEF(librarian)
	name = "Librarian"
	init_order = INIT_ORDER_PLAYER_ARCHIVES
	flags = SS_NO_FIRE
	var/list/books = list()
	/// The archive of player books, kept across rounds.
	var/datum/player_archive/books/archive
	/// Stocking callbacks of mapped random book spawners, run in a random order once every one in their map load has initialized.
	var/list/pending_random_books = list()

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

/datum/controller/subsystem/librarian/Initialize(start_timeofday)
	archive = new
	return ..()

/// Adds a newly bound player book to the archive. Returns TRUE on success.
/datum/controller/subsystem/librarian/proc/playerbook2file(obj/item/book/rogue/playerbook/book, mob/user)
	if(!book.player_book_text)
		player_archive_feedback(user, "There is no text in the book!")
		return FALSE
	var/file_name = archive.check_upload(user, book.player_book_title, book.get_contributor_ckeys())
	if(!file_name)
		return FALSE
	if(archive.is_title_taken(file_name))
		player_archive_feedback(user, "There is already a book by this title!")
		return FALSE
	var/category = book.player_book_category
	if(!(category in GLOB.player_book_categories))
		category = PLAYER_BOOK_DEFAULT_CATEGORY
	var/list/contents = list(
		"book_title" = "[book.player_book_title]",
		"author" = "[book.player_book_author]",
		"author_ckey" = "[book.player_book_author_ckey]",
		"icon" = "[book.player_book_icon]",
		"category" = "[category]",
		"text" = "[book.player_book_text]",
		"ic_date" = "[book.player_book_date || get_ic_date_short_as_string()]",
	)
	return archive.add_entry(file_name, contents, user)

/// Returns the filenames of usable archived books, limited to one category if given. Books already placed by a random book spawner this round are left out unless include_placed is set.
/datum/controller/subsystem/librarian/proc/pull_player_book_titles(category, include_placed = FALSE)
	. = list()
	for(var/file_name in archive.get_usable_entries(include_placed))
		if(!category || archive.entries[file_name]["category"] == category)
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
	var/list/contents = archive.entries[filename]
	if(!contents)
		return FALSE
	contents = contents.Copy()
	contents[amend_type] = amend_text
	var/new_file_name = filename
	if(amend_type == "book_title")
		new_file_name = player_archive_filename(amend_text)
		if(!new_file_name)
			return FALSE
		if(new_file_name != filename && archive.is_title_taken(new_file_name))
			return FALSE
	// Write the amended copy before removing the original so a failed save cannot lose the book.
	if(!archive.save_entry(new_file_name, contents))
		return FALSE
	if(new_file_name != filename)
		return archive.delete_entry(filename)
	return TRUE
