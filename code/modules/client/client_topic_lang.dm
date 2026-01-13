/client/Topic(href, href_list)
	// Handle language info clicks from chat
	if(href_list["lang_name"]) 
		var/name = href_list["lang_name"]
		var/desc = href_list["lang_desc"]
		if(desc && length(desc))
			to_chat(mob, span_notice("[name]: [desc]"))
		else
			to_chat(mob, span_notice("[name]"))
		return
	..()
