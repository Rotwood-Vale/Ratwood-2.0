SUBSYSTEM_DEF(whitelist)
	name = "白名单"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_WHITELIST
	var/list/whitelist = list()

/datum/controller/subsystem/whitelist/Initialize()
	. = ..()
	if(!SSdbcore.Connect())
		return
	load_entry_whitelist()

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
	set category = "-服务器-"
	set name = "添加白名单"

	if(!check_rights())
		return

	var/selection = input("你想放谁进来？", "CKEY", "") as text|null
	if(selection)
		if(ckey(selection) in SSwhitelist.whitelist)
			to_chat(src, span_warning("ckey 为[selection]的玩家已在名单中。"))
			return
		if(alert("确认允许 ckey 为[selection]的玩家连接吗？", "", "是", "否") == "是")
			SSwhitelist.add_entry_whitelist(selection, ckey)
