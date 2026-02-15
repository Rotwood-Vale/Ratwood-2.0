// Ratworld Object Serialization
// Defines how specific object types save and restore their state

//=============================================================================
// BASE SERIALIZATION - All persistent objects use this
//=============================================================================

/// Base Write proc for persistent objects
/atom/movable/Write(savefile/F)
	// Save position (for non-turf objects)
	if(!isturf(src))
		F["x"] << x
		F["y"] << y
		F["z"] << z
	
	// Save basic properties
	F["dir"] << dir
	F["name"] << name
	F["desc"] << desc
	
	// Save pixel offsets if any
	if(pixel_x != initial(pixel_x))
		F["pixel_x"] << pixel_x
	if(pixel_y != initial(pixel_y))
		F["pixel_y"] << pixel_y
	
	// Save persistence metadata
	F["builder_ckey"] << builder_ckey
	F["build_time"] << build_time
	
	return ..()

/// Base Read proc for persistent objects
/atom/movable/Read(savefile/F)
	// Restore position
	var/saved_x, saved_y, saved_z
	F["x"] >> saved_x
	F["y"] >> saved_y
	F["z"] >> saved_z
	
	// Move to saved location (after Read completes)
	if(saved_x && saved_y && saved_z)
		var/turf/T = locate(saved_x, saved_y, saved_z)
		if(T)
			forceMove(T)
	
	// Restore basic properties
	F["dir"] >> dir
	F["name"] >> name
	F["desc"] >> desc
	
	// Restore pixel offsets
	var/saved_pixel_x, saved_pixel_y
	F["pixel_x"] >> saved_pixel_x
	F["pixel_y"] >> saved_pixel_y
	if(saved_pixel_x)
		pixel_x = saved_pixel_x
	if(saved_pixel_y)
		pixel_y = saved_pixel_y
	
	// Restore metadata
	F["builder_ckey"] >> builder_ckey
	F["build_time"] >> build_time
	
	return ..()

//=============================================================================
// STRUCTURE SERIALIZATION
//=============================================================================

/// Base structure persistence
/obj/structure
	persistent = TRUE // Most structures should persist

/obj/structure/Write(savefile/F)
	// Structures may have custom vars to save
	// Anchored state
	F["anchored"] << anchored
	
	// Density
	F["density"] << density
	
	return ..()

/obj/structure/Read(savefile/F)
	F["anchored"] >> anchored
	F["density"] >> density
	
	return ..()

//=============================================================================
// DOOR SERIALIZATION
//=============================================================================

/obj/structure/mineral_door/Write(savefile/F)
	F["mineralType"] << mineralType
	F["sheetType"] << sheetType
	F["isSwitchingStates"] << isSwitchingStates
	return ..()

/obj/structure/mineral_door/Read(savefile/F)
	F["mineralType"] >> mineralType
	F["sheetType"] >> sheetType
	F["isSwitchingStates"] >> isSwitchingStates
	return ..()

//=============================================================================
// CONTAINER SERIALIZATION (Chests, Barrels, etc.)
//=============================================================================

/obj/structure/closet/Write(savefile/F)
	// Save if opened/closed
	F["opened"] << opened
	F["locked"] << locked
	
	// Save contents (but NOT mobs!)
	var/list/safe_contents = list()
	for(var/atom/movable/AM in contents)
		if(!ismob(AM))
			safe_contents += AM
	
	F["contents_count"] << safe_contents.len
	var/i = 0
	for(var/atom/movable/AM in safe_contents)
		F["content_[i]"] << AM
		i++
	
	return ..()

/obj/structure/closet/Read(savefile/F)
	F["opened"] >> opened
	F["locked"] >> locked
	
	// Restore contents
	var/contents_count
	F["contents_count"] >> contents_count
	
	if(contents_count)
		for(var/i = 0 to contents_count - 1)
			var/atom/movable/AM
			F["content_[i]"] >> AM
			if(AM)
				AM.forceMove(src)
	
	return ..()

//=============================================================================
// SIGN SERIALIZATION (Custom text)
//=============================================================================

/obj/structure/sign/Write(savefile/F)
	// Signs might have custom messages
	if(sign_message)
		F["sign_message"] << sign_message
	return ..()

/obj/structure/sign/Read(savefile/F)
	F["sign_message"] >> sign_message
	return ..()

//=============================================================================
// MACHINERY SERIALIZATION
//=============================================================================

/obj/machinery/Write(savefile/F)
	// Basic machine state
	F["machine_stat"] << machine_stat
	F["use_power"] << use_power
	
	return ..()

/obj/machinery/Read(savefile/F)
	F["machine_stat"] >> machine_stat
	F["use_power"] >> use_power
	
	return ..()

//=============================================================================
// ITEM SERIALIZATION
//=============================================================================

/obj/item
	persistent = FALSE // Most items don't persist by default

/obj/item/Write(savefile/F)
	// Item-specific properties
	if(item_flags)
		F["item_flags"] << item_flags
	
	return ..()

/obj/item/Read(savefile/F)
	F["item_flags"] >> item_flags
	
	return ..()

//=============================================================================
// TURF MODIFICATION SERIALIZATION
//=============================================================================

// Note: We generally don't save turfs themselves, but we can track
// modifications to turfs (like custom flooring, walls broken, etc.)

/// Track if this turf has been modified from initial map state
/turf/var/tmp/modified_from_map = FALSE

/// Mark a turf as modified
/turf/proc/MarkModified()
	modified_from_map = TRUE
	// TODO: Add to global modified turfs list for tracking

//=============================================================================
// RATWORLD-SPECIFIC PERSISTENCE
//=============================================================================

// Hook into Ratworld enchantment system if items have enchantments
/obj/item/Write(savefile/F)
	. = ..()
	
	// TODO: Save enchantments when that system is integrated
	// if(ratworld_enchantments)
	//     F["enchantments"] << ratworld_enchantments

/obj/item/Read(savefile/F)
	. = ..()
	
	// TODO: Restore enchantments
	// F["enchantments"] >> ratworld_enchantments

//=============================================================================
// HELPER PROCS
//=============================================================================

/// Check if an object should be saved
/proc/ratworld_should_save_object(atom/movable/O)
	if(!O)
		return FALSE
	if(!O.persistent)
		return FALSE
	if(ismob(O))
		return FALSE // NEVER save mobs
	if(!O.approved_persistent)
		return FALSE // Skip unapproved items
	
	return TRUE

/// Serialize an object to a list (alternative to savefile for JSON storage)
/proc/ratworld_serialize_object(atom/movable/O)
	if(!ratworld_should_save_object(O))
		return null
	
	var/list/data = list()
	data["type"] = "[O.type]"
	data["x"] = O.x
	data["y"] = O.y
	data["z"] = O.z
	data["dir"] = O.dir
	data["name"] = O.name
	data["builder_ckey"] = O.builder_ckey
	data["build_time"] = O.build_time
	
	return data

/// Deserialize an object from a list
/proc/ratworld_deserialize_object(list/data)
	if(!data || !data["type"])
		return null
	
	var/obj_type = text2path(data["type"])
	if(!obj_type)
		return null
	
	var/turf/T = locate(data["x"], data["y"], data["z"])
	if(!T)
		return null
	
	var/atom/movable/O = new obj_type(T)
	O.dir = data["dir"]
	O.name = data["name"]
	O.builder_ckey = data["builder_ckey"]
	O.build_time = data["build_time"]
	
	return O
