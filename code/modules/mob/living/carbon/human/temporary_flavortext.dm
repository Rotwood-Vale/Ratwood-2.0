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

/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(href_list["task"] == "show_temp_ft")
		var/output = "<span class='info' style='color: #eaeaea'>[temporary_flavortext]</span>"
		if(!usr.client.prefs.no_examine_blocks)
			output = examine_block(output)
		to_chat(usr, output)
