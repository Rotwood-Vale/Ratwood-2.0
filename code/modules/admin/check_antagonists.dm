//I wish we had interfaces sigh, and i'm not sure giving team and antag common root is a better solution here

//Name shown on antag list
/datum/antagonist/proc/antag_listing_name()
	if(!owner)
		return "Unassigned"
	if(owner.current)
		return "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(owner.current)]'>[owner.current.real_name]</a> "
	else
		return "<a href='?_src_=vars;[HrefToken()];Vars=[REF(owner)]'>[owner.name]</a> "

//Whatever interesting things happened to the antag admins should know about
//Include additional information about antag in this part
/datum/antagonist/proc/antag_listing_status()
	if(!owner)
		return "(Unassigned)"
	if(!owner.current)
		return "<font color=red>(Body destroyed)</font>"
	else
		if(owner.current.stat == DEAD)
			return "<font color=red>(DEAD)</font>"
		else if(!owner.current.client)
			return "(No client)"

//Builds the common FLW PM TP commands part
//Probably not going to be overwritten by anything but you never know
/datum/antagonist/proc/antag_listing_commands()
	if(!owner)
		return
	var/list/parts = list()
	parts += "<a href='?priv_msg=[ckey(owner.key)]'>PM</a>"
	if(owner.current) //There's body to follow
		parts += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(owner.current)]'>FLW</a>"
	else
		parts += ""
	parts += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(owner)]'>Show Objective</a>"
	return parts //Better as one cell or two/three

//Builds table row for the antag
// Jim (Status) FLW PM TP
/datum/antagonist/proc/antag_listing_entry()
	var/list/parts = list()
	if(show_name_in_check_antagonists)
		parts += "[antag_listing_name()]([name])"
	else
		parts += antag_listing_name()
	parts += antag_listing_status()
	parts += antag_listing_commands()
	return "<tr><td>[parts.Join("</td><td>")]</td></tr>"


/datum/team/proc/get_team_antags(antag_type,specific = FALSE)
	. = list()
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(A.get_team() == src && (!antag_type || !specific && istype(A,antag_type) || specific && A.type == antag_type))
			. += A

//Builds section for the team
/datum/team/proc/antag_listing_entry()
	//NukeOps:
	// Jim (Status) FLW PM TP
	// Joe (Status) FLW PM TP
	//Disk:
	// Deep Space FLW
	var/list/parts = list()
	parts += "<b>[antag_listing_name()]</b><br>"
	parts += "<table cellspacing=5>"
	for(var/datum/antagonist/A in get_team_antags())
		parts += A.antag_listing_entry()
	parts += "</table>"
	parts += antag_listing_footer()
	return parts.Join()

/datum/team/proc/antag_listing_name()
	return name

/datum/team/proc/antag_listing_footer()
	return

//Moves them to the top of the list if TRUE
/datum/antagonist/proc/is_gamemode_hero()
	return FALSE

/datum/team/proc/is_gamemode_hero()
	return FALSE

/datum/admins/proc/build_antag_listing()
	var/list/sections = list()
	var/list/priority_sections = list()

	var/list/all_teams = list()
	var/list/all_antagonists = list()

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		all_teams |= A.get_team()
		all_antagonists += A

	for(var/datum/team/T in all_teams)
		for(var/datum/antagonist/X in all_antagonists)
			if(X.get_team() == T)
				all_antagonists -= X
		if(T.is_gamemode_hero())
			priority_sections += T.antag_listing_entry()
		else
			sections += T.antag_listing_entry()

	sortTim(all_antagonists, GLOBAL_PROC_REF(cmp_antag_category))

	var/current_category
	var/list/current_section = list()
	for(var/i in 1 to all_antagonists.len)
		var/datum/antagonist/current_antag = all_antagonists[i]
		var/datum/antagonist/next_antag
		if(i < all_antagonists.len)
			next_antag = all_antagonists[i+1]
		if(!current_category)
			current_category = current_antag.roundend_category
			current_section += "<b>[capitalize(current_category)]</b><br>"
			current_section += "<table cellspacing=5>"
		current_section += current_antag.antag_listing_entry() // Name - (Traitor) - FLW | PM | TP

		if(!next_antag || next_antag.roundend_category != current_antag.roundend_category) //End of section
			current_section += "</table>"
			if(current_antag.is_gamemode_hero())
				priority_sections += current_section.Join()
			else
				sections += current_section.Join()
			current_section.Cut()
			current_category = null
	var/list/all_sections = priority_sections + sections
	return all_sections.Join("<br>")

/datum/admins/proc/check_antagonists()
	if(!SSticker.HasRoundStarted())
		alert("The game hasn't started yet!")
		return
	var/list/dat = list("<html><head><title>Round Status</title></head><body><h1><B>Round Status</B></h1>")
	dat += "<a href='?_src_=holder;[HrefToken()];gamemode_panel=1'>Gamemode Panel</a><br>"
	dat += "Round Duration: <B>[DisplayTimeText(world.time - SSticker.round_start_time)]</B><BR>"
	dat += "<BR>"
	dat += "<a href='?_src_=holder;[HrefToken()];end_round=[REF(usr)]'>End Round Now</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];delay_round_end=1'>[SSticker.delay_end ? "End Round Normally" : "Delay Round End"]</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];ctf_toggle=1'>Enable/Disable CTF</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];rebootworld=1'>Reboot World</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];check_teams=1'>Check Teams</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];check_hunted_targets=1'>Gnoll Information</a><br>"
	dat += "<a href='?_src_=holder;[HrefToken()];check_hag_information=1'>Hag Information</a>"
	var/connected_players = GLOB.clients.len
	var/lobby_players = 0
	var/observers = 0
	var/observers_connected = 0
	var/living_players = 0
	var/living_players_connected = 0
	var/living_players_antagonist = 0
	var/brains = 0
	var/other_players = 0
	// var/living_skipped = 0
	// var/drones = 0
	for(var/mob/M in GLOB.mob_list)
		if(M.ckey)
			if(isnewplayer(M))
				lobby_players++
				continue
			else if(M.stat != DEAD && M.mind && !isbrain(M))
				// if(is_centcom_level(M.z))
				// 	living_skipped++
				// 	continue
				living_players++
				if(M.mind.special_role)
					living_players_antagonist++
				if(M.client)
					living_players_connected++
			else if(M.stat == DEAD || isobserver(M))
				observers++
				if(M.client)
					observers_connected++
			else if(isbrain(M))
				brains++
			else
				other_players++
	dat += "<BR><b><font color='blue' size='3'>Players:|[connected_players - lobby_players] ingame|[connected_players] connected|[lobby_players] lobby|</font></b>"
	dat += "<BR><b><font color='green'>Living Players:|[living_players_connected] active|[living_players - living_players_connected] disconnected|[living_players_antagonist] antagonists|</font></b>"
	// dat += "<BR><b><font color='#bf42f4'>SKIPPED \[On centcom Z-level\]: [living_skipped] living players|[drones] living drones|</font></b>"
	dat += "<BR><b><font color='red'>Dead/Observing players:|[observers_connected] active|[observers - observers_connected] disconnected|[brains] brains|</font></b>"
	if(other_players)
		dat += "<BR><span class='danger'>[other_players] players in invalid state or the statistics code is bugged!</span>"
	dat += "<br><br>"

	dat += build_antag_listing()

	dat += "</body></html>"
	usr << browse(dat.Join(), "window=roundstatus;size=500x500")

/datum/admins/proc/check_hunted_targets()
	if(!SSticker.HasRoundStarted())
		alert("The game hasn't started yet!")
		return

	var/list/combat_roles = get_gnoll_tracking_combat_roles()
	var/list/hunted_targets = list()
	var/list/combat_targets = list()
	var/list/direct_scent_targets = list()
	var/list/tracking_gnolls_by_target_ref = list()

	for(var/mob/living/L in GLOB.player_list)
		if(!L || QDELETED(L) || L.stat == DEAD)
			continue
		if(istype(L, /mob/living/carbon/human/dummy) || !L.mind)
			continue

		if(L.has_flaw(/datum/charflaw/hunted))
			hunted_targets += L
		else if(L.job in combat_roles)
			combat_targets += L

	for(var/datum/antagonist/gnoll/G in GLOB.antagonists)
		var/mob/living/gnoll_mob = G.owner?.current
		if(!gnoll_mob || QDELETED(gnoll_mob))
			continue
		var/mob/living/tracked_target = G.get_tracked_target()
		if(!tracked_target)
			continue
		if(!(tracked_target in hunted_targets) && !(tracked_target in combat_targets) && !(tracked_target in direct_scent_targets))
			direct_scent_targets += tracked_target

		var/target_ref = "\ref[tracked_target]"
		if(!tracking_gnolls_by_target_ref[target_ref])
			tracking_gnolls_by_target_ref[target_ref] = list()

		var/list/tracking_gnolls = tracking_gnolls_by_target_ref[target_ref]
		if(!(gnoll_mob in tracking_gnolls))
			tracking_gnolls += gnoll_mob

	var/list/active_targets = length(hunted_targets) ? hunted_targets : combat_targets
	var/list/display_targets = active_targets.Copy()
	if(length(direct_scent_targets))
		for(var/mob/living/direct_target in direct_scent_targets)
			if(!(direct_target in display_targets))
				display_targets += direct_target
	var/active_source = length(hunted_targets) ? "Hunted flaw" : "Combat fallback"
	var/selection_mode_description = "Follows gnoll tracking rules: hunted targets are preferred globally, combat roles are only used when no hunted targets are valid."
	if(length(direct_scent_targets))
		selection_mode_description += " Active direct-scent targets already being tracked by gnolls are also shown below."
	var/gnoll_mode_name = "Unavailable"
	var/gnoll_mode_id = null
	var/has_pop_growth_scaling = FALSE
	var/auto_scaling_status = "Unavailable"
	var/slot_open_display = "Unavailable"
	var/gnoll_spawn_status = "Enabled"
	var/pop_remaining_display = "N/A"
	var/list/subclass_slot_lines = list("Unavailable")

	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	if(gnoll_job)
		var/gnoll_total_slots = max(gnoll_job.total_positions, 0)
		var/gnoll_open_slots = max(gnoll_total_slots - gnoll_job.current_positions, 0)
		slot_open_display = "[gnoll_open_slots]/[gnoll_total_slots]"

		subclass_slot_lines = list()
		if(!SSrole_class_handler)
			subclass_slot_lines += "Unavailable (class handler not initialized)"
		else
			for(var/adv in gnoll_job.job_subclasses)
				var/datum/advclass/advpath = adv
				var/datum/advclass/subclass = SSrole_class_handler.get_advclass_by_name(initial(advpath.name))
				if(!subclass)
					continue

				if(subclass.maximum_possible_slots == -1)
					subclass_slot_lines += "[subclass.name]: unlimited"
					continue

				var/subclass_open_slots = max(subclass.maximum_possible_slots - subclass.total_slots_occupied, 0)
				subclass_slot_lines += "[subclass.name]: [subclass_open_slots]/[subclass.maximum_possible_slots]"

		if(!length(subclass_slot_lines))
			subclass_slot_lines += "(none)"

	if(SSgnoll_scaling)
		var/list/scaling_snapshot = SSgnoll_scaling.get_admin_scaling_snapshot()
		if(length(scaling_snapshot))
			gnoll_mode_id = scaling_snapshot["mode_id"]
			gnoll_mode_name = scaling_snapshot["mode_name"] || gnoll_mode_name
			has_pop_growth_scaling = scaling_snapshot["has_pop_growth"]
			auto_scaling_status = scaling_snapshot["auto_scaling_status"] || auto_scaling_status
			pop_remaining_display = scaling_snapshot["pop_remaining"] || pop_remaining_display

	if(gnoll_mode_id == GNOLL_SCALING_NONE)
		gnoll_spawn_status = "Disabled by storyteller scaling mode (NONE)"
		slot_open_display = "0/0 (disabled)"

	var/subclass_slots_display = subclass_slot_lines.Join("<br>")

	var/list/dat = list("<html><head><title>Gnoll Information</title></head><body><h1><B>Gnoll Information</B></h1>")
	dat += "<a href='?_src_=holder;[HrefToken()];check_hunted_targets=1'>Refresh</a><br>"
	dat += "<br><b>Selection mode:</b> [active_source]"
	dat += "<br><b>Current gnoll scaling mode:</b> "
	dat += gnoll_mode_name
	dat += "<br><b>Automated gnoll scaling:</b> "
	dat += auto_scaling_status
	dat += "<br><b>Gnoll spawning:</b> "
	dat += gnoll_spawn_status
	dat += "<br><b>Gnoll slots open:</b> "
	dat += slot_open_display
	dat += "<br><b>Subclass slots (open/total):</b><br>"
	dat += subclass_slots_display
	if(SSgnoll_scaling && has_pop_growth_scaling)
		dat += "<br><b>Pop remaining before slot opens:</b> "
		dat += pop_remaining_display
	dat += "<br><i>[selection_mode_description]</i><br><br>"

	if(!length(display_targets))
		dat += "No valid gnoll track targets."
	else
		var/list/sorted_target_rows = list()
		for(var/mob/living/target in display_targets)
			var/target_name = "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(target)]'>[target.real_name]</a>"
			var/target_location = AREACOORD(target)
			var/target_key = target.ckey || "(none)"
			var/target_job = target.job || "(none)"
			var/target_source = "Direct scent"
			if(target in hunted_targets)
				target_source = "Hunted flaw"
			else if(target in combat_targets)
				target_source = "Combat fallback"
			var/target_ref = "\ref[target]"
			var/gnoll_tracking_display = "(none)"
			var/gnoll_tracking_locations = "(none)"
			var/list/tracking_gnolls = tracking_gnolls_by_target_ref[target_ref]
			if(length(tracking_gnolls))
				var/list/tracking_name_links = list()
				var/list/tracking_location_labels = list()
				for(var/mob/living/gnoll_mob in tracking_gnolls)
					tracking_name_links += "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(gnoll_mob)]'>[gnoll_mob.real_name]</a>"
					tracking_location_labels += "[gnoll_mob.real_name]: [AREACOORD(gnoll_mob)]"
				gnoll_tracking_display = tracking_name_links.Join(", ")
				gnoll_tracking_locations = tracking_location_labels.Join("<br>")
			var/row_key = "[LOWER_TEXT(target.real_name)]-[REF(target)]"
			sorted_target_rows[row_key] = "<tr><td>[target_name]</td><td>[target_location]</td><td>[target_key]</td><td>[target_job]</td><td>[target_source]</td><td>[gnoll_tracking_display]</td><td>[gnoll_tracking_locations]</td></tr>"

		sortTim(sorted_target_rows, GLOBAL_PROC_REF(cmp_text_asc), associative = TRUE)

		dat += "<table cellspacing=5>"
		dat += "<tr><th align='left'>Target</th><th align='left'>Location</th><th align='left'>Key</th><th align='left'>Job</th><th align='left'>Source</th><th align='left'>Tracking Gnolls</th><th align='left'>Tracking Gnoll Locations</th></tr>"
		for(var/row_key in sorted_target_rows)
			dat += sorted_target_rows[row_key]
		dat += "</table>"

	dat += "</body></html>"
	usr << browse(dat.Join(), "window=gnollinformation;size=700x500")

/datum/admins/proc/check_hag_information()
	if(!SSticker.HasRoundStarted())
		alert("The game hasn't started yet!")
		return

	var/list/active_hags = list()
	for(var/datum/antagonist/hag/hag_datum as anything in GLOB.antagonists)
		if(!hag_datum?.owner?.current)
			continue
		active_hags += hag_datum

	var/list/dat = list("<html><head><title>Hag Information</title></head><body><h1><B>Hag Information</B></h1>")
	dat += "<a href='?_src_=holder;[HrefToken()];check_hag_information=1'>Refresh</a><br>"

	if(!length(active_hags))
		dat += "<br><b>No active hags.</b>"
	else
		dat += "<br><table cellspacing=5>"
		dat += "<tr><th align='left'>Hag</th><th align='left'>Job</th><th align='left'>Advjob</th><th align='left'>Tier</th><th align='left'>Curse Scars</th><th align='left'>Prepared Boons</th><th align='left'>Actions</th></tr>"
		for(var/datum/antagonist/hag/hag_datum as anything in active_hags)
			var/mob/living/carbon/human/hag_body = hag_datum.owner.current
			var/datum/component/hag_curio_tracker/tracker = hag_body.GetComponent(/datum/component/hag_curio_tracker)
			var/hag_tier = tracker ? tracker.hag_tier : 1
			var/curse_scar_count = 0
			var/list/prepared_bits = list()
			if(tracker)
				for(var/true_name in tracker.boon_registry)
					var/datum/hag_boon/curse_scar/scar = tracker.find_boon_by_type(true_name, /datum/hag_boon/curse_scar)
					if(scar)
						curse_scar_count++
				for(var/boon_path in tracker.prepared_boons)
					var/count = tracker.prepared_boons[boon_path]
					if(count > 0)
						prepared_bits += "[initial(boon_path:name)]x[count]"
			var/links = list()
			links += "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(hag_body)]'>Panel</a>"
			links += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(hag_body)]'>FLW</a>"
			if(hag_body.client)
				links += "<a href='?_src_=holder;[HrefToken()];priv_msg=[ckey(hag_body.ckey)]'>PM</a>"
			dat += "<tr><td>[hag_body.real_name]</td><td>[hag_body.job || "(none)"]</td><td>[hag_body.advjob || "(none)"]</td><td>[hag_tier]</td><td>[curse_scar_count]</td><td>[length(prepared_bits) ? prepared_bits.Join(", ") : "(none)"]</td><td>[links.Join(" | ")]</td></tr>"
		dat += "</table>"

		dat += "<hr><h2>Active Hag Details</h2>"
		for(var/datum/antagonist/hag/hag_datum as anything in active_hags)
			var/mob/living/carbon/human/hag_body = hag_datum.owner.current
			var/datum/component/hag_curio_tracker/tracker = hag_body.GetComponent(/datum/component/hag_curio_tracker)
			if(!tracker)
				continue

			var/obj/structure/roguemachine/hag_heart/heart = null
			for(var/obj/structure/roguemachine/hag_heart/H as anything in GLOB.hag_hearts)
				if(H.bound_hag == hag_datum)
					heart = H
					break

			dat += "<h3>[hag_body.real_name]</h3>"
			dat += "<b>Location:</b> [AREACOORD(hag_body)]<br>"
			dat += "<b>Alive:</b> [hag_body.stat == DEAD ? "No" : "Yes"]<br>"
			dat += "<b>Hag tier:</b> [tracker.hag_tier]<br>"
			dat += "<b>Bound boons:</b> [length(tracker.boon_registry)] victims tracked<br>"
			if(length(tracker.prepared_boons))
				var/list/prepare_rows = list()
				for(var/boon_path in tracker.prepared_boons)
					var/count = tracker.prepared_boons[boon_path]
					if(count > 0)
						prepare_rows += "- [initial(boon_path:name)]: [count]"
				dat += "<b>Prepared boons:</b><br>[prepare_rows.Join("<br>")]<br>"
			else
				dat += "<b>Prepared boons:</b> none<br>"

			if(heart)
				dat += "<b>Heart:</b> [heart.destroyed ? "Destroyed" : "Active"]<br>"
				dat += "<b>Heart health:</b> [heart.obj_integrity]/[heart.max_integrity]<br>"
				dat += "<b>Heart stage:</b> [heart.current_stage]/[heart.max_stages]<br>"
				if(heart.timer_id)
					var/time_left = timeleft(heart.timer_id)
					dat += "<b>Grand Rite:</b> [heart.rite_started ? "Running" : "Pending"] ([time_left > 0 ? DisplayTimeText(time_left) : "ending"])<br>"
				else if(heart.rite_completed)
					dat += "<b>Grand Rite:</b> Completed<br>"
				else if(heart.current_stage > heart.max_stages)
					dat += "<b>Grand Rite:</b> Ready to choose<br>"
				else
					dat += "<b>Grand Rite:</b> Not ready<br>"

				var/list/current_requirements = heart.rite_requirements[heart.current_stage]
				if(length(current_requirements))
					dat += "<b>Current rite requirements:</b><br>"
					for(var/req_path in current_requirements)
						var/needed = current_requirements[req_path]
						var/delivered = heart.delivered_items[req_path] || 0
						dat += "- [needed - delivered] remaining of [initial(req_path:name)] ([delivered]/[needed])<br>"
			else
				dat += "<b>Heart:</b> No bound heart found<br>"

			dat += "<b>Curse-scarred victims:</b><br>"
			var/any_scarred = FALSE
			for(var/true_name in tracker.boon_registry)
				var/datum/hag_boon/curse_scar/scar = tracker.find_boon_by_type(true_name, /datum/hag_boon/curse_scar)
				if(!scar)
					continue
				any_scarred = TRUE
				var/list/scar_links = list()
				var/mob/living/victim = tracker.find_target(true_name)
				if(victim)
					scar_links += "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(victim)]'>[true_name]</a>"
				else
					scar_links += true_name
				dat += "- [scar_links.Join()] : [scar.points] points<br>"
			if(!any_scarred)
				dat += "- none<br>"

			dat += "<br><b>Last revive:</b> [tracker.last_revive_time > 0 ? DisplayTimeText(world.time - tracker.last_revive_time) + " ago" : "never"]<br>"

			dat += "<br><b>Heartroot Ward Status:</b><br>"
			if(!length(GLOB.hag_wards))
				dat += "No wards remain.<br>"
			else
				for(var/obj/structure/roguemachine/hag_ward/ward as anything in GLOB.hag_wards)
					var/datum/reagent/reagent_type = ward.required_reagent
					dat += "- [ward.name]: [initial(reagent_type.name)] ([ward.units_needed] units remaining)<br>"

			dat += "<hr>"

	dat += "</body></html>"
	usr << browse(dat.Join(), "window=haginformation;size=850x700")
