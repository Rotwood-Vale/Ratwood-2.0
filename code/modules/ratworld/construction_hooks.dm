// Ratworld Construction Hooks
// Intercepts object creation and destruction to log transactions

//=============================================================================
// CONSTRUCTION TRACKING
//=============================================================================

/// Hook into object initialization to track constructions
/atom/movable/Initialize(mapload, ...)
	. = ..()
	
	// Only track player-built objects (not mapload)
	if(!mapload && persistent && usr)
		builder_ckey = usr.ckey
		build_time = world.realtime
		
		// Log the construction
		ratworld_log_transaction("BUILD", src, usr)

/// Hook into object destruction to log it
/atom/movable/Destroy()
	// Log destruction if it was a persistent object
	if(persistent && builder_ckey)
		ratworld_log_transaction("DESTROY", src, usr)
	
	return ..()

//=============================================================================
// PERIODIC TRANSACTION FLUSHING
//=============================================================================

// We need to periodically flush transactions to disk
// This will be handled by making the persistence subsystem fire periodically

/datum/controller/subsystem/persistence
	flags = SS_BACKGROUND // Changed from SS_NO_FIRE to allow periodic processing

/datum/controller/subsystem/persistence/fire(resumed)
	// Flush transaction buffer every tick (runs in background)
	if(GLOB.ratworld_transaction_buffer && world.time >= GLOB.ratworld_last_flush + TRANSACTION_FLUSH_INTERVAL)
		ratworld_flush_transactions()

//=============================================================================
// ADMIN BUILDING TOOLS
//=============================================================================

/// Mark an object as admin-built (auto-approved)
/proc/ratworld_admin_build(obj_type, turf/location, mob/admin)
	var/atom/movable/O = new obj_type(location)
	if(!O)
		return null
	
	O.persistent = TRUE
	O.approved_persistent = TRUE
	O.builder_ckey = admin.ckey
	O.build_time = world.realtime
	
	log_admin("[admin.ckey] built [O.type] at ([location.x],[location.y],[location.z])")
	message_admins("[key_name_admin(admin)] built [O.type]")
	
	return O

/// Admin verb to delete recent builds by a player
/client/proc/admin_ratworld_delete_builds()
	set category = "Admin.Events"
	set name = "Ratworld: Delete Player Builds"
	
	if(!check_rights(R_ADMIN))
		return
	
	var/target_ckey = input(src, "Enter player ckey:", "Delete Builds") as text|null
	if(!target_ckey)
		return
	
	target_ckey = ckey(target_ckey)
	
	var/hours = input(src, "Delete builds from last how many hours?", "Time Range", 24) as num|null
	if(!hours)
		return
	
	if(alert("Delete all builds by [target_ckey] from last [hours] hours?", "Confirm", "Yes", "No") != "Yes")
		return
	
	var/cutoff_time = world.realtime - (hours * 36000) // Convert hours to deciseconds
	var/deleted = 0
	
	for(var/atom/movable/O in world)
		if(!O.persistent)
			continue
		if(O.builder_ckey != target_ckey)
			continue
		if(O.build_time < cutoff_time)
			continue
		
		qdel(O)
		deleted++
	
	message_admins("[key_name_admin(src)] deleted [deleted] structures built by [target_ckey]")
	log_admin("[key] deleted [deleted] structures built by [target_ckey] from last [hours] hours")

/// Admin verb to view building statistics
/client/proc/admin_ratworld_build_stats()
	set category = "Admin.Events"
	set name = "Ratworld: Build Statistics"
	
	if(!check_rights(R_ADMIN))
		return
	
	var/list/builder_counts = list()
	var/total_persistent = 0
	
	for(var/atom/movable/O in world)
		if(!O.persistent)
			continue
		total_persistent++
		
		if(O.builder_ckey)
			if(!builder_counts[O.builder_ckey])
				builder_counts[O.builder_ckey] = 0
			builder_counts[O.builder_ckey]++
	
	var/output = "<b>Persistent Object Statistics</b><br>"
	output += "Total persistent objects: [total_persistent]<br><br>"
	output += "<b>Top Builders:</b><br>"
	
	// Sort by count
	var/list/sorted = list()
	for(var/ckey in builder_counts)
		sorted += list(list("ckey" = ckey, "count" = builder_counts[ckey]))
	
	sorted = sortTim(sorted, GLOBAL_PROC_REF(cmp_builder_count_dsc))
	
	for(var/list/entry in sorted)
		output += "[entry["ckey"]]: [entry["count"]] objects<br>"
	
	usr << browse(output, "window=buildstats;size=400x600")

/proc/cmp_builder_count_dsc(list/a, list/b)
	return b["count"] - a["count"]

//=============================================================================
// BUILDING APPROVAL SYSTEM
//=============================================================================

/// Request approval for a major structure
/atom/movable/proc/RequestPersistenceApproval(mob/builder)
	src.approved_persistent = FALSE
	
	message_admins("[key_name_admin(builder)] built [src.type] at ([x],[y],[z]) - <a href='?src=[REF(src)];approve_persist=1'>APPROVE</a> | <a href='?src=[REF(src)];deny_persist=1'>DENY</a>")
	to_chat(builder, span_notice("Your structure has been submitted for admin approval."))

/// Handle approval/denial
/atom/movable/Topic(href, href_list)
	. = ..()
	
	if(href_list["approve_persist"])
		if(!check_rights(R_ADMIN))
			return
		
		approved_persistent = TRUE
		message_admins("[key_name_admin(usr)] approved persistence for [type]")
		return TRUE
	
	if(href_list["deny_persist"])
		if(!check_rights(R_ADMIN))
			return
		
		approved_persistent = FALSE
		persistent = FALSE
		message_admins("[key_name_admin(usr)] denied persistence for [type]")
		
		// Optionally delete the object
		if(alert(usr, "Delete this object?", "Delete", "Yes", "No") == "Yes")
			qdel(src)
		
		return TRUE

//=============================================================================
// EXAMINE HOOKS FOR ADMINS
//=============================================================================

/atom/movable/examine(mob/user)
	. = ..()
	
	// Show admin info
	if(check_rights(R_ADMIN, 0, user) && persistent)
		. += span_notice("<b>PERSISTENCE INFO:</b>")
		. += span_notice("- Persistent: [persistent ? "YES" : "NO"]")
		. += span_notice("- Approved: [approved_persistent ? "YES" : "NO"]")
		. += span_notice("- Builder: [builder_ckey || "unknown"]")
		if(build_time)
			var/time_ago = DisplayTimeText(world.realtime - build_time)
			. += span_notice("- Built: [time_ago] ago")
