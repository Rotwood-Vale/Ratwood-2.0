#define PRINTER_COOLDOWN (60 SECONDS)
#define PRINTING_TIME (25 SECONDS)
#define PRESS_ARCHIVE_BOOK "book"
#define PRESS_ARCHIVE_PAINTING "painting"

/obj/machinery/printingpress
	name = "printing press"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "Ppress_Clean"
	desc = "The Archivist's wonder. Gears, ink, and wood blocks can turn the written word to the printed word."
	density = TRUE
	var/printing = FALSE
	/// Blank paper for printing books, or a blank canvas for printing paintings.
	var/obj/item/loaded_medium
	var/obj/item/output_item
	/// Which archive each user has open in the archive UI, keyed by REF(user).
	var/list/archive_browsers = list()

	var/static/list/manual_name_to_path = list()
	COOLDOWN_DECLARE(print_cooldown)

/obj/machinery/printingpress/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(AM == loaded_medium)
		loaded_medium = null
	if(AM == output_item)
		output_item = null
	if(!QDELETED(src))
		update_icon()

/obj/machinery/printingpress/update_icon_state()
	. = ..()
	if(printing)
		icon_state = "Ppress_Printing"
	else if(output_item)
		icon_state = "Ppress_Done"
	else if(loaded_medium)
		icon_state = "Ppress_Prepared"
	else
		icon_state = "Ppress_Clean"

/obj/machinery/printingpress/examine(mob/user)
	. = ..()
	. += span_info("Insert blank paper or a blank canvas, then right-click to select what to print. Use an empty hand to retrieve the loaded material or a finished print. Apply a finished player book or signed canvas to archive it.")
	if(printing)
		. += span_info("It is currently printing.")
	else
		if(output_item)
			. += span_info("It has [output_item] ready. Use an empty hand to retrieve it.")
		else if(loaded_medium)
			. += span_info("It has a blank [loaded_medium.name] loaded.")
		else
			. += span_info("It is empty and has nothing loaded.")
		if(!COOLDOWN_FINISHED(src, print_cooldown))
			. += span_info("It is currently recalibrating and cannot print yet.")

/obj/machinery/printingpress/attackby(obj/item/O, mob/user, params)
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return
	if(output_item)
		to_chat(user, span_warning("Retrieve the printed item before inserting new items."))
		return
	if(istype(O, /obj/item/canvas))
		var/obj/item/canvas/M = O
		if(M.is_blank())
			load_medium(M, user)
			return
		if(M.archived)
			to_chat(user, span_warning("Only newly painted canvases can be added to the archive."))
			return
		if(!M.author || !M.title)
			to_chat(user, span_warning("This canvas isn't signed."))
			return
		var/choice = tgui_alert(user, "Do you want to add the painting to the archive?", "Confirm", list("Yes", "No"))
		if(choice == "Yes")
			if(QDELETED(M) || !user.canUseTopic(src, BE_CLOSE) || !user.Adjacent(M))
				return
			M.upload_painting(user)
		else
			to_chat(user, span_notice("You decide not to upload the painting."))
		return

	if(istype(O, /obj/item/manuscript))
		to_chat(user, span_warning("Finish this manuscript with a book crafting kit and give it a title before uploading it."))
		return

	if(istype(O, /obj/item/book/rogue/playerbook))
		var/obj/item/book/rogue/playerbook/PB = O
		if(!PB.written)
			to_chat(user, span_warning("This book has yet to be authored and titled. You'll need to do so before uploading it."))
			return
		// Copies printed or shelved from the archive must not restore books an admin has removed.
		if(!PB.is_in_round_player_generated)
			to_chat(user, span_warning("Only newly bound books can be added to the archive."))
			return
		var/choice = tgui_alert(user, "Do you want to add the book to the archive?", "Confirm", list("Yes", "No"))
		if(choice == "Yes")
			if(QDELETED(PB) || !user.canUseTopic(src, BE_CLOSE) || !user.Adjacent(PB))
				return
			if(SSlibrarian.playerbook2file(PB.player_book_text, PB.player_book_title, PB.player_book_author, PB.player_book_author_ckey, PB.player_book_icon, user, PB.player_book_date, PB.player_book_category))
				PB.is_in_round_player_generated = FALSE
		else
			to_chat(user, span_notice("You decide not to upload the book."))
		return
	if(O.type == /obj/item/paper)
		var/obj/item/paper/paper = O
		if(paper.info)
			to_chat(user, span_warning("The paper needs to be blank to be put into [src]."))
			return
		load_medium(paper, user)
		return
	return ..()

/obj/machinery/printingpress/proc/load_medium(obj/item/medium, mob/user)
	if(loaded_medium)
		to_chat(user, span_warning("It already has [loaded_medium] loaded."))
		return
	if(!user.transferItemToLoc(medium, src))
		to_chat(user, span_warning("You can't insert [medium] into [src]."))
		return
	loaded_medium = medium
	update_icon()
	to_chat(user, span_notice("You insert the blank [medium.name] into [src]."))

/obj/machinery/printingpress/attack_hand(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return
	if(output_item)
		// Exited() clears output_item once it leaves, so keep a local reference.
		var/obj/item/printed = output_item
		if(!user.put_in_hands(printed))
			printed.forceMove(get_turf(user))
		to_chat(user, span_notice("You retrieve [printed] from [src]."))
		return
	if(loaded_medium)
		var/obj/item/medium = loaded_medium
		if(!user.put_in_hands(medium))
			medium.forceMove(get_turf(user))
		to_chat(user, span_notice("You retrieve [medium] from [src]."))
		return
	to_chat(user, span_warning("[src] is empty."))

/obj/machinery/printingpress/attack_right(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return
	if(output_item)
		to_chat(user, span_warning("There is a finished product in [src]. Use an empty hand to retrieve it."))
		return
	var/choice = input(user, "Choose an option for \the [src]") as null|anything in list("Print The Verses and Acts of the Ten", "Print a Tome of Justice", "Print a book from the archive", "Print a painting from the archive", "Profession Manual")
	switch(choice)
		if("Print The Verses and Acts of the Ten")
			start_printing(user, /obj/item/book/rogue/bibble)
		if("Print a Tome of Justice")
			start_printing(user, /obj/item/book/rogue/law)
		if("Print a book from the archive")
			open_archive(user, PRESS_ARCHIVE_BOOK)
		if("Print a painting from the archive")
			open_archive(user, PRESS_ARCHIVE_PAINTING)
		if("Profession Manual")
			if(!length(manual_name_to_path))
				for(var/obj/item/recipe_book/book as anything in subtypesof(/obj/item/recipe_book))
					if(!initial(book.can_spawn))
						continue
					manual_name_to_path[initial(book.name)] = book
			choice = input(user, "Choose an option for \the [src]") as null|anything in manual_name_to_path
			if(choice)
				start_printing(user, manual_name_to_path[choice])

/// Returns the blank material needed to print the given type, or null if the type cannot be printed.
/obj/machinery/printingpress/proc/get_print_medium(print_type)
	if(print_type == PRESS_ARCHIVE_PAINTING)
		return /obj/item/canvas
	if(print_type == PRESS_ARCHIVE_BOOK || print_type == /obj/item/book/rogue/bibble || print_type == /obj/item/book/rogue/law || ispath(print_type, /obj/item/recipe_book))
		return /obj/item/paper

/// Returns TRUE if the press is ready to print the given type.
/obj/machinery/printingpress/proc/can_print(mob/user, print_type)
	if(!user || !user.canUseTopic(src, BE_CLOSE))
		return FALSE
	if(printing)
		to_chat(user, span_warning("[src] is currently printing. Please wait."))
		return FALSE
	if(output_item)
		to_chat(user, span_warning("Retrieve the finished print before printing another."))
		return FALSE
	var/medium_type = get_print_medium(print_type)
	if(!medium_type)
		to_chat(user, span_warning("That cannot be printed."))
		return FALSE
	if(!istype(loaded_medium, medium_type))
		to_chat(user, span_warning("[src] requires [medium_type == /obj/item/canvas ? "a blank canvas" : "a blank piece of paper"] to print that."))
		return FALSE
	if(!COOLDOWN_FINISHED(src, print_cooldown))
		to_chat(user, span_warning("[src] is still recalibrating."))
		return FALSE
	return TRUE

/// Returns TRUE if printing started.
/obj/machinery/printingpress/proc/start_printing(mob/user, print_type, id = null)
	if(!can_print(user, print_type))
		return FALSE
	// Load the archive entry before waiting, so deletion during printing cannot produce a damaged print.
	switch(print_type)
		if(PRESS_ARCHIVE_BOOK)
			var/list/book = SSlibrarian.file2playerbook(id)
			if(!book["book_title"] || !book["text"])
				to_chat(user, span_warning("This book is no longer in the archive."))
				return FALSE
			output_item = new /obj/item/book/rogue/playerbook(src, FALSE, null, null, id)
		if(PRESS_ARCHIVE_PAINTING)
			var/obj/item/canvas/print = new /obj/item/canvas(src)
			if(!print.load_archived_painting(id))
				qdel(print)
				to_chat(user, span_warning("This painting can no longer be printed."))
				return FALSE
			output_item = print
		else
			output_item = new print_type(src)
	output_item.desc = output_item.desc ? "[output_item.desc]<br>It is a printed copy." : "It is a printed copy."
	printing = TRUE
	to_chat(user, span_notice("[src] starts printing..."))
	playsound(src, 'sound/misc/ppress.ogg', 100, FALSE)
	qdel(loaded_medium)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(finish_printing)), PRINTING_TIME)
	return TRUE

/obj/machinery/printingpress/proc/finish_printing()
	printing = FALSE
	COOLDOWN_START(src, print_cooldown, PRINTER_COOLDOWN)
	update_icon()
	if(!output_item)
		return
	visible_message(span_notice("[src] hums as it produces [output_item]."))
	if(!istype(output_item, /obj/item/canvas))
		record_round_statistic(STATS_BOOKS_PRINTED)

/// Opens the archive UI listing the books or paintings that can be printed.
/obj/machinery/printingpress/proc/open_archive(mob/user, archive_type)
	if(!can_print(user, archive_type))
		return
	// Reopen rather than update, so switching archives resends the entries and window title.
	var/datum/tgui/existing_ui = SStgui.get_open_ui(user, src)
	existing_ui?.close()
	archive_browsers[REF(user)] = archive_type
	ui_interact(user)

/obj/machinery/printingpress/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PrintingPressArchive", "[archive_browsers[REF(user)] == PRESS_ARCHIVE_PAINTING ? "Painting" : "Book"] Archive")
		ui.open()

/obj/machinery/printingpress/ui_close(mob/user)
	. = ..()
	archive_browsers -= REF(user)

/obj/machinery/printingpress/ui_static_data(mob/user)
	var/list/data = ..()
	var/archive_type = archive_browsers[REF(user)]
	var/list/entries = list()
	if(archive_type == PRESS_ARCHIVE_PAINTING)
		for(var/file_name in SSpaintings.paintings)
			var/list/painting = SSpaintings.paintings[file_name]
			if(!painting["painting_title"] || !fexists(SSpaintings.get_painting_image_path(file_name)))
				continue
			UNTYPED_LIST_ADD(entries, list(
				"filename" = file_name,
				"title" = html_decode(painting["painting_title"]),
				"author" = html_decode(painting["author"] || "Unknown"),
				"date" = painting["ic_date"],
			))
	else
		for(var/file_name in SSlibrarian.player_books)
			var/list/book = SSlibrarian.player_books[file_name]
			if(!book["book_title"] || !book["text"])
				continue
			UNTYPED_LIST_ADD(entries, list(
				"filename" = file_name,
				"title" = html_decode(book["book_title"]),
				"author" = html_decode(book["author"] || "Unknown"),
				"category" = book["category"] || "Unknown",
				"date" = book["ic_date"],
			))
	data["archive_type"] = archive_type
	data["entries"] = entries
	return data

/obj/machinery/printingpress/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(action != "print")
		return
	if(start_printing(ui.user, archive_browsers[REF(ui.user)], params["filename"]))
		ui.close()
	return TRUE

#undef PRINTER_COOLDOWN
#undef PRINTING_TIME
#undef PRESS_ARCHIVE_BOOK
#undef PRESS_ARCHIVE_PAINTING
