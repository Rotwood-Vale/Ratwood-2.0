// ES-native replacement for AP's open_economy_guidebook(), which used AP's
// /datum/recipe_wiki multi-pane wiki UI (get_recipe_wiki(), wiki.show_to_user()) - a whole
// system that doesn't exist in ES. This version follows ES's existing book_entry pattern
// instead: /datum/book_entry/show_menu(user) just browse()s a single generated page
// (code/modules/crafting/recipe_books/book_entries/book_entry_base.dm), so the guidebook
// either opens one chapter directly, or falls back to an input() picker over every chapter.
//
// Call sites (unchanged, all pre-existing before this port step):
//  - code/modules/roguetown/roguemachine/merchant/_goldface.dm ("help" ui_act) passes the
//    ABSTRACT parent /datum/book_entry/treasury_merchant - falls through to the picker,
//    pre-sorted so Merchant-category chapters are listed first.
//  - code/modules/roguetown/roguemachine/merchant/trade/fulfillment_crate.dm ("help" ui_act)
//    passes the concrete leaf /datum/book_entry/treasury_merchant/fulfillment_crate - opens
//    directly.
//  - code/modules/roguetown/roguemachine/noticeboard/noticeboard.dm ("help_market" ui_act)
//    passes the concrete leaf /datum/book_entry/treasury_merchant/avisa_market - opens directly.

/// Returns the flat list of concrete (non-abstract) treasury guidebook chapter typepaths,
/// across all four categories (Common, Merchant, Steward, Underground). Cached after first
/// build since the guidebook's chapter roster is fixed at compile time.
/proc/get_economy_guidebook_entries()
	var/static/list/entries
	if(entries)
		return entries
	entries = list()
	var/list/abstract_roots = list(
		/datum/book_entry/treasury_general,
		/datum/book_entry/treasury_merchant,
		/datum/book_entry/treasury_realm,
		/datum/book_entry/treasury_underground,
	)
	var/list/all_types = list()
	for(var/root in abstract_roots)
		all_types += typesof(root)
	for(var/T in all_types)
		if(T in abstract_roots)
			continue
		entries += T
	return entries

/proc/open_economy_guidebook(mob/user, category, entry_type)
	if(!user)
		return
	var/list/entries = get_economy_guidebook_entries()

	// Concrete leaf typepaths open directly - no picker needed.
	if(entry_type && (entry_type in entries))
		var/datum/book_entry/B = new entry_type()
		B.show_menu(user)
		return

	// Anything else (null, an abstract parent, or an unrecognized type) falls back to a
	// picker over every chapter, with the requested category's chapters listed first.
	var/list/matching_labels = list()
	var/list/other_labels = list()
	var/list/label_to_type = list()
	for(var/T in entries)
		var/datum/book_entry/probe = T
		var/nm = initial(probe.name)
		var/cat = initial(probe.category)
		var/label = "\[[cat]\] [nm]"
		label_to_type[label] = T
		if(category && cat == category)
			matching_labels += label
		else
			other_labels += label
	sortList(matching_labels)
	sortList(other_labels)
	var/list/options = matching_labels + other_labels
	if(!length(options))
		return

	var/picked = input(user, "Which chapter would I like to read?", "The Comprehensive Guide to the Azurian Economy") as null|anything in options
	if(!picked)
		return
	var/picked_type = label_to_type[picked]
	if(!picked_type)
		return
	var/datum/book_entry/B = new picked_type()
	B.show_menu(user)
