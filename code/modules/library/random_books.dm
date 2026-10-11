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
	return INITIALIZE_HINT_LATELOAD

/obj/item/book/random/LateInitialize()
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
	if(book_count && isnum(book_count))
		book_count += pick(-5,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-2,-2,-1,-1,0,)
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/bookcase/random/LateInitialize()
	create_random_books_rogue(book_count, src, category)
	update_icon()

/obj/structure/bookcase/random/archive
	book_count = 10

/obj/structure/bookcase/random/archive/Initialize(mapload)
	. = ..()
	if(book_count && isnum(book_count))
		book_count += pick(0,1,2,3,4,5,6,7,8,9,10)
		. = INITIALIZE_HINT_LATELOAD

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

/// Spawns random books, with archived player books limited to the given category if one is set.
/proc/create_random_books_rogue(amount = 2, location, category)
	var/list/possible_books = subtypesof(/obj/item/book/rogue/) - typesof(/obj/item/book/rogue/playerbook)
	// Each archived book can only be placed once per shelf.
	var/list/unused_player_titles = SSlibrarian.pull_player_book_titles(category)
	var/player_book_chance = clamp(length(unused_player_titles), 10, 90)
	for(var/b in 1 to amount)
		if(prob(0.1))
			new /obj/item/book_crafting_kit(location)
		var/placed_player_book = FALSE
		if(length(unused_player_titles) && prob(player_book_chance))
			while(length(unused_player_titles))
				var/obj/item/book/rogue/playerbook/player_book = new(location, FALSE, null, null, pick_n_take(unused_player_titles))
				if(player_book.written)
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
	name = "bookcase (Fiction)"
	category = "Fiction"
/obj/structure/bookcase/random/nonfiction
	name = "bookcase (Non-Fiction)"
	category = "Non-fiction"
/obj/structure/bookcase/random/religion
	name = "bookcase (Religion)"
	category = "Religion"
/obj/structure/bookcase/random/adult
	name = "bookcase (Adult)"
	category = "Adult"

/obj/structure/bookcase/random/reference
	name = "bookcase (Reference)"
	category = "Reference"
	var/ref_book_prob = 20

/obj/structure/bookcase/random_recipes
	name = "bookcase (Recipes)"

/obj/structure/bookcase/random_recipes/Initialize(mapload)
	. = ..()
	var/list/books = subtypesof(/obj/item/recipe_book)
	for(var/obj/item/recipe_book/listed_book as anything in books)
		if(initial(listed_book.can_spawn))
			continue
		books -= listed_book

	for(var/i = 1 to books.len) // Spawn one copy of every book
		var/obj/item/recipe_book/book = pick_n_take(books)
		new book(src)
	update_icon()
