// Ratworld World Persistence System
// Handles saving and loading of persistent world objects (buildings, structures, etc.)
// Uses transaction logging for crash recovery with high population servers

#define RATWORLD_SAVE_FILE "data/ratworld/world_state.sav"
#define RATWORLD_AUTOSAVE_FILE "data/ratworld/world_autosave.sav"
#define RATWORLD_TRANSACTION_LOG "data/ratworld/transactions.log"
#define RATWORLD_BACKUPS_DIR "data/ratworld/backups"

// How often to flush transaction log to disk (in deciseconds)
#define TRANSACTION_FLUSH_INTERVAL 100 // 10 seconds

// Maximum number of backups to keep
#define MAX_BACKUPS 10

/// Global tracker for pending transactions
GLOBAL_VAR_INIT(ratworld_transaction_buffer, "")
GLOBAL_VAR_INIT(ratworld_last_flush, 0)

/// Mark an object as persistent (will be saved/loaded)
/atom/movable/var/persistent = FALSE

/// Who built this object (for logging and admin tools)
/atom/movable/var/builder_ckey = null

/// When was this object built (world.realtime)
/atom/movable/var/build_time = 0

/// Mark if object has been approved for persistence (anti-grief)
/atom/movable/var/approved_persistent = TRUE

//=============================================================================
// TRANSACTION LOGGING - For high-pop crash recovery
//=============================================================================

/// Log a building action to the transaction log
/proc/ratworld_log_transaction(action, atom/movable/obj, mob/user)
	if(!obj || !obj.persistent)
		return
	
	var/list/transaction = list(
		"time" = world.realtime,
		"action" = action, // "BUILD" or "DESTROY"
		"type" = "[obj.type]",
		"x" = obj.x,
		"y" = obj.y,
		"z" = obj.z,
		"ckey" = user?.ckey,
		"name" = obj.name
	)
	
	// Add to buffer (will be flushed periodically)
	GLOB.ratworld_transaction_buffer += json_encode(transaction) + "\n"
	
	// Log for admins
	log_world("RATWORLD BUILD: [action] [obj.type] at ([obj.x],[obj.y],[obj.z]) by [user?.ckey || "unknown"]")

/// Flush transaction buffer to disk
/proc/ratworld_flush_transactions()
	if(!GLOB.ratworld_transaction_buffer)
		return
	
	var/log_file = file(RATWORLD_TRANSACTION_LOG)
	log_file << GLOB.ratworld_transaction_buffer
	GLOB.ratworld_transaction_buffer = ""
	GLOB.ratworld_last_flush = world.time

/// Replay transaction log from a specific timestamp
/proc/ratworld_replay_transactions(from_time = 0)
	if(!fexists(RATWORLD_TRANSACTION_LOG))
		return 0
	
	var/log_text = file2text(RATWORLD_TRANSACTION_LOG)
	if(!log_text)
		return 0
	
	var/list/lines = splittext(log_text, "\n")
	var/replayed = 0
	
	for(var/line in lines)
		if(!line)
			continue
		
		var/list/transaction = json_decode(line)
		if(!transaction)
			continue
		
		// Skip transactions before the cutoff time
		if(from_time && transaction["time"] < from_time)
			continue
		
		// TODO: Implement actual object recreation
		// This will be filled in when we implement object serialization
		replayed++
	
	log_world("RATWORLD: Replayed [replayed] transactions from log")
	return replayed

//=============================================================================
// PERSISTENCE SUBSYSTEM HOOKS
//=============================================================================

/// Save world state at round end
/datum/controller/subsystem/persistence/proc/RatworldSaveWorld()
	log_world("RATWORLD: Starting world save...")
	
	var/savefile/F = new /savefile(RATWORLD_SAVE_FILE)
	if(!F)
		log_world("RATWORLD ERROR: Failed to create savefile!")
		return FALSE
	
	// Store metadata
	F.cd = "/"
	F["version"] = 1
	F["timestamp"] = world.realtime
	F["round_id"] = GLOB.round_id || 0
	
	// Count persistent objects
	var/list/objects_to_save = list()
	for(var/atom/movable/O in world)
		if(O.persistent && !ismob(O) && O.approved_persistent)
			objects_to_save += O
	
	F.cd = "/objects"
	F["count"] = objects_to_save.len
	
	// Individual objects will serialize themselves via Write()
	var/saved_count = 0
	for(var/atom/movable/O in objects_to_save)
		try
			F.cd = "/objects/[saved_count]"
			F << O
			saved_count++
		catch(var/exception/e)
			log_world("RATWORLD ERROR: Failed to save object [O.type]: [e]")
	
	log_world("RATWORLD: Saved [saved_count] persistent objects")
	
	// Clear transaction log since we just did a full save
	fdel(RATWORLD_TRANSACTION_LOG)
	GLOB.ratworld_transaction_buffer = ""
	
	// Create timestamped backup
	RatworldCreateBackup()
	
	return TRUE

/// Load world state at round start
/datum/controller/subsystem/persistence/proc/RatworldLoadWorld()
	log_world("RATWORLD: Starting world load...")
	
	var/load_from = RATWORLD_SAVE_FILE
	var/from_autosave = FALSE
	
	// Check if autosave is newer (crash recovery)
	if(fexists(RATWORLD_AUTOSAVE_FILE) && fexists(RATWORLD_SAVE_FILE))
		var/autosave_time = text2num(rustg_file_get_time(RATWORLD_AUTOSAVE_FILE))
		var/official_time = text2num(rustg_file_get_time(RATWORLD_SAVE_FILE))
		
		if(autosave_time > official_time)
			load_from = RATWORLD_AUTOSAVE_FILE
			from_autosave = TRUE
			message_admins(span_danger("RATWORLD: Loading from autosave - server may have crashed!"))
	
	if(!fexists(load_from))
		log_world("RATWORLD: No save file found, starting fresh")
		return FALSE
	
	var/savefile/F = new /savefile(load_from)
	if(!F)
		log_world("RATWORLD ERROR: Failed to open savefile!")
		return FALSE
	
	// Read metadata
	F.cd = "/"
	var/version = F["version"]
	var/save_timestamp = F["timestamp"]
	
	log_world("RATWORLD: Loading save from version [version], timestamp [save_timestamp]")
	
	// Read object count
	F.cd = "/objects"
	var/count = F["count"] || 0
	
	// Load objects (they will deserialize themselves via Read())
	var/loaded_count = 0
	for(var/i = 0 to count - 1)
		try
			F.cd = "/objects/[i]"
			var/atom/movable/O
			F >> O
			if(O)
				loaded_count++
		catch(var/exception/e)
			log_world("RATWORLD ERROR: Failed to load object [i]: [e]")
	
	log_world("RATWORLD: Loaded [loaded_count] persistent objects")
	
	// If we loaded from autosave, replay any transactions that happened after
	if(from_autosave)
		ratworld_replay_transactions(save_timestamp)
	
	return TRUE

/// Create a timestamped backup
/datum/controller/subsystem/persistence/proc/RatworldCreateBackup()
	if(!fexists(RATWORLD_SAVE_FILE))
		return
	
	// Create backups directory if it doesn't exist
	if(!fexists(RATWORLD_BACKUPS_DIR))
		// BYOND doesn't have mkdir, but file operations will create it
	
	var/timestamp = time2text(world.realtime, "YYYY-MM-DD_hh-mm-ss")
	var/backup_path = "[RATWORLD_BACKUPS_DIR]/world_[timestamp].sav"
	
	if(fcopy(RATWORLD_SAVE_FILE, backup_path))
		log_world("RATWORLD: Created backup at [backup_path]")
		RatworldCleanOldBackups()
	else
		log_world("RATWORLD ERROR: Failed to create backup")

/// Remove old backups, keeping only the most recent MAX_BACKUPS
/datum/controller/subsystem/persistence/proc/RatworldCleanOldBackups()
	// TODO: Implement backup cleanup
	// Will need to list files in directory and sort by date
	return

//=============================================================================
// ADMIN TOOLS
//=============================================================================

/// Admin verb to manually save world state
/client/proc/admin_ratworld_save()
	set category = "Admin.Events"
	set name = "Ratworld: Save World"
	
	if(!check_rights(R_ADMIN))
		return
	
	message_admins("[key_name_admin(src)] is manually saving world state...")
	
	if(SSpersistence.RatworldSaveWorld())
		message_admins("World save completed successfully")
	else
		message_admins(span_danger("World save FAILED - check logs!"))

/// Admin verb to manually load world state (dangerous!)
/client/proc/admin_ratworld_load()
	set category = "Admin.Events"
	set name = "Ratworld: Load World"
	
	if(!check_rights(R_ADMIN))
		return
	
	if(alert("This will REPLACE the current world state! Continue?", "Confirm", "Yes", "No") != "Yes")
		return
	
	message_admins("[key_name_admin(src)] is manually loading world state...")
	
	if(SSpersistence.RatworldLoadWorld())
		message_admins("World load completed successfully")
	else
		message_admins(span_danger("World load FAILED - check logs!"))

/// Admin verb to view recent build logs
/client/proc/admin_ratworld_view_logs()
	set category = "Admin.Events"
	set name = "Ratworld: View Build Logs"
	
	if(!check_rights(R_ADMIN))
		return
	
	// TODO: Implement log viewer
	to_chat(src, span_notice("Build log viewer not yet implemented"))

#undef TRANSACTION_FLUSH_INTERVAL
#undef MAX_BACKUPS
