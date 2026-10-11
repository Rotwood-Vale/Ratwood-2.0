/obj/item/book/manual/random
	icon_state = "random_book"

/obj/item/book/manual/random/Initialize(mapload)
	..()
	return INITIALIZE_HINT_QDEL

/obj/item/book/random
	icon_state = "random_book"
	var/amount = 1
	var/category = null

/obj/item/book/random/Initialize(mapload)
	..()
	SSlibrarian.pending_random_books += CALLBACK(src, PROC_REF(stock_books))
	return INITIALIZE_HINT_LATELOAD

/obj/item/book/random/LateInitialize()
	SSlibrarian.stock_random_books()

/obj/item/book/random/proc/stock_books()
	if(!QDELETED(src))
		create_random_books_rogue(amount, loc, category)
	qdel(src)

/obj/item/book/random/triple
	amount = 3

/obj/structure/bookcase/random
	var/category = null
	var/book_count = 10
	icon_state = "bookcase"
	anchored = TRUE
	state = 2

/obj/structure/bookcase/random/Initialize(mapload)
	. = ..()
	if(category)
		name = "bookcase ([category])"
	if(book_count && isnum(book_count))
		book_count += pick(-5,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-2,-2,-1,-1,0,)
		SSlibrarian.pending_random_books += CALLBACK(src, PROC_REF(stock_books))
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/bookcase/random/LateInitialize()
	SSlibrarian.stock_random_books()

/obj/structure/bookcase/random/proc/stock_books()
	if(QDELETED(src))
		return
	create_random_books_rogue(min(book_count, max_books - length(contents)), src, category)
	update_icon()

/obj/structure/bookcase/random/archive
	book_count = 10

/obj/structure/bookcase/random/archive/Initialize(mapload)
	. = ..()
	if(book_count && isnum(book_count))
		book_count += pick(0,1,2,3,4,5,6,7,8,9,10)

/obj/structure/bookcase/random/archive/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/book/rogue/playerbook))
		var/obj/item/book/rogue/playerbook/PB = I
		if(PB.is_in_round_player_generated)
			if(!PB.written)
				to_chat(user, span_warning("Finish authoring this book before archiving it."))
				return
			if(SSlibrarian.playerbook2file(PB.player_book_text, PB.player_book_title, PB.player_book_author, PB.player_book_author_ckey, PB.player_book_icon, user, PB.player_book_date, PB.player_book_category))
				PB.is_in_round_player_generated = FALSE

	. = ..()

/// Spawns random books, with archived player books limited to the given category if one is set. Each archived book is placed at most once per round.
/proc/create_random_books_rogue(amount = 2, location, category)
	var/list/possible_books = subtypesof(/obj/item/book/rogue/) - typesof(/obj/item/book/rogue/playerbook)
	var/list/unused_player_titles = SSlibrarian.pull_player_book_titles(category)
	var/player_book_chance = clamp(length(unused_player_titles), 10, 90)
	for(var/b in 1 to amount)
		if(prob(0.1))
			new /obj/item/book_crafting_kit(location)
			continue
		var/placed_player_book = FALSE
		if(length(unused_player_titles) && prob(player_book_chance))
			while(length(unused_player_titles))
				var/file_name = pick_n_take(unused_player_titles)
				var/obj/item/book/rogue/playerbook/player_book = new(location, FALSE, null, null, file_name)
				if(player_book.written)
					SSlibrarian.placed_player_books[file_name] = TRUE
					placed_player_book = TRUE
					break
				qdel(player_book)
		if(!placed_player_book)
			var/obj/item/book/rogue/addition = pick(possible_books)
			var/obj/item/book/rogue/newbook = new addition(location)
			if(istype(newbook, /obj/item/book/rogue/secret))
				qdel(newbook)
				continue
			if(istype(newbook, /obj/item/book/rogue/bibble))
				qdel(newbook)
				continue


/obj/structure/bookcase/random/fiction
	category = "Fiction"
/obj/structure/bookcase/random/nonfiction
	category = "Non-fiction"
/obj/structure/bookcase/random/religion
	category = "Religion"
/obj/structure/bookcase/random/adult
	category = "Adult"

/obj/structure/bookcase/random/reference
	category = "Reference"
	var/ref_book_prob = 20

/// Bookcase filled only with a random selection of archived player books. These do not count as placed, so the same books can still turn up in other bookcases.
/obj/structure/bookcase/player_archive
	name = "bookcase (Archive)"
	icon_state = "bookcase"
	anchored = TRUE
	state = 2
	var/book_count = 15

/obj/structure/bookcase/player_archive/Initialize(mapload)
	. = ..()
	var/list/unused_player_titles = assoc_list_strip_value(SSlibrarian.player_books)
	var/books_to_place = min(book_count, max_books - length(contents))
	var/placed_books = 0
	while(placed_books < books_to_place && length(unused_player_titles))
		var/obj/item/book/rogue/playerbook/player_book = new(src, FALSE, null, null, pick_n_take(unused_player_titles))
		if(player_book.written)
			placed_books++
		else
			qdel(player_book)
	update_icon()

/obj/structure/bookcase/random_recipes
	name = "bookcase (Recipes)"

/obj/structure/bookcase/random_recipes/Initialize(mapload)
	. = ..()
	var/list/books = subtypesof(/obj/item/recipe_book)
	for(var/obj/item/recipe_book/listed_book as anything in books)
		if(initial(listed_book.can_spawn))
			continue
		books -= listed_book

	for(var/i = 1 to min(books.len, max_books - length(contents))) // Spawn one copy of every book
		var/obj/item/recipe_book/book = pick_n_take(books)
		new book(src)
	update_icon()
