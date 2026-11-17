/mob/living/carbon/human
	var/temporary_flavortext = null

/mob/living/carbon/human/verb/temp_flavor()
	set name = "Set temporary flavortext"
	set category = "IC"

	var/new_temp_flavortext = input(usr, "Choose a new flavortext (Empty will remove any active ones)", "Temporary flavortext") as null|text
	if(isnull(new_temp_flavortext))
		return
	if(new_temp_flavortext == "")
		temporary_flavortext = null
		return
	else
		temporary_flavortext = new_temp_flavortext

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
		while(open_colours-- > 0)
			text += "=-"
	for(var/double in list("**", "__"))
		if((length(splittext(text, double)) - 1) % 2)
			text += double
	var/open_small = (length(splittext(text, "((")) - 1) - (length(splittext(text, "))")) - 1)
	while(open_small-- > 0)
		text += "))"
	return parsemarkdown_basic(text)

/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(href_list["task"] == "show_temp_ft")
		var/output = "<span class='info' style='color: #eaeaea'>[format_temporary_flavortext(temporary_flavortext)]</span>"
		if(!usr.client.prefs.no_examine_blocks)
			output = examine_block(output)
		to_chat(usr, output)
