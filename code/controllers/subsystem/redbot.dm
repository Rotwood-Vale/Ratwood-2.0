/// Bridges round status, round-end stats, and ahelps to the Ratwood RedBot cog over HTTP.
SUBSYSTEM_DEF(redbot)
	name = "RedBot"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT

/datum/controller/subsystem/redbot/Initialize(start_timeofday)
	return ..()

/datum/controller/subsystem/redbot/proc/enabled()
	return CONFIG_GET(string/bot_ip) && CONFIG_GET(string/comms_key)

/datum/controller/subsystem/redbot/proc/event_url()
	var/bot_ip = CONFIG_GET(string/bot_ip)
	if(!bot_ip)
		return
	if(findtext(bot_ip, "://"))
		return "[bot_ip]/event"
	return "http://[bot_ip]/event"

/// Fire-and-forget JSON POST to the RedBot cog. Safe to call before init; no-ops if unconfigured.
/datum/controller/subsystem/redbot/proc/send_event(list/data)
	set waitfor = FALSE
	if(!enabled())
		return
	data["key"] = CONFIG_GET(string/comms_key)
	if(!data["server"])
		data["server"] = CONFIG_GET(string/bot_server_name)
	if(!data["round_id"])
		data["round_id"] = GLOB.round_id
	if(!data["rogue_round_id"])
		data["rogue_round_id"] = GLOB.rogue_round_id
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, event_url(), json_encode(data), list(
		"Content-Type" = "application/json"
	))
	request.begin_async()

/datum/controller/subsystem/redbot/proc/connect_url()
	var/server = CONFIG_GET(string/server)
	if(server)
		return "byond://[server]"
	if(world.internet_address)
		return "byond://[world.internet_address]:[world.port]"
	return "byond://[world.address]:[world.port]"

/datum/controller/subsystem/redbot/proc/announce_round_start()
	if(!enabled())
		return
	send_event(list(
		"type" = "round_start",
		"map" = SSmapping.current_map?.map_name,
		"storyteller" = SSgamemode?.storyteller_name,
		"realm" = SSticker?.realm_name
	))

/datum/controller/subsystem/redbot/proc/announce_round_end()
	if(!enabled())
		return
	var/survivors = 0
	var/list/species_counts = list()
	for(var/mob/living/carbon/human/human_mob as anything in GLOB.human_list)
		if(!human_mob.mind || !human_mob.client)
			continue
		if(human_mob.stat == DEAD)
			continue
		survivors++
		var/species_name = human_mob.dna?.species?.name
		if(!species_name)
			species_name = "Unknown"
		species_counts[species_name] = (species_counts[species_name] || 0) + 1

	var/round_duration = SSticker ? round((world.time - SSticker.round_start_time) / 10) : 0
	send_event(list(
		"type" = "round_end",
		"map" = SSmapping.current_map?.map_name,
		"storyteller" = SSgamemode?.storyteller_name,
		"realm" = SSticker?.realm_name,
		"duration" = round_duration,
		"survivors" = survivors,
		"deaths" = GLOB.azure_round_stats[STATS_DEATHS] || 0,
		"joined" = length(GLOB.joined_player_list),
		"players" = length(GLOB.clients),
		"species" = species_counts
	))

/datum/controller/subsystem/redbot/proc/send_ahelp_new(datum/admin_help/ticket, message)
	if(!enabled() || !ticket)
		return
	var/list/adm = get_admin_counts()
	send_event(list(
		"type" = "ahelp",
		"action" = "new",
		"ticket" = ticket.id,
		"ckey" = ticket.initiator_ckey,
		"name" = html_decode(ticket.initiator_key_name),
		"message" = html_decode(strip_html(message)),
		"admins_present" = length(adm["present"])
	))

/datum/controller/subsystem/redbot/proc/send_ahelp_update(datum/admin_help/ticket, action, actor, message)
	if(!enabled() || !ticket)
		return
	send_event(list(
		"type" = "ahelp",
		"action" = action,
		"ticket" = ticket.id,
		"ckey" = ticket.initiator_ckey,
		"name" = html_decode(ticket.initiator_key_name),
		"actor" = actor,
		"message" = message ? html_decode(strip_html(message)) : ""
	))
