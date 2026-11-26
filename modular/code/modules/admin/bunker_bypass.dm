SUBSYSTEM_DEF(whitelist)
	name = "Whitelist"
	flags = SS_NO_FIRE
	var/list/whitelist = list()

/datum/controller/subsystem/whitelist/Initialize()
	if(!SSdbcore.Connect())
		return SS_INIT_SUCCESS
	load_entry_whitelist()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/whitelist/proc/add_entry_whitelist(target_ckey, admin_ckey = "SYSTEM")
	if(!target_ckey)
		return

	target_ckey = ckey(target_ckey)
	SSwhitelist.whitelist |= target_ckey
	message_admins("WHITELIST: Added [target_ckey] to the whitelist[admin_ckey? " by [admin_ckey]":""]")
	log_admin("WHITELIST: Added [target_ckey] to the whitelist[admin_ckey? " by [admin_ckey]":""]")

	var/datum/DBQuery/query_add_entry_whitelist = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("whitelists")] (ckey, type, added_by, timestamp, round_id)
		VALUES (:ckey, :type, :added_by, :timestamp, :round_id)
	"}, list(
		"ckey" = target_ckey,
		"type" = "entry",
		"added_by" = admin_ckey,
		"timestamp" = SQLtime(),
		"round_id" = GLOB.round_id,
	))
	if(!query_add_entry_whitelist.Execute())
		message_admins("Failed to add entry whitelist for [key_name_admin(target_ckey)] to the database!")
		log_admin("Failed to add entry whitelist for [key_name_admin(target_ckey)] to the database!")
	qdel(query_add_entry_whitelist)

/datum/controller/subsystem/whitelist/proc/load_entry_whitelist()
	var/datum/DBQuery/query_load_entry_whitelist = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("whitelists")] WHERE type = 'entry'")
	if(!query_load_entry_whitelist.Execute())
		qdel(query_load_entry_whitelist)
		return
	while(query_load_entry_whitelist.NextRow())
		whitelist |= query_load_entry_whitelist.item[1]
	qdel(query_load_entry_whitelist)

/client/proc/entry_whitelist_check()
	return (ckey && (ckey in SSwhitelist.whitelist))

/client/proc/bunker_bypass()
	set category = "-Server-"
	set name = "Add Whitelist"

	if(!check_rights())
		return

	var/selection = input("Who would you like to let in?", "CKEY", "") as text|null
	if(selection)
		if(ckey(selection) in SSwhitelist.whitelist)
			to_chat(src, span_warning("Player with ckey [selection] is already on the list."))
			return
		if(alert("Confirm: allow ckey [selection] to connect?", "", "Yes!", "No") == "Yes!")
			SSwhitelist.add_entry_whitelist(selection, ckey)
