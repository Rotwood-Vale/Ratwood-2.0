#define PLAYER_PAINTING_DIRECTORY "data/player_generated_paintings/"
#define PLAYER_PAINTING_IMAGE_DIRECTORY "data/player_generated_paintings/paintings/"

SUBSYSTEM_DEF(paintings)
	name = "Paintings"
	init_order = INIT_ORDER_PLAYER_ARCHIVES
	flags = SS_NO_FIRE

	/// Archived painting metadata, keyed by filename. Loaded once at init and kept in sync with the files on every change.
	var/list/paintings = list()
	/// Archived paintings already hung by mapped random paintings this round, so none is hung twice.
	var/list/placed_paintings = list()
	/// Mapped random paintings waiting to be hung once every one in their map load has initialized.
	var/list/pending_random_paintings = list()

/datum/controller/subsystem/paintings/Initialize(start_timeofday)
	paintings = load_player_archive(PLAYER_PAINTING_DIRECTORY)
	return ..()

/// Returns the path of the image for the archived painting stored under a filename.
/datum/controller/subsystem/paintings/proc/get_painting_image_path(filename)
	return "[PLAYER_PAINTING_IMAGE_DIRECTORY][filename].png"

/// Returns the archived painting metadata stored under a filename, or an empty list if there is none.
/datum/controller/subsystem/paintings/proc/file2playerpainting(filename)
	var/list/contents = paintings[filename]
	return contents ? contents : list()

/datum/controller/subsystem/paintings/proc/playerpainting2file(icon/painting, painting_title = "Unknown", author = "Unknown", author_ckey = "Unknown", canvas_size, obj/item/canvas/canvas, mob/user)
	if(!painting)
		player_archive_feedback(user, "There is no painting to archive!")
		return FALSE
	if(!(istext(painting_title) && istext(author) && istext(author_ckey)))
		player_archive_feedback(user, "This painting is incorrectly formatted!")
		return FALSE
	var/file_name = player_archive_filename(painting_title)
	if(!file_name)
		player_archive_feedback(user, "That title cannot be archived. Use a shorter title that does not begin with an underscore.")
		return FALSE

	var/json_path = "[PLAYER_PAINTING_DIRECTORY][file_name].json"
	var/list/existing = paintings[file_name]
	// fexists also catches titles differing only in case on case-insensitive filesystems.
	if(existing || fexists(json_path))
		if(existing?["author_ckey"] != author_ckey)
			player_archive_feedback(user, "There is already a painting by this title!")
			return FALSE
		if(canvas?.reject)
			player_archive_feedback(user, "The painter has refused to replace [painting_title].")
			return FALSE
		var/client/author_client = GLOB.directory[ckey(author_ckey)]
		if(!author_client)
			player_archive_feedback(user, "The painter must be present to replace their painting titled [painting_title].")
			return FALSE
		var/replace = tgui_alert(author_client, "Replace your archived painting '[html_decode(painting_title)]' with this new one?", "Replace Painting", list("Yes", "No"))
		if(replace != "Yes")
			if(canvas)
				canvas.reject = TRUE
			player_archive_feedback(user, "The painter has refused to replace [painting_title].")
			return FALSE
		// The painting may have been deleted or replaced while the alert was open.
		existing = paintings[file_name]
		if(existing && existing["author_ckey"] != author_ckey)
			player_archive_feedback(user, "There is already a painting by this title!")
			return FALSE

	var/image_path = get_painting_image_path(file_name)
	fdel(image_path)
	if(!fcopy(painting, image_path))
		player_archive_feedback(user, "The archive could not store this painting.")
		return FALSE
	var/list/contents = list("painting_title" = "[painting_title]", "author" = "[author]", "author_ckey" = "[author_ckey]", "canvas_size" = canvas_size, "ic_date" = get_ic_date_short_as_string())
	if(!write_player_archive_file(json_path, contents))
		player_archive_feedback(user, "The archive could not store this painting.")
		return FALSE
	paintings[file_name] = contents
	message_admins("Painting [player_archive_display_text(painting_title)] has been saved to the player painting database by [player_archive_display_text(author_ckey)]([player_archive_display_text(author)])")
	player_archive_feedback(user, "You have a feeling the painting will remain in the archive for a very long time...", TRUE)
	return TRUE

/// Reserves a random archived painting of the given size whose image exists and that has not been hung this round. Returns its filename, or null if there are none left.
/datum/controller/subsystem/paintings/proc/claim_random_painting(canvas_size)
	var/list/candidates = list()
	for(var/file_name in paintings)
		if(placed_paintings[file_name])
			continue
		var/list/painting_data = paintings[file_name]
		if(painting_data["painting_title"] && painting_data["canvas_size"] == canvas_size)
			candidates += file_name
	while(length(candidates))
		var/file_name = pick_n_take(candidates)
		if(fexists(get_painting_image_path(file_name)))
			placed_paintings[file_name] = TRUE
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

/datum/controller/subsystem/paintings/proc/del_player_painting(filename)
	if(!paintings[filename])
		return FALSE
	var/json_file = "[PLAYER_PAINTING_DIRECTORY][filename].json"
	fdel(json_file)
	if(fexists(json_file))
		message_admins("Unable to delete archived painting [json_file].")
		return FALSE
	fdel(get_painting_image_path(filename))
	paintings -= filename
	return TRUE

#undef PLAYER_PAINTING_DIRECTORY
#undef PLAYER_PAINTING_IMAGE_DIRECTORY
