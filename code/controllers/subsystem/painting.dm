SUBSYSTEM_DEF(paintings)
	name = "Paintings"
	init_order = INIT_ORDER_PLAYER_ARCHIVES
	flags = SS_NO_FIRE

	/// The archive of player paintings, kept across rounds.
	var/datum/player_archive/paintings/archive
	/// Mapped random paintings waiting to be hung once every one in their map load has initialized.
	var/list/pending_random_paintings = list()

/datum/controller/subsystem/paintings/Initialize(start_timeofday)
	archive = new
	return ..()

/// Adds a signed canvas to the archive, using an image of it rendered for the upload. Returns TRUE on success.
/datum/controller/subsystem/paintings/proc/playerpainting2file(obj/item/canvas/canvas, icon/painting, mob/user)
	if(!painting)
		player_archive_feedback(user, "There is no painting to archive!")
		return FALSE
	var/painting_title = canvas.title
	var/author_ckey = canvas.author_ckey
	var/file_name = archive.check_upload(user, painting_title, canvas.get_contributor_ckeys())
	if(!file_name)
		return FALSE

	var/list/existing = archive.entries[file_name]
	if(archive.is_title_taken(file_name))
		if(existing?["author_ckey"] != author_ckey)
			player_archive_feedback(user, "There is already a painting by this title!")
			return FALSE
		if(canvas.reject)
			player_archive_feedback(user, "The painter has refused to replace [painting_title].")
			return FALSE
		var/client/author_client = GLOB.directory[ckey(author_ckey)]
		if(!author_client)
			player_archive_feedback(user, "The painter must be present to replace their painting titled [painting_title].")
			return FALSE
		var/replace = tgui_alert(author_client, "Replace your archived painting '[html_decode(painting_title)]' with this new one?", "Replace Painting", list("Yes", "No"))
		if(replace != "Yes")
			canvas.reject = TRUE
			player_archive_feedback(user, "The painter has refused to replace [painting_title].")
			return FALSE
		// The painting may have been deleted or replaced while the alert was open.
		existing = archive.entries[file_name]
		if(existing && existing["author_ckey"] != author_ckey)
			player_archive_feedback(user, "There is already a painting by this title!")
			return FALSE

	var/image_path = archive.get_image_path(file_name)
	fdel(image_path)
	if(!fcopy(painting, image_path))
		player_archive_feedback(user, "The archive could not store this painting.")
		return FALSE
	var/list/contents = list(
		"painting_title" = "[painting_title]",
		"author" = "[canvas.author]",
		"author_ckey" = "[author_ckey]",
		"canvas_size" = canvas.canvas_size,
		"ic_date" = get_ic_date_short_as_string(),
	)
	return archive.add_entry(file_name, contents, user)

/// Reserves a random archived painting of the given size that has not been hung this round. Returns its filename, or null if there are none left.
/datum/controller/subsystem/paintings/proc/claim_random_painting(canvas_size)
	var/list/candidates = list()
	for(var/file_name in archive.get_usable_entries())
		if(archive.entries[file_name]["canvas_size"] == canvas_size)
			candidates += file_name
	if(!length(candidates))
		return
	var/file_name = pick(candidates)
	archive.placed[file_name] = TRUE
	return file_name

/// Hangs archived paintings on the pending mapped random paintings in a random order, so which spots stay empty differs each round. Deletes the spots left without a painting.
/datum/controller/subsystem/paintings/proc/hang_random_paintings()
	var/list/spots = shuffle(pending_random_paintings)
	pending_random_paintings = list()
	for(var/obj/item/canvas/random_painting/spot as anything in spots)
		if(QDELETED(spot))
			continue
		var/file_name = claim_random_painting(spot.canvas_size)
		if(!file_name || !spot.load_archived_painting(file_name))
			qdel(spot)
