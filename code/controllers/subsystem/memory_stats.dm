/// Periodically logs process memory usage and the sizes of leak-prone lists/queues
/// to data/logs/<round>/memory_stats.log
SUBSYSTEM_DEF(memory_stats)
	name = "Memory Stats"
	wait = 30 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	/// RSS (in MB) of the last sample, so admins/log readers can see the delta
	var/last_rss_mb = 0
	/// RSS in raw bytes of the last sample (float precision, ~256 byte granularity at the 4GB scale)
	var/last_rss_bytes = 0

/datum/controller/subsystem/memory_stats/Initialize(start_timeofday)
	can_fire = !CONFIG_GET(flag/disable_memory_stats)
	return ..()

/datum/controller/subsystem/memory_stats/fire(resumed)
	log_memory_stats()

#define MEMORY_RSS_FILE "data/memory_rss.txt"

/// Returns the process resident set size in bytes, or null if unavailable right now.
/// On windows a hidden background powershell writer (tools/memory_stats/mem_writer.ps1)
/// updates MEMORY_RSS_FILE, avoiding a console window flash per sample.
/proc/get_process_rss_bytes()
	if(world.system_type == UNIX)
		var/status = rustg_file_read("/proc/self/status")
		if(status)
			var/regex/rss_regex = regex(@"VmRSS:\s+(\d+) kB")
			if(rss_regex.Find(status))
				return text2num(rss_regex.group[1]) * 1024
		return null
	var/static/writer_started = FALSE
	if(!writer_started)
		writer_started = TRUE
		fdel(MEMORY_RSS_FILE) // clear stale data from a previous round
		shell("wscript //B //nologo \"tools/memory_stats/mem_writer.vbs\"")
		return null
	if(fexists(MEMORY_RSS_FILE))
		var/bytes = text2num(trim(file2text(MEMORY_RSS_FILE) || ""))
		if(bytes)
			return bytes
	return null

/// Logs the RSS delta and init time of one subsystem's Initialize. Returns the new baseline for the next call.
/proc/log_subsystem_init_memory(datum/controller/subsystem/SS, rss_before, init_time_s)
	var/rss_after = get_process_rss_bytes()
	if(isnull(rss_after) || isnull(rss_before))
		WRITE_LOG(GLOB.world_mem_log, "MEMINIT: [SS.name] rss_mb=unknown delta_mb=unknown init_s=[init_time_s]")
		return isnull(rss_after) ? rss_before : rss_after
	WRITE_LOG(GLOB.world_mem_log, "MEMINIT: [SS.name] rss_mb=[round(rss_after / (1024 * 1024), 0.1)] delta_mb=[round((rss_after - rss_before) / (1024 * 1024), 0.1)] init_s=[init_time_s]")
	return rss_after

/// Logs memory and time cost of parsing/loading one map file from SSmapping
/proc/log_map_memory(stage, map_path, rss_before, start_time)
	var/rss_after = get_process_rss_bytes()
	var/delta = (isnull(rss_after) || isnull(rss_before)) ? "unknown" : round((rss_after - rss_before) / (1024 * 1024), 0.1)
	WRITE_LOG(GLOB.world_mem_log, "MEMMAP: [stage] [map_path] delta_mb=[delta] time_s=[(REALTIMEOFDAY - start_time) / 10]")

/datum/controller/subsystem/memory_stats/proc/log_memory_stats()
	var/list/out = list()

	var/rss_bytes = get_process_rss_bytes()
	if(!isnull(rss_bytes))
		var/rss = round(rss_bytes / (1024 * 1024), 0.1)
		out += "rss_mb=[rss]"
		out += "rss_bytes=[num2text(rss_bytes, 12)]"
		if(last_rss_mb && rss - last_rss_mb > 250)
			message_admins("MEMORY: process RSS jumped [round(rss - last_rss_mb)]MB in [wait / (1 SECONDS)]s (now [rss]MB)")
		last_rss_mb = rss
		last_rss_bytes = rss_bytes

	out += "world_contents=[length(world.contents)]"
	out += "clients=[length(GLOB.clients)]"
	out += "mobs=[length(GLOB.mob_list)]"
	out += "dead_mobs=[length(GLOB.dead_mob_list)]"
	out += "alive_mobs=[length(GLOB.alive_mob_list)]"

	// lighting/sunlight - underlay lighting suspects
	out += "light_srcq=[length(SSlighting.sources_queue)]"
	out += "light_cornq=[length(SSlighting.corners_queue)]"
	out += "light_objq=[length(SSlighting.objects_queue)]"
	out += "sun_workq=[length(GLOB.SUNLIGHT_QUEUE_WORK)]"
	out += "sun_updq=[length(GLOB.SUNLIGHT_QUEUE_UPDATE)]"
	out += "sun_cornq=[length(GLOB.SUNLIGHT_QUEUE_CORNER)]"
	out += "sun_overlay_cache=[length(SSoutdoor_effects.sunlight_overlays)]"

	// garbage: failed hard deletes pin memory; a growing queue means qdel's harddelling too much
	out += "gc_totaldels=[SSgarbage.totaldels]"
	out += "gc_totalgcs=[SSgarbage.totalgcs]"
	for(var/i in 1 to length(SSgarbage.queues))
		out += "gc_queue[i]=[length(SSgarbage.queues[i])]"

	// timers
	out += "timer_buckets=[SStimer.bucket_count]"
	out += "timer_secondq=[length(SStimer.second_queue)]"
	out += "timer_ids=[length(SStimer.timer_id_dict)]"

	// vis overlays cache (grows per unique overlay key, never evicted)
	out += "vis_overlay_cache=[length(SSvis_overlays.vis_overlay_cache)]"
	out += "vis_overlay_unique=[length(SSvis_overlays.unique_vis_overlays)]"

	// every processing-style subsystem: name=processing/currentrun lengths
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if("processing" in SS.vars)
			var/list/procs_list = SS.vars["processing"]
			if(islist(procs_list) && length(procs_list))
				out += "ss_[ckey(SS.name)]_processing=[length(procs_list)]"
		if("currentrun" in SS.vars)
			var/list/current_run = SS.vars["currentrun"]
			if(islist(current_run) && length(current_run))
				out += "ss_[ckey(SS.name)]_currentrun=[length(current_run)]"

	WRITE_LOG(GLOB.world_mem_log, "MEMSTAT: [out.Join(" ")]")

/client/proc/dump_memory_stats()
	set category = "Debug"
	set name = "Dump Memory Stats"
	if(!check_rights(R_DEBUG))
		return
	SSmemory_stats.log_memory_stats()
	to_chat(usr, span_notice("Memory stats dumped to memory_stats.log (rss: [SSmemory_stats.last_rss_mb]MB / [num2text(SSmemory_stats.last_rss_bytes, 12)] bytes)."))
