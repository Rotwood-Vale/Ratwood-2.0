/datum/preferences/proc/validate_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		if(entry)
			continue
		entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry

	for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(entry.descriptor_choice_type)
		if(!choice || entry.descriptor_type == null || !(entry.descriptor_type in choice.descriptors))
			if(choice && choice.default_descriptor)
				entry.descriptor_type = choice.default_descriptor
			else if(choice)
				entry.descriptor_type = pick(choice.descriptors)
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		if(length(custom_descriptors) >= i)
			continue
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[i]
		custom_entry.prefix_type = sanitize_integer(custom_entry.prefix_type, 1, CUSTOM_PREFIX_AMOUNT, CUSTOM_PREFIX_HAS_A)
		custom_entry.content_text = STRIP_HTML_SIMPLE(LOWER_TEXT(custom_entry.content_text), CUSTOM_DESCRIPTOR_TEXT_LENGTH)

/datum/preferences/proc/reset_descriptors()
	descriptor_entries = list()
	custom_descriptors = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry

/datum/preferences/proc/handle_descriptors_topic(mob/user, href_list)
	switch(href_list["preference"])
		if("choose_descriptor")
			var/choice_type = text2path(href_list["descriptor_choice"])
			if(!(choice_type in pref_species.descriptor_choices))
				return
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
			if(!choice)
				return
			var/list/picklist = list()
			for(var/desc_type in choice.descriptors)
				var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
				picklist[descriptor.name] = desc_type
			var/picked_descriptor_name = input(user, "Describe my [LOWER_TEXT(choice.name)]", "Describe myself") as null|anything in picklist

			if(!picked_descriptor_name)
				return
			var/picked_type = picklist[picked_descriptor_name]
			var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
			entry.descriptor_type = picked_type
		if("custom_descriptor_prefix")
			var/static/list/full_translation = CUSTOM_PREFIX_TRANSLATION_LIST
			var/static/list/full_input = CUSTOM_PREFIX_INPUT_LIST
			var/static/list/article_translation = CUSTOM_ARTICLE_TRANSLATION_LIST
			var/static/list/article_input = CUSTOM_ARTICLE_INPUT_LIST
			var/static/list/article_only_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY
			var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST

			var/index = text2num(href_list["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/is_article_only = (custom_descriptor_types[index] in article_only_types)
			var/list/translation = is_article_only ? article_translation : full_translation
			var/list/input_list = is_article_only ? article_input : full_input
			var/current_prefix_text = translation["[custom_entry.prefix_type]"]
			if(!current_prefix_text)
				current_prefix_text = is_article_only ? "a" : "Has a"
			var/new_prefix_text = input(user, "Choose the prefix", "Describe myself", current_prefix_text) as null|anything in input_list
			if(!new_prefix_text)
				return
			custom_entry.prefix_type = input_list[new_prefix_text]
		if("custom_descriptor_content")
			var/index = text2num(href_list["index"])
			var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
			var/new_content = input(user, "Describe the feature", "Describe myself") as text|null
			if(!new_content)
				return
			new_content = STRIP_HTML_SIMPLE(LOWER_TEXT(new_content), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
			custom_entry.content_text = new_content
		if("preview_descriptors")
			preview_descriptors(user)

/datum/preferences/proc/print_descriptors_page()
	var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST
	var/list/dat = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(entry.descriptor_type)
		dat += "<b>[choice.name]:</b> <a href='?_src_=prefs;descriptor_choice=[choice_type];preference=choose_descriptor;task=change_descriptor'>[descriptor.name]</a><br>"

	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		if(!has_descriptor_type_in_entries(custom_descriptor_types[i]))
			continue
		var/list/custom_data = print_custom_descriptor_customization(i)
		if(custom_data)
			dat += custom_data

	dat += "<br><br><center>Descriptors can vary based on gender<br>Some don't appear if you don't match a requirement<center>"
	dat += "<br><center><a href='?_src_=prefs;preference=preview_descriptors;task=change_descriptor'><b>Preview All Descriptors</b></a></center>"
	return dat

/datum/preferences/proc/print_custom_descriptor_customization(index)
	var/static/list/full_translation = CUSTOM_PREFIX_TRANSLATION_LIST
	var/static/list/article_translation = CUSTOM_ARTICLE_TRANSLATION_LIST
	var/static/list/custom_descriptor_types = CUSTOM_DESCRIPTOR_TYPE_LIST
	var/static/list/prefix_support = CUSTOM_DESCRIPTOR_SHOWS_PREFIX
	var/static/list/article_only_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY

	var/list/dat = list()
	var/datum/custom_descriptor_entry/custom_entry = custom_descriptors[index]
	var/desc_type = custom_descriptor_types[index]
	var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)

	var/prefix_html = ""
	if(desc_type in prefix_support)
		var/is_article_only = (desc_type in article_only_types)
		var/translation = is_article_only ? article_translation : full_translation
		prefix_html = "<a href='?_src_=prefs;index=[index];preference=custom_descriptor_prefix;task=change_descriptor'>[translation["[custom_entry.prefix_type]"]]</a>"

	dat += "<br><b>[descriptor.name]:</b> [prefix_html]<a href='?_src_=prefs;index=[index];preference=custom_descriptor_content;task=change_descriptor'>[custom_entry.content_text]</a>"
	return dat

/datum/preferences/proc/show_descriptors_ui(mob/user)
	var/list/dat = list()
	dat += print_descriptors_page()
	var/datum/browser/popup = new(user, "descriptors_customization", "<div align='center'>Describe myself</div>", 350, 510)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/has_descriptor_type_in_entries(descriptor_type)
	if(length(descriptor_entries))
		for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
			if(entry.descriptor_type != descriptor_type)
				continue
			return TRUE
	return FALSE

/datum/preferences/proc/preview_descriptors(mob/user)
	if(!COOLDOWN_FINISHED(src, descriptor_preview))
		to_chat(user, span_warning("You must wait before previewing descriptors again."))
		return
	COOLDOWN_START(src, descriptor_preview, 5 SECONDS)
	to_chat(user, span_notice("-- Preview of [real_name]'s descriptors --"))

	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	copy_to(mannequin, FALSE, TRUE, TRUE)
	apply_descriptors(mannequin)

	// Calculate speaking name
	to_chat(user, \
		"[SPAN_TOOLTIP("This will be displayed when you speak when your face is hidden or out of view range.", span_notice("Anonymous Speaking Name"))]: \
		<font color='[voice_color]'>[get_speaking_name_preview(mannequin)]</font>")

	// Calculate visible name
	var/list/descriptors = mannequin.get_mob_descriptors(FALSE, null)
	to_chat(user, \
		"[SPAN_TOOLTIP("This will be displayed when you emote or are examined when your face is hidden.", span_notice("Anonymous Visible Name"))]: \
		<font color='[voice_color]'>[get_visible_name_preview(mannequin, descriptors.Copy())]</font>")

	// Calculate descriptor blurb
	var/list/desc_lines = build_cool_description(descriptors, mannequin)
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

	// Output blurb
	to_chat(user, span_notice("<b>Details</b>"))
	for(var/line in desc_lines)
		to_chat(user, span_info(line))

// This should mirror /mob/living/carbon/human/get_alt_name()
/datum/preferences/proc/get_speaking_name_preview(mob/living/carbon/human/mannequin)
	var/datum/mob_descriptor/voice/voice_descriptor = mannequin.get_descriptor_type(/datum/mob_descriptor/voice)
	if(!voice_descriptor)
		return "Unknown Person"
	var/voice_gender = "Person"
	switch(voice_type)
		if(VOICE_TYPE_FEM)
			voice_gender = "Woman"
		if(VOICE_TYPE_MASC)
			voice_gender = "Man"
		if(VOICE_TYPE_ANDR)
			voice_gender = "Person"
	return voice_descriptor.get_speaking_name(voice_gender, src)

// This should mirror /mob/living/carbon/human/get_visible_name()
/datum/preferences/proc/get_visible_name_preview(mob/living/carbon/human/mannequin, list/descriptors)
	var/trait_desc = "[capitalize(build_coalesce_description_nofluff(descriptors, mannequin, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
	var/stature_desc = "[capitalize(build_coalesce_description_nofluff(descriptors, mannequin, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
	return "[trait_desc] [stature_desc]"

/datum/preferences/proc/get_descriptor_entry_for_choice(choice_type)
	if(length(descriptor_entries))
		for(var/datum/descriptor_entry/entry as anything in descriptor_entries)
			if(entry.descriptor_choice_type != choice_type)
				continue
			return entry
	return null

/datum/preferences/proc/apply_descriptors(mob/living/character)
	character.clear_mob_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		character.add_mob_descriptor(entry.descriptor_type)
	character.custom_descriptors = list()
	for(var/datum/custom_descriptor_entry/entry as anything in custom_descriptors)
		var/datum/custom_descriptor_entry/new_entry = new /datum/custom_descriptor_entry()
		new_entry.prefix_type = entry.prefix_type
		new_entry.content_text = entry.content_text
		character.custom_descriptors += new_entry
