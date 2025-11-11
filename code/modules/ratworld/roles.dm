// Ratworld role persistence scaffolding
// Stores core leadership roles in a single JSON file under data/ratworld/roles.json
// This is intentionally simple and admin-driven for initial chapters.

#define RATWORLD_ROLES_FILE "data/ratworld/roles.json"

GLOBAL_LIST_INIT(rw_roles, list(
	"duke" = null,
	"duchess" = null,
	"heirs" = list(),
	"council" = list(),
	"knights" = list(),
	"knight_captain" = null,
	"priest" = null,
	"templars" = list(),
	"acolytes" = list(),
	"inquisition" = list()
))

// Load at world init
/datum/controller/subsystem/persistence/proc/RatworldLoadRoles()
	if(!fexists(RATWORLD_ROLES_FILE)) return
	var/list/json = json_decode(file2text(RATWORLD_ROLES_FILE))
	if(islist(json))
		GLOB.rw_roles = json

/datum/controller/subsystem/persistence/proc/RatworldSaveRoles()
	var/list/data = GLOB.rw_roles || list()
	var/file_path = file(RATWORLD_ROLES_FILE)
	fdel(file_path)
	WRITE_FILE(file_path, json_encode(data))

// Hook into SSpersistence lifecycle
/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	RatworldLoadRoles()
	return .

/datum/controller/subsystem/persistence/proc/ratworld_set_role(role, value)
	if(!role) return FALSE
	GLOB.rw_roles[role] = value
	RatworldSaveRoles()
	return TRUE

/datum/controller/subsystem/persistence/proc/ratworld_add_to_rolelist(role, ckey_or_id)
	if(!role) return FALSE
	var/list/L = GLOB.rw_roles[role]
	if(!islist(L))
		L = list()
	if(!(ckey_or_id in L))
		L += ckey_or_id
	GLOB.rw_roles[role] = L
	RatworldSaveRoles()
	return TRUE

/datum/controller/subsystem/persistence/proc/ratworld_remove_from_rolelist(role, ckey_or_id)
	if(!role) return FALSE
	var/list/L = GLOB.rw_roles[role]
	if(islist(L))
		L -= ckey_or_id
		GLOB.rw_roles[role] = L
		RatworldSaveRoles()
		return TRUE
	return FALSE

// Admin verbs for quick management
/client/proc/ratworld_assign_duke(target as text)
	set category = "Ratworld"
	set name = "Assign Duke/Duchess"
	if(!check_rights(R_ADMIN)) return
	if(!target) target = input(src, "Enter ckey for Duke/Duchess", "Assign Role") as text
	if(!target) return
	SSpersistence.ratworld_set_role("duke", lowertext(target))
	to_chat(src, span_notice("Assigned [target] as Duke/Duchess."))

/client/proc/ratworld_assign_priest(target as text)
	set category = "Ratworld"
	set name = "Assign Priest"
	if(!check_rights(R_ADMIN)) return
	if(!target) target = input(src, "Enter ckey for Priest", "Assign Role") as text
	if(!target) return
	SSpersistence.ratworld_set_role("priest", lowertext(target))
	to_chat(src, span_notice("Assigned [target] as Priest."))

/client/proc/ratworld_view_roles()
	set category = "Ratworld"
	set name = "View Roles"
	if(!check_rights(R_ADMIN)) return
	var/list/R = GLOB.rw_roles
	to_chat(src, json_encode(R))
