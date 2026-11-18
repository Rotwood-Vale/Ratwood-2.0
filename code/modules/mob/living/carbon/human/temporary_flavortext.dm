/mob/living/carbon/human
	var/temporary_flavortext = null
	var/temporary_flavortext_cache_source = null
	var/temporary_flavortext_formatted = null
	/// The formatted cut preview examine shows, null when the text fits whole
	var/temporary_flavortext_preview = null

/mob/living/carbon/human/verb/temp_flavor()
	set name = "Set temporary flavortext"
	set category = "IC"

	var/new_temp_flavortext = input(usr, "Choose a new flavortext (Empty will remove any active ones)", "Temporary flavortext") as null|text
	if(isnull(new_temp_flavortext))
		return
	if(new_temp_flavortext == "")
		temporary_flavortext = null
	else
		temporary_flavortext = copytext_char(new_temp_flavortext, 1, MAX_MESSAGE_LEN + 1)
	update_temporary_flavortext_cache()

/// Rebuilds the formatted text when temporary_flavortext differs from the raw text it was built from, so a VV edit is picked up too
/mob/living/carbon/human/proc/update_temporary_flavortext_cache()
	if(temporary_flavortext == temporary_flavortext_cache_source)
		return
	temporary_flavortext_cache_source = temporary_flavortext
	temporary_flavortext_formatted = null
	temporary_flavortext_preview = null
	if(!temporary_flavortext)
		return
	temporary_flavortext_formatted = format_temporary_flavortext(temporary_flavortext)
	var/max_temp_ft_length = 100 //Proably a good idea to fine-tune this later
	if(length_char(temporary_flavortext) > max_temp_ft_length)
		temporary_flavortext_preview = format_temporary_flavortext(copytext_char(temporary_flavortext, 1, max_temp_ft_length + 1), cut = TRUE)

/**
 * Encodes the text and applies the same markdown as flavor text, without web links
 *
 * A lone ** or __ becomes an italic tag the markdown never closes, and a lone (( a small font tag, so either
 * would restyle the rest of the examine. Those are always closed. With cut set, the single markers and colour
 * codes the 100 character preview cut off are closed too, single markers counted with their doubles taken out
 */
/proc/format_temporary_flavortext(text, cut = FALSE)
	text = html_encode(text)
	if(cut)
		for(var/marker in list("*", "_", "^", "|"))
			var/singles = length(splittext(text, marker)) - 1
			if(marker == "*" || marker == "_")
				singles -= 2 * (length(splittext(text, marker + marker)) - 1)
			if(singles % 2)
				text += marker
		var/open_colours = (length(splittext(text, "-=")) - 1) - (length(splittext(text, "=-")) - 1)
		var/list/colour_closers = list()
		for(var/i in 1 to open_colours)
			colour_closers += "=-"
		text += jointext(colour_closers, "")
	for(var/double in list("**", "__"))
		if((length(splittext(text, double)) - 1) % 2)
			text += double
	var/open_small = (length(splittext(text, "((")) - 1) - (length(splittext(text, "))")) - 1)
	var/list/small_closers = list()
	for(var/i in 1 to open_small)
		small_closers += "))"
	text += jointext(small_closers, "")
	return parsemarkdown_basic(text)

/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(href_list["task"] == "show_temp_ft")
		update_temporary_flavortext_cache()
		var/output = "<span class='info' style='color: #eaeaea'>[temporary_flavortext_formatted]</span>"
		if(!usr.client.prefs.no_examine_blocks)
			output = examine_block(output)
		to_chat(usr, output)
