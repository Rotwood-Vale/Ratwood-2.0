/client/proc/list_severed_heads()
	set name = "List Severed Heads"
	set category = "-Admin-"
	set desc = "Show every loose severed player head, who is inside it and where it is."
	if(!check_rights(R_ADMIN))
		return
	var/dat = "<B>Showing severed player heads.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Character</th><th>Key</th><th>Occupant</th><th>Where</th></tr>"
	var/found = 0
	for(var/datum/mind/M in SSticker.minds)
		var/obj/item/bodypart/head/severed = M.severed_head_ref?.resolve()
		if(!severed)
			continue
		if(!severed.loc) //an attached head sits in nullspace, so this one is not loose
			continue
		found++
		var/turf/head_turf = get_turf(severed) //ADMIN_VERBOSEJMP expands into src.x, so it needs a var not a proc call
		var/list/nesting = list()
		for(var/atom/container as anything in get_nested_locs(severed))
			nesting += "[container]"
		var/where = length(nesting) ? "inside [jointext(nesting, " inside ")]" : "on the ground"
		var/occupant = "EMPTY"
		if(severed.brainmob)
			occupant = severed.brainmob.key ? "[severed.brainmob.key]" : "SSD/ghosted"
		else if(severed.brain)
			occupant = "brain, no mind"
		if(severed.brainkill)
			occupant += " (BRAINKILLED)"
		dat += "<tr><td>[M.name] [ADMIN_VV(severed)]</td><td>[M.key ? M.key : "no key"]</td><td>[occupant]</td><td>[where], [ADMIN_VERBOSEJMP(head_turf)]</td></tr>"
	if(!found)
		dat += "<tr><td colspan=4>No severed player heads.</td></tr>"
	dat += "</table>"
	usr << browse(dat, "window=severed_heads;size=700x500")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "List Severed Heads")
